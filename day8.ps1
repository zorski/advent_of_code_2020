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

# PART 2 

$Visited.Clear()
$Stack = [System.Collections.Generic.Stack[int]]::new()
$i = 0
$Accumulator = 0
$Flag = $false

while ($i -lt $PuzzleInput.Count) {
  $Instruction = Parse-Instruction -Instruction $PuzzleInput[$i]
  # if ($Flag) {
  #   if ($Instruction['name'] -eq "jmp") {
  #     $Instruction['name'] = 'nop'
  #     $Flag = $false
  #   } elseif ($Instruction['name'] -eq "nop") {
  #     $Instruction['name'] = "jmp"
  #     $Flag = $false
  #   } else {
  #     Write-Debug "nope"
  #   }
  # }

  if (-not($visited.Add($i))) {
    $PreviousIndex = $Stack.Pop()
    Write-Warning "Current Index: $i | Current: $($PuzzleInput[$i])"
    Write-Warning "Previous Index: $PreviousIndex | Previous: $($PuzzleInput[$PreviousIndex])"
    # $Flag = $true
    # $i = $PreviousIndex
    # $Visited.Remove($i)
    # continue
    break
  }
  $Stack.Push($i)
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
}

$Accumulator