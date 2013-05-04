# NAME

DBIx::Class::Storage::Statistics::Log4perl - DBIx::Class

# SYNOPSIS

    use DBIx::Class::Storage::Statistics::Log4perl;

    $schema->storage->debugobj(DBIx::Class::Storage::Statistics::Log4perl->new($config));
    



# DESCRIPTION

DBIx::Class::Storage::Statistics::Log4perl is a logger for DBIx::Class sql statements that uses log4perl as it's output.
Logs to category 'dbixLog'.  $config can be whatever Log::Log4perl->init() takes as a parameter (file path, scalar reference, etc).

# AUTHOR

Brian Mowrey <brian@drlabs.org>

# COPYRIGHT

Copyright 2013- Brian Mowrey

# LICENSE

This library is free software; you can redistribute it and/or modify
it under the same terms as Perl itself.

# SEE ALSO
