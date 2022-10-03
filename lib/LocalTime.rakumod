unit class LocalTime is DateTime;

# to adjust for DST if applicable and use US abbreviations
use Timezones::US;

use Formatters;
# New formatters:
my $with-tz-abbrev = $Formatters::with-tz-abbrev;
my $no-tz-abbrev   = $Formatters::no-tz-abbrev;

# See DateTime::Julian for how to create
# a subclass with a "new" method with
# a different signature.
# 
# Uses the following variable as defined by input.
# If not entered, the default DateTime and its formatter
# are used.
#   $tz-abbrev, # converts to offset in seconds from UTC

# As a subclass, it already has the
# attributes and methods of its parent
# class, but we can create our own
# versions as necessary.

has Str $.tz-abbrev;
has Str $.tz-name;
has Str $.non-us;

method new(:$tz-abbrev, :$tz-name, :$non-us, |c) {
    if not ($tz-abbrev.defined or $tz-name.defined or $non-us.defined) {
        # a normal DateTime instantiation is expected, otherwise an exception is thrown
        # but note the formatter leaves off any suffix indicating TZ or local time
        self.DateTime::new(:formatter($no-tz-abbrev), |c); 
    }
    else {
        self.DateTime::new(:formatter($with-tz-abbrev), |c); 
    }
}

submethod TWEAK {

    # the four modes of operation
    =begin comment
    1. The default format for C<LocalTime> with no time zone entry:
    $ say LocalTime.new: :2022year;
    2022-01-01T00:00:00
    =end comment

    =begin comment
    2. The default format for C<LocalTime> with 'CST' entered:
    $ say LocalTime.new: :2022year, :tz-abbrev('CST');
    2022-01-01T00:00:00 CST 
    =end comment

    =begin comment
    3. The format for C<LocalTime> with a non-US TZ abbreviation entered:
    $ say LocalTime.new: :2022year, :tz-abbrev('XYT');
    2022-01-01T00:00:00 XYT
    =end comment

    =begin comment
    4. The format for C<LocalTime> with an empty C<:tz-abbrev> named argument
    $ say LocalTime.new: :2022year, :tz-abbrev;
    2022-01-01T00:00:00 Local Time (UTC -4 hrs)
    =end comment

    # named arg vars
    my $tza = $!tz-abbrev;
    my $timezone = 0; # default for DateTime's :timezone attribute

    # working vars for modes 1-4
    my $mode1 = 0; # not $tza.defined
    my $mode2 = 0; # $tza = some valid US entry     test $mode2 ~~ Str
    my $mode3 = 0; # $tza = some non-vald US entry  test $mode2 ~~ Str
    my $mode4 = 0; # $tza.defined but no value      test $mode4 ~~ Bool, value True

    if not $tza.defined {
        # mode 1
        ++$mode1;
    }
    elsif $tza.defined {
        # mode 2, 3, or 4
        if $tza ~~ Bool {
            # mode 4
            ++$mode4;
        }
        elsif $tza ~~ Str {
            # mode 2 or 3
            if %tzones{}:exists {
                # mode 2
            }
            else {
                # mode 3
            }
        }

        # make sure it's recognized and ensure it's in Xst format
        $tza .= lc;
        $tza ~~ s/dt$/st/;
        # using Timezones::US
        if %tzones{$tza}:exists {
            $!tz-name = %tzones{$tza}<name>; 

            # convert the $!timezone value to the correct number 
            # of seconds from UTC (corrected for DST if appropriate)
            my $tz-offset = %tzones{$tza}<utc-offset>; # hours 
            $tz-offset   *= SEC-PER-HOUR;
            =begin comment
            if is-dst(:localtime(self)) {
                note "DEBUG is-dst";
            }
            else {
                note "DEBUG is-NOT-dst";
            }
            =end comment
        }
        else {
            # fix it farther down
            ++$tza-non-us;
        }
    }

    if $nus.defined or $tza-non-us {
        # non-us may have a value
        $!tz-abbrev = 'PST';
  
    }
    elsif $*TZ.defined {
        # use the $*TZ value to determine the correct abbreviation
        my $zsec  = $*TZ;
        my $zhr   = $zsec div SEC-PER-HOUR;
        my $tznam;
        if %offsets-utc{$zhr}:exists {
            $tznam = %offsets-utc{$zhr}.uc;
            $!tz-abbrev = $tznam;
        }
        else {
            $!tz-abbrev = "UTC";
        }
        
    }
    else {
        # use the current value of $!timezone
        die "FATAL - TODO fix this";
    }
}
