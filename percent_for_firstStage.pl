#!/usr/bin/perl -w

use strict;
use YAML;

my $label = shift;
my @fea_label;
my $correct;
my $amount;
open F1,$label;
while(my $line = <F1>){
	chomp $line;
	push @fea_label, $line;
}
close F1;

for(1..20){
	$amount = $_*100;
	$correct = 0;
	for(0..($amount-1)){
		if($fea_label[$_]==1){$correct++;}
	}
	print 100*($correct/$amount)."\n";
}
#vi:ts=4:sw=4
