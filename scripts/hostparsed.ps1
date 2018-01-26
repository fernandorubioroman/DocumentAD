$results=@()
$lines=get-content -path C:\Windows\System32\drivers\etc\hosts | Where-Object {$_.trim() -ne "" }  |select-string -pattern "^\#" -notmatch
foreach ($line in $lines){
    $values=(($line -split "#")[0]) -Split('\s+') | Where-Object {$_.trim() -ne "" }
    #regular A record
    if ($values.count -ge 2){
        for ($i=1;$i -lt $values.count;$i++){
            $resultsobj= New-Object psobject
            $resultsobj | Add-Member -MemberType NoteProperty -Name IP  -Value $values[0] -force
            $resultsobj | Add-Member -MemberType NoteProperty -Name Hostname -PassThru  -Value $values[$i] -force 
            $results+=$resultsobj  
            }
        }
}    
return $results