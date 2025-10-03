unit programmeroulette;

interface

implementation 

procedure choix(var choix: integer);
	begin;
		writeln('Sur quoi voulez-vous miser?');
		writeln('Tapez 1 pour miser sur le rouge ou le noir');
		writeln('tapez 2 pour miser sur une douzaine');
		writeln('tapez 3 pour miser sur pair ou impair');
		writeln('tapez 4 pour miser le zéro');
		writeln('tapez 5 pour miser sur une ligne');
		writeln('tapez 6 pour miser sur une colonne');
		begin
			repeat
				readln(choix)
			until ((choix<7) and (choix>0));
		end; 
end;

procedure mise(choix : integer ; var mise, douzaine, ligne, colonne: integer; c, ip :char);
begin;
case choix of 
1 : writeln('noir ou rouge?');
   writeln('tapez n miser sur le noir');
   writeln('tapez r miser sur le rouge');
   repeat 
   readln(c)
   until (c=n) or (c=r);
   writeln('combien voulez-vous miser');
   readln(mise); 
2: writeln('quelle douzaine?');
   repeat 
   readln(douzaine)
   until ((douzaine<4) and (douzaine>0));
   writeln('combien voulez-vous miser');
   readln(mise); 
3: writeln('pair ou impair?');
   writeln('tapez p miser sur le noir');
   writeln('tapez i miser sur le rouge');
   repeat 
   readln(ip)
   until (ip=p) or (ip=i);
   writeln('combien voulez-vous miser');
   readln(mise); 
4: writeln('combien voulez-vous miser');
   readln(mise); 
5: writeln('quelle ligne?');
   repeat 
   readln(ligne)
   until ((ligne<3) and (ligne>0));
   writeln('combien voulez-vous miser');
   readln(mise); 
6: writeln('quelle colonne?');
   repeat 
   readln(colonne)
   until ((colonnne<12) and (colonne>0));
   writeln('combien voulez-vous miser');
   readln(mise); 
end;

