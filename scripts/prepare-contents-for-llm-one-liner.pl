#!/usr/bin/env perl

use BOSS::Config;
use PerlLib::SwissArmyKnife;

$specification = q(
	-c <contents>		Contents to process
);

my $config =
  BOSS::Config->new
  (Spec => $specification);
my $conf = $config->CLIConfig;
# $UNIVERSAL::systemdir = "/var/lib/myfrdcsa/codebases/minor/system";

my $contents = $conf->{'-c'};

if ($contents) {
  $contents =~ s/\e\[?.*?[\@-~]//g;
  $contents =~ s///g;

  print $contents;
}
