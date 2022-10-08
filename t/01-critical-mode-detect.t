use Test;

my %tzones = [
    a => 'A',
];

class Foo {
    has $.tz;
    has $.mode = 0;

    submethod TWEAK {
        my %m;
        my ($m0, $m1, $m2, $m3) = 0, 0, 0, 0;

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

my $c0b = Foo.new: :tz('');
is $c0b.mode, 0;

my $c1 = Foo.new: :tz('a');
is $c1.mode, 1;

my $c2 = Foo.new: :tz('c');
is $c2.mode, 2;

my $c3 = Foo.new: :tz;
is $c3.mode, 3;

