#import "./storage.mligo" "Storage"


let add_admin (addr : address ) (store : Storage.t) : Storage.t =
    let () = if (store.admin <> Tezos.get_sender()) then (failwith Errors.only_admin) in
    let map_opt : address option = Map.find_opt addr store.admin in
    match map_opt with
        | Some (_) -> failwith ("Admin already existing")
        | None -> 
        let new_admin = Map.add addr (Tezos.get_sender()) store.admin in
        { store with amdin = new_admin }


let main (action : Parameter.t) ( store : Storage.t) : return =
    ([] : operation list), (match action with
        | SubmitNumber (n) -> submit_number n store
        | CheckWinner (n) -> check_winner n store)

