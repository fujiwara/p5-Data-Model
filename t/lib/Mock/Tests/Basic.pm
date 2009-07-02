package Mock::Tests::Basic;
use t::Utils;
use base 'Test::Class';
use Mock::Tests;
use Test::More;

sub t_01_basic : Tests {
    my $ret1 = mock->set( tusr => 'yappo', { name => 'Kazuhiro Osawa' } );
    isa_ok $ret1, mock_class."::tusr";
    is $ret1->id, 'yappo';
    is $ret1->name, 'Kazuhiro Osawa';

    my($ret2) = mock->get( tusr => 'yappo' );
    isa_ok $ret2, mock_class."::tusr";
    is $ret2->id, 'yappo';
    is $ret2->name, 'Kazuhiro Osawa';

    ok mock->delete( tusr => 'yappo' ), 'delete ok';
    ($ret2) = mock->get( tusr => 'yappo' );
    ok !$ret2, 'get error';
    ok !mock->delete( tusr => 'yappo' ), 'delete error';
}

sub t_02_insert_bookmark_tusr : Tests {
    my $ret1 = mock->set( bookmark_tusr => [qw/ 1 yappo /] );
    isa_ok $ret1, mock_class."::bookmark_tusr";
    is $ret1->bookmark_id, 1, 'bookmark_id';
    is $ret1->tusr_id, 'yappo';

    $ret1 = mock->set( bookmark_tusr => [qw/ 1 lopnor /] );
    is $ret1->bookmark_id, 1;
    is $ret1->tusr_id, 'lopnor';

    $ret1 = mock->set( bookmark_tusr => [qw/ 2 yappo /] );
    is $ret1->bookmark_id, 2;
    is $ret1->tusr_id, 'yappo';

    $ret1 = mock->set( bookmark_tusr => [qw/ 2 lopnor /] );
    is $ret1->bookmark_id, 2;
    is $ret1->tusr_id, 'lopnor';
}

sub t_03_get : Tests {
    my($ret2) = mock->get( bookmark_tusr => [qw/ 1 yappo /] );
    isa_ok $ret2, mock_class."::bookmark_tusr";
    is $ret2->bookmark_id, 1;
    is $ret2->tusr_id, 'yappo';
}
        
sub t_03_order : Tests {
    my($ret3) = mock->get( bookmark_tusr => '1', { order => [ { tusr_id => 'DESC' } ] } );
    isa_ok $ret3, mock_class."::bookmark_tusr";
    is $ret3->bookmark_id, 1;
    is $ret3->tusr_id, 'yappo';
}

sub t_03_index : Tests {
    my($ret4) = mock->get( bookmark_tusr => {
        index => { tusr_id => 'lopnor' },
        order => [{ bookmark_id => 'DESC' }],
    });
    isa_ok $ret4, mock_class."::bookmark_tusr";
    is $ret4->bookmark_id, 2;
    is $ret4->tusr_id, 'lopnor';
}
    
sub t_04_delete : Tests {
    ok mock->delete( bookmark_tusr => [qw/ 1 yappo /] ), 'delete bookmark_tusr';
    ok !mock->get( bookmark_tusr => [qw/ 1 yappo /] ), 'get error bookmark_tusr';
    ok !mock->delete( bookmark_tusr => [qw/ 1 yappo /] ), 'delete error bookmark_tusr';
}

sub t_05_select_all_iterator : Tests(5) {
    my $itr = mock->get('bookmark_tusr');
    isa_ok $itr, 'Data::Model::Iterator';
    my $i = 0;
    while (my $row = $itr->next) {
        $i++;
        isa_ok $row, mock_class."::bookmark_tusr";
    }
    is $i, 3;
}

sub t_05_select_all_iterator_with_reset : Tests(8) {
    my $itr = mock->get('bookmark_tusr');
    isa_ok $itr, 'Data::Model::Iterator';
    my $i = 0;
    while (my $row = $itr->next) {
        $i++;
        isa_ok $row, mock_class."::bookmark_tusr";
    }
    $itr->reset;
    while (my $row = $itr->next) {
        $i++;
        isa_ok $row, mock_class."::bookmark_tusr";
    }
    is $i, 6;
}

sub t_05_select_all_iterator_limit : Tests(4) {
    my $itr = mock->get('bookmark_tusr', { limit => 2 });
    isa_ok $itr, 'Data::Model::Iterator';
    my $i = 0;
    while (my $row = $itr->next) {
        $i++;
        isa_ok $row, mock_class."::bookmark_tusr";
    }
    is $i, 2;
}

sub t_05_select_all_iterator_limit_offset : Tests(3) {
    my $itr = mock->get('bookmark_tusr', { limit => 1, offset => 2 });
    isa_ok $itr, 'Data::Model::Iterator';
    my $i = 0;
    while (my $row = $itr->next) {
        $i++;
        isa_ok $row, mock_class."::bookmark_tusr";
    }
    is $i, 1;
}

sub t_06_update : Tests {
    my($set) = mock->set( tusr => 'yappo' => { name => '-' } );
    is $set->name, '-', 'is -';
    my($obj) = mock->get( tusr => 'yappo' );

    $obj->name('Kazuhiro Osawa');
    $obj->update;
    my($obj2) = mock->get( tusr => 'yappo' );
    is $obj2->name, 'Kazuhiro Osawa', 'is Kazuhiro Osawa';

    $obj->name('Kazuhiro');
    mock->set($obj);
    my($obj3) = mock->get( tusr => 'yappo' );
    is $obj3->name, 'Kazuhiro', 'is Kazuhiro';

    $obj->name('Kazuhiro Osawa');
    mock->replace($obj);
    my($obj4) = mock->get( tusr => 'yappo' );
    is $obj4->name, 'Kazuhiro Osawa', 'is Kazuhiro Osawa';


    $obj->name('Osawa');
    mock->replace($obj);
    my($obj5) = mock->get( tusr => 'yappo' );
    is $obj5->name, 'Osawa', 'is Osawa';
}

sub t_06_update_2ndidx : Tests {
    my $set1 = mock->set( bookmark_tusr => [qw/ 10 jyappo /] );
    isa_ok $set1, mock_class."::bookmark_tusr";
    my $set2 = mock->set( bookmark_tusr => [qw/ 11 jyappo /] );
    isa_ok $set2, mock_class."::bookmark_tusr";

    my $row;
    my $it = mock->get( bookmark_tusr => { index => { tusr_id => 'jyappo' }, order => [{ bookmark_id => 'ASC' }] } );
    $row = $it->next;
    isa_ok $row, mock_class."::bookmark_tusr";
    is $row->bookmark_id, 10, '10 jyappo';
    is $row->tusr_id, 'jyappo', '10 jyappo';
    $row = $it->next;
    isa_ok $row, mock_class."::bookmark_tusr";
    is $row->bookmark_id, 11, '11 jyappo';
    is $row->tusr_id, 'jyappo', '11 jyappo';
    ok !$it->next;

    $row->tusr_id('iyappo');
    $row->update;

    $it = mock->get( bookmark_tusr => { index => { tusr_id => 'jyappo' }, order => [{ bookmark_id => 'ASC' }] } );
    $row = $it->next;
    isa_ok $row, mock_class."::bookmark_tusr";
    is $row->bookmark_id, 10, '10 jyappo';
    is $row->tusr_id, 'jyappo', '10 jyappo';
    ok !$it->next;

    $it = mock->get( bookmark_tusr => { index => { tusr_id => 'iyappo' }, order => [{ bookmark_id => 'ASC' }] } );
    $row = $it->next;
    isa_ok $row, mock_class."::bookmark_tusr";
    is $row->bookmark_id, 11, '11 iyappo';
    is $row->tusr_id, 'iyappo', '11 iyappo';
    ok !$it->next;
}

sub t_07_replace : Tests {
    my $set1  = mock->set( tusr => 'yappologs' => { name => 'blog' } );
    is $set1->name, 'blog', 'is blog';
    my($obj1) = mock->get( tusr => 'yappologs' );
    is $obj1->name, 'blog', 'is blog';

    my $set2  = mock->replace( tusr => 'yappologs' => { name => "yappo's blog" } );
    is $set2->name, "yappo's blog", "is yappo's blog";
    my($obj2) = mock->get( tusr => 'yappologs' );
    is $obj2->name, "yappo's blog", "is yappo's blog";
}

sub t_08_autoincrement : Tests {
    my $set1 = mock->set( bookmark => { url => 'url1' });
    is $set1->id, 1, 'set id1';
    is $set1->url, 'url1';

    my $set2 = mock->set( bookmark => { url => 'url2' });
    is $set2->id, 2, 'set id2';
    is $set2->url, 'url2';

    my $set3 = mock->set( bookmark => { url => 'url3' });
    is $set3->id, 3, 'set id3';
    is $set3->url, 'url3';


    my($key1) = mock->get( bookmark => 1 );
    is $key1->id, 1, 'key id1';
    is $key1->url, 'url1';

    my($key2) = mock->get( bookmark => 2 );
    is $key2->id, 2, 'key id2';
    is $key2->url, 'url2';

    my($key3) = mock->get( bookmark => 3 );
    is $key3->id, 3, 'key id3';
    is $key3->url, 'url3';


    my($idx1) = mock->get( bookmark => { index => { url => 'url1' } } );
    is $idx1->id, 1, 'idx id1';
    is $idx1->url, 'url1';

    my($idx2) = mock->get( bookmark => { index => { url => 'url2' } } );
    is $idx2->id, 2, 'idx id2';
    is $idx2->url, 'url2';

    my($idx3) = mock->get( bookmark => { index => { url => 'url3' } } );
    is $idx3->id, 3, 'idx id3';
    is $idx3->url, 'url3';
}

sub t_09_get_delete : Tests {
    my $set = mock->set( tusr => 'select-delete', { name => 'Kazuhiro Osawa' } );
    isa_ok $set, mock_class."::tusr";

    my($get) = mock->get( tusr => 'select-delete' );
    isa_ok $get, mock_class."::tusr";
    ok($get->delete, 'delete by row');

    ok(!mock->get( tusr => 'select-delete' ));
}

sub t_10_direct_update : Tests {
    my $set1 = mock->set( tusr => 'direct_update-1', { name => 'direct_update 1' } );
    isa_ok $set1, mock_class."::tusr";
    my $set2 = mock->set( tusr => 'direct_update-2', { name => 'direct_update 2' } );
    isa_ok $set2, mock_class."::tusr";

    my($get1) = mock->get( tusr => 'direct_update-1' );
    isa_ok $get1, mock_class."::tusr";
    is $get1->id, 'direct_update-1';
    is $get1->name, 'direct_update 1';
    my($get2) = mock->get( tusr => 'direct_update-2' );
    isa_ok $get2, mock_class."::tusr";
    is $get2->id, 'direct_update-2';
    is $get2->name, 'direct_update 2';

    ok mock->update(
        tusr => 'direct_update-1',
        undef, +{
            name => 'updated direct_update 1',
        },
    ), 'update 1';
    my($get3) = mock->get( tusr => 'direct_update-1' );
    isa_ok $get3, mock_class."::tusr";
    is $get3->id, 'direct_update-1';
    is $get3->name, 'updated direct_update 1';

    ok mock->update(
        tusr => ['direct_update-1'],
        undef, +{
            name => 'updated 2 direct_update 1',
        },
    ), 'update 2';
    my($get4) = mock->get( tusr => 'direct_update-1' );
    isa_ok $get4, mock_class."::tusr";
    is $get4->id, 'direct_update-1';
    is $get4->name, 'updated 2 direct_update 1';

    my($get5) = mock->get( tusr => 'direct_update-2' );
    isa_ok $get5, mock_class."::tusr";
    is $get5->id, 'direct_update-2';
    is $get5->name, 'direct_update 2';


    ok mock->update(
        tusr => +{
            where => [
                name => { LIKE => '%2' },
            ],
        }, +{
            name => 'updated direct_update 2',
        },
    ), 'update 3';
    my($get6) = mock->get( tusr => 'direct_update-1' );
    isa_ok $get6, mock_class."::tusr";
    is $get6->id, 'direct_update-1';
    is $get6->name, 'updated 2 direct_update 1';
    my($get7) = mock->get( tusr => 'direct_update-2' );
    isa_ok $get7, mock_class."::tusr";
    is $get7->id, 'direct_update-2';
    is $get7->name, 'updated direct_update 2';


    ok mock->update(
        tusr => ['direct_update-1'],
        undef, +{
            id   => 'direct_update-3',
            name => 'direct_update 3',
        },
    ), 'update 4';
    ok(!mock->get( tusr => 'direct_update-1' ));
    my($get8) = mock->get( tusr => 'direct_update-3' );
    isa_ok $get8, mock_class."::tusr";
    is $get8->id, 'direct_update-3';
    is $get8->name, 'direct_update 3';
    my($get9) = mock->get( tusr => 'direct_update-2' );
    isa_ok $get9, mock_class."::tusr";
    is $get9->id, 'direct_update-2';
    is $get9->name, 'updated direct_update 2';
}

sub t_11_obj_delete : Tests {
    my $set = mock->set( tusr => 'obj-delete', { name => 'Kazuhiro Osawa' } );
    isa_ok $set, mock_class."::tusr";

    my($get) = mock->get( tusr => 'obj-delete' );
    isa_ok $get, mock_class."::tusr";
    ok(mock->delete($get), 'mock->delete( $obj )');

    ok(!mock->get( tusr => 'obj-delete' ));
}

sub t_12_lookup : Tests {
    my $lookup = mock->lookup( tusr => 'yappo' );
    isa_ok $lookup, mock_class."::tusr";
    is $lookup->id, 'yappo', 'id is yappo';
    is $lookup->name, 'Osawa', 'name is Osawa';
}

sub t_13_lookup_multi : Tests {
    my @lookup = mock->lookup_multi( tusr => [ 'yappo', 'yappologs' ] );

    isa_ok $lookup[0], mock_class."::tusr";
    is $lookup[0]->id, 'yappo', 'id is yappo';
    is $lookup[0]->name, 'Osawa', 'name is Osawa';
    isa_ok $lookup[1], mock_class."::tusr";
    is $lookup[1]->id, 'yappologs', 'id is yappologs';
    is $lookup[1]->name, "yappo's blog", "name is yappo's blog";

    my @lookup_rev = mock->lookup_multi( tusr => [ 'yappo', 'yappologs' ] );
    isa_ok $lookup_rev[0], mock_class."::tusr";
    is $lookup_rev[0]->id, 'yappo', 'id is yappo';
    is $lookup_rev[0]->name, 'Osawa', 'name is Osawa';
    isa_ok $lookup_rev[1], mock_class."::tusr";
    is $lookup_rev[1]->id, 'yappologs', 'id is yappologs';
    is $lookup_rev[1]->name, "yappo's blog", "name is yappo's blog";

    @lookup = mock->lookup_multi( tusr => [ 'yappo', 'hoge', 'yappologs' ] );

    ok !$lookup[1], 'null';
    isa_ok $lookup[0], mock_class."::tusr";
    is $lookup[0]->id, 'yappo', 'id is yappo';
    is $lookup[0]->name, 'Osawa', 'name is Osawa';
    isa_ok $lookup[2], mock_class."::tusr";
    is $lookup[2]->id, 'yappologs', 'id is yappologs';
    is $lookup[2]->name, "yappo's blog", "name is yappo's blog";

}

sub t_14_prepere : Tests {
    ok(mock->set( bookmark_tusr => [qw/ 101 yappo /] ));
    ok(mock->set( bookmark_tusr => [qw/ 102 osawa /] ));
    ok(mock->set( bookmark_tusr => [qw/ 103 kazuhiro /] ));
}

sub t_15_lookup_multikey : Tests {
    eval { mock->lookup( bookmark_tusr => 'yappo' ) };
    like $@, qr/The number of key is wrong at /;

    my $lookup;
    $lookup = mock->lookup( bookmark_tusr => [qw/ 101 yappo /] );
    isa_ok $lookup, mock_class."::bookmark_tusr";
    is $lookup->bookmark_id, 101, 'id';
    is $lookup->tusr_id, 'yappo', 'tusr_id';

    $lookup = mock->lookup( bookmark_tusr => [qw/ 102 osawa /] );
    isa_ok $lookup, mock_class."::bookmark_tusr";
    is $lookup->bookmark_id, 102, 'id';
    is $lookup->tusr_id, 'osawa', 'tusr_id';

    $lookup = mock->lookup( bookmark_tusr => [qw/ 103 kazuhiro /] );
    isa_ok $lookup, mock_class."::bookmark_tusr";
    is $lookup->bookmark_id, 103, 'id';
    is $lookup->tusr_id, 'kazuhiro', 'tusr_id';
}

sub t_16_lookup_multi_multikey : Tests {
    eval { mock->lookup_multi( bookmark_tusr => 'yappo' ) };
    like $@, qr/The number of key is wrong at /;
    eval { mock->lookup_multi( bookmark_tusr => ['yappo'] ) };
    like $@, qr/The number of key is wrong at /;

    my($lookup) = mock->lookup_multi( bookmark_tusr => [ [qw/ 101 yappo /] ]);
    isa_ok $lookup, mock_class."::bookmark_tusr";
    is $lookup->bookmark_id, 101, 'id';
    is $lookup->tusr_id, 'yappo', 'tusr_id';

    my @lookup = mock->lookup_multi( bookmark_tusr => [ [qw/ 102 osawa /], [qw/ 103 kazuhiro /] ] );
    isa_ok $lookup[0], mock_class."::bookmark_tusr";
    is $lookup[0]->bookmark_id, 102, 'id';
    is $lookup[0]->tusr_id, 'osawa', 'tusr_id';
    isa_ok $lookup[1], mock_class."::bookmark_tusr";
    is $lookup[1]->bookmark_id, 103, 'id';
    is $lookup[1]->tusr_id, 'kazuhiro', 'tusr_id';

    @lookup = mock->lookup_multi( bookmark_tusr => [ [qw/ 102 osawa /], [qw/ 1 s /], [qw/ 103 kazuhiro /] ] );
    ok !$lookup[1], 'null';
    isa_ok $lookup[0], mock_class."::bookmark_tusr";
    is $lookup[0]->bookmark_id, 102, 'id';
    is $lookup[0]->tusr_id, 'osawa', 'tusr_id';
    isa_ok $lookup[2], mock_class."::bookmark_tusr";
    is $lookup[2]->bookmark_id, 103, 'id';
    is $lookup[2]->tusr_id, 'kazuhiro', 'tusr_id';
}

1;
