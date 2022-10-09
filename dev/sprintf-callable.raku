#!/usr/bin/env raku

use File::Temp;
class fmt1 {...}

if not @*ARGS {
    print qq:to/HERE/;
    Usage: {$*PROGRAM.basename} go

    Demos dynamic creation of DateTime formatting objects
      in various ways courtesy of @tonyo, the docs, and
      my experiments.
    HERE
    exit;
}

#=== inline hand coding ================
my $dt;
my &formatter = fmt1.new;
$dt = DateTime.new: :2022year, :&formatter;
say "fmt1: '{$dt.Str}'";

# rename the container
my $formatter = fmt1.new;
$dt = DateTime.new: :2022year, :$formatter;
say "fmt1: '{$dt.Str}'";
#=== end inline hand coding ================

#=== create the formatter as a string ================
my $f = gen-fmt2;
$formatter = $f.new;
$dt = DateTime.new: :2022year, :$formatter;
say "fmt2: '{$dt.Str}'";


=begin comment
our $CST = sub ($self) {
    sprintf "%04d-%02d-%02dT%02d:%02d:%02d CST",
    .year, .month, .day, .hour, .minute, .second given $self
}
=end comment

sub write-formatter($fh, :$name!, :$tz-info = '') {
    # note the 'our' is required, but no 'export'
    $fh.say:   "our \${$name} = sub (\$self) \{"; 
    $fh.print: '    sprintf "%04d-%02d-%02dT%02d:%02d:%02d'; # <= note no closing "
    if $tz-info {
        $fh.print: " $tz-info";
    }
    # close the format string (don't forget the trailing comma!!)
    $fh.say: '",';
    
    $fh.say:   '    .year, .month, .day, .hour, .minute, .second given $self'; 
    $fh.say:   '}';
}

#| This class has the information baked in and was hand coded
class fmt1 does Callable {
    submethod CALL-ME($self, |c) {
        sprintf "%04d-%02d-%02dT%02d:%02d:%02d HAND-CODED INLINE",
        .year, .month, .day, .hour, .minute, .second given $self
    }
}

sub gen-fmt2 {
    use MONKEY-SEE-NO-EVAL;

    my $fmt2 = q:to/HERE/;
    class fmt2 does Callable {
        submethod CALL-ME($self, |c) {
            sprintf "%04d-%02d-%02dT%02d:%02d:%02d EVAL",
            .year, .month, .day, .hour, .minute, .second given $self
        }
    }
    HERE

    EVAL $fmt2
}

