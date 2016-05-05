#!/usr/bin/perl -w


use strict;
use YAML;

my $base_dataFile = shift;
my $compare_dataFile = shift;
my %protein_pair;
my $total = 0;

open F1,$base_dataFile;
while(<F1>){
	/^(\S+)\s(\S+)$/;
	$protein_pair{$1} = 1;
	$protein_pair{$2} = 1;
}
close F1;
open F2,$compare_dataFile;
while(<F2>){
	/^(\S+)\t.*$/;
	if(defined $protein_pair{$1}){
		$total++;
	}
	else{
		next;
		#print "$1\t$2\n";
	}
}
close F2;
print $total;
#vi:ts:sw=4
