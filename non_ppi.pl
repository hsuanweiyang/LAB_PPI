#! /usr/bin/perl -w
use strict;
use YAML;

my $ppi_file = shift;
my $all_file = shift;
my %ppi_pair;
my %nonppi_pair;

for (`cat $ppi_file`){
	/^(\S+)\t(\S+)/;
	$ppi_pair{$1}{$2} = 1;
}

for (`cat $all_file`){
	/^\S+\t(\S+)\t(\S+)/;
	defined $ppi_pair{$1}{$2} and next;
	defined $ppi_pair{$2}{$1} and next;
	print "$1\t$2\n";

}
