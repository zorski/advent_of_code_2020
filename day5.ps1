$Seats = Get-Content -Path .\day5_input.txt

function Take-Lower {
  [CmdletBinding()]
  param (
    [Parameter(Mandatory=$true)]
    [System.Collections.Hashtable]$Range
  )

  $Low = $Range['low']
  $High = $Range['high']

  $NewHigh = [math]::Floor($Low + ($High - $Low) / 2)

  @{'low' = $Low; 'high' = $NewHigh}
}

function Take-Upper {
  [CmdletBinding()]
  param (
    [Parameter(Mandatory=$true)]
    [System.Collections.Hashtable]$Range
  )

  $Low = $Range['low']
  $High = $Range['high']

  $NewLow = [math]::Ceiling($Low + ($High - $Low) / 2)

  @{'low' = $NewLow; 'high' = $High}
}

function Convert-SeatCode {
  [CmdletBinding()]
  param (
    [Parameter(Mandatory=$true,ValueFromPipeline=$true)]
    [string]$SeatCode
  )
  process {
    $Row = $SeatCode.Substring(0,7).ToCharArray()
    $Column = $SeatCode.Substring(7,3).ToCharArray()
    $RowRange = @{
      'low' = 0
      'high' = 127
    }

    $ColumnRange = @{
      'low' = 0
      'high' = 7
    }

    foreach ($Letter in $Row) {
      if ($Letter -eq "F") {
        $RowRange = Take-Lower -Range $RowRange
      } else {
        $RowRange = Take-Upper -Range $RowRange
      }
    }

    foreach ($Letter in $Column) {
      if ($Letter -eq "R") {
        $ColumnRange = Take-Upper -Range $ColumnRange
      } else {
        $ColumnRange = Take-Lower -Range $ColumnRange
      }
    }

    $SeatID = $RowRange['low'] * 8 + $ColumnRange['low']
    @{'row' = $RowRange['low']; 'column' = $ColumnRange['low']; id = $SeatID }
  }
}

$ConvertedSeatCodes = $Seats | Convert-SeatCode
$HighestSeatID = $ConvertedSeatCodes.id | Measure-Object -Maximum | Select-Object -ExpandProperty Maximum
Write-Output "Highest SeatID: $HighestSeatID"

#PART 2
$AllIds = [System.Collections.Generic.HashSet[int]]::new(780)
48..818 | ForEach-Object { $AllIDs.Add($PSItem) | Out-Null }

$CurrentIds = [System.Collections.Generic.HashSet[int]]::new(780)
$ConvertedSeatCodes.id | ForEach-Object { $CurrentIds.Add($PSItem) | Out-Null }

$AllIds.ExceptWith($CurrentIds)
Write-Output "My SeatID: $AllIds"