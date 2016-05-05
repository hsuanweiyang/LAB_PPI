#! /usr/bin/perl -w 

use YAML;
use strict;


my $pair_file = shift;
my $dim_file = shift;
my %protein_data;
my @protein_pair_name;
my $pair_count = 0;
my @shq_num_dim;
my @pro_fre;
my $protein_num = 0;
my $total_seq = 0;
my @sf_ipf_score;
my $sf;
my $ipf;
open F1, $pair_file;
while(<F1>){
	chomp $_;
	push @protein_pair_name, $_;
}

print "Data Preprocess\n";
while(`cat $dim_file` =~ /[01]\t1:(.*)\t344:(.*)\n/g){
	my @protein_name = split(/\t/, $protein_pair_name[$pair_count]);
	my @dim_data_a = split(/\t\d+:/, $1);
 	my @dim_data_b = split(/\t\d+:/, $2);
	$protein_data{$protein_name[0]}{data} = [@dim_data_a];
	$protein_data{$protein_name[1]}{data} = [@dim_data_b];
	$pair_count++;
}
print "Data Accumulate\n";
for my $pro(keys %protein_data){
	for(0.. 342){
		$shq_num_dim[$_] += $protein_data{$pro}{data}[$_];
		$total_seq += $protein_data{$pro}{data}[$_];
		if ($protein_data{$pro}{data}[$_] != 0){
			$pro_fre[$_] += 1;
		}
	}
	$protein_num++;
}
print "Calculate sf-ipf\n";
for(0.. 342){
	$sf = $shq_num_dim[$_]/$total_seq;
	if (!defined $pro_fre[$_]){
		$ipf = 0
	}else{
		$ipf = log($protein_num/$pro_fre[$_])/log(10);
	}
	$sf_ipf_score[$_] = $sf*$ipf;
	print int($_+1)."\t$sf_ipf_score[$_]\n";
}


