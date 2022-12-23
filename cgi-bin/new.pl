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
my $text = $q->param("text");
my $sth = $dbh->prepare("INSERT INTO Wiki(title,text) VALUES (?,?)");
$sth->execute($title, $text);
$sth->finish;
$dbh->disconnect;

print $q->header('text/html');
print<<BLOCK;
<!DOCTYPE html>
<html lang="es">
<head>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1.0">
  <title>Pagina Creada</title>
</head>
<body>
    <header>
        <h1>$title</h1>
    </header>
    <article>
        <p>$text</p>
        <hr>
        <h1>Pagina grabada <a href="list.pl">Listado de Paginas</a></h1>
    </article>
</body>
</html>
BLOCK
