; Liest  Extender aus der Registry
; erstellt Dummy.Ext Datei
; ermittelt die dazugehoerigen Executablen
; Schreibt ZZO Cache nach DiesesErgebnisDir
#NoEnv  ; Recommended for performance and compatibility with future AutoHotkey releases.
AutoTrim, Off
ListLines, Off
SetBatchLines, -1
#KeyHistory 0
SetWorkingDir %A_ScriptDir%  ; Ensures a consistent starting directory.

DiesesErgebnisDir:=A_AppDataCommon "\Zack\WuCont\Start Menu\ProgExt"
IfExist %DiesesErgebnisDir%
{
	FileRemoveDir %DiesesErgebnisDir%,1
	if ErrorLevel
		MsgBox, 262192, Loesch-Fehler, Das Verzeichnis `n	%DiesesErgebnisDir%`nkonnte nicht geloescht werden`, bitte manuell loeschen und`ndann OK klicken.
}
Loop, Reg,HKEY_CLASSES_ROOT,K ; VR
{
	if(SubStr(A_LoopRegName,1,1)=".")
	{
		if(StrLen(A_LoopRegName)<2)
			continue
		MusterPath=%A_Temp%\Temp%A_LoopRegName%
		FileDelete, %MusterPath%
		FileAppend,a,%MusterPath%
		; SplitPath,MusterPath,MusterName,,MusterExt
		File:=MusterPath
		gosub GetOpenWithPaths
		ProgPath:=FindExecutable(MusterPath)
		if (InStr(ProgPaths,ProgPath))
		{
		}
		else
			ProgPaths:=ProgPaths "`r`n" ProgPath
		Loop,Parse,ProgPaths,`n,`r
		{
			ProgPath:=A_LoopField
			; MsgBox % A_LoopRegName "	-->	" ProgPath
			if (ProgPath="")
				continue
			if(InStr(ProgPath,A_Temp))
				continue
			IfExist %ProgPath%
			{
				SplitPath,ProgPath,ProgName,,ProgExt
				ges.=ProgName "	" A_LoopRegName "	" ProgPath "`r`n"
				DieserPfad:=DiesesErgebnisDir "\" ProgName ".txt"
				; SplitPath,DieserPfad,,DiesesDir
				IfNotExist %DiesesErgebnisDir%
					FileCreateDir, %DiesesErgebnisDir%
				IfNotExist %DieserPfad%
					FileAppend,%ProgPath%`r`n%A_LoopRegName%,%DieserPfad%
				else
					FileAppend,%A_LoopRegName%,%DieserPfad%
			}
		}
	}
}
; MsgBox % ges

Loop,%DiesesErgebnisDir%\*
{
	FileReadLine,ProgPath,%A_LoopFileLongPath%,1
	FileReadLine,ExtList,%A_LoopFileLongPath%,2
	FileAppend,`r`n%ProgPath%,%A_LoopFileDir%\%ExtList%.%A_LoopFileName%
	FileDelete,%A_LoopFileLongPath%
}
; Clipboard:=ges
ExitApp



FindExecutable(sDocument, sMaxPathLen:=260) 
{
	VarSetCapacity(Ret, sMaxPathLen)
	RetCode := DllCall("shell32.dll\FindExecutable", "Str", sDocument, "Str", "", "Str", Ret)
	if (RetCode > 32) 
	{
		Ret = %Ret%
		Loop %Ret%, 1
        return A_LoopFileLongPath
		; return Ret
	}
	ErrorLevel := RetCode
	return ""
}


GetOpenWithPaths:
; Quelle: https://autohotkey.com/boards/viewtopic.php?t=17806
ges:=				; + Var fuer Programmliste
GesPath:=			; + Var fuer ProgrammPfadListe
; Not the best way to check for errors apparently: https://msdn.microsoft.com/en-gb/library/windows/desktop/ff485842(v=vs.85).aspx
S_OK := 0
; SHAssocEnumHandlers constants
ASSOC_FILTER_NONE := 0
ASSOC_FILTER_RECOMMENDED := 0x1

; File := A_ScriptFullPath

; Define GUIDs used by SHCreateItemFromParsingName and BindToHandler
Guid_FromStr("{43826d1e-e718-42ee-bc55-a1e261c37bfe}", IID_IShellItem)
Guid_FromStr("{B8C0BD9F-ED24-455c-83E6-D5390C4FE8C4}", BHID_DataObject)
Guid_FromStr("{0000010e-0000-0000-C000-000000000046}", IID_IDataObject)

; Get extension of file to pass to SHAssocEnumHandlers. 
; It's also possible to call SHCreateItemFromParsingName and bind it to BHID_EnumAssocHandlers to get the IAssocHandlers for a file directly,
; but I think that shows recommended apps only
SplitPath, File,,, ext
if (DllCall("Shell32.dll\SHAssocEnumHandlers", "WStr", "." . ext, "UInt", ASSOC_FILTER_RECOMMENDED, "Ptr*", EnumHandler) != S_OK)
	ExitApp 1

; Array to store handlers
handlers := Object()

Loop
{
	; IEnumAssocHandlers::Next - iterate through the available IAssocHandlers
	if (DllCall(NumGet(NumGet(EnumHandler+0)+3*A_PtrSize), "Ptr", EnumHandler, "UInt", 1, "Ptr*", AssocHandler, "UInt*", fetched) != S_OK || !fetched)
		break
	; IAssocHandler::GetUIName - falling back to ::GetName something to consider?
	if (DllCall(NumGet(NumGet(AssocHandler+0)+4*A_PtrSize), "Ptr", AssocHandler, "Ptr*", uiName) == S_OK)
	{
		DieserName:=WStrOut(uiName)				; + Var fuer temporaeres
		ges.= DieserName "`r`n"					; + Liste erzeugen
		; Menu, MyMenu, Add, % WStrOut(uiName), MenuHandler		; Original-Zeile
		Menu, MyMenu, Add, %DieserName%, MenuHandler
		if (DllCall(NumGet(NumGet(AssocHandler+0)+5*A_PtrSize), "Ptr", AssocHandler, "Ptr*", iconLoc, "Int*", iconIdx) == S_OK) ; ::GetIconLocation
		{
			if (WStrOut(iconLoc))	
			{
				if (SubStr(iconLoc, 1, 1) == "@")
					ShellUtils_LoadStringResource(iconLoc, iconLoc)
				if (iconLoc)
					try
					{
						Menu, MyMenu, Icon, %uiName%, %iconLoc%, %iconIdx%
						if (SubStr(iconLoc,-3)=".exe")
							GesPath.=iconLoc "`r`n"
					}
			}
		}
		handlers.Insert(AssocHandler) ; Add valid handler to array
	}
	else
		ObjRelease(AssocHandler) ; Assume if the display name couldn't be retrieved, the handler is useless and release it now
}
ObjRelease(EnumHandler) ; All the handlers were enumerated, so release the enumerator
ProgPaths:=GesPath
; MsgBox % ges "`r`n---------------------------------------------`r`n`r`n" GesPath
; This should block...
; Menu, MyMenu, Show			; - auskommentiert, da das Menu nicht benoetigt wird.

; Free the handlers we kept after the menu is displayed
for index, element in handlers
	ObjRelease(element), handlers[index] := 0
return							; + Ruecksprung statt ProgrammEnde
; ExitApp						; -

MenuHandler:
{
	; Get IShellItem representing a specific file so that we can call one of the AssocHandlers with a file
	if (DllCall("Shell32.dll\SHCreateItemFromParsingName", "WStr", File, "Ptr", 0, "Ptr", &IID_IShellItem, "Ptr*", Item) == S_OK)
	{
		; ::BindToHandler - get IDataObject representing the file to use with ::Invoke
		if (DllCall(NumGet(NumGet(Item+0)+3*A_PtrSize), "Ptr", Item, "Ptr", 0, "Ptr", &BHID_DataObject, "Ptr", &IID_IDataObject, "Ptr*", DataObj) == S_OK)
		{
			DllCall(NumGet(NumGet(handlers[A_ThisMenuItemPos]+0)+8*A_PtrSize), "Ptr", handlers[A_ThisMenuItemPos], "Ptr", DataObj) ; ::Invoke handler with file
			ObjRelease(DataObj)
		}
		ObjRelease(Item)
	}
}
return

; From Lexikos' VA.ahk: Convert COM-allocated wide char string pointer to usable string.
WStrOut(ByRef str) {
    str := StrGet(ptr := str, "UTF-16")
    DllCall("ole32\CoTaskMemFree", "ptr", ptr)
	return str
}

; https://github.com/cocobelgica/AutoHotkey-Util/blob/master/Guid.ahk#L36
Guid_FromStr(sGuid, ByRef VarOrAddress)
{
	if IsByRef(VarOrAddress) && (VarSetCapacity(VarOrAddress) < 16)
		VarSetCapacity(VarOrAddress, 16) ; adjust capacity
	pGuid := IsByRef(VarOrAddress) ? &VarOrAddress : VarOrAddress
	if ( DllCall("ole32\CLSIDFromString", "WStr", sGuid, "Ptr", pGuid) < 0 )
		throw Exception("Invalid GUID", -1, sGuid)
	return pGuid ; return address of GUID struct
}

; This one is mine ^_^
ShellUtils_LoadStringResource(resourceId, ByRef outputString, replaceLFwithCRLF:=false) {
	outputString := "", VarSetCapacity(renameString, (2048 * 2) + 2)
	if (DllCall("Shlwapi\SHLoadIndirectString", "Str", resourceId, "Ptr", &renameString, "UInt", 2048, "Ptr*", 0) == 0) {
		outputString := StrGet(&renameString, "UTF-16")
		if (replaceLFwithCRLF)
			outputString := StrReplace(outputString, "`n", "`r`n")
	}
	VarSetCapacity(renameString, 0), renameString := 0
	return outputString != ""
}
