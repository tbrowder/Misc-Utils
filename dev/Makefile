PROG = ../bin/create-md.p6
MFIL = ../lib/Misc/Utils.pm6
TDIR = ../docs
BDIR = ../bin

create: subs
#create: progs
#create: subs progs

subs:
	$(PROG) -m $(MFIL) -d $(TDIR)

progs:
	$(PROG) -b $(BDIR) -d $(TDIR) -D
