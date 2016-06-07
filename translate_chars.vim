" translate_chars.vim
"
" This file is part of
" Regreso al campo de minas
" By Marcos Cruz (programandala.net)
"
" 2016-06-06: Start.

set nomore

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

write
quit
