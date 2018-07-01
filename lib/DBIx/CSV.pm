package DBIx::CSV;

# DATE
# VERSION

use strict;
use warnings;
use DBIx::TextTableAny;

sub import {
    my $class = shift;

    $DBIx::TextTableAny::opts = {
        @_,
        backend => 'Text::Table::CSV',
    };
}

package
    DBI::db;

sub selectrow_csv { goto &selectrow_texttable }
sub selectall_csv { goto &selectrow_texttable }

package
    DBI::st;

sub fetchrow_csv { goto &fetchrow_texttable }
sub fetchall_csv { goto &fetchall_texttable }

1;
# ABSTRACT: Generate CSV from SQL query result

=for Pod::Coverage ^(.+)$

=head1 SYNOPSIS

 use DBI;
 use DBIx::CSV;
 my $dbh = DBI->connect("dbi:mysql:database=mydb", "someuser", "somepass");

Selecting a row:

 print $dbh->selectrow_csv("SELECT * FROM member");

Sample result (default backend is L<Text::Table::Tiny>):

 "Name","Rank","Serial"
 "alice","pvt","123456"

Selecting all rows:

 print $dbh->selectrow_csv("SELECT * FROM member");

Sample result:

 "Name","Rank","Serial"
 "alice","pvt","123456"
 "bob","cpl","98765321"
 "carol","brig gen","8745"

Setting other options:

 DBIx::CSV->import(header_row => 0);

 my $sth = $dbh->prepare("SELECT * FROM member");
 $sth->execute;

 print $sth->fetchall_csv;

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

as well as the following methods to statement handle:

 fetchrow_csv
 fetchall_csv

The methods send the result of query to Text::Table::Any (using the
L<Text::Table::CSV> backend) and return the rendered CSV data.

In essence, this is an easy, straightforward way produce CSV data from SQL
query.


=head1 SEE ALSO

L<DBI::Format>, particularly L<DBI::Format::CSV>

L<DBIx::CSVDumper>
