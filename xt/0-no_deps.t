use strict;
use warnings;
use Test::More;
use Path::Class;

my $dir = Path::Class::tempdir(CLEANUP => 1);
copy_dist_files_into_dir($dir);
chdir $dir;

my $status = system 'dzil build >/dev/null 2>/dev/null';
is $status << 0, 0, 'zero exit status';

my $dist_dir = $dir->subdir('No-Deps-Script-0.07');
ok -d $dist_dir,
    'dist dir';

ok -f $dir->file('No-Deps-Script-0.07.tar.gz'),
    'dist tar.gz';

my $packed_script_file = $dist_dir->file('bin/no_deps.pl');
like scalar $packed_script_file->slurp,
    qr{\A [#]!/usr/bin/env \s perl}xms,
    'shebang';

is `$^X $packed_script_file`,
    'script without deps is running',
    'script output';

done_testing;


sub copy_dist_files_into_dir {
    my $dir = shift;

    foreach my $subdir (qw(t lib/No/Deps bin)) {
        $dir->subdir($subdir)->mkpath;
    }

    $dir->file('dist.ini')->spew(dist_ini());
    $dir->file('lib/No/Deps/Script.pm')->spew(script_pm());
    $dir->file('bin/no_deps.pl')->spew(script());
}

sub dist_ini { <<'DIST_INI' }
name    = No-Deps-Script
version = 0.07
author  = CPAN Tester
license = Perl_5
copyright_holder = CPAN Tester

[@Classic]

[FatPacker]
script = bin/no_deps.pl
DIST_INI

sub script_pm { <<'SCRIPT_PM' }
package No::Deps::Script;
# ABSTRACT: No Deps Script
1;
SCRIPT_PM

sub script { <<'NO_DEPS_PL' }
#!/usr/bin/env perl
use strict;
use warnings;

print "script without deps is running";
NO_DEPS_PL
