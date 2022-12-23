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

$textB = convertor($textB);

print $q->header('text/html');
print<<BLOCK;
<!DOCTYPE html>
<html lang="es">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>$titleB</title>
</head>
<body>
    $textB
</body>
</html>
BLOCK

$sth->finish;
$dbh->disconnect;

sub convertor {

    my $markdown = $_[0];

    $markdown =~ s/^#\s+(.*)$/<h1>$1<\/h1>/gm;

    $markdown =~ s/^##\s+(.*)$/<h2>$1<\/h2>/gm;
    
    $markdown =~ s/^###\s+(.*)$/<h3>$1<\/h3>/gm;

    $markdown =~ s/^####\s+(.*)$/<h4>$1<\/h4>/gm;

    $markdown =~ s/^#####\s+(.*)$/<h5>$1<\/h5>/gm;

    $markdown =~ s/\*\*(.+?)\*\*/<b>$1<\/b>/g;

    $markdown =~ s/\*(.+?)\*/<i>$1<\/i>/g;

    $markdown =~ s/\*\*\*(.+?)\*\*\*/<b><i>$1<\/i><\/b>/g;

    $markdown =~ s/~~(.+?)~~/<del>$1<\/del>/g;

    $markdown =~ s/```(.+?)```/<pre style="background-color: rgb(230, 230, 230)"><code>$1<\/code><\/pre>/gs;

    $markdown =~ s/\[(.+?)\]\((.+?)\)/<a href="$2">$1<\/a>/g;
    return $markdown;
}
