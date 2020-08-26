#include <GuiConstantsEx.au3>
#include <WindowsConstants.au3>
#include <ScreenCapture.au3>
#include <Misc.au3>

Global $iX1, $iY1, $iX2, $iY2, $aPos, $sMsg, $sBMP_Path

; Create GUI
$hMain_GUI = GUICreate("Select Rectangle", 240, 50)

$hRect_Button = GUICtrlCreateButton("Mark Area", 10, 10, 80, 30)
$hCancel_Button = GUICtrlCreateButton("Cancel", 150, 10, 80, 30)

GUISetState()

While 1

	Switch GUIGetMsg()
		Case $GUI_EVENT_CLOSE, $hCancel_Button
			FileDelete(@ScriptDir & "Rect.bmp")
			Exit
		Case $hRect_Button
			GUISetState(@SW_HIDE, $hMain_GUI)
			Mark_Rect()
			; Capture selected area
			$sBMP_Path = @ScriptDir & "Rect.bmp"
			_ScreenCapture_Capture($sBMP_Path, $iX1, $iY1, $iX2, $iY2, False)
			GUISetState(@SW_SHOW, $hMain_GUI)
			; Display image
			$hBitmap_GUI = GUICreate("Selected Rectangle", $iX2 - $iX1 + 1, $iY2 - $iY1 + 1, 100, 100)
			$hPic = GUICtrlCreatePic(@ScriptDir & "Rect.bmp", 0, 0, $iX2 - $iX1 + 1, $iY2 - $iY1 + 1)
			GUISetState()

	EndSwitch

WEnd

; -------------

Func Mark_Rect()

	Local $aMouse_Pos, $hMask, $hMaster_Mask, $iTemp
	Local $UserDLL = DllOpen("user32.dll")

	; Create transparent GUI with Cross cursor
	$hCross_GUI = GUICreate("Test", @DesktopWidth, @DesktopHeight - 20, 0, 0, $WS_POPUP, $WS_EX_TOPMOST)
	WinSetTrans($hCross_GUI, "", 8)
	GUISetState(@SW_SHOW, $hCross_GUI)
	GUISetCursor(3, 1, $hCross_GUI)

	Global $hRectangle_GUI = GUICreate("", @DesktopWidth, @DesktopHeight, 0, 0, $WS_POPUP, $WS_EX_TOOLWINDOW + $WS_EX_TOPMOST)
	GUISetBkColor(0x000000)

	; Wait until mouse button pressed
	While Not _IsPressed("01", $UserDLL)
		Sleep(10)
	WEnd

	; Get first mouse position
	$aMouse_Pos = MouseGetPos()
	$iX1 = $aMouse_Pos[0]
	$iY1 = $aMouse_Pos[1]

	; Draw rectangle while mouse button pressed
	While _IsPressed("01", $UserDLL)

		$aMouse_Pos = MouseGetPos()

		$hMaster_Mask = _WinAPI_CreateRectRgn(0, 0, 0, 0)
		$hMask = _WinAPI_CreateRectRgn($iX1, $aMouse_Pos[1], $aMouse_Pos[0], $aMouse_Pos[1] + 1)   ; Bottom of rectangle
		_WinAPI_CombineRgn($hMaster_Mask, $hMask, $hMaster_Mask, 2)
		_WinAPI_DeleteObject($hMask)
		$hMask = _WinAPI_CreateRectRgn($iX1, $iY1, $iX1 + 1, $aMouse_Pos[1]) ; Left of rectangle
		_WinAPI_CombineRgn($hMaster_Mask, $hMask, $hMaster_Mask, 2)
		_WinAPI_DeleteObject($hMask)
		$hMask = _WinAPI_CreateRectRgn($iX1 + 1, $iY1 + 1, $aMouse_Pos[0], $iY1) ; Top of rectangle
		_WinAPI_CombineRgn($hMaster_Mask, $hMask, $hMaster_Mask, 2)
		_WinAPI_DeleteObject($hMask)
		$hMask = _WinAPI_CreateRectRgn($aMouse_Pos[0], $iY1, $aMouse_Pos[0] + 1, $aMouse_Pos[1])  ; Right of rectangle
		_WinAPI_CombineRgn($hMaster_Mask, $hMask, $hMaster_Mask, 2)
		_WinAPI_DeleteObject($hMask)
		; Set overall region
		_WinAPI_SetWindowRgn($hRectangle_GUI, $hMaster_Mask)

		If WinGetState($hRectangle_GUI) < 15 Then GUISetState()
		Sleep(10)

	WEnd

	; Get second mouse position
	$iX2 = $aMouse_Pos[0]
	$iY2 = $aMouse_Pos[1]

	; Set in correct order if required
	If $iX2 < $iX1 Then
		$iTemp = $iX1
		$iX1 = $iX2
		$iX2 = $iTemp
	EndIf
	If $iY2 < $iY1 Then
		$iTemp = $iY1
		$iY1 = $iY2
		$iY2 = $iTemp
	EndIf

	GUIDelete($hRectangle_GUI)
	GUIDelete($hCross_GUI)
	DllClose($UserDLL)

EndFunc   ;==>Mark_Rect
