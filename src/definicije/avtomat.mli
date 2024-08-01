(* Definicija tipa avtomata *)
type t

(* Ustvari prazen avtomat z danim začetnim stanjem *)
val prazen_avtomat : Stanje.t -> t

(* Dodaj nesprejemno stanje avtomatu *)
val dodaj_nesprejemno_stanje : Stanje.t -> t -> t

(* Dodaj sprejemno stanje avtomatu *)
val dodaj_sprejemno_stanje : Stanje.t -> t -> t

(* Dodaj prehod med dvema stanjem z določenim vhodom *)
val dodaj_prehod : Stanje.t -> char -> Stanje.t -> t -> t

(* Prehodna funkcija, ki vrne naslednje stanje glede na trenutno stanje in vhodni znak *)
val prehodna_funkcija : t -> Stanje.t -> char -> Stanje.t option

(* Vrne začetno stanje avtomata *)
val zacetno_stanje : t -> Stanje.t

(* Vrne seznam vseh stanj avtomata *)
val seznam_stanj : t -> Stanje.t list

(* Vrne seznam vseh prehodov avtomata *)
val seznam_prehodov : t -> (Stanje.t * char * Stanje.t) list

(* Preveri, ali je dano stanje sprejemno *)
val je_sprejemno_stanje : t -> Stanje.t -> bool

(* Definira avtomat za premikanje po koordinatnem sistemu in dosego ciljne točke *)
val premik_na_koordinate : int -> int -> t

(* Funkcija za branje niza in vrnitev končnega stanja po obdelavi niza *)
val preberi_niz : t -> Stanje.t -> string -> Stanje.t option

(* Funkcija, ki generira vsa možna stanja na gridu z dimenzijami (max_x, max_y) *)
val generiraj_vsa_stanja : int -> int -> Stanje.t list

(* Funkcija, ki generira vse prehode za avtomat *)
val generiraj_vse_prehode : int -> int -> (Stanje.t * char * Stanje.t) list
