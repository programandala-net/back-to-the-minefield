" translate_chars.vim
"
" This file is part of
" Regreso al campo de minas
" By Marcos Cruz (programandala.net)
"
" 2016-06-06: Start. Translate Spanish characters.
" 2016-06-07: Shorten variable names. Add file header.

set nomore

" Convert Latin1 chars to UDG notation

%substitute,á,\\A,gIe
%substitute,Á,\\B,gIe
%substitute,é,\\C,gIe
%substitute,É,\\D,gIe
%substitute,í,\\E,gIe
%substitute,Í,\\F,gIe
%substitute,ó,\\G,gIe
%substitute,Ó,\\H,gIe
%substitute,ú,\\I,gI
%substitute,Ú,\\J,gIe
%substitute,ñ,\\K,gIe
%substitute,Ñ,\\L,gIe
%substitute,ü,\\M,gIe
%substitute,Ü,\\N,gIe
%substitute,¿,\\O,gIe
%substitute,¡,\\P,gIe
"%substitute,º,\\Q,gIe
%substitute,«,\\R,gIe
%substitute,»,\\S,gIe

" Convert long string variable names

%substitute,\<blank_row\$,b$,gIe
%substitute,\<record_player\$,h$,gIe
%substitute,\<protagonist\$,p$,gIe
%substitute,\<protagonist_with_damsel\$,q$,gIe
%substitute,\<safe_zone\$,s$,gIe
%substitute,\<blank_safe_zone\$,u$,gIe
%substitute,\<version\$,v$,gIe

" Convert long numeric variable names

%substitute,\<border_color\>,bc,gIe
%substitute,\<back_surrounding_mines\>,bsm,gIe
%substitute,\<damsel_1_col\>,d1c,gIe
%substitute,\<damsel_2_col\>,d2c,gIe
%substitute,\<damsels_row\>,dr,gIe
%substitute,\<front_surrounding_mines\>,fsm,gIe
%substitute,\<ink_color\>,ic,gIe
%substitute,\<left_surrounding_mines\>,lsm,gIe
%substitute,\<right_surrounding_mines\>,rsm,gIe
%substitute,\<surrounding_mines\>,sm,gIe
%substitute,\<paper_color\>,pc,gIe

" Remove underscore from remaining variables and labels
" (zmakebas does not accept them)

%substitute,\(\a\)_\(\a\|\d\),\1\U\2,ge

" Remove comments

%substitute,^#.*\n,,

" Add header

" XXX TODO --
let s:header ="# This file was automatically generated\r"
let s:header.="# from 'regreso_al_campo_de_minas.bas'.\r\r"
let s:header.="# This file is part of\r"
let s:header.="# Regreso al campo de minas\r"
let s:header.="# By Marcos Cruz (programandala.net)\r"

%substitute,\%^,\=s:header,

write
quit
