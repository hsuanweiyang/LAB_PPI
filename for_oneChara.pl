#! /usr/bin/perl -w
use strict;
use YAML;

my $inputFile = shift;
my %data;

open F1,$inputFile;
while(<F1>){
	/^(\S+)\t(\S+)/;
	$data{$1}=$2;
}
close F1;

open FH,"proteinPair_sce.e132";
while(<FH>){
	/^(\S+)\s(\S+)/;
	if(!defined $data{$1}){
		print $1."\n";
	}
	if(!defined $data{$2}) {
		print "$2\n";
	}

}

#vi:ts=4:sw=4
