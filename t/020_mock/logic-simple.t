use t::Utils;
use Test::More tests => 20;
use Mock::Logic::Simple;

my $mock = Mock::Logic::Simple->new;

do {
    my($ret1) = $mock->get( tusr => 'yappo' );
    ok(Mock::Logic::Simple::tusr->can('id'));
    isa_ok $ret1, 'Mock::Logic::Simple::tusr';
    is $ret1->name, 'Osawa';
    
    my($ret2) = $mock->get( tusr => 'lopnor' );
    isa_ok $ret2, 'Mock::Logic::Simple::tusr';
    is $ret2->name, 'Danjou';
    
    my $ret3 = $mock->set( tusr => +{
        id   => 'soozy',
        name => 'Souji',
    });
    isa_ok $ret3, 'Mock::Logic::Simple::tusr';
    is $ret3->id, 'soozy';
    is $ret3->name, 'Souji';
    
    ok $mock->delete( tusr => 'ok' );
    ok !$mock->delete( tusr => 'ng' );
};

do {
    my($ret1) = $mock->get( barerow => 'yappo' );
    ok(!Mock::Logic::Simple::barerow->can('id'));
    isa_ok $ret1, 'HASH';
    is $ret1->{name}, 'Osawa';
    
    my($ret2) = $mock->get( barerow => 'lopnor' );
    isa_ok $ret2, 'HASH';
    is $ret2->{name}, 'Danjou';
    
    my $ret3 = $mock->set( barerow => +{
        id   => 'soozy',
        name => 'Souji',
    });
    isa_ok $ret3, 'HASH';
    is $ret3->{id}, 'soozy';
    is $ret3->{name}, 'Souji';
    
    ok $mock->delete( barerow => 'ok' );
    ok !$mock->delete( barerow => 'ng' );
};
