# Makefile
#
# This file is part of
# Regreso al campo de minas
# By Marcos Cruz (programandala.net)

# ==============================================================
# Requirements

# The following programs must be installed in your system:

# Pasmo, by Julián Albo
# http://pasmo.speccy.org/

# Vimclair BASIC, by Marcos Cruz (programandala.net)
# http://programandala.net/en.program.vimclair_basic.html

# ==============================================================

.PHONY: all
all: regreso_al_campo_de_minas.tap

clean:
	rm -f *.tap
	rm -f tmp/*

tmp/udg.tap: src/udg.z80s
	pasmo --name UDG.BIN --tap $< $@ 

tmp/main.tap: src/regreso_al_campo_de_minas.vbas
	vbas2tap $< ;\
	mv src/regreso_al_campo_de_minas.bas tmp/main.bas;\
	mv src/regreso_al_campo_de_minas.tap $@

regreso_al_campo_de_minas.tap: tmp/main.tap tmp/udg.tap
	cat $^ > $@

# ==============================================================
# Change log

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
#
# 2017-12-30: Update layout.
