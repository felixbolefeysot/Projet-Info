unit Frogger;

{$MODE OBJFPC}
{$H+}

interface 

uses crt, sysutils, typesmenu;

procedure Frogger(var score : Integer);
procedure modifscorefrogger(score : Integer; var liste: TListeProfils; j: Integer);

var score : Integer;

implementation

const
  LARGEUR_ECRAN = 80;
  HAUTEUR_ECRAN = 25;
  NB_VOITURES = 30;
  UP = #72;
  DOWN = #80;
  RIGHT = #77;
  LEFT = #75;

type
  TObjet = record
    x, y: integer;
    vitesse: integer;
    direction: integer; // 1 = droite, -1 = gauche
    symbole: string;
    taille: Integer;
  end;

  TGrenouille = record
    x, y: integer;
    vie: integer;
  end;

var
  key: char;
  grenouille: TGrenouille;
  voitures: array[1..NB_VOITURES] of TObjet; 
  hauteurPrecedente: integer;
  niveau: integer;
  nbVoituresActuel: integer;

  


procedure InitialiserVoitures;
var 
  i: Integer;
begin 
  Randomize;
  for i := 1 to NB_VOITURES do
  begin
    voitures[i].x := Random(LARGEUR_ECRAN - 4) + 1;
    voitures[i].y := Random(15) + 3;
    voitures[i].vitesse := Random(6) + 1;
    if (i mod 2 = 0) then
		voitures[i].direction := 1
	else
		voitures[i].direction := -1;

    case voitures[i].vitesse of
      1: voitures[i].taille := 5; 
      2: voitures[i].taille := 5; 
      3: voitures[i].taille := 4;
      4: voitures[i].taille := 4;
      5: voitures[i].taille := 3;
      6: voitures[i].taille := 2;
      7: voitures[i].taille := 1;
    end;

    case voitures[i].taille of 
      1: voitures[i].symbole := '$';
      2: voitures[i].symbole := '#';
      3: voitures[i].symbole := 'O';  
      4: voitures[i].symbole := '&';  
      5: voitures[i].symbole := '~';
    end;
  end;
end;

procedure AfficherVoitures;
var
  i, j: Integer;
begin
  for i := 1 to nbVoituresActuel do
  begin
    // Couleur selon le niveau (cycle sur 5 couleurs)
    case (niveau mod 5) of
      1: TextColor(Blue);           { Bleu }
      2: TextColor(LightRed);       { Rouge }
      3: TextColor(Brown);          { Orange }
      4: TextColor(Magenta);        { Violet }
      0: TextColor(LightMagenta);   { Rose }
    end;

    for j := 0 to voitures[i].taille - 1 do
    begin
      GotoXY(voitures[i].x + j, voitures[i].y);
      Write(voitures[i].symbole);
    end;
  end;
  TextColor(White);
end;



procedure AfficherGrenouille;
begin
  GotoXY(grenouille.x, grenouille.y);
  TextColor(Green);
  Write('@');
  TextColor(White);
end;

procedure EffacerGrenouille(x, y: Integer);
begin
  GotoXY(x, y);
  Write(' ');
end;


procedure DeplacerVoitures;
var
  i, j: Integer;
begin
  for i := 1 to NB_VOITURES do
  begin
    if Random(10) < voitures[i].vitesse then
    begin
      {Effacer ancienne position}
      for j := 0 to voitures[i].taille - 1 do
      begin
        GotoXY(voitures[i].x + j, voitures[i].y);
        Write(' ');
      end;

      {Déplacement}
      voitures[i].x := voitures[i].x + voitures[i].direction;

      if voitures[i].x < 1 then
        voitures[i].x := LARGEUR_ECRAN - voitures[i].taille
      else if voitures[i].x + voitures[i].taille > LARGEUR_ECRAN then
        voitures[i].x := 1;
    end;
  end;
end;

procedure DeplacementGrenouille;
begin
  if KeyPressed then
  begin
    key := ReadKey;
    { Gestion portable des touches fléchées }
    if key = #0 then  { Windows: touches étendues }
    begin
      key := ReadKey;
      case key of
        LEFT  : if grenouille.x > 1 then grenouille.x := grenouille.x - 1;
        RIGHT : if grenouille.x < LARGEUR_ECRAN then grenouille.x := grenouille.x + 1;
        UP    : if grenouille.y > 1 then grenouille.y := grenouille.y - 1;
        DOWN  : if grenouille.y < HAUTEUR_ECRAN then grenouille.y := grenouille.y + 1;
      end;
    end
    else if key = #224 then  { Alternative sur certains systèmes }
    begin
      key := ReadKey;
      case key of
        LEFT  : if grenouille.x > 1 then grenouille.x := grenouille.x - 1;
        RIGHT : if grenouille.x < LARGEUR_ECRAN then grenouille.x := grenouille.x + 1;
        UP    : if grenouille.y > 1 then grenouille.y := grenouille.y - 1;
        DOWN  : if grenouille.y < HAUTEUR_ECRAN then grenouille.y := grenouille.y + 1;
      end;
    end
    else  
    begin
      case UpCase(key) of
        'Z', 'W': if grenouille.y > 1 then grenouille.y := grenouille.y - 1;  { Haut }
        'S'     : if grenouille.y < HAUTEUR_ECRAN then grenouille.y := grenouille.y + 1;  { Bas }
        'Q', 'A': if grenouille.x > 1 then grenouille.x := grenouille.x - 1;  { Gauche }
        'D'     : if grenouille.x < LARGEUR_ECRAN then grenouille.x := grenouille.x + 1;  { Droite }
      end;
    end;
  end;
end;


function CollisionVoiture: boolean;
var i: Integer;
begin
  CollisionVoiture := False;
  for i := 1 to NB_VOITURES do
    if (grenouille.y = voitures[i].y) and (grenouille.x >= voitures[i].x) and (grenouille.x < voitures[i].x + voitures[i].taille) then
    begin
      CollisionVoiture := True;
      Exit;
    end;
end;

procedure Explosion(x, y: Integer);
begin
  TextColor(Red);
  GotoXY(x, y); Write('*');
  Delay(100);
  GotoXY(x, y); Write(' ');
  TextColor(White);
end;

procedure ToucheVoiture;
begin
  if CollisionVoiture then
  begin
    hauteurPrecedente := grenouille.y;
    Explosion(grenouille.x, grenouille.y);
    {$IFDEF WINDOWS}
    Sound(500); Delay(100); NoSound;
    {$ELSE}
    Delay(100);
    {$ENDIF}
    grenouille.x := 40;
    grenouille.y := 24;
    grenouille.vie := grenouille.vie - 1;
  end;
end;


function Victoire: boolean;
begin
  Victoire := grenouille.y = 2;
end;


procedure AfficherZoneVictoire;
var i: Integer;
begin
  TextColor(Cyan);
  for i := 1 to LARGEUR_ECRAN do
  begin
    GotoXY(i, 2);
    Write('=');
  end;
  TextColor(White);
end;


procedure MettreAJourScore(var score: Integer);
begin
  if grenouille.y < hauteurPrecedente then
  begin
    score := score + 10;
    hauteurPrecedente := grenouille.y;
  end;
end;


procedure AfficherScore;
begin
  GotoXY(1,1);
  TextColor(White);
  Write('Vies: ', grenouille.vie, '  |  Score: ', score, '  |  Niveau: ', niveau);
end;


procedure NouveauNiveau;
var
  i: integer;
begin
  niveau := niveau + 1;
  nbVoituresActuel := nbVoituresActuel + 5;

  if nbVoituresActuel > High(voitures) then
    nbVoituresActuel := High(voitures);

   {change vitesse et le skin des voitures selon le niveau}
  for i := 1 to nbVoituresActuel do
  begin
    voitures[i].vitesse := voitures[i].vitesse + 1;
    if voitures[i].vitesse > 10 then
      voitures[i].vitesse := 10;
    case voitures[i].vitesse of
  1, 2: voitures[i].taille := 5;
  3, 4: voitures[i].taille := 4;
  5, 6: voitures[i].taille := 3;
  7, 8: voitures[i].taille := 2;
    else
  voitures[i].taille := 2;  
end;

    case niveau mod 4 of
      1: voitures[i].symbole := '#';
      2: voitures[i].symbole := '&';  
      3: voitures[i].symbole := 'O';  
      0: voitures[i].symbole := '$';
    end;
  end;

  {effet visuel et son}
  clrscr;
  TextColor(Green);
  GotoXY(30, 12);
  Write('=== Niveau ', niveau, ' ===');
  TextColor(White);
  {$IFDEF WINDOWS}
  Sound(500 + 100 * niveau);
  Delay(600);
  NoSound;
  {$ELSE}
  Delay(600);
  {$ENDIF}

  // Repositionner la grenouille
  grenouille.x := 40;
  grenouille.y := 24;
  hauteurPrecedente := grenouille.y;
end;

// ----------------------- Programme principal -----------------------
procedure Frogger(var score : Integer);
begin
  { Initialisation CRT pour compatibilité Windows/Linux }
  TextBackground(Black);
  TextColor(White);
  clrscr;
  CursorOff;  { Masquer le curseur }
  
  key := ' ';  { Initialiser la touche }
  niveau := 1;
  nbVoituresActuel := NB_VOITURES;
  InitialiserVoitures;
  grenouille.x := 40;
  grenouille.y := 24;
  grenouille.vie := 3;
  score := 0;
  hauteurPrecedente := grenouille.y;

  { Instructions }
  TextColor(Yellow);
  GotoXY(10, 12);
  WriteLn('Utilisez les fleches ou ZQSD pour bouger, ENTREE pour quitter');
  TextColor(White);
  GotoXY(10, 14);
  WriteLn('Appuyez sur une touche pour commencer...');
  ReadKey;

  { Affichage initial complet }
  clrscr;
  AfficherZoneVictoire;

  repeat
    { Ne PAS effacer tout l'écran - optimisation ! }
    DeplacerVoitures;
    AfficherVoitures;
    DeplacementGrenouille;
    AfficherGrenouille;
    ToucheVoiture;
    MettreAJourScore(score);
    AfficherScore;

    if Victoire then
      NouveauNiveau;

    Delay(80);
  until (key = #13) or (grenouille.vie <= 0);  { #13 = Entrée pour quitter }

  { Écran de fin }
  clrscr;
  TextColor(White);
  GotoXY(30, 10);
  if grenouille.vie <= 0 then
  begin
    TextColor(Red);
    WriteLn('Game Over!');
  end
  else if Victoire then
  begin
    TextColor(Green);
    WriteLn('Bravo ! Vous avez gagne !');
  end
  else
  begin
    TextColor(Yellow);
    WriteLn('Merci d''avoir joue !');
  end;
  
  TextColor(White);
  GotoXY(25, 12);
  WriteLn('Score final : ', score);
  GotoXY(25, 13);
  WriteLn('Niveau atteint : ', niveau);
  GotoXY(20, 15);
  WriteLn('Appuyez sur une touche pour continuer...');
  ReadKey;
  
  { Restaurer le curseur et réinitialiser les couleurs }
  CursorOn;
  TextBackground(Black);
  TextColor(White);
  clrscr;
end;

procedure modifscorefrogger(score : Integer; var liste: TListeProfils; j: Integer);
var
  scoreIndex: Integer;
begin
  scoreIndex := MAX_JEUX_SOLO + 2;
  if score > liste.profils[j].scores[scoreIndex] then
    liste.profils[j].scores[scoreIndex] := score;
end;

end.