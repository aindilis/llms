#!/usr/bin/env perl

# FIXME: replace all this with template toolkit

use BOSS::Config;
use Capability::LargeLanguageModels;
use PerlLib::SwissArmyKnife;
use PerlLib::ToText;
use UniLang::Util::TempAgent;

$specification = q(
	-f <file>		Files containing text to do QnA over
	-F <file>		File containing list of files to do QnA over

	-i <text>		Introduction to prompt and question
	-d <text>		Divider between prompt and question

	-q <question>		Question to ask
	-Q <question>		Question file to ask

	-c <text>		Conclusion to prompt and question

	-t <num>		Number of tokens for context
	-b <num>		Number of tokens for buffer

	-n			Preserve \\n
	-q			Quiet
	-r			Record the answer in Sayer2
);

my $config =
  BOSS::Config->new
  (Spec => $specification);
my $conf = $config->CLIConfig;
# $UNIVERSAL::systemdir = "/var/lib/myfrdcsa/codebases/minor/system";

if (! exists $conf->{'-f'}) {
  die "Must define texts with -f\n";
}

if (! exists $conf->{'-q'} and ! exists $conf->{'-Q'}) {
  die "Must define question with -q or -Q\n";
}

my $totext = PerlLib::ToText->new();
my $file  = $conf->{'-f'};
print '<<<'.$file.">>>\n";
my $result = $totext->ToText(File => $file);
my $prompt;
if ($result->{Success}) {
  $prompt = (exists $conf->{'-i'} ? $conf->{'-i'}." " : "").$result->{Text};
}

if ($conf->{'-n'}) {
  $prompt =~ s/[\n\r]+/\\n/sg;
} else {
  $prompt =~ s/[\n\r\s]+/ /sg;
}

my $llms = Capability::LargeLanguageModels->new(EngineName => 'Mistral');
$llms->StartServer();

sub Receive {
  my %args = @_;
  # print Dumper({Args => \%args});
}

my $limit = $conf->{'-t'} || 4096; # FIXME change this to 32768 or what not, for Mistral
my $buffer = $conf->{'-b'} || 100;

my $question = $conf->{'-q'};
if (exists $conf->{'-Q'}) {
  $question = (exists $conf->{'-d'} ? " ".$conf->{'-d'}." " : "").read_file($conf->{'-Q'}).(exists $conf->{'-c'} ? " ".$conf->{'-c'} : "");
}

$question =~ s/[\n\r\s]+/ /sg;

my @questiontokens = split / +/, $question;
my $questioncount = scalar @questiontokens;
print "<QUESTION COUNT: $questioncount>\n" if $UNIVERSAL::debug;

my @prompttokens = split / +/, $prompt;
my $promptcount = scalar @prompttokens;
print "<PROMPT COUNT: $promptcount>\n" if $UNIVERSAL::debug;
my @new;



print "Limit ".$limit."\n";
if ($promptcount + $questioncount + buffer > $limit) {
  @new = splice(@prompttokens,0,$limit - ($questioncount + $buffer));
} else {
  @new = @prompttokens;
}
my $newprompt = join(' ',@new);

print '<<<'.$questioncount.':::'.$question.">>>\n" if $UNIVERSAL::debug;
print '<<<'.$promptcount.':::'.$newprompt.">>>\n" if $UNIVERSAL::debug;

my $finalprompt = $newprompt.' '.$question;
print '<<<'.($promptcount + $questioncount).':::'.$finalprompt.">>>\n" if $UNIVERSAL::debug;

WC(
   NewPrompt => $newprompt,
   Question => $question,
   FinalPrompt => $finalprompt,
  );

if (! $conf->{'-q'}) {
  print "\n\n\n------------------------------------------------\n\n\n".$finalprompt."\n\n\n------------------------------------------------\n\n\n";
}

my @results = $llms->Query
  (
   DoNotRecord => 1,
   Prompt => $finalprompt,
  );
print $results[0]->{Result}."\n\n";;

sub WC {
  my (%args) = @_;
  foreach my $key (keys %args) {
    my @tokens = split /\s+/, $args{$key};
    my $count = scalar @tokens;
    print $key."\t".$count."\n";
  }
}
