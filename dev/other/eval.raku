#!/usr/bin/env raku

my $with-tz-abbrev = sub ($self) { 
    sprintf "%04d-%02d-%02dT%02d:%02d:%02d NYI", .year, .month, .day, .hour, .minute, .second
    given $self; 
}

my $no-tz-abbrev = sub ($self) { 
    sprintf "%04d-%02d-%02dT%02d:%02d:%02d", .year, .month, .day, .hour, .minute, .second
    given $self; 
}

class foo is DateTime {

    method new(:$tz-abbrev, |c) {
        if $tz-abbrev.defined {
            self.DateTime::new(:formatter($with-tz-abbrev), |c);
        }
        else {
            self.DateTime::new(:formatter($no-tz-abbrev), |c);
        }
    }
}

my $s = foo.new: :2022year, :tz-abbrev;
my $t = foo.new: :2022year;
say $t.Str;
say $s.Str;

