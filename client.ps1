<#
# CITRA IT - EXCELÊNCIA EM TI
# SCRIPT POC DE SOCKET TCP CLIENT
# AUTOR: luciano@citrait.com.br
# DATA: 10/10/2021
# EXAMPLO DE USO: Powershell -ExecutionPolicy ByPass -File C:\scripts\client.ps1
#>

$server_address = "localhost"
$server_port = 9000


# Read Buffer Size
$READ_BUFFER_SIZE = 8192


# Creating the tcp socket client object
$socket = New-Object System.Net.Sockets.TCPClient

# Connecting to server
$socket.connect($server_address, $server_port)


# Getting the socket stream of type [System.Net.Sockets.NetworkStream]
$stream = $socket.GetStream()
$sw = New-Object System.IO.StreamWriter $stream

# Message to send to server
[Console]::WriteLine("Message to send to server:")
$ping_text = [Console]::ReadLine()
$sw.Write($ping_text)
$sw.Flush()


# Getting the answer from server
$sr = New-Object System.IO.StreamReader $stream
[Console]::WriteLine("Received from server: ")
[Console]::WriteLine($sr.ReadToEnd())


# Closing the connection
$socket.Close()