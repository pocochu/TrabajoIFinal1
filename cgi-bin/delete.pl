#!/usr/bin/perl
use strict;
use warnings;
use CGI;
use DBI;

my $user = 'alumno';
my $password = 'pweb1';
my $dsn = "DBI:MariaDB:database=pweb1;host=192.168.1.22";
my $dbh = DBI->connect($dsn, $user, $password) or die("No se pudo conectar!");
my $q = CGI->new;
my $title = $q->param("title");
my $sth = $dbh->prepare("DELETE FROM Wiki WHERE title=?;");
$sth->execute($title);
$sth->finish;
$dbh->disconnect;