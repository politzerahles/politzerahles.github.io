#!/usr/bin/perl
#uyghurscript
#Convert between different Uyghur alphabets
#Author: Stephen Politzer-Ahles
#Last modified: 2013-08-05
#You are free to use or modify this code as you see fit, but please credit accordingly and do not redistribute for profit.

use CGI qw( :standard );                                   	#Modules
use Encode;

our %latincodes = ("h" => "06BE FBAA FBAB FBAC FBAD",
	 	"y" => "064A FEF1 FEF2 FEF3 FEF4",
		"'" => "0626 FE89 FE8A FE8B FE8C", 
		"s" => "0633 FEB1 FEB2 FEB3 FEB4",
		"u" => "06C7 FBD7 FBD8",
		"t" => "062A FE95 FE96 FE97 FE98",
		"j" => "062C FE9D FE9E FE9F FEA0",
		"&#x00EB;" => "06D0 FBE4 FBE5 FBE6 FBE7",
		"&#x00CB;" => "06D0 FBE4 FBE5 FBE6 FBE7",
		"&#x00E9;" => "06D0 FBE4 FBE5 FBE6 FBE7",
		"&#x00C9;" => "06D0 FBE4 FBE5 FBE6 FBE7",
		"l" => "0644 FEDD FEDE FEDF FEE0",
		"zh" => "0698 FB8A FB8B",
		"gh" => "063A FECD FECE FECF FED0",
		"o" => "0648 FEED FEEE",
		"x" => "062E FEA5 FEA6 FEA7 FEA8",
		"r" => "0631 FEAD FEAE",
		"n" => "0646 FEE5 FEE6 FEE7 FEE8",
		"i" => "0649 FEEF FEF0",
		"m" => "0645 FEE1 FEE2 FEE3 FEE4",
		"z" => "0632 FEAF FEB0",
		"f" => "0641 FED1 FED2 FED3 FED4",
		"&#x00F6;" => "06C6 FBD9 FBDA",
		"&#x00D6;" => "06C6 FBD9 FBDA",
		"&#x00FC;" => "06C8 FBDB FBDC",
		"&#x00DC;" => "06C8 FBDB FBDC",
		"q" => "0642 FED5 FED6 FED7 FED8",
		"b" => "0628 FE8F FE90 FE91 FE92",
		"p" => "067E FB56 FB57 FB58 FB59",
		"ch" => "0686 FB7A FB7B FB7C FB7D",
		"g" => "06AF FB92 FB93 FB94 FB95",
		"a" => "0627 FE8D FE8E",
		"sh" => "0634 FEB5 FEB6 FEB7 FEB8",
		"d" => "062F FEA9 FEAA",
		"ng" => "06AD FBD3 FBD4 FBD5 FBD6",
		"e" => "06D5",
		"k" => "0643 FED9 FEDA FEDB FEDC",
		"v" => "06CB FBDE FBDF",
		"w" => "06CB FBDE FBDF",
		"," => "060C",
		"\"" => "00AB 00BB 201C 201D",
              "$#x0030;" => "0030",
		"&#x003F;" => "061F");				#Question marks and zeros must be encoded, or else
                                                               # they mess up regex and other things later

if( $ENV{'CONTENT_LENGTH'} > 0 ){                              #If input has been entered
	$origin = param("origin");
	$str = param("str");
	chomp( $str );
	if( $origin eq "Arabic" ){
		$latstr = convert_ug_lat( $str );
		$ugstr = $str;
		$pinstr = convert_lat_pin( $latstr, "coded" );
		$cyrstr = convert_lat_cyr( $latstr, "coded" );
	}
	elsif( $origin eq "Latin" ){
		$ugstr = convert_lat_ug( $str );
		$latstr = $str;
		$pinstr = convert_lat_pin( $latstr, "uncoded" );
		$cyrstr = convert_lat_cyr( $latstr, "uncoded" );
	}
	elsif( $origin eq "Pinyin" ){ }
	elsif( $origin eq "Cyrillic" ){ }

}
else{ $str=""; }                                           #Else, $str is an empty string

print <<HTML1;
Content-Type: text/html; charset=UTF-8

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "DTD/xhtml1-transitional.dtd">
<html lang="en">
    <head>
        <meta http-equiv="Content-Type" content="text/html;charset=UTF-8" />
        <title>Convert Uyghur script</title>
        <link rel="stylesheet" type="text/css" href="../stevetools_stylesheet.css" />
    </head>

    <body>
       
        <h2>Uyghur script converter</h2>
        <p class="centercol"><a href="http://www.ethnologue.com/show_language.asp?code=uig">Uyghur</a> is
                                      a Turkic language spoken throughout Central Asia, particularly in the
                                      Xinjiang province of western People's Republic of China. Uyghur has 
                                      <a href="http://en.wikipedia.org/wiki/Uyghur_alphabets">several alphabets</a>,
                                      the most common of which are an Arabic-based alphabet and a Latin-based
                                      alphabet. This tool will convert between the two. Currently the tool can also convert
						<em>to</em> two other Uyghur alphabets (the Cyrillic Uyghur alphabet
                                      and the Pinyin-based Uyghur alphabet also called Uy&#x01A3;ur Yengi Yezi&#x2C6A;i) but cannot convert <em>from</em> them.</p>
         <p class="centercol"><u>Note on fonts</u>: Fonts that can display Uyghur Arabic script include <a
                                      href="http://www.microsoft.com/typography/fonts/family.aspx?FID=327">Microsoft
                                      Uighur</a> and <a href="http://cooltext.com/Download-Font-Arabic+Typesetting">
                                      Arabic Typesetting</a>. Many Uyghur fonts are available for download at the 
                                      <a href="http://www.ukij.org/fonts/">Uyghur Computer Science Society</a>, and
                                      other Unicode-compliant Arabic fonts are available at <a
                                      href="http://www.wazu.jp/gallery/Fonts_Uighur.html">Wazu</a>. Arabic script
                                      on this page  will display best if you have one of the Uyghur fonts installed;
                                      if not, your browser will select another Arabic font to use.</p>              

        <hr>
        <form method="post" action="http://www.mypolyuweb.hk/~sjpolit/cgi-bin/uyghurscript.pl">
           <div class="floatingbox">
               <h3>Special characters</h3>
               <b>Latin</b>
               <p align="center">&#x00CB; &#x00EB; &#x00C9; &#x00E9; &#x00D6; &#x00F6; &#x00DC; &#x00FC;</p>
               <b>Pinyin</b>
               <p align="center">&#x018F; &#x0259;  &#x2C6B; &#x2C6C; &#x01A2; &#x01A3; &#x2C69; &#x2C6A;
                                 &#x2C67; &#x2C68; &#x019F; &#x0275; &#x00DC; &#x00FC;</p>
           </div>
           <p class="center"><b><u>Type or paste a string of characters into the box and click submit.</u></b></p>
           <p class="centercol"><u>Please note:</u> the tool currently has trouble converting strings that include numbers or
					carriage returns (newlines).
                                      If you pasted in a large amount of text and got an error, this may be the reason.<br/>
					Some ambiguous Latin strings (e.g. 'ngh', which may be segmented either as 'ng h' or 'n gh')
					may also give incorrect results. For instance, "nangha",
					intended to yield &#x0646;&#x0627;&#x0646;&#x063A;&#x0627;&nbsp;, will instead yield 
					&#x0646;&#x0627;&#x06AD;&#x06BE;&#x0627;&nbsp;. For now, the best solution if you encounter this
					is to just put in a space or hyphen (e.g. "nan-gha") and then delete it from the Arabic output.
					In the long term I may try to resolve this issue in the code, but the solution seems to be nontrivial.</p>
           <p class="center"><textarea cols=80 name="str"></textarea></p>
           <p class="center">What script is your input in?
HTML1

if( $origin eq "Arabic" ){
print <<ARABICSELECTED;
                             <input type="radio" name="origin" value="Arabic" CHECKED>Arabic</input>
                             <input type="radio" name="origin" value="Latin">Latin</input>
				 <!--<input type="radio" name="origin" value="Pinyin">Pinyin-based Latin</input>-->
				 <!--<input type="radio" name="origin" value="Cyrillic">Cyrillic</input>-->
ARABICSELECTED

}
elsif( $origin eq "Latin" ){
print <<LATINSELECTED;
                             <input type="radio" name="origin" value="Arabic">Arabic</input>
                             <input type="radio" name="origin" value="Latin" CHECKED>Latin</input>
				 <!--<input type="radio" name="origin" value="Pinyin">Pinyin-based Latin</input>-->
				 <!--<input type="radio" name="origin" value="Cyrillic">Cyrillic</input>-->
LATINSELECTED

}
else{
print <<NONESELECTED;
                             <input type="radio" name="origin" value="Arabic">Arabic</input>
                             <input type="radio" name="origin" value="Latin" CHECKED>Latin</input>
				 <!--<input type="radio" name="origin" value="Pinyin">Pinyin-based Latin</input>-->
				 <!--<input type="radio" name="origin" value="Cyrillic">Cyrillic</input>-->
NONESELECTED

}
print <<CLOSEFORM;
                             <input type="submit" value="submit" /></p>
        </form>
CLOSEFORM

if( $ENV{'CONTENT_LENGTH'} > 0 ){     #If input has been entered
    print <<HTMLresults;
    <table align="center">
        <tr>
            <td class="left"><b>Latin Y&#x00E9;ziqi</b>:</td>
            <td class="right">$latstr</td>
        </tr>
        <tr>
            <td class="left"><b>Arabic</b>:</td>
            <td class="right"><div class="arabic">$ugstr</div></td>
        </tr>
        <tr>
            <td class="left"><b>Pinyin Y&#x00E9;ziqi</b>:</td>
            <td class="right">$pinstr</td>
        </tr>
        <tr>
            <td class="left"><b>Cyrillic</b>:</td>
            <td class="right">$cyrstr</td>
        </tr>
    </table>
HTMLresults

}

print <<HTMLfooter;
    <br style="clear:both"/>
        <hr>
        <p class="mini">Script by <a href="..">Stephen Politzer-Ahles</a>. If you experience
                                 an error, contact me at politzerahless <img src="../at.jpg" alt="(at)"
                                 height="10px" width="10px"> gmail <img src="../dot.jpg" alt="(dot)"
                                 height="10px" width="10px"> com.
        <p class="mini">A similar tool is available at <a href="http://web.archive.org/web/20081207052953/http://www.uyghurdictionary.org/tools.asp">The 
                        Uyghur-English Dictionary project</a>. It does not work in Mozilla Firefox.</br>(That site seems to have been removed and the link provided
			is an archival link from the Wayback Machine; the original location of the site was <a href="http://www.uyghurdictionary.org/tools.asp">
			www.uyghurdictionary.org/tools.asp</a>.)</p>
	<p class="mini">As of December 2012, a similar tool written by <a href="http://anwarmamat.blogspot.co.uk/2012/12/uyghur-latin-alphabet-to-uyghur.html">Anwar Mamat</a>
			is also available <a href="http://cis-linux1.temple.edu/~anwar/code/latin2uyghur.html">here</a>.
			It doesn't do Cyrillic, but otherwise it's similar to this tool, and probably better than this tool for handling larger blocks of text.</p>
        <dl class="mini">Version history:
            <dd><a href="../codearchive/uyghurscript_code_20091130.txt">2009-11-30</a>: Created</dd>
            <dd><a href="../codearchive/uyghurscript_code_20091201.txt">2009-12-01</a>: Added some Pinyin Y&#x00E9;ziqi
                and Cyrillic functionality, corrected several errors caused by punctuation and capitalization.</dd>
            <dd><a href="../codearchive/uyghurscript_code_20091208.txt">2009-12-08</a>: Added some missing letters.</dd>
            <dd><a href="../codearchive/uyghurscript_code_20091215.txt">2009-12-15</a>: Replaced ULY &#x00E9; with
                &#x00EB;; added Cyrillic bigrams &#x044E; and &#x044F;.</dd>
            <dd><a href="../codearchive/uyghurscript_code_20101001.txt">2010-10-01</a>: Made the radio button remember user's
                latest selection (to save some clicks).</dd>
            <dd><a href="../codearchive/uyghurscript_code_20120415.txt">2012-14-15</a>: Fixed Cyrillic &#x0422; and &#x0442;
		(thanks to Chuyang Zheng for pointing this out).</dd>
            <dd><a href="../codearchive/uyghurscript_code_20130805.txt">2013-08-05</a>: Migrated to NYU server; 2016-08-12 migrated to PolyU server.</dd>
        </dl>

    </body>
</html>
HTMLfooter

sub hex_to_dec{
		#Function documentation
		#Converts a single hex number (string format) to a decimal number

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
			$hex = $digit . $hex;
			$dec = int( $dec/16 );
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
		#Function documentation
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

sub convert_ug_lat{
	#What still needs to be done: List of proper nouns that must be capitalized

	$string = shift();
		
	$decodedstr = decode( "utf8", $string );           	#Decode characters from text into binary
	$newtr = "";
	while( $x = chop($decodedstr) ){				#Get one character off the end
		$x = dec_to_hex( ord( $x ) );

		$matched = 0;								
		foreach $item ( keys(%latincodes) ){			#Go through the list of codes
			if( $latincodes{ $item } =~ m/$x/ ){		#If the code matches
		 		$newstr = $item . $newstr;		#Add the letter
				$matched = 1;				#Flag to know that this was an Arabic letter
				last;
			}
		}

		if( $matched == 0){					#If no match (i.e., not Arabic script):
			$letter = encode("utf8", chr( hex_to_dec($x) ) );	
			$newstr = "$letter" . $newstr;		#Just concatenate the plain letter
		}

		$finalstr = $newstr;
		$finalstr =~ s/(^|\W)'/\1/;			#Remove hamza-apostrophe from word beginning
		$finalstr =~ s/(^|\.\s+)(\w)/\1\u\2/g;		#Capitalizing

		#Fix capitalization of various special characters
		$finalstr =~ s/(^|\.\s)&#x00E9;/\1&#x00C9;/g;
		$finalstr =~ s/(^|\.\s)&#x00EB;/\1&#x00CB;/g;
		$finalstr =~ s/(^|\.\s)&#x00F6;/\1&#x00D6;/g;
		$finalstr =~ s/(^|\.\s)&#x00FC;/\1&#x00DC;/g;

		$finalstr =~ s/(\S)&#x00C9/\1&#x00E9/g;
		$finalstr =~ s/(\S)&#x00CB/\1&#x00EB/g;
		$finalstr =~ s/(\S)&#x00D6/\1&#x00F6/g;
		$finalstr =~ s/(\S)&#x00DC/\1&#x00FC/g;

	}
	return $finalstr;

}

sub convert_lat_ug{
	#Tasks remaining: add list of words with word-medial hamza, like sun'i and din'i
	$string = shift();
	$newstr = "";
	while( $string ){							#Decode only the fancies. Keep regular letters as regular letters
		$string = decode("utf8", $string);
		 while( $x = chop($string) ){			 	#One at a time off the end of the string
			$x = dec_to_hex( ord( $x ) );			#To hex
			if( $x =~ m/(201C|201D)/ ){ $x = 0022; }		#Convert curly quote to straight quote
			$x = "&#x" . $x . ";";
			$matched = 0;
			foreach( keys(%latincodes) ){
				if( $x eq $_ ){ $matched = 1; last;}	#If it's one of the fancies: keep as code									 
			}
			
			if( $matched == 0 ){		 			#If it's not a fancy: change back to text
				$x =~ s/&#x(\S{4});/\1/; 
				$x = encode("utf8", chr( hex_to_dec( $x ) ) );
			}
			$decodedstr = $x . $decodedstr;
								
		}
	}
					 
	while( $decodedstr ){				 	 	#Actual conversion
		$lastdecodedstr = $decodedstr;				#Catch bigraphs and fancies in this regex
		$decodedstr =~ s/^(&#x00F6;|&#x00D6;|&#x00FC;|&#x00DC;|&#x00EB;|&#x00CB;|&#x00E9;|&#x00C9;|&#x003F;|&#x00AB;|&#x00BB|zh|gh|sh|ch|ng|\n|[hy'sutjloxrnimzfqbgadekvwp «».,;!?"\-\d\/])//i;
		if ($decodedstr eq $lastdecodedstr){ $newstr = "Aborting.\n"; last; }	#Error handler
					 
		$letter = $1;	 						#Harvest the letter
		$ugletter = $letter;
		foreach $code (keys(%latincodes)){
			if( $letter =~ m/\A$code\Z/i ){     		#If it corresponds to an Arabic letter, get the letter
				$ugletter = $latincodes{ $code };						
				$ugletter =~ s/(\S{4}).*/&#x\1;/; 		#Strip extra codes	 
			}	 						#Otherwise (i.e., if it's punc.), just keep it as is.
		}
					 
		$newstr = $newstr . $ugletter; 
		$newstr =~ s/(^|\s)(&#x06D0;|&#x06C6;|&#x06C8;|&#x06C7;|&#x0648;|&#x0649;|&#x0627;|&#x06D5;)/\1&#x0626;\2/g;	 #Add hamza
		$newstr =~s/(\S)&#x00AB;/\1&#x00BB/g;			#Fix guillemets
	}
		
	return $newstr;

}

sub convert_lat_pin{

	$string = shift();
	$newstr = "";

	if( $_[0] eq "uncoded" ){

		while( $string ){							#Decode only the fancies. Keep regular letters as regular letters
			$string = decode("utf8", $string);
			 while( $x = chop($string) ){			 	#One at a time off the end of the string
				$x = dec_to_hex( ord( $x ) );			#To hex
				if( $x =~ m/(201C|201D)/ ){ $x = 0022; }		#Convert curly quote to straight quote
				$x = "&#x" . $x . ";";
				foreach( keys(%latincodes) ){
					$matched = 0;
					if( $x eq $_ ){ $matched = 1; last;}	#If it's one of the fancies: keep as code									 
				}
			
				if( $matched == 0 ){		 			#If it's not a fancy: change back to text
					$x =~ s/&#x(\S{4});/\1/; 
					$x = encode("utf8", chr( hex_to_dec( $x ) ) );
				}
				$decodedstr = $x . $decodedstr;						
			}
		}
	}
	elsif( $_[0] eq "coded" ){
		$decodedstr = $string;
	}

	while( $decodedstr ){				 	 	#Actual conversion
		$lastdecodedstr = $decodedstr;				#Catch bigraphs and fancies in this regex
		$decodedstr =~ s/^(&#x00F6;|&#x00D6;|&#x00FC;|&#x00DC;|&#x00EB;|&#x00CB;|&#x00E9;|&#x00C9;|&#x003F;|&#x00AB;|&#x00BB|zh|gh|sh|ch|ng|\n|[hy'sutjloxrnimzfqbgadekvpw «».,;!?"-\d\/])//i;
		if ($decodedstr eq $lastdecodedstr){ $newstr = "<font color=\"red\">Unreadable input.</font> Aborting at $newstr."; last; }	#Error handler
					 
		$letter = $1;	 						#Harvest the letter

		if( $letter eq "e" ){ $pinletter = "&#x0259;"; }
		elsif( $letter eq "E" ){ $pinletter = "&#x018F;"; }
		elsif( $letter eq "ch" ){ $pinletter = "q"; }
		elsif( $letter eq "Ch" ){ $pinletter = "Q"; }
		elsif( $letter eq "x" ){ $pinletter = "h"; }
		elsif( $letter eq "X" ){ $pinletter = "H"; }
		elsif( $letter eq "zh" ){ $pinletter = "&#x2C6C;"; }
		elsif( $letter eq "Zh" ){ $pinletter = "&#x2C6B;"; }
		elsif( $letter eq "sh" ){ $pinletter = "x"; }
		elsif( $letter eq "Sh" ){ $pinletter = "X"; }
		elsif( $letter eq "gh" ){ $pinletter = "&#x01A3;"; }
		elsif( $letter eq "Gh" ){ $pinletter = "&#x01A2;"; }
		elsif( $letter eq "q" ){ $pinletter = "&#x2C6A;"; }
		elsif( $letter eq "Q" ){ $pinletter = "&#x2C69;"; }
		elsif( $letter eq "h" ){ $pinletter = "&#x2C68;"; }
		elsif( $letter eq "H" ){ $pinletter = "&#x2C67;"; }
		elsif( $letter eq "&#x00F6;" ){ $pinletter = "&#x0275;"; }
		elsif( $letter eq "&#x00D6;" ){ $pinletter = "&#x019F;"; }
		elsif( $letter eq "&#x00E9;" ){ $pinletter = "e"; }
		elsif( $letter eq "&#x00C9;" ){ $pinletter = "E"; }
		elsif( $letter eq "&#x00EB;" ){ $pinletter = "e"; }
		elsif( $letter eq "&#x00CB;" ){ $pinletter = "E"; }
		else{ $pinletter = $letter; }
		
		
					 
		$newstr = $newstr . $pinletter; 
	}
		
	return $newstr;

}

sub convert_lat_cyr{

	$string = shift();
	$newstr = "";

	if( $_[0] eq "uncoded" ){

		while( $string ){							#Decode only the fancies. Keep regular letters as regular letters
			$string = decode("utf8", $string);
			 while( $x = chop($string) ){			 	#One at a time off the end of the string
				$x = dec_to_hex( ord( $x ) );			#To hex
				if( $x =~ m/(201C|201D)/ ){ $x = 0022; }		#Convert curly quote to straight quote
				$x = "&#x" . $x . ";";
				foreach( keys(%latincodes) ){
					$matched = 0;
					if( $x eq $_ ){ $matched = 1; last;}	#If it's one of the fancies: keep as code									 
				}
			
				if( $matched == 0 ){		 			#If it's not a fancy: change back to text
					$x =~ s/&#x(\S{4});/\1/; 
					$x = encode("utf8", chr( hex_to_dec( $x ) ) );
				}
				$decodedstr = $x . $decodedstr;						
			}
		}
	}
	elsif( $_[0] eq "coded" ){
		$decodedstr = $string;
	}

	while( $decodedstr ){				 	 	#Actual conversion
		$lastdecodedstr = $decodedstr;				#Catch bigraphs and fancies in this regex
		$decodedstr =~ s/^(&#x00F6;|&#x00D6;|&#x00FC;|&#x00DC;|&#x00EB;|&#x00CB;|&#x00E9;|&#x00C9;|&#x003F;|&#x00AB;|&#x00BB|zh|gh|sh|ch|ng|yu|ya|\n|[hy'sutjloxrnimzfqbgadekvpw «».,;!?"-\d\/])//i;
		if ($decodedstr eq $lastdecodedstr){ $newstr = "<font color=\"red\">Unreadable input.</font> Aborting at $newstr."; last; }	#Error handler
		$letter = $1;	 						#Harvest the letter

		if( $letter eq "e" ){ $cyrletter = "&#x0259;"; }
		elsif( $letter eq "E" ){ $cyrletter = "&#x018F;"; }
		elsif( $letter eq "a" ){ $cyrletter = "&#x0430;"; }
		elsif( $letter eq "A" ){ $cyrletter = "&#x0410;"; }
		elsif( $letter eq "b" ){ $cyrletter = "&#x0431;"; }
		elsif( $letter eq "B" ){ $cyrletter = "&#x0411;"; }
		elsif( $letter eq "p" ){ $cyrletter = "&#x043F;"; }
		elsif( $letter eq "P" ){ $cyrletter = "&#x041F;"; }
		elsif( $letter eq "x" ){ $cyrletter = "&#x0445;"; }
		elsif( $letter eq "X" ){ $cyrletter = "&#x0425;"; }
		elsif( $letter eq "j" ){ $cyrletter = "&#x0497;"; }
		elsif( $letter eq "J" ){ $cyrletter = "&#x0496;"; }
		elsif( $letter eq "ch" ){ $cyrletter = "&#x0447;"; }
		elsif( $letter eq "Ch" ){ $cyrletter = "&#x0427;"; }
		elsif( $letter eq "d" ){ $cyrletter = "&#x0434;"; }
		elsif( $letter eq "D" ){ $cyrletter = "&#x0414;"; }
		elsif( $letter eq "r" ){ $cyrletter = "&#x0440;"; }
		elsif( $letter eq "R" ){ $cyrletter = "&#x0420;"; }
		elsif( $letter eq "z" ){ $cyrletter = "&#x0437;"; }
		elsif( $letter eq "Z" ){ $cyrletter = "&#x0417;"; }
		elsif( $letter eq "zh" ){ $cyrletter = "&#x0436;"; }
		elsif( $letter eq "Zh" ){ $cyrletter = "&#x0416;"; }
		elsif( $letter eq "s" ){ $cyrletter = "&#x0441;"; }
		elsif( $letter eq "S" ){ $cyrletter = "&#x0421;"; }
		elsif( $letter eq "sh" ){ $cyrletter = "&#x0448;"; }
		elsif( $letter eq "Sh" ){ $cyrletter = "&#x0428;"; }
		elsif( $letter eq "gh" ){ $cyrletter = "&#x0493;"; }
		elsif( $letter eq "Gh" ){ $cyrletter = "&#x0492;"; }
		elsif( $letter eq "f" ){ $cyrletter = "&#x0444;"; }
		elsif( $letter eq "F" ){ $cyrletter = "&#x0424;"; }
		elsif( $letter eq "q" ){ $cyrletter = "&#x049B;"; }
		elsif( $letter eq "Q" ){ $cyrletter = "&#x049A;"; }
		elsif( $letter eq "k" ){ $cyrletter = "&#x043A;"; }
		elsif( $letter eq "K" ){ $cyrletter = "&#x041A;"; }
		elsif( $letter eq "g" ){ $cyrletter = "&#x0433;"; }
		elsif( $letter eq "G" ){ $cyrletter = "&#x0413;"; }
		elsif( $letter eq "ng" ){ $cyrletter = "&#x04A3;"; }
		elsif( $letter eq "Ng" ){ $cyrletter = "&#x04A2;"; }
		elsif( $letter eq "l" ){ $cyrletter = "&#x043B;"; }
		elsif( $letter eq "L" ){ $cyrletter = "&#x041B;"; }
		elsif( $letter eq "m" ){ $cyrletter = "&#x043C;"; }
		elsif( $letter eq "M" ){ $cyrletter = "&#x041C;"; }
		elsif( $letter eq "n" ){ $cyrletter = "&#x043D;"; }
		elsif( $letter eq "N" ){ $cyrletter = "&#x041D;"; }
		elsif( $letter eq "h" ){ $cyrletter = "&#x04BB;"; }
		elsif( $letter eq "H" ){ $cyrletter = "&#x04BA;"; }
		elsif( $letter eq "o" ){ $cyrletter = "&#x043E;"; }
		elsif( $letter eq "O" ){ $cyrletter = "&#x041E;"; }
		elsif( $letter eq "u" ){ $cyrletter = "&#x0443;"; }
		elsif( $letter eq "U" ){ $cyrletter = "&#x0423;"; }
		elsif( $letter eq "t" ){ $cyrletter = "&#x0442;"; }
		elsif( $letter eq "T" ){ $cyrletter = "&#x0422;"; }
		elsif( $letter eq "&#x00F6;" ){ $cyrletter = "&#x04E8;"; }
		elsif( $letter eq "&#x00D6;" ){ $cyrletter = "&#x04E9;"; }
		elsif( $letter eq "&#x00FC;" ){ $cyrletter = "&#x04AF;"; }
		elsif( $letter eq "&#x00DC;" ){ $cyrletter = "&#x04AE;"; }
		elsif( $letter eq "v" || $letter eq "w" ){ $cyrletter = "&#x0432;"; }
		elsif( $letter eq "V" || $letter eq "W" ){ $cyrletter = "&#x0412;"; }
		elsif( $letter eq "&#x00E9;" ){ $cyrletter = "&#x0435;"; }
		elsif( $letter eq "&#x00C9;" ){ $cyrletter = "&#x0415;"; }
		elsif( $letter eq "&#x00EB;" ){ $cyrletter = "&#x0435;"; }
		elsif( $letter eq "&#x00CB;" ){ $cyrletter = "&#x0415;"; }
		elsif( $letter eq "i" ){ $cyrletter = "&#x0438;"; }
		elsif( $letter eq "I" ){ $cyrletter = "&#x0418;"; }
		elsif( $letter eq "y" ){ $cyrletter = "&#x0439;"; }
		elsif( $letter eq "Y" ){ $cyrletter = "&#x0419;"; }
		elsif( $letter eq "yu" ){ $cyrletter = "&#x044E;"; }
		elsif( $letter eq "Yu" ){ $cyrletter = "&#x042E;"; }
		elsif( $letter eq "ya" ){ $cyrletter = "&#x044F;"; }
		elsif( $letter eq "Ya" ){ $cyrletter = "&#x042F;"; }
		else{ $cyrletter = $letter; }
			 
		$newstr = $newstr . $cyrletter; 
	}
	return $newstr;
}
exit;