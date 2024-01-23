#!/usr/bin/perl
#web form to get homophony data. uses homophone_output.txt for data

use Encode;								#Modules
use CGI qw( :standard );


if( $ENV{'CONTENT_LENGTH'} > 0 ){ 					#If input has been entered:
	# do nothing	
}

print <<HTML1;
Content-Type: text/html; charset=UTF-8

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "DTD/xhtml1-transitional.dtd">
<html lang="en">
    <head>
        <meta http-equiv="Content-Type" content="text/html;charset=UTF-8" />
        <title>Han character homophone counter</title>
        <link rel="stylesheet" type="text/css" href="stevetools_stylesheet.css" />
    </head>

    <body>
       
        <h2>test</h2>
HTML1

end;