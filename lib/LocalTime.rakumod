#==== VERSION 3 =====

#| A wrapper around a DateTime object
unit class LocalTime; 

# to adjust for DST if applicable and use US abbreviations
use Timezones::US;

has          $.tz-abbrev;     # lower case, index into %tzones
has          $.TZ-ABBREV;     # upper case
has          $.TZ-ABBREV-DST; # upper case
has          $.tz-name = '';
has          $.tz-abbrev-orig;

has DateTime $.dt;
has          $.mode = 0;
has          %.fclass;  #| Keep track of generated formatters

submethod TWEAK(:$tz-abbrev, |c) {
    # trying a better way to determine mode
    # sets all $tz-* if a US entry
    # sets some $tz-* otherwise

    my $Mode = self!get-mode(:$!tz-abbrev, :%tzones);

    # We need the time entered by the user. We'll modify it after we
    # determine the proper formatter and timezone to use. We should be
    # able to do that with the '.clone' method.
    $!dt = DateTime.new(|c);

    #| Working vars to pass to DateTime
    #|   The default no-info formatter
    =begin comment
    my $formatter = $::("F::no-tz-info");
    =end comment

    my $tz-info;   # used for formatter class construction
    my $formatter;

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
    # see code extracted from here in file 'SAVED-CODE'
    #=============================================================

    # get the appropriate formatter
    if $!mode == 0 {
        # $mode 0   not $!tz-abbrev.defined or $!tz-abbrev eq ''
        #             set $tz-info = ''
    }
    elsif $!mode == 1 {
        # $mode 1   $!tz-abbrev = some valid US entry     test $mode2 ~~ Str
        #             set $tz-info = 'CST'
    }
    elsif $!mode == 2 {
        # $mode 2   $!tz-abbrev = some non-valid US entry  test $mode2 ~~ Str
        #             set $tz-info = 'as entered.uc'
    }
    elsif $!mode == 3 {
        # $mode 3   $!tz-abbrev.defined but no value      test $mode4 ~~ Bool, value True
        #             set $tz-info = 'Local Time (UTC +/-$n hrs)'
    }
    else {
        die "FATAL: Unable to determine a mode."
    }

    # Finally, get a NEW DateTime object for the time components
    # AFTER the formatter and timezone values have been determined.
    # Clone the original one:

    # SAFETY PLAY
    if not $formatter.defined {
        $!dt;
    }
    else {
        if $timezone.defined {
            $!dt .= clone(:$timezone, :$formatter);
        }
        else {
            $!dt .= clone(:$formatter);
        }
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
    $!tz-abbrev-orig = $!tz-abbrev;

    my $tz-abbrev = $!tz-abbrev;
    my $mode;
    if not $tz-abbrev.defined {
        $mode = 0;
    }
    elsif $tz-abbrev eq '' {
        $mode = 0;
    }
    elsif $!tz-abbrev ~~ Str {
        # get in shape to be a %tzones hash key (lower case, CST)
        $tz-abbrev .= lc;
        $tz-abbrev ~~ s/dt$/st/; # TODO: affect on non-US?
        $!tz-abbrev = $tz-abbrev;
        $!TZ-ABBREV = $tz-abbrev.uc;

        if %tzones{$!tz-abbrev}:exists {
            $mode = 1;
            $!TZ-ABBREV-DST = $!TZ-ABBREV;
            $!TZ-ABBREV-DST ~~ s/ST$/DT/;
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

method gen-fmt-class(
                  :$class!,      # must not have ANY spaces, must be unique
                  :$tz-abbrev,    # determines mode (0-3)
                  :$tz-info = '', # needed for actual formatter class construction
                  :$debug,
                 ) {

    #| An exportable class generator factory for DateTime formatters.
    #| The caller must ensure the class name is unique.
    #| Passing in a hash of generated names provides that
    #| that capability.
    #|
#    #| Note that classes will have "LocalTime::" prefixed to their names.

    use MONKEY-SEE-NO-EVAL;
    if self.fclass{$class}:exists {
        # return it
        return self.fclass{$class};
    }
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
    EVAL $fmt
} # sub gen-fmt-class
