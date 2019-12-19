Param(
    [string]$ComputerName,
    [string]$ZoneName,
    [int]$Iterations
    #[Parameter(Mandatory=$True, ParameterSetName="tuple")]
    #[tuple[string,string,string][]]$tuple
)


for($i = 0; $i -lt $Iterations; ++$i)
{
        $oct1 = Get-Random -Maximum 254
        $oct2 = Get-Random -Maximum 254
        $oct3 = Get-Random -Maximum 254
        $oct4 = Get-Random -Maximum 254
        $name = [guid]::NewGuid() 
        $ip = $oct1.ToString() + '.' + $oct2.ToString() + '.' + $oct3.ToString() + '.' + $oct4.ToString()
        Add-DnsServerResourceRecordA -ComputerName $ComputerName -Name $name.ToString()  -ZoneName $ZoneName -IPv4Address $IP -TimeToLive 05:00:00 -CreatePtr 
}
