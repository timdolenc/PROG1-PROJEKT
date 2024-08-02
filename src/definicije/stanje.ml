type smer_neba = S | J | V | Z

type t = { smer : smer_neba; x : int; y : int }

let iz_komponent smer x y = { smer; x; y }

let iz_niza oznaka =
  match String.split_on_char ',' oznaka with
  | [smer; x; y] ->
    let smer =
      match smer with
      | "S" -> S
      | "J" -> J
      | "V" -> V
      | "Z" -> Z
      | _ -> failwith "Invalid direction"
    in
    iz_komponent smer (int_of_string x) (int_of_string y)
  | _ -> failwith "Invalid format"

let v_niz { smer; x; y } =
  let smer =
    match smer with
    | S -> "S"
    | J -> "J"
    | V -> "V"
    | Z -> "Z"
  in
  Printf.sprintf "%s,%d,%d" smer x y

let smer { smer; _ } = smer
let koordinate { x; y; _ } = (x, y)
