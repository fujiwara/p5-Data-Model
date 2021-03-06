use t::Utils;
use Mock::Tests::Basic;
use Data::Model::Driver::DBI;
use Test::More;

BEGIN {
    plan skip_all => "Set TEST_PG environment variable to run this test"
        unless $ENV{TEST_PG};
    plan tests => 34;
};

BEGIN {
    my $dbfile = temp_filename;
    our $DRIVER = Data::Model::Driver::DBI->new(
        dsn => 'dbi:Pg:database=test',
    );
    use_ok('Mock::Basic');
    use_ok('Mock::Index');
    use_ok('Mock::ColumnSugar');
    use_ok('Mock::ColumnSugar2');
    use_ok('Mock::SchemaOptions');
}


my $mock = Mock::Basic->new;

my @tusr = $mock->get_schema('tusr')->sql->as_sql;
is scalar(@tusr), 1;
is($tusr[0], qq{CREATE TABLE tusr (
    id              CHAR(255)      ,
    name            CHAR(255)      ,
    PRIMARY KEY (id)
)});

my @bookmark = $mock->get_schema('bookmark')->sql->as_sql;
is scalar(@bookmark), 1;
is($bookmark[0], qq{CREATE TABLE bookmark (
    id              SERIAL         ,
    url             CHAR(255)      ,
    PRIMARY KEY (id),
    UNIQUE (url)
)});

my @bookmark_tusr = $mock->get_schema('bookmark_tusr')->sql->as_sql;
is scalar(@bookmark_tusr), 2;
is($bookmark_tusr[0], qq{CREATE TABLE bookmark_tusr (
    bookmark_id     VARCHAR(100)   ,
    tusr_id         VARCHAR(100)   ,
    PRIMARY KEY (bookmark_id, tusr_id)
)});
is($bookmark_tusr[1], qq{CREATE INDEX tusr_id ON bookmark_tusr (tusr_id)});

$mock = Mock::Index->new;

my @multi_keys = $mock->get_schema('multi_keys')->sql->as_sql;
is scalar(@multi_keys), 1;
is($multi_keys[0], qq{CREATE TABLE multi_keys (
    key1            CHAR(255)      ,
    key2            CHAR(255)      ,
    key3            CHAR(255)      ,
    PRIMARY KEY (key1, key2, key3)
)});

my @multi_unique = $mock->get_schema('multi_unique')->sql->as_sql;
is scalar(@multi_unique), 1;
is($multi_unique[0], qq{CREATE TABLE multi_unique (
    c_key           SERIAL         ,
    unq1            CHAR(255)      ,
    unq2            CHAR(255)      ,
    unq3            CHAR(255)      ,
    PRIMARY KEY (c_key),
    UNIQUE (unq1, unq2, unq3)
)});

my @multi_index = $mock->get_schema('multi_index')->sql->as_sql;
is scalar(@multi_index), 2;
is($multi_index[0], qq{CREATE TABLE multi_index (
    c_key           SERIAL         ,
    idx1            CHAR(255)      ,
    idx2            CHAR(255)      ,
    idx3            CHAR(255)      ,
    PRIMARY KEY (c_key)
)});
is($multi_index[1], qq{CREATE INDEX idx ON multi_index (idx1, idx2, idx3)});


$mock = Mock::ColumnSugar->new;

my @author = $mock->get_schema('author')->sql->as_sql;
is scalar(@author), 1;
is($author[0], qq{CREATE TABLE author (
    id              SERIAL         ,
    name            VARCHAR(128)    NOT NULL,
    PRIMARY KEY (id)
)});

my @book = $mock->get_schema('book')->sql->as_sql;
is scalar(@book), 2;
is($book[0], qq{CREATE TABLE book (
    id              SERIAL         ,
    author_id       INT             NOT NULL,
    sub_author_id   INT            ,
    title           VARCHAR(255)    NOT NULL,
    description     TEXT            NOT NULL DEFAULT 'not yet writing',
    recommend       TEXT           ,
    PRIMARY KEY (id)
)});
is($book[1], qq{CREATE INDEX author_id ON book (author_id)});


$mock = Mock::ColumnSugar2->new;
my @author2 = $mock->get_schema('author')->sql->as_sql;
is scalar(@author2), 1;
is($author2[0], qq{CREATE TABLE author (
    id              CHAR(32)        NOT NULL,
    name            VARCHAR(128)    NOT NULL,
    PRIMARY KEY (id)
)});


$mock = Mock::SchemaOptions->new;
my @unq = $mock->get_schema('unq')->sql->as_sql;
is scalar(@unq), 1;
is($unq[0], qq{CREATE TABLE unq (
    id1             CHAR(255)      ,
    id2             CHAR(255)      ,
    UNIQUE (id1, id2),
    UNIQUE (id2, id1)
)});

my @unq2 = $mock->get_schema('unq2')->sql->as_sql;
is scalar(@unq2), 1;
is($unq2[0], qq{CREATE TABLE unq2 (
    id1             CHAR(255)      ,
    id2             CHAR(255)      ,
    UNIQUE (id2, id1),
    UNIQUE (id1, id2)
)});

my @in_bin = $mock->get_schema('in_bin')->sql->as_sql;
is scalar(@in_bin), 1;
is($in_bin[0], qq{CREATE TABLE in_bin (
    name            BYTEA          
)});

my @in_bin_option = $mock->get_schema('in_bin_option')->sql->as_sql;
is scalar(@in_bin_option), 1;
is($in_bin_option[0], qq{CREATE TABLE in_bin_option (
    name            BYTEA          
)});
