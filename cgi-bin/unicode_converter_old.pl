#!/usr/local/bin/perl
#unicode_converter.pl
#Author: Stephen Politzer-Ahles
#Last modified: 25 October 2009
#Script to convert a string of characters into unicode decimal code points, complete with &#...; to make them
#  ready for pasting into an html document

use CGI qw( :standard );                                   #Modules
use Encode;

$hanstr = param( "hanstr" );                               #Get the input from a web form (unicode_converter.html)
chomp( $hanstr );                                          #  and store in the variable $hanstr

$decodedstr = decode( "utf8", $hanstr );                   #Decode characters from text into binary
$codes_mixed = "";
$codes_dec = "";
while( $x = chop( $decodedstr ) ){                         #Take one character at a time off the end of the string
    if( ord($x) <= 255 ){
        $codes_mixed = $x . $codes_mixed;                        #If it's a normal ASCII char, just append the char
    }
    else{
        $codes_mixed = "&amp;#" . ord($x) . ";" . $codes_mixed; ; #Else, append the codepoint along with &#...;
    } 
    $codes_dec = "&amp;#" . ord($x) . ";" . $codes_dec;
}

                                                           #Show the results on a webpage
print <<HTML;
Content-Type: text/html; charset=UTF-8

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "DTD/xhtml1-transitional.dtd">
<html lang="en">
    <head>
        <meta http-equiv="Content-Type" content="text/html;charset=UTF-8" />
        <title>Convert special characters to Unicode</title>
        <link href="/default/pubprwb.cc.ku.edu/css/peoplestyle.css" title="people.ku.edu  stylesheet" />
    </head>

    <body style="background:#DCDCDC">
    <p align="center">You entered: $hanstr</p>
    <center>
        <table width="50%" border="0">
            <tr>
                <!--<th><del>Unicode hex</del></th>-->
                <th>Unicode decimal (converted all characters)</th>
                <th>Unicode decimal (only converted non-basic characters)</th>
            </tr>
            <tr>
                <!--<td><textarea cols=50 name="hex">(not working yet, please try some other time) </textarea></td>-->
                <td><textarea cols=50 name="codes_dec">$codes_dec</textarea></td>
                <td><textarea cols=50 name="codes_mixed">$codes_mixed</textarea></td>
            </tr>          
        </table>
    <hr>
    <form method="post" action="http://people.ku.edu/~sjpa/cgi-bin/unicode_converter_old.pl">
           <p align="center">Submit another string?<br/>
           <textarea cols=50 name="hanstr"></textarea>
           <input type="submit" value="submit"></p>
    </form>  
    <hr>
    <p align="center">Or <a href="http://people.ku.edu/~sjpa/unicode_converter.html">Return to the main page</a></p>                                                                 
  </body>

</html>
HTML

exit;