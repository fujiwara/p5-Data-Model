use t::Utils config => +{
    type   => 'Basic',
    driver => 'DBI',
    dsn    => 'dbi:SQLite:dbname=',
};
run;
