#==== VERSION 3 =====

#| A wrapper around a DateTime object
unit class LocalTime;

# To adjust for DST if applicable and use US abbreviations
use Timezones::US;
# To create unique class names for formatter creation
use UUID::V4;

has          $.tz-abbrev = '';      # lower case, index into %tzones
has          $.TZ-ABBREV = '';      # upper case: the formatter constant, may be in ST or DT form
has          $.tz-abbrev-orig = ''; # the original entry
has          $.tz-name = '';

has DateTime $.dt;
has          $.mode = 0;
has          $.formatter;

submethod TWEAK(:$tz-abbrev is copy, |c) {

    # We need the time entered by the user. We'll modify it after we
    # determine the proper formatter and timezone to use. We should be
    # able to do that with the '.clone' method.
    $!dt = DateTime.new(|c);

    # working vars for modes 0-3
    my $mode0 = 0; # not $!tz-abbrev.defined or $!tz-abbrev eq ''
                   #   set $tz-info = ''
    my $mode1 = 0; # $!tz-abbrev = some valid US entry     test $mode2 ~~ Str
                   #   set $tz-info = 'CST'
    my $mode2 = 0; # $!tz-abbrev = some non-valid US entry  test $mode2 ~~ Str
                   #   set $tz-info = 'as entered.uc'
    my $mode3 = 0; # $!tz-abbrev.defined but no value      test $mode4 ~~ Bool, value True
                   #   set $tz-info = 'Local Time (UTC +/-$n hrs)'

    #| Working vars to pass to DateTime
    my $tz-info;              # used for formatter class construction
    my $formatter;

    # the initial entry is kept for possible need for non-US time zone abbrevs
    $!tz-abbrev-orig = $tz-abbrev;

    my $mode;
    if (not $tz-abbrev.defined) or ($tz-abbrev eq '')  {
        $mode = 0;
        # $mode 0   not $!tz-abbrev.defined or $!tz-abbrev eq ''
        #             set $tz-info = ''
        $formatter = self.gen-fmt-class;
        $tz-info   = '';
    }
    elsif $tz-abbrev ~~ Str {
        # mode 1 or 2
        # get in shape to be a %tzones hash key (lower case, standard time, e.g., cst)

        # ensure %tzones key is lower-case
        $tz-abbrev .= lc;
        $tz-abbrev ~~ s/dt$/st/; # TODO: affect on non-US?

        # set the class attrs
        $!tz-abbrev = $tz-abbrev;
        # create the upper-case version
        $!TZ-ABBREV = $tz-abbrev.uc;

        # note we have NOT determined the actual DST status yet
        if %tzones{$tz-abbrev}:exists {
            $mode = 1;
            # $mode 1   $!tz-abbrev = some valid US entry     test $mode2 ~~ Str
            #             set $tz-info = 'CST'
            # check DST status
            if is-dst(:localtime($!dt.local)) {
                # change per DST
                # update the pertinent class attrs
                $!tz-name   ~~ s/Standard/Daylight/;
                $!TZ-ABBREV ~~ s/ST$/DT/;

                # set the formatter constant
                $tz-info = $!TZ-ABBREV;
            }
            else {
                # set the formatter constant
                $tz-info   = $!TZ-ABBREV;
            }
            $formatter = self.gen-fmt-class(:$tz-info);
        }
        else {
            $mode = 2;
            # $mode 2   $!tz-abbrev = some non-valid US entry  test $mode2 ~~ Str
            #             set $tz-info = 'as entered.uc'
            $tz-info   = $!tz-abbrev-orig.uc;
            $formatter = self.gen-fmt-class(:$tz-info);
        }
    }
    elsif $!tz-abbrev ~~ Bool {
        $mode = 3;
        # $mode 3   $!tz-abbrev.defined but no value      test $mode3 ~~ Bool, value True
        #             set $tz-info = 'Local Time (UTC +/-$n hrs)'
        my $tz-offset = $*TZ div SEC-PER-HOUR;
        my $sign = '' if $tz-offset < 0;
        $sign = '+' if $tz-offset > 0;
        if $tz-offset {
            $tz-info = "Local Time (UTC $sign$tz-offset hrs)";
        }
        else {
            $tz-info = "Local Time (UTC)";
        }
        $formatter = self.gen-fmt-class(:$tz-info);
    }
    else {
        die "FATAL: All possibilities exhausted.";
    }

    if not $formatter.defined {
        # SAFETY PLAY
        die "FATAL: No formatter was created.";
    }

    $!mode = $mode;

    # Finally, get a NEW DateTime object for the time components
    # AFTER the formatter and timezone values have been determined.
    # Clone the original one:

    # save the formatter for external use with a DateTime object
    $!formatter = $formatter;
    $!dt .= clone(:$formatter);

} # end of submethod TWEAK

# dup the DateTime methods
method year         { self.dt.year         }
method month        { self.dt.month        }
method day          { self.dt.day          }
method hour         { self.dt.hour         }
method minute       { self.dt.minute       }
method second       { self.dt.second       }
method timezone     { self.dt.timezone     }
method Str          { self.dt.Str          }
method local        { self.dt.local        }
method hh-mm-ss     { self.dt.hh-mm-ss     }
method offset       { self.dt.offset       }
method utc          { self.dt.utc          }
method in-timezone  { self.dt.in-timezone  }
method Instant      { self.dt.Instant      }
method truncated-to { self.dt.truncated-to }


=begin comment
# working vars for modes 0-3
mode 0: not $!tz-abbrev.defined or $!tz-abbrev eq ''
        action: set $tz-info = ''
mode 1: $!tz-abbrev eq some valid US entry
        test:   $!tz-abbrev ~~ Str
        action: set $tz-info = 'CST'

mode 2: $!tz-abbrev eq some non-valid US entry
        test:   $!tz-abbrev ~~ Str
        action: set $tz-info = 'as entered.uc'

mode 3: $!tz-abbrev.defined but no value
        test:   $!tz-abbrev $mode4 ~~ Bool, value True
        action: set $tz-info = 'Local Time (UTC +/-$n hrs)'
=end comment

method gen-fmt-class(
                  :$tz-abbrev,    # determines mode (0-3)
                  :$tz-info = '', # needed for actual formatter class construction
                  :$debug,
                 ) {

    #| A class generator factory for DateTime formatters.
    #| Formatter class names are random until @tonyo or other person
    #| can improve on that.

    my $class = self.uuid2cname("{uuid-v4}");
    use MONKEY-SEE-NO-EVAL;
    my $fmt = qq:to/HERE/;
    class $class does Callable \{
    HERE
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
    $fmt = EVAL $fmt;
    my $formatter = $fmt.new;
    $formatter
} # sub gen-fmt-class

method uuid2cname($uuid --> Str) {
    my $cname = $uuid;

    my @c = ('a'..'z').list;
    @c.push: |('A'..'Z').list;

    my @p = split '-', $cname;
    my @cname;
    while @p.elems {
        my $c = @c.pick(1);
        my $p = @p.shift;
        $p ~~ s/^\d/$c/;
        @cname.push: $p;
    }
    $cname = @cname.join: '-';
}
