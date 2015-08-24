use Mojo::Base -strict;

use Test::More;
use Test::Mojo;

my $cfgfile   = "t/benchmarkanything-tapper.cfg";
my $dsn       = 'dbi:SQLite:t/benchmarkanything.sqlite';

$ENV{BENCHMARKANYTHING_CONFIGFILE} = $cfgfile;

my $t = Test::Mojo->new('BenchmarkAnything::Storage::Frontend::HTTP');
$t->get_ok('/')->status_is(200)->content_like(qr/Mojolicious/i);

done_testing();
