use Test;

use LocalTime;

my $o;
my $m;
my $exp;

lives-ok {
    $o = DateTime.new: :year(2022);
}, "default DateTime";
is $o.year, 2022, "year is 2022";
is $o.Str, "2022-01-01T00:00:00Z", "is Z (default DateTime fmt)";

lives-ok {
    $o = LocalTime.new: :year(2022);
}, "default LocalTime";
is $o.year, 2022, "year is 2022";
is $o.Str, "2022-01-01T00:00:00", "is '(no tz abbrev entry)'";
$m   = $o.mode;
$exp = 0;
is $o.mode, $exp, "mode should be $exp, is mode $m";
is $o.tz-abbrev.defined, False;


# check auto-correction of lower-case entries
lives-ok {
    $o = LocalTime.new: :year(2022), :tz-abbrev('cst');
}, "cst";
is $o.year, 2022, "year is 2022";
is $o.Str, "2022-01-01T00:00:00 CST", "is CST (entered 'cst')";
$m = $o.mode;
$exp = 1;
is $o.mode, $exp, "mode should be $exp, is mode $m";
is $o.tz-abbrev, "cst";

# check auto-correction of wrong DST 
lives-ok {
    $o = LocalTime.new: :year(2022), :tz-abbrev('cdt');
}, "cdt";
is $o.year, 2022, "year is 2022";
is $o.Str, "2022-01-01T00:00:00 CST", "is CST (entered 'cdt)";
$m = $o.mode;
$exp = 1;
is $o.mode, $exp, "mode should be $exp, is mode $m";

lives-ok {
    $o = LocalTime.new: :year(2022), :7month, :tz-abbrev('cst');
}, "cst => cdt";
is $o.year, 2022, "year is 2022";
is $o.Str, "2022-07-01T00:00:00 CDT", "is CDT (entered 'cst')";
$m = $o.mode;
$exp = 1;
is $o.mode, $exp, "mode should be $exp, is mode $m";

done-testing;
