#!/usr/bin/perl


use strict;
use warnings;

# File and job variables to be loaded:
our $num_jobs;

our $head_dir;
our $bin_dir;
our $data_dir;

our $run_title;

our $run_dir;
our $parameter_dir;
our $stderr_dir;
our $stdout_dir;
our $analysis_dir;

our $stdoutbase;
our $stderrbase;
our $parameterbase;
our $parametermotbase;

# Base Parameters to be loaded:
our $seed;
our $steps;
our $thresh;
our $gamma;

# Adjusted parameters:
our $seed_increment;

# Load the PARAMETERS file:
if( @ARGV != 1 ) {
    die("Needs PARAMETERS.pl file as argument.");
}

my $paramfile = $ARGV[0];
require $paramfile;


#print "$num_jobs\n";
#print "$parameterbase";


# Create directories and run, unless directory exists.
if( -d "$run_dir" ) {
    die "Error: data directory exists. Delete $run_dir or rename \$run_title to something other than $run_title.\n";
} else { 
    mkdir("$run_dir") or die "Could not make directory";
    mkdir("$parameter_dir") or die "Could not make directory";
    mkdir("$stdout_dir") or die "Could not make directory";
    mkdir("$stderr_dir") or die "Could not make directory";
    mkdir("$analysis_dir") or die "Could not make directory";
}



# Main loop:

my $j;
for ($j=1; $j<=$num_jobs; $j++) {

# Adjusted parameters
    $seed = $seed + $seed_increment;

    open(my $paramfh, ">$parameterbase.$j");
    print $paramfh "# file automatically generated by makeparameters.pl\n";
    print $paramfh "\$bin_dir='$bin_dir';\n";
    print $paramfh "\$stdoutfile='$stdoutbase.$j';\n";
    print $paramfh "\$stderrfile='$stderrbase.$j';\n";
    print $paramfh "\$parametermotbase = '$parametermotbase';\n";
    print $paramfh "\$run_number='$j';\n";
    print $paramfh "\n";
    print $paramfh "1\n";
    print $paramfh "\n";
    close($paramfh);

    open($paramfh, ">$parametermotbase.$j");
    print $paramfh "seed                 $seed\n";
    print $paramfh "thresh               $thresh\n";
    print $paramfh "gamma                $gamma\n";
    print $paramfh "steps                $steps\n";
    close($paramfh);

}

#return 0; #this is for success?
