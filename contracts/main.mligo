type storage = {
  admins : (address, bool) map;
}

type parameter =
  | SetAdmin of address
  | RemoveAdmin of address
  | CheckAdmin of bool

  type return = operation list * storage


let check_admin (n: address)(store: storage) : storage = 
    let map_opt : bool option = Map.find_opt n store.admins in
    match map_opt with
        | Some (_) -> true
        | None -> failwith "Not an admin" in
    let bool_opt : address option = Map.find_opt false store.admins in 
    match bool_opt with 
        | Some (_) -> failwith "Not an admin"
        | None -> true in

    // let () = if(bool_opt.is_some && map_opt.is_none ) then (failwith "Not an admin") in



let set_admin (n : address) (store : storage) : storage =
    let map_opt : bool option = Map.find_opt n store.admins in
    match map_opt with
        | Some (_) -> failwith "Address already exist"
        | None -> 
        let new_admin = Map.add n true store.admins in
        { store with admins = new_admin }

let remove_admin (n : address) (store : storage) : storage = 
    let updated_map = Map.remove n store.admins in


let main (action : parameter) ( store : storage) : return =
    ([] : operation list), (match action with
        | SetAdmin (n) -> set_admin n store
        | RemoveAdmin (n) -> remove_admin n store
        | CheckAdmin (n) -> check_admin n store )
