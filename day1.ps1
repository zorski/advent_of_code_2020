$Puzzle = Get-Content -Path .\input1.txt

$Set = [System.Collections.Generic.HashSet[int]]::new($Puzzle.Count+1)

$Puzzle | ForEach-Object { $Set.Add($PSItem) | Out-Null }

foreach($Expense in $Puzzle) {
    $SearchFor = 2020 - $Expense
    if($Set.Contains($SearchFor)) {
        [int]$Expense * [int]$SearchFor
        break
    }
}

$Min = [int]($Set | Measure-Object -Minimum | Select-Object -ExpandProperty Minimum)

$P = @()
$Puzzle | ForEach-Object { $P += [int]$PSItem }

for($i = 0;$i -lt $P.Count; $i++) {
    for($j = $i+1;$j -lt $P.Count; $j++) {
        if($P[$i] + $P[$j] -lt 2020) {
            for($k = $j+1;$k -lt $P.Count; $k++) {
                if($P[$i] + $P[$j] + $P[$k] -eq 2020) {
                    $P[$i] * $P[$j] * $P[$k]
                    break;
                }
            }
        }
    }
}