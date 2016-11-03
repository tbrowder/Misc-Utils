use v6;
use Test;

use Misc::Utils :ALL;

plan 8;

# first, normalize these strings
my $str1 = '1 2  3   4    5     6      7       8        9         0';
my $str2 = ' 1 2  3   4    5     6      7       8        9         0';
my $str3 = '1 2  3   4    5     6      7       8        9         0 ';
my $str4 = ' 1 2  3   4    5     6      7       8        9         0 ';
# all should normalize to:
my $n = '1 2 3 4 5 6 7 8 9 0';

is normalize-string($str1), $n;
is normalize-string($str2), $n;
is normalize-string($str3), $n;
is normalize-string($str4), $n;

# normalize the strings in place
normalize-string-rw($str1), $n;
normalize-string-rw($str2), $n;
normalize-string-rw($str3), $n;
normalize-string-rw($str4), $n;
is $str1, $n;
is $str2, $n;
is $str3, $n;
is $str4, $n;

# now on to split-line
