unit roulette;

interface

procedure demanderChoix(var choix: integer);
procedure demanderMise(choix: integer; var montant, douzaine, ligne, colonne: integer; var couleurChoisie, pairImpair: char);
procedure afficherArgent(argent: integer);
function calculerGain(choix, numero, montant, douzaine, ligne, colonne: integer; couleurChoisie, pairImpair: char): integer;
function tirage: integer;
function couleurDuNumero(numero: integer): char;

implementation

uses crt, sysutils;

procedure demanderChoix(var choix: integer);
begin
   writeln('Que voulez-vous miser ?');
   writeln('1 - Rouge / Noir');
   writeln('2 - Douzaine');
   writeln('3 - Pair / Impair');
   writeln('4 - Zéro');
   writeln('5 - Ligne (1 à 3)');
   writeln('6 - Colonne (1 à 3)');

   repeat
      readln(choix);
   until (choix >= 1) and (choix <= 6);
end;


procedure demanderMise(choix: integer; var montant, douzaine, ligne, colonne: integer; var couleurChoisie, pairImpair: char);
begin
   case choix of
      1:
      begin
         writeln('Rouge (r) ou noir (n) ?');
         repeat readln(couleurChoisie); until (couleurChoisie='r') or (couleurChoisie='n');
         writeln('Montant de la mise :');
         readln(montant);
      end;

      2:
      begin
         writeln('Choisissez la douzaine (1 : 1-12 | 2 : 13-24 | 3 : 25-36) :');
         repeat readln(douzaine); until (douzaine>=1) and (douzaine<=3);
         writeln('Montant de la mise :');
         readln(montant);
      end;

      3:
      begin
         writeln('Pair (p) ou impair (i) ?');
         repeat readln(pairImpair); until (pairImpair='p') or (pairImpair='i');
         writeln('Montant de la mise :');
         readln(montant);
      end;

      4:
      begin
         writeln('Mise sur le zéro : montant ?');
         readln(montant);
      end;

      5:
      begin
         writeln('Ligne (1, 2, 3) :');
         repeat readln(ligne); until (ligne>=1) and (ligne<=3);
         writeln('Montant :');
         readln(montant);
      end;

      6:
      begin
         writeln('Colonne (1, 2, 3) :');
         repeat readln(colonne); until (colonne>=1) and (colonne<=3);
         writeln('Montant :');
         readln(montant);
      end;
   end;
end;


function tirage: integer;
begin
   randomize;
   tirage := random(37);
end;


function couleurDuNumero(numero: integer): char;
const
   rouges : array[1..18] of integer =
     (1,3,5,7,9,12,14,16,18,19,21,23,25,27,30,32,34,36);
var i: integer;
begin
   if numero = 0 then exit('v'); // vert
   couleurDuNumero := 'n';
   for i := 1 to 18 do
      if numero = rouges[i] then couleurDuNumero := 'r';
end;


function calculerGain(choix, numero, montant, douzaine, ligne, colonne: integer; couleurChoisie, pairImpair: char): integer;
var
   douzaineTirage, ligneTirage, colonneTirage: integer;
   coul: char;
begin
   coul := couleurDuNumero(numero);
   calculerGain := 0;

   // Détermination des zones du tirage
   if (numero>=1) and (numero<=12) then douzaineTirage := 1
   else if (numero<=24) then douzaineTirage := 2
   else if (numero<=36) then douzaineTirage := 3
   else douzaineTirage := 0;

   if numero = 0 then
   begin
      ligneTirage := 0;
      colonneTirage := 0;
   end
   else
   begin
      colonneTirage := ((numero-1) mod 3) + 1;
      ligneTirage   := ((numero-1) div 3) mod 3 + 1;
   end;

   // Calcul du gain
   case choix of
      1: if couleurChoisie = coul then calculerGain := montant * 2;
      2: if douzaine = douzaineTirage then calculerGain := montant * 3;
      3: if (numero<>0) and (((pairImpair='p') and (numero mod 2=0)) or
                             ((pairImpair='i') and (numero mod 2=1))) then
            calculerGain := montant * 2;
      4: if numero=0 then calculerGain := montant * 36;
      5: if ligne = ligneTirage then calculerGain := montant * 3;
      6: if colonne = colonneTirage then calculerGain := montant * 3;
   end;
end;


procedure afficherArgent(argent: integer);
begin
   writeln('------------------------------');
   writeln('Votre capital : ', argent);
   writeln('------------------------------');
end;

end.

