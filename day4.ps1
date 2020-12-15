$passports = Get-Content -Path ./day4_input.txt

$fields = @("byr", "iyr", "eyr", "hgt", "hcl", "ecl", "pid")
$required_fields = [System.Collections.Generic.HashSet[string]]::new()
$fields | ForEach-Object { [void]$required_fields.Add($PSItem) }
$ValidPassports = 0
$ActualValidPassports = 0
$j = 0
$i = 0

function Invoke-PassportsChecks {
  [CmdletBinding()]
  Param (
    $PassportData
  )
  
  if ($PassportData['byr'] -notin (1920..2002)) {
    return $false
  }

  if ($PassportData['iyr'] -notin (2010..2020)) {
    return $false
  }

  if ($PassportData['eyr'] -notin (2020..2030)) {
    return $false
  }

  if ($PassportData['hgt'].EndsWith("cm")) {
    $Height = $PassportData['hgt'].TrimEnd("cm")
    if ($Height -notin (150..193)) {
      return $false
    }
  } elseif ($PassportData['hgt'].EndsWith("in")) {
    $Height = $PassportData['hgt'].TrimEnd("in")
    if ($Height -notin (59..76)) {
      return $false
    }
  } else {
    return $false
  }

  if ($PassportData['hcl'] -notmatch "^#[0-9a-f]{6}$") {
    return $false
  }

  if ($PassportData['ecl'] -notin @("amb", "blu", "brn", "gry", "grn", "hzl", "oth")) {
    return $false
  }

  if ($PassportData['pid'] -notmatch "^[0-9]{9}$") {
    return $false
  }

  return $true
}

while ($j -lt $passports.Count) {
  $passport_fields = [System.Collections.Generic.HashSet[string]]::new(8)
  $passport_data = @{}
  do {
    $passports[$i] -split " " | ForEach-Object {
      $key, $val = $PSItem.split(":")
      [void]$passport_fields.Add($key)
      $passport_data.Add($key, $val)
    }
    $i++
  } until ($passports[$i] -in @("`r","", $null))
  
  $passport_fields.IntersectWith($required_fields)

  if ($passport_fields.Count -eq 7) {
    $ValidPassports++
    $PasswordDataCheckResult = Invoke-PassportsChecks -PassportData $passport_data
    if ($PasswordDataCheckResult) {
      $ActualValidPassports++
    }
  }
  
  $i++
  $j = $i
}

Write-Output "PART 1: $ValidPassports"

# PART 2
Write-Output "PART 2: $ActualValidPassports"