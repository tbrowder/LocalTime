#| Formatters for DateTime classes
unit module F;

our $no-tz-info = sub ($self) {
    sprintf "%04d-%02d-%02dT%02d:%02d:%02d"
    .year, .month, .day, .hour, .minute, .second given $self
}
our $AKST = sub ($self) {
    sprintf "%04d-%02d-%02dT%02d:%02d:%02d AKST"
    .year, .month, .day, .hour, .minute, .second given $self
}
our $AKDT = sub ($self) {
    sprintf "%04d-%02d-%02dT%02d:%02d:%02d AKDT"
    .year, .month, .day, .hour, .minute, .second given $self
}
our $AST = sub ($self) {
    sprintf "%04d-%02d-%02dT%02d:%02d:%02d AST"
    .year, .month, .day, .hour, .minute, .second given $self
}
our $ADT = sub ($self) {
    sprintf "%04d-%02d-%02dT%02d:%02d:%02d ADT"
    .year, .month, .day, .hour, .minute, .second given $self
}
our $CHST = sub ($self) {
    sprintf "%04d-%02d-%02dT%02d:%02d:%02d CHST"
    .year, .month, .day, .hour, .minute, .second given $self
}
our $CHDT = sub ($self) {
    sprintf "%04d-%02d-%02dT%02d:%02d:%02d CHDT"
    .year, .month, .day, .hour, .minute, .second given $self
}
our $CST = sub ($self) {
    sprintf "%04d-%02d-%02dT%02d:%02d:%02d CST"
    .year, .month, .day, .hour, .minute, .second given $self
}
our $CDT = sub ($self) {
    sprintf "%04d-%02d-%02dT%02d:%02d:%02d CDT"
    .year, .month, .day, .hour, .minute, .second given $self
}
our $EST = sub ($self) {
    sprintf "%04d-%02d-%02dT%02d:%02d:%02d EST"
    .year, .month, .day, .hour, .minute, .second given $self
}
our $EDT = sub ($self) {
    sprintf "%04d-%02d-%02dT%02d:%02d:%02d EDT"
    .year, .month, .day, .hour, .minute, .second given $self
}
our $HAST = sub ($self) {
    sprintf "%04d-%02d-%02dT%02d:%02d:%02d HAST"
    .year, .month, .day, .hour, .minute, .second given $self
}
our $HADT = sub ($self) {
    sprintf "%04d-%02d-%02dT%02d:%02d:%02d HADT"
    .year, .month, .day, .hour, .minute, .second given $self
}
our $MST = sub ($self) {
    sprintf "%04d-%02d-%02dT%02d:%02d:%02d MST"
    .year, .month, .day, .hour, .minute, .second given $self
}
our $MDT = sub ($self) {
    sprintf "%04d-%02d-%02dT%02d:%02d:%02d MDT"
    .year, .month, .day, .hour, .minute, .second given $self
}
our $PST = sub ($self) {
    sprintf "%04d-%02d-%02dT%02d:%02d:%02d PST"
    .year, .month, .day, .hour, .minute, .second given $self
}
our $PDT = sub ($self) {
    sprintf "%04d-%02d-%02dT%02d:%02d:%02d PDT"
    .year, .month, .day, .hour, .minute, .second given $self
}
our $WST = sub ($self) {
    sprintf "%04d-%02d-%02dT%02d:%02d:%02d WST"
    .year, .month, .day, .hour, .minute, .second given $self
}
our $WDT = sub ($self) {
    sprintf "%04d-%02d-%02dT%02d:%02d:%02d WDT"
    .year, .month, .day, .hour, .minute, .second given $self
}
our $p12 = sub ($self) {
    sprintf "%04d-%02d-%02dT%02d:%02d:%02d Local Time (UTC +12 hrs)"
    .year, .month, .day, .hour, .minute, .second given $self
}
our $p11 = sub ($self) {
    sprintf "%04d-%02d-%02dT%02d:%02d:%02d Local Time (UTC +11 hrs)"
    .year, .month, .day, .hour, .minute, .second given $self
}
our $p10 = sub ($self) {
    sprintf "%04d-%02d-%02dT%02d:%02d:%02d Local Time (UTC +10 hrs)"
    .year, .month, .day, .hour, .minute, .second given $self
}
our $p9 = sub ($self) {
    sprintf "%04d-%02d-%02dT%02d:%02d:%02d Local Time (UTC +9 hrs)"
    .year, .month, .day, .hour, .minute, .second given $self
}
our $p8 = sub ($self) {
    sprintf "%04d-%02d-%02dT%02d:%02d:%02d Local Time (UTC +8 hrs)"
    .year, .month, .day, .hour, .minute, .second given $self
}
our $p7 = sub ($self) {
    sprintf "%04d-%02d-%02dT%02d:%02d:%02d Local Time (UTC +7 hrs)"
    .year, .month, .day, .hour, .minute, .second given $self
}
our $p6 = sub ($self) {
    sprintf "%04d-%02d-%02dT%02d:%02d:%02d Local Time (UTC +6 hrs)"
    .year, .month, .day, .hour, .minute, .second given $self
}
our $p5 = sub ($self) {
    sprintf "%04d-%02d-%02dT%02d:%02d:%02d Local Time (UTC +5 hrs)"
    .year, .month, .day, .hour, .minute, .second given $self
}
our $p4 = sub ($self) {
    sprintf "%04d-%02d-%02dT%02d:%02d:%02d Local Time (UTC +4 hrs)"
    .year, .month, .day, .hour, .minute, .second given $self
}
our $p3 = sub ($self) {
    sprintf "%04d-%02d-%02dT%02d:%02d:%02d Local Time (UTC +3 hrs)"
    .year, .month, .day, .hour, .minute, .second given $self
}
our $p2 = sub ($self) {
    sprintf "%04d-%02d-%02dT%02d:%02d:%02d Local Time (UTC +2 hrs)"
    .year, .month, .day, .hour, .minute, .second given $self
}
our $p1 = sub ($self) {
    sprintf "%04d-%02d-%02dT%02d:%02d:%02d Local Time (UTC +1 hrs)"
    .year, .month, .day, .hour, .minute, .second given $self
}
our $m0 = sub ($self) {
    sprintf "%04d-%02d-%02dT%02d:%02d:%02d Local Time (UTC)"
    .year, .month, .day, .hour, .minute, .second given $self
}
our $p0 = sub ($self) {
    sprintf "%04d-%02d-%02dT%02d:%02d:%02d Local Time (UTC)"
    .year, .month, .day, .hour, .minute, .second given $self
}
our $UTC = sub ($self) {
    sprintf "%04d-%02d-%02dT%02d:%02d:%02d Local Time (UTC)"
    .year, .month, .day, .hour, .minute, .second given $self
}
our $Z = sub ($self) {
    sprintf "%04d-%02d-%02dT%02d:%02d:%02d Local Time (UTC)"
    .year, .month, .day, .hour, .minute, .second given $self
}
our $m1 = sub ($self) {
    sprintf "%04d-%02d-%02dT%02d:%02d:%02d Local Time (UTC -1 hrs)"
    .year, .month, .day, .hour, .minute, .second given $self
}
our $m2 = sub ($self) {
    sprintf "%04d-%02d-%02dT%02d:%02d:%02d Local Time (UTC -2 hrs)"
    .year, .month, .day, .hour, .minute, .second given $self
}
our $m3 = sub ($self) {
    sprintf "%04d-%02d-%02dT%02d:%02d:%02d Local Time (UTC -3 hrs)"
    .year, .month, .day, .hour, .minute, .second given $self
}
our $m4 = sub ($self) {
    sprintf "%04d-%02d-%02dT%02d:%02d:%02d Local Time (UTC -4 hrs)"
    .year, .month, .day, .hour, .minute, .second given $self
}
our $m5 = sub ($self) {
    sprintf "%04d-%02d-%02dT%02d:%02d:%02d Local Time (UTC -5 hrs)"
    .year, .month, .day, .hour, .minute, .second given $self
}
our $m6 = sub ($self) {
    sprintf "%04d-%02d-%02dT%02d:%02d:%02d Local Time (UTC -6 hrs)"
    .year, .month, .day, .hour, .minute, .second given $self
}
our $m7 = sub ($self) {
    sprintf "%04d-%02d-%02dT%02d:%02d:%02d Local Time (UTC -7 hrs)"
    .year, .month, .day, .hour, .minute, .second given $self
}
our $m8 = sub ($self) {
    sprintf "%04d-%02d-%02dT%02d:%02d:%02d Local Time (UTC -8 hrs)"
    .year, .month, .day, .hour, .minute, .second given $self
}
our $m9 = sub ($self) {
    sprintf "%04d-%02d-%02dT%02d:%02d:%02d Local Time (UTC -9 hrs)"
    .year, .month, .day, .hour, .minute, .second given $self
}
our $m10 = sub ($self) {
    sprintf "%04d-%02d-%02dT%02d:%02d:%02d Local Time (UTC -10 hrs)"
    .year, .month, .day, .hour, .minute, .second given $self
}
our $m11 = sub ($self) {
    sprintf "%04d-%02d-%02dT%02d:%02d:%02d Local Time (UTC -11 hrs)"
    .year, .month, .day, .hour, .minute, .second given $self
}
our $m12 = sub ($self) {
    sprintf "%04d-%02d-%02dT%02d:%02d:%02d Local Time (UTC -12 hrs)"
    .year, .month, .day, .hour, .minute, .second given $self
}
