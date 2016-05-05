#!/usr/bin/perl -w

use strict;
use YAML;

my $file_featureEncoding = shift;
my $file_chara = shift;
my @f_chara;
my $file_max;
my $count = 0;
open F1,$file_chara;
while(<F1>){
	chomp $_;
	push @f_chara,$_;
}
close F1;

open F2,$file_featureEncoding;
while(<F2>){
	chomp $_;
	$_ =~ /.*\t(\d+):\d+$/;
	$file_max = $1;
	print $_;
	
	my @tmp;
	push @tmp,split(/\t/,$f_chara[$count]);
	for(1..$#tmp){
		
		if($tmp[$_] =~ /\d+:(.*?)$/){
			$file_max++;
			print "\t$file_max:$1";
		}
	}
	print "\n";
	$count++;
}
close F2;

