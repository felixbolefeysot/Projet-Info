unit typesmenu;
    
interface
    
    Type TProfil=record
        nom : string;
        scores : array[1..2] of integer;
    end;

    Type TListeProfils=record
        profils : array of TProfil
    end;

    var liste : TListeProfils;

    Type TListeJeux=record
        jeu : array[1..2] of string;
    end;

implementation
     
end.
