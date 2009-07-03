use t::Utils::Pg;
use t::Utils config => +{
    type   => 'ForCache',
    driver => 'DBI',
    dsn    => 'dbi:Pg:dbname=test',
};
run;
