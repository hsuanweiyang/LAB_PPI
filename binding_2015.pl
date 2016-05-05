#!/usr/bin/perl -w

################################################################################
#
# Copyright 2009 Cheng-Hao Hsueh.  This code cannot be
# redistributed without permission from <zzhowzz@gmail.com>.
#
################################################################################

# depedent modules
use strict;
use Data::Dumper;
use Getopt::Std;
use YAML;
# show usage
sub usage {
	print <<EOF;
Usage: feature_binding.pl svm1 svm2 svm3 ...
This script is used to combine feature sets in one set.
Options:
  -h  print this help, then exit
Examples:
  feature_binding.pl svm1 svm2 svm3 ...

Report bugs to <zzhowzz\@gmail.com>.
EOF
	exit;
}

################################################################################
# analyze command-line parameters and show usage if needed

# command-line parameters
my %opt = (); &getopts( "h", \%opt );

# special modes
defined $opt{h} and &usage;

# default values of parameters

# necessary parameters
@ARGV < 1 and die "please specify at least 1 argument (-h for help)\n";

################################################################################
# main
#$| = 1, select $_ for select STDERR;

my $t1;
my $t2;
my $file1_max;
my $line_count = 0;
my @label;
my $binding_file = shift;
my $label_file = shift;

open FH,$label_file;
while(my $line = <FH>){
	chomp $line;
	push @label, $line;
}
close FH;


open FILE1,$binding_file;
while(my $line = <FILE1>)
{
	chomp $line;
	if($line_count%2 == 0){
		$t1 = $line;
	}
	else{
		$t2 = $line;
		$t1 =~ /.*\t(\d+):\d+/;
		$file1_max = $1;
		print "$label[($line_count-1)/2]$t1";

		my @tmp;
		push @tmp, split(/\s|\t/,$t2);
		for(0..$#tmp){
		
			
			if($tmp[$_] =~ /\d+:(.*?)$/){
				$file1_max++;
				print"\t$file1_max:$1";
			}
		}
		print "\n";
	}
	$line_count++;
}



# vi:sw=4:ts=4

