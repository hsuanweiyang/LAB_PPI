#! /usr/bin/perl -w 

use strict;
use YAML;

my $ppi_pairFile = shift;
my $feature_file = shift;
my %feature_pair;


for(`cat $feature_file`){
	/^(\S+)\t(\S+)\t(\S+)/;
	$feature_pair{$1}{$2} = $3;
}

for (`cat $ppi_pairFile`){
	/^(\S+)\t(\S+)/;
	defined $feature_pair{$1}{$2} and print "$1\t$2\t$feature_pair{$1}{$2}\n";
}
