package BenchmarkAnything::Storage::Frontend::HTTP::Controller::Search;
# ABSTRACT: BenchmarkAnything - Mojolicious - REST API

use Mojo::Base 'Mojolicious::Controller';

=head2 hello

Returns a hello answer. Mostly for self and unit testing.

=cut

sub hello
{
        my ($self) = @_;

        $self->render;
}

=head2 search

Parameters:

=over 4

=item * value_id (INTEGER)

If a single integer value is provided the complete data point for that
ID is returned.

=item * JSON request body

If a JSON request is provided it is interpreted as query according to
L<Tapper::Benchmark::search()|Tapper::Benchmark/search>.

=back

=cut

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

=head2 listnames

Returns a list of available benchmark metric NAMEs.

Parameters:

=over 4

=item * pattern (STRING)

If a pattern is provided it restricts the results. The pattern is used
as SQL LIKE pattern, i.e., it allows to use C<%> as wildcards.

=back

=cut

sub listnames
{
        my ($self) = @_;

        my $pattern = $self->param('pattern');

        my @pattern = $pattern ? ($pattern) : ();
        my $answer = $self->tapper_benchmark->list_benchmark_names(@pattern);

        $self->render(json => $self->tapper_benchmark->list_benchmark_names(@pattern));
}

1;
