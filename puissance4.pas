unit puissance4;

interface

uses TADGrille, Typesmenu, crt;

procedure puissance4;
procedure scorepuissance4(var liste: TListeProfils; profileJ1, profileJ2: Integer);
var
    dernierGagnant: Integer; 


implementation

procedure puissance4;
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
        writeln('Le joueur ', dernierGagnant, ' a gagne !');
    readln;
end;

procedure scorepuissance4(var liste: TListeProfils; profileJ1, profileJ2: Integer);
var
  scoreIndex: Integer;
begin
  scoreIndex := MAX_JEUX_SOLO + 1;
  if dernierGagnant = 1 then
    liste.profils[profileJ1].scores[scoreIndex] := liste.profils[profileJ1].scores[scoreIndex] + 1;
  if dernierGagnant = 2 then
    liste.profils[profileJ2].scores[scoreIndex] := liste.profils[profileJ2].scores[scoreIndex] + 1;
end;

end.
