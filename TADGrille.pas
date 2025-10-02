unit TADGrille;

interface

uses typesmenu;

Type TGrille = array [1..7,1..6] of integer;

procedure CreerGrilleVide(var g : TGrille);
function estColonneValide(c : integer; g : TGrille) : boolean;
procedure PoserJeton(joueur : integer; var g : TGrille );
{function estGagné(g : TGrille; joueur : Integer) : integer;
procedure ModifScoreP4(j : integer; var p : TListeProfils);}

implementation

procedure CreerGrilleVide(var g : TGrille);
var i,j : integer;
begin
    for i:=1 to 7 do
        for j:=1 to 6 do
            g[i,j]:=0;
end;


function estColonneValide(c : integer; g : TGrille) : boolean;
begin
    if (c<1) or (c>7) then
        estColonneValide:=false
    else if g[c,1]<>0 then
        estColonneValide:=false
    else
        estColonneValide:=true;
end;

procedure PoserJeton(joueur : integer; var g : TGrille );
var c,i : integer;
begin
    writeln('choissisez le numéro de la colonne (1-7) dans laquelle vous voulez poser votre jeton');
    repeat
        readln(c);
        if estColonneValide(c,g)=false then
            writeln('cette colonne est pleine ou n''existe pas, veuillez en choisir une autre');
    until estColonneValide(c,g);
    i:=6;
    while (g[c,i]<>0) do
        i:=i-1;
    g[c,i]:=joueur;
    
end;

{function estGagné(g : TGrille; joueur : Integer) : integer;

procedure ModifScoreP4(j : integer; var p : TListeProfils);
begin
    p.profils[j].score[1]=p.profils[j].score[1]+1;
end;}


end.