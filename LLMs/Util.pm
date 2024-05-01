package LLMs::Util;

use PerlLib::SwissArmyKnife;
use Rival::String::Tokenizer;

# use File::Temp;

require Exporter;
@ISA = qw(Exporter);
@EXPORT = qw(FitPrompt SaveLLMPromptAndOutput);

our $tokenizer = Rival::String::Tokenizer->new();

sub FitPrompt {
  my (%args) = @_;

  my $instructions = $args{Instructions};
  my $l1 = GetTokenCount($instructions);

  my $question = $args{Question};
  my $l2 = GetTokenCount($question);

  my $buffer = $args{Buffer} || 25;
  my $max_prompt = $args{MaxPrompt} || 2048;

  my $l1_cutoff = ($max_prompt - ($l2 + $buffer));
  my $finaltext = '';
  my $i = 1;

  my $tokens = GetTokens($instructions);
  my @instructions_prompt = splice(@$tokens,0,$l1_cutoff);

  my $question_prompt = $question;

  $question_prompt =~ s/([^[:ascii:]]+)/ /msg;
  $question_prompt =~ s/\s+/ /msg;

  my $prompt = join(' ',@instructions_prompt).' '.$question_prompt;

  return
    {
     Success => 1,
     Result => $prompt,
    };
}

sub GetTokenCount {
  my ($text) = @_;
  my $tokens = GetTokens($text);
  return length(@$tokens);

}

sub GetTokens {
  my ($text) = @_;
  $tokenizer->tokenize($text);
  my @tokens = $tokenizer->getTokens();
  return \@tokens;
}

sub SaveLLMPromptAndOutput {
  my (%args) = @_;
  my ($fh, $filename) = tempfile
    (
     'llm-result-XXXXXXX',
     DIR => '/var/lib/myfrdcsa/codebases/minor/emotional-intelligence/data-git/llm-qna',
     SUFFIX => '.dat',
    );
  WriteFile(File => $filename, Contents => Dumper({Prompt => $args{Prompt},Output => $args{Output}}));
}

1;
