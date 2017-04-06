#include "foo.hh"

// Note: virtual and override identifiers / keywords not allow in this impl section!
//   If you want to remind readers, add comments
// overriding class
std::vector<std::string> Foo::get_list_of_stuff() {
  return {"wizard", "hat"};
}
