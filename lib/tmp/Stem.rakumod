unit class IO::Stem is IO::Path;

# a normal instantiation is expected, otherwise an exception is thrown
method new(|c) {
    return self.IO::Path::new(|c);
}

use MONKEY-TYPING;
augment class IO::Path {
    method stem {
        self.extension("").basename;
    }
    # aliases
    method barename { self.stem }
    method name     { self.stem }
    method filename { self.stem }
    method suffix   { self.extension }
}
