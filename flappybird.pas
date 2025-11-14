unit flappybird;

interface 

uses crt, typesmenu, sysutils;

procedure jouerflappy();
procedure scoreflappy(j1, score : Integer; var liste : TListeProfils);


implementation

Const
  LARGEUR_ECRAN = 80;
  HAUTEUR_ECRAN = 25;
  UP = #72;
  NB_OBJETS = 15;

Type TObjet = record
    x, y: integer;
    vitesse: integer;
    symbole: string;
    taille: Integer;
  end;
  
Type TOiseau = record
    x, y: integer;
    vie: integer;
  end;
  
var
  key: char;
  oiseau : TOiseau;
  objet: array[1..NB_OBJETS] of TObjet; 
  
procedure InitObjet(objet : TObjet);
var 
  i: Integer;
begin 
  Randomize;
  for i := 1 to NB_OBJETS do
  begin
    objet[i].x := Random(LARGEUR_ECRAN)+5;
    objet[i].y := Random(HAUTEUR_ECRAN)+3;
    objet[i].vitesse := Random(4)+1;

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

procedure AfficherObjets(objet : TObjet);
var
  i, j: Integer;
begin
	TextColor(LightRed);
	for i := 1 to NB_OBJETS do
	begin
		for j := 0 to objet[i].taille - 1 do
			begin
				GotoXY(objet[i].x + j, objet[i].y);
				Write(objet[i].symbole);
			end;
	end;
	TextColor(White);
end;

procedure AfficherOiseau(oiseau : TOiseau);
begin
  GotoXY(oiseau.x, oiseau.y);
  TextColor(Yellow);
  Write('§');
  TextColor(White);
end;

procedure EffacerOiseau(x, y: Integer);
begin
  GotoXY(x, y);
  Write(' ');
end;

procedure DeplacerObjets;
var
  i, j: Integer;
begin
  for i := 1 to NB_Objet do
  begin
    if Random(10) < objet[i].vitesse then
    begin
      {Effacer ancienne position}
      for j := 0 to objet[i].taille - 1 do
      begin
        GotoXY(objet[i].x + j, objet[i].y);
        Write(' ');
      end;

      {Déplacement}
      objet[i].x := objet[i].x + objet[i].direction;

      if objet[i].x < 1 then
        objet[i].x := LARGEUR_ECRAN - objet[i].taille
      else if objet[i].x + objet[i].taille > LARGEUR_ECRAN then
        objet[i].x := 1;
    end;
  end;
end;

procedure DeplacementOiseau;
begin
  if KeyPressed then
  begin
    key := ReadKey;
    if key := UP then 
		
end;

procedure jouerflappy();
begin
end;

procedure scoreflappy(j1, score: Integer; var liste : TListeProfils);
begin
	if score > liste.profils[j1].scores[3] then
		liste.profils[j1].scores[3]:=score
end;

procedure deplacement();
begin
end;

procedure collision();
begin
end;


end.
