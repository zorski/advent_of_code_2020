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

## PART 2
$Trees = @{}
for ($i = 1; $i -lt $Map.Count; $i++) {
  1,3,5,7 | ForEach-Object { 
    if($Map[$i][($i*$_) % 31] -eq "#") {
      $Trees[$_]++
    }
  }
  if ($i % 2 -eq 0) {
    if ($Map[$i][($i/2) % 31] -eq "#") {
      $Trees["oddone2down"]++
    }
  }
}
