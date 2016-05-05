#! /usr/bin/perl -w

use strict;
use YAML;

my $data_file = shift;

open FH,$data_file;
while(<FH>){
	/^\S+\t(\S+)\t(\S+).*$/;
	print "$1\t$2\n";
}












#vi:ts:sw=4
