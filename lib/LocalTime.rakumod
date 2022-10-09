#==== VERSION 3 =====

#| A wrapper around a DateTime object
unit class LocalTime; # is DateTime;

# to adjust for DST if applicable and use US abbreviations
use Timezones::US;
=begin comment
# trying to use only dynamically generated formatters
use F; # formatters for various time zones
=end comment

has          $.tz-abbrev;
has          $.tz-name = '';
has DateTime $.dt;
has          $.mode = 0;
has          %.class-names;  #| Keep track of generated formatters

submethod TWEAK(:$tz-abbrev, |c) {
    # trying a better way to determine mode
    my $Mode = self!get-mode(:$!tz-abbrev, :%tzones); 

    =begin comment
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
    =end comment


    # We need the time entered by the user. We'll modify it after we
    # determine the proper formatter and timezone to use. We should be
    # able to do that with the '.clone' method.
    $!dt = DateTime.new(|c);

    #| Working vars to pass to DateTime
    #|   The default no-info formatter
    =begin comment
    my $formatter = $::("F::no-tz-info");
    =end comment

    my $tz-info; # used for formatter class construction
    #my $def-fmt-name = 'no-tz-info';
    #my $default-formatter = gen-fmt-class :class-names(%!class-names), :class-name($def-fmt-name);
    #my $formatter = $default-formatter;
    
    #|   The default timezone
    my $timezone; # don't define it unless needed (is it ever needed?)

    # working vars for modes 0-3
    my $mode0 = 0; # not $!tz-abbrev.defined or $!tz-abbrev eq ''
                   #   set $tz-info = ''
    my $mode1 = 0; # $!tz-abbrev = some valid US entry     test $mode2 ~~ Str
                   #   set $tz-info = 'CST'
    my $mode2 = 0; # $!tz-abbrev = some non-valid US entry  test $mode2 ~~ Str
                   #   set $tz-info = 'as entered.uc'
    my $mode3 = 0; # $!tz-abbrev.defined but no value      test $mode4 ~~ Bool, value True
                   #   set $tz-info = 'Local Time (UTC +/-$n hrs)'

    #=============================================================
    # SAVE THIS IN ANOTHER FILE FOR NOW
    =begin comment
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
            =begin comment
            $formatter = $::("F::$!tz-abbrev");
            =end comment
            $formatter = gen-fmt-class :classnames(%!class-names), :class-name($!tz-abbrev);
        }
        else {
            # mode 2
            ++$mode2;
            $!mode = 2;
            %m<2> = True;
            # leave the $!tz-abbrev entry as is for now
            # $!tz-abbrev .= uc;

            # define the formatter
            =begin comment
            my $fkey = '$' ~ $!tz-abbrev;
            # create a module for one-time use
            self.write-temp-formatter($fh, :name($fkey), :tz-info($!tz-abbrev));
            $fh.close;
            $formatter = $::("Ftemp::$!tz-abbrev");
            =end comment
            $formatter = gen-fmt-class :class-names(%!class-names), :class-name($!tz-abbrev);
        }
    }

    die "FATAL: Unable to determine a mode." if not ($mode0 or $mode1 or $mode2 or $mode3);
    if %m.elems > 1 {
         my $s = %m.keys.sort.join(', ');
         note "FATAL: Multiple modes found: $s";
         die  "Bailing out!";
    }

    die "FATAL: mode ($!mode) and Mode ($Mode) differ" if $!mode !== $Mode;

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
    =end comment
    #=============================================================

    # Finally, get a NEW DateTime object for the time components
    # AFTER the formatter and timezone values have been determined.
    # Clone the original one:
    if $timezone.defined {
        #$!dt = DateTime.new(:$timezone, :$formatter, |c);
        $!dt .= clone(:$timezone, :$formatter);
    }
    else {
        #$!dt = DateTime.new(:$formatter, |c);
        $!dt .= clone(:$formatter);
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

method !get-mode(:$!tz-abbrev!, :%tzones!) {
    my $mode;
    if not $!tz-abbrev.defined {
        $mode = 0;
    }
    elsif $!tz-abbrev eq '' {
        $mode = 0;
    }
    elsif $!tz-abbrev ~~ Str {
        if %tzones{$!tz-abbrev}:exists {
            $mode = 1;
        }
        else {
            $mode = 2;
        }
    }
    elsif $!tz-abbrev ~~ Bool {
        $mode = 3;
    }
    else {
        die "FATAL: All possibilities exhausted.";
    }
    $mode
}
    =begin comment
    # working vars for modes 0-3
    my $mode0 = 0; # not $!tz-abbrev.defined or $!tz-abbrev eq ''
    my $mode1 = 0; # $!tz-abbrev = some valid US entry     test $mode2 ~~ Str
    my $mode2 = 0; # $!tz-abbrev = some non-valid US entry  test $mode2 ~~ Str
    my $mode3 = 0; # $!tz-abbrev.defined but no value      test $mode4 ~~ Bool, value True
    =end comment

sub gen-fmt-class(:%class-names!, 
                  :$class-name!,  # must not have ANY spaces, must be unique
                  :$tz-abbrev,    # determines mode (0-3)
                  :$tz-info = ''  # needed for actual formatter class construction
                 ) is export(:gen-fmt-class) {
    #| An exportable class generator factory for DateTime formatters.
    #| The caller must ensure the class name is unique.
    #| Passing in a hash of generated names provides that
    #| that capability.

    use MONKEY-SEE-NO-EVAL;

    if %class-names{$class-name}:exists {
        # return it
        return %class-names{$class-name};
        die "FATAL: class $class-name already exists";
    }
    %class-names{$class-name} = True;
 
    my $fmt = qq:to/HERE/;
    class $class-name does Callable \{
    HERE
    $fmt .= chomp;

    $fmt ~= q:to/HERE/;
        submethod CALL-ME($self, |c) {
            sprintf "%04d-%02d-%02dT%02d:%02d:%02d
    HERE
    $fmt .= chomp;

    if $tz-info {
        $fmt ~= " $tz-info";
    }
    $fmt .= chomp;

    # close the format string (don't forget the trailing comma!!)
    $fmt ~= q:to/HERE/;
    ",
            .year, .month, .day, .hour, .minute, .second given $self
         }
    }
    HERE
    $fmt .= chomp;

    EVAL $fmt
} # sub gen-fmt-class

