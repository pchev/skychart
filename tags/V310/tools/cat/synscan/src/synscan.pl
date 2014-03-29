#!/usr/bin/perl -w
use IO::Socket;
use Cwd;

#
# example program to send sequential command to the program
#

$host = "127.0.0.1";
$port = "3292";
$eol = "\x0D\x0A";
$path = cwd;

  open STARF,"starlist.txt" or die $!;

  connectCDC();

  sendcmd("setproj equat");
  sendcmd("redraw");
  
  while (my $star =<STARF>) {
    $star =~ s/\n//;
    search($star);
  }
  close(STARF);

  sleep(1);
  sendcmd("quit");

sub search {
  my $obj = shift;
  my $obj1 = $obj;
  $obj1 =~ s/\s+$//; # remove blank

  print $handle 'search "'.$obj1.'"'.$eol;                       # send command
  
  $line = <$handle>;
  while (($line =~/^\.\r\n$/) or ($line =~ /^>/)) # keepalive and click on the chart
    {
     if ($line =~ /$client/) {       # response form our client
	($h1,$chart,$ra,$dec,$type,$id,$mv,$bv,$sp,$pmr,$pmd,$hr,$hd,$cn) = split(/\t/,$line);
	if ($ra and ($h1 eq ">"))
		{
                #my $cn1 = $cn;
		#$cn1 =~ s/Common name://;  
		#$cn1 =~ s/\s+$//; 
                #if ($cn1 eq $obj1) {
			print STDOUT "$obj $ra $dec \n";
		#	}
		#else {
		#	print STDOUT "$obj $ra $dec $cn \n";
		#}
	}   
	else {print STDOUT "$obj Error! \n"; }
     }
    $line = <$handle>;
    
 }
  if (($line =~ /^OK!/) or ($line =~ /^Bye!/) )
     {
     #print STDOUT "Command success\n";
     }
  else {print STDOUT "$obj $line \n"; }

}


sub sendcmd {
  my $cmd = shift;
  print STDOUT " Send CMD : $cmd \n";
  print $handle $cmd.$eol;                       # send command

  $line = <$handle>;
  if ($line =~ /$client/) {       # click form our client
     print STDOUT $line;
     }
  while (($line =~/^\.\r\n$/) or ($line =~ /^>/)) # keepalive and click on the chart
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
     print STDOUT "Command failed: +$line+ \n";
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
