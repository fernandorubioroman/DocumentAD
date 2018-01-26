if (!(test-path C:\temp)){new-item c:\temp -type Directory}
if ((test-path C:\temp\auditpol.csv)){remove-item c:\temp\auditpol.csv -force}
auditpol /backup /file:c:\temp\Auditpol.csv
$audit=import-csv -Path C:\temp\Auditpol.csv
return $audit