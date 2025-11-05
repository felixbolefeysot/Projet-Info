unit programmeroulette;

interface

procedure choix(var choix: integer);
procedure mise(choix : integer; var mise, douzaine, ligne, colonne: integer; var c, ip : char);
procedure afficherCapital(capital: integer);
function verifgain(choix, num, mise, douzaine, ligne, colonne: integer; c, ip : char) : integer;
function tirage : integer;
function couleur(num : integer) : char;

implementation

uses sysutils, crt, typesmenu;


procedure choix(var choix: integer);
begin
   writeln('Sur quoi voulez-vous miser ?');
   writeln('Tapez 1 pour miser sur le rouge ou le noir');
   writeln('Tapez 2 pour miser sur une douzaine');
   writeln('Tapez 3 pour miser sur pair ou impair');
   writeln('Tapez 4 pour miser le zero');
   writeln('Tapez 5 pour miser sur une ligne');
   writeln('Tapez 6 pour miser sur une colonne');
   
   repeat
      readln(choix);
   until (choix >= 1) and (choix <= 6);
end;

procedure mise(choix : integer; var mise, douzaine, ligne, colonne: integer; var c, ip : char);
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
            writeln('Quelle douzaine ? (1=1-12, 2=13-24, 3=25-36)');
            repeat
               readln(douzaine);
            until (douzaine >= 1) and (douzaine <= 3);
            writeln('Combien voulez-vous miser ?');
            readln(mise);
         end;
      3: begin
            writeln('Pair ou impair ?');
            writeln('Tapez p pour miser sur le pair');
            writeln('Tapez i pour miser sur l''impair');
            repeat
               readln(ip);
            until (ip = 'p') or (ip = 'i');
            writeln('Combien voulez-vous miser ?');
            readln(mise);
         end;
      4: begin
            writeln('Combien voulez-vous miser sur le zero ?');
            readln(mise);
         end;
      5: begin
            writeln('Quelle ligne ? (1, 2 ou 3)');
            repeat
               readln(ligne);
            until (ligne >= 1) and (ligne <= 3);
            writeln('Combien voulez-vous miser ?');
            readln(mise);
         end;
      6: begin
            writeln('Quelle colonne ? (1, 2 ou 3)');
            repeat
               readln(colonne);
            until (colonne >= 1) and (colonne <= 3);
            writeln('Combien voulez-vous miser ?');
            readln(mise);
         end;
   end;
end;

function tirage : integer;
begin
   randomize;
   tirage := random(37); { 0 à 36 }
end;

function couleur(num : integer) : char;
const
   rouges : array[1..18] of integer = (1,3,5,7,9,12,14,16,18,19,21,23,25,27,30,32,34,36);
var
   i : integer;
begin
   if num = 0 then
      couleur := 'v'
   else
   begin
      couleur := 'n';
      for i := 1 to 18 do
         if num = rouges[i] then couleur := 'r';
   end;
end;

function verifgain(choix, num, mise, douzaine, ligne, colonne: integer; c, ip : char) : integer;
var
   gain : integer;
   col_tirage, ligne_tirage, douzaine_tirage : integer;
   colcolor : char;
begin
   gain := 0;
   colcolor := couleur(num);

   if (num >= 1) and (num <= 12) then douzaine_tirage := 1
   else if (num >= 13) and (num <= 24) then douzaine_tirage := 2
   else if (num >= 25) and (num <= 36) then douzaine_tirage := 3
   else douzaine_tirage := 0;

   if num = 0 then
   begin
      ligne_tirage := 0;
      col_tirage := 0;
   end
   else
   begin
      col_tirage := ((num - 1) mod 3) + 1;
      ligne_tirage := ((num - 1) div 3) mod 3 + 1;
   end;

   case choix of
      1: if (c = colcolor) then gain := mise * 2;
      2: if (douzaine = douzaine_tirage) then gain := mise * 3;
      3: if (num <> 0) and (((ip = 'p') and (num mod 2 = 0)) or ((ip = 'i') and (num mod 2 = 1))) then
            gain := mise * 2;
      4: if (num = 0) then gain := mise * 36;
      5: if (ligne = ligne_tirage) then gain := mise * 3;
      6: if (colonne = col_tirage) then gain := mise * 3;
   end;

   verifgain := gain;
end;


procedure afficherCapital(capital: integer);
begin
  writeln('----------------------------------------');
  writeln('Capital actuel : ', capital, ' unites');
  writeln('----------------------------------------');
end;


end.
