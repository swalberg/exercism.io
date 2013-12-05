use strict;
use warnings;

use Test::More;
use JSON qw(from_json);

my $cases_file = 'cases.json';
my $cases;
if (open my $fh, '<', $cases_file) {
    local $/ = undef;
    $cases = from_json scalar <$fh>;
} else {
    die "Could not open '$cases_file' $!";
}

#plan tests => 3 + @$cases;
#diag explain $cases; 

ok -e 'Queens.pm', 'missing Queens.pm'
    or BAIL_OUT("You need to create a class called Queens.pm with a constructor called new.");

eval "use Queens";
ok !$@, 'Cannot load Queens.pm'
    or BAIL_OUT('Does Queens.pm compile?  Does it end with 1; ?');

can_ok('Queens', 'new') or BAIL_OUT("Missing package Queens; or missing sub new()");

foreach my $c (@$cases) {
	my $q = Queens->new(%{ $c->{params} });
	if ($c->{white}) {
		is_deeply $q->white, $c->{white}, "$c->{name} white";
	}
	if ($c->{black}) {
		is_deeply $q->black, $c->{black}, "$c->{name} black";
	}
}


done_testing();
