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

my $query1 = "SELECT * FROM Wiki WHERE title = ?;";
my $query2 = "INSERT INTO Wiki(title,text) VALUES (?,?);";
my $query3 = "DELETE FROM Wiki WHERE title=?;";
my $sth1 = $dbh->prepare($query1);
$sth1->execute($title);

my $row = $sth1->fetchrow_hashref();
$sth1->finish;

if($row eq undef){
    my $sth2 = $dbh->prepare($query2);
    $sth2->execute($title, $text);
    $sth2->finish;

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
            <h1>Pagina grabada en <a href="list.pl">Listado de Paginas</a></h1>
        </article>
    </body>
    </html>
BLOCK
} else {
    my $sth2 = $dbh->prepare($query2);
    my $sth3 = $dbh->prepare($query3);

    $sth3->execute($title);
    $sth3->finish;
    $sth2->execute($title, $text);
    $sth2->finish;

    print $q->header('text/html');
    print<<BLOCK;
    <!DOCTYPE html>
    <html lang="es">
    <head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Pagina Editada</title>
    </head>
    <body>
        <header>
            <h1>$title</h1>
        </header>
        <article>
            <p>$text</p>
            <hr>
            <h1>Pagina editada en <a href="list.pl">Listado de Paginas</a></h1>
        </article>
    </body>
    </html>
BLOCK
}

$dbh->disconnect;
