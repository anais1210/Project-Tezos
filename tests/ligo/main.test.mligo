#import "./helpers/bootstrap.mligo" "Bootstrap"
#import "../../contracts/errors.mligo" "Contract_Errors"

let () = Test.log("[MAIN] Testing entrypoints for contract")

let test_success_setadmin = 
    let (admin, user1, _user2) = Bootstrap.bootstrap_accounts() in
    let (_addr, _t_addr, contr) = Bootstrap.originate_contract(admin) in
    let () = Test.set_source admin in
    let _ = Test.transfer_to_contract contr (SetAdmin(user1)) 0mutez in
    ()


let test_failure_setadmin_duplicateadmin = 
    let (admin, user1, _user2) = Bootstrap.bootstrap_accounts() in
    let (_addr, _t_addr, contr) = Bootstrap.originate_contract(admin) in
    let () = Test.set_source admin in
    let _ = Test.transfer_to_contract contr (SetAdmin(user1)) 0mutez in
    let test_result = Test.transfer_to_contract contr (SetAdmin(user1)) 0mutez in
    let match () = test_result with 
        | Fail (Rejected (actual, _)) -> assert(actual = (Test.eval "Address already exist"))
        | Fail (Balance_too_low _) -> failwith ("Balance is too low")
        | Fail (Other p) failwith (p)
        | Success (_) -> failwith("Test should have failed")
    ()

let test_success_bancreator = 
    let (admin, user1, _user2) = Bootstrap.bootstrap_accounts() in
    let (_addr, _t_addr, contr) = Bootstrap.originate_contract(admin) in
    let () = Test.set_source admin in
    let _ = Test.transfer_to_contract contr (BanCreator(user1)) 0mutez in


let test_fail_bancreator = 
    let (admin, user1, _user2) = Bootstrap.bootstrap_accounts() in
    let (_addr, _t_addr, contr) = Bootstrap.originate_contract(admin) in
    let () = Test.set_source admin in
    let _ = Test.transfer_to_contract contr (BanCreator(user1)) 0mutez in
    let test_result = Test.transfer_to_contract contr (BanCreator(user1)) 0mutez in
    let match () = test_result with 
        | Fail (Rejected (actual, _)) -> assert(actual = (Test.eval "Creator already banned"))
        | Fail (Balance_too_low _) -> failwith ("Balance is too low")
        | Fail (Other p) failwith (p)
        | Success (_) -> failwith("Test should have failed")
    ()

let test_fail_participation = 
    let (admin, user1, _user2) = Bootstrap.bootstrap_accounts() in
    let (_addr, _t_addr, contr) = Bootstrap.originate_contract(admin) in
    let () = Test.set_source user1 in
    let _ = Test.transfer_to_contract contr (Whitelist(user1)) 10mutez in
    let match () = test_result with 
        | Fail (Rejected (actual, _)) -> assert(actual = (Test.eval "Not enough for participating..."))
        | Fail (Balance_too_low _) -> failwith ("Balance is too low")
        | Fail (Other p) failwith (p)
        | Success (_) -> failwith("Test should have failed")

let test_success_removeadmin = 
    let (admin, user1, _user2) = Bootstrap.bootstrap_accounts() in
    let (_addr, _t_addr, contr) = Bootstrap.originate_contract(admin) in
    let () = Test.set_source admin in
    let _ = Test.transfer_to_contract contr (RemoveAdmin(user1)) 10mutez in

    
