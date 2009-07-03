use t::Utils::Pg;
use t::Utils config => +{
    type   => 'Binary',
    driver => 'DBI',
    dsn    => 'dbi:Pg:dbname=test',
};
run;
