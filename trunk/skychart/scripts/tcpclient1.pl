#!/usr/bin/perl
use IO::Socket;

#
# example program that receive all messages from the program
# and process the information from each click on the chart.
#

$host = "192.168.0.1";
$port = "3292";

connectCDC();

while (defined ($line = <$handle>))
{
	if (!($line =~/^\.\r\n$/))  #skip keepalive data
	{
		($h1,$chart,$h2,$ra,$dec,$type,$desc) = split(/\s+/,$line,7);
		if ($ra and ($h1 eq ">"))
			{
			print "From $chart  RA: $ra DEC: $dec Type: $type \n";
			print "$desc \n";
			}
		else { print $line };
	}
}


sub connectCDC {

# do the connection
$handle = IO::Socket::INET->new(Proto     => "tcp",
                                PeerAddr  => $host,
                                PeerPort  => $port)
          or die "cannot connect to Cartes du Ciel at $host port $port : $!";

$handle->autoflush(1);

print STDOUT "[Connected to $host:$port]\n";

# wait connection and get client chart name
  $line = <$handle>;
  print STDOUT $line;
  $line =~ /OK! id=(.*) chart=(.*)$/;
  $client = $1;
  $chart = $2;
  chop $chart;
  if ($client)
    {
     print STDOUT " We are connected as client $client , the active chart is $chart\n";
     print STDOUT " Close CDC or hit Ctrl+C to quit.\n";
    }
    else { die " We are not connected \n"};
}
