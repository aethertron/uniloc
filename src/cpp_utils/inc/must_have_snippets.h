
// Timestamp, integral seconds
// - Boost doesn't provide an easy-to-use alternative atm
#include <iostream>
#include <ctime>
#include <string>

std::string timestamp_iso8601() {
  time_t now;
  time(&now);
  char buf[sizeof "2017-01-01T00:00:00Z"];
  std::strftime(buf, sizeof buf, "%FT%TZ", gmtime(&now));
  return buf;
}

std::string timestamp() {
  time_t now;
  time(&now);
  char buf[sizeof "2017-01-01 00:00:00"];
  std::strftime(buf, sizeof buf, "%FT%T", gmtime(&now));
  return buf;
}


// Timestamp using GNU utils

#include <sys/time.h>
#include <stdio.h>		// snprintf
#include <memory>

std::string timestamp_precise(std::shared_ptr<timeval>tv=nullptr) {
  if (!tv) {
    tv.reset(new timeval);
    gettimeofday(tv.get(),nullptr);
  }

  time_t nowtime;
  struct tm *nowtm;
  char tmbuf[64], buf[64];

  nowtime = tv->tv_sec;
  nowtm = localtime(&nowtime);
  strftime(tmbuf, sizeof tmbuf, "%F %T", nowtm);
  snprintf(buf,sizeof buf,"%s.%06d",tmbuf, (int)tv->tv_usec);
  return buf;
}
