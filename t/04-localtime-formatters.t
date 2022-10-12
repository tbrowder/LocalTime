use Test;

use LocalTime;
use Timezones::US;

for @tz -> $tz {
    my $TZ = $tz.uc;
 
    my $dt;
    lives-ok {
        $dt = LocalTime.new: :2022year, :tz-abbrev($tz);

    }, "tz-abbrev: '$tz'";
    is $dt.year, 2022;

    last;
}

done-testing;
