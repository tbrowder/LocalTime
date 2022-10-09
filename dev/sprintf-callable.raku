#!/usr/bin/env raku

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
my $f2 = gen-fmt2;
$formatter = $f2.new;
$dt = DateTime.new: :2022year, :$formatter;
say "fmt2: '{$dt.Str}'";

#=== dynamically create the formatter as a string ================
my %class-names; # generated classes must have unique names
my $fmt3 = "fmt3";
my $fmt4 = "fmt4";

my $f3 = gen-class :%class-names, :class-name($fmt3);
$formatter = $f3.new;
$dt = DateTime.new: :2022year, :$formatter;
say "fmt3: '{$dt.Str}'";
  
my $f4 = gen-class :%class-names, :class-name($fmt4), :tz-info("HOORAY!");
$formatter = $f4.new;
$dt = DateTime.new: :2022year, :$formatter;
say "fmt4: '{$dt.Str}'";
#=== EUREKA!! 

# try the clone
#$dt = $dt.clone.year(2024);
#say "fmt4 clone: '{$dt.Str}'";


#| This class has the information baked in and was hand coded
class fmt1 does Callable {
    submethod CALL-ME($self, |c) {
        sprintf "%04d-%02d-%02dT%02d:%02d:%02d HAND-CODED INLINE",
        .year, .month, .day, .hour, .minute, .second given $self
    }
}

#| This generates the class via an eval, usable in a class generator
sub gen-fmt2 {
    use MONKEY-SEE-NO-EVAL;
    my $fmt = q:to/HERE/;
    class fmt2 does Callable {
        submethod CALL-ME($self, |c) {
            sprintf "%04d-%02d-%02dT%02d:%02d:%02d EVAL",
            .year, .month, .day, .hour, .minute, .second given $self
        }
    }
    HERE
    EVAL $fmt
}

sub gen-class(:%class-names!, :$class-name!, :$tz-info = '') {
    #| A class generator factory for DateTime formatters.
    #| The caller must ensure the class name is unique.
    #| Passing in a hash of generated names provides that
    #| that capability.

    use MONKEY-SEE-NO-EVAL;

    if %class-names{$class-name}:exists {
        die "FATAL: class $class-name already exists";
    }
    %class-names{$class-name} = True;
 
    my $fmt = qq:to/HERE/;
    class $class-name does Callable \{
    HERE
    $fmt .= chomp;

    $fmt ~= q:to/HERE/;
        submethod CALL-ME($self, |c) {
            sprintf "%04d-%02d-%02dT%02d:%02d:%02d
    HERE
    $fmt .= chomp;

    if $tz-info {
        $fmt ~= " $tz-info";
    }
    $fmt .= chomp;

    # close the format string (don't forget the trailing comma!!)
    $fmt ~= q:to/HERE/;
    ",
            .year, .month, .day, .hour, .minute, .second given $self
         }
    }
    HERE
    $fmt .= chomp;

    EVAL $fmt
}
