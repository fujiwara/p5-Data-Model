use t::Utils;
use Test::More tests => 3;

use Mock::Basic;

my $tusr = Mock::Basic::tusr->new;
isa_ok $tusr, 'Mock::Basic::tusr';
my $bookmark = Mock::Basic::bookmark->new;
isa_ok $bookmark, 'Mock::Basic::bookmark';
my $bookmark_tusr = Mock::Basic::bookmark_tusr->new;
isa_ok $bookmark_tusr, 'Mock::Basic::bookmark_tusr';
