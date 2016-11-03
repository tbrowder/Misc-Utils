use v6;
use Test;

use Misc::Utils :ALL;

plan 18;

# input: 10 five-letter words in a string
my $para = ' words';
for 1..^10 -> $i {
    my $s = ' ' x $i;
    $s ~= 'words';
    $para ~= $s;
}
$para ~= ' ';
say "input para words = '$para'";

my $f = '.tmp-030';

# test against some strings
my ($fh, $p1);

#============================================================================================
# the file output version

# test 1
{
    $fh = open $f, :w;
    write-paragraph($fh, $para, :max-line-length(30));
    $p1 =
    "words words words words words\n" ~
    "words words words words words\n";

    is slurp($f), $p1;
}

# test 2
{
    $fh = open $f, :w;
    write-paragraph($fh, $para, :max-line-length(24));
    $p1 =
    "words words words words\n" ~
    "words words words words\n" ~
    "words words\n";

    is slurp($f), $p1;
}


# test 3
{
    $fh = open $f, :w;
    write-paragraph($fh, $para, :max-line-length(20));
    $p1 =
    "words words words\n" ~
    "words words words\n" ~
    "words words words\n" ~
    "words\n";

    is slurp($f), $p1;
}

# test 4
{
    $fh = open $f, :w;
    write-paragraph($fh, $para, :max-line-length(38), :pre-text('topic:  '));
    $p1 =
    "topic:  words words words words words\n" ~
    "        words words words words words\n";

    is slurp($f), $p1;
}

# test 5
{
    $fh = open $f, :w;
    write-paragraph($fh, $para, :max-line-length(30), :first-line-indent(3));
    $p1 =
    "   words words words words\n" ~
    "words words words words words\n" ~
    "words\n";

    is slurp($f), $p1;
}

# test 6
{
    $fh = open $f, :w;
    write-paragraph($fh, $para, :max-line-length(33), :first-line-indent(3),
		    :para-indent(5));
    $p1 =
    "   words words words words words\n" ~
    "     words words words words\n" ~
    "     words\n";

    is slurp($f), $p1;
}

# test 7
{
    $fh = open $f, :w;
    write-paragraph($fh, $para, :max-line-length(33), :first-line-indent(5),
		    :para-indent(3));
    $p1 =
    "     words words words words\n" ~
    "   words words words words words\n" ~
    "   words\n";

    is slurp($f), $p1;
}

# test 8
{
    $fh = open $f, :w;
    write-paragraph($fh, $para, :pre-text('text: '), :max-line-length(39),
		    :first-line-indent(5), :para-indent(3));
    $p1 =
    "text:      words words words words\n" ~
    "         words words words words words\n" ~
    "         words\n";

    is slurp($f), $p1;
}

#============================================================================================
# the string output version

# test 9 (compare with 1)
{
    my $pin = $para;
    write-paragraph($pin, :max-line-length(30));
    $p1 =
    "words words words words words\n" ~
    "words words words words words\n";

    is $pin, $p1;
}

# test 10 (compare with 2)
{
    my $pin = $para;
    write-paragraph($pin, :max-line-length(24));
    $p1 =
    "words words words words\n" ~
    "words words words words\n" ~
    "words words\n";

    is $pin, $p1;
}


# test 11 (compare with 3)
{
    my $pin = $para;
    write-paragraph($pin, :max-line-length(20));
    $p1 =
    "words words words\n" ~
    "words words words\n" ~
    "words words words\n" ~
    "words\n";

    is $pin, $p1;
}

# test 12 (compare with 4)
{
    my $pin = $para;
    write-paragraph($pin, :max-line-length(38), :pre-text('topic:  '));
    $p1 =
    "topic:  words words words words words\n" ~
    "        words words words words words\n";

    is $pin, $p1;
}

# test 13 (compare with 5)
{
    my $pin = $para;
    write-paragraph($pin, :max-line-length(30), :first-line-indent(3));
    $p1 =
    "   words words words words\n" ~
    "words words words words words\n" ~
    "words\n";

    is $pin, $p1;
}

# test 14 (compare with 6)
{
    my $pin = $para;
    write-paragraph($pin, :max-line-length(33), :first-line-indent(3),
		    :para-indent(5));
    $p1 =
    "   words words words words words\n" ~
    "     words words words words\n" ~
    "     words\n";

    is $pin, $p1;
}

# test 15 (compare with 7)
{
    my $pin = $para;
    write-paragraph($pin, :max-line-length(33), :first-line-indent(5),
		    :para-indent(3));
    $p1 =
    "     words words words words\n" ~
    "   words words words words words\n" ~
    "   words\n";

    is $pin, $p1;
}

# test 16 (compare with 3)
{
    my $pin = $para;
    write-paragraph($pin, :pre-text('text: '), :max-line-length(39),
		    :first-line-indent(5), :para-indent(3));
    $p1 =
    "text:      words words words words\n" ~
    "         words words words words words\n" ~
    "         words\n";

    is $pin, $p1;
}

# test some corner cases
#                     1         2         3
my $para2 = '023456789012345678901234567890';
# test 17
{
    $fh = open $f, :w;
    write-paragraph($fh, $para2, :max-line-length(30));
    $p1 =
    "023456789012345678901234567890\n\n";

    is slurp($f), $p1, "line reported too long";
}
# test 18 (compare with 17)
{
    my $pin = $para2;
    write-paragraph($pin, :max-line-length(30));
    $p1 =
    "023456789012345678901234567890\n\n";

    is $pin, $p1, "line reported too long";
}

=begin pod
=end pod

#============================================================================================
unlink $f;
