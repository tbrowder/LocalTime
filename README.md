[![Actions Status](https://github.com/tbrowder/LocalTime/actions/workflows/test.yml/badge.svg)](https://github.com/tbrowder/LocalTime/actions)

NAME
====

**LocalTime** - A clone of class **DateTime** with a different default formatter

SYNOPSIS
========

```raku
use LocalTime;
```

DESCRIPTION
===========

**LocalTime** is a subclass of the Raku **DateTime** class and was created to either add a local timezone abbreviation to a time string or show no timezone information at all if no abbreviation is available.

Curtently only US abbreviations are available but a future modification will add others (perhaps in other languages also).

AUTHOR
======

Tom Browder <tbrowder@acm.org>

COPYRIGHT AND LICENSE
=====================

Copyright 2022 Tom Browder

This library is free software; you can redistribute it and/or modify it under the Artistic License 2.0.

