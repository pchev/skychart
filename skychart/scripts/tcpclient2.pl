#!/usr/bin/perl -w
use IO::Socket;

#
# example program to send sequential command to the program
#

$host = "192.168.0.1";
$port = "3292";
$eol = "\x0D\x0A";

  connectCDC();

  sendcmd("newchart test");
  sendcmd("selectchart test");

  sendcmd("setproj equat");
  sendcmd("search M37");
  sleep(2);
  sendcmd("setfov 3d0m0s");
  sendcmd("redraw");

  $path = `pwd`;
  chop $path;
  sendcmd("saveimg PNG $path/test.png");
  sendcmd("saveimg JPEG $path/test.jpg 50");

  sleep(5);
  sendcmd("closechart test");
  sendcmd("quit");


sub sendcmd {
  my $cmd = shift;
  print STDOUT " Send CMD : $cmd \n";
  print $handle $cmd.$eol;                       # send command

  $line = <$handle>;
  if ($line =~ /$client/) {       # click form our client
     print STDOUT $line;
     }
  while (($line =~/^\.\r\n$/) or ($line =~ /^> /)) # keepalive and click on the chart
    {
     $line = <$handle>;
     if ($line =~ /$client/) {       # click form our client
        print STDOUT $line;
        }
    }
  # we go here after receiving response from our command
  if (($line =~ /^OK!/) or ($line =~ /^Bye!/) )
     {
     print STDOUT "Command success\n";
     }
  else {
     print STDOUT "Command failed\n";
	 exit;
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
    }
    else { die " We are not connected \n"};
}
