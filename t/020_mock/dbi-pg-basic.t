use t::Utils::Pg;
use t::Utils config => +{
    type   => 'Basic',
    driver => 'DBI',
    dsn    => 'dbi:Pg:dbname=test',
};
run;
