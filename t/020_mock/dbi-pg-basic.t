use t::Utils config => +{
    type   => 'Basic',
    driver => 'DBI',
    dsn    => 'dbi:Pg:dbname=test',
};

Data::Model::Schema::Properties->add_trigger(
    post_load => sub {
        my ($schema, $obj) = @_;
        for my $name ( $schema->column_names ) {
            if ( $schema->column_type($name) eq 'char' ) {
                $obj->{column_values}->{$name} =~ s/ +\z//;
            }
        }
    }
);

run;
