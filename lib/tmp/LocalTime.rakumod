unit class LocalTime; # is DateTime;

# See DateTime::Julian for how to create
# a subclass with a "new" method with
# a different signature.
# 
# :tz-abbrev, # converts to offset in seconds from UTC
# :tz-long,   # converts to offset in seconds from UTC

has DateTime $.datetime is required;
has          $.us-tz-abbrev;

has DateTime $.localtime;

my $localtime-format = sub ($self) {
    sprintf "%04d-%02d-%02dT%02d:%02d:%02.2f", .year, .month, .day, .hour, .minute, .second
    given $self;
};

submethod TWEAK {
    my $t = $!datetime;
    $!localtime = DateTime.new: :year($t.year), :month($t.month), :day($t.day), :hour($t.hour), :minute($t.minute), :second($t.second),
                  :formatter($localtime-format);
}

method Str {
    sprintf "%04d-%02d-%02dT%02d:%02d:%02.2f", 
        $!localtime.year, 
        $!localtime.month, 
        $!localtime.day, 
        $!localtime.hour, 
        $!localtime.minute, 
        $!localtime.second
}

=begin comment
method new(|c) {
    #return self.DateTime::new(formatter => $localtime-format, |c);
    return self.DateTime.new($format, formatter => $localtime-format);
}
=end comment

=begin comment
use MONKEY-TYPING;
augment class DateTime {
    method formatter {
        self.extension("").basename;
    }
}
=end comment

