package Mock::Basic;
use strict;
use warnings;
use base 'Data::Model';
use Data::Model::Schema;

install_model tusr => schema {
    driver $main::DRIVER;
    key 'id';
    columns qw/id name/;
};

install_model bookmark => schema {
    driver $main::DRIVER;
    key 'id';
    unique 'url';

    column id
        => int => {
            auto_increment => 1,
        };

    column 'url';
};

install_model bookmark_tusr => schema {
    driver $main::DRIVER;
    key [qw/ bookmark_id tusr_id /];
    index 'tusr_id';

    column bookmark_id
        => char => {
            size => 100,
        };
    column tusr_id
        => char => {
            size => 100,
        };
};

1;
