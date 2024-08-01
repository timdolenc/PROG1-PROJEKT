(* Definicija tipa 'smer' *)
type smer = S | J | V | Z
(* Smer lahko zavzame vrednosti S (sever), J (jug), V (vzhod) ali Z (zahod) *)

(* Definicija tipa 't', ki predstavlja stanje avtomata *)
type t
(* Tip 't' je abstrakten, predstavlja stanje z določeno smerjo in koordinatama *)

(* Funkcija 'iz_komponent', ki ustvari stanje iz danih komponent *)
val iz_komponent : smer -> int -> int -> t
(* Prejme smer, x in y koordinati ter vrne stanje tipa 't' *)

(* Funkcija 'v_niz', ki pretvori stanje v niz *)
val v_niz : t -> string
(* Prejme stanje tipa 't' in ga pretvori v niz oblike "(smer, x, y)" *)

(* Funkcija 'iz_niza', ki ustvari stanje iz niza *)
val iz_niza : string -> t
(* Prejme niz oblike "(smer, x, y)" in ga pretvori v stanje tipa 't' *)
