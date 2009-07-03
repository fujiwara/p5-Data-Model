use t::Utils::Pg;
use t::Utils config => +{
    type   => 'AliasColumnSuger',
    driver => 'DBI',
    dsn    => 'dbi:Pg:database=test',
};
run;
