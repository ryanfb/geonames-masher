GeoNames Masher
===============

Tool for general-purpose mashing of a toponym-containing CSV against GeoNames.

Usage:

    JRUBY_OPTS="-J-Xmx8G" ./geonames-masher.rb input.csv geonames.csv input_toponym_column_1 [input_toponym_column_2 ...] > output.csv

The masher assumes your input CSV (not GeoNames CSV) has column headers, so that you can specify the columns containing toponyms as additional command line arguments.

GeoNames matches for all toponym columns will be newline-separated in an additional column on the output.

License
-------

Copyright (c) 2014 Ryan Baumann

Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the "Software"), to deal
in the Software without restriction, including without limitation the rights
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the Software is
furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in
all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
THE SOFTWARE.
