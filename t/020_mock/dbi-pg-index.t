use t::Utils::Pg;
use t::Utils config => +{
    type   => 'Index',
    driver => 'DBI',
    dsn    => 'dbi:Pg:dbname=test',
};
run;
