#include "animal.hh"
#include <string>

enum BearType { BEAR_BROWN, BEAR_BLACK, OSO_FUERTE};


class Bear : public Animal {
public:
  std::string call() {
    return "grrrrr!";
  }

  double attack () {
    return 42.0;
  }

  BearType bear_type;

};
