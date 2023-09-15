#import "./types.mligo" "Types"
type t = {
  admins : (address, bool) map;
  blacklist: (address, bool) map;
  whitelist : address set;
}