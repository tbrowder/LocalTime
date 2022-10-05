#!/usr/bin/env raku

use Timezones::US;

# modes
my $create = 0;
my $show   = 0;
my $exe    = 0;
# options
my $force  = 0;
my $debug  = 0;

my $mod-fil = 'TZ-formatters.rakumod';
my $mod-nam = 'TZ-formatters';
if not @*ARGS {
    print qq:to/HERE/;
    Usage: {$*PROGRAM.basename} create | show | exe [options: force debug]

    Modes:
      create - Creates a module of DateTime formatting objects
               for use by users of module 'Timezones::Universal'.
               The file is named '$mod-fil'.

      show   - Shows the formatter names (keys).

      exe    - Try using the exported formatters.

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
    $fh.say:   "our \${$name} = sub(\$self) \{"; 
    $fh.print: '    sprintf "%04d-%02d-%02dT%02d:%02d:%02d"'; 
    if $tz-info {
        $fh.say: " $tz-info";
    }
    else {
        $fh.say();
    }
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
        $fh = open $mod-fil, :x;
    }
    $fh.say: "unit module $mod-nam;";

    #| US abbreviation first
    for @tz.sort -> $tz {
        my $XST = $tz.uc;
        my $XDT = $XST;
        $XDT ~~ s/ST$/DT/;
        write-formatter($fh, :name($XST), :tz-info($XST));
        write-formatter($fh, :name($XDT), :tz-info($XDT));
    }

    #| Then hours of UTC offset
    for 12...1 -> $hr {
        my $name = "p$hr";
        my $tz-info = "";
        write-formatter($fh, :$name, :$tz-info);
    }
    for 0...-12 -> $hr is copy {
        $hr *= -1;
        my $name = "m$hr";
        my $tz-info = "";
        write-formatter($fh, :$name, :$tz-info);
    }
    
    $fh.close;
    say "See new formatter file '$mod-fil'.";
}

if $exe {
    use lib ".";
    use F;

    my $cst = $F::CST;
    my $dt;
    $dt = DateTime.new: :2022year, :formatter($cst);
    say $dt.Str;
    $dt = DateTime.new: :2022year;
    say $dt.Str;
}
