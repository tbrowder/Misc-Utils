# Misc::Utils

[![Build Status](https://travis-ci.org/tbrowder/Misc-Utils-Perl6.svg?branch=master)](https://travis-ci.org/tbrowder/Misc-Utils-Perl6)

Being a lazy programmer, I refactor chunks of code I find useful into
a module; whence comes this collection of Perl 6 subroutines I have
written during my coding adventures using Perl 5's new little sister.
I hope they will be useful to others.

The routines are exportable as a set in the following categories:

| Category                    | Export Tag             | Possible Future Module |
| :---                        | :---                   | :---                   |
| number base conversion      | [export(:number)]      | Number::More           |
| text handling               | [export(:text)]        | Text::More             |
| process time measurements   | [export(:time)]        | Linux::Proc::Time      |
| date formatting             | [export(:date-format)] | DateTime::Format::More |
| date routines               | [export(:date-sub)]    | DateTime::Math::More   |
| file and directory routines | [export(:files-dirs)]  | File::Find::More   |

The routines are described in more detail in
[ALL-SUBS](https://github.com/tbrowder/Misc-Utils-Perl6/blob/master/docs/ALL-SUBS.md)
which shows a short description of each exported routine along along
with its complete signature.

This module also includes various utility programs in the bin
directory.

## Status

This version is 0.1.0 which is considered usable, but the APIs are
subject to change in which case the version major number will be
updated. Note that newly added subroutines or application programs are
not considered a change in API.

## Debugging

For debugging, use one the following methods:

- set the module's $DEBUG variable:

```Perl6
$Misc::Utils::DEBUG = True;
```

- set the environment variable:

```Perl6
MISC_UTILS_DEBUG=1
```

## Subroutines Exported by the `:ALL` Tag

See
[ALL-SUBS](https://github.com/tbrowder/Misc-Utils-Perl6/blob/master/docs/ALL-SUBS.md)
for a list of export(:ALL) subroutines, each with a short description
along with its complete signature.
Note that individual subroutines may also be exported:

```Perl6
use Misc::Utils :strip-comment;
```

```Perl6
use Misc::Utils :ALL;
```

## Utility Programs

See
[UTIL-PROGS](https://github.com/tbrowder/Misc-Utils-Perl6/blob/master/docs/UTIL-PROGS.md)
for a list of utility programs, each with a short
description along with its help output.
