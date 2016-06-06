# Makefile
#
# This file is part of
# Regreso al campo de minas
# By Marcos Cruz (programandala.net)

# 2016-06-04: Start.
# 2016-06-06: Update.

.PHONY: all
all: regreso_al_campo_de_minas.tap

clean:
	rm regreso_al_campo_de_minas.tap

regreso_al_campo_de_minas.tap: regreso_al_campo_de_minas.bas
	zmakebas -n cdm -a @start -l -o $@ $<
