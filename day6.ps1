$PuzzleInput = Get-Content -Path .\day6_input.txt

#PART 1
$i = 0
$k = 0
$ListOfGroupAnswers = @()

while ($i -lt $PuzzleInput.Count) {
  $GroupAnswers = @{}
  $groupSize = 0
  $GroupId = ("#{0:d$($PuzzleInput.Count.ToString().Length)}" -f $k)
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
  $k++
  $GroupData = [PSCustomObject]@{
    group_id = $GroupId
    group_size = $groupSize
    group_answers = $GroupAnswers
  }
  $ListOfGroupAnswers += $GroupData
}

Write-Output 'For each group, count the number of questions to which anyone answered "yes".'
Write-Output "What is the sum of those counts?"
Write-Host $ListOfGroupAnswers.group_answers.Keys.Count -ForegroundColor DarkGreen

# PART 2
$Results = foreach($GroupAnswer in $ListOfGroupAnswers) {
  $Count = 0
  $groupSize = $GroupAnswer.group_size
  $GroupAnswer.group_answers.GetEnumerator() | ForEach-Object {
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