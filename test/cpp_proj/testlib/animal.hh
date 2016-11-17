#include <string>

class Animal {
public:
  virtual std::string call() = 0;

  // All animals are living beings
  bool is_living_being() {
    return true;
  }
};
