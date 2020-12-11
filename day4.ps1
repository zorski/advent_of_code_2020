$passList = @()
$passports = Get-Content -Path ./day4_input.txt
# $passports = @"
# ecl:gry pid:860033327 eyr:2020 hcl:#fffffd
# byr:1937 iyr:2017 cid:147 hgt:183cm

# iyr:2013 ecl:amb cid:350 eyr:2023 pid:028048884
# hcl:#cfa07d byr:1929

# hcl:#ae17e1 iyr:2013
# eyr:2024
# ecl:brn pid:760753108 byr:1931
# hgt:179cm

# hcl:#cfa07d eyr:2025 pid:166559648
# iyr:2011 ecl:brn hgt:59in
# "@ -split "`n"

$fields = @("byr", "iyr", "eyr", "hgt", "hcl", "ecl", "pid")
$required_fields = [System.Collections.Generic.HashSet[string]]::new()
$fields | ForEach-Object { [void]$required_fields.Add($PSItem) }
$ValidPassports = 0
$j = 0
$i = 0

while ($j -lt $passports.Count) {
  $passport_fields = [System.Collections.Generic.HashSet[string]]::new(8)
  do {
    $passports[$i] -split " " | ForEach-Object {
      $key, $val = $PSItem.split(":")
      [void]$passport_fields.Add($key)
    }
    $i++
  } until ($passports[$i] -in @("`r","", $null))
  
  $passport_fields.IntersectWith($required_fields)
  if ($passport_fields.Count -eq 7) {
    $ValidPassports++
  }
  
  $i++
  $j = $i
}

$ValidPassports

