#include <string>
#include <vector>

class FooBase {
public:
  virtual std::vector<std::string> get_list_of_stuff() = 0;
};

class Foo : public FooBase {
public:
  std::vector<std::string> get_list_of_stuff() override;

};
