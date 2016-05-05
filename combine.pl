#! /usr/bin/perl -w
use strict;
use YAML;

my %bendability;
my %gene_distence;
my %nu_occupancy;
my %nu_occupancy_g;
my %tata;
my %tfb;
my %gene_size;
my %tfko;
open F1,"DNA_bendability";
while (<F1>){
	/^(\S+)\t(\S+)$/;
	$bendability{$1} = $2;
}
close F1;

open F2,"gene_distence";
while (<F2>){
	    /^(\S+)\t(\S+)\t(\S+)$/;
	    $gene_distence{$1}{$2} = $3;
}
close F2;

open F3,"nu_occupancy_pair";
while (<F3>){
	    /^(\S+)\t(\S+)\t(\S+)$/;
	    $nu_occupancy{$1}{$2} = $3;
}
close F3;

open F4,"nu_occupancy_gene";
while (<F4>){
	/^(\S+)\t(\S+)$/;
	$nu_occupancy_g{$1} = $2;
}
close F4;

open F5,"tata";
while (<F5>){
	/^(\S+)\t(\S+)$/;
	$tata{$1} = $2;
}
close F5;

open F6,"tfb";
while(<F6>){
	/^(\S+)\t(\S+)\t\S+\t\S+\t(\S+)$/;
	$tfb{$1}{$2} = $3;
}

open F7,"gene_size";
while(<F7>){
	/^(\S+)\t(\S+)$/;
	$gene_size{$1} = $2;

}

open F8,"tfko";
while(<F8>){
	/^(\S+)\t(\S+)\t\S+\t\S+\t(\S+)$/;
	$tfko{$1}{$2} = $3;
}



print "#gene_a\tgene_b\tbendability_of_gene_a\tbendability_of_gene_b\tgene_distence\tgene_a_tatabox\tgene_b_tatabox\tnu_occupancy_pairs\tnu_occupancy_gene_a\tnu_occupancy_gene_b\ttfbs_distribution\ttfb\tgene_size_a\tgene_size_b\ttfko\n";
open FH,"tfbs_distribution";
while (<FH>){
	/^(\S+)\t(\S+)\t(\S+)$/;
	!defined $bendability{$1} and next;#die "ERROR: $1's bendability score does not exist!\n";
	!defined $bendability{$2} and next;#die "ERROR: $2's bendability score does not exist!\n";
	!defined $gene_distence{$1}{$2} and $gene_distence{$1}{$2} = "-1"; # If two genes of this pair aren't on the same chromsome, set it as -1;
	!defined $nu_occupancy{$1}{$2}  and $nu_occupancy{$1}{$2}  = "-1"; # 
	!defined $nu_occupancy_g{$1} and $nu_occupancy_g{$1} = "-1";
	!defined $nu_occupancy_g{$2} and $nu_occupancy_g{$2} = "-1";
	!defined $tfb{$1}{$2} and  $tfb{$1}{$2} = "-1";
	!defined $gene_size{$1} and next;#die "ERROR: $1's size score does not exist!\n";
	!defined $gene_size{$2} and next;#die "ERROR: $2's size score does not exist!\n";
	!defined $tfko{$1}{$2} and $tfko{$1}{$2} = "-1";
	
	print "$1\t$2\t$bendability{$1}\t$bendability{$2}\t$gene_distence{$1}{$2}\t$tata{$1}\t$tata{$2}\t$nu_occupancy{$1}{$2}\t$nu_occupancy_g{$1}\t$nu_occupancy_g{$2}\t$3\t$tfb{$1}{$2}\t$gene_size{$1}\t$gene_size{$2}\t$tfko{$1}{$2}\n";
}

# vi:ts=4:sw=4
