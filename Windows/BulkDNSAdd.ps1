Param(
    [string]$ComputerName,
    [string]$ZoneName,
    [int]$Iterations,
    [Parameter(Mandatory=$False)] 
    [int]$RecordType
)


# A record (1)
# DS record (2)
# MX record (3)
# PTR record (4)
# CNAME record (5)
# DNSKEY record (6)

# ForwardLookupZone (7)
# ReverseLookupZone (8)
# Conditional Forwarder (9)


for($i = 0; $i -lt $Iterations; ++$i)
{
        if(!$RecordType) { 
            $id = Get-Random -Maximum 9 -Minimum 1 }
            else{ $id = $RecordType }

           
        $name = [guid]::NewGuid().ToString()

        switch($id){
            1 {
                $oct1 = Get-Random -Maximum 254
                $oct2 = Get-Random -Maximum 254
                $oct3 = Get-Random -Maximum 254
                $oct4 = Get-Random -Maximum 254

                $ip = $oct1.ToString() + '.' + $oct2.ToString() + '.' + $oct3.ToString() + '.' + $oct4.ToString()
                Add-DnsServerResourceRecordA -ComputerName $ComputerName -Name $name  -ZoneName $ZoneName -IPv4Address $IP -TimeToLive 05:00:00
            }
            2 {
                $digest = Get-Random -Maximum 100000 -Minimum 1
                $keyTag = Get-Random -Maximum 127 -Minimum 0
                Add-DnsServerResourceRecordDS -ZoneName $ZoneName -Name $name -CryptoAlgorithm RsaSha1 -ComputerName $ComputerName -Digest $digest -DigestType Sha1 -KeyTag $keyTag
            }
            3 {
                $pref = Get-Random -Maximum 1000
                $mailExchange = [guid]::NewGuid().ToString() 
                Add-DnsServerResourceRecordMX -Preference $pref -Name $name -TimeToLive 05:00:00 -ZoneName $ZoneName -MailExchange $mailExchange
            }
            4{
                $domainName = [guid]::NewGuid().ToString()

                Add-DnsServerResourceRecordPtr -Name $name -ZoneName $ZoneName -PtrDomainName $domainName
            }
            5{
                $hostName = [guid]::NewGuid().ToString()
                Add-DnsServerResourceRecordCName -Name $name -ZoneName $ZoneName -HostNameAlias $hostName
            }
            6{
                
            }
            7{
                Add-DnsServerPrimaryZone -Name $name -ReplicationScope Domain -DynamicUpdate NonsecureAndSecure
            }
            8{
                #$networkId = Get-Random -Maximum 1000 -Minimum 0
                #Add-DnsServerPrimaryZone -NetworkId $networkId -ReplicationScope Domain
            }
            9{
                $oct1 = Get-Random -Maximum 254
                $oct2 = Get-Random -Maximum 254
                $oct3 = Get-Random -Maximum 254
                $oct4 = Get-Random -Maximum 254

                $ip = $oct1.ToString() + '.' + $oct2.ToString() + '.' + $oct3.ToString() + '.' + $oct4.ToString()
                Add-DnsServerConditionalForwarderZone -MasterServers $ip -Name $name -ReplicationScope Forest -ComputerName $ComputerName
            }
            10{
                Add-DnsServerStubZone -MasterServers "1.2.3.4" -ComputerName $ComputerName -Name $name
            }
        }
}
