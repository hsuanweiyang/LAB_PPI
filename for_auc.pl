#!/usr/bin/perl -w

use strict;
use YAML;

my $label_file = shift;
my $predict_file = shift;
my @lable_ans;
my @predict;
my $label_linecount = 0;

open F1,$label_file;
while(<F1>){
	chomp $_;
	push @lable_ans, $_;
}
close F1;

open F2,$predict_file;
while(<F2>){
	/label.*/ and next;
	#/^(\S+)\s(\S+)\s(\S+)$/;
	@predict = split(/\s+/,$_);
	print "$lable_ans[$label_linecount]\t$predict[2]\n";
	$label_linecount++;
}
close F2;


#vi:ts=4:sw=4
