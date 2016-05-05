#! /usr/bin/perl -w
use strict;
use YAML;

my $size;

for (`/bin/cat chr.gene`){
	/^#/ and next;
	/^(\S+)\t\S+\t\S+\t(\S+)\t(\S+)\t/;
	$size = abs(($3-$2)+1);
	print "$1\t$size\n"
}
