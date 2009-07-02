package Mock::SetBaseDriver;
use strict;
use warnings;
use base 'Data::Model';
use Data::Model::Schema;
use Data::Model::Driver::Memory;

base_driver(Data::Model::Driver::Memory->new);

install_model tusr => schema {
    key 'id';
    columns qw/id name/;
};

install_model bookmark => schema {
    key 'id';
    unique 'url';

    column id
        => int => {
            auto_increment => 1,
        };

    column 'url';
};

install_model bookmark_tusr => schema {
    my $columns = [qw/ bookmark_id tusr_id /];
    key $columns;
    index 'tusr_id';

    columns @{ $columns };
};

1;
