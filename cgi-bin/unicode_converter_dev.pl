#!/usr/local/bin/perl

use CGI qw( :standard );                                   #Modules
use Encode;

if( $ENV{'CONTENT_LENGTH'} > 0 ){                              #If input has been entered
    $hanstr = param( "hanstr" );                               #Get the input from a web form (unicode_converter.html)
    chomp( $hanstr );                                          #  and store in the variable $hanstr

    $decodedstr = decode( "utf8", $hanstr );                   #Decode characters from text into binary
    $codes_mixed = "";
    $codes_dec = "";
    $codes_hex = "";
    while( $x = chop( $decodedstr ) ){                         #Take one character at a time off the end of the string
        if( ord($x) <= 255 ){
            $codes_mixed = $x . $codes_mixed;                        #If it's a normal ASCII char, just append the char
        }
        else{
            $codes_mixed = "&amp;#" . ord($x) . ";" . $codes_mixed; ; #Else, append the codepoint along with &#...;
        } 
        $codes_dec = "&amp;#" . ord($x) . ";" . $codes_dec;
	 $codes_hex = "&amp;#x" . dec_to_hex( ord($x) ) . ";" . $codes_hex;    #Build the hex string
    }
}
else{ $hanstr=""; }                                           #Else, $hanstr is an empty string

print <<HTML1;
Content-Type: text/html; charset=UTF-8

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "DTD/xhtml1-transitional.dtd">
<html lang="en">
    <head>
        <meta http-equiv="Content-Type" content="text/html;charset=UTF-8" />
        <title>Convert special characters to Unicode</title>
        <link href="/default/pubprwb.cc.ku.edu/css/peoplestyle.css" title="people.ku.edu stylesheet" />
    </head>

    <body style="background:#DCDCDC">
       
        <center><h2>Characters-to-Unicode converter</h2></center>
        <table width="75%" align="center">
            <tr>
                <td>
                    <p>This tool will convert special characters (such as CJK characters, special IPA characters,
                       and other non-ASCII scripts) into Unicode decimal code points, along with the HTML escape
                       sequences that allow the codes to display as characters. The output of this tool can be
                       pasted directly into HTML source code (for example) to display characters that are not
                       supported otherwise. Code points for individual characters are available in the <a href=
                       "http://www.unicode.org/charts/unihan.html">Unihan database</a>, but can only be
                       looked up one character at a time; with this tool, you can enter as many characters
                       as you want at once.</p>
                </td>
            </tr>
        </table>                 

        <hr>
        
        <form method="post" action="http://people.ku.edu/~sjpa/cgi-bin/unicode_converter_dev.pl">
           <p align="center">Type or paste a string of characters into the box and click submit.</p>
           <center><textarea cols=80 name="hanstr">$hanstr</textarea> <input type="submit" value="submit"></center>
        </form>
HTML1

print <<HTMLresults;
    <center>
        <table width="50%" border="0">
            <tr>
                <th><del>Unicode hex</del></th>
                <th>Unicode decimal (converted all characters)</th>
                <th>Unicode decimal (only converted non-basic characters)</th>
            </tr>
            <tr>
                <td><textarea cols=50 name="hex">$codes_hex</textarea></td>
                <td><textarea cols=50 name="codes_dec">$codes_dec</textarea></td>
                <td><textarea cols=50 name="codes_mixed">$codes_mixed</textarea></td>
            </tr>          
        </table>
    </center>
HTMLresults

print <<HTMLfooter;
        <hr>
        <p style="font-size:70%">Script by Stephen Politzer-Ahles. Last modified on 27 October 2009.</a>
        <p style="font-size:70%">If this tool is not working, try <a href=
                                 "http://pinyin.info/tools/converter/chars2uninumbers.html"> this nearly
                                 identical tool</a> by Mark Swofford of PinyinInfo</p>

    </body>
</html>
HTMLfooter

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

exit;