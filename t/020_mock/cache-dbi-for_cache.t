use t::Utils config => +{
    type   => 'ForCache',
    driver => 'DBI',
    dsn    => 'dbi:SQLite:dbname=',
    cache  => 'HASH',
};
run;
