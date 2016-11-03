# Subroutines Exported by the `:ALL` Tag

### Contents

| Col 1 | Col 2 | Col 3 |
| :--- | :--- | :--- |
| [bin2dec](#bin2dec) | [bin2hex](#bin2hex)| [commify](#commify) |
| [count-substrs](#count-substrs) | [dec2bin](#dec2bin)| [dec2hex](#dec2hex) |
| [delta-time-hms](#delta-time-hms) | [hex2bin](#hex2bin)| [hex2dec](#hex2dec) |
| [hexchar2bin](#hexchar2bin) | [hexchar2dec](#hexchar2dec)| [normalize-string](#normalize-string) |
| [normalize-string-rw](#normalize-string-rw) | [read-sys-time](#read-sys-time)| [split-line](#split-line) |
| [split-line-rw](#split-line-rw) | [strip-comment](#strip-comment)| [time-command](#time-command) |
| [write-paragraph](#write-paragraph) | |  |

### bin2dec
- Purpose : Convert a binary number (string) to a decimal number
- Params  : Binary number (string), desired length (optional)
- Returns : Decimal number (or string)
```perl6
sub bin2dec(Str:D $bin where &binary, UInt $len = 0)
  returns Cool is export(:bin2dec) {#...}
```

### bin2hex
- Purpose : Convert a binary number (string) to a hexadecimal number (string)
- Params  : Binary number (string), desired length (optional)
- Returns : Hexadecimal number (string)
```perl6
sub bin2hex(Str:D $bin where &binary, UInt $len = 0)
  returns Str is export(:bin2hex) {#...}
```

### commify
- Purpose : Add commas to a mumber to separate multiples of a thousand
- Params  : An integer or number with a decimal fraction
- Returns : The input number with commas added, e.g., 1234.56 => 1,234.56
```perl6
sub commify($num) is export(:commify) {#...}
  
```

### count-substrs
- Purpose : Count instances of a substring in a string
- Params  : String, Substring
- Returns : Number of substrings found
```perl6
sub count-substrs(Str:D $ip, Str:D $substr)
  returns UInt is export(:count-substrs) {#...}
```

### dec2bin
- Purpose : Convert a positive integer to a binary number (string)
- Params  : Positive decimal number, desired length (optional)
- Returns : Binary number (string)
```perl6
sub dec2bin(UInt $dec, UInt $len = 0) returns Str is export(:dec2bin) {#...}
  
```

### dec2hex
- Purpose : Convert a positive integer to a hexadecimal number (string)
- Params  : Positive decimal number, desired length (optional)
- Returns : Hexadecimal number (string)
```perl6
sub dec2hex(UInt $dec, UInt $len = 0) returns Str is export(:dec2hex) {#...}
  
```

### delta-time-hms
- Purpose : Convert time in seconds to hms format
- Params  : Time in seconds
- Returns : Time in hms format, e.g, "3h02m02.65s"
```perl6
sub delta-time-hms($Time) returns Str is export(:delta-time-hms) {#...}
  
```

### hex2bin
- Purpose : Convert a positive hexadecimal number (string) to a binary string
- Params  : Hexadecimal number (string), desired length (optional)
- Returns : Binary number (string)
```perl6
sub hex2bin(Str:D $hex where &hexadecimal, UInt $len = 0)
  returns Str is export(:hex2bin) {#...}
```

### hex2dec
- Purpose : Convert a positive hexadecimal number (string) to a decimal number
- Params  : Hexadecimal number (string), desired length (optional)
- Returns : Decimal number (or string)
```perl6
sub hex2dec(Str:D $hex where &hexadecimal, UInt $len = 0)
  returns Cool is export(:hex2dec) {#...}
```

### hexchar2bin
- Purpose : Convert a single hexadecimal character to a binary string
- Params  : Hexadecimal character
- Returns : Binary string
```perl6
sub hexchar2bin(Str:D $hexchar where &hexadecimalchar)
  is export(:hexchar2bin) {#...}
```

### hexchar2dec
- Purpose : Convert a single hexadecimal character to a decimal number
- Params  : Hexadecimal character
- Returns : Decimal number
```perl6
sub hexchar2dec(Str:D $hexchar is copy where &hexadecimalchar)
  returns UInt is export(:hexchar2dec) {#...}
```

### normalize-string
- Purpose : Trim a string and collapse multiple whitespace characters to single ones
- Params  : The string to be normalized
- Returns : The normalized string
```perl6
sub normalize-string(Str:D $str is copy)
  returns Str is export(:normalize-string) {#...}
```

### normalize-string-rw
- Purpose : Trim a string and collapse multiple whitespace characters to single ones
- Params  : The string to be normalized
- Returns : Nothing, the input string is normalized in-place
```perl6
sub normalize-string-rw(Str:D $str is rw)
  is export(:normalize-string-rw) {#...}
```

### read-sys-time
- Purpose : An internal helper function that is not exported
- Params  : Name of a file that contains output from the GNU 'time' command
- Returns : A list or a single value depending upon the presence of the ':$uts' variable
```perl6
sub read-sys-time($time-file, :$uts) {#...}
  
```

### split-line
- Purpose : Split a string into two pieces
- Params  : String to be split, the split character, maximum length, a starting position for the search, search direction
- Returns : The two parts of the split string; the second part will be empty string if the input string is not too long
```perl6
sub split-line(Str:D $line is copy, Str:D $brk, UInt :$max-line-length = 78,
               UInt :$start-pos = 0, Bool :$rindex = False)
  returns List is export(:split-line) {#...}
```

### split-line-rw
- Purpose : Split a string into two pieces
- Params  : String to be split, the split character, maximum length, a starting position for the search, search direction
- Returns : The part of the input string past the break character, or an empty string (the input string is modified in-place if it is too long)
```perl6
sub split-line-rw(Str:D $line is rw, Str:D $brk, UInt :$max-line-length = 78,
                  UInt :$start-pos = 0, Bool :$rindex = False)
  returns Str is export(:split-line-rw) {#...}
```

### strip-comment
- Purpose : Strip comments from an input text line
- Params  : String of text, comment char ('#' is default)
- Returns : String of text with any comment stripped off
```perl6
sub strip-comment(Str $line is copy, Str $comment-char = '#')
  returns Str is export(:strip-comment) {#...}
```

### time-command
- Purpose : Collect the process times for a system command
- Params  : The command as a string, optionally a parameter to ask for user time only
- Returns : A list of times or user time only
```perl6
sub time-command(Str:D $cmd, :$uts) is export(:time-command) {#...}
  
```

### write-paragraph
- Purpose : Wrap a string of words into a paragraph with a maximum line width (default: 78) and updates input string with the results
- Params  : String of words, max line length, paragraph indent, first line indent, pre-text
- Returns : Nothing (caution, this routine uses more memory than the output-to-file version)
