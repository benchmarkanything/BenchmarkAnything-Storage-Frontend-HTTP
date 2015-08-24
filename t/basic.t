use Mojo::Base -strict;

use Test::More;
use Test::Mojo;

my $t = Test::Mojo->new('BenchmarkAnything::Storage::Frontend::HTTP');
$t->get_ok('/api/v1/listnames')->status_is(200);

done_testing();
