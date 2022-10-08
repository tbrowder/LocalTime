use Test;

#use LocalTime;
use F;
use Timezones::US;

class T-LocalTime {
    has $.tz-abbrev;
    has $.tz-name = '';
    has $.dt;

    submethod TWEAK(:$tz-abbrev, :&formatter, |c) {
        # determine the formatter

        # now get a DateTime object
        $!dt = DateTime.new(:&formatter, |c); 
    }
    method year     { self.dt.year     }
    method month    { self.dt.month    }
    method day      { self.dt.day      }
    method hour     { self.dt.hour     }
    method minute   { self.dt.minute   }
    method second   { self.dt.second   }
    method timezone { self.dt.timezone }
    method Str      { self.dt.Str      }
    method local    { self.dt.local    }
}

for @tz -> $tz is copy {
    $tz .= uc;
    my $formatter = $::("F::$tz");

    my $dt;
    lives-ok {
        $dt = T-LocalTime.new: :$formatter, :2022year;
    }
    is $dt.year, 2022;
}

done-testing;
