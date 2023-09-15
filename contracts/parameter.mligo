type t =
   SetAdmin of address
  | RemoveAdmin of address
  | BanCreator of address
  | AcceptAdmin
  | Whitelist
