LMEMinterval <- function(
	formula,
	data,
	conf=.95,
	diff.adj=F){

formula	# This convenience function calculates LMEM-based "confidence" intervals for
	#	a given design and dataset. 
	# Parameters:
	#	formula: a usual model formula, with one DV and one or more IVs. Currently
	#		this function is able to handle functions in DVs (e.g., using log(RT)
	#		rather than RT as a DV), but not in IVs. And I haven't done much testing
	#		of DVs with functions so there may be bugs; I prefer just creating a 
	#		new column in the data frame (e.g., creating a logRT column).
	#		Also note that this is currently only implemented for single-factor
	#		designs. If you have a factorial (e.g. 2x2) design, this function will
	#		collapse it into a single-factor (e.g. 1x4) design.
	#	data: a data frame with repeated measures data
	#	conf: The confidence level (between 0 and 1) for the CI. Defaults .95.
	#	boot.type: which type of bootstrap to use. Defaults to "percentile". If set 
	#		to anything else, it will instead use normal bootstrap. 
	#		Percentile bootstrap is more accurate but slower, as it requires more  
	#     iterations to get accurate.
	#	nsim: Number of bootstrap replicates to use. By default this will be 2000 if
	#		boot.type=="percentile" and 200 otherwise, but you can set `nsim` to 
	#		override that.

	# Load the lme4 and boot packages
	require( lme4 )
	require( lmerTest )

	# Figure out the DV and the IVs.
	# This doesn't use all.var() because that strips away functions,
	#	whereas sometimes your formula might be like log(DV) ~ rather than just DV.
	vars <- rownames(attr(terms(formula),"factors"))

	# Figure out the DV
	DV <- vars[1]

	# Figure out what the random effects are. The first line finds which
	#	IVs look like random effects terms (which ones have pipes), and 
	#	the next line grabs the stuff after the pipe
	ranef_idx <- which( unlist( lapply( vars, function(x){ length( grep("|", x, fixed=T ) ) } ) )>0 )
	grouping.vars <- unlist( lapply( vars[ranef_idx],
	  function(x){ strsplit( x, " | ", fixed=T )[[1]][2] } ) )

	# Figure out the fixed IVs
	IVs <- vars[-c(1,ranef_idx)]

	# handles cases where the DV has a function around it (e.g. when the DV
	#	is `log(RT)` rather than just `RT`
	realDV <- all.vars(formula)[1] 
	if( DV != realDV ){
		func <- gsub( paste0("(",realDV,")"), "", DV, fixed=T )
		DV <- realDV
		data[,DV] <- unlist(lapply( data[,DV], func ) )
	}

	### A function to do the scaling. It first fits an intercept-only model to the 
	### data, then subtracts the residuals and adds the intercept (the grand mean)
	LMEscale <- function( formula, data ){
		model <- lmer( formula, data )
		data$LMEscale <- as.numeric( resid(model) + fixef(model)["(Intercept)"] )
		return(data)
	}

	# Scale the data, using a model with only a fixed intercept
	# and random intercepts
	lmerformula <- paste( DV, " ~ 1 + ", paste( "(1|", grouping.vars, ")", collapse=" + " ) ) 
	data <- LMEscale( lmerformula, data )

	### The rest of the code handles making  CIs of the scaled data. The 
	###	general procedure is as follows: to get the  CIs we have to fit 
	###	an lmer	model to the scaled data. To make the models more likely to 
	###	converge, we want to fit the models without random correlation 
	###	parameters; to do this use a hack from https://rpubs.com/Reinhold/22193,
	###	which requires first calculating a temporary model [which may not 
	###	converge] and then extracting dummy coefficients directly from
	###	its model matrix to construct the good model.
	###	Finally, we get lmerTest dfs to calculate the CI

	# Collapse design into one factor (just treating each condition as its 
	#	own condition, without considering main effects, interactions, etc.)
	data$Condition <- factor( do.call( paste0, lapply( IVs, function(IV){ data[,IV] } ) ) )

	# Create the temporary model, which may not converge, it doesn't matter
	lmerformula <- paste( "LMEscale ~ 0 + Condition + ", paste( "(1|", grouping.vars, ")", collapse=" + " ) )
	junkmodel <- lmer( lmerformula, data )

	# Pull out dummy variables from model matrix https://rpubs.com/Reinhold/22193
	mydummies <- list()
	for ( i in 1:dim( model.matrix(junkmodel) )[2] ) {
		data[,paste0("c",i)] <- model.matrix(junkmodel)[,i]	
	}

	# Make random effect terms using the dummy variables rather than the big 
	#	'Condition' variable. Per https://rpubs.com/Reinhold/22193, this ensures 
	#	that random correlations between the random effects will not 
	#  be used.
	#	We also specify no random intercepts; because the data are scaled, every
	#	subject/item/whatever should already have a mean of 0, so the random
	#	intercept is meaningless and in fact often cannot be fit anyway.
	ran <- paste( "0 +", paste( "c", 1:dim( model.matrix(junkmodel) )[2],
	   collapse="+", sep="" ) )

	# Now fit the good model. Because there is no fixed-effect intercept, it will 
	#	estimate a coefficient for each condition, rather than estimating 
	#	comparisons between conditions.
	lmerformula <- paste( "LMEscale ~ 0 + Condition + ", paste( "(", ran, "||", grouping.vars, ")", collapse=" + " ) )
	model <- lmer( lmerformula, data )


	# CI
	two_tailed_conf <- (conf+1)/2
	SEs <- summary(model)$coefficients[,"Std. Error"]
	dfs <- summary(model)$coefficients[,"df"]
	MoEs <- SEs * qt( two_tailed_conf, dfs )

	if (diff.adj) { MoEs <- MoEs * sqrt(2) }

	CIs <- cbind( fixef(model) - MoEs, fixef(model), fixef(model) + MoEs )
	colnames(CIs) <- c("Lower","mean","Upper")



	# Returns the CIs
	return(CIs)
}
