(* Definira tip stanja, ki je določen v modulu Stanje *)
type stanje = Stanje.t

(* Definira tip avtomata z lastnostmi: stanja, začetno stanje, sprejemna stanja in prehodi *)
type t = {
  stanja : stanje list;                 (* Seznam vseh stanj avtomata *)
  zacetno_stanje : stanje;              (* Začetno stanje avtomata *)
  sprejemna_stanja : stanje list;       (* Seznam sprejemnih stanj *)
  prehodi : (stanje * char * stanje) list; (* Seznam prehodov v obliki (trenutno stanje, vhod, naslednje stanje) *)
}

(* Ustvari prazen avtomat z danim začetnim stanjem *)
let prazen_avtomat zacetno_stanje =
  {
    stanja = [ zacetno_stanje ];        (* Začetno stanje je edino stanje *)
    zacetno_stanje;                     (* Nastavi začetno stanje *)
    sprejemna_stanja = [];              (* Ni sprejemnih stanj *)
    prehodi = [];                       (* Ni prehodov *)
  }

(* Dodaj nesprejemno stanje avtomatu *)
let dodaj_nesprejemno_stanje stanje avtomat =
  { avtomat with stanja = stanje :: avtomat.stanja } (* Dodaj novo stanje na seznam stanj *)

(* Dodaj sprejemno stanje avtomatu *)
let dodaj_sprejemno_stanje stanje avtomat =
  {
    avtomat with
    stanja = stanje :: avtomat.stanja;                (* Dodaj novo stanje na seznam stanj *)
    sprejemna_stanja = stanje :: avtomat.sprejemna_stanja; (* Dodaj novo stanje na seznam sprejemnih stanj *)
  }

(* Dodaj prehod med dvema stanjem z določenim vhodom *)
let dodaj_prehod stanje1 znak stanje2 avtomat =
  { avtomat with prehodi = (stanje1, znak, stanje2) :: avtomat.prehodi } (* Dodaj nov prehod na seznam prehodov *)

(* Prehodna funkcija, ki vrne naslednje stanje glede na trenutno stanje in vhodni znak *)
let prehodna_funkcija avtomat stanje znak =
  match
    List.find_opt
      (fun (stanje1, znak', _stanje2) -> stanje1 = stanje && znak = znak')
      avtomat.prehodi
  with
  | None -> None                         (* Če prehoda ni, vrni None *)
  | Some (_, _, stanje2) -> Some stanje2 (* Če prehod obstaja, vrni naslednje stanje *)

(* Vrne začetno stanje avtomata *)
let zacetno_stanje avtomat = avtomat.zacetno_stanje
(* Vrne seznam vseh stanj avtomata *)
let seznam_stanj avtomat = avtomat.stanja
(* Vrne seznam vseh prehodov avtomata *)
let seznam_prehodov avtomat = avtomat.prehodi

(* Preveri, ali je dano stanje sprejemno *)
let je_sprejemno_stanje avtomat stanje =
  List.mem stanje avtomat.sprejemna_stanja (* Vrne true, če je stanje v seznamu sprejemnih stanj *)

(* Definira avtomat za prepoznavanje nizov, kjer je število enic deljivo s 3 *)
let enke_1mod3 =
  let q0 = Stanje.iz_niza "q0"
  and q1 = Stanje.iz_niza "q1"
  and q2 = Stanje.iz_niza "q2" in
  prazen_avtomat q0 |> dodaj_sprejemno_stanje q1
  |> dodaj_nesprejemno_stanje q2
  |> dodaj_prehod q0 '0' q0 |> dodaj_prehod q1 '0' q1 |> dodaj_prehod q2 '0' q2
  |> dodaj_prehod q0 '1' q1 |> dodaj_prehod q1 '1' q2 |> dodaj_prehod q2 '1' q0

(* Funkcija za branje niza in vrnitev končnega stanja po obdelavi niza *)
let preberi_niz avtomat q niz =
  let aux acc znak =
    match acc with None -> None | Some q -> prehodna_funkcija avtomat q znak
  in
  niz |> String.to_seq |> Seq.fold_left aux (Some q) (* Izvede prehod za vsak znak v nizu *)
