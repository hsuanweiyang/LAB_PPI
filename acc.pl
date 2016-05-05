#!/usr/bin/perl -w

use strict;
use YAML;

my $label_file = shift;
my $predict_file = shift;
my @lable_ans;
my $label_linecount = 0;
my $acc_count = 0;
open F1,$label_file;
while(<F1>){
	chomp $_;
	push @lable_ans, $_;
}
close F1;

open F2,$predict_file;
while(<F2>){
	/label.*/ and next;
	/^(\S+)\s\S+\s\S+$/;
	if ($lable_ans[$label_linecount] == $1){
		$acc_count++;
	}	
	#print "$lable_ans[$label_linecount]\t$1\n";
	$label_linecount++;
}
print $acc_count/10000;
print "\n";
close F2;


#vi:ts=4:sw=4
