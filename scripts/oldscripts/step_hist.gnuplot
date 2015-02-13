data = "steps_dist"

bin_width=0.01

bin_number(x)=floor(x/bin_width)
rounded(x) = bin_width*(bin_number(x))

set output "| head -n -2 > stepstemp.dat"
set table
plot ejectiondata u (scale*rounded($1)):(1) smooth frequency
unset table

