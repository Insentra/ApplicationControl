        $AccessibleFolder = $Configuration.CreateInstanceFromClassName("AM.Folder")

                # Disabled until adding multiple folders with the same path can be fixed
        <#if ($PSBoundParameters.ContainsKey('AccessibleFolders')) {
            foreach ($file in $AccessibleFolders) {
                # Add a file to the list of accessible files.
                $FolderPath = Split-Path -Path $file.Path -Parent
                Write-Verbose "[Adding Accessible Folder] $(ConvertTo-EnvironmentPath -Path $FolderPath)"
                $AccessibleFolder.ItemKey = $(ConvertTo-EnvironmentPath -Path $FolderPath)
                $AccessibleFolder.Path = $(ConvertTo-EnvironmentPath -Path $FolderPath)
                if ($RegEx) { $AccessibleFolder.UseRegularExpression -eq $True}
                $AccessibleFolder.Recursive = $True
                $AccessibleFolder.TrustedOwnershipChecking = $False
                if ($file.Company -gt 1) {
                    $AccessibleFolder.Metadata.CompanyName = $file.Company
                    $AccessibleFolder.Metadata.CompanyNameEnabled = $True
                    $AccessibleFolder.Description = $file.Company
                }
                else {
                    $AccessibleFolder.Metadata.CompanyNameEnabled = $False
                }
                if ($file.Vendor -gt 1) {
                    $AccessibleFolder.Metadata.VendorName = $file.Vendor
                    $AccessibleFolder.Metadata.VendorNameEnabled = $True
                    $AccessibleFolder.Description = $file.Vendor
                } else {
                    $AccessibleFile.Metadata.VendorNameEnabled = $False
                }
                if ($file.Product -gt 1) {
                    $AccessibleFolder.Metadata.ProductName = $file.Product
                    $AccessibleFolder.Metadata.ProductNameEnabled = $True
                    $AccessibleFolder.Description = $file.Product
                }
                else {
                    $AccessibleFolder.Metadata.ProductNameEnabled = $False
                }
                if ($file.Description -gt 1) {
                    $AccessibleFolder.Metadata.FileDescription = $file.Description
                    $AccessibleFolder.Metadata.FileDescriptionEnabled = $True
                    $AccessibleFolder.Description = $file.Description
                }
                else {
                    $AccessibleFolder.Metadata.FileDescriptionEnabled = $False
                } 
                if (!($AccessibleFolder.Description)) {
                    $AccessibleFolder.Description = "[No metadata found]"
                }
                
                # Add folder to the rule and remove values from all properties ready for next file
                $Configuration.GroupRules.Item($GroupRule).AccessibleFolders.Add($AccessibleFolder.Xml()) | Out-Null
                $AccessibleFolder.Path = ""
                $AccessibleFolder.ItemKey = ""
                $AccessibleFolder.Description = ""
                $AccessibleFolder.Metadata.CompanyName = ""
                $AccessibleFolder.Metadata.ProductName = ""
                $AccessibleFolder.Metadata.VendorName = ""
                $AccessibleFolder.Metadata.FileDescription = ""
            }
        }#>