#==== VERSION 2 =====

unit class LocalTime is DateTime;

# to adjust for DST if applicable and use US abbreviations
use Timezones::US;
use F; # formatters for various time zones

# See DateTime::Julian for how to create
# a subclass with a "new" method with
# a different signature.
 
# Uses the following variable as defined by input.
# If not entered, the default DateTime and its formatter
# are used.
#   $tz-abbrev, # converts to offset in seconds from UTC

# As a subclass, it already has the
# attributes and methods of its parent
# class, but we can create our own
# local versions inside "new" as necessary
# and use them to instantiate the existing
# DateTime.

has Str $.tz-abbrev;
has Str $.tz-name  = '';

# attributes from the parent class
has     $.timezone = 0;

method new(:$tz-abbrev, |c) {

    # default LocalTime named arg vars
    my $tza    = $!tz-abbrev;

    # working vars for modes 0-3
    my $mode0 = 0; # not $tza.defined or $tza eq ''
    my $mode1 = 0; # $tza = some valid US entry     test $mode2 ~~ Str
    my $mode2 = 0; # $tza = some non-vald US entry  test $mode2 ~~ Str
    my $mode3 = 0; # $tza.defined but no value      test $mode4 ~~ Bool, value True

    #| The default no-info formatter
    my $formatter = $F::no-tz-info;

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
            $!timezone = %tzones{$tza}<utc-offset>;
            $!timezone *= SEC-PER-HOUR;
            $!tz-name = %tzones{$tza}<name>;
            $!tz-abbrev .= uc;
            if is-dst(:localtime(self.new)) {
                # change per DST
                $!timezone -= SEC-PER-HOUR;
                $!tz-abbrev ~~ s/ST$/DT/;
                $!tz-name   ~~ s/Standard/Daylight/;
            }
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

    if (not $tz-abbrev.defined) or $tz-abbrev eq '' {
        #| A normal DateTime instantiation is expected, otherwise an exception is thrown
        #| but note the formatter leaves off any suffix indicating TZ or local time
        self.DateTime::new(:$formatter, |c); 
    }
    else {
        #| The self.tz-abbrev value is used here:
        self.DateTime::new(:$!timezone, :formatter($with-tz-abbrev), |c); 
    }
}

=begin comment
submethod TWEAK {

    # the four modes of operation
    =begin comment
    0. The default format for C<LocalTime> with no time zone entry:
    $ say LocalTime.new: :2022year;
    2022-01-01T00:00:00
    =end comment

    =begin comment
    1. The default format for C<LocalTime> with 'CST' entered:
    $ say LocalTime.new: :2022year, :tz-abbrev('CST');
    2022-01-01T00:00:00 CST 
    =end comment

    =begin comment
    2. The format for C<LocalTime> with a non-US TZ abbreviation entered:
    $ say LocalTime.new: :2022year, :tz-abbrev('XYT');
    2022-01-01T00:00:00 XYT
    =end comment

    =begin comment
    3. The format for C<LocalTime> with an empty C<:tz-abbrev> named argument
    $ say LocalTime.new: :2022year, :tz-abbrev;
    2022-01-01T00:00:00 Local Time (UTC -4 hrs)
    =end comment

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
            $!timezone = %tzones{$tza}<utc-offset>;
            $!timezone *= SEC-PER-HOUR;
            $!tz-name = %tzones{$tza}<name>;
            $!tz-abbrev .= uc;
            if is-dst(:localtime(self.new)) {
                # change per DST
                $!timezone -= SEC-PER-HOUR;
                $!tz-abbrev ~~ s/ST$/DT/;
                $!tz-name   ~~ s/Standard/Daylight/;
            }
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

    =begin comment
    if $*TZ.defined {
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
    =end comment
}
=end comment
