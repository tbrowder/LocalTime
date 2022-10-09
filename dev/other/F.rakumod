#| Formatters for DateTime classes
unit module F;

our $no-tz-info = sub ($self) {
    sprintf "%04d-%02d-%02dT%02d:%02d:%02d",
    .year, .month, .day, .hour, .minute, .second given $self
};
our $CST = sub ($self) {
    sprintf "%04d-%02d-%02dT%02d:%02d:%02d CST",
    .year, .month, .day, .hour, .minute, .second given $self
};
our $CDT = sub ($self) {
    sprintf "%04d-%02d-%02dT%02d:%02d:%02d CDT",
    .year, .month, .day, .hour, .minute, .second given $self
};

