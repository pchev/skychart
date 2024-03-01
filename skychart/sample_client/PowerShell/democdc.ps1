# Sample Powershell code to return chart data from a running
# instance of CdC using TCP. At the time of writing CdC
# uses port 3292.
# See: https://groups.io/g/skychart/message/11883
#
# 127.0.0.1 is the local machine
$cdcServer = "127.0.0.1"
$cdcPort = "3292"

$tcp = New-Object System.Net.Sockets.TcpClient($cdcServer,$cdcPort)
$tcpstream = $tcp.GetStream()
$reader = New-Object System.IO.StreamReader($tcpStream)
$writer = New-Object System.IO.StreamWriter($tcpStream)
$writer.AutoFlush = $true
[string]$commandOutput = ""
while ($tcp.Connected)
{      
    while(($reader.Peek() -ne -1) -or ($tcp.Available)){    
        $commandOutput += ([char]$reader.Read())
    }
    write-host ("Command Output: $commandOutput") -NoNewline
    $commandOutput = ""
    if ($tcp.Connected)
    {
        Write-Host -NoNewline "CDC:>"
        $command = Read-Host
        if ($command -eq "escape")
        {
            break
        }
        $writer.WriteLine($command) | Out-Null
    }    
}
$reader.Close()
$writer.Close()
$tcp.Close()
