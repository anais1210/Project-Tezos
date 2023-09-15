#import "./storage.mligo" "Storage"
#import "./parameter.mligo" "Parameter"
#import "./types.mligo" "Types"
#import "./errors.mligo" "Errors"

type storage = {
  admins : (address, bool) map;
  blacklist: (address, bool) map;
  whitelist : address set;
}

type parameter =
   SetAdmin of address
  | RemoveAdmin of address
  | BanCreator of address
  | AcceptAdmin of address
  | Whitelist of address

type return = operation list * storage

let set_admin (n : address) (store : storage) : storage =
    let is_admin = Map.find n store.admins in
        if is_admin then
            let map_opt : bool option = Map.find_opt n store.admins in
            match map_opt with
                | Some (_) -> failwith "Address already exist"
                | None -> 
                let new_admin = Map.add n true store.admins in
                { store with admins = new_admin }
        else
            failwith "Only admins"

let remove_admin (n : address) (store : storage) : storage = 
    let is_admin = Map.find n store.admins in
        if is_admin then
            let updated_admins = Map.remove n store.admins in
            { store with admins = updated_admins }
        else
            failwith "Only admins"


let accept_admin (store : storage) : storage =
    let is_find = Map.find_opt Tezos.get_sender() store.admins in
        match is_find with
        | Some true -> let updated_admins = Map.add Tezos.sender true store.admins in
        { store with admins = updated_admins }
        | None false -> failwith "Address not found"


let ban_creator (n : address) (amount : tez) (store : storage) : storage = 
    let is_admin = Map.find Tezos.get_sender() store.admins in
        if is_admin then
            let is_banned = Map.find_opt n store.blacklist in
                match is_banned with
                | Some false -> failwith "Creator already banned"
                    (* Creator is banned, no need to update *)
                    store
                | None _ ->
                    let updated_blacklist = Map.add n false store.blacklist in
                    { store with blacklist = updated_blacklist }
        else
            failwith "Only admins"


let participation (amount : tez)(store :storage): storage = 
    if is_whitelisted = Set.mem Tezos.get_sender() whitelist
        then failwith "You're already whitelisted"
    else
        if (amount < 10tez ) then failwith "Not enough for participating..."
        else 
            let updated_set = Set.add Tezos.get_sender() whitelist in
            updated_set


let main (action : parameter) ( store : storage) : return =
    ([] : operation list), (match action with
        | SetAdmin (n) -> set_admin n store
        | RemoveAdmin (n) -> remove_admin n store
        | BanCreator (n) -> ban_creator n store
        | AcceptAdmin -> accept_admin 
        | Whitelist (n) -> participation n store
        )
