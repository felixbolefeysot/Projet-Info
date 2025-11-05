{$MODE OBJFPC}

unit menu;

interface

uses Typesmenu, crt, SysUtils, puissance4, casino;

var choixj : Integer;
	listej : TListeJeux;
	ListeProfils : TListeProfils;

procedure choix(var choix : Integer);
procedure menu(ListeProfils: TListeProfils; choix : Integer);
procedure lancerJeu(j1,j2,choixj : Integer; var ListeProfils : TListeProfils);
procedure Choixjeu(nbJ : Integer; var choixj : Integer);
procedure UnJoueur(var ListeProfils : TListeProfils);
procedure DeuxJoueurs(var ListeProfils : TListeProfils);
procedure Parametres(var ListeProfils : TListeProfils);
procedure Records(ListeProfils : TListeProfils);
procedure AjouterProfil(var ListeProfils : TListeProfils);
procedure SupprimerProfil(var ListeProfils : TListeProfils);
procedure ModifierProfil(var ListeProfils : TListeProfils);
procedure chargerProfils(var ListeProfils : TListeProfils);
procedure sauvegarderProfils( const ListeProfils : TListeProfils);
procedure initNomJeux(var listej : TListeJeux);
procedure choixJoueur(p : Integer; var j: Integer);

implementation

procedure choix(var choix : Integer);
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

procedure menu(ListeProfils: TListeProfils; choix : Integer);
begin
	case choix of
	1: Records(ListeProfils);
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
	for i:= 1 to length(listej.jeu) do
		writeln(i,'-',listej.jeu[i]);
	repeat
		writeln('Quel jeu voulez-vous faire ?');
		readln(choixj);
		if (choixj<1) or (choixj>3) then
			writeln('Choix invalide, veuillez reessayer.');
	until (choixj >= 1) and (choixj <= 3);
end;

procedure lancerJeu(j1,j2,choixj : Integer; var ListeProfils : TListeProfils);
begin
		case choixj of
					1: begin
							jouerRoulette; 
							scorecasino(ListeProfils, j1);
						 end;
					2: begin
							puissance4.
							scorepuissance4(ListeProfils, j1, j2);
						 end;
			{3: begin
					 frogger();
					 scorefrogger(ListeProfils, j1);
				 end;}
		end;
end;
	
procedure UnJoueur(var ListeProfils : TListeProfils);
var
	j1, choixj : Integer;
begin
	Choixjeu(1, choixj);
	ChoixJoueur(1, j1);
	lancerJeu(j1, 0, choixj, ListeProfils);
end;

procedure DeuxJoueurs(var ListeProfils : TListeProfils);
var
	j1, j2, choixj : Integer;
begin
	Choixjeu(2, choixj);
	ChoixJoueur(1, j1);
	ChoixJoueur(2, j2);
	lancerJeu(j1, j2, choixj, ListeProfils);
end;

procedure Records(ListeProfils : TListeProfils);
var i,j, score : Integer;
	nomrecord : string;
begin
	initNomJeux(listej);
	writeln('Affichage des records :');
	for i:=1 to 3 do
		begin
			score := 0;
			nomrecord := '';
			for j:=0 to length(ListeProfils.profils)-1 do
				if ListeProfils.profils[j].scores[i] > score then
					begin
						score := ListeProfils.profils[j].scores[i];
						nomrecord := ListeProfils.profils[j].nom;
					end;
			writeln(listej.jeu[j],' : ',nomrecord,' avec un score de ',score);
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
	writeln('choissisez un nom pour le nouveau profil :');
	readln(liste.profils[length(liste.profils)+1].nom);
	for i:=1 to 3 do
		liste.profils[length(liste.profils)].scores[i]:=0;
end;

procedure SupprimerProfil(var ListeProfils : TListeProfils);
var i,j : Integer;
	nomASupprimer : string;
begin
	writeln('choissisez le nom du profil à supprimer :');
	readln(nomASupprimer);
	for i:=0 to length(liste.profils)-1 do
		if liste.profils[i].nom = nomASupprimer then
			for j:=i to length(liste.profils)-1 do
				liste.profils[j]:=liste.profils[j+1];
	setlength(liste.profils,length(liste.profils)-1);
end;

procedure ModifierProfil(var ListeProfils : TListeProfils);
var i : Integer;
	nomAModifier,nouveauNom : string;
begin
	writeln('choissisez le nom du profil à modifier :');
	readln(nomAModifier);
	for i:=0 to length(liste.profils)-1 do
		if liste.profils[i].nom = nomAModifier then
			begin
				writeln('Entrez le nouveau nom :');
				readln(nouveauNom);
				liste.profils[i].nom := nouveauNom;
			end;
end;


procedure sauvegarderProfils(const ListeProfils : TListeProfils);
var
	f : TextFile;
	i, j : Integer;
begin
	assignfile(f, 'profils.txt');
	rewrite(f);
	writeLn(f, length(ListeProfils.profils));
	for i := 0 to length(ListeProfils.profils) - 1 do
	begin
		writeLn(f, ListeProfils.profils[i].nom);
		for j := 1 to 2 do
			writeLn(f, ListeProfils.profils[i].scores[j]);
	end;
		closefile(f);
end;


procedure chargerProfils(var ListeProfils : TListeProfils);
var
	f : TextFile;
	i, j, n : Integer;
begin
	if not FileExists('profils.txt') then
	begin
		writeln('Fichier profils.txt introuvable, aucun profil charge.');
		setlength(ListeProfils.profils, 0);
		exit;
	end;
		assignfile(f, 'profils.txt');
	reset(f);
	readLn(f, n);
	setlength(ListeProfils.profils, n);
	for i := 0 to n - 1 do
	begin
		readLn(f, ListeProfils.profils[i].nom);
		for j := 1 to 3 do
			readLn(f, ListeProfils.profils[i].scores[j]);
	end;
		closefile(f);
end;

procedure initNomJeux(var listej : TListeJeux);
begin
	listej.jeu[1] := 'casino';
	listej.jeu[2] := 'Puissance 4';
	listej.jeu[3] := 'frogger';
end;

procedure choixJoueur(p : Integer; var j: Integer);
var i : Integer;
begin
	if length(ListeProfils.profils) = 0 then
		AjouterProfil(ListeProfils);
	for i:=0 to length(ListeProfils.profils)-1 do
		writeln(i+1,'-',ListeProfils.profils[i].nom);
	writeln('choissez un profil pour le joueur ',p,':');
	readln(j);
end;

end.
