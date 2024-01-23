#!c:\perl\bin\perl.exe

sub startDocument{
		#Precondition: Parameter is the title of the webpage
		
		print <<HTML;
Content-type: text/html

<html>
			<head>
						<title>$_[0]</title>
			</head>
			
			<body>
HTML

}

sub createParagraph{
		#Precondition: Parameter is the STRING to be used as a paragraph
		
		print "<p>$_[0]</p>";
}

sub createHyperlink{
		#Precondition: First parameter is the address of the link. Second is the
		#  text to be displayed. Third, if set to "blank", makes the link open
		#  in a new window
		
		print "<a href=\"$_[0]\"";
		if( $_[2] =~ m/blank/i ){ print "target=\"_blank\""; }
		print ">$_[1]</a>";
}

sub endDocument{
		print <<HTML;
		</body>
</html>

HTML

}