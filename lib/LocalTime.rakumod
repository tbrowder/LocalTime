#==== VERSION 3 =====

#| A wrapper around a DateTime object
unit class LocalTime; # is DateTime;

# to adjust for DST if applicable and use US abbreviations
use Timezones::US;
use F; # formatters for various time zones

has          $.tz-abbrev;
has          $.tz-name = '';
has DateTime $.dt;
has          $.mode = 0;

submethod TWEAK(:$tz-abbrev, |c) {
    # Create a temporary directory as a place for a temporary module
    # for dynamic formatters
    use File::Temp;
    my $tdir = tempdir;
    %*ENV<RAKUDOLIB> = $tdir;
    my $tmodfil = "$tdir/Ftemp.rakumod";
    my $fh = open $tmodfil, :w;
    $fh.say: "unit module Ftemp;";
    $fh.close;
    use Ftemp;


    # We need the time entered by the user. We'll modify
    # it after we determine the proper formatter and
    # timezone to use. We should be able to do that
    # with the '.clone' method.
    $!dt = DateTime.new(|c); 

    #| Working vars to pass to DateTime
    #|   The default no-info formatter
    my $formatter = $::("F::no-tz-info");
    #|   The default timezone
    my $timezone; # don't define it until needed

    # working vars for modes 0-3
    my $mode0 = 0; # not $!tz-abbrev.defined or $!tz-abbrev eq ''
    my $mode1 = 0; # $!tz-abbrev = some valid US entry     test $mode2 ~~ Str
    my $mode2 = 0; # $!tz-abbrev = some non-valid US entry  test $mode2 ~~ Str
    my $mode3 = 0; # $!tz-abbrev.defined but no value      test $mode4 ~~ Bool, value True
    my %m;
    %m<0> = 1; # the default

    # mode 0, 1, 2, or 3
    if not $!tz-abbrev.defined {
        ++$mode0;
        $!mode = 0;
        %m<0> = True;
    }
    elsif $!tz-abbrev ~~ Bool {
        # mode 3
        ++$mode3;
        $!mode = 3;
        %m<3> = True;
    }
    elsif $!tz-abbrev ~~ Str and $!tz-abbrev eq '' {
        ++$mode0;
        $!mode = 0;
        %m<0> = True;
    }
    elsif $!tz-abbrev ~~ Str {
        # mode 1 or 2
        # for time zone lookup
        my $tmp = $!tz-abbrev.lc;
        $tmp ~~ s/dt$/st/;
        if %tzones{$tmp}:exists {
            # mode 1
            ++$mode1;
            $!mode = 1;
            %m<1> = True;
            $!tz-abbrev = $tmp; # keep lc and xst format temporarily

            #$timezone = %tzones{$!tz-abbrev}<utc-offset>;
            #$timezone *= SEC-PER-HOUR;

            $!tz-name = %tzones{$!tz-abbrev}<name>;
            $!tz-abbrev .= uc;
            if is-dst(:localtime($!dt.local)) {
                # change per DST
            #    $timezone -= SEC-PER-HOUR;
                $!tz-abbrev ~~ s/ST$/DT/;
                $!tz-name   ~~ s/Standard/Daylight/;
            }
            else {
                # correct the abbrev if necessary
                $!tz-abbrev ~~ s/DT$/ST/;
                $!tz-name   ~~ s/Daylight/Standard/;
            }
            $formatter = $::("F::$!tz-abbrev");
        }
        else {
            # mode 2
            ++$mode2;
            $!mode = 2;
            %m<2> = True;
            # leave the $!tz-abbrev entry as is for now
            # $!tz-abbrev .= uc;
            
            # define the formatter
            my $fkey = '$' ~ $!tz-abbrev;
            # create a module for one-time use
            self.write-temp-formatter($fh, :name($fkey), :tz-info($!tz-abbrev)); 
            $fh.close;
            $formatter = $::("Ftemp::$!tz-abbrev");
        }
    }

    die "FATAL: Unable to determine a mode." if not ($mode0 or $mode1 or $mode2 or $mode3);
    if %m.elems > 1 {
         my $s = %m.keys.sort.join(', ');
         note "FATAL: Multiple modes found: $s"; 
         die  "Bailing out!";
    }

    if $mode0 or $mode1 or $mode2 {
        # details are already determined
        ; # ok
    }
    elsif $mode3 {
        # use $*TZ
        my $tz = $*TZ;
        $tz = $tz div SEC-PER-HOUR;
        my $fkey;
        if $tz < 0  {
            $fkey = "m$tz";
        }
        else {
            $fkey = "p$tz";
        }
        $formatter = $::("F::$fkey");
    }

    # Finally, get a NEW DateTime object for the time components
    # AFTER the formatter and timezone values have been determined.
    if $timezone.defined {
        $!dt = DateTime.new(:$timezone, :$formatter, |c); 
    }
    else {
        $!dt = DateTime.new(:$formatter, |c); 
    }

} # end of submethod TWEAK

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

method write-temp-formatter($fh, :$name!, :$tz-info = '') {
    # note the 'our' is required, but no 'export'
    $fh.say:   "our \${$name} = sub (\$self) \{"; 
    $fh.print: '    sprintf "%04d-%02d-%02dT%02d:%02d:%02d'; # <= note no closing "
    if $tz-info {
        $fh.print: " $tz-info";
    }
    # close the format string (don't forget the trailing comma!!)
    $fh.say: '",';
    
    $fh.say:   '    .year, .month, .day, .hour, .minute, .second given $self'; 
    $fh.say:   '}';
    $fh.close:
}
