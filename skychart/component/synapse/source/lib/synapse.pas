{ This file was automatically created by Lazarus. Do not edit!
This source is only used to compile and install the package.
 }

unit synapse; 

interface

uses
  asn1util, blcksock, dnssend, ftpsend, ftptsend, httpsend, imapsend, ldapsend, 
    mimeinln, mimemess, mimepart, nntpsend, pingsend, pop3send, slogsend, 
    smtpsend, snmpsend, sntpsend, synachar, synacode, synafpc, synaicnv, 
    synamisc, synautil, synsock, tlntsend, clamsend, synaser, 
    LazarusPackageIntf; 

implementation

procedure Register; 
begin
end; 

initialization
  RegisterPackage('synapse', @Register); 
end.
