#!/usr/bin/perl -w

#
# example program that fork to Send and Receive process.
# work the same way as telnet.
#

use strict;
use IO::Socket;
my ($host, $port, $kidpid, $handle, $line, $eol);

$host = "127.0.0.1";
$port = "3292";

$eol = "\x0D\x0A";

# do the connection
$handle = IO::Socket::INET->new(Proto     => "tcp",
                                PeerAddr  => $host,
                                PeerPort  => $port)
          or die "cannot connect to Cartes du Ciel at $host port $port : $!";

$handle->autoflush(1);

print STDERR "[Connected to $host:$port]\n";

# fork the Send and Receive part:
die "cannot fork: $!" unless defined($kidpid = fork());

# main process with the Receive function:
if ($kidpid) {
   # print each received line
   while (defined ($line = <$handle>)) {
          if (!($line =~/^\.\r\n$/))  #skip keepalive data
             {
             print STDOUT $line;
             }
          }
   kill("TERM", $kidpid);          # kill Send process on exit
   }

   # child process with the Send function:
   else {
        # send interactive command :
         while (defined ($line = <STDIN>))
         {
           chop $line;
           print $handle $line.$eol;
         }
}
