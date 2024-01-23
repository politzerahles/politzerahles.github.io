#!/usr/local/bin/perl
#Tones.pl
#Converts pinyin with tone numbers to pinyin with tone diacritics
#Author: Stephen Politzer-Ahles
#Last modified: 2009-11-25
#You are free to use or modify this code as you see fit, but please credit accordingly and do not redistribute for profit.


use CGI qw( :standard );                                   	#Modules
use Encode;

if( $ENV{'CONTENT_LENGTH'} > 0 ){                              #If input has been entered
    $num_to_dia_str = param( "num_to_dia_str" );               #Get the input from a web form 
    chomp( $num_to_dia_str );
    $num_to_dia_str_copy = $num_to_dia_str;
    NUM_TO_DIA_CONVERSION: {

	@syllables = ();
									#Segment the text
	while( $num_to_dia_str ){
		$laststr = $num_to_dia_str;
		$num_to_dia_str =~ s/(['.;!?,-])?([bcdfghjklmnpqrstwxyz]+)?([aeiouv]+:?)((?:ng|n|r)+)?(\d)?([\s.;!?,-]+)?//i;
		($preceder, $onset, $nucleus, $coda, $tone, $space) = ($1, $2, $3, $4, $5, $6);
		if( $laststr eq $num_to_dia_str ){ $outputstr = "Conversion aborted because of an error. You may have entered unrecognizable input. Please try again."; last NUM_TO_DIA_CONVERSION; }
		$syll = $preceder . $onset . $nucleus . $coda . $tone . $space;
		push( @syllables, $syll );
	}

	$outputstr = "";
									#The actual conversion
	foreach $syllable (@syllables){
		$syllable =~ s/(['.;!?,-])?([bcdfghjklmnpqrstwxyz]+)?([aeiouv]+:?)((?:ng|n|r)+)?(\d)?([\s.;!?,-]+)?//i;
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

   DIA_TO_NUM_CONVERSION: {
    	$dia_to_num_str = param( "dia_to_num_str" );               #Get the input from a web form 
    	chomp( $dia_to_num_str );
    	$dia_to_num_str_copy = $dia_to_num_str;

	$decodedline = decode( "utf8", $dia_to_num_str );                   #Decode characters from text into binary
	$newstr = "";					 				 		#Start with empty string

	while( $x = chop( $decodedline ) ){ 							#Take one character at a time from the end
			 $x = dec_to_hex( ord( $x ) );
			 if( $x eq "2019" ){ $newstr = "'" . $newstr; }				 #Convert curly ' to straight '
			 else{		 					 																			 #Convert normal letters back to normal letters
			 	($letter, $tone) = split(/\+/, diatonum( $x ) );
				$newstr = $letter . $tone . $newstr;
			 }
	}

	$finalstr = "";
	while( $newstr ){		 								#Move numbers to syllable ends
		$lastnewstr = $newstr;
		$newstr =~ s/(')?([.;!?,-])?([bcdfghjklmnpqrstwxyz]+)?([aeiouv]+)(\d)?([aeiouv])?((?:ng|n|r)+)?([\s.;!?,-]+)?//i;
									 				 																					 #Error handling hack!
		if( $lastnewstr eq $newstr ){ $finalstr = "Conversion aborted because of an error. You may have entered unrecognizable input. Please try again."; last DIA_TO_NUM_CONVERSION; }
			 				 																					 #Throw away the unnecessary apostrophe
		($apostrophe, $preceder, $onset, $nucleus1, $tone, $nucleus2, $coda, $space) = ($1, $2, $3, $4, $5, $6, $7, $8);
		$word = $preceder . $onset . $nucleus1 . $nucleus2 . $coda . $tone . $space;
			 
		$finalstr = $finalstr . $word;
	}
   }

}
else{ $num_to_dia_str_copy=""; $dia_to_num_str_copy=""; }                                           #Else, $hanstr is an empty string

print <<HTML1;
Content-Type: text/html; charset=UTF-8

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "DTD/xhtml1-transitional.dtd">
<html lang="en">
    <head>
        <meta http-equiv="Content-Type" content="text/html;charset=UTF-8" />
        <title>Pinyin tone numbers and diacritics</title>
        <link rel="stylesheet" type="text/css" href="/projects/politzer-ahles/stevetools_stylesheet.css" />
    </head>

    <body>
               <h2>Pinyin tone numbers and diacritics</h2>

         <p class="center">This tool will convert <a href="http://en.wikipedia.org/wiki/Pinyin">Hanyu Pinyin</a> written
                       with tone numbers (e.g., <font color="#006400"><code>Ni3 hao3!</code></font>) to Hanyu Pinyin
                       written with diacritics (e.g., <font color="#006400"><code>Ni&#x30C; ha&#x30C;o!</code>
                       </font>), and vice versa. Punctuation, capitalization, and spacing are not a problem. The
                       tool can currently only convert pinyin for syllables of Standard Mandarin, not any other
                       dialects, and it cannot convert other romanizations (such as Wade-Giles).</p>
          <p class="center">For more information on writing in pinyin, see <a href="http://pinyin.info/readings/zyg/rules.html#x4.11">
                       Basic Rules of Hanyu Pinyin Orthography</a>, at <a href="http://pinyin.info/">
                       Pi&#x304;nyi&#x304;n.info</a>.
                </td>                 

        <hr>
        <form method="post" action="http://www.nyu.edu/cgi-bin/cgiwrap/spa268/tones.pl#results">
        <p class="center"><b><u>Type or paste some pinyin into either box and click submit.</u></b></p>
        <p class="center"><font color="red">This tool is still under development; please note the following
                          caveats:</font></p>
        <ul class="center"><li>For pinyin with numbers, the tone number for each syllable must come at the end of the
                             syllable, not after the vowel, or else there will be an error. For example,
                             <font color="#006400"><code>mang2</code></font> is correct, <font color="#006400">
                             <code>ma2ng</code></font> is incorrect.</li>
                             <li>Syllables ending in <em>n</em> or <em>ng</em> may cause problems when converting
                             from diacritics to tone numbers. For example, <font color="#006400"><code>
                             Jia&#x0300;nguo&#x0301;me&#x0301;n</code></font>
                             currently yields <code>Jiang4uo2men2</code> instead of the correct <code>Jian4guo2men2</code>.</li>
                             <li>Be careful that you put the text in the proper field, (i.e., don't put pinyin with
                             diacritics in the field for pinyin with numbers), or there may be an error.</li>
				<li>Spaces between words/syllables aren't a problem, but a space at the very beginning of the string
				will give you an error.</li></ul>
           <!--<p class="center">If you are waiting a very long time after clicking "submit" and the results haven't
                             loaded yet, there has probably been an error and the page is in an infinite loop. You
                             can reload the page by selecting the URL in your browser bar and hitting ENTER, and
                             then you can try again.</p>-->
        <p class="center"><font color="red">Update 2012-09-21:</font> I am not working on this anymore, so the abovementioned bugs will not be corrected.
				If you need to type Pinyin with tone diacritics, consider using <a href="http://www.lexilogos.com/keyboard/pinyin_conversion.htm">this tool</a>,
				which works great. Or download
				<a href="http://pinyinput.sourceforge.net/">Pinyinput</a>, a handy IME for inputting Pinyin with diacritics
				directly from your keyboard.</p>

           <a name="results">
               <table align= "center" width="50%" border="0">
                   <tr>
                       <th>Pinyin with numbers (to convert to diacritics)</th>
                       <th>Pinyin with diacritics (to convert to numbers)</th>
                   </tr>
                   <tr>
                       <td><textarea cols=50 name="num_to_dia_str"></textarea></td>
                       <td><textarea cols=50 name="dia_to_num_str"></textarea></td>
                   </tr>
                   <tr>
                       <td align="center" colspan="2"><input type="submit" value="submit"></td>

               </table>
        </form>
HTML1

if( $ENV{'CONTENT_LENGTH'} > 0 ){     #If input has been entered
    print <<HTMLresults;
    <center>
        <table width="50%" border="0">
            <tr>
                <td><b>You entered:</b> $num_to_dia_str_copy</td>
                <td><b>You entered:</b> $dia_to_num_str_copy</td>
            </tr>
            <tr>
                <td><textarea cols=50 name="outputstr">$outputstr</textarea></td>
                <td><textarea cols=50 name="finalstr">$finalstr</textarea></td>
            </tr>
        </table>

    </center>
HTMLresults

}

print <<HTMLfooter;
        <hr>
        <p class="mini">Script by <a href="/~sjpa">Stephen Politzer-Ahles</a>. Last modified on 2009-11-27.
                                 If you experience an error, contact me at politzerahless <img src="/~sjpa/at.jpg"
                                 alt="(at)" height="10px" width="10px"> gmail <img src="/~sjpa/dot.jpg" alt="(dot)"
                                 height="10px" width="10px"> com.
                                 <span style="float:right; font-size:100%"><a href="/~sjpa/chinesetools.html">back to 
                                 Chinese tools</a></span></p>
        <dl class="mini">Version history:
            <dd><a href="/~sjpa/tones_code_20091125.txt">2009-11-25</a>: Created, number-to-diacritic only</dd>
            <dd><a href="/~sjpa/tones_code_20091127.txt">2009-11-27</a>: Enabled diacritic-to-number and error handling</dd>
        </dl>
    </body>
</html>
HTMLfooter

sub num_to_dia{

		$num = shift();
		
		if( $num == 1 ){ return "0304"; }
		elsif( $num == 2 ){ return "0301" ; }
		elsif( $num == 3 ){ return "030C"; }
		elsif( $num == 4 ){ return "0300"; }
		else{ return; }

}

sub diatonum{

		$dia = shift();
		
		if( $dia == "0304" ){ return 1; }
		elsif( $dia == "0301" ){ return 2; }
		elsif( $dia == "030C" ){ return 3; }
		elsif( $dia == "0300" ){ return 4; }
		else{ return; }
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
								#Make sure the hex number is 4 digits long
		while( length( $hex ) < 4 ){ $hex = "0" . $hex; }

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

sub diatonum{

		$dia = shift();
		
		if( $dia eq "0304" ){ return 1; }					 #Combining diacritics
		elsif( $dia eq "0301" ){ return 2; }
		elsif( $dia eq "030C" ){ return 3; }
		elsif( $dia eq "0300" ){ return 4; }
		elsif( $dia eq "01DB" ){ return "V+4";}		 #Unified glyphs
		elsif( $dia eq "0101" ){ return "a+1";}
		elsif( $dia eq "00C8" ){ return "E+4";}
		elsif( $dia eq "01D8" ){ return "v+2";}
		elsif( $dia eq "00F2" ){ return "o+4";}
		elsif( $dia eq "00E9" ){ return "e+2";}
		elsif( $dia eq "00FA" ){ return "u+2";}
		elsif( $dia eq "016B" ){ return "u+1";}
		elsif( $dia eq "01D1" ){ return "O+3";}
		elsif( $dia eq "00D9" ){ return "U+4";}
		elsif( $dia eq "00D2" ){ return "O+4";}
		elsif( $dia eq "00EC" ){ return "i+4";}
		elsif( $dia eq "00C9" ){ return "E+2";}
		elsif( $dia eq "016A" ){ return "U+1";}
		elsif( $dia eq "01D3" ){ return "U+3";}
		elsif( $dia eq "01DC" ){ return "v+4";}
		elsif( $dia eq "00E0" ){ return "a+4";}
		elsif( $dia eq "0100" ){ return "A+1";}
		elsif( $dia eq "0112" ){ return "E+1";}
		elsif( $dia eq "01CD" ){ return "A+3";}
		elsif( $dia eq "011A" ){ return "E+3";}
		elsif( $dia eq "01D2" ){ return "o+3";}
		elsif( $dia eq "00C1" ){ return "A+2";}
		elsif( $dia eq "01D6" ){ return "v+1";}
		elsif( $dia eq "00D3" ){ return "O+2";}
		elsif( $dia eq "00E1" ){ return "a+2";}
		elsif( $dia eq "00CC" ){ return "I+4";}
		elsif( $dia eq "00F3" ){ return "o+2";}
		elsif( $dia eq "012B" ){ return "i+1";}
		elsif( $dia eq "01D7" ){ return "V+2";}
		elsif( $dia eq "01DA" ){ return "v+3";}
		elsif( $dia eq "00ED" ){ return "i+2";}
		elsif( $dia eq "01D0" ){ return "i+3";}
		elsif( $dia eq "014D" ){ return "o+1";}
		elsif( $dia eq "012A" ){ return "I+1";}
		elsif( $dia eq "00CD" ){ return "I+2";}
		elsif( $dia eq "014C" ){ return "O+1";}
		elsif( $dia eq "00F9" ){ return "u+4";}
		elsif( $dia eq "01D4" ){ return "u+3";}
		elsif( $dia eq "00E8" ){ return "e+4";}
		elsif( $dia eq "011B" ){ return "e+3";}
		elsif( $dia eq "01D5" ){ return "V+1";}
		elsif( $dia eq "01CE" ){ return "a+3";}
		elsif( $dia eq "0113" ){ return "e+1";}
		elsif( $dia eq "01CF" ){ return "I+3";}
		elsif( $dia eq "00DA" ){ return "U+2";}
		elsif( $dia eq "00C0" ){ return "A+4";}
		elsif( $dia eq "01D9" ){ return "V+3";}
		elsif( $dia eq "00FC" ){ return "v"; }					#unified u:
		else{ return encode("utf8", chr( hex_to_dec($dia) ) ); }		#No diacritic, 
								 										 										 			#just regular letter
}

exit;