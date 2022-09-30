[![Actions Status](https://github.com/tbrowder/LocalTime/actions/workflows/test.yml/badge.svg)](https://github.com/tbrowder/LocalTime/actions)

NAME
====

**LocalTime** - A clone of class **DateTime** with different default formatters

SYNOPSIS
========

```raku
use LocalTime;
```

DESCRIPTION
===========

**LocalTime** is a subclass of the Raku **DateTime** class and was created to either add a local timezone abbreviation to a time string or show no timezone information at all if no abbreviation is available.

This is the default format for `DateTime`:

    $ say DateTime.new: :2022year;
    2022-01-01T00:00:00Z

This is the default format for `LocalTime` with no time zone entry:

    $ say LocalTime.new: :2022year;
    2022-01-01T00:00:00 # <== note no trailing 'Z'

And this is the default format for `LocalTime` with 'CST' entered:

    $ say LocalTime.new: :2022year, :tz-abbrev('CST');
    2022-01-01T00:00:00 CST

Note that the user can enter either '*st' or '*dt' (case insensitive) and the correct form will be used for the time of year.

Curtently only US abbreviations are available but a future modification will add others (perhaps in other languages also).

AUTHOR
======

Tom Browder <tbrowder@acm.org>

COPYRIGHT AND LICENSE
=====================

Copyright 2022 Tom Browder

This library is free software; you can redistribute it and/or modify it under the Artistic License 2.0.

