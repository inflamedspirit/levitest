#!/usr/bin/perl -w
#use File::Glob;

use strict;
use warnings;

our $num_jobs;

our $analysis_dir;

our $stdoutbase;
our $stderrbase;

our $step_threshhold;

our $long_step_filex;
our $long_step_filey;
our $long_step_filez;
our $long_step_filer;

our $longstep_dir;
our $longstepbase;

# Load the PARAMETERS file:
if( @ARGV != 1 ) {
    die("Needs PARAMETERS.pl file as argument.");
}
my $paramfile = $ARGV[0];
require $paramfile;

if( !(-d "$longstep_dir") ) {
    mkdir("$longstep_dir") or die "Could not make directory $longstep_dir";
}

my @stepsx;
my @stepsy;
my @stepsz;
my @stepsr;

my $x=0;
my $y=0;
my $z=0;
my $r=0;

my $step;


print "Scanning through logfiles...\n";

my $j;
for($j=1; $j<=$num_jobs; $j++) {
    my $infile = "$stdoutbase.$j";
    my $outfile = "$longstepbase.$j";

    open FILE, "<$infile" or print "Error, missing data file. Dumping remainder to step_dist.\n", last;
    open FILEOUT, ">$outfile" or die "Error, could not save to $outfile \n";

    print "Scanning $infile...\n";

    while(<FILE>){
	if(/^\s*#/){
	    next;
	}

	my $printed = 0;


	if(/^\s*(\S+)\s+(\S+)\s+(\S+)\s+(\S+)/){
	    my $time = $1;
	    $printed=0;
	    $step = $x-$2;
	    if($step > $step_threshhold){
		push(@stepsx,"$time $step");
		if($printed == 0){
		    print FILEOUT $_;
		    $printed = 1;
		}
	    }
	    $step = $y-$3;
	    if($step > $step_threshhold){
		push(@stepsy,"$time $step");
		if($printed == 0){
		    print FILEOUT $_;
		    $printed = 1;
		}
	    }
	    $step = $z-$4;
	    if($step > $step_threshhold){
		push(@stepsz,"$time $step"); 
		if($printed == 0){
		    print FILEOUT $_;
		    $printed = 1;
		}
	    }
	    my $rnew = ($2**(2.0)+$3**(2.0)+$4**(2.0))**(0.5);
	    $step = $r-$rnew;
	    if($step > $step_threshhold){
		push(@stepsr,"$time $step");
		if($printed == 0){
		    print FILEOUT $_;
		    $printed = 1;
		}
	    }

	    $x=$2;
	    $y=$3;
	    $z=$4;
	    $r=$rnew;
	}
    }
    close FILE;
    close FILEOUT;
}

print "Saving data to files...\n";

open FILE, ">$long_step_filex" or die "Error, output steps.";
print FILE "#time   stepsize\n";
for(@stepsx){
    print FILE "$_\n";
}
close FILE;

open FILE, ">$long_step_filey" or die "Error, output steps.";
print FILE "#time   stepsize\n";
for(@stepsy){
    print FILE "$_\n";
}
close FILE;

open FILE, ">$long_step_filez" or die "Error, output steps.";
print FILE "#time   stepsize\n";
for(@stepsz){
    print FILE "$_\n";
}
close FILE;

open FILE, ">$long_step_filer" or die "Error, output steps.";
for(@stepsr){
    print FILE "$_\n";
}
close FILE;



