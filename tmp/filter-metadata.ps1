# ----------
# Filtering metadata
$Values = @(" ", "", $Null)
$Less = $Files | Where-Object {
    ($Values -contains $_.Vendor) -or `
    ($Values -contains $_.Company) -or `
    ($Values -contains $_.Product) -or `
    ($Values -contains $_.Description)
}
$NoMetadata = $Files | Where-Object {
    ($Values -contains $_.Vendor) -and `
    ($Values -contains $_.Company) -and `
    ($Values -contains $_.Product) -and `
    ($Values -contains $_.Description)
}
$Metadata = $Files | Where-Object {
    ($Values -notcontains $_.Vendor) -and `
    ($Values -notcontains $_.Company) -and `
    ($Values -notcontains $_.Product) -and `
    ($Values -notcontains $_.Description)
}