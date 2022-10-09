#!/usr/bin/env raku

use lib "../lib";
use Formatters;

class foo is DateTime {
    has $.tz-abbrev;
    has $.year;

    submethod TWEAK {
        $!year = 3000;
    }
}

my $t = foo.now;
say $t.Str;
say $t.local;

