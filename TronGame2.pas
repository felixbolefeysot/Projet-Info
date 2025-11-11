unit TronGame2;

interface
uses
  SDL2, SDL2_image, SysUtils, Math;

procedure JouerTron;

implementation

const
  LARGEUR_ECRAN = 800;
  HAUTEUR_ECRAN = 600;
  TAILLE_CASE   = 8;
  VITESSE       = 80;  // ms entre frames

type
  TDirection = (Haut, Bas, Gauche, Droite);

  TJoueur = record
    x, y: Integer;
    dir: TDirection;
    image: PSDL_Texture;
    angle: Double;
    trailColor: SDL_Color;
  end;

var
  window: PSDL_Window;
  renderer: PSDL_Renderer;
  event: TSDL_Event;
  grille: array of array of Boolean;
  joueur1, joueur2: TJoueur;
  jeuActif: Boolean;

{-----------------------------------------------------}
procedure ChargerImage(var texture: PSDL_Texture; fichier: string);
var
  surface: PSDL_Surface;
begin
  surface := IMG_Load(PChar(fichier));
  if surface = nil then
    raise Exception.Create('Erreur : impossible de charger ' + fichier);
  texture := SDL_CreateTextureFromSurface(renderer, surface);
  SDL_FreeSurface(surface);
end;

{-----------------------------------------------------}
procedure InitialiserJoueur(var j: TJoueur; x, y: Integer; d: TDirection;
                            imageFile: string; trail: SDL_Color);
begin
  j.x := x;
  j.y := y;
  j.dir := d;
  j.trailColor := trail;
  j.angle := 0;
  ChargerImage(j.image, imageFile);
end;

{-----------------------------------------------------}
procedure InitialiserGrille;
begin
  SetLength(grille, LARGEUR_ECRAN div TAILLE_CASE, HAUTEUR_ECRAN div TAILLE_CASE);
end;

{-----------------------------------------------------}
procedure Deplacement(var j: TJoueur);
begin
  case j.dir of
    Haut:    Dec(j.y);
    Bas:     Inc(j.y);
    Gauche:  Dec(j.x);
    Droite:  Inc(j.x);
  end;
end;

{-----------------------------------------------------}
procedure Trace(var j: TJoueur);
begin
  if (j.x >= 0) and (j.x < Length(grille)) and
     (j.y >= 0) and (j.y < Length(grille[0])) then
    grille[j.x][j.y] := True;
end;

{-----------------------------------------------------}
procedure DessinerGrille;
var
  i, j: Integer;
  rect: TSDL_Rect;
begin
  rect.w := TAILLE_CASE;
  rect.h := TAILLE_CASE;
  for i := 0 to High(grille) do
    for j := 0 to High(grille[0]) do
      if grille[i][j] then
      begin
        SDL_SetRenderDrawColor(renderer, 30, 30, 60, 255);
        rect.x := i * TAILLE_CASE;
        rect.y := j * TAILLE_CASE;
        SDL_RenderFillRect(renderer, @rect);
      end;
end;

{-----------------------------------------------------}
procedure DessinerJoueur(var j: TJoueur);
var
  rect: TSDL_Rect;
begin
  rect.x := j.x * TAILLE_CASE - 12;
  rect.y := j.y * TAILLE_CASE - 12;
  rect.w := 32;
  rect.h := 32;

  case j.dir of
    Haut:    j.angle := 0;
    Droite:  j.angle := 90;
    Bas:     j.angle := 180;
    Gauche:  j.angle := 270;
  end;

  SDL_RenderCopyEx(renderer, j.image, nil, @rect, j.angle, nil, SDL_FLIP_NONE);
end;

{-----------------------------------------------------}
procedure GererTouches(var quitter: Boolean);
begin
  while SDL_PollEvent(@event) <> 0 do
  begin
    if event.type_ = SDL_QUITEV then quitter := True;

    if event.type_ = SDL_KEYDOWN then
    begin
      case event.key.keysym.sym of
        SDLK_ESCAPE: quitter := True;

        // Joueur 1 - flèches
        SDLK_UP:    if joueur1.dir <> Bas    then joueur1.dir := Haut;
        SDLK_DOWN:  if joueur1.dir <> Haut   then joueur1.dir := Bas;
        SDLK_LEFT:  if joueur1.dir <> Droite then joueur1.dir := Gauche;
        SDLK_RIGHT: if joueur1.dir <> Gauche then joueur1.dir := Droite;

        // Joueur 2 - ZQSD
        SDLK_z: if joueur2.dir <> Bas    then joueur2.dir := Haut;
        SDLK_s: if joueur2.dir <> Haut   then joueur2.dir := Bas;
        SDLK_q: if joueur2.dir <> Droite then joueur2.dir := Gauche;
        SDLK_d: if joueur2.dir <> Gauche then joueur2.dir := Droite;
      end;
    end;
  end;
end;

{-----------------------------------------------------}
function Collision(var j: TJoueur): Boolean;
begin
  Result := False;
  if (j.x < 0) or (j.x >= Length(grille)) or
     (j.y < 0) or (j.y >= Length(grille[0])) then
    Exit(True);
  if grille[j.x][j.y] then
    Exit(True);
end;

{-----------------------------------------------------}
procedure JouerTron;
var
  quitter: Boolean = False;
begin
  if SDL_Init(SDL_INIT_VIDEO) < 0 then
    raise Exception.Create('Erreur SDL_Init: ' + SDL_GetError);

  window := SDL_CreateWindow('TRON ARENA',
    SDL_WINDOWPOS_CENTERED, SDL_WINDOWPOS_CENTERED,
    LARGEUR_ECRAN, HAUTEUR_ECRAN, SDL_WINDOW_SHOWN);

  renderer := SDL_CreateRenderer(window, -1, SDL_RENDERER_ACCELERATED);
  if renderer = nil then
    raise Exception.Create('Erreur création renderer.');

  IMG_Init(IMG_INIT_PNG);
  InitialiserGrille;

  // Arène
  SDL_SetRenderDrawColor(renderer, 10, 10, 20, 255);
  SDL_RenderClear(renderer);

  // Joueurs
  InitialiserJoueur(joueur1, 10, (HAUTEUR_ECRAN div TAILLE_CASE) div 2, Droite,
    'moto_bleue.png', SDL_Color(r:0,g:120,b:255,a:255));
  InitialiserJoueur(joueur2, (LARGEUR_ECRAN div TAILLE_CASE)-10, (HAUTEUR_ECRAN div TAILLE_CASE) div 2, Gauche,
    'moto_orange.png', SDL_Color(r:255,g:140,b:0,a:255));

  jeuActif := True;

  while not quitter do
  begin
    GererTouches(quitter);
    if not jeuActif then Break;

    Trace(joueur1);
    Trace(joueur2);
    Deplacement(joueur1);
    Deplacement(joueur2);

    if Collision(joueur1) or Collision(joueur2) then
    begin
      jeuActif := False;
      Break;
    end;

    SDL_SetRenderDrawColor(renderer, 10, 10, 20, 255);
    SDL_RenderClear(renderer);

    DessinerGrille;
    DessinerJoueur(joueur1);
    DessinerJoueur(joueur2);

    SDL_RenderPresent(renderer);
    SDL_Delay(VITESSE);
  end;

  SDL_DestroyTexture(joueur1.image);
  SDL_DestroyTexture(joueur2.image);
  SDL_DestroyRenderer(renderer);
  SDL_DestroyWindow(window);
  IMG_Quit;
  SDL_Quit;
end;

end.
