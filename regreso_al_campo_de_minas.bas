# Regreso al campo de minas
#
# "Campo de minas" was published by Indescomp. It was the Spanish
# version of "Minefield", written by Ian Andrew.
#
# This is a fork under development by Marcos Cruz (programandala.net),
# started on 2016-06-04.
#
# This source is in the zmakebas format of Sinclair BASIC,
# with extended features (e.g. long string variable names).

# ==============================================================

border 0: paper 0: ink 7:\
clear 65535-21*8*2:\
let version$="0.9.0+201606071659":\
let udg1=65535-21*8*2:\
let udg2=udg1+21*8:\
goto @init

# Note: version number after Semantic Versioning: http://semver.org

# ==============================================================

@new_game:

if level>2 then\
  goto @l5700
let mines=50: let score=0: let bonus=0: 
let paper_color=6: let border_color=0

# ==============================================================

@l10:

border border_color: paper paper_color: ink ink_color: cls
gosub @select_graphics

# coordinates
let row=21: let col=15
let old_row=row: let old_col=col

# list of coordinates, stored as chars
let t$=chr$ (row+65)+chr$ (col+65)

# counter
let time=0

let protagonist$="\a"
let protagonist_with_damsel$="\b"
let damsels_row=0: let damsel_1_col=0: let damsel_2_col=0
let rr=1
let oo=21: let pp=15
let safe_zone$="       < ZONA SEGURA >        "
let blank_safe_zone$="                              "
let pa=7
let ss=0
goto @l300

# ==============================================================

@l100:

let rn=int (rnd*13)+4
for a=3 to 30
  if a=10 or a=20 then next a
  print at 21,19; paper paper; ink 9;"mas minas "
  if attr (rn,a)=56 then\
     goto @l115
  print at rn,a;"\m"
  @l115:

  let k=rn-1+int (rnd*3)
  if attr (k,a-1)<>56 then\
    print at k,a-1;"\o"
  beep .002,55
  print at 21,19;"          "
  if attr (rn,a)=56 then\
    goto @l150
  print at rn,a;" "
  @l150:

next a
goto @l570

@l300:

gosub @status_bar
print at 1,0;"\f\f\f\f\f\f\f\f\f\f\f\f\f\f\f  \f\f\f\f\f\f\f\f\f\f\f\f\f\f\f"
for n=2 to 19:\
  print at n,0;"\f                              \f":\
next n
print at 20,0;"\f\f\f\f\f\f\f\f\f\f\f\f\f\f   \f\f\f\f\f\f\f\f\f\f\f\f\f\f\f"
print at row,col;protagonist$
print at 21,17; flash 1; paper 8; ink 8;"Poniendo minas"
if level=9 then\
  let mines=mines+32+(10-int (score/1000))

print paper 8;bright 1; at 2,1;safe_zone$;at 19,1;safe_zone$
for w=1 to mines:\
  print at int (rnd*16)+3,int (rnd*30)+1; ink paper_color;"\o":\
  beep .0015,35:\
next w
print paper 8;at 2,1;blank_safe_zone$;at 19,1;blank_safe_zone$

print \
  ink paper_color;\
  at 10,1;"\o";\
  at 11,15;"\o\o";\
  at 10,30;"\o"

print at 21,0;"                               "

if level=1 then\
  goto @l480
if level=9 then\
  gosub @level9: goto @l480

print at 21,0; inverse 1; bright 1;"Rescata a las pobres damiselas!"

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

if level<>8 then\
  goto @l490
print at 21,0;\
  ink 7; flash 1; paper 0; bright 1;\
  "Ponte entre 3 minas para abrir  "
print at 1,15;"\f\f"
print at 8,9; ink 1; bright 1; paper 7;"puerta cerrada"
for m=60 to 10 step -2.5
  for n=1 to 7: next n
  beep .125,m
next m
print at 21,0;"                                "
print at 8,9;"              "

@l490:

beep .0875,10
print at 21,0;"               \a                "
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
let row=row-(row=22)
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
let t$=t$+chr$ (row+65)+chr$ (col+65)
if screen$ (row,col)<>" " then\
  gosub @explosion
if level=9 and pa<>paper_color and row<17 then\
  gosub @l8000
print at row,col; paper pa;protagonist$

@l570:

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

let front_surrounding_mines=screen$ (row-1,col)<>" ":\
let back_surrounding_mines=screen$ (row+1,col)<>" ":\
let left_surrounding_mines=screen$ (row,col-1)<>" ":\
let right_surrounding_mines=screen$ (row,col+1)<>" ":\
let surrounding_mines=\
  front_surrounding_mines+\
  back_surrounding_mines+\
  left_surrounding_mines+\
  right_surrounding_mines

if surrounding_mines then\
  beep .04,surrounding_mines*10
gosub @status_bar
if row=0 then\
  gosub @l3000
if surrounding_mines=3 and level=8 then\
  print at 8,9; flash 1;"puerta abierta":\
  for c=1 to 40: beep .001,30+c/4:\
    border 0: border 7:\
  next c:\
  print at 1,15;"  ":\
  print at 8,9;"              ":\
  border 2
if level>2 and level<9 and time>50 then\
  if rnd>.98 then\
    goto @l100
goto @l500

# ==============================================================
# subroutine: status bar

@status_bar:

# XXX TODO -- improve the position of the texts

print paper 0; ink 7;\
  at 0,0;"Minas vecinas ";\
    paper (4-surrounding_mines);ink 9;surrounding_mines;\
  paper 0; ink 7;\
  at 0,15;"Niv. ";level;" ";\
  at 0,22;"Punt. 0000";\
  at 0,31-(score>9)-(score>99)-(score>999);score:\
return

# ==============================================================
# subroutine

@l543:

print at oo,pp; paper pa;" "
let i$=t$+t$
if level>=5 and paper_color<>pa and time>2000 then\
  gosub @l8000
let rr=rr+2: beep .0018,60
let oo=65-code i$(rr): let pp=65-code i$(rr+1)
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
if level=9 then\
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
gosub @status_bar
gosub @select_chars
print at 10,9; ink 7; paper 2; bright 1;"  ¿Otra vez?  "
gosub @select_graphics
if paper_color>=4 then\
  ink 0
if paper_color<4 then\
  ink 7
plot 72,96: draw 112,0: draw 0,-9: draw -113,0: draw 0,9
ink 9

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
  "Felicidades!"
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
let level=1
goto @l1200

# ==============================================================
# subroutine: replay

@replay:

for n=1 to 20: next n
for a=1 to 21
  print at a,0; over 1; ink 9;"                                "
next a
gosub @select_chars
print at 21,1;flash 1; paper 7; ink 0;"Repetición"
print at 21,17;"[R]apido [F]in"
gosub @select_graphics
for n=1 to 100: next n
let y$=t$
let replay_row=code y$(1)-65: let replay_col=code y$(2)-65
for t=1 to len y$ step 2
  let i$=inkey$
  if i$="f" or i$="F" then\
    goto @replay_end
  if i$<>"r" and i$<>"R" then\
    for m=1 to 5: next m
  print at replay_row,replay_col; paper 7;" "
  let replay_row=code y$(1)-65: let replay_col=code y$(2)-65
  print at replay_row,replay_col; paper 7;protagonist$
  beep .005,5+(t*40/(len t$))
  let y$=y$(3 to )
next t

@replay_end:

print at 21,0;"                                "
return

# ==============================================================
# subroutine

@l3000:

let time_score=(int ((2000-time)/50))*5
if time_score<50 then\
  let time_score=50
let time_score=time_score*level
for n=15 to 50:\
  beep .001+((50-30)/2000),(50+n/2.8):\
  border 2: border 7: border 0:\
next n
border border_color

# XXX TODO -- remove
if bonus>0 then\
  let score=score+bonus:\
  print at 21,0; paper 7; bright 1;"Bonos iniciales= ";bonus:\
  let bonus=0:\
  for n=1 to 20 step .6:\
    beep .025,n+5:\
  next n:\
  print at 21,0;"                                "

gosub @replay

for g=4 to 22 step 6
  beep .005,g+24
next g
for n=1 to 80
  border 1: border 2: border 3: border 4: border 5: border 6
next n
let score=score+time_score
gosub @status_bar
for n=1 to 120
next n
let mines=mines+10
let paper_color=paper_color-1
let level=level+1
if paper_color<0 then\
  let border_color=border_color+2: let paper_color=6
if paper_color=6 then\
  let mines=50
if level=7 then\
  let mines=20
goto @l10

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
for n=1 to 6
  print at 0,15;"\d\e"
  for l=1 to 7: next l
  beep .006,13
  print at 0,15;"\e\d"
  for l=1 to 7: next l
  beep .006,16
next n
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

@l5700:

let max_level=level-1
gosub @select_chars
let z$="   ¿Desde qué nivel empiezas?      "
gosub @select_graphics

for n=0 to 21: paper paper_color: beep .002,n+5: print at n,0; over 1;"\::                              \::": next n
for n=1 to 21: next n
for n=0 to 31
  paper paper_color: ink paper_color
  plot n*8,0: draw 0,175
  beep .0015,64: beep .0015,59
  print at 10,n; paper int (rnd*6); ink 9;z$(n+1)
next n
ink 9
print at 13,13; flash 1;"1";at 13,14;" a ";at 13,18; flash 1;max_level
print at 13,13; flash 1;"1"
print at 13,14;" a "
print at 13,18; flash 1;max_level
beep .1,30
for n=1 to 25: next n

pause 0:let i$=inkey$
print at 21,0; ink paper_color; paper paper_color; inverse 1;\
  "     Vuelve a intentarlo        "
#  <------------------------------>
print at 0,0; ink paper_color; paper paper_color; inverse 1;\
  "     Vuelve a intentarlo        "
#  <------------------------------>
if code i$<49 or code i$>57 then\
  beep 1,-15: goto @l5700
let new_level=val i$
if new_level>max_level or new_level<>(int new_level) or new_level<1 then\
  beep 1,-15: goto @l5700
let score=0
let level=new_level
for n=30 to 34: beep .006,n: next n
# XXX TODO -- convert to data
if new_level=1 then\
  let paper_color=6: let border_color=0: let mines=50: let bonus=0
if new_level=2 then\
  let paper_color=5: let border_color=0: let mines=60: let bonus=250
if new_level=3 then\
  let paper_color=4: let border_color=0: let mines=70: let bonus=750
if new_level=4 then\
  let paper_color=3: let border_color=0: let mines=80: let bonus=1500
if new_level=5 then\
  let paper_color=2: let border_color=0: let mines=90: let bonus=2200
if new_level=6 then\
  let paper_color=1: let border_color=0: let mines=100: let bonus=2700
if new_level=7 then\
  let paper_color=0: let border_color=0: let mines=20: let bonus=3500
if new_level=8 then\
  let paper_color=6: let border_color=2: let mines=50: let bonus=4200
goto @l10

# ==============================================================
# subroutine: damsel rescued

@damsel_rescued:

print at row,col;protagonist_with_damsel$
let protagonist$=protagonist_with_damsel$
paper 7
for u=25 to 50 step 5
  print at row,col;"\g"
  for n=1 to 8 step 2
    beep .002,n+u
    let score=score+5
# XXX TODO -- create subroutine to print the score
    print at 0,21; paper 0; ink 7;" Puntos ";score
  next n
  print at row,col;"\d"
  for n=1 to 8 step 2
    beep .002,n+u
  next n
next u
let time=time+35
paper paper_color
return

# ==============================================================
# subroutine

@l8000:

let pa=paper_color
print at 21,0;\
  flash 1; bright 1; ink 7; paper 1;\
  "Tu mapa ha explotado"
print at 20,14; paper paper_color;"   "
for n=19 to 2 step -.5
  beep .05,n-10
  if level<=8 or n>14 then\
    print at n,1;\
      over 1; ink paper_color; paper paper_color;\
      "                              "
  print at row,col; paper pa;protagonist$
next n
print at 20,14; paper pa;"   "
print at 21,0;"                                "
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

let record_player$="IAN"

gosub @select_graphics
gosub @read_UDG_bank
gosub @select_chars
gosub @read_UDG_bank

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

let k$=chr$ 8+chr$ 9+chr$ 11+chr$ 10:rem cursor keys
let ink_color=9
let level=1: let bonus=0: let high_score=250
let surrounding_mines=0

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
# subroutine: read UDG bank

@read_UDG_bank:

read a$
if a$="" then return
let udg=usr a$
for b=0 to 7:\
  read c: poke udg+b,c:\
next b
goto @read_UDG_bank

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
# subroutine: level 9

@level9:

let ss=int (rnd*11)+6
beep .3,-12
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

# ==============================================================
# data

# UDG bank 1: game graphics

# protagonist:
data "a",24,24,36,195,195,36,24,24
# protagonist carrying a damsel:
data "b",90,90,36,219,219,36,90,153
# mine exploding:
data "c",165,165,66,90,40,189,126,129
# damsel 1:
data "d",72,84,73,62,8,28,62,62
# damsel 2:
data "e",18,42,146,124,16,56,124,124
# fence:
data "f",8,16,8,186,93,16,8,16
# protagonist carrying a damsel:
data "g",90,90,36,195,195,36,90,153
# walking mine:
data "h",0,0,0,0,60,126,165,165
# fence door?:
data "k",0,0,0,0,0,0,85,170
# miner:
data "m",192,32,18,13,63,16,32,192
# Bill:
data "n",0,0,192,192,78,74,91,112
# mine:
data "o",0,0,0,0,60,126,0,0

# XXX OLD -- not used
# # Part 1 of "MINES":
# data "p",0,132,204,180,132,132,132,0
# # Part 2 of "MINES":
# data "q",0,144,152,148,146,145,144,0
# # Part 3 of "MINES":
# data "r",0,159,144,158,144,144,159,0
# # Part 4 of "MINES":
# data "s",0,31,32,30,1,33,30,0

data "":rem end of UDG bank

# UDG bank 2: Spanish letters and symbols

# a accute
data "a"
data bin 00001000
data bin 00010000
data bin 00111000
data bin 00000100
data bin 00111100
data bin 01000100
data bin 00111100
data bin 00000000
# A accute
data "b"
data bin 00000100
data bin 00001000
data bin 00111100
data bin 01000010
data bin 01111110
data bin 01000010
data bin 01000010
data bin 00000000
# e acute
data "c"
data bin 00001000
data bin 00010000
data bin 00111000
data bin 01000100
data bin 01111000
data bin 01000000
data bin 00111100
data bin 00000000
# E accute
data "d"
data bin 00000100
data bin 00001000
data bin 01111110
data bin 01000000
data bin 01111100
data bin 01000000
data bin 01111110
data bin 00000000
# i accute
data "e"
data bin 00001000
data bin 00010000
data bin 00000000
data bin 00110000
data bin 00010000
data bin 00010000
data bin 00111000
data bin 00000000
# I accute
data "f"
data bin 00000100
data bin 00001000
data bin 00111110
data bin 00001000
data bin 00001000
data bin 00001000
data bin 00111110
data bin 00000000
# o accute
data "g"
data bin 00001000
data bin 00010000
data bin 00111000
data bin 01000100
data bin 01000100
data bin 01000100
data bin 00111000
data bin 00000000
# O accute
data "h"
data bin 00001000
data bin 00010000
data bin 00111100
data bin 01000010
data bin 01000010
data bin 01000010
data bin 00111100
data bin 00000000
# u accute
data "i"
data bin 00001000
data bin 00010000
data bin 01000100
data bin 01000100
data bin 01000100
data bin 01000100
data bin 00111000
data bin 00000000
# U accute
data "j"
data bin 00000100
data bin 01001010
data bin 01000010
data bin 01000010
data bin 01000010
data bin 01000010
data bin 00111100
data bin 00000000
# n tilde
data "k"
data bin 00000000
data bin 01111000
data bin 00000000
data bin 01111000
data bin 01000100
data bin 01000100
data bin 01000100
data bin 00000000
# N tilde
data "l"
data bin 00111100
data bin 00000000
data bin 01100010
data bin 01010010
data bin 01001010
data bin 01000110
data bin 01000010
data bin 00000000
# u umlaut
data "m"
data bin 01000100
data bin 00000000
data bin 01000100
data bin 01000100
data bin 01000100
data bin 01000100
data bin 00111000
data bin 00000000
# U umlaut
data "n"
data bin 01000010
data bin 00000000
data bin 01000010
data bin 01000010
data bin 01000010
data bin 01000010
data bin 00111100
data bin 00000000
# inversed question mark
data "o"
data bin 00000000
data bin 00010000
data bin 00000000
data bin 00010000
data bin 00100000
data bin 01000010
data bin 00111100
data bin 00000000
# inversed exclamation mark
data "p"
data bin 00000000
data bin 00001000
data bin 00000000
data bin 00001000
data bin 00001000
data bin 00001000
data bin 00001000
data bin 00000000

# XXX OLD -- not used
# # º
# data "q"
# data bin 00011000
# data bin 00100100
# data bin 00011000
# data bin 00000000
# data bin 00111100
# data bin 00000000
# data bin 00000000
# data bin 00000000

# «
data "r"
data bin 00000000
data bin 00000000
data bin 00010010
data bin 00100100
data bin 01001000
data bin 00100100
data bin 00010010
data bin 00000000
# »
data "s"
data bin 00000000
data bin 00000000
data bin 01001000
data bin 00100100
data bin 00010010
data bin 00100100
data bin 01001000
data bin 00000000

data "":rem end of UDG bank
 

# vim: ft=sinclairbasic:fileencoding=latin1
