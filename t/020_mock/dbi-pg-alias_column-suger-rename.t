use t::Utils::Pg;
use t::Utils config => +{
    type   => 'AliasColumnSugerRename',
    driver => 'DBI',
    dsn    => 'dbi:Pg:database=test',
};
run;
