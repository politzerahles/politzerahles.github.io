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

   DIA_TO_NUM_CONVERSION: {
    	$dia_to_num_str = param( "dia_to_num_str" );               #Get the input from a web form 
    	chomp( $dia_to_num_str );
    	$dia_to_num_str_copy = $dia_to_num_str;
									#Regex string to match all possible syllables
	$matchstr = "(ne\d?|hu\d?an|ke\d?ng|yo\d?u\d?|sa\d?o\d?|ka\d?i\d?|ni\d?e\d?|lu\d?n|she\d?ng|na\d?ng|e\d?|no\d?u\d?|bo\d?|po\d?u\d?|za\d?o\d?|to\d?u\d?|la\d?i\d?|ku\d?o\d?|pi\d?ng|ke\d?|ta\d?o\d?|xi\d?ang|ji\d?|re\d?n|bu\d?|zho\d?u\d?|do\d?u\d?|ku\d?ang|be\d?i\d?|ri\d?|chi\d?|ta\d?i\d?|ti\d?|she\d?|ga\d?|sha\d?ng|ka\d?|li\d?e\d?|zhu\d?n|xi\d?e\d?|mi\d?|mo\d?u\d?|ze\d?|zha\d?o\d?|chu\d?ai\d?|hu\d?|za\d?|fa\d?|ca\d?n|zhu\d?an|di\d?ao\d?|ma\d?n|se\d?|qi\d?an|a\d?i\d?|ku\d?i\d?|ji\d?n|na\d?|bi\d?n|ba\d?|a\d?|ta\d?ng|ti\d?an|lv|shi\d?|da\d?ng|na\d?o\d?|che\d?ng|ma\d?|zu\d?an|xi\d?n|si\d?|shu\d?a\d?|zhu\d?|sha\d?o\d?|re\d?|me\d?|qi\d?ng|u\d?u\d?|la\d?o\d?|ma\d?i\d?|qu\d?e\d?|wo\d?|li\d?|zhu\d?a\d?|mi\d?an|sa\d?ng|ta\d?n|fa\d?n|sa\d?n|xi\d?an|ze\d?n|le\d?ng|pi\d?e\d?|zu\d?i\d?|we\d?ng|ji\d?ao\d?|ze\d?i\d?|yu\d?e\d?|pe\d?ng|qi\d?ao\d?|cho\d?ng|be\d?ng|pa\d?|lu\d?an|de\d?i\d?|gu\d?ang|ku\d?an|cha\d?i\d?|bi\d?|be\d?n|fe\d?ng|ca\d?o\d?|ro\d?ng|shu\d?an|ge\d?i\d?|nv|zu\d?o\d?|li\d?a\d?|o\d?|ni\d?ao\d?|nu\d?an|du\d?|ba\d?i\d?|ra\d?n|ce\d?n|za\d?n|he\d?i\d?|ke\d?n|zhu\d?o\d?|la\d?ng|ya\d?o\d?|me\d?ng|ya\d?ng|xi\d?ng|chu\d?an|ne\d?us|no\d?ng|ka\d?n|cha\d?ng|ji\d?ang|a\d?ng|tu\d?i\d?|na\d?n|yi\d?n|lu\d?e\d?|we\d?i\d?|yo\d?|zha\d?i\d?|ha\d?o\d?|me\d?i\d?|chu\d?i\d?|gu\d?|ze\d?ng|chu\d?ang|di\d?an|zhu\d?i\d?|xu\d?|shu\d?o\d?|zhe\d?ng|ca\d?|ca\d?i\d?|lu\d?o\d?|ne\d?i\d?|che\d?n|pi\d?n|ge\d?ge\d?|fu\d?|cu\d?n|bi\d?e\d?|bi\d?an|sa\d?|tu\d?an|ya\d?i\d?|la\d?n|co\d?u\d?|ka\d?ng|sha\d?|ju\d?an|e\d?n|qu\d?an|de\d?|zu\d?|tu\d?n|te\d?ng|sha\d?i\d?|xu\d?n|gu\d?n|za\d?ng|ku\d?n|na\d?i\d?|qi\d?ang|she\d?n|ku\d?a\d?|ni\d?an|che\d?|mi\d?n|he\d?|ba\d?n|qi\d?ong|pu\d?|su\d?o\d?|ji\d?an|xu\d?e\d?|fe\d?i\d?|re\d?ng|ca\d?ng|ce\d?ng|ji\d?ong|cu\d?o\d?|go\d?u\d?|she\d?i\d?|le\d?|da\d?|cha\d?|ju\d?|mi\d?e\d?|xi\d?|nu\d?|xi\d?ao\d?|ci\d?|yo\d?ng|du\d?i\d?|se\d?ng|ta\d?|hu\d?ang|pe\d?n|ti\d?ng|ge\d?ng|su\d?n|pa\d?ng|zu\d?n|mo\d?|wa\d?n|ge\d?|we\d?n|a\d?o\d?|ru\d?i\d?|di\d?e\d?|pa\d?n|qu\d?|la\d?|me\d?n|de\d?ng|di\d?a\d?|qi\d?u\d?|pe\d?i\d?|pa\d?i\d?|ha\d?i\d?|shu\d?i\d?|ha\d?n|ka\d?o\d?|ng|sa\d?i\d?|ga\d?o\d?|hu\d?a\d?|lu\d?|qi\d?|qu\d?n|yu\d?an|ya\d?|ni\d?ang|tu\d?|ju\d?n|zha\d?ng|cu\d?i\d?|ji\d?e\d?|li\d?ng|nga\d?g|fa\d?ng|wu\d?|zhi\d?|ni\d?n|fo\d?u\d?|hng|xu\d?an|du\d?n|zo\d?ng|yi\d?|e\d?i\d?|qi\d?a\d?|ha\d?|Ju\d?n|ro\d?u\d?|chu\d?n|shu\d?|da\d?o\d?|ru\d?n|nu\d?o\d?|ge\d?n|ha\d?ng|zhe\d?i\d?|cha\d?o\d?|ba\d?ng|ye\d?|li\d?u\d?|li\d?n|zo\d?u\d?|ni\d?ng|gu\d?a\d?|hu\d?o\d?|se\d?n|zhu\d?ai\d?|su\d?|hu\d?ai\d?|ku\d?ai\d?|bi\d?ng|shu\d?ang|yu\d?n|ru\d?|le\d?i\d?|E|ku\d?|li\d?ao\d?|lo\d?|hu\d?i\d?|po\d?|li\d?ang|Sha\d?n|pi\d?ao\d?|ji\d?u\d?|ga\d?ng|bi\d?ao\d?|su\d?i\d?|ne\d?n|fi\d?ao\d?|su\d?an|za\d?i\d?|ju\d?e\d?|ru\d?an|zhe\d?n|di\d?|mi\d?ng|ba\d?o\d?|tu\d?o\d?|ho\d?ng|ko\d?u\d?|pa\d?o\d?|lo\d?u\d?|ra\d?o\d?|cu\d?|yu\d?|gu\d?o\d?|mu\d?|wa\d?|ni\d?|ya\d?n|zha\d?n|ti\d?e\d?|wa\d?i\d?|li\d?an|ma\d?o\d?|ho\d?u\d?|zhe\d?|gu\d?an|a\d?n|yi\d?ng|di\d?u\d?|da\d?n|di\d?ng|fo\d?|sha\d?n|shu\d?ai\d?|sho\d?u\d?|cu\d?an|qi\d?n|go\d?ng|co\d?ng|ma\d?ng|zha\d?|so\d?|du\d?o\d?|zhu\d?ang|e\d?r|ko\d?ng|so\d?ng|du\d?an|ga\d?n|ti\d?ao\d?|gu\d?ai\d?|so\d?u\d?|nu\d?e\d?|ji\d?a\d?|gu\d?i\d?|ne\d?ng|zho\d?ng|ni\d?u\d?|pi\d?an|shu\d?n|zi\d?|hu\d?n|wa\d?ng|to\d?ng|ga\d?i\d?|da\d?i\d?|chu\d?|ru\d?o\d?|ce\d?|do\d?ng|mi\d?ao\d?|fe\d?n|lo\d?ng|pi\d?|xi\d?a\d?|chu\d?o\d?|qi\d?e\d?|xi\d?ong|cho\d?u\d?|o\d?u\d?|mi\d?u\d?|ye\d?n|ji\d?ng|te\d?|ra\d?ng|xi\d?u\d?|he\d?n|he\d?ng|cha\d?n)";

	$decodedline = decode( "utf8", $dia_to_num_str );                   			#Decode characters from text into binary
	$newstr = "";					 				 		#Start with empty string

	while( $x = chop( $decodedline ) ){ 							#Take one character at a time from the end
			 $x = dec_to_hex( ord( $x ) );						#Convert to hex
			 if( $x eq "2019" ){ $newstr = "'" . $newstr; }				#Convert curly ' to straight '
			 else{		 					 																			 #Convert normal letters back to normal letters
			 	($letter, $tone) = split(/\+/, diatonum( $x ) );
				$newstr = $letter . $tone . $newstr;
			 }
	}

	@words = split( / /, $newstr );			#Split on whitespace to get words

	$finalstr = "";
	foreach $word (@words){
		$finalword = "";
		while( $word ){

			$thismatchstr = $matchstr;				#Match string being used in this loop
			$word =~ s/$thismatchstr//;				#Strip off the first thing that looks like an allowable syllable
			$syllable = $1;
	
			$word =~ s/$thismatchstr//;				#try getting another
			if(! $1){						#if it doesn't work:
				$word = $syllable . $word;			#put the bad syllable back on the word
				$syllable =~ s/\d//;				#Format the syllable like it was in the matchstring
				$syllable =~ s/([aeiou])(\w)/\1\\d\?\2/g;
				$thismatchstr = s/$syllable//;		#Remove it from the matchstring
				redo;
			}
			else{
				$nextsyllable = $1; 
										#Move numbers to syllable ends
				$syllable =~ s/(')?([.;!?,-'"])?([bcdfghjklmnpqrstwxyz]+)?([aeiouv]+)(\d)?([aeiouv])?((?:ng|n)+)?([\s.;!?,-'"]+)?//i;
				($apostrophe, $preceder, $onset, $nucleus1, $tone, $nucleus2, $coda, $space) = ($1, $2, $3, $4, $5, $6, $7, $8);				#Error handling hack!
				$syllable = $preceder . $onset . $nucleus1 . $nucleus2 . $coda . $tone . $space;			 						#Throw away the unnecessary apostrophe

				$nextsyllable =~ s/(')?([.;!?,-'"])?([bcdfghjklmnpqrstwxyz]+)?([aeiouv]+)(\d)?([aeiouv])?((?:ng|n)+)?([\s.;!?,-'"]+)?//i;
				($apostrophe, $preceder, $onset, $nucleus1, $tone, $nucleus2, $coda, $space) = ($1, $2, $3, $4, $5, $6, $7, $8);				#Error handling hack!
				$nextsyllable = $preceder . $onset . $nucleus1 . $nucleus2 . $coda . $tone . $space;

				$finalword = $syllable . $nextsyllable;

				$thismatchstr = $matchstr;			#Restore the matchstring
		}
		}
		$finalstr = $finalstr . " " . $finalword;
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
        <link rel="stylesheet" type="text/css" href="/~sjpa/stevetools_stylesheet.css" />
    </head>

    <body>
       
              <!--<div style="background:#FFF8DC; float:right; border:2px solid #708090; width:20%">
                <h3 align="center"><a href="/~sjpa/chinesetools.html"><span style="color:black">
                                   Chinese and Uyghur tools</span></a></h3>
                        <ul>
                            <li><a href="/~sjpa/cgi-bin/unicode_converter.pl">
                                Characters-to-Unicode converter</a></li>
                            <li><b>
                                Pinyin tone marks converter</b></li>
                            <li><a href="/~sjpa/cgi-bin/strokecounter.pl">
                                Stroke counter</a></li>
                            <li><a href="/~sjpa/cgi-bin/uyghurscript.pl">
                                Uyghur script converter</a></li>
                        </ul>
              </div>-->
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
        <form method="post" action="http://people.ku.edu/~sjpa/cgi-bin/tones_dev.pl#results">
        <p class="center"><b><u>Type or paste some pinyin into either box and click submit.</u></b></p>
        <p class="center"><font color="red">This tool is still under development; please note the following
                          caveats:</font></p>
        <p class="center">For pinyin with numbers, the tone number for each syllable must come at the end of the
                             syllable, not after the vowel, or else there will be an error. For example,
                             <font color="#006400"><code>mang2</code></font> is correct, <font color="#006400">
                             <code>ma2ng</code></font> is incorrect.<br/>
                             Syllables ending in <em>n</em> or <em>ng</em> may cause problems when converting
                             from diacritics to tone numbers. For example, <font color="#006400"><code>
                             Jia&#x0300;nguo&#x0301;me&#x0301;n</code></font>
                             currently yields <code>Jiang4uo2men2</code> instead of the correct <code>Jian4guo2men2</code>.<br/>
                             Be careful that you put the text in the proper field, (i.e., don't put pinyin with
                             diacritics in the field for pinyin with numbers), or there may be an error.</p>
           <!--<p class="center">If you are waiting a very long time after clicking "submit" and the results haven't
                             loaded yet, there has probably been an error and the page is in an infinite loop. You
                             can reload the page by selecting the URL in your browser bar and hitting ENTER, and
                             then you can try again.</p>-->

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