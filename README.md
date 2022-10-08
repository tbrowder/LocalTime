[![Actions Status](https://github.com/tbrowder/LocalTime/actions/workflows/test.yml/badge.svg)](https://github.com/tbrowder/LocalTime/actions)

NAME
====

**LocalTime** - A wrapper of class **DateTime** with varied formatters depending on time zone entry

SYNOPSIS
========

```raku
use LocalTime;
```

DESCRIPTION
===========

**LocalTime** is a wrapper class holding an instance of the Raku **DateTime** class. It was created to either add a local timezone (TZ) abbreviation to a time string or show either none or other TZ information depending on the use (or non-use) of the named variable `:tz-abbrev`. Following are the formatting effects of the various input conditions:

### class DateTime

  * The default format for `DateTime`:

        $ say DateTime.new: :2022year;
        2022-01-01T00:00:00Z

### class LocalTime

  * The default format for `LocalTime` with no time zone entry:

        $ say LocalTime.new: :2022year;
        2022-01-01T00:00:00 # <== note no trailing 'Z'

  * The default format for `LocalTime` with 'CST' entered:

        $ say LocalTime.new: :2022year, :tz-abbrev('CST');
        2022-01-01T00:00:00 CST

  * The format for `LocalTime` with a non-US TZ abbreviation entered:

        $ say LocalTime.new: :2022year, :tz-abbrev('XYT');
        2022-01-01T00:00:00 XYT

  * The format for `LocalTime` with an empty `:tz-abbrev` named argument entered:

        $ say LocalTime.new: :2022year, :tz-abbrev;
        2022-01-01T00:00:00 Local Time (UTC -4 hrs)

Note for US TZ entries the user can enter either '*st' or '*dt' (case insensitive) and the correct form will be used for the time of year.

Currently only US abbreviations are in the database, but a future modification will add others (perhaps in other languages also). PRs are welcome!

AUTHOR
======

Tom Browder <tbrowder@acm.org>

COPYRIGHT AND LICENSE
=====================

© 2022 Tom Browder

This library is free software; you may redistribute or modify it under the Artistic License 2.0.

