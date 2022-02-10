function Show-Error{
    param ($errorItem)
    Write-Host "Sorry, we cannot find $errorItem!" -ForegroundColor Red
    Write-Host "Make sure to open the wish history ingame first." -ForegroundColor Yellow
    Write-Host "If you keep seeing this issue, try to run powershell as administrator." -ForegroundColor Yellow
}
function Get-Link{
    param ($pathToFile)
    $logs = Get-Content -Path $pathToFile
    $match = $logs -match "^OnGetWebViewPageFinish.*log$"
    if (-Not $match) {
        Show-Error -errorItem "WISH HISTORY URL" 
        return
    }
    [string] $wishHistoryUrl = $match[$match.count-1] -replace 'OnGetWebViewPageFinish:', ''
    Set-Clipboard -Value $wishHistoryUrl
    Write-Host "LINK COPIED TO YOUR CLIPBOARD" -ForegroundColor Green
    Write-Host "Paste it on the website." -ForegroundColor Cyan
    Read-Host "PRESS ENTER to open genshin-wishes.com on your browser"
    Start-Process "https://genshin-wishes.com/settings"
}

Write-Host "Asterium"

$globalPath  = [System.Environment]::ExpandEnvironmentVariables("%userprofile%\AppData\LocalLow\miHoYo\Genshin Impact\output_log.txt");
$chinaPath = [System.Environment]::ExpandEnvironmentVariables("%userprofile%\AppData\LocalLow\miHoYo\$([char]0x539f)$([char]0x795e)\output_log.txt");
$globalPathExist = [System.IO.File]::Exists($globalPath);
$chinaPathExist = [System.IO.File]::Exists($chinaPath);

if ($globalPathExist -xor $chinaPathExist){
    if($globalPathExist){
        Get-Link -pathToFile $globalPath
    } else {
        Get-Link -pathToFile $chinaPath
    }
} else {
    if ($globalPathExist -and $chinaPathExist){     
        if(((Get-ItemProperty -Path $chinaPath -Name LastWriteTime).lastwritetime - (Get-ItemProperty -Path $globalPath -Name LastWriteTime).lastwritetime) -gt 0){
            Get-Link -pathToFile $chinaPath
        } else {
            Get-Link -pathToFile $globalPath
        }
    } else {
        Show-Error -errorItem "GENSHIN IMPACT LOG FILE"
        return
    }
}
