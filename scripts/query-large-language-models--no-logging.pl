#!/usr/bin/env perl

# see also /var/lib/myfrdcsa/codebases/minor/llms/scripts/qna-over-text.pl

use BOSS::Config;
use Capability::LargeLanguageModels;
use PerlLib::SwissArmyKnife;

$specification = q(
	-m <model>		Model to use
);

my $config =
  BOSS::Config->new
  (Spec => $specification);
my $conf = $config->CLIConfig;
# $UNIVERSAL::systemdir = "/var/lib/myfrdcsa/codebases/minor/system";

my $enginename = $conf->{'-m'} || 'Mistral';

my $llms = Capability::LargeLanguageModels->new(EngineName => $enginename);
$llms->StartServer();

print "THIS SESSION IS NOT RECORDED VIA DB (BUT COULD POSSIBLY BE EAVESDROPPEDON)\n\n";

my $query;
print '> ';
while (<>) {
  my @results = $llms->Query
    (
     DoNotRecord => 1,
     Prompt => $_,
    );
  print $results[0]->{Result}."\n\n";;
  print '> ';
}
