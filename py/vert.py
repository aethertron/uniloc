#!/usr/bin/python2
from __future__ import print_function
import uniloc_utils
#
import argparse
import sys


def main(args):
    parser = argparse.ArgumentParser(parents=[uniloc_utils.argparse_filter_parser()])
    parser.add_argument("-s")
    args = parser.parse_args(args)
    vals = args.fin.read()
    if ',' in vals:
        sep = ','
    elif ':' in vals:
        sep = ':'
    else:
        sep = None
    vals = vals.split(sep)
    for val in vals:
        print(val.strip(), file=args.fout)

if __name__ == '__main__':
    main(sys.argv[1:])
