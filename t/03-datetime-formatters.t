use Test;

use Timezones::US;
use LocalTime;

my $formatter = LocalTime.new(:2022year, :tz-abbrev).formatter;
for @tz -> $tz is copy {
    $tz .= uc;

    my $dt;
    lives-ok {
        $dt = DateTime.new: :$formatter, :2022year;
    }
    is $dt.year, 2022;
}

done-testing;

