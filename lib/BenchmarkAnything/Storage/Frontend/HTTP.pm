use strict;
use warnings;
package BenchmarkAnything::Storage::Frontend::HTTP;
# ABSTRACT: Access a BenchmarkAnything store via HTTP

use Mojo::Base 'Mojolicious';

require File::HomeDir; # MUST 'require', 'use' conflicts with Mojolicious
require Tapper::Benchmark;
require File::Slurp;
require YAML::Any;
require DBI;

# config
my $configfile  = $ENV{BENCHMARKANYTHING_CONFIGFILE} || File::HomeDir->my_home . "/.benchmarkanything.cfg";
my $config      = YAML::Any::Load("".File::Slurp::read_file($configfile));

# connection
my $dsn              = $config->{benchmarkanything}{backends}{tapper}{benchmark}{dsn};
my $user             = $config->{benchmarkanything}{backends}{tapper}{benchmark}{user};
my $password         = $config->{benchmarkanything}{backends}{tapper}{benchmark}{password};
my $dbh              = DBI->connect ($dsn, $user, $password, { RaiseError => 1, AutoCommit => 1 });
my $tapper_benchmark = Tapper::Benchmark->new ({ dbh => $dbh, debug => 0 });

# This method will run once at server start
sub startup {
        my $self = shift;

        $self->plugin('InstallablePaths');

        # Normal route to controller
        # # helper
        $self->helper (tapper_benchmark => sub { $tapper_benchmark } );

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
}

1;
