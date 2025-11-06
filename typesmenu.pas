unit typesmenu;
    
interface
    
    Type TProfil=record
        nom : string;
        scores : array[1..3] of integer;
    end;

    Type TListeProfils=record
        profils : array of TProfil
    end;

    var liste : TListeProfils;

    const
        MAX_JEUX_SOLO = 2;    
        MAX_JEUX_MULTI = 1;   
        MAX_SCORES = MAX_JEUX_SOLO + MAX_JEUX_MULTI;  
    Type TListeJeux=record
        jeu1 : array[1..MAX_JEUX_SOLO] of string;  
        jeu2 : array[1..MAX_JEUX_MULTI] of string; 
    end;

    var listej : TListeJeux;

implementation
     
end.
