unit puissance4;

interface

uses TADGrille, Typesmenu, crt;

procedure puissance4(var dernierGagnant: Integer);
procedure scorepuissance4(dernierGagnant: Integer; var liste: TListeProfils; profilJ1, profilJ2: Integer);
var
    dernierGagnant: Integer; 


implementation

procedure puissance4(var dernierGagnant: Integer);
var 
    j,c,l : Integer;
	g : TGrille;
begin
    CreerGrilleVide(g);
    dernierGagnant := 0;
    j := 1;
    afficherGrille(g);
    c:=0;
    l:=0;
    repeat
        PoserJeton(j,g,c,l);
        afficherGrille(g);
        if estGagne(g, j, c, l) then
        begin
            dernierGagnant := j;
            break;
        end;
        j := 3 - j;
    until estFinie(g,c,l);
    if dernierGagnant = 0 then
        writeln('Match nul ou fin de partie')
    else
        writeln( liste.profils[dernierGagnant].nom, ' a gagne !');
    readln;
end;

procedure scorepuissance4(dernierGagnant: Integer; var liste: TListeProfils; profilJ1, profilJ2: Integer);
var
  scoreIndex: Integer;
begin
  scoreIndex := MAX_JEUX_SOLO + 1;
  if dernierGagnant = 1 then
    liste.profils[profilJ1].scores[scoreIndex] := liste.profils[profilJ1].scores[scoreIndex] + 1;
  if dernierGagnant = 2 then
    liste.profils[profilJ2].scores[scoreIndex] := liste.profils[profilJ2].scores[scoreIndex] + 1;
end;

end.
