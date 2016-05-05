#! /usr/bin/perl -w


use strict;
use YAML;

my $label_file = shift;
my $predict_file = shift;
my $num;
my @tp_nontp;
my $tp_amount;
`./combine_ans_pre.pl $label_file $predict_file > tmp_combine_ans_pre`;
#`./calulate_tp.pl tmp_combine_ans_pre > tmp_tp_result`;
`sort -g -r -k 2 tmp_combine_ans_pre > tmp_sort_result`;

open FH,"tmp_sort_result";
while(<FH>){
	/^(\d+)\t.*$/;
	push @tp_nontp,$1;
}
close FH;

for(1..20){
	$tp_amount = 0;
	$num = 100*$_;
	for(0..$num-1){
		if($tp_nontp[$_] == 1){
			$tp_amount++;
		}
	}
	print 1*($tp_amount/$num)."\n";
}


#vi:ts=4:sw=4
