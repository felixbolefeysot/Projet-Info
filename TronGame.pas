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
  touche: char;
  jeuActif: boolean;
  grille: array[1..LARGEUR_ECRAN, 1..HAUTEUR_ECRAN] of boolean;


procedure InitialiserGrille;
var i, j: integer;
begin
  for i := 1 to LARGEUR_ECRAN do
    for j := 1 to HAUTEUR_ECRAN do
      grille[i, j] := False;
end;


procedure InitialiserJeu;
var i: integer;
begin
  clrscr;
  TextColor(Blue);

  
  for i := 1 to LARGEUR_ECRAN do
  begin
    gotoxy(i, 1); write('-');
    gotoxy(i, HAUTEUR_ECRAN); write('-');
  end;


  for i := 1 to HAUTEUR_ECRAN do
  begin
    gotoxy(1, i); write('|');
    gotoxy(LARGEUR_ECRAN, i); write('|');
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
  InitialiserGrille;
end;


procedure AfficherJoueur(var j: TJoueur);
begin
  if j.symbole = '1' then TextColor(LightBlue)
  else TextColor(Yellow);
  gotoxy(j.x, j.y);
  write('■');
end;


procedure Deplacement(var j: TJoueur);
begin
  case j.dir of
    Haut: dec(j.y);
    Bas: inc(j.y);
    Gauche: dec(j.x);
    Droite: inc(j.x);
  end;
end;


procedure GererTouches;
begin
  if keypressed then
  begin
    touche := readkey;
    if touche = #0 then
    begin
      touche := readkey;
      case touche of
        #75: joueur1.dir := Gauche;
        #77: joueur1.dir := Droite;
        #72: joueur1.dir := Haut;
        #80: joueur1.dir := Bas;
      end;
    end
    else
    case LowerCase(touche) of
      'q': joueur2.dir := Gauche;
      'd': joueur2.dir := Droite;
      'z': joueur2.dir := Haut;
      's': joueur2.dir := Bas;
    end;
  end;
end;


procedure Trace(var j: TJoueur);
begin
  if (j.x > 1) and (j.x < LARGEUR_ECRAN) and
     (j.y > 1) and (j.y < HAUTEUR_ECRAN) then
  begin
    grille[j.x, j.y] := True;
    gotoxy(j.x, j.y);
    if (j.dir = Gauche) or (j.dir = Droite) then
    begin
      if j.symbole = '1' then TextColor(LightBlue)
      else TextColor(Yellow);
      write('-');
    end
    else
    begin
      if j.symbole = '1' then TextColor(LightBlue)
      else TextColor(Yellow);
      write('|');
    end;
  end;
end;


procedure VerifierCollision(var j: TJoueur);
begin
  if (j.x <= 1) or (j.x >= LARGEUR_ECRAN) or
     (j.y <= 1) or (j.y >= HAUTEUR_ECRAN) then
  begin
    j.vie := j.vie - 1;
    jeuActif := False;
  end
  else if grille[j.x, j.y] then
  begin
    j.vie := j.vie - 1;
    jeuActif := False;
  end;
end;


procedure AfficherScore;
begin
  TextColor(White);
  gotoxy(2, HAUTEUR_ECRAN + 1);
  write('J1: ', joueur1.vie, '   J2: ', joueur2.vie);
end;


procedure JouerTron;
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

      Trace(joueur1);
      Trace(joueur2);

      Deplacement(joueur1);
      Deplacement(joueur2);

      VerifierCollision(joueur1);
      VerifierCollision(joueur2);

      AfficherJoueur(joueur1);
      AfficherJoueur(joueur2);
      AfficherScore;

      delay(120);
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
