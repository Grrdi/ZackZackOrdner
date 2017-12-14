; Liest  Extender aus der Registry
; erstellt Dummy.Ext Datei
; ermittelt die dazugehoerigen Executablen
; Schreibt ZZO Cache nach DiesesErgebnisDir

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
		FileDelete, %A_Temp%\Temp%A_LoopRegName%
		FileAppend,a,%A_Temp%\Temp%A_LoopRegName%
		ProgPath:=FindExecutable(A_Temp "\Temp" A_LoopRegName)
		; MsgBox % A_LoopRegName "	-->	" ProgPath
		if (ProgPath="")
			continue
		if(InStr(ProgPath,A_Temp))
			continue
		IfExist %ProgPath%
		{
			SplitPath,ProgPath,ProgName
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

