open Avtomat

type model = {
  avtomat : t;
  stanje_avtomata : Stanje.t;
  max_x : int;
  max_y : int;
}

let init max_x max_y =
  let avtomat = Avtomat.premik_na_koordinate max_x max_y in
  {
    avtomat;
    stanje_avtomata = Avtomat.zacetno_stanje avtomat;
    max_x;
    max_y;
  }

let premakni_avtomat model ukaz =
  match Avtomat.prehodna_funkcija model.avtomat model.stanje_avtomata ukaz with
  | None -> model
  | Some novo_stanje -> { model with stanje_avtomata = novo_stanje }

let je_sprejemno_stanje model =
  Avtomat.je_sprejemno_stanje model.avtomat model.stanje_avtomata
