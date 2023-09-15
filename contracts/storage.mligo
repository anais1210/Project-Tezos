#import "./types.mligo" "Types"
type t = {
  ultime_admin : address;
  admins : (address, bool) map;
  blacklist: (address, bool) map;
  whitelist : address set;
}