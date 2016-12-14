#!/usr/bin/python2.7

'''
transforms csv file into an sql insert statement

solves a missing feature in the generally quite awesome sqlite3

want to go from csv file -> sql statement -> table
this tool handles the csv to sql portion
to load into table:

  cat foo.csv | csv2sql | sqlite3 dbname.db


to specify a name:
  cat foo.csv | csv2sql -t foo | sqlite3 dbname.db

to go  back to csv:
  echo "select * from foo;" | sqlite3 dbname.db  --csv

to go to sql:
  echo ".dump foo" | sqlite3 dbname.db

the sql file generated the other direction looks VERY similar to this
output. May decide to add transaction to make it atomic like the
sqlite3 generated code

Going from sql to csv isn't provide yet, but isn't terribly pressing,
usually want to go to a db.

'''
import sys
import argparse
import csv
import shutil
import tempfile
from uniloc_utils import argparse_filter_parser

csv.register_dialect('ctsv', csv.excel_tab, lineterminator='\n',
                     doublequote=False, escapechar='\\',
                     quoting=csv.QUOTE_NONNUMERIC)


def get_dialect_and_header(fin, dialect=None, delimiter=None, hasheader=None):
    '''
    #type: (file, Optional[str], Optional[str], Optional[bool]) -> (datafile, dialect, fieldnames)
    '''
    if dialect is None or hasheader is None:
        sniff = True
    else:
        sniff = False
    # determine starting dialect and whether there's a header
    if sniff:
        fold = fin
        fin = tempfile.NamedTemporaryFile()
        shutil.copyfileobj(fold, fin)
        fold.close()
        fin.seek(0)
        sample = fin.read(40)
        fin.seek(0)
        sniffer = csv.Sniffer()
        if not dialect:
            dialect = sniffer.sniff(sample)
        if hasheader is None:
            hasheader = sniffer.has_header(sample)
    else:
        if isinstance(dialect, basestring):
            dialect = csv.get_dialect(dialect)
    # override delimiter if delimiter set
    if delimiter:
        csv.register_dialect('temp', dialect, delimiter=delimiter)
        dialect = csv.get_dialect('temp')
    # get fieldnames, from header if avail, fin starts at data
    if hasheader:
        fieldnames = next(fin).strip().split(dialect.delimiter)
    else:
        cnt = len(next(fin).strip().split(dialect.delimiter))
        fieldnames = ['col_{0:0>2}'.format(colnum) for colnum in range(cnt)]
    return fin, dialect, fieldnames


def csv2sql(fin, fout, tablename, dialect=None, delimiter=None, hasheader=None):
    fin, dialect, fieldnames = get_dialect_and_header(fin, dialect, delimiter, hasheader)
    # * Fin now is at data start
    reader = csv.reader(fin, dialect=dialect)
    # * Write schema
    fout.write('CREATE TABLE {0} (\n'.format(tablename))
    for fieldname in fieldnames[:-1]:
        fout.write('{0},\n'.format(fieldname))
    if len(fieldnames):
        fout.write('{0}\n'.format(fieldnames[-1]))
    fout.write(');\n')
    # * Write data
    for row in reader:
        values = '(' + ', '.join([str(val) for val in row]) + ')'
        fout.write('INSERT INTO {0} VALUES {1};\n'.format(tablename, values))
    # * Close
    fin.close()
    fout.close()


def main(args):
    '''
    CLI parsing
    '''
    parser = argparse.ArgumentParser(parents=[argparse_filter_parser()])
    parser.add_argument('-t', '--tablename', default='tbl')
    parser.add_argument('-d', '--dialect', choices=['excel', 'excel-tab', 'ctsv'])
    parser.add_argument('-f', '--delimiter', help='delimiter field')
    parser.add_argument('--hh', '--hasheader', dest='hasheader', action='store_true')
    args = parser.parse_args(args)
    csv2sql(args.fin,
            args.fout,
            args.tablename,
            args.dialect,
            args.delimiter,
            args.hasheader)


if __name__ == '__main__':
    main(sys.argv[1:])
