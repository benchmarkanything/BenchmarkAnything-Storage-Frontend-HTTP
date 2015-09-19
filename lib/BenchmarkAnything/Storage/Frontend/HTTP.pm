use strict;
use warnings;
package BenchmarkAnything::Storage::Frontend::HTTP;
# ABSTRACT: Access a BenchmarkAnything store via HTTP

use Mojo::Base 'Mojolicious';

require BenchmarkAnything::Storage::Frontend::Lib;
require File::HomeDir; # MUST 'require', 'use' conflicts with Mojolicious
require BenchmarkAnything::Storage::Backend::SQL;
require File::Slurp;
require YAML::Any;
require DBI;

my $balib   = BenchmarkAnything::Storage::Frontend::Lib->new;
my $backend = BenchmarkAnything::Storage::Backend::SQL->new ({ dbh => $balib->{dbh}, debug => 0 });

# This method will run once at server start
sub startup {
        my $self = shift;

        $self->log->debug("Using BenchmarkAnything");
        $self->log->debug(" - Configfile: ".$balib->{cfgfile});
        $self->log->debug(" - Backend:    ".$balib->{config}{benchmarkanything}{backend});
        $self->log->debug(" - DSN:        ".$balib->{config}{benchmarkanything}{storage}{backend}{sql}{dsn});
        die "Config backend:".$balib->{config}{benchmarkanything}{backend}."' not yet supported (".$balib->{cfgfile}."), must be 'local'.\n"
         if $balib->{config}{benchmarkanything}{backend} ne 'local';

        my $queueing_processing_batch_size = $balib->{config}{benchmarkanything}{storage}{backend}{sql}{queueing}{processing_batch_size} || 100;
        my $queueing_processing_sleep      = $balib->{config}{benchmarkanything}{storage}{backend}{sql}{queueing}{processing_sleep}      ||  30;
        my $queueing_gc_sleep              = $balib->{config}{benchmarkanything}{storage}{backend}{sql}{queueing}{gc_sleep}              || 120;

        $self->log->debug(" - Q.batch_size: $queueing_processing_batch_size");
        $self->log->debug(" - Q.sleep:      $queueing_processing_sleep");
        $self->log->debug(" - Q.gc_sleep:   $queueing_gc_sleep");

        $self->plugin('InstallablePaths');

        # helper
        $self->helper (backend => sub { $backend } );
        $self->helper (balib   => sub { $balib   } );

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
