#include "bear.hh"
#include <iostream>


void test_bear() {
  Bear bear;
  std::cout << "Bear says: " << bear.call() << std::endl;
  Animal* anim = &bear;
  bear
}
