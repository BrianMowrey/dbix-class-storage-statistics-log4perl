 package MyApp::Model::Result::Artist;

use base qw/DBIx::Class::Core/;

__PACKAGE__->table('artist');
__PACKAGE__->add_columns(qw/ artistid name /);
__PACKAGE__->set_primary_key('artistid');
#__PACKAGE__->has_many(cds => 'MyApp::Model::Result::CD', 'artistid');

1;
