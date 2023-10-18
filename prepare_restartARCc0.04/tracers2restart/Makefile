.SUFFIXES: .o .f90 .F90  # any suffix used in suffix rule should be declared

  FC      = /opt/intel/composer_xe_2013_sp1.2.144/bin/intel64/ifort
  FFLAGS  = -convert big_endian -O3
#  IOLIBS = -L/opt/hpc/intel13/lib64 -lnetcdf -lnetcdff -limf -lm
  IOLIBS = -L/opt/intel/composer_xe_2013_sp1.2.144/compiler/lib/intel64 -limf -lm
  IOINCS = -I/opt/intel/composer_xe_2013_sp1.2.144/compiler/include

# ---------------------
# LIBRARIES
# ---------------------
  LIBS  = $(IOLIBS)

  INCS  = $(IOINCS)

PRGRM  = tracers2restart.F90

MODS   = utils.F90 interp.F90

SRCS   = $(MODS) $(PRGRM)

OBJS   = $(SRCS:.F90=.o) 

EXEC   = trcRST.x

.F90.o:
	$(FC) -c $(FFLAGS) $(INCS) $<

$(EXEC):  $(OBJS)
	$(FC) $(OBJS) $(LIBS) -o $(EXEC)

all: $(EXEC) 

clean:
	/bin/rm -f *.o *.mod ${EXEC}

#all: clean make
