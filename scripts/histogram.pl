#!/usr/bin/perl -w
#use File::Glob;

use strict;
use warnings;
use POSIX qw/floor/;

our $num_jobs;
our $analysis_dir;
our $stdoutbase;
our $stderrbase;

our $histogram_dir;

our %histogramlist;


# Load the PARAMETERS file:
if( @ARGV != 1 ) {
    die("Needs PARAMETERS.pl file as argument.");
}
my $paramfile = $ARGV[0];
require $paramfile;



if( !(-d "$histogram_dir") ) {
    mkdir("$histogram_dir") or die "Could not make directory $histogram_dir";
}

foreach my $histogram_title (keys %histogramlist){


    # Absolute value, normalized, series of files
    if( ${$histogramlist{$histogram_title}}{type} eq 'abs_norm_series' ){
	my %bins;
	my $bin;
	my $total=0;


	my $filebase    =  ${$histogramlist{$histogram_title}}{infilebase};
	my $outfile      = "$histogram_dir/$histogram_title";
	my $binwidth     =  ${$histogramlist{$histogram_title}}{binwidth};
	my $num          =  ${$histogramlist{$histogram_title}}{num};
	my $item         =  ${$histogramlist{$histogram_title}}{item};

	print "Extracting steps $histogram_title...\n";
	print "Scanning through logfiles...\n";

	my $j;

	for($j=1; $j<=$num; $j++) {
	    my $infile = "$filebase.$j";
	    print "Scanning $infile...\n";
	    open FILE, "<$infile" or print "Error, missing data file. Attempting to save data up to this point...\n", last;
	    while(<FILE>){
		my $line_full = $_;
		my @line = split(/\s+/);

		unless( $line_full =~ /#/ ){
		    $bin = floor(abs($line[$item])/$binwidth);
		    $bins{$bin} ||= 0;
		    $bins{$bin} = $bins{$bin} + 1;
		    $total=$total+1;  
		}


	    }
	    close FILE;
	}

	my @keylist = keys %bins;
	my @valuelist = values %bins;
	my @sortedkeylist = sort { $a <=> $b } @keylist;

	open FILE, ">$outfile" or die "Error, output steps.";
	print FILE "#bin start\tnormalized frequency\n";
	for(@sortedkeylist){
	    my $outvalue = $bins{$_};
	    my $outvaluescaled = $bins{$_}/$total;
	    my $binstart = $binwidth*$_;
	    print FILE "$binstart\t$outvaluescaled\n";
	}
	close FILE;


    }
    #End Histogram Type

    # Absolute value, normalized, series of files, cumulative
    if( ${$histogramlist{$histogram_title}}{type} eq 'abs_norm_series_cumulative' ){
	my %bins;
	my $bin;
	my $total=0;

	my $filebase    =  ${$histogramlist{$histogram_title}}{infilebase};
	my $outfile      = "$histogram_dir/$histogram_title";
	my $num          =  ${$histogramlist{$histogram_title}}{num};
	my $item         =  ${$histogramlist{$histogram_title}}{item};

	print "Extracting steps $histogram_title...\n";
	print "Scanning through logfiles...\n";

	my $j;
	my @points;
	my @points_sorted;


	for($j=1; $j<=$num; $j++) {
	    my $infile = "$filebase.$j";
	    print "Scanning $infile...\n";
	    open FILE, "<$infile" or print "Error, missing data file. Attempting to save data up to this point...\n", last;
	    while(<FILE>){
		my $line_full = $_;
		my @line = split(/\s+/);

		unless( $line_full =~ /#/ ){
		    push(@points, abs($line[$item]) );
		    $total = $total+1;
		}


	    }
	    close FILE;
	}

	print "Sorting list...";
	    @points_sorted =  sort { $a <=> $b } @points;


	print "Exporting data...";

	open FILE, ">$outfile" or die "Error, output steps.";
	print FILE "#value\tnormalized frequency\n";
	my $count=0;
	for(@points_sorted){
	    $count = $count + 1;
	    my $value = $_;
	    my $frequency = 1-$count/$total;
	    print FILE "$value\t$frequency\n";
	}
	close FILE;


    }
    #End Histogram Type

}
