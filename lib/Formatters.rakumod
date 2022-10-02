unit module Formatters;

# New formatters:
our $with-tz-abbrev = sub ($self) { 
    sprintf "%04d-%02d-%02dT%02d:%02d:%02d %s", 
        .year, .month, .day, 
        .hour, .minute, .second, 
        .tz-abbrev 
    given $self; 
}

our $no-tz-abbrev = sub ($self) { 
    sprintf "%04d-%02d-%02dT%02d:%02d:%02d", 
        .year, .month, .day, 
        .hour, .minute, .second 
    given $self; 
}
