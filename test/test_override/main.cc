// This is a test of some c++11 features

#include "foo.hh"

#include <string>
#include <cstdlib>
#include <vector>

void print_vec(std::vector<std::string> const & vec) {
  int cnt = 0;
  for (auto elem : vec) {
    std::printf("elem #%d: %s\n", ++cnt, elem.c_str());
  }
}

int main (int argc, char ** argv) {
  std::printf("Hello World! This is %s\n", "Bill");
  print_vec({"foo", "bar", "con"});
  print_vec(Foo().get_list_of_stuff());
  return 0;
}
