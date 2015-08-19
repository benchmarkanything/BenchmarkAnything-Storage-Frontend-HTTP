package BenchmarkAnything::Storage::Frontend::HTTP::Controller::Search;
# ABSTRACT: BenchmarkAnything - Mojolicious - REST API

use Mojo::Base 'Mojolicious::Controller';

sub search
{
        my ($self) = @_;

        my $value_id = $self->param('value_id');

        if ($value_id) {
                $self->render(json => {
                                       VALUE_ID => $value_id,
                                      });
        }
        else
        {
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
}

1;
