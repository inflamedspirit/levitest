#!/usr/bin/perl -w
#use File::Glob;

# This script does a bunch of "feature" extraction. Basically, there are certain lists
# of parametersets for different feature extraction types in the PARAMETERS.pl file.
# These lists should be in the form of (feature_title, param1, param2, ..., paramN). This
# script will extract the appropriate steps that match the feature parameters, and print
# them in the "analysis/features/feature_title.feature" file. These will then be plotted by the
# plotposition.pl script. Some feature extractions give subtitles based on parameters in
# the form of "feature_title.subtitle.feature"

use strict;
use warnings;

our $num_jobs;
our $analysis_dir;

our $stdoutbase;
our $stderrbase;

our $feature_dir;

our $step_integration_skip;

# for vfinal extraction:
our $tfinal;
our $tstep;
our $save_interval;
our $vx;
our $vy;
our $vz;



# FEATURE LISTS

# Step Size Range Extraction
# 0 indicates no bound at all, e.g. 0,0 means ALL steps
# ("feature_title", "x/y/z", lower_bound, upper_bound)
our %featurelist;


# Load the PARAMETERS file:
if( @ARGV != 1 ) {
    die("Needs PARAMETERS.pl file as argument.");
}
my $paramfile = $ARGV[0];
require $paramfile;


if( !(-d "$feature_dir") ) {
    mkdir("$feature_dir") or die "Could not make directory $feature_dir";
}

#print $featurelist{steprange}{1};
#print $featurelist{steprange}{1}{title};
#print values(%{$featurelist{steprange}{1}});
#print $featurelist{steprange}{1}{title};



foreach my $feature_title (keys %featurelist){

    print "hellooo\n";

    # Extract Feature: Energy Threshold
    if( ${$featurelist{$feature_title}}{type} eq 'energy' ){
	my $step_type    =  ${$featurelist{$feature_title}}{axis};
	my $comparison   =  ${$featurelist{$feature_title}}{comparison};
	my $energy_min   =  ${$featurelist{$feature_title}}{energy_min};
	my $energy_max   =  ${$featurelist{$feature_title}}{energy_max};
	my $feature_base = "$feature_dir/$feature_title";

	print "Extracting feature $feature_title...\n";
	print "Scanning through logfiles...\n";


	my $j;



	for($j=1; $j<=$num_jobs; $j++) {
	    my $infile = "$stdoutbase.$j";
	    my $outfile = "$feature_base.$j";

	    open FILE, "<$infile" or print "Error, missing data file. Attempting to save data up to this point...\n", last;
	    open FILEOUT, ">$outfile" or die "Error, could not save to $outfile \n";

	    print "Scanning $infile...\n";

	    my @steps;
	    my $skip_counter = 0;
	    my $x=0;
	    my $energy=0;

	    while(<FILE>){

		my @line = split(/\s+/);
		my $step = 0;
		unless( $line[1] =~ /#/ ){


		    if( $step_type eq 'x' ){
			$step = abs($x-$line[2]);
			$x=$line[2];
		    } elsif( $step_type eq 'y' ){
			$step = abs($x-$line[3]);
			$x=$line[3];
		    } elsif( $step_type eq 'z' ){
			$step = abs($x-$line[4]);
			$x=$line[4];
		    }
		    
		    $energy = $line[8];
		    
		    # if just min or just max, then always accept for the other one, minmax or other will do both
		    if( ($comparison eq 'max') || ($energy > $energy_min) ) {
			if( ($comparison eq 'min') || ($energy < $energy_max) ) {
			    my $time = $line[1];
			    
			    if( $step_type eq 'x' ){
				push(@steps,"$time $x $step $energy");
			    } elsif( $step_type eq 'y' ){
				push(@steps,"$time $x $step $energy");
			    } elsif( $step_type eq 'z' ){
				push(@steps,"$time $x $step $energy");
			    }
			}
			
		    }
		}     
	    }
	
    
	    close FILE;
	    
	    print "Saving data to $outfile...\n";
	    
	    print FILEOUT "# Feature Extraction: Step Size Range. File: $feature_base.$j axis: $step_type min: $energy_min max: $energy_max \n";
	    print FILEOUT "# time position stepsize energy \n";
	    foreach my $step_temp (@steps){
		print FILEOUT "$step_temp \n";
	    }
	    close FILEOUT;
	}
    }


    # Extract Feature: Step Size Range Extraction
    if( ${$featurelist{$feature_title}}{type} eq 'steprange' ){

    my $step_type          =  ${$featurelist{$feature_title}}{axis};
    my $step_threshold_min =  ${$featurelist{$feature_title}}{threshold_min};
    my $step_threshold_max =  ${$featurelist{$feature_title}}{threshold_max};

    my $feature_base = "$feature_dir/$feature_title";


    print "Extracting feature $feature_title...\n";
    print "Scanning through logfiles...\n";



    my $j;

    for($j=1; $j<=$num_jobs; $j++) {
	my $infile = "$stdoutbase.$j";
	my $outfile = "$feature_base.$j";

	open FILE, "<$infile" or print "Error, missing data file. Attempting to save data up to this point...\n", last;
	open FILEOUT, ">$outfile" or die "Error, could not save to $outfile \n";

	print "Scanning $infile...\n";

	my @steps;
	my $skip_counter = 0;
	my $x=0;
	my $step=0;

	while(<FILE>){

	    my @line = split(/\s+/);

	    unless( $line[1] =~ /#/ ) #|| scalar @line < 5 )
	    {
		$skip_counter++;
		if( ($skip_counter % $step_integration_skip) == 0 ){

		    if( $step_type eq 'x' ){
			$step = abs($x-$line[2]);
			$x=$line[2];
		    } elsif( $step_type eq 'y' ){
			$step = abs($x-$line[3]);
			$x=$line[3];
		    } elsif( $step_type eq 'z' ){
			$step = abs($x-$line[4]);
			$x=$line[4];
		    } elsif( $step_type eq 'r' ){
			my $rnew = ($line[2]**(2.0)+$line[3]**(2.0)+$line[4]**(2.0))**(0.5);
			$step = abs($x-$rnew);
			$x=$rnew;

		    }
		    
		    if( ($step_threshold_min == 0) || ($step > $step_threshold_min) ) {
			if( ($step_threshold_max == 0) || ($step < $step_threshold_max) ) {
			    my $time = $line[1];
			    push(@steps,"$time $x $step");
			}
		    }
		}
	    }
	}
    
	close FILE;

	print "Saving data to $outfile...\n";

	print FILEOUT "# Feature Extraction: Step Size Range. File: $feature_base.$j axis: $step_type min: $step_threshold_min max: $step_threshold_max \n ";
	print FILEOUT "# time position stepsize \n";
	foreach $step (@steps){
	    print FILEOUT "$step \n";
	}
	close FILEOUT;
    }
    }


    # Extract Feature: Final velocity average extraction
    if( ${$featurelist{$feature_title}}{type} eq 'final_velocity' ){
	my $num_to_avg   =  ${$featurelist{$feature_title}}{num_to_avg};
	my $feature_base = "$feature_dir/$feature_title";

	print "Extracting feature $feature_title...\n";
	print "Scanning through logfiles...\n";


	my $j;

	my $outfile = "$feature_base";
	open FILEOUT, ">$outfile" or die "Error, could not save to $outfile \n";
	print "Saving data to $outfile...\n";

	print FILEOUT "# Feature Extraction: Final RMS velocities. File: $feature_base \n";


	for($j=1; $j<=$num_jobs; $j++) {
	    my $infile = "$stdoutbase.$j";


	   open FILE, "<$infile" or print(STDERR "Error, missing data file. Attempting to continue...\n"), next;
	   #open FILE, "<$infile" or die "Error, missing data file. Attempting to save data up to this point...\n";


	    print "Scanning $infile...\n";

	    my $step_num=0;
	    my $num_added=0;
	    my $num_added0=0;
	   
###############
################# I really should average the initial velocity since this is not right
#################
################   also it would be terrrrible if line[blah] were not matched up to what I think it should be.

	    my $vfx0=0; 
	    my $vfy0=0; 
	    my $vfz0=0;
	    my $vfx=0; 
	    my $vfy=0; 
	    my $vfz=0;

	    while(<FILE>){

		my @line = split(/\s+/);
		
		unless( $line[1] =~ /#/ ){
		    $step_num++;

		    if( $step_num < $num_to_avg ) { 
			$num_added0++;
			$vfx0+=$line[5]*$line[5];
			$vfy0+=$line[6]*$line[6];
			$vfz0+=$line[7]*$line[7];
		    }


		    if( $step_num > $tfinal/$tstep/$save_interval - $num_to_avg ) { 
			$num_added++;
			$vfx+=$line[5]*$line[5];
			$vfy+=$line[6]*$line[6];
			$vfz+=$line[7]*$line[7];
		    }
		}
	    }

	    $vfx0 = sqrt($vfx0/$num_added0);
	    $vfy0 = sqrt($vfy0/$num_added0);
	    $vfz0 = sqrt($vfz0/$num_added0);

	    $vfx = sqrt($vfx/$num_added);
	    $vfy = sqrt($vfy/$num_added);
	    $vfz = sqrt($vfz/$num_added);


    
	    close FILE;
	       
	    print FILEOUT "$vfx0 $vfy0 $vfz0 $vfx $vfy $vfz \n";


	 
	}

	close FILEOUT;
    }

}



