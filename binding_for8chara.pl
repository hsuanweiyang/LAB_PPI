#! /usr/bin/perl -w

use strict;
use YAML;

my $feature_file = shift;
my $label_file = shift;

my @label;
my $line_count = 0;
open F1,$label_file;
while(my $line = <F1>){
	chomp $line;
	push @label,$line;

}
close F1;

open F2,$feature_file;
while(<F2>){
	/^#/ and next;
	/\S+\t\S+\t(.*)$/;
	my @feature;
	push @feature, split(/\t/,$1);
	print $label[$line_count];
	for (0 .. $#feature){
		print "\t".($_+1).":$feature[$_]";
	}
	print "\n";
	$line_count++;
}
close F2;

#vi:sw=4:ts=4
