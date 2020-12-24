# Makefile
#
# This file is part of
# Back to the minefield
# By Marcos Cruz (programandala.net)

# Last modified 202012241631
# See change log at the end of the file

# ==============================================================
# Requirements

# The following programs must be installed in your system:

# Asciidoctor (by Dan Allen, Sarah White et al.)
# http://asciidoctor.org

# Pasmo, by Julián Albo
# http://pasmo.speccy.org/

# Vimclair BASIC, by Marcos Cruz (programandala.net)
# http://programandala.net/en.program.vimclair_basic.html

# ==============================================================
# Main {{{1

.PHONY: all
all: target/back_to_the_minefield.tap wwwdoc

clean:
	rm -f target/* tmp/*

# ==============================================================
# Create a TAP file {{{1

tmp/udg.tap: src/udg.z80s
	pasmo --name UDG.BIN --tap $< $@ 

tmp/main.tap: src/back_to_the_minefield.vbas
	vbas2tap $< ;\
	mv src/back_to_the_minefield.bas tmp/main.bas;\
	mv src/back_to_the_minefield.tap $@

target/back_to_the_minefield.tap: tmp/main.tap tmp/udg.tap
	cat $^ > $@

# ==============================================================
# Online documentation {{{1

# Online documentation displayed on the Fossil repository.

.PHONY: wwwdoc
wwwdoc: wwwreadme

.PHONY: cleanwww
cleanwww:
	rm -f \
		doc/www/* \
		tmp/README.*

.PHONY: wwwreadme
wwwreadme: doc/www/README.html

doc/www/README.html: tmp/README.html
	echo "<div class='fossil-doc' data-title='README'>" > $@;\
	cat $< >> $@;\
	echo "</div>" >> $@

tmp/README.html: README.adoc
	asciidoctor \
		--embedded \
		--out-file=$@ $<

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
#
# 2019-03-10: Update after the renaming of the project.
#
# 2019-03-12: Make the TAP in the target directory.
#
# 2020-12-24: Online documentation.
