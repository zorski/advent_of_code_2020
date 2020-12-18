$PuzzleInput = Get-Content -Path ./day8_input.txt

function Parse-Instruction {
  param (
    [string]$Instruction
  )
  
  if($Instruction -match "(?<int>[a-z]{3})\s(?<sign>[+-]{1})(?<arg>\d+)"){
    [PSCustomObject]@{
      int  = $Matches['int']
      arg  = [int]"$($Matches['sign'])$($Matches['arg'])"
    }
  } else {
    Write-Warning "couldn't parse the instruction"
  }
}

$visited = [System.Collections.Generic.HashSet[int]]::new()
$i = 0
$acc = 0

do {
  $Int = Parse-Instruction -Instruction $PuzzleInput[$i]
  switch ($Int.int) {
    'nop' { 
      $i++
    }
    'jmp' {
      $i += $Int.arg
    }
    'acc' {
      $acc += $Int.arg 
      $i++
    }
  }
} until (-not($visited.Add($i)))

Write-Output "Accumulator = $acc"