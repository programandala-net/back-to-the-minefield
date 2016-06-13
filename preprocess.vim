" translate_chars.vim
"
" This file is part of
" Regreso al campo de minas
" By Marcos Cruz (programandala.net)
"
" 2016-06-06: Start. Translate Spanish characters.
" 2016-06-07: Shorten variable names. Add file header. Remove comments.
" 2016-06-08: Remove indented comments.
" 2016-06-12: Update.
" 2016-06-13: Update.

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

" Shorten string variable names

%substitute,\<blank_row\$,b$,gIe
%substitute,\<fence\$,f$,gIe
%substitute,\<record_player\$,h$,gIe
%substitute,\<replay_controls\$,m$,gIe
%substitute,\<protagonist\$,p$,gIe
%substitute,\<protagonist_with_damsel\$,q$,gIe
%substitute,\<safe_zone\$,s$,gIe
%substitute,\<trail\$,t$,gIe
%substitute,\<blank_field_row\$,u$,gIe
%substitute,\<version\$,v$,gIe
%substitute,\<message\$,w$,gIe

" Shorten for-next variable names
%substitute,\<miner_col\>,i,gIe

" Shorten numeric variable names

%substitute,\<border_color\>,bc,gIe
%substitute,\<bottom_fence_row\>,bfr,gIe
%substitute,\<back_surrounding_mines\>,bsm,gIe
%substitute,\<bottom_safe_row\>,bsr,gIe
%substitute,\<door_col\>,dc,gIe
%substitute,\<damsel_1_col\>,d1c,gIe
%substitute,\<damsel_2_col\>,d2c,gIe
%substitute,\<damsels_row\>,dr,gIe
%substitute,\<first_level\>,fl,gIe
%substitute,\<front_surrounding_mines\>,fsm,gIe
%substitute,\<ink_color\>,ic,gIe
%substitute,\<last_level\>,ll,gIe
%substitute,\<mine_row\>,mr0,gIe
%substitute,\<mined_rows\>,mr1,gIe
%substitute,\<miner_row\>,mr2,gIe
%substitute,\<left_surrounding_mines\>,lsm,gIe
%substitute,\<right_surrounding_mines\>,rsm,gIe
%substitute,\<surrounding_mines\>,sm,gIe
%substitute,\<paper_color\>,pc,gIe
%substitute,\<paused_replay\>,pr,gIe
%substitute,\<record\>,r,gIe
%substitute,\<score\>,s,gIe
%substitute,\<start_col\>,sc,gIe
%substitute,\<top_fence_row\>,tfr,gIe
%substitute,\<top_mined_row\>,tmr,gIe
%substitute,\<top_safe_row\>,tsr,gIe
%substitute,\<walking_mine_col\>,wmc,gIe
%substitute,\<walking_mine_row\>,wmr,gIe
%substitute,\<walking_mine_step\>,wms,gIe

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
