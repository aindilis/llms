# package LLMs::Util3;

# # see LLMs::Util

# use BOSS::Config;
# use Capability::LargeLanguageModels;
# use LLMs::Templating;
# use PerlLib::SwissArmyKnife;
# use PerlLib::ToText;
# use Rival::String::Tokenizer;
# use UniLang::Util::TempAgent;

# # use File::Temp;

# require Exporter;
# @ISA = qw(Exporter);
# @EXPORT = qw(FitPrompt3 ExtractList);

# our $tokenizer = Rival::String::Tokenizer->new();

# sub FitPrompt3 {
#   my (%args) = @_;

#   my $templating = LLMs::Templating->new();

#   # order is Introduction, Text, Divider, Question, Conclusion

#   $UNIVERSAL::debug ||= $args{Debug};

#   my $limit = $args{Limit} || 8192;
#   my $buffer = $args{Buffer} || 100;

#   my $prompt = (exists $args{Introduction} ? $args{Introduction}." " : "").$args{Text};
#   $prompt =~ s/[\n\r\s]+/ /sg;

#   my $question = (exists $args{Divider} ? " ".$args{Divider}." " : "").$args{Question}.(exists $args{Conclusion} ? " ".$args{Conclusion} : "");
#   $question =~ s/[\n\r\s]+/ /sg;

#   my @questiontokens = split / +/, $question;
#   my $questioncount = scalar @questiontokens;
#   print "<QUESTION COUNT: $questioncount>\n" if $UNIVERSAL::debug;

#   my @prompttokens = split / +/, $prompt;
#   my $promptcount = scalar @prompttokens;
#   print "<PROMPT COUNT: $promptcount>\n" if $UNIVERSAL::debug;

#   # my $questioncount = GetTokenCount2($question);
#   # print "<QUESTION COUNT: $questioncount>\n" if $UNIVERSAL::debug;

#   # my $promptcount = GetTokenCount2($prompt);
#   # print "<PROMPT COUNT: $promptcount>\n" if $UNIVERSAL::debug;

#   my @new;
#   print "Limit ".$limit."\n";
#   if ($promptcount + $questioncount + buffer > $limit) {
#     @new = splice(@prompttokens,0,$limit - ($questioncount + $buffer));
#   } else {
#     @new = @prompttokens;
#   }
#   my $newprompt = join(' ',@new);



#   print '<<<'.$questioncount.':::'.$question.">>>\n" if $UNIVERSAL::debug;
#   print '<<<'.$promptcount.':::'.$newprompt.">>>\n" if $UNIVERSAL::debug;

#   my $finalprompt = $newprompt.' '.$question;
#   print '<<<'.($promptcount + $questioncount).':::'.$finalprompt.">>>\n" if $UNIVERSAL::debug;

#   my @finalprompttokens = split / +/, $finalprompt;
#   my $finalpromptcount = scalar @finalprompttokens;
#   print "<FINALPROMPT COUNT: $finalpromptcount>\n" if $UNIVERSAL::debug;

#   return
#     {
#      Success => 1,
#      Result => $finalprompt,
#     };
# }

# sub GetTokenCount2 {
#   my ($text) = @_;
#   my $tokens = GetTokens($text);
#   return length(@$tokens);

# }

# sub GetTokens {
#   my ($text) = @_;
#   $tokenizer->tokenize($text);
#   my @tokens = $tokenizer->getTokens();
#   return \@tokens;
# }

# sub ExtractList {
#   my (%args) = @_;
#   my $c = $args{Text};

#   my @results;
#   my $c1 = $c;
#   foreach my $line (split /\n/, $c1) {
#     if ($line =~ /^\s*<li[^>]+>\s*(.*?)\s*<\/li>/) {
#       push @results, $1;
#     } elsif ($line =~ /^\s*(\d+)\b\s*(.*?)$/) {
#       push @results, $2;
#     } elsif ($line =~ /^\s*([*+])\b\s*(.*?)$/) {
#       push @results, $2;
#     } elsif ($line =~ /\s*\*\s+(.*?)$/) {
#       push @results, $1;
#     }
#   }
#   return CleanExtractedList(List => \@results);
# }

# sub CleanExtractedList {
#   my (%args) = @_;
#   my $c = $args{List};
#   my @newlist;
#   foreach my $entry (@$c) {
#     $entry =~  s/^\s*[\.\*\+\s]*//sg;
#     push @newlist, $entry;
#   }
#   return \@newlist;
# }

# 1;
