unit flappybird;

interface 

uses crt, typesmenu, sysutils;

procedure jouerflappy(var score: SmallInt );
procedure scoreflappy(j1, score : Integer; var liste : TListeProfils);


implementation

Const
  LARGEUR_ECRAN = 80;
  HAUTEUR_ECRAN = 25;
  NB_OBJETS = 15;
  FRAME_DELAY = 60; 
  GRAVITY_TICKS = 1;
  OBJECT_MOVE_TICKS = 1;

Type TObjet = record
    x, y: integer;
    vitesse: integer;
    symbole: string;
    taille: Integer;
  end;
  
Type TOiseau = record
    x, y: integer;
  vie: integer;
  vy: integer; 
  end;
  
var
  oiseau : TOiseau;
  objet: array[1..NB_OBJETS] of TObjet; 
  tickCounter: Integer = 0; 

procedure InitObjet;
var 
  i: Integer;
begin 
  Randomize;
  for i := 1 to NB_OBJETS do
  begin
    objet[i].x := LARGEUR_ECRAN + Random(20);
    objet[i].y := Random(HAUTEUR_ECRAN - 4) + 4;
    objet[i].vitesse := Random(2) + 1;

    case objet[i].vitesse of
      1: objet[i].taille := 1; 
      2: objet[i].taille := 2; 
      3: objet[i].taille := 3;
      4: objet[i].taille := 4;
    end;

    case objet[i].taille of 
      1: objet[i].symbole := '$';
      2: objet[i].symbole := '#';
      3: objet[i].symbole := '~';  
      4: objet[i].symbole := '&';  
    end;
  end;
end;  

procedure AfficherObjets;
var
  i, j: Integer;
begin
  TextColor(LightRed);
  for i := 1 to NB_OBJETS do
  begin
    for j := 0 to objet[i].taille - 1 do
    begin
      if (objet[i].x + j >= 1) and (objet[i].x + j <= LARGEUR_ECRAN) and (objet[i].y >= 1) and (objet[i].y <= HAUTEUR_ECRAN) then
      begin
        GotoXY(objet[i].x + j, objet[i].y);
        Write(objet[i].symbole);
      end;
    end;
  end;
  TextColor(White);
end;

procedure AfficherOiseau;
begin
  if (oiseau.x>=1) and (oiseau.x<=LARGEUR_ECRAN) and (oiseau.y>=1) and (oiseau.y<=HAUTEUR_ECRAN) then
  begin
    GotoXY(oiseau.x, oiseau.y);
    TextColor(Yellow);
    Write('O');
    TextColor(White);
  end;
end;

procedure EffacerOiseau(x, y: Integer);
begin
  if (x>=1) and (x<=LARGEUR_ECRAN) and (y>=1) and (y<=HAUTEUR_ECRAN) then
  begin
    GotoXY(x, y);
    Write(' ');
  end;
end;

procedure DeplacerObjets;
var
  i: Integer;
begin
  if (OBJECT_MOVE_TICKS <= 1) or (tickCounter mod OBJECT_MOVE_TICKS = 0) then
  begin
    for i := 1 to NB_OBJETS do
    begin
      objet[i].x := objet[i].x - objet[i].vitesse;
    if objet[i].x < 1 then
    begin
      objet[i].x := LARGEUR_ECRAN;
      objet[i].y := Random(HAUTEUR_ECRAN - 4) + 4;
          objet[i].vitesse := Random(2) + 1;

      case objet[i].vitesse of
        1: objet[i].taille := 1; 
        2: objet[i].taille := 2; 
        3: objet[i].taille := 3;
        4: objet[i].taille := 4;
      end;

      case objet[i].taille of 
        1: objet[i].symbole := '$';
        2: objet[i].symbole := '#';
        3: objet[i].symbole := '~';  
        4: objet[i].symbole := '&';  
      end;
    end;
    end;
  end;
end;

procedure DeplacementOiseau;
var
  k: char;
begin
  // handle input: set upward velocity on flap, or quit on Enter
  if KeyPressed then
  begin
    k := ReadKey;
    if k = #0 then
      k := ReadKey;
    if (k = #72) or (k = ' ') or (k = 'w') or (k = 'W') then
    begin
      // instant upward impulse
      oiseau.vy := -3;
    end
    else if k = #13 then
    begin
      oiseau.vie := 0;
    end;
  end;

  // gravity: increase vertical speed, applied every GRAVITY_TICKS frames
  if (GRAVITY_TICKS <= 1) or (tickCounter mod GRAVITY_TICKS = 0) then
    oiseau.vy := oiseau.vy + 1;

  // apply vertical velocity
  if oiseau.vy <> 0 then
  begin
    EffacerOiseau(oiseau.x, oiseau.y);
    oiseau.y := oiseau.y + oiseau.vy;
    // clamp and detect ground
    if oiseau.y < 1 then
      oiseau.y := 1
    else if oiseau.y >= HAUTEUR_ECRAN then
    begin
      oiseau.y := HAUTEUR_ECRAN;
      oiseau.vie := 0;
    end;
    AfficherOiseau;
  end;
end;

procedure Collision;
var
  i: Integer;
begin
  for i := 1 to NB_OBJETS do
  begin
    if (objet[i].x <= oiseau.x + 1) and (objet[i].x + objet[i].taille >= oiseau.x) and
       (objet[i].y <= oiseau.y + 1) and (objet[i].y + 1 >= oiseau.y) then
    begin
      EffacerOiseau(oiseau.x, oiseau.y);
      oiseau.vie := oiseau.vie - 1;
      if oiseau.vie <= 0 then
      begin
        oiseau.vie := 0;
        AfficherOiseau;
        exit;
      end
      else
        AfficherOiseau;
    end;
  end;
end;

procedure explosion(x, y: Integer);
begin
  GotoXY(x, y);
  TextColor(Red);
  Write('*');
  TextColor(White);
end;

procedure EffacerObjets;
var
  i, j: Integer;  
begin
  for i := 1 to NB_OBJETS do
  begin
    for j := 0 to objet[i].taille - 1 do
    begin
      if (objet[i].x + j >= 1) and (objet[i].x + j <= LARGEUR_ECRAN) and (objet[i].y >= 1) and (objet[i].y <= HAUTEUR_ECRAN) then
      begin
        GotoXY(objet[i].x + j, objet[i].y);
        Write(' ');
      end;
    end;
  end;
end;

procedure InitialiserJeu;
begin
  clrscr;
  oiseau.x := 10;
  oiseau.y := HAUTEUR_ECRAN div 2;
  oiseau.vie := 3;
  oiseau.vy := 0;
  InitObjet;
  tickCounter := 0;
  AfficherOiseau;
  AfficherObjets;
end;

procedure MettreAJourJeu;
begin
  tickCounter := tickCounter + 1;
  EffacerObjets;
  DeplacerObjets;
  AfficherObjets;
  DeplacementOiseau;
  Collision;
end;

procedure MettreAJourScore(var score: SmallInt);
begin
  score := score + 1;
  GotoXY(1, 1);
  Write('Score: ', score);
  GotoXY(oiseau.x, oiseau.y); 
end;

procedure jouerflappy(var score: SmallInt);
var
  runScore: SmallInt;
  sessionBest: SmallInt;
  ch: char;
begin
  sessionBest := score;
  repeat
    runScore := 0;
    InitialiserJeu;
    GotoXY(1, 1);
    Write('Score: ', runScore);
    GotoXY(oiseau.x, oiseau.y);
    repeat
      MettreAJourJeu;
      MettreAJourScore(runScore);
      Delay(FRAME_DELAY);
    until oiseau.vie <= 0;
    if runScore > sessionBest then
      sessionBest := runScore;

    GotoXY(LARGEUR_ECRAN div 2 - 10, HAUTEUR_ECRAN div 2);
    TextColor(Red);
    Write('Game Over');
    GotoXY(LARGEUR_ECRAN div 2 - 16, HAUTEUR_ECRAN div 2 + 1);
    if runScore = sessionBest then
      Write('New session best: ', sessionBest)
    else
      Write('Session best: ', sessionBest);
    TextColor(White);
    GotoXY(LARGEUR_ECRAN div 2 - 18, HAUTEUR_ECRAN div 2 + 3);
    Write('Press R to replay, Enter to quit');
    repeat
      ch := ReadKey;
      if ch = #0 then ch := ReadKey;
    until (ch = 'r') or (ch = 'R') or (ch = #13);
  until ch = #13;
  if sessionBest > score then
    score := sessionBest;
  delay(500);
  clrscr;
end;
 
procedure scoreflappy(j1, score: Integer; var liste : TListeProfils);
begin
  if score > liste.profils[j1].scores[3] then
    liste.profils[j1].scores[3] := score;
end;

end.
