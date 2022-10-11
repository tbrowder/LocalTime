use Test;

use LocalTime :gen-fmt-class;

=begin comment
use F;
=end comment

use Timezones::US;

my $debug = 0;
my %class-names;

for @tz -> $tz {
    my $TZ = $tz.uc;

    =begin comment
    my $formatter = $::("F::$tz");
    =end comment

    =begin comment
    note "tz: '$tz', TZ: '$TZ'";
    =end comment

    my $f = gen-fmt-class :%class-names, :class-name($TZ), :tz-abbrev($tz); #, :$debug;
    
    =begin comment
    for $f.lines -> $line {
        note $line;
    }
    note "DEBUG exit"; exit;
    =end comment

    my $formatter = $f.new;
    %class-names{$tz} = $formatter;

    if $debug {
        note "DEBUG: \$formatter:";
        note $formatter.raku;
        exit;
    }
 
    my $dt;
    lives-ok {
        $dt = LocalTime.new: :2022year, :$formatter;

    }, "tz-abbrev: '$tz'";
    is $dt.year, 2022;

    last;
}

done-testing;
