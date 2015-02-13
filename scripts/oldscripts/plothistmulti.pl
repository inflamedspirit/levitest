#!/usr/bin/perl -w
#use File::Glob;

use strict;
use warnings;

our $analysis_dir;
our $offset32 = 1.0;
our $offset12 = 1.0;
our $offset1  = 1.0;

our $tstep;
our $save_interval;
our $step_histogram_bin_width;

# Load the PARAMETERS file:
if( @ARGV == 0 ) {
    die("Needs PARAMETERS.pl file as argument.");
}

my @binfilelist;
my $plotcommand = "";

foreach my $paramfile (@ARGV){
    require $paramfile;
    my $binned_file = "$analysis_dir/binned_steps";
    push(@binfilelist, $binned_file);
#    my $scale_factor = $tstep*$save_interval*$step_histogram_bin_width; # This sets the bins, which were initially in position, to be in characterisitc velocities.
    my $scale_factor = 1;
    $plotcommand = $plotcommand . "'$binned_file' u (\\\$2/$scale_factor):4 w l, "
}
$plotcommand = $plotcommand . "pow32(x)"; #, pow12(x), pow1(x)


print "Plotting histogrammed data @binfilelist...";

system(
"gnuplot -persist <<EOF
set term x11
set logscale xy

#set yrange [1:10000000]

pow32(x) = $offset32*x**(-3.0/2.0)
pow12(x) = $offset12*x**(-1.0/2.0)
pow1(x)  = $offset1*x**(-1.0)
gaus(x) = 18000*exp(-x**2/22);

plot $plotcommand

EOF
");

print "done.\n";
