# reported by tokuhirom
use strict;
use warnings;
use Test::More tests => 6;
use Data::Model;
use Data::Model::Driver::DBI;

{
    package Neko::DB::User;
    use base 'Data::Model';
    use Data::Model::Schema;

    install_model tusr => schema {
        key 'foo';

        column 'foo' => varchar => {
            binary => 1,
        };
    };
}

my $dm = Neko::DB::User->new();
my $driver = Data::Model::Driver::DBI->new(
    dsn => 'dbi:SQLite:'
);
$dm->set_base_driver($driver);

for my $target ($dm->schema_names) {
    for my $sql ($dm->as_sqls($target)) {
        $driver->rw_handle->do($sql);
    }
}

ok 1;

my $ret;
ok($dm->set( tusr => 'foo' ), 'set tusr foo');
ok($dm->set( tusr => 'Foo' ), 'set tusr Foo');

($ret) = $dm->get( tusr => 'foo' );
is($ret->foo, 'foo', 'get tusr foo');
($ret) = $dm->get( tusr => 'Foo' );
is($ret->foo, 'Foo', 'get tusr Foo');

($ret) = $dm->get( tusr => 'FOO' );
ok(!$ret, 'FOO is not found in tusr');
