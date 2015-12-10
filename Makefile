
F90     = pgf95
#FFLAGS  = -Ibuild -Jbuild -g -Wall -Wno-unused-dummy-argument
FFLAGS  = -module build -Ibuild -acc -Minfo=acc -g

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
