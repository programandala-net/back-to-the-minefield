" translate_chars.vim
"
" This file is part of
" Regreso al campo de minas
" By Marcos Cruz (programandala.net)
"
" 2016-06-06: Start. Translate Spanish characters.
" 2016-06-07: Shorten variable names. Add file header. Remove comments.
" 2016-06-08: Remove indented comments.

set nomore

" Convert Latin1 chars to UDG notation

%substitute,�,\\A,gIe
%substitute,�,\\B,gIe
%substitute,�,\\C,gIe
%substitute,�,\\D,gIe
%substitute,�,\\E,gIe
%substitute,�,\\F,gIe
%substitute,�,\\G,gIe
%substitute,�,\\H,gIe
%substitute,�,\\I,gI
%substitute,�,\\J,gIe
%substitute,�,\\K,gIe
%substitute,�,\\L,gIe
%substitute,�,\\M,gIe
%substitute,�,\\N,gIe
%substitute,�,\\O,gIe
%substitute,�,\\P,gIe
"%substitute,�,\\Q,gIe
%substitute,�,\\R,gIe
%substitute,�,\\S,gIe

" Shorten string variable names

%substitute,\<blank_row\$,b$,gIe
%substitute,\<record_player\$,h$,gIe
%substitute,\<replay_pause_message\$,m$,gIe
%substitute,\<protagonist\$,p$,gIe
%substitute,\<protagonist_with_damsel\$,q$,gIe
%substitute,\<safe_zone\$,s$,gIe
%substitute,\<blank_safe_zone\$,u$,gIe
%substitute,\<version\$,v$,gIe

" Shorten numeric variable names

%substitute,\<border_color\>,bc,gIe
%substitute,\<back_surrounding_mines\>,bsm,gIe
%substitute,\<damsel_1_col\>,d1c,gIe
%substitute,\<damsel_2_col\>,d2c,gIe
%substitute,\<damsels_row\>,dr,gIe
%substitute,\<first_level\>,fl,gIe
%substitute,\<front_surrounding_mines\>,fsm,gIe
%substitute,\<ink_color\>,ic,gIe
%substitute,\<last_level\>,ll,gIe
%substitute,\<left_surrounding_mines\>,lsm,gIe
%substitute,\<right_surrounding_mines\>,rsm,gIe
%substitute,\<surrounding_mines\>,sm,gIe
%substitute,\<paper_color\>,pc,gIe
%substitute,\<paused_replay\>,pr,gIe

" Remove underscore from remaining variables and labels (zmakebas does not
" accept them, though the manual says only colon and space are forbidden):

%substitute,\(\a\)_\(\a\|\d\),\1\U\2,ge

" Reduce the length of labels to the maximum allowed by zmakebas, just in
" case:

%substitute-@\([^: ]\+\)\>-\='@'.strpart(submatch(1),0,16)-ge

" Remove comments

%substitute,^\s*#.*\n,,

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
