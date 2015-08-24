package BenchmarkAnything::Storage::Frontend::HTTP::Controller::Search;
# ABSTRACT: BenchmarkAnything - Mojolicious - REST API

use Mojo::Base 'Mojolicious::Controller';

sub hello
{
        my ($self) = @_;

        $self->render;
}

sub search
{
        my ($self) = @_;

        my $value_id = $self->param('value_id');
        my $query    = $self->req->json;

        if ($value_id) {
                $self->render(json => $self->tapper_benchmark->get_single_benchmark_point($value_id));
        }
        elsif ($query)
        {
                $self->render(json => $self->tapper_benchmark->search_array($query));
        }
        else
        {
                $self->render(json => []);
        }
}

sub listnames
{
        my ($self) = @_;

        my $pattern = $self->param('pattern');

        my @pattern = $pattern ? ($pattern) : ();
        my $answer = $self->tapper_benchmark->list_benchmark_names(@pattern);

        $self->render(json => $self->tapper_benchmark->list_benchmark_names(@pattern));
}

1;
