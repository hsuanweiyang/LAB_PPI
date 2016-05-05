#! /usr/bin/perl -w

use strict;
use YAML;

my $file = shift;
my $compareFile = shift;
my $sum=0;
my %base;

open FH, $file;
while(<FH>){
	/^(\S+)\t(\S+).*/;
	$base{$1}{$2} = 0;

}

open FA, $compareFile;
while(<FA>){
	/^(\S+)\t(\S+).*/;
	if(defined $base{$1}{$2}){
		$sum += 1;	
	}


}
print "sum : ".$sum."\n";

# vi:ts=4:sw=4
