#! /usr/bin/perl -w 

use strict;
use YAML;

my $dataFile = `cat ../../DB_source/SGD/orf_trans_all.fasta`;
my $gene;
my %protein;
my $size;

while($dataFile =~ m/>(.*?)\s.*?\n(.*?)\*/gs){
	$size = 3*(length($2));	
	print "$1\t$size\n";
	
	}
