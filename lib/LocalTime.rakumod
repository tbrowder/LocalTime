#==== VERSION 3 =====

#| A wrapper around a DateTime object
unit class LocalTime; 

# To adjust for DST if applicable and use US abbreviations
use Timezones::US;
# To create unique class names for formatter creation
use UUID::V4;

has          $.tz-abbrev;      # lower case, index into %tzones
has          $.TZ-ABBREV;      # upper case
has          $.TZ-ABBREV-DST;  # upper case in form ~~ s/ST$/DT/ 
has          $.tz-abbrev-orig; # the original entry
has          $.tz-name = '';

has DateTime $.dt;
has          $.mode = 0;
has          $.formatter;

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
        $formatter = self.gen-fmt-class;
        $tz-info   = '';
    }
    elsif $!mode == 1 {
        # $mode 1   $!tz-abbrev = some valid US entry     test $mode2 ~~ Str
        #             set $tz-info = 'CST'
        $tz-info   = $!TZ-ABBREV;
        $formatter = self.gen-fmt-class(:$tz-info);
    }
    elsif $!mode == 2 {
        # $mode 2   $!tz-abbrev = some non-valid US entry  test $mode2 ~~ Str
        #             set $tz-info = 'as entered.uc'
        $tz-info   = $!tz-abbrev-orig.uc;
        $formatter = self.gen-fmt-class(:$tz-info);
    }
    elsif $!mode == 3 {
        # $mode 3   $!tz-abbrev.defined but no value      test $mode4 ~~ Bool, value True
        #             set $tz-info = 'Local Time (UTC +/-$n hrs)'
        my $tz-offset = $*TZ div SEC-PER-HOUR;
        my $sign = '-' if $tz-offset < 0;
        $sign = '+' if $tz-offset > 0;
        if $tz-offset {
            $tz-info = "Local Time (UTC $sign hrs)";
        }
        else {
            $tz-info = "Local Time (UTC)";
        }
        $formatter = self.gen-fmt-class(:$tz-info);
    }
    else {
        die "FATAL: Unable to determine a mode."
    }

    # Finally, get a NEW DateTime object for the time components
    # AFTER the formatter and timezone values have been determined.
    # Clone the original one:

    $!formatter = $formatter;

    if not $formatter.defined {
        # SAFETY PLAY
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
#                  :$class!,      # must not have ANY spaces, must be unique
                  :$tz-abbrev,    # determines mode (0-3)
                  :$tz-info = '', # needed for actual formatter class construction
                  :$debug,
                 ) {

    #| An exportable class generator factory for DateTime formatters.
    #| The caller must ensure the class name is unique.
    #| Passing in a hash of generated names provides that
    #| that capability.
    #|

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
    #EVAL $fmt
    $fmt = EVAL $fmt;
    my $formatter = $fmt.new; 
    $formatter
} # sub gen-fmt-class

method uuid2cname($uuid --> Str) {
    my $cname = $uuid;
    my $ca = 'a'..'z';
    my $cA = 'A'..'Z';
    my @c;
    @c.push($_) for $ca.list;
    @c.push($_) for $cA.list;
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
