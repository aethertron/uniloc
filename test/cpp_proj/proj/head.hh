#include <vector>

std::vector<int> get_vector_of_stuff() {
  std::vector<int> vec;
  for (int ii = 0; ii < 5; ++ii) {
    vec.push_back(ii);
  }
  return vec;
}
