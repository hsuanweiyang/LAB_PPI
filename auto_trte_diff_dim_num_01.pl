#!/usr/bin/perl -w

use strict;
use YAML;
use Getopt::Std;

my (%opts,$key); &getopt('bdnafzskl',\%opts);
my @pick_feature;
my $start_num;

defined $opts{b} and @pick_feature = ("bend") and $start_num = $opts{b};
defined $opts{d} and @pick_feature = ("distance") and $start_num = $opts{d};
defined $opts{n} and @pick_feature = ("nu_occupancy") and $start_num = $opts{n};
defined $opts{z} and @pick_feature = ("size") and $start_num = $opts{z};
defined $opts{a} and @pick_feature = ("tata") and $start_num = $opts{a};
defined $opts{f} and @pick_feature = ("tfb") and $start_num = $opts{f};
defined $opts{s} and @pick_feature = ("tfbs") and $start_num = $opts{s};
defined $opts{k} and @pick_feature = ("tfko") and $start_num = $opts{k};
defined $opts{l} and @pick_feature = ("bend","distance","nu_occupancy","tata","tfb","size","tfbs","tfko");

foreach my $feature(@pick_feature){
	my $num;
	print "***************Start***************\n";
	print "Feature :  ".$feature."\n";
	for($start_num .. 10){
		$num = 10*$_;
		print "Dimension : ".$num."\n";
		print "----scale----\n";
		`svm-scale -s train-scale-info result/combine_data/combine_e132_$feature-$num\_train > scale-train-data`;
		`svm-scale -r train-scale-info result/combine_data/combine_e132_$feature-$num\_test > scale-test-data`;
		print "---complete--\n";
		print "----grid-----\n";
		`svm-grid -log2c -1,1,0.5 -log2g -10.5,-8.5,0.5 scale-train-data`;
		print "---complete--\n";
		`sort -n -r -k 3 scale-train-data.out > sort_grid`;
		my $grid_str = `cat sort_grid | head -n 1`;
		my @para_arr = split(/\s/,$grid_str);
		#my @c_arr = split(/=/,$para_arr[0]);
		#my @g_arr = split(/=/,$para_arr[1]);
		#my $c_para = 2**$c_arr[1];
		#my $g_para = 2**$g_arr[1];
		my $c_para = 2**$para_arr[0];
		my $g_para = 2**$para_arr[1];
		print "c parameter = ".$c_para."\n";
		print "g parameter = ".$g_para."\n";
		print "----train-----\n";
		`svm-train -b 1 -h 0 -c $c_para -g $g_para scale-train-data train-model`;
		#`svm-train -b 1 -h 0 scale-train-data train-model`;
		print "----predict----\n";
		`svm-predict -b 1 scale-test-data train-model result/predict_report-new/predict_$feature-$num`;
#		 `./for_graphRank.pl label_test result/predict_$feature-$num > result/report/report_$feature-$num`;
		print "**************End**************\n\n";
			}
}








#vi:ts=4
