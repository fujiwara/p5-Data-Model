use t::Utils::Pg;
use t::Utils config => +{
    type   => 'AliasColumn',
    driver => 'DBI',
    dsn    => 'dbi:Pg:dbname=test',
};
run;
