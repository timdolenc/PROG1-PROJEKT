type stanje = Stanje.t

type t = {
  stanja : stanje list;
  zacetno_stanje : stanje;
  sprejemna_stanja : stanje list;
  prehodi : (stanje * char * stanje) list;
  izhodna_funkcija : (stanje * char -> string) option;
}

let prazen_avtomat zacetno_stanje =
  {
    stanja = [ zacetno_stanje ];
    zacetno_stanje;
    sprejemna_stanja = [];
    prehodi = [];
    izhodna_funkcija = None;
  }

let dodaj_nesprejemno_stanje stanje avtomat =
  { avtomat with stanja = stanje :: avtomat.stanja }

let dodaj_sprejemno_stanje stanje avtomat =
  {
    avtomat with
    stanja = stanje :: avtomat.stanja;
    sprejemna_stanja = stanje :: avtomat.sprejemna_stanja;
  }

let dodaj_prehod stanje1 znak stanje2 avtomat =
  { avtomat with prehodi = (stanje1, znak, stanje2) :: avtomat.prehodi }

let prehodna_funkcija avtomat stanje znak =
  match
    List.find_opt
      (fun (stanje1, znak', _stanje2) -> stanje1 = stanje && znak = znak')
      avtomat.prehodi
  with
  | None -> None
  | Some (_, _, stanje2) -> Some stanje2

let zacetno_stanje avtomat = avtomat.zacetno_stanje
let seznam_stanj avtomat = avtomat.stanja
let seznam_prehodov avtomat = avtomat.prehodi

let je_sprejemno_stanje avtomat stanje =
  List.mem stanje avtomat.sprejemna_stanja

let nastavi_izhodno_funkcijo f avtomat =
  { avtomat with izhodna_funkcija = Some f }

let izhodna_funkcija avtomat stanje znak =
  match avtomat.izhodna_funkcija with
  | Some f -> f (stanje, znak)
  | None -> "No output function set"

let generiraj_vsa_stanja max_x max_y =
  let smeri = [Stanje.S; Stanje.J; Stanje.V; Stanje.Z] in
  let stanja = ref [] in
  for x = 0 to max_x do
    for y = 0 to max_y do
      List.iter (fun smer -> stanja := (Stanje.iz_komponent smer x y) :: !stanja) smeri
    done
  done;
  !stanja

let generiraj_vse_prehode max_x max_y =
  let prehodi = ref [] in
  let dodaj_prehod stanje1 znak stanje2 = prehodi := (stanje1, znak, stanje2) :: !prehodi in
  for x = 0 to max_x do
    for y = 0 to max_y do
      List.iter (fun smer ->
        let trenutna = Stanje.iz_komponent smer x y in
        match smer with
        | Stanje.S ->
          dodaj_prehod trenutna 'L' (Stanje.iz_komponent Stanje.Z x y);
          dodaj_prehod trenutna 'D' (Stanje.iz_komponent Stanje.V x y);
          if y < max_y then
            dodaj_prehod trenutna 'N' (Stanje.iz_komponent Stanje.S x (y + 1))
          else
            dodaj_prehod trenutna 'N' (Stanje.iz_komponent Stanje.S x y)
        | Stanje.J ->
          dodaj_prehod trenutna 'L' (Stanje.iz_komponent Stanje.V x y);
          dodaj_prehod trenutna 'D' (Stanje.iz_komponent Stanje.Z x y);
          if y > 0 then
            dodaj_prehod trenutna 'N' (Stanje.iz_komponent Stanje.J x (y - 1))
          else
            dodaj_prehod trenutna 'N' (Stanje.iz_komponent Stanje.J x y)
        | Stanje.V ->
          dodaj_prehod trenutna 'L' (Stanje.iz_komponent Stanje.S x y);
          dodaj_prehod trenutna 'D' (Stanje.iz_komponent Stanje.J x y);
          if x < max_x then
            dodaj_prehod trenutna 'N' (Stanje.iz_komponent Stanje.V (x + 1) y)
          else
            dodaj_prehod trenutna 'N' (Stanje.iz_komponent Stanje.V x y)
        | Stanje.Z ->
          dodaj_prehod trenutna 'L' (Stanje.iz_komponent Stanje.J x y);
          dodaj_prehod trenutna 'D' (Stanje.iz_komponent Stanje.S x y);
          if x > 0 then
            dodaj_prehod trenutna 'N' (Stanje.iz_komponent Stanje.Z (x - 1) y)
          else
            dodaj_prehod trenutna 'N' (Stanje.iz_komponent Stanje.Z x y)
      ) [Stanje.S; Stanje.J; Stanje.V; Stanje.Z]
    done
  done;
  !prehodi

(* Definira avtomat za premikanje po koordinatnem sistemu in dosego ciljne točke *)
let premik_na_koordinate max_x max_y =
  let q0 = Stanje.iz_komponent Stanje.S 0 0 in  (* Začetno stanje: smer S, koordinate (0, 0) *)
  let cilji = [
    Stanje.iz_komponent Stanje.S max_x max_y;
    Stanje.iz_komponent Stanje.J max_x max_y;
    Stanje.iz_komponent Stanje.V max_x max_y;
    Stanje.iz_komponent Stanje.Z max_x max_y;
  ] in  (* Ciljna stanja: vse smeri na koordinatah (max_x, max_y) *)
  let stanja = generiraj_vsa_stanja max_x max_y in
  let prehodi = generiraj_vse_prehode max_x max_y in
  let avtomat = {
    stanja;
    zacetno_stanje = q0;
    sprejemna_stanja = cilji;
    prehodi;
    izhodna_funkcija = None;
  } in
  (* Nastavi izhodno funkcijo, ki vrača trenutno smer *)
  nastavi_izhodno_funkcijo (fun (stanje, _znak) ->
    match Stanje.smer stanje with
    | Stanje.S -> "Sever"
    | Stanje.J -> "Jug"
    | Stanje.V -> "Vzhod"
    | Stanje.Z -> "Zahod"
  ) avtomat

let preberi_niz avtomat q niz =
  let aux acc znak =
    match acc with
    | None -> None
    | Some q -> prehodna_funkcija avtomat q znak
  in
  niz |> String.to_seq |> Seq.fold_left aux (Some q)
