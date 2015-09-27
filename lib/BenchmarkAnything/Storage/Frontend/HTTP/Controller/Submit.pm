package BenchmarkAnything::Storage::Frontend::HTTP::Controller::Submit;
# ABSTRACT: BenchmarkAnything - REST API - data submit

use Mojo::Base 'Mojolicious::Controller';

=head2 add

Parameters:

=over 4

=item * JSON request body

If a JSON request is provided it is interpreted as an array of
BenchmarkAnything data points according to
L<BenchmarkAnything::Schema|BenchmarkAnything::Schema>, inclusive the
surrounding hash key C<BenchmarkAnythingData>.

=back

=cut

sub add
{
        my ($self) = @_;

        my $data = $self->req->json;

        if ($data)
        {
                if (!$ENV{HARNESS_ACTIVE}) {
                        my $orig = $self->app->balib->{queuemode};
                        $self->app->balib->{queuemode} = 1;
                        $self->app->balib->add($data);
                        $self->app->balib->{queuemode} = $orig;
                } else {
                        $self->app->balib->add($data);
                }
        }
        # how to report error?
        $self->render;
}

1;
