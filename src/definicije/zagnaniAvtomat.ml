(* Definicija tipa t, ki predstavlja simulacijo avtomata *)
type t = {
  avtomat : Avtomat.t;    (* Avtomat, ki ga simuliramo *)
  trak : Trak.t;          (* Trak z ukazi za avtomat *)
  stanje : Stanje.t       (* Trenutno stanje avtomata *)
}

(* Funkcija, ki inicializira simulacijo avtomata z danim trakom *)
let pozeni avtomat trak =
  { avtomat; trak; stanje = Avtomat.zacetno_stanje avtomat }

(* Funkcija, ki vrne avtomat iz simulacije *)
let avtomat { avtomat; _ } = avtomat

(* Funkcija, ki vrne trak iz simulacije *)
let trak { trak; _ } = trak

(* Funkcija, ki vrne trenutno stanje iz simulacije *)
let stanje { stanje; _ } = stanje

(* Funkcija, ki izvede en korak simulacije *)
let korak_naprej { avtomat; trak; stanje } =
  if Trak.je_na_koncu trak then None  (* Če je trak na koncu, vrni None *)
  else
    let stanje' =
      Avtomat.prehodna_funkcija avtomat stanje (Trak.trenutni_znak trak)
    in
    match stanje' with
    | None -> None  (* Če ni veljavnega prehoda, vrni None *)
    | Some stanje' ->
        Some { avtomat; trak = Trak.premakni_naprej trak; stanje = stanje' }
        (* Premakni trak naprej in posodobi stanje avtomata *)

(* Funkcija, ki preveri, ali je avtomat v sprejemnem stanju *)
let je_v_sprejemnem_stanju { avtomat; stanje; _ } =
  Avtomat.je_sprejemno_stanje avtomat stanje
