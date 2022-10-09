use Test;

my %tzones = [
    a => 'A',
];

sub get-mode(:$tz!, :%tzones!) {
    my $mode;
    if not $tz.defined {
        $mode = 0;
    }
    elsif $tz eq '' {
        $mode = 0;
    }
    elsif $tz ~~ Str {
        if %tzones{$tz}:exists {
            $mode = 1;
        }
        else {
            $mode = 2;
        }
    }
    elsif $tz ~~ Bool {
        $mode = 3;
    }
    else {
        die "FATAL: All possibilities exhausted.";
    }
    $mode
}

class Foo {
    has $.tz;
    has $.mode  = 0;
    has $.mode2 = 0;

    submethod TWEAK {
        my %m;
        my ($m0, $m1, $m2, $m3) = 0, 0, 0, 0;

        # an alternative mode checker
        $!mode2 = get-mode :$!tz, :%tzones;

        if not $!tz.defined {
            %m<0> = True;
            $!mode = 0;
        }
        elsif $!tz eq '' {
            %m<0> = True;
            $!mode = 0;
        }
        elsif $!tz ~~ Str {
            if %tzones{$!tz}:exists {
                %m<1> = True;
                $!mode = 1;
            }
            else {
                %m<2> = True;
                $!mode = 2;
            }
        }
        elsif $!tz ~~ Bool {
            %m<3> = True;
            $!mode = 3;
        }
    }
}

my $c0a = Foo.new;
is $c0a.mode, 0;
is $c0a.mode2, 0;

my $c0b = Foo.new: :tz('');
is $c0b.mode, 0;
is $c0b.mode2, 0;

my $c1 = Foo.new: :tz('a');
is $c1.mode, 1;
is $c1.mode2, 1;

my $c2 = Foo.new: :tz('c');
is $c2.mode, 2;
is $c2.mode2, 2;

my $c3 = Foo.new: :tz;
is $c3.mode, 3;
is $c3.mode2, 3;

