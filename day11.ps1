$PuzzleInput = @"
L.LL.LL.LL
LLLLLLL.LL
L.L.L..L..
LLLL.LL.LL
L.LL.LL.LL
L.LLLLL.LL
..L.L.....
LLLLLLLLLL
L.LLLLLL.L
L.LLLLL.LL
"@ -split "`n" | foreach-object {$PSItem.trim() } | foreach-object { ,$PSItem.ToCharArray() }

function CalculateAdjacentSeats {
    [CmdletBinding()]
    param (
        [int]$Row,
        [int]$Column,
        $PuzzleInput
    )

    $StartRow = if (($Row -1) -lt 0) { 0 } else { $Row - 1 }
    $EndRow = if (($Row + 1) -ge $PuzzleInput.Count) { $Row } else { $Row + 1 }
    $StartColumn = if (($Column - 1) -lt 0) { 0 } else { $Column - 1 }
    $EndColumn = if (($Column + 1) -ge $PuzzleInput.Count) { $Column } else { $Column + 1 }
    
    $StartRow..$EndRow | ForEach-Object {
        $R = $PSitem
        $StartColumn..$EndColumn | ForEach-Object {
            $C = $PSitem
            if (-not($C -eq $Column -and $R -eq $Row)) {
                ,@($R,$C)
            }  
        }
    }
}

function EvaluateSeat {
    param (
        $Seat,
        $Neighbors,
        $PuzzleInput
    )

    $Occupied = 0

    if ($Seat -in @("L","#")) {
        foreach ($Neighbor in $Neighbors) {
            $X,$Y = $Neighbor[0],$Neighbor[1]
            if ($PuzzleInput[$X][$Y] -eq "#") { 
                $Occupied++ 
            }
        }

        if ($Seat -eq "L" -and $Occupied -eq 0) {
            return "#"
        }

        if ($Seat -eq "#" -and $Occupied -ge 4) {
            return "L"
        }

    } else {
        return $Seat
    }
}

$SeatArg = [System.Array]::CreateInstance([char],10,10)

for ($i = 0; $i -lt $PuzzleInput.Count; $i++) {
    for ($j = 0; $j -lt $PuzzleInput.Count; $j++) {
        $Neighbors = CalculateAdjacentSeats -Row $i -Column $j -PuzzleInput $PuzzleInput
        $EvaluatedSeat = EvaluateSeat -Seat $PuzzleInput[$i][$j] -Neighbors $Neighbors -PuzzleInput $PuzzleInput
        $SeatArg[$i,$j] = $EvaluatedSeat
    }
}

