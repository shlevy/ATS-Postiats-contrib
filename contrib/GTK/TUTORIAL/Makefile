#
#
# A Simple Makefile
#
#

######

ATSHOMEQ="$(ATSHOME)"

######

ATSCC=$(ATSHOMEQ)/bin/atscc
ATSDOC=$(ATSHOMEQ)/bin/atsdoc

######

DBSRC= \
  chap_start_atxt.db \
  chap_hello_atxt.db \
  chap_boxpack_atxt.db \

######

all:: html

######

pdf: main.db $(DBSRC) ; jw -b pdf --output PDF/ main.db
html: main.db $(DBSRC) ; jw -b html --output HTML/ main.db

######

chap_start.exe: \
  chap_start_atxt.dats; $(ATSCC) -D_ATS_GCATS -o $@ $< -latsdoc
chap_start_atxt.dats: \
  ATEXT/chap_start.atxt; $(ATSDOC) --outcode $@ -i $< > chap_start_atxt.txt
chap_start_atxt.db: chap_start.exe ; ./chap_start.exe > $@
clean:: ; $(RMF) chap_start.exe
cleanall:: ; $(RMF) chap_start_atxt.*

######

chap_hello.exe: \
  chap_hello_atxt.dats; $(ATSCC) -D_ATS_GCATS -o $@ $< -latsdoc
chap_hello_atxt.dats: \
  ATEXT/chap_hello.atxt; $(ATSDOC) --outcode $@ -i $< > chap_hello_atxt.txt
chap_hello_atxt.db: chap_hello.exe ; ./chap_hello.exe > $@
clean:: ; $(RMF) chap_hello.exe
cleanall:: ; $(RMF) chap_hello_atxt.*

######

chap_boxpack.exe: \
  chap_boxpack_atxt.dats; $(ATSCC) -D_ATS_GCATS -o $@ $< -latsdoc
chap_boxpack_atxt.dats: \
  ATEXT/chap_boxpack.atxt; $(ATSDOC) --outcode $@ -i $< > chap_boxpack_atxt.txt
chap_boxpack_atxt.db: chap_boxpack.exe ; ./chap_boxpack.exe > $@
clean:: ; $(RMF) chap_boxpack.exe
cleanall:: ; $(RMF) chap_boxpack_atxt.*

######

upload:: upload_html
upload_html: html; scp -r HTML/*.html \
  ats-hwxi,ats-lang@web.sourceforge.net:htdocs/DOCUMENT/ATS2GTK/HTML

######

upload_code: ; \
scp -r CODE/Makefile CODE/*.dats \
  ats-hwxi,ats-lang@web.sourceforge.net:htdocs/DOCUMENT/ATS2GTK/CODE
upload_image: ; scp -r IMAGE/*.png \
  ats-hwxi,ats-lang@web.sourceforge.net:htdocs/DOCUMENT/ATS2GTK/IMAGE

######

RMF=rm -f

######

clean:: ; $(RMF) *~
clean:: ; $(RMF) *_?ats.c *_?ats.o

cleanall:: clean
cleanall:: ; $(RMF) HTML/*.html

###### end of [Makefile] ######
