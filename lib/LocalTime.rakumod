unit class LocalTime is DateTime;

use Timezones::US; # to adjust for DST if applicable and use US abbreviations

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

# New formatters:
my $lt-format1 = sub ($self, :$tz-abbrev) {
    # use local timezone abbreviation
    sprintf "%04d-%02d-%02dT%02d:%02d:%02d {$tz-abbrev}", 
        .year, .month, .day, .hour, .minute, .second
        given $self;
};

my $lt-format2 = sub ($self) {
    # use NO local timezone abbreviation
    sprintf "%04d-%02d-%02dT%02d:%02d:%02d", 
        .year, .month, .day, .hour, .minute, .second
        given $self;
};

method new(:$tz-abbrev, |c) {
    if not $tz-abbrev.defined {
        # a normal instantiation is expected, otherwise an exception is thrown
        return self.DateTime::new(:formatter($lt-format2), |c); 
    }

    # get the correct offset in seconds from UTC for the TZ

    self.DateTime::new(:formatter($lt-format1), |c); 
}

=begin comment
submethod TWEAK {
    if $!tz-abbrev.defined {
        # use it 
    }
    else {
        # default formatter2
        $!abbrev = $!tz-abbrev;
    }
}
=end comment

