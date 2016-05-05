#! /usr/bin/perl -w
use strict;
use YAML;

my $ppi_pair_file = shift;
my $all_gene = shift;

my %protein;
for (`cat $ppi_pair_file`){
	/^(\S+)\t(\S+)/;
	$protein{$1}++;
	$protein{$2}++;
}

for my $pro(keys %protein){
	print "$pro\t$protein{$pro}\n";
}

for (`cat $all_gene`){
	/^(\S+)/;
	defined $protein{$1} and next;
	print "$1\t0\n";
}

