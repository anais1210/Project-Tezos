#import "./types.mligo" "Types"
type t = {
  ultime_admin : address;
  admins : Types.admin_list;
  blacklist: Types.blacklist;
  whitelist : address set;
}