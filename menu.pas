unit menu;

interface

uses Typesmenu, crt, SysUtils, puissance4, roulette, frogger, morpion, flappybird, TronGame;

var choixj : Integer;
	listej : TListeJeux;

procedure choixmenu(var choix : Integer);
procedure menu( var choix : integer; var ListeProfils: TListeProfils);
procedure Choixjeu(nbJ : Integer; var choixj : Integer);
procedure lancerJeu(j1,j2,choixj : Integer; var ListeProfils : TListeProfils);
procedure UnJoueur(var ListeProfils : TListeProfils);
procedure DeuxJoueurs(var ListeProfils : TListeProfils);
procedure Parametres(var ListeProfils : TListeProfils);
procedure Records(listej : TListeJeux; ListeProfils : TListeProfils);
procedure AjouterProfil(var ListeProfils : TListeProfils);
procedure SupprimerProfil(var ListeProfils : TListeProfils);
procedure ModifierProfil(var ListeProfils : TListeProfils);
procedure chargerProfils(var ListeProfils : TListeProfils);
procedure sauvegarderProfils( const ListeProfils : TListeProfils);
procedure initNomJeux(var listej : TListeJeux);
procedure choixJoueur(p : Integer; var j: Integer; var ListeProfils : TListeProfils);


implementation

procedure choixmenu(var choix : Integer);
begin
	repeat 
		writeln('1-Records');
		writeln('2-1 Joueur');
		writeln('3-2 Joueurs');
		writeln('4-Parametres Profils');
		writeln('5-Quitter');
		readln(choix)
	until (choix<6) and (choix>0)
end;

procedure menu( var choix : integer; var ListeProfils: TListeProfils);
begin
	choixmenu(choix);
	case choix of
	1: Records(listej,ListeProfils);
	2: UnJoueur(ListeProfils);
	3: DeuxJoueurs(ListeProfils);
	4: Parametres(ListeProfils);
	5: writeln('Au revoir !');
	end;
end;

procedure Choixjeu(nbJ : Integer; var choixj : Integer);
var i : Integer;
begin
	initNomJeux(listej);
	if nbJ = 1 then
	begin
		for i:= low(listej.jeu1) to high(listej.jeu1) do
			writeln(i,'-',listej.jeu1[i]);
	end
	else
	begin
		for i:= low(listej.jeu2) to high(listej.jeu2) do
			writeln(MAX_JEUX_SOLO + i,'-',listej.jeu2[i]);
	end;
	repeat
		writeln('Quel jeu voulez-vous faire ?');
		readln(choixj);
		if (choixj<1) or (choixj>MAX_SCORES) then
			writeln('Choix invalide, veuillez reessayer.');
	until (choixj >= 1) and (choixj <= MAX_SCORES);
end;

procedure lancerJeu(j1,j2,choixj : Integer; var ListeProfils : TListeProfils);
var
	score: SmallInt;  
begin
    case choixj of
        1: begin
            jouerRoulette(score); 
            scorecasino(ListeProfils, score, j1);
            sauvegarderProfils(ListeProfils); 	
        end;
        MAX_JEUX_SOLO + 1: begin
            puissance4.puissance4(dernierGagnant);
            scorepuissance4(dernierGagnant, ListeProfils, j1, j2);
            sauvegarderProfils(ListeProfils); 
        end;
        2: begin
            frogger.Frogger(score);
            modifscorefrogger(score, ListeProfils, j1);
            sauvegarderProfils(ListeProfils); 
        end;
		MAX_JEUX_SOLO + 2: begin
			morpion.morpion(dernierGagnant);
			morpion.scoremorpion(dernierGagnant, ListeProfils, j1, j2);
			sauvegarderProfils(ListeProfils); 
		end;
		3: begin
			flappybird.jouerflappy(score);
			flappybird.scoreflappy(j1, score, ListeProfils);
		    sauvegarderProfils(ListeProfils);
		end;
		MAX_JEUX_SOLO + 3: begin
			TronGame.JouerTron;
			TronGame.scoretron(TronGame.dernierGagnant, j1, j2, ListeProfils);
			sauvegarderProfils(ListeProfils);
		end;
    end;
    ClrScr;
end;
	
procedure UnJoueur(var ListeProfils : TListeProfils);
var
	j1, choixj : Integer;
begin
	Choixjeu(1, choixj);
	ChoixJoueur(1, j1, ListeProfils);
	lancerJeu(j1, 0, choixj, ListeProfils);
end;

procedure DeuxJoueurs(var ListeProfils : TListeProfils);
var
	j1, j2, choixj : Integer;
begin
	Choixjeu(2, choixj);
	ChoixJoueur(1, j1, ListeProfils);
	ChoixJoueur(2, j2, ListeProfils);
	lancerJeu(j1, j2, choixj, ListeProfils);
end;

procedure Records(listej : TListeJeux; ListeProfils : TListeProfils);
var i,j, score, scoreIndex : Integer;
    nomrecord : string;
begin
    initNomJeux(listej);
	clrscr;
    writeln('Affichage des records :');
    for i:= low(listej.jeu1) to high(listej.jeu1) do
    begin
        score := -1;
        nomrecord := '';
        scoreIndex := i;
        for j:=0 to length(ListeProfils.profils)-1 do
            if ListeProfils.profils[j].scores[scoreIndex] > score then
            begin
                score := ListeProfils.profils[j].scores[scoreIndex];
                nomrecord := ListeProfils.profils[j].nom;
            end;
		if score > 0 then
            writeln(listej.jeu1[i],' : ',nomrecord,' avec un score de ',score)
        else
            writeln(listej.jeu1[i],' : Aucun record');
    end;
    for i:= low(listej.jeu2) to high(listej.jeu2) do
    begin
        score := -1;
        nomrecord := '';
        scoreIndex := MAX_JEUX_SOLO + i; 
        for j:=0 to length(ListeProfils.profils)-1 do
            if ListeProfils.profils[j].scores[scoreIndex] > score then
            begin
                score := ListeProfils.profils[j].scores[scoreIndex];
                nomrecord := ListeProfils.profils[j].nom;
            end;
		if score > 0 then
            writeln(listej.jeu2[i],' : ',nomrecord,' avec un score de ',score)
        else
            writeln(listej.jeu2[i],' : Aucun record');
    end;
end;

procedure Parametres(var ListeProfils : TListeProfils);
var choixp : Integer;
begin
	repeat
		writeln('1-Ajouter un profil');
		writeln('2-Supprimer un profil');
		writeln('3-Modifier un profil');
		writeln('4-Retour au menu principal');
		readln(choixp);
		case choixp of
			1: AjouterProfil(ListeProfils);
			2: SupprimerProfil(ListeProfils);
			3: ModifierProfil(ListeProfils);
		end;
	until choixp = 4;

end;

procedure AjouterProfil(var ListeProfils : TListeProfils);
var i : Integer;
begin
    setlength(ListeProfils.profils, length(ListeProfils.profils) + 1);
    writeln('choissisez un nom pour le nouveau profil :');
    readln(ListeProfils.profils[high(ListeProfils.profils)].nom);
    for i:=1 to MAX_SCORES do
        ListeProfils.profils[high(ListeProfils.profils)].scores[i]:=0;
    sauvegarderProfils(ListeProfils); 
end;

procedure SupprimerProfil(var ListeProfils : TListeProfils);
var i,j : Integer;
	nomASupprimer : string;
begin
	writeln('choissisez le nom du profil a supprimer :');
	for i:=0 to length(ListeProfils.profils)-1 do
		writeln(ListeProfils.profils[i].nom);
	readln(nomASupprimer);
	for i:=0 to length(ListeProfils.profils)-1 do
		if ListeProfils.profils[i].nom = nomASupprimer then
		begin
			for j:=i to length(ListeProfils.profils)-2 do
				ListeProfils.profils[j]:=ListeProfils.profils[j+1];
			setlength(ListeProfils.profils,length(ListeProfils.profils)-1);
			break;
		end;
    sauvegarderProfils(ListeProfils); 
end;

procedure ModifierProfil(var ListeProfils : TListeProfils);
var i : Integer;
	nomAModifier,nouveauNom : string;
	trouve : Boolean;
begin
	trouve := False;
	writeln('choissisez le nom du profil à modifier :');
	for i:=0 to length(ListeProfils.profils)-1 do
		writeln(ListeProfils.profils[i].nom);
	readln(nomAModifier);
	for i:=0 to length(ListeProfils.profils)-1 do
		if ListeProfils.profils[i].nom = nomAModifier then
		begin
			writeln('Entrez le nouveau nom :');
			readln(nouveauNom);
			ListeProfils.profils[i].nom := nouveauNom;
			trouve := True;
			break;
		end;
	if not trouve then
		writeln('Profil non trouve.');
    sauvegarderProfils(ListeProfils); 
end;


procedure sauvegarderProfils(const ListeProfils : TListeProfils);
var
	f : TextFile;
	i, j : Integer;
	profilsPath : string;
begin
	profilsPath := ExtractFilePath(ParamStr(0)) + 'profils.txt';
	assign(f, profilsPath);
	rewrite(f);
	writeLn(f, length(ListeProfils.profils));
	for i := 0 to length(ListeProfils.profils) - 1 do
	begin
		writeLn(f, ListeProfils.profils[i].nom);
		for j := 1 to MAX_SCORES do
			writeLn(f, ListeProfils.profils[i].scores[j]);
	end;
	close(f);
end;


procedure chargerProfils(var ListeProfils : TListeProfils);
var
	f : TextFile;
	i, j, n : Integer;
	profilsPath : string;
begin
	profilsPath := ExtractFilePath(ParamStr(0)) + 'profils.txt';
	if not FileExists(profilsPath) then
	begin
		writeln('Fichier profils.txt introuvable, aucun profil charge.');
		setlength(ListeProfils.profils, 0);
		exit;
	end;
	assign(f, profilsPath);
	reset(f);
	readLn(f, n);
	setlength(ListeProfils.profils, n);
	for i := 0 to n - 1 do
	begin
		readLn(f, ListeProfils.profils[i].nom);
		for j := 1 to MAX_SCORES do
			readLn(f, ListeProfils.profils[i].scores[j]);
	end;
	close(f);
end;

procedure initNomJeux(var listej : TListeJeux);
begin
	listej.jeu1[1] := 'Casino';
	listej.jeu1[2] := 'Frogger';
	listej.jeu1[3] := 'Flappy Bird';
	listej.jeu2[1] := 'Puissance 4';
	listej.jeu2[2] := 'Morpion';
	listej.jeu2[3] := 'Tron';
end;

procedure choixJoueur(p : Integer; var j: Integer; var ListeProfils : TListeProfils);
var i : Integer;
begin
	if length(ListeProfils.profils) < p then
	begin
	repeat
		AjouterProfil(ListeProfils);
	until length(ListeProfils.profils) >= p;
	end;
	for i:=0 to length(ListeProfils.profils)-1 do
		writeln(i+1,'-',ListeProfils.profils[i].nom);
	writeln('choissez un profil pour le joueur ',p,':');
	repeat
		readln(j);
		j := j - 1;
		if (j < 0) or (j > high(ListeProfils.profils)) then
		begin
			writeln('Choix invalide. Reessayez.');
			j := -1;
		end;
	until (j >= 0) and (j <= high(ListeProfils.profils));
end;

end.
