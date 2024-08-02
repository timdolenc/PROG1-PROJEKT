open Definicije

(* Definicija načinov delovanja vmesnika *)
type nacin = VnosDimenzij | Premikanje

(* Definicija modela *)
type model = {
  avtomat : ZagnaniAvtomat.t option;  (* Zagnani avtomat *)
  max_x : int;                        (* Maksimalna x dimenzija mreže *)
  max_y : int;                        (* Maksimalna y dimenzija mreže *)
  nacin : nacin;                      (* Trenutni način delovanja *)
}

(* Inicializacija modela *)
let init max_x max_y =
  {
    avtomat = None;  (* Avtomat še ni inicializiran *)
    max_x;
    max_y;
    nacin = VnosDimenzij;
  }

(* Definicija sporočil *)
type msg =
  | NastaviDimenzije of int * int (* Nastavi dimenzije mreže *)
  | Premakni of char              (* Premik avtomata z ukazom (N, L, D) *)
  | PreveriStanje                 (* Preveri, če je avtomat v sprejemnem stanju *)

(* Posodobitev modela glede na prejeto sporočilo *)
let update model = function
  | NastaviDimenzije (x, y) ->
      let avtomat = Avtomat.premik_na_koordinate x y in
      {
        avtomat = Some (ZagnaniAvtomat.pozeni avtomat Trak.prazen);
        max_x = x;
        max_y = y;
        nacin = Premikanje;
      }
  | Premakni ukaz -> (
      match model.avtomat with
      | None -> model
      | Some avtomat -> (
          let trak = Trak.iz_niza (String.make 1 ukaz) in
          let avtomat' = ZagnaniAvtomat.pozeni (ZagnaniAvtomat.avtomat avtomat) trak in
          match ZagnaniAvtomat.korak_naprej avtomat' with
          | None -> model
          | Some avtomat'' -> { model with avtomat = Some avtomat'' }))
  | PreveriStanje -> model  (* Dodamo logiko za preverjanje stanja v naslednji datoteki *)
