use t::Utils::Pg;
use t::Utils config => +{
    type   => 'NoKey',
    driver => 'DBI',
    dsn    => 'dbi:Pg:dbname=test',
};
run;
