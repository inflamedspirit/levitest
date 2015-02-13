#!/bin/bash

./levi parameters.levi.1 > out
gnuplot -persist <<EOF
plot 'out' u 1:2 w l
EOF