#!/usr/bin/env raku

use UUID::V4;

sub uuid2cname($uuid --> Str) {
    my $cname = $uuid;
    my @c = ('a'..'z').list;
    @c.push: |('A'..'Z').list;
    my @p = split '-', $cname;
    my @cname;
    while @p.elems {
        my $c = @c.pick(1);
        my $p = @p.shift;
        $p ~~ s/^\d/$c/;
        @cname.push: $p;
    }
    $cname = @cname.join: '-';
}

my $n = @*ARGS.shift // 1;
for 0..^$n {
    my $uuid  = uuid-v4;
    my $cname = uuid2cname $uuid;
    say "=============";
    say "uuid  '$uuid'";
    say "cname '$cname'";
}

