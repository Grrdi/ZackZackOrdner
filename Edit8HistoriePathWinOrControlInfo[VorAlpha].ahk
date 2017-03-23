; Version 0.05
; Das Skript liefert Informationen zu Ausgewählten Objekten.
; Es ist bisher nur ein machbarkeits Test und es soll das Look and Feeling unterstützen.
; Bisher rudimentär implementiert:
; 1) Informationen zu Dateien, deren Pfad gegeben ist.
; 2) Infos zu existierenden Fenstern
; 3) und deren Controls
; für 1) ist der Pfad als Parameter zu übergeben oder ZackZackOrdner also SchnellOrdner.ahk vorher zu starten.
; für 2) ist das HWND des Fensters als Parameter zu übergeben oder ZackZackOrdner nicht zu starten.
; für 3) ist das ControlHWND als Parameter zu übergeben oder in 2) auf einen Spalteneintrag ganz links zu klicken
; ausgewählte Controls (die Pfade noch nicht) lassen sich auch manipulieren, durch editieren der Werte bzw. durch Rechtsklick auf die Reihe. Bei meinen Test ist nichts passiert, aber es ist durch aus denkbar, dass das Ändern von Controls zu Programmabstürzen führen kann. Schlimmeres ist nicht auszuschließen.
; In der Betriebsart 1) mit vorgestartetem ZZO werden die Edit8-Ausgaben von ZZO historisiert.
; Pro neuer Ausgabe nach 1 Sekunde idle-Time wird automatisch der Pfad übernommen.
; Mit der Tastenkombination #< können weitere Pfade übernommen werden.
; Hinweise: 
; ZZO lässt sich dazu nur das Edit8-Feld auslesen, alle Informationen besorgt momentan dieses Skript.
; Das ändert sich voraussichlich (in Arbeit) wenn die Sucheinstellungen, die zum Inhalt von Edit8 führen, mit Historisiert werden.
; Das Skript in Betriebsart 1) zeichnet auch im Hintergrund oder minimiert auf.
; probieren Sie auch mal die Anordnung Dieses Fenster hinter dem ZZO-Fenster dass oben mindestens der neu historisierte Pfad zu sehen ist.
; Auch nett ist Maximiert als unterstes Fenster.
; Ausblick: 
; Z.B.: "Öffnen mit" kann mit einer zukünftigen Version dieses Skriptes übersichtlicher und einfacher werden. 

; Bekannte Fehler: Viele. Unter anderem ragen bei meinem 4K-Bildschirm die Enden der Outlines über die Controls hinaus.

; inspiriert wurde ich u.a. von:
; https://www.autohotkey.com/boards/viewtopic.php?f=11&t=9798
; der Befehl
; ControlGet, AusgabeVar, List, ColN, SysListView321, Fenstertitel, Fenstertext
;                                  N. Spalte
; könnte manche Dinge erleichtern
#NoEnv
#SingleInstance off
PfadAngekommenZaehler:=1
Decimal_to_Hex(var)
{
  SetFormat, integer, hex
  var += 0
  SetFormat, integer, d
  return var
}
Ue1=%1% ; 
IfWinExist,ZackZack ahk_class AutoHotkeyGUI
	ZzoExist:=true
if(Ue1="" and ZzoExist)
	Ue1=Pfade
; Ue1=C:\temp\Gerd\Helga.txt ; %1%
; Ue1=C:\temp\Gerd ; %1%
; Ue1=C:\temp\StreamBar\logos\chilltrax.png
; Ue1=C:\temp\Gerd\Hola\Hall\Bla.txt
; Ue1=C:\temp\Gerd\Hola\Hall\letzt\Welt.txt
; Ue1=C:\temp\Gerd\Hola\Hall\letzt\AllerLetzt\Gerda.txt
If (Ue1="Top")
	Ue1:=DllCall("GetDesktopWindow")
Ue2=%2% ; 
IfExist %Ue1%
{
	PathModus:=true
}
else If(Ue1<>"" and Ue1<>"Pfade")
{
	ControlModus:=true
	WinModus:=false
	ThisWinHwnd:=Ue1
}

else
{
	If (Ue1="Pfade")
	{
		PathModus:=true
	}
	else
	{
		ControlModus:=false
		WinModus:=true
		; ThisWinHwnd:=WinExist("A")
	}
}
If(Ue2="")
	Ue2:="Red"
Else If(Ue2="Red")
	Ue2:=0xff8f00
Else If(Ue2=0xff8f00)
	Ue2:="Yellow"
Else If(Ue2="Yellow")
	Ue2:="Green"
Else If(Ue2="Green")
	Ue2:="Blue"
Ue3=%3%
ProcessHwndListe:=Ue3
; #SingleInstance off
outline := Outline()
Gui, +Resize
Gui, Margin, 20, 20
if PathModus
{
	Gui, Add, ListView, w800 r15 Grid -ReadOnly AltSubmit HwndHLV1 gSubLV vListe, #|HWND|Name|Ext|Size|Attrib.|Time modi.|Time crea.|Typ|Drive|O/N|O/N|O/N|O/N|O/N|O/N|O/N|O/N|O/N|O/N|O/N|O/N
	AnzSpalten:=22
}
else if WinModus
{
	Gui, Add, ListView, w800 r15 Grid -ReadOnly AltSubmit HwndHLV1 gSubLV vListe, #|WinHWND|Prozess-Name|ProcessId|ParentProcessId|Prio|X|Y|W|H|Klasse|Titel|CommandLine|Owner|ShortText
	AnzSpalten:=14
}
else if ControlModus
{
	Gui, Add, ListView, w800 r15 Grid -ReadOnly AltSubmit HwndHLV1 gSubLV vListe, #|ControlHWND|Prozess-Name|ProcessId/Name Attribut|ParentProcessId/Node-Parent|Prio/Win-Parents+Tag|X|Y|W|H|Klasse/Flaeche|Titel/Tag|CommandLine/Link|Owner|ShortText
	AnzSpalten:=14
}
if PathModus
{
	;	Gui, Show, , Pfad--Daten von %Index% 	%Ue1%	 %A_ComputerName%.     (Stand %A_Now%)

}
else
{
	ProgramManagerHwnd:=WinExist("Program Manager")
	if(ThisWinHwnd="")
	{
	ThisWinHwnd:=ProgramManagerHwnd
	}
	TopParentID:= Decimal_to_Hex(DllCall("GetDesktopWindow"))
	if (ProcessHwndListe="")
		ProcessHwndListe:= TopParentID  "`," "Top"  "`," ; ProgramManagerHwnd "	" 
	Loop,5
	{
		; ID := DllCall("GetParent", UInt,WinExist("A")), ID := !ID ? WinExist("A") : ID		; original
		ThisParentID := Decimal_to_Hex(DllCall("GetParent", UInt,WinExist("ahk_id " ThisWinHwnd))) ; , ThisID := !ThisID ? WinExist("ahk_id " ThisWinHwnd) : ThisID
		; Parent := Decimal_to_Hex( DllCall( "GetParent", "uint", wid ) )

		; OwnerHwnd := Decimal_to_Hex( DllCall( "GetWindow", "uint", ThisWinHwnd , "uint", "4" ) ) ; GW_OWNER = 4
		;  Owner :=  DllCall( "GetWindow", "uint", ThisWinHwnd , "uint", "4" )  ; GW_OWNER = 4
		; MsgBox % TopParentID "	" ProgramManagerHwnd  "	" ThisParentID "	(" ThisWinHwnd ")	"  "	" Owner "	" OwnerHwnd
		WinGetClass, ThisClass, ahk_id %ThisWinHwnd%
		WinClassBeiStart:=ThisClass
		ProcessHwndListe.= "§§" ThisWinHwnd "`," ThisClass "`," 
		
		if (ThisParentID=0)
		{
			break
		}
		else if (ThisParentID<>LastID)
		{
			break
		}
		
		LastID:=ThisWinHwnd
	}
	; MsgBox % ProcessHwndListe
	StringReplace,AnzeigeProcessHwndListe,ProcessHwndListe,%ThisWinHwnd%,>%ThisWinHwnd%
	StringReplace,AnzeigeProcessHwndListe,AnzeigeProcessHwndListe,%ThisClass%,%ThisClass%<
	StringReplace,AnzeigeProcessHwndListe,AnzeigeProcessHwndListe,`,,%A_Space%%A_Space%,All
	StringReplace,AnzeigeProcessHwndListe,AnzeigeProcessHwndListe,§,%A_Space%,All

	/*
	Loop,5
	{
	ThisParentID := DllCall("GetParent", UInt,WinExist("ahk_id " ThisWinHwnd)) ; , ThisID := !ThisID ? WinExist("ahk_id " ThisWinHwnd) : ThisID
	ParentsHwndList.=ThisParentID A_Space
	if (ThisParentID=ThisWinHwnd)
		break
	ThisWinHwnd:=ThisID
	}
	MsgBox % ThisWinHwnd "	" ParentsHwndList

	*/

	if (WinClassBeiStart="Internet Explorer_Server")
	{
		ContOrWin:=false
		ie:=true
	}
	else
	{
		ContOrWin:=true
		ie:=false
	}




	if ContOrWin
	{
			ContOrWinArray := ContOrWinListe(ThisWinHwnd)
		For Index, ContOrWin In ContOrWinArray
		{
			LoopWinId:=ContOrWin.WinID
			loop,10
			{
				ThisParentContID := Decimal_to_Hex(DllCall("GetParent", UInt,WinExist("ahk_id " LoopWinId)))   ; ThisWinHwnd
				if not ThisParentContID
					break
				else if (ThisWinHwnd=ThisParentContID)
				{
					Fuell:=A_Index-1
					break
				}
				else if(LoopWinId=ThisParentContID)
				{
					Fuell:=A_Index-1
					break
				}
					
				LoopWinId:=ThisParentContID
			}
			VorIndex:=""
			Loop,% Fuell
				VorIndex.="."
		   LV_Add("",VorIndex Index, ContOrWin.WinID,ContOrWin.Name,ContOrWin.ProcessId,ContOrWin.ParentProcessId,ContOrWin.priority, ContOrWin.X, ContOrWin.Y, ContOrWin.W, ContOrWin.H, ContOrWin.Class, ContOrWin.Title, ContOrWin.CommandLine, ContOrWin.Owner, ContOrWin.ShortText)
		   ProcessIdListe.=ContOrWin.ProcessId ","
		}
	}
	else if ie
	{
		ContOrWinArray := IeContListe(ThisWinHwnd)
		For Index, ContOrWin In ContOrWinArray
		LV_Add("",VorIndex Index, ContOrWin.WinID,ContOrWin.Name,ContOrWin.ProcessId,ContOrWin.ParentProcessId,ContOrWin.priority, ContOrWin.X, ContOrWin.Y, ContOrWin.W, ContOrWin.H, ContOrWin.Class, ContOrWin.Title, ContOrWin.CommandLine, ContOrWin.Owner, ContOrWin.ShortText)
	}
}
if PathModus
	Gui, Show, , Pfad--Daten von %Index% 	%Ue1%	 %A_ComputerName%.     (Stand %A_Now%)
else if WinModus
	Gui, Show, , Fenster-Daten von %Index% existierenden Fenstern auf %A_ComputerName%.     (Stand %A_Now%)
else if ControlModus
	Gui, Show, , Control-Daten von %Index% existierenden Controls des FensterHWNDs %ThisWinHwnd%  auf %A_ComputerName%.     (Stand %A_Now%)

	DieserPfad:=Ue1
	goto Ue1Verwenden
#<::
NeuerPfadAngekommen:
ControlGetText,DieserRohPfad,Edit8,ZackZack
DieserPfad:=FuehrendeSterneEntfernen(DieserRohPfad)
++PfadAngekommenZaehler

Ue1Verwenden:
if(InStr(DieserRohPfad,A_Tab,A_Tab))
{
	if DieserRohPfad contains http:,https:,ftp:
	{
		DieserTyp:="WinURL"
		WinUrlModus:=true
	}
	else
	{
		DieserTyp:="WinOrdner"
		WinUrlModus:=false
	}
}
else
	WinUrlModus:=false
if WinUrlModus
{
	
	; if(InStr(ZzoEdit8,A_Tab . A_Tab))		; vorhandenes Explorerfenster erkennen
{
	ZzoEdit8:=DieserRohPfad
	EckKlammerAufPos:=InStr(ZzoEdit8,"[",,0)
	EckKlammerZuPos:=InStr(ZzoEdit8,"]",,0)
	ThisAnzZeichen:=EckKlammerZuPos-EckKlammerAufPos-1
	ThisCacheName:=SubStr(ZzoEdit8,EckKlammerAufPos+1,ThisAnzZeichen)
	; ThisWinHwnd:=SubStr(ZzoEdit8,EckKlammerZuPos+2)
	DieserPfadHwnd:=Decimal_to_Hex(SubStr(ZzoEdit8,EckKlammerZuPos+2))
	; MsgBox % DieserPfadHwnd "	" SubStr(ZzoEdit8,EckKlammerZuPos+2) "	" EckKlammerZuPos

	; StringReplace,ThisCacheName,ThisCacheName,|,!,all
	; ThisNewFavorit:=ThisCacheName "|*" FuehrendeSterneEntfernen(ZzoEdit8)
}
; if (ThisNewFavorit="")
; 	ThisNewFavorit=Name|*Pfad
					LV_Insert(1,"",PfadAngekommenZaehler,DieserPfadHwnd,ThisCacheName,"","","","","",DieserTyp,FuehrendeSterneEntfernen(ZzoEdit8), "","","","","","","","","","","","")
					GetSuchRelevanteVarsVonZzo()

}
else if PathModus
{

	FileGetAttrib,DieserPfadAttrib,%DieserPfad%
	if(InStr(DieserPfadAttrib,"D"))
	{
		DieserPfadOrdner:=true
		DieserPfadDatei:=false
		DieserTyp:="Ordner"
	}
	else
	{
		DieserPfadOrdner:=false
		DieserPfadDatei:=true
		DieserTyp:="Datei"
		File := FileOpen(DieserPfad, "r")
		if !IsObject(File)
		{
			; MsgBox Kann "%DieserPfad%" nicht zum Lesen öffnen.
			; return
		}
		DieserPfadHwnd:=File.__Handle
	}
	; MsgBox jetzt %DieserRohPfad%
	if(InStr(DieserRohPfad,A_Tab . A_Tab))		; vorhandenes Explorerfenster erkennen
	{
		ZzoEdit8:=DieserRohPfad
		; EckKlammerAufPos:=InStr(ZzoEdit8,"[",,0)
		EckKlammerZuPos:=InStr(ZzoEdit8,"]",,0)
		; ThisAnzZeichen:=EckKlammerZuPos-EckKlammerAufPos-1
		; ThisCacheName:=SubStr(ZzoEdit8,EckKlammerAufPos+1,ThisAnzZeichen)
		FormatInteger:=A_FormatInteger
		; SetFormat,IntegerFast,H
		DieserPfadHwnd:=Decimal_to_Hex(SubStr(ZzoEdit8,EckKlammerZuPos+2))
		; MsgBox % DieserPfadHwnd
		; SetFormat,IntegerFast,D
		; StringReplace,ThisCacheName,ThisCacheName,|,!,all
		; ThisNewFavorit:=ThisCacheName "|*" FuehrendeSterneEntfernen(ZzoEdit8)
	}

	FileGetSize,DieserPfadSize,%DieserPfad%
	FileGetTime,DieserPfadTimeModify,%DieserPfad%,m
	FileGetTime,DieserPfadTimeCreated,%DieserPfad%,c
	FileGetVersion,DieserPfadVersion,%DieserPfad%
	Loop 100
		DieserNameNoExt%A_Index%:=
	DownIndex:=100
	Loop 12
	{
		--DownIndex
		if (A_Index=1)
			SplitPath,DieserPfad,DieserFileName,DieserDir,DieserExt%DownIndex%,DieserNameNoExt%DownIndex%,DieserDrive
		else if(DieserDir<>"")
			SplitPath,DieserDir,DummyFileName,DieserDir,DieserExt%DownIndex%,DieserNameNoExt%DownIndex%,DummyDrive
		else
		{
			DieserPfadAnzEltern:=A_Index+1
			break
		}
		if(DieserNameNoExt%DownIndex%="")
		{
			DieserPfadAnzEltern:=A_Index+1
			break
		}
	}
	; if DieserPfadOrdner
	;	DieserPfadAnzEltern:=DieserPfadAnzEltern+DieserPfadOrdner
	Loop % DieserPfadAnzEltern ; -2*DieserPfadDatei
	{
		DownIndex:=100+A_Index-DieserPfadAnzEltern+1 ; +2*DieserPfadOrdner ; -DieserPfadDatei-DieserPfadOrdner
		DieserNameNoExt%A_Index%:=DieserNameNoExt%DownIndex%
	}
	DieserPfadAnzElternWeg2:=DieserPfadAnzEltern-2
	if(DieserTyp="Datei")
		DieserNameNoExt%DieserPfadAnzElternWeg2%:=DieserFileName
	if(PfadAngekommenZaehler=1)
				LV_Add("",PfadAngekommenZaehler,Decimal_to_Hex(DieserPfadHwnd),DieserFileName,DieserExt1,DieserPfadSize,DieserPfadAttrib,DieserPfadTimeModify,DieserPfadTimeCreated,DieserTyp,DieserDrive, DieserNameNoExt1,DieserNameNoExt2,DieserNameNoExt3,DieserNameNoExt4,DieserNameNoExt5,DieserNameNoExt6,DieserNameNoExt7,DieserNameNoExt8,DieserNameNoExt9,DieserNameNoExt10,DieserNameNoExt11,DieserNameNoExt12)
	else
	{
				LV_Insert(1,"",PfadAngekommenZaehler,Decimal_to_Hex(DieserPfadHwnd),DieserFileName,DieserExt1,DieserPfadSize,DieserPfadAttrib,DieserPfadTimeModify,DieserPfadTimeCreated,DieserTyp,DieserDrive, DieserNameNoExt1,DieserNameNoExt2,DieserNameNoExt3,DieserNameNoExt4,DieserNameNoExt5,DieserNameNoExt6,DieserNameNoExt7,DieserNameNoExt8,DieserNameNoExt9,DieserNameNoExt10,DieserNameNoExt11,DieserNameNoExt12)
				GetSuchRelevanteVarsVonZzo()
	}
}
else if WinModus
{
	if(Clipboard="SkriptProzessReload")
		ProzesseOhneFenster:=true
	else if(Clipboard="SkriptReload")
		ProzesseOhneFenster:=false
	else
	{
		ProzesseOhneFenster:=false
	MsgBox, 260, Prozesse, ohne Fenster auch anzeigen?,10
	IfMsgBox,Yes
		ProzesseOhneFenster:=true
	}
	if ProzesseOhneFenster
	{
		StringTrimRight,ProcessIdListe,ProcessIdListe,1
		for Prozess in ComObjGet("winmgmts:").ExecQuery("Select * from Win32_Process")
		{
			++Index
			temp:=Prozess.ProcessId
			; MsgBox % temp " " ProcessIdListe
			if temp not in %ProcessIdListe%
			; if   ProcessIdListe not in %temp%
				LV_Add("",Index, "",Prozess.Name,Prozess.ProcessId,Prozess.ParentProcessId,Prozess.priority, "", "","", "", "", "", Prozess.CommandLine,"")
		   ;  LV_Add("", Prozess.Name, Prozess.CommandLine)
		   ; MsgBox % Prozess.CommandLine   
		}
	}
}





LV_ModifyCol()
; LV_ModifyCol(1, "Integer")
LV_ModifyCol(4, "Integer")
LV_ModifyCol(5, "Integer")
LV_ModifyCol(6, "Integer")
if ProzesseOhneFenster
{
	LV_ModifyCol(4, "Sort")
	ZusatzText:=" und "
	Gui, Show, , Fenster und Prozesse auf %A_ComputerName%.     (Stand %A_Now%)

}
else
{
 if WinModus
	Gui, Show, , HWND    %AnzeigeProcessHwndListe%   Win-Daten[%Index%]  auf %A_ComputerName%.     (Stand %A_Now%)
else if ControlModus
	Gui, Show, , HWND    %AnzeigeProcessHwndListe%   Control-Daten[%Index%]  auf %A_ComputerName%.     (Stand %A_Now%)
}

Menu, OhneBezugMenue, Add, Reload, SkriptReloadDito


Menu, MeinMenü, Add, Fenster schließen, FensterSchliessen
Menu, MeinMenü, Add, Prozess schließen, ProzessSchliessen
Menu, MeinMenü, Add, Fenster aktivieren, FensterAktivieren
Menu, MeinMenü, Add, Fenster minimieren, FensterMinimieren
Menu, MeinMenü, Add, Fenster maximieren, FensterMaximieren
Menu, MeinMenü, Add, Fenster neu zeichnen, FensterRedraw
; Menu, MeinMenü, Add, Fenster transparent, FensterTransparent
Menu, MeinMenü, Add, Fenster Text ..., FensterText
Menu, MeinMenü, Add  ; Fügt eine Trennlinie ein.
; Erstellt ein weiteres Menü, das als Untermenü für das obige Menü dienen soll.
Menu, Submenu1, Add, Fenster transparent, FensterTransparent
Menu, Submenu1, Add, Fenster nicht transparent, FensterNichtTransparent
Menu, Submenu1, Add, Fenster on Top, FensterOnTop
Menu, Submenu1, Add, Fenster not on Top, FensterNotOnTop
Menu, Submenu1, Add, Fenster Bottom, FensterBottom
Menu, Submenu1, Add, Fenster Top, FensterTop
; Erstellt ein Untermenü im ersten Menü (mit einem nach rechts gerichteten Pfeil). Sobald der Benutzer dieses Untermenü auswählt, wird das zweite Menü angezeigt.
Menu, MeinMenü, Add, Fenster sonstiges, :Submenu1
Menu, Submenu2, Add, Text, GetControlText
Menu, Submenu2, Add, QuellText, GetControlQuellText
Menu, MeinMenü, Add, Get, :Submenu2
Menu, Submenu3, Add, Clip 2 Text, SetClip2ControlText
Menu, Submenu3, Add, Control Click, ControlClick
Menu, MeinMenü, Add, Set, :Submenu3
Menu, MeinMenü, Add  ; Fügt eine Trennlinie unterhalb des Untermenüs ein.
Menu, MeinMenü, Add, Zeilen Text 2 Clip.,Zeile2Clip
Menu, MeinMenü, Add  ; Fügt eine Trennlinie unterhalb des Untermenüs ein.
Menu, MeinMenü, Add, Reload Skript nur Fenster, SkriptReload  ; Fügt einen weiteren Menüpunkt unterhalb des Untermenüs ein.
Menu, MeinMenü, Add, Reload Skript +Prozesse, SkriptProzessReload  ; Fügt einen weiteren Menüpunkt unterhalb des Untermenüs ein.
Loop
{
	; MsgBox im loop
	if(A_TimeIdlePhysical>1000 and A_TimeIdlePhysical<1500 )
	{
	; 	MsgBox im timeidle
		ControlGetText,DieserRohPfad,Edit8,ZackZack
		DieserPfad:=FuehrendeSterneEntfernen(DieserRohPfad)
		if(LetzterPfad<>DieserPfad and DieserPfad<>"0")
		{
			LetzterPfad:=DieserPfad
			gosub NeuerPfadAngekommen
			sleep 300
		}
		else
			sleep 500
		LetzterPfad:=DieserPfad
	}
	sleep 500
}
return ; Ende des automatischen Ausführungsbereichs.
SubLV:  ; https://autohotkey.com/board/topic/80265-solved-which-column-is-clicked-in-listview/
	Row := A_EventInfo
	; TrayTip, A_GuiEvent,% A_GuiEvent "	" A_EventInfo,
	; ToolTip,% "A_GuiEvent " A_GuiEvent "	" A_EventInfo,,TTx*20,TTx
	++TTx
	if (TTx>10)
		TTx=1
	; if (A_GuiEvent="I")

	If (A_GuiEvent = "Normal" or A_GuiEvent = "K")
	{
		
		ControlGet,Row,List,Focused,,ahk_id %HLV1%
		ErgRow:=""
		Loop % StrLen(Row)
		{
			Zeichen:=SubStr(Row,A_Index,1)
			if (Zeichen=".")
				continue
			if Zeichen is Integer
				ErgRow.=Zeichen
			else
				break
		}
		Row:=ErgRow
		; StringSplit,Ro,Row,A_Tab
		; StringReplace,Row,Ro1,.,,All
		; ToolTip,%Row%
		if (Row=0)
			return
		LV_GetText(x, Row, 7)
		LV_GetText(y, Row, 8)
		; MsgBox x= %x%		y= %y%
		LV_GetText(w, Row, 9)
		LV_GetText(h, Row, 10)
		StringReplace,xoutline,x,(
		StringReplace,xoutline,xoutline,)
		StringReplace,youtline,y,(
		StringReplace,youtline,youtline,)
		Xsolo2:=0
		StringSplit,Xsolo,xoutline,+
		xoutline:=Xsolo1+Xsolo2
		Ysolo2:=0
		StringSplit,Ysolo,Youtline,+
		Youtline:=Ysolo1+Ysolo2
		; xoutline:=Eval(x)
		; youtline:=Eval(y)
		x2:=xoutline+W, y2:=youtline+H
		;  MsgBox % xoutline "	" youtline "	" x "	" y
		 outline.show( xoutline,youtline, x2, y2,"TRBL")
		 if ControlModus
			Outline_Color("",Ue2) ; Blue,Yellow,Purple,Red,
		outline.setAbove(DieseRowWinHwnd)
		; outline.setAbove("green")
		; outline.setAbove.self.color := "green"
		; outline.setAbove.self.color("green")
		; outline.setAbove.color("green")
		;  Outline_Color("green")
		; outline("green")
		; return
	}
	if (A_GuiEvent="F")
		; Tastaturfokus
	return
	If(A_GuiEvent="ColClick") 		; and A_EventInfo=1)
		; Sortierung nach Spalte 	;                 1 angeklickt
	return

	; if (StrLen(A_GuiEvent)=1)
	; return
	ControlGet,Row,List,Focused,,ahk_id %HLV1%

    LV_GetText(DieseRowWinHwnd, Row , 2)
    WinGetPos,GuiX,GuiY,GuiW,GuiH,ahk_id %DieseRowWinHwnd%
    x:=GuiX, y:=GuiY, x2:=x+GuiW, y2:=y+GuiH
    ; outline.show(1, x, y, x2, y2,"TRBL")
     if Fehlersuche
        MsgBox %  x " , " y " , "  x2 " , "  y2 "   " GuiX  "   " GuiY  "   " GuiW  "   " GuiH  "   " DieseRowWinHwnd
   ;  
   ; if(A_GuiEvent ="DoubleClick")
   if(A_EventInfo =0)
		; ScrollLeistenClick
		return
	if(A_GuiEvent ="Normal")
   {
      
      ; RowMerker := A_EventInfo
      Column := LV_SubItemHitTest(HLV1)
        LV_GetText(BisherigerWert, Row , Column)
        LV_GetText(ThisRowWinHwnd, Row , 2)
        AktWinHwnd:=WinExist("A")
        ControlGetFocus,FocusedControl, ahk_id %AktWinHwnd%
        if (FocusedControl<>"SysListView321")
            return
        ZeilenText:=""
		if Column not in 1,2,3,4,5,15
		{
			InputBox,NeuerWert,Neuen Wert, fuer %DieseRowWinHwnd% eintragen,,,,,,,,%BisherigerWert%
			if ErrorLevel
				return
		}
        if (Column=1)
        {
            gosub Zeile2Clip
			; If WinModus ; weglassen um unter-Controls vereinzeln zu koennen
			StringTrimRight,ScriptFullPath,A_ScriptFullPath,3
			ScriptFullPathExe:=ScriptFullPath "exe"
			ScriptFullPathAhk:=ScriptFullPath "ahk"
			IfExist %ScriptFullPathExe%
				Run, %ScriptFullPathExe% %ScriptFullPathAhk% %ThisRowWinHwnd% %Ue2% %ProcessHwndListe%
			else
			{
				Run, %A_ScriptFullPath% %ThisRowWinHwnd% %Ue2% %ProcessHwndListe%
				; StringTrimRight,ScriptFullPath,A_ScriptFullPath,3
			}
			; If ControlModus
				; Run, %A_ScriptFullPath% %ThisRowWinHwnd% "Yellow"
            return
        }
        
        else if (Column=2)
        {
			return
            LV_GetText(x, Row, 7)
            LV_GetText(y, Row, 8)
            LV_GetText(w, Row, 9)
            LV_GetText(h, Row, 10)
			StringReplace,xoutline,x,(
			StringReplace,xoutline,xoutline,)
			StringReplace,youtline,y,(
			StringReplace,youtline,youtline,)
			Xsolo2:=0
			StringSplit,Xsolo,xoutline,+
			xoutline:=Xsolo1+Xsolo2
			Ysolo2:=0
			StringSplit,Ysolo,Youtline,+
			Youtline:=Ysolo1+Ysolo2
			; xoutline:=Eval(x)
			; youtline:=Eval(y)
            x2:=xoutline+W, y2:=youtline+H
            ; MsgBox % xoutline "	" youtline
             outline.show( xoutline,youtline, x2, y2,"TRBL")
			 if ControlModus
				Outline_Color("",Ue2) ; Blue,Yellow,Purple,Red,
            outline.setAbove(DieseRowWinHwnd)
            ; outline.setAbove("green")
			; outline.setAbove.self.color := "green"
			; outline.setAbove.self.color("green")
			; outline.setAbove.color("green")
			;  Outline_Color("green")
			; outline("green")
            return
        }
		else if (Column=3)
        {
			IfWinExist,ZackZack ahk_class AutoHotkeyGUI
			{
				ControlSetText,Edit4,SelfActivate.,ZackZack
				sleep 200
				StringSplit,Spalte,Row,%A_Tab%
				SetSuchRelevanteVarsVonZzo(Spalte1)
			}
		}
        else if (Column=6)
        {
            LV_GetText(ThisPID, Row , 4)
            If(NeuerWert=4)
                NeuerWert:="L"
            else If(NeuerWert=6)
                NeuerWert:="B"
            else If(NeuerWert=8)
                NeuerWert:="N"
            else If(NeuerWert=10)
                NeuerWert:="A"
            else If(NeuerWert=13)
                NeuerWert:="H"
            else If(NeuerWert=24)
            {
                NeuerWert:="R"
                Process, Priority, %ThisPID%, %NeuerWert%
                sleep 200
                
                MsgBox Die neue Prio ist eventuell auf 13 / A beschraenkt.
            }
            Process, Priority, %ThisPID%, %NeuerWert%
            	

            sleep 3000
            If (ErrorLevel<>ThisPID)
            MsgBox %  " Die Prioritaet von " ThisPID  " konnte nicht geandert werden. Errorlevel=" ErrorLevel 
        }
        else if (Column=7)
		{
			if WinModus
				Winmove,ahk_id %ThisRowWinHwnd%,,NeuerWert
			if ControlModus
				ControlMove,,NeuerWert,,,,ahk_id %ThisRowWinHwnd%		; der Befehl drueber hatte auch fast das richtige gemacht, er hatte aber auch bei x-Aenderung y veraendert.
		}
        else if (Column=8)
		{
			if WinModus
				Winmove,ahk_id %ThisRowWinHwnd%,,,NeuerWert
			if ControlModus
				ControlMove,,,NeuerWert,,,ahk_id %ThisRowWinHwnd%
		}
        else if (Column=9)
		{
			if WinModus
				Winmove,ahk_id %ThisRowWinHwnd%,,,,NeuerWert
			if ControlModus
				ControlMove,,,,NeuerWert,,ahk_id %ThisRowWinHwnd%
		}
        else if (Column=10)
		{
			if WinModus
				Winmove,ahk_id %ThisRowWinHwnd%,,,,,NeuerWert
			if ControlModus
				ControlMove,,,,,NeuerWert,ahk_id %ThisRowWinHwnd%
		}
        else if (Column=12)
		{
			if WinModus
				WinSetTitle,ahk_id %ThisRowWinHwnd%,,%NeuerWert%
			if ControlModus
				ControlSetText,,%NeuerWert%,ahk_id %ThisRowWinHwnd%
		}
        else if (Column=13)
        {
            LV_GetText(AktComandLine, Row , Column)
            Clipboard:=AktComandLine
            TrayTip,Zwischenablage,ComandLine ---> Clipboard
            return
        }
        else if (Column=15)
        {
			{
            LV_GetText(ThisRowWinHwnd, Row , 2)
			WinGetText,ThisText,ahk_id %ThisRowWinHwnd%
			InputBox,ThisText,Neuen Wert, fuer %ThisRowWinHwnd% eintragen,,,,,,,,%ThisText%
			if ErrorLevel
				return
			if ControlModus
				ControlSetText,,%ThisText%,ahk_id %ThisRowWinHwnd%
			if IeModus
				GetWebBrowser().document.all[ThisRowWinHwnd].innerText:=ThisText				
			; ThisText:=GetShortTextFromHwnd(ThisRowWinHwnd)
            ; Clipboard:=ThisText
            ; TrayTip,Zwischenablage,ThisText ---> Clipboard
            return
			}
        }
        else
        {
            MsgBox Das Aendern dieses Feldes-Eintrages [Spalte=%Column%] wird noch nicht unterstuetzt!
            return
        }
       ; MsgBox, You clicked on column %Column% in row %Row%!
      ; SetTimer, KillToolTip, -1500
   }
Return
SkriptProzessReload:
Clipboard:="SkriptProzessReload"
Reload
return
SkriptReload:
Clipboard:="SkriptReload"
Reload
return
SkriptReloadDito:
if ProzesseOhneFenster
    Clipboard:="SkriptProzessReload"
else
    Clipboard:="SkriptReload"
Run, %A_ScriptFullPath% %ThisWinHwnd% %Ue2% ; %ProcessHwndListe%
ExitApp
Reload
return
FensterSchliessen:
LV_GetText(ThisWinHwnd, RechtsKlickAufZeile , 2)
WinClose,ahk_id %ThisWinHwnd%
return
ProzessSchliessen:
LV_GetText(ThisWinHwnd, RechtsKlickAufZeile , 4)
Process,Close,%ThisWinHwnd%
; WinClose,ahk_id %ThisWinHwnd%
return
FensterAktivieren:
LV_GetText(ThisWinHwnd, RechtsKlickAufZeile , 2)
WinActivate,ahk_id %ThisWinHwnd%
return
FensterMinimieren:
LV_GetText(ThisWinHwnd, RechtsKlickAufZeile , 2)
WinMinimize,ahk_id %ThisWinHwnd%
return
FensterMaximieren:
LV_GetText(ThisWinHwnd, RechtsKlickAufZeile , 2)
WinMaximize,ahk_id %ThisWinHwnd%
return
FensterRedraw:
LV_GetText(ThisWinHwnd, RechtsKlickAufZeile , 2)
WinSet,ReDraw,,ahk_id %ThisWinHwnd%
return
FensterTransparent:
LV_GetText(ThisWinHwnd, RechtsKlickAufZeile , 2)
WinSet, Transparent, 150,ahk_id %ThisWinHwnd%
return
FensterNichtTransparent:
LV_GetText(ThisWinHwnd, RechtsKlickAufZeile , 2)
WinSet, Transparent, 255,ahk_id %ThisWinHwnd%
return
FensterOnTop:
LV_GetText(ThisWinHwnd, RechtsKlickAufZeile , 2)
WinSet, AlwaysOnTop, On,ahk_id %ThisWinHwnd%
return
FensterNotOnTop:
LV_GetText(ThisWinHwnd, RechtsKlickAufZeile , 2)
WinSet, AlwaysOnTop, Off,ahk_id %ThisWinHwnd%
return
FensterBottom:
LV_GetText(ThisWinHwnd, RechtsKlickAufZeile , 2)
WinSet, Bottom,,ahk_id %ThisWinHwnd%
return
FensterTop:
LV_GetText(ThisWinHwnd, RechtsKlickAufZeile , 2)
WinSet, Top,,ahk_id %ThisWinHwnd%
return
GetControlText:
LV_GetText(ThisWinHwnd, RechtsKlickAufZeile , 2)
WinGetText,ThisText,ahk_id %ThisWinHwnd%
If IeModus
	ThisText:=GetWebBrowser().document.all[ThisWinHwnd].innerText
MsgBox % ThisText
return
GetControlQuellText:
LV_GetText(ThisWinHwnd, RechtsKlickAufZeile , 2)
WinGetText,ThisText,ahk_id %ThisWinHwnd%
If IeModus
	ThisQuellText:=GetWebBrowser().document.all[ThisWinHwnd].outerHTML
MsgBox % ThisQuellText
return
SetClip2ControlText:
LV_GetText(ThisWinHwnd, RechtsKlickAufZeile , 2)
ControlSetText,ahk_id %ThisWinHwnd%,Clipboard
If IeModus
	GetWebBrowser().document.all[ThisWinHwnd].innerText:=Clipboard
MsgBox % ThisText
return
ControlClick:
LV_GetText(ThisWinHwnd, RechtsKlickAufZeile , 2)
if IeModus
	GetWebBrowser().document.all[ThisWinHwnd].Click()				
if ControlModus
	ControlClick,,ahk_id %ThisWinHwnd%
if WinModus
	ControlClick,,ahk_id %ThisWinHwnd%
return

GetShortTextFromHwnd(Hwnd="",MaxLen=50,MaxColumn=1)
{
	global ThisWinHwnd
	if (Hwnd="")
		Hwnd:=ThisWinHwnd
	WinGetText,ThisText,ahk_id %Hwnd%
	Strlen:=StrLen(ThisText)
	if (Strlen>MaxLen)
	{
		Anfang:=SubStr(ThisText,1,MaxLen/2)
		Ende:=SubStr(ThisText,-MaxLen/2)
		if(MaxColumn=1)
			ThisText:=Anfang "...[" Strlen "]..." Ende
	}
	StringReplace,ThisText,ThisText,`r`n,¶,all
	return ThisText
}

KuerzeText(ThisText,MaxLen=50,MaxColumn=1)
{
	Strlen:=StrLen(ThisText)
	if (Strlen>MaxLen)
	{
		Anfang:=SubStr(ThisText,1,MaxLen/2)
		Ende:=SubStr(ThisText,-MaxLen/2)
		if(MaxColumn=1)
			ThisText:=Anfang "...[" Strlen "]..." Ende
	}
	StringReplace,ThisText,ThisText,`r`n,¶,all
	return ThisText
}



FensterText:
LV_GetText(ThisWinHwnd, RechtsKlickAufZeile , 2)

WinGetText,ThisWinText,ahk_id %ThisWinHwnd%
If IeModus
	ThisWinText:=GetWebBrowser().document.all[ThisWinHwnd].innerText
; MsgBox % ThisWinHwnd "`n"  GetWebBrowser().document.all[ThisWinHwnd].innerText
MsgBox, 262404, Text von %ThisWinHwnd% ins Clipboard, %ThisWinText%
IfMsgBox,Yes
  Clipboard:=ThisWinText
return
Zeile2Clip:
	Column := LV_SubItemHitTest(HLV1)
	; MsgBox % Row " | " RowMerker  " || " A_GuiEvent  " || " A_EventInfo " # " Column
if (StrLen(Row>20))	
{
	if(Column<>0)	; Bedienung Maus uebers Feld und dort lassen.  Menu | Zeilen Text 2 Clip.  via Tastatur auswaehlen.
	{
		StringSplit,Spalte,Row,%A_Tab%
		; SetSuchRelevanteVarsVonZzo(Spalte1) ; umgezogen nach Linksklick auf Spalte 3
		Clipboard:=Spalte%Column%				; Einzelfeld ins Clipboard
	}
	else
		Clipboard:=Row		; wiso?
	return
}
else
{
    loop % AnzSpalten
    {
        LV_GetText(ZellenText, Row , A_Index)
        ZeilenText .= ZellenText . "`r`n"
    }
    StringTrimRight,ZeilenText,ZeilenText,1
    Clipboard:=ZeilenText
    TrayTip,Zwischenablage,ZeilenText[%Row%] ---> Clipboard
	return
}
MenuHandler:
MsgBox Sie haben %A_ThisMenuItem% im Menü %A_ThisMenu% ausgewählt.
return

; #z::Menu, MeinMenü, Show  ; Drücke WIN+Z, um das Menü anzuzeigen.
Return
GuiContextMenu:
RechtsKlickAufZeile:=A_EventInfo
if (RechtsKlickAufZeile>0)
  Menu, MeinMenü, Show 
else
  Menu, OhneBezugMenue, Show 
  
return
; GuiContextMenu(GuiHwnd, CtrlHwnd, EventInfo, IstRechtsklick, X, Y)
{
  Menu, MeinMenü, Show  ; Drücke WIN+Z, um das Menü anzuzeigen.
  ; MsgBox GuiHwnd %GuiHwnd%   CtrlHwnd %CtrlHwnd%    EventInfo %EventInfo%   IstRechtsklick %IstRechtsklick%  X %X%   y %y%
  ; MsgBox % 1.A_GuiControl " " A_EventInfo " "  " "  " "  " "  " " 
return
}

GuiSize:
  ;       ControlName         ,  xwyh , [ x     w     y     h     or True for MoveDraw]
  Anchor("Liste"              , " w h", "    , 1  ,     ,  1   ")
return

GuiClose:
WD:=""
ExitApp



GetAllRootHwnd()
{
RootHwnd:=WinExist("ahk_id" DllCall("GetDesktopWindow")) ; Gibt das oberste HWND zurueck
WinGet, ThisControlListHwnd , ControlListHwnd , ahk_id %RootHwnd%
return ThisControlListHwnd
}

OKabsParent(el) 
{
     return (el.offsetParent)?absParent(el.offsetParent)  . " " . el.TagName : el.TagName
}
absParent(el) 
{
     return (el.offsetParent)?absParent(el.offsetParent)  . " " . el.TagName : el.TagName
}
absLeft(el) 
{
     return (el.offsetParent)? el.offsetLeft+absLeft(el.offsetParent) : el.offsetLeft
}
absTop(el) 
{
     return (el.offsetParent)? el.offsetTop+absTop(el.offsetParent) : el.offsetTop
}




ContOrWinListe(ThisWinHwnd) 
{
	global ControlModus, WinModus,InternetExplorerServer
	ReturnArray := [] ; Rückgabearry deklarieren
	
	; WinGet, ControlHwndCrListe, ControlListHwnd ,% "ahk_id" WinExist("A") ; siehe Hilfe
	if ControlModus
	{
		WinGet, ControlHwndCrListe, ControlListHwnd ,% "ahk_id" ThisWinHwnd ; siehe Hilfe
		WinGetPos, Xabs, Yabs, Ww, Hw, % "ahk_id" ThisWinHwnd
		loop,Parse,ControlHwndCrListe,`n,`r
		{
			ID:=A_Index
			ID%A_Index%:=A_LoopField
		}
	}
	else if WinModus
		WinGet, ID, List, , , Program Manager ; siehe Hilfe
	; MsgBox % ID
	Loop, %ID% 
	{
		ControlIndex:=A_Index
		WinID := ID%A_Index%
		WinGetClass, Class, ahk_id %WinID%
		if(Class="Internet Explorer_Server")
			InternetExplorerServer:=true
		else
			InternetExplorerServer:=false
		; MsgBox class %Class%
		if WinModus
			WinGetPos, X, Y, W, H, ahk_id %WinID%
		if ControlModus
		{
			ControlGetPos,Xrel,Yrel,Wc,Hc,, ahk_id %WinID%
			X:="(" Xabs ")+" Xrel
			Y:="(" Yabs ")+" Yrel
			W:=Wc
			H:=Hc
		}
		WinGetTitle, Title, ahk_id %WinID%
		WinGet pid, PID, ahk_id %WinID%
		ShortText:=GetShortTextFromHwnd(WinID)
		; <Get CommandLine>
		; Ermittelt das WMI-Service-Objekt. 
		wmi := ComObjGet("winmgmts:")       ; Quelle: Beispiel aus der Deutschen AHK-Hilfe zu ComObjGet()
		; Führt eine Abfrage zur Ermittlung von passenden Prozessen aus.
		queryEnum := wmi.ExecQuery(""
		  . "Select * from Win32_Process where ProcessId=" . pid)
		  ._NewEnum()
		; Ermittelt den ersten passenden Prozess.
		if queryEnum[process]
		{
			CommandLine:=process.CommandLine                    ; eingefuegt
			ProzessName:=process.Name                    ; eingefuegt von Beispiel 5 der Deutschen Hilfe zu Process
			; Information:=process.Information                    ; Unbekannt
			priority:=process.priority                    ; Funzt
		;        KernelModeTime:=process.KernelModeTime                    ; Funzt
			; sngProcessTime:=process.sngProcessTime                    ; Funzt ned
			WorkingSetSize:=process.WorkingSetSize                    ; Funzt
		;        PageFileUsage:=process.PageFileUsage                    ; Funzt
			ThreadCount :=process.ThreadCount                     ; Funzt
		;        PageFaults:=process.PageFaults                    ; Funzt
			Caption:=process.Caption                    ; Funzt wie Name?
		;        CreationClassName:=process.CreationClassName                    ; Funzt 
		;        Description:=process.Description                    ; Funzt wie Name?
			ParentProcessId:=process.ParentProcessId                    ; Funzt
			; Status:=process.Status                    ;  gibt leer aus aber ohne Fehlermeldung
			ExecutablePath:=process.ExecutablePath                    ; Funzt vermute wie WinGet,,ProcessPath 
			; CSName:=process.CSName                    ; Funzt gibt aber nur den Computername aus
		;        InstallDate:=process.InstallDate                   ;  gibt leer aus aber ohne Fehlermeldung
			ProcessId:=process.ProcessId                   ;  gibt leer aus aber ohne Fehlermeldung
/*
			; Owner:=process.GetOwner("out" User,"out" Domain)                  ;  gibt 0 aus aber ohne Fehlermeldung
			; Owner:=process.GetOwner.NameOfUser                 ;  gibt leer aus aber ohne Fehlermeldung
			; Owner:=process.GetOwner(NameOfUser)                  ;  gibt 0 aus aber ohne Fehlermeldung
			; outNameOfUser:="NameOfUser"
			; Owner:=process.GetOwner(outNameOfUser)                  ;  gibt 0 aus aber ohne Fehlermeldung
			; Owner:=process.GetOwner(&NameOfUser)                  ;  gibt 0 aus aber ohne Fehlermeldung
			; Owner:=process.GetOwner($NameOfUser)                  ;  gibt 0 aus aber ohne Fehlermeldung
			; Owner:=process.GetOwner(ByRef NameOfUser)                  ;  gibt 0 aus aber ohne Fehlermeldung
			; Owner:=process.GetOwner[NameOfUser]                  ;  gibt 0 aus aber ohne Fehlermeldung
*/
			user := ComVar()

			domain := ComVar()

			process.GetOwner(user.ref, domain.ref)
/*        
			; Owner:=process.GetOwner(User,Domain)                  ;  gibt 0 aus aber ohne Fehlermeldung
			; Owner:=process.GetOwner()                  ;  gibt 0 aus aber ohne Fehlermeldung
			; Owner:=process.GetOwner[]                 ;  gibt leer aus aber ohne Fehlermeldung
			; Owner:=process.GetOwner                  ;  gibt 0 aus aber ohne Fehlermeldung
			; Owner:=process.GetOwner.User.blablub                  ;  gibt leer aus aber ohne Fehlermeldung
			; Owner:=process.GetOwner.User                  ;  gibt leer aus aber ohne Fehlermeldung
			; Owner:=process.GetOwner("User","Domain")                   ;  gibt 0 aus aber ohne Fehlermeldung
			; Owner:=process.GetOwner["User","Domain"]                   ;  gibt 0 aus aber ohne Fehlermeldung
			; Owner:=GetOwner(User,Domain).process.                  ; Funzt ned
			; if(User<>"")
			; MsgBox % ProcessId "    " ProzessName  "    " ThreadCount  "    " ParentProcessId   "    " Owner   "    " User[]     "    " Domain[]  
			; weitere siehe https://msdn.microsoft.com/en-us/library/aa394372(v=vs.85).aspx
*/
		}
		;  MsgBox 0, Befehlszeile, % process.CommandLine    ; entnommen
		; else
		; TrayTip,Hinweis, Prozess nicht gefunden!
		; Alle globalen Objekte freigeben (nicht notwendig, wenn lokale Variablen verwendet werden).
		wmi := queryEnum := process := ""  
		; </Get CommandLine>
		ReturnArray[A_Index] := {WinID: WinID,Name:ProzessName,ProcessId:ProcessId,ParentProcessId:ParentProcessId,priority:priority, X: X, Y: Y, W: W, H: H, Class: Class, Title: Title,CommandLine: CommandLine ,Owner:User[],ShortText:ShortText}  ; befuellen des Ruckgabeobjektes.
		; if InternetExplorerServer
		;	 gosub IE_ControllsEinfuegen
	}
	
	Return ReturnArray
}



IeContListe(ThisWinHwnd) 
{
	global ControlModus, WinModus,InternetExplorerServer,IeModus
	IeModus:=true
	LV_ModifyCol(11, "Integer")
	ReturnArray2 := [] ; Rückgabearry deklarieren
	ThisWinHwndMerker:=ThisWinHwnd
	; WinGet, ControlHwndCrListe, ControlListHwnd ,% "ahk_id" WinExist("A") ; siehe Hilfe
	if ControlModus
	{
		WinGet, ControlHwndCrListe, ControlListHwnd ,% "ahk_id" ThisWinHwnd ; siehe Hilfe
		loop,Parse,ControlHwndCrListe,`n,`r
		{
			ID:=A_Index
			ID%A_Index%:=A_LoopField
		}
	}
	else if WinModus
		WinGet, ID, List, , , Program Manager ; siehe Hilfe

	ReturnArray2:=""
	if(not IsObject(ReturnArray2))
		ReturnArray2 := [] ; Rückgabearry deklarieren
	else
		MsgBox Skriptfehler ReturnArray2 sollte hier leer sein!
	
	; MsgBox dreinn
	WinActivate,ahk_id %ThisWinHwnd%
	WinWaitActive,ahk_id %ThisWinHwnd%,,3
	; outline := Outline()
	; WD:=""
	WD := GetWebBrowser()
	document:=WD.document
	AnzHtmlElemente:=document.all.length
	; MsgBox, 262436, Elemente[%AnzHtmlElemente%], sollen auch Tags mit der Flaeche 0 angezeigt werden?
	; IfMsgBox,Yes
		AlleAnzeigen:=true
	loop % AnzHtmlElemente
	{
		
		i:=A_Index-1
		; MsgBox % Vaeter[i].nodeName
		AnzeigeIndex:=ControlIndex " " i
		AnzeigeHwnd:=ThisWinHwndMerker  " "  A_Index
		DieserTagName:= document.all[i].TagName
		; MsgBox % DieserTagName
		DiesesID:= document.all[i].ID
		if (DiesesHwnd<>"")
			MsgBox % DiesesID
		HTMLQuelle:= document.all[i].outerHTML
		try
			attributes0:= document.all[A_Index-1].attributes[0]
		
		W:=document.all[i].offsetWidth
		H:=document.all[i].offsetHeight
		if((W=0 or H=0) and Not AlleAnzeigen)
			continue
		Flaeche:=W*H
		x0:=0,y0:=0
		WinGetPos,X0,Y0,FensterBreite,FensterHoehe,ahk_id %ThisWinHwnd%
		x:=+X0 +absLeft(document.all[i])
		y:=+y0 +absTop(document.all[i])
		
		Parents:=absParent(document.all[i])
		
		
		
		
		if((x<-3000 or H<-2000) and Not AlleAnzeigen)
			continue

		
		
		if(document.all[A_Index-1].getAttribute("href")<>"")
		{
			Href%i%:=document.links[m].href
			++m
		}
		PreviousNodeName:= document.all[A_Index-1].previousSibling.nodeName
		NextNodeName:= document.all[A_Index-1].nextSibling.nodeName
		DieseAtribute:=""
		DieseAtribute:=  document.all[A_Index-1].getAttribute("bgcolor") " " document.all[A_Index-1].getAttribute("text") " " document.all[A_Index-1].getAttribute("name") " " document.all[A_Index-1].getAttribute("http-equiv") " " document.all[A_Index-1].getAttribute("content")
		DieserTagText:=document.all[A_Index-1].innerText
		
		
		
		
		NodeNameVaterKnoten:=document.all[i].parentNode.nodeName
		; IndexVaterKnoten:=document.all[i].parentElement.sourceIndex 
/*
		IndexVaterKnoten:=i
		IndexVaterKnotenAlt:=""
		Parents:=""
		Loop,20
		{
			Parents.=document.all[IndexVaterKnoten].parentNode.nodeName 
			Parents.="[" IndexVaterKnoten  "] "
			; IndexVaterKnotenMerk:=document.all[IndexVaterKnoten].parentElement.offsetParent.sourceIndex 
			Eltern:=document.all[IndexVaterKnoten]
			Eltern:=Eltern.parentElement
			IndexVaterKnoten:=Eltern.sourceIndex
			; if(IndexVaterKnotenMerk>IndexVaterKnoten)
			;	MsgBox % document.all[IndexVaterKnotenMerk].parentNode.nodeName A_Space IndexVaterKnotenMerk "`n" document.all[IndexVaterKnoten].parentNode.nodeName A_Space IndexVaterKnoten
			; IndexVaterKnoten:=IndexVaterKnotenMerk
			; if(IndexVaterKnoten<2)
				; break
			if(IndexVaterKnotenAlt=IndexVaterKnoten)
				break
			if(IndexVaterKnoten="")
				break
			IndexVaterKnotenAlt:=IndexVaterKnoten
			
		}
		; if(IdVaterKnoten<>"")
			; MsgBox % Parents
*/
		HatKindKnoten:=document.all[A_Index-1].hasChildNodes()
		TagNamesKindKnoten:=""
		NodeNamesKindKnoten:=""
		if HatKindKnoten
		{
			KinderErster_Ordnung:=document.all[A_Index-1].childNodes.length
			loop % KinderErster_Ordnung
			{
				j:=A_Index-1
				try
					HatKindKindKnoten%j%:=document.all[i].childNodes[j].hasChildNodes()
				; if HatKindKindKnoten%j%
				try
					NodeNameKindKnoten%j%:=document.all[i].childNodes[j].nodeName
				try
				if (NodeNameKindKnoten%j%<>"#text")
					TagNameKindKnoten%j%:=document.all[i].childNodes[j].TagName
				TagNamesKindKnoten.=TagNameKindKnoten%j% A_Space
				NodeNamesKindKnoten.=NodeNameKindKnoten%j% A_Space
				TagNameKindKnoten%j%:=
				NodeNameKindKnoten%j%:=
			}
		}
		else
		{
			KinderErster_Ordnung:=0
			TagNamesKindKnoten:=""
		}
		if KinderErster_Ordnung
		{
			try DieserWert:=document.all[A_Index-1].childNodes[0].nodeValue
			catch 
			{
				if(DieserTagName="Title")
					DieserWert:=document.getElementsByTagName("title")[0].text			; ########################## fehler
				else
					DieserWert:=""
			}
		}
		else
			DieserWert:=""
		DieseAtribute:=attributesArray[0] " " attributesArray[1] " " attributesArray[2] " " attributesArray[3] " " attributesArray[4] " " 
		if(AlleAnzeigen or (document.all[i].offsetWidth<>0 and document.all[i].offsetHeight<>0))
			BisherigeAugabe:=
		ShortText:=KuerzeText(DieserTagText)
		ReturnArray2[A_Index] := {WinID: AnzeigeIndex,Name:DieserTagName,ProcessId:DiesesID,ParentProcessId:NodeNameVaterKnoten,priority:Parents, X: X, Y: Y, W: W, H: H, Class: Flaeche, Title: DieserTagName,CommandLine: Href%i% ,Owner:User[],ShortText:ShortText}  ; befuellen des Ruckgabeobjektes.
	}
	; ListLines
	; MsgBox
   return ReturnArray2
}

; Beispiel: Automatisiert ein vorhandenes Internet-Explorer-Fenster.

sURL := "https://autohotkey.com/boards/"
if webBrowser := GetWebBrowser()
   webBrowser.Navigate(sURL)
return

GetWebBrowser()
{
    ; Ermittelt einen unbearbeiteten Pointer, der auf das Document-Objekt des obersten IE-Fensters verweist.
    static msg := DllCall("RegisterWindowMessage", "str", "WM_HTML_GETOBJECT")
    SendMessage msg, 0, 0, Internet Explorer_Server1, ahk_class IEFrame
    if ErrorLevel = FAIL
        return  ; IE nicht gefunden.
    lResult := ErrorLevel
    DllCall("oleacc\ObjectFromLresult", "ptr", lResult
        , "ptr", GUID(IID_IHTMLDocument2,"{332C4425-26CB-11D0-B483-00C04FD90119}")
        , "ptr", 0, "ptr*", pdoc)

    ; Fordert den WebBrowserApp-Service an. In diesem bestimmten Fall sind
    ; SID und IID das gleiche, das aber nicht immer so ist.
    static IID_IWebBrowserApp := "{0002DF05-0000-0000-C000-000000000046}"
    static SID_SWebBrowserApp := IID_IWebBrowserApp
    pweb := ComObjQuery(pdoc, SID_SWebBrowserApp, IID_IWebBrowserApp)

    ; Gibt den Document-Objekt-Pointer frei.
    ObjRelease(pdoc)

    ; Gibt das WebBrowser-Objekt in verwendbarer Form zurück:
    static VT_DISPATCH := 9, F_OWNVALUE := 1
    return ComObject(VT_DISPATCH, pweb, F_OWNVALUE)
}

GUID(ByRef GUID, sGUID) ; Wandelt eine Zeichenkette in eine binäre GUID um und gibt deren Adresse zurück.
{
    VarSetCapacity(GUID, 16, 0)
    return DllCall("ole32\CLSIDFromString", "wstr", sGUID, "ptr", &GUID) >= 0 ? &GUID : ""
}



ComVar(Type=0xC)    ;https://autohotkey.com/board/topic/72999-com-byef-parameters/
{
    static base := { __Get: "ComVarGet", __Set: "ComVarSet", __Delete: "ComVarDel" }
    ; Create an array of 1 VARIANT.  This method allows built-in code to take
    ; care of all conversions between VARIANT and AutoHotkey internal types.
    arr := ComObjArray(Type, 1)
    ; Lock the array and retrieve a pointer to the VARIANT.
    DllCall("oleaut32\SafeArrayAccessData", "ptr", ComObjValue(arr), "ptr*", arr_data)
    ; Store the array and an object which can be used to pass the VARIANT ByRef.
    return { ref: ComObjParameter(0x4000|Type, arr_data), _: arr, base: base }
}
ComVarGet(cv, p*) { ; Called when script accesses an unknown field.
    if p.MaxIndex() = "" ; No name/parameters, i.e. cv[]
        return cv._[0]
}
ComVarSet(cv, v, p*) { ; Called when script sets an unknown field.
    if p.MaxIndex() = "" ; No name/parameters, i.e. cv[]:=v
        return cv._[0] := v
}
ComVarDel(cv) { ; Called when the object is being freed.
    ; This must be done to allow the internal array to be freed.
    DllCall("oleaut32\SafeArrayUnaccessData", "ptr", ComObjValue(cv._))
}


Anchor(ctrl, a, d = false) {
    static pos
    sig = `n%A_Gui%:%ctrl%=

    If (d = 1){
        draw = Draw
        d=1,1,1,1
    }Else If (d = 0)
        d=1,1,1,1
    StringSplit, q, d, `,

    If !InStr(pos, sig) {
      GuiControlGet, p, Pos, %ctrl%
      pos := pos . sig . px - A_GuiWidth * q1 . "/" . pw  - A_GuiWidth * q2 . "/"
        . py - A_GuiHeight * q3 . "/" . ph - A_GuiHeight * q4 . "/"
    }
    StringTrimLeft, p, pos, InStr(pos, sig) - 1 + StrLen(sig)
    StringSplit, p, p, /
    
    c = xwyh
    Loop, Parse, c
      If InStr(a, A_LoopField) {
        If A_Index < 3
          e := p%A_Index% + A_GuiWidth * q%A_Index%
        Else e := p%A_Index% + A_GuiHeight * q%A_Index%
        m = %m%%A_LoopField%%e%
      }
    
    GuiControl, %A_Gui%:Move%draw%, %ctrl%, %m%
  }

LV_SubitemHitTest(HLV) {
   ; To run this with AHK_Basic change all DllCall types "Ptr" to "UInt", please.
   ; HLV - ListView's HWND
   Static LVM_SUBITEMHITTEST := 0x1039
   VarSetCapacity(POINT, 8, 0)
   ; Get the current cursor position in screen coordinates
   DllCall("User32.dll\GetCursorPos", "Ptr", &POINT)
   ; Convert them to client coordinates related to the ListView
   DllCall("User32.dll\ScreenToClient", "Ptr", HLV, "Ptr", &POINT)
   ; Create a LVHITTESTINFO structure (see below)
   VarSetCapacity(LVHITTESTINFO, 24, 0)
   ; Store the relative mouse coordinates
   NumPut(NumGet(POINT, 0, "Int"), LVHITTESTINFO, 0, "Int")
   NumPut(NumGet(POINT, 4, "Int"), LVHITTESTINFO, 4, "Int")
   ; Send a LVM_SUBITEMHITTEST to the ListView
   SendMessage, LVM_SUBITEMHITTEST, 0, &LVHITTESTINFO, , ahk_id %HLV%
   ; If no item was found on this position, the return value is -1
   If (ErrorLevel = -1)
      Return 0
   ; Get the corresponding subitem (column)
   Subitem := NumGet(LVHITTESTINFO, 16, "Int") + 1
   Return Subitem
}

{ ; OUTLINE OBJECT DEFINITION
Outline(color="red") { ; uses GUI 95-99
	self := object(	"base",	object(	"show",			"Outline_Show"
								,	"hide",			"Outline_Hide" 
								,	"setAbove",		"Outline_SetAbove"	
								,	"transparent",	"Outline_Transparent"
								,	"color",		"Outline_Color"
								,	"destroy",		"Outline_Destroy"
								,	"__delete",		"Object_Delete"	)	)
	Loop, 4 {
		Gui, % A_Index+95 ": -Caption +ToolWindow"
		Gui, % A_Index+95 ": Color", %color%
		Gui, % A_Index+95 ": Show", NA h0 w0, outline%A_Index%
		self[A_Index] := WinExist("outline" A_Index " ahk_class AutoHotkeyGUI")
	}
	self.visible := false
	, self.color := color
	, self.top := self[1]
	, self.right := self[2]
	, self.bottom := self[3]
	, self.left := self[4]
	Return, self
}
	Outline_Show(self, x1, y1, x2, y2, sides="TRBL") { ; show outline at coords
		if InStr( sides, "T" )
		{
			try
			Gui, 96:Show, % "NA X" x1-2 " Y" y1-2 " W" x2-x1+4 " H" 2,outline1
		}
		Else, Gui, 96: Hide
		if InStr( sides, "R" )
		{
			try
			Gui, 97:Show, % "NA X" x2 " Y" y1 " W" 2 " H" y2-y1,outline2
		}
		Else, Gui, 97: Hide
		if InStr( sides, "B" )
		{
			try
			Gui, 98:Show, % "NA X" x1-2 " Y" y2 " W" x2-x1+4 " H" 2,outline3
		}
		Else, Gui, 98: Hide
		if InStr( sides, "L" )
		{
			try
			Gui, 99:Show, % "NA X" x1-2 " Y" y1 " W" 2 " H" y2-y1,outline4
		}
		Else, Gui, 99: Hide
		self.visible := true		
	}
	Outline_Hide(self) { ; hide outline
		Loop, 4
			Gui, % A_Index+95 ": Hide"
		self.visible := false
	}
	Outline_SetAbove(self, hwnd) { ; set Z-Order one above "hwnd"
		ABOVE := DllCall("GetWindow", "uint", hwnd, "uint", 0x3) ; get window directly above "hwnd"
		Loop, 4  ; set 4 "outline" GUI's directly below "hwnd_above"
			DllCall(	"SetWindowPos", "uint", self[ A_Index ], "uint", ABOVE
					,	"int", 0, "int", 0, "int", 0, "int", 0
					,	"uint", 0x1|0x2|0x10	) ; NOSIZE | NOMOVE | NOACTIVATE
	}
	Outline_Transparent(self, param) { ; set Transparent ( different from hiding )
		Loop, 4
			WinSet, Transparent, % param=1? 0:255, % "ahk_id" self[A_Index]
		self.visible := !param
	}
	Outline_Color(self, color) { ; set Color of Outline GUIs
		Loop, 4
			Gui, % A_Index+95 ": Color" , %color%
		self.color := color
	}
	Outline_Destroy(self) { ; Destroy Outline
		VarSetCapacity(self, 0)
	}
	Object_Delete() { ; Destroy "outline GUIs" when object is deleted
		Loop, 4
			Gui, % A_Index+95 ": Destroy"
	}
}

; Eval(x)	; https://autohotkey.com/board/topic/4779-simple-script-for-evaluating-arithmetic-expressions/
Eval(x)
{
   StringGetPos i, x, +, R
   StringGetPos j, x, -, R
   If (i > j)
      Return Left(x,i)+Right(x,i)
   If (j > i)
      Return Left(x,j)-Right(x,j)
   StringGetPos i, x, *, R
   StringGetPos j, x, /, R
   If (i > j)
      Return Left(x,i)*Right(x,i)
   If (j > i)
      Return Left(x,j)/Right(x,j)
   Return x
}

Left(x,i)
{
   StringLeft x, x, i
   Return Eval(x)
}
Right(x,i)
{
   StringTrimLeft x, x, i+1
   Return Eval(x)
}

FuehrendeSterneEntfernen(Pfad,Max=20)
{
 	global AnzahlEntfernterSterne
	Stern=*
	AnzahlEntfernterSterne:=0
	TabTabPos:=InStr(Pfad,A_Tab . A_Tab)
	if(TabTabPos>0)
		Pfad:=SubStr(Pfad,1,TabTabPos-1)
	StringReplace,Pfad,Pfad,%A_Tab%,`\
	Loop
	{
		if not Max
			return Pfad
		First:=SubStr(Pfad,1,1)
		if(First = Stern)
		{
			StringTrimLeft,Pfad,Pfad,1
			++AnzahlEntfernterSterne
		}
		else
		{
			return Pfad
		}
		--Max
	}
	return 
}

GetSuchRelevanteVarsVonZzo(ZzoEdit8="")
{
	global
	ControlGetText,Zzo%PfadAngekommenZaehler%Edit8,Edit8,ZackZack
	if(ZzoEdit8<>"" and ZzoEdit8<>Zzo%PfadAngekommenZaehler%Edit8 and ZzoEdit8<>Zzo%GemerkterPfadAngekommenZaehler%Edit8)
	{
		SuchVars%PfadAngekommenZaehler%Gueltig:=false
		return 0
	}
	else
		SuchVars%PfadAngekommenZaehler%Gueltig:=true
	ControlGetText,Zzo%PfadAngekommenZaehler%Edit2,Edit2,ZackZack
	ControlGetText,Zzo%PfadAngekommenZaehler%Edit3,Edit3,ZackZack
	ControlGetText,Zzo%PfadAngekommenZaehler%Edit7,Edit7,ZackZack
	ControlGetText,Zzo%PfadAngekommenZaehler%Button1,Button11,ZackZack
	DotPos:=InStr(Zzo%PfadAngekommenZaehler%Button1,".")
	KlammerZuPos:=InStr(Zzo%PfadAngekommenZaehler%Button1,"]")
	Zzo%PfadAngekommenZaehler%Button1:=SubStr(Zzo%PfadAngekommenZaehler%Button1,DotPos+1,KlammerZuPos-DotPos-1)
	; ControlGet,ZzoSuFi,Checked,,HwndCheckE0,ZackZack
	ControlGet,Zzo%PfadAngekommenZaehler%SuFi,Checked,,Button4,ZackZack	;OK
	
	TempRueck:="AktContainerNr:=?"
	ControlSetText,Edit4,%TempRueck%.,ZackZack
	sleep 800
	ControlGetText,Zzo%PfadAngekommenZaehler%AktHauptContainerNr,Edit4,ZackZack
	; ControlGet,ZzoSuFi,Checked,,SuFi,ZackZack
	; ToolTip,% "ZzoSuFi= " Zzo%PfadAngekommenZaehler%SuFi
	return 1
}
SetSuchRelevanteVarsVonZzo(GemerkterPfadAngekommenZaehler)
{
	global
	; ToolTip % GemerkterPfadAngekommenZaehler
	if(SuchVars%GemerkterPfadAngekommenZaehler%Gueltig)
	{
		Loop, 8
		{
			TempRueck:="AktContainerNr:=?"
			; sleep 400
			ControlSetText,Edit4,%TempRueck%.,ZackZack
			sleep 600
			ControlGetText,Zzo%PfadAngekommenZaehler%IstAktHauptContainerNr,Edit4,ZackZack
			; MsgBox % "if(" Zzo%PfadAngekommenZaehler%IstAktHauptContainerNr ">" Zzo%GemerkterPfadAngekommenZaehler%AktHauptContainerNr ")"
			sleep 600
			if Zzo%PfadAngekommenZaehler%IstAktHauptContainerNr is not Integer
			{
				MsgBox die aktuelle ContainerNr. konnte nicht gelesen werden! 
				break
			}
			else if Zzo%GemerkterPfadAngekommenZaehler%AktHauptContainerNr is not Integer
			{
				MsgBox die gespeicherte ContainerNr. konnte nicht gelesen werden! 
				break
			}
			else if(Zzo%PfadAngekommenZaehler%IstAktHauptContainerNr > Zzo%GemerkterPfadAngekommenZaehler%AktHauptContainerNr)
			{
				ControlSetText,Edit4,ContainerPrev.,ZackZack
				sleep 800
			}
			else if(Zzo%PfadAngekommenZaehler%IstAktHauptContainerNr = Zzo%GemerkterPfadAngekommenZaehler%AktHauptContainerNr)
				break
			else
			{
				ControlSetText,Edit4,ContainerNext.,ZackZack
				sleep 800
			}
			
		}
		
		sleep 100
		if(Zzo%GemerkterPfadAngekommenZaehler%SuFi)
			Control,Check,,Button4,ZackZack
		else
			Control,UnCheck,,Button4,ZackZack
		sleep 500
		TempRueck:=Zzo%GemerkterPfadAngekommenZaehler%Edit7
		sleep 100
		ControlSetText,Edit4,E7%TempRueck%.,ZackZack
		TempRueck:=Zzo%GemerkterPfadAngekommenZaehler%Edit2
		ControlSetText,Edit4,E2%TempRueck%.,ZackZack
		sleep 1000
		TempRueck:=Zzo%GemerkterPfadAngekommenZaehler%Edit3
		ControlSetText,Edit4,E3%TempRueck%.,ZackZack
		
; MsgBox % GemerkterPfadAngekommenZaehler "	" TempRueck
		
		; TempRueck:=Zzo%PfadAngekommenZaehler%Edit3
		; ControlSetText,Edit3,%TempRueck%,ZackZack
		; TempRueck:=Zzo%PfadAngekommenZaehler%Edit8
		; ControlSetText,Edit8,%TempRueck%,ZackZack
	}
	else
		return 0
	return 1
}