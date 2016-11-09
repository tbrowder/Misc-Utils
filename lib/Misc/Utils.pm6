unit module Misc::Utils:auth<github:tbrowder>;

# file:  ALL-SUBS.md
# title: Subroutines Exported by the `:ALL` Tag

# export a debug var for users
our $DEBUG is export(:DEBUG) = False;
BEGIN {
    if %*ENV<MISC_UTILS_DEBUG> {
	$DEBUG = True;
    }
    else {
	$DEBUG = False;
    }
}

# define tokens for common regexes
my token binary is export(:token-binary)                   { ^ <[01]>+ $ }
my token decimal is export(:token-decimal)                 { ^ \d+ $ }              # actually an int
my token hexadecimal is export(:token-hecadecimal)         { :i ^ <[a..f\d]>+ $ }   # multiple chars
my token hexadecimalchar is export(:token-hexadecimalchar) { :i ^ <[a..f\d]> $ }    # single char

#------------------------------------------------------------------------------
# Subroutine count-substrs
# Purpose : Count instances of a substring in a string
# Params  : String, Substring
# Returns : Number of substrings found
sub count-substrs(Str:D $ip, Str:D $substr) returns UInt is export(:count-substrs) {
    my $nsubstrs = 0;
    my $idx = index $ip, $substr;
    while $idx.defined {
	++$nsubstrs;
	$idx = index $ip, $substr, $idx+1;
    }

    return $nsubstrs;

} # count-substrs

#------------------------------------------------------------------------------
# Subroutine hexchar2bin
# Purpose : Convert a single hexadecimal character to a binary string
# Params  : Hexadecimal character
# Returns : Binary string
sub hexchar2bin(Str:D $hexchar where &hexadecimalchar) is export(:hexchar2bin) {
    my $decimal = hexchar2dec($hexchar);
    return sprintf "%04b", $decimal;
} # hexchar2bin

#------------------------------------------------------------------------------
# Subroutine hexchar2dec
# Purpose : Convert a single hexadecimal character to a decimal number
# Params  : Hexadecimal character
# Returns : Decimal number
sub hexchar2dec(Str:D $hexchar is copy where &hexadecimalchar) returns UInt is export(:hexchar2dec) {
    my UInt $num;

    $hexchar .= lc;
    if $hexchar ~~ /^ \d+ $/ {
	# 0..9
	$num = +$hexchar;
    }
    elsif $hexchar eq 'a' {
	$num = 10;
    }
    elsif $hexchar eq 'b' {
	$num = 11;
    }
    elsif $hexchar eq 'c' {
	$num = 12;
    }
    elsif $hexchar eq 'd' {
	$num = 13;
    }
    elsif $hexchar eq 'e' {
	$num = 14;
    }
    elsif $hexchar eq 'f' {
	$num = 15;
    }
    else {
	fail "FATAL: \$hexchar '$hexchar' is unknown";
    }

    return $num;

} # hexchar2dec

#------------------------------------------------------------------------------
# Subroutine hex2dec
# Purpose : Convert a positive hexadecimal number (string) to a decimal number
# Params  : Hexadecimal number (string), desired length (optional)
# Returns : Decimal number (or string)
sub hex2dec(Str:D $hex where &hexadecimal, UInt $len = 0) returns Cool is export(:hex2dec) {
    my @chars = $hex.comb;
    @chars .= reverse;
    my UInt $decimal = 0;
    my $power = 0;
    for @chars -> $c {
        $decimal += hexchar2dec($c) * 16 ** $power;
	++$power;
    }
    if $len && $len > $decimal.chars {
	return sprintf "%0*d", $len, $decimal;
    }
    return $decimal;
} # hex2dec

#------------------------------------------------------------------------------
# Subroutine hex2bin
# Purpose : Convert a positive hexadecimal number (string) to a binary string
# Params  : Hexadecimal number (string), desired length (optional)
# Returns : Binary number (string)
sub hex2bin(Str:D $hex where &hexadecimal, UInt $len = 0) returns Str is export(:hex2bin) {
    my @chars = $hex.comb;
    my $bin = '';

    for @chars -> $c {
        $bin ~= hexchar2bin($c);
    }

    if $len && $len > $bin.chars {
	my $s = '0' x ($len - $bin.chars);
	$bin = $s ~ $bin;
    }

    return $bin;

} # hex2bin

#------------------------------------------------------------------------------
# Subroutine dec2hex
# Purpose : Convert a positive integer to a hexadecimal number (string)
# Params  : Positive decimal number, desired length (optional)
# Returns : Hexadecimal number (string)
sub dec2hex(UInt $dec, UInt $len = 0) returns Str is export(:dec2hex) {
    my $hex = sprintf "%x", $dec;
    if $len && $len > $hex.chars {
	my $s = '0' x ($len - $hex.chars);
	$hex = $s ~ $hex;
    }
    return $hex;
} # dec2hex

#------------------------------------------------------------------------------
# Subroutine dec2bin
# Purpose : Convert a positive integer to a binary number (string)
# Params  : Positive decimal number, desired length (optional)
# Returns : Binary number (string)
sub dec2bin(UInt $dec, UInt $len = 0) returns Str is export(:dec2bin) {
    my $bin = sprintf "%b", $dec;
    if $len && $len > $bin.chars {
	my $s = '0' x ($len - $bin.chars);
	$bin = $s ~ $bin;
    }
    return $bin;
} # dec2bin

#------------------------------------------------------------------------------
# Subroutine bin2dec
# Purpose : Convert a binary number (string) to a decimal number
# Params  : Binary number (string), desired length (optional)
# Returns : Decimal number (or string)
sub bin2dec(Str:D $bin where &binary, UInt $len = 0) returns Cool is export(:bin2dec) {
    my @bits = $bin.comb;
    @bits .= reverse;
    my $decimal = 0;
    my $power = 0;
    for @bits -> $bit {
        $decimal += $bit * 2 ** $power;
	++$power;
    }
    if $len && $len > $decimal.chars {
	my $s = '0' x ($len - $decimal.chars);
	$decimal = $s ~ $decimal;
    }
    return $decimal;
} # bin2dec

#------------------------------------------------------------------------------
# Subroutine bin2hex
# Purpose : Convert a binary number (string) to a hexadecimal number (string)
# Params  : Binary number (string), desired length (optional)
# Returns : Hexadecimal number (string)
sub bin2hex(Str:D $bin where &binary, UInt $len = 0) returns Str is export(:bin2hex) {
    # take the easy way out
    my $dec = bin2dec($bin);
    my $hex = dec2hex($dec, $len);
    return $hex;
} # bin2hex

#------------------------------------------------------------------------------
# Subroutine strip-comment
# Purpose : Strip comments from an input text line
# Params  : String of text, comment char ('#' is default)
# Returns : String of text with any comment stripped off. Note that char will trigger the strip even though it is escaped or included in quotes.
sub strip-comment(Str $line is copy, Str $comment-char = '#') returns Str is export(:strip-comment) {
    my $idx = index $line, $comment-char;
    if $idx.defined {
	return substr $line, 0, $idx;
    }
    return $line;
} # strip-comment

#------------------------------------------------------------------------------
# Subroutine delta-time-hms
# Purpose : Convert time in seconds to hms format
# Params  : Time in seconds
# Returns : Time in hms format, e.g, "3h02m02.65s"
sub delta-time-hms($Time) returns Str is export(:delta-time-hms) {
    #say "DEBUG exit: Time: $Time";
    #exit;

    my Num $time = $Time.Num;

    my Int $sec-per-min = 60;
    my Int $min-per-hr  = 60;
    my Int $sec-per-hr  = $sec-per-min * $min-per-hr;

    my Int $hr  = ($time/$sec-per-hr).Int;
    my Num $sec = $time - ($sec-per-hr * $hr);
    my Int $min = ($sec/$sec-per-min).Int;

    $sec = $sec - ($sec-per-min * $min);

    return sprintf "%dh%02dm%05.2fs", $hr, $min, $sec;
} # delta-time-hms


#------------------------------------------------------------------------------
# Subroutine read-sys-time
# Purpose : An internal helper function that is not exported
# Params  : Name of a file that contains output from the GNU 'time' command
# Returns : A list or a single value depending upon the presence of the ':$uts' variable
sub read-sys-time($time-file, :$uts) {
    say "DEBUG: time-file '$time-file'" if $DEBUG;
    my ($Rts, $Uts, $Sts);
    for $time-file.IO.lines -> $line {
	say "DEBUG: line: $line" if $DEBUG;

	my $typ = $line.words[0];
	my $sec = $line.words[1];
	given $typ {
            when $_ ~~ /real/ {
		$Rts = sprintf "%.3f", $sec;
		say "DEBUG: rts: $Rts" if $DEBUG;
            }
            when $_ ~~ /user/ {
		$Uts = sprintf "%.3f", $sec;
		say "DEBUG: uts: $Uts" if $DEBUG;
            }
            when $_ ~~ /sys/ {
		$Sts = sprintf "%.3f", $sec;
		say "DEBUG: sts: $Sts" if $DEBUG;
            }
	}
    }

    # convert each to hms
    my $rt = delta-time-hms($Rts);
    my $ut = delta-time-hms($Uts);
    my $st = delta-time-hms($Sts);

    # back to the caller
    return $Uts if $uts;
    return $Rts, $rt,
           $Uts, $ut,
           $Sts, $st;
} # read-sys-time


#------------------------------------------------------------------------------
# Subroutine time-command
# Purpose : Collect the process times for a system command
# Params  : The command as a string, optionally a parameter to ask for user time only
# Returns : A list of times or user time only
sub time-command(Str:D $cmd, :$uts) is export(:time-command) {
    # runs the input cmd using the system 'time' function and returns
    # the process times shown below

    use File::Temp;
    # get a temp file (File::Find)
    my ($filename, $filehandle);
    if !$DEBUG {
	($filename, $filehandle) = tempfile;
    }
    else {
	($filename, $filehandle) = tempfile(:tempdir('./tmp'), :!unlink);
    }
    my $TCMD = "time -p -o $filename";
    my $proc = shell "$TCMD $cmd"; #, :out;

    if $uts {
        return read-sys-time(:uts(True), $filename);
    }
    else {
        return read-sys-time($filename);
    }

} # time-command

#------------------------------------------------------------------------------
# Subroutine commify
# Purpose : Add commas to a mumber to separate multiples of a thousand
# Params  : An integer or number with a decimal fraction
# Returns : The input number with commas added, e.g., 1234.56 => 1,234.56
sub commify($num) is export(:commify) {
    # translated from Perl Cookbook, 2e, Recipe 2.16
    say "DEBUG: input '$num'" if $DEBUG;
    my $text = $num.flip;
    say "DEBUG: input flipped '$text'" if $DEBUG;
    #$text =~ s:g/ (\d\d\d)(?=\d)(?!\d*\.)/$0,/; # how to do in Perl 6?

    $text ~~ s:g/ (\d\d\d) <?before \d> <!before \d*\.> /$0,/;

    # don't forget to flip back to the original
    $text .= flip;
    say "DEBUG: commified output '$text'" if $DEBUG;

    return $text;

} # commify

#------------------------------------------------------------------------------
# Subroutine write-paragraph
# Purpose : Wrap a list of words into a paragraph with a maximum line width (default: 78) and updates the input list with the results
# Params  : List of words, max line length, paragraph indent, first line indent, pre-text
# Returns : List of formatted paragraph lines
multi write-paragraph(@text,
		      UInt :$max-line-length = 78,
                      UInt :$para-indent = 0,
		      UInt :$first-line-indent = 0,
                      Str :$pre-text = '') returns List is export(:write-paragraph) {

    #say "DEBUG: text = '@text'" if $DEBUG;
    # calculate the various effective indents and any pre-text effects
    # get the effective first-line indent
    my $findent = $first-line-indent ?? $first-line-indent !! $para-indent;
    # get the effective paragraph indent
    my $pindent = $pre-text.chars + $para-indent;

    my $findent-spaces = ' ' x $findent;
    # ready to take care of the first line
    my $first-line = $pre-text ~ $findent-spaces;
    my $line = $first-line;

    # now do a length check
    {
        my $nc = $line.chars;
        if $nc > $max-line-length {
            say "FATAL:  Line length too long ($nc), must be <= \$max-line-length ($max-line-length)";
            say "line:   '$line'";
            die "length: $nc";
        }
    }

    # get all the words
    my @words = (join ' ', @text).words;

    my @para = ();
    my $first-word = True;
    loop {
        if !@words.elems {
            @para.push: $line if $line;
            #@para.push: $line;
            last;
        }

        my $next = @words[0];
        $next = ' ' ~ $next if !$first-word;
        $first-word = False;

        # do a length check
	{
            my $nc = $next.chars;
            if $nc > $max-line-length {
                say "FATAL:  Line length too long ($nc), must be <= \$max-line-length ($max-line-length)";
                say "line:   '$next'";
                die "length: $nc";
            }
        }

        if $next.chars + $line.chars <= $max-line-length {
            $line ~= $next;
            shift @words;
            next;
        }

        # we're done with this line
        @para.push: $line if $line;
        #@para.push: $line;
        last;
    }

    # and remaining lines
    my $pindent-spaces = ' ' x $pindent;
    $line = $pindent-spaces;
    $first-word = True;
    loop {
        if !@words.elems {
            @para.push: $line if $line;
            #@para.push: $line;
            last;
        }

        my $next = @words[0];
        $next = ' ' ~ $next if !$first-word;
        $first-word = False;

        # do a length check
	{
            my $nc = $next.chars;
            if $nc > $max-line-length {
                say "FATAL:  Line length too long ($nc), must be <= \$max-line-length ($max-line-length)";
                say "line:   '$next'";
                die "length: $nc";
            }
        }

        if $next.chars + $line.chars <= $max-line-length {
            $line ~= $next;
            shift @words;
            next;
        }

        # we're done with this line
        @para.push: $line if $line;
        #@para.push: $line;

        last if !@words.elems;

        # replenish the line
        $line = $pindent-spaces;
        $first-word = True;
    }

    return @para;

} # write-paragraph

#------------------------------------------------------------------------------
# Subroutine write-paragraph
# Purpose : Wrap a list of words into a paragraph with a maximum line width (default: 78) and print it to the input file handle
# Params  : Output file handle, list of words, max line length, paragraph indent, first line indent, pre-text
# Returns : Nothing
multi write-paragraph($fh, @text,
                      UInt :$max-line-length = 78,
                      UInt :$para-indent = 0,
                      UInt :$first-line-indent = 0,
                      Str :$pre-text = '') is export(:write-paragraph2) {

    # do the mods for the para text
    my @para = write-paragraph(@text, :$max-line-length, :$para-indent, :$first-line-indent, :$pre-text);

    # write to the open file handle
    $fh.say($_) for @para;
}

#------------------------------------------------------------------------------
# Subroutine normalize-string
# Purpose : Trim a string and collapse multiple whitespace characters to single ones
# Params  : The string to be normalized
# Returns : The normalized string
sub normalize-string(Str:D $str is copy) returns Str is export(:normalize-string) {
    $str .= trim;
    $str ~~ s:g/ \s ** 2..*/ /;
    return $str;
} # normalize-string

=begin pod
#------------------------------------------------------------------------------
# Subroutine normalize-string-rw
# Purpose : Trim a string and collapse multiple whitespace characters to single ones
# Params  : The string to be normalized
# Returns : Nothing, the input string is normalized in-place
sub normalize-string-rw(Str:D $str is rw) is export(:normalize-string-rw) {
    $str .= trim;
    $str ~~ s:g/ \s ** 2..*/ /;
} # normalize-string-rw
=end pod

#------------------------------------------------------------------------------
# Subroutine split-line
# Purpose : Split a string into two pieces
# Params  : String to be split, the split character, maximum length, a starting position for the search, search direction
# Returns : The two parts of the split string; the second part will be empty string if the input string is not too long
sub split-line(Str:D $line is copy, Str:D $brk, UInt :$max-line-length = 0,
               UInt :$start-pos = 0, Bool :$rindex = False) returns List is export(:split-line) {
    my $line2 = '';
    return ($line, $line2) if $max-line-length && $line.chars <= $max-line-length;

    my $idx;
    if $rindex {
        my $spos = max $start-pos, $max-line-length;
        $idx = $spos ?? rindex $line, $brk, $spos !! rindex $line, $brk;
    }
    else {
        $idx = $start-pos ?? index $line, $brk, $start-pos !! index $line, $brk;
    }
    if $idx.defined {
        $line2 = substr $line, $idx+1;
        $line  = substr $line, 0, $idx+1;

        #$line  .= trim-trailing;
        #$line2 .= trim;
    }
    return ($line, $line2);

} # split-line

#------------------------------------------------------------------------------
# Subroutine split-line-rw
# Purpose : Split a string into two pieces
# Params  : String to be split, the split character, maximum length, a starting position for the search, search direction
# Returns : The part of the input string past the break character, or an empty string (the input string is modified in-place if it is too long)
sub split-line-rw(Str:D $line is rw, Str:D $brk, UInt :$max-line-length = 0,
                  UInt :$start-pos = 0, Bool :$rindex = False) returns Str is export(:split-line-rw) {
    my $line2 = '';
    return $line2 if $max-line-length && $line.chars <= $max-line-length;

    my $idx;
    if $rindex {
        my $spos = max $start-pos, $max-line-length;
        $idx = $spos ?? rindex $line, $brk, $spos !! rindex $line, $brk;
    }
    else {
        $idx = $start-pos ?? index $line, $brk, $start-pos !! index $line, $brk;
    }
    if $idx.defined {
        $line2 = substr $line, $idx+1;
        $line  = substr $line, 0, $idx+1;

        #$line  .= trim-trailing;
        #$line2 .= trim;
    }
    return $line2;

} # split-line-rw

sub time-zone-offset-us(Str $tz, :$basic) {
    # given a three-character string describing a US time zone,
    # return the ISO 8601 extended (or basic) offset
    my $offset = 'Z'; # UTC
    given $tz {
        # standard
        when /:i ast / { $offset = '-04:00' }
        when /:i est / { $offset = '-05:00' }
        when /:i cst / { $offset = '-06:00' }
        when /:i mst / { $offset = '-07:00' }
        when /:i pst / { $offset = '-08:00' }
        # daylight
        when /:i adt / { $offset = '-03:00' }
        when /:i edt / { $offset = '-04:00' }
        when /:i cdt / { $offset = '-05:00' }
        when /:i mdt / { $offset = '-06:00' }
        when /:i pdt / { $offset = '-07:00' }
    }

    $offset ~~ s/\:00// if $basic;

    return $offset;
} # time-zone-offset-us

sub time-stamp(:$set-time) is export(:time-stamp) {
    my $dt; # DateTime object

    my $default-fmt = { sprintf "%04d-%02d-%02dT%02d:%02d:%05.2fZ",
                .year, .month, .day, .hour, .minute, .second};

    if $set-time {
        # this is strictly for testing
        $dt = DateTime.new($set-time, formatter => $default-fmt);
    }
    else {
         # this should stay the default format when more formats are added
        $dt = DateTime.new(formatter => $default-fmt);
    }

    =begin pod
         my $fmt2 = { sprintf "%04d-%02d-%02dT%02d:%02d:%05.2f%+03d%02d",
                .year, .month, .day, .hour, .minute, .second, .timezone div 3600, .timezone % 3600};
        $dt = DateTime.now(formatter => $fmt2);
    =end pod

    return $dt.Str;
}

=begin pod
sub time-stamp(Bool :$basic = True,
               Bool :$day = True,
               Bool :$local = True,
               Str  :$set-time,
               Str  :$tz,
               Bool :$decorated = True) is export(:time-stamp) {

    # default is extended UTC
    my $tz-offset = 'Z';
    if $tz {
        $tz-offset = time-zone-offset-us($tz);
        $tz-offset ~~ s:g/ \: // if $basic;
    }

    my $date;
    if $day {
	$date = DateTime.now(formatter => {
	sprintf "%04d-%02d-%02d",
	.year, .month, .day});
        $date ~~ s:g/ \: // if $basic;
    }
    elsif $local {
	$date = DateTime.now.local(formatter => {
				    sprintf "%04d-%02d-%02dT%02d:%02d:%02d",
				    .year, .month, .day, .hour, .minute, .second});
        $date ~~ s:g/ <[:-]> // if $basic;
    }
    elsif $decorated {
	$date = DateTime.now.utc(formatter => {
	# bzr-friendly format (no ':' used)
	sprintf "%04d%02d%02dT%02dh%02dm%02ds",
	.year, .month, .day, .hour, .minute, .second});
    }
    else {
        # ISO 8601 extended
	$date = DateTime.now.utc(formatter => {
				    sprintf "%04d-%02d-%02dT%02d:%02d:%02d",
				    .year, .month, .day, .hour, .minute, .second});
        $date ~~ s:g/ <[:-]> // if $basic;
    }

    $date ~= $tz-offset;

    return $date;
} # time-stamp
=end pod

sub find-dirs($dir) returns List is export(:find-dirs) {
    my @dirs = ();
    if !$dir.IO.d {
	say "WARNING: '$dir' is not a directory.";
	return @dirs;
    }

    say "Files in dir '$dir':" if $DEBUG;
    for $dir.IO.dir -> $f {
	# for now assume it's a prog (TODO docs show auto finding files, NOT so)
	my $is-file = $f.f ?? True !! False;
	if $is-file {
	    say "  '$f' is a file...skipping" if $DEBUG;
	    next;
	}
	else {
	    say "  '$f' is a directory..." if $DEBUG;
	    @dirs.push: $f;
	}
    }
    return @dirs;
} # find-dirs

sub find-files($dir) returns List is export(:find-files) {
    my @fils = ();
    if !$dir.IO.d {
	say "WARNING: '$dir' is not a directory.";
	return @fils;
    }

    say "Files in dir '$dir':" if $DEBUG;
    for $dir.IO.dir -> $f {
	# for now assume it's a prog (TODO docs show auto finding files, NOT so)
	my $is-file = $f.f ?? True !! False;
	if $is-file {
	    say "  '$f' is a file..." if $DEBUG;
	    @fils.push: $f;
	}
	else {
	    say "  '$f' is a directory...skipping" if $DEBUG;
	    next;
	}
    }
    return @fils;
} # find-files
