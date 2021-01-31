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
"@ -split "`n" | foreach-object { ,$PSItem.ToCharArray() }

function CalculateAdjacentSeats {
    [CmdletBinding()]
    param (
        [int]$Row,
        [int]$Column
    )
    
    ($Row-1)..($Row+1) | Foreach-object {
        $R = $PSitem
        ($Column-1)..($Column+1) | foreach-object {
            $C = $PSitem
            if($C -ge 0 -and $R -ge 0) {
                if (-not($C -eq $Column -and $R -eq $Row)) {
                    ,@($R,$C)
                }
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

            if ($Occupied -ge 4 -and $Seat -eq "#") {
                $Result = "L"
                break
            }
        }

        if ($Seat -eq "L" -and $Occupied -eq 0) {
            $Result = "#"
        }

        return $Result
    } else {
        return $Seat
    }
}
for ($i = 0; $i -lt $PuzzleInput.Count; $i++) {
    for ($j = 0; $j -lt $PuzzleInput.Count; $j++) {
        $Neighbors = CalculateAdjacentSeats -Row $i -Column $j
        $EvaluatedSeat = EvaluateSeat -Seat $PuzzleInput[$i][$j] -Neighbors $Neighbors -PuzzleInput $PuzzleInput
        $PuzzleInput[$i][$j] = $EvaluatedSeat
    }
}

$PuzzleInput