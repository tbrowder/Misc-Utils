# title: Subroutines Exported by the `:ALL` Tag

### Contents

| a | b | c |
| --- | --- | --- |
| [bin2dec](#bin2dec)| [bin2hex](#bin2hex) |
| [count-substrs](#count-substrs)| [dec2bin](#dec2bin) |
| [dec2hex](#dec2hex)| [hex2bin](#hex2bin) |
| [hex2dec](#hex2dec)| [hexchar2bin](#hexchar2bin) |
| [hexchar2dec](#hexchar2dec)| [strip-comment](#strip-comment) |

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
  returns Str is export(:bib2hex) {#...}
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
sub dec2bin(UInt $dec, UInt $len = 0)
  returns Str is export {#...}
```

### dec2hex
- Purpose : Convert a positive integer to a hexadecimal number (string)
- Params  : Positive decimal number, desired length (optional)
- Returns : Hexadecimal number (string)
```perl6
sub dec2hex(UInt $dec, UInt $len = 0)
  returns Str is export(:dec2hex) {#...}
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

### strip-comment
- Purpose : Strip comments from an input text line
- Params  : String of text, comment char ('#' is default)
- Returns : String of text with any comment stripped off
```perl6
sub strip-comment(Str $line is copy, Str $comment-char = '#')
  returns Str is export(:strip-comment) {#...}
```
