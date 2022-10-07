#!/usr/bin/env raku

use Timezones::US;

# modes
my $create = 0;
my $show   = 0;
my $exe    = 0;
# options
my $force  = 0;
my $debug  = 0;

my $mod-fil = 'F.rakumod';
my $mod-nam = 'F';
if not @*ARGS {
    print qq:to/HERE/;
    Usage: {$*PROGRAM.basename} create | show | exe [options: force debug]

    Modes:
      create - Creates a module of DateTime formatting objects
               for use by users of modules 'Timezones::Universal'
               and 'Timezones::US'. The file is named '$mod-fil'.

      show   - Shows the formatter names (keys).

      exe    - Test using the exported formatters in './Ftest.rakumod'.

    Options:
      force  - Forces overwriting files
      debug  - For developer use

    Currently the only TZ-specific formatters are for
      the US as found in module 'Timezones::US' but
      there are also formtters usable for TZs given 
      as integral hour offsets from the Prime Meridian.
    HERE
    exit;
}

for @*ARGS {
    when /^c/ { ++$create }
    when /^s/ { ++$show   }
    when /^e/ { ++$exe    }
    when /^f/ { ++$force  }
    when /^d/ { ++$debug  }
    default {
        die "Unknown arg '$_'";
    }
}

if $show {
    #| US abbreviation first
    for @tz.sort -> $tz {
        my $st = $tz.uc;
        my $dt = $st;
        $dt ~~ s/ST$/DT/;
        say "  $st";
        say "  $dt";
    }
    #| Then hours of UTC offset
    for 12...1 {
        say "  $_";
    }
    for 0...-12 {
        say "  $_";
    }
} 

sub write-formatter($fh, :$name!, :$tz-info = '') {
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
}

if $create {
    ; # ok for now
    my $fh;
    if $force {
        $fh = open $mod-fil, :w;
    }
    else {
        try { 
            $fh = open $mod-fil, :x; 
        }
        if $! {
            note "FATAL: You must use option 'force' to overwrite an existing file.'";
            exit;
        }
    }
    $fh.say: qq:to/HERE/;
    #| Formatters for DateTime classes
    unit module $mod-nam;
    HERE
    write-formatter($fh, :name("no-tz-info"));

    #| US abbreviation first
    for @tz.sort -> $tz {
        my $XST = $tz.uc;
        my $XDT = $XST;
        $XDT ~~ s/ST$/DT/;
        write-formatter($fh, :name($XST), :tz-info($XST));
        write-formatter($fh, :name($XDT), :tz-info($XDT));
    }

    #| Then hours of UTC offset
    #|   2022-01-01T00:00:00 Local Time (UTC -4 hrs)
    for 12...1 -> $hr {
        my $name = "p$hr";
        my $tz-info = "Local Time (UTC +$hr hrs)";
        write-formatter($fh, :$name, :$tz-info);
    }
    {
        my $tz-info = "Local Time (UTC)";
        my $hr = 0;
        $tz-info = "Local Time (UTC)" if $hr == 0;
        # create several possibilities
        my $m0   = "m0";
        my $p0   = "p0";
        my $utc  = "UTC";
        my $zulu = "Z";
        for ($m0, $p0, $utc, $zulu) -> $name {
            write-formatter($fh, :$name, :$tz-info);
        }
    }
    for -1...-12 -> $hr is copy {
        my $tz-info = "Local Time (UTC $hr hrs)";
        $hr *= -1;
        my $name = "m$hr";
        write-formatter($fh, :$name, :$tz-info);
    }
    
    $fh.close;
    say "See new formatter file '$mod-fil'.";
}

if $exe {
    use lib ".";
    use Ftest;

    my $pkg = "Ftest::CST";
    my $cst = $::($pkg);
    my $dt;
    $dt = DateTime.new: :2022year, :formatter($cst);
    say $dt.Str;
    $dt = DateTime.new: :2022year;
    say $dt.Str;
}
