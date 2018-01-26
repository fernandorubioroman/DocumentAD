#requires -modules parallelexecution 
#requires -version 3
#First we get an array of Domains, of all DCs in the Forest and of the best ones (in the same site as we are) to collect extensive domain data from them
$domains=(Get-ADForest).domains
$dcs=@()
$bestdcs=@()
$date=get-date -Format yyyyMMddhhmm
foreach ($domain in $domains){
    $dcs+=get-addomaincontroller  -filter * -server $domain
    $bestdcs+=get-addomaincontroller -server $domain
}
#Then we get the information per domain
$bestdcs| select -ExpandProperty hostname| Start-ParallelExecution -InputCommandFile .\commandDomain.csv -OutputFile ".\output_domains_$($date).xml" -TimeoutInSeconds 900 -ScriptFolder .\scripts -Verbose
#Then we get the information we want per DC
$dcs| select -ExpandProperty hostname | Start-ParallelExecution -InputCommandFile .\commandDC.csv -OutputFile ".\output_DCs_$($date).xml" -TimeoutInSeconds 900 -ScriptFolder .\scripts  -Verbose
#if we want to load the exported data for analysis run
Get-ChildItem -Path .\ |where{$_.Extension -eq ".xml"} | Compress-Archive -DestinationPath .\DocumentedAD$date.zip 
Get-ChildItem -Path .\ |where{$_.Extension -eq ".xml"}  | remove-item



