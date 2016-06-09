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

border 0: paper 0: ink 7:\
clear 65535-21*8*2:\

let version$="0.21.0+201606091942":\

goto @init

# Note: version number after Semantic Versioning: http://semver.org

# ==============================================================
# subroutine: calculate surrounding mines

@calculate_surrounding_mines:

# XXX FIXME -- There's a bug in Sinclar BASIC: the following
# calculation returns a wrong non-integer value:

# let surrounding_mines=int(\
#   (screen$ (row-1,col)<>" ")+\
#   (screen$ (row+1,col)<>" ")+\
#   (screen$ (row,col-1)<>" ")+\
#   (screen$ (row,col+1)<>" "))

# XXX FIXME -- Also this doesn't work fine:

# let surrounding_mines=(screen$ (row-1,col)<>" ")
# let surrounding_mines=surrounding_mines+(screen$ (row+1,col)<>" ")
# let surrounding_mines=surrounding_mines+(screen$ (row,col-1)<>" ")
# let surrounding_mines=surrounding_mines+(screen$ (row,col+1)<>" ")

# XXX REMARK -- This slow method works fine:

let front_surrounding_mines=screen$ (row-1,col)<>" ":\
let back_surrounding_mines=screen$ (row+1,col)<>" ":\
let left_surrounding_mines=screen$ (row,col-1)<>" ":\
let right_surrounding_mines=screen$ (row,col+1)<>" ":\
let surrounding_mines=\
  front_surrounding_mines+\
  back_surrounding_mines+\
  left_surrounding_mines+\
  right_surrounding_mines:
return

# ==============================================================
# Miners

# XXX TODO -- convert to a subrountine and move it down -- or remove

@miners:

let rn=int (rnd*13)+4
for a=3 to 30
  if a=10 or a=20 then next a
  if attr (rn,a)=56 then\
     goto @l115
  print at rn,a;"\m"
  @l115:

  let k=rn-1+int (rnd*3)
  if attr (k,a-1)<>56 then\
    print at k,a-1;"\o"
  beep .002,55
  if attr (rn,a)=56 then\
    goto @l150
  print at rn,a;" "
  @l150:

next a
goto @l570

# ==============================================================
# Start a new game

@new_game:

let level=first_level:\
let score=0

# ==============================================================
# Enter a new level

@new_level:

gosub @select_graphics

let surrounding_mines=0

# coordinates
let row=20: let col=15
let old_row=row: let old_col=col

# list of coordinates, stored as chars
let t$=chr$ row+chr$ col

# counter
let time=0

let protagonist$="\a"
let protagonist_with_damsel$="\b"
let damsels_row=0: let damsel_1_col=0: let damsel_2_col=0
let rr=1
let oo=20: let pp=15
let pa=7
let ss=0

let paper_color=7-level:\
let border_color=paper_color:\
let mines=32+level*8

border border_color:\
paper paper_color:\
ink ink_color:\
cls

gosub @new_status_bar
# XXX TODO -- use a constant for the top and bottom rows of the field
print at 1,0;"\f\f\f\f\f\f\f\f\f\f\f\f\f\f\f  \f\f\f\f\f\f\f\f\f\f\f\f\f\f\f"
for n=2 to 19:\
  print at n,0;"\f                              \f":\
next n
print at 20,0;"\f\f\f\f\f\f\f\f\f\f\f\f\f\f   \f\f\f\f\f\f\f\f\f\f\f\f\f\f\f"
print at row,col;protagonist$
print at 21,17; flash 1; paper 8; ink 8;"Poniendo minas"

print paper 8;bright 1; at 2,1;safe_zone$;at 19,1;safe_zone$
for w=1 to mines:\
  print at int (rnd*16)+3,int (rnd*30)+1; ink paper_color;"\o":\
  beep .0015,35:\
next w
print paper 8;at 2,1;blank_field_row$;at 19,1;blank_field_row$

print at 21,0;blank_row$

if level=first_level then\
  goto @l480
if level=last_level then\
  gosub @last_level: goto @l480

# XXX REMARK -- levels second..last_but_one:

let damsels_row=int (rnd*12)+4:\
let damsel_1_col=int (rnd*6)+6:\
let damsel_2_col=int (rnd*6)+19
for j=1 to 7
  print at damsels_row,damsel_1_col;"\d";\
        at damsels_row,damsel_2_col;"\d"
  for e=1 to 11: next e
  beep .002,58
  print at damsels_row,damsel_1_col;"\e";\
        at damsels_row,damsel_2_col;"\e"
  for e=1 to 11: next e
  beep .002,58
next j

@l480:

if level<>(last_level-1) then\
  goto @l490

# XXX REMARK -- last but one level:

# XXX TODO -- remove?
print at 21,0;\
  ink 7; flash 1; paper 0; bright 1;\
  "Ponte entre 3 minas para abrir  "
print at 1,15;"\f\f"
print at 8,9; ink 1; bright 1; paper 7;"puerta cerrada"
for m=60 to 10 step -2.5
  for n=1 to 7: next n
  beep .125,m
next m
print at 21,0;blank_row$
print at 8,9;"              "

@l490:

beep .0875,10
print at 21,31; ink paper_color; paper paper_color;"\h"

# XXX OLD
# gosub @select_chars
# print at 21,4; inverse 1;"¡Adelante!"
# gosub @select_graphics

for n=1 to 20
  beep .002,n+20
next n
print at 21,4;"         ": beep .05,37
goto @l535

@l500:

let old_row=row: let old_col=col

@l520:

let i$=inkey$
let row=row+(i$=k$(4))-(i$=k$(3))
let row=row-(row=21)
let col=col+(i$=k$(2))-(i$=k$(1))

let time=time+1

if level>=4 then\
  if time>(260*paper_color+70) then\
    if int (time/(3*paper_color+1))=(time/(3*paper_color+1)) then\
      gosub @l543

if old_row=row and old_col=col then\
  goto @l520

beep .003,-4

@l535:

print at old_row,old_col; paper pa;" "
let t$=t$+chr$ row+chr$ col
if screen$ (row,col)<>" " then\
  gosub @explosion

if level=last_level and pa<>paper_color and row<17 then\
  gosub @erase_the_path

print at row,col; paper pa;protagonist$

@l570:

gosub @update_surrounding_mines

# XXX TODO -- move up
if row=1 then\
  goto @level_passed

# XXX TODO -- improve
# XXX TODO -- remove?
if surrounding_mines=3 and level=(last_level-1) then\
  print at 8,9; flash 1;"Puerta abierta":\
  for c=1 to 40: beep .001,30+c/4:\
    border 0: border 7:\
  next c:\
  print at 1,15;"  ":\
  print at 8,9;"              ":\
  border 2

if level>2 and level<last_level and time>50 then\
  if rnd>.98 then\
    goto @miners

goto @l500

# ==============================================================
# subroutine: status bar

@new_status_bar:

input #1:\
print #1;paper 8;ink 9;\
  at 0,0;"Minas vecinas ";\
  at 0,15;"Nivel";\
  at 0,22;"Puntos";\
  at 1,22;"0000"

@update_status_bar:

print #1;ink 9;paper 8; \
  at 1,15;level;" ";\
  at 1,25-(score>9)-(score>99)-(score>999);score

@print_surrounding_mines:

print #1; ink 9; paper (4-surrounding_mines);\
  at 1,0; surrounding_mines:\
return

@update_surrounding_mines:

gosub @calculate_surrounding_mines:\
gosub @print_surrounding_mines:\
beep .04*sgn surrounding_mines,surrounding_mines*10:\
return

# ==============================================================
# subroutine

@l543:

# XXX TODO -- what for?

print at oo,pp; paper pa;" "

# XXX TODO -- why?:
let i$=t$+t$

if level>=5 and paper_color<>pa and time>2000 then\
  gosub @erase_the_path

let rr=rr+2: beep .0018,60
let oo=code i$(rr): let pp=code i$(rr+1)
if screen$ (oo,pp)<>" " then\
  gosub @explosion
print at oo,pp; paper pa;"\h"
return

# ==============================================================
# subroutine: explosion

@explosion:

# XXX TODO -- remove mine count from the status bar

# XXX TODO -- remove:
if row=damsels_row then\
  if col=damsel_1_col or col=damsel_2_col then\
    gosub @damsel_rescued: return

if level=last_level then\
  if row=8 and col=5+ss then\
    goto @l8444

for w=20 to 1 step -1
  beep .003,w: print at row,col;"\c"
  beep .002,10: print at row,col;"\o"
next w
beep 1.6,-35
gosub @replay
print at row,col; paper 7; ink 0; over 1;chr$ (65+int (rnd*60))
beep 1,-35
if score>high_score then\
  gosub @new_record
gosub @update_status_bar
gosub @select_chars
print at 10,9; ink 7; paper 2; bright 1;"  ¿Otra vez?  "
gosub @select_graphics
if paper_color>=4 then\
  ink 0
if paper_color<4 then\
  ink 7
plot 72,96: draw 112,0: draw 0,-9: draw -113,0: draw 0,9
ink 9

# XXX OLD
@l1200:

# XXX OLD
# gosub @select_chars
# print \
#   at 21,29; paper border_color; ink 9;"   ";\
#   at 21,0; paper border_color; ink 9;" Récor = ";high_score;" por ";record_player$
# gosub @select_graphics

@again:
pause 0:let i$=inkey$
if i$="n" or i$="N" then cls:stop
if i$="s" or i$="S" then goto @new_game
goto @again

# ==============================================================

@l8444:

gosub @l9300
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
gosub @l9300
print at 0,0; ink 7; paper 0;"   ¡Dos mil puntos extra!       "
let score=score+2000
for b=0 to 7
  paper b: ink 9: print at row,col;protagonist$
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
if score>high_score then\
  gosub @new_record

goto @l1200

# ==============================================================
# subroutine: replay

# XXX FIXME -- don't show the final explosion when the user quits the
# replay 
#
# XXX FIXME -- when the the protagonist has reached the door, remove
# it before the replay
#
# XXX FIXME -- remove the walking mine before the replay.

@replay:

for a=1 to 21:\
  print at a,0; over 1; ink 9;blank_row$:\
next a
gosub @select_chars
print at 21,0;flash 1; paper 7; ink 0;"Repetición"
let paused_replay=0:\
gosub @show_replay_controls
gosub @select_graphics
for n=1 to 100: next n

let row=code t$(1):\
let col=code t$(2)

for t=1 to len t$ step 2

@replay_control:
  let i$=inkey$
  if i$="f" or i$="F" then\
    goto @replay_end
  if i$="p" or i$="P" then\
    let paused_replay=not paused_replay:\
    beep .1,paused_replay*10:\
    gosub @show_replay_controls
  if paused_replay then \
    goto @replay_control

  print at row,col; paper 7;" "
  let row=code t$(t):\
  let col=code t$(t+1):\
  print at row,col; paper 7;protagonist$:\
  gosub @update_surrounding_mines:\
  if not surrounding_mines then\
    beep .005,5+(t*40/(len t$))

next t

@replay_end:

print at 21,0;blank_row$:\
return

@show_replay_controls:

print \
  at 21,9;replay_pause_message$(paused_replay+1);\
  at 21,21;"[F]inalizar":\
return

# ==============================================================
# subroutine: level passed

@level_passed:

# XXX TODO -- remove surrounding mines

# XXX TODO -- improve time score with the frames system variable

let time_score=(int ((2000-time)/50))*5
if time_score<50 then\
  let time_score=50
let time_score=time_score*level
for n=15 to 50:\
  beep .001+((50-30)/2000),(50+n/2.8):\
  border 2: border 7: border 0:\
next n
border border_color

gosub @replay

for g=4 to 22 step 6
  beep .005,g+24
next g
for n=1 to 80
  border 1: border 2: border 3: border 4: border 5: border 6
next n

# XXX TODO -- use also the mines
let score=score+time_score

gosub @update_status_bar

for n=1 to 120:\
next n

let level=level+1:\
goto @new_level

# ==============================================================
# subroutine: new record

@new_record:

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
let high_score=score
print at 21,0; paper 7; ink 0;"         muy bien  ";record_player$;"          "
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
# subroutine: damsel rescued

@damsel_rescued:

print at row,col;protagonist_with_damsel$
let protagonist$=protagonist_with_damsel$

# XXX TODO -- simplify the sound effect:

# XXX OLD:
paper 7

for u=25 to 50 step 5
  print at row,col;"\g"
  for n=1 to 8 step 2
    beep .002,n+u
    let score=score+5
    gosub @update_status_bar
  next n
  print at row,col;"\d"
  for n=1 to 8 step 2
    beep .002,n+u
  next n
next u
let time=time+35

# XXX OLD
#paper paper_color

return

# ==============================================================
# subroutine: erase the path

@erase_the_path:

# XXX TODO -- use the history instead

let pa=paper_color
print at 21,0;\
  flash 1; bright 1; paper 8; ink 8;\
  "     Tu rastro se ha borrado     "
#  <------------------------------->   

print at 20,14; paper paper_color;"   "

# XXX TODO -- use a constant for the top and bottom rows of the field
for n=19 to 2 step -.5
  beep .05,n-10
  if level<last_level or n>14 then\
    print at n,1;\
      over 1; ink paper_color; paper paper_color;\
      blank_field_row$
  print at row,col; paper pa;protagonist$
next n
print at 20,14; paper pa;"   "
print at 21,0;blank_row$
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

# There are two UDG banks, the first one for graphics and the second
# one for the Spanish characters.

let udg1=65535-21*8*2:\
let udg2=udg1+21*8:\
load "UDG.BIN" code udg1 

# Constants

let first_level=1:rem XXX TMP -- change for debugging -- default=1
let last_level=7

dim replay_pause_message$(2,11):\
let replay_pause_message$(1)="[P]ausar":\
let replay_pause_message$(2)="[P]roseguir"

let blank_row$="                                "

let safe_zone$      ="<<<<<<<< ZONA SEGURA >>>>>>>>>":\
let blank_field_row$="                              "

let ink_color=9

let k$=chr$ 8+chr$ 9+chr$ 11+chr$ 10:rem cursor keys

# Variables

let record_player$="IAN":\
let high_score=250

# ==============================================================
# menu

# XXX TODO -- rewrite, complete

@menu:

border 1: paper 1: ink 7
gosub @credits

#  <------------------------------>
print '\
  "________________________________"''\
  "Pulsa ";\
  inverse 1;"I";inverse 0;\
         " para ver instrucciones,"'\
  "     otra tecla para jugar."'\
  "________________________________"\
#  <------------------------------>

beep .1 ,23
pause 0:let i$=inkey$
if i$="i" or i$="I" then\
  gosub @instructions:\
  goto @menu

goto @new_game

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

return

# ==============================================================
# subroutine: instructions

@instructions:

cls
let i$="\a":gosub @icon
#     <------------------------------>
print " Tú: Debes atravesar cada campo"
#      <------------------------------>
print "  de minas, moviéndote con las"
print "  teclas del cursor."

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
# subroutine

@l9300:

print at 4,4+ss;"\ :";\
      at 4,6+ss;"\: "
print at 5,4+ss;"\ :";\
      at 5,6+ss;"\: "
print at 6,4+ss;"\ :";\
      at 6,6+ss;"\: "
print at 7,1+ss;"\:.\..\..\..";\
      at 7,6+ss;"\..\..\..\.:"
print at 9,1+ss;"\''\''\''\':";\
      at 9,6+ss;"\:'\''\''\''"
print at 10,4+ss;"\ :";\
      at 10,6+ss;"\: "
print at 11,4+ss;"\ :";\
      at 11,6+ss;"\: "
print at 12,4+ss;"\ :";\
      at 12,6+ss;"\: "
return

# ==============================================================
# subroutine: last level

@last_level:

let ss=int (rnd*11)+6
beep .3,-12

# XXX OLD -- close the door:
print at 0,15;"\h\h";at 1,15;"\f\f"

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
  gosub @l9300
next n
print at 11,5+ss; ink paper_color; paper paper_color;"\o"
flash 0
print at 8,5+ss; flash 0;"\n"
return

# vim: ft=sinclairbasic:fileencoding=latin1
