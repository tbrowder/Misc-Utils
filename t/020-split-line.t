use v6;
use Test;

use Misc::Utils :ALL;

plan 2;

my $s1 = "sub foo($song, $tool, @long-array, :$good) is export { say 'blah' }";

my ($line1, $line2) = split-line($s1, ')', :start-pos(0));
is $line1, 'sub foo($song, $tool, @long-array, :$good)';
is $oine2, " is export { say 'blah' }";
