unit puissance4;

interface

uses TADGrille;

puissance4(var g : TGrille);

implementation

puissance4(var g : TGrille);
var j,c,l : Integer
begin
	CreerGrilleVide(g);
	j:=1
	repeat
		PoserJeton(j,g,c,l)
	until estGagne
end;

end.
