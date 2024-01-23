#!/usr/local/bin/perl
#ex79.pl

# Read the data from standard input.
read (STDIN, $QueryString, $ENV{'CONTENT_LENGTH'});

# Use split to make an array of name-value pairs broken at
# the ampersand character. Then get the values.
@NameValuePairs = split (/&/, $QueryString);

foreach $NameValue (@NameValuePairs) {
    ($Name, $Value) = split (/=/, $NameValue);
    $Value =~ tr/+/ /;
    if ( $Name eq "CD" ) {
       $cd = $Value;
    } elsif ( $Name eq "book" ) {
       $book = $Value;
    } elsif ($Name eq "airplane" ) {
		   $airplane = $Value;
		} # end if
} # end foreach

print "Content-type: text/html\n\n";

use constant CDPRICE => 12;
use constant BOOKPRICE => 19.99;
use constant AIRPLANEPRICE => 1000000;

$total = CDPRICE * $cd + BOOKPRICE * $book + AIRPLANEPRICE * $airplane;

print <<HTML;
<html>

  <title> Your totals </title>

  <body>
    <center><h2>Thanks for shopping with us!</h2></center>
    <dl>You purchased:
	    <dd>$cd CDs</dd>
      <dd>$book books</dd>
      <dd>$airplane airplanes</dd>
		<dl>
		<p>Your total comes to <b>\$$total</b></p>
		
    <hr>
    <p align="center">Please do not refresh this page.<br/>
                      Click <a href="http://people.ku.edu/~sjpa/ex79.html">here</a>
											to continue shopping.</p>
                                                                         
  </body>
</html>

HTML

exit;