use strict;
use warnings;
package BenchmarkAnything::Storage::Frontend::HTTP;
# ABSTRACT: Access a BenchmarkAnything store via HTTP

use Mojo::Base 'Mojolicious';

# This method will run once at server start
sub startup {
        my $self = shift;

        my $routes = $self->routes;

        # Normal route to controller
        $routes->any('/api/v1/search')->to('search#search');
}

1;
