package Mock::Tests::Binary;
use t::Utils;
use base 'Test::Class';
use Mock::Tests;
use Test::More;

#my @list = qw( 10 2 43 0 9 84 45 255 );
my @list = qw( 54 0 43 0 9 84 45 255 );
sub t_01_set : Tests(4) {
    my $bin = pack 'C*', @list; 
    my $set = mock->set( model => 1 => { data => $bin } );
    isa_ok $set, mock_class."::model";
    is $set->id, 1, 'id';
    is $set->data, $bin, 'binary data';

    use bytes;
    is bytes::length($set->data), 8, 'length';
}

sub t_02_get : Tests(4) {
    my $bin = pack 'C*', @list;
    my($get) = mock->get( model => 1 );
    isa_ok $get, mock_class."::model";
    is $get->id, 1, 'id';
    is $get->data, $bin, 'binary data';

    use bytes;
    is bytes::length($get->data), 8, 'length';
}

sub t_11_set_bin_id : Tests(3) {
    my $bin = pack 'C*', @list; 
    my $set = mock->set( model_bin_id => $bin );
    isa_ok $set, mock_class."::model_bin_id";
    is $set->id, $bin, 'id';

    use bytes;
    is bytes::length($set->id), 8, 'length';
}

sub t_12_get : Tests(3) {
    my $bin = pack 'C*', @list;
    my($get) = mock->get( model_bin_id => $bin );
    isa_ok $get, mock_class."::model_bin_id";
    is $get->id, $bin, 'id';

    use bytes;
    is bytes::length($get->id), 8, 'length';
}

1;

