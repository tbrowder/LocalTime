use Test;

use F;
use Timezones::US;

for @tz -> $tz is copy {
    $tz .= uc;
    my $formatter = $::("F::$tz");

    my $dt;
    lives-ok {
        $dt = DateTime.new: :$formatter, :2022year;
    }
    is $dt.year, 2022;
}

done-testing;

