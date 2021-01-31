$Adapters = Get-Content -Path ./day10_input.txt | ForEach-Object { [int]$_ } | Sort-Object
$Adapters = @(0) + $Adapters + @($Adapters[-1] + 3)
# $Adapters = @"
# 16
# 10
# 15
# 5
# 1
# 11
# 7
# 19
# 6
# 12
# 4
# "@ -split "`n" | ForEach-Object { [int]$_ } | Sort-Object

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


$Sum = @{Sum = 0}
$Memo = @{}
function CountDistinctAssignments {
    param (
        $Adapters,
        [int]$Start,
        $Sum
    )

    if ($Memo.ContainsKey($Start)) {
        $Sum.Sum += $Memo[$Start]
        return
    }

    if($Start -eq $Adapters[-1]) {
        $Sum.Sum += 1
        return
    }

    if ($Adapters -contains ($Start+1)) {
        CountDistinctAssignments -Adapters $Adapters -Start ($Start+1) -sum $Sum
    }

    if ($Adapters -contains ($Start+2)) {
        CountDistinctAssignments -Adapters $Adapters -Start ($Start+2) -sum $Sum
    }

    if ($Adapters -contains ($Start+3)) {
        CountDistinctAssignments -Adapters $Adapters -Start ($Start+3) -sum $Sum
    }

    $Memo.Add($Start,$Sum.Sum)
}

CountDistinctAssignments -Adapters $Adapters -start $Adapters[0] -Sum $Sum
"PART 2: $($Sum["Sum"])"



