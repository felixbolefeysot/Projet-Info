program Minijeux;
uses menu, typesmenu;
var choixmenu : LongInt;
    listep : TListeProfils;
begin
    writeln('Bienvenue dans le menu des mini-jeux !');
    chargerProfils(listep);
    choixmenu := 0;
    repeat
        choix(choixmenu);
        menu.menu(listep, choixmenu);
    until choixmenu = 5;
    sauvegarderProfils(listep);
end.