use v6;
use Test;

use Misc::Utils :ALL;

plan 8;

# 10 five-letter words
my @p1;
@p1[$_] = 'words' for 0..^10;
my $f = '.tmp-030';

# test againts some strings
my ($fh, $p1);
{
    $fh = open $f, :w;
    write-paragraph($fh, @p1, :max-line-length(30));
    $p1 =
    "words words words words words\n" ~
    "words words words words words\n";

    is slurp($f), $p1;
}

{
    $fh = open $f, :w;
    write-paragraph($fh, @p1, :max-line-length(24));
    $p1 =
    "words words words words\n" ~
    "words words words words\n" ~
    "words words\n";

    is slurp($f), $p1;
}

{
    $fh = open $f, :w;
    write-paragraph($fh, @p1, :max-line-length(20));
    $p1 =
    "words words words\n" ~
    "words words words\n" ~
    "words words words\n" ~
    "words\n";

    is slurp($f), $p1;
}

{
    $fh = open $f, :w;
    write-paragraph($fh, @p1, :max-line-length(38), :pre-text('topic:  '));
    $p1 =
    "topic:  words words words words words\n" ~
    "        words words words words words\n";

    is slurp($f), $p1;
}

{
    $fh = open $f, :w;
    write-paragraph($fh, @p1, :max-line-length(30), :first-line-indent(3));
    $p1 =
    "   words words words words\n" ~
    "words words words words words\n" ~
    "words\n";

    is slurp($f), $p1;
}

{
    $fh = open $f, :w;
    write-paragraph($fh, @p1, :max-line-length(33), :first-line-indent(3),
		    :para-indent(5));
    $p1 =
    "   words words words words words\n" ~
    "     words words words words\n" ~
    "     words\n";

    is slurp($f), $p1;
}

{
    $fh = open $f, :w;
    write-paragraph($fh, @p1, :max-line-length(33), :first-line-indent(5),
		    :para-indent(3));
    $p1 =
    "     words words words words\n" ~
    "   words words words words words\n" ~
    "   words\n";

    is slurp($f), $p1;
}

{
    $fh = open $f, :w;
    write-paragraph($fh, @p1, :pre-text('text: '), :max-line-length(39),
		    :first-line-indent(5), :para-indent(3));
    $p1 =
    "text:      words words words words\n" ~
    "         words words words words words\n" ~
    "         words\n";

    is slurp($f), $p1;
}

unlink $f;
