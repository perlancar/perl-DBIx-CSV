package DBIx::CSV;

# DATE
# VERSION

use strict;
use warnings;
use DBIx::TextTableAny;

sub import {
    my $class = shift;

    %DBIx::TextTableAny::opts = (
        @_,
        backend => 'Text::Table::CSV',
    );
}

package
    DBI::db;

sub selectrow_csv          { local %DBIx::TextTableAny::opts = (backend => 'Text::Table::CSV', header_row => 1); &selectrow_texttable(@_) }
sub selectall_csv          { local %DBIx::TextTableAny::opts = (backend => 'Text::Table::CSV', header_row => 1); &selectall_texttable(@_) }
sub selectrow_csv_noheader { local %DBIx::TextTableAny::opts = (backend => 'Text::Table::CSV', header_row => 0); &selectrow_texttable(@_) }
sub selectall_csv_noheader { local %DBIx::TextTableAny::opts = (backend => 'Text::Table::CSV', header_row => 0); &selectall_texttable(@_) }

package
    DBI::st;

sub fetchrow_csv          { local %DBIx::TextTableAny::opts = (backend => 'Text::Table::CSV', header_row => 1); &fetchrow_texttable(@_) }
sub fetchall_csv          { local %DBIx::TextTableAny::opts = (backend => 'Text::Table::CSV', header_row => 1); &fetchall_texttable(@_) }
sub fetchrow_csv_noheader { local %DBIx::TextTableAny::opts = (backend => 'Text::Table::CSV', header_row => 0); &fetchrow_texttable(@_) }
sub fetchall_csv_noheader { local %DBIx::TextTableAny::opts = (backend => 'Text::Table::CSV', header_row => 0); &fetchall_texttable(@_) }

1;
# ABSTRACT: Generate CSV from SQL query result

=for Pod::Coverage ^(.+)$

=head1 SYNOPSIS

 use DBI;
 use DBIx::CSV;
 my $dbh = DBI->connect("dbi:mysql:database=mydb", "someuser", "somepass");

Generating a row of CSV (with header):

 print $dbh->selectrow_csv("SELECT * FROM member");

Sample result:

 "Name","Rank","Serial"
 "alice","pvt","123456"

Generating all rows (with header):

 print $dbh->selectrow_csv("SELECT * FROM member");

Sample result:

 "Name","Rank","Serial"
 "alice","pvt","123456"
 "bob","cpl","98765321"
 "carol","brig gen","8745"

Generating rows (without header):

 my $sth = $dbh->prepare("SELECT * FROM member");
 $sth->execute;

 print $sth->fetchall_csv_noheader;

Sample result:

 "alice","pvt","123456"
 "bob","cpl","98765321"
 "carol,"brig gen","8745"


=head1 DESCRIPTION

This package is a thin glue between L<DBI> and L<DBIx::TextTableAny> (which in
turn is a thin glue to L<Text::Table::Any>). It adds the following methods to
database handle:

 selectrow_csv
 selectall_csv
 selectrow_csv_noheader
 selectall_csv_noheader

as well as the following methods to statement handle:

 fetchrow_csv
 fetchall_csv
 fetchrow_csv_noheader
 fetchall_csv_noheader

The methods send the result of query to Text::Table::Any (using the
L<Text::Table::CSV> backend) and return the rendered CSV data.

In essence, this is an easy, straightforward way produce CSV data from SQL
query.


=head1 SEE ALSO

L<DBI::Format>, particularly L<DBI::Format::CSV>

L<DBIx::CSVDumper>

L<DBIx::TextTableAny> which has a similar interface as this module and offers
multiple output formats.
