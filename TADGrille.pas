unit TADGrille;

interface

uses typesmenu, crt;

Type TGrille = array [1..7,1..6] of integer;

procedure CreerGrilleVide(var g : TGrille);
function estColonneValide(c : integer; g : TGrille) : boolean;
procedure PoserJeton(joueur : integer; var g : TGrille; var c,l : integer);
function estGagne(g : TGrille; joueur,c,l : Integer) : Boolean;
function verifligne(g : TGrille; joueur,l : Integer) : Boolean;
function verifcolonne(g : TGrille; joueur,c : Integer) : Boolean;
function verifdiagonale(g : TGrille; joueur,c,l : Integer) : Boolean;
procedure afficherGrille(g : TGrille);
function estFinie(g : TGrille; c,l : Integer) : Boolean;

var c,l : Integer;
    g : TGrille;

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

procedure PoserJeton(joueur : integer; var g : TGrille ; var c,l : integer);
begin
    writeln('choissisez le numero de la colonne (1-7) dans laquelle vous voulez poser votre jeton');
    repeat
        readln(c);
        if estColonneValide(c,g)=false then
            writeln('cette colonne est pleine ou n''existe pas, veuillez en choisir une autre');
    until estColonneValide(c,g);
    l:=6;
    while (l>0) and (g[c,l]<>0) do
        l:=l-1;
    if l>=1 then
        g[c,l]:=joueur;
    
end;

function estGagne(g : TGrille; joueur,c,l : Integer) : Boolean;
var
    col,row: Integer;
begin
    estGagne := False;
    if verifligne(g, joueur, l) or verifcolonne(g, joueur, c) or verifdiagonale(g, joueur, c, l) then
        estGagne := True;
end;

function verifligne(g : TGrille; joueur,l : Integer) : Boolean;
var c,count : integer;
begin
    count:=0;
    verifligne := False;
    for c:=1 to 7 do
    begin
        if g[c,l]=joueur then
            count:=count+1
        else
            count:=0;
        if count>=4 then
        begin
            verifligne := True;
            Exit;
        end;
    end;
end;

function verifcolonne(g : TGrille; joueur,c : Integer) : Boolean;
var l,count : integer;
begin
    count:=0;
    verifcolonne := False;
    for l:=1 to 6 do
    begin
        if g[c,l]=joueur then
            count:=count+1
        else
            count:=0;
        if count>=4 then
        begin
            verifcolonne := True;
            Exit;
        end;
    end;
end;

function verifdiagonale(g : TGrille; joueur,c,l : Integer) : Boolean;
var dc,dl,count : integer;
begin
    verifdiagonale := False;
    dc := c;
    dl := l;
    while (dc > 1) and (dl > 1) do
    begin
        dc := dc - 1;
        dl := dl - 1;
    end;
    count := 0;
    while (dc <= 7) and (dl <= 6) do
    begin
        if g[dc,dl] = joueur then
            count := count + 1
        else
            count := 0;
        if count >= 4 then
        begin
            verifdiagonale := True;
            Exit;
        end;
        dc := dc + 1;
        dl := dl + 1;
    end;
    dc := c;
    dl := l;
    while (dc > 1) and (dl < 6) do
    begin
        dc := dc - 1;
        dl := dl + 1;
    end;
    count := 0;
    while (dc <= 7) and (dl >= 1) do
    begin
        if g[dc,dl] = joueur then
            count := count + 1
        else
            count := 0;
        if count >= 4 then
        begin
            verifdiagonale := True;
            Exit;
        end;
        dc := dc + 1;
        dl := dl - 1;
    end;
end;


procedure afficherGrille(g : TGrille);
var i,j : integer;
begin
    clrscr;
    for j:=1 to 6 do
        begin
            for i:=1 to 7 do
                begin
                    if g[i,j]=0 then
                        write('| . ')
                    else if g[i,j]=1 then
                        write('| 1 ')
                    else
                        write('| 2 ');
                end;
            writeln('|');
        end;
    writeln(' -----------------------------');
    writeln('  1   2   3   4   5   6   7  ');
end;

function estFinie(g : TGrille; c,l : Integer) : Boolean;
begin
    if estGagne(g,1,c,l) then
        estFinie := True
    else if estGagne(g,2,c,l) then
        estFinie := True
    else if (g[1,1]<>0) and (g[2,1]<>0) and (g[3,1]<>0) and (g[4,1]<>0) and (g[5,1]<>0) and (g[6,1]<>0) and (g[7,1]<>0) then
        estFinie := True
    else
        estFinie := False;
end;

end.