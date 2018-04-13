$results=@{}
$recordresults=@{}
$policies=@{}
$OSVersion=((Get-CimInstance win32_operatingsystem).Version).split(".",2)[0]
#if on 2016 we need to collect more info as scopes could be used
if ($osversion -gt 6){
    $zones=$null
    $zones=Get-DnsServerZone
    $server=Get-DnsServer -ErrorAction SilentlyContinue
    $results.add("dnszones",$zones)
    $results.add("dnsserver",$server)
    foreach ($zone in $zones){
        $records=$null
        $scopes=$null
        $scopes=get-dnsserverzonescope -zonename $zone.ZoneName
        foreach($scope in $scopes){
            $records=Get-DnsServerResourceRecord -ZoneName $zone.ZoneName -zonescope $scope.Zonescope
            $recordresults.add(($zone.ZoneName+"_"+$scope.ZoneScope),$records)
        }
        $records=Get-DnsServerResourceRecord -ZoneName $zone.ZoneName
        $recordresults.add($zone.ZoneName,$records)
        $zonepolicies=$null
        $zonepolicies=Get-DnsServerQueryResolutionPolicy -ZoneName $zone.ZoneName 
        $policies.add($zone.ZoneName,$zonepolicies)
    }
    $results.add("dnsrecords",$recordresults)
    $results.Add("dnspolicies",$policies)
    $conditional = Get-DnsServerForwarder
    $results.Add("conditional", $conditional)
    $globalpolicies=$null
    $globalpolicies=Get-DnsServerQueryResolutionPolicy
    $results.Add("dnsglobalpolicies",$globalpolicies)
}
#this is for 2008r2, 2012...
else{
    $zones=$null
    $zones=Get-DnsServerZone
    $server=Get-DnsServer -ErrorAction SilentlyContinue
    $results.add("dnszones",$zones)
    $results.add("dnsserver",$server)
    foreach ($zone in $zones){
        $records=$null
        $records=Get-DnsServerResourceRecord -ZoneName $zone.ZoneName
    $recordresults.add($zone.ZoneName,$records)            
    }
    $results.add("dnsrecords",$recordresults)
    $conditional = Get-DnsServerForwarder
    $results.Add("conditional", $conditional)

}
return $results