$PuzzleInput = Get-Content -Path .\day6_input.txt

#PART 1
$j = 0
$i = 0
$ListOfGroupAnswers = @()

while ($j -lt $PuzzleInput.Count) {
  $GroupAnswers = @{}
  $groupSize = 0
  do {
    $groupSize++
    # Adding answers to $GroupAnswers
    $PuzzleInput[$i].ToCharArray() | ForEach-Object {
      if (-not ($GroupAnswers.ContainsKey($PSItem))) {
        $GroupAnswers.Add($PSItem, 1)      
      } else {
        $GroupAnswers[$PSItem]++
      }

    }
    #increment
    $i++
  } until ($PuzzleInput[$i] -in @("","`r",$null))
  $i++
  $j = $i
  $GroupAnswers.Add("#",$groupSize)
  $ListOfGroupAnswers += $GroupAnswers
}

Write-Output 'For each group, count the number of questions to which anyone answered "yes".'
Write-Output "What is the sum of those counts?"
Write-Host ($ListOfGroupAnswers.Keys.Where({$_ -ne "#"}).Count) -ForegroundColor DarkGreen

# PART 2
$Results = foreach($GroupAnswer in $ListOfGroupAnswers) {
  $Count = 0
  $GroupSize = $GroupAnswer['#']
  $GroupAnswer.GetEnumerator().Where({$_.Key -ne "#"}) | ForEach-Object {
    if ($PSItem.Value -eq $groupSize) {
      $Count++
    }
  }
  $Count
}

Write-Output @"

You don't need to identify the questions to which anyone answered "yes"; 
you need to identify the questions to which everyone answered "yes"!
"@
Write-Output "What is the sum of those counts?"
Write-Host ($Results | Measure-Object -Sum).Sum -ForegroundColor DarkGreen