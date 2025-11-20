unit TronGame;

interface
uses crt, sysutils;

procedure JouerTron;

implementation

const
  LARGEUR_ECRAN = 80;
  HAUTEUR_ECRAN = 30;

type
  TDirection = (Haut, Bas, Gauche, Droite);
  TJoueur = record
    x, y, vie: integer;
    dir: TDirection;
    symbole: char;
  end;

var
  joueur1, joueur2: TJoueur;
  jeuActif: boolean;
  grille: array[1..LARGEUR_ECRAN, 1..HAUTEUR_ECRAN] of boolean;
  
procedure InitialiserGrille;
var
  i, j: integer;
begin
  for i := 1 to LARGEUR_ECRAN do
    for j := 1 to HAUTEUR_ECRAN do
      grille[i, j] := False;
      
  for i := 1 to LARGEUR_ECRAN do
  begin
    grille[i, 1] := True;
    grille[i, HAUTEUR_ECRAN] := True;
  end;

  for j := 1 to HAUTEUR_ECRAN do
  begin
    grille[1, j] := True;
    grille[LARGEUR_ECRAN, j] := True;
  end;
end;


procedure InitialiserJeu;
var i: integer;
begin
  clrscr;
  TextColor(Blue);

  InitialiserGrille;
  
  for i := 1 to LARGEUR_ECRAN do
  begin
    gotoxy(i,1); write('-');
    gotoxy(i,HAUTEUR_ECRAN); write('-');
  end;

  for i := 1 to HAUTEUR_ECRAN do
  begin
    gotoxy(1,i); write('|');
    gotoxy(LARGEUR_ECRAN,i); write('|');
  end;

  joueur1.x := 10;
  joueur1.y := HAUTEUR_ECRAN div 2;
  joueur1.dir := Droite;
  joueur1.symbole := '1';

  joueur2.x := LARGEUR_ECRAN - 10;
  joueur2.y := HAUTEUR_ECRAN div 2;
  joueur2.dir := Gauche;
  joueur2.symbole := '2';

  jeuActif := True;
end;

procedure AfficherJoueur(var j: TJoueur);
begin
  if (j.x < 1) or (j.x > LARGEUR_ECRAN) or
     (j.y < 1) or (j.y > HAUTEUR_ECRAN) then Exit;

  if j.symbole = '1' then TextColor(LightBlue)
  else TextColor(Yellow);

  gotoxy(j.x, j.y);
  write('■');
end;


procedure AfficherScore;
begin
  TextColor(White);
  gotoxy(2, HAUTEUR_ECRAN + 1);
  write('J1: ', joueur1.vie, '   J2: ', joueur2.vie, '     ');
end;

procedure Deplacement(var j: TJoueur; var oldx, oldy: integer);
begin
  oldx := j.x;
  oldy := j.y;

  case j.dir of
    Haut: dec(j.y);
    Bas: inc(j.y);
    Gauche: dec(j.x);
    Droite: inc(j.x);
  end;
end;


procedure Trace(var j: TJoueur; oldx, oldy: integer);
var horiz: boolean;
begin
  if (oldx < 2) or (oldx > LARGEUR_ECRAN - 1) or
     (oldy < 2) or (oldy > HAUTEUR_ECRAN - 1) then Exit;

  grille[oldx, oldy] := True;

  if j.symbole = '1' then TextColor(LightBlue)
  else TextColor(Yellow);

  horiz := (oldy = j.y) and (oldx <> j.x);

  gotoxy(oldx, oldy);
  if horiz then write('-') else write('|');
end;


procedure GererTouches;
var
  t, ext: char;
begin
  if not keypressed then Exit;

  t := readkey;

  if t = #0 then
  begin
    ext := readkey;
    case ext of
      #75: if joueur1.dir <> Droite then joueur1.dir := Gauche;
      #77: if joueur1.dir <> Gauche then joueur1.dir := Droite;
      #72: if joueur1.dir <> Bas then joueur1.dir := Haut;
      #80: if joueur1.dir <> Haut then joueur1.dir := Bas;
    end;
  end
  else
  begin
    case LowerCase(t) of
      'q': if joueur2.dir <> Droite then joueur2.dir := Gauche;
      'd': if joueur2.dir <> Gauche then joueur2.dir := Droite;
      'z': if joueur2.dir <> Bas then joueur2.dir := Haut;
      's': if joueur2.dir <> Haut then joueur2.dir := Bas;
    end;
  end;
end;

procedure VerifierCollision(var j: TJoueur);
begin
  if grille[j.x, j.y] then
  begin
    dec(j.vie);
    jeuActif := False;
  end;
end;

procedure JouerTron;
var
  oldx1, oldy1, oldx2, oldy2: integer;
begin
  joueur1.vie := 10;
  joueur2.vie := 10;

  repeat
    InitialiserJeu;

    AfficherJoueur(joueur1);
    AfficherJoueur(joueur2);
    AfficherScore;

    while jeuActif do
    begin
      GererTouches;

      Deplacement(joueur1, oldx1, oldy1);
      Deplacement(joueur2, oldx2, oldy2);

      VerifierCollision(joueur1);
      VerifierCollision(joueur2);

      if not jeuActif then Break;

      Trace(joueur1, oldx1, oldy1);
      Trace(joueur2, oldx2, oldy2);

      AfficherJoueur(joueur1);
      AfficherJoueur(joueur2);

      AfficherScore;

      delay(100);
    end;

    TextColor(Red);
    gotoxy(1, HAUTEUR_ECRAN + 2);
    writeln('💥 Collision ! Nouvelle manche dans 2 secondes...');
    delay(2000);

  until (joueur1.vie = 0) or (joueur2.vie = 0);

  clrscr;
  TextColor(White);

  if joueur1.vie = 0 then
    writeln('🏁 Le joueur 2 a gagné !')
  else
    writeln('🏁 Le joueur 1 a gagné !');

  writeln('Appuie sur une touche pour quitter...');
  readkey;
end;

end.

