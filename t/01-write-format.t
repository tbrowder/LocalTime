use Test;

use LocalTime;
use Timezones::US;

for <xst zst> -> $tz {
    my $o = LocalTime.new: :2022year, :tz-abbrev($tz);
    is $o.tz-abbrev, $tz;
    is $o.TZ-ABBREV, $tz.uc;
}

for %tzones.keys.sort -> $tz {
    my $o = LocalTime.new: :2022year, :tz-abbrev($tz);
    is $o.tz-abbrev, $tz;
    is $o.TZ-ABBREV, $tz.uc;
}

done-testing;


