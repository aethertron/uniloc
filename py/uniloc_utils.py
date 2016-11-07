'''
generic utils file
'''
from __future__ import print_function
import sys
import json

def po(obj, file=sys.stdout, prune_private=True, prune_protected=True):
    keys = dir(obj)
    if prune_private:
        keys = [key for key in keys if not key.startswith('__')]
    if prune_protected:
        keys = [key for key in keys if not key.startswith('_')]
    dictionary = {key: getattr(obj, key) for key in keys}
    json.dump(dictionary, file, indent=1, default=lambda x: str(x)[:24])

def pd(obj, file=sys.stdout):
    json.dump(dir(obj), file, indent=1, default=str)
