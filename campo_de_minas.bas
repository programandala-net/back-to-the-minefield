# ZX Spectrum "Minefield", by Ian Andrew
# Spanish version "Campo de minas", published by Indescomp
#
# Fork by Marcos Cruz (programandala.net):
# 2016-06-04: Remove embedded control codes. Print to a text file.
# Restore UDGs, using the notation of zmakebas. Use cursor keys.

LET inkColor=9: LET bonus=0: LET level=1: LET damsels=1: LET highScore=250 : LET DAMSELS=1
LET H$="IAN"
let k$=chr$ 8+chr$ 9+chr$ 11+chr$ 10:rem cursor keys

@l6:
IF damsels>2 THEN goto @l5700
LET mines=50: LET damsels=1: LET score=0: LET bonus=0: 
LET paperColor=6: LET borderColor=0
@l10:
BORDER borderColor: PAPER paperColor: INK inkColor: CLS
LET x=21: LET y=15
LET t$=CHR$ (x+65)+CHR$ (y+65)
LET XX=21: LET YY=15
LET TI=0
LET oldx=x: LET oldy=y
LET C$="\a": LET V$="\b"
LET CC=0: LET DD=0: LET EE=0
LET RR=1
LET OO=21: LET PP=15
LET X$="                                 < ZONA SEGURA >                                 "
LET PA=7
LET ss=0
IF level<>1 THEN PRINT AT 15,0;: LIST
goto @l300

@l100:
LET RN=INT (RND*13)+4
FOR a=3 TO 30
  IF A=10 OR A=20 THEN NEXT A
  PRINT AT 21,19; PAPER PAPER; INK 9;"MAS MINAS "
  IF ATTR (RN,A)=56 THEN goto @l115
  PRINT AT RN,a;"\m"
  @l115:
  LET K=RN-1+INT (RND*3)
  IF ATTR (K,A-1)<>56 THEN PRINT AT K,a-1;"\o"
  BEEP .002,55
  PRINT AT 21,19;"          "
  IF ATTR (RN,A)=56 THEN goto @l150
  PRINT AT RN,A;" "
  @l150:
NEXT a
goto @l570

@l300:
PRINT AT 0,28; PAPER 0;"    "
PRINT AT 0,0; PAPER 0; INK 7;"MINAS VECINAS 0";AT 0,17;"NO.";DAMSELS;" PUNT. ";score
PRINT AT 1,0;"\f\f\f\f\f\f\f\f\f\f\f\f\f\f\f  \f\f\f\f\f\f\f\f\f\f\f\f\f\f\f"
FOR n=2 TO 19
  PRINT AT n,0;"\f                              \f"
NEXT n
PRINT AT 20,0;"\f\f\f\f\f\f\f\f\f\f\f\f\f\f   \f\f\f\f\f\f\f\f\f\f\f\f\f\f\f"
PRINT AT x,y;C$
NEXT n: IF score=0 AND DAMSELS>2 AND BONUS=0 THEN PRINT AT 15,0;: LIST
PRINT AT 21,17; FLASH 1; PAPER 2; INK 7;"PONIENDO MINAS": IF damsels=9 THEN LET mines=mines+32: LET MINES=MINES+(10-INT (score/1000))
PRINT AT 21,3; FLASH 1; PAPER 2; INK 7; INVERSE 1;"NIVEL ";DAMSELS
FOR w=1 TO mines
  PRINT AT INT (RND*16)+3,INT (RND*30)+1; INK paperColor;"\o"
  BEEP .0015,35
  IF DAMSELS<>1 THEN NEXT W
  IF DAMSELS<>1 THEN goto @l439
  PRINT AT 19,1;X$(W TO W+29)
  PRINT AT 2,1;X$(51-W TO 51-W+29)
NEXT W
@l439:
IF level<>1 THEN PRINT AT 15,0;: LIST
PRINT AT 10,1; INK PaperColor;"\o";AT 11,15;"\o\o";AT 10,30;"\o"
PRINT AT 21,0;"                               "
IF DAMSELS=1 THEN goto @l480
IF damsels=9 THEN gosub @l9900: goto @l480
PRINT AT 21,0; INVERSE 1; BRIGHT 1;"RESCATA A LAS POBRES DAMISELAS !": goto @l450
@l450:
LET CC=INT (RND*12)+4: LET DD=INT (RND*6)+6: LET EE=INT (RND*6)+19
FOR J=1 TO 7
  PRINT AT CC,DD;"\d";AT CC,EE;"\d"
  FOR E=1 TO 11: NEXT E
  BEEP .002,58
  PRINT AT CC,DD;"\e";AT CC,EE;"\e"
  FOR E=1 TO 11: NEXT E
  BEEP .002,58
NEXT J
@l480:
IF damsels<>8 THEN goto @l490
PRINT AT 21,0; INK 7; FLASH 1; PAPER 0; BRIGHT 1;"PONTE ENTRE 3 MINAS PARA ABRIR  "
PRINT AT 1,15;"\f\f": PRINT AT 8,9; INK 1; BRIGHT 1; PAPER 7;"PUERTA CERRADA"
FOR m=60 TO 10 STEP -2.5
  FOR n=1 TO 7: NEXT n
  BEEP .125,m
NEXT m
PRINT AT 21,0;"                                "
PRINT AT 8,9;"              "
@l490:
BEEP .0875,10
PRINT AT 21,0;"               \a                "
PRINT AT 21,31; INK paperColor; PAPER paperColor;"\h"
PRINT AT 21,4; INVERSE 1;"ADELANTE!"
FOR n=1 TO 20
  BEEP .002,n+20
NEXT n
PRINT AT 21,4;"         ": BEEP .05,37
goto @l535

@l500:
LET oldx=x: LET oldy=y
@l520:
LET x=x+(INKEY$=k$(4))-(INKEY$=k$(3))
LET x=x-(x=22)
LET y=y+(INKEY$=k$(2))-(INKEY$=k$(1))
LET TI=TI+1
IF DAMSELS>=4 THEN IF TI>(260*PAPER+70) THEN IF INT (TI/(3*PAPER+1))=(TI/(3*PAPER+1)) THEN gosub @l543
IF oldx=x AND oldy=y THEN goto @l520
BEEP .003,-4
@l535:
PRINT AT oldx,oldy; PAPER PA;" "
LET t$=t$+CHR$ (x+65)+CHR$ (y+65)
IF SCREEN$ (x,y)<>" " THEN gosub @l1000
IF damsels=9 AND pa<>paperColor AND x<17 THEN gosub @l8000
goto @l550

# subroutine

@l543:
PRINT AT OO,PP; PAPER PA;" "
LET I$=T$+T$: IF DAMSELS>=5 AND paperColor<>PA AND TI>2000 THEN gosub @l8000
LET RR=RR+2: BEEP .0018,60
LET OO=65-CODE I$(RR): LET PP=65-CODE I$(RR+1)
IF SCREEN$ (OO,PP)<>" " THEN gosub @l1000
PRINT AT OO,PP; PAPER PA;"\h"
RETURN


@l550:
PRINT AT x,y; PAPER PA;C$
@l570:
LET o=(SCREEN$ (x-1,y)<>" ")
LET p=(SCREEN$ (x+1,y)<>" ")
LET q=(SCREEN$ (x,y-1)<>" ")
LET r=(SCREEN$ (x,y+1)<>" ")
LET o=o+p+q+r
IF o THEN BEEP .04,o*10
PRINT AT 0,0; PAPER (4-O); INK 9;"MINAS VECINAS ";O
IF x=0 THEN gosub @l3000
IF o=3 AND damsels=8 THEN PRINT AT 8,9; FLASH 1;"PUERTA ABIERTA": FOR c=1 TO 40: BEEP .001,30+c/4: BORDER 0: BORDER 7: NEXT c: PRINT AT 1,15;"  ": PRINT AT 8,9;"              ": BORDER 2

# subroutine

@l800:
IF damsels>2 AND damsels<9 AND ti>50 THEN IF RND>.98 THEN goto @l100
goto @l500
STOP

# subroutine

@l1000:
IF X=CC THEN IF Y=DD OR Y=EE THEN gosub @l6000: RETURN
IF damsels=9 THEN IF x=8 AND y=5+ss THEN goto @l8444
FOR W=20 TO 1 STEP -1
  BEEP .003,0+W: PRINT AT X,Y;"\c"
  BEEP .002,10: PRINT AT X,Y;"\o"
NEXT W
LET j$=" HAS EXPLOTADO! "
IF RND>.8 THEN LET j$="  HAS VOLADO!   "
IF RND>.7 THEN LET j$="  DESTRUCCION!  "
PRINT AT 0,0; PAPER 0; INK 7;j$
BEEP 1.6,-35
gosub @l2000
PRINT AT X,Y; PAPER 7; INK 0; OVER 1;CHR$ (65+INT (RND*60))
BEEP 1,-35
IF score>highScore THEN gosub @newRecord
PRINT AT 0,28; PAPER 0;"  "
PRINT AT 0,0; PAPER 0; INK 7;" ";"OTRA VEZ?    NIVEL ";DAMSELS;" ";AT 0,22; FLASH 1;"PUNT. ";score
PRINT AT 2,1; PAPER 0; INK 7;" PULSA UNA TECLA (""I"" = INFO) "
PRINT AT 10,9; INK 7; PAPER 2; BRIGHT 1;"   SE ACABO   "
IF paperColor>=4 THEN INK 0
IF paperColor<4 THEN INK 7
PLOT 72,96: DRAW 112,0: DRAW 0,-9: DRAW -113,0: DRAW 0,9
INK 9

# subroutine

@l2000:
FOR n=1 TO 20: NEXT n
FOR a=1 TO 21
  PRINT AT a,0; OVER 1; INK 9;"                                "
NEXT a
PRINT AT 21,1; FLASH 1; PAPER 7; INK 0;" REPETICION  "
FOR n=1 TO 100: NEXT n
LET y$=t$
FOR t=1 TO LEN y$ STEP 2
  FOR m=1 TO 5: IF INKEY$="S" OR INKEY$="s" THEN goto @l2033: NEXT m
  @l2033:
  PRINT AT XX,YY; PAPER 7;" "
  IF damsels>1 AND T=21 THEN PRINT AT 21,0; PAPER 0; INK 7;"""S""= MAS RAPIDO, ""E""= TERMINAR  "
  LET xX=CODE y$(1)-65: LET yY=CODE y$(2)-65
  PRINT AT Xx,Yy; PAPER 7;C$
  BEEP .005,5+(T*40/(LEN T$))
  LET y$=y$(3 TO )
  IF INKEY$="E" OR INKEY$="e" THEN goto @l2055
NEXT t
@l2055:
PRINT AT 21,0;"                                "
RETURN

# subroutine

@l3000:
LET SS=(INT ((2000-TI)/50))*5: IF SS<50 THEN LET SS=50
LET SS=SS*DAMSELS
PRINT AT 0,0; PAPER DAMSELS/1.5; INK 9;"NIVEL ";DAMSELS;"  PUNTOS POR TIEMPO= ";SS;
IF damsels=1 AND ss<100 THEN PRINT AT 0,31; PAPER 1;" "
PRINT AT 1,0;"\f"
FOR N=15 TO 50: BEEP .001+((50-30)/2000),(50+N/2.8): BORDER 2: BORDER 7: BORDER 0: NEXT N
BORDER borderColor
IF bonus>0 THEN LET score=score+bonus: PRINT AT 21,0; PAPER 7; BRIGHT 1;"BONOS INICIALES = ";BONUS: LET BONUS=0: FOR N=1 TO 20 STEP .6: BEEP .025,n+5: NEXT N: PRINT AT 21,0;"                                "
gosub @l2000
FOR g=4 TO 22 STEP 6: BEEP .005,g+24: NEXT g
FOR N=1 TO 80
  BORDER 1: BORDER 2: BORDER 3: BORDER 4: BORDER 5: BORDER 6
NEXT N
LET score=score+SS
PRINT AT 0,30; PAPER 0;"  "
PRINT AT 0,0; PAPER 0; INK 7;"MINAS VECINAS 0  NO.";DAMSELS;" PUNT ";score
FOR n=1 TO 120
NEXT n
LET MINES=MINES+10
LET papercolor=paperColor-1
LET DAMSELS=DAMSELS+1
IF PAPERcolor<0 THEN LET BORDERcolor=BORDERcolor+2: LET PAPERcolor=6
IF PAPERcolor=6 THEN LET MINES=50
IF damsels=7 THEN LET mines=20
goto @l10

# subroutine

@newRecord:
FOR N=1 TO 50
  BORDER 1: BORDER 2: BORDER 3: BORDER 4
NEXT N
IF DAMSELS=1 THEN LIST
FOR N=1 TO 50
  BORDER 6: BORDER 2: BEEP .002,40+(N/10): BORDER 6
NEXT N
FOR M=1 TO 4
  FOR N=7 TO 0 STEP -1
    PRINT AT 10,7; INK N;"UN NUEVO RECORD!"
    BEEP .004,50-N
  NEXT N
NEXT M
PRINT AT 10,7; INK 9;"UN NUEVO RECORD!"
FOR N=1 TO 6
  PRINT AT 0,15;"\d\e"
  FOR L=1 TO 7: NEXT L
  BEEP .006,13
  PRINT AT 0,15;"\e\d"
  FOR L=1 TO 7: NEXT L
  BEEP .006,16
NEXT N
PRINT AT 21,0; FLASH 1; PAPER 1; INK 7;"INTRODUCE TUS INICIALES"; FLASH 0;"         "
LET Q$="   "
FOR N=1 TO 3
  @l5088:
  LET Q$(N)=INKEY$
  IF Q$(N)=" " THEN goto @l5088
  IF CODE Q$(N)>=97 AND CODE Q$(N)<=122 THEN LET Q$(N)=CHR$ ((CODE Q$(N))-32)
  PRINT AT 21,(24+(2*N)); INK 7; PAPER 1;Q$(N)
  BEEP .12,(N*5)+20
  FOR m=1 TO 4: NEXT m
NEXT N
LET H$=Q$: LET highScore=score
PRINT AT 21,0; PAPER 7; INK 0;"         MUY BIEN  ";H$;"          "
FOR N=1 TO 12
  BEEP .0045,-10: BORDER 1: BORDER 2: BORDER 6: BORDER 4
NEXT N
BORDER bordercolor
BEEP .1,8
FOR N=1 TO 4: NEXT N
BEEP .1,8: BEEP .1,8: BEEP .1,20: BEEP .1,24: BEEP .1,18: BEEP .15,29
FOR N=1 TO 7: NEXT N
BEEP .12,22
FOR N=1 TO 3: NEXT N
BEEP .07,19: BEEP .08,17
FOR N=1 TO 3: NEXT N
BEEP .1,14: BEEP .1,12
PRINT AT 10,7;"                  "
RETURN

@l5700:
LET level=damsels-1
LET z$="   Desde que nivel empiezas?      "
FOR n=0 TO 21: PAPER paperColor: BEEP .002,n+5: PRINT AT n,0; OVER 1;"\::                              \::": NEXT n
FOR n=1 TO 21: NEXT n: FOR n=0 TO 31: PAPER paperColor: INK paperColor: PLOT n*8,0: DRAW 0,175
BEEP .0015,64: BEEP .0015,59
PRINT AT 10,n; PAPER INT (RND*6); INK 9;z$(n+1)
NEXT n
INK 9: IF score=0 AND bonus=0 THEN PRINT AT 15,0;: LIST
PRINT AT 13,13; FLASH 1;"1";AT 13,14;" A ";AT 13,18; FLASH 1;level
PRINT AT 13,13; FLASH 1;"1"
PRINT AT 13,14;" A "
PRINT AT 13,18; FLASH 1;level
BEEP .1,30
FOR n=1 TO 25: NEXT n

@l5751:
LET l$=INKEY$: IF l$="" THEN goto @l5751
PRINT AT 21,0; INK paperColor; PAPER paperColor; INVERSE 1;"     VUELVE A INTENTARLO !!     "
PRINT AT 0,0; INK paperColor; PAPER paperColor; INVERSE 1;"     VUELVE A INTENTARLO !!     "
IF CODE l$<49 OR CODE l$>57 THEN BEEP 1,-15: goto @l5700
LET ll=VAL l$
IF ll>level OR ll<>(INT ll) OR ll<1 THEN BEEP 1,-15: goto @l5700
LET score=0
LET damsels=ll
IF ll=1 THEN LET paperColor=6: LET borderColor=0: LET mines=50: LET bonus=0
FOR n=30 TO 34: BEEP .006,n: NEXT n
IF ll=2 THEN LET paperColor=5: LET borderColor=0: LET mines=60: LET bonus=250
IF ll=3 THEN LET paperColor=4: LET borderColor=0: LET mines=70: LET bonus=750
IF ll=4 THEN LET paperColor=3: LET borderColor=0: LET mines=80: LET bonus=1500
IF ll=5 THEN LET paperColor=2: LET borderColor=0: LET mines=90: LET bonus=2200
IF ll=6 THEN LET paperColor=1: LET borderColor=0: LET mines=100: LET bonus=2700
IF ll=7 THEN LET paperColor=0: LET borderColor=0: LET mines=20: LET bonus=3500
IF ll=8 THEN LET paperColor=6: LET borderColor=2: LET mines=50: LET bonus=4200
IF LL=9 THEN LIST
LET level=1
goto @l10
STOP

# subroutine

@l6000:
PRINT AT X,Y;V$: LET C$=V$
PAPER 7: LET C$=V$
FOR U=25 TO 50 STEP 5: PRINT AT X,Y;"\g"
FOR N=1 TO 8 STEP 2: BEEP .002,n+u
LET score=score+5
PRINT AT 0,21; PAPER 0; INK 7;" SCORE ";score
NEXT n
PRINT AT X,Y;"\d"
FOR N=1 TO 8 STEP 2: BEEP .002,n+u
NEXT n
NEXT U
LET ti=ti+35
PAPER paperColor
RETURN

# subroutine: Instructions

@l7000:
LET P=0
BORDER 1: PAPER 1: CLS : INK 7
PRINT AT 0,0;"     INDESCOMP PRESENTA ...."
FOR n=1 TO 60: NEXT n
FOR N=2 TO 16
PRINT AT N,0;"                                ": REM XXX TODO -- color
NEXT N
BEEP .2,30: BEEP .1,20: FOR N=1 TO 5: NEXT N: BEEP .075,26: BEEP .125,26: BEEP .1,18
PRINT AT 0,0;"PRUEBA TU ESTRATEGIA Y HABILIDAD"
FOR N=47 TO 56 STEP 3
PRINT AT 9,9; PAPER P; OVER 0; INK 9;"CAMPO DE MINAS": CIRCLE INK 7;128,99,N: LET P=P+2
NEXT N
INK 9
PRINT AT 18,0;"""RESCATA A BILL EL GUSANO DE UNAHORRIBLE JUBILACION"""
PRINT AT 9,9; INK 0; PAPER 7; FLASH 1;"CAMPO DE MINAS"
PAPER 8: FOR N=3 TO 17: PRINT AT N-1,4; PAPER 8;"\o";AT N-1,27;"\o": PRINT AT 19-n,3;"\o";AT 19-n,5;"\o";AT 19-n,26;"\o";AT 19-n,28;"\o"
BEEP .005,33: NEXT N: PAPER 1
gosub @l7057
goto @l7080

# subroutine

@l7057:
PRINT AT 21,17; INVERSE 1;"PULSA UNA TECLA"
FOR n=1 TO 60: NEXT n
@l7060:
IF INKEY$="" THEN goto @l7060
PAPER 7: INK 0
CLS
RETURN

@l7080:
PRINT AT 2,0;"\* CAMPO DE MINAS! Por Ian Andrew"
PRINT ''" TU MISION: (deberas decidir     si la aceptas) LLEGAR HASTA     BILL EL GUSANO Y RESCATARLE"''" EL ESTA DURMIENDO EN EL ULTIMO  CAMPO DE MINAS (NIVEL 9)"
PRINT '" ESTE ES BILL ""\n"""
PRINT ''" TU, ""\a"", COMIENZAS EN LA PARTE  INFERIOR DE LA PANTALLA."
PRINT '" TU OBJETIVO: ALCANZAR LA PUERTA DE LA PARTE SUPERIOR."
PRINT AT 21,17; INVERSE 1;"PULSA UNA TECLA"
FOR N=1 TO 40: NEXT N
FOR N=1 TO 50000: IF INKEY$="" THEN NEXT N
RESTORE @l9980
FOR N=1 TO 47
  READ I: READ L:
  PRINT AT I,L;"\a": BEEP .035,N/2
  PRINT AT I,L;" "
NEXT N
CLS
PRINT AT 1,0;" MUEVETE UTILIZANDO LAS TECLAS   5,6,7 Y 8 [ VER LAS FLECHAS ]"
PRINT ''" MINAS:  ""\o"" SON DESAGRADABLES"''" EN LA PARTE SUPERIOR IZQUIERDA  DE LA PANTALLA SE TE INDICARA   CUANTAS SE ENCUENTRAN A TU AL-  REDEDOR."
REM "HELLO THERE"
PRINT '" SOLO SE VIVE UNA VEZ                   NO PISES LAS MINAS "
PRINT ''" DAMISELAS - CUENTAN COMO MINAS  PERO SI TE ENCUENTRAS JUNTO A   UNA DE ELLAS NO DUDES EN CORRER A RESCATARLA. SERAS AMPLIAMENTE RECOMPENSADO."
gosub @l7057
PRINT AT 2,0;" EL BICHO ""\h"" (mina con patas)   TE PERSEGUIRA SIN DESCANSO -    PUEDE VOLVERSE MUY AGRESIVO."
FOR n=1 TO 15: NEXT n
LET j$="                                 \a        \h                                        "
FOR n=1 TO LEN j$-35
  PRINT AT 6,0;j$(n TO n+31): BEEP .0018,60
  FOR m=1 TO 1: NEXT m
NEXT n
PRINT " Y AHORA ALGUNOS..."''" TRUCOS - EN LAS ZONAS SEGURAS   NO HAY MINAS, POR ESO DIRIGETE  A LA ZONA SUPERIOR (NO SOLO A   LA PUERTA) Y DESDE ALLI VETE A  LA PUERTA TRANQUILAMENTE.       CUANDO ESTE PULULANDO EL BICHO  (NIVEL 4 O MAS) MUEVETE CONTI-  NUAMENTE. NORMALMENTE TE MOVE-  RAS MAS DEPRISA QUE EL."
gosub @l7057
PRINT AT 3,0;" LA VERJA ESTA ELECTRIFICADA Y   CONTARA COMO UNA MINA SI ESTAS  JUNTO A ELLA."
PRINT AT 8,0;"\f\f\f\f\f\f\f\f\f\f\f\f\f\f\f\f\f\f\f\f\f\f\f\f\f\f\f\f\f\f\f\f"
FOR N=1 TO 2
  FOR O=0 TO 1
    PRINT AT 6+O,14;"\a"
    PRINT AT 0,0; PAPER (4-O); INK 9;"MINAS VECINAS ";O
    IF o THEN BEEP .04,o*10
    FOR M=1 TO 22: NEXT M: PRINT AT 6+O,14;" "
  NEXT O
NEXT N
PRINT AT 6,14;"\a": PRINT AT 0,0; PAPER 4; INK 9;"MINAS VECINAS 0"
PRINT AT 11,0;" IMPOSIBLE? - SI TE PARECE IMPO- SIBLE NO DESESPERES. LOS MINA-  DORES, ""\m"", NO SOLO PONEN MI-   NAS SINO QUE TAMBIEN LAS QUITAN (amables, No?) "
PRINT ''; PAPER 1; INK 7;"                                 PULSA ""I"" PARA VOLVER A VER     LAS INSTRUCCIONES, OTRA TECLA   PARA JUGAR                     "
@l7390:
LET s$=INKEY$: IF s$="" THEN goto @l7390
IF s$="I" OR s$="i" THEN goto @l7000
CLS
RETURN

# subroutine

@l8000:
LET PA=PAPER
PRINT AT 21,0; FLASH 1; BRIGHT 1; INK 7; PAPER 1;"TU MAPA HA EXPLOTADO!(LO SIENTO)"
PRINT AT 20,14; PAPER paperColor;"   "
FOR n=19 TO 2 STEP -.5
  BEEP .05,N-10
  IF damsels<=8 OR n>14 THEN PRINT AT N,1; OVER 1; INK PAPER; PAPER PAPER;"                              "
  PRINT AT X,Y; PAPER PA;C$
NEXT N
PRINT AT 20,14; PAPER PA;"   "
PRINT AT 21,0;"                                "
RETURN

@l8444:
gosub @l9300
LET DX=30
FOR u=.155 TO .005 STEP -.01
  IF damsels<>9 OR x<>8 THEN PRINT AT 15,0;: LIST
  PRINT AT 0,dx; INK 0; PAPER 7;"\n "
  LET dx=dx-1
  BEEP u,8: BEEP u,12: BEEP u,16
  BORDER RND*7
NEXT u
FOR n=1 TO 16
  PRINT AT 0,dx; INK 0; PAPER 7;"\n "
  LET dx=dx-1+(dx=0)
  BEEP u+.005,8
  BORDER RND*7
  BEEP u+.005,12: BEEP u,16
NEXT n
PRINT AT 0,0; PAPER 7;" "
FOR t=0 TO 2
FOR l=0 TO 7 STEP 7
  INK l: gosub @l8450
NEXT l
NEXT t
INK 0
gosub @l9300
PRINT AT 0,0; INK 7; PAPER 0;"    DOS MIL PUNTOS EXTRA!       "
LET score=score+2000
FOR b=0 TO 7
  PAPER B: INK 9: PRINT AT x,y;c$
  FOR n=1 TO 14
    BEEP .002,50-n+b
    BORDER 1: BORDER 2: BORDER 3: BORDER 4
    BORDER 5: BORDER 6: BORDER 7: BORDER b
  NEXT n
NEXT b
INK 9: BORDER 0: PAPER 0: CLS
FOR n=0 TO 30 STEP 6
  FOR m=1 TO 10
    BEEP .008,n+m
  NEXT m
NEXT n
PRINT AT 3,8;"  FELICIDADES  "
print '" HAS RESCATADO A BILL. EL MUN-   DO TE ESTA AGRADECIDO.         "
PRINT ''''';" TUS PUNTOS = ";score;", QUE NO ESTA"
print " NADA MAL ... POR QUE NO VUELVESA JUGAR Y TRATAS DE MEJORAR TU          PUNTUACION? "
IF score>highScore THEN gosub @newRecord
LET DAMSELS=1
PRINT AT 21,29; PAPER borderColor; INK 9;"   ";AT 21,0; PAPER borderColor; INK 9;" PUNTUACION MAX.= ";highScore;" POR ";H$
FOR n=1 TO 100: NEXT n
FOR N=1 TO 10000000
  IF score=highScore THEN PRINT AT 21,0; PAPER borderColor; INK 9;"\d";AT 21,31;"\e"
  IF INKEY$="" THEN FOR M=1 TO 16: NEXT M
  IF score=highScore THEN PRINT AT 21,0; PAPER borderColor; INK 9;"\e";AT 21,31;"\d"
  IF INKEY$="" THEN FOR M=1 TO 16: NEXT M
  LET s$=INKEY$
IF s$="" THEN NEXT n
IF S$="I" OR S$="i" THEN gosub @l7000
PRINT AT 2,1;"                              "
goto @l6

# subroutine

@l8450:
FOR n=1 TO 5
  PRINT AT x+n,y+n;"*"
  PRINT AT x-n,y+n;"*"
  PRINT AT x+n,y-n;"*"
  PRINT AT x-n,y-n;"*"
NEXT n
FOR n=1 TO 5
  PRINT AT x,y+n;">"
  PRINT AT x,y-n;"<"
  PRINT AT x+n,y;"#"
  PRINT AT x-n,y;"#"
NEXT n
RETURN

# start line

@start:
BORDER 1: PAPER 3: INK 9
CLEAR : RESTORE : PRINT AT 10,8;"PARA EL CASSETE"
PAPER 2: FOR g=1 TO 50: BEEP .000650,50+g/50: BORDER 5: BORDER 2: BORDER 3: BORDER 4: BORDER 1: BORDER 4: BORDER 6: BORDER 1: NEXT g
POKE 23609,32:rem length of keyboard click
PRINT AT 10,8;" NO TE VAYAS!  "
PRINT AT 0,0;" ";AT 0,31;" ";AT 21,0;" ";AT 21,31;" ":rem XXX TODO -- flash
FOR A=1 TO 16: READ A$: FOR B=0 TO 7: READ C: POKE USR A$+B,C: NEXT B: NEXT A
PRINT AT 10,0; PAPER 0; INK 7;"Pulsa ""I"" para ver INSTRUCCIONES"'"     otra tecla para jugar      "
BEEP .1 ,23
@l9095:
LET s$=INKEY$: IF s$="" THEN goto @l9095
IF s$="i" OR s$="I" THEN gosub @l7000
RUN

@l9200:
FOR n=2 TO -1 STEP -1
BEEP .003,27-n: BEEP .003,19-n: BEEP .003,29-n
IF n>=0 THEN INK n
IF n=-1 THEN FLASH 1: BRIGHT 0
gosub @l9300: goto @l9340

# subroutine
# XXX TODO -- move outside the loop

@l9300:
PRINT AT 4,4+ss;"\ :";AT 4,6+ss;"\: "
PRINT AT 5,4+ss;"\ :";AT 5,6+ss;"\: "
PRINT AT 6,4+ss;"\ :";AT 6,6+ss;"\: "
PRINT AT 7,1+ss;"\:.\..\..\..";AT 7,6+ss;"\..\..\..\.:"
PRINT AT 9,1+ss;"\''\''\''\':";AT 9,6+ss;"\:'\''\''\''"
PRINT AT 10,4+ss;"\ :";AT 10,6+ss;"\: "
PRINT AT 11,4+ss;"\ :";AT 11,6+ss;"\: "
PRINT AT 12,4+ss;"\ :";AT 12,6+ss;"\: "
RETURN

@l9340:
NEXT n

PRINT AT 11,5+ss; INK paperColor; PAPER paperColor;"\o"
FLASH 0
PRINT AT 8,5+ss; FLASH 0;"\n"
RETURN
STOP

# subroutine

@l9900:
LET ss=INT (RND*11)+6: BEEP .3,-12
PRINT AT 0,15;"\h\h";AT 1,15;"\f\f": BEEP .3,-12
FOR n=0 TO 1: FOR m=0 TO 6: BORDER n: BEEP .003,n*m: BORDER m: BEEP .002,30+n+m*2: NEXT m: NEXT n
BORDER 2: FLASH 1
FOR n=0 TO 9
PRINT AT n+3,ss+1; PAPER paperColor; INK paperColor;"         ": NEXT n
FLASH 0
goto @l9200

DATA "A",24,24,36,195,195,36,24,24
DATA "B",90,90,36,219,219,36,90,153
DATA "C",165,165,66,90,40,189,126,129
DATA "D",72,84,73,62,8,28,62,62
DATA "E",18,42,146,124,16,56,124,124
DATA "F",8,16,8,186,93,16,8,16
DATA "G",90,90,36,195,195,36,90,153
DATA "H",0,0,0,0,60,126,165,165
DATA "K",0,0,0,0,0,0,85,170
DATA "M",192,32,18,13,63,16,32,192
DATA "N",0,0,192,192,78,74,91,112
DATA "O",0,0,0,0,60,126,0,0
DATA "P",0,132,204,180,132,132,132,0
DATA "Q",0,144,152,148,146,145,144,0
DATA "R",0,159,144,158,144,144,159,0
DATA "S",0,31,32,30,1,33,30,0

@l9980:
DATA 15,6,15,6,15,6,15,6,15,6,14,6,13,6,13,7,13,8,12,8,11,8,11,7,11,6,11,5,11,4,11,3,11,2,11,1,11,0,10,0,9,0,8,0,7,0,6,0,5,0,4,0,3,0
DATA 3,1,3,2,3,3,3,4,3,5,3,6,3,7,3,8,3,9,3,10,3,11,3,12,3,13,3,14,3,15,3,16,3,17,2,17,1,17,0,17
DATA 0,17,0,17

# vim: ft=sinclairbasic
