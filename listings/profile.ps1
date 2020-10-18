Set-PSReadLineOption -EditMode Vi
Set-PSReadLineOption -HistorySearchCursorMovesToEnd
Set-PSReadLineOption -ViModeIndicator Cursor
Set-PSReadLineKeyHandler -Key Ctrl+d -Function ViCommandMode
Set-PSReadLineKeyHandler -Key Ctrl+a -Function BeginningOfLine
Set-PSReadLineKeyHandler -Key Ctrl+e -Function EndOfLine
Set-PSReadLineKeyHandler -Key Ctrl+b -Function BackwardChar
Set-PSReadLineKeyHandler -Key Ctrl+f -Function ForwardChar
Set-PSReadLineKeyHandler -Key Ctrl+w -Function BackwardDeleteWord
Set-PSReadLineKeyHandler -Key Ctrl+u -Function BackwardDeleteLine
Set-PSReadLineKeyHandler -Key Ctrl+p -Function PreviousHistory
Set-PSReadLineKeyHandler -Key Ctrl+n -Function NextHistory
Set-PSReadLineKeyHandler -Key Alt+b -Function SelectBackwardWord
Set-PSReadLineKeyHandler -Key Alt+f -Function SelectForwardWord
Set-PSReadLineKeyHandler -Key Shift+LeftArrow -Function SelectBackwardChar
Set-PSReadLineKeyHandler -Key Shift+RightArrow -Function SelectForwardChar
Set-PSReadLineKeyHandler -Key Ctrl+c -Function CopyOrCancelLine
Set-PSReadLineKeyHandler -Key UpArrow -Function HistorySearchBackward
Set-PSReadLineKeyHandler -Key DownArrow -Function HistorySearchForward
Set-PSReadLineKeyHandler -Key Tab -Function MenuComplete

$env:EDITOR="nvim -u NONE"
$env:GO111MODULE="on"
$env:GOPROXY="https://goproxy.io,direct"

function global:prompt {
$Success = $?

## Time calculation
$LastExecutionTimeSpan = if (@(Get-History).Count -gt 0) {
Get-History | Select-Object -Last 1 | ForEach-Object {
New-TimeSpan -Start $_.StartExecutionTime -End $_.EndExecutionTime
}
}
else {
New-TimeSpan
}

$LastExecutionShortTime = if ($LastExecutionTimeSpan.Days -gt 0) {
"$($LastExecutionTimeSpan.Days + [Math]::Round($LastExecutionTimeSpan.Hours / 24, 2)) d"
}
elseif ($LastExecutionTimeSpan.Hours -gt 0) {
"$($LastExecutionTimeSpan.Hours + [Math]::Round($LastExecutionTimeSpan.Minutes / 60, 2)) h"
}
elseif ($LastExecutionTimeSpan.Minutes -gt 0) {
"$($LastExecutionTimeSpan.Minutes + [Math]::Round($LastExecutionTimeSpan.Seconds / 60, 2)) m"
}
elseif ($LastExecutionTimeSpan.Seconds -gt 0) {
"$($LastExecutionTimeSpan.Seconds + [Math]::Round($LastExecutionTimeSpan.Milliseconds / 1000, 2)) s"
}
elseif ($LastExecutionTimeSpan.Milliseconds -gt 0) {
"$([Math]::Round($LastExecutionTimeSpan.TotalMilliseconds, 2)) ms"
}
else {
"0 s"
}

## History ID
$HistoryId = ($MyInvocation.HistoryId).ToString().PadLeft(3, "0")

## User
$IsAdmin = (New-Object Security.Principal.WindowsPrincipal ([Security.Principal.WindowsIdentity]::GetCurrent())).IsInRole([Security.Principal.WindowsBuiltinRole]::Administrator)

$WindowTitle = $env:COMPUTERNAME
if ($IsAdmin) { $WindowTitle = "Administrator - " + $WindowTitle }
$Host.UI.RawUI.WindowTitle = $WindowTitle

Write-Host -Object $PWD.Path -NoNewline -ForegroundColor DarkCyan
Write-Host -Object "  took " -NoNewline -ForegroundColor DarkGray
Write-Host -Object $LastExecutionShortTime -ForegroundColor $(if ($Success) { "DarkYellow" } else { "DarkRed" })
Write-Host -Object "[$HistoryId]" -NoNewline -ForegroundColor White
Write-Host -Object " >" -NoNewline -ForegroundColor $(if ($IsAdmin) { "Red" } else { "Green" })

return " "
}
