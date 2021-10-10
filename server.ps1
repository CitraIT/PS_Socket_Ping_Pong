<#
# CITRA IT - EXCELÊNCIA EM TI
# SCRIPT POC DE SOCKET TCP SERVER
# AUTOR: luciano@citrait.com.br
# DATA: 10/10/2021
# EXAMPLO DE USO: Powershell -ExecutionPolicy ByPass -File C:\scripts\server.ps1
#>



Function Log
{
	Param([String]$text)
	$timestamp = Get-Date -Format G
	Write-Host -ForegroundCOlor Green "$timestamp`: $text"
}

# Bind Address and port
$bind_address = "0.0.0.0"
$bind_port = 9000


# Buffers
$READ_BUFFER_SIZE = 8192


# Create the socket object
$tcplistener = New-Object System.Net.Sockets.TcpListener $bind_address,$bind_port


# Start listening on the selected port 
Log "Start listening on port $bind_port"
$tcplistener.Start()

# listen indefinitely one client by time
While($True){

	# Block/Wait until the client connects
	Log "Waiting for client connections..."
	$socket = $tcplistener.AcceptSocket()
	Log([String]::Format("New incoming connection from {0}",$socket.RemoteEndPoint.toString()))

	# Reading Data
	$ReadBuffer = [System.Array]::CreateInstance([System.Byte], $READ_BUFFER_SIZE)
	
	# Waiting data from client
	Log("Waiting for client data")
	While(-Not $socket.Available)
	{
		[System.Threading.Thread]::Sleep(100)
	}
	
	# Parse bytes data as string
	$read_bytes = $socket.Receive($ReadBuffer)
	$buffer_only_data = [System.Array]::CreateInstance([System.Byte], $read_bytes)
	[System.Array]::Copy($ReadBuffer, $buffer_only_data, $read_bytes)
	$client_data = [System.Text.Encoding]::UTF8.GetString($buffer_only_data)
	Log([String]::Format("Received data: {0}", $client_data))
	
	
	# Answering the client
	Log("Sending response to Client...")
	$socket.Send($buffer_only_data) | Out-Null
	Log("Response sent")


	Log("Closing client socket...")
	$socket.Close()
}

$tcplistener.Stop()
