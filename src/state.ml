open Lwd_infix

let ui_running = ref true

type focus =
  [ `Procs
  | `Output
  ]
[@@deriving eq]
let focus_var : focus Lwd.var = Lwd.var `Procs
let focus' = Lwd.get focus_var

let procs_var : Proc.t array Lwd.var = Lwd.var [||]
let procs' = Lwd.get procs_var

let selected_var = Lwd.var 0
let selected' = Lwd.get selected_var

let current' =
  Lwd.map2 procs' selected' ~f:(fun procs i ->
      if i >= 0 && i < Array.length procs then Some procs.(i) else None)
let get_current_proc () =
  let procs = Lwd.peek procs_var in
  let selected = Lwd.peek selected_var in
  if selected >= 0 && selected < Array.length procs then Some procs.(selected)
  else None

let kind' =
  let$* current = current' in
  match current with
  | None -> Lwd.return None
  | Some proc -> proc.Proc.kind_var |> Lwd.get |> Lwd.map ~f:Option.some
