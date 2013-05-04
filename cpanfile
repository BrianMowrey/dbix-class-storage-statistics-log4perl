requires 'perl', '5.008005';
requires 'DBIx::Class', '0';
requires 'Log::Log4perl', '0';



on test => sub {
    requires 'Test::More', '0.88';
};
