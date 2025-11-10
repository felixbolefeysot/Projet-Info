unit casino;

interface 

uses programmeroulette, Typesmenu;

var capital : Integer;

procedure jouerRoulette;
procedure scorecasino(var liste: TListeProfils; j: Integer);

implementation
  procedure jouerRoulette;
var
  ch, m, d, l, co, num, gain: integer;
  c, ip, rejouer: char;
begin
  capital := 70; 
  randomize;
  writeln('----------------------------------------');
  writeln(' Bienvenue à la Roulette !');
  writeln('Capital de depart : ', capital, ' unites.');
  writeln('----------------------------------------');

  repeat
    if capital <= 0 then
    begin
      writeln(' Vous n''avez plus d''argent... Le jeu est termine.');
      break;
    end;

    afficherCapital(capital);
    choix(ch);
    mise(ch, m, d, l, co, c, ip);

    if m > capital then
    begin
      writeln(' Vous ne pouvez pas miser plus que votre capital !');
      continue;
    end;

    num := tirage;
    writeln;
    writeln('----------------------------------------');
    writeln(' Numero tire : ', num, ' (', couleur(num), ')');
    gain := verifgain(ch, num, m, d, l, co, c, ip);

    if gain > 0 then
    begin
      writeln(' Gagne ! Vous remportez ', gain, ' unites.');
      capital := capital + (gain - m); 
    end
    else
    begin
      writeln(' Perdu ! Vous perdez votre mise de ', m, ' unites.');
      capital := capital - m;
    end;

    afficherCapital(capital);

    if capital > 0 then
    begin
      write('Voulez-vous rejouer ? (o/n) : ');
      readln(rejouer);
    end
    else
      rejouer := 'n';

  until (rejouer <> 'o') and (rejouer <> 'O');

  writeln;
  writeln('----------------------------------------');
  writeln(' Fin du jeu ! Capital final : ', capital, ' unites.');
  writeln('Merci d''avoir joué !');
  writeln('----------------------------------------');
  readln;
end;

procedure scorecasino(var liste: TListeProfils; j: Integer);
begin
    if capital > liste.profils[j].scores[1] then
        liste.profils[j].scores[1] := capital;
end;

end.
