package Mock::Logic::Simple;
use strict;
use warnings;
use base 'Data::Model';
use Data::Model::Schema;
use Data::Model::Driver::Logic;

my $logic = Data::Model::Driver::Logic->new;

install_model tusr => schema {
    driver $logic;
    key 'id';
    columns qw/id name/;
};

sub get_tusr {
    my($self, $schema, $key, $columns, %args) = @_;
    my $obj = +{ id => $key->[0] };
    $obj->{name} = 'Osawa' if $key->[0] eq 'yappo';
    $obj->{name} = 'Danjou' if $key->[0] eq 'lopnor';
    $obj;
}

sub set_tusr {
    my($self, $schema, $key, $columns, %args) = @_;
    $columns;
}

sub update_tusr {}

sub delete_tusr {
    my($self, $schema, $key, $columns, %args) = @_;
    $key->[0] eq 'ok' ? 1 : 0;
}

install_model barerow => schema {
    driver $logic;
    key 'id';
    columns qw/ id name /;
    schema_options bare_row => 1;
};

sub get_barerow { get_tusr(@_) }
sub set_barerow { set_tusr(@_) }
sub delete_barerow { delete_tusr(@_) }

1;
