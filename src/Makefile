# Makefile to compile example program 'levi' on generic
#   Unix machines

# comments are on lines that begin with a '#'

.IGNORE:

SHELL = /bin/csh


# set commonds for compiling and loading
#   ifort is the Intel Fortran compiler on the cluster.
#   you could also use pgf90, another commercial compiler on the cluster,
#   or gfortran, which you can install for free on your computer.
F90 = gfortran
F90FLAGS = -O3 -g -pg -fdefault-integer-8
F90CFLAGS = -c
F90LFLAGS =

F90_COMPILE  = $(F90) $(F90FLAGS) $(F90CFLAGS)
F90_LOAD     = $(F90) $(F90FLAGS) $(F90LFLAGS)

.SUFFIXES:
.SUFFIXES: .f90 .o .mod


# these are the compilation rules; i.e., how to change a .f90 file to a .o
#   file (object code file), and how to change a .f90 file to a .mod file
#   (module information file)

.f90.o:
	$(F90_COMPILE) $*.f90
.f90.mod:
	$(F90_COMPILE) $*.f90

EXECUTABLES = levi

INSTALLED_FILES = 

# below here are listed all the dependencies; that is, before the 
#  'hosc' "target" gets compiled, first the make utility must do
#   whatever it needs to do to update the files
#   globals.mod odeab90.mod odeab_support.mod utilities.mod
#   using the above rules
#   'all' is the default here, which builds all the executables (hosc)
#  NOTE: there are tabs here that will not transfer if you copy and paste,
#   and the Makefile WILL NOT WORK if the tabs are replaced by spaces.

all: $(EXECUTABLES)

install: $(INSTALLED_FILES)
	cp $(EXECUTABLES) ../bin/

levi: levi.o globals.o utilities.o random_pl.o
	$(F90_LOAD) levi.o globals.o utilities.o random_pl.o -o levi

levi.o: globals.mod utilities.mod random_pl.mod
utilities.mod: globals.mod
random_pl: globals.mod

# this is what to do when you type "make clean"

clean:
	rm -f *.o *.mod *.d $(EXECUTABLES)

