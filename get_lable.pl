#! /usr/bin/perl -w
use strict;
use YAML;

my $inputFile = shift;
my %data;

open F1,$inputFile;
while(<F1>){
	/^(\S+)\t(\S+)/;
	$data{$1}{$2} = 1;
}
close F1;

#my $a = 0;
#my $b = 0;
open FH,"proteinPair_sce.e132";
while(<FH>){
	/^(\S+)\s(\S+)/;
	if(defined $data{$1}{$2} || defined $data{$2}{$1}){
#		$a++;
		print "1\n";	
	}
	else{
#		$b++;
		print "0\n";
	}

}
close FH;
#print $a."\n";

#print $b."\n";


#vi:ts=4:sw=4
