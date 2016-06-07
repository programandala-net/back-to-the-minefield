# Makefile
#
# This file is part of
# Regreso al campo de minas
# By Marcos Cruz (programandala.net)

# 2016-06-04: Start.
# 2016-06-06: Update.
# 2016-06-07: Update.

.PHONY: all
all: regreso_al_campo_de_minas.tap

clean:
	rm regreso_al_campo_de_minas.tap

regreso_al_campo_de_minas.zmakebas: regreso_al_campo_de_minas.bas
	cp -f $< $@
	vim --noplugin $@ -S preprocess.vim

regreso_al_campo_de_minas.tap: regreso_al_campo_de_minas.zmakebas
	zmakebas -n cdm -a 1 -l -o $@ $<
