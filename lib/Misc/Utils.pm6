unit module Misc::Utils:auth<github:tbrowder>;

# file:  ALL-SUBS.md
# title: Subroutines Exported by the `:ALL` Tag

# export a debug var for users
our $DEBUG = False;
BEGIN {
    if %*ENV<NET_IP_LITE_DEBUG> {
	$DEBUG = True;
    }
    else {
	$DEBUG = False;
    }
}

# define tokens for common regexes
my token binary           { ^ <[01]>+ $ }
my token decimal          { ^ \d+ $ }              # actually an int
my token hexadecimal      { :i ^ <[a..f\d]>+ $ }   # multiple chars
my token hexadecimalchar  { :i ^ <[a..f\d]> $ }    # single char

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
sub dec2bin(UInt $dec, UInt $len = 0) returns Str is export {
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
sub bin2hex(Str:D $bin where &binary, UInt $len = 0) returns Str is export(:bib2hex) {
    # take the easy way out
    my $dec = bin2dec($bin);
    my $hex = dec2hex($dec, $len);
    return $hex;
} # bin2hex

#------------------------------------------------------------------------------
# Subroutine strip-comment
# Purpose : Strip comments from an input text line
# Params  : String of text, comment char ('#' is default)
# Returns : String of text with any comment stripped off
sub strip-comment(Str $line is copy, Str $comment-char = '#') returns Str is export(:strip-comment) {
    my $idx = index $line, $comment-char;
    if $idx.defined {
	return substr $line, 0, $idx;
    }
    return $line;
} # strip-comment

#------------------------------------------------------------------------------
# Subroutine
# Purpose :
# Params  :
# Returns :
sub delta-time-hms($Time) returns Str is export {
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
# Subroutine
# Purpose :
# Params  :
# Returns :
sub read-sys-time($time-file, :$uts) is export {
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
# Subroutine
# Purpose :
# Params  :
# Returns :
sub time-command(Str:D $cmd, :$uts) is export {
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
# Subroutine
# Purpose :
# Params  :
# Returns :
sub commify($num) is export {
    # translated from Perl Cookbook, 2e, Recipe 2.16
    say "DEBUG: input '$num'" if $DEBUG;
    my $text = $num.flip;
    say "DEBUG: input flipped '$text'" if $DEBUG;
    #$text =~ s:g/(\d\d\d)(?=\d)(?!\d*\.)/$0,/; # how to do in Perl 6?

    $text ~~ s:g/ (\d\d\d) <?before \d> <!before \d*\.> /$0,/;

    # don't forget to flip back to the original
    $text .= flip;
    say "DEBUG: commified output '$text'" if $DEBUG;

    return $text;

} # commify
