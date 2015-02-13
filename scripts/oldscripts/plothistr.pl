#!/usr/bin/perl -w
#use File::Glob;

use strict;
use warnings;

our $analysis_dir;
our $offset32 = 1000.0;
our $offset12 = 1000.0;
our $offset1  = 1000.0;

# Load the PARAMETERS file:
if( @ARGV != 1 ) {
    die("Needs PARAMETERS.pl file as argument.");
}
my $paramfile = $ARGV[0];
require $paramfile;

my $binned_file = "$analysis_dir/binned_stepsr";

print "Plotting histogrammed data $binned_file...";

system(
"gnuplot -persist <<EOF
set term x11
set logscale xy

pow32(x) = $offset32*x**(-3.0/2.0)
pow12(x) = $offset12*x**(-1.0/2.0)
pow1(x)  = $offset1*x**(-1.0)

plot '$binned_file' u 1:3, pow32(x), pow12(x), pow1(x)

EOF
");

print "done.\n";
