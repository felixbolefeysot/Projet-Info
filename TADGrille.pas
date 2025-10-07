unit TADGrille;

interface

uses typesmenu;

Type TGrille = array [1..7,1..6] of integer;

procedure CreerGrilleVide(var g : TGrille);
function estColonneValide(c : integer; g : TGrille) : boolean;
procedure PoserJeton(joueur : integer; var g : TGrille; c,l : integer);
function estGagne(g : TGrille; joueur,c,l : Integer) : Boolean;
function verifligne(g : TGrille; joueur,l : Integer) : Boolean;
function verifcolonne(g : TGrille; joueur,c : Integer) : Boolean;
function verifdiagonale(g : TGrille; joueur,c,l : Integer) : Boolean;
procedure ModifScoreP4(joueur : integer; var p : TListeProfils);

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

procedure PoserJeton(joueur : integer; var g : TGrille ; c,l : integer);
begin
    writeln('choissisez le numéro de la colonne (1-7) dans laquelle vous voulez poser votre jeton');
    repeat
        readln(c);
        if estColonneValide(c,g)=false then
            writeln('cette colonne est pleine ou n''existe pas, veuillez en choisir une autre');
    until estColonneValide(c,g);
    l:=6;
    while (g[c,l]<>0) do
        l:=l-1;
    g[c,l]:=joueur;
    
end;

function estGagne(g : TGrille; joueur,c,l : Integer) : Boolean;
begin
    verifligne(g,joueur,l);
    verifcolonne(g,joueur,c);
    verifdiagonale(g,joueur,c,l);
    if (verifligne(g,joueur,l)=true) or (verifcolonne(g,joueur,c)=true) or (verifdiagonale(g,joueur,c,l)=true) then
        estGagne:=True
    else
        estGagne:=False;
end;

function verifligne(g : TGrille; joueur,l : Integer) : Boolean;
var c,count : integer;
begin
    count:=0;
    for c:=1 to 7 do
        if g[c,l]=joueur then
            count:=count+1
        else
            count:=0;
    if count>=4 then
        verifligne:=True
    else
        verifligne:=False;
end;

function verifcolonne(g : TGrille; joueur,c : Integer) : Boolean;
var l,count : integer;
begin
    count:=0;
    for l:=1 to 6 do
        if g[c,l]=joueur then
            count:=count+1
        else
            count:=0;
    if count>=4 then
        verifcolonne:=True
    else
        verifcolonne:=False;
end;

function verifdiagonale(g : TGrille; joueur,c,l : Integer) : Boolean;
var dc,dl,count : integer;
begin
    verifdiagonale:=False;
    count:=0;
    dc:=c;
    dl:=l;
    repeat
        dc:=dc-1;
        dl:=dl-1;
    until (dc=1) or (dl=1);
    repeat
        if g[dc,dl]=joueur then
            count:=count+1
        else
            count:=0;
        dc:=dc+1;
        dl:=dl+1;
    until (dc=7) or (dl=6) or (count=4);
    if count=4 then
        verifdiagonale:=True;
    dc:=c;
    dl:=l;
    repeat
        dc:=dc+1;
        dl:=dl+1;
    until (dc=7) or (dl=6);
    repeat
        if g[dc,dl]=joueur then
            count:=count+1
        else
            count:=0;
        dc:=dc-1;
        dl:=dl-1;
    until (dc=1) or (dl=1) or (count=4);
    if count=4 then
        verifdiagonale:=True;
end;
procedure ModifScoreP4(joueur : integer; var p : TListeProfils);
begin
    p.profils[joueur].scores[1]:=p.profils[joueur].scores[1]+1;
end;


end.