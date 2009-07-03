use t::Utils::Pg;
use t::Utils config => +{
    type   => 'Default',
    driver => 'DBI',
    dsn    => 'dbi:Pg:dbname=test',
};
run;
