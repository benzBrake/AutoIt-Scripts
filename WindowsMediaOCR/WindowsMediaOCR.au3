#include <clipboard.au3>
#include <MsgBoxConstants.au3>
#include <gdiplus.au3>
#include "UWPOCR.au3"
Global $bUseClipboard = False
If $CmdLine[0] > 0 Then
    If $CmdLine[1] = "-p" Then
        $bUseClipboard = True
    EndIf
EndIf

If $bUseClipboard Then
	If _ClipBoard_Open(0) <> 1 Then
		ClipbardFailed()
		Exit
	EndIf
	$hMemory = _ClipBoard_GetDataEx($CF_BITMAP)
	If $hMemory  = 0 Then
		ClipbardFailed()
		Exit
	EndIf
	_GDIPlus_Startup()
	$hBitmap = _GDIPlus_BitmapCreateFromHBITMAP($hMemory)
	If $hBitmap = 0 Then
		ClipbardFailed()
		Exit
	EndIf
	Local $sOCRTextResult = _UWPOCR_GetText($hBitmap)
	ClipPut ($sOCRTextResult)
Else
	Local $sOCRTextResult = _UWPOCR_GetText(FileOpenDialog("Select Image", @ScriptDir & "\", "Images (*.jpg;*.bmp;*.png;*.tif;*.gif)"))
	ClipPut ($sOCRTextResult)
EndIf
Func ClipbardFailed() 
	MsgBox($MB_OK, "Error", "Failed to read image from clipboard!")
EndFunc