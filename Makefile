# Makefile
#
# This file is part of
# Regreso al campo de minas
# By Marcos Cruz (programandala.net)

# ==============================================================
# Requirements

# The following programs must be installed in your system:

# Pasmo (by Julián Albo)
# http://pasmo.speccy.org/

# tap2dsk from Taptools (by John Elliott)
# http://www.seasip.info/ZX/unix.html

# zmakebas (by Russell Marks)
# Version 1.2 is a package of Debian, Raspbian, Ubuntu and probably other distros.
# Version 1.1 can be found here:
# http://web.archive.org/web/20080525213938/http://rus.members.beeb.net/zmakebas.html
# ftp://ftp.ibiblio.org/pub/Linux/system/emulators/zx/
#
# Version by Antonio Villena (with fixed DEF FN):
# http://sourceforge.net/p/emuscriptoria/code/HEAD/tree/desprot/ZMakeBas.c

# ==============================================================
# History

# 2016-06-04: Start.
#
# 2016-06-06: Update.
#
# 2016-06-07: Update.
#
# 2016-06-09: Improve with UDG defined in Z80 source. Create also a DSK disk
# image for +3.
#
# 2016-06-13: Use start line 1 and increment 1.
#
# 2016-06-19: Update: the source has been converted to Vimclair BASIC.

# ==============================================================

.PHONY: all
all: tap dsk

.PHONY: tap
tap: media/regreso_al_campo_de_minas.tap

.PHONY: dsk
tap: media/regreso_al_campo_de_minas.dsk

clean:
	rm -f media/*
	rm -f tmp/*

tmp/udg.tap: udg.z80s
	pasmo --name UDG.BIN --tap $< $@ 

tmp/main.tap: regreso_al_campo_de_minas.vbas
	vbas2tap $< ;\
	mv regreso_al_campo_de_minas.bas tmp/main.bas;\
	mv regreso_al_campo_de_minas.tap $@

media/regreso_al_campo_de_minas.tap: tmp/main.tap tmp/udg.tap
	cat $^ > $@

media/regreso_al_campo_de_minas.dsk: media/regreso_al_campo_de_minas.tap
	tap2dsk -180 -label RACDM $< $@
