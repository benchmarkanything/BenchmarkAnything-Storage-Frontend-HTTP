use strict;
use warnings;
package BenchmarkAnything::Storage::Frontend::HTTP;
# ABSTRACT: Access a BenchmarkAnything store via HTTP

use Mojo::Base 'Mojolicious';

# This method will run once at server start
sub startup {
        my $self = shift;

        $self->plugin('InstallablePaths');

        # Normal route to controller
        my $routes = $self->routes;
        $routes
            ->any('/api/v1/search/:value_id' => [value_id => qr/\d+/])
            ->to('search#search', value_id => 0);
        $routes
            ->any('/api/v1/listnames/:pattern' => [value_id => qr/[\\.\w*+=\%]+/])
            ->to('search#listnames', value_id => 0);
}

1;
