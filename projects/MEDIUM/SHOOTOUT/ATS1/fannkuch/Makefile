######
#
# For a SHOOTOUT/benchmark
#
######

all:: fannkuch

######

fannkuch: fannkuch.dats ; \
  patscc -DATS_MEMALLOC_LIBC -O3 -fomit-frame-pointer $< -o $@

######

RMF=rm -f

######

.phony: clean

clean:: ; $(RMF) *~
clean:: ; $(RMF) *_dats.c

cleanall:: clean
cleanall:: ; $(RMF) fannkuch

###### end of [Makefile] ######
