package Data::Model::Driver::DBI::DBD::Pg;
use strict;
use warnings;
use base 'Data::Model::Driver::DBI::DBD';

sub fetch_last_id {
    my ( undef, undef, $dbh, undef, $table ) = @_;
    $dbh->last_insert_id( undef, undef, $table, undef );
}

sub bind_param_attributes {
    my($self, $data_type) = @_;
    if ($data_type) {
        if ($data_type =~ /(?:blob|bin|bytea)/i) {
            return { pg_type => DBD::Pg::PG_BYTEA() };
        }
    }
    return;
}

sub _as_sql_column {
    my($self, $c, $column, $args) = @_;

    # for primary key
    if (exists $args->{options}->{auto_increment} && $args->{options}->{auto_increment}) {
        $c->{_sqlite_output_primary_key} = 1;
        return sprintf('%-15s %-15s', $column, 'SERIAL');
    }

    # binary flagged is BYTEA
    if (exists $args->{options}->{binary} && $args->{options}->{binary}) {
        return sprintf('%-15s %-15s', $column, 'BYTEA');
    }

    return;
}

sub _as_sql_column_type {
    my($self, $c, $column, $args) = @_;
    my $type = uc($args->{type});
    if ($type =~ /(?:BIN|BYTEA|BLOB)/) {
        $args->{options}->{binary} = 0;
        return "BYTEA";
    }
    return;
}

sub _as_sql_type_attributes { '' }

sub _as_sql_unsigned { }

sub _as_sql_primary_key { }

sub _as_sql_unique {
    my($self, $c, $unique) = @_;
    return () unless @{ $unique };

    my @sql = ();
    for my $data (@{ $unique }) {
        my($name, $columns)  = @{ $data };
        push(@sql, 'UNIQUE (' . join(', ', @{ $columns }) . ')');
    }
    return @sql;
}

sub _as_sql_get_table_attributes {
    my($self, $c, $attributes) = @_;
    return '' unless $attributes->{Pg};
    return $attributes->{Pg};
}

1;
