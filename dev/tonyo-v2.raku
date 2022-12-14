#!/usr/bin/env raku

# from tonyo, IRC #raku, 1230, 2022-10-11
# modified to suit me

class A {
    has $.fstr; # some formatter as a string
}

sub gen-fmt(A:D $obj) {
    $obj does role :: does Callable {
        submethod CALL-ME(|) {
            self.fstr;
        }
    };
}

my %fstrings;
for <CST PST> -> $cname {
    my $s = "";

    $s ~= q:to/HERE/;
    sub ($self) { 
        sprintf "%04d-%02d-%02dT%02d:%02d:02d
    HERE
    $s .= chomp;
    $s ~= " $cname";
    $s .= chomp;
    # Close the format string (don't forget the trailing comma!!)
    $s ~= q:to/HERE/;
    ",
            .year, .month, .day, .hour, .minute, .second given $self
	}
    }
    HERE
    $s .= chomp;
    %fstrings{$cname} = $s;
}

for %fstrings.keys.sort -> $tz {
    say "=== key: '$tz', fstring:";
    say %fstrings{$tz};
}

for %fstrings -> $fstr {
    #use MONKEY-SEE-NO-EVAL;
    my $formatter = $fstr.new;
    my $dt = DateTime.new: :2020year, :$formatter;
    say $dt.Str;
}

=finish

my $a = A.new(:info<$a>);
my $b = A.new(:info<$b>);
my $c = A.new(:info<blah>);

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


