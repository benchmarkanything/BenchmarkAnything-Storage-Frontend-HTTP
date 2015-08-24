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

        my $query;
        if ($value_id) {
                $self->render(json => $self->tapper_benchmark->get_single_benchmark_point($value_id));
        }
        else
        {
                $self->render(json => { This => { Is => [ qw(a deeply nested json) ], Example => ".", }, }, );
        }
}

sub listnames
{
        my ($self) = @_;

        my $pattern = $self->param('pattern');

        if ($pattern) {
                $self->render(json => [qw(dummy metric names matching pattern), $pattern]);
        }
        else
        {
                $self->render(json => [qw(all dummy metric names pattern)]);
        }
}

sub fullpoint
{
        my ($self) = @_;

        my $value_id = $self->param('value_id');
}

1;
