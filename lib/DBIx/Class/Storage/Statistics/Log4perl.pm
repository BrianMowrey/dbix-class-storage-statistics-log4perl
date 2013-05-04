package DBIx::Class::Storage::Statistics::Log4perl;

use strict;
use warnings;
use v5.12;

our $VERSION = '0.1';

use Log::Log4perl;
use parent 'DBIx::Class::Storage::Statistics';



sub new {
    my ($class,$logger_conf) = @_;
    die "no log4perl config given" unless $logger_conf;

    my $self = $class->next::method();
    
    Log::Log4perl->init($logger_conf);
    Log::Log4perl->wrapper_register(__PACKAGE__);

    $self->{_logger} = Log::Log4perl->get_logger('dbixLog');

    return $self;

}


sub query_start {
    my ($self,$sql,@params) = @_;
    my $params = '';

    $params = ': ' . join(',',@params) if scalar @params > 0;
    $self->{_logger}->debug( $sql . $params);
}


1;
__END__

=encoding utf-8

=head1 NAME

DBIx::Class::Storage::Statistics::Log4perl - DBIx::Class

=head1 SYNOPSIS

  use DBIx::Class::Storage::Statistics::Log4perl;

  $schema->storage->debugobj(DBIx::Class::Storage::Statistics::Log4perl->new($config));
  

=head1 DESCRIPTION

DBIx::Class::Storage::Statistics::Log4perl is a logger for DBIx::Class sql statements that uses log4perl as it's output.
Logs to category 'dbixLog'.  $config can be whatever Log::Log4perl->init() takes as a parameter (file path, scalar reference, etc).

=head1 AUTHOR

Brian Mowrey E<lt>brian@drlabs.orgE<gt>

=head1 COPYRIGHT

Copyright 2013- Brian Mowrey

=head1 LICENSE

This library is free software; you can redistribute it and/or modify
it under the same terms as Perl itself.

=head1 SEE ALSO

=cut
