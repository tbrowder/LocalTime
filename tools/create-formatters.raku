#!/usr/bin/env raku

use Timezones::US;

# modes
my $create = 0;
my $show   = 0;
# options
my $force  = 0;
my $debug  = 0;

my $mod = 'TZ-formatters.rakumod';
if not @*ARGS {
    print qq:to/HERE/;
    Usage: {$*PROGRAM.basename} create | show [options: force debug]

    Creates a module of DateTime formatting objects
      for use by users of module 'Timezones::Universal'.
    Currently the only TZ-specific formatters are for
      the US as found in module 'Timezones::US' but
      there are also formtters usable for TZs given 
      as integral hour offsets from the Prime Meridian.
    HERE
    exit;
}

for @*ARGS {
    when /^c/ { ++$create }
    when /^s/ { ++$show   }
    when /^f/ { ++$force  }
    when /^d/ { ++$debug  }
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


