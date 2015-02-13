 # File and job variables:
# Notes:
# This parameter file was derived from srate_scan_04e_wn
# this is a series designed to test the momentum/position dists
# for relatively 'short' runs (with varying amount of jobs)

our $run_title = "testlevi_shorter_1";
our $num_jobs = 10000;

our $head_dir = "/home/wwe/levitest";

our $root_paramfile = "$head_dir/PARAMETERS.pl";

our $bin_dir = "$head_dir/bin";
our $script_dir = "$head_dir/scripts";
our $data_dir = "$head_dir/data";
our $run_dir = "$data_dir/$run_title";
our $parameter_dir = "$run_dir/parameters";
our $stderr_dir = "$run_dir/stderr";
our $stdout_dir = "$run_dir/stdout";
our $analysis_dir = "$run_dir/analysis";
our $feature_dir = "$analysis_dir/features";
our $histogram_dir = "$analysis_dir/histograms";

our $stdoutbase = "$stdout_dir/stdout";
our $stderrbase = "$stderr_dir/stderr";
our $parameterbase = "$parameter_dir/parameters.gen";
our $parametermotbase = "$parameter_dir/parameters.mot";


# Simulation Parameters
our $seed=1;
our $steps=100;
our $thresh=10;
our $gamma=0.01;

# Adjusted Parameters:
our $seed_increment=1;


#$featurelist{vfinal_z} = {
#    type          => 'final_velocity',
#    num_to_avg    => '100',
#};


#$featurelist{shortstepsx} = {
#    type          => 'steprange',
#    axis          => 'x',
#    threshold_min => '0',
#    threshold_max => '16',
#};
#
#$featurelist{medstepx} = {
#    type          => 'steprange',
#    axis          => 'x',
#    threshold_min => '16',
#    threshold_max => '52',
#};
#
#$featurelist{longstepx} = {
#    type          => 'steprange',
#    axis          => 'x',
#    threshold_min => '52',
#    threshold_max => '0',
#};
#
#$featurelist{energyxmin} = {
#    type          => 'energy',
#    axis          => 'x',
#    comparison => 'min',
#    energy_min => '0',
#    energy_max => '0',
#};
#
#$featurelist{energyxmax} = {
#    type          => 'energy',
#    axis          => 'x',
#    comparison => 'max',
#    energy_min => '0',
#    energy_max => '0',
#};
#

# Histograms
#$histogramlist{hist_min} = {
#   type         => 'abs_norm_series',
#   infilebase   => "$feature_dir/energyxmin",
#   binwidth     => '0.2',
#   item         => '2',
#   num          => "$num_jobs",
#};
#
#
#$histogramlist{hist_test} = {
#   type         => 'abs_norm_series',
#   infilebase   => "$stdoutbase",
#   binwidth     => '0.4',
#   item         => '2',
#   num          => "100",
#};
#
#$histogramlist{hist_test_cum} = {
#   type         => 'abs_norm_series_cumulative',
#   infilebase   => "$stdoutbase",
#   item         => '2',
#   num          => "100",
#};
#
#$histogramlist{hist_test_cum2pos} = {
#   type         => 'abs_norm_series_cumulative',
#   infilebase   => "$stdoutbase",
#   item         => '2',
#   num          => "1000",
#};
#
#$histogramlist{hist_test_cum2vel} = {
#   type         => 'abs_norm_series_cumulative',
#   infilebase   => "$stdoutbase",
#   item         => '5',
#   num          => "1000",
#};

#$histogramlist{hist_test_cum_old_pos0} = {
#   type         => 'abs_norm_series_cumulative',
#   infilebase   => "$data_dir/srate_scan_04e_wn/stdout/stdout",
#   item         => '2',
#   num          => "32",
#};
#
#$histogramlist{hist_test_cum_old_vel0} = {
#   type         => 'abs_norm_series_cumulative',
#   infilebase   => "$data_dir/srate_scan_04e_wn/stdout/stdout",
#   item         => '5',
#   num          => "32",
#};
#
#$histogramlist{hist_test_cum_old_pos} = {
#   type         => 'abs_norm_series_cumulative',
#   infilebase   => "$data_dir/srate_scan_05e_wn/stdout/stdout",
#   item         => '2',
#   num          => "32",
#};
#
#$histogramlist{hist_test_cum_old_vel} = {
#   type         => 'abs_norm_series_cumulative',
#   infilebase   => "$data_dir/srate_scan_05e_wn/stdout/stdout",
#   item         => '5',
#   num          => "32",
#};
#
#$histogramlist{hist_test_cum_old_pos2} = {
#   type         => 'abs_norm_series_cumulative',
#   infilebase   => "$data_dir/srate_scan_06e_wn/stdout/stdout",
#   item         => '2',
#   num          => "32",
#};
#
#$histogramlist{hist_test_cum_old_vel2} = {
#   type         => 'abs_norm_series_cumulative',
#   infilebase   => "$data_dir/srate_scan_06e_wn/stdout/stdout",
#   item         => '5',
#   num          => "32",
#};
#
#
#$histogramlist{hist_test_cum_old_pos3} = {
#   type         => 'abs_norm_series_cumulative',
#   infilebase   => "$data_dir/srate_scan_07e_wn/stdout/stdout",
#   item         => '2',
#   num          => "32",
#};
#

#$histogramlist{cpd_pos00010} = {
#   type         => 'abs_norm_series_cumulative',
#   infilebase   => "$data_dir/typical_jc00010/stdout/stdout",
#   item         => '2',
#   num          => "10",
#};
#
#$histogramlist{cpd_vel00010} = {
#   type         => 'abs_norm_series_cumulative',
#   infilebase   => "$data_dir/typical_jc00010/stdout/stdout",
#   item         => '5',
#   num          => "10",
#};
#
#
#$histogramlist{cpd_pos00100} = {
#   type         => 'abs_norm_series_cumulative',
#   infilebase   => "$data_dir/typical_jc00100/stdout/stdout",
#   item         => '2',
#   num          => "100",
#};
#
#$histogramlist{cpd_vel00100} = {
#   type         => 'abs_norm_series_cumulative',
#   infilebase   => "$data_dir/typical_jc00100/stdout/stdout",
#   item         => '5',
#   num          => "100",
#};
#
#
#$histogramlist{cpd_pos01000} = {
#   type         => 'abs_norm_series_cumulative',
#   infilebase   => "$data_dir/typical_jc01000/stdout/stdout",
#   item         => '2',
#   num          => "1000",
#};
#
#$histogramlist{cpd_vel01000} = {
#   type         => 'abs_norm_series_cumulative',
#   infilebase   => "$data_dir/typical_jc01000/stdout/stdout",
#   item         => '5',
#   num          => "1000",
#};
#
#
#$histogramlist{cpd_pos10000} = {
#   type         => 'abs_norm_series_cumulative',
#   infilebase   => "$data_dir/typical_jc10000/stdout/stdout",
#   item         => '2',
#   num          => "10000",
#};
#
#$histogramlist{pos1} = {
#   type         => 'abs_norm_series_cumulative',
#   infilebase   => "$data_dir/testlevi/stdout/stdout",
#   item         => '2',
#   num          => "100",
#};
#
#$histogramlist{pos2} = {
#   type         => 'abs_norm_series_cumulative',
#   infilebase   => "$data_dir/testlevi2/stdout/stdout",
#   item         => '2',
#   num          => "1000",
#};
#
#$histogramlist{pos3} = {
#   type         => 'abs_norm_series_cumulative',
#   infilebase   => "$data_dir/testlevi3/stdout/stdout",
#   item         => '2',
#   num          => "10000",
#};


$histogramlist{longer1} = {
   type         => 'abs_norm_series_cumulative',
   infilebase   => "$data_dir/testlevi_longer_1/stdout/stdout",
   item         => '2',
   num          => "100",
};

$histogramlist{longer2} = {
   type         => 'abs_norm_series_cumulative',
   infilebase   => "$data_dir/testlevi_longer_2/stdout/stdout",
   item         => '2',
   num          => "1000",
};



return 1;
