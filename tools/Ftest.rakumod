unit module Ftest;

# New formatters:
our $CST = sub ($self) { 
    sprintf "%04d-%02d-%02dT%02d:%02d:%02d CST", 
        .year, .month, .day, .hour, .minute, .second given $self; 
}

our $CDT = sub ($self) { 
    sprintf "%04d-%02d-%02dT%02d:%02d:%02d CDT", 
        .year, .month, .day, .hour, .minute, .second given $self; 
}
our $UTC = sub ($self) { 
    sprintf "%04d-%02d-%02dT%02d:%02d:%02d UTC", 
        .year, .month, .day, .hour, .minute, .second given $self; 
}
our $p1 = sub ($self) { 
    sprintf "%04d-%02d-%02dT%02d:%02d:%02d UTC +1 hr", 
        .year, .month, .day, .hour, .minute, .second given $self; 
}
our $m1 = sub ($self) { 
    sprintf "%04d-%02d-%02dT%02d:%02d:%02d UTC -1 hr", 
        .year, .month, .day, .hour, .minute, .second given $self; 
}
