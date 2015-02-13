#!/usr/bin/perl -w
#use File::Glob;

use strict;
use warnings;
use POSIX qw/floor/;
our $num_jobs;
our $analysis_dir;
our $stdoutbase;
our $stderrbase;

our $step_filex;
our $step_filey;
our $step_filez;
our $step_filer;

our $step_histogram_bin_width;

# Load the PARAMETERS file:
if( @ARGV != 1 ) {
    die("Needs PARAMETERS.pl file as argument.");
}
my $paramfile = $ARGV[0];
require $paramfile;

my $output_file = "$analysis_dir/binned_steps";
my $output_filer = "$analysis_dir/binned_stepsr";

#Generate list of all stdout files:
my $j;
my @logfiles;
for($j=1; $j<=$num_jobs; $j++) {
  push @logfiles, "$stdoutbase.$j"
}
#my @logfiles = glob 'stdout.*';

my %bins;
my $bin, my $total=0;


open FILE, "<$step_filex" or die "Error, no data file.\n";
while(<FILE>){
    chomp;
    $bin = floor(abs($_)/$step_histogram_bin_width);
    $bins{$bin} ||= 0;
    $bins{$bin} = $bins{$bin} + 1;
    $total=$total+1;  
}
close FILE;

open FILE, "<$step_filey" or die "Error, no data file.\n";
while(<FILE>){
    chomp;
    $bin = floor(abs($_)/$step_histogram_bin_width);
    $bins{$bin} ||= 0;
    $bins{$bin} = $bins{$bin} + 1;
    $total=$total+1;  
}
close FILE;

open FILE, "<$step_filez" or die "Error, no data file.\n";
while(<FILE>){
    chomp;
    $bin = floor(abs($_)/$step_histogram_bin_width);
    $bins{$bin} ||= 0;
    $bins{$bin} = $bins{$bin} + 1;
    $total=$total+1;  
}
close FILE;


my @keylist = keys %bins;
my @valuelist = values %bins;
my @sortedkeylist = sort { $a <=> $b } @keylist;

open FILE, ">$output_file" or die "Error, output steps.";
print FILE "#bin number\tbin start\traw frequency\tnormalized frequency\n";
for(@sortedkeylist){
    my $outvalue = $bins{$_};
    my $outvaluescaled = $bins{$_}/$total;
    my $binstart = $step_histogram_bin_width*$_;
    print FILE "$_\t$binstart\t$outvalue\t$outvaluescaled\n";
}
close FILE;


#for r


my %binsr;
my $binr, my $totalr=0;


open FILE, "<$step_filer" or die "Error, no data file.\n";
while(<FILE>){
    chomp;
    $binr = floor(abs($_)/$step_histogram_bin_width);
    $binsr{$binr} ||= 0;
    $binsr{$binr} = $binsr{$binr} + 1;
    $totalr=$totalr+1;  
}
close FILE;



my @keylistr = keys %binsr;
my @valuelistr = values %binsr;
my @sortedkeylistr = sort { $a <=> $b } @keylistr;

open FILE, ">$output_filer" or die "Error, output steps.";
print FILE "#bin number\tbin start\traw frequency\tnormalized frequency\n";
for(@sortedkeylistr){
    my $outvalue = $binsr{$_};
    my $outvaluescaled = $binsr{$_}/$totalr;
    my $binstart = $step_histogram_bin_width*$_;
    print FILE "$_\t$binstart\t$outvalue\t$outvaluescaled\n";
}
close FILE;

