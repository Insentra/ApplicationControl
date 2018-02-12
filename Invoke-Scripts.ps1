. .\Get-DigitalSignatures.ps1
. .\Get-FileMetadata.ps1
. .\New-AampConfiguration.ps1

$Path = "C:\Users\aaron\AppData\Local\GitHubDesktop"
Get-DigitalSignatures -Path $Path -OutPath "C:\Temp\GitHubDesktop" -Verbose
Get-DigitalSignatures -Path $Path -Verbose | Where-Object { $_.Status -eq "NotSigned" } | Get-FileMetadata -Verbose | New-AampConfiguration -Path C:\Temp\GitHubDesktop.aamp

$Path = "C:\Users\aaron\AppData\Local\Microsoft\Teams", "C:\Users\aaron\AppData\Local\Microsoft\TeamsMeetingAddin"
Get-DigitalSignatures -Path $Path -OutPath "C:\Temp\Teams" -Verbose
$Files = Get-DigitalSignatures -Path $Path -Verbose | Where-Object { $_.Status -eq "NotSigned" } | Get-FileMetadata -Verbose
New-AampConfiguration -Path C:\Temp\Teams.aamp

$Path = "C:\Users\aaron\AppData\Local\yammerdesktop"
Get-DigitalSignatures -Path $Path -OutPath "C:\Temp\yammer" -Verbose
Get-DigitalSignatures -Path $Path -Verbose | Where-Object { $_.Status -eq "NotSigned" } | Get-FileMetadata -Verbose | New-AampConfiguration -Path C:\Temp\yammer.aamp


$Path = "C:\Users\aaron\AppData\Local\Spotify"
Get-DigitalSignatures -Path $Path -OutPath "C:\Temp\Spotify" -Verbose
Get-DigitalSignatures -Path $Path -Verbose | Where-Object { $_.Status -eq "NotSigned" } | Get-FileMetadata -Verbose | New-AampConfiguration -Path C:\Temp\spotify.aamp

$Path = "C:\Users\aaron\AppData\Local\GoTo Opener", "C:\Users\aaron\AppData\Local\GoToMeeting"
Get-DigitalSignatures -Path $Path -OutPath "C:\Temp\GoTo" -Verbose
Get-DigitalSignatures -Path $Path -Verbose | Where-Object { $_.Status -eq "NotSigned" } | Get-FileMetadata -Verbose | New-AampConfiguration -Path C:\Temp\goto.aamp

$Path = "C:\Users\aaron\AppData\Local\Google\Chrome"
Get-DigitalSignatures -Path $Path -OutPath "C:\Temp\Chrome" -Verbose
$Files = Get-DigitalSignatures -Path $Path -Verbose | Where-Object { $_.Status -eq "NotSigned" } | Get-FileMetadata -Verbose
New-AampConfiguration -Path C:\Temp\goto.aamp -AccessibleFiles $Files

$Path = "C:\Users\aaron\AppData\Local\Atlassian", "C:\Users\aaron\AppData\Local\SourceTree"
Get-DigitalSignatures -Path $Path -OutPath "C:\Temp\SourceTree" -Verbose
$Files = Get-DigitalSignatures -Path $Path -Verbose | Where-Object { $_.Status -eq "NotSigned" } | Get-FileMetadata -Verbose
New-AampConfiguration -Path C:\Temp\goto.aamp -AccessibleFiles $Files

$Path = "C:\Users\aaron\AppData\Local\slack"
Get-DigitalSignatures -Path $Path -OutPath "C:\Temp\Slack" -Verbose
$Files = Get-DigitalSignatures -Path $Path -Verbose | Where-Object { $_.Status -eq "NotSigned" } | Get-FileMetadata -Verbose
New-AampConfiguration -Path C:\Temp\slack.aamp -AccessibleFiles $Files

$Path = "C:\Users\aaron\AppData\Local\Microsoft\OneDrive"
Get-DigitalSignatures -Path $Path -OutPath "C:\Temp\OneDrive" -Verbose
$Files = Get-DigitalSignatures -Path $Path -Verbose | Where-Object { $_.Status -eq "NotSigned" } | Get-FileMetadata -Verbose
New-AampConfiguration -Path C:\Temp\OneDrive.aamp -AccessibleFiles $Files

$Path = "C:\Users\aaron\AppData\Roaming\Mozilla"
Get-DigitalSignatures -Path $Path -OutPath "C:\Temp\Mozilla" -Verbose
$Files = Get-DigitalSignatures -Path $Path -Verbose | Where-Object { $_.Status -eq "NotSigned" } | Get-FileMetadata -Verbose
New-AampConfiguration -Path C:\Temp\Mozilla.aamp -AccessibleFiles $Files

$Path = "C:\Temp\SysinternalsSuite"
Get-DigitalSignatures -Path $Path -OutPath "C:\Temp\Sysinternals" -Verbose
$Files = Get-DigitalSignatures -Path $Path -Verbose | Where-Object { $_.Status -eq "NotSigned" } | Get-FileMetadata -Verbose

