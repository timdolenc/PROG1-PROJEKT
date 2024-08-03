open Js_of_ocaml
open Js_of_ocaml_tyxml
open Model

let create_grid max_x max_y =
  let rows = List.init (max_y + 1) (fun y ->
    let cells = List.init (max_x + 1) (fun x ->
      Tyxml_js.Html.(td [txt " "])
    ) in
    Tyxml_js.Html.(tr cells)
  ) in
  Tyxml_js.Html.(table rows)

let update_grid model =
  let table = Dom_html.getElementById "grid" in
  table##.innerHTML := Js.string "";
  let grid = create_grid model.max_x model.max_y in
  Dom.appendChild table (Tyxml_js.To_dom.of_table grid)

let place_agent model =
  let cell = Dom_html.getElementById (Printf.sprintf "cell-%d-%d" model.stanje_avtomata.Stanje.x model.stanje_avtomata.Stanje.y) in
  cell##.innerHTML := Js.string "<div id='agent'>⬆️</div>"

let rotate_agent direction =
  let agent = Dom_html.getElementById "agent" in
  let rotation = match direction with
    | Stanje.S -> 0
    | Stanje.V -> 90
    | Stanje.J -> 180
    | Stanje.Z -> 270
  in
  agent##.style##.transform := Js.string (Printf.sprintf "rotate(%ddeg)" rotation)

let init_view model =
  let container = Dom_html.getElementById "gridContainer" in
  let grid = create_grid model.max_x model.max_y in
  Dom.appendChild container (Tyxml_js.To_dom.of_table grid);
  place_agent model

let handle_keydown model (e : Dom_html.keyboardEvent Js.t) =
  let code = Js.to_string e##.code in
  let new_model = match code with
    | "Space" -> Model.premakni_avtomat model 'N'
    | "ArrowLeft" -> Model.premakni_avtomat model 'L'
    | "ArrowRight" -> Model.premakni_avtomat model 'D'
    | _ -> model
  in
  if Model.je_sprejemno_stanje new_model then
    Dom_html.window##alert (Js.string "Reached goal!");
  update_grid new_model;
  place_agent new_model;
  rotate_agent new_model.stanje_avtomata.Stanje.smer
