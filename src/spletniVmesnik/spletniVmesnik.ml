open Js_of_ocaml
open Js_of_ocaml_tyxml
open Model
open View

let () =
  let max_x_input = Dom_html.getElementById_coerce "max_x" Dom_html.CoerceTo.input in
  let max_y_input = Dom_html.getElementById_coerce "max_y" Dom_html.CoerceTo.input in
  let create_button = Dom_html.getElementById "createGrid" in

  let create_grid _ =
    let max_x = int_of_string (Js.to_string max_x_input##.value) in
    let max_y = int_of_string (Js.to_string max_y_input##.value) in
    let model = Model.init max_x max_y in
    init_view model;
    Dom_html.window##.onkeydown := Dom_html.handler (handle_keydown model);
    Js._false
  in

  create_button##.onclick := Dom_html.handler create_grid
