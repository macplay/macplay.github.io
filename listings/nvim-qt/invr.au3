; A wrapper of [nvr](https://github.com/mhinz/neovim-remote), mainly for nvim-qt on windows. It upports nvr's all features, plus more: no more "os.fork" error (which means do NOT use "--servername" parameter)! Also, a extra "--server" parameter is handled.
; Note: you need to follow the conduct of command line parameters on windows. i.e. use [invr --remote-expr "map([1,2,3], 'v:val + 1')"] instead of [nvr --remote-expr 'map([1,2,3], "v:val + 1")'].

; by ashfinal 2019-11-30

#NoTrayIcon
Opt("ExpandEnvStrings", 1)
#include <AutoItConstants.au3>
#include <GUIConstantsEx.au3>
#include <WindowsConstants.au3>
#include <Array.au3>
#include <EditConstants.au3>
#include <GuiEdit.au3>


Global $args, $idx, $server
If Not EnvGet("NVIM_LISTEN_ADDRESS") Then
   EnvSet("NVIM_LISTEN_ADDRESS", "127.0.0.1:7777")
   EnvUpdate()
EndIf

If Not ProcessExists("nvim-qt.exe") Then
   $NVIM = Run("nvim-qt.exe")
   If @error Then
      $info = "Unable to launch nvim-qt.exe!"
      InfoWindow($info)
   EndIf
EndIf

If $CmdLine[0] Then
; _ArrayDisplay($CmdLine)
   For $i = 0 To $CmdLine[0]
      If StringLeft($CmdLine[$i], 1) == "+" Then
         Local $result = StringRegExpReplace($CmdLine[$i], "^(\+)(.+)", '$1"$2"')
         $CmdLine[$i] = $result
      EndIf
      If Not StringInStr("+-", StringLeft($CmdLine[$i], 1)) Then
         Local $result = StringRegExpReplace($CmdLine[$i], "^(.+)", '"$1"')
         $CmdLine[$i] = $result
      EndIf
      If $CmdLine[$i] == "--server" Then
         $idx = $i
         $server = $CmdLine[$i+1]
      EndIf
   Next
   If $server <> "" Then
      _ArrayDelete($CmdLine, $idx & ";" & $idx+1)
   EndIf
; _ArrayDisplay($CmdLine)
   _ArrayDelete($CmdLine, 0)
   $args = _ArrayToString($CmdLine, " ")
; MsgBox(0, "", $args)
EndIf

; MsgBox(0, "server", $server)
If $server <> "" Then
   $iQT = Run("nvim-qt.exe --server " & $server)
   If @error Then
      $info = "Unable to launch nvim-qt.exe!"
      InfoWindow($info)
   EndIf
EndIf

$iPID = Run(@ComSpec & " /c nvr.exe " & $args, "", @SW_HIDE, $STDERR_MERGED)
If @error Then
   $info = "Unable to launch nvr.exe!"
   InfoWindow($info)
Else
   WinActivate("[REGEXPTITLE:.* - NVIM - Neovim; Class:Qt5QWindowIcon]", "")
EndIf

$sOutput = ""
While 1
  $sOutput &= StdoutRead($iPID)
  If @error Then ; Exit the loop if the process closes or StderrRead returns an error.
      ExitLoop
  EndIf
WEnd

If $sOutput <> "" Then InfoWindow($sOutput)

Func InfoWindow($info)
   $hGUI = GUICreate("Info", 480, 240) ; will create a dialog box that when displayed is centered
   $iEdit = GUICtrlCreateEdit("", 0, 0, 480, 240-30-2*10, $ES_READONLY + $WS_HSCROLL + $WS_VSCROLL)
   GUICtrlSetFont(-1, 10)
   $iBtn = GUICtrlCreateButton("OK", 480-85-15, 240-30-10, 85, 30)
   GUISetState(@SW_SHOW, $hGUI)

   GUICtrlSetData($iEdit, $info, 1)
   _GUICtrlEdit_LineScroll($iEdit, 0, -_GUICtrlEdit_GetLineCount($iEdit))

   ; Loop until the user exits.
   While 1
      Switch GUIGetMsg()
         Case $GUI_EVENT_CLOSE, $iBtn
            ExitLoop
      EndSwitch
   WEnd
   GUIDelete($hGUI)
EndFunc
