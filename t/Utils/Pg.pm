package t::Utils::Pg;
use strict;
use Data::Model::Schema::Properties;

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
no warnings 'redefine';
sub Data::Model::Schema::Properties::default_column_type { 'text' }

1;
