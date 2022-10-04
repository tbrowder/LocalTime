#!/usr/bin/env raku

# from tonyo, #raku, 0938, 2022-10-04

class A {
    method info {
        "A.info"
    }
}

my $f = sub ($s) {
    sprintf "got: %s", .info give $s
}


