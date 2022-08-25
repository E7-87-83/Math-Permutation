require "./Permutation.pm";
use v5.30.0;
use warnings;
use Data::Dump qw/dump/;

my $hello = Math::Permutation->wrepr([1,3,2,4,5,6,7,8,9,10]);
say $hello->sprint_wrepr;
say $hello->sprint_tabular;

my $err = Math::Permutation->tabular([1,3,2,4],[4,3,2,1]);
say $err->sprint_tabular;
dump $err->cyc;
say $err->sprint_cycle_full;
say $err->sprint_cycle;

my $last = Math::Permutation->unrank(4, 19);
say $last->sprint_tabular;
say $last->is_even;

my $cyc = Math::Permutation->cycles_with_len(7, [[1,2],[3,5]]);
say $cyc->sprint_tabular;
