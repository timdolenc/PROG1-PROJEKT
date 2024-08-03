open Definicije
open Avtomat

(* Definicija stanj vmesnika *)
type stanje_vmesnika =
  | SeznamMoznosti           (* Prikaz seznama možnosti *)
  | IzpisAvtomata            (* Izpis stanj avtomata *)
  | BranjeNiza               (* Branje niza ukazov *)
  | RezultatPrebranegaNiza   (* Prikaz rezultata po branju niza *)
  | OpozoriloONapacnemNizu   (* Opozorilo o napačnem nizu *)
  | NastavljanjeDimenzij     (* Nastavljanje dimenzij mreže *)

(* Definicija modela *)
type model = {
  avtomat : t;               (* Avtomat, ki ga simuliramo *)
  stanje_avtomata : Stanje.t; (* Trenutno stanje avtomata *)
  stanje_vmesnika : stanje_vmesnika; (* Trenutno stanje vmesnika *)
  max_x : int;               (* Maksimalna x dimenzija mreže *)
  max_y : int;               (* Maksimalna y dimenzija mreže *)
}

(* Definicija sporočil *)
type msg =
  | PreberiNiz of string         (* Sporočilo za branje niza ukazov *)
  | ZamenjajVmesnik of stanje_vmesnika (* Sporočilo za menjavo stanja vmesnika *)
  | VrniVPrvotnoStanje           (* Sporočilo za ponastavitev avtomata na začetno stanje *)
  | NastaviDimenzije of int * int (* Sporočilo za nastavitev dimenzij mreže *)

(* Funkcija za branje niza ukazov *)
let preberi_niz avtomat q niz =
  let aux acc znak =
    match acc with
    | None -> None
    | Some q -> Avtomat.prehodna_funkcija avtomat q znak
  in
  niz |> String.to_seq |> Seq.fold_left aux (Some q)  (* Izvede prehod za vsak znak v nizu *)

(* Funkcija za posodobitev modela glede na prejeto sporočilo *)
let update model = function
  | PreberiNiz str -> (
      match preberi_niz model.avtomat model.stanje_avtomata str with
      | None -> { model with stanje_vmesnika = OpozoriloONapacnemNizu }  (* Če je niz neveljaven *)
      | Some stanje_avtomata ->
          {
            model with
            stanje_avtomata;                    (* Posodobi stanje avtomata *)
            stanje_vmesnika = RezultatPrebranegaNiza;  (* Posodobi stanje vmesnika *)
          })
  | ZamenjajVmesnik stanje_vmesnika -> { model with stanje_vmesnika }  (* Menjava stanja vmesnika *)
  | VrniVPrvotnoStanje ->
      {
        model with
        stanje_avtomata = zacetno_stanje model.avtomat;  (* Ponastavi stanje avtomata *)
        stanje_vmesnika = SeznamMoznosti;  (* Vrni vmesnik na začetni meni *)
      }
  | NastaviDimenzije (x, y) ->
      let avtomat = Avtomat.premik_na_koordinate x y in
      {
        avtomat;
        stanje_avtomata = zacetno_stanje avtomat;
        max_x = x;
        max_y = y;
        stanje_vmesnika = SeznamMoznosti;
      }

(* Funkcija za izpis možnosti vmesnika *)
let rec izpisi_moznosti () =
  print_endline "1) izpiši stanja avtomata";  (* Možnost za izpis avtomata *)
  print_endline "2) začni sprehod";      (* Možnost za branje niza ukazov *)
  print_endline "3) nastavi na začetno stanje";  (* Možnost za ponastavitev avtomata *)
  print_endline "4) nastavi dimenzije mreže";  (* Možnost za nastavljanje dimenzij *)
  print_string "> ";  (* Izpis poziva za vnos uporabnika *)
  match read_line () with
  | "1" -> ZamenjajVmesnik IzpisAvtomata  (* Preklop na izpis avtomata *)
  | "2" -> ZamenjajVmesnik BranjeNiza     (* Preklop na branje niza *)
  | "3" -> VrniVPrvotnoStanje             (* Ponastavitev avtomata *)
  | "4" -> ZamenjajVmesnik NastavljanjeDimenzij  (* Preklop na nastavljanje dimenzij *)
  | _ ->
      print_endline "** VNESI 1, 2, 3 ALI 4 **";  (* Opozorilo o neveljavnem vnosu *)
      izpisi_moznosti ()  (* Ponovni izpis možnosti *)

(* Funkcija za izpis avtomata *)
let izpisi_avtomat avtomat =
  let izpisi_stanje stanje =
    let prikaz = Stanje.v_niz stanje in
    let prikaz =
      if stanje = zacetno_stanje avtomat then "-> " ^ prikaz else prikaz  (* Označi začetno stanje *)
    in
    let prikaz =
      if je_sprejemno_stanje avtomat stanje then prikaz ^ " +" else prikaz  (* Označi sprejemno stanje *)
    in
    print_endline prikaz  (* Izpiši stanje *)
  in
  List.iter izpisi_stanje (seznam_stanj avtomat)  (* Iteriraj skozi vsa stanja avtomata *)

(* Funkcija za branje niza ukazov od uporabnika *)
let beri_niz _model =
  print_string "Vnesi niz ukazov (L, N, D) > ";  (* Poziv za vnos niza ukazov *)
  let str = read_line () in
  PreberiNiz str  (* Vrni sporočilo za branje niza *)

(* Funkcija za izpis rezultata po branju niza *)
let izpisi_rezultat model =
  let koncno_stanje = model.stanje_avtomata in
  Printf.printf "Končno stanje: %s\n" (Stanje.v_niz koncno_stanje);  (* Izpiši končno stanje *)
  if je_sprejemno_stanje model.avtomat koncno_stanje then
    print_endline "Uspešen prihod na cilj!"  (* Niz je bil sprejet *)
  else print_endline "Niste prišli na cilj:(";  (* Niz ni bil sprejet *)
  Printf.printf "Izhod: %s\n" (Avtomat.izhodna_funkcija model.avtomat koncno_stanje ' ')

(* Funkcija za nastavljanje dimenzij mreže *)
let nastavi_dimenzije _model =
  print_string "Vnesi maksimalno x dimenzijo: ";  (* Poziv za vnos x dimenzije *)
  let x = read_int () in
  print_string "Vnesi maksimalno y dimenzijo: ";  (* Poziv za vnos y dimenzije *)
  let y = read_int () in
  NastaviDimenzije (x, y)  (* Vrni sporočilo za nastavitev dimenzij *)

(* Funkcija za upravljanje pogleda vmesnika *)
let view model =
  match model.stanje_vmesnika with
  | SeznamMoznosti -> izpisi_moznosti ()  (* Prikaz možnosti vmesnika *)
  | IzpisAvtomata ->
      izpisi_avtomat model.avtomat;  (* Izpis avtomata *)
      ZamenjajVmesnik SeznamMoznosti  (* Vrni na seznam možnosti *)
  | BranjeNiza -> beri_niz model  (* Branje niza ukazov *)
  | RezultatPrebranegaNiza ->
      izpisi_rezultat model;  (* Izpis rezultata *)
      ZamenjajVmesnik SeznamMoznosti  (* Vrni na seznam možnosti *)
  | OpozoriloONapacnemNizu ->
      print_endline "Niz ni veljaven";  (* Opozorilo o napačnem nizu *)
      ZamenjajVmesnik SeznamMoznosti  (* Vrni na seznam možnosti *)
  | NastavljanjeDimenzij -> nastavi_dimenzije model  (* Nastavljanje dimenzij mreže *)

(* Inicializacija modela *)
let init avtomat =
  {
    avtomat;  (* Inicializiraj avtomat *)
    stanje_avtomata = zacetno_stanje avtomat;  (* Nastavi začetno stanje avtomata *)
    stanje_vmesnika = SeznamMoznosti;  (* Nastavi začetno stanje vmesnika *)
    max_x = 2;  (* Privzeta maksimalna x dimenzija *)
    max_y = 2;  (* Privzeta maksimalna y dimenzija *)
  }

(* Glavna zanka vmesnika *)
let rec loop model =
  let msg = view model in  (* Prikaži pogled in pridobi sporočilo *)
  let model' = update model msg in  (* Posodobi model glede na sporočilo *)
  loop model'  (* Ponovno zaženi zanko z novim modelom *)

(* Zagon programa *)
let () =
  let max_x = 2 in  (* Nastavi največjo x koordinato *)
  let max_y = 2 in  (* Nastavi največjo y koordinato *)
  let avtomat = Avtomat.premik_na_koordinate max_x max_y in  (* Ustvari avtomat za premikanje po mreži *)
  loop (init avtomat)  (* Zaženi glavno zanko vmesnika z inicializiranim avtomatom *)
