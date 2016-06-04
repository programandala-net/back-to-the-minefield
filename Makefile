# 2016-06-04: Start.

.PHONY: all
all: campo_de_minas.tap

clean:
	rm campo_de_minas.tap

campo_de_minas.tap: campo_de_minas.bas
	zmakebas -n cdm -a @start -l -o $@ $<
