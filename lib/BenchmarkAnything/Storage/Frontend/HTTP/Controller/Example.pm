package BenchmarkAnything::Storage::Frontend::HTTP::Controller::Example;
# ABSTRACT: BenchmarkAnything - Mojolicious - initial example

use Mojo::Base 'Mojolicious::Controller';

=head2 welcome

Example Hello World style answer.

=cut

# This action will render a template
sub welcome {
  my $self = shift;

  # Render template "example/welcome.html.ep" with message
  $self->render(msg => 'Welcome to the Mojolicious real-time web framework!');
}

1;
