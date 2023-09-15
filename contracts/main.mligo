#import "./storage.mligo" "Storage"
#import "./parameter.mligo" "Parameter"
#import "./types.mligo" "Types"
#import "./errors.mligo" "Errors"


type return = operation list * Storage.t

let set_admin (n : address) (store : Storage.t) : Storage.t =
    let is_admin = Map.find n store.admins in
        if is_admin then
            let map_opt : bool option = Map.find_opt n store.admins in
            match map_opt with
                | Some (_) -> failwith "Address already exist"
                | None -> 
                let new_admin = Map.add n true store.admins in
                { store with admins = new_admin }
        else
            failwith Errors.only_admin 

let remove_admin (n : address) (store : Storage.t) : Storage.t = 
    let is_admin = Map.find n store.admins in
        if is_admin then
            let map_opt : bool option = Map.find_opt n store.admins in
                match map_opt with
                | Some (_) ->  let updated_admins = Map.remove n store.admins in
            { store with admins = updated_admins }
                | None -> failwith "This address is not an admin"
               
        
        else
            failwith Errors.only_admin  


let accept_admin (store : Storage.t) : Storage.t =
    let is_find = Map.find_opt (Tezos.get_sender()) store.admins in
        match is_find with
        | Some (_) -> let updated_admins = Map.add (Tezos.get_sender()) true store.admins in
        { store with admins = updated_admins }
        | None _false -> failwith "Address not found" 


let ban_creator (n : address) (store : Storage.t) : Storage.t = 
    let is_admin = Map.find (Tezos.get_sender()) store.admins in
        if is_admin then
            let is_banned = Map.find_opt n store.blacklist in
                match is_banned with
                | Some (_) -> failwith "Creator already banned" 
                    (* Creator is banned, no need to update *)
                    store
                | None _ ->
                    let updated_blacklist = Map.add n false store.blacklist in
                    { store with blacklist = updated_blacklist }
        else
            failwith Errors.only_admin 


let participation (store :Storage.t): Storage.t = 
    let is_whitelisted = Set.mem (Tezos.get_sender()) store.whitelist in
    if is_whitelisted
        then failwith "You're already whitelisted" 
    else
        if ((Tezos.get_amount()) < 10tez ) then failwith "Not enough for participating..." 
        else 
            let updated_set = Set.add (Tezos.get_sender()) store.whitelist in
    { store with whitelist = updated_set }

let main (action : Parameter.t) ( store : Storage.t) : return =
    ([] : operation list), (match action with
        | SetAdmin (n) -> set_admin n store
        | RemoveAdmin (n) -> remove_admin n store
        | BanCreator (n) -> ban_creator n store
        | AcceptAdmin -> accept_admin store
        | Whitelist -> participation store
    
    )