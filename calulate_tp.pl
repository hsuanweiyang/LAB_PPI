#!/usr/bin/perl -w

use strict;
use YAML;

my $ans_pre_file = shift;

open FH,$ans_pre_file;
while(<FH>){
	/^(\d)\t(\d)(.*)$/;
	if($1 == $2 && $1 == 1){
		print "1\t";
	}
	else{
		print "0\t";
	}
	print $3."\n";
}

close FH;





#vi:ts=4:sw=4
