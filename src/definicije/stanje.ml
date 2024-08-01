(* Definicija tipa 'smer', ki predstavlja smer neba *)
type smer = S | J | V | Z

(* Definicija tipa 't', ki predstavlja stanje avtomata *)
type t = { 
  smer_neba : smer;  (* Smer neba: S (sever), J (jug), V (vzhod), Z (zahod) *)
  x : int;           (* X koordinata stanja *)
  y : int;           (* Y koordinata stanja *)
}

(* Funkcija 'iz_komponent', ki ustvari stanje iz danih komponent *)
let iz_komponent smer_neba x y = { smer_neba; x; y }
(* Prejme smer, x in y koordinati ter ustvari zapis tipa 't' *)

(* Funkcija 'v_niz', ki pretvori stanje v niz *)
let v_niz { smer_neba; x; y } = 
  let smer_str = match smer_neba with
    | S -> "S"   (* Če je smer S, vrne niz "S" *)
    | J -> "J"   (* Če je smer J, vrne niz "J" *)
    | V -> "V"   (* Če je smer V, vrne niz "V" *)
    | Z -> "Z"   (* Če je smer Z, vrne niz "Z" *)
  in
  Printf.sprintf "(%s, %d, %d)" smer_str x y
(* Združi smer in koordinate v niz oblike "(smer, x, y)" *)

(* Funkcija 'iz_niza', ki ustvari stanje iz niza *)
let iz_niza niz = 
  try
    Scanf.sscanf niz "(%s, %d, %d)" (fun s x y ->
      let smer_neba = match s with
        | "S" -> S        (* Če je niz "S", vrne smer S *)
        | "J" -> J        (* Če je niz "J", vrne smer J *)
        | "V" -> V        (* Če je niz "V", vrne smer V *)
        | "Z" -> Z        (* Če je niz "Z", vrne smer Z *)
        | _ -> failwith "Neveljavna smer"  (* V primeru neveljavne smeri vrne napako *)
      in
      { smer_neba; x; y }
    )
  with _ -> failwith "Neveljaven niz za stanje"
(* Prejme niz in ga razčleni v komponentah, ter ustvari stanje. V primeru napake vrne izjemo *)
