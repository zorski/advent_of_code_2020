$PuzzleInput = @"
nop +0
acc +1
jmp +4
acc +3
jmp -3
acc -99
acc +1
jmp -4
acc +6
"@ -split "`n"

function Parse-Instruction {
  param (
    [string]$Instruction
  )
  
  if($Instruction -match "(?<int>[a-z]{3})\s(?<sign>[+-]{1})(?<arg>\d+)"){
    [PSCustomObject]@{
      int=$Matches['int']
      sign=$Matches['sign']
      arg=$Matches['arg']
    }
  } else {
    Write-Warning "couldn't parse the instruction"
  }
}

$visited = [System.Collections.Generic.HashSet[int]]::new()
$i = 0
while($i -lt $PuzzleInput.Count) {
  $Int = Parse-Instruction -Instruction $PuzzleInput[$i]
  if($visited.Add($i)) {
    echo "ok"
  } else {
    echo "byeeem"
  }
  switch ($Int.int) {
    'nop' { 
      Write-Warning "nop"
    }
    'jmp' {
      $i = $i + "$($Int.sign)$($Int.arg-1)" 
    }
    'acc' {
      $acc += $Int.arg
    }
  }
  $i++ 
}