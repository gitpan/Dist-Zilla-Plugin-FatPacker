use 5.008;
use strict;
use warnings;

package Dist::Zilla::Plugin::FatPacker;
our $VERSION = '1.100840';

# ABSTRACT: pack your dependencies onto your script file
use Moose;
with 'Dist::Zilla::Role::FileMunger';

sub munge_file {
    my ($self, $file) = @_;
    my $content = $file->content;
    $content =~ s/.*__FATPACK__/`$^X -e 'use App::FatPacker -run_script' file`/e;
    $file->content($content);
}
__PACKAGE__->meta->make_immutable;
no Moose;
1;


__END__
=pod

=head1 NAME

Dist::Zilla::Plugin::FatPacker - pack your dependencies onto your script file

=head1 VERSION

version 1.100840

=head1 SYNOPSIS

In C<dist.ini>:

    [FatPacker]

=head1 DESCRIPTION

This plugin uses L<App::FatPacker> to pack your dependencies onto your script
file.

=head1 FUNCTIONS

=head2 munge_file

Looks for a C<__FATPACK__> marker and replaces the line it occurs in with the
packed dependencies. A good way of using this is in a comment line:

    #!/usr/bin/env perl
    # __FATPACK__
    use strict;
    use warnings;
    use Foo::Bar;
    use Hoge::Hoge;

=for test_synopsis 1;
__END__

=head1 INSTALLATION

See perlmodinstall for information and options on installing Perl modules.

=head1 BUGS AND LIMITATIONS

No bugs have been reported.

Please report any bugs or feature requests through the web interface at
L<http://rt.cpan.org/Public/Dist/Display.html?Name=Dist-Zilla-Plugin-FatPacker>.

=head1 AVAILABILITY

The latest version of this module is available from the Comprehensive Perl
Archive Network (CPAN). Visit L<http://www.perl.com/CPAN/> to find a CPAN
site near you, or see
L<http://search.cpan.org/dist/Dist-Zilla-Plugin-FatPacker/>.

The development version lives at
L<http://github.com/hanekomu/Dist-Zilla-Plugin-FatPacker/>.
Instead of sending patches, please fork this project using the standard git
and github infrastructure.

=head1 AUTHOR

  Marcel Gruenauer <marcel@cpan.org>

=head1 COPYRIGHT AND LICENSE

This software is copyright (c) 2010 by Marcel Gruenauer.

This is free software; you can redistribute it and/or modify it under
the same terms as the Perl 5 programming language system itself.

=cut

