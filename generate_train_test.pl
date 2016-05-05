#! /usr/bin/perl -w

use strict;
use YAML;

my $raw_data = shift;
my $triger = 1;

open (F1,'>',$raw_data."_train");
open (F2,'>',$raw_data."_test");

open FH,$raw_data;
while(my $line = <FH>){
	if ($triger == 1){
		print F2 $line;
		$triger = 2;
	}
	elsif($triger == 2){
		print F1 $line;
		$triger = 1;
	}
}
close F1;
close F2;
close FH;

#vi:ts:sw=4

