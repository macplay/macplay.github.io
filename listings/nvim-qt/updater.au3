; Download nvim-win32.zip(NVIM nightly on Windows) from GitHub and extract it to designed directory, so I don't have to do it manually :)

#include <AutoItConstants.au3>
#include <InetConstants.au3>
#include <MsgBoxConstants.au3>
#include <WinAPIFiles.au3>
#include <TrayConstants.au3>

Opt("TrayAutoPause", 0)

TraySetState($TRAY_ICONSTATE_SHOW) ; Show the tray menu.

; Download a file in the background.
; Wait for the download to complete.

; Save the downloaded file to the temporary folder.
Local $sFilePath = _WinAPI_GetTempFileName(@TempDir)

; Download the file in the background with the selected option of 'force a reload from the remote site.'
Local $hDownload = InetGet("https://github.com/neovim/neovim/releases/download/nightly/nvim-win32.zip", $sFilePath, $INET_FORCERELOAD, $INET_DOWNLOADBACKGROUND)
; Wait for the download to complete by monitoring when the 2nd index value of InetGetInfo returns True.
Do
    Sleep(250)
    ; Retrieve details about the download files
    Local $aData = InetGetInfo($hDownload)
    Local $rSize = StringFormat("%.2fMB", $aData[$INET_DOWNLOADREAD]/1024/1024)
    Local $fSize
    Local $aPercent
    If $aData[$INET_DOWNLOADSIZE] <> 0 Then
        $fSize = StringFormat("%.2fMB", $aData[$INET_DOWNLOADSIZE]/1024/1024)
        $aPercent = StringFormat("%.2f%", $aData[$INET_DOWNLOADREAD]/$aData[$INET_DOWNLOADSIZE]*100)
    Else
        $fSize = "?"
        $aPercent = "?"
    EndIf
    TraySetToolTip($rSize & "/" & $fSize & " i.e. " & $aPercent)
    If @error Then
        ExitLoop
        FileDelete($sFilePath)
        TrayTip("Error while downloading the file", "I will resume the download procedure in 5s.", 5)
        Sleep(5000)
        Run(@AutoItExe)
        Exit
    EndIf
Until InetGetInfo($hDownload, $INET_DOWNLOADCOMPLETE)

; Retrieve the number of total bytes and the filesize.
Local $iBytesSize = InetGetInfo($hDownload, $INET_DOWNLOADSIZE)
Local $iFileSize = FileGetSize($sFilePath)
If $iFileSize = 0 Or $iFileSize < $iBytesSize Then
    TrayTip("Hmm...", "The file size seems not right, I will resume the download procedure in 5s.", 5)
    Sleep(5000)
    FileDelete($sFilePath)
    Run(@AutoItExe)
    Exit
EndIf

; Close the handle returned by InetGet.
InetClose($hDownload)

If ProcessExists("nvim-qt.exe") Or ProcessExists("nvim.exe") Then
    $iAsk = MsgBox($MB_OKCANCEL, "Continue?", "You need to close nvim-qt/nvim before continue.")
    If $iAsk == $IDOK Then
        TraySetToolTip("Waiting for nvim-qt/nvim to exit...")
        ProcessWaitClose("nvim-qt.exe")
        ProcessWaitClose("nvim.exe")
    Else
        FileDelete($sFilePath)
        Exit
    EndIf
EndIf

Local $s7zPath = @ProgramFilesDir & "\7-Zip\7z.exe"
Local $sExtract = "c:\tools\Neovim\"
If $s7zPath Then
    Local $e7zPath = StringRegExpReplace($s7zPath, "^(.+)", '"$1"')
    ConsoleWrite($e7zPath & @CRLF)
    TraySetToolTip("Extracting files to designed directory...")
    Local $iPID = RunWait(@ComSpec & " /c " & $e7zPath & " x " & $sFilePath & " -o" & $sExtract & " -r -y", @TempDir, @SW_HIDE)
    If @error Then
        TrayTip("Error", "Error while extracting file.", 3)
        Exit
    EndIf
    ; Delete the file.
    FileDelete($sFilePath)
    TrayTip("\o/", "Done!", 1)
Else
    TrayTip("Error", "Can't find 7z.exe for extracting!", 5)
    Exit
EndIf
