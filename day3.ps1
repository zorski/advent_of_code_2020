$Map = Get-Content -Path .\day3_input.txt
$Trees = 0 
$idx = 0
foreach($Line in ($Map | Select-Object -Skip 1)) {
  $idx = ($idx + 3) % 31
  if ($Line[$idx] -eq "#") {
    $Trees++
  }
}

Write-Output $Trees