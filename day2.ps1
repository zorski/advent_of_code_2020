$PasswordAndPolicy = Get-Content .\day2_input.txt
$Counter = 0
$SecondCounter = 0

$PasswordAndPolicy | ForEach-Object {
  if($PSItem -match "^(?<min>\d+)-(?<max>\d+)\s(?<letter>\w{1}):\s(?<pass>\w+)") {
    $Password,$PolicyMin,$PolicyMax,$Letter = $Matches.pass,$Matches.min,$Matches.max,$Matches.letter
    if ($Password.ToCharArray().Where({$_ -eq $Letter}).Count -in $PolicyMin..$PolicyMax) {
      $Counter++
    }
  }
  
  $FirstIndex = $PolicyMin-1
  $SecondIndex = $PolicyMax-1

  if ($Password[$FirstIndex] -eq $Letter -xor $Password[$SecondIndex] -eq $Letter) {
    $SecondCounter++
  }
}

Write-Output $Counter
Write-Output $SecondCounter

