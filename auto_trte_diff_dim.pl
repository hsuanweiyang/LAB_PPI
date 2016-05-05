#!/usr/bin/perl -w

use strict;
use YAML;
use Getopt::Std;

my (%opts,$key); &getopt('bdnafzskl',\%opts);
my @pick_feature;

defined $opts{b} and @pick_feature = ("bend");
defined $opts{d} and @pick_feature = ("distance");
defined $opts{n} and @pick_feature = ("nu_occupancy");
defined $opts{z} and @pick_feature = ("size");
defined $opts{a} and @pick_feature = ("tata");
defined $opts{f} and @pick_feature = ("tfb");
defined $opts{s} and @pick_feature = ("tfbs");
defined $opts{k} and @pick_feature = ("tfko");
defined $opts{l} and @pick_feature = ("bend","distance","nu_occupancy","tata","tfb","size","tfbs","tfko");

foreach my $feature(@pick_feature){
	#my $num;
	#for(1 .. 10){
#		$num = 10*$_;
		print "***************Start***************\n";
		print "Feature :  ".$feature."\n";
		print "----scale----\n";
		`svm-scale -s train-scale-info result/combine_data/combine_e132_$feature\_train > scale-train-data`;
		`svm-scale -r train-scale-info result/combine_data/combine_e132_$feature\_test > scale-test-data`;
		print "---complete--\n";
		print "----grid-----\n";
		`python ../libsvm-3.21_fmeasure/tools/grid.py -log2c -2,2,1 -log2g -2,2,1 scale-train-data`;
		print "---complete--\n";
		`sort -n -r -k 3 scale-train-data.out > sort_grid`;
		my $grid_str = `cat sort_grid | head -n 1`;
		my @para_arr = split(/\s/,$grid_str);
		my @c_arr = split(/=/,$para_arr[0]);
		my @g_arr = split(/=/,$para_arr[1]);
		my $c_para = 2**$c_arr[1];
		my $g_para = 2**$g_arr[1];
		print "c parameter = ".$c_para."\n";
		print "g parameter = ".$g_para."\n";
		print "----train-----\n";
		`svm-train -b 1 -h 0 -c $c_para -g $g_para scale-train-data train-model`;
		#`svm-train -b 1 -h 0 scale-train-data train-model`;
		print "----predict----\n";
		`svm-predict -b 1 scale-test-data train-model result/predict_report-f/predict_$feature`;
#		 `./for_graphRank.pl label_test result/predict_$feature-$num > result/report/report_$feature-$num`;
		print "**************End**************\n\n";

		#	}
}








#vi:ts=4
