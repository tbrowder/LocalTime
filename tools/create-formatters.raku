#!/usr/bin/env raku

use Timezones::US;

# modes
my $create = 0;
my $show   = 0;
# options
my $force  = 0;
my $debug  = 0;

my $mod = 'TZ-formatters.rakumod';
if not @*ARGS {
    print qq:to/HERE/;
    Usage: {$*PROGRAM.basename} create | show [options: force debug]

    Modes:
      create - Creates a module of DateTime formatting objects
               for use by users of module 'Timezones::Universal'.
               The file is named '$mod'.

      show   - Shows the formatter names (keys).

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
    for 12...1 {
        say "  $_";
    }
    for 0...-12 {
        say "  $_";
    }

} 

if $create {
}


