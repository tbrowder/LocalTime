#!/usr/bin/env raku

# based on info from tonyo, IRC #raku, 0938, 2022-10-04
# also referring to Callable in the docs

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


if $eg-a {
    my $f = sub ($self) {
        sprintf "%04d-%02d-%02dT%02d:%02d:%02d CST",
        .year, .month, .day, .hour, .minute, .second given $self
    }
}

if $eg-b {
    class A {
        has $.tz-info;
        submethod CALL-ME(|c) {
        }
    }
}

our $CST = sub ($self) {
    sprintf "%04d-%02d-%02dT%02d:%02d:%02d CST",
    .year, .month, .day, .hour, .minute, .second given $self
};
