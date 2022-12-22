#!/usr/bin/perl
use strict;
use warnings;
use CGI;
use DBI;

my $user = 'alumno';
my $password = 'pweb1';
my $dsn = "DBI:MariaDB:database=pweb1;host=192.168.1.22";
my $dbh = DBI->connect($dsn, $user, $password) or die("No se pudo conectar!");
my $sth = $dbh->prepare("SELECT title FROM Wiki");
$sth->execute();

my $q = CGI->new;
print $q->header('text/html');
print<<BLOCK;
<!DOCTYPE html>
<html lang="es">
<head>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1.0">
  <title>Lista de Paginas</title>
</head>
<body>
    <header>
        <h1>Nuestras paginas de wiki</h1>
    </header>
    <article>
        <ul>
BLOCK

        
while(my  @row = $sth->fetchrow_array()){
    print<<BLOCK;
    <li>
      @row
      <form action="delete.pl?title=@row">
        <input type="submit" value="X">
      </form>
      <form action="edit.pl?title=@row">
        <input type="submit" value="E">
      </form>
    </li>
BLOCK
    print "@row\n";
}

print<<BLOCK;
        </ul>
        <hr>
        <a href="new.html">Nueva Pagina</a><br>
        <a href="index.html">Volver al Inicio</a>
    </article>
</body>
</html>
BLOCK

$sth->finish;
$dbh->disconnect;
