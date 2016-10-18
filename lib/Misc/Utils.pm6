unit module Misc::Utils:auth<github:tbrowder>;

# file: DEFAULT-SUBS.md
# title: Subroutines Exported by Default

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
sub count-substrs(Str:D $ip, Str:D $substr) returns UInt is export {
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
sub hexchar2bin(Str:D $hexchar where &hexadecimalchar) is export {
    my $decimal = hexchar2dec($hexchar);
    return sprintf "%04b", $decimal;
} # hexchar2bin

#------------------------------------------------------------------------------
# Subroutine hexchar2dec
# Purpose : Convert a single hexadecimal character to a decimal number
# Params  : Hexadecimal character
# Returns : Decimal number
sub hexchar2dec(Str:D $hexchar is copy where &hexadecimalchar) returns UInt is export {
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
sub hex2dec(Str:D $hex where &hexadecimal, UInt $len = 0) returns Cool is export {
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
sub hex2bin(Str:D $hex where &hexadecimal, UInt $len = 0) returns Str is export {
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
sub dec2hex(UInt $dec, UInt $len = 0) returns Str is export {
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
sub bin2dec(Str:D $bin where &binary, UInt $len = 0) returns Cool is export {
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
sub bin2hex(Str:D $bin where &binary, UInt $len = 0) returns Str is export {
    # take the easy way out
    my $dec = bin2dec($bin);
    my $hex = dec2hex($dec, $len);
    return $hex;
} # bin2hex
