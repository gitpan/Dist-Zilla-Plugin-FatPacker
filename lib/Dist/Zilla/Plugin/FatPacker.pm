use 5.008;
use strict;
use warnings;

package Dist::Zilla::Plugin::FatPacker;
our $VERSION = '1.100841';

# ABSTRACT: pack your dependencies onto your script file
use File::Temp 'tempfile';
use File::Path 'remove_tree';
use Moose;
with 'Dist::Zilla::Role::FileMunger';
has script => (is => 'ro');

sub safe_system {
    my $cmd = shift;
    system($cmd) == 0 or die "can't $cmd: $?";
}

sub safe_remove_tree {
    my $errors;
    remove_tree(@_, { error => \$errors });
    return unless @$errors;
    for my $diag (@$errors) {
        my ($file, $message) = %$diag;
        if ($file eq '') {
            warn "general error: $message\n";
        } else {
            warn "problem unlinking $file: $message\n";
        }
    }
    die "remove_tree had errors, aborting\n";
}

sub munge_file {
    my ($self, $file) = @_;
    unless (defined $self->script) {
        our $did_warn;
        $did_warn++ || warn "[FatPacker] requires a 'script' configuration\n";
        return;
    }
    return unless $file->name eq $self->script;
    my $content = $file->content;
    my ($fh, $temp_script) = tempfile();
    warn "temp script [$temp_script]\n";
    print $fh $content;
    close $fh or die "can't close temp file $temp_script: $!\n";
    safe_system("fatpack trace $temp_script");
    safe_system("fatpack packlists-for `cat fatpacker.trace` >packlists");
    safe_system("fatpack tree `cat packlists`");
    my $fatpack = `fatpack file`;

    for ($temp_script, 'fatpacker.trace', 'packlists') {
        unlink $_ or die "can't unlink $_: $!\n";
    }
    safe_remove_tree('fatlib');
    $file->content($fatpack . $content);
}
__PACKAGE__->meta->make_immutable;
no Moose;
1;


__END__
=pod

=head1 NAME

Dist::Zilla::Plugin::FatPacker - pack your dependencies onto your script file

=head1 VERSION

version 1.100841

=head1 SYNOPSIS

In C<dist.ini>:

    [FatPacker]
    script = bin/my_script

=head1 DESCRIPTION

This plugin uses L<App::FatPacker> to pack your dependencies onto your script
file.

=head1 FUNCTIONS

=head2 munge_file

When processing the script file indicated by the C<script> configuration parameter,
it prepends its packed dependencies to the script.

This process creates temporary files outside the build directory, but if there
are no errors, they will be removed again.

=head2 safe_remove_tree

This is a wrapper around C<remove_tree()> from C<File::Path> that adds some
error checks.

=head2 safe_system

This is a wrapper around C<system()> that adds some error checks.

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

