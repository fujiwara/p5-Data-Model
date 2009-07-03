use t::Utils::Pg;
use t::Utils config => +{
    type   => 'Inflate',
    driver => 'DBI',
    dsn    => 'dbi:Pg:dbname=test',
};
run;
