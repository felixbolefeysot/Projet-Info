unit flappybird;

interface 

uses crt, typesmenu, sysutils;

procedure jouerflappy(var score: SmallInt; var oiseau: TOiseau; var objet: array of TObjet; var modCompte: Integer);
procedure scoreflappy(j1, score : Integer; var liste : TListeProfils);

implementation

Const
  LARGEUR_ECRAN = 80;
  HAUTEUR_ECRAN = 25;
  NB_OBJETS = 9; 
  DELAI = 100; 
  GRAVITE_MOD = 2; 
  OBJET_MOVE_MOD = 1;
  MIN_OISEAU_Y = 4; 

type TObjet = record
    x, y: integer;
    vitesse: integer;
    symbole: string;
    taille: Integer;
    oldX: Integer;
    oldY: Integer;
    oldTaille: Integer;
  end;
  
type TOiseau = record
    x, y: integer;
    dead: boolean;
    vy: integer;
    oldX: Integer;
    oldY: Integer;
  end;

procedure InitObjet(var objet: array of TObjet);
var i: Integer;
begin
  Randomize;
  for i := 0 to High(objet) do
  begin
    objet[i].x := LARGEUR_ECRAN + Random(40);
    objet[i].y := Random(HAUTEUR_ECRAN - 4) + 4;
    objet[i].vitesse := Random(2) + 1;
    objet[i].oldX := objet[i].x;
    objet[i].oldY := objet[i].y;
    objet[i].oldTaille := 1;

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

    objet[i].oldTaille := objet[i].taille;
  end;
end;

procedure AfficherObjets(var objet: array of TObjet);
var i, j: Integer;
begin
  TextColor(LightRed);
  for i := 0 to High(objet) do
  begin
    for j := 0 to objet[i].taille - 1 do
    begin
      if (objet[i].x + j >= 1) and (objet[i].x + j <= LARGEUR_ECRAN) and (objet[i].y >= 1) and (objet[i].y <= HAUTEUR_ECRAN) then
      begin
        GotoXY(objet[i].x + j, objet[i].y);
        Write(objet[i].symbole);
      end;
    end;
    objet[i].oldX := objet[i].x;
    objet[i].oldY := objet[i].y;
    objet[i].oldTaille := objet[i].taille;
  end;
  TextColor(White);
end;

procedure AfficherOiseau(var oiseau: TOiseau);
begin
  if (oiseau.x>=1) and (oiseau.x<=LARGEUR_ECRAN) and (oiseau.y>=1) and (oiseau.y<=HAUTEUR_ECRAN) then
  begin
    GotoXY(oiseau.x, oiseau.y);
    TextColor(Yellow);
    Write('O');
    TextColor(White);
    oiseau.oldX := oiseau.x;
    oiseau.oldY := oiseau.y;
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

procedure DeplacerObjets(var objet: array of TObjet; var modCompte: Integer);
var i: Integer;
begin
  if (OBJET_MOVE_MOD <= 1) or (modCompte mod OBJET_MOVE_MOD = 0) then
  begin
    for i := 0 to High(objet) do
    begin
      objet[i].x := objet[i].x - objet[i].vitesse;
      if objet[i].x < 1 then
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
  end;
end;

procedure DeplacementOiseau(var oiseau: TOiseau; var modCompte: Integer);
var k: char;
begin
  if KeyPressed then
  begin
    k := ReadKey;
    if k = #0 then k := ReadKey;
    if (k = #72) or (k = ' ') or (k = 'w') or (k = 'W') then
      oiseau.vy := -2
    else if k = #13 then
      oiseau.dead := True;
  end;

  if (GRAVITE_MOD <= 1) or (modCompte mod GRAVITE_MOD = 0) then
    oiseau.vy := oiseau.vy + 1;

  if (oiseau.oldX >= 1) and (oiseau.oldY >= 1) then
    EffacerOiseau(oiseau.oldX, oiseau.oldY);

  oiseau.y := oiseau.y + oiseau.vy;

  if oiseau.y < MIN_OISEAU_Y then
  begin
    oiseau.y := MIN_OISEAU_Y;
    oiseau.vy := 0;
  end
  else if oiseau.y >= HAUTEUR_ECRAN then
  begin
    oiseau.y := HAUTEUR_ECRAN;
    oiseau.dead := True;
  end;

  AfficherOiseau(oiseau);
end;

procedure explosion(x, y: Integer);
begin
  GotoXY(x, y);
  TextColor(Red);
  Write('*');
  TextColor(White);
end;

procedure Collision(var oiseau: TOiseau; var objet: array of TObjet);
var i: Integer;
begin
  for i := 0 to High(objet) do
  begin
    if (objet[i].x <= oiseau.x + 1) and (objet[i].x + objet[i].taille >= oiseau.x) and
       (objet[i].y <= oiseau.y + 1) and (objet[i].y + 1 >= oiseau.y) then
    begin
      EffacerOiseau(oiseau.x, oiseau.y);
      explosion(oiseau.x, oiseau.y);
      oiseau.dead := True;
      exit;
    end;
  end;
end;

procedure EffacerObjets(var objet: array of TObjet);
var i, j: Integer;
begin
  for i := 0 to High(objet) do
  begin
    for j := 0 to objet[i].oldTaille - 1 do
    begin
      if (objet[i].oldX + j >= 1) and (objet[i].oldX + j <= LARGEUR_ECRAN) and (objet[i].oldY >= 1) and (objet[i].oldY <= HAUTEUR_ECRAN) then
      begin
        GotoXY(objet[i].oldX + j, objet[i].oldY);
        Write(' ');
      end;
    end;
  end;
end;

procedure InitialiserJeu(var oiseau: TOiseau; var objet: array of TObjet; var modCompte: Integer);
begin
  clrscr;
  oiseau.x := 10;
  oiseau.y := HAUTEUR_ECRAN div 2;
  oiseau.dead := False;
  oiseau.vy := 0;
  InitObjet(objet);
  modCompte := 0;
  AfficherOiseau(oiseau);
  AfficherObjets(objet);
end;

procedure MettreAJourJeu(var oiseau: TOiseau; var objet: array of TObjet; var modCompte: Integer);
begin
  modCompte := modCompte + 1;
  EffacerObjets(objet);
  DeplacerObjets(objet, modCompte);
  AfficherObjets(objet);
  DeplacementOiseau(oiseau, modCompte);
  Collision(oiseau, objet);
end;

procedure MettreAJourScore(var score: SmallInt; var oiseau: TOiseau);
begin
  score := score + 1;
  GotoXY(1, 1);
  Write('Score: ', score);
  GotoXY(oiseau.x, oiseau.y);
end;

procedure jouerflappy(var score: SmallInt; var oiseau: TOiseau; var objet: array of TObjet; var modCompte: Integer);
var runScore, sessionBest: SmallInt;
    ch: char;
begin
  sessionBest := score;
  writeln('utilisez la flèche du haut pour sauter, appuyez sur une touche pour commencer...');
  ReadKey;
  CursorOff;
  repeat
    runScore := 0;
    InitialiserJeu(oiseau, objet, modCompte);
    GotoXY(1, 1);
    Write('Score: ', runScore);
    GotoXY(oiseau.x, oiseau.y);
    repeat
      MettreAJourJeu(oiseau, objet, modCompte);
      MettreAJourScore(runScore, oiseau);
      Delay(DELAI);
    until oiseau.dead;

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

  clrscr;
  writeln('session best: ', sessionBest);
  if sessionBest > score then score := sessionBest;
  delay(1500);
  clrscr;
  CursorOn;
end;

procedure scoreflappy(j1, score: Integer; var liste: TListeProfils);
begin
  if score > liste.profils[j1].scores[3] then
    liste.profils[j1].scores[3] := score;
end;

end.
