# ZX Spectrum "Minefield", by Ian Andrew
# Spanish version "Campo de minas", published by Indescomp
#
# Fork by Marcos Cruz (programandala.net):
# 2016-06-04: Remove embedded control codes. Print to a text file.
# Restore UDGs, using the notation of zmakebas. Use cursor keys.

let inkcolor=9: let bonus=0: let level=1: let damsels=1: let highscore=250 : let damsels=1
let h$="ian"
let k$=chr$ 8+chr$ 9+chr$ 11+chr$ 10:rem cursor keys

@l6:

if damsels>2 then go to @l5700
let mines=50: let damsels=1: let score=0: let bonus=0: 
let papercolor=6: let bordercolor=0

@l10:

border bordercolor: paper papercolor: ink inkcolor: cls
let x=21: let y=15
let t$=chr$ (x+65)+chr$ (y+65)
let xx=21: let yy=15
let time=0
let oldx=x: let oldy=y
let c$="\a": let v$="\b"
let cc=0: let dd=0: let ee=0
let rr=1
let oo=21: let pp=15
let x$="                                 < zona segura >                                 "
let pa=7
let ss=0
if level<>1 then print at 15,0;: list
go to @l300

@l100:

let rn=int (rnd*13)+4
for a=3 to 30
  if a=10 or a=20 then next a
  print at 21,19; paper paper; ink 9;"mas minas "
  if attr (rn,a)=56 then go to @l115
  print at rn,a;"\m"
  @l115:

  let k=rn-1+int (rnd*3)
  if attr (k,a-1)<>56 then print at k,a-1;"\o"
  beep .002,55
  print at 21,19;"          "
  if attr (rn,a)=56 then go to @l150
  print at rn,a;" "
  @l150:

next a
go to @l570

@l300:

print at 0,28; paper 0;"    "
print at 0,0; paper 0; ink 7;"minas vecinas 0";at 0,17;"no.";damsels;" punt. ";score
print at 1,0;"\f\f\f\f\f\f\f\f\f\f\f\f\f\f\f  \f\f\f\f\f\f\f\f\f\f\f\f\f\f\f"
for n=2 to 19
  print at n,0;"\f                              \f"
next n
print at 20,0;"\f\f\f\f\f\f\f\f\f\f\f\f\f\f   \f\f\f\f\f\f\f\f\f\f\f\f\f\f\f"
print at x,y;c$
next n: if score=0 and damsels>2 and bonus=0 then print at 15,0;: list
print at 21,17; flash 1; paper 2; ink 7;"poniendo minas": if damsels=9 then let mines=mines+32: let mines=mines+(10-int (score/1000))
print at 21,3; flash 1; paper 2; ink 7; inverse 1;"nivel ";damsels
for w=1 to mines
  print at int (rnd*16)+3,int (rnd*30)+1; ink papercolor;"\o"
  beep .0015,35
  if damsels<>1 then next w
  if damsels<>1 then go to @l439
  print at 19,1;x$(w to w+29)
  print at 2,1;x$(51-w to 51-w+29)
next w

@l439:

if level<>1 then print at 15,0;: list
print at 10,1; ink papercolor;"\o";at 11,15;"\o\o";at 10,30;"\o"
print at 21,0;"                               "
if damsels=1 then go to @l480
if damsels=9 then go sub @l9900: go to @l480
print at 21,0; inverse 1; bright 1;"rescata a las pobres damiselas !": go to @l450

@l450:

let cc=int (rnd*12)+4: let dd=int (rnd*6)+6: let ee=int (rnd*6)+19
for j=1 to 7
  print at cc,dd;"\d";at cc,ee;"\d"
  for e=1 to 11: next e
  beep .002,58
  print at cc,dd;"\e";at cc,ee;"\e"
  for e=1 to 11: next e
  beep .002,58
next j

@l480:

if damsels<>8 then go to @l490
print at 21,0; ink 7; flash 1; paper 0; bright 1;"ponte entre 3 minas para abrir  "
print at 1,15;"\f\f": print at 8,9; ink 1; bright 1; paper 7;"puerta cerrada"
for m=60 to 10 step -2.5
  for n=1 to 7: next n
  beep .125,m
next m
print at 21,0;"                                "
print at 8,9;"              "

@l490:

beep .0875,10
print at 21,0;"               \a                "
print at 21,31; ink papercolor; paper papercolor;"\h"
print at 21,4; inverse 1;"adelante!"
for n=1 to 20
  beep .002,n+20
next n
print at 21,4;"         ": beep .05,37
go to @l535

@l500:

let oldx=x: let oldy=y

@l520:

let i$=inkey$
let x=x+(i$=k$(4))-(i$=k$(3))
let x=x-(x=22)
let y=y+(i$=k$(2))-(i$=k$(1))
let time=time+1
if damsels>=4 then if time>(260*papercolor+70) then if int (time/(3*papercolor+1))=(time/(3*papercolor+1)) then go sub @l543
if oldx=x and oldy=y then go to @l520
beep .003,-4

@l535:

print at oldx,oldy; paper pa;" "
let t$=t$+chr$ (x+65)+chr$ (y+65)
if screen$ (x,y)<>" " then go sub @l1000
if damsels=9 and pa<>papercolor and x<17 then go sub @l8000
print at x,y; paper pa;c$

@l570:

let o=(screen$ (x-1,y)<>" ")
let p=(screen$ (x+1,y)<>" ")
let q=(screen$ (x,y-1)<>" ")
let r=(screen$ (x,y+1)<>" ")
let o=o+p+q+r
if o then beep .04,o*10
print at 0,0; paper (4-o); ink 9;"minas vecinas ";o
if x=0 then go sub @l3000
if o=3 and damsels=8 then print at 8,9; flash 1;"puerta abierta": for c=1 to 40: beep .001,30+c/4: border 0: border 7: next c: print at 1,15;"  ": print at 8,9;"              ": border 2
if damsels>2 and damsels<9 and time>50 then if rnd>.98 then go to @l100
go to @l500

# ==============================================================
# subroutine

@l543:

print at oo,pp; paper pa;" "
let i$=t$+t$: if damsels>=5 and papercolor<>pa and time>2000 then go sub @l8000
let rr=rr+2: beep .0018,60
let oo=65-code i$(rr): let pp=65-code i$(rr+1)
if screen$ (oo,pp)<>" " then go sub @l1000
print at oo,pp; paper pa;"\h"
return

# ==============================================================
# subroutine

@l1000:

if x=cc then if y=dd or y=ee then go sub @l6000: return
if damsels=9 then if x=8 and y=5+ss then go to @l8444
for w=20 to 1 step -1
  beep .003,0+w: print at x,y;"\c"
  beep .002,10: print at x,y;"\o"
next w
let j$=" has explotado! "
if rnd>.8 then let j$="  has volado!   "
if rnd>.7 then let j$="  destruccion!  "
print at 0,0; paper 0; ink 7;j$
beep 1.6,-35
go sub @l2000
print at x,y; paper 7; ink 0; over 1;chr$ (65+int (rnd*60))
beep 1,-35
if score>highscore then go sub @newrecord
print at 0,28; paper 0;"  "
print at 0,0; paper 0; ink 7;" ";"otra vez?    nivel ";damsels;" ";at 0,22; flash 1;"punt. ";score
print at 2,1; paper 0; ink 7;" pulsa una tecla (""i"" = info) "
print at 10,9; ink 7; paper 2; bright 1;"   se acabo   "
if papercolor>=4 then ink 0
if papercolor<4 then ink 7
plot 72,96: draw 112,0: draw 0,-9: draw -113,0: draw 0,9
ink 9

@l1200:

print at 21,29; paper bordercolor; ink 9;"   ";at 21,0; paper bordercolor; ink 9;" puntuacion max.= ";highscore;" por ";h$
for n=1 to 100: next n
for n=1 to 10000000
  if score=highscore then print at 21,0; paper bordercolor; ink 9;"\d";at 21,31;"\e"
  if inkey$="" then for m=1 to 16: next m
  if score=highscore then print at 21,0; paper bordercolor; ink 9;"\e";at 21,31;"\d"
  if inkey$="" then for m=1 to 16: next m
  let s$=inkey$
if s$="" then next n
if s$="i" or s$="i" then go sub @instructions
print at 2,1;"                              "
go to @l6

# ==============================================================
# subroutine

@l2000:

for n=1 to 20: next n
for a=1 to 21
  print at a,0; over 1; ink 9;"                                "
next a
print at 21,1; flash 1; paper 7; ink 0;" repeticion  "
for n=1 to 100: next n
let y$=t$
for t=1 to len y$ step 2

# XXX FIXME --
  for m=1 to 5: if inkey$="s" or inkey$="S" then go to @l2033: next m
  @l2033:

  print at xx,yy; paper 7;" "
  if damsels>1 and t=21 then print at 21,0; paper 0; ink 7;"""s""= mas rapido, ""e""= terminar  "
  let xx=code y$(1)-65: let yy=code y$(2)-65
  print at xx,yy; paper 7;c$
  beep .005,5+(t*40/(len t$))
  let y$=y$(3 to )
  if inkey$="e" or inkey$="E" then go to @l2055
next t

@l2055:

print at 21,0;"                                "
return

# ==============================================================
# subroutine

@l3000:

let ss=(int ((2000-time)/50))*5: if ss<50 then let ss=50
let ss=ss*damsels
print at 0,0; paper damsels/1.5; ink 9;"nivel ";damsels;"  puntos por tiempo= ";ss;
if damsels=1 and ss<100 then print at 0,31; paper 1;" "
print at 1,0;"\f"
for n=15 to 50: beep .001+((50-30)/2000),(50+n/2.8): border 2: border 7: border 0: next n
border bordercolor
if bonus>0 then let score=score+bonus: print at 21,0; paper 7; bright 1;"bonos iniciales = ";bonus: let bonus=0: for n=1 to 20 step .6: beep .025,n+5: next n: print at 21,0;"                                "
go sub @l2000
for g=4 to 22 step 6: beep .005,g+24: next g
for n=1 to 80
  border 1: border 2: border 3: border 4: border 5: border 6
next n
let score=score+ss
print at 0,30; paper 0;"  "
print at 0,0; paper 0; ink 7;"minas vecinas 0  no.";damsels;" punt ";score
for n=1 to 120
next n
let mines=mines+10
let papercolor=papercolor-1
let damsels=damsels+1
if papercolor<0 then let bordercolor=bordercolor+2: let papercolor=6
if papercolor=6 then let mines=50
if damsels=7 then let mines=20
go to @l10

# ==============================================================
# subroutine: new record

@newrecord:

for n=1 to 50
  border 1: border 2: border 3: border 4
next n
if damsels=1 then list
for n=1 to 50
  border 6: border 2: beep .002,40+(n/10): border 6
next n
for m=1 to 4
  for n=7 to 0 step -1
    print at 10,7; ink n;"un nuevo record!"
    beep .004,50-n
  next n
next m
print at 10,7; ink 9;"un nuevo record!"
for n=1 to 6
  print at 0,15;"\d\e"
  for l=1 to 7: next l
  beep .006,13
  print at 0,15;"\e\d"
  for l=1 to 7: next l
  beep .006,16
next n
print at 21,0; flash 1; paper 1; ink 7;"introduce tus iniciales"; flash 0;"         "
let q$="   "
for n=1 to 3
  @l5088:

  let q$(n)=inkey$
  if q$(n)=" " then go to @l5088
  if code q$(n)>=97 and code q$(n)<=122 then let q$(n)=chr$ ((code q$(n))-32)
  print at 21,(24+(2*n)); ink 7; paper 1;q$(n)
  beep .12,(n*5)+20
  for m=1 to 4: next m
next n
let h$=q$: let highscore=score
print at 21,0; paper 7; ink 0;"         muy bien  ";h$;"          "
for n=1 to 12
  beep .0045,-10: border 1: border 2: border 6: border 4
next n
border bordercolor
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

let level=damsels-1
let z$="   desde que nivel empiezas?      "
for n=0 to 21: paper papercolor: beep .002,n+5: print at n,0; over 1;"\::                              \::": next n
for n=1 to 21: next n: for n=0 to 31: paper papercolor: ink papercolor: plot n*8,0: draw 0,175
beep .0015,64: beep .0015,59
print at 10,n; paper int (rnd*6); ink 9;z$(n+1)
next n
ink 9: if score=0 and bonus=0 then print at 15,0;: list
print at 13,13; flash 1;"1";at 13,14;" a ";at 13,18; flash 1;level
print at 13,13; flash 1;"1"
print at 13,14;" a "
print at 13,18; flash 1;level
beep .1,30
for n=1 to 25: next n

pause 0:let l$=inkey$
print at 21,0; ink papercolor; paper papercolor; inverse 1;"     vuelve a intentarlo !!     "
print at 0,0; ink papercolor; paper papercolor; inverse 1;"     vuelve a intentarlo !!     "
if code l$<49 or code l$>57 then beep 1,-15: go to @l5700
let ll=val l$
if ll>level or ll<>(int ll) or ll<1 then beep 1,-15: go to @l5700
let score=0
let damsels=ll
if ll=1 then let papercolor=6: let bordercolor=0: let mines=50: let bonus=0
for n=30 to 34: beep .006,n: next n
if ll=2 then let papercolor=5: let bordercolor=0: let mines=60: let bonus=250
if ll=3 then let papercolor=4: let bordercolor=0: let mines=70: let bonus=750
if ll=4 then let papercolor=3: let bordercolor=0: let mines=80: let bonus=1500
if ll=5 then let papercolor=2: let bordercolor=0: let mines=90: let bonus=2200
if ll=6 then let papercolor=1: let bordercolor=0: let mines=100: let bonus=2700
if ll=7 then let papercolor=0: let bordercolor=0: let mines=20: let bonus=3500
if ll=8 then let papercolor=6: let bordercolor=2: let mines=50: let bonus=4200
if ll=9 then list
let level=1
go to @l10
stop

# ==============================================================
# subroutine

@l6000:

print at x,y;v$: let c$=v$
paper 7: let c$=v$
for u=25 to 50 step 5: print at x,y;"\g"
for n=1 to 8 step 2: beep .002,n+u
let score=score+5
print at 0,21; paper 0; ink 7;" score ";score
next n
print at x,y;"\d"
for n=1 to 8 step 2: beep .002,n+u
next n
next u
let time=time+35
paper papercolor
return

# ==============================================================
# subroutine: instructions

@instructions:

let p=0
border 1: paper 1: ink 7: cls
print at 0,0;"     indescomp presenta ...."
for n=1 to 60: next n
for n=2 to 16
  print at n,0;"                                ": rem xxx todo -- color
next n
beep .2,30: beep .1,20: for n=1 to 5: next n: beep .075,26: beep .125,26: beep .1,18
print at 0,0;"prueba tu estrategia y habilidad"
for n=47 to 56 step 3
print at 9,9; paper p; over 0; ink 9;"campo de minas": circle ink 7;128,99,n: let p=p+2
next n
ink 9
print at 18,0;"""rescata a bill el gusano de unahorrible jubilacion"""
print at 9,9; ink 0; paper 7; flash 1;"campo de minas"
paper 8: for n=3 to 17: print at n-1,4; paper 8;"\o";at n-1,27;"\o": print at 19-n,3;"\o";at 19-n,5;"\o";at 19-n,26;"\o";at 19-n,28;"\o"
beep .005,33: next n: paper 1
go sub @pressKey

print at 2,0;"\* campo de minas! por ian andrew"
print ''" tu mision: (deberas decidir     si la aceptas) llegar hasta     bill el gusano y rescatarle"''" el esta durmiendo en el ultimo  campo de minas (nivel 9)"
print '" este es bill ""\n"""
print ''" tu, ""\a"", comienzas en la parte  inferior de la pantalla."
print '" tu objetivo: alcanzar la puerta de la parte superior."
print at 21,17; inverse 1;"pulsa una tecla"
for n=1 to 40: next n
for n=1 to 50000: if inkey$="" then next n
restore @demoCoordinates
for n=1 to 47
  read i: read l:

  print at i,l;"\a": beep .035,n/2
  print at i,l;" "
next n
cls
print at 1,0;" muevete utilizando las teclas   5,6,7 y 8 [ ver las flechas ]"
print ''" minas:  ""\o"" son desagradables"''" en la parte superior izquierda  de la pantalla se te indicara   cuantas se encuentran a tu al-  rededor."
rem "hello there"
print '" solo se vive una vez                   no pises las minas "
print ''" damiselas - cuentan como minas  pero si te encuentras junto a   una de ellas no dudes en correr a rescatarla. seras ampliamente recompensado."
go sub @pressKey
print at 2,0;" el bicho ""\h"" (mina con patas)   te perseguira sin descanso -    puede volverse muy agresivo."
for n=1 to 15: next n
let j$="                                 \a        \h                                        "
for n=1 to len j$-35
  print at 6,0;j$(n to n+31): beep .0018,60
  for m=1 to 1: next m
next n
print " y ahora algunos..."''" trucos - en las zonas seguras   no hay minas, por eso dirigete  a la zona superior (no solo a   la puerta) y desde alli vete a  la puerta tranquilamente.       cuando este pululando el bicho  (nivel 4 o mas) muevete conti-  nuamente. normalmente te move-  ras mas deprisa que el."
go sub @pressKey
print at 3,0;" la verja esta electrificada y   contara como una mina si estas  junto a ella."
print at 8,0;"\f\f\f\f\f\f\f\f\f\f\f\f\f\f\f\f\f\f\f\f\f\f\f\f\f\f\f\f\f\f\f\f"
for n=1 to 2
  for o=0 to 1
    print at 6+o,14;"\a"
    print at 0,0; paper (4-o); ink 9;"minas vecinas ";o
    if o then beep .04,o*10
    for m=1 to 22: next m: print at 6+o,14;" "
  next o
next n
print at 6,14;"\a": print at 0,0; paper 4; ink 9;"minas vecinas 0"
print at 11,0;" imposible? - si te parece impo- sible no desesperes. los mina-  dores, ""\m"", no solo ponen mi-   nas sino que tambien las quitan (amables, no?) "
print ''; paper 1; ink 7;"                                 pulsa ""i"" para volver a ver     las instrucciones, otra tecla   para jugar                     "

pause 0:let s$=inkey$:
if s$="i" or s$="I" then go to @instructions
cls
return

# ==============================================================
# subroutine

@pressKey:

print at 21,17; inverse 1;"pulsa una tecla"
for n=1 to 60: next n
pause 0:paper 7: ink 0: cls
return

# ==============================================================
# subroutine

@l8000:

let pa=papercolor
print at 21,0; flash 1; bright 1; ink 7; paper 1;"tu mapa ha explotado!(lo siento)"
print at 20,14; paper papercolor;"   "
for n=19 to 2 step -.5
  beep .05,n-10
  if damsels<=8 or n>14 then print at n,1; over 1; ink papercolor; paper papercolor;"                              "
  print at x,y; paper pa;c$
next n
print at 20,14; paper pa;"   "
print at 21,0;"                                "
return

@l8444:

go sub @l9300
let dx=30
for u=.155 to .005 step -.01
  if damsels<>9 or x<>8 then print at 15,0;: list
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
    ink l: go sub @l8450
  next l
next t
ink 0
go sub @l9300
print at 0,0; ink 7; paper 0;"    dos mil puntos extra!       "
let score=score+2000
for b=0 to 7
  paper b: ink 9: print at x,y;c$
  for n=1 to 14
    beep .002,50-n+b
    border 1: border 2: border 3: border 4
    border 5: border 6: border 7: border b
  next n
next b
ink 9: border 0: paper 0: cls
for n=0 to 30 step 6
  for m=1 to 10
    beep .008,n+m
  next m
next n
print at 3,8;"  felicidades  "
print '" has rescatado a bill. el mun-   do te esta agradecido.         "
print ''''';" tus puntos = ";score;", que no esta"
print " nada mal ... por que no vuelvesa jugar y tratas de mejorar tu          puntuacion? "
if score>highscore then go sub @newrecord
let damsels=1: go to @l1200
let damsels=1: for n=1 to 50000000: if inkey$="" then next n
go to @l6

# ==============================================================
# subroutine

@l8450:

# XXX TODO -- simpler

for n=1 to 5
  print at x+n,y+n;"*"
  print at x-n,y+n;"*"
  print at x+n,y-n;"*"
  print at x-n,y-n;"*"
next n
for n=1 to 5
  print at x,y+n;">"
  print at x,y-n;"<"
  print at x+n,y;"#"
  print at x-n,y;"#"
next n
return

# start line

# ==============================================================
@start:

border 0: paper 0: ink 9: clear
poke 23609,32:rem length of keyboard click
for a=1 to 16
  read a$
  print paper 7;" ";
  for b=0 to 7: read c: poke usr a$+b,c: border b: next b
  print paper 7;" ";
next a
border 0
cls
print at 10,0; paper 0; ink 7;"pulsa ""i"" para ver instrucciones"'"     otra tecla para jugar      "
beep .1 ,23
pause 0:let s$=inkey$
if s$="i" or s$="I" then go sub @instructions
run

# ==============================================================
# subroutine

@l9300:

print at 4,4+ss;"\ :";at 4,6+ss;"\: "
print at 5,4+ss;"\ :";at 5,6+ss;"\: "
print at 6,4+ss;"\ :";at 6,6+ss;"\: "
print at 7,1+ss;"\:.\..\..\..";at 7,6+ss;"\..\..\..\.:"
print at 9,1+ss;"\''\''\''\':";at 9,6+ss;"\:'\''\''\''"
print at 10,4+ss;"\ :";at 10,6+ss;"\: "
print at 11,4+ss;"\ :";at 11,6+ss;"\: "
print at 12,4+ss;"\ :";at 12,6+ss;"\: "
return

# ==============================================================
# subroutine

@l9900:

let ss=int (rnd*11)+6: beep .3,-12
print at 0,15;"\h\h";at 1,15;"\f\f": beep .3,-12
for n=0 to 1: for m=0 to 6: border n: beep .003,n*m: border m: beep .002,30+n+m*2: next m: next n
border 2: flash 1
for n=0 to 9
print at n+3,ss+1; paper papercolor; ink papercolor;"         ": next n
flash 0

for n=2 to -1 step -1
  beep .003,27-n: beep .003,19-n: beep .003,29-n
  if n>=0 then ink n
  if n=-1 then flash 1: bright 0
  go sub @l9300
next n
print at 11,5+ss; ink papercolor; paper papercolor;"\o"
flash 0
print at 8,5+ss; flash 0;"\n"
return

# ==============================================================
# data

# graphics

data "a",24,24,36,195,195,36,24,24
data "b",90,90,36,219,219,36,90,153
data "c",165,165,66,90,40,189,126,129
data "d",72,84,73,62,8,28,62,62
data "e",18,42,146,124,16,56,124,124
data "f",8,16,8,186,93,16,8,16
data "g",90,90,36,195,195,36,90,153
data "h",0,0,0,0,60,126,165,165
data "k",0,0,0,0,0,0,85,170
data "m",192,32,18,13,63,16,32,192
data "n",0,0,192,192,78,74,91,112
data "o",0,0,0,0,60,126,0,0
data "p",0,132,204,180,132,132,132,0
data "q",0,144,152,148,146,145,144,0
data "r",0,159,144,158,144,144,159,0
data "s",0,31,32,30,1,33,30,0

# coordinates used in the instructions

@demoCoordinates:

data 15,6,15,6,15,6,15,6,15,6,14,6,13,6,13,7
data 13,8,12,8,11,8,11,7,11,6,11,5,11,4,11,3
data 11,2,11,1,11,0,10,0,9,0,8,0,7,0,6,0
data 5,0,4,0,3,0,3,1,3,2,3,3,3,4,3,5
data 3,6,3,7,3,8,3,9,3,10,3,11,3,12,3,13
data 3,14,3,15,3,16,3,17,2,17,1,17,0,17,0,17,0,17

# vim: ft=sinclairbasic
