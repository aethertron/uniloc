#!/usr/bin/python2
'''
written in python 3?
'''
from __future__ import print_function
from argparse import ArgumentDefaultsHelpFormatter, ArgumentParser
import os
from os import walk, symlink, remove, getcwd
from os.path import (join, relpath, expanduser, expandvars,
                     samefile, exists, lexists)
import sys
import logging

log = logging.getLogger()
warn = log.warn

def copy_directory_contents_to_target():
    pass

def printf(*args, **kwargs):
    print(args[0].format(*args[1:], **kwargs))


def confdir_install(targ_dir, dest_dir, force_overwrite=False, dryrun=False):
    # make absolute targ_dir and dest_dir
    targ_dir = join(getcwd(), expanduser(expandvars(targ_dir)))
    dest_dir = join(getcwd(), expanduser(expandvars(dest_dir)))
    # move to dest_dir
    for root, dirs, files in walk(targ_dir, topdown=True):
        if root != targ_dir and (('.git' in dirs) or
                                 ('.gitrepo' in files) or ('.confdir_dir' in files)):
            print("repo at {}, making one symlink".format(root))
            targ = root
            rel = '.' + relpath(targ, targ_dir)
            dest = join(dest_dir, rel)
            print("{} -> {}".format(targ, dest), end=' ')
            if not exists(dest):
                if lexists(dest):
                    if not dryrun:
                        os.remove(dest)
                    print('remove broken link and',end=' ')
                print("create")
                if not dryrun:
                    symlink(targ, dest)
            elif samefile(targ, dest):
                print("already exists")
            elif force_overwrite:
                print("force_overwrite")
                if not dryrun:
                    remove(dest)
                    symlink(targ, dest)
            else:
                print("can't create, file already exists")
                warn("can't create, file already exists")
            while dirs:
                del dirs[0]
            continue

        for filen in files:
            targ = join(root, filen)
            rel = relpath(targ, targ_dir)
            # ignore . files and emacs ~ files
            if not (rel.startswith('.') or rel.endswith('~')):
                rel = '.' + rel
                dest = join(dest_dir, rel)
                print("{} -> {}".format(targ, dest), end=' ')
                if not exists(dest):
                    if lexists(dest):
                        if not dryrun:
                            os.remove(dest)
                        print('remove broken link and',end=' ')
                    print("create")
                    if not dryrun:
                        symlink(targ, dest)
                elif samefile(targ, dest):
                    print("already exists")
                elif force_overwrite:
                    print("force_overwrite")
                    if not dryrun:
                        remove(dest)
                        symlink(targ, dest)
                else:
                    print("can't create, file already exists")
                    warn("can't create, file already exists")
    return
            

def confdir_install_cli(args):
    # * argparse
    parser = ArgumentParser(formatter_class=ArgumentDefaultsHelpFormatter)
    parser.add_argument('targ', nargs='?', default='.', help='target')
    parser.add_argument('dest', nargs='?', default='~', help='destination')
    parser.add_argument('--dryrun', action='store_true')
    parser.add_argument('-f', '--force', action='store_true')
    args = parser.parse_args(args)
    # * run
    print(args)
    confdir_install(args.targ, args.dest, args.force, args.dryrun)

if __name__ == '__main__':
    logging.basicConfig()
    confdir_install_cli(sys.argv[1:])
