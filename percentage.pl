#!/usr/bin/perl -w

use strict;
use YAML;

my $file = shift;
my $true = 0;
my $false = 0;
my $count = 0;

open FH,$file;
while(<FH>){
	$count++;
	/^(\S+)\t.*$/;
	if($1 == 1){
		$true++;
	}
	elsif($1 == 0){
		$false++;
	}
	
	if($count <= 10000 && $count%100 == 0 ){
		print "$count\t ".100*($true/$count)."\n";
	}
}
close FH;




#print "$true\n$false\nPercentage:\t".($true/($false+$true))."\n";

#vi:ts=4:sw=4
