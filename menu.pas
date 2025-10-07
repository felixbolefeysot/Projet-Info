unit menu;

interface 

uses Typesmenu;

procedure choix(var choix : Integer);
{procedure menu(liste: TListeProfils; choix : Integer);
procedure lancerJeu(choixj : Integer);}
procedure Choixjeu(nbJ : Integer; var choixj : Integer);

implementation

procedure choix(var choix : Integer);
begin
	repeat 
		writeln('1-Records');
		writeln('2-1 Joueur');
		writeln('3-2 Joueurs');
		writeln('4-Paramètres Profils');
		readln(choix)
	until (choix<5) and (choix>0)
end;

{procedure menu(liste: TListeProfils; choix : Integer);
begin
	case choix of
	1: Records(liste);
	2: UnJoueur();
	3: DeuxJoueurs();
	4: Parametres(liste);
	end;
end;}

procedure Choixjeu(nbJ : Integer; var choixj : Integer);
begin
	if nbJ = 1 then
		writeln('1-jeu 1')
	else
		begin
			writeln('1-puissance 4');
			writeln('2-jeu 2');
		end;
	readln(choixj);
end;

{procedure lancerJeu(choixj : Integer);
begin
	case choixj of
	1: if nbJ=1 then
		jeu1()
	else
		Puissance4();
	2: if nbJ=1 then
		jeu2()
	else
		jeu2();
	end;}

end.
