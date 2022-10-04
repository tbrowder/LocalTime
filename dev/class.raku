#!/usr/bin/env raku

use lib <../lib>;
use Formatters;

class foo is DateTime {
    has DateTime $.dt;
    has $.tz-abbrev = "CST";
    # dup of DateTime

    has $.year is required;
    has $.month    = 1;
    has $.day      = 1;
    has $.hour     = 0;
    has $.minute   = 0;
    has $.second   = 0;
    has $.timezone = 0;

    #method new(:$tz-abbrev, :$year!, :$month, :$day, :$hour, :$minute, :$second, :$timezone) { }

    #submethod BUILD(:$!tz-abbrev, :$!year!, :$!month, :$!day, :$!hour, :$!minute, :$!second, :$!timezone) { }

    submethod TWEAK() {
        $!dt = DateTime.new(
            :$!year, :$!month, :$!day, :$!hour, :$!minute, :$!second, :$!timezone
        ); 
        self::new(|c);
    }
}

my $t = foo.new: :tz-abbrev('CST'), :2022year;
say $t.year;
say $t.tz-abbrev;

=finish


# working vars for modes 1-4
my $mode1; #  = 0; # not $tza.defined
my $mode2 = 'CST'; # $tza = some valid US entry
my $mode3 = 'XST'; # $tza = some non-vald US entryy
my $mode4;         # $tza.defined but no value

for ($mode1, $mode2, $mode3, $mode4).kv -> $i, $mode {
    # determine 
    my $n = $i+1;
    #say "Mode $n, status '{$v.^name}'";
    if $n == 1 {
        f :$n;
    }
    elsif $n == 2 {
        f :$mode, :$n;
    }
    elsif $n == 3 {
        f :$mode, :$n;
    }
    elsif $n == 4 {
        f :mode, :$n;
    }
}

sub f(:$mode, :$n) {
    if $mode.defined {
        say "$n: {$mode}";
        say "    {$mode.^name}";
        say "    is Bool" if $mode ~~ Bool;
        say "    is Str"  if $mode ~~ Str;
    }
    else {
        say "$n: mode not defined";
    }
}


