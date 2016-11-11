use v6;
use Test;

use Misc::Utils :ALL;

plan 2;

my $s = 30;
my $t = '0h00m30.00s';
is delta-time-hms($s), $t;

# desired date formats:                                 available formats with a Date ($d) or DateTime ($dt) object:

# default (ISO 8601 extended format):
# yyyy-mm-dd                  # :date                     $dt.new(formatter).Str
# yyyy-mm-ddThh:mm:ss.ssssssZ                             $dt.Str
# yyyy-mm-ddThh:mm:ssZ        # :round                    $dt.truncate-to('second').Str

# :basic (ISO 8601 basic format:
# yyyymmdd                    # :date                     $dt.Str ~~ ??
# yyyymmddThhmmss.ssssssZ                                 $dt.Str ~~ ??
# yyyymmddThhmmssZ            # :trunc                    $dt.truncate-to('second').Str ~~ ??

# :local
# yyyy-mm-dd                      # :date                 $d.Str
# yyyy-mm-dd-EST                  # :date :tz
# yyyymmdd                        # :date :basic
# yyyymmdd-EST                    # :date :basic :tz

# yyyy-mm-ddThh:mm:ss.ssssss+hhmm
# yyyy-mm-ddThh:mm:ss+hh          # :trunc
# yyyymmddThhmmss.ss+hh           # :basic
# yyyymmddThhmmss+hh              # :round :basic

# yyyymmddThhmmss.ss-EST          # :tz
# yyyymmddThhmmss-EST             # :round :tz

# use a known time for testing:
my $tt = '2015-12-11T13:41:10.562000-06:00'; # from rt 126948
my $dt = time-stamp(:set-time($tt));

# default format
my $exp = $tt;
is $dt, $exp;

# other formats (TBD);
{
    $dt = time-stamp(:set-time($tt), :utc);
    $exp = '2015-12-11T19:41:10.562000Z';
    is $dt, $exp;
}

{
    $dt = time-stamp(:set-time($tt), :code);
    $exp = '2015-12-11T13:41:10.562000-CST';
    is $dt, $exp;
}

{
    # round seconds to X places
    $dt = time-stamp(:set-time($tt), :round(2));
    $exp = '2015-12-11T13:41:10.56-06:00';
    is $dt, $exp;
}

done-testing;
