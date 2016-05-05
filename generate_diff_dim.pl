#!/usr/bin/perl -w

use strict;
use YAML;

my $raw_file_dir = shift;
my @file;

`ls $raw_file_dir > list`;

open FH, "list";
while(<FH>){
	push @file, split(/\t|\s/,$_);
}
close FH;
foreach my $current_file(@file){
	print "$current_file  ----- start -----\n";
	`./binding_for8chara.pl $raw_file_dir/$current_file ../label > result/raw_data/bind_$current_file`;
	`./combine_f_chara.pl ../bind_sce_e132_f result/raw_data/bind_$current_file > result/combine_data/combine_e132_$current_file`;
	`../generate_train_test.pl result/combine_data/combine_e132_$current_file`;
	print "$current_file ----- finsh -----\n";
}

#vi:ts=4:sw=4:
