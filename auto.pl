#!/usr/bin/perl -w 

use strict;
use YAML;
use Switch;
my @feature_array = ("b","d","n","a","f","z","s","k");
my $current_feature = "0";
foreach my $feature (@feature_array){
	switch($feature){
		case "b"	{$current_feature = "bend"}
		case "d"	{$current_feature = "distance"}
		case "n"	{$current_feature = "nu_occupancy"}
		case "a"	{$current_feature = "tata"}
		case "f"	{$current_feature = "tfb"}
		case "z"	{$current_feature = "size"}
		case "s"	{$current_feature = "tfbs"}
		case "k"	{$current_feature = "tfko"}
	}
	for(1..10){
		my $num = 10*$_;
		`./new_combine.pl proteinPair_sce.e132 -$feature $num > result/$current_feature-$num`;
	}	
#		`./new_combine.pl proteinPair_sce.e132 -$feature 1 > result_one/$current_feature-1`;
}
