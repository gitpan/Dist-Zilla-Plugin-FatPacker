
use strict;
use warnings;

 BEGIN { require 5.008; } 

use ExtUtils::MakeMaker 6.11;



my %WriteMakefileArgs = (
                       'test' => {
                                   'TESTS' => 't/*.t'
                                 },
                       'NAME' => 'Dist::Zilla::Plugin::FatPacker',
                       'DISTNAME' => 'Dist-Zilla-Plugin-FatPacker',
                       'CONFIGURE_REQUIRES' => {
                                                 'ExtUtils::MakeMaker' => '6.11'
                                               },
                       'AUTHOR' => 'Marcel Gruenauer <marcel@cpan.org>',
                       'BUILD_REQUIRES' => {},
                       'ABSTRACT' => 'pack your dependencies onto your script file',
                       'EXE_FILES' => [],
                       'VERSION' => '1.100841',
                       'PREREQ_PM' => {
                                        'Scalar::Util' => '0',
                                        'English' => '0',
                                        'App::FatPacker' => '0',
                                        'Carp' => '0',
                                        'Test::More' => '0.88',
                                        'Dist::Zilla::Role::FileMunger' => '0',
                                        'File::Find' => '0',
                                        'File::Temp' => '0',
                                        'File::Path' => '0',
                                        'Moose' => '0'
                                      },
                       'LICENSE' => 'perl'
                     );


delete $WriteMakefileArgs{LICENSE}
  unless eval { ExtUtils::MakeMaker->VERSION(6.31) };

WriteMakefile(%WriteMakefileArgs);



