#!/usr/bin/perl
#strokecounter.pl
#Counts character strokes
#Author: Stephen Politzer-Ahles
#Last modified: 2009-11-18
#You are free to use or modify this code as you see fit, but please credit accordingly and do not redistribute for profit.
use CGI qw( :standard );                                   	#Modules
use Encode;

open totalstrokes, "< totalstrokes.txt";
while( chomp( $line = <totalstrokes> ) ){				#Populate %strokecount hash
			 ($c, $s) = split(/\t/, $line);
			 $strokecount{ $c } = $s;
}
close totalstrokes;

if( $ENV{'CONTENT_LENGTH'} > 0 ){                              #If input has been entered
    $hanstr = param( "hanstr" );                               #Get the input from a web form
    chomp( $hanstr );                                          #  and store in the variable $hanstr

    $decodedstr = decode( "utf8", $hanstr );                   #Decode characters from text into binary
		
		$perchar_strokes = "";
		$total_strokes = 0;
		
    while( $x = chop( $decodedstr ) ){                         #Take one character at a time off the end of the string
        $hex = dec_to_hex( ord($x) );
				$total_strokes += $strokecount{ $hex };
				$perchar_strokes = $strokecount{ $hex } . " " . $perchar_strokes;
    }
}
else{ $hanstr=""; }                                           #If input has not been entered, $hanstr is an empty string

print <<HTML1;
Content-Type: text/html; charset=UTF-8

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "DTD/xhtml1-transitional.dtd">
<html lang="en">
    <head>
        <meta http-equiv="Content-Type" content="text/html;charset=UTF-8" />
        <title>Han character stroke counter</title>
        <link rel="stylesheet" type="text/css" href="../stevetools_stylesheet.css" />
    </head>

    <body>
       
        <h2>Han character stroke counter</h2>
        <p class="centercol">This tool counts the total number of strokes in a single character or a string of
                       characters (useful for getting the number of strokes in a multi-character word such as
                       &#x7B14;&#x753B;). The counts come from the
                       <a href="http://www.unicode.org/charts/unihan.html">Unihan database</a> and are thus
                       subject to the Unihan <a href="http://www.unicode.org/charts/unihan.html#Disclaimers">disclaimer</a>.</p>
        <p class="centercol">It can only count the strokes in Chinese characters (hanzi, kanji, hanja); feeding it
                       characters from any other scripts will only confuse it.</p>
        <p class="centercol">Looking up stroke counts for a lot of words one at a time can be tedious (and <a
			href="http://linuxcommand.org/lc3_learning_the_shell.php">why should you do tedious work that a
			computer can do for you</a>?). If you need stroke counts for a lot of words, see the
			instructions below.</p>        

        <hr>

        <form method="post" action="http://www.mypolyuweb.hk/~sjpolit/cgi-bin/strokecounter.pl">
           <p class="center"><b><u>Type or paste a string of characters into the box and click submit.</u></b></p>
           <p class="center"><input type="text" name="hanstr" value="$hanstr"> <input type="submit" value="submit"></center>
        </form>
HTML1

if( $ENV{'CONTENT_LENGTH'} > 0 ){					#If input has been entered
print <<HTMLresults;
    <center>
        <table width="50%" border="0">
            <tr>
                <th>Total count</th>
                <th>Count per character</th>
            </tr>
            <tr>
                <td><textarea cols=50 name="total_strokes">$total_strokes</textarea></td>
                <td><textarea cols=50 name="perchar_strokes">$perchar_strokes</textarea></td>
        </table>
    </center>
HTMLresults

}

print <<HTMLfooter;
	<hr>
	<h3><a name="batch">How to run this in batch mode</a></h3>
	<ol class="center">
		<li>Since this is a Perl script, you will need to have Perl installed; you can get it at <a href="http://www.perl.org/">http://www.perl.org/</a>.</li>
		<li>Download and unzip <a href="../strokecounter_batchmode.zip">strokecounter_batchmode.zip</a>. This includes the script, the raw data (totalstrokes.txt), and a sample input file.</li>
		<li>Create a text file with the list of characters or words you would like stroke counts for. Each word or character should be on its own line. You can use datatocount.txt as a sample and overwrite it with your own file when you are done.
		<li>Run strokecounter_batchmode.pl from the command line. It will create a new output, strokecounts.txt, containing the total stroke count for each word you gave it. (If you gave it a multi-character string it will total the stroke count over all the characters; if you would like different behavior you can modify the script.)</li>
	</ol>

        <hr>
        <p class="mini">Script by <a href="..">Stephen Politzer-Ahles</a>. If you experience
                                 an error, contact me at politzerahless <img src="../at.jpg" alt="(at)"
                                 height="10px" width="10px"> gmail <img src="../dot.jpg" alt="(dot)"
                                 height="10px" width="10px"> com.

				<dl class="mini">Version history:
					<dd><a href="../codearchive/strokecounter_code_20091118.txt">2009-11-18</a>: Created</dd>
					<dd><a href="../codearchive/strokecounter_code_20120305.txt">2012-03-05</a>: Added instructions for using as a batch</dd>
					<dd>2012-06-16: Updated the Unihan data. Previous version of the script used an older version of the Unihan data which
						included some errors (for example, &#x90FD; was incorrectly listed as having 12 strokes). (The script itself remains unchanged.)</dd>
            				<dd><a href="../codearchive/strokecounter_code_20130805.txt">2013-08-05</a>: Migrated to NYU server.</dd>
   
				</dl>
	</p>

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