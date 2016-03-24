FCOMP ?= PGI
ACC ?= t

ifeq ($(FCOMP),PGI)
  #PGI
  #F90     = ftn
  #FFLAGS  = -module build -Ibuild -acc -Minfo=acc -ta=nvidia
  F90     = pgf95

  ifdef ACC
    #FFLAGS  = -module build -Ibuild -acc -Minfo=acc -Mcuda=cuda7.0 -ta=nvidia:maxwell,managed
    FFLAGS  = -module build -Ibuild -acc -Minfo=acc -Mcuda=cuda7.0 -ta=nvidia:maxwell
  else
    FFLAGS  = -module build -Ibuild -g -O0
  endif

else ifeq ($(FCOMP),GNU)
  #GNU
  F90     = gfortran
  FFLAGS  = -Ibuild -Jbuild -g -Wall -Wno-unused-dummy-argument -O0 -fbounds-check -fbacktrace -Wuninitialized -Wunused -ffpe-trap=invalid,zero,overflow,underflow -finit-real=snan

else ifeq ($(FCOMP),Cray)
  #Cray
  F90     = ftn
  FFLAGS  = -Ibuild -Jbuild -h msgs -h acc -lcudart
 
else
  $(error ERROR: compiler $(FCOMP) invalid)
endif

all: t1.exe

#
# rules
#

%.exe: %.f90 build/bl_types.o build/bl_constants.o build/vddot.o build/idamax.o build/dscal.o build/daxpy.o build/dgefa.o build/dgesl.o build/bdf.o 
	$(F90) $(FFLAGS) $^ -o $@

build/%.o: %.f
	@mkdir -p build
	$(F90) -c $(FFLAGS) $^ -o $@

build/%.o: %.f90
	@mkdir -p build
	$(F90) -c $(FFLAGS) $^ -o $@

clean: 
	rm -rf build
	rm -f *.o
	rm -f t1.exe
