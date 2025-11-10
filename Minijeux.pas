program Minijeux;
uses menu, typesmenu;
var choixmenu : LongInt;
    listep : TListeProfils;
begin
    writeln('Bienvenue dans le menu des mini-jeux !');
    chargerProfils(listep);
    if length(listep.profils) = 0 then
        writeln('Aucun profil existant. Creez-en un via Parametres Profils.');
    choixmenu := 0;
    repeat
        choix(choixmenu);
        menu.menu(choixmenu, listep);
    until choixmenu = 5;
    sauvegarderProfils(listep);
end.