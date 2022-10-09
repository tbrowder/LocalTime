use Test;

use LocalTime;

for <xst zst> -> $tz {
    my $o LocalTime.new: :2022year, :tz-abbrev($tz);
    is $o.tz-abbrev, $tz;
}


done-testing;


