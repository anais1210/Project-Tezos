#import "../../../contracts/main.mligo" "Contract"
#import "../../../contracts/parameter.mligo" "Parameter"
#import "../../../contracts/storage.mligo" "Storage"
#import "../../../contracts/types.mligo" "Types"

type originated = (
    address * 
   (Parameter.t, Storage.t) typed_address *
    Parameter.t contract 
)

let bootstrap_accounts () = 
    let () = Test.reset_state 5n ([] : tez list ) in
    let accounts = 
        Test.nth_bootstrap_account 1,
        Test.nth_bootstrap_account 2,
        Test.nth_bootstrap_account 3
    in
    accounts


let initial_storage (admin:address )= {
    ultime_admin = admin;
    admins = (Map.empty : Types.admin_list);
    blacklist = (Map.empty : Types.blacklist);
    whitelist = (Set.empty: address set);
}
let initial_balance = 0mutez

let originate_contract (admin : address) : originated = 
    let _init_storage = (Test.eval (initial_storage(admin))) in
    let (_admin, _user1, _user2) = bootstrap_accounts() in
    let (typed_address, _code , _nonce) = Test.originate Contract.main (initial_storage(admin)) initial_balance in
    let actual_storage = Test.get_storage typed_address in
    let () = assert(initial_storage(admin) = actual_storage) in
    let contr = Test.to_contract typed_address in
    let addr = Tezos.address contr in
    (addr, typed_address, contr)
    
