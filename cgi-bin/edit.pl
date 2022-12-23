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
my $sth = $dbh->prepare("SELECT title, text FROM Wiki WHERE title=?;");
$sth->execute($title);

my $valores = $sth->fetchrow_hashref();
my $titleB = $valores->{title};
my $textB = $valores->{text};

print $q->header('text/html');
print<<BLOCK;
<!DOCTYPE html>
<html lang="es">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Pagina para editar</title>
</head>
<body>
    <header>
        <h1>Pagina para editar</h1>
        <hr>
    </header>
    <section>
        <form action="cgi-bin/new.pl">
            <label for="tilte">Titulo</label>
            <input type="text" id="title" name="title" value="$titleB"><br>
            <label for="text">Texto</label>
            <textarea name="text" id="text" cols="30" rows="10" placeholder="$textB"></textarea><br>
            <input type="submit" value="Enviar">
        </form>
        <a href="../index.html">Cancelar</a>
    </section>
</body>
</html>
BLOCK

$sth->finish;
$dbh->disconnect;
