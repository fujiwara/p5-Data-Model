use t::Utils::Pg;
use t::Utils config => +{
    type   => 'Transaction',
    driver => 'DBI',
    dsn    => 'dbi:Pg:dbname=test',
};
run;
