DECLARE SUB BoxScore ()
DECLARE SUB EndGame ()
DECLARE SUB After ()
DECLARE SUB NewFrame ()
DECLARE SUB Setup ()
DECLARE SUB NewInning ()
DECLARE SUB AddRun (R AS INTEGER)
DECLARE SUB Advance (hit AS INTEGER)
DECLARE SUB PlayBall (R AS INTEGER)
DECLARE FUNCTION Fetch$ (R AS INTEGER)
DECLARE FUNCTION Roll% ()
REM Dice Baseball
REM VER 0.1
DEFINT A-Z
RANDOMIZE -TIMER: CLS
DIM SHARED P%(21), P$(21): REM Play number and name
DIM SHARED SI(10, 2): REM scores each inning
CONST TOP% = 1, BOTTOM% = 2: REM Frame nos.
REM R/H/E each team
DIM SHARED R(2), H(2), E(2)
DIM SHARED OnBase AS INTEGER: REM runners on base
REM 0: no runners, 1, 2, 3: one runner on 1st 2nd 3rd
REM 13: runners on 1st and 3rd, 23: runners un 2nd and 3rd etc.
DIM SHARED Team$(2): REM team names
DIM SHARED Inning, Frame, Outs AS INTEGER
CALL Setup
REM Main loop
DO WHILE i$ <> "Q"
  i$ = "": REM clear key
  PRINT "Any key to roll, or [Q]uit ";
  DO WHILE i$ = ""
    i$ = UCASE$(INKEY$)
  LOOP
  R = Roll
  CALL PlayBall(R)
  CALL After
  CALL BoxScore
LOOP
PRINT "Bye."
DATA 11,12,13,14,15,16
DATA 22,23,24,25,26
DATA 33,34,35,36,44,45
DATA 46,55,56,66
DATA "SINGLE","SAC BUNT","FLY OUT","POP OUT","GROUND OUT","SINGLE"
DATA "DOUBLE","FLY OUT","POP OUT","GROUND OUT","SINGLE"
DATA "TRIPLE","DOUBLE PLAY","GROUND OUT","FLY OUT","WALK","STRIKE OUT"
DATA "POP OUT","REACH ON ERROR","SAC FLY","HOME RUN"

SUB AddRun (Runs AS INTEGER)
  IF Runs > 0 THEN
    PRINT USING "& scores ## run(s)_!_!_!"; Team$(Frame); Runs
  END IF
  IF Inning > 9 THEN
    REM Account for extra inning scores
    SI(10, Frame) = SI(10, Frame) + Runs
  ELSE
    SI(Inning, Frame) = SI(Inning, Frame) + Runs
  END IF
  R(Frame) = R(Frame) + Runs
END SUB

SUB Advance (hit)
  R = 0
  SELECT CASE OnBase
    CASE 0: REM No runners on base
      OnBase = hit
      IF hit = 4 THEN
        R = 1: REM One HR
        OnBase = 0
      END IF
   
    CASE 1: REM Runner on 1st
      SELECT CASE hit
       CASE 0: REM Bunt
         OnBase = 2
       CASE 1: REM Single
         OnBase = 12
       CASE 2: REM Double
         OnBase = 13
       CASE 3: REM Triple
         OnBase = 3
         R = 1
       CASE 4: REM Home run
         OnBase = 0
         R = 2
       END SELECT
   
    CASE 2: REM Runner on 2nd
      SELECT CASE hit
       CASE 0: REM Bunt
         OnBase = 3
       CASE 1: REM Single
         OnBase = 12
       CASE 2: REM Double
         OnBase = 23
       CASE 3: REM Triple
         OnBase = 3
         R = 1
       CASE 4: REM Home run
         OnBase = 0
         R = 2
       END SELECT

    CASE 3: REM Runner on 3rd
      SELECT CASE hit
       CASE 0: REM Bunt
         OnBase = 0
         R = 1
       CASE 1: REM Single
         OnBase = 13
       CASE 2: REM Double
         OnBase = 23
       CASE 3: REM Triple
         OnBase = 3
         R = 1
       CASE 4: REM Home run
         OnBase = 0
         R = 2
       END SELECT
   
    CASE 12: REM Runners on 1st & 2nd
      SELECT CASE hit
       CASE 0: REM Bunt
         OnBase = 23
       CASE 1: REM Single
         OnBase = 123
       CASE 2: REM Double
         OnBase = 23
         R = 1
       CASE 3: REM Triple
         OnBase = 3
         R = 2
       CASE 4: REM Home run
         OnBase = 0
         R = 3
       END SELECT

    CASE 13: REM Runners on 1st & 3rd
      SELECT CASE hit
       CASE 0: REM Bunt
         OnBase = 2
         R = 1
       CASE 1: REM Single
         OnBase = 123
       CASE 2: REM Double
         OnBase = 23
         R = 1
       CASE 3: REM Triple
         OnBase = 3
         R = 2
       CASE 4: REM Home run
         OnBase = 0
         R = 3
       END SELECT

    CASE 23: REM Runners on 2nd & 3rd
      SELECT CASE hit
       CASE 0: REM Bunt
         OnBase = 3
         R = 1
       CASE 1: REM Single
         OnBase = 123
       CASE 2: REM Double
         OnBase = 23
         R = 1
       CASE 3: REM Triple
         OnBase = 3
         R = 2
       CASE 4: REM Home run
         OnBase = 0
         R = 3
       END SELECT

    CASE 123: REM Bases loaded!
      SELECT CASE hit
       CASE 0: REM Bunt
         OnBase = 23
         R = 1
       CASE 1: REM Single
         OnBase = 123
         R = 1
       CASE 2: REM Double
         OnBase = 123
         R = 2
       CASE 3: REM Triple
         OnBase = 3
         R = 3
       CASE 4: REM Home run
         OnBase = 0
         R = 4
       END SELECT

  END SELECT
  CALL AddRun(R)
END SUB

SUB After
  REM Stuff that happens AFTER play
  IF Outs >= 3 THEN
    IF R(TOP) <> R(BOTTOM) AND Inning = 9 THEN
      CALL EndGame
      END
    ELSE
      CALL NewFrame
    END IF
  END IF
END SUB

SUB BoxScore
  OT$ = "": OB$ = ""
  REM prints a * next to the team at bat
  IF Frame = TOP THEN
    OT$ = "*"
    OB$ = " "
  ELSE
    OT$ = " "
    OB$ = "*"
  END IF
  PRINT "           R  H  E"
  PRINT USING "!VISITOR: ## ## ##  ON BASE:###"; OT$; R(TOP); H(TOP); E(TOP); OnBase
  PRINT USING "!   HOME: ## ## ##     OUTS:  #"; OB$; R(BOTTOM); H(BOTTOM); E(BOTTOM); Outs
  IF Frame = TOP THEN
    PRINT "Top";
  ELSE
    PRINT "Bot";
  END IF
  PRINT Inning;
  SELECT CASE Inning
    CASE 1: PRINT "st"
    CASE 2: PRINT "nd"
    CASE 3: PRINT "rd"
    CASE ELSE: PRINT "th"
  END SELECT

END SUB

SUB EndGame
  PRINT "                 *** FINAL SCORE ***"
  PRINT "            1  2  3  4  5  6  7  8  9  X"
  PRINT USING "VISITOR:## "; R(TOP);
  FOR i = 1 TO 10
    PRINT SI(i, TOP);
  NEXT
  PRINT
  PRINT USING "   HOME:## "; R(BOTTOM);
  FOR i = 1 TO 10
    PRINT SI(i, BOTTOM);
  NEXT
  PRINT
  PRINT "BYE."
END SUB

FUNCTION Fetch$ (R AS INTEGER)
  FOR i = 1 TO 21
    IF R = P(i) THEN
      id = R
      EXIT FOR
    END IF
  NEXT
  Fetch$ = P$(i)
END FUNCTION

SUB NewFrame
  OnBase = 0: Outs = 0
  IF Frame = TOP THEN
  Frame = BOTTOM
  ELSE
    Frame = TOP
    Inning = Inning + 1
  END IF
  PRINT Team$(Frame); " at bat."
END SUB

SUB NewInning
  OnBase = 0
  Frame = TOP
END SUB

SUB PlayBall (R AS INTEGER)
REM Play ball depending on 2d6 roll
  REM handle edge cases first
  IF R = 12 AND (OnBase = 0 OR Outs = 2) THEN
    REM No sac bunt if nobody on base
    REM No sac bunt if 2 outs
    REM Bunt becomes single hit
    R = 11
  ELSEIF R = 34 AND OnBase = 0 THEN
    REM nobody on base, no double play
    REM play becomes ground out
    R = 15
  ELSEIF R = 56 AND (OnBase = 0 OR Outs = 2) THEN
    REM No Sac fly if nobody on base
    REM No Sac fly if 2 outs
    REM Sac fly becomes fly out
    R = 13
  END IF
  PRINT R; "- "; Fetch$(R)
  SELECT CASE R
    CASE 11, 16, 26
      REM Single
      H(Frame) = H(Frame) + 1
      CALL Advance(1)
    CASE 12: REM Sacrifice bunt
      Advance (0): REM 0 is special for bunt
      Outs = Outs + 1
    CASE 13, 14, 15, 23, 24, 25, 35, 36, 45, 46
      REM Fly Out, Pop Out, Ground Out etc.
      Outs = Outs + 1
    CASE 22: REM Double
      H(Frame) = H(Frame) + 1
      CALL Advance(2)
    CASE 33: REM Triple
      H(Frame) = H(Frame) + 1
      CALL Advance(3)
    CASE 34: REM Double play
      Outs = Outs + 2
    CASE 44: REM Walk
      CALL Advance(1)
    CASE 55: REM Reach On Error
      E(Frame) = E(Frame) + 1
      CALL Advance(1)
    CASE 56: REM Sacrifice fly
      CALL Advance(1)
      Outs = Outs + 1
    CASE 66: REM Home run
      H(Frame) = H(Frame) + 1
      CALL Advance(4)
    CASE ELSE
      PRINT "Uhmm... I'm confused. This wasn't supposed to happen."
  END SELECT
  IF Outs > 3 THEN Outs = 3
END SUB

DEFSNG A-Z
FUNCTION Roll%
  d1 = INT(RND * 6) + 1
  d2 = INT(RND * 6) + 1
  IF d1 > d2 THEN
    T = d1
    d1 = d2
    d2 = T
  END IF
  Roll = VAL(STR$(d1) + STR$(d2))
END FUNCTION

DEFINT A-Z
SUB Setup
  Team$(1) = "VISITOR"
  Team$(2) = "HOME"
  R(TOP) = 0: R(BOTTOM) = 0
  H(TOP) = 0: H(BOTTOM) = 0
  E(TOP) = 0: E(BOTTOM) = 0
  Inning = 0: Frame = BOTTOM
  REM Populate play array
  FOR i = 1 TO 21
    READ P(i)
  NEXT
  FOR i = 1 TO 21
    READ P$(i)
  NEXT
  PRINT "*** PLAY BALL! ***": PRINT
  CALL NewFrame
END SUB

