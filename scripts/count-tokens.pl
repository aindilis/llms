#!/usr/bin/env perl

use BOSS::Config;
use Capability::Tokenize;
use PerlLib::SwissArmyKnife;

$specification = q(
	-f <file>		File to count tokens in
);

my $config =
  BOSS::Config->new
  (Spec => $specification);
my $conf = $config->CLIConfig;
# $UNIVERSAL::systemdir = "/var/lib/myfrdcsa/codebases/minor/system";

if (! exists $conf->{'-f'}) {
  die "Need to specify file to tokenize with -f\n";
}

my $file = $conf->{'-f'};
if (! -f $file) {
  die "File doesn't exist, need to specify an existing file with -f\n";
}

my $text = read_file($file);
my $tokens = Tokenize(Text => $text);
print scalar(@$tokens);
