$PuzzleInput = Get-Content -Path day9_input.txt | Foreach-Object { [int64]$_ }
$PREAMBLE_SIZE = 25

function Check-Previous {
    param (
        [int64]$Number,
        [int64[]]$Previous
    )
    
    $Previous = $Previous | Sort-Object -Descending
    for ($i = 0; $i -lt $Previous.Count; $i++) {
        if ($Previous[$i] -gt $Number) { continue }
        for ($j = $i+1; $j -lt $Previous.Count; $j++) {
            if ($Previous[$j] -gt $Number) { continue }
            if ($Number -eq $Previous[$i]+$Previous[$j]) {
                return $true
            }
        }
    }
    return $false
}

for ($i = $PREAMBLE_SIZE; $i -lt $PuzzleInput.Count; $i++) {
    if (-not(Check-Previous -Number $PuzzleInput[$i] -Previous $PuzzleInput[($i - $PREAMBLE_SIZE)..($i-1)])) {
        $FoundNumber = $PuzzleInput[$i]
    }
}

"PART 1: $FoundNumber"

for ($i = ($PuzzleInput.IndexOf($FoundNumber) - 1); $i -ge 0; $i--) {
    $ContigSet = [System.Collections.ArrayList]::new()
    $Sum = $PuzzleInput[$i]
    if ($Sum -ge $FoundNumber) { continue }
    [void]$ContigSet.Add($PuzzleInput[$i])
    $j = $i - 1
    do {
        $Sum += $PuzzleInput[$j]
        [void]$ContigSet.Add($PuzzleInput[$j])
        $j--
    } while ($Sum -lt $FoundNumber)
    if ($Sum -eq $FoundNumber) {
        $MinMax = $ContigSet | Measure-Object -Min -Max | Select-Object Maximum,Minimum
        $Result = $MinMax.Minimum + $MinMax.Maximum
        break
    }
}

"PART 2: $Result"