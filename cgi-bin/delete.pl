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

print $q->header('text/html');
print<<BLOCK;
<!DOCTYPE html>
<html>
<head>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1.0">
  <title>Pagina Eliminada</title>
</head>
<body>
    <header>
        <h1>Pagina eliminada con exito</h1>
    </header>
    <article>
        <hr>
        <h1>Volver a la pagina de listado <a href="list.pl">Listado de Páginas</a></h1>
    </article>
</body>
</html>
BLOCK

$sth->finish;
$dbh->disconnect;