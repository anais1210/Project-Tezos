type storage = {
  admins : (address, bool) map;
}

type parameter =
  | SetAdmin of address

  type return = operation list * storage

let set_admin (n : address) (store : storage) : storage =
    // let () = if (Tezos.get_sender() = store.admin) then (failwith Errors.admin_can_not_play) in
    // let () = if (n < 1n) || (n > 100n) then (failwith Errors.number_out_of_bounds) in
    let map_opt : bool option = Map.find_opt n store.admins in
    match map_opt with
        | Some (_) -> failwith "Address already exist"
        | None -> 
        let new_admin = Map.add n true store.admins in
        { store with admins = new_admin }


let main (action : parameter) ( store : storage) : return =
    ([] : operation list), (match action with
        | SetAdmin (n) -> set_admin n store)
