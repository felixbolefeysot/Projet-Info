unit typesmenu;
    
interface
    
    Type TProfil=record
        nom : string;
        scores : array[1..1] of integer;
    end;

    Type TListeProfils=record
        profils : array of TProfil
    end;

implementation
     
end.
