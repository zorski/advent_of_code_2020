$PuzzleInput = Get-Content -Path .\day7_input.txt

function Parse-BagRules {
    [cmdletbinding()]
    Param(
        $BagRules
    )

    $BagRulesParsed = @{}
    $BagRulesParsedReversed = @{}

    foreach($BagRule in $BagRules) {
        $Parent, $Children = ($BagRule -split "contain").Trim()
        $Parent = ($Parent.Split(" ")[0..1] -join " ")
        if($Children -eq "no other bags.") {
            $Children = $null
        } else {
            $ChildrenSet = @{}
            $Children = $Children.Split(",").Trim()
            $Children | ForEach-Object {
                $C = $PSItem.Split(" ")
                $Quantity = [int]$C[0]
                $Name = $C[1..2] -join " "
                $ChildrenSet.Add($Name,$Quantity)
            }
            $Children = $ChildrenSet
        }

        if ($Children) {
            $Children.Keys | ForEach-Object {
                if($BagRulesParsedReversed.ContainsKey($PSItem)){
                    $BagRulesParsedReversed[$PSItem] += $Parent
                } else {
                    $BagRulesParsedReversed.Add($PSItem,@($Parent))
                }    
            }  
        }
        
        $BagRulesParsed.Add($Parent,$Children)
    }

    @{tree=$BagRulesParsed;tree_reversed=$BagRulesParsedReversed}
}

$BG = Parse-BagRules -BagRules $PuzzleInput

$Bags = [System.Collections.Generic.HashSet[string]]::new()

function Traverse-Tree {
    Param(
        $needle,
        $haystack
    )

    $parents = $haystack[$needle]
    if(-not($parents)) { return }
    $parents | ForEach-Object {
        $Bags.Add($PSItem) | Out-Null
        Traverse-Tree -needle $PSItem -haystack $haystack 
    }
}

Traverse-Tree -needle "shiny gold" -haystack $BG.tree_reversed

Write-Output ("How many bag colors can eventually contain at least one shiny gold bag? {0}" -f $Bags.Count)

#PART 2
function Traverse-OnceAgain {
    [CmdletBinding()]
    param (
        $start,
        $where
    )

    Write-Debug -Message "I'm in $start, childnodes: $($where[$start].Keys -join '|')"

    $c = $where[$start]
    if (-not $c) {
        return 0
    }

    foreach ($child in $c.GetEnumerator()) {
        $add = $child.Value
        $tothisshit = Traverse-OnceAgain -start $child.Key -where $where
        ($add + $add * ($tothisshit | Measure-Object -Sum).Sum)
    }
}

$Result = Traverse-OnceAgain -start "shiny gold" -where $BG.tree

($Result | Measure-Object -Sum).Sum