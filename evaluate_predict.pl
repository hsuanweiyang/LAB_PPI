#! /usr/bin/perl -w 

use YAML;
use strict;


for (1..343){
	#my @prc = `./for_graphRank.pl label_test default_result/predict_$_\_dim`;
	#my $acc = `./acc.pl label_test default_result/predict_$_\_dim`;
	#chomp @prc;
	#chomp $acc;
	#print "Dim=$_\t100 : $prc[0]\t200 : $prc[1]\t2000 : $prc[19]\n";
	#print $acc;
	print $_."\n";
}
