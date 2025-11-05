unit puissance4;

interface

uses TADGrille, Typesmenu, crt;

procedure puissance4;
procedure scorepuissance4(var liste: TListeProfils; j1, j2: Integer);


implementation

procedure puissance4;
var 
    j,c,l : Integer;
	g : TGrille;
begin
    CreerGrilleVide(g);
    j := 1;
    afficherGrille(g);
	c:=0;
	l:=0;
    repeat
        PoserJeton(j,g,c,l);
        afficherGrille(g);
		j := (j+1)mod 2+2;
    until estFinie(g,c,l);
end;

procedure scorepuissance4(var liste: TListeProfils; j1, j2: Integer);
begin
    if estGagne(g,j1,c,l) then
        liste.profils[j1].scores[2]:=liste.profils[j1].scores[2]+1;
    if estGagne(g,j2,c,l) then
        liste.profils[j2].scores[2]:=liste.profils[j2].scores[2]+1;
end;

end.
