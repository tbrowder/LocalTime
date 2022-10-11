unit class FG:

has %.class;

method formatter(
                  :$class!,  # must not have ANY spaces, must be unique
                  :$tz-abbrev,    # determines mode (0-3)
                  :$tz-info = '', # needed for actual formatter class construction
                  :$debug,
                 ) {

    #| A class generator factory for DateTime formatters.
    #| Note that classes will have "FG::" prefixed to their names.

    use MONKEY-SEE-NO-EVAL;
    if %class{$class}:exists {
        # return it
        return %class{$class};
    }
    my $fmt = qq:to/HERE/;
    class $class-name does Callable \{
    HERE
    $fmt ~= q:to/HERE/;
        submethod CALL-ME($self, |c) {
            sprintf "%04d-%02d-%02dT%02d:%02d:%02d
    HERE
    $fmt .= chomp;
    if $tz-info {
}

=finish

sub gen-fmt-class(:%class-names!,
                  :$class-name!,  # must not have ANY spaces, must be unique
                  :$tz-abbrev,    # determines mode (0-3)
                  :$tz-info = '', # needed for actual formatter class construction
                  :$debug,
                 ) is export(:gen-fmt-class) {

    #| An exportable class generator factory for DateTime formatters.
    #| The caller must ensure the class name is unique.
    #| Passing in a hash of generated names provides that
    #| that capability.
    #|
    #| Note that classes will have "LocalTime::" prefixed to their names.

    use MONKEY-SEE-NO-EVAL;
    if %class-names{$class-name}:exists {
        die "FATAL: class $class-name already exists";
        # return it
        return %class-names{$class-name};
    }
    my $fmt = qq:to/HERE/;
    class $class-name does Callable \{
    HERE
    $fmt ~= q:to/HERE/;
        submethod CALL-ME($self, |c) {
            sprintf "%04d-%02d-%02dT%02d:%02d:%02d
    HERE
    $fmt .= chomp;
    if $tz-info {
        $fmt ~= " $tz-info";
    }
    $fmt .= chomp;
    # close the format string (don't forget the trailing comma!!)
    $fmt ~= q:to/HERE/;
    ",
            .year, .month, .day, .hour, .minute, .second given $self
        }
    }
    HERE
    $fmt .= chomp;
    EVAL $fmt
} # sub gen-fmt-class
