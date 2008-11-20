package Data::Model::Schema::Properties;
use strict;
use warnings;
use base qw(Data::Model::Accessor);

use Data::Model::Schema;
use Data::Model::Schema::SQL;

__PACKAGE__->mk_accessors(qw/ driver schema_class model class column index unique key options /);

our @RESERVED = qw(
    update save new
    add_trigger call_trigger remove_trigger
);


sub new {
    my($class, %args) = @_;
    bless { %args }, $class;
}

sub add_keys {
    my($self, $key, %args) = @_;
    $self->{key} = ref($key) eq 'ARRAY' ? $key : [ $key ];
}

BEGIN {
    for my $name (qw/ unique index /) {
        no strict 'refs';
        *{"add_$name"} = sub {
            my($self, $index, $columns, %args) = @_;
            my $key = $columns || $index;
            die sprintf '%s::%s : %s name is require', $self->schema_class, $self->name, $name
                if ref($index) || !defined $index; 
            $key = [ $key ] unless ref($key) eq 'ARRAY';
            $self->{$name}->{$index} = $key;
        };
    }
}

sub add_column {
    my $self = shift;
    my($column, $type, $options) = @_;
    return $self->add_column_sugar(@_) if $column =~ /^[^\.+]+\.[^\.+]+$/;
    Carp::croak "Column can't be called '$column': reserved name" 
            if grep { lc $_ eq lc $column } @RESERVED;

    push @{ $self->{columns} }, $column;
    $self->{column}->{$column} = +{
        type    => $type    || 'char',
        options => $options || +{},
    };
}

sub add_column_sugar {
    my $self   = shift;
    my $name   = shift;
    my $sugar = Data::Model::Schema->get_column_sugar($self);
    Carp::croak "Undefined column of '$name'" 
        unless exists $sugar->{$name} && $sugar->{$name};

    my $conf = $sugar->{$name};
    my %clone = (
        type    => $conf->{type},
        options => +{ %{ $conf->{options} } },
    );
    my $column;
    if (@_ == 0 || ref($_[0])) {
        my $model;
        ($model, $column) = split /\./, $name;
        unless ($self->{model} eq $model) {
            $column = join '_', $model, $column;
        }
    } else {
        $column = shift;
    }
    if (@_ && ref($_[0]) eq 'HASH') {
        $clone{options} = +{ %{ $clone{options} }, %{ ( shift ) } } 
    }
    $self->add_column($column, $clone{type}, $clone{options});
}

sub add_options {
    my $self = shift;
    if (ref($_[0]) eq 'HASH') {
        $self->options(shift);
    } elsif (!(@_ % 2)) {
        while (my($key, $value) = splice @_, 0, 2) {
            $self->options->{$key} = $value;
        }
    }
}



sub column_names {
    my $self = shift;
    @{ $self->{columns} };
}

sub column_type {
    my($self, $column) = @_;
    $self->{column}->{$column}->{type} || 'char';
}
sub column_options {
    my($self, $column) = @_;
    $self->{column}->{$column}->{options} || +{};
}



sub get_key_array_by_hash {
    my($self, $hash) = @_;
    my @keys;
    for my $key (@{ $self->{key} }) {
        push @keys, $hash->{$key};
    }
    \@keys;
}

sub get_columns_hash_by_key_array_and_hash {
    my($self, $hash, $array) = @_;
    my $ret = {};

    # by column
    for my $column (keys %{ $self->{column} }) {
        $ret->{$column} = $hash->{$column};
    }

    # by key
    my $key = $self->{key};
    $key = [ $key ] unless ref($key) eq 'ARRAY';
    @{ $ret }{@{ $key }} = @{ $array };

    $ret;
}


sub sql {
    my $self = shift;
    $self->{sql} ||= Data::Model::Schema::SQL->new($self);
}


1;