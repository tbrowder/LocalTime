#!/usr/bin/env raku

# from tonyo, IRC #raku, 1230, 2022-10-11

class A {
    has $.some-property;
}

sub gen-fmt(A:D $obj) {
    $obj does role :: does Callable {
        submethod CALL-ME(|) {
            self.some-property;
        }
    };
}

my $a = A.new(:some-property<$a>);
my $b = A.new(:some-property<$b>);
my $c = A.new(:some-property<blah>);

say gen-fmt($a)();
say gen-fmt($b)();
say gen-fmt($c)();


=finish

my $show = 0;
my $use  = 0;

if not @*ARGS {
    print qq:to/HERE/;
    Usage: {$*PROGRAM.basename} show | use

    Demos dynamic creation of DateTime formatting objects
      courtesy of @tonyo
    HERE
    exit;
}

for @*ARGS {
    when /^s/ { ++$show }
    when /^u/ { ++$use  }
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

if $use {
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


