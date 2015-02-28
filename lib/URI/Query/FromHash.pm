package URI::Query::FromHash 0.001;

use strict;
use warnings;

my %escapes;
@escapes{ map chr, 0..255 } = map { sprintf '%%%02X', $_ } 0..255;

# TODO bench
# $escapes{+chr} = sprintf '%%%02X', $_ for 0..255;

sub import {
    no strict 'refs';

    *{ caller . '::hash2query' } = \&hash2query;
}

sub hash2query {
    my $args = shift;

    my $q = '';

    # TODO test we don't modify values (we blatently do!)
    for my $key ( sort keys %$args ) {
        $key =~ s|([;/?:@&=+,\$\[\]%])|$escapes{$1}|g;
        $key =~ y| |+|;

        for ( ref $args->{$key} ? @{ $args->{$key} } : $args->{$key} ) {
            s|([;/?:@&=+,\$\[\]%])|$escapes{$1}|g;
            y| |+|;

            $q .= "$key=$_&";
        }
    }

    # Trim off the last "&".
    substr $q, -1, 1, '';

    utf8::encode $q;

    $q =~ s|([^\Q;/?:@&=+,$[]%-_.!~*'()\EA-Za-z0-9])|@escapes{ split //, $1 }|eg;

    $q;
}

1;
