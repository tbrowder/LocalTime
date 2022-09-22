#!/usr/bin/env raku

use lib "../lib";
use LocalTime;

my $t = DateTime.new: :2000year, :10month, :10day, :12hour :12minute :12second;
#my $dt = LocalTime.new: :datetime($t);
my $dt = LocalTime.new: :2000year, :10month, :10day, :12hour :12minute :12second;

say $dt.Str;
