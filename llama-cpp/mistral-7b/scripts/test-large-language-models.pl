#!/usr/bin/env perl

# System::GPT3
use Capability::LargeLanguageModels;
use PerlLib::SwissArmyKnife;

my $llms = Capability::LargeLanguageModels->new();
my $res1 = $llms->Query(Prompt => "Negative self-talk: I am fudged. Positive reframing: I ");
print Dumper({Res1 => $res1});

