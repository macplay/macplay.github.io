#NoTrayIcon
#Region ;**** Directives created by AutoIt3Wrapper_GUI ****
#AutoIt3Wrapper_Icon=mpv-icon.ico
#EndRegion ;**** Directives created by AutoIt3Wrapper_GUI ****
#include <File.au3>
#include <Array.au3>
#include <NamedPipes.au3>
#include <StaticConstants.au3>
#include <WinAPI.au3>
#include <WindowsConstants.au3>
#include <GUIConstantsEx.au3>
#include <ButtonConstants.au3>
#include <GuiEdit.au3>
#include <TrayConstants.au3>
#include <EditConstants.au3>
#include <Misc.au3>

Opt("TrayMenuMode", 3)

If _Singleton("mmate", 1) = 0 Then
    MsgBox($MB_ICONWARNING, "Warning!", "An occurrence of mmate is already running.", 3)
    Exit(1)
EndIf

Global Const $PIPE_NAME = "\\.\\pipe\\mpvsocket"
Global Const $SESSION_PATH = @TempDir & '\mpv_session.conf'
Global $PLAY_LIST[0]
Global $COM_HISTORY[0]
Global $FIRST_PROCESS = True
Global $PIPE_HANDLER
Global $LAST_CLIP
Global $LAST_URL
Global $HOSTS

Global $hGUI, $g_idEdit, $g_idMemo, $g_idSend, $g_idServer, $g_idConsole, $g_idExit

$hGUI = GUICreate("mmate", 500, 400, -1, -1, $WS_SIZEBOX)
GUICtrlCreateLabel("Server:", 2, 14, 52, 20, $SS_RIGHT)
$g_idServer = GUICtrlCreateEdit($PIPE_NAME, 56, 10, 200, 20, $SS_LEFT + $ES_READONLY)
GUICtrlCreateLabel("Command:", 2, 36, 52, 20, $SS_RIGHT)
$g_idEdit = GUICtrlCreateEdit("", 56, 32, 370, 20, $SS_LEFT + $WS_HSCROLL + $ES_AUTOHSCROLL)
$g_idSend = GUICtrlCreateButton("Send", 430, 32, 60, 20, $BS_DEFPUSHBUTTON)
$g_idMemo = GUICtrlCreateEdit("", 0, 62, _WinAPI_GetClientWidth($hGUI), 332, $WS_VSCROLL + $WS_HSCROLL + $ES_READONLY)
GUICtrlSetFont($g_idMemo, 9, 400, 0, "Courier New")
Local $srHistory = IniRead($SESSION_PATH, "General", "History", "")
If $srHistory <> "" Then
    _ArrayAdd($COM_HISTORY, StringSplit($srHistory, "|", $STR_NOCOUNT))
    Local $sData = StringReplace($srHistory, "|", @CRLF)
    _GUICtrlEdit_SetText($g_idMemo, $sData)
EndIf
$g_idConsole = TrayCreateItem("Show Console")
TrayCreateItem("") ; Create a separator line.
$g_idExit = TrayCreateItem("Exit")
TraySetState($TRAY_ICONSTATE_SHOW) ; Show the tray menu.
TraySetToolTip("mmate")
; TraySetClick(16)

$LAST_URL = IniRead($SESSION_PATH, "General", "URL", "")
$HOSTS = IniRead($SESSION_PATH, "General", "Hosts", "")

While True
    Local $sClip, $sURL, $iPL
    $sClip = ClipGet()
    If $sClip <> $LAST_CLIP Then
        ConsoleWrite('@@ Debug(' & @ScriptLineNumber & ') : $LAST_CLIP = ' & $LAST_CLIP & @CRLF & '>Error code: ' & @error & @CRLF) ;### Debug Console
        $LAST_CLIP = $sClip
        $sURL = FilterString($sClip)
        If $sURL == "" Then
            If Not _WinAPI_FileExists($PIPE_NAME) Then
                ConsoleWrite('@@ Debug(' & @ScriptLineNumber & ') : _WinAPI_FileExists($PIPE_NAME) = ' & _WinAPI_FileExists($PIPE_NAME) & @CRLF & '>Error code: ' & @error & @CRLF) ;### Debug Console
                If $FIRST_PROCESS Then
                    If $LAST_URL <> "" Then
                        _ArrayAdd($PLAY_LIST, $LAST_URL)
                        ConsoleWrite('@@ Debug(' & @ScriptLineNumber & ') : $PLAY_LIST = ' & $PLAY_LIST & @CRLF & '>Error code: ' & @error & @CRLF) ;### Debug Console
                        LaunchAndWrite("loadfile " & $LAST_URL & " append-play" & @CRLF)
                        ConsoleWrite('@@ Debug(' & @ScriptLineNumber & ') : LaunchAndWrite("loadfile " & $LAST_URL & " append-play" & @CRLF) = ' & LaunchAndWrite("loadfile " & $LAST_URL & " append-play" & @CRLF) & @CRLF & '>Error code: ' & @error & @CRLF) ;### Debug Console
                    EndIf
                EndIf
            EndIf
        Else
            If _WinAPI_FileExists($PIPE_NAME) Then
                ConsoleWrite('@@ Debug(' & @ScriptLineNumber & ') : _WinAPI_FileExists($PIPE_NAME) = ' & _WinAPI_FileExists($PIPE_NAME) & @CRLF & '>Error code: ' & @error & @CRLF) ;### Debug Console
                If $sURL <> $LAST_URL Then
                    $iPL = _ArraySearch($PLAY_LIST, $sURL)
                    If @error Then
                        _ArrayAdd($PLAY_LIST, $sURL)
                        IniWrite($SESSION_PATH, "General", "URL", $sURL)
                        WriteMsg($PIPE_NAME, "loadfile " & $sURL & " append-play" & @CRLF)
                    EndIf
                EndIf
            Else
                _ArrayDelete($PLAY_LIST, "0-" & (UBound($PLAY_LIST) - 1))
                _ArrayAdd($PLAY_LIST, $sURL)
                IniWrite($SESSION_PATH, "General", "URL", $sURL)
                LaunchAndWrite("loadfile " & $sURL & " append-play" & @CRLF)
            EndIf
        EndIf
    EndIf
    $FIRST_PROCESS = False
    Switch GUIGetMsg()
        Case $g_idSend
            Local $sMsg, $iHS
            $sMsg = GUICtrlRead($g_idEdit)
            If $sMsg <> "" Then
                If _WinAPI_FileExists($PIPE_NAME) Then
                    WriteMsg($PIPE_NAME, $sMsg & @CRLF)
                Else
                    LaunchAndWrite($sMsg & @CRLF)
                EndIf
                GUICtrlSetData($g_idEdit, "")
                $iHS = _ArraySearch($COM_HISTORY, $sMsg)
                If @error Then
                    _ArrayAdd($COM_HISTORY, $sMsg)
                    _GUICtrlEdit_InsertText($g_idMemo, $sMsg & @CRLF, 0)
                EndIf
                GUICtrlSetState($g_idEdit, $GUI_FOCUS)
            EndIf
        Case $GUI_EVENT_CLOSE
            GUISetState(@SW_HIDE, $hGUI)
    EndSwitch
    Switch TrayGetMsg()
        Case $g_idConsole
            GUISetState(@SW_SHOW, $hGUI)
            GUICtrlSetState($g_idEdit, $GUI_FOCUS)
        Case $g_idExit
            Local $swHistory
            If $PIPE_HANDLER Then _WinAPI_CloseHandle($PIPE_HANDLER)
            _ArrayDelete($COM_HISTORY, "200-" & (UBound($COM_HISTORY) - 1))
            $swHistory = _ArrayToString($COM_HISTORY, "|")
            IniWrite($SESSION_PATH, "General", "History", $swHistory)
            Exit
    EndSwitch
WEnd

Func FilterString($sString)
    Local $iStrip, $iPattern, $aArray, $iURL, $aITEM
    $iStrip = StringStripWS($sString, $STR_STRIPLEADING + $STR_STRIPTRAILING)
    $iPattern = "^((?:ht|f)tps?)\:\/\/([0-9a-zA-Z](?:[-.\w]*[0-9a-zA-Z])*)(?::([0-9]+))*\/?([a-zA-Z0-9\-\.\?\,\'\/\\\+\$\*=&%#_]*)?$"
    $aArray = StringRegExp($iStrip, $iPattern, $STR_REGEXPARRAYFULLMATCH)
    If UBound($aArray) == 5 Then
        If StringRight($aArray[0], 5) == ".m3u8" Then $iURL = $aArray[0]
        If $HOSTS <> "" Then
            $aITEM = StringSplit($HOSTS, "|")
            For $i = 1 To $aITEM[0]
                If StringInStr($aArray[2], $aITEM[$i]) <> 0 Then
                    $iURL = $aArray[0]
                    ExitLoop
                EndIf
            Next
        EndIf
    EndIf
    Return $iURL
EndFunc   ;==>FilterString

Func LaunchAndWrite($sMessage)
    $iPid = Run("mpv --input-ipc-server=mpvsocket --idle")
    If $iPid Then
        For $i = 5 To 1 Step -1
            If WriteMsg($PIPE_NAME, $sMessage) Then
                Return True
            EndIf
            Sleep(200)
        Next
    Else
        TrayTip("Can't launch mpv!", "Please check your mpv path." & @CRLF & "mmate will exit now.", 3)
        Exit (1)
    EndIf
    Return False
EndFunc   ;==>LaunchAndWrite

Func WriteMsg($sServer, $sMessage)
    Local $iWritten, $iBuffer, $pBuffer, $tBuffer
    If Not $PIPE_HANDLER Then GetPipeHandler($sServer)
    ConsoleWrite('@@ Debug(' & @ScriptLineNumber & ') : $PIPE_HANDLER = ' & $PIPE_HANDLER & @CRLF & '>Error code: ' & @error & @CRLF) ;### Debug Console
    If $PIPE_HANDLER Then
        $iBuffer = StringLen($sMessage) + 1
        $tBuffer = DllStructCreate("char Text[" & $iBuffer & "]")
        $pBuffer = DllStructGetPtr($tBuffer)
        DllStructSetData($tBuffer, "Text", $sMessage)
        If _WinAPI_WriteFile($PIPE_HANDLER, $pBuffer, $iBuffer, $iWritten, 0) Then
            ConsoleWrite('@@ Debug(' & @ScriptLineNumber & ') : _WinAPI_WriteFile($PIPE_HANDLER, $pBuffer, $iBuffer, $iWritten, 0) = ' & _WinAPI_WriteFile($PIPE_HANDLER, $pBuffer, $iBuffer, $iWritten, 0) & @CRLF & '>Error code: ' & @error & @CRLF) ;### Debug Console
            _WinAPI_CloseHandle($PIPE_HANDLER)
            $PIPE_HANDLER = False
            Return True
        EndIf
    EndIf
    Return False
EndFunc   ;==>WriteMsg

Func GetPipeHandler($sServer)
    Local $hPipe
    For $i = 5 To 1 Step -1
        $hPipe = _WinAPI_CreateFile($sServer, 2, 4)
        If $hPipe Then
            $PIPE_HANDLER = $hPipe
            Return True
        EndIf
        Sleep(200)
    Next
    Return False
EndFunc   ;==>GetPipeHandler
