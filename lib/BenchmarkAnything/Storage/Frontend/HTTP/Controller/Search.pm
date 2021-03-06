package BenchmarkAnything::Storage::Frontend::HTTP::Controller::Search;
# ABSTRACT: BenchmarkAnything - REST API - data query

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
L<BenchmarkAnything::Storage::Backend::SQL::search()|BenchmarkAnything::Storage::Backend::SQL/search>.

=back

=cut

sub search
{
        my ($self) = @_;

        my $value_id = $self->param('value_id');
        my $query    = $self->req->json;

        if ($value_id) {
                $self->render(json => $self->app->backend->get_single_benchmark_point($value_id));
        }
        elsif ($query)
        {
                $self->render(json => $self->app->backend->search_array($query));
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
        my $answer = $self->app->backend->list_benchmark_names(@pattern);

        $self->render(json => $answer);
}

=head2 listkeys

Returns a list of additional key names.

Parameters:

=over 4

=item * pattern (STRING)

If a pattern is provided it restricts the results. The pattern is used
as SQL LIKE pattern, i.e., it allows to use C<%> as wildcards.

=back

=cut

sub listkeys
{
        my ($self) = @_;

        my $pattern = $self->param('pattern');

        my @pattern = $pattern ? ($pattern) : ();
        my $answer = $self->app->backend->list_additional_keys(@pattern);

        $self->render(json => $answer);
}

=head2 stats

Returns a hash with info about the storage, like how many data points,
how many metrics, how many additional keys, are stored.

Parameters: none

=cut

sub stats
{
        my ($self) = @_;

        my $answer = $self->app->backend->get_stats;

        $self->render(json => $answer);
}

1;
