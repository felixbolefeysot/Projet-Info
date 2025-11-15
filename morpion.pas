unit morpion;

{$MODE OBJFPC}
{$H+}

interface
uses Typesmenu, crt;

procedure morpion(var ListeProfils: TListeProfils; j1, j2: Integer);
procedure scoremorpion(var liste: TListeProfils; profileJ1, profileJ2: Integer);

implementation

Type TGrilleMorpion = array[1..3, 1..3] of char;

var
    dernierGagnant: Integer;  


procedure afficherGrilleMorpion(g : TGrilleMorpion);
var i,j : integer;
begin
    writeln('  1 2 3');
    for i:=1 to 3 do
    begin
        write(i,' ');
        for j:=1 to 3 do
        begin
            write(g[j,i]);
            if j<3 then
                write('|');
        end;
        writeln;
        if i<3 then
            writeln('  -----');
    end;
end;

function verifdiagonale(g : TGrilleMorpion; symbole: char; c, l : Integer) : Boolean;
var
    dc, dl, count : Integer;
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
    while (dc <= 3) and (dl <= 3) do
    begin
        if g[dc,dl] = symbole then
            count := count + 1
        else
            count := 0;
        if count >= 3 then
        begin
            verifdiagonale := True;
            Exit;
        end;
        dc := dc + 1;
        dl := dl + 1;
    end;
    dc := c;
    dl := l;
    while (dc < 3) and (dl > 1) do
    begin
        dc := dc + 1;
        dl := dl - 1;
    end;
    count := 0;
    while (dc >= 1) and (dl <= 3) do
    begin
        if g[dc,dl] = symbole then
            count := count + 1
        else
            count := 0;
        if count >= 3 then
        begin
            verifdiagonale := True;
            Exit;
        end;
        dc := dc - 1;
        dl := dl + 1;
    end;
end;

procedure verifligne(g : TGrilleMorpion; symbole: char; l : Integer; var gagne : Boolean);
var c, count : Integer;
begin
    count := 0;
    for c:=1 to 3 do
    begin
        if g[c,l] = symbole then
            count := count + 1
        else
            count := 0;
        if count >= 3 then
        begin
            gagne := True;
            Exit;
        end;
    end;
end;

procedure verifcolonne(g : TGrilleMorpion; symbole: char; c : Integer; var gagne : Boolean);
var l, count : Integer;
begin
    count := 0;
    for l:=1 to 3 do
    begin
        if g[c,l] = symbole then
            count := count + 1
        else
            count := 0;
        if count >= 3 then
        begin
            gagne := True;
            Exit;
        end;
    end;
end;

procedure estGagne(g : TGrilleMorpion; symbole: char; c, l : Integer; var gagne : Boolean);
begin
    gagne := False;
    verifligne(g, symbole, l, gagne);
    if gagne then Exit;
    verifcolonne(g, symbole, c, gagne);
    if gagne then Exit;
    if verifdiagonale(g, symbole, c, l) then
        gagne := True;
end;    

procedure morpion(var ListeProfils: TListeProfils; j1, j2: Integer);
var 
    g : TGrilleMorpion;
    j, c, l, tour : Integer;
    gagne : Boolean;
    symbole: char;
begin
    for c:=1 to 3 do
        for l:=1 to 3 do
            g[c,l] := ' ';
    j := 1;
    tour := 0;
    gagne := False;
    dernierGagnant := 0;
    
    repeat
        ClrScr();
        afficherGrilleMorpion(g);
        writeln('Joueur ', j, ', entrez la colonne (1-3) : ');
        readln(c);
        writeln('Joueur ', j, ', entrez la ligne (1-3) : ');
        readln(l);
        if (c < 1) or (c > 3) or (l < 1) or (l > 3) then
        begin
            writeln('Coordonnees invalides. Reessayez.');
            continue;
        end;
        if g[c,l] <> ' ' then
        begin
            writeln('Case deja occupee. Reessayez.');
            continue;
        end;
        if j = 1 then
            symbole := 'X'
        else
            symbole := 'O';
        g[c,l] := symbole;
        tour := tour + 1;
        estGagne(g, symbole, c, l, gagne);
        if gagne then
        begin
            ClrScr();
            afficherGrilleMorpion(g);
            writeln('Le joueur ', j, ' a gagne !');
            dernierGagnant := j;
            break;
        end;
        if tour = 9 then
        begin
            ClrScr();
            afficherGrilleMorpion(g);
            writeln('Match nul !');
            break;
        end;
        j := 3 - j; 
    until False;
    readln;
end;

procedure scoremorpion(var liste: TListeProfils; profileJ1, profileJ2: Integer);
var
  scoreIndex: Integer;
begin
  scoreIndex := MAX_JEUX_SOLO + 2;  { Morpion est le 2ème jeu multi : 2 + 2 = 4 }
  if dernierGagnant = 1 then
    liste.profils[profileJ1].scores[scoreIndex] := liste.profils[profileJ1].scores[scoreIndex] + 1
  else if dernierGagnant = 2 then
    liste.profils[profileJ2].scores[scoreIndex] := liste.profils[profileJ2].scores[scoreIndex] + 1;
end;

end.
