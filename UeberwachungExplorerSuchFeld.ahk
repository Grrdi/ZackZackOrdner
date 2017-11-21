; SetFormat,integer,h
ExternalToolTipPath:=A_AppData "\Zack\ExternalTooltip.ahk"
ue1=%1%
RunOtherAhkScriptOrExe(ExternalToolTipPath,A_ScriptFullPath A_Space Ue1 "	gestartet")
if(Ue1="einmal")
	NurEinDurchlauf:=true
else
	NurEinDurchlauf:=false

DirektModus:=true
CacheModus:=false
Loop 0
{
	; if (A_Index<0xffff)
	; 	continue
	; SoundBeep
	WinGetText, ExplorerWinSuchControlText2, ahk_id %A_Index% ; ,ahk_id %AktWinHwnd%	; liefert was
	if(InStr(ExplorerWinSuchControlText2,"Suchergebnisse in ""Strukturen"""))
	{
		GefundenID:=A_Index
		break
		WinGetClass,Class, ahk_id %A_Index%
		Clipboard:=ExplorerWinSuchControlText2
		MsgBox % A_Index "	" Class "`n`n" ExplorerWinSuchControlText2
	}
	
}
; TextStellenIndex:=1
; TopParentTxtMaxLen:=100
TopParentID:= Decimal_to_Hex(DllCall("GetDesktopWindow"))
; SoundBeep
; SuchKennung:="- Suchergebnisse in """
SuchKennungsListe=- Suchergebnisse in,- search,-%A_Space%
SuchKennungLen:=StrLen(SuchKennung)
Loop
{
	WinWaitActive ,ahk_class CabinetWClass
	
	if(A_TimeIdlePhysical<5000 and NurEinDurchlauf)
		{
			loop, 300
				sleep -1
			continue
		}
	/*			
				; Run or activate Notepad
				; Works with any Windows version
				; (uses window classes instead of
				; windows title).
				IfWinNotExist, ahk_class Notepad
					Run, notepad.exe
				WinWait, ahk_class Notepad
				; WinActivate ; Run or activate Notepad
				; Works with any Windows version
				; (uses window classes instead of
				; windows title).
				IfWinNotExist, ahk_class Notepad
					Run, notepad.exe
				WinWait, ahk_class Notepad
				; WinActivatelDirectUIHWND3 -1
			
		}
			*/
	AktWinHwnd:=WinExist("A")
	Anzeige=
	Loop
	{
		WinGetTitle,TitleText,ahk_id %AktWinHwnd%
		TitleTextLen:=StrLen(TitleText)
		ThisAktWinHwnd:=WinExist("A")
        ControlGetFocus,FocusedControl, ahk_id %AktWinHwnd%
		FocusedControlLen:=StrLen(FocusedControl)
		; ToolTip,% FocusedControl,10,10
		if(FocusedControl=SubStr(TitleText,1,FocusedControlLen) or FocusedControl="DirectUIHWND1")
		{	
		}
		else
		{
			Clipboard:=FocusedControl
			break
		}
				
		if(ThisAktWinHwnd<>AktWinHwnd)
			break
		StringSplit,SuchKennung,SuchKennungsListe,`,
		loop, % SuchKennung0
			{
				SuchergebnissePos:=InStr(TitleText,SuchKennung%A_Index%)
				if SuchergebnissePos
					{
						SuchKennungLen:=SuchKennung%A_Index%
						break
					}
			}
;		SuchergebnissePos:=InStr(TitleText,SuchKennung)
;		if TitleText contains %SuchKennungsListe%
		if not SuchergebnissePos
			break
		FuerEdit2:=SubStr(TitleText,1,SuchergebnissePos-1)
		OrdnerName:=SubStr(TitleText,SuchergebnissePos+SuchKennungLen,TitleTextLen-SuchergebnissePos-SuchKennungLen)
		; ToolTip,%A_LineNumber% >%FuerEdit2%< 	>%OrdnerName%<
		FuerEdit2:=trim(FuerEdit2)
		if((Fuer_Edit2<>FuerEdit2Last) and Fuer_Edit2<>"" and CacheModus)
		{
			ControlSetText,Edit4,SufiAus.,ZackZackOrdner ahk_class AutoHotkeyGUI
			sleep 30
			ControlSetText,Edit2,%FuerEdit2%,ZackZackOrdner ahk_class AutoHotkeyGUI
			ControlSend,,F5,ZackZackOrdner ahk_class AutoHotkeyGUI
			if NurEinDurchlauf
				ExitApp
		}
		
		
		if(OrdnerName<>OrdnerNameLast)
		{
			; SoundBeep
			if CacheModus
			{
				ControlGetText,VorhandenerText,Edit7,ZackZackOrdner ahk_class AutoHotkeyGUI
				if VorhandenerText is Integer
				{
				}
				else if (OrdnerName="")
				{
				}
				else if (FuerEdit2="")
				{
				}
				else
				{
					ControlSetText,Edit4,SufiAus.,ZackZackOrdner ahk_class AutoHotkeyGUI
					sleep 30
					ControlSetText,Edit7,%OrdnerName%,ZackZackOrdner ahk_class AutoHotkeyGUI
					OrdnerNameLast:=OrdnerName
					ControlSend,,F5,ZackZackOrdner ahk_class AutoHotkeyGUI
						ExitApp

				}
			}
		}
		if DirektModus
		{
			
			ControlGetText,SuchstringAusfuehlich,ToolbarWindow323, ahk_id %AktWinHwnd%
			; MsgBox % SuchstringAusfuehlich
			; RunOtherAhkScriptOrExe(ExternalToolTipPath,A_ScriptName "	" A_LineNumber "	" SuchstringAusfuehlich)
			; sleep 3000
			if(SuchstringAusfuehlich="")
			{
				WinGetText, TopParentTxt, ahk_id %TopParentID% ; ,ahk_id %AktWinHwnd%	; liefert was
				SuchstringAusfuehlich:=TopParentTxt
				LocationPos:=InStr(SuchstringAusfuehlich,"location:")
				LocationPosLen:=InStr(SubStr(SuchstringAusfuehlich,LocationPos),"`n")-11
				LocationPath:=SubStr(SuchstringAusfuehlich,LocationPos+9,LocationPosLen)
				RunOtherAhkScriptOrExe(ExternalToolTipPath,A_ScriptName "	" A_LineNumber "	" LocationPath)

			}
			else
			{
				LocationPos:=InStr(SuchstringAusfuehlich,"location:")
				if NOT LocationPos
					LocationPos:=InStr(SuchstringAusfuehlich,"Adresse:")+1

				; LocationPosLen:=InStr(SubStr(SuchstringAusfuehlich,LocationPos),"`n")-10
				LocationPath:=SubStr(SuchstringAusfuehlich,LocationPos+9)
			}
			if(LocationPos=0) ; Pfad nicht ermittelbar
			{
				RunOtherAhkScriptOrExe(ExternalToolTipPath,A_ScriptName "	" A_LineNumber "	Explorer-Pfad nicht ermittelbar")
				
				; ControlSetText,Edit4,SufiAus.,ZackZackOrdner ahk_class AutoHotkeyGUI
				; ControlSetText,Edit2,%Fuer_Edit2%,ZackZackOrdner ahk_class AutoHotkeyGUI 
				; LocationPathLast:=LocationPath
				SoundBeep, 4000
				SoundBeep, 4000
				SoundBeep, 4000
				if NurEinDurchlauf
				{
					ExitApp
				}
				break
			}
			; MsgBox % LocationPath
			StringReplace,LocationPath,LocationPath,`%3A,:,All
			StringReplace,LocationPath,LocationPath,`%5C,`\,All
			StringReplace,LocationPath,LocationPath,`%20,%A_Space%,All
			ToolTip >%FuerEdit2%< in`n>%LocationPath%<	;	`n>%SuchstringAusfuehlich%<
			Fuer_Edit2m:=Fuer_Edit2
			if(SubStr(LocationPath,0,1)="`\")
			if(SubStr(LocationPath,0,1)="`\")
				StringTrimRight,LocationPath,LocationPath,1
			if(SubStr(LocationPath,1)="`\")		; Pfad nicht ermittelbar oder Netzlaufwerk, es wird doch der CacheModus verwendet
			{
				; Fuer_Edit2 bleibt wie oben definiert
				ControlSetText,Edit4,SufiAus.,ZackZackOrdner ahk_class AutoHotkeyGUI
				ControlSetText,Edit2,%Fuer_Edit2%,ZackZackOrdner ahk_class AutoHotkeyGUI 
				ControlSend,,F5,ZackZackOrdner ahk_class AutoHotkeyGUI
				RunOtherAhkScriptOrExe(ExternalToolTipPath,A_ScriptName "	" A_LineNumber "	" Fuer_Edit2 "	->Edit2")
	
				LocationPathLast:=LocationPath
				if NurEinDurchlauf
					ExitApp
				break
			}
			else
				Fuer_Edit2:="Filp://" LocationPath "\*" FuerEdit2 "*`,DFR" A_Space "in_RoW?" A_Space ; OrdnerName A_Space

			if(FuerEdit2Last<>Fuer_Edit2)
			{
			; SoundBeep,3000
			ControlGetText,Edit2Vorhanden,Edit2,ZackZackOrdner ahk_class AutoHotkeyGUI
			; ControlFocus,Edit2,ZackZackOrdner ahk_class AutoHotkeyGUI 
			sleep 50
			if(not InStr(Edit2Vorhanden,"FilP://") or LocationPath<>LocationPathLast)
			{
				; ControlSetText,Edit4,SufiAus.,ZackZackOrdner ahk_class AutoHotkeyGUI		; scharfschalten wenn Sufi ausgewertet wird!
				ControlSetText,Edit2,%Fuer_Edit2%,ZackZackOrdner ahk_class AutoHotkeyGUI 
				; ToolTip,%A_LineNumber% >%FuerEdit2%< 	>%OrdnerName%< 		%Fuer_Edit2%
				LocationPathLast:=LocationPath
			ControlSend,,F5,ZackZackOrdner ahk_class AutoHotkeyGUI
			RunOtherAhkScriptOrExe(ExternalToolTipPath,A_ScriptName "	" A_LineNumber "	" Fuer_Edit2 "	->Edit2")

			if NurEinDurchlauf
					ExitApp

			}
			else
			{
				 ControlFocus,Edit11,ZackZackOrdner ahk_class AutoHotkeyGUI 
				 ControlSetText,Edit11,%FuerEdit2%,ZackZackOrdner ahk_class AutoHotkeyGUI 
				; ControlFocus,Edit12,ZackZackOrdner ahk_class AutoHotkeyGUI 
				; ControlSetText,Edit12,%OrdnerName%,ZackZackOrdner ahk_class AutoHotkeyGUI
			ControlSend,,F5,ZackZackOrdner ahk_class AutoHotkeyGUI
			RunOtherAhkScriptOrExe(ExternalToolTipPath,A_ScriptName "	" A_LineNumber "	" Fuer_Edit2 "	->Edit2")
			LocationPathLast:=LocationPath
				if NurEinDurchlauf
					ExitApp
			}			 
			
			; sleep 5000
			FuerEdit2Last:=Fuer_Edit2
			; MsgBox % Fuer_Edit2
			}
			else
				Fuer_Edit2:=Fuer_Edit2m
		}
		; SuchStringPos:=InStr(SubStr(TopParentTxt,1,SuchergebnissePos-1),"`n",,0)+1
		; Anzeige:=SubStr(TopParentTxt,SuchStringPos,SuchergebnissePos-SuchStringPos-1)  "`n" ; "	" SuchergebnissePos-SuchStringPos-3 "	" SuchStringPos "	" SuchergebnissePos	;	
		; ToolTip,% Anzeige
		;++TextStellenIndex
		sleep 400
	}
	Sleep 900
	; ToolTip,% SubStr(TopParentTxt,SuchergebnissePos-TopParentTxtMaxLen,TopParentTxtMaxLen-3)
	
}

Decimal_to_Hex(var)
{
  SetFormat, integer, hex
  var += 0
  SetFormat, integer, d
  return var
}

; Backup
/*
		continue
        ControlGetFocus,FocusedControl, ahk_id %AktWinHwnd%
		ControlGetText, ExplorerWinSuchControlText3, Edit1,ahk_id %AktWinHwnd%	; liefert das gew��te veraltet
		; ControlGet, AusgabeVar, Hwnd,, Edit1, Fenstertitel
		WinGet,ControlHwnd,ControlListHwnd, ahk_id %AktWinHwnd%
		StringSplit,ControlHwnd,ControlHwnd,`n
		n:=0
		Loop, % ControlHwnd0
		{
			if (GefundenID+0 = ControlHwnd%A_Index%+0)
				MsgBox %GefundenID%
			++n
			WinGetText, ControlHwndTxt, ahk_id ControlHwnd%A_Index% ; ,ahk_id %AktWinHwnd%	; liefert was
if (ControlHwndTxt<>"")
	MsgBox, % ControlHwndTxt
if(InStr(ControlHwndTxt,"Suchergebnisse in ""Strukturen"""))
			{
				MsgBox, % ExplorerWinSuchControlText2
			}
;		ControlGet, ThisControlHwnd, Hwnd,, CabinetWClass%A_Index%, ahk_id %AktWinHwnd%
;		if ThisControlHwnd ; ControlHwnd1
	;		break
		}
		MsgBox % GefundenID "`n`n" ControlHwnd
		SoundBeep
		ExitApp
		ControlGetText, ExplorerWinSuchControlText4, CabinetWClass,ahk_id %AktWinHwnd%
		ControlGetText, ExplorerWinSuchControlText5, Edit3,ahk_id %AktWinHwnd%
		ControlGetText, ExplorerWinSuchControlText2, ShellTabWindowClass,ahk_id %AktWinHwnd%
		ControlGetText, ExplorerWinSuchControlText2,, ahk_id 0x20ce4 ; ,ahk_id %AktWinHwnd%
		ControlGetText, ExplorerWinSuchControlText2, ahk_id 0x20ce4 ; ,ahk_id %AktWinHwnd%
		WinGetText, ExplorerWinSuchControlText2, ahk_id 0x20ce4 ; ,ahk_id %AktWinHwnd% 	; liefert was
		WinGetText, ExplorerWinSuchControlText2, ahk_id 0x506f2 ; ,ahk_id %AktWinHwnd%	; liefert was
		WinGetText, ExplorerWinSuchControlText2, ahk_id 0x5909f4 ; ,ahk_id %AktWinHwnd%	; liefert das gew��te veraltet
		WinGetText, ExplorerWinSuchControlText2, ahk_id 0x506f4 ; ,ahk_id %AktWinHwnd%	; liefert was
		WinGetText, ExplorerWinSuchControlText2, ahk_id 0x506f6 ; ,ahk_id %AktWinHwnd%	; liefert was
		WinGetText, ExplorerWinSuchControlText2, ahk_id 0x506f8 ; ,ahk_id %AktWinHwnd%	; liefert was
		WinGetText, ExplorerWinSuchControlText2, ahk_id 0x506fc ; ,ahk_id %AktWinHwnd%	; liefert was
		WinGetText, ExplorerWinSuchControlText2, ahk_id %ThisControlHwnd% ; ,ahk_id %AktWinHwnd%	; liefert was
		ControlGetText, ExplorerWinSuchControlText1, ToolbarWindow32,ahk_id %AktWinHwnd%
		ToolTip,%FocusedControl%	>%ThisControlHwnd%<>%ExplorerWinSuchControlText2%<	`n%ExplorerWinSuchControlText3%`n%ExplorerWinSuchControlText4%`n>%ExplorerWinSuchControlText5%<
		sleep 2000
		;	WinGet,ExplorerWinHwnd,ID
		;	ToolTip, %ExplorerWinHwnd%
		; SoundBeep,200
		IfWinActive ,ahk_class CabinetWClass
		{
			WinGet,ExplorerWinHwnd,ID
			ControlGetFocus,FocusedControl, ahk_id %AktWinHwnd%
			; ControlGetText, ExplorerWinSuchControlText,ahk_class DirectUIHWND3,ahk_id %ExplorerWinHwnd%
			; ControlGetText, ExplorerWinSuchControlText,ahk_class ShellTabWindowClass,ahk_id %ExplorerWinHwnd%
			ControlGetText, ExplorerWinSuchControlText2, ShellTabWindowClass,ahk_id %ExplorerWinHwnd%
			ControlGetText, ExplorerWinSuchControlText1, ToolbarWindow32,ahk_id %ExplorerWinHwnd%
			Tooltip, >%ExplorerWinSuchControlText1%<>%ExplorerWinSuchControlText2%<
		}
		else
		{
			ToolTip
			sleep 2000
			break
		}
		sleep 500
	}
*/
RunOtherAhkScriptOrExe(StartScriptPath,UebergabeParameter*)	;{()	
{
		
	global RunPid, NurExeStartErlaubt

	Hochkomma="
	
; 			WinGet, GuiWinPid, PID, %GuiWinHwnd%
		; Ermittelt das WMI-Service-Objekt.
; 		wmi := ComObjGet("winmgmts:")
		; Führt eine Abfrage zur Ermittlung von passenden Prozessen aus.
; 		queryEnum := wmi.ExecQuery(""
; 			. "Select * from Win32_Process where ProcessId=" . GuiWinPid)
; 			._NewEnum()
; 		; Ermittelt den ersten passenden Prozess.
		;~ if queryEnum[process]
		;~ {
			;~ ; MsgBox % process.CommandLine
			;~ StringTrimRight,ScriptNameOhneExt, A_ScriptName,4
			;~ if(InStr(process.CommandLine,"AutoHotKey.exe"))
				;~ AhkIstInstalliert:=true
			;~ else if(InStr(process.CommandLine,ScriptNameOhneExt ".ahk"))
			;~ {
				;~ AhkIstInstalliert:=false
			;~ }
			;~ else if(InStr(process.CommandLine,ScriptNameOhneExt ".exe"))
				;~ AhkIstInstalliert:=false
				;~ ; MsgBox %A_LineNumber%	ZackZackOrdener kompiliert wird nicht unterstützt.
			;~ else
				;~ MsgBox %A_LineNumber%	Unerwarteter Script-Zweig
		;~ }

	
	If (UebergabeParameter.MaxIndex()="")
		ThisUebergabeParameter:=false
	else
		ThisUebergabeParameter:=true
	Loop, % UebergabeParameter.MaxIndex()
	{
		AlleUebergabeParameter:=AlleUebergabeParameter A_Space Hochkomma UebergabeParameter[A_Index] Hochkomma
		if ZackZackOrdnerLogErstellen
;			ThreadUeberwachungLog(A_LineNumber-1,AlleUebergabeParameter,A_ThisLabel,A_ThisFunc,UebergabeParameter[A_Index],A_ThisMenuItem,A_ThisMenuItemPos)
	if (StartScriptExt="ahk")
		StartScriptAhkPath:=StartScriptPath
	}
	SplitPath,StartScriptPath,StartScriptFileName,StartScriptDir,StartScriptExt,StartScriptNameNoExt
	if (StartScriptExt="ahk")
		StartScriptAhkPath:=StartScriptPath
	else if (StartScriptExt="exe")
	{
		StartScriptAhkPath:=StartScriptDir "\" StartScriptNameNoExt ".ahk"
		StartScriptExePath:=StartScriptPath
	}
	try
		run, %StartScriptAhkPath% %AlleUebergabeParameter%,,UseErrorLevel, RunPid
	catch
	{
		try
			run, %StartScriptExePath% %Hochkomma%%StartScriptAhkPath%%Hochkomma% %AlleUebergabeParameter%,,UseErrorLevel, RunPid
	}
	if (RunPid="")
		MsgBox, 262160, %A_LineNumber% Fehler bei Skriptstart, %StartScriptAhkPath% und %StartScriptExePath% nicht vorhanden!
	else
		return 1
/*

	else if (StartScriptExt="exe")
		StartScriptAhkPath:=StartScriptDir "\" StartScriptNameNoExt ".ahk"
	IfExist % FuehrendeSterneEntfernen(StartScriptAhkPath)
		DaStartScriptAhkPath:=true
	else
		DaStartScriptAhkPath:=false
	StartScriptExePath:=StartScriptDir "\" StartScriptNameNoExt ".exe" 
	IfExist % FuehrendeSterneEntfernen(StartScriptExePath)
		DaStartScriptExePath:=true
	else
		DaStartScriptExePath:=false
	
	if (DaStartScriptAhkPath and not DaStartScriptExePath and not AhkIstInstalliert)
	{
		IfExist %A_ScriptDir%\%ScriptNameOhneExt%.exe
		{
			FileCopy %A_ScriptDir%\%ScriptNameOhneExt%.exe,StartScriptExePath
			IfExist %StartScriptExePath%
				DaStartScriptExePath:=true
		}
	}
	if (DaStartScriptAhkPath and AhkIstInstalliert)
	{
		try
			run, %StartScriptAhkPath% %AlleUebergabeParameter%,,UseErrorLevel, RunPid
		if ErrorLevel
		{
			MsgBox, 262160, %A_LineNumber% Fehler bei Skriptstart, Direktstart von %StartScriptAhkPath% schlug fehl!
			return 0
		}
		else
			return RunPid
	}
	else if (DaStartScriptAhkPath and DaStartScriptExePath)_	
	{
		; run, %StartScriptExePath%  %AlleUebergabeParameter%,,UseErrorLevel, RunPid
		run, %StartScriptExePath% %Hochkomma%%StartScriptAhkPath%%Hochkomma% %AlleUebergabeParameter%,,UseErrorLevel, RunPid
		if ErrorLevel
		{
			MsgBox, 262160, %A_LineNumber% Fehler bei Skriptstart, Start von %StartScriptExePath% %Hochkomma%%StartScriptAhkPath%%Hochkomma% %AlleUebergabeParameter% schlug fehl und %StartScriptExePath% nicht vorhanden!
			return 0
		}
		else
			return RunPid
	}
	else if DaStartScriptExePath
	{
		MsgBox, 262160, %A_LineNumber% Fehler bei Skriptstart, %StartScriptAhkPath% nicht vorhanden!
		; MsgBox %A_LineNumber%	%StartScriptAhkPath% fehlt!
		return 0
	}
	else if DaStartScriptAhkPath
	{
		MsgBox, 262160, %A_LineNumber% Fehler bei Skriptstart, %StartScriptExePath% nicht vorhanden!
		; MsgBox %A_LineNumber%	%StartScriptAhkPath% fehlt!
		return 0
	}
	else
	{
		MsgBox, 262160, %A_LineNumber% Fehler bei Skriptstart, %StartScriptAhkPath% und %StartScriptExePath% nicht vorhanden!
		; MsgBox %A_LineNumber%	%StartScriptAhkPath% fehlt!
		return 0
	}
	
	return
	*/
}
;}	
