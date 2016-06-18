rem Regreso al campo de minas
#
#   "Campo de minas" was published by Indescomp. It was the Spanish
#   version of "Minefield", written by Ian Andrew.
#
#   This is a fork under development
rem by Marcos Cruz (programandala.net), 2016.
#
#   This source is in the zmakebas format of Sinclair BASIC, with
#   extended features (e.g. long string variable names).

# ==============================================================

border 0: paper 0: ink 0: flash 0: inverse 0: bright 0:\
clear 65535-21*8*2-8:\

let version$="0.49.0+201606181512":\

goto @init

# Note: version number after Semantic Versioning: http://semver.org

# ==============================================================
# Functions

deffn random_row()=int(rnd*mined_rows)+top_mined_row

deffn random_col()=int(rnd*30)+1

# ==============================================================
# Start a new game

@new_game:

let level=first_level:\
let score=0

# ==============================================================
# Enter a new level

@new_level:

gosub @select_graphics

let surrounding_mines=0:\
let door_closed=0

# coordinates
let row=bottom_fence_row:\
let col=start_col:\
let old_row=row:\
let old_col=col

# list of coordinates, stored as chars
let trail$=chr$ row+chr$ col

# counter
let time=0

dim protagonist$(2):\
let protagonist$="\d\e":\
let protagonist_frame=0:\
let flower$="\q"

# XXX OLD
# let damsels_row=0:\
# let damsel_1_col=0:\
# let damsel_2_col=0

let walking_mine_step=-1:\
let walking_mine_row=row:\
let walking_mine_col=col:\
let pa=7:\
let ss=0

let paper_color=7-level:\
let border_color=0:\
let mines=32+level*4

border border_color:\
paper paper_color:\
ink ink_color:\
cls:\
gosub @no_message:\
load!"fence.scr"code

let message$="Poniendo minas...":\
gosub @message

print paper 8;bright 1;\
  at top_fence_row+1,1;safe_zone$;\
  at bottom_fence_row-1,1;safe_zone$

for w=1 to mines:\
  print\
    at fn random_row(),fn random_col();\
    ink paper_color;mine_udg$:\
  beep .0015,35:\
next w

print paper 8;\
  at top_fence_row+1,1;blank_field_row$;\
  at bottom_fence_row-1,1;blank_field_row$

gosub @no_message:\
gosub @new_status_bar

if level=first_level then\
  goto @l480
if level=last_level then\
  gosub @last_level: goto @l480

# XXX REMARK -- levels second..last_but_one:
# XXX TODO -- move to a subroutine
# XXX TODO -- store the position of the flowers, in order
# to restore them before the replay
let flowers=int(rnd*level)+1:\
for i=1 to flowers:\
  print at fn random_row(),fn random_col();flower$:\
next i:\

@l480:

if level=(last_level-1) then\
  gosub @close_the_door

beep .0875,10

# XXX OLD
# gosub @select_chars
# print at 21,4; inverse 1;"¡Adelante!"
# gosub @select_graphics

for n=1 to 20
  beep .002,n+20
next n
#print at 21,4;"         ": beep .05,37
goto @l535

@l500:

let old_row=row: let old_col=col

@l520:

let i$=inkey$
let row=row+(i$=k$(4))-(i$=k$(3))
let row=row-(row=(bottom_fence_row+1))
let col=col+(i$=k$(2))-(i$=k$(1))

# XXX TODO -- remove
let time=time+1

# XXX TODO -- improve or remove
# if level>=4 then\
#   if time>(260*paper_color+70) then\
#     if int (time/(3*paper_color+1))=(time/(3*paper_color+1)) then\
#       gosub @walking_mine

if old_row=row and old_col=col then\
  goto @l520

beep .003,-4

@l535:

print at old_row,old_col; paper pa;" "
let trail$=trail$+chr$ row+chr$ col

# XXX TODO -- move down to save the print
if door_closed then\
    if row=key_row then\
      if col=key_col then\
        print at row,col; paper pa;protagonist$(protagonist_frame+1):\
        let protagonist_frame=not protagonist_frame:\
        gosub @open_the_door:\
        goto @step_done

# make the first UDG bank the current font, in order to detect
# the graphics with `screen$()`:
poke 23606,udg1_font_low:poke 23607,udg1_font_high:\

let found_char=code screen$(row,col):\
let front_surrounding_mines=screen$(row-1,col)=mine_char$:\
let back_surrounding_mines=screen$(row+1,col)=mine_char$:\
let left_surrounding_mines=screen$(row,col-1)=mine_char$:\
let right_surrounding_mines=screen$(row,col+1)=mine_char$:\

# restore the default font:
poke 23606,0:poke 23607,60

# mine?
if found_char=mine_char then\
  goto @explosion

# fence?
if found_char=fence_char then\
  goto @explosion

# flower?
if found_char=flower_char then\
  gosub @pick_flower

print at row,col; paper pa;protagonist$(protagonist_frame+1):\
let protagonist_frame=not protagonist_frame:\

@step_done:

# XXX REMAK -- There's a bug in Sinclar BASIC: the following
# calculation returns a wrong non-integer value:

# let surrounding_mines=int(\
#   (screen$ (row-1,col)<>" ")+\
#   (screen$ (row+1,col)<>" ")+\
#   (screen$ (row,col-1)<>" ")+\
#   (screen$ (row,col+1)<>" "))

# XXX REMARK -- Also this doesn't work fine:

# let surrounding_mines=(screen$ (row-1,col)<>" ")
# let surrounding_mines=surrounding_mines+(screen$ (row+1,col)<>" ")
# let surrounding_mines=surrounding_mines+(screen$ (row,col-1)<>" ")
# let surrounding_mines=surrounding_mines+(screen$ (row,col+1)<>" ")

# XXX REMARK -- This slow method works fine:

# let front_surrounding_mines=screen$ (row-1,col)<>" ":\
# let back_surrounding_mines=screen$ (row+1,col)<>" ":\
# let left_surrounding_mines=screen$ (row,col-1)<>" ":\
# let right_surrounding_mines=screen$ (row,col+1)<>" ":\
# let surrounding_mines=\
#   front_surrounding_mines+\
#   back_surrounding_mines+\
#   left_surrounding_mines+\
#   right_surrounding_mines:\

let surrounding_mines=\
  front_surrounding_mines+\
  back_surrounding_mines+\
  left_surrounding_mines+\
  right_surrounding_mines:\
gosub @print_surrounding_mines:\
beep .04*sgn surrounding_mines,surrounding_mines*10

if row=top_fence_row then\
  goto @level_passed

goto @l500

# ==============================================================
# subroutine: close the door

@close_the_door:

let key_row=fn random_row():\
let key_col=fn random_col():\
# XXX FIXME -- key_udg$, not found:
print at key_row,key_col;key_udg$\

let message$=\
  "Necesitas la llave para salir":\
#  <------------------------------->
gosub @message
for i=60 to 10 step -5:\
  print at top_fence_row,door_col;"   ":\
  beep .125,i:\
  print at top_fence_row,door_col;"\f\f\f":\
  for j=1 to 7: next j:\
next i:\
gosub @no_message:\
let door_closed=1:\
return

# ==============================================================
# subroutine: open the door

@open_the_door:

let message$=\
  "Puerta abierta":\
#  <------------------------------->
gosub @message:\
for i=10 to 60 step 5:\
  print at top_fence_row,door_col;"\f\f\f":\
  beep .125,i:\
  print at top_fence_row,door_col;"   ":\
  for j=1 to 7: next j:\
next i:\
gosub @no_message:\
let door_closed=0:\
return
 
# ==============================================================
# subroutine: status bar

@new_status_bar:

input ;:\
gosub @select_chars:\
print #1;paper 8;ink 9;\
  at 0, 0;"Nivel";\
  at 0, 6;"Minas vecinas";\
  at 0,20;"Puntos";inverse 1;\
  at 1,20;" 0000 ";inverse 0;\
  at 0,27;"Récor";inverse 1;\
  at 1,27;" 0000":\
gosub @select_graphics

@update_status_bar:

print #1;ink 9;paper 8;inverse 1; \
  at 1,0;"  ";level;"  ";\
  at 1,24-(score>9)-(score>99)-(score>999);score;\
  at 1,31-(record>9)-(record>99)-(record>999);record

@print_surrounding_mines:

print #1; ink 9; paper detector_color(surrounding_mines+1);\
  at 1,6;"      ";surrounding_mines;"      ":\
return

# ==============================================================
# subroutine: walking mine

# XXX TODO -- improve or remove

@walking_mine:

# XXX TODO -- try, after the latest changes (2016-06-12)

print at walking_mine_row,walking_mine_col; paper pa;" "

let walking_mine_step=walking_mine_step+2:\
beep .0018,60
let walking_mine_row=code trail$(walking_mine_step):\
let walking_mine_col=code trail$(walking_mine_step+1):\
if screen$ (walking_mine_row,walking_mine_col)<>" " then\
  goto @explosion

# XXX TODO -- improve:
print at walking_mine_row,walking_mine_col; paper pa;"\h":\
return

# ==============================================================
# subroutine: pick flower

@pick_flower:

# XXX TODO --
let score=score+10
gosub @update_status_bar
return

# ==============================================================
# explosion

@explosion:

# XXX TODO -- remove mine count from the status bar

if level=last_level then\
  if row=8 and col=5+ss then\
    goto @l8444

for i=20 to 1 step -1:\
  beep .003,i: print at row,col;"\c":\
  beep .002,10: print at row,col;dead_protagonist_udg$:\
next i
beep 1.6,-35
print at row,col;mine_udg$:\
gosub @replay:\

# XXX FIXME -- only if the replay was completed:
print at row,col;dead_protagonist_udg$

beep 1,-35
if score>record then\
  gosub @new_record
gosub @update_status_bar
let message$="¿Otra vez?":\
gosub @message

# XXX OLD
@l1200:

# XXX OLD
# gosub @select_chars
# print \
#   at 21,29; paper border_color; ink 9;"   ";\
#   at 21,0; paper border_color; ink 9;" Récor = ";record;" por ";record_player$
# gosub @select_graphics

@again:
pause 0:let i$=inkey$
if i$="n" or i$="N" then cls:stop
if i$="s" or i$="S" then goto @new_game
goto @again

# ==============================================================
# subroutine: message

@message:

gosub @no_message:\
gosub @select_chars:\
print bright 1; ink 9; paper border_color;\
  at message_row,(32-len message$)/2;message$;:\
gosub @select_graphics:\
return

@no_message:

print at message_row,0;paper border_color;blank_row$;:\
return

# ==============================================================

@l8444:

gosub @the_nest
let dx=30
for u=.155 to .005 step -.01
  print at 0,dx; ink 0; paper 7;"\n "
  let dx=dx-1
  beep u,8: beep u,12: beep u,16
  border rnd*7
next u
for n=1 to 16
  print at 0,dx; ink 0; paper 7;"\n "
  let dx=dx-1+(dx=0)
  beep u+.005,8
  border rnd*7
  beep u+.005,12: beep u,16
next n
print at 0,0; paper 7;" "
for t=0 to 2
  for l=0 to 7 step 7
    ink l: gosub @l8450
  next l
next t
ink 0
gosub @the_nest
print at 0,0; ink 7; paper 0;"   ¡Dos mil puntos extra!       "
let score=score+2000
for b=0 to 7
  paper b: ink 9
  print at row,col;protagonist$(protagonist_frame+1):\
  let protagonist_frame=not protagonist_frame
  for n=1 to 14
    beep .002,50-n+b
    border 1: border 2: border 3: border 4
    border 5: border 6: border 7: border b
  next n
next b
border 0: paper 0: cls
for n=0 to 30 step 6
  for m=1 to 10
    beep .008,n+m
  next m
next n
#  <------------------------------>
print at 3,8;\
  "¡Felicidades!"
#  <------------------------------>
print '\
  "Has rescatado a Bill. El mundo"'
  "te está agradecido."
#  <------------------------------>
print ''''';\
  "Puntuación: ";score;"."
#  <------------------------------>
print\
  "¿Por qué no vuelves a jugar y"'
  "tratas de mejorarla?"
#  <------------------------------>
if score>record then\
  gosub @new_record

goto @l1200

# ==============================================================
# subroutine: replay

@replay:

# XXX FIXME -- remove the surrounding mines

# XXX TODO -- 
# print at walking_mine_row,walking_mine_col;" ";\
#       at row,col;" "

for i=1 to 21:\
  print at i,0; over 1;paper paper_color;ink 9;blank_row$:\
next i
gosub @select_chars

let paused_replay=0:\
gosub @show_replay_bar
gosub @select_graphics
for n=1 to 100: next n

let row=code trail$(1):\
let col=code trail$(2)

for t=1 to len trail$ step 2

@replay_control:
  let i$=inkey$
  if paused_replay then \
    let paused_replay=(i$=""):\
    beep .1*not paused_replay,0:\
    if paused_replay then \
      gosub @show_replay_bar:\
      goto @replay_control
  if i$="f" or i$="F" then\
    goto @replay_end
  if i$="p" or i$="P" then\
    let paused_replay=1:\
    beep .1,10:\
    gosub @show_replay_bar

  print at row,col; paper 7;" "
  let row=code trail$(t):\
  let col=code trail$(t+1):\
  print at row,col; paper 7;protagonist$(protagonist_frame+1):\
  let protagonist_frame=not protagonist_frame
  beep .005,5+(t*40/(len trail$))

next t

@replay_end:

gosub @no_message:\
return

@show_replay_bar:

let message$=replay_controls$(paused_replay+1):\
  gosub @message:\
return

# ==============================================================
# subroutine: level passed

@level_passed:

let surrounding_mines=0:\
gosub @print_surrounding_mines

# XXX TODO -- improve time score with the frames system variable

let time_score=(int ((2000-time)/50))*5
let time_score=time_score*(time_score>=50)+50*(time_score<50)
let time_score=time_score*level

# XXX TODO --
#restore @applause_sound:\
#gosub @sound

for i=1 to 8:\
  print at row,col;protagonist$(1):\
  if inkey$<>"" then goto @level_replay
#  for j=1 to 100:next j
  beep .1,0:\
  print at row,col;protagonist$(2):\
  beep .1,10:\
  if inkey$<>"" then goto @level_replay
next i

@level_replay:

# XXX TODO --
#restore @no_sound:\
#gosub @sound

print at row,col;paper pa;" "

gosub @replay

for i=4 to 22 step 6:\
  beep .005,i+24:\
next i

for i=1 to 8:\
  for j=1 to 6:\
    print at message_row,0;paper j;blank_row$;:\
    border j:\
  next j:\
next i:\
print at message_row,0;paper 0;blank_row$;:\
border border_color

# XXX TODO -- variable to flash the score
let score=score+time_score+mines:\
gosub @update_status_bar

let level=level+1:\
goto @new_level

# ==============================================================
# subroutine: new record

@new_record:

# XXX TMP --
let record=score:return

# XXX TODO -- rewrite:

for n=1 to 50
  border 1: border 2: border 3: border 4
next n
for n=1 to 50
  border 6: border 2: beep .002,40+(n/10): border 6
next n
gosub @select_chars
for m=1 to 4
  for n=7 to 0 step -1
    print at 10,7; ink n;"¡Un nuevo récor!"
    beep .004,50-n
  next n
next m
print at 10,7; ink 9;"¡Un nuevo récor!"
gosub @select_graphics

# XXX TODO -- adapt

print at 21,0;\
  flash 1; paper 1; ink 7;\
  "Introduce tus iniciales"; flash 0;"         "

let record_player$="   "
for n=1 to 3
  @l5088:
  let record_player$(n)=inkey$
  if record_player$(n)=" " then\
    goto @l5088
  if record_player$(n)>="a" and record_player$(n)<="z" then\
    let record_player$(n)=chr$ ((code record_player$(n))-32)
  print at 21,24+n; ink 7; paper 1;record_player$(n)
  beep .12,(n*5)+20
  for m=1 to 4: next m
next n
let record=score
for n=1 to 12
  beep .0045,-10: border 1: border 2: border 6: border 4
next n
border border_color
beep .1,8
for n=1 to 4: next n
beep .1,8: beep .1,8: beep .1,20: beep .1,24: beep .1,18: beep .15,29
for n=1 to 7: next n
beep .12,22
for n=1 to 3: next n
beep .07,19: beep .08,17
for n=1 to 3: next n
beep .1,14: beep .1,12
print at 10,7;"                  "
return

# ==============================================================
# subroutine

@l8450:

# XXX TODO -- simpler

for n=1 to 5
  print at row+n,col+n;"*"
  print at row-n,col+n;"*"
  print at row+n,col-n;"*"
  print at row-n,col-n;"*"
next n
for n=1 to 5
  print at row,col+n;">"
  print at row,col-n;"<"
  print at row+n,col;"#"
  print at row-n,col;"#"
next n
return

# ==============================================================
# init

@init:

# Graphics

# There are two UDG banks: for graphics (udg1) and 
# for the Spanish characters (udg2).

let udg1=65535-21*8*2:\
let udg2=udg1+21*8:\
load "UDG.BIN" code udg1-8
let udg1_font=udg1-256-8:\
let udg1_font_high=int(udg1_font/256):\
let udg1_font_low=udg1_font-(udg1_font_high*256)

# Constants

let first_level=2:rem XXX TMP -- change for debugging -- default=1
let last_level=7

let message_row=0:\
let top_fence_row=1:\
let bottom_fence_row=21:\
let top_safe_row=top_fence_row+1:\
let top_mined_row=top_safe_row+1:\
let bottom_safe_row=bottom_fence_row-1:\
let mined_rows=bottom_safe_row-top_safe_row-1:\
let door_col=14:\
let start_col=15

dim replay_controls$(2,27):\
let replay_controls$(1)="REPETICIÓN:  [P]ausa  [F]in":\
let replay_controls$(2)="Una tecla para seguir"

let blank_row$="                                "

let dead_protagonist_udg$="\l":\
let mine_udg$="\o":\
let mine_char$="/":\
let bill_udg$="\n":\
let fence_char=38:\
let bill_char=46:\
let mine_char=47:\
let key_char=48:\
let flower_char=49

let fence$="\f\f\f\f\f\f\f\f\f\f\f\f\f\f   \f\f\f\f\f\f\f\f\f\f\f\f\f\f\f"

let safe_zone$      ="<<<<<<<< ZONA SEGURA >>>>>>>>>":\
let blank_field_row$="                              "

let ink_color=9

let k$=chr$ 8+chr$ 9+chr$ 11+chr$ 10:rem cursor keys

dim detector_color(4):\
let detector_color(1)=4:\
let detector_color(2)=5:\
let detector_color(3)=6:\
let detector_color(4)=2

# Variables

let record_player$="IAN":\
let record=250

# Files

gosub @select_graphics:\
print at top_fence_row,0;fence$:\
for n=top_safe_row to bottom_safe_row:\
  print at n,0;"\f                              \f":\
next n:\
print at bottom_fence_row,0;fence$:\
save!"fence.scr"code 16384,6144

# ==============================================================
# XXX TMP -- tests

# let time=100
# let level=2
# goto @level_passed

# rem --------------------------------
# paper 2
# ink 7
# print at 15,15;mine_udg$;" (mine)=";
# gosub @graphics_font
# let tmp= code screen$(15,15)
# gosub @default_font
# print tmp

# print at 16,15;"  (space)=";
# gosub @graphics_font
# let tmp= code screen$(16,15)
# gosub @default_font
# print tmp

# stop



# ==============================================================
# menu

# XXX TODO -- complete

@menu:

border 1: paper 1: ink 7
cls
gosub @title

gosub @select_chars

#  <------------------------------>
print '\
  "________________________________"''\
  inverse 1;"I";inverse 0;"nstrucciones"''\
  inverse 1;"J";inverse 0;"ugar"''\
  inverse 1;"C";inverse 0;"réditos"''\
  "________________________________"\
#  <------------------------------>

@menu_key:

pause 0:let i$=inkey$

if i$="i" or i$="I" then\
  gosub @instructions:\
  goto @menu

if i$="j" or i$="J" then\
  goto @new_game

if i$="c" or i$="C" then\
  gosub @credits:\
  goto @menu

beep .1 ,23:\
goto @menu_key

# ==============================================================
# subroutine: credits

@credits:

cls
gosub @title
print
gosub @select_chars
#      <------------------------------>
print "Versión ";version$
print
print "Una reescritura de:"
print
print "  Minefield,"
print "    escrito por Ian Andrew, 198x"
print "  Campo de minas,"
print "    traducido por Indescomp,"
print "    198x"
print
print "Por Marcos Cruz"
print "(programandala.net), 2016"
#      <------------------------------>

pause 0
gosub @select_graphics
return

# ==============================================================
# subroutine: instructions

@instructions:

cls
gosub @title
let i$="\a":gosub @icon
#     <------------------------------>
print " Tú: Atraviesa los campos"
#      <------------------------------>
print "  de minas, usando el cursor."

let i$="\n":gosub @icon
#     <------------------------------>
print " Bill el gusano: Está en el úl-"
#      <------------------------------>
print "  timo campo. Rescátalo."

let i$="\o":gosub @icon
#     <------------------------------>
print " Minas: En la parte superior"
#      <------------------------------>
print "  verás cuántas te rodean."

let i$="\d\e":gosub @icon
#    <------------------------------>
print " Damiselas: Cuentan como minas"
#      <------------------------------>
print "   pero dan puntos."

let i$="\h":gosub @icon
#     <------------------------------>
print " La mina con patas:"
#      <------------------------------>
print "  Te perseguirá sin descanso."

let i$="\f":gosub @icon
#     <------------------------------>
print " Verja: Está electrificada y"
#      <------------------------------>
print "  cuenta como una mina."

let i$="\m":gosub @icon
#     <------------------------------>
print " Minadores: ponen minas pero"
#      <------------------------------>
print "  también las quitan."

pause 0
gosub @select_graphics
return

# ==============================================================
# subroutine: title

@title:

#      <------------------------------>
print "   REGRESO AL CAMPO DE MINAS"
return

# ==============================================================
# subroutine: icon

# Input:
# i$ = UDG string

@icon:
gosub @select_graphics:\
print 'bright 1;i$;:\
goto @select_chars

# ==============================================================
# subroutine: select user defined graphics

@select_graphics:

randomize udg1:\
poke 23675,peek 23670:poke 23676,peek 23671:\
randomize:\
return

# ==============================================================
# subroutine: select user defined characters

@select_chars:

randomize udg2:\
poke 23675,peek 23670:poke 23676,peek 23671:\
randomize:\
return

# ==============================================================
# subroutine: the_nest

@the_nest:

print at 4,4+ss;"\ :";\
      at 4,6+ss;"\: ";\
      at 5,4+ss;"\ :";\
      at 5,6+ss;"\: ";\
      at 6,4+ss;"\ :";\
      at 6,6+ss;"\: ";\
      at 7,1+ss;"\..\..\..\..";\
      at 7,6+ss;"\..\..\..\..";\
      at 9,1+ss;"\''\''\''\''";\
      at 9,6+ss;"\''\''\''\''";\
      at 10,4+ss;"\ :";\
      at 10,6+ss;"\: ";\
      at 11,4+ss;"\ :";\
      at 11,6+ss;"\: ";\
      at 12,4+ss;"\ :";\
      at 12,6+ss;"\: ":\
return

# ==============================================================
# subroutine: last level

# XXX TODO -- rewrite
# XXX FIXME --

@last_level:

let ss=int (rnd*11)+6
beep .3,-12

print at top_fence_row,door_col;"\f\f\f"

beep .3,-12
for n=0 to 1:\
  for m=0 to 6:\
    border n: beep .003,n*m: border m: beep .002,30+n+m*2:\
  next m:\
next n
border 2: flash 1
for n=0 to 9:\
  print at n+3,ss+1; paper paper_color; ink paper_color;"         ":\
next n
flash 0

for n=2 to -1 step -1
  beep .003,27-n: beep .003,19-n: beep .003,29-n
  if n>=0 then\
    ink n
  if n=-1 then\
    flash 1: bright 0
  gosub @the_nest
next n
print at 11,5+ss; ink paper_color; paper paper_color;mine_udg$
flash 0
print at 8,5+ss; flash 0;bill_udg$
return

# ==============================================================
# Sounds

# XXX TODO --

@sound:
for i=0 to 13:\
  read d: out 65333,i: out 49149,d:\
next i:\
return

@applause_sound:
data 0,0,0,0,0,0,30,64,15,16,15,0,7,24

@no_sound:
data 0,0,0,0,0,0,0,0,0,0,0,0,0,0

# vim: ft=sinclairbasic:fileencoding=latin1
