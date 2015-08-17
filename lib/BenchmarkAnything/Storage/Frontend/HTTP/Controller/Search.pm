package BenchmarkAnything::Storage::Frontend::HTTP::Controller::Search;
# ABSTRACT: BenchmarkAnything - Mojolicious - REST API

use Mojo::Base 'Mojolicious::Controller';

sub search
{
        my ($self) = @_;

        $self->render(json => {
                               This => {
                                        Is => [
                                               qw(a deeply nested json)
                                              ],
                                        Example => ".",
                                       },
                              },
                     );
}

1;
