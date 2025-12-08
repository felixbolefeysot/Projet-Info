unit TronGame;

interface
uses crt, sysutils, Typesmenu;

var
  dernierGagnant: Integer;

procedure JouerTron;
procedure scoretron(winner, j1, j2: Integer; var liste : TListeProfils);

implementation

const
  LARGEUR_ECRAN = 80;
  HAUTEUR_ECRAN = 30;
  INITIAL_LIVES = 10;
  SCORE_POS_X = 3;
  SCORE_POS_Y = 1;

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
  joueur1.symbole := 'O'; // J1 ASCII

  joueur2.x := LARGEUR_ECRAN - 10;
  joueur2.y := HAUTEUR_ECRAN div 2;
  joueur2.dir := Gauche;
  joueur2.symbole := 'X'; // J2 ASCII

  jeuActif := True;
end;

procedure AfficherJoueur(var j: TJoueur);
begin
  if (j.x < 1) or (j.x > LARGEUR_ECRAN) or
     (j.y < 1) or (j.y > HAUTEUR_ECRAN) then Exit;

  if j.symbole = 'O' then TextColor(LightBlue)
  else TextColor(Yellow);

  gotoxy(j.x, j.y);
  write(j.symbole); // ASCII char to avoid multibyte/width issues
end;

procedure AfficherScore;
begin
  TextColor(White);
  gotoxy(SCORE_POS_X, SCORE_POS_Y);
  ClrEol; // efface la fin de la ligne de statut pour éviter résidus
  gotoxy(SCORE_POS_X, SCORE_POS_Y);
  write('J1: ', joueur1.vie:3, '   J2: ', joueur2.vie:3);
end;

procedure Deplacement(var j: TJoueur; var xprecedent, yprecedent: integer);
begin
  xprecedent := j.x;
  yprecedent := j.y;

  case j.dir of
    Haut: dec(j.y);
    Bas: inc(j.y);
    Gauche: dec(j.x);
    Droite: inc(j.x);
  end;
end;

procedure Trace(var j: TJoueur; xprecedent, yprecedent: integer);
var horiz: boolean;
begin
  // On trace la position précédente du joueur (sa "traînée")
  if (xprecedent < 2) or (xprecedent > LARGEUR_ECRAN - 1) or
     (yprecedent < 2) or (yprecedent > HAUTEUR_ECRAN - 1) then Exit;

  grille[xprecedent, yprecedent] := True;

  if j.symbole = 'O' then TextColor(LightBlue)
  else TextColor(Yellow);

  horiz := (yprecedent = j.y) and (xprecedent <> j.x);

  gotoxy(xprecedent, yprecedent);
  if horiz then write('-') else write('|');
end;

procedure GererTouches;
var
  t, ext: char;
  code: integer;
begin
  if not keypressed then Exit;

  t := readkey;

  // Touche Echap pour quitter immédiatement
  if t = #27 then
  begin
    jeuActif := False;
    joueur1.vie := 0;
    joueur2.vie := 0;
    Exit;
  end;

  if t = #0 then
  begin
    ext := readkey;
    code := Ord(ext);
    case code of
      75: if joueur1.dir <> Droite then joueur1.dir := Gauche;  // gauche
      77: if joueur1.dir <> Gauche then joueur1.dir := Droite;  // droite
      72: if joueur1.dir <> Bas then joueur1.dir := Haut;       // haut
      80: if joueur1.dir <> Haut then joueur1.dir := Bas;       // bas
    end;
  end
  else
  begin
    case UpCase(t) of
      'Q': if joueur2.dir <> Droite then joueur2.dir := Gauche;
      'D': if joueur2.dir <> Gauche then joueur2.dir := Droite;
      'Z': if joueur2.dir <> Bas then joueur2.dir := Haut;
      'S': if joueur2.dir <> Haut then joueur2.dir := Bas;
    end;
  end;
end;

procedure VerifierCollision(var j: TJoueur);
begin
  // Vérifier bornes avant d'accéder à grille
  if (j.x < 1) or (j.x > LARGEUR_ECRAN) or (j.y < 1) or (j.y > HAUTEUR_ECRAN) then
  begin
    dec(j.vie);
    jeuActif := False;
    Exit;
  end;

  if grille[j.x, j.y] then
  begin
    dec(j.vie);
    jeuActif := False;
  end;
end;

procedure scoretron(winner, j1, j2: Integer; var liste : TListeProfils);
begin
  if winner = 2 then
    liste.profils[j2].scores[MAX_JEUX_SOLO + 3] := liste.profils[j2].scores[MAX_JEUX_SOLO + 3] + 1
  else if winner = 1 then
    liste.profils[j1].scores[MAX_JEUX_SOLO + 3] := liste.profils[j1].scores[MAX_JEUX_SOLO + 3] + 1;
end;

procedure JouerTron;
var
  xprecedent1, yprecedent1, xprecedent2, yprecedent2: integer;
begin
  joueur1.vie := INITIAL_LIVES;
  joueur2.vie := INITIAL_LIVES;
  dernierGagnant := 0;

  GotoXY(1, HAUTEUR_ECRAN + 2);
  writeln('Deplacez vous avec les fleches pour j1 et avec ZQSD pour j2');
  GotoXY(1, HAUTEUR_ECRAN + 3);
  writeln('Appuyez sur Echap pour quitter le jeu a tout moment.');
  GotoXY(1, HAUTEUR_ECRAN + 4);
  writeln('Appuyez sur une touche pour commencer...');
  readkey;

  repeat
    InitialiserJeu;

    AfficherJoueur(joueur1);
    AfficherJoueur(joueur2);
    AfficherScore;

    while jeuActif do
    begin
      GererTouches;

      Deplacement(joueur1, xprecedent1, yprecedent1);
      Deplacement(joueur2, xprecedent2, yprecedent2);

      VerifierCollision(joueur1);
      VerifierCollision(joueur2);

      if not jeuActif then Break;

      Trace(joueur1, xprecedent1, yprecedent1);
      Trace(joueur2, xprecedent2, yprecedent2);

      AfficherJoueur(joueur1);
      AfficherJoueur(joueur2);

      AfficherScore;

      delay(100);
    end;

    // Si le jeu a été arrêté par Echap (on force vies à 0), sortir proprement
    if (joueur1.vie = 0) and (joueur2.vie = 0) then
    begin
      clrscr;
      writeln('Jeu interrompu.');
      Exit;
    end;

    TextColor(Red);
    gotoxy(1, HAUTEUR_ECRAN + 2);
    writeln('Collision ! Nouvelle manche dans 2 secondes...');
    delay(2000);

  until (joueur1.vie = 0) or (joueur2.vie = 0);

  clrscr;
  TextColor(White);

  if joueur1.vie = 0 then
  begin
    dernierGagnant := 2;
    writeln('Le joueur 2 a gagne !');
  end
  else
  begin
    dernierGagnant := 1;
    writeln('Le joueur 1 a gagne !');
  end;

  writeln('Appuie sur une touche pour quitter...');
  readkey;
  clrscr;
end;

end.
