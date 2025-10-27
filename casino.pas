program casino;

uses
  crt, roulette;

var
  choixPari, mise, douzaineMise, ligneMise, colonneMise: integer;
  douzaineTirage, ligneTirage, colonneTirage, numeroTirage: integer;
  couleurTirage, pariteTirage: string;
  c, ip: char;
  gain: integer;
  rejouer: char;

begin
  Randomize;

  repeat
    clrscr;

    // 1. Choix du type de pari
    choix(choixPari);

    // 2. Demander la mise selon le choix
    miser(choixPari, mise, douzaineMise, ligneMise, colonneMise, c, ip);

    // 3. Tirage du numéro
    tirage(numeroTirage, couleurTirage, pariteTirage, douzaineTirage, ligneTirage, colonneTirage);
    writeln('Le numero tire est : ', numeroTirage, ' (', couleurTirage, ', ', pariteTirage, ')');

    // 4. Calcul du gain
    calculerGain(
      choixPari, mise, douzaineMise, ligneMise, colonneMise, numeroTirage,
      douzaineTirage, ligneTirage, colonneTirage,
      c, ip, couleurTirage, pariteTirage,
      gain
    );

    // 5. Affichage du résultat
    if gain > 0 then
      writeln('Bravo ! Vous avez gagne ', gain, ' euros.')
    else
      writeln('Dommage, vous avez perdu votre mise de ', mise, ' euros.');

    // 6. Rejouer ?
    writeln;
    write('Voulez-vous rejouer ? (o/n) : ');
    readln(rejouer);

  until (rejouer = 'N') or (rejouer = 'n');

  writeln('Merci d''avoir joue !');

end.
