#!/usr/bin/env raku

if not @*ARGS {
    say "Usage: {$*PROGRAM.basename} go";
    say "  Demos unpacking a capture";
    exit;
}

if 0 {
my $cst = sub ($self) { 
   sprintf "%4d-%02d-%02dT%02d:%02d:%02d CST", 
       .year, .month, .day, .hour, .minute, .second 
   given $self 
}
my $cdt = sub ($self) { 
   sprintf "%4d-%02d-%02dT%02d:%02d:%02d CDT", 
       .year, .month, .day, .hour, .minute, .second 
   given $self 
}
}

use lib ".";
use F;
use lib "../lib";
use Timezones::US;

class foo is DateTime {
    my $spkg = "F::CST";
    my $dpkg = "F::CDT";
    my $cst = $::($spkg);
    my $cdt = $::($dpkg);
    my $fmt = $cst;
    
    #method new(:$tz, |c) {
    method new(|c) {
        my $dt = DateTime.new(|c);
        $fmt = $cdt if is-dst(:localtime($dt.local));
        self.DateTime::new(:formatter($fmt), |c);
    }
}

my $t;
#$t = foo.new(:2022year);
#say $t.Str;
$t = foo.new(:year(2022), :month(1), :day(1), :hour(6), :minute(5), :second(8), :timezone(3600));
say $t.Str;
$t = foo.new(:year(2022), :month(6), :day(1), :hour(6), :minute(5), :second(8), :timezone(3600));
say $t.Str;
