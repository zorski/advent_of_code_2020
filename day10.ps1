$Adapters = Get-Content -Path ./day10_input.txt | ForEach-Object { [int]$_ } | Sort-Object
$Adapters = @(0) + $Adapters + @($Adapters[-1] + 3)

$Results = [PSCustomObject]@{
    One = 0
    Three = 0
}

$i = 0
while ($i -lt $Adapters.Count - 1) {
    if ($Adapters[$i+1] - $Adapters[$i] -eq 1) {
        $Results.One++
    } else {
        $Results.Three++
    }
    $i++
}

"PART 1: $($Results.One * $Results.Three)"



