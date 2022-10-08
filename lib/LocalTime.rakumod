#==== VERSION 3 =====

unit class LocalTime; # is DateTime;

# to adjust for DST if applicable and use US abbreviations
use Timezones::US;
use F; # formatters for various time zones

has Str $.tz-abbrev;
has Str $.tz-name = '';
has     $.dt;

submethod TWEAK(:$tz-abbrev, |c) {
    # determine the formatter and $tz-name
    #|   The default no-info formatter
    my $formatter = $::("F::no-tz-info");

    # now get a DateTime object for the time components
    $!dt = DateTime.new(|c); 

    # default LocalTime named arg vars
    my $tza    = $!tz-abbrev;

    # working vars for modes 0-3
    my $mode0 = 0; # not $tza.defined or $tza eq ''
    my $mode1 = 0; # $tza = some valid US entry     test $mode2 ~~ Str
    my $mode2 = 0; # $tza = some non-vald US entry  test $mode2 ~~ Str
    my $mode3 = 0; # $tza.defined but no value      test $mode4 ~~ Bool, value True

    # mode 0, 1, 2, or 3
    if not $tza.defined {
        ++$mode0;
    }
    elsif $tza ~~ Bool {
        # mode 3
        ++$mode3;
    }
    elsif $tza ~~ Str and $tza eq '' {
        ++$mode0;
    }
    elsif $tza ~~ Str {
        # mode 1 or 2
        my $tmp = $tza.lc;
        $tmp ~~ s/dt$/st/;
        if %tzones{$tza.lc}:exists {
            # mode 1
            ++$mode1;
            $tza = $tmp; # keep lc and xst format temporarily
            $!tz-name = %tzones{$tza}<name>;
            $!tz-abbrev .= uc;
            if is-dst(:localtime($!dt.local)) {
                # change per DST
                $!tz-abbrev ~~ s/ST$/DT/;
                $!tz-name   ~~ s/Standard/Daylight/;
            }
            $formatter = $::("F::$!tz-abbrev");
        }
        else {
            # mode 2
            ++$mode2;
        }
    }

    die "FATAL: Unable to determine a mode." if not ($mode0 or $mode1 or $mode2 or $mode3);

    if $mode1 {
        # US time zone
        # details are already determined
        die "FATAL: NYI" if $!tz-abbrev eq 'NYI';
    }
    else {
        $!tz-abbrev = 'NYI';
    }
}

# dup the DateTime methods
method year     { self.dt.year     }
method month    { self.dt.month    }
method day      { self.dt.day      }
method hour     { self.dt.hour     }
method minute   { self.dt.minute   }
method second   { self.dt.second   }
method timezone { self.dt.timezone }
method Str      { self.dt.Str      }
method local    { self.dt.local    }
