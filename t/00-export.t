use strict;
use warnings;

use Test::More tests => 4;

package t::default { use URI::Query::FromHash }

is_deeply
    [ sort keys %t::default:: ],
    [qw/BEGIN hash2query/],
    'use URI::Query::FromHash';

package t::empty { use URI::Query::FromHash () }

is_deeply
    [ sort keys %t::empty:: ],
    ['BEGIN'],
    'use URI::Query::FromHash ()';

package t::explicit { use URI::Query::FromHash 'hash2query' }

is_deeply
    [ sort keys %t::explicit:: ],
    [qw/BEGIN hash2query/],
    'use URI::Query::FromHash "hash2query"';

package t::foo { use URI::Query::FromHash 'foo' }

is_deeply
    [ sort keys %t::foo:: ],
    [qw/BEGIN hash2query/],
    'use URI::Query::FromHash "foo"';
