$PuzzleInput = Get-Content -Path ./day8_input.txt

function Parse-Instruction {
  param (
    [string]$Instruction
  )
  
  if($Instruction -match "(?<ins>[a-z]{3})\s(?<sign>[+-]{1})(?<arg>\d+)"){
    @{
      name  = $Matches['ins']
      arg  = [int]"$($Matches['sign'])$($Matches['arg'])"
    }
  } else {
    Write-Warning "couldn't parse the instruction"
  }
}

$Visited = [System.Collections.Generic.HashSet[int]]::new()
$i = 0
$Accumulator = 0

do {
  $Instruction = Parse-Instruction -Instruction $PuzzleInput[$i]
  switch ($Instruction['name']) {
    'nop' { 
      $i++
    }
    'jmp' {
      $i += $Instruction['arg']
    }
    'acc' {
      $Accumulator += $Instruction['arg'] 
      $i++
    }
  }
} while ($visited.Add($i))

Write-Output "Accumulator = $Accumulator"