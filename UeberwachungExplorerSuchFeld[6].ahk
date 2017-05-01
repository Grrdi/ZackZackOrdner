; SetFormat,integer,h
ue1=%1%
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
; TopParentID:= Decimal_to_Hex(DllCall("GetDesktopWindow"))
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
	WinGetText, WinTitleTxt, ahk_id %TopParentID% ; ,ahk_id %AktWinHwnd%	; liefert was
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
			ControlSetText,Edit2,%FuerEdit2%,ZackZackOrdner
			if NurEinDurchlauf
				ExitApp
		}
		
		
		if(OrdnerName<>OrdnerNameLast)
		{
			; SoundBeep
			if CacheModus
			{
				ControlGetText,VorhandenerText,Edit7,ZackZackOrdner
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
					ControlSetText,Edit7,%OrdnerName%,ZackZackOrdner
					OrdnerNameLast:=OrdnerName
					if NurEinDurchlauf
						ExitApp

				}
			}
		}
		if DirektModus
		{
			ControlGetText,SuchstringAusfuehlich,ToolbarWindow323, ahk_id %AktWinHwnd%
			LocationPos:=InStr(SuchstringAusfuehlich,"location:")
			LocationPath:=SubStr(SuchstringAusfuehlich,LocationPos+9)
			StringReplace,LocationPath,LocationPath,`%3A,:,All
			StringReplace,LocationPath,LocationPath,`%5C,`\,All
			StringReplace,LocationPath,LocationPath,`%20,%A_Space%,All
			ToolTip >%FuerEdit2%< in`n>%LocationPath%<	;	`n>%SuchstringAusfuehlich%<
			Fuer_Edit2m:=Fuer_Edit2
			if(SubStr(LocationPath,0,1)="`\")
				StringTrimRight,LocationPath,LocationPath,1
			Fuer_Edit2:="Filp://" LocationPath "\*" FuerEdit2 "*`,DFR" A_Space "in_RoW?" A_Space ; OrdnerName A_Space

			if(FuerEdit2Last<>Fuer_Edit2)
			{
			; SoundBeep,3000
			ControlGetText,Edit2Vorhanden,Edit2,ZackZackOrdner ahk_class AutoHotkeyGUI
			; ControlFocus,Edit2,ZackZackOrdner ahk_class AutoHotkeyGUI 
			sleep 50
			if(not InStr(Edit2Vorhanden,"FilP://") or LocationPath<>LocationPathLast)
			{
				ControlSetText,Edit2,%Fuer_Edit2%,ZackZackOrdner ahk_class AutoHotkeyGUI 
				; ToolTip,%A_LineNumber% >%FuerEdit2%< 	>%OrdnerName%< 		%Fuer_Edit2%
				LocationPathLast:=LocationPath
				if NurEinDurchlauf
					ExitApp

			}
			else
			{
				 ControlFocus,Edit11,ZackZackOrdner ahk_class AutoHotkeyGUI 
				 ControlSetText,Edit11,%FuerEdit2%,ZackZackOrdner ahk_class AutoHotkeyGUI 
				; ControlFocus,Edit12,ZackZackOrdner ahk_class AutoHotkeyGUI 
				; ControlSetText,Edit12,%OrdnerName%,ZackZackOrdner ahk_class AutoHotkeyGUI
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
		ControlGetText, ExplorerWinSuchControlText3, Edit1,ahk_id %AktWinHwnd%	; liefert das gewüschte veraltet
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
		WinGetText, ExplorerWinSuchControlText2, ahk_id 0x5909f4 ; ,ahk_id %AktWinHwnd%	; liefert das gewüschte veraltet
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
