#!/usr/bin/perl -w
#use File::Glob;

use strict;
use warnings;
use POSIX ();
#use IPC::Run3;    # Exports run3() by default
use IPC::Open3;

our $num_jobs;
our $stdoutbase;
our $stderrbase;

our $feature_dir;

our $tfinal;



our %featurelist;


# Load the PARAMETERS file:
if( @ARGV != 1 ) {
    die("Needs PARAMETERS.pl file as argument.");
}
my $paramfile = $ARGV[0];
require $paramfile;


my %datafiles;
my %datafilesfeatures;
my $num_of_features=0;

my $j;
my $k;
for ($j=1; $j<=$num_jobs; $j++) {
    $datafiles{$j} ||= 0;
    $datafiles{$j} = "$stdoutbase.$j";

    my @feature_titles = keys %featurelist;
    $num_of_features = scalar @feature_titles;
    print "feature_titles: @feature_titles \n";
    print "num_of_features: $num_of_features \n";
    for($k=1; $k<=$num_of_features; $k++){
	$datafilesfeatures{$k}{$j} ||= 0;
	$datafilesfeatures{$k}{$j}  = "$feature_dir/$feature_titles[$k-1].$j";
    }
}


# Fork to make a gnuplotter. 

#run3("gnuplot -", my $in);
my $pid = open3(my $WRITE, my $READ, my $ERROR,"gnuplot -");


#my $pid = fork();
#if($pid == 0){
                        # This is the child fork.
#    system("exec $exec_dir/photon_pulse_rec.pl $raw_file_name");
#    exit 0;
#}


# Taking a tip out of Jeremy's crazy cool code (intanim.pl)...

# We want to be able to read keys as they are pressed, so save the current
# terminal settings, and then alter them.
my $oldterm=POSIX::Termios->new;
if(!defined($oldterm->getattr())){
    die("Unable to read terminal attributes from stdin.\n");
}
# This is the version I will alter.  I'm not sure if you can just assign
# these guys, so I'll just grab the data again:
my $newterm=POSIX::Termios->new;
if(!defined($newterm->getattr())){
    die("Unable to read terminal attributes from stdin.\n");
}
# Try to set the terminal back when we get a signal:
my $old_handler=$SIG{'INT'};
sub quit(){
    $oldterm->setattr;
        # Finally, call the old handler:
    &$old_handler(@_);
    print $WRITE "exit\n";
    waitpid($pid, 1);
}
$SIG{'INT'}=$SIG{'QUIT'}=$SIG{'TERM'}=\&quit;

# Like die(), but returns the terminal to its original state.
sub mydie(@){
    $oldterm->setattr;
    die(@_);
}

# In order to read characters as they are typed you need to turn canonical
# mode off and shut down the input timers -- I want read to return
# whenever there's a byte typed.  Also, there's no need for characters to
# echo, so turn that off, too:
{
    my $flag=$newterm->getlflag;
    $newterm->setlflag($flag & (~&POSIX::ICANON) & (~&POSIX::ECHO));
    $newterm->setcc(&POSIX::VMIN,1);
    $newterm->setcc(&POSIX::VTIME,0);
    $newterm->setattr;
}


my $option_logscale=0;
my $string_logscale=" ";
my $option_xrange=0;
my $option_yrange=0;
my $string_xrange=" ";
my $string_yrange=" ";

my $option_wlines=0;
my $string_wlines=" ";

my $option_features=0;
my $string_features=' ';

my $min_xrange=0;
my $max_xrange=$tfinal;
my $width_xrange=$tfinal;

my $min_yrange=-2;
my $max_yrange=2;

my $frame=1;
my $update=1;

my $yvar = 2; #default to x position
my $yvar_max = 8; 
my $yvar_min = 1; 
# 1 time
# 2 x
# 3 y
# 4 z
# 5 px
# 6 py
# 7 pz
# 8 ?
# ?
# ?

print "Starting display loop...";

for(;;){
    my $a;
# Get input:
    my $bits='';vec($bits,fileno(STDIN),1)=1;

#    select($bits,undef,undef,0.25);
    select($bits,undef,undef,undef);


    if(vec($bits,fileno(STDIN),1) && read(STDIN,$a,1)>0){


	if($a eq ' '){}

	if($a eq 'q'){quit();}

	if($a eq 'l'){
	    $option_logscale = !$option_logscale;
	    if($option_logscale){
		$string_logscale = 'set logscale xy';
	    } else {
		$string_logscale = '';
	    }
	    $update=1;
	}

	if($a eq 'x'){
	    $option_xrange = !$option_xrange;
	    if($option_xrange){
		$string_xrange = "set xrange [$min_xrange:$max_xrange]";
		print "$string_xrange\n";
	    } else {
		$string_xrange = '';
		print "xrange disabled.\n";
	    }
	    $update=1;
	}


# Fast window sizing (not really good)
#	if($a eq 'a'){
#	    $width_xrange *= 2.0;
#	    $min_xrange = $max_xrange - $width_xrange;	
#	    $option_xrange = 1;
#	    $string_xrange = "set xrange [$min_xrange:$max_xrange]";
#	    print "$string_xrange\n";
#	    $update=1;
#	}elsif($a eq 'A'){
#	    $width_xrange /= 2.0;
#	    $min_xrange = $max_xrange - $width_xrange;
#	    $option_xrange = 1;
#	    $string_xrange = "set xrange [$min_xrange:$max_xrange]";
#	    print "$string_xrange\n";
#	    $update=1;
#	}elsif($a eq 'd'){
#	    $width_xrange *= 2.0;
#	    $max_xrange = $min_xrange + $width_xrange;
#	    $option_xrange = 1;
#	    $string_xrange = "set xrange [$min_xrange:$max_xrange]";
#	    print "$string_xrange\n";
#	    $update=1;
#	}elsif($a eq 'D'){
#	    $width_xrange /= 2.0;
#	    $max_xrange = $min_xrange + $width_xrange;
#	    $option_xrange = 1;
#	    $string_xrange = "set xrange [$min_xrange:$max_xrange]";
#	    print "$string_xrange\n";
#	    $update=1;
#	}

	if($a eq '['){
	    $yvar-=1;
	    if( $yvar < $yvar_min )
	    {
		$yvar = $yvar_min;
	    }
		$update=1;
	}elsif($a eq ']'){
	    $yvar+=1;
	    if( $yvar > $yvar_max )
	    {
		$yvar = $yvar_max;
	    }
		$update=1;
	}


	if($a eq 'a'){
	    $min_xrange -= $width_xrange*0.1;	
	    $max_xrange -= $width_xrange*0.1;	
	    $option_xrange = 1;
	    $string_xrange = "set xrange [$min_xrange:$max_xrange]";
	    print "$string_xrange\n";
	    $update=1;
	}elsif($a eq 'A'){
	    $min_xrange -= $width_xrange*0.01;	
	    $max_xrange -= $width_xrange*0.01;	
	    $option_xrange = 1;
	    $string_xrange = "set xrange [$min_xrange:$max_xrange]";
	    print "$string_xrange\n";
	    $update=1;
	}elsif($a eq 'd'){
	    $min_xrange += $width_xrange*0.1;	
	    $max_xrange += $width_xrange*0.1;	
	    $option_xrange = 1;
	    $string_xrange = "set xrange [$min_xrange:$max_xrange]";
	    print "$string_xrange\n";
	    $update=1;
	}elsif($a eq 'D'){
	    $min_xrange += $width_xrange*0.01;	
	    $max_xrange += $width_xrange*0.01;	
	    $option_xrange = 1;
	    $string_xrange = "set xrange [$min_xrange:$max_xrange]";
	    print "$string_xrange\n";
	    $update=1;
	}elsif($a eq 'z'){
	    $width_xrange += $width_xrange*0.1;
	    $min_xrange = $max_xrange - $width_xrange;
	    $option_xrange = 1;
	    $string_xrange = "set xrange [$min_xrange:$max_xrange]";
	    print "$string_xrange\n";
	    $update=1;
	}elsif($a eq 'Z'){
	    $width_xrange -= $width_xrange*0.1;
	    $min_xrange = $max_xrange - $width_xrange;
	    $option_xrange = 1;
	    $string_xrange = "set xrange [$min_xrange:$max_xrange]";
	    print "$string_xrange\n";
	    $update=1;
	}elsif($a eq 'c'){
	    $width_xrange += $width_xrange*0.1;
	    $max_xrange = $min_xrange + $width_xrange;
	    $option_xrange = 1;
	    $string_xrange = "set xrange [$min_xrange:$max_xrange]";
	    print "$string_xrange\n";
	    $update=1;
	}elsif($a eq 'C'){
	    $width_xrange -= $width_xrange*0.1;
	    $max_xrange = $min_xrange + $width_xrange;
	    $option_xrange = 1;
	    $string_xrange = "set xrange [$min_xrange:$max_xrange]";
	    print "$string_xrange\n";
	    $update=1;
	}

	elsif($a eq ','){--$frame;$update=1;}
	elsif($a eq '.'){++$frame;$update=1;}
	elsif($a eq '<'){$frame=1;$update=1;}
	elsif($a eq '>'){$frame=$num_jobs;$update=1;}

	elsif($a eq '1'){
		$string_wlines = ' w points ';
		$update=1;
	}elsif($a eq '2'){
		$string_wlines = ' w lines ';
		$update=1;
	}elsif($a eq '3'){
		$string_wlines = ' w linespoints ';
		$update=1;
	}elsif($a eq '4'){
		$string_wlines = ' w impulses ';
		$update=1;
	}elsif($a eq '5'){
		$string_wlines = ' w dots ';
		$update=1;
	}elsif($a eq '6'){
		$string_wlines = ' w steps ';
		$update=1;
	}elsif($a eq '7'){
		$string_wlines = ' w fsteps ';
		$update=1;
	}


	if($frame<1){$frame=1;}
	if($frame>$num_jobs){$frame=$num_jobs;}


	if($a eq 't'){
	    if($option_features <= 1){
		$option_features = 0;

	    } else {
		$option_features--;
#		my $plotfilefeature = $datafilesfeatures{$option_features}{$frame};
	    }
	    $update=1;
	}elsif($a eq 'y'){
	    if($option_features >= $num_of_features-1){
		$option_features = $num_of_features;
#		my $plotfilefeature = $datafilesfeatures{$option_features}{$frame};
	    } else {
		$option_features++;
#		my $plotfilefeature = $datafilesfeatures{$option_features}{$frame};
	    }
	    $update=1;
	}

#	elsif($a eq '2'){}
#	elsif($a eq '3'){}

    


	if($update){
	    $update=0;

	    my $plotfile = $datafiles{$frame};
	    my $plotfilefeatures = $datafilesfeatures{$option_features}{$frame};

	    
	    if(!($option_features)){
		$string_features = ' ';
	    } else {
		$string_features = ", '$plotfilefeatures' u 1:2 w points";
	    }


	    print "Plotting $plotfile...\n";

	    print "DEBUG: Using command:\n";
	    print "set term x11 1 title \"hello\" noraise
$string_logscale
$string_xrange
$string_yrange
plot '$plotfile' u 1:$yvar $string_wlines$string_features
";


	    print $WRITE "set term x11 1 title \"hello\" noraise
$string_logscale
$string_xrange
$string_yrange
plot '$plotfile' u 1:$yvar $string_wlines$string_features
";
	

#	    system("gnuplot -persist <<EOF
#set term x11 1 title \"hello\" noraise
#$string_logscale
#$string_xrange
#$string_yrange
#plot '$plotfile' u 1:3
#EOF");

# || mydie("Could not display $ARGV[$frame].\n");

	    
	}

    }
}



print "done.\n";
waitpid($pid, 1);
