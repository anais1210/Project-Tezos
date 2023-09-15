type t =
   SetAdmin of address
  | RemoveAdmin of address
  | BanCreator of address
  | AcceptAdmin of address
  | Whitelist of address
