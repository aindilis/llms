package LLMs::Templating;

use PerlLib::SwissArmyKnife;

use Template;

use Class::MethodMaker
  new_with_init => 'new',
  get_set       =>
  [

   qw / MyTemplate /

  ];

our $stub = '';

sub init {
  my ($self,%args) = @_;
  my $config =
    {
     INCLUDE_PATH => '/var/lib/myfrdcsa/codebases/minor/llms/data-git/templates', # or list ref
     INTERPOLATE  => 1,		# expand "$var" in plain text
     POST_CHOMP   => 1,		# cleanup whitespace
     # PRE_PROCESS  => 'header', # prefix each template
     EVAL_PERL    => 1,		# evaluate Perl code blocks
    };
  $self->MyTemplate
    (Template->new
     (
      $config
     ));
}

sub Process {
  my ($self,%args) = @_;
  my $vars = $args{Vars};
  $stub = '';
  $self->MyTemplate->process
    (
     $args{TemplateName},
     $vars,
     sub {$stub = $_[0];},
    ) || die $self->MyTemplate->error(), "\n";
  my $result = $stub;
  $stub = '';
  return $result;
}

1;
