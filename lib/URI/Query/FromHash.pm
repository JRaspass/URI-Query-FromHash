package URI::Query::FromHash 0.002;

use strict;
use warnings;

my %escapes;
$escapes{+chr} = sprintf '%%%02X', $_ for 0..255;

sub import {
    no strict 'refs';

    *{ caller . '::hash2query' } = \&hash2query;
}

sub hash2query(+%) {
    my $q = '';

    while ( my ($k, $v) = each %{ $_[0] // return '' } ) {
        $k =~ s|([;/?:@&=+,\$\[\]%])|$escapes{$1}|g;
        $k =~ y| |+|;

        for ( ref $v ? @$v : $v ) {
            # Avoid modifying the original.
            my $v = $_;

            $v =~ s|([;/?:@&=+,\$\[\]%])|$escapes{$1}|g;
            $v =~ y| |+|;

            $q .= "$k=$v&";
        }
    }

    # Trim off the last "&".
    substr $q, -1, 1, '';

    utf8::encode $q;

    $q =~ s|([^\Q;/?:@&=+,\$\[\]%-_.!~*'()\EA-Za-z0-9])|@escapes{ split //, $1 }|eg;

    $q;
}

1;
