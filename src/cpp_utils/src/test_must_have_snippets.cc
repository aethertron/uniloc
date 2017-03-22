#include "../inc/must_have_snippets.h"

#include <iostream>
#include <vector>
#include <numeric>
#include <unistd.h>
#include <string>
#include <sys/time.h>
#include <sys/select.h>

#include <stdio.h>		// snprintf
#include <cstdio>
#include <memory>


// timestamp test
int timestamp_test() {
  int const max_count = 40;
  int const sleep_usec = 100000;

  std::vector<int> counter(max_count);
  std::iota(counter.begin(), counter.end(), 1);
  std::string ts;

  timeval tv;
  timeval diff_tv;

  for (auto ii : counter) {

    ts = timestamp_precise();
    std::cout << ii << "  " << ts << std::endl;
    usleep(sleep_usec);
  }
  return 0;
}

int main() {
  int const max_count = 40;
  int const sleep_us = 1000000;
  timeval sleep_tv;
  sleep_tv.tv_sec = 0;
  sleep_tv.tv_usec = sleep_us;


  std::vector<int> counter(max_count);
  std::iota(counter.begin(), counter.end(), 1);

  // create array of shared ptrs
  std::vector<std::shared_ptr<timeval> > tvs(max_count);
  for (auto ii : counter) {
    tvs[ii - 1].reset(new timeval);
  }

  std::vector<std::string> tvstrs(max_count);

  auto tv = std::make_shared<timeval>();

  timeval tv_ref;
  gettimeofday(&tv_ref, nullptr);
  std::vector<timeval> tv_diffs(max_count);

  for (auto ii : counter) {
    gettimeofday(tv.get(),nullptr);
    *tvs[ii - 1] = *tv;
    usleep(sleep_us);
    // select(0, NULL, NULL, NULL, &sleep_tv);
    // sleep_tv.tv_sec = 0;
    // sleep_tv.tv_usec = sleep_us;
  }

  for (auto ii : counter) {
    timersub(tvs[ii - 1].get(), &tv_ref, &tv_diffs[ii - 1]);
    tvstrs[ii - 1] = timestamp_precise(tvs[ii - 1]);
    std::printf("%02d int: %02d  frac: %06d %s\n", ii,
		tv_diffs[ii - 1].tv_sec, tv_diffs[ii - 1].tv_usec,
		tvstrs[ii - 1].c_str());
  }
  
  return 0;
}
