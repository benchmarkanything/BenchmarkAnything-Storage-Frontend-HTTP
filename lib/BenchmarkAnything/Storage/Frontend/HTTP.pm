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

        $self->log->debug("Using BenchmarkAnything");
        $self->log->debug(" - Configfile: ".$balib->{cfgfile});
        $self->log->debug(" - Frontend:   ".$balib->{config}{benchmarkanything}{frontend});
        $self->log->debug(" - DSN:        ".$balib->{config}{benchmarkanything}{backends}{tapper}{benchmark}{dsn});
        die "Config frontend:".$balib->{config}{benchmarkanything}{frontend}."' not yet supported (".$balib->{cfgfile}."), must be 'lib'.\n"
         if $balib->{config}{benchmarkanything}{frontend} ne 'lib';

        my $queueing_processing_batch_size = $balib->{config}{benchmarkanything}{backends}{tapper}{benchmark}{queueing}{processing_batch_size} || 100;
        my $queueing_processing_sleep      = $balib->{config}{benchmarkanything}{backends}{tapper}{benchmark}{queueing}{processing_sleep}      ||  30;
        my $queueing_gc_sleep              = $balib->{config}{benchmarkanything}{backends}{tapper}{benchmark}{queueing}{gc_sleep}              || 120;

        $self->plugin('InstallablePaths');

        # helper
        $self->helper (tapper_benchmark => sub { $tapper_benchmark } );
        $self->helper (balib            => sub { $balib } );

        # recurrinbox worker
        Mojo::IOLoop->recurring($queueing_processing_sleep => sub {
                                        $self->log->debug("process bench queue (batchsize: $queueing_processing_batch_size) [".~~localtime."]");
                                        $self->balib->process_raw_result_queue($queueing_processing_batch_size);
                                });
        Mojo::IOLoop->recurring($queueing_gc_sleep => sub {
                                        $self->log->debug("garbage collection [".~~localtime."]");
                                        $self->balib->gc();
                                });

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
