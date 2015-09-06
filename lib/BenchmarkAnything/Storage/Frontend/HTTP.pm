use strict;
use warnings;
package BenchmarkAnything::Storage::Frontend::HTTP;
# ABSTRACT: Access a BenchmarkAnything store via HTTP

use Mojo::Base 'Mojolicious';

require BenchmarkAnything::Storage::Frontend::Lib;
require File::HomeDir; # MUST 'require', 'use' conflicts with Mojolicious
require Tapper::Benchmark;
require File::Slurp;
require YAML::Any;
require DBI;

my $balib            = BenchmarkAnything::Storage::Frontend::Lib->new;
my $tapper_benchmark = Tapper::Benchmark->new ({ dbh => $balib->{dbh}, debug => 0 });

# This method will run once at server start
sub startup {
        my $self = shift;

        $self->plugin('InstallablePaths');

        # helper
        $self->helper (tapper_benchmark => sub { $tapper_benchmark } );
        $self->helper (balib            => sub { $balib } );

        # routes
        my $routes = $self->routes;
        $routes
            ->any('/api/v1/search/:value_id' => [value_id => qr/\d+/])
            ->to('search#search', value_id => 0);
        $routes
            ->any('/api/v1/listnames/:pattern' => [pattern => qr/[^\/]+/])
            ->to('search#listnames', pattern => '');
        $routes
            ->any('/api/v1/hello')
            ->to('search#hello');
        $routes
            ->any('/api/v1/add')
            ->to('submit#add');
}

1;
