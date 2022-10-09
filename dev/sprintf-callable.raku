#!/usr/bin/env raku

use File::Temp;
class foo {...}


if not @*ARGS {
    print qq:to/HERE/;
    Usage: {$*PROGRAM.basename} go

    Demos dynamic creation of DateTime formatting objects
      courtesy of @tonyo and the docs
    HERE
    exit;
}

my &formatter = foo.new;
my $dt = DateTime.new: :2022year, :&formatter;
say "fmt: '{$dt.Str}'";

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

class foo does Callable {
    has $.info;
    submethod CALL-ME($self, |c) {
    #our $CST = sub ($self) {
    sprintf "%04d-%02d-%02dT%02d:%02d:%02d GMT",
    .year, .month, .day, .hour, .minute, .second given $self
    }
}
