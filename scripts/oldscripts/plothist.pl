#!/usr/bin/perl -w
#use File::Glob;

use strict;
use warnings;

our $analysis_dir;
our $offset32 = 1.0;
our $offset12 = 1.0;
our $offset1  = 1.0;

# Load the PARAMETERS file:
if( @ARGV != 1 ) {
    die("Needs PARAMETERS.pl file as argument.");
}
my $paramfile = $ARGV[0];
require $paramfile;

my $binned_file = "$analysis_dir/binned_steps";

print "Plotting histogrammed data $binned_file...";

system(
"gnuplot -persist <<EOF
set term x11
set logscale xy

#set yrange [1:10000000]

pow32(x) = $offset32*x**(-3.0/2.0)
pow12(x) = $offset12*x**(-1.0/2.0)
pow1(x)  = $offset1*x**(-1.0)
gaus(x) = 18000*exp(-x**2/22);

plot '$binned_file' u 1:4, pow32(x), pow12(x), pow1(x)

EOF
");

print "done.\n";
