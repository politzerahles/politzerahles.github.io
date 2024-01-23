#!/usr/bin/perl
#web form to get homophony data. uses homophone_output.txt for data

use Encode;								#Modules
use CGI qw( :standard );

open data, "< homophones_without_trad.txt";
#This file was created from the pronunciation data in Da Jun's text corpus. There are characters and readings 
#  present in the Unihan database that are not present in this corpus, but many of them are so infrequent, or
#  not Chinese, that using Da's corpus gives a more accurate reflection of actually recognizable homophony (and
#  even the corpus has a large number of extremely infrequent characters). By way of example, only 2 characters
#  with pronunciation geng4 appear in the dictionary http://www.nciku.com. Da's corpus includes 1 character with this
#  pronuncation; the Unihan database includes 12. For the pronunciation ge4, Da's corpus includes 20 characters,
#  while Unihan includes 80. Thus, it is clear that the corpus is a more accurate reflection of a Chinese speaker's
#  lexicon, whereas the Unihan database is more comprehensive.
%homophony = {};
while( chomp( $line = <data> ) ){					#Read in data homophony
	($pron, $words) = split(/\t/, $line);
	$homophony{ $pron } = $words;
}
close data;

open variants, "< variants.txt";
#This file was created from the Unihan database; it matches hex codes of traditional characters to those of
#  corresponding simplified characters.
%variants = ();
while( chomp( $line = <variants> ) ){				#Map traditional to simplified characters
	($trad, $simp) = split( /\t/, $line );
	$variants{ $trad } = $simp;
}
close variants;


if( $ENV{'CONTENT_LENGTH'} > 0 ){ 					#If input has been entered:
	$char = param( "char" );
	chomp( $char );
	$code = convert( $char );					#Convert to Unicode hex

	if( exists $variants{ $code } ){				#If user entered a traditional character:
		$code = $variants{ $code };				#  convert to simplified
		$char = encode("utf8", chr( hex_to_dec($code) ) );
	}

	@matches = ();	 			 		#An empty array to store pronunciations that match

	foreach $pron ( keys(%homophony) ){
		if( $homophony{$pron} =~ m/$code/ ){		#If the query word has this
			push( @matches, $pron );			#  pronunciation, add matches
		}
	}
	$output = "<u>Homophone data for </u><span class=\"underlinedchinese\">$char</span><br /><br />\n" . " "x26; #output string
	$totalhomophones = 0;
					
	foreach $pron (@matches){					#Display the results
		$pronunciation_diacritics = add_diacritics( $pron );
		$info = $homophony{ $pron };
		$info =~ s/(\d+) +(.+)/\2/;				#Strip off the count
		$count = $1 - 1; 					#Subtract 1 for this character
		$info =~ s/( )?$code//;					#Remove copy of this character
		$info =~ s/^ +(.+)/\1/;				#Strip whitespace from front
		$totalhomophones += $count;				#Increment the total
		$words = $info;	 				#Remaining info is just the
						 	 		#  homophonous words		
									#Print output to screen
		$output = $output . "<em>$pronunciation_diacritics</em> pronuncation: <b>$count</b> matches<br/>\n" . " "x26 . "<span class=\"chinese\">";
							 		#And print output to file
		@words = split(/ /, $words);
		foreach (@words){
			$word = encode("utf8", chr( hex_to_dec($_) ) );
			$output = $output . "$word ";
		}
		$output = $output . "</span><br />\n" . " "x26 . "<br />\n" . " "x26;
	}
	$output = $output . "Total homophones for $char: <b>$totalhomophones</b><br />\n" . " "x8;
}

print <<HTML1;
Content-Type: text/html; charset=UTF-8

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "DTD/xhtml1-transitional.dtd">
<html lang="en">
    <head>
        <meta http-equiv="Content-Type" content="text/html;charset=UTF-8" />
        <title>Han character homophone counter</title>
        <link rel="stylesheet" type="text/css" href="../stevetools_stylesheet.css" />
    </head>

    <body>
       
        <h2>Han character homophone counter</h2>
        <p class="centercol">This tool will return the number of homophones for a given Chinese character. It considers
                          all pronunciations&mdash;for example, for <span class="chinese">&#x8FD8;</span>, it will
                          list homophones of <em>ha&#x0301;i</em>, <em>hua&#x0301;n</em>, and <em>hua&#x0300;n</em>.
                          Only Standard Mandarin pronunciations are considered.</p>
        <p class="centercol">The data for this tool come from <a href="http://lingua.mtsu.edu/chinese-computing/">
                          Jun Da's character corpus</a> and from the <a href="http://www.unicode.org/charts/unihan.html">
                          Unihan database</a>. The raw data this tool uses may be downloaded from <a href=
                          "/projects/politzer-ahles/homophony_data.txt">homophony_data.txt</a> if you
                          would like to process them directly.</p>
        <hr>

        <form method="post" action="http://www.mypolyuweb.hk/~sjpolit/cgi-bin/homophones2.pl">
           <p class="center"><b><u>Type or paste a single character into the box and click submit.</u></b></p>
           <p class="centercol"><font color="red">Please note:</font> The tool currently only works with single
                          characters, not compound words; if you enter more than one character, it will only
                          process the first. Currently it is only equipped to handle simplified characters. If you
                          enter a traditional character, the tool may convert it to simplified and proceed as
                          normal if you're lucky, or it may just say there are 0 matches. So, it's better to just
                          enter simplified characters.</p>
           <p class="center"><input type="text" name="char"> <input type="submit" value="submit"></center>
        </form>
HTML1

print <<HTMLresults;
        <p class="centercol">$output</p>
HTMLresults

print <<HTMLfooter;

	<hr>
	<p class="centercol"><strong>Note on corpus</strong>: This file was created from the pronunciation data in Jun Da's text corpus. There are characters and readings 
		present in the Unihan database that are not present in this corpus, but many of them are so infrequent, or
		not Chinese, that using Da's corpus gives a more accurate reflection of actually recognizable homophony (and
		even it has a large number of extremely infrequent characters). By way of example, only 2 characters
		with pronunciation geng4 appear in the dictionary <a href="http://www.nciku.com">nciku.com</a>. Da's corpus includes 1 character with this
		pronuncation; the Unihan database includes 12. For the pronunciation ge4, Da's corpus includes 20 characters,
		while Unihan includes 80. Thus, this corpus is a more accurate reflection of a Chinese speaker's
		lexicon, whereas the Unihan database is more comprehensive. Nevertheless, the corpus still does include some very low-frequency characters, so be sure to review
		the results when using this tool, rather than simply taking the numbers without looking. In the future I may revise the data used by this tool to include only characters
		above a certain frequency in the corpus, and/or re-generate the data using the <a href="http://www.plosone.org/article/info%3Adoi%2F10.1371%2Fjournal.pone.0010729">
		SUBTLEX-CH</a> (Cai & Brysbaert, 2010) corpus.</p>
	<p class="centercol">Also note that this tool does not take individual characters'/pronunciations' token frequencies into account. For some psycholinguistic applications,
		token frequencies may matter more than type frequencies. This tool is not designed to measure token frequencies, but the code for this tool could be revised to get token
		frequencies, using the frequency data from the corpus along with the homophony data from this tool.</p>
        <hr>

        <p class="mini">Script by <a href="..">Stephen Politzer-Ahles</a>. Last modified on <a href=
                        "../codearchive/homophones_code20091203.txt">2009-12-03</a> If you experience an error, contact
                        me at politzerahless <img src="../at.jpg" alt="(at)" height="10px" width="10px"> gmail
                        <img src="../dot.jpg" alt="(dot)" height="10px" width="10px"> com.</p>
HTMLfooter


sub convert{
		$chars = shift();
		
		$decoded = decode( "utf8", $chars );
		$hex = dec_to_hex( ord($decoded) );
		
		return $hex;

}
sub hex_to_dec{

		$hex = shift();
		$dec = 0;

		$pos = 0;
		
		while( $hex ){		
  		$digit = numberify( chop( $hex ) );
			$dec += $digit*( 16**$pos );
			$pos += 1;
		}
		
		return $dec;
}

sub dec_to_hex{
		$dec = shift();
		$hex = '';
		
		while( $dec ){
					 $digit = hexnumberify( $dec % 16 );
					 #print "$digit\n";
					 $hex = $digit . $hex;
					 $dec = int( $dec/16 );
					 #print "$dec\n";
		}

		return $hex;
}

sub numberify{
		#Function documentation
		#Takes a single hex digit in string format and converts it to a number
    		$x = shift();
		
		if( $x eq "1" ){ $x = 1; }
		elsif( $x eq "2" ){ $x = 2; }
		elsif( $x eq "3" ){ $x = 3; }
		elsif( $x eq "4" ){ $x = 4; }
		elsif( $x eq "5" ){ $x = 5; }
		elsif( $x eq "6" ){ $x = 6; }
		elsif( $x eq "7" ){ $x = 7; }
		elsif( $x eq "8" ){ $x = 8; }
		elsif( $x eq "9" ){ $x = 9; }
		elsif( $x eq "A" ){ $x = 10; }
		elsif( $x eq "B" ){ $x = 11; }
		elsif( $x eq "C" ){ $x = 12; }
		elsif( $x eq "D" ){ $x = 13; }
		elsif( $x eq "E" ){ $x = 14; }
		elsif( $x eq "F" ){ $x = 15; }
		
		return $x
}

sub hexnumberify{
		#Takes a decimal number below 16 in number format and converts it to a hex
		# digit
    $x = shift();
		
		if( $x < 10 ){ }#Do nothing
		elsif( $x == 10 ){ $x = 'A'; }
		elsif( $x == 11 ){ $x = 'B'; }
		elsif( $x == 12 ){ $x = 'C'; }
		elsif( $x == 13 ){ $x = 'D'; }
		elsif( $x == 14 ){ $x = 'E'; }
		elsif( $x == 15 ){ $x = 'F'; }
		
		return $x
}

sub add_diacritics{
	$num_to_dia_str = shift();

    NUM_TO_DIA_CONVERSION: {

	@syllables = ();
									#Segment the text
	while( $num_to_dia_str ){
		$laststr = $num_to_dia_str;
		$num_to_dia_str =~ s/(['.;!?,-])?([bcdfghjklmnpqrstwxyz]+)?([aeiouv]+:?)((?:ng|n)+)?(\d)?([\s.;!?,-]+)?//i;
		($preceder, $onset, $nucleus, $coda, $tone, $space) = ($1, $2, $3, $4, $5, $6);
		if( $laststr eq $num_to_dia_str ){ $outputstr = "Conversion aborted because of an error. You may have entered unrecognizable input. Please try again."; last NUM_TO_DIA_CONVERSION; }
		$syll = $preceder . $onset . $nucleus . $coda . $tone . $space;
		push( @syllables, $syll );
	}

	$outputstr = "";
									#The actual conversion
	foreach $syllable (@syllables){
		$syllable =~ s/(['.;!?,-])?([bcdfghjklmnpqrstwxyz]+)?([aeiouv]+:?)((?:ng|n)+)?(\d)?([\s.;!?,-]+)?//i;
		($preceder, $onset, $nucleus, $coda, $tone, $space) = ($1, $2, $3, $4, $5, $6);
				
		$diacritic = num_to_dia( $tone );			#Convert tone number to combining diacritic
				
		if( $nucleus eq "a" ){ 
			if( $diacritic ){ $outputstr = $outputstr . $preceder . $onset . "a" . "&#x$diacritic;" . $coda . $space;	}
			else{ $outputstr = $outputstr . $preceder . $onset . "a" . $coda . " "; }
		}
		elsif( $nucleus eq "ai" ){ 
			if( $diacritic ){ $outputstr = $outputstr . $preceder . $onset . "a" . "&#x$diacritic;" . "i" . $coda . $space; }
			else{ $outputstr = $outputstr . $preceder . $onset . "a" . "i" . $coda . $space; }
		}
		elsif( $nucleus eq "ao" ){ 
			if( $diacritic ){ $outputstr = $outputstr . $preceder . $onset . "a". "&#x$diacritic;" . "o" . $coda . $space;	}
			else{ $outputstr = $outputstr . $preceder . $onset . "a". "o" . $coda . $space;	}
		}
		elsif( $nucleus eq "e" ){ 
			if( $diacritic ){ $outputstr = $outputstr . $preceder . $onset . "e" . "&#x$diacritic;" . $coda . $space;	}
			else{ $outputstr = $outputstr . $preceder . $onset . "e" . $coda . $space;	}
		}
		elsif( $nucleus eq "ei" ){ 
			if( $diacritic ){ $outputstr = $outputstr . $preceder . $onset . "e" . "&#x$diacritic;" . "i" . $coda . $space; }
			else{ $outputstr = $outputstr . $preceder . $onset . "e" . "i" . $coda . $space; }
		}
		elsif( $nucleus eq "i" ){ 
			if( $diacritic ){ $outputstr = $outputstr . $preceder . $onset . "i" . "&#x$diacritic;" . $coda . $space; }
			else{ $outputstr = $outputstr . $preceder . $onset . "i" . $coda . $space; }
		}
		elsif( $nucleus eq "ia" ){ 
			if( $diacritic ){ $outputstr = $outputstr . $preceder . $onset . "i" . "a" . "&#x$diacritic;" . $coda . $space; }
			 else{ $outputstr = $outputstr . $preceder . $onset . "i" . "a" . $coda . $space; }
		}
		elsif( $nucleus eq "ie" ){ 
			if( $diacritic ){ $outputstr = $outputstr . $preceder . $onset . "i" . "e" . "&#x$diacritic;" . $coda . $space; }
			else{ $outputstr = $outputstr . $preceder . $onset . "i" . "e" . $coda . $space; }
		}
		elsif( $nucleus eq "io" ){ 
			if( $diacritic ){ $outputstr = $outputstr . $preceder . $onset . "i" . "o" . "&#x$diacritic;" . $coda . $space; }
			else{ $outputstr = $outputstr . $preceder . $onset . "i" . "o" . $coda . $space; }
		}
		elsif( $nucleus eq "iu" ){ 
			if( $diacritic ){ $outputstr = $outputstr . $preceder . $onset . "i" . "u" . "&#x$diacritic;" . $coda . $space; }
			else{ $outputstr = $outputstr . $preceder . $onset . "i" . "u" . $coda . $space; }
		}
		elsif( $nucleus eq "iao" ){
			if( $diacritic ){ $outputstr = $outputstr . $preceder . $onset . "i" . "a" . "&#x$diacritic;" . "o" . $coda . $space; }
			else{ $outputstr = $outputstr . $preceder . $onset . "i" . "a" . "o" . $coda . $space; }
		}
		elsif( $nucleus eq "o" ){ 
			if( $diacritic ){ $outputstr = $outputstr . $preceder . $onset . "o" . "&#x$diacritic;" . $coda . $space; }
			else{ $outputstr = $outputstr . $preceder . $onset . "o" . $coda . $space; }
		}
		elsif( $nucleus eq "ou" ){ 
			if( $diacritic ){ $outputstr = $outputstr . $preceder . $onset . "o" . "&#x$diacritic;" . "u" . $coda . $space; }
			else{ $outputstr = $outputstr . $preceder . $onset . "o" . "u" . $coda . $space; } 
		}
		elsif( $nucleus eq "u" ){ 
			if( $diacritic ){ $outputstr = $outputstr . $preceder . $onset . "u" . "&#x$diacritic;" . $coda . $space; }
			else{ $outputstr = $outputstr . $preceder . $onset . "u" . $coda . $space; }
		}
		elsif( $nucleus eq "ua" ){ 
			if( $diacritic ){ $outputstr = $outputstr . $preceder . $onset . "u" . "a" . "&#x$diacritic;" . $coda . $space; }
			else{ $outputstr = $outputstr . $preceder . $onset . "u" . "a" . $coda . $space; } 
		}
		elsif( $nucleus eq "ue" ){ 
			if( $diacritic ){ $outputstr = $outputstr . $preceder . $onset . "u" . "e" . "&#x$diacritic;" . $coda . $space; }
			else{ $outputstr = $outputstr . $preceder . $onset . "u" . "e" . $coda . $space; } 
		}
		elsif( $nucleus eq "ui" ){ 
			if( $diacritic ){ $outputstr = $outputstr . $preceder . $onset . "u" . "i" . "&#x$diacritic;" . $coda . $space; }
			else{ $outputstr = $outputstr . $preceder . $onset . "u" . "i" . $coda . $space; }
		}
		elsif( $nucleus eq "uo" ){ 
			if( $diacritic ){ $outputstr = $outputstr . $preceder . $onset . "u" . "o" . "&#x$diacritic;" . $coda . $space; }
			else{ $outputstr = $outputstr . $preceder . $onset . "u" . "o" . $coda . $space; }
		}
		elsif( $nucleus eq "v" || $nucleus eq "u:" ){ 
			if( $diacritic ){ $outputstr = $outputstr . $preceder . $onset . "&#x00FC;" . "&#x$diacritic;" . $coda . $space; }
			else{ $outputstr = $outputstr . $preceder . $onset . "&#x00FC;" . $coda . $space; }
		}
		elsif( $nucleus eq "ve" ){ 
			if( $diacritic ){ $outputstr = $outputstr . $preceder . $onset . "&#x00FC;" . "e" . "&#x$diacritic;" . $coda . $space; }
			else{ $outputstr = $outputstr . $preceder . $onset . "&#x00FC;" . "e" . $coda . $space; }
		}
	}
    }

	return $outputstr;
}

sub num_to_dia{

		$num = shift();
		
		if( $num == 1 ){ return "0304"; }
		elsif( $num == 2 ){ return "0301" ; }
		elsif( $num == 3 ){ return "030C"; }
		elsif( $num == 4 ){ return "0300"; }
		else{ return; }

}

end;