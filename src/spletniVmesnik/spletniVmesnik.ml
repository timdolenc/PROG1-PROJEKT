let app =
  Vdom.simple_app
    ~init:(Model.init 500 500)
    ~view:View.view ~update:Model.update ()

let () =
  let open Js_browser in
  let run () =
    let element = match
      Js_browser.Document.get_element_by_id Js_browser.document "app" with
      | None -> Js_browser.Document.document_element Js_browser.document
      | Some el -> el
    in
    Vdom_blit.run app |> Vdom_blit.dom
    |> Js_browser.Element.append_child element
  in
  Window.set_onload window run
