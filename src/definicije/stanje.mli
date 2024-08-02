type smer_neba = S | J | V | Z

type t

val iz_komponent : smer_neba -> int -> int -> t
val iz_niza : string -> t
val v_niz : t -> string

val smer : t -> smer_neba
val koordinate : t -> int * int
