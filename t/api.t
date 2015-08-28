use Mojo::Base -strict;

use Test::More;
use Test::Mojo;

my $cfgfile   = "t/benchmarkanything-tapper.cfg";
my $dsn       = 'dbi:SQLite:t/benchmarkanything.sqlite';

$ENV{BENCHMARKANYTHING_CONFIGFILE} = $cfgfile;

my $t = Test::Mojo->new('BenchmarkAnything::Storage::Frontend::HTTP');
$t->get_ok('/api/v1/search')->status_is(200);

done_testing();
