package Math::Permutation;

use 5.010;
use strict;
use warnings;

=head1 NAME

Math::Permutation - pure Perl implementation of functions related to the permutation groups 

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

=item init()

=item rules

=item tabular (two-line form)

=item cycles

=item cycles_incomplete

=item cycles_sleepy

=item unrank($n, $i)

// Trotter-Johnson ordering of permutations

=item random($n)

=back

=head2 DISPLAY THE PERMUTATION

=over 1

=item vector()

=item print_tabular()

=item print_cycles()

=item print_cycles_incomplete()

=back

=head2 MODIFY THE PERMUTATION

=over 1

=item swap($i, $j)

=item lmul

=item rmul

=back

=head2 OBTAIN ANOTHER PERMUTATION FROM THE PERMUTATION

=over 1

=item inverse()

=item rank()

=item sqrt()

Caveat: may return undef

=item next()

Caveat: may return undef

=item prev()

Caveat: may return undef.

=back

=head2 PRORERTIES OF THE CURRENT PERMUTATION

=over 1

=item valid()

=item index()

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

=item rmul( more than one permutations )

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

=head2 See Also

https://en.wikipedia.org/wiki/Left_and_right_(algebra)


=head1 LICENSE AND COPYRIGHT

This software is Copyright (c) 2022 by Cheok-Yin Fung.

This is free software, licensed under:

  MIT License


=cut

1; # End of Math::Permutation
