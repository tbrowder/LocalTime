#!/usr/bin/env raku

# using info from tonyo, IRC #raku, 0938, 2022-10-04
# trying to use it with DateTime:

my $demo = 0;

if not @*ARGS {
    print qq:to/HERE/;
    Usage: {$*PROGRAM.basename} demo

    Demos dynamic creation of DateTime formatting objects
      courtesy of @tonyo
    HERE
    exit;
}

for @*ARGS {
    when /^d/ { ++$demo }
    default {
        die "Unknown arg '$_'";
    }
}

if $show {
    # example of dynamic instantiation
    my class A {
        method info {
        "A.info"
        }
    }

    my $f = sub ($s) {
        sprintf "got:%s", .info given $s
    }
    say $f(A.new);
} 

if $demo {
    # example of dynamic instantiation inside a program
    my class A {
        has $.num = 0;
        has $!formatter;
        method formatter() {
            $!formatter();
        }
        submethod TWEAK(|) {
            $!formatter = self.num < 10 ?? sub { "<10" }
                                        !! sub { ">=10" }
        }
    }

    A.new(:num(10)).formatter.say;
    A.new(:num(5)).formatter.say;
}


