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

(* Funkcija za branje niza in vrnitev končnega stanja po obdelavi niza *)
let preberi_niz avtomat q niz =
  let aux acc znak =
    match acc with None -> None | Some q -> prehodna_funkcija avtomat q znak
  in
  niz |> String.to_seq |> Seq.fold_left aux (Some q) (* Izvede prehod za vsak znak v nizu *)

(* Funkcija, ki generira vsa možna stanja na gridu z dimenzijami (max_x, max_y) *)
let generiraj_vsa_stanja max_x max_y =
  let smeri = [Stanje.S; Stanje.J; Stanje.V; Stanje.Z] in (* Seznam vseh možnih smeri *)
  let stanja = ref [] in  (* Referenca na seznam stanj *)
  for x = 0 to max_x do  (* Iteracija skozi vse možne vrednosti x na gridu *)
    for y = 0 to max_y do  (* Iteracija skozi vse možne vrednosti y na gridu *)
      List.iter (fun smer -> stanja := (Stanje.iz_komponent smer x y) :: !stanja) smeri
      (* Za vsako smer dodamo novo stanje na seznam stanj *)
    done
  done;
  !stanja  (* Vrni vse zbrana stanja *)

(* Funkcija, ki generira vse prehode za avtomat *)
let generiraj_vse_prehode max_x max_y =
  let prehodi = ref [] in  (* Referenca na seznam prehodov *)
  let dodaj_prehod stanje1 znak stanje2 = prehodi := (stanje1, znak, stanje2) :: !prehodi in
  (* Funkcija za dodajanje prehoda na seznam prehodov *)
  for x = 0 to max_x do  (* Iteracija skozi vse možne vrednosti x na gridu *)
    for y = 0 to max_y do  (* Iteracija skozi vse možne vrednosti y na gridu *)
      List.iter (fun smer ->  (* Iteracija skozi vse možne smeri *)
        let trenutna = Stanje.iz_komponent smer x y in  (* Trenutno stanje *)
        match smer with
        | Stanje.S ->  (* Če je smer sever *)
          dodaj_prehod trenutna 'L' (Stanje.iz_komponent Stanje.Z x y);  (* Premik levo *)
          dodaj_prehod trenutna 'D' (Stanje.iz_komponent Stanje.V x y);  (* Premik desno *)
          if y < max_y then
            dodaj_prehod trenutna 'N' (Stanje.iz_komponent Stanje.S x (y + 1))  (* Premik naprej *)
          else
            dodaj_prehod trenutna 'N' (Stanje.iz_komponent Stanje.S x y)  (* Ostane na mestu *)
        | Stanje.J ->  (* Če je smer jug *)
          dodaj_prehod trenutna 'L' (Stanje.iz_komponent Stanje.V x y);  (* Premik levo *)
          dodaj_prehod trenutna 'D' (Stanje.iz_komponent Stanje.Z x y);  (* Premik desno *)
          if y > 0 then
            dodaj_prehod trenutna 'N' (Stanje.iz_komponent Stanje.J x (y - 1))  (* Premik naprej *)
          else
            dodaj_prehod trenutna 'N' (Stanje.iz_komponent Stanje.J x y)  (* Ostane na mestu *)
        | Stanje.V ->  (* Če je smer vzhod *)
          dodaj_prehod trenutna 'L' (Stanje.iz_komponent Stanje.S x y);  (* Premik levo *)
          dodaj_prehod trenutna 'D' (Stanje.iz_komponent Stanje.J x y);  (* Premik desno *)
          if x < max_x then
            dodaj_prehod trenutna 'N' (Stanje.iz_komponent Stanje.V (x + 1) y)  (* Premik naprej *)
          else
            dodaj_prehod trenutna 'N' (Stanje.iz_komponent Stanje.V x y)  (* Ostane na mestu *)
        | Stanje.Z ->  (* Če je smer zahod *)
          dodaj_prehod trenutna 'L' (Stanje.iz_komponent Stanje.J x y);  (* Premik levo *)
          dodaj_prehod trenutna 'D' (Stanje.iz_komponent Stanje.S x y);  (* Premik desno *)
          if x > 0 then
            dodaj_prehod trenutna 'N' (Stanje.iz_komponent Stanje.Z (x - 1) y)  (* Premik naprej *)
          else
            dodaj_prehod trenutna 'N' (Stanje.iz_komponent Stanje.Z x y)  (* Ostane na mestu *)
      ) [Stanje.S; Stanje.J; Stanje.V; Stanje.Z]
      (* Iteracija skozi vse možne smeri *)
    done
  done;
  !prehodi  (* Vrni vse zbrane prehode *)

(* Definira avtomat za premikanje po koordinatnem sistemu in dosego ciljne točke *)
let premik_na_koordinate max_x max_y =
  let q0 = Stanje.iz_komponent Stanje.S 0 0 in  (* Začetno stanje: smer S, koordinate (0, 0) *)
  let q_cilj_S = Stanje.iz_komponent Stanje.S max_x max_y in  (* Ciljno stanje: smer S, koordinate (max_x, max_y) *)
  let q_cilj_J = Stanje.iz_komponent Stanje.J max_x max_y in  (* Ciljno stanje: smer J, koordinate (max_x, max_y) *)
  let q_cilj_V = Stanje.iz_komponent Stanje.V max_x max_y in  (* Ciljno stanje: smer V, koordinate (max_x, max_y) *)
  let q_cilj_Z = Stanje.iz_komponent Stanje.Z max_x max_y in  (* Ciljno stanje: smer Z, koordinate (max_x, max_y) *)
  let stanja = generiraj_vsa_stanja max_x max_y in  (* Generiraj vsa možna stanja *)
  let prehodi = generiraj_vse_prehode max_x max_y in  (* Generiraj vse možne prehode *)
  {
    stanja;
    zacetno_stanje = q0;
    sprejemna_stanja = [q_cilj_S; q_cilj_J; q_cilj_V; q_cilj_Z];  (* Dodaj vsa ciljna stanja *)
    prehodi;
  }
  (* Vrni avtomat z začetnim stanjem q0, ciljnimi stanji q_cilj_S, q_cilj_J, q_cilj_V, q_cilj_Z, vsemi možnimi stanjih in prehodi *)

