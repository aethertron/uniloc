#include "bear.hh"
#include "head.hh"

#include <iostream>
#include <string>
#include <sstream>
#include <vector>

std::string get_string() {
  std::ostringstream ss;
  ss << "Test #" << 1;
  return ss.str();
}

int main(int argc, char **argv) {
  std::cout << "Hello world!" << std::endl;
  std::string str = get_string();
  std::cout << "String: " << str << std::endl;
  std::vector<int> vec = get_vector_of_stuff();

  Bear bear;

  std::cout << "Bear says: " << bear.call() << std::endl;

  std::cout << "Is Living Being: " << bear.is_living_being() << std::endl;



  switch(bear.bear_type){
  case BearType::BEAR_BLACK:
    break;
  case BearType::OSO_FUERTE:
    break;
  case BearType::BEAR_BROWN:
    break;
  default:
    break;
  }
  
  return 0;
}
