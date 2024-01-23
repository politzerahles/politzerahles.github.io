#!/usr/local/bin/perl



# This is just a dumb script that creates a webpage that takes a text string as input, and then spits that text string back out


use CGI qw( :standard );                                   	# Modules
use Encode;

if( $ENV{'CONTENT_LENGTH'} > 0 ){                              # If input has been entered...
	$inputstr = param( "inputstr" );                               # Get the input from a web form and store in the variable $inputstr

	chomp( $inputstr );                                     	# Remove trailing whitespace/newline from the input
	$inputstr = decode( "utf8", $inputstr );				# Decode characters from text into binary


	$newstr = "";								# Initiatlize a new string that will spit out the output

	while( $x = chop( $inputstr ) ){					# Iterate through the string, taking one character at a time off the end and appending it to the beginning of $newstr
		$newstr = encode( "utf8", $x ) . $newstr;
	}
}
else{ $inputstr=""; }                                           # If input has not been entered, $inputstr is an empty string


									# Here we create a long string which is the HTML which will show the site. It includes a "post" form that will feed its input into this script
print <<HTML1;
Content-Type: text/html; charset=UTF-8

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "DTD/xhtml1-transitional.dtd">
<html lang="en">
    <head>
        <meta http-equiv="Content-Type" content="text/html;charset=UTF-8" />
        <title>test</title>
        <link rel="stylesheet" type="text/css" href="/projects/politzer-ahles/stevetools_stylesheet.css" />
    </head>

    <body>
       
        <h2>just testing CGI i/o</h2>
      
        <form method="post" action="http://www.nyu.edu/cgi-bin/cgiwrap/spa268/test_with_encode.pl">
           <p class="center"><b><u>Type or paste a string of characters into the box and click submit.</u></b></p>
           <p class="center"><input type="text" name="inputstr" value="$inputstr"> <input type="submit" value="submit"></center>
        </form>
HTML1
									# End of the long string of HTML


									# If input has been entered, also print out some more HTML which shows the output (i.e., copying the same input)
if( $ENV{'CONTENT_LENGTH'} > 0 ){					
print <<HTMLresults;
    <center><strong>OUTPUT:</center></strong>
    <center>$newstr</center>
HTMLresults

}									# End of the output


									# One more string, just printing the HTML footer
print <<HTMLfooter;
    </body>
</html>
HTMLfooter
									# Done
exit;