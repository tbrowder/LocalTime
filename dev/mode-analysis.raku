#!/usr/bin/env raku

# working vars for modes 1-4
my $mode1; #  = 0; # not $tza.defined
my $mode2 = 'CST'; # $tza = some valid US entry
my $mode3 = 'XST'; # $tza = some non-vald US entryy
my $mode4;         # $tza.defined but no value

class foo {
    has $.tz
}

my $c0a = foo.new;
my $c0b = foo.new: :tz('');
my $c1  = foo.new: :tz('a');
my $c2  = foo.new: :tz('c');
my $c3  = foo.new: :tz;

my %tz = [
    a => True
];

say "== c0a (undefined)";
say $c0a.tz.defined;
say $c0a.tz.^name;
say $c0a.raku;

say "== c0b (eq '')";
say $c0b.tz.defined;
say $c0b.tz.^name;
say $c0b.raku;

say "== c1 (eq 'a')";
say $c1.tz.defined;
say $c1.tz.^name;
say %tz{$c1.tz}:exists;
say $c1.raku;

say "== c2 (eq 'c')";
say $c2.tz.defined;
say $c2.tz.^name;
say %tz{$c2.tz}:exists;
say $c2.raku;

say "== c3 (present, ~~ Bool)";
say $c3.tz.defined;
say $c3.tz.^name;
say $c3.raku;


=finish

my $r; # results
$r0a = 
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


