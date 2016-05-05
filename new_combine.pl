#! /usr/bin/perl -w
use strict;
use YAML;
use Getopt::Std;

my %bendability;
my %gene_distance;
my %nu_occupancy;
my %nu_occupancy_g;
my %tata;
my %tfb;
my %gene_size;
my %tfko;
my %tfbs;
my $pair_list = shift;

my (%opts,$key); &getopt('bdnafzskl',\%opts);


defined $opts{l} and &all;
defined $opts{b} and &bend;
defined $opts{d} and &distance;;
defined $opts{a} and &tata;
defined $opts{f} and &tfb;
defined $opts{z} and &size;
defined $opts{k} and &tfko;
defined $opts{s} and &tfbs;
defined $opts{n} and &nu;

sub bend{
	open F1,"DNA_bendability";
	while (<F1>){
		/^(\S+)\t(\S+)$/;
		$bendability{$1} = $2;
	}
	close F1;
	open FH,$pair_list;
	while(<FH>){
		/^(\S+)\t(\S+)$/;
		!defined $bendability{$1} and next;
		!defined $bendability{$2} and next;
		print "$1\t$2";
		for (1..($opts{b}/2)){
			print "\t$bendability{$1}\t$bendability{$2}";
		}
		print "\n";
	}
	close FH;
	exit;
}


sub get_distance{
	my $start1;
	my $start2;
	my $stop1;
	my $stop2;
	my %dis;
	my $output_str;
	my $chrnum = 1;
	while ($chrnum <=16){
		my %pos;
		for (`/bin/cat /free1/lstayreal/shaoting/ppi_research/chromosome/chr$chrnum.gene`){
			/^#/ and next;
			/^(\S+)\t(\S+\t){2}(\S+)\t(\S+)\t(\S+)\t(\S+)/;
			$pos{$1}{start} = $3;
			$pos{$1}{stop} = $4;
		}
		for (`/usr/bin/cut -f1,2 $pair_list`){
			my ( $proA, $proB ) = /(\S+)\t(\S+)/;
			defined $pos{$proA} and defined $pos{$proB} or next;
			$start1 = $pos{$proA}{start};
			$start2 = $pos{$proB}{start};
			$stop1 = $pos{$proA}{stop};
			$stop2 = $pos{$proB}{stop};
			@_ = sort { $a <=> $b } ($start1, $start2, $stop1, $stop2);
			$dis{$proA}{$proB} = ($_[3]-$_[0]) <= (abs($start1-$stop1)+abs($start2-$stop2)) ? 0 : $_[2]-$_[1];
		}
		$chrnum +=1;
	}

	for my $pro1(keys %dis){
		for my $pro2(keys %{$dis{$pro1}}){
			$output_str = $output_str."$pro1\t$pro2\t$dis{$pro1}{$pro2}\n";
		}
	}
	open (my $FH, '>', "gene_distance");
	print $FH $output_str;
	close $FH;
	exit;

}


sub distance{
	&get_distance;
	open F2,"gene_distance";
	while (<F2>){
		/^(\S+)\t(\S+)\t(\S+)$/;
		$gene_distance{$1}{$2} = $3;
	}
	close F2;
	open FH,$pair_list;
	while(<FH>){
		/^(\S+)\t(\S+)$/;
		!defined $gene_distance{$1}{$2} and $gene_distance{$1}{$2} = "-1";
		print "$1\t$2";
		for (1..$opts{d}){
			print "\t$gene_distance{$1}{$2}";
		}
		print "\n";
	}
	close FH;
	exit;
}


sub nu{
=head
	open F3,"nu_occupancy_pair";
	while (<F3>){
		/^(\S+)\t(\S+)\t(\S+)$/;
		$nu_occupancy{$1}{$2} = $3;
	}
	close F3;
=cut

	open F4,"nu_occupancy_gene";
	while(<F4>){
		/^(\S+)\t(\S+)$/;
		$nu_occupancy_g{$1} = $2;
	}
	close F4;
	open FH,$pair_list;
	while(<FH>){
		/^(\S+)\t(\S+)$/;
		#!defined $nu_occupancy{$1}{$2} and $nu_occupancy{$1}{$2} = "-1";
		if(defined $nu_occupancy_g{$1} and defined $nu_occupancy_g{$2}){
			$nu_occupancy{'avg'}{$1}{$2} = ($nu_occupancy_g{$1} + $nu_occupancy_g{$2})/2;
			$nu_occupancy{'diff'}{$1}{$2} = abs($nu_occupancy_g{$1} - $nu_occupancy_g{$2});
		}else{
			$nu_occupancy{'avg'}{$1}{$2} = "-1";
			$nu_occupancy{'diff'}{$1}{$2} = "-1";
		}
		print "$1\t$2";
		for (1..($opts{n}/2)){
			print "\t$nu_occupancy{'avg'}{$1}{$2}\t$nu_occupancy{'diff'}{$1}{$2}";
		}
		if($opts{n}%2 == 1){
			print "\t$nu_occupancy{'diff'}{$1}{$2}";
		}
=head
		!defined $nu_occupancy_g{$1} and $nu_occupancy_g{$1} = "-1";
		!defined $nu_occupancy_g{$2} and $nu_occupancy_g{$2} = "-1";
		print "$1\t$2";
		for (1..($opts{n}/3)){
			print "\t$nu_occupancy_g{$1}\t$nu_occupancy_g{$2}\t$nu_occupancy{$1}{$2}";
		}
		if($opts{n}%3 == 2){
			print "\t$nu_occupancy_g{$1}\t$nu_occupancy_g{$2}";
		}
		elsif($opts{n}%3 == 1){
			print "\t$nu_occupancy{$1}{$2}";
		}
=cut
	print "\n";
	}
	close FH;
	exit;
}

sub tata{
	open F5,"tata";
	while (<F5>){
		/^(\S+)\t(\S+)$/;
		$tata{$1} = $2;
	}
	close F5;
	open FH,$pair_list;
	while(<FH>){
		/^(\S+)\t(\S+)$/;
		!defined $tata{$1} and next;
		!defined $tata{$2} and next;
		print "$1\t$2";
		for (1..($opts{a}/2)){
			print "\t$tata{$1}\t$tata{$2}";
		}
		print "\n";
	}
	close FH;
	exit;
}


sub tfb{
	open F6,"tfb";
	while (<F6>){
		/^(\S+)\t(\S+)\t\S+\t\S+\t(\S+)$/;
		$tfb{$1}{$2} = $3;
	}
	close F6;
	open FH,$pair_list;
	while(<FH>){
		/^(\S+)\t(\S+)$/;
		!defined $tfb{$1}{$2} and $tfb{$1}{$2} = "-1";
		print "$1\t$2";
		for (1..$opts{f}){
			print "\t$tfb{$1}{$2}";
		}
		print "\n"
	}
	close FH;
	exit;
}


sub get_size{
	my $dataFile = `cat ../../DB_source/SGD/orf_trans_all.fasta`;
	my $size;
	my $output_str;
	while($dataFile =~ m/>(.*?)\s.*?\n(.*?)\*/gs){
		$size = 3*(length($2));
		$output_str = $output_str."$1\t$size\n";
	}
	open (my $F1, '>', "new_gene_size");
	print $F1 $output_str;
	close $F1;
}


sub size{
	&get_size;
	open F7,"new_gene_size";
	while (<F7>){
		/^(\S+)\t(\S+)$/;
		$gene_size{$1} = $2;
	}
	close F7;
	open FH,$pair_list;
	while(<FH>){
		/^(\S+)\t(\S+)$/;
		!defined $gene_size{$1} and next;
		!defined $gene_size{$2} and next;
		#	print "$1\t$2";
		#for (1..($opts{z}/2)){
			#	print "\t$gene_size{$1}\t$gene_size{$2}";
			#}
		#print "\n";
	}
	close FH;
	exit;
}


sub tfko{
	open F8,"tfko";
	while (<F8>){
		/^(\S+)\t(\S+)\t\S+\t\S+\t(\S+)$/;
		$tfko{$1}{$2} = $3;
	}
	close F8;
	open FH,$pair_list;
	while(<FH>){
		/^(\S+)\t(\S+)$/;
		!defined $tfko{$1}{$2} and $tfko{$1}{$2} = "-1";
		print "$1\t$2";
		for (1..$opts{k}){
			print "\t$tfko{$1}{$2}";
		}
		print "\n";
	}
	close FH;
	exit;
}
my $tt = 0;
sub tfbs{
	open F9,"new_hyper_tfbs";
	while (<F9>){
		/^(\S+)\t(\S+)\t(\S+)$/;
		$tfbs{$1}{$2} = $3;
	}
	close F9;
	open FH,$pair_list;
	while(<FH>){
		/^(\S+)\t(\S+)$/;
		#	!defined $tfbs{$1}{$2} and $tt++;
		!defined $tfbs{$1}{$2} and $tfbs{$1}{$2} = "-1";
		print "$1\t$2";
		for (1..$opts{s}){
			print "\t$tfbs{$1}{$2}";
		}
		print "\n";
	}
	#print $tt;
	close FH;
	exit;
}


sub all{
	open F1,"DNA_bendability";
	while (<F1>){
		/^(\S+)\t(\S+)$/;
		$bendability{$1} = $2;
	}
	close F1;

	open F2,"new_gene_distance";
	while (<F2>){
		/^(\S+)\t(\S+)\t(\S+)$/;
		$gene_distance{$1}{$2} = $3;
	}
	close F2;


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
	close F6;

	open F7,"new_gene_size";
	while(<F7>){
		/^(\S+)\t(\S+)$/;

		$gene_size{$1} = $2;
	}
	close F7;

	open F8,"tfko";
	while(<F8>){
		/^(\S+)\t(\S+)\t\S+\t\S+\t(\S+)$/;
		$tfko{$1}{$2} = $3;
	}
	close F8;

	open F9,"tfbs_distribution";
	while(<F9>){
		/^(\S+)\t(\S+)\t(\S+)/;
		$tfbs{$1}{$2} = $3; 
	}
	close F9;


	print "#gene_a\tgene_b\tbendability_of_gene_a\tbendability_of_gene_b\tgene_distance\tgene_a_tatabox\tgene_b_tatabox\tnu_occupancy_pairs\tnu_occupancy_gene_a\tnu_occupancy_gene_b\ttfbs_distribution\ttfb\tgene_size_a\tgene_size_b\ttfko\n";
	open FH,$pair_list;
	while (<FH>){
		/^(\S+)\t(\S+)$/;
		!defined $bendability{$1} and next;#die "ERROR: $1's bendability score does not exist!\n";
		!defined $bendability{$2} and next;#die "ERROR: $2's bendability score does not exist!\n";
		!defined $gene_distance{$1}{$2} and $gene_distance{$1}{$2} = "-1"; # If two genes of this pair aren't on the same chromsome, set it as -1;
		#!defined $nu_occupancy{$1}{$2}  and $nu_occupancy{$1}{$2}  = "-1"; # 
		if(defined $nu_occupancy_g{$1} and defined $nu_occupancy_g{$2}){
			$nu_occupancy{$1}{$2} = ($nu_occupancy_g{$1} + $nu_occupancy_g{$2})/2;
		}else{
			$nu_occupancy{$1}{$2} = "-1";
		}
		!defined $nu_occupancy_g{$1} and $nu_occupancy_g{$1} = "-1";
		!defined $nu_occupancy_g{$2} and $nu_occupancy_g{$2} = "-1";
		!defined $tata{$1} and next;#die "ERROR: $1's tata score does not exist!\n";	
		!defined $tata{$2} and next;#die "ERROR: $2's tata score does not exist!\n";
		!defined $tfb{$1}{$2} and  $tfb{$1}{$2} = "-1";
		!defined $gene_size{$1} and next;#die "ERROR: $1's size score does not exist!\n";
		!defined $gene_size{$2} and next;#die "ERROR: $2's size score does not exist!\n";
		!defined $tfko{$1}{$2} and $tfko{$1}{$2} = "-1";
		!defined $tfbs{$1}{$2} and $tfbs{$1}{$2} = "-1";


		print "$1\t$2\t$bendability{$1}\t$bendability{$2}\t$gene_distance{$1}{$2}\t$tata{$1}\t$tata{$2}\t$nu_occupancy{$1}{$2}\t$nu_occupancy_g{$1}\t$nu_occupancy_g{$2}\t$tfbs{$1}{$2}\t$tfb{$1}{$2}\t$gene_size{$1}\t$gene_size{$2}\t$tfko{$1}{$2}\n";
	}
	exit;
}
# vi:ts=4:sw=4
