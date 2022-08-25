package Math::Permutation;

use 5.010;
use strict;
use warnings;
use Carp;
use List::Util qw/any uniq none all sum first max min/;
use feature 'say';


# supportive math function
sub lcm {
    return reduce { $a*$b/gcd($a,$b) } @_;
}

sub gcd {    # gcd of two positive integers
    my $x = min($_[0], $_[1]);
    my $y = max($_[0], $_[1]);
    while ($x != 0) {
        ($x, $y) = ($y % $x, $x)
    }
    return $y;
}

sub factorial {
    my $ans = 1;
    for (1..$_[0]) {
       $ans *= $_; 
    }
    return $ans;
}



sub wrepr {
    my ($class) = @_;
    my $wrepr = $_[1] || [1];
    # begin: checking
    my $n = scalar $wrepr->@*;
    my %check;
    $check{$_} = 1 foreach $wrepr->@*;
    unless (all {defined($check{$_})} (1..$n)) {
        carp "Error in input representation. "
              ."The permutation will initialize to identity permutation "
              ."of $n elements.\n";
        $wrepr = [1..$n];
    }
    # end: checking
    bless {
        _wrepr => $wrepr,
        _n => $n,
    }, $class;
}

sub tabular {
    my ($class) = @_;
    my @domain = $_[1]->@*;
    my @codomain = $_[2]->@*;
    my $wrepr;
    my $n = scalar @domain;
    # begin: checking
    my %check1, my %check2;
    $check1{$_} = 1 foreach @domain;
    $check2{$_} = 1 foreach @codomain;
    my $check = 1;
    unless ( (all {defined($check1{$_})} (1..$n))
        && $n == scalar @codomain
        && (all {defined($check2{$_})} (1..$n)) ) {
        carp "Error in input representation. "
              ."The permutation will initialize to identity permutation "
              ."of $n elements.\n";
        $wrepr = [1..$n];
        $check = 0;
    }
    # end: checking
    if ($check) {
        my %w;
        $w{$domain[$_]} = $codomain[$_] foreach 0..$n-1;
        $wrepr = [ map {$w{$_}} 1..$n ];
    }
    bless {
        _wrepr => $wrepr,
        _n => $n,
    }, $class;
}


sub cycles {
    my ($class) = @_;
    my @cycles = $_[1]->@*;
    my $wrepr;
    my @elements;
    push @elements, @{$_} foreach @cycles;
    my $n = int max @elements;
    # begin: checking
    my $check = 1;
    for (@elements) {
        if ($_ != int $_) {
            $check = 0;
            last;
        }
    }
    unless (scalar uniq @elements == scalar @elements) {
        $check = 0;
    }
    if (!$check) {
        carp "Error in input representation. "
              ."The permutation will initialize to identity permutation "
              ."of $n elements.\n";
        $wrepr = [1..$n]; 
    }
    # end: checking
    if ($check) {
        my %hash;
        $hash{$_} = 0 for (1..$n);
        for my $c (@cycles) {
            if (scalar @{$c} > 1) {
                $hash{$c->[$_]} = $c->[$_+1] for (0..scalar @{$c} - 2);
                $hash{$c->[-1]} = $c->[0];
            }
            elsif (scalar @{$c} == 1) {
                $hash{$c->[0]} = $c->[0];
            }
        }
        foreach (keys %hash) {
            $hash{$_} = $_ if ($hash{$_} == 0);
        }
        $wrepr = [ map {$hash{$_}} (1..$n) ];
    }
    bless {
        _wrepr => $wrepr,
        _n => $n,
    }, $class;
}


sub cycles_with_len {
    my ($class) = @_;
    my $n = $_[1];
    my @cycles = $_[2]->@*;
    my @elements;
    push @elements, @{$_} foreach @cycles;
    return (any {$n == $_} @elements) ? $_[0]->cycles([@cycles]) 
                                      : $_[0]->cycles([@cycles, [$n]]);
}

sub sprint_wrepr {
    return "\"" . (join ",", $_[0]->{_wrepr}->@*) . "\"";
}

sub sprint_tabular {
    my $n = $_[0]->{_n};
    my $digit_len = length $n;
    return "|" . (join " ", map {sprintf("%*s", $digit_len, $_)} 1..$n )
    . "|" . "\n"
    ."|" 
    . (join " ", map {sprintf("%*s", $digit_len, $_)} $_[0]->{_wrepr}->@* )
    . "|";
}

sub sprint_cycle_full {
    my @cycles = $_[0]->cyc->@*;
    my @p_cycles = map {"(".(join " ", @{$_}). ")"} @cycles;
    return join " ", @p_cycles;
}

sub sprint_cycle {
    my @cycles = $_[0]->cyc->@*;
    @cycles = grep { scalar @{$_} > 1 } @cycles;
    my @p_cycles = map {"(".(join " ", @{$_}). ")"} @cycles;
    return join " ", @p_cycles;
}

sub unrank {
    my ($class) = @_;
    my $n = $_[1];
    my @list = (1..$n);
    my $r = $_[2]-1;
    my $fact = factorial($n-1);
    my @unused_list = sort {$a<=>$b} @list;
    my @p = ();
    for my $i (0..$n-1) {
        my $q = int $r / $fact;
        $r %= $fact;
        push @p, $unused_list[$q];
        splice @unused_list, $q, 1;
        $fact = int $fact / ($n-1-$i) if $i != $n-1;
    }
    my $wrepr = [@p];
    bless {
        _wrepr => $wrepr,
        _n => $n,
    }, $class;
}

sub cyc {
    my $w = $_[0]->{_wrepr};
    my $n = $_[0]->{_n};
    my %hash;
    $hash{$_} = $w->[$_-1] foreach 1..$n;
    my @cycles;
    while (scalar %hash != 0) {
        my $c1 = first {1} %hash;
        my @cycle;
        my $c = $c1;
        do {
            push @cycle, $c;
            my $pre_c = $c;
            $c = $hash{$c};
            delete $hash{$pre_c};
        } while ($c != $c1);
        push @cycles, [@cycle];
    }
    return [@cycles];
}



sub sigma {
    return $_[0]->{_wrepr}->[$_[1]-1];
}

sub rule {
    return $_[0]->{_wrepr};
}

sub elems {
    return $_[0]->{_n};
}

sub rank {
    my @list = $_[0]->{_wrepr}->@*;
    my $n = scalar @list;
    my $fact = factorial($n-1);
    my $r = 1;
    my @unused_list = sort {$a<=>$b} @list;
    for my $i (0..$n-2) {
        my $q = first { $unused_list[$_] == $list[$i] } 0..$#unused_list;
        $r += $q*$fact;
        splice @unused_list, $q, 1;
        $fact = int $fact / ($n-$i-1);
    }
    return $r;
}

# rank() and unrank($n, $i) using
# O(n^2) solution, translation of Python code on
# https://tryalgo.org/en/permutations/2016/09/05/permutation-rank/

sub order {
    my @cycles = $_[0]->cyc->@*;
    return lcm(map {scalar @{$_}} @cycles);
}

sub is_even {
    my @cycles = $_[0]->cyc->@*;
    my $num_of_two_swaps = sum(map { scalar @{$_} - 1 } @cycles);
    return $num_of_two_swaps % 2 == 0 ? 1 : 0;
}

sub is_odd {
    return $_[0]->is_even ? 0 : 1;
}

sub sgn {
    return $_[0]->is_even ? 1 : -1;
}

=head1 NAME

Math::Permutation - pure Perl implementation of functions related to the permutations 

=head1 VERSION

Version 0.01

=cut

our $VERSION = '0.01';


=head1 SYNOPSIS

Quick summary of what the module does.

Perhaps a little code snippet.

    use Math::Permutation;

    my $foo = Math::Permutation->new();
    ...

=head1 METHODS

=head2 INITALIZE/GENERATE NEW PERMUTATION

=over 1

=item init($n)

=item wrepr([$a, $b, $c, ..., $m]) (one-line notation)

=item tabular([$A, $B, ... , $M), [$a, $b, $c, ..., $m]) (two-line form)

usually tabular([1..$n], [$p1, $p2, ..., $pn])

=item cycles([$a, $b, $c], [$d, $e], [$f, $g])

=item cycles_with_len($n, [$a, $b, $c], [$d, $e])

=item unrank($n, $i)

=item random($n)

=back

=head2 DISPLAY THE PERMUTATION

=over 1

=item sprint_wrepr()

=item sprint_tabular()

=item sprint_cycles()

=item sprint_cycles_full()

=back

=head2 MODIFY THE PERMUTATION

=over 1

=item swap($i, $j)

=item mul

=back

=head2 OBTAIN ANOTHER PERMUTATION FROM THE PERMUTATION

=over 1

=item inverse()

=item sqrt()

Caveat: may return [].

=item next()

Caveat: may return [].

=item prev()

Caveat: may return [].

=back

=head2 PRORERTIES OF THE CURRENT PERMUTATION

=over 1

=item sigma($i)

=item rule()

=item cyc()

=item elems()

=item rank()

=item index() -- ???

=item order()

=item is_even()

0, 1

=item is_odd()

0, 1

=item sgn()

1, -1

=item inversion() - the inversion vector as a list

=item matrix()

=item fixed_points() - a list of the fixed points

=back

=head1 SUBROUTINES/METHODS TO BE INPLEMENTED

=over 1

=item longest_increasing()

=item longest_decreasing()

=item coxeter_decomposition()

=item mul( more than one permutations )

=item reverse()

Chapter 1, Patterns in Permutations and Words

=item complement()  

Chapter 1, Patterns in Permutations and Words

=item is_irreducible()

Chapter 1, Patterns in Permutations and Words

=item num_of_occurrences_of_pattern()

Chapter 1, Patterns in Permutations and Words

=item contains_pattern()

Chapter 1, Patterns in Permutations and Words

=item avoids_pattern()

Chapter 1, Patterns in Permutations and Words

=item new_barred_pattern(  )

Section 1.2, Patterns in Permutations and Words

new_barred_pattern( [ -3,-1,5,-2,4 ] )

=back

=head1 AUTHOR

Cheok-Yin Fung, C<< <fungcheokyin at gmail.com> >>

=head1 BUGS

Please report any bugs or feature requests to C<bug-math-permutation at rt.cpan.org>, or through
the web interface at L<https://rt.cpan.org/NoAuth/ReportBug.html?Queue=Math-Permutation>.  I will be notified, and then you'll
automatically be notified of progress on your bug as I make changes.




=head1 SUPPORT

You can find documentation for this module with the perldoc command.

    perldoc Math::Permutation


You can also look for information at:

=over 4

=item * RT: CPAN's request tracker (report bugs here)

L<https://rt.cpan.org/NoAuth/Bugs.html?Dist=Math-Permutation>

=item * CPAN Ratings

L<https://cpanratings.perl.org/d/Math-Permutation>

=item * Search CPAN

L<https://metacpan.org/release/Math-Permutation>

=back


=head1 REFERENCES

The module has gained ideas from various sources:

Opensource resources:

https://github.com/scheinerman/Permutations.jl/blob/master/docs/src/index.md

https://metacpan.org/pod/Math::GSL::Permutation

https://maxima.sourceforge.io/docs/manual/maxima_singlepage.html#combinatorics_002dpkg

Non-opensource resources:

https://www.wolframalpha.com/

Algebra, Michael Artin

Patterns in Permutations and Words, Sergey Kitaev

=head2 See Also

https://en.wikipedia.org/wiki/Left_and_right_(algebra)


=head1 LICENSE AND COPYRIGHT

This software is Copyright (c) 2022 by Cheok-Yin Fung.

This is free software, licensed under:

  MIT License


=cut

1; # End of Math::Permutation
