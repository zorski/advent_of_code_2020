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
            $Children = @()
        } else {
            $Children = $Children.Split(",").Trim()
            $Children = $Children -replace "^\d+\s",""
            $Children = $Children -replace "bags?",""
            $Children = $Children -replace "\.$",""
            $Children = $Children.Trim()
        }
        $Children | ForEach-Object {
            if($BagRulesParsedReversed.ContainsKey($PSItem)){
                $BagRulesParsedReversed[$PSItem] += $Parent
            } else {
                $BagRulesParsedReversed.Add($PSItem,@($Parent))
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
    $parents | foreach {
        $Bags.Add($PSItem) | Out-Null
        Traverse-Tree -needle $PSItem -haystack $haystack 
    }
}

Traverse-Tree -needle "shiny gold" -haystack $BG.tree_reversed

Write-Output ("How many bag colors can eventually contain at least one shiny gold bag? {0}" -f $Bags.Count)

