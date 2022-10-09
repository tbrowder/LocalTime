use Test;

use LocalTime :gen-fmt-class;
=begin comment
use F;
=end comment
use Timezones::US;

my %class-names;
for @tz -> $tz is copy {
    $tz .= uc;

    =begin comment
    my $formatter = $::("F::$tz");
    =end comment

    my $formatter = gen-fmt-class :%class-names, :class-name($tz), :tz-abbrev($tz);

    my $dt;
    lives-ok {
        $dt = LocalTime.new: :$formatter, :2022year;
    }
    #is $dt.year, 2022;
}

done-testing;
