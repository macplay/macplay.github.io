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

Opt("TrayMenuMode", 3)

Global Const $PIPE_NAME = "\\.\\pipe\\mpvsocket"
Global Const $SESSION_PATH = @TempDir & '\mpv_session.conf'
Global $PLAY_LIST[0]
Global $COM_HISTORY[0]
Global $LAST_URL
Global $HOSTS

Global $hGUI, $g_idEdit, $g_idMemo, $g_idSend, $g_idServer, $g_idConsole, $g_idExit

$hGUI = GUICreate("mmate", 500, 400, -1, -1, $WS_SIZEBOX)
GUICtrlCreateLabel("Server:", 2, 14, 52, 20, $SS_RIGHT)
$g_idServer = GUICtrlCreateEdit($PIPE_NAME, 56, 10, 200, 20, $SS_LEFT)
GUICtrlCreateLabel("Command:", 2, 36, 52, 20, $SS_RIGHT)
$g_idEdit = GUICtrlCreateEdit("", 56, 32, 370, 20, $SS_LEFT + $WS_HSCROLL + $ES_AUTOHSCROLL)
$g_idSend = GUICtrlCreateButton("Send", 430, 32, 60, 20, $BS_DEFPUSHBUTTON)
$g_idMemo = GUICtrlCreateEdit("", 0, 62, _WinAPI_GetClientWidth($hGUI), 332, $WS_VSCROLL + $ES_READONLY)
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
$HOSTS = IniRead($SESSION_PATH, "General", "Host", "")

While True
    Local $sClip, $sNow, $sURL, $iIndex
    $sClip = ClipGet()
    $sNow = FilterString($sClip)
    If $sNow == "" Then
        If $LAST_URL <> "" And $sNow <> $LAST_URL Then
            $sURL = $LAST_URL
        EndIf
    Else
        If $sNow <> $LAST_URL Then $sURL = $sNow
    EndIf
    If $sURL <> "" Then
        $iIndex = _ArraySearch($PLAY_LIST, $sURL)
        If @error Then
            _ArrayAdd($PLAY_LIST, $sURL)
            IniWrite($SESSION_PATH, "General", "URL", $sURL)
            If Not ProcessExists("mpv.exe") Then
                Run("mpv --input-ipc-server=mpvsocket  --idle")
                If ProcessWait("mpv.exe") Then
                    sleep(200)
                    WriteMsg($PIPE_NAME, "loadfile " & $sURL & " append-play" & @CRLF)
                EndIf
            Else
                If $sURL <> $LAST_URL Then
                    WriteMsg($PIPE_NAME, "loadfile " & $sURL & " append-play" & @CRLF)
                EndIf
            EndIf
        EndIf
    EndIf
    Switch GUIGetMsg()
        Case $g_idSend
            Local $iSend, $iIndex
            $iSend = GUICtrlRead($g_idEdit)
            If $iSend <> "" Then
                WriteMsg(GUICtrlRead($g_idServer), $iSend & @CRLF)
                GUICtrlSetData($g_idEdit, "")
                $iIndex = _ArraySearch($COM_HISTORY, $iSend)
                If @error Then
                    _ArrayAdd($COM_HISTORY, $iSend)
                    _GUICtrlEdit_InsertText($g_idMemo, $iSend & @CRLF, 0)
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
            Local $sHistory
            _ArrayDelete($COM_HISTORY, "200-")
            $swHistory = _ArrayToString($COM_HISTORY, "|")
            IniWrite($SESSION_PATH, "General", "History", $swHistory)
            Exit
    EndSwitch
WEnd

Func FilterString($sString)
    Local $iStrip, $iPattern, $aArray, $iURL
    $iStrip = StringStripWS($sString, $STR_STRIPLEADING + $STR_STRIPTRAILING)
    $iPattern = "^((?:ht|f)tps?)\:\/\/([0-9a-zA-Z](?:[-.\w]*[0-9a-zA-Z])*)(?::([0-9]+))*\/?([a-zA-Z0-9\-\.\?\,\'\/\\\+\$=&%#_]*)?$"
    $aArray = StringRegExp($iStrip, $iPattern, $STR_REGEXPARRAYFULLMATCH)
 ; _ArrayDisplay($aArray)
    If UBound($aArray) == 5 Then
        If StringRight($aArray[0], 5) == ".m3u8" Then $iURL = $aArray[0]
        If $HOSTS <> "" Then
            If StringInStr($aArray[2], $HOSTS) <> 0 Then $iURL = $aArray[0]
        EndIf
    EndIf
    Return $iURL
EndFunc   ;==>FilterString

Func WriteMsg($sServer, $sMessage)
    Local $hPipe, $iWritten, $iBuffer, $pBuffer, $tBuffer
    $hPipe = _WinAPI_CreateFile($sServer, 2, 6)
    If $hPipe <> -1 Then
        $iBuffer = StringLen($sMessage) + 1
        $tBuffer = DllStructCreate("char Text[" & $iBuffer & "]")
        $pBuffer = DllStructGetPtr($tBuffer)
        DllStructSetData($tBuffer, "Text", $sMessage)
        If Not _WinAPI_WriteFile($hPipe, $pBuffer, $iBuffer, $iWritten, 0) Then
            TrayTip("Hmm...", "WriteMsg: _WinAPI_WriteFile failed", 3)
        EndIf
    EndIf
    _WinAPI_CloseHandle($hPipe)
EndFunc   ;==>WriteMsg
