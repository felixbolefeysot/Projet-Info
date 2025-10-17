unit menu;

interface 

uses Typesmenu;

var choixj,nbJ,nbJeu : Integer;

procedure choix(var choix : Integer);
{procedure menu(liste: TListeProfils; choix : Integer);
procedure lancerJeu(choixj : Integer);}
procedure Choixjeu(nbJ : Integer; var choixj : Integer);
procedure UnJoueur(choixj: Integer;var ListeProfils : TListeProfils);
procedure DeuxJoueurs(choixj:Integer;var ListeProfils : TListeProfils);


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
	1: Records(ListeProfils);
	2: UnJoueur(choixj,ListeProfils);
	3: DeuxJoueurs(choixj,ListeProfils);
	4: Parametres(ListeProfils);
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

{procedure lancerJeu(choixj : Integer; var ListeProfils : TListeProfils);
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
	
procedure UnJoueur(choixj: Integer;var ListeProfils : TListeProfils);
begin
	Choixjeu(nbJ,choixj);
	{lancerJeu(choixj,ListeProfils)}
end;

procedure DeuxJoueurs(choixj:Integer;var ListeProfils : TListeProfils);
begin
	Choixjeu(nbJ,choixj);
	{LancerJeu(choixj,ListeProfils)}
end;

{procedure Records(nbJeu: Integer;ListeProfils : TListeProfils);
var i : Integer;
begin
	for i:=1 to ListeProfils[i].nbJeu do
		writeln(nomJeu,':',bestJ,',',bestScore,'pts')
end;}

end.
