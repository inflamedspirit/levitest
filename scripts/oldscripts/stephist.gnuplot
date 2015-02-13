
#set xrange [0:0.4]
#set yrange [0:100]
#set logscale xy

set term x11
#set output 'stephist.png'
plot 'step_dist_prep' u 1:2 w points t "Stepsize"





