#!/usr/bin/perl -w
#use File::Glob;

use strict;
use warnings;

our $num_jobs;

our $analysis_dir;

our $stdoutbase;
our $stderrbase;

our $step_filex;
our $step_filey;
our $step_filez;
our $step_filer;

our $step_integration_skip;


# Load the PARAMETERS file:
if( @ARGV != 1 ) {
    die("Needs PARAMETERS.pl file as argument.");
}
my $paramfile = $ARGV[0];
require $paramfile;


#Generate list of all stdout files:
my $j;
my @logfiles;
for($j=1; $j<=$num_jobs; $j++) {
  push @logfiles, "$stdoutbase.$j"
}
#my @logfiles = glob 'stdout.*';

my @stepsx;
my @stepsy;
my @stepsz;
my @stepsr;

my $x=0;
my $y=0;
my $z=0;
my $r=0;

my $step;


print "Scanning through @logfiles stdout logfiles...\n";

for(@logfiles){

    open FILE, "<$_" or print "Error, missing data file. Dumping remainder to step_dist.\n", last;
    print "Scanning $_...\n";

    my $skip_counter=0;

    while(<FILE>){
	# change to split

	my @line = split(/\s+/);

#	foreach my $item (@line){
	#    print "$item\n";
	#}


#	print "@line\n";
	unless( $line[1] =~ /#/ ) #|| scalar @line < 5 )
	{
	    $skip_counter++;
	    if( ($skip_counter % $step_integration_skip) == 0 ){

	    $step = $x-$line[2];
	    push(@stepsx,$step);
	    $step = $y-$line[3];
	    push(@stepsy,$step);
	    $step = $z-$line[4];
	    push(@stepsz,$step);   
	    my $rnew = ($line[2]**(2.0)+$line[3]**(2.0)+$line[4]**(2.0))**(0.5);
	    $step = $r-$rnew;
	    push(@stepsr,$step);

	    $x=$line[2];
	    $y=$line[3];
	    $z=$line[4];
	    $r=$rnew;
	    }
	} 


    }
    close FILE;
}

print "Saving data to files...\n";

open FILE, ">$step_filex" or die "Error, output steps.";
for(@stepsx){
    print FILE "$_\n";
}
close FILE;

open FILE, ">$step_filey" or die "Error, output steps.";
for(@stepsy){
    print FILE "$_\n";
}
close FILE;

open FILE, ">$step_filez" or die "Error, output steps.";
for(@stepsz){
    print FILE "$_\n";
}
close FILE;

open FILE, ">$step_filer" or die "Error, output steps.";
for(@stepsr){
    print FILE "$_\n";
}
close FILE;



