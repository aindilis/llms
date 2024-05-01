#!/usr/bin/env perl

use BOSS::Config;
use LLMs::Util2 qw(ExtractList);
use PerlLib::SwissArmyKnife;

$specification = q(
	-t <text>	Text to extract list from
);

my $config =
  BOSS::Config->new
  (Spec => $specification);
my $conf = $config->CLIConfig;
# $UNIVERSAL::systemdir = "/var/lib/myfrdcsa/codebases/minor/system";

my $c = read_file($conf->{'-t'});
print Dumper(ExtractList(Text => $c));




