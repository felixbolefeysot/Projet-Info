unit roulette;

interface

implementation
procedure choix(var i: integer);
procedure mise(choix: integer; var mise, douzaine, ligne, colonne: integer; var c, ip: char);
procedure tirage(var numero: integer; var couleur, parite: string; var douzaine, ligne, colonne: integer);
procedure calculerGain(choix, mise, douzaineMise, ligneMise, colonneMise, numeroTirage, douzaineTirage, ligneTirage, colonneTirage: integer; c, ip: char; couleurT

procedure choix(var i: integer);
	begin
		writeln('Sur quoi voulez-vous miser?');
		writeln('Tapez 1 pour miser sur le rouge ou le noir');
		writeln('tapez 2 pour miser sur une douzaine');
		writeln('tapez 3 pour miser sur pair ou impair');
		writeln('tapez 4 pour miser le zéro');
		writeln('tapez 5 pour miser sur une ligne');
		writeln('tapez 6 pour miser sur une colonne');
		begin
			repeat
				readln(i)
			until ((i<7) and (i>0));
		end; 
end;

procedure mise(choix: integer; var mise, douzaine, ligne, colonne: integer; var c, ip: char);
begin
  case choix of
    1: begin
         writeln('Noir ou rouge ?');
         writeln('Tapez n pour miser sur le noir');
         writeln('Tapez r pour miser sur le rouge');
         repeat
           readln(c);
         until (c = 'n') or (c = 'r');
         writeln('Combien voulez-vous miser ?');
         readln(mise);
       end;

    2: begin
         writeln('Quelle douzaine ? (1 à 3)');
         repeat
           readln(douzaine);
         until (douzaine >= 1) and (douzaine <= 3);
         writeln('Combien voulez-vous miser ?');
         readln(mise);
       end;

    3: begin
         writeln('Pair ou impair ?');
         writeln('Tapez p pour pair');
         writeln('Tapez i pour impair');
         repeat
           readln(ip);
         until (ip = 'p') or (ip = 'i');
         writeln('Combien voulez-vous miser ?');
         readln(mise);
       end;

    4: begin
         writeln('Combien voulez-vous miser ?');
         readln(mise);
       end;

    5: begin
         writeln('Quelle ligne ? (1 à 3)');
         repeat
           readln(ligne);
         until (ligne >= 1) and (ligne <= 3);
         writeln('Combien voulez-vous miser ?');
         readln(mise);
       end;

    6: begin
         writeln('Quelle colonne ? (1 à 12)');
         repeat
           readln(colonne);
         until (colonne >= 1) and (colonne <= 12);
         writeln('Combien voulez-vous miser ?');
         readln(mise);
       end;
    end;
end;

procedure tirage(var numero: integer; var couleur, parite: string; var douzaine, ligne, colonne: integer);
const
  rouges: array[1..18] of integer = (1,3,5,7,9,12,14,16,18,19,21,23,25,27,30,32,34,36);
var
  i: integer;
begin
  numero := Random(37); // 0 à 36

  // Couleur
  if numero = 0 then
    couleur := 'vert'
  else
  begin
    couleur := 'noir'; // Par défaut
    for i := 1 to 18 do
      if numero = rouges[i] then
        couleur := 'rouge';
  end;

  // Pair ou impair
  if (numero = 0) then
    parite := 'aucune'
  else if (numero mod 2 = 0) then
    parite := 'pair'
  else
    parite := 'impair';

  // Douzaine
  if (numero = 0) then
    douzaine := 0
  else if (numero <= 12) then
    douzaine := 1
  else if (numero <= 24) then
    douzaine := 2
  else
    douzaine := 3;

  // Ligne (1, 2 ou 3)
  if numero = 0 then
    ligne := 0
  else
    ligne := ((numero - 1) mod 3) + 1;

  // Colonne (1 à 12)
  if numero = 0 then
    colonne := 0
  else
    colonne := ((numero - 1) div 3) + 1;
end;

procedure calculerGain(choix, mise, douzaineMise, ligneMise, colonneMise, numeroTirage, douzaineTirage, ligneTirage, colonneTirage: integer; c, ip: char; couleurTirage, pariteTirage: string; var gain: integer);
begin
  gain := 0; // par défaut perdu

  case choix of
    1: // mise sur couleur (n ou r)
      if ((c = 'n') and (couleurTirage = 'noir')) or
         ((c = 'r') and (couleurTirage = 'rouge')) then
        gain := mise * 2; // gain 2 fois la mise

    2: // mise sur douzaine (1, 2, 3)
      if douzaineMise = douzaineTirage then
        gain := mise * 3; // gain triple

    3: // mise sur pair ou impair (p ou i)
      if ((ip = 'p') and (pariteTirage = 'pair')) or
         ((ip = 'i') and (pariteTirage = 'impair')) then
        gain := mise * 2;

    4: // mise sur zéro
      if numeroTirage = 0 then
        gain := mise * 35; // gain 35 fois la mise

    5: // mise sur ligne (1 à 3)
      if ligneMise = ligneTirage then
        gain := mise * 3;

    6: // mise sur colonne (1 à 12)
      if colonneMise = colonneTirage then
        gain := mise * 3;
  end;
end;
