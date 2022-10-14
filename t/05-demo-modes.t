use Test;

use LocalTime;

my $o;
my $m;
my $exp;

# mode 0
subtest {
    $o = LocalTime.new: :year(2022);
    is $o.Str, "2022-01-01T00:00:00", "is '(no tz abbrev entry)'";
    $m   = $o.mode;
    $exp = 0;
    is $o.mode, $exp, "mode should be $exp, is mode $m";
}, "subtest 0";

# mode 1
subtest {
    $o = LocalTime.new: :year(2022), :tz-abbrev('cst');
    is $o.Str, "2022-01-01T00:00:00 CST", "is CST";
    $m = $o.mode;
    $exp = 1;
    is $o.mode, $exp, "mode should be $exp, is mode $m";
}, "subtest 1";

# mode 2
subtest {
    $o = LocalTime.new: :year(2022), :tz-abbrev('ZNT');
    is $o.Str, "2022-01-01T00:00:00 ZNT", "is ZNT";
    $m = $o.mode;
    $exp = 2;
    is $o.mode, $exp, "mode should be $exp, is mode $m";
}, "subtest 2";

# mode 3
subtest {
    my $offset = $*TZ div 3600;
    my $res;
    if $offset < 0 {
        $res = "Local Time (UTC $offset hrs)";
    }
    elsif $offset > 0 {
        $res = "Local Time (UTC +$offset hrs)";
    }
    else {
        $res = "Local Time (UTC)";
    }
    $o = LocalTime.new: :year(2022), :tz-abbrev;
    is $o.Str, "2022-01-01T00:00:00 $res", "is Bool";
    $m = $o.mode;
    $exp = 3;
    is $o.mode, $exp, "mode should be $exp, is mode $m";
}, "subtest 3";

done-testing;
