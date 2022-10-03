#!/usr/bin/env raku


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


