#!/usr/bin/perl

use strict;

# Output files
our $bin_dir;
our $stdoutfile;
our $stderrfile;
our $run_number;
our $parametermotbase;

# Load Parameters
if(@ARGV != 1 ){
    die "Needs parameter.gen file as argument.";
}
my $paramfile = $ARGV[0];
require $paramfile;

# Launch Mot
#system("time $bin_dir/mot $rabi_frequency $detuning $wavenumber $decay_rate $vx $vy $vz $focalradius $focalthreshhold $motradius $tstep $tfinal $save_interval $seed $stop_on_return 1> $stdoutfile 2> $stderrfile ");

system("$bin_dir/levi $parametermotbase.$run_number 1> $stdoutfile 2> $stderrfile ");

