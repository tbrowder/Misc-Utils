use v6;
use Test;

use Misc::Utils :ALL;

plan 1;

my $s = 30;
my $t = '0h00m30.00s';
is delta-time-hms($s), $t;

# date formats:

# default (ISO 8601 extended format):
# yyyy-mm-dd               # :date
# yyyy-mm-ddThh:mm:ss.ssZ
# yyyy-mm-ddThh:mm:ssZ     # :round

# :basic (ISO 8601 basic format:
# yyyymm-dd                # :date
# yyyymmddThhmmss.ssZ
# yyyymmddThhmmssZ         # :round

# :local
# yyyy-mm-dd                # :date
# yyyy-mm-dd-EST            # :date :tz
# yyyymmdd                  # :date :basic
# yyyymmdd-EST              # :date :basic :tz

# yyyy-mm-ddThh:mm:ss.ss+hh
# yyyy-mm-ddThh:mm:ss+hh    # :round
# yyyymmddThhmmss.ss+hh     # :basic
# yyyymmddThhmmss+hh        # :round :basic

# yyyymmddThhmmss.ss-EST   # :tz
# yyyymmddThhmmss-EST      # :round :tz


