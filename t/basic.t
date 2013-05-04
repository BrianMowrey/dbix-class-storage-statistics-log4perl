#!/usr/bin/perl

use strict;
use Test::More;
use lib 'lib';
use lib 't/lib';
use Data::Printer colored => 1;
BEGIN {
    use_ok('DBIx::Class');
    use_ok('Log::Log4perl');
    use_ok('DBIx::Class::Storage::Statistics::Log4perl');
    use_ok('MyApp::Model');
}
my $schema = MyApp::Model->connect('dbi:SQLite:t/test.db');
#remove old log file so we know where we are:
note("Removing old log files");
unlink 't/test.log';
unlink 't/test2.log';

note("turning on logging with log4perl.conf");
#turn on logging
my $obj = DBIx::Class::Storage::Statistics::Log4perl->new('t/log4perl.conf');

isa_ok($obj,'DBIx::Class::Storage::Statistics::Log4perl');


$schema->storage->debugobj($obj);

$schema->storage->debug(1);
my @artists = $schema->resultset('Artist')->search();

note("inserting data (for params)");
$schema->resultset('Artist')->create({
    artistid    => 3,
    name        => 'Rage against the Machine',
});

note("verifying log data");
my @lines;
open(my $fh, "<", "t/test.log") or die "error opening log file: $!\n";
while (<$fh>) {
    chomp;
    push @lines,$_;
}

close($fh);



ok($lines[0] =~ /^\[\d+\] dbixLog - SELECT me.artistid, me.name FROM artist me$/, "SELECT logged");
ok($lines[1] =~ /^\[\d+\] dbixLog - INSERT INTO artist \( artistid, name\) VALUES \( \?, \? \): '3','Rage against the Machine'$/, "INSERT logged");

note("testing with scalar log4perl conf");
my $conf = 'log4perl.rootLogger=DEBUG, LOGFILE

log4perl.appender.LOGFILE=Log::Log4perl::Appender::File
log4perl.appender.LOGFILE.filename=t/test2.log
log4perl.appender.LOGFILE.mode=append

log4perl.appender.LOGFILE.layout=PatternLayout
log4perl.appender.LOGFILE.layout.ConversionPattern=[%r] %c - %m%n';


my $obj2 = DBIx::Class::Storage::Statistics::Log4perl->new(\$conf);

isa_ok($obj2,'DBIx::Class::Storage::Statistics::Log4perl');

$schema->resultset('Artist')->find(3)->delete();

open(my $fh2,"<","t/test2.log") or die "error opening test2.log: $!\n";
while (<$fh2>) {
    chomp;
    push @lines, $_;
}

close($fh2);

ok($lines[2] =~ /^\[\d+\] dbixLog - SELECT me.artistid, me\.name FROM artist me WHERE \( me\.artistid = \? \)\: '3'/,"find logged");
ok($lines[3] =~ /^\[\d+\] dbixLog - DELETE FROM artist WHERE \( artistid = \? \): '3'/,"DELETE logged");







done_testing(10);
