; < ######################################### I n h a l t ########################################## > @0010
;	@0010		I n h a l t
;	@0020		Anfangs-Kommentare										
;	@0100		Haupt-Programm								
;	@0110		Konstanten											
;	@0120		DefaultWerte											
;	@0130		Variablen											
;	@0150		Vor Fenster												
;	@0155			Gui
;	@0160			Gui Erstaufbau		Gui Elemente
;	@0170			Menues
;					Hauptmenue
;					LinksKlick
;					RechtsKlick
;					Drop Down
;	@0180		Nach Fensster												
;	@0199		Ende Haupt-Programm									
;	@0210		globale Hotkeys HotStrings
;	@0230 		Vom Gui aufegrufene Functions										
;	@0250		Vom Gui aufegrufene Labels
;	@0260			Edits										
;	@0270			Buttons
;	@0280			CheckBoxen
;	@0290			Haupt-Menue
;	@0291				Datei
;	@0292				Edit8
;	@0293				Container
;	@0294				Start-Pfad
;	@0295				Favoriten
;	@0296				Macro
;	@0297				Optionen
;	@0298				?
;	@0300 		Unterprogramme										
;	@0310			Eingbundene Unterprogramme
;	@0350			Unterprogramme fuer Macros
;	@0400		Funktionen											
;	@0410			Eingbundene Funktionen
;	@0450			Funktionen fuer Macros
;				(auch eventuell verwendbar --> @1000 Vorlagen)
;	@0500		Sonstige Menues Labels
;	@0510			Tray Menue
;	@0520			Clipboard Menue
;	@0800		Hilfe	
;				Versions-Info										
;	@0900		Im  eigenen  Prozess  laufende Skripte			
;	@0920			TaskWatch
;	@0940			Dir2Paths
;	@1000 		Vorlagen											
;	@1010			UnterProgramme
;	@1020			Funktionen
; nicht vergessen:
;  		Befehlsliste 
;  		Muster-Ausgabe-Funktion
; < / ####################################### I n h a l t ########################################## >
; < ######################################### Anfangs-Kommwntare ########################################## > @0020
; Das Skript wurde geschrieben um schnell mit Ordnern umzugehen
; Ordner von  Download:	
; 	https://github.com/Grrdi/ZackZackOrdner/archive/master.zip 
; auspacken
; und 
; 	SchnellOrdner.ahk
; starten.
; Beim Erststart sollte das Skript zum anlegen des Containers
; 	Haupt
; auffordern.
; 	Ja
; Dito Startpfad
; Die nun einzugebende Wurzel ist der Start-Pfad in dem anschlissend rekursiv Schnell Ordner gefunden werden koennen.
; Das Einlesen erfolgt in einem eigenen Prozess (suchen ist schon waehrend des Einlesens moeglich)
; Ubers Menue koennen weitere Start-Pfade eingelesen werden.
; Ueber das Feld 
; 	Ordner-Namen-Suche
; werden die angezeigten Ordner gefiltert 
; Aktionen werden mit den obigen Buttons eingeleitet.
; 	Menue | ? | Hilfe 
; erzeugt eine auf die Umgebung zugeschnittene Hilfe und oeffnet sie
; +++++++++++++++++++++++++++++++++++++++	Timer   und  On... Events  +++++++++++++++++++++++++++++++++++++++++++++++++ 
; # im Hauptteil werden keine Timer mehr benoetigt
; # ---------------------------------------------- Empfange_WM_COPYDATA ------------------------------------
; # 
; # OnMessage(0x4a, "Empfange_WM_COPYDATA")
; # Empfange_WM_COPYDATA(...)								String-Uebergabe fuer Befehle
; # 						On  				darf nicht unterbrochen werden. Uebergibt an den unkritischen Timer TimerEditUebernahme
; # 
; # -----------------------------------------------	LinksKlick -------------------------------------------------------
; # 
; # OnMessage(0x201, "WM_LBUTTONDOWN")
; # WM_LBUTTONDOWN(wParam, lParam)				LinksKlicks ins Gui verarbeiten
; # 
; # -----------------------------------------------	RchtsKlick ------------------------------------------------------
; # 
; # 											Rechtsklick auf die Statischen Text-Zahlen 1 2 3 etc. ist kein Timer sondern ein Ereignissgesteuertes Label GuiContextMenu
; # ---------------------------------------------- OnExit ----------------------------------------------------
; #
; # OnExit  GuiClose
; #												1. Befehl im Hauptprogramm
; +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
; < / ######################################### Anfangs-Kommwntare ########################################## >
#SingleInstance
#NoEnv
#Persistent
; < ######################################### H a u p t - P r o g r a m m  ################################################## > @0100
OnExit  GuiClose
Ue1=%1%
; < ########################################################## Konstanten ######################################################## > @0110
CR=`r
LF=`n
CRLF:=CR LF
Backslash=\
DotOverDot:=":"
Hochkomma="
AutoFavorit:=0
GrEdit2Default:=2
GuiNachHochfahrenMinimierenDefault:=0
WortVorschlaege:=true
Edit1Default:=
Edit2Default:=
Edit3Default:=1
Edit4Default:="Befehlsentgegennahme"
Edit5Default:=
Edit6Default:="25"
Edit7Default:="Filter"
Edit8Default:=
Edit9Default:=4
Edit10Default:="Zusatz"
; Edit10Default:="Start-Pfade: "
RegExBeratungsFormularHoehe:=365
RegExBeratungsFormularBreite:=840
WiWaDefault:=0
OnTopDefault:=0
IeAnzDefault:=0
RekurDefault:=1
MinDefault:=0
AktDefault:=1
AuAbDefault:=0
RegExDefault:=0
SuFiDefault:=0
ExpSelDefault:=0
SeEnDefault:=0
SrLiDefault:=1
BsAnDefault:=1
WoAnDefault:=0
beschaeftigtDefault:=0
MausGuenstigPositionierenDefault:=1
FileKenner=file://
FilePatternKenner=fileP://
; < / ########################################################## Konstanten ######################################################## >
AnzeigeNichtAktualisieren:=false
GrEdit2:=GrEdit2Default
; if(A_ScreenDPI<>96)
	DpiKorrektur:=A_ScreenDPI/96
MausGuenstigPositionieren:=MausGuenstigPositionierenDefault
StringReplace,ZumSpeichernThisAufmerksamkeitText,ThisAufmerksamkeitText,`r`n,`%CRLF`%,All
StringReplace,ZumSpeichernThisAufmerksamkeitText,ZumSpeichernThisAufmerksamkeitText,`n,`%LF`%,All
StringReplace,ZumSpeichernThisAufmerksamkeitText,ZumSpeichernThisAufmerksamkeitText,`r,`%CR`%,All
; < Hilfe einlesen Individueller Button> 
IfExist  %A_ScriptDir%\Button6.htm	
{
	FileRead,Button6HtmInhalt,%A_ScriptDir%\Button6.htm
	if ErrorLevel
		MsgBox %A_ScriptDir%\Button6.htm
}
; </ Hilfe einlesen Individueller Button> 
if (StarteOrdnerDetailierungsSkripte="")
	StarteOrdnerDetailierungsSkripte:=true
if StarteOrdnerDetailierungsSkripte
	gosub imHauptprogrammOrdnerDetailierungsSkripte
NurExeStartErlaubt:=false
MaxEditNumber:=10											; groesste verwendete Edit#
SpaeterKontainerAnzeigen:=false
ZackZackOrdnerLogErstellen:=false	
if ZackZackOrdnerLogErstellen
	ThreadUeberwachungLog(A_LineNumber,A_ThisHotkey,A_ThisLabel,A_ThisFunc,A_ThisMenu,A_ThisMenuItem,A_ThisMenuItemPos)
ScripKlammerInhalt:=GetKlammerInhalt(A_ScriptName)
If(ScripKlammerInhalt="")
{
	SkriptVersion:=false
}
else
{
	ScriptKlammerMitInhalt:="[" ScripKlammerInhalt "]"
}
StringReplace,ScriptNamneOhneKlammer,A_ScriptName,%ScriptKlammerMitInhalt%
IfNotExist %A_AppData%\Zack
	FileCreateDir, %A_AppData%\Zack		; Pfad fuer UnterSkripte Icons etc. und den Cache
LabelList=Wenn vor der Hilfe-Datei-Erzeugung via F1 eine BefehlsListe via`r`nMenue | Macro | Befehls-Liste`r`nangefordert wurde.`r`nerscheint hier in der Hilfe auch die Befehlsiste.
IfExist %A_ScriptDir%\Dir2Paths.exe
{
	IfNotExist  %A_AppDataCommon%\Zack\Dir2Paths.exe
		FileCopy,%A_ScriptDir%\Dir2Paths.exe, %A_AppDataCommon%\Zack\Dir2Paths.exe
}
IfExist %A_ScriptDir%\TastWatch.exe
{
	IfNotExist %A_AppDataCommon%\Zack\TastWatch.exe
		FileCopy,%A_ScriptDir%\TastWatch.exe, %A_AppDataCommon%\Zack\TastWatch.exe
}
FileDelete,%A_AppDataCommon%\Zack\SchnellOrdner.txt
FileAppend,%A_ScriptFullPath%,%A_AppDataCommon%\Zack\SchnellOrdner.txt,utf-16
DriveGet,DriveNames1CList,List
StringSplit,LaufwerksBuchstabe,DriveNames1CList
Loop, % LaufwerksBuchstabe0
{
	DriveNamesKommaList:=DriveNamesKommaList "," LaufwerksBuchstabe%A_Index%
	DriveNamesAwpfList.=LaufwerksBuchstabe%A_Index% ":\*`r`n" 
}
StringTrimLeft,DriveNamesKommaList,DriveNamesKommaList,1
StringTrimRight,DriveNamesAwpfList,DriveNamesAwpfList,2
IfNotExist %A_AppDataCommon%\Zack
	FileCreateDir, %A_AppDataCommon%\Zack
IfNotExist %A_AppDataCommon%\Zack\SkriptOrdner.lnk
	FileCreateShortcut,%A_ScriptDir%,%A_AppDataCommon%\Zack\SkriptOrdner.lnk
IfNotExist %A_AppDataCommon%\Zack\A_AppData.lnk
	FileCreateShortcut,%A_AppData%\Zack,%A_AppDataCommon%\Zack\A_AppData.lnk
IfNotExist %A_AppData%\Zack\A_AppDataCommon.lnk
	FileCreateShortcut,%A_AppDataCommon%\Zack,%A_AppData%\Zack\A_AppDataCommon.lnk
IfNotExist %A_AppData%\Zack\SkriptOrdner.lnk
	FileCreateShortcut,%A_ScriptDir%,%A_AppData%\Zack\SkriptOrdner.lnk
FileDelete,%A_AppDataCommon%\Zack\AlleLaufwerke.awpf
FileAppend,%DriveNamesAwpfList%,%A_AppDataCommon%\Zack\AlleLaufwerke.awpf,utf-16
WBvor:="file:///"
WichtigeTrayTipsAnzeigen:=true	
if ZackZackOrdnerLogErstellen
	ThreadUeberwachungLog(A_LineNumber,A_ThisHotkey,A_ThisLabel,A_ThisFunc,A_ThisMenu,A_ThisMenuItem,A_ThisMenuItemPos)
IfExist GeKoLi.ico
{
	Menu,Tray,icon,GeKoLi.ico
	if ZackZackOrdnerLogErstellen
		ThreadUeberwachungLog(A_LineNumber-1,A_ThisHotkey,A_ThisLabel,A_ThisFunc,A_ThisMenu,A_ThisMenuItem,A_ThisMenuItemPos)
}
#Include *i %A_ScriptDir%\DateiNamensVorschlag.ahk
GuiNachHochfahrenMinimieren:=false
if(Ue1="Minimized")
	GuiNachHochfahrenMinimieren:=true
StringReplace,ScriptFullPathOhneKlammer,A_ScriptFullPath,%A_ScriptName%,%ScriptNamneOhneKlammer%
If Fehlersuche
	MsgBox % ScriptFullPathOhneKlammer A_Tab ScriptNamneOhneKlammer
ZackData=%A_AppDataCommon%\Zack
WurzelContainer=%ZackData%\WuCont
if ZackZackOrdnerLogErstellen
	ThreadUeberwachungLog(A_LineNumber-1,A_ThisHotkey,A_ThisLabel,A_ThisFunc,A_ThisMenu,A_ThisMenuItem,A_ThisMenuItemPos)
IfNotExist %WurzelContainer%
{
	FileCreateDir,%WurzelContainer%
	IfNotExist %WurzelContainer%
		MsgBox kann  %WurzelContainer%  nicht erzeugen.
}
MetroAppLinksDir:=ZackData "\MetroAppLinks"
IfNotExist %MetroAppLinksDir%
	FileCreateDir, %MetroAppLinksDir%
IfExist %WurzelContainer%\Haupt
{
	SkriptDataPath=%WurzelContainer%\Haupt	
	IfExist % WurzelContainer "\Start Menu"
	{
		LetzterSkriptDataPathI:=WurzelContainer "\Start Menu"
		LetzterSkriptDataPath:=WurzelContainer "\Start Menu"
	}
	FavoritenDirPath:=SkriptDataPath "\!Fav"	
	SpaeterKontainerAnzeigen:=true
}
SkriptDataPathKurzNachProgrammbeginn:=SkriptDataPath					; diese Variable bitte als Konstante ansehen und ab hier nicht mehr aendern. 
if ZackZackOrdnerLogErstellen
	ThreadUeberwachungLog(A_LineNumber-1,A_ThisHotkey,A_ThisLabel,A_ThisFunc,A_ThisMenu,A_ThisMenuItem,A_ThisMenuItemPos)
IndexierenBeenden:=0
OrdnerEingelesen:=False
Rekursiv=R
gosub WorteCacheBefuellen
; < ################################    G  u  i    #################################### >	@0155
; < ################################  Gui Elemente  #################################### >	@0160
if(A_ScreenDPI=96)
	Gui,1:New,+HwndGuiWinHwnd -DPIScale
else
{
	Gui,1:New,+HwndGuiWinHwnd  ; -DPIScale
	/*
	IfNotExist,%A_AppData%\Zack\DpiMeldungNot.txt
	{
		MsgBox, 262452, DPI <> 96, Die Pixeldichte (%A_ScreenDPI%DPI) auf dem Bildschirm liegt nicht bei 96DPI.`nVermutlich treffen Drag & Drop - Aktionen auf Pfade von Edit5 nicht ihr Ziel.`n`nDiese Meldung bei jedem Programmstart anzeigen?
		IfMsgBox,No
		{
			FileAppend,Diese Datei loeschen`, wenn die Warnung`r`n`r`nDie Pixeldichte auf dem Bildschirm liegt nicht bei 96DPI.`r`nVermutlich treffen Drag & Drop - Aktionen auf Pfade von Edit5 nicht ihr Ziel.`r`n`r`nwieder angezeigt werden soll.,%A_AppData%\Zack\DpiMeldungNot.txt
		}
	}
	*/
}
if ZackZackOrdnerLogErstellen
	ThreadUeberwachungLog(A_LineNumber-1,A_ThisHotkey,A_ThisLabel,A_ThisFunc,A_ThisMenu,A_ThisMenuItem,A_ThisMenuItemPos)
Gui,1:+Resize ; AlwaysOnTop
Gui,1: Show, w510 h480, ZackZackOrdner
; sleep 1000
; PixelGetColor,GuiHintergrundFarbe, 510/2, 480/2,Alt
; PixelGetColor,GuiHintergrundFarbe, 510/2, 480/2,Slow
; PixelGetColor,GuiHintergrundFarbe,% A_ScreenWidth/2,% A_ScreenHeight/2,Alt
; MsgBox % GuiHintergrundFarbe
GuiHeight:=480
Gui,1: Add, Edit, 	x8 	y111 	w60 	h16 	HwndHwndEdit1	gEdit1 	vEdit1  -Tabstop 		r1	Right	 	, 	Anz
Gui,1: Add,	Text,	x78		y113	w55 	h16 																	,	gefundene
Gui,1: Add,	Text,	x0		y135 	w70		h32 																	,	ausgewaehlte`nPfad Nr.
; Gui,1: Add,	Text,	x71		y131 	w20		h52 																	,	_↑¯`n¯↓`n    \
Gui,1: Add,	Text,	x71		y125 	w25		h65 																	,	_┌─`n`n¯  \`n    ↓
Gui,1: Add,	Text,	x136	y113 	w30 	h16 																	,	Pfade
Gui,1: Add,	Text,	x0		y75 	w93 	h32															Right		,	Ordner-`nNamen-Suche
Gui,1: Add, Edit, 	x98 	y78 	w390 	h20   	HwndHwndEdit2	gEdit2 	vEdit2 				 	r1				, 	Such
Gui,1: Add,	Text,	x98		y98 	w83 	h16 																	,	Suche vom
Gui,1: Add, Edit, 	x40 		y150 	w30 	h18 	HwndHwndEdit3	gEdit3 	vEdit3				-Wrap r1	Number 	, 	1
Gui,1: Add, Edit, 	x490 	y78 	w150 	h20 	HwndHwndEdit4	gEdit4 	vEdit4	-Tabstop	-Wrap		 	 	, 	Befehlsentgegennahme
Edit5Y0:=125		; immer ueber diese Variable Y von Edit5 eingeben sonst trifft GuiDropFiles nicht
Gui,1: Add, Edit, 	x141 	y%Edit5Y0% w350	h240  	HwndHwndEdit5	gEdit5 	vEdit5	-Tabstop	-Wrap 	0x100	 -VScroll  T235 T0 T0	HScroll, 	Ordner ; HScroll
Gui,1: Add, UpDown, 	x122 	y%Edit5Y0% w8	h240	HwndHwndEdit5UpDown							vEdit5UpDown  gEdit5UpDown  -16 Range999999-1, 1
Gui,1: Add,	Text,	x239	y98 	w82 	h16 																	,	 Abbruch nach
Gui,1: Add, Edit, 	x309 	y96 	w70		h24  	HwndHwndEdit6	gEdit6 	vEdit6				-Wrap r1	Number 	, 	25
Gui,1: Add,	Text,	x351	y98 	w55 	h16 																	,	 Iterationen.
GuiControl,1:, Edit6, 25
Gui,1: Add, CheckBox, x425 	y108	w80 	h15 	HwndHwndCheckA0	gbeschaeftigt		vbeschaeftigt	-Tabstop				, 	beschaeftigt
Gui,1: Add, CheckBox, x156 	y98	w80 	h15 	HwndHwndCheckA5	gWoAn	vWoAn	-Tabstop						, 	WortAnfang,
Gui,1: Add,	Text,	x0	y62 	w130 	h14 																	,	Rückgabeopt. →
Gui,1: Add, CheckBox,	x97 	y62 	w31 	h14  	HwndHwndCheckB2	gBsAn	vBsAn	-Tabstop	Checked		Right	,	..\
BsAn:=true
GuiControl,1:, BsAn, %BsAn%
Gui,1: Add, CheckBox,	x132 	y62 	w32 	h14 	HwndHwndCheckB4	gSrLi	vSrLi	-Tabstop	Checked		Right	,	<--
SrLi:=true
GuiControl,1:, SrLi, %SrLi%
Gui,1: Add, CheckBox,	x160 	y62 	w33 	h14 	HwndHwndCheckB6	gSeEn  	vSeEn	-Tabstop				Right	,	ok
Gui,1: Add, CheckBox,	x302 	y62 	w90 	h14 	HwndHwndCheckB8	gExpSel vExpSel	-Tabstop			Right	, 	Selektiert		; Checked
ExpSel:=false
GuiControl,1:, ExpSel, %ExpSel%
Gui,1: Add,	Text,	x0		y184 	w90 	h16 																	,	Pfad-Filter
Gui,1: Add, CheckBox, x0 		y222 	w45 	h16 	HwndHwndCheckE0	gSuFi	vSuFi	-Tabstop						, 	Filter
HwndSuFi:=HwndCheckE0
Gui,1: Add,	Text,	x0		y243 	w90 	h16 																	,	Fenster
Gui,1: Add, CheckBox, x47 	y222 	w55 	h16 	HwndHwndCheckE5	gRegEx	vRegEx	-Tabstop						, 	RegEx
Gui,1: Add, Edit, 	x0 		y200 	w90 	h16 	HwndHwndEdit7	gEdit7 	vEdit7	-Tabstop 	-Wrap r1 			, 	Filter
Gui,1: Add, Edit, 	x0 		y0 		w510	h16 	HwndHwndEdit8 	gEdit8 	vEdit8	-Tabstop 	-Wrap r1 0x100	Center 	, 	EinzelErg		; Right
WiWa:=false
Gui,1: Add, CheckBox, x0 		y236 	w65 	h20 	HwndHwndCheckE9	gAuAb	vAuAb	-Tabstop						, 	AutoAbbr
GuiControl,1:Hide,AuAb
Gui,1: Add, Edit, 	x62		y235 	w30 	h16 	HwndHwndEdit9	gEdit9	vEdit9	-Tabstop	r1			Number	, 	4
GuiControl,1:Hide,Edit9
Gui,1: Add, CheckBox, x0 		y256 	w35 	h20 	HwndHwndCheckG0	gOnTop	vOnTop	-Tabstop						, 	To				; Top (Top -> Min)
Gui,1: Add, CheckBox, x42 	y256 	w35 	h20 	HwndHwndCheckG3	gAkt	vAkt	-Tabstop	Checked				, 	Ak				; Akt (Akt+Min -> Min; Akt+Top -> Min Akt -> Bottom ; Nichts -> lassen)		Top or Min -> Min    +Akt -Top -Min -> Bottom    -Top -Akt -Min -> lassen
Gui,1: Add, Edit, 	x122 	y450 	w390 	h20   	HwndHwndEdit10	gEdit10 	vEdit10 				 	r1		, 	%Edit10Default%
GuiControl,1:, %HwndHwndCheckG3%, 1
; Gui, Add, CheckBox, x62 	y256 	w30 	h20 	HwndHwndCheckG9	gOnTop	vMin	-Tabstop						, 	Mi				; Min (Min gewinnt gegen Top und Akt)
Gui,1: Add,	Text,	x0		y314 	w90 	h16 																	,	Pfade einlesen
Gui,1: Add, CheckBox, x0 		y326 	w90 	h20 	HwndHwndCheckI0	gRekursiv	vRekur 	-Tabstop	Checked			, 	Rekursiv
Gui,1: Add,	Text,	x0		y350 	w90 	h32																	,	Anzeige im`nFeld rechts
Gui,1: Add, CheckBox, x0 		y376 	w90 	h32 	HwndHwndCheckK5	gIeAnz vIeAnz	-Tabstop						, 	zeige Inhalte √`noder Pfade
Gui,1: Add, Button,	x0 		y19		w90 	h40 	HwndHwndButton1	gButton1		-Tabstop			 			, 	aktualisieren
Gui,1: Add, Button, 	x102 	y19 	w90 	h40 	HwndHwndButton2	gButton2  	 									,  	-> &I
Gui,1: Add, Button, 	x202 	y19 	w90 	h40 	HwndHwndButton3	gButton3										, 	└> &Clip
Gui,1: Add, Button, 	x302 	y19 	w90 	h40 	HwndHwndButton4	gButton4					Default				,	Explorer ; (Enter)	; vorzugsweise Default-Button
Gui,1: Add, Button, 	x402 	y19	 	w90 	h40 	HwndHwndButton5	gButton5		-Tabstop						, 	Copy`nMove
; PixelGetColor,GuiHintergrundFarbe, 510/2, 480/2,RGB
MouseMove,56*DpiKorrektur, 445*DpiKorrektur			; eigentlich unnoetig, Wartezeit damit der Folgebefehl klappt
; sleep 5000
PixelGetColor,GuiHintergrundFarbe, 56*DpiKorrektur, 440*DpiKorrektur,RGB
Loop,10
{
	ButtonIndex:=5+A_Index
	IfExist %A_ScriptDir%\Button%ButtonIndex%.ahk
	{
		IfExist %A_ScriptDir%\Button%ButtonIndex%.Txt
		{
			FileRead,Button%ButtonIndex%Inhalt,%A_ScriptDir%\Button%ButtonIndex%.Txt
			{
				Datenkopie:=Button%ButtonIndex%Inhalt
				gosub TimerEditUebernahme
			}
		}
		Button%ButtonIndex%X:=402+A_Index*100
		ThisButtonX:=Button%ButtonIndex%X
		if (Button%ButtonIndex%Name="")
			Button%ButtonIndex%Name=Spzial: Script %ButtonIndex%
		ThisButtonName:=Button%ButtonIndex%Name
		Gui,1: Add, Button, 	x%ThisButtonX%	y19	 	w90 	h40 	HwndHwndButton%ButtonIndex%	gButton%ButtonIndex%		-Tabstop		, 	%ThisButtonName%
	}
}
Gui,1: Add, ActiveX, x141 	y%Edit5Y0% w350	h240 HWNDHwndIe1 vWB gWB, Shell.Explorer  ; Der letzte Parameter ist der Name der ActiveX-Komponente.
gosub IeControl
if ZackZackOrdnerLogErstellen
	ThreadUeberwachungLog(A_LineNumber-1,A_ThisHotkey,A_ThisLabel,A_ThisFunc,A_ThisMenu,A_ThisMenuItem,A_ThisMenuItemPos)
; < / ###############################  Gui Elemente  #################################### >
; < ##################################### Fenster-Menue ################################## >	@0170
Menu, Dateimenü, 		Add, &Reload					, NeuStarten
Menu, Dateimenü, 		Add, &Skript-Ordner oeffnen		, SkriptOrdnerOeffnen	
Menu, Dateimenü, 		Add, &Data-Ordner oeffnen		, DataOrdnerOeffnen	
Menu, Dateimenü, 		Add, &Testumgebung erzeugen		, TestumgebungErzeugen	
Menu, Dateimenü, 		Add, &Beenden					, GuiClose
; Edit8
Menu, Edit8menue, 		Add, &oeffnen			`t#F4		, Edit8Oeffnen
Menu, Edit8Menue, 		Add, &neuer Ordner				, Edit8NeuerOrdner
Menu, Edit8Menue, 		Add, &zeige Unter-DrueberOrdner		, Edit8ZeigeVorfahrenUndUnterordner
Menu, Edit8Menue, 		Add, &Explorer					, Edit8Explorer
Menu, Edit8Menue, 		Add, &Explorer Select (GetFather)			, Edit8ExplorerSelect
Menu, Edit8Menue, 		Add, &Zeige Inhalte im internen Explorer			, Edit8ExplorerEingebunden
Menu, Edit8Menue, 		Add, &Zeige Inhalte nur Text in Edit5	, Edit82Edit2
Menu, Edit8Menue, 		Add, DirName -> Edit2					, DirName2Edit2
Menu, Edit8Menue, 		Add, FatherName -> Edit2					, FatherName2Edit2
Menu, Edit8Menue, 		Add, &umbenennen				, Edit8Umbenennen
Menu, Edit8Menue, 		Add, &DateiSuche				, DateiSucheAusgehendVonEdit8
; Container
Menu, ContainerMenue, 	Add, (Angezeigten) &oeffnen		, WurzelContainerOeffnen  
Menu, ContainerMenue, 	Add, Letzten oeffnen	`tF4	, LetzterContainer  
Menu, ContainerMenue, 	Add, &anlegen ...					, ContainerAnlegen  
Menu, ContainerMenue, 	Add, &loeschen ...					, ContainerLoeschen  
Menu, ContainerMenue,	Add, &Alle loeschen ...				, DelCache
Menu, ContainerMenue,	Add, Uebersicht anzeigen 		, ContainerUebersichtZeigen
; Wurzel
Menu, StartPfadMenue, 	Add, von &Datei einlesen ...	, WurzelVonDateiHinzuFuegen  ; Siehe untere Bemerkungen zu Ctrl+F.
Menu, StartPfadMenue, 	Add, &einlesen ...`tCtrl+O		, WurzelHinzuFuegen  ; Siehe untere Bemerkungen zu Ctrl+F.
Menu, StartPfadMenue, 	Add, (Angezeigten) &aktualisieren ...	(einzeln)	, WurzelAktualisieren ; 
Menu, StartPfadMenue, 	Add, &aktualisieren	(Container)	, WurzelnAktualisieren ; 
Menu, StartPfadMenue, 	Add, &Loeschen ...				, WurzelLoeschen  ; 
Menu, StartPfadMenue, 	Add, &Uebersicht anzeigen		, StartPfadeUebersicht  ; 
; Favoriten
Menu, FavMenue, 		Add, &speichern ...					, FavoritSpeichern
Menu, FavMenue, 		Add, &oeffnen (restaurieren) ...	, FavoritOeffnen
Menu, FavMenue, 		Add, &plus *					, PlusStern
Menu, FavMenue, 		Add, &minus *					, MinusStern
Menu, FavMenue, 		Add, Sternlose loeschen		, SternLoseFavoritenLoeschen
Menu, FavMenue, 		Add, &AutoFavorit=%AutoFavorit%	, AutoFavoritEingeben
Menu, FavMenue, 		Add, &Ordner oeffnen			, FavoritenOrdnerOeffnen
; Menu, FavMenue, 		Add, &Zeige temp Pos in Ordner-Struktur	, Edit8ZeigeVorfahrenUndUnterordner ; entnommen wegen zu vieler Eintraege
Menu, FavMenue, 		Add, Fav-Vorschlag generieren ...	, FavoritenVorschlagErzeuegen
Menu, FavMenue, 		Add
Menu, FavMenue, 		Add, plus * Clip-Pfade `t#*		, PlusSternClipPfade
Menu, FavMenue, 		Add, minus * Clip-Pfade				, MinusSternClipPfade
Menu, FavMenue, 		Add, Loeschen * Clip-Pfade			, LoeschenSternClipPfade
Menu, FavMenue, 		Add
Menu, FavMenue, 		Add, plus * &manuell ...			, PlusSternManuell
Menu, FavMenue, 		Add
SuperFavoritenDateiAlterPfad=%WurzelContainer%\SuperFavoriten\!Fav\SuperFavoriten.txt
SuperFavoritenDateiPfad=%A_AppData%\Zack\SuperFavoriten.txt
IfExist %SuperFavoritenDateiPfad%
{
	Menu, FavMenue, 		Add, SuperFavoriten ♥ bearbeiten	, SuperFaVoritenAnlegenBearbeiten
}
else
{
	IfExist %SuperFavoritenDateiAlterPfad%
		FileCopy,%SuperFavoritenDateiAlterPfad%,%SuperFavoritenDateiPfad%
	; MsgBox %ErrorLevel%	%SuperFavoritenDateiAlterPfad%	%SuperFavoritenDateiPfad%
	Menu, FavMenue, 		Add, SuperFavoriten ♥ anlegen / bearbeiten	, SuperFaVoritenAnlegenBearbeiten
}
; Macro
Menu, MacroMenue, 		Add, &Ordner oeffnen			, StaOrdnerBefehlsDateiPfadOeffnen
Menu, MacroMenue, 		Add, &Starten...				, UserSelBefehlsDateiPfadAusfuehren
; Menu, MacroMenue, 		Add, &nochmals starten			, BefehlsVariableAusfuehren ; auskommentiert da nicht verlaesslich
Menu, MacroMenue, 		Add, &Muster-Dateien ...			, MusterDateienErzeugen
Menu, MacroMenue, 		Add, &Befehls-Liste				, ListLabels
; Optionen
Menu, OptionsMenue, 	Add, &Sitzungs-Einst. speichern				, SitzungsEinstellungenMerken
Menu, OptionsMenue, 	Add, &Sitzungs-Einst. einlesen				, SitzungsEinstellungenEinlesen
Menu, OptionsMenue, 	Add, &Sitzungs-Einst. bearbeiten			, SitzungsEinstellungenBearbeiten
Menu, OptionsMenue, 	Add, Suche &ruecksetzen			, ResetAllNocontainer
IfExist %A_ScriptDir%\AktualisiereZackZackOrdner.ahk
	Menu, OptionsMenue, 	Add, ZZO Neueste Version holen				, ZZOAktualisieren
Menu, OptionsMenue, 	Add, &Einstellungen ...				, Einstellungen
; Hilfe
Menu, Hilfsmenü, 		Add, &Verlangsamte Demo			, LangsamDemoToggle
Menu, Hilfsmenü, 		Add, Inf&o						, Info
Menu, Hilfsmenü, 		Add, &Hilfe						, Hilfe
; ---------------------------------------------------------------------------------
Menu, MeineMenüleiste,	Add, &Datei						, 	:Dateimenü  ; Fügt die oben erstellten Untermenüs hinzu.
Menu, MeineMenüleiste,	Add, &Edit8						, 	:Edit8menue  ; Fügt die oben erstellten Untermenüs hinzu.
Menu, MeineMenüleiste,	Add, &Container					, 	:ContainerMenue
; Menu, MeineMenüleiste,	Add, &Start-Container			, 	:WurzelMenue
Menu, MeineMenüleiste,	Add, &Start-Pfad				, 	:StartPfadMenue
Menu, MeineMenüleiste,	Add, &Favoriten					, 	:FavMenue
Menu, MeineMenüleiste,	Add, &Macro						, 	:MacroMenue
Menu, MeineMenüleiste,	Add, &Optionen					, 	:OptionsMenue
Menu, MeineMenüleiste, 	Add, &?							, 	:Hilfsmenü 
; Menu, MeineMenüleiste, 	Add, ♥`:							, 	SuperFavorit0 
IfExist %SuperFavoritenDateiPfad%
{
	FileRead,SuperFavoritenDateiInhalt,%SuperFavoritenDateiPfad%
	StringSplit,SuperFavoritenPfad,SuperFavoritenDateiInhalt,`n,`r
	FavoritenHerzAnzeige=♥
	Loop % SuperFavoritenPfad0-1
	{
		TempIndexPlus1:=A_Index+1
		if (A_index>29)
		{
			ZuEntfernendePfade:=SuperFavoritenPfad0-30
			gosub SuperFavorit0
			MsgBox, 262160, SuperFavoriten ♥, SuperFavoriten-Pfade werden nur bis zu 29 unterstuetzt!`nBitte mindestens %ZuEntfernendePfade% Pfade von der sich öffnenden Datei SuperFavoriten.txt entfernen 
			break
		}
		else if (SuperFavoritenPfad%TempIndexPlus1%<>"")
		{
			Menu, MeineMenüleiste, 	Add, %FavoritenHerzAnzeige%%A_Index%							, 	SuperFavorit%A_Index%
			FavoritenHerzAnzeige=
		}
	}
}
; Menu, MeineMenüleiste, 	Add, 1							, 	SuperFavorit1 
; Menu, MeineMenüleiste, 	Add, 2							, 	SuperFavorit2 
; Menu, MeineMenüleiste, 	Add, 3							, 	SuperFavorit3 
Gui, Menu, MeineMenüleiste
if ZackZackOrdnerLogErstellen
	ThreadUeberwachungLog(A_LineNumber-1,A_ThisHotkey,A_ThisLabel,A_ThisFunc,A_ThisMenu,A_ThisMenuItem,A_ThisMenuItemPos)
; </---------------------------------- Fenster-Menue ----------------------------------------->
Menu, IntegerMenu, Add, Nur_Nr, IntegerMenuHandler
Menu, IntegerMenu, Add, Set Clipboard, IntegerMenuHandler
Menu, IntegerMenu, Add, Neuer_Ordner, IntegerMenuHandler
Menu, IntegerMenu, Add, zeige_UnterOrdner, IntegerMenuHandler
Menu, IntegerMenu, Add, Explorer, IntegerMenuHandler
Menu, IntegerMenu, Add, Explorer Select, IntegerMenuHandler
Menu, IntegerMenu, Add, Zeige Inhalte, IntegerMenuHandler
Menu, IntegerMenu, Add, umbenennen, IntegerMenuHandler
Menu, IntegerMenu, Add  ; Fügt eine Trennlinie ein.
; Erstellt ein weiteres Menü, das als Untermenü für das obige Menü dienen soll.
Menu, Submenu1, Add, + Stern, IntegerMenuHandler
Menu, Submenu1, Add, - Stern, IntegerMenuHandler
; Erstellt ein Untermenü im ersten Menü (mit einem nach rechts gerichteten Pfeil). Sobald der Benutzer dieses Untermenü auswählt, wird das zweite Menü angezeigt.
Menu, IntegerMenu, Add, Favorit, :Submenu1
Menu, IntegerMenu, Add  ; Fügt eine Trennlinie unterhalb des Untermenüs ein.
Menu, Submenu2, Add, Set Clipboard, IntegerMenuHandler
Menu, Submenu2, Add, Get Clipboard, IntegerMenuHandler
Menu, IntegerMenu, Add, Edit#, :Submenu2
; -----------------------------------------------------------
Menu, SucheMenu, Add, vom VaterDir, SucheMenuHandler
Menu, SucheMenu, Add, vom VaterWin, SucheMenuHandler
Menu, SucheMenu, Add
Menu, SucheMenu, Add, Control Infos, SucheMenuHandler  ; Fügt einen weiteren Menüpunkt unterhalb des Untermenüs ein.
; --------------------------------------------------------------
Menu, SuFiMenu, Add, vom VaterDir, SuFiMenuHandler
Menu, SuFiMenu, Add, vom GrossVaterDir, SuFiMenuHandler
Menu, SuFiMenu, Add, vom VaterWin, SuFiMenuHandler
Menu, SuFiMenu, Add
Menu, SuFiMenu, Add, Control Infos, SuFiMenuHandler  ; Fügt einen weiteren Menüpunkt unterhalb des Untermenüs ein.
Menu, ExplorerMenu, Add, Clip-Pfad -> Explorer, ExplorerMenuHandler
; --------------------------------------------------------------
Menu, ClipboardMenu, Add, Clipboard 2 Text, ClipboardMenuHandler1
Menu, ClipboardMenu, Add, Clipboard 2 Speicher1, ClipboardMenuHandler2
Menu, ClipboardMenu, Add, Markiertes 2 Clipboard und zu Speicher1 hinzufuegen, ClipboardMenuHandler2a
Menu, ClipboardMenu, Add, Speicher1 2 Clipboard, ClipboardMenuHandler3
Menu, ClipboardMenu, Add, fuege Speicher1 an Schreibmarke ein, ClipboardMenuHandler3a
Menu, ClipboardMenu, Add
Menu, ClipboardMenu, Add, Aktives Fenster als ZZO-Favorit einrichten, ClipboardMenuHandler4
Menu, ClipboardMenu, Add,  Clip-Pfade 2 ZZO-Favoriten (plus *)`t#*	, ClipboardMenuHandler5
Menu, ClipboardMenu, Add
Menu, ClipboardMenu, Add, sortiere Clip-Zeilen 	, ClipboardMenuHandler6
Menu, ClipboardMenu, Add, sortiere Clip-Zeilen nach Ordner-/Datei-Name	, ClipboardMenuHandler7
Menu, ClipboardMenu, Add
Menu, ClipboardMenu, Add, spiele Clippboard (mp3)	, SoundPlayClipboard
Menu, ClipboardMenu, Add, starte Clippboard	, ClipboardMenuHandler8
Menu, ClipboardMenu, Add
Menu, ClipboardMenu, Add, Edit82AWin (für CMD`, Save as`, Expl.)	, ClipboardMenuHandler12
Menu, ClipboardMenu, Add
Menu, ClipboardMenu, Add, zeige / editiere ClipInhalt	, ClipboardMenuHandler10
IfExist % FuehrendeSterneEntfernen(Clipboard)
	Menu, ClipboardMenu, Add, zeige ClipPathInhalt in Edit5	, ClipboardMenuHandler11

; < /  ##################################### Fenster-Menue ################################## >
; < ------------------------------ PfadNummern links von Edit5 ins Gui --------------------------------->
if (PfadNrStatisch1YOhne = "")	
PfadNrStatisch1YOhne := 128												; Die Nummern beginnen ab Pixel
if (PfadNrStatisch1YOhneEich = "")
PfadNrStatisch1YOhneEich := -2												; EichSummand	Neeutral := 0
PfadNrStatisch1Y := PfadNrStatisch1YOhne + PfadNrStatisch1YOhneEich			; Erster Y Abstand in Pixel
if (GrundZeilenVersatzYEich = "")
GrundZeilenVersatzYEich := 1											; EichFaktor	Neeutral := 1
if (GrundZeilenVersatzYStandart = "")
GrundZeilenVersatzYStandart := 13												; StandartVersatz in Pixel
Edit5=1`n2`n3`n4`n5`n6`n7`n8`n9`n10`n11`n12`n13`n14`n15`n
gosub Edit5Festigen
ControlFocus,Edit5,ahk_id %GuiWinHwnd%
ControlClick,Edit5,ahk_id %GuiWinHwnd%
ControlSend,Edit5,^{Home},ahk_id %GuiWinHwnd%
sleep 100
Zeile1Y:=A_CaretY
; ToolTip % Zeile1Y-(PfadNrStatisch1YOhne/DpiKorrektur+DieseThisY)  "	=	 " Zeile1Y "	" PfadNrStatisch1YOhne/DpiKorrektur "	" DieseThisY	"	" PfadNrStatisch1YOhne
; PfadNrStatisch1YOhneEich:=Zeile1Y-(PfadNrStatisch1YOhne/DpiKorrektur+DieseThisY)
; PfadNrStatisch1Y:=PfadNrStatisch1YOhne + PfadNrStatisch1YOhneEich	
ControlSend,Edit5,^{End},ahk_id %GuiWinHwnd%
sleep 10
Zeile15Y:=A_CaretY
; Sleep 5000
; MouseMove,A_CaretX,Zeile1Y
; Sleep 5000
; MouseMove,A_CaretX,Zeile15Y
GrundZeilenVersatzYEich:=(Zeile15Y-Zeile1Y)/(15*GrundZeilenVersatzYStandart*DpiKorrektur)

ZeilenVersatzY := GrundZeilenVersatzYStandart * GrundZeilenVersatzYEich		; in Pixel
PfadNrStatischAnzahl:=Round((A_ScreenHeight - PfadNrStatisch1Y) / ZeilenVersatzY) -9
if ZackZackOrdnerLogErstellen
	ThreadUeberwachungLog(A_LineNumber-1,A_ThisHotkey,A_ThisLabel,A_ThisFunc,A_ThisMenu,A_ThisMenuItem,A_ThisMenuItemPos)


Loop, % PfadNrStatischAnzahl
{
	ThisIndexPlus1 := A_Index + 1
	ThissPfadNrStatischY := PfadNrStatisch%A_Index%Y
	Gui,1: Add,	Text	,								x90	y%ThissPfadNrStatischY% w20 h12 Right, %A_Index%
	PfadNrStatisch%ThisIndexPlus1%Y := PfadNrStatisch1Y + (ZeilenVersatzY * A_Index)
}
; Sleep 15000
; </ ------------------------------ PfadNummern links von Edit5 ins Gui --------------------------------->
gosub GuiAnfaengerModus
Edit2:=
GuiControl,1:, %HwndEdit2%, %Edit2%
if ZackZackOrdnerLogErstellen
	ThreadUeberwachungLog(A_LineNumber+1,A_ThisHotkey,A_ThisLabel,A_ThisFunc,A_ThisMenu,A_ThisMenuItem,A_ThisMenuItemPos)
gosub Edit2
ControlFocus,Edit2,ahk_id %GuiWinHwnd%
if ZackZackOrdnerLogErstellen
	ThreadUeberwachungLog(A_LineNumber+1,A_ThisHotkey,A_ThisLabel,A_ThisFunc,A_ThisMenu,A_ThisMenuItem,A_ThisMenuItemPos)
if ZackZackOrdnerLogErstellen
	ThreadUeberwachungLog(A_LineNumber+1,A_ThisHotkey,A_ThisLabel,A_ThisFunc,A_ThisMenu,A_ThisMenuItem,A_ThisMenuItemPos)
if ZackZackOrdnerLogErstellen
	ThreadUeberwachungLog(A_LineNumber+1,A_ThisHotkey,A_ThisLabel,A_ThisFunc,A_ThisMenu,A_ThisMenuItem,A_ThisMenuItemPos)
gosub BsAn
ControlGetPos,,YEdit5default,,,,ahk_id %HwndEdit5%
TitelleistenPlusMenuHoehe:= YEdit5default  - Edit5Y0
if ZackZackOrdnerLogErstellen
	ThreadUeberwachungLog(A_LineNumber-1,A_ThisHotkey,A_ThisLabel,A_ThisFunc,A_ThisMenu,A_ThisMenuItem,A_ThisMenuItemPos)
CoordMode,ToolTip Pixel Mouse Caret Menu , Client
if ZackZackOrdnerLogErstellen
	ThreadUeberwachungLog(A_LineNumber-1,A_ThisHotkey,A_ThisLabel,A_ThisFunc,A_ThisMenu,A_ThisMenuItem,A_ThisMenuItemPos)
if ZackZackOrdnerLogErstellen
	ThreadUeberwachungLog(A_LineNumber+1,A_ThisHotkey,A_ThisLabel,A_ThisFunc,A_ThisMenu,A_ThisMenuItem,A_ThisMenuItemPos)
If(SkriptDataPath="")
{
	if ZackZackOrdnerLogErstellen
		ThreadUeberwachungLog(A_LineNumber+1,A_ThisHotkey,A_ThisLabel,A_ThisFunc,A_ThisMenu,A_ThisMenuItem,A_ThisMenuItemPos)
	gosub ContainerUebersichtZeigen
}
if ZackZackOrdnerLogErstellen
	ThreadUeberwachungLog(A_LineNumber+1,A_ThisHotkey,A_ThisLabel,A_ThisFunc,A_ThisMenu,A_ThisMenuItem,A_ThisMenuItemPos)
if SpaeterKontainerAnzeigen
{
	if ZackZackOrdnerLogErstellen
		ThreadUeberwachungLog(A_LineNumber-2,A_ThisHotkey,A_ThisLabel,A_ThisFunc,A_ThisMenu,A_ThisMenuItem,A_ThisMenuItemPos)
	SpaeterKontainerAnzeigen:=false
	if ZackZackOrdnerLogErstellen
	{
		ThreadUeberwachungLog(A_LineNumber-1,A_ThisHotkey,A_ThisLabel,A_ThisFunc,A_ThisMenu,A_ThisMenuItem,A_ThisMenuItemPos)
		ThreadUeberwachungLog(A_LineNumber+1,A_ThisHotkey,A_ThisLabel,A_ThisFunc,A_ThisMenu,A_ThisMenuItem,A_ThisMenuItemPos)
	}
	gosub HauptKontainerAnzeigen
}
gosub Edit7Farbe
ControlClick,,ahk_id %HwndEdit7%
ControlClick,,ahk_id %HwndEdit2%
if ZackZackOrdnerLogErstellen
	ThreadUeberwachungLog(A_LineNumber+1,A_ThisHotkey,A_ThisLabel,A_ThisFunc,A_ThisMenu,A_ThisMenuItem,A_ThisMenuItemPos)
ScriptFullPathKlammmerInhalt:=GetKlammerInhalt(A_ScriptFullPath)
StringReplace,ScriptFullPathMain,A_ScriptFullPath,[%ScriptFullPathKlammmerInhalt%],
if ZackZackOrdnerLogErstellen
	ThreadUeberwachungLog(A_LineNumber+1,A_ThisHotkey,A_ThisLabel,A_ThisFunc,A_ThisMenu,A_ThisMenuItem,A_ThisMenuItemPos)
IfNotExist %ScriptFullPathMain%.htm		; Skript ErstStart erkannt
{
	if ZackZackOrdnerLogErstellen
		ThreadUeberwachungLog(A_LineNumber+1,A_ThisHotkey,A_ThisLabel,A_ThisFunc,A_ThisMenu,A_ThisMenuItem,A_ThisMenuItemPos)
	gosub ContainerUebersichtZeigen
	Sleep 2000
	if ZackZackOrdnerLogErstellen
		ThreadUeberwachungLog(A_LineNumber+1,A_ThisHotkey,A_ThisLabel,A_ThisFunc,A_ThisMenu,A_ThisMenuItem,A_ThisMenuItemPos)
	gosub RunTastWatch
	Sleep 2000
	if ZackZackOrdnerLogErstellen
		ThreadUeberwachungLog(A_LineNumber+1,A_ThisHotkey,A_ThisLabel,A_ThisFunc,A_ThisMenu,A_ThisMenuItem,A_ThisMenuItemPos)
	gosub Hilfe
	sleep 20000
	if ZackZackOrdnerLogErstellen
		ThreadUeberwachungLog(A_LineNumber+1,A_ThisHotkey,A_ThisLabel,A_ThisFunc,A_ThisMenu,A_ThisMenuItem,A_ThisMenuItemPos)
	; deaktiviert ; MsgBox, 262436, AutoStart, moechten Sie`, dass die OrdnerUnterstuezung nach der Anmeldung automatisch startet?
		return
}
if ZackZackOrdnerLogErstellen
	ThreadUeberwachungLog(A_LineNumber+1,A_ThisHotkey,A_ThisLabel,A_ThisFunc,A_ThisMenu,A_ThisMenuItem,A_ThisMenuItemPos)
IfWinNotExist,ahk_exe TastWatch.exe
{
	if ZackZackOrdnerLogErstellen
		ThreadUeberwachungLog(A_LineNumber+1,A_ThisHotkey,A_ThisLabel,A_ThisFunc,A_ThisMenu,A_ThisMenuItem,A_ThisMenuItemPos)
	gosub RunTastWatch
}
ThreadUeberwachungLog(A_LineNumber+1,A_ThisHotkey,A_ThisLabel,A_ThisFunc,A_ThisMenu,A_ThisMenuItem,A_ThisMenuItemPos)
gosub KontainerAnzeigen
if ZackZackOrdnerLogErstellen
	ThreadUeberwachungLog(A_LineNumber+1,A_ThisHotkey,A_ThisLabel,A_ThisFunc,A_ThisMenu,A_ThisMenuItem,A_ThisMenuItemPos)
if ZackZackOrdnerLogErstellen
	ThreadUeberwachungLog(A_LineNumber+1,"vor OnMessage " A_ThisHotkey,A_ThisLabel,A_ThisFunc,A_ThisMenu,A_ThisMenuItem,A_ThisMenuItemPos)
OnMessage(0x4a, "Empfange_WM_COPYDATA")  ; 0x4a ist WM_COPYDATA
if ZackZackOrdnerLogErstellen
	ThreadUeberwachungLog(A_LineNumber-1,"vor OnMessage " A_ThisHotkey,A_ThisLabel,A_ThisFunc,A_ThisMenu,A_ThisMenuItem,A_ThisMenuItemPos)
gosub StartPfadAenderung
gosub SitzungsEinstellungenBeiScriptStartEinlesen
if GuiNachHochfahrenMinimieren
{
	GuiNachHochfahrenMinimieren:=false
	if ZackZackOrdnerLogErstellen
	{	
		ThreadUeberwachungLog(A_LineNumber-1,A_ThisHotkey,A_ThisLabel,A_ThisFunc,A_ThisMenu,A_ThisMenuItem,A_ThisMenuItemPos)
		ThreadUeberwachungLog(A_LineNumber+1,A_ThisHotkey,A_ThisLabel,A_ThisFunc,A_ThisMenu,A_ThisMenuItem,A_ThisMenuItemPos)
	}
	gosub F4
}
gosub F5
sleep 500
ControlFocus,Edit2,ahk_id %GuiWinHwnd%
return	; ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^Ende des automatischen Ausfuhreungsbereiches^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
; < / ######################################################### Ende Haupt-Programm ######################################################	 @0199
Empfange_WM_COPYDATA(wParam, lParam)
{
	global FuerEdit1, FuerEdit2, FuerEdit3, FuerEdit4, FuerEdit5, FuerEdit6, FuerEdit7, FuerEdit8, FuerEdit9,Datenkopie
    Stringadresse := NumGet(lParam + 2*A_PtrSize)  ; Ermittelt die Adresse des lpData-Elements in CopyDataStruct.
    Datenkopie := StrGet(Stringadresse)  ; Kopiert den String aus der Struktur.
	if ZackZackOrdnerLogErstellen
		ThreadUeberwachungLog(A_LineNumber-1,A_ThisHotkey,A_ThisLabel,A_ThisFunc,A_ThisMenu,A_ThisMenuItem,A_ThisMenuItemPos)
    ; Zeige ihn via ToolTip statt MsgBox an, so dass wir rechtzeitig fertig werden:
    ; ToolTip %A_ScriptName%`nhat den folgenden String empfangen:`n%Datenkopie%
	SetTimer ,TimerEditUebernahme,-1
	if ZackZackOrdnerLogErstellen
		ThreadUeberwachungLog(A_LineNumber-1,A_ThisHotkey,A_ThisLabel,A_ThisFunc,A_ThisMenu,A_ThisMenuItem,A_ThisMenuItemPos)
    return true  ; Die Rückgabe einer 1 (wahr) ist der übliche Weg, um diese Nachricht zu bestätigen.
}
if ZackZackOrdnerLogErstellen
	ThreadUeberwachungLog(A_LineNumber-1,A_ThisHotkey,A_ThisLabel,A_ThisFunc,A_ThisMenu,A_ThisMenuItem,A_ThisMenuItemPos)
OnMessage(0x201, "WM_LBUTTONDOWN")
if ZackZackOrdnerLogErstellen
	ThreadUeberwachungLog(A_LineNumber-1,A_ThisHotkey,A_ThisLabel,A_ThisFunc,A_ThisMenu,A_ThisMenuItem,A_ThisMenuItemPos)
IfExist %SkriptDataPath%					; SkriptDataPath=%A_AppDataCommon%\Zack
{
	OrdnerEingelesen:=true
	if ZackZackOrdnerLogErstellen
		ThreadUeberwachungLog(A_LineNumber-1,A_ThisHotkey,A_ThisLabel,A_ThisFunc,A_ThisMenu,A_ThisMenuItem,A_ThisMenuItemPos)
}
return
; < #################################### globale Hotkeys HotStrings ########################################## >	@0210
PlusSternClipPfade:
MaxAnzClipPfade:=10
RueckFrageAbAnzClipPfade:=8
goto WindowsN		; ist hier notwendig, da Skript sonst bei naechster Zeile aufhoert.
#*::				; Pfade im ClipBoard zu den Favoriten hinzufuegen
WindowsN:			; Pfade im ClipBoard zu den Favoriten hinzufuegen
if (RueckFrageAbAnzClipPfade="")
	RueckFrageAbAnzClipPfade:=10
ClipKopie:=Clipboard
StringSplit,ClipZeile,ClipKopie,`n,`r
if(ClipZeile0 > 10)
	ClipZeilenRestSymbolisch:="..."
else
	ClipZeilenRestSymbolisch:=
if(ClipZeile0 > RueckFrageAbAnzClipPfade) ; ,FehlerAnzeige:="MsgBox" ,FehlerSuche(A_LineNumber,ClipZeile0,RueckFrageAbAnzClipPfade)
{
	IfExist %ClipKopie%
		MsgBox, 262180, Clip2Fav, 		%ClipKopie%`nals Favorit einlesen
	else
		MsgBox, 262436, Clip2Fav, Das Clipboard enthaelt %ClipZeile0% Zeilen`,`nsollen diese wirklich als Favoriten eingelesen werden?`n		Ja`n		Nein	(Default)`n`n%ClipZeile1%`n%ClipZeile2%`n%ClipZeile3%`n%ClipZeile4%`n%ClipZeile5%`n%ClipZeile6%`n%ClipZeile7%`n%ClipZeile8%`n%ClipZeile9%`n%ClipZeile10%`n%ClipZeilenRestSymbolisch%
	RueckFrageAbAnzClipPfade:=
	IfMsgBox,No
		return
	IfMsgBox,Cancel
		return
	IfMsgBox,Abort
		return	
}
FavPlusZaehler:=0
Loop, % ClipZeile0
{
	ThisClipZeile:=ClipZeile%A_Index%
	if(ThisClipZeile<>"")
	{
		ifexist %ThisClipZeile%
			{
				Edit8:=ThisClipZeile
				gosub Edit8Festigen
				AnzeigeNichtAktualisieren:=true
				gosub PlusStern
				AnzeigeNichtAktualisieren:=false
			}
		else
		{
			MsgBox, 262435, Clip2Fav, soll`n`n%ThisClipZeile%`n`nals Favorit eingelesen werden?
			IfMsgBox,Yes
			{
				Edit8:=ThisClipZeile
				gosub Edit8Festigen
				AnzeigeNichtAktualisieren:=true
				gosub PlusStern
				AnzeigeNichtAktualisieren:=false
			}
			else IfMsgBox,Cancel
				return
		}
		++FavPlusZaehler
	}
}
TrayTip,Clip2Fav,%FavPlusZaehler% Anforderungen bearbeitet.,3
Loop, % ClipZeile0
	ClipZeile%A_Index%:=
return
#v::
Menu, ClipboardMenu, Show  
return
#n::	; AutoPop Ersatz
gosub OpenGuiNebenAktWin
if MausGuenstigPositionieren
	MouseMove,A_CaretX+90*DpiKorrektur,A_CaretY+9*DpiKorrektur
return
#ä::	; fuer Fehlersuche gibt mehr Meldungen aus
Fehlersuche:=true
return
#ß::	; Fehlersuche ListLines
ListLines
return
:*:*§*::°	; HotString: gibt bei Eingabe von *§* den ZackZack-intern in Speichernamen dafuer verwendeten ° aus
:*:\§\::►	; HotString: gibt bei Eingabe von \§\ den ZackZack-intern in Speichernamen dafuer verwendeten ► aus
:?::§::	; HotString: gibt bei Eingabe von :§: den ZackZack-intern in Speichernamen dafuer verwendeten hochgestellten Doppelpunkt ˸ aus 
if (A_EndChar=DotOverDot)
	send ˸
return
#z::	; hole minimiertes Fenster.	Hinweis: Bewirkt nicht das Gleiche wie Button Ordner oder #n.
gosub SelfActivate
if MausGuenstigPositionieren
	MouseMove,A_CaretX+90,A_CaretY+9
return
; < / ################################## globale Hotkeys HotStrings ########################################## >
Edit4:		;	@0264										; Befehlsentgegennahme. wirkt mit . am Ende wie eine MacroZeile
HwndEdit4:
Gui,1:Submit,NoHide
if(SubStr(Edit4,0)=".")
{
	StringTrimRight,Edit4,Edit4,1
	GuiControl,1:, %HwndEdit4%, %Edit4%
	Datenkopie:=Edit4
}
else
	return
TimerEditUebernahme:						; Warten auf eingehende Befehle von Tastatur, Datei oder Variable. Ist kein Timer mehr.
BeschaeftigtAnzeige(1)
; < KurzBefehle Uebersicht >
; #		->	Edit3						[1:9]								Die # landet in der Nummern-Auswahl (Edit4) 
; #*		wie		e#*
; b#	->	Buttonclick					b[1:5]								Der Button mit der Nummer # wird gedrueckt
; c?#	->	Checkbox					c[a|b|c|d|e|f|g|h|j|k]][0:9][0||1]	Die Checkbox mit der ID aus einem Buchstabe und # wird gehakt 1 oder enthkt 0
; e#*	->	Edit	* = Freitext		e[1:9]*								Das Edit mit der Nummer # wird mit dem Text * befuellt.
; ?:*	->	neuer StartPfad				?[LaufwerksBuchstabe]*[\OrdnerPfad]
; \\*	->	neuer StartPfad				*[Netzwerk-Feigabe]
; awpf*	->	neues StartPfadMuster		*[LaufwerksBuchstabe:\OrdnerPfad\*|\\Netzwerk-Feigabe\*]		\*[Belibige_Buchstaben_Bagslash_Stern_Kombination]	Wird ungeprueft als StartPfadMuster an   Menue: Start-Pfad | einlesen   uebergeben
; andere->	Edit2						*{rest}								Die Suche also Edit2 wird mit * befuellt (* ohne denen die ddrueber herausgefidcht wurden)
; *:=?									* ist ein VariablenName	? ist keine Wildcard 	gibt Variable in Edit4 aus
; *:=?#									* ist ein VariablenName	? ist keine Wildcard 	gibt Variable in Edit# aus
; < / KurzBefehle Uebersicht >
; *:=*									Beispiel: VarA:=VarB							setzt Variable
; *=String								Beispiel: VarA=Hosentraeger						setzt Variable
	DieseDatenkopieMehrzeilig:=Datenkopie
	Loop,Parse,DieseDatenkopieMehrzeilig,`n,`r
	{
	DieseDatenkopie:=A_LoopField
	if Fehlersuche
		TrayTip,Zack empfaengt,>%DieseDatenkopie%<
	EinmalKopieDieseDatenkopie:=DieseDatenkopie
	LaengeDieseDatenkopie:=StrLen(DieseDatenkopie)
	ErstesZeichenDieseDatenkopie:=SubStr(DieseDatenkopie,1,1)
		ErstesZeichenDieseDatenkopieIstGueltigerLaufwerksBuchstabe:=false
	If ErstesZeichenDieseDatenkopie in %DriveNamesKommaList%
		ErstesZeichenDieseDatenkopieIstGueltigerLaufwerksBuchstabe:=true
	IntegerErstesZeichenDieseDatenkopie:=false
	if ErstesZeichenDieseDatenkopie is Integer
		IntegerErstesZeichenDieseDatenkopie:=true
	ZweitesZeichenDieseDatenkopie:=SubStr(DieseDatenkopie,2,1)
	InAbcListeZweitesZeichenDieseDatenkopie:=false
	if ZweitesZeichenDieseDatenkopie in a,b,c,d,e,f,g,h,i,j,k,l
		InAbcListeZweitesZeichenDieseDatenkopie:=true
	IntegerZweitesZeichenDieseDatenkopie:=false
	if ZweitesZeichenDieseDatenkopie is Integer
		IntegerZweitesZeichenDieseDatenkopie:=true
	DrittesZeichenDieseDatenkopie:=SubStr(DieseDatenkopie,3,1)
	ViertesZeichenDieseDatenkopie:=SubStr(DieseDatenkopie,4,1)
	IntegerDrittesZeichenDieseDatenkopie:=false
	if DrittesZeichenDieseDatenkopie is Integer
		IntegerDrittesZeichenDieseDatenkopie:=true
	EinstelligDieseDatenkopie:=false
	if(LaengeDieseDatenkopie=1)
	{
		EinstelligDieseDatenkopie:=true
		IntegerDieseDatenkopie:=false
		if DieseDatenkopie is Integer
			IntegerDieseDatenkopie:=true
	}	
	if(ErstesZeichenDieseDatenkopie="§")	; FunktionsAufruf erkannt
	{
		StringTrimLeft,FurDieseFunktion,DieseDatenkopie,1
		StringSplit,DieseFunktionParameter,FurDieseFunktion,§,%A_Space%
		if(DieseFunktionParameter1<>"")
			DieseFunktionsZuweisungsVariable:=DieseFunktionParameter1
		if(DieseFunktionParameter2<>"")
			DieseFunktion:=DieseFunktionParameter2
		else
		{
			TrayTip, BefehlsSysntax Fehler, FunktionsName fehlt!
			BeschaeftigtAnzeige(-1)
			return
		}
		If (DieseFunktionParameter0=2)
		{
			if(DieseFunktionsZuweisungsVariable="")
				{
				If(IsFunc(DieseFunktion))
				{
					Dummy:=%DieseFunktion%()
					BeschaeftigtAnzeige(-1)
					return
				}
			}
			else
			{
				If(IsFunc(DieseFunktion))
				{
					%DieseFunktionsZuweisungsVariable%:=%DieseFunktion%()
					BeschaeftigtAnzeige(-1)
					return
				}
			}
		}
		else If (DieseFunktionParameter0=3)
		{
			if(DieseFunktionsZuweisungsVariable="")
				{
				If(IsFunc(DieseFunktion))
				{
					Dummy:=%DieseFunktion%(FunktionUeberGabestringErzeugen(DieseFunktionParameter3))
					BeschaeftigtAnzeige(-1)
					return
				}
			}
			else
			{
				If(IsFunc(DieseFunktion))
				{
					%DieseFunktionsZuweisungsVariable%:=%DieseFunktion%(FunktionUeberGabestringErzeugen(DieseFunktionParameter3))
					BeschaeftigtAnzeige(-1)
					return
				}
			}
		}
		else If (DieseFunktionParameter0=4)
		{
			if(DieseFunktionsZuweisungsVariable="")
				{
				If(IsFunc(DieseFunktion))
				{
					Dummy:=%DieseFunktion%(FunktionUeberGabestringErzeugen(DieseFunktionParameter3),FunktionUeberGabestringErzeugen(DieseFunktionParameter4))
					BeschaeftigtAnzeige(-1)
					return
				}
			}
			else
			{
				If(IsFunc(DieseFunktion))
				{
					%DieseFunktionsZuweisungsVariable%:=%DieseFunktion%(FunktionUeberGabestringErzeugen(DieseFunktionParameter3),FunktionUeberGabestringErzeugen(DieseFunktionParameter4))
					BeschaeftigtAnzeige(-1)
					return
				}
			}
		}
		else If (DieseFunktionParameter0=5)
		{
			if(DieseFunktionsZuweisungsVariable="")
				{
				If(IsFunc(DieseFunktion))
				{
					Dummy:=%DieseFunktion%(FunktionUeberGabestringErzeugen(DieseFunktionParameter3),FunktionUeberGabestringErzeugen(DieseFunktionParameter4),FunktionUeberGabestringErzeugen(DieseFunktionParameter5))
					BeschaeftigtAnzeige(-1)
					return
				}
			}
			else
			{
				If(IsFunc(DieseFunktion))
				{
					%DieseFunktionsZuweisungsVariable%:=%DieseFunktion%(FunktionUeberGabestringErzeugen(DieseFunktionParameter3),FunktionUeberGabestringErzeugen(DieseFunktionParameter4),FunktionUeberGabestringErzeugen(DieseFunktionParameter5))
					BeschaeftigtAnzeige(-1)
					return
				}
			}
		}
		else If (DieseFunktionParameter0=6)
		{
			if(DieseFunktionsZuweisungsVariable="")
				{
				If(IsFunc(DieseFunktion))
				{
					Dummy:=%DieseFunktion%(FunktionUeberGabestringErzeugen(DieseFunktionParameter3),FunktionUeberGabestringErzeugen(DieseFunktionParameter4),FunktionUeberGabestringErzeugen(DieseFunktionParameter5),FunktionUeberGabestringErzeugen(DieseFunktionParameter6))
					BeschaeftigtAnzeige(-1)
					return
				}
			}
			else
			{
				If(IsFunc(DieseFunktion))
				{
					%DieseFunktionsZuweisungsVariable%:=%DieseFunktion%(FunktionUeberGabestringErzeugen(DieseFunktionParameter3),FunktionUeberGabestringErzeugen(DieseFunktionParameter4),FunktionUeberGabestringErzeugen(DieseFunktionParameter5),FunktionUeberGabestringErzeugen(DieseFunktionParameter6))
					BeschaeftigtAnzeige(-1)
					return
				}
			}
		}
		else If (DieseFunktionParameter0=7)
		{
			if(DieseFunktionsZuweisungsVariable="")
				{
				If(IsFunc(DieseFunktion))
				{
					Dummy:=%DieseFunktion%(FunktionUeberGabestringErzeugen(DieseFunktionParameter3),FunktionUeberGabestringErzeugen(DieseFunktionParameter4),FunktionUeberGabestringErzeugen(DieseFunktionParameter5),FunktionUeberGabestringErzeugen(DieseFunktionParameter6),FunktionUeberGabestringErzeugen(DieseFunktionParameter7))
					BeschaeftigtAnzeige(-1)
					return
				}
			}
			else
			{
				If(IsFunc(DieseFunktion))
				{
					%DieseFunktionsZuweisungsVariable%:=%DieseFunktion%(FunktionUeberGabestringErzeugen(DieseFunktionParameter3),FunktionUeberGabestringErzeugen(DieseFunktionParameter4),FunktionUeberGabestringErzeugen(DieseFunktionParameter5),FunktionUeberGabestringErzeugen(DieseFunktionParameter6),FunktionUeberGabestringErzeugen(DieseFunktionParameter7))
					BeschaeftigtAnzeige(-1)
					return
				}
			}
		}
		else If (DieseFunktionParameter0 > 7)
		{
			MsgBox, 262144,%A_ScriptName% at %A_LineNumber% ,Dieser Funktionsaufruf wird Prinzipiell unterstutzt, ist momentan aber noch nicht ausformuliert. Dies ist in der Gegend von der Quelltext-Zeile %A_LineNumber% von  %A_ScriptFullPath% nachzutragen. `n`nDieser Thread endet hier.
			BeschaeftigtAnzeige(-1)
			return
		}
	}
	else if(InStr(DieseDatenkopie,":=?"))
	{
		LastZeichen:=SubStr(DieseDatenkopie,0)
		if (LastZeichen="?")
		{
			DieseVariable2:=SubStr(DieseDatenkopie,1,-3)
			Transform, DieseVariableDeref, Deref, %DieseVariable2% 
			Edit4:=%DieseVariableDeref%
			GuiControl,1:,%HwndEdit4%,%Edit4%
		}
		Else if LastZeichen is Integer
		{
			DieseVariable2:=SubStr(DieseDatenkopie,1,-4)
			Transform, DieseVariableDeref, Deref, %DieseVariable2% 
			Edit%LastZeichen%:=%DieseVariableDeref%
			GuiControl,1:,% HwndEdit%LastZeichen%,% Edit%LastZeichen%
		}
	}
	else if(InStr(DieseDatenkopie,":="))	; Variablen Zuweisung mit := erkannt
	{
		StringReplace,DieseDatenkopieDotOverDotGleich,DieseDatenkopie,:=,%A_Tab%,All
		StringSplit,DieseVariable,DieseDatenkopieDotOverDotGleich,%A_Tab%,%A_Space%
		If (DieseVariable0=2)
		{
			if (DieseVariable2="")
			{
				%DieseVariable1%:=
			}
			else if if (DieseVariable1="")
			{
			}
			else
			{
				if(InStr(DieseVariable2,"%"))
				{
					Transform, DieseVariable2Deref, Deref, %DieseVariable2% 
					%DieseVariable1% := DieseVariable2Deref
				}
				else
				{
					%DieseVariable1% :=	%DieseVariable2%
				}
			}
			GuiControl,1:, %DieseVariable1%, %SuperDieseVariable1%
		}
	}
	else if(InStr(DieseDatenkopie,"="))	; Variablen Zuweisung mit = erkannt
	{
		StringSplit,DieseVariable,DieseDatenkopie,=,%A_Space%
		If (DieseVariable0=2)
		{
			if (DieseVariable2="")
			{
				%DieseVariable1%:=
			}
			else if if (DieseVariable1="")
			{
			}
			else
			{
				if(InStr(DieseVariable2,"%"))
				{
					Transform, DieseVariable2Deref, Deref, %DieseVariable2% 
					DieseVariable2:=DieseVariable2Deref
				}
				%DieseVariable1% := DieseVariable2
			}
			GuiControl,1:, %DieseVariable1%, %DieseVariable2%
		}
	}
	else if((ZweitesZeichenDieseDatenkopie=":") and ErstesZeichenDieseDatenkopieIstGueltigerLaufwerksBuchstabe)	; LaufwerksBuchstabe gefolgt von : also Laufwerks Start-Pfad einlesen erkannt
	{					; ?:*	?[LaufwerksBuchstabe]*[\OrdnerPfad]
		LastSkriptDataPath:=SkriptDataPath
		If (ThisContainer="")
			ThisContainer:=SkriptDataPath
		else
		{
			if(InStr(ThisContainer,WurzelContainer))
				ThisContainer:=ThisContainer
			else
				ThisContainer=%WurzelContainer%\%ThisContainer%
			IfNotExist %SkriptDataPathTemp%
			{
				FileCreateDir,  %ThisContainer%
			}
		}
		IfExist % FuehrendeSterneEntfernen(ThisContainer)
		{
			SkriptDataPath:=ThisContainer
			NeueWurzel:=DieseDatenkopie 
			NeueWurzel0:=1
			gosub NeueWurzelHinzufuegenBeiVorhandenemWurzelName
		}
	}
	else if((ZweitesZeichenDieseDatenkopie="\") and ErstesZeichenDieseDatenkopie="\")	; \\  also Freigabe Start-Pfad einlesen erkannt 
	{				; ?:*	?[LaufwerksBuchstabe]*[\OrdnerPfad]
		LastSkriptDataPath:=SkriptDataPath
		If (ThisContainer="")
			ThisContainer:=SkriptDataPath
		else
		{
			if(InStr(ThisContainer,WurzelContainer))
				ThisContainer:=ThisContainer
			else
				ThisContainer=%WurzelContainer%\%ThisContainer%
			IfNotExist %SkriptDataPathTemp%
			{
				FileCreateDir,  %ThisContainer%
			}
		}
		IfExist % FuehrendeSterneEntfernen(ThisContainer)
		{
			SkriptDataPath:=ThisContainer
			gosub KontainerAnzeigen
			NeueWurzel:=DieseDatenkopie 
			NeueWurzel0:=1
			gosub NeueWurzelHinzufuegenBeiVorhandenemWurzelName
		}
	}
	else if(LaengeDieseDatenkopie=1 and IntegerDieseDatenkopie)					; Edit3:=#
	{	
		; StringTrimLeft,RestlicheZeichenDieseDatenkopie,DieseDatenkopie,1
		Edit3:=DieseDatenkopie
		GuiControl,1:, %HwndEdit3%, %Edit3%
	}
	else if(IntegerErstesZeichenDieseDatenkopie)	; Set Edit# Feld Variante 1 erkannt
	{							; Edit#:=*
		StringTrimLeft,RestlicheZeichenDieseDatenkopie,DieseDatenkopie,1
		ThhisHwndEditName:=HwndEdit%ErstesZeichenDieseDatenkopie%
		Edit%ErstesZeichenDieseDatenkopie%:=RestlicheZeichenDieseDatenkopie
		GuiControl,1:, %ThhisHwndEditName%, %RestlicheZeichenDieseDatenkopie%
		if Fehlersuche
			TrayTip,Edit%ErstesZeichenDieseDatenkopie%,%RestlicheZeichenDieseDatenkopie%
	}
	else if(LaengeDieseDatenkopie=2 and ErstesZeichenDieseDatenkopie="b" and IntegerZweitesZeichenDieseDatenkopie)	; Buttonklick erkannt
	{	; gosub Button#
		If(IsLabel("HwndButton" ZweitesZeichenDieseDatenkopie))
			gosub HwndButton%ZweitesZeichenDieseDatenkopie%
		else If(IsLabel("Button" ZweitesZeichenDieseDatenkopie))
			gosub Button%ZweitesZeichenDieseDatenkopie%
		else
		if Fehlersuche
			TrayTip,Button,%ZweitesZeichenDieseDatenkopie%     	gedrueckt   `n`n gosub  HwndButton%ZweitesZeichenDieseDatenkopie%
	}
	else if(LaengeDieseDatenkopie=4 and ErstesZeichenDieseDatenkopie="c" and InAbcListeZweitesZeichenDieseDatenkopie and IntegerDrittesZeichenDieseDatenkopie) ; Set Checkbox erkannt
	{ ; Checkboxen
		ThhisHwndCheck=HwndHwndCheck%ZweitesZeichenDieseDatenkopie%%DrittesZeichenDieseDatenkopie%
		if(IsLabel(ThhisHwndCheck))
		{
			gosub %ThhisHwndCheck%
		}
		else
		{
		}
	}
	else if(							ErstesZeichenDieseDatenkopie="e" and IntegerZweitesZeichenDieseDatenkopie)	; Set Edit# Feld Variante 2 erkannt
	{
		StringTrimLeft,RestlicheZeichenDieseDatenkopie,DieseDatenkopie,2
		ThhisHwndEditName=HwndEdit%ZweitesZeichenDieseDatenkopie%
		if(IsLabel(ThhisHwndEditName))
		{
			superThhisHwndEditName:=%ThhisHwndEditName%
			Edit%ZweitesZeichenDieseDatenkopie%:=RestlicheZeichenDieseDatenkopie
			GuiControl,1:, %superThhisHwndEditName%, %RestlicheZeichenDieseDatenkopie%
		}
		else	; suchfeld also Edit2 befuellen erkannt
		{
		}
	}
	else if(IsLabel(DieseDatenkopie))
		gosub %DieseDatenkopie%
	else
	{
		Edit2:=DieseDatenkopie
		GuiControl,1:, %HwndEdit2%, %Edit2%
	}
}
BeschaeftigtAnzeige(-1)
return
HwndHwndCheckE0:
SuFi:=ViertesZeichenDieseDatenkopie
GuiControl,1:,%HwndCheckE0%, %ViertesZeichenDieseDatenkopie%
return
HwndHwndCheckE5:
RegEx:=ViertesZeichenDieseDatenkopie
GuiControl,1:,%HwndCheckE5%, %ViertesZeichenDieseDatenkopie%
return
dummy:=
return
LeseEin:
Gui,1:Submit,NoHide
If LeseEin
{
}	
else
		IndexierenBeenden:=True
return
EinstellungenLaden:
return
EinstellungenSichern:
return
AuswahlGuiAnzeigeFortgeschritten:
if GuiAnzeigeFortgeschritten
	gosub GuiFortegeschrittenenerModus
else
	gosub GuiAnfaengerModus
return
GuiFortegeschrittenenerModus:
GuiControl,1:Show,Rückgabeopt
GuiControl,1:Show,..\
GuiControl,1:Show,<--
GuiControl,1:Show,ok
GuiControl,1:Show,Abbruch
GuiControl,1:Show,Suche vom
GuiControl,1:Show,WortAnfang
GuiControl,1:Show,Edit6
GuiControl,1:Show,AutoPop
GuiControl,1:Show,ExpSel
GuiControl,1:Show,Edit4
GuiControl,1:Show,Abbruchnach
GuiControl,1:Show,Iterationen
GuiControl,1:Show,Fenster
GuiControl,1:Show,RegEx
GuiControl,1:Show,OnTop
GuiControl,1:Show,Akt
GuiControl,1:Show,Min
GuiControl,1:Show,Pfade einlesen
GuiControl,1:Show,Rekursiv
GuiControl,1:Show,Pfadeeinlesen
GuiControl,1:Show,Anzeige im`nFeld rechts
GuiControl,1:Show,zeige Inhalte √`noder Pfade
return
return
GuiAnfaengerModus:
GuiControl,1:Hide,Rückgabeopt
GuiControl,1:Hide,..\
GuiControl,1:Hide,<--
GuiControl,1:Hide,ok
GuiControl,1:Hide,Abbruch
GuiControl,1:Hide,Suche vom
GuiControl,1:Hide,WortAnfang
GuiControl,1:Hide,Edit6
GuiControl,1:Hide,AutoPop
GuiControl,1:Hide,ExpSel
GuiControl,1:Hide,Edit4
GuiControl,1:Hide,Abbruchnach
GuiControl,1:Hide,Iterationen
GuiControl,1:Hide,Fenster
GuiControl,1:Hide,RegEx
GuiControl,1:Hide,OnTop
GuiControl,1:Hide,Akt
GuiControl,1:Hide,Min
GuiControl,1:Hide,Pfade einlesen
GuiControl,1:Hide,Rekursiv
GuiControl,1:Hide,Pfadeeinlesen
GuiControl,1:Hide,Anzeige im`nFeld rechts
GuiControl,1:Hide,zeige Inhalte √`noder Pfade
return
		; MsgBox % DriveNames
			; OrdnerPfade("Indizieren", A_LoopField ":\*")
RechsClickAufControl:
if A_GuiControl is integer
{
	Edit3:=A_GuiControl
	GuiControl,1:, Edit3, %Edit3%
	gosub Edit3
	gosub Button4
}
return
GuiSize:
	WinGetPos,DieseThisX,DieseThisY,DieseThisB,DieseThisH,ahk_id %GuiWinHwnd%
	Rahmenbreite:=4
	GuiYAbzuziehen := DieseThisH/DpiKorrektur - A_GuiHeight -2*Rahmenbreite/DpiKorrektur

	; GuiYAbzuziehen := (DieseThisH /DpiKorrektur - A_GuiHeight/DpiKorrektur -(2*Rahmenbreite)/DpiKorrektur )
	; ToolTip % DieseThisH "	1	" A_GuiHeight "	2	" 2*Rahmenbreite "	3	" DpiKorrektur "	4	" GuiYAbzuziehen	"	5	" Edit5Y0
	; ToolTip GuiYAbzuziehen=%GuiYAbzuziehen%
	RegExBeratungsFormularXPos:=DieseThisX+DieseThisB
If (A_EventInfo=1)
{
	ControlGetPos,,YEdit5default,,,,ahk_id %HwndEdit5%
	TitelleistenPlusMenuHoehe:= YEdit5default  - Edit5Y0
	LastThisActiveOpenOrSaveWinWND:=ThisActiveOpenOrSaveWinWND
	ThisActiveHWND:=WinExist("A") 
	ThisOpenOrSaveWinWND:=WinExist("ahk_class #32770") 
	if (ThisActiveHWND=ThisOpenOrSaveWinWND)
		ThisActiveOpenOrSaveWinWND:=ThisOpenOrSaveWinWND
	if OnTop
		WinSet, AlwaysOnTop,on,,ahk_id %GuiWinHwnd%
	If ((A_TickCount-GuiMinizeTime < 200) and GuiMinizeTime<>"")
	{
		UserMinimized:=false
		ScriptMinimized:=true	
		ScriptMinimizedTime:=A_TickCount
	}
	else
	{
		UserMinimizedTime:=A_TickCount
		UserMinimized:=true
		ScriptMinimized:=false
	}
	If (GuiMinizeTime="")
		GuiMinizeTime=0
	if (ScriptMinimizedTime < UserMinimizedTime)
	{
		LastScriptMinimizedUser:=true
	}
	else
		LastScriptMinimizedUser:=false
}
If Fehlersuche
	TrayTip,A_EventInfo,% A_EventInfo " seit delta " A_TickCount-GuiMinizeTime "	LastOpenOrSaveWinHwnd " LastOpenOrSaveWinHwnd "	DeltaLastGuiMinizeTime " DeltaLastGuiMinizeTime
NeueBreite := A_GuiWidth - 4
NeueHoehe := A_GuiHeight - 20
GuiSetSize:
GuiHeight:=A_GuiHeight
Edit5Breite:=NeueBreite-122
Edit5Breite20:=Edit5Breite -20
Edit5Breite100:=Edit5Breite -100
Edit5Breite105:=Edit5Breite100 -5 +122
Edit5Hoehe:=NeueHoehe-126
GuiControl,1: Move, Edit8, 	w%A_GuiWidth%
gosub IeControl
GuiControl,1: Move, Edit5UpDown, 		h%Edit5Hoehe%
GuiControl,1: Move, Edit4, 	x%Edit5Breite105%
GuiControl,1: Move, Edit2, 					w%Edit5Breite100% 
GuiControl,1: Move, Edit10, y%NeueHoehe%	w%Edit5Breite%				
ControlFocus,Edit2,ahk_id %GuiWinHwnd%
return
Rekursiv:
Gui,1:Submit,NoHide
if Rekur
	Rekursiv=R
else
	Rekursiv=
return
ExpSel:
Gui,1:Submit,NoHide
return
IfActiveWinTextOneOf(WinText*)
{
	AnzParam:=WinText.MaxIndex()
	WinGetText,ThisWinText,A
	MsgBox WinText[A_Index]
	Loop, % AnzParam
	{
		if (Instr(ThisWinText,WinText[A_Index]))
			return 1
	}
	return 0
}
AWinTitle(WinTitle*)
{
	AnzParam:=WinTitle.MaxIndex()
	WinGetTitle,ThisWinTitle,A	
	Loop, % AnzParam-1
	{
		if (Instr(ThisWinTitle,WinTitle[A_Index]))
		{
			return 1
		}
	}
	return 0
}
OpenGuiNebenAktWin:
	ThisActiveHWND:=WinExist("A") 
	ThisAufmerksamkeitHWND:=ThisActiveHWND
	WinGetPos,FremdFensterX,FremdFensterY,FremdFensterB,FremdFensterH,ahk_id %ThisAufmerksamkeitHWND%
	GuiControl,1: +Default, %HwndButton2%				
	gosub IfMainGuiMinRestore
	Gui,1:Submit,NoHide
	WinGetPos,EigenFensterX,EigenFensterY,EigenFensterB,EigenFensterH,ahk_id %GuiWinHwnd%
	WinMove,ahk_id %GuiWinHwnd%,, EigenFensterX,  EigenFensterY,510*DpiKorrektur,482*DpiKorrektur								; Wingroesse begrenzen
	WinGetPos,EigenFensterX,EigenFensterY,EigenFensterB,EigenFensterH,ahk_id %GuiWinHwnd%
	If ((FremdFensterX < EigenFensterX) and (EigenFensterX < FremdFensterX+FremdFensterB) and (FremdFensterX + FremdFensterB + EigenFensterB <=A_ScreenWidth))
	{
		WinMove,ahk_id %GuiWinHwnd%,, FremdFensterX+FremdFensterB,  EigenFenstery
	}
	else If ((FremdFensterY < EigenFensterY) and (EigenFensterY < FremdFensterY+FremdFensterH) and (FremdFensterY + FremdFensterH + EigenFensterH <=A_ScreenHeight))
	{
		WinMove,ahk_id %GuiWinHwnd%,, EigenFensterX,  FremdFensterY+FremdFensterH 
	}
	gosub SelfActivate
	; gosub IfMainGuiMinRestore
	ControlFocus,Edit2,ahk_id %GuiWinHwnd%
return
SuperFaVoritenEinfuehrung:
if not AufgerufenSuperFaVoritenBearbeiten
				MsgBox, 262144, SuperFavoriten, SuperFavoriten sind Container-unabhaengige schnell erreichbare Favoriten`,`ndie uebers Haupt-Menue rechts aufrufbar sind.`nBitte beim Bearbeiten die Leerzeile oben drinn lassen.`n`nAenderungen sind erst nach einem ZZO Neustart im Menue rechts sichtbar. 
AufgerufenSuperFaVoritenBearbeiten:=true
return
SortBS:			; Sortieren nach dem Ordnername ohne Pfad
sort,Edit5,U \		
gosub Edit5Festigen
return
SortR:			; Sortierung Alphabetisch z...a
sort,Edit5,U R
gosub Edit5Festigen
return
SortLen:		; Sortieren nach StrLen
sort,Edit5,F NachStrLen
gosub Edit5Festigen
return
NachStrLen(a,b)
{
	if (StrLen(a)>StrLen(b))
		return 1
	else if (StrLen(a)=StrLen(b))
		return 0
	else
		return -1
}
GetAbPos(ZeilenText,ZeilenNummer)
{
	Len:=0
	Loop, Parse,ZeilenText,`n,`r
	{
		AbPos:=Len
		if(A_Index>=ZeilenNummer)
			break
		Len+=StrLen(A_LoopField)+2
	}
	if(Len>0)
		return Len
	else
		return 1
}
SucheInEdit5Markieren:
ThisEdit8Exist:=false
DiesesEdit8Sternlos:=FuehrendeSterneEntfernen(Edit8)
IfExist % FuehrendeSterneEntfernen(Edit8)
{
	ThisEdit8Exist:=true
	OnlyFirstChar:=false
}
else
	OnlyFirstChar:=true
; OnlyFirstChar:=true
if (substr(DiesesEdit8Sternlos,-3)=".lnk")
{
	FileGetShortcut, %DiesesEdit8Sternlos% ,DiesesEdit8Sternlos
}
if (ThisEdit8Exist or InStr(DiesesEdit8Sternlos,"http:") or InStr(DiesesEdit8Sternlos,"https:") or InStr(DiesesEdit8Sternlos,"ftp:") or or InStr(DiesesEdit8Sternlos,"File:"))
	OnlyFirstChar:=false
{
	ControlGetFocus,ThisFocussedControl,A
	if (ThisFocussedControl="Edit5")
		return
	StringReplace,NurSterneWegEdit8,Edit8,*,,all
	IfExist %NurSterneWegEdit8%
		MarkiereSuchtext(FuehrendeSterneEntfernen(Edit8),"Edit5","ahk_id " GuiWinHwnd,GetAbPos(Edit5,Edit3),OnlyFirstChar) 
	else
		MarkiereSuchtext(Edit8,"Edit5","ahk_id " GuiWinHwnd,1,OnlyFirstChar)
	StringSplit,Edit8Ordner,% FuehrendeSterneEntfernen(Edit8),\
	ThisMarkierfolder:=FuehrendeSterneEntfernen(Edit8Ordner%Edit8Ordner0%)
	MarkiereSuchtext(FuehrendeSterneEntfernen(ThisMarkierfolder),"Edit8","ahk_id " GuiWinHwnd,1,OnlyFirstChar)
	if Fehlersuche
	{
		TrayTip Markierung, %ThisMarkierfolder%
		MsgBox % ThisMarkierfolder
	}
}
if StarteOrdnerDetailierungsSkripte
	gosub PrufenUndStarteOrdnerDetailierungsSkripte
return
imHauptprogrammOrdnerDetailierungsSkripte:
AnzahlOrdnerDetailierungsSkripte:=0
if StarteOrdnerDetailierungsSkripte
{
	Loop,Files,%A_ScriptDir%\BeiExtender.*.ahk
	{
		BeiExtenderAhkPfad%A_Index%:=A_LoopFileLongPath
		BeiExtenderExePfad%A_Index%:=(substr(A_LoopFileLongPath,1,-3)) "exe"
		if NurExeStartErlaubt
		{
			IfNotExist % BeiExtenderExePfad%A_Index%
			{
				MsgBox, 262160, Fehlende InstallationsDatei, % "Bitte eine AutohotKey.exe Datei kopieren und umbenennen in`n" BeiExtenderExePfad%A_Index% "`n`nAlle OrdnerDetailierungs-Skripte werden abgeschatet."
				StarteOrdnerDetailierungsSkripte:=false
			}
		}
		StringSplit,BeiThisExtender,BeiExtenderAhkPfad%A_Index%,.
		BeiExtender%A_Index%:=BeiThisExtender2
		AnzahlOrdnerDetailierungsSkripte:=A_Index
	}
}
return
PrufenUndStarteOrdnerDetailierungsSkripte:
Loop % AnzahlOrdnerDetailierungsSkripte
{
	ThisOrdnerDetailierungsFile:=FuehrendeSterneEntfernen(Edit8) "." BeiExtender%A_Index% 
	if NurExeStartErlaubt
	{
		IfExist %ThisOrdnerDetailierungsFile%
		{
			WinGetPos,GuiWinPosX,GuiWinPosY,GuiWinB,GuiWinH,ahk_id %GuiWinHwnd%
			run, % BeiExtenderExePfad%A_Index% 	A_Space HochKomma BeiExtenderAhkPfad%A_Index% HochKomma 	A_Space HochKomma ThisOrdnerDetailierungsFile HochKomma 	A_Space HochKomma Edit2	HochKomma 	A_Space HochKomma GuiWinPosX HochKomma A_Space HochKomma GuiWinPosY HochKomma  A_Space HochKomma GuiWinB HochKomma  A_Space HochKomma GuiWinH
		}
	}
	else
	{
	IfExist %ThisOrdnerDetailierungsFile%
		{
			WinGetPos,GuiWinPosX,GuiWinPosY,GuiWinB,GuiWinH,ahk_id %GuiWinHwnd%
			run, % BeiExtenderAhkPfad%A_Index%  	A_Space HochKomma ThisOrdnerDetailierungsFile HochKomma 	A_Space HochKomma Edit2	HochKomma 	A_Space HochKomma GuiWinPosX HochKomma A_Space HochKomma GuiWinPosY HochKomma  A_Space HochKomma GuiWinB HochKomma  A_Space HochKomma GuiWinH
		}
	}
}
return
Button1OhneMausPos:
MerkerMausGuenstigPositionieren:=MausGuenstigPositionieren
MausGuenstigPositionieren:=false
gosub Button1
MausGuenstigPositionieren:=MerkerMausGuenstigPositionieren
return
ZaehleZeilen(Ges)
{
	StringReplace,dummy,Ges,`n,,UseErrorLevel
	ZeilenZahl:=ErrorLevel+1
	If(Ges="")
		ZeilenZahl:=0
	return ZeilenZahl
}
GetZeile(Ges,Zeilennummer)
{
	StringSplit,Zeile,Ges,`n,
	if (Zeilennummer=0)
		return 0
	else if(Zeilennummer>Zeile0)
		return 0
	else if (Zeilennummer="")
		return 0
	else
		return Zeile%Zeilennummer%
}
; StringTrimLeft,AnfTeilWortListe,AnfTeilWortListe,1
; StringTrimLeft,TeilWortListe,TeilWortListe,1
; +F11::	; deaktiviert
; send {Right}{home}{Del}{home}\{home}
; return
; F11:: 	; deaktiviert
; ControlSetText,Edit1,%GlobalMomentanerFolderVorschlag1%\ ,Speichern
; Clipboard:=GlobalMomentanerFolderVorschlag1 "\" GlobalBenutzerEin2
; GlobalEndEdit1Loop:=true
; send ^a
; send ^v
; return
; FileSelAbfrage:
; FileSelectFile,SelectedFile,,c:\G\Gegenst, Zuerst den Ordner ...,TextFiles (*.txt)
; return
RunOtherAhkScript(StartScriptPath,UebergabeParameter*)
{	
	global RunPid, NurExeStartErlaubt
	If (UebergabeParameter.MaxIndex()="")
		ThisUebergabeParameter:=false
	else
		ThisUebergabeParameter:=true
	if ZackZackOrdnerLogErstellen
		ThreadUeberwachungLog(A_LineNumber-8,A_ThisHotkey,A_ThisLabel,A_ThisFunc,A_ThisMenu,A_ThisMenuItem,A_ThisMenuItemPos)
	Hochkomma="
	Loop, % UebergabeParameter.MaxIndex()
	{
		AlleUebergabeParameter:=AlleUebergabeParameter A_Space Hochkomma UebergabeParameter[A_Index] Hochkomma
		if ZackZackOrdnerLogErstellen
			ThreadUeberwachungLog(A_LineNumber-1,AlleUebergabeParameter,A_ThisLabel,A_ThisFunc,UebergabeParameter[A_Index],A_ThisMenuItem,A_ThisMenuItemPos)
	}
	if ZackZackOrdnerLogErstellen
		ThreadUeberwachungLog(A_LineNumber-3,A_ThisHotkey,A_ThisLabel,A_ThisFunc,AlleUebergabeParameter,A_ThisMenuItem,A_ThisMenuItemPos)
	SplitPath,StartScriptPath,StartScriptFileName,StartScriptDir,StartScriptExt,StartScriptNameNoExt
	if ZackZackOrdnerLogErstellen
		ThreadUeberwachungLog(A_LineNumber-1,A_ThisHotkey,StartScriptNameNoExt,A_ThisFunc,StartScriptFileName,StartScriptDir,StartScriptExt)
	SplitPath,A_AhkPath,ExeStartScriptFileName,ExeStartScriptDir,ExeStartScriptExt,ExeStartScriptNameNoExt
	if ZackZackOrdnerLogErstellen
		ThreadUeberwachungLog(A_LineNumber-1,A_ThisHotkey,ExeStartScriptNameNoExt,A_ThisFunc,ExeStartScriptFileName,ExeStartScriptDir,ExeStartScriptExt)
	StartScriptAhkPath:=StartScriptDir "\" StartScriptNameNoExt ".ahk" 
	if ZackZackOrdnerLogErstellen
		ThreadUeberwachungLog(A_LineNumber-1,A_ThisHotkey,A_ThisLabel,A_ThisFunc,StartScriptAhkPath,A_ThisMenuItem,A_ThisMenuItemPos)
	IfExist % FuehrendeSterneEntfernen(StartScriptAhkPath)
		DaStartScriptAhkPath:=true
	else
		DaStartScriptAhkPath:=false
	if ZackZackOrdnerLogErstellen
		ThreadUeberwachungLog(A_LineNumber-4,A_ThisHotkey,A_ThisLabel,A_ThisFunc,FuehrendeSterneEntfernen(StartScriptAhkPath),DaStartScriptAhkPath,A_ThisMenuItemPos)
	StartScriptExePath:=StartScriptDir "\" StartScriptNameNoExt ".exe" 
	if ZackZackOrdnerLogErstellen
		ThreadUeberwachungLog(A_LineNumber-1,A_ThisHotkey,A_ThisLabel,A_ThisFunc,StartScriptExePath,A_ThisMenuItem,A_ThisMenuItemPos)
	IfExist % FuehrendeSterneEntfernen(StartScriptExePath)
		DaStartScriptExePath:=true
	else
		DaStartScriptExePath:=false
	if ZackZackOrdnerLogErstellen
		ThreadUeberwachungLog(A_LineNumber-4,A_ThisHotkey,A_ThisLabel,A_ThisFunc,FuehrendeSterneEntfernen(StartScriptExePath),DaStartScriptExePath,A_ThisMenuItemPos)
	if ZackZackOrdnerLogErstellen
		ThreadUeberwachungLog(A_LineNumber+1,A_ThisHotkey,A_ThisLabel,A_ThisFunc,StartScriptDir,ExeStartScriptDir,A_ThisMenuItemPos)
	If NurExeStartErlaubt															
		InstallierterAhkStart:=false
	else If(StartScriptDir=ExeStartScriptDir)
	{
		InstallierterAhkStart:=false
		if ZackZackOrdnerLogErstellen
			ThreadUeberwachungLog(A_LineNumber-1,A_ThisHotkey,A_ThisLabel,A_ThisFunc,A_ThisMenu,A_ThisMenuItem,A_ThisMenuItemPos)
	}
	else
	{
		if Fehlersuche
		MsgBox % StartScriptDir "<>" ExeStartScriptDir
		InstallierterAhkStart:=true
		if ZackZackOrdnerLogErstellen
			ThreadUeberwachungLog(A_LineNumber-1,A_ThisHotkey,A_ThisLabel,A_ThisFunc,A_ThisMenu,A_ThisMenuItem,A_ThisMenuItemPos)
	}
	If (InstallierterAhkStart and DaStartScriptAhkPath)
	{
		if ZackZackOrdnerLogErstellen
			ThreadUeberwachungLog(A_LineNumber+1,A_ThisHotkey,A_ThisLabel,A_ThisFunc,A_ThisMenu,A_ThisMenuItem,A_ThisMenuItemPos)
		run, %StartScriptAhkPath% %AlleUebergabeParameter%,,UseErrorLevel, RunPid
		return ErrorLevel
	}
	else If DaStartScriptExePath
	{
		if ZackZackOrdnerLogErstellen
			run, %StartScriptExePath% %AlleUebergabeParameter%,,UseErrorLevel, RunPid
		return ErrorLevel
	}
	else If (not DaStartScriptExePath and not DaStartScriptAhkPath)
	{
		if ZackZackOrdnerLogErstellen
			ThreadUeberwachungLog(A_LineNumber-2,A_ThisHotkey,A_ThisLabel,A_ThisFunc,A_ThisMenu,A_ThisMenuItem,A_ThisMenuItemPos)
		; MsgBox, 262192, Fehler, kann die auszufuehrende Datei `n`n	%StartScriptAhkPath% `n`noder `n`n	%StartScriptExePath% `n`nnicht im Ordner `n`n	%StartScriptDir% `n`nfinden!
		EckKlamPosAuf:=InStr(StartScriptNameNoExt,"[")
		if EckKlamPosAuf
		{
			If(SubStr(StartScriptNameNoExt,0)="]")
			{
				EckKlamPosZu:=InStr(StartScriptNameNoExt,"]")
				if EckKlamPosZu
				{
					DeltaEckKlamPos:=EckKlamPosZu - EckKlamPosAuf
					EckKlamPlusText:=SubStr(StartScriptNameNoExt,EckKlamPosAuf,DeltaEckKlamPos+1)
					VorEckKlamPlusText:=SubStr(StartScriptNameNoExt,1,EckKlamPosAuf-1)
					ThisFilePattern:=StartScriptDir "\" VorEckKlamPlusText "[*].*"   ; StartScriptExt		
					{
						LoopFileAlt:=
						Loop,Files,%ThisFilePattern%, F
						{
							SplitPath,A_LoopFileLongPath,LoopFileLongFileName,LoopFileLongDir,LoopFileLongExt,LoopFileLongNameNoExt
							SubStr(StartScriptNameNoExt,InStr(StartScriptNameNoExt,"["),InStr(StartScriptNameNoExt,"]") - InStr(StartScriptNameNoExt,"[")+1)
							LoopFileInEckKlam:=SubStr(LoopFileLongNameNoExt,	InStr(LoopFileLongNameNoExt,"[")+1,	InStr(LoopFileLongNameNoExt,"]") - InStr(LoopFileLongNameNoExt,"[")-1)
							LoopFileAlt:= SubStr("00000" . LoopFileInEckKlam, -4) A_Tab A_LoopFileLongPath "`n" LoopFileAlt
						}
						StringTrimLeft,LoopFileAlt,LoopFileAlt,1
						Sort,LoopFileAlt,U R
						Loop,Parse,LoopFileAlt,`n,`r
						{
							Last3Char:=SubStr(A_LoopField,-2)
							if Last3Char not in lnk,bak
							{
								StringSplit,NewestLoopFileAlt,A_LoopField,%A_Tab%
								break
							}
						}
						return NewestLoopFileAlt2
						ExitApp
					}
				}
			}
		}
		return "FileNotFound"
	}
	else
		MsgBox, 262192, Fehler, Bitte die neueste Version der AutoHottKey.exe von AHK V1.x von AhkScript.org herunterladen. Umbenennen zu `n`n%ExeStartScriptFileName%`n`nund dort`n`n%StartScriptExePath%`n`nplazieren. Dann erneut versuchen.
}
GetKlammerInhalt(StringMitKlammern,Auf="[",Zu="]")
{
	if (StrLen(Auf)>1)
		MsgBox Nur ein Zeichen bei %Auf% erlaubt
	if (StrLen(Zu)>1)
		MsgBox Nur ein Zeichen bei %Zu% erlaubt
	if (not InStr(StringMitKlammern,Zu))
	{
		if (InStr(StringMitKlammern,Auf))
		MsgBox % "SyntaxFehler in `n`n" StringMitKlammern "`n`nnur oefnende Klammer"
		return
	}
	Merker:=InStr(StringMitKlammern,Auf)
	return (SubStr(StringMitKlammern,	Merker+1,	InStr(StringMitKlammern,Zu) - Merker-1))
}
F9::	; fuer Fehlersuche
MsgBox
LauscheTast:=true
send {Home}
return
F10::	; fuer Fehlersuche
LauscheTast:=false
return
#ü:: 	;	fuer die Fehlersuche, zeigt zeitnah listvars 
AnzListvars:=true
return
				; MsgBox % "nach *	" ThisWurzel
					; MsgBox % "nach	" ThisWurzel
						; MsgBox % ThisWurzel
MarkiereSuchtext(Suchtext,Control="",Win="A",AbPos=1,OnlyFirstChar=0)
{
	If (Win="A")
		Win:="ahk_id " WinExist("A")
	If (Control="")
	{
		ControlGetFocus,ClassNN,%Win%
		Control:=ClassNN
	}
	ControlGetText,ControlText,%Control%,%Win%
	Pos1:=InStr(SubStr(ControlText,AbPos),Suchtext)-2+AbPos
	if OnlyFirstChar
		Pos2:=Pos1+1
	else
		Pos2:=Pos1+StrLen(Suchtext)
	SendMessage 0xB1, %Pos1%, %Pos2%, %Control%, %Win% ; EM_SetSel
	If Fehlersuche
		TrayTip, Markiere %Win%, in %Control%  den Suchtext %Suchtext%`, d.h. die Zeichen von %Pos1% bis %Pos2%
	Erg:=Pos1 A_Tab Pos2
	return Erg
}
MarkiereVonBis(Pos1=1,Pos2=99999999,Control="",Win="A",AbPos=1)
{
	Pos1:=Pos1-1
	If (Win="A")
		Win:="ahk_id " WinExist("A")
	If (Control="")
	{
		ControlGetFocus,ClassNN,%Win%
		Control:=ClassNN
	}
	ControlGetText,ControlText,%Control%,%Win%
	SendMessage 0xB1, %Pos1%, %Pos2%, %Control%, %Win% ; EM_SetSel
	If Fehlersuche
		TrayTip, Markiere, von %Pos1% bis %Pos2% `n`n %ControlText%
	Erg:=SubStr(ControlText,Pos1+1,Pos2+1)
	return Erg
}
GetSel(TextOrPoses="Text",Control="",Win="A",AbPos=1)
{
	If (Win="A")
		Win:="ahk_id " WinExist("A")
	If (Control="")
	{
		ControlGetFocus,ClassNN,%Win%
		Control:=ClassNN
	}
	else if(Control="MausKlick")
	{
		TrayTip,Control,anklicken oder MouseOverControl LShift
		Loop
		{
			KeyWait, LButton, D T0.2
			If Not ErrorLevel
				break
			KeyWait, LShift, D T0.05
			If Not ErrorLevel
				break
		}
		TrayTip,Control,markiere Text vom angeklickten Control`ndann RShift
		KeyWait, RShift, D T30
		MouseGetPos,MouseX,MouseY,Win,Control,3
		Win:="ahk_id " Control
		Control=
	}
	ControlGetText,ControlText,%Control%,%Win%
	StartPos := -1
	EndPos := -1
	SendMessage 0xB0,&StartPos,&EndPos, %Control%, %Win%  ; EM_GetSel
	FirstSel2 := NumGet(&StartPos)+1
	LastSel2 := NumGet(&EndPos)
	SelLen:=LastSel2-FirstSel2
	If(TextOrPoses="Poses")
		Erg:=FirstSel2 A_Tab LastSel2
	else if(TextOrPoses="Text")
	{
		Erg:=SubStr(ControlText,FirstSel2,SelLen+1)
		if (Erg="")
		{
			if Fehlersuche
				TrayTip,Ersatz-Rueckgabe, gesammtes Control
			Erg:=ControlText
		}
	}
	else
		MsgBox TextOrPoses=%TextOrPoses% wird (noch) nicht unterst��.
	return Erg
}
WM_LBUTTONDOWN(wParam, lParam)
{
	global Edit5Hoehe, GuiWinHwnd, GuiHeight
	if (A_GuiHeight>GuiHeight)
		GuiHeight:=A_GuiHeight
    X := lParam & 0xFFFF
    Y := lParam >> 16
	If(y>115 and y<(GuiHeight-35) and x<122 and x>92)
	{
		ThisZeile:=round((((y-123)+6)/13))
		Edit3:=ThisZeile
		GuiControl,1:, Edit3, %Edit3%
		gosub Edit3
		gosub Button2
	}
	else If(y>102  and x<122 and x>92)
	{
		gosub Edit2
		return
	}
	else if((90+Edit5Hoehe<Y) and x>122)		
	{
		if(x<116 and x>92)
		{
			gosub Edit2
			LetzerAendererVonEdit5:="Edit3"
			return
		}
		gosub SucheInEdit5Markieren
		If Fehlersuche
			SoundBeep 400
		ControlFocus,Edit5,ahk_id %GuiWinHwnd%
	}
	else if A_GuiControl
	 {
		return
        Steuerelement := "`n(im Steuerelement " . A_GuiControl . ")"
		ToolTip Sie haben im GUI-Fenster #%A_Gui% auf die Koordinaten %X%x%Y% geklickt.%Steuerelement%
	}
	return
}
/*
E2E7(QuellLineNr,E2,E7,BelVar,DeltVorigeZNr=0)
{
	global
	DieseQuellLineNr:=[]
	DieseQuellLineNrMi:=[]
	DieseQuellLineNr["diese"]:=QuellLineNr
	DieseQuellLineNrMi["diese"]:="QQuellTextZeilenNummer	" QuellLineNr
	if ((E2="Gerd" and E7="users") or (Edit2="Gerd" and Edit7="users") or E2="Filter" or E7="Filter" or Edit2="Filter" or Edit7="Filter")
	{
		FileReadLine,QuelltextZeile1,%A_LineFile%,% DieseQuellLineNr["diese"]
		FileReadLine,QuelltextZeile2,%A_LineFile%,% DieseQuellLineNr["diese"] - DeltVorigeZNr
		LogInhalt:=DieseQuellLineNr["diese"] A_Tab QuelltextZeile1 A_Tab BelVar A_Tab E2 A_Tab E7 A_Tab Edit2 A_Tab Edit7 "`r`n"
		LogInhalt:=DieseQuellLineNr["diese"] A_Tab QuelltextZeile2 A_Tab BelVar A_Tab E2 A_Tab E7 A_Tab Edit2 A_Tab Edit7 "`r`n"
		FileAppend,%LogInhalt%,%A_ScriptFullPath%.Log
	}
	return
}
*/
SASize:		; wird bei jeder Fensterbewegung aufgerufen
WinGetPos,ExplWinX,ExplWinY,ExplWinB,ExplWinH,ahk_class CabinetWClass
if (ExplWinX<>"" and ExplWinY<>"" and ExplWinB<>"" and ExplWinH<>"")
{
	gosub IfMainGuiMinRestore
	if(ExplWinB*1.5<A_ScreenWidth or ExplWinH*1.5<A_ScreenHeight)
		WinMove,ahk_id %GuiWinHwnd%,,%ExplWinX%,%ExplWinY%,%ExplWinB%,%ExplWinH%
}
else
{
}
A:	; aktiviere GuiWin
SA:	; aktiviere GuiWin
SelfActivate:	; aktiviere GuiWin
AktionBeiClipChange:=
If Fehlersuche
	TrayTip,SelfActivate,SelfActivate
gosub IfMainGuiMinRestore
Gui,1:Submit,NoHide
If OnTop
{
	if TimerFehlerSuche
	{
		TrayTip, Timer WarteSpeicherOeffnen %A_LineNumber%, BeiGuiWinHwndkeinAutoPop= %BeiGuiWinHwndkeinAutoPop%  =	ThisAufmerksamkeitHWND= %ThisAufmerksamkeitHWND%
		sleep 3000
	}
	WinSet,AlwaysOnTop,On,ahk_id %GuiWinHwnd%
}
if Akt
	WinActivate,ahk_id %GuiWinHwnd%
ControlFocus,Edit2,ahk_id %GuiWinHwnd%
if (MausGuenstigPositionieren and A_ThisLabel="SASize")
	MouseMove,A_CaretX+90,A_CaretY+9
return
LV:
ListVars
return
2b2:
Edit2:=Edit2*2
sb2:
		Gui,1:Submit,NoHide
bs2:
		GuiControl,1:, %HwndEdit2%, %Edit2%
		Gui,1:Submit,NoHide
return
b2:
		Gui,1:Submit,NoHide
2:
		GuiControl,1:, %HwndEdit2%, %Edit2%
return
ExplorerPfadEingeben:
Ex:
IfWinActive,ahk_class CabinetWClass
	WinGetPos,ExplWinX,ExplWinY,ExplWinB,ExplWinH,A
if (ExplWinX<>"" and ExplWinY<>"" and ExplWinB<>"" and ExplWinH<>"")
WinMove,ahk_id %GuiWinHwnd%,,%WinX%,%WinY%,%WinB%,%WinH%
Edit1FremdBefuellt:=false
loop, 3
{
	FremdEdit1Vorher:=
	ControlFocus,ToolbarWindow323,ahk_class CabinetWClass
	sleep A_Index*30
	ControlGetText,FremdEdit1Vorher,Edit1,ahk_class CabinetWClass
	sleep A_Index*60
	if(A_Index>2)
		ControlClick,ComboBox1,ahk_class CabinetWClass
	else if(A_Index=2)
		ControlClick,ToolbarWindow323,ahk_class CabinetWClass
	Gui,1:Submit,NoHide
	sleep A_Index*30
	ControlSetText,Edit1,% FuehrendeSterneEntfernen(Edit8),ahk_class CabinetWClass
	sleep A_Index*30
	ControlGetText,FremdEdit1Probe,Edit1,ahk_class CabinetWClass
	if(FremdEdit1Vorher<>FremdEdit1Probe)
	{
		Edit1FremdBefuellt:=true
		break
	}
}
if Edit1FremdBefuellt
	ControlSend,Edit1,{Enter},ahk_class CabinetWClass
else
{
	Clipboard:=FuehrendeSterneEntfernen(Edit8)
	MsgBox, 262160, Edit8 to Pfad-Eingabe Fremdfenster, Die Texteingabe wurde vom Fremdfenster nicht angenommen.`nAbbruch`n`nHinweis:`nDer Text wurde fuer manuelle Versuche ins Clipboard geschrieben!
}
return
/*
CabinetWClass	0x1306d8	0x4e0442	0xbb0534	0x1100ea	            Address Band Root1	115	150	1052	28	
CabinetWClass	0x1306d8	0x4e0442	0xbb0534	0x1100ea	0x807a0	                msctls_progress321	117	154	1048	22	
CabinetWClass	0x1306d8	0x4e0442	0xbb0534	0x1100ea	0x807a0	0x602aa	                    Breadcrumb Parent1	117	154	1023	22	
CabinetWClass	0x1306d8	0x4e0442	0xbb0534	0x1100ea	0x807a0	0x602aa	0x802b4	                        ToolbarWindow323	117	154	1023	22	Adresse: Dieser PC
CabinetWClass	0x1306d8	0x4e0442	0xbb0534	0x1100ea	0x807a0	0xb0268	                    ToolbarWindow324	1140	154	25	22	Symbolleiste "Adressleiste"
CabinetWClass	0x1306d8	0x4e0442	0xbb0534	0x1100ea	0x807a0	0x1b01fe	                    ComboBoxEx321	117	154	1023	22	Dieser PC
CabinetWClass	0x1306d8	0x4e0442	0xbb0534	0x1100ea	0x807a0	0x1b01fe	0x300620	                        ComboBox1	117	154	1023	22
*/
GetAWinInfosHtml:
MsgBox FensterDetail-Informationenn:`n`nes ist 10 Sekundden Zeit um nach Ok das gewuenschte Fenster zu oeffnen und das Control zu fokusieren
sleep, 10000
HWND:=WinExist("A")						; wwenn HWND:="" werden Fehlerhafte Infos ueber alle bekannten Controls ausgegeben 
FensterHtmlInfos:
/*
WinGetTitle,WinTitle,ahk_id %HWNDvorl%
MsgBox, 262179, Fensterinformationen, Ja		vom aktiven Fenster	%WinTitle%`n`nNein		alle Fenster-Infos`n`nCancel		Abbruch
IfMsgBox,Yes
	HWND:=HWNDvorl
IfMsgBox, No
{
	HWND:=
	WinWaitClose,Fensterinformationen,,4
	sleep 3000
}
IfMsgBox,Cancel
	return
*/
HTML_Liste:=WinConIndex(HWND)
ThisHtmlPath=%A_AppDataCommon%\Fensterinfo_%A_Now%.htm
FileAppend,%HTML_Liste%,%ThisHtmlPath%,utf-16
if ZackZackOrdnerLogErstellen
	ThreadUeberwachungLog(A_LineNumber-1,A_ThisHotkey,A_ThisLabel,A_ThisFunc,A_ThisMenu,A_ThisMenuItem,A_ThisMenuItemPos)
run %ThisHtmlPath%
if ZackZackOrdnerLogErstellen
	ThreadUeberwachungLog(A_LineNumber-1,A_ThisHotkey,A_ThisLabel,A_ThisFunc,A_ThisMenu,A_ThisMenuItem,A_ThisMenuItemPos)
return
WinConIndex(WinHwnd="",GetLocalVar="")		; 1.) indiziert Variablen mit Control-Informationen und erstellt daraus eine moeglichst uebersichtiche HTML-Tabelle  2.) speichert die Variablen und gibt sie auf verlangen aus. Die 1. Uebergabe-Variable ist in diesem Falle zwar zu uebergeben (als Dummy), sie wird jedoch momentan weder einwaerts noch auswaerts benutzt.
{
	static        ; static aktivieren fuehrt noch zu Fehlern bei der NeuIndexierung, wahrschscheinlich muessen die richtigen Variablen geloescht werden.
	If(GetLocalVar<>"")
	{
		Rueckgabe:= %GetLocalVar%
		GetLocalVar=
		return Rueckgabe
	}
	Last=
	ControlHwnd0=
	ControlClassNN0=
	ControlListHwnd=
	ControlList=
	Einrueck=
	Lines=
	Gesammt=
	FocussedWinHwnd=
	FocusedHwnd=
	FocusedHwndIndex:=1
	VorDetectHiddenWindows:=A_DetectHiddenWindows
	VorDetectHiddenText:=A_DetectHiddenText
	If(WinHwnd="")
	{
		DetectHiddenWindows, On
		DetectHiddenText, On
		VonRoot:=true
		WinHwnd:=WinExist("ahk_id" DllCall("GetDesktopWindow")) ; Gibt das oberste (Parent of all) HWND zurueck
	}
	else
		VonRoot:=false
	Header=
(
<html>
<head>
<title>Untitled Document</title>
<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1">
</head>
<body bgcolor="#FFFFFF" text="#000000">
<table border="1">
)
	VorWinTitle=<h1>
	NachWinTitle=</h1>
	VorZeile=<tr>
	VorAnker=<a name="
	NachAnker="></a>
	NachZeile=</tr>
	kleiner=<
	Nullx:="0x" ""
	FestesLeerzeichen=&nbsp;
	VorVar=<td>
	NachVar=</td>
TabellenUeberschrift:=VorZeile 	VorVar "Win_Class  Parents_HWND_List<br>(oder) <b>WinTitle</b>" NachVar 	VorVar "Hwnd<br>(<b>focus</b>)" NachVar 	VorVar "ClassNN" NachVar 	VorVar "X1" NachVar 	VorVar "Y1" NachVar 	VorVar "Breite" NachVar 	VorVar "Hoehe" NachVar 		VorVar "Text" NachVar 		NachZeile
Bottom=
(
</table>
</body>
</html>
)
	WinGetTitle,WinTitle,ahk_id %WinHwnd%
	WinGetClass,WinClass,ahk_id %WinHwnd%
	Winget,ControlListHwnd ,ControlListHwnd ,ahk_id %WinHwnd%
	Winget,ControlList ,ControlList ,ahk_id %WinHwnd%
	StringSplit,ControlHwnd,ControlListHwnd,`n,`r
	StringSplit,ControlClassNN,ControlList,`n,`r
	If (ControlHwnd0=ControlClassNN0)	; wenn zwischen obigen Winget-Aufrufen sich die Anzahl der Controls geaendert hat, wuerde die 1:1 Beziehung ControlHwnd's : ControlClasses falsche Ergebnisse liefern. Zwischen diesen Aufrufen sollten auch keine Fenster-Veraenderungen gemacht werden. Im Zweifel kann kann der 1:1 Vergleich beliebig oft wiederholt werden.
	{
		Class_VarName_List=
		Loop, % ControlHwnd0
		{
			ThisHwnd:=ControlHwnd%A_Index%
			Class_%ThisHwnd%:=ControlClassNN%A_Index%		; Ausserhalb dieser Funktion zur Verfuegung via WinConIndex(dummy,Var_contains_local_Varname)			
			Class_VarName_List:=Class_VarName_List A_Tab  Class_%ThisHwnd%			; Ausserhalb dieser Funktion  zur Verfuegung via WinConIndex(dummy,Var_contains_local_Varname)
			ThisClassNN:=ControlClassNN%A_Index%
			VarNameClassNNHex:=String2Hex(ThisClassNN)	; Ausserhalb dieser Funktion zur Verfuegung via WinConIndex(dummy,Var_contains_local_ClassNN_Varname_als_HexString)
			Hwnd_%VarNameClassNN%:=ControlHwnd%A_Index%		
			ControlGetFocus, ClassNNFoxussedName , ahk_id %ThisHwnd%
			if (ClassNNFoxussedName<>"")
			{
				ControlGet, FocusedHwnd%FocusedHwndIndex%, Hwnd,, %ClassNNFoxussedName%, ahk_id %ThisHwnd%
				LastFocusedHwnd:=FocusedHwnd%FocusedHwndIndex%,
				++FocusedHwndIndex
				FocussedWinHwnd:=FocussedWinHwnd "`r`n" ThisHwnd	ClassNNFoxussedName
			}
			else if(LastFocusedHwnd=ThisHwnd)     ; 	If(substr((Hwnd+0),1)<>substr((NullHwnd+0),1))			; hier hatte sich AutoHotKey nicht wie ich erwartet haette verhalten, bis ich die doppelte Formatwandlung erzwang. Gerne erfahre ich elegantere Loesungen.				FocusedControlClassNN	FocusedControlHwnd0
			{
				VorHervorheben=<b>
				NachHervorheben=</b>
			}
			else
			{
				VorHervorheben=
				NachHervorheben=
			}
			if VonRoot
			{
				KorrParentHwnd:=GetParent(ThisHwnd)
				Winget,KorrParentControlListHwnd ,ControlListHwnd ,ahk_id %KorrParentHwnd%
				Winget,KorrParentControlList ,ControlList ,ahk_id %KorrParentHwnd%
				StringSplit,KorrControlHwnd,KorrParentControlListHwnd,`n,`r
				StringSplit,KorrControlclassNN,KorrParentControlList,`n,`r
				Loop, % KorrControlHwnd0
				{
					if(KorrControlHwnd%A_Index%=ThisHwnd) 
					{
						Class_%ThisHwnd%:=KorrControlClassNN%A_Index%
					}
				}
			}
			ControlGetText,Text_%ThisHwnd%,,ahk_id %ThisHwnd%
			ControlGetPos,Pos1_%ThisHwnd%,Pos2_%ThisHwnd%,Pos3_%ThisHwnd%,Pos4_%ThisHwnd%,,ahk_id %ThisHwnd%
			ParentClass_%ThisHwnd%:=GetParentClass(ThisHwnd)
			ThisParentsAnzeige:=GetParentsHwndList(ThisHwnd)
				StringReplace,Unnuetz,ThisParentsAnzeige, 0x,,UseErrorLevel 
				Anzahl0x:=ErrorLevel
				Einrueck=
				Loop, % Anzahl0x
				{
					Einrueck:=FestesLeerzeichen Einrueck
				}
			Last:=GetParentsHwndList(ThisHwnd,"Last")
			If (Last<>"")
			{
				ThisWinTitle=
				VorParent=<a href="#%Last%">
				NachParent=</a>
			}
			else
			{
				WinGetTitle,ThisWinTitle,ahk_id %ThisHwnd%
					ThisWinTitle=<b>%ThisWinTitle%</b>
				VorParent=
				NachParent=
			}
			ThisLine:= VorZeile 	     	VorVar ThisWinTitle VorParent Class_%Last% NachParent " " ThisParentsAnzeige  NachVar            VorVar  VorAnker  ThisHwnd NachAnker VorHervorheben ThisHwnd NachHervorheben NachVar 	VorVar Einrueck Einrueck Einrueck Einrueck  Class_%ThisHwnd% NachVar 	VorVar Pos1_%ThisHwnd% NachVar 	VorVar Pos2_%ThisHwnd% NachVar 	VorVar Pos3_%ThisHwnd% NachVar 	VorVar Pos4_%ThisHwnd% NachVar 		VorVar Text_%ThisHwnd% NachVar			NachZeile
			Lines:=Lines ThisLine
		}
		Gesammt:=	Header	 VorWinTitle WinHwnd "  "  WinClass " " WinTitle NachWinTitle	  TabellenUeberschrift	 Lines Bottom
	DetectHiddenWindows,%VorDetectHiddenWindows%
	DetectHiddenText,%VorDetectHiddenText%
	return Gesammt
	}
	Return "Error: Die Control_Anzahl aenderte sich waehrend den Abfragen"
}
GetParent(Hwnd)
{
	ID := DllCall("GetParent", UInt,WinExist("ahk_id " Hwnd)), ID := !ID ? WinExist("ahk_id " Hwnd) : ID
	return ID
}
GetParentClass(Hwnd,ParentBisHwnd="")
{
	OldFormat:=A_FormatInteger
	SetFormat,IntegerFast,hex
	ParentHwnd:= GetParent(Hwnd)
	WinGetClass,ParentClass,ahk_id %ParentHwnd%
	SetFormat,IntegerFast,%OldFormat%
	return ParentHwnd "	" ParentClass
}
GetParentsHwndList(Hwnd,ParentBisHwnd="")
{
	static RootHwnd
	OldFormat:=A_FormatInteger
	SetFormat,IntegerFast,hex
	if (RootHwnd="")
		RootHwnd:=WinExist("ahk_id" DllCall("GetDesktopWindow")) ; Gibt das oberste HWND zurueck
	NullHwnd:=0x0 + 0x0
	If(substr((Hwnd+0),1)<>substr((NullHwnd+0),1))			; hier hatte sich AutoHotKey nicht wie ich erwartet haette verhalten, bis ich die doppelte Formatwandlung erzwang. Gerne erfahre ich elegantere Loesungen.
	{
		Loop,20		;	die 20 in der Parent-Such-Schleife ist Willkuer
		{
			if(A_Index>=20)
				MsgBox %A_LineNumber% 	hier sollte das Skript nicht hinkommen.`nHinweis: Quelltext auf Fehler pruefen oder 20 Parent-Generationen unterstuetzen (maximale Loop-Anzahl erhoehen).
			If(substr(Hwnd+0 ,1)=substr(NullHwnd+0 ,1))
			{
				HwndIstNull:=true
				MsgBox nullHwnd erkannt			; wird nicht erreicht
				break
			}
			ParentHwnd:=GetParent(Hwnd)
			If(substr(ParentHwnd+0 ,1)=substr(NullHwnd+0,1))
			{
				HwndIstNull:=true
				break
			}
			else If(substr(ParentHwnd+0 ,1)=substr(RootHwnd+0 ,1))
			{
				HwndList:=ParentHwnd A_Tab HwndList
				RootErreicht:=true
				break
			}
			else if(substr(Hwnd+0 ,1)=substr(ParentHwnd+0 ,1))
			{
				break
			}
			else
			{
				HwndList:=ParentHwnd A_Tab HwndList
				Hwnd:=ParentHwnd
				LastGoodHwnd:=Hwnd
			}
		}
	}
	ParentClass:=CHwnd(LastGoodHwnd,"Class","Get")
	StringReplace,ParentClass,ParentClass,NulllluN,
	HwndList:=ParentClass A_Tab HwndList
	SetFormat,IntegerFast,%OldFormat%
	If(ParentBisHwnd="Last")
		return LastGoodHwnd
	else
		return HwndList 
}
String2Hex(String)			; gibt es sicherlich effizientere Funktionen als diese hier
{
	OldFormat:=A_FormatInteger
	StringSplit,C,String
	Loop, % C0
	{
		T:=Asc(C%A_Index%)
		SetFormat,IntegerFast,hex
		T:= SubStr(T,3)
		E:=E . T
		SetFormat,IntegerFast,d
	}
	SetFormat,IntegerFast,%OldFormat%
	return E
}
CHwnd(Hwnd,Was,Ri="Get",Optionen="")
{
	static
	If (Optionen<>"")
	{
		ListLines
		MsgBox
	}
	Gosub CHwnd_%Was%_%Ri%
	return Erg
	CHwnd_Text_???:		Vorlage fuer Cashbare Ergebnisse
	Erg:=C_%Hwnd%_Text
	If(Erg="")
	{
		ControlGetText, Erg,, ahk_id %Hwnd%
		if(Erg="")
			Erg:="NulllluN"
		C_%Hwnd%_Text:=Erg
	}
	return
	CHwnd_Text_Get:
	ControlGetText, Erg,, ahk_id %Hwnd%
	if(Erg="")
		Erg:="NulllluN"
	return
	CHwnd_Class_Get:
	WinGetClass, Erg, ahk_id %Hwnd%
	if(Erg="")
		Erg:="NulllluN"
	return
	CHwnd_ClassNN_Siblings_Get:
	WinGet, Erg, ControlList,ahk_id %Hwnd%
	if(Erg="")
		Erg:="NulllluN"
	return
	CHwnd_Hwnd_Get:
	WinGet, Erg , ID, ahk_id %Hwnd%
	if(Erg="")
		Erg:="NulllluN"
	return
	CHwnd_Parent_Get:
	ThisHwnd:=Hwnd
	ThisID := DllCall("GetParent", UInt,WinExist("ahk_id " ThisHwnd)), ThisID := !ThisID ? WinExist("ahk_id " ThisHwnd) : ThisID
	Erg:=ThisID
	return
	CHwnd_Parents_Get:
	Erg1:=
	Erg2:=
	Tabs=................
	WinGetClass, ThisControlClass, ahk_id %Hwnd%
	Erg1:= "`n" Tabs  Hwnd    "  " ThisControlClass    Erg1
	Loop,20
	{
		StringTrimLeft, TabsW1,Tabs,1
		ID := DllCall("GetParent", UInt,WinExist("ahk_id " Hwnd)), ID := !ID ? WinExist("ahk_id " Hwnd) : ID
		SetFormat IntegerFast,h
		gosub CHwnd_Class_Get
		Hwnd:=ID
		Erg2:= "`n" Tabs Erg   Erg2
		WinGetClass, ThisControlClass, ahk_id %ID%
		Erg1:= "`n" TabsW1  ID  "  " ThisControlClass  Erg1
		If(ID="" or ID=LastID or ID=0)
			break
		LastID:=ID
		I:=A_Index
		StringTrimLeft, Tabs,Tabs,1
	}
	Erg:=  Erg1 ;  "`n" "Klasse" Erg2
	SetFormat IntegerFast,d
	return 
	CHwnd_Sons_Get:
	WinGet, Erg , ControlListHwnd,ahk_id %Hwnd%
		if(Erg="			")
		Erg:="NulllluN"
	return
	CHwnd_Pos_Get:
	ControlGetPos , C_%Hwnd%_Pos_X1, C_%Hwnd%_Pos_Y1, C_%Hwnd%_Pos_Width, C_%Hwnd%_Pos_Height, , ahk_id %Hwnd%
	Erg:= C_%Hwnd%_Pos_X1 " "  C_%Hwnd%_Pos_Y1 " "  C_%Hwnd%_Pos_Width " "  C_%Hwnd%_Pos_Height
	if(Erg="			")
		Erg:="NulllluN"
	return
	CHwnd_Pos_X1_Get:
	If(C_%Hwnd%_Pos_X1="")
		ControlGetPos , C_%Hwnd%_Pos_X1, C_%Hwnd%_Pos_Y1, C_%Hwnd%_Pos_Width, C_%Hwnd%_Pos_Height, , ahk_id %Hwnd%
	Erg:= C_%Hwnd%_Pos_X1
	return
	CHwnd_Pos_Y1_Get:
	If(C_%Hwnd%_Pos_Y1="")
		ControlGetPos , C_%Hwnd%_Pos_X1, C_%Hwnd%_Pos_Y1, C_%Hwnd%_Pos_Width, C_%Hwnd%_Pos_Height, , ahk_id %Hwnd%
	Erg:= C_%Hwnd%_Pos_Y1
	return
	CHwnd_Pos_Width_Get:
	If(C_%Hwnd%_Pos_Width="")
		ControlGetPos , C_%Hwnd%_Pos_X1, C_%Hwnd%_Pos_Y1, C_%Hwnd%_Pos_Width, C_%Hwnd%_Pos_Height, , ahk_id %Hwnd%
	Erg:= C_%Hwnd%_Pos_Width
	return
	CHwnd_Pos_Height_Get:
	If(C_%Hwnd%_Pos_Height="")
		ControlGetPos , C_%Hwnd%_Pos_X1, C_%Hwnd%_Pos_Y1, C_%Hwnd%_Pos_Width, C_%Hwnd%_Pos_Height, , ahk_id %Hwnd%
	Erg:= C_%Hwnd%_Pos_Height
	return
}
IfMainGuiMinRestore:
	WinGet,GuiMinMax,MinMax,ahk_id %GuiWinHwnd%
	if(GuiMinMax=-1)
	{
		WinRestore,ahk_id %GuiWinHwnd%
	}
return
GuiDropFiles:
{
	BeschaeftigtAnzeige(1)
	if(A_GuiControl="")
	{
 		If((DieseThisX < A_GuiX) and (A_GuiX < (DieseThisX + DieseThisB))	and 	(DieseThisY < (A_GuiY-GuiYAbzuziehen)) and ((A_GuiY-GuiYAbzuziehen) < (DieseThisY + DieseThisH)))
		{
			BeschaeftigtAnzeige(-1)
			return
		}
	}
	If A_GuiControl is Integer
	{
		ZielPfadWirdUebrgeben:=true
		Zielpfad:=GetZeile(Edit5,A_GuiControl)
		DateiPfadeWerdenUebergeben:=true
		DateiPfade:=A_GuiEvent
		gosub KopiereOderVerschiebeFilesAndFolders
		BeschaeftigtAnzeige(-1)		
		return		
	}
	else If (A_GuiControl="Edit10")
	{
		If(Edit10="" or Edit10="Zusatz" )  ; ; IfNotExist %Edit10%
		{
			FileSelectFile,UbergabeProgramPfad,,,zu welchem Skript oder Programm sollen die Dateien uebergeben werden?,ausfuehrbare Dateien (*.*; *.ahk; *.exe; *.bat)
			if ErrorLevel
			{
				BeschaeftigtAnzeige(-1)
				return
			}
			IfNotExist %UbergabeProgramPfad%
			{
				BeschaeftigtAnzeige(-1)
				return
			}
			Edit10:=UbergabeProgramPfad
			gosub Edit10Festigen
		}
		Gui,1:Submit,NoHide
		StringSplit,GuiDropEinzelPfad,A_GuiEvent,`n,`r
		Run, %Edit10% "%GuiDropEinzelPfad1%" "%GuiDropEinzelPfad2%" "%GuiDropEinzelPfad3%" "%GuiDropEinzelPfad4%" "%GuiDropEinzelPfad5%" "%GuiDropEinzelPfad6%" "%GuiDropEinzelPfad7%" "%GuiDropEinzelPfad8%" "%GuiDropEinzelPfad9%" "%GuiDropEinzelPfad10%" "%GuiDropEinzelPfad11%" 
		if ZackZackOrdnerLogErstellen
			ThreadUeberwachungLog(A_LineNumber-1,A_ThisHotkey,A_ThisLabel,A_ThisFunc,A_ThisMenu,A_ThisMenuItem,A_ThisMenuItemPos)
		BeschaeftigtAnzeige(-1)
		return
	}
	else	If (A_GuiControl="┌> &Clip" or A_GuiControl="└> &Clip")							; DopFiles auf Button3: die angekommenen Pfade werden ins Clipboard geschrieben
	{
		StringReplace,Clipboard,A_GuiEvent,`n,`r`n,All
		TrayTip GuiDropFiles, dropped Files-Paths on Button3 ---> Clipboard
		BeschaeftigtAnzeige(-1)
		return
	}
	else	If (A_GuiControl=Button6Name)							; DopFiles auf Button6: siehe GuiDropFilesButton6.ahk
	{
		IfExist %A_ScriptDir%\GuiDropFilesButton6.ahk
		{
			run, "%A_ScriptDir%\GuiDropFilesButton6.exe" "%A_ScriptDir%\GuiDropFilesButton6.ahk"
			TrayTip GuiDropFiles, dropped Files-Paths send at GuiDropFilesButton6.ahk
		}
		BeschaeftigtAnzeige(-1)
		return
	}
	else	If (A_GuiControl="-> &I" or A_GuiControl="-> |")  ; 20160420234443 (Enter)")			; -> |   (Enter)	; DopFiles auf Button 2 wird so interpraetiert als moechte man die Datei im Oeffnen Dialog eines ahk_class #32770-Fensters eingeben.
	{
		WinActivate,ahk_class #32770
		StringSplit,GuiDropEinzelPfad,A_GuiEvent,`n,`r
		if(GuiDropEinzelPfad0>1)
		{																		; wenn mehrere Dateien kommen
			SplitPath,GuiDropEinzelPfad1,,GuiDropsDir
			DateinamenInHochKommasMitBlankGetrennt:=GuiDropsDir "\" A_Space
			Loop, % GuiDropEinzelPfad0
			{
				SplitPath,GuiDropEinzelPfad%A_Index%,GuiDropEinzelFilename%A_Index%
				DateinamenInHochKommasMitBlankGetrennt:=DateinamenInHochKommasMitBlankGetrennt A_Space Hochkomma GuiDropEinzelFilename%A_Index% Hochkomma  
			}
			MsgBox, 262180, GuiDropFiles Hinweis, Sollen wirklich mehrere Dateien als Uebergabe`n%DateinamenInHochKommasMitBlankGetrennt%`nan das Ziel von Button2 also in das Edit-Feld eines Oeffnen-Dialoges geschrieben werden?`n`nDies kann z.B. in Notepad++ verwendet werden`num mehrere Dateien gleichzeitig zu oeffnen.
			IfMsgBox,Yes
			{
				WinActivate,ahk_class #32770
				Gui,1:Submit,NoHide
				Edit8:=DateinamenInHochKommasMitBlankGetrennt
				gosub Edit8Festigen
				BsAnMerker:=BsAn
				BsAn:=0
				GuiControl,1:,%HwndCheckB2%,0
				gosub BsAn
				WinWaitActive,ahk_class #32770,,2
				if  ErrorLevel
				{
					BeschaeftigtAnzeige(-1)
					return
				}
				Sleep 10
				gosub Button2
				sleep 10
				if BsAnMerker
				{
					BsAn:=1
					GuiControl,1:,%HwndCheckB2%,1
					gosub BsAn
				}		
			}
			BeschaeftigtAnzeige(-1)
			return
		}
		Edit8:=GuiDropEinzelPfad1
		gosub Edit8Festigen
		WinWaitActive,ahk_class #32770,,2
		if  ErrorLevel
		{
			BeschaeftigtAnzeige(-1)
			return
		}
		gosub Button2
		return
	}
	else if(True or A_GuiControl="Edit5" Or A_GuiControl="Edit8")	; 	True entfernen wenn weiter aufgeschlüsselt werden soll ###################
	{
		if(A_GuiControl="Edit5")
		{
			ThisZeile:=round((((A_GuiY*DpiKorrektur - GuiYAbzuziehen*DpiKorrektur)-Edit5Y0*DpiKorrektur)+round(DpiKorrektur*ZeilenVersatzY/2))/(ZeilenVersatzY*DpiKorrektur))			; Edit5Y0:=125		Die 52 duerfte sich aus Unterkante Menue 50 +irgend ein Rand 2 zusammensetzen	Die TitelleistenPlusMenuHoehe duerfte mt 51 hinkommen
			Edit3:=ThisZeile
			GuiControl,1:, Edit3, %Edit3%
		gosub Edit3
		}
		DateiPfadeWerdenUebergeben:=true
		ControlText:=
		DateiPfade:=A_GuiEvent
		gosub KopiereOderVerschiebeFilesAndFolders
		BeschaeftigtAnzeige(-1)
		return
	}
}
Integer3Hex(Int,NullX="")			; NullX=[|x|X]		leer	->	hex (ohne Ox)		; 		x	->	0xhex		;		X	->	0xHEX
{
	if (NullX="")
		Hex:=Format("{1:x}",Int)
	else 
		Hex:=Format("{1:#" NullX "}",Int)
	return Hex
}
MinusStern_VorbereitetZumLoeschen:
Loop,Files,%FavoritenDirPath%\*.txt, F
{
	LoopFileLongPath:=A_LoopFileLongPath
	SplitPath,A_LoopFileLongPath,LoopFileLongName  ,LoopFileLongDir
	If (LoopFileLongName="")
	{
		LoopFileLongName:=LoopFileLongDir
		LoopFileLongPath:=SubStr(A_LoopFileLongPath,1,-4) LoopFileLongDir ".txt"
		StringReplace,LoopFileLongPath,LoopFileLongPath,:,˸,All
	}
	SplitPath,% FuehrendeSterneEntfernen(Edit8),ThisEdit8Name,ThisEdit8Dir
	If (ThisEdit8Name="")
		ThisEdit8Name:=ThisEdit8Dir
		StringReplace,ThisEdit8Name,ThisEdit8Name,:,˸,All
	if (LoopFileLongName=ThisEdit8Name ".txt")
	{
		FileRead,ThisFavoriteInhalt,%LoopFileLongPath%
		OldFavoriteInhalt:=ThisFavoriteInhalt
		ThisFavoriteInhalt:=ThisFavoriteInhalt "`r"
		StringReplace,NewFavoriteInhalt,ThisFavoriteInhalt,% "*" FuehrendeSterneEntfernen(Edit8) "`r", %  FuehrendeSterneEntfernen(Edit8) "`r"	; ,All
		StringReplace,NewFavoriteInhalt,NewFavoriteInhalt,`r`n`r,`r,All
		StringTrimRight,NewFavoriteInhalt,NewFavoriteInhalt,1
		if(OldFavoriteInhalt<>NewFavoriteInhalt)
		{
			if(InStr(NewFavoriteInhalt,"*"))
			{
				FileDelete,%LoopFileLongPath%
				if ErrorLevel
				{
					MsgBox, 262192, Fehler, Die Datei `n%LoopFileLongPath%`nkonnte nicht geloescht werden.`nSomit kann auch kein Stern entfernt werden.`nBitte manuell den Stern entfernen.
				}
				else
				{
					MsgBox %A_LineNumber%	FileAppend`,%NewFavoriteInhalt%`,%LoopFileLongPath%`,utf-16
					FileAppend,%NewFavoriteInhalt%,%LoopFileLongPath%,utf-16
					if ErrorLevel
					{
						MsgBox, 262192, Fehler, Die Datei `n%LoopFileLongPath%`nkonnte nicht erstellt werden.`nSomit konnte auch kein Stern entfernt werden.`nBitte manuell den Stern entfernen.
					}
				}
			}
			else
			{
				FileDelete,%LoopFileLongPath%
				if ErrorLevel
				{
					MsgBox, 262192, Fehler, Die Datei `n%LoopFileLongPath%`nkonnte nicht geloescht werden.`nSomit kann auch kein Stern entfernt werden.`nBitte manuell den Stern entfernen.
				}
			}				
		}
	}
}
	Edit3:=1
	GuiControl,1:, %HwndEdit3%, %Edit3%
	gosub Button1OhneMausPos
return
SpezialOrdnerAnlegen:
ClsIdVorlage=
(
Arbeitsplatz Dieser PC.{20d04fe0-3aea-1069-a2d8-08002b30309d}
Haeufig besuchte Orte Zuletzt verwendet Recent Places.{22877A6D-37A1-461A-91B0-DBDA5AAEBC99}
Systemsteuerung alle Tasks.{ED7BA470-8E54-465E-825C-99712043E01C}
Drucker.{2227A280-3AEA-1069-A2DE-08002B30309D}
)
loop,Parse,ClsIdVorlage,`n,`r
{
	FileCreateDir,% A_AppDataCommon "\Zack\ClsId\" A_LoopField
}
return
DrivesListErzeugen:
DriveNamesPfadList:=
; EnvGet, windir, windir
DriveGet,DriveNames1CList,List
StringSplit,LaufwerksBuchstabe,DriveNames1CList
Loop, % LaufwerksBuchstabe0
{
	DriveGet, DriveTyp, type,% LaufwerksBuchstabe%A_Index% ":"
	if (DriveTyp<>"CDROM")
	DriveNamesPfadList.=LaufwerksBuchstabe%A_Index% ":`r`n"
	;  MsgBox % LaufwerksBuchstabe%A_Index% ":	" DriveTyp
}
StringTrimRight,DriveNamesPfadList,DriveNamesPfadList,2
return
Edit5UpDown:
Gui,1:Submit,NoHide
IfWinActive,ahk_id %GuiWinHwnd%
{
	ControlGetFocus,ThisFocussedControl,A
	if (ThisFocussedControl="Edit5")
	{
		ControlFocus,Edit3,A
	}
}
	Edit3:=Edit5UpDown
	GuiControl,1:, %HwndEdit3%, %Edit3%
return
Up100:	; blaettert 100 Zeilen in der PfadListe Edit5 nach oben. Dito fuer die Folgenden Up#
Loop 10
{
	gosub ImmerUp
	Sleep, 100
}
Up90:
Loop 10
{
	gosub ImmerUp
	Sleep, 100
}
Up80:
Loop 10
{
	gosub ImmerUp
	Sleep, 100
}
Up70:
Loop 10
{
	gosub ImmerUp
	Sleep, 100
}
Up60:
Loop 10
{
	gosub ImmerUp
	Sleep, 100
}
Up50:
Loop 10
{
	gosub ImmerUp
	Sleep, 100
}
Up40:
Loop 10
{
	gosub ImmerUp
	Sleep, 100
}
Up30:
Loop 10
{
	gosub ImmerUp
	Sleep, 100
}
Up20:
gosub ImmerUp
Sleep, 100
Up19:
gosub ImmerUp
Sleep, 100
Up18:
gosub ImmerUp
Sleep, 100
Up17:
gosub ImmerUp
Sleep, 100
Up16:
gosub ImmerUp
Sleep, 100
Up15:
gosub ImmerUp
Sleep, 100
Up14:
gosub ImmerUp
Sleep, 100
Up13:
gosub ImmerUp
Sleep, 100
Up12:
gosub ImmerUp
Sleep, 100
Up11:
gosub ImmerUp
Sleep, 100
Up10:
gosub ImmerUp
Sleep, 100
Up9:
gosub ImmerUp
Sleep, 100
Up8:
gosub ImmerUp
Sleep, 100
Up7:
gosub ImmerUp
Sleep, 100
Up6:
gosub ImmerUp
Sleep, 100
Up5:
gosub ImmerUp
Sleep, 100
Up4:
gosub ImmerUp
Sleep, 100
Up3:
gosub ImmerUp
Sleep, 100
Up2:
gosub ImmerUp
Sleep, 100
Up:
Up1:
gosub ImmerUp
return
Down100:	; blaettert 100 Zeilen in der PfadListe Edit5 nach unten. Dito fuer die Folgenden Down#
Loop 10
{
	gosub ImmerDown
	Sleep, 100
}
Down90:
Loop 10
{
	gosub ImmerDown
	Sleep, 100
}
Down80:
Loop 10
{
	gosub ImmerDown
	Sleep, 100
}
Down70:
Loop 10
{
	gosub ImmerDown
	Sleep, 100
}
Down60:
Loop 10
{
	gosub ImmerDown
	Sleep, 100
}
Down50:
Loop 10
{
	gosub ImmerDown
	Sleep, 100
}
Down40:
Loop 10
{
	gosub ImmerDown
	Sleep, 100
}
Down30:
Loop 10
{
	gosub ImmerDown
	Sleep, 100
}
Down20:
gosub ImmerDown
Sleep, 100
Down19:
gosub ImmerDown
Sleep, 100
Down18:
gosub ImmerDown
Sleep, 100
Down17:
gosub ImmerDown
Sleep, 100
Down16:
gosub ImmerDown
Sleep, 100
Down15:
gosub ImmerDown
Sleep, 100
Down14:
gosub ImmerDown
Sleep, 100
Down13:
gosub ImmerDown
Sleep, 100
Down12:
gosub ImmerDown
Sleep, 100
Down11:
gosub ImmerDown
Sleep, 100
Down10:
gosub ImmerDown
Sleep, 100
Down9:
gosub ImmerDown
Sleep, 100
Down8:
gosub ImmerDown
Sleep, 100
Down7:
gosub ImmerDown
Sleep, 100
Down6:
gosub ImmerDown
Sleep, 100
Down5:
gosub ImmerDown
Sleep, 100
Down4:
gosub ImmerDown
Sleep, 100
Down3:
gosub ImmerDown
Sleep, 100
Down2:
gosub ImmerDown
Sleep, 100
Down:
Down1:
gosub ImmerDown
return
#IfWinActive,ZackZackOrdner ahk_class AutoHotkeyGUI
Up::	; 	eine Zeile hoch bei den Pfadmarkierungen
ImmerUp:	; 	eine Zeile hoch bei den Pfadmarkierungen
ControlGetFocus,ThisFocussedControl,A
if (ThisFocussedControl="Edit5")
{
	ControlSend,Edit5,{Up},ahk_id %GuiWinHwnd%	; ControlFocus,Edit5,ahk_id %GuiWinHwnd%	up		
	return
}
else
{
	Gui,1:Submit,NoHide
	if(Edit5UpDown>1)
		--Edit5UpDown
	GuiControl,1:, %HwndEdit5UpDown%, %Edit5UpDown%
	gosub Edit5UpDown
}
return
Down::	; 	eine Zeile runter bei den Pfadmarkierungen
ImmerDown:	; 	eine Zeile runter bei den Pfadmarkierungen
ControlGetFocus,ThisFocussedControl,A
if (ThisFocussedControl="Edit5")
{
	ControlSend,Edit5,{Down},ahk_id %GuiWinHwnd%
	return
}
else
{
	Gui,1:Submit,NoHide
		++Edit5UpDown
	GuiControl,1:, %HwndEdit5UpDown%, %Edit5UpDown%
	gosub Edit5UpDown
}
return
/*	
#IfWinActive,ZackZackOrdner
Up::
ControlGetFocus,ThisFocussedControl,A
if (ThisFocussedControl="Edit5")
{
	FocusEdit5:=true
}
else
	FocusEdit5:=false
if(Edit3>2)
{
	--Edit3
	GuiControl,1:, %HwndEdit3%, %Edit3%
	if FocusEdit5
		ControlFocus,Edit5,A
}
if false and FocusEdit5
{
thread,Priority,-20
Critical,Off
SoundBeep,6000,50
sleep,-1
sleep,-1
sleep,-1
sleep,-1
sleep,-1
sleep,-1
SoundBeep,6000,50
ControlFocus,Edit5,A
}
return
Down::
++Edit3
GuiControl,1:, %HwndEdit3%, %Edit3%
if FocusEdit5
{
thread,Priority,-20
Critical,Off
sleep,-1
sleep,-1
sleep,-1
sleep,-1
sleep,-1
sleep,-1
ControlFocus,Edit5,A
}
return
*/
F1::	; gib die Hilfe aus.
gosub Hilfe
return
F2::	; springe in Edit2 Suche und markiere alles zum ueberschreiben. P.S. anhaengen von \*, an den Suchstring, zeigt bei existierendem Such-Ergebnis, die Unterordner an.
Edit3:=1
GuiControl,1:, %HwndEdit3%, %Edit3%
ControlFocus,Edit2,A
ControlSend,Edit2,^a,A
Edit31F2:	; Edit3 --> 1 gefolgt von springe in Edit4 Befehlsentgegennahme und markiere alles zum ueberschreiben. 
return
Edit3:=1
GuiControl,1:, %HwndEdit3%, %Edit3%
#F2::	; springe in Edit4 Befehlsentgegennahme und markiere alles zum ueberschreiben. 
ControlFocus,Edit4,A
ControlSend,Edit4,^a,A
return
#F3::	; springe in Edit7 Filter und markiere alles zum ueberschreiben.
Edit3:=1
GuiControl,1:, %HwndEdit3%, %Edit3%
ControlFocus,Edit7,A
ControlSend,Edit7,^a,A
return
F3::	; springe in Edit3 Nr. Wahl und markiere alles zum ueberschreiben.
ControlFocus,Edit3,A
ControlSend,Edit3,^a,A
return
beschaeftigt:
; ControlClick,Button1,ahk_id %GuiWinHwnd%
gosub F5
return
#F4::	; Oeffnet Edit8
gosub Edit8Oeffnen
return
F4::	; aktiviert letzten Container
gosub LetzterContainer  
sleep 100
ControlFocus,Edit2,ahk_id %GuiWinHwnd%
return
F5::	; wie betaetigen von Button1 -> zum aktualisieren einiger Edit-Felder. funktionierte virtuell geklickt nicht immer 100-Prozentig.
; Gui,Submit,NoHide
SuchVerlauf()
IfWinActive,ahk_id %GuiWinHwnd%
{
	ControlGetFocus, FocusedGuiConntrol,A
	if (FocusedGuiConntrol<>"Edit3")
	{
		ControlFocus,Edit3,ahk_id %GuiWinHwnd%
		ControlSend,Edit3,^a,ahk_id %GuiWinHwnd%
	}
}
ThisEdit2:=Edit2
Edit2:="a1b2c3d4"
GuiControl,1:, %HwndEdit2%,%Edit2%
; sleep 4000
Edit2:=ThisEdit2
GuiControl,1:, %HwndEdit2%,%Edit2%
return
; gosub Button1
; gosub HwndButton1
; ControlFocus,Button1,ahk_id %GuiWinHwnd%
; ControlFocus,%GuiWinHwnd%,ahk_id %GuiWinHwnd%
; 20160,416220629 ; {
; Gui,Submit,NoHide
; MsgBox,,Zack,%Beschaeftigt%,2
; gosub BeschaeftigtEnd
F6::	; wie betaetigen von Button2 -> zum einfuegen des WunschOrdners ins Speichern unter bzw Oeffnen-Feldes des Fremdprogramms
gosub HwndButton2
return
F8::	; wie betaetigen von Button4 Explorer
gosub HwndButton4
return
F9::	; wie betaetigen von Button5 Copy-Move
gosub HwndButton5
return

PgDn::
; MsgBox % GuiHeight
ZeilenBlaettern:=Round(GuiHeight/200,0)*10
StringSplit,VorDotOverDot,Edit1,:
if(VorDotOverDot0>1)
{
	AnzahlZeichenLinksWeg:=0
	StringReplace,VorDotOverDot1,VorDotOverDot1,`(
	VorDotOverDot1:=VorDotOverDot1+ZeilenBlaettern
	Edit1:=VorDotOverDot1 . ":"
	gosub Edit1Festigen
}
else
{
	Edit1:=ZeilenBlaettern+1 ":"
	gosub Edit1Festigen
}
gosub Button1
; gosub F5
return
PgUp::
StringSplit,VorDotOverDot,Edit1,:
if(VorDotOverDot0>1)
{
	AnzahlZeichenLinksWeg:=0
	StringReplace,VorDotOverDot1,VorDotOverDot1,`(
	VorDotOverDot1:=VorDotOverDot1-ZeilenBlaettern
	if(VorDotOverDot1<1)
		VorDotOverDot1:=1
	Edit1:=VorDotOverDot1 . ":"
	gosub Edit1Festigen
}
gosub Button1
; gosub F5
return
/*
m12:
gosub NeuStarten
return		;		Menu, Dateimenü, 		Add, &Reload					, NeuStarten
m13:
gosub SkriptOrdnerOeffnen
return		; 		Menu, Dateimenü, 		Add, &Skript-Ordner oeffnen		, SkriptOrdnerOeffnen	
m14:
gosub DataOrdnerOeffnen
return		; 		Menu, Dateimenü, 		Add, &Data-Ordner oeffnen		, DataOrdnerOeffnen	
m15:
gosub TestumgebungErzeugen
return		; 		Menu, Dateimenü, 		Add, &Testumgebung erzeugen		, TestumgebungErzeugen	
m16:
gosub GuiClose
return		; 		Menu, Dateimenü, 		Add, &Beenden					, GuiClose
; Edit8
m21:
gosub Edit8Oeffnen
return		; 		Menu, Edit8menue, 		Add, &oeffnen					, Edit8Oeffnen
m22:
gosub Edit8NeuerOrdner
return 		;		Menu, Edit8Menue, 		Add, &neuer Ordner				, Edit8NeuerOrdner 
m23:
gosub Edit8ZeigeUnterOrdner
return		; 		Menu, Edit8Menue, 		Add, &zeige Unter-Ordner		, Edit8ZeigeUnterOrdner
m24:
gosub Edit8Explorer
return		; 		Menu, Edit8Menue, 		Add, &Explorer					, Edit8Explorer
m25:
gosub WurzelContainerUebersichtErzeugenAnzeigen
return		; 		Menu, ContainerMenue, 	Add, Uebersicht &erzeugen		, WurzelContainerUebersichtErzeugenAnzeigen  
m26:
gosub Edit8ExplorerSelect
return		; 		Menu, Edit8Menue, 		Add, &Explorer Select			, Edit8ExplorerSelect
m27:
gosub Edit8ExplorerEingebunden
return			; 	Menu, Edit8Menue, 		Add, &Zeige Inhalte				, Edit8ExplorerEingebunden
m28:
gosub Edit8Umbenennen
return			; 	Menu, Edit8Menue, 		Add, &umbenennen				, Edit8Umbenennen
m29:
gosub DateiSucheAusgehendVonEdit8
return			; 	Menu, Edit8Menue, 		Add, &DateiSucheE				, DateiSucheAusgehendVonEdit8
; Container
m31:
gosub WurzelContainerUebersichtOeffnen
return		; 		Menu, ContainerMenue, 	Add, &Uebersicht oeffnen		, WurzelContainerUebersichtOeffnen
m32:
gosub WurzelContainerOeffnen
return 		;		Menu, ContainerMenue, 	Add, &oeffnen					, WurzelContainerOeffnen  
m33:
gosub ContainerAnlegen
return		; 		Menu, ContainerMenue, 	Add, &anlegen					, ContainerAnlegen  
m34:
gosub ContainerLoeschen
return		; 		Menu, ContainerMenue, 		Add, &loeschen				, ContainerLoeschen  
m35:
gosub WurzelContainerUebersichtErzeugenAnzeigen
return		; 		Menu, ContainerMenue, 	Add, Uebersicht &erzeugen		, WurzelContainerUebersichtErzeugenAnzeigen  
m36:
gosub ContainerUebersichtZeigen
return		; 		Menu, ContainerMenue,	Add, &Container Uebersicht ohne speichern				, Container
m37:
gosub DelCache
return			; 	Menu, ContainerMenue,	Add, &Alle loeschen				, DelCache
; Wurzel
m41:
gosub WurzelVonDateiHinzuFuegen
return		; 		Menu, StartPfadMenue, 	Add, von &Datei einlesen`tCtrl+O, WurzelVonDateiHinzuFuegen  ; Siehe untere Bemerkungen zu Ctrl+F.
m42:
gosub WurzelHinzuFuegen
return			; 	Menu, StartPfadMenue, 	Add, &einlesen`tCtrl+O			, WurzelHinzuFuegen  ; Siehe untere Bemerkungen zu Ctrl+F.
m43:
gosub WurzelnAktualisieren
return			; 	Menu, StartPfadMenue, 	Add, &aktualisieren ...			, WurzelAktualisieren ; 
m44:
gosub WurzelLoeschen
return			;	Menu, StartPfadMenue, 	Add, &Loeschen ...				, WurzelLoeschen  ; 
m45:
gosub StartPfadeUebersicht
return			;	Menu, StartPfadMenue, 	Add, &uebersicht			, StartPfadeUebersicht  ; 
; Favoriten
m51:
gosub FavoritSpeichern
return		; 		Menu, FavMenue, 		Add, &speichern					, FavoritSpeichern
m52:
gosub FavoritOeffnen
return		; 		Menu, FavMenue, 		Add, &oeffnen					, FavoritOeffnen
m53:
gosub PlusStern
return		; 		Menu, FavMenue, 		Add, &plus *					, PlusStern
m54:
gosub MinusStern
return		; 		Menu, FavMenue, 		Add, &minus *					, MinusStern
m55:
gosub FavoritenOrdnerOeffnen
return		; 		Menu, FavMenue, 		Add, &Ordner oeffnen			, FavoritenOrdnerOeffnen
; Macro
m61:
gosub StaOrdnerBefehlsDateiPfadOeffnen
return		; 		Menu, MacroMenue, 		Add, &Ordner oeffnen			, StaOrdnerBefehlsDateiPfadOeffnen
m62:
gosub UserSelBefehlsDateiPfadAusfuehren
return		; 		Menu, MacroMenue, 		Add, &Starten...				, UserSelBefehlsDateiPfadAusfuehren
m63:
gosub BefehlsVariableAusfuehren
return		; 		Menu, MacroMenue, 		Add, &nochmals starten			, BefehlsVariableAusfuehren
m64:
gosub MusterDateienErzeugen
return		; 		Menu, MacroMenue, 		Add, &Muster-Dateien			, MusterDateienErzeugen
m65:
gosub ListLabels
return		; 		Menu, MacroMenue, 		Add, &Befehls-Liste				, ListLabels
; Optionen
m81:
gosub SitzungsEinstellungenMerken
return		; 		Menu, OptionsMenue, 	Add, &Sitzungs-Einst. speichern				, SitzungsEinstellungenMerken
m82:
gosub SitzungsEinstellungenEinlesen
return		; 		Menu, OptionsMenue, 	Add, &Sitzungs-Einst. einlesen				, SitzungsEinstellungenEinlesen
m83:
gosub SitzungsEinstellungenBearbeiten
return		; 		Menu, OptionsMenue, 	Add, &Sitzungs-Einst. bearbeiten				, SitzungsEinstellungenBearbeiten
m84:
gosub Einstellungen
return		; 		Menu, OptionsMenue, 	Add, &Einstellungen				, Einstellungen
; Hilfe
m91:
gosub LangsamDemoToggle
return		; 		Menu, Hilfsmenü, 		Add, &Verlangsamte Demo			, LangsamDemoToggle
m92:
gosub Info
return		; 		Menu, Hilfsmenü, 		Add, Inf&o						, Info
m93:
gosub Hilfe
return		; 		Menu, Hilfsmenü, 		Add, &Hilfe						, Hilfe
*/
RunTastWatch:	; erstellt und kopiert und startet TastWatch.ahk bzw. -exe . Der TastWatch-Quelltext ist vollstaendig in der Variablen TastWatch dieses Skriptes gespeichert. Sodass die TastWatch.ahk bei Bedarf erzeugt wird.
if ZackZackOrdnerLogErstellen
	ThreadUeberwachungLog(A_LineNumber-1,A_ThisHotkey,A_ThisLabel,A_ThisFunc,A_ThisMenu,A_ThisMenuItem,A_ThisMenuItemPos)
Gosub VarTastWatcherzeugen
if ZackZackOrdnerLogErstellen
	ThreadUeberwachungLog(A_LineNumber-1,A_ThisHotkey,A_ThisLabel,A_ThisFunc,A_ThisMenu,A_ThisMenuItem,A_ThisMenuItemPos)
DetectHiddenWindows,On
IfWinExist,ButtonGUI
{
	DetectHiddenWindows,Off
	return
}
DetectHiddenWindows,Off
IfWinNotExist,ButtonGUI
{
	WinClose,%A_temp%
	FileDelete, %A_AppDataCommon%\Zack\TastWatch.ahk
	FileAppend, %TastWatch%, %A_AppDataCommon%\Zack\TastWatch.ahk,utf-16
	if ZackZackOrdnerLogErstellen
		ThreadUeberwachungLog(A_LineNumber-1,A_ThisHotkey,A_ThisLabel,A_ThisFunc,A_ThisMenu,A_ThisMenuItem,A_ThisMenuItemPos)
	IfExist %A_ScriptDir%\GeKoOb.ico
		FileCopy,%A_ScriptDir%\GeKoOb.ico, %A_AppDataCommon%\Zack\GeKoOb.ico
	if ZackZackOrdnerLogErstellen
		ThreadUeberwachungLog(A_LineNumber-1,A_ThisHotkey,A_ThisLabel,A_ThisFunc,A_ThisMenu,A_ThisMenuItem,A_ThisMenuItemPos)
	IfExist %A_ScriptDir%\GeKoRe.ico
		FileCopy,%A_ScriptDir%\GeKoRe.ico, %A_AppDataCommon%\Zack\GeKoRe.ico
	TastWatchRunRueck:=IfExistCallEExeOrAhk(A_AppDataCommon "\Zack\TastWatch.ahk")
	If TastWatchRunRueck
	{
		TastWatchPid:=TastWatchRunRueck
		return
	}
	RunOtherAhkScript(A_AppDataCommon "\Zack\TastWatch.ahk")
	if ZackZackOrdnerLogErstellen
		ThreadUeberwachungLog(A_LineNumber-1,A_ThisHotkey,A_ThisLabel,A_ThisFunc,A_ThisMenu,A_ThisMenuItem,A_ThisMenuItemPos)
	TastWatchPid:=RunPid
	WinClose,%A_temp%
	return
}
WinClose,%A_temp%
return
BereiteVorDir2Paths:	; erstellt Dir2Path.ahk und kopiert die Dir2Path-Dateien an die benoetigten Orte. Der Dir2Path-Quelltext ist vollstaendig in der Variablen Dir2Paths dieses Skriptes gespeichert. Sodass die Dir2Path.ahk bei Bedarf erzeugt werden kann.
Dir2Paths=
(
#NoEnv
; MsgBox `% A_FileEncoding
IfExist GeKoOb.ico
	Try Menu,Tray,icon,GeKoOb.ico
Try Menu,Tray,Add 	; Trennlinie
FilePattern0 =`%0`%
if(FilePattern0<2)
; if false			; ################################ wieder weg erledigt pruefen
{
	MsgBoxText=
`(
`%A_ScriptName`% benoetigt 2 Uebergabe-Parameter:
 1. Pfad des zu bildenden Caches  (z.B. C:\ProgramData\Zack\WuCont\Haupt)
 2. FilePattern der zu cachenden Wurzeln (z.B. c:\*)
 optional
 3 (und weitere``, wie 2.)
Skriptende
`)
	MsgBox, 262160, Fehler, `%MsgBoxText`%
	ExitApp
}
else
{
	IfExist `%A_Temp`%\Dir2PathSilentStartPfade.txt
	FileRead,SilentStartPfade,`%A_Temp`%\Dir2PathSilentStartPfade.txt	; auslesen der Pfade, bei dene nicht ausgegeben wird 
	loop, `% FilePattern0 
	{
		FilePattern`%A_Index`% :=`%A_Index`% 
	; MsgBox `% FilePattern`%A_Index`%  "	" A_Index
		if (not InStr(Filepattern`%A_Index`%,"*") and A_index>1)
		{
			IfExist `% Filepattern`%A_Index`%
			{
				FileRead,InhaltFilepattern`%A_Index`%, `% Filepattern`%A_Index`%
				; MsgBox `% InhaltFilepattern`%A_Index`%
				InhaltFilepatternListe:=InhaltFilepatternListe      "``r``n"         InhaltFilepattern`%A_Index`%
			}
		}
		else 
			InhaltFilepatternListe:=InhaltFilepatternListe      "``r``n"       Filepattern`%A_Index`%
	}
	StringTrimLeft,InhaltFilepatternListe,InhaltFilepatternListe,2
	if FehlerSuche
		MsgBox `% InhaltFilepatternListe
	Loop,Parse,InhaltFilepatternListe,``n,``r
	{
		If(A_Index<2)
			continue
		Filepattern`%A_Index`%:=A_LoopField ;  A_Tab A_Index
		Filepattern0:=A_Index
		; MsgBox `% Filepattern`%A_Index`% 
	}
}
Try Menu,Tray,Add ,`%FilePattern1`%,StandAnzeige
Try Menu,Tray,Disable,`%FilePattern1`%
; SkriptDataPath=`%A_AppDataCommon`%\Zack
SkriptDataPath:=FilePattern1
IfNotExist `%SkriptDataPath`%
	FileCreateDir, `%SkriptDataPath`%
; run, explorer.exe /select``,"`%SkriptDataPath`%" ; ###################################################
; run `%SkriptDataPath`%
WurzelIndexPath=`%SkriptDataPath`%\WurzelIndex.txt
; msgbox >`%SkriptDataPath`%<	
WurzelIndex:=100
IfExist `%WurzelIndexPath`%
{
	FileRead,WurzelIndex,`%WurzelIndexPath`%
	FileDelete,`%WurzelIndexPath`%
}
{
	if FehlerSuche
		MsgBox `%WurzelIndexPath`% wuerde nicht existieren
	WurzelIndexFile:=WurzelIndex + FilePattern0 -1		;  berechnet den Index
	FileAppend,`%WurzelIndexFile`%,`%WurzelIndexPath`%,UTF-16	; 	schreibt den Index in WurzelIndex.txt
}
; MsgBox `% WurzelIndex
BackSlash=\
Stern=*
FileappendFehlerGes:=0
Loop, `% FilePattern0 
{
	if(A_Index="1")
		{
			StringReplace,CachePath,FilePattern1,*,,All
			continue
		}
	ThisI:=
	Index:=A_Index
	UebergebenerFilePattern:=FilePattern`%Index`%
	StringReplace,ThisFilePatternOhnestern,FilePattern`%Index`%,*,,All
	if (SubStr(ThisFilePatternOhnestern,0,1)="\")
		StringTrimRight,ThisFilePatternPath,ThisFilePatternOhnestern,1
	if (SubStr(ThisFilePatternOhnestern,1,1)="+")
	{
		StringTrimLeft,FilePattern`%Index`%,FilePattern`%Index`%,1
		DateienEinlesen:="F"
;		TabAnf:="\"
	}
	else
		DateienEinlesen:=""
	if (SubStr(ThisFilePatternOhnestern,2,1)="+")
	{
		StringTrimLeft,FilePattern`%Index`%,FilePattern`%Index`%,1
		DCEnde:="F"
		TabAnf:=A_Tab
	}
	else
	{
		DCEnde:=""
		TabAnf:="\"
	}
	Try Menu,Tray,Add,`% FilePattern`%Index`% "()",StandAnzeige
	Silent:=false
	If (SilentStartPfade<>"")
	{
		if(InStr(SilentStartPfade,ThisFilePatternPath))
			Silent:=true
	}
	ThisFilePattern:=FilePattern`%Index`%
	FileAppend,`%UebergebenerFilePattern`%,`%SkriptDataPath`%\Wurzel`%WurzelIndex`%.txt,UTF-16
	; CashPathWNr=`%SkriptDataPath`%\DP`%WurzelIndex`%				; DP steht fuer Dir 2 Path(s)
	; ThisFilePatternSpeicherName:=SubStr(ThisFilePattern,1,-2)	; entfernt 2 Zeichen rechts
	StringReplace,ThisFilePatternSpeicherName,ThisFilePattern,`%Stern`%,°,All
	StringReplace,ThisFilePatternSpeicherName,ThisFilePatternSpeicherName,:,˸
	StringReplace,ThisFilePatternSpeicherName,ThisFilePatternSpeicherName,`%BackSlash`%,►,All
	ThisFilePatternSpeicherName=`%WurzelIndex`%_`%ThisFilePatternSpeicherName`%
	; CashPathWNr=`%SkriptDataPath`%\DP`%WurzelIndex`%	
	CashPathWNr=`%SkriptDataPath`%\`%ThisFilePatternSpeicherName`%				; c:\temp\Zack\WuCont\Haupt\c˸►\AllG\Gegenst
	IfNotExist `%CashPathWNr`%
		FileCreateDir, `%CashPathWNr`%
	if(DCEnde="F")
	{
		IfNotExist `%CashPathWNr`%F
			FileCreateDir, `%CashPathWNr`%F
	}
	FileappendFehler:=0
	ThisFilePattern:=FilePattern`%Index`%
	Rekursiv:=true
	if(SubStr(ThisFilePattern,-1)="-R")
	{
		Rekursiv:=false
		StringTrimRight,ThisFilePattern,ThisFilePattern,2
	}
	StringTrimRight,ThisFilePatternPath,ThisFilePattern,2
	IfExist `%ThisFilePatternPath`%
	{
		SplitPath,ThisFilePattern,ThisFilePatternName,ThisFilePatternDir,ThisFilePatternExt,ThisFilePatternDrive
		StringReplace,ThisFilePatternSpeichername,ThisFilePatternDir,:,˸
		SplitPath, ThisFilePatternDir,ThisFilePatternDirName
		; MsgBox `% ThisFilePatternSpeichername A_Tab ThisFilePatternDirName
		if(ThisFilePatternDirName<>"")
		{
			FileAppend,``r``n`%ThisFilePatternPath`%, `%CashPathWNr`%\`%ThisFilePatternDirName`%.txt,UTF-16		; 
			; FileAppend,``r``n*`%ThisFilePatternPath`%, `%CashPathWNr`%\`%ThisFilePatternDirName`%.txt		; eher doch kein Grund-Stern fuer Drives
			ThisFolderNames:=ThisFolderNames "``r``n" ThisFilePatternDirName
		}
		else
		{
			FileAppend,``r``n`%ThisFilePatternPath`%, `%CashPathWNr`%\`%ThisFilePatternSpeichername`%.txt,UTF-16
			; FileAppend,``r``n*`%ThisFilePatternPath`%, `%CashPathWNr`%\`%ThisFilePatternSpeichername`%.txt	; eher doch kein Grund-Stern fuer Drives
			ThisFolderNames:=ThisFolderNames "``r``n" ThisFilePatternSpeichername
		}
	}
	; MsgBox Loop,Files,`%ThisFilePattern`%, D R
	If Rekursiv
	{	
		; i:=0
		Loop,Files,`%ThisFilePattern`%, D `%DateienEinlesen`% R
		{
			; Path	A_LoopFileLongPath
			; Dir	A_LoopFileName
			;  MsgBox FileAppend,``r``n`%A_LoopFileLongPath`%, `%CashPathWNr`%\`%A_LoopFileName`%.txt
			if(InStr(A_LoopFileAttrib,"D"))
			{
				OKe:=
				Einger:="\"
			}
			else
			{
				OKe:=DCEnde
				Einger:=TabAnf
			}
			if(inStr(A_LoopFileLongPath,CachePath))
				continue
			if(not inStr(A_LoopFileLongPath,"►"))
			{
				DisplayName:=GetDisplayName(A_LoopFileLongPath)
				if(InStr(A_LoopFileName,DisplayName))
					DisplayName=
				; MsgBox `%CashPathWNr`%`%OKe`%\`%A_LoopFileName`%.txt|`%Einger`%`%A_LoopFileLongPath`%
			FileAppend, `% "``r``n"   A_LoopFileDir Einger A_LoopFileName , `%CashPathWNr`%`%OKe`%\`%DisplayName`%`%A_LoopFileName`%.txt,UTF-16
			if ErrorLevel
			{
				FileAppend, `% "``r``n"   A_LoopFileDir Einger A_LoopFileName , `%CashPathWNr`%`%OKe`%\`%A_LoopFileName`%.txt,UTF-16
				if ErrorLevel
					++FileappendFehlerGes, ++FileappendFehler
			}
			i:=A_Index
			; ThisFolderNames:=ThisFolderNames "``r``n" A_LoopFileName
			}
		}
	}
	else
	{
		; i:=0
		Loop,Files,`%ThisFilePattern`%, D `%DateienEinlesen`%
		{
			; Path	A_LoopFileLongPath
			; Dir	A_LoopFileName
			;  MsgBox FileAppend,``r``n`%A_LoopFileLongPath`%, `%CashPathWNr`%\`%A_LoopFileName`%.txt
			if(InStr(A_LoopFileAttrib,"D"))
			{
				OKe:=
				Einger:="\"
			}
			else
			{
				OKe:=DCEnde
				Einger:=TabAnf
			}
			if(inStr(A_LoopFileLongPath,CachePath))
				continue
			if(not inStr(A_LoopFileLongPath,"►"))
			{
				DisplayName:=GetDisplayName(A_LoopFileLongPath)
				if(InStr(A_LoopFileName,DisplayName))
					DisplayName=
				; MsgBox `%CashPathWNr`%`%OKe`%\`%A_LoopFileName`%.txt|`%Einger`%`%A_LoopFileLongPath`%
			FileAppend, `% "``r``n"   A_LoopFileDir Einger A_LoopFileName , `%CashPathWNr`%`%OKe`%\`%DisplayName`%`%A_LoopFileName`%.txt,UTF-16
			if ErrorLevel
			{
				FileAppend, `% "``r``n"   A_LoopFileDir Einger A_LoopFileName , `%CashPathWNr`%`%OKe`%\`%A_LoopFileName`%.txt,UTF-16
				if ErrorLevel
					++FileappendFehlerGes, ++FileappendFehler
			}
			i:=A_Index
			; ThisFolderNames:=ThisFolderNames "``r``n" A_LoopFileName
			}
		}
	}
		if(i="0")
			EinleseZustand=nicht (eventuell Syntax-Fehler im FilePattern dieser Wurzel)
		else If (FileappendFehler="0")
		{
			EinleseZustand=erfolgreich
			SplitPath,CashPathWNr,CashPathWNrName,CashPathWNrDir
			StringTrimLeft,CashPathWNrNameOhneNr,CashPathWNrName,3
			Loop,`% CashPathWNrDir "\*" CashPathWNrNameOhneNr,2
			{
				if(not InStr(A_LoopFileLongPath,CashPathWNrName))
				{
					FileRemoveDir, `%A_LoopFileLongPath`% , 1 
					FileDelete `% A_LoopFileDir "\Wurzel" SubStr(A_LoopFileName,1,3) ".txt"
				}
			}
			if (DCEnde="F")
			{
			Loop,`% CashPathWNrDir "\*" CashPathWNrNameOhneNr DCEnde,2
				{
					if(not InStr(A_LoopFileLongPath,CashPathWNrName))
					{
						FileRemoveDir, `%A_LoopFileLongPath`% , 1
						FileDelete `% A_LoopFileDir "\Wurzel" SubStr(A_LoopFileName,1,3) ".txt"
					}
				}
			} 
		}
		else if(FileappendFehler=i)
			EinleseZustand=nicht
		else 
			EinleseZustand=teilweise
		if not Silent
			MsgBoxText:= A_ScriptName " meldet: ``n``nDie Wurzel ``n	" ThisFilePattern "``nwurde " EinleseZustand " in den Cache ``n	" CashPathWNr "``neingelesen.``n``n(" FileappendFehler " Einlesefehler von " i " einzulesenden Ordnernamen)"
		if (FileappendFehler/i>0.1 or i=0)							; MsgBox, 64, p, , 15
			MsgBox, 262160, Fehler,`%MsgBoxText`%
		else if(FileappendFehler=0)
		{
			if not Silent
				MsgBox,64,OK,`%MsgBoxText`%,15
		}
		else
			MsgBox,`%MsgBoxText`%
	++WurzelIndex 
	gosub StandAnzeige
	Menu,Tray,Disable,`% FilePattern`%Index`% "(" LastI ")"
	LastI:=
}
StringTrimLeft,ThisFolderNames,ThisFolderNames,2
sort,ThisFolderNames,U
WurzelindexMinus1:=WurzelIndex -1
; FileAppend,`%ThisFolderNames`%,`%SkriptDataPath`%\FolderNames`%WurzelindexMinus1`%.txt,UTF-16
if(WurzelIndexFile<>WurzelIndex)
	MsgBox, 262160,`%A_ScriptName`%	`%A_LineNumber`% Fehler, unbekannter Fehler
if not Silent
	{
	run `%CashPath`%	
	}
ExitApp
StandAnzeige:
	ThisI:=i
	Menu,Tray,Rename,`% FilePattern`%Index`% "(" LastI ")",`% FilePattern`%Index`% "("  ThisI  ")"
	LastI:=ThisI
return
GetDisplayName(FileOrFolder) ; Danke Just Me
{
   Static IID_IShellItem := 0
          Init := VarSetCapacity(IID_IShellItem, 16, 0)
                  . DllCall("Ole32.dll\IIDFromString", "WStr", "{43826d1e-e718-42ee-bc55-a1e261c37bfe}", "Ptr", &IID_IShellItem)
   DisplayName := ""
   If !DllCall("Shell32.dll\SHCreateItemFromParsingName", "WStr", FileOrFolder, "Ptr", 0, "Ptr", &IID_IShellItem, "PtrP", Item) {
      GetDisplayName := NumGet(NumGet(Item + 0, "UPtr"), A_PtrSize * 5, "UPtr")
      If !DllCall(GetDisplayName, "Ptr", Item, "UInt", 0, "PtrP", StrPtr) { ; SIGDN_NORMALDISPLAY = 0
         DisplayName := StrGet(StrPtr, "UTF-16")
         , DllCall("Ole32.dll\CoTaskMemFree", "Ptr", StrPtr)
      }
      ObjRelease(Item)
   }
   Return DisplayName
}
)
IfExist %A_ScriptDir%\GeKoOb.ico
	FileCopy,%A_ScriptDir%\GeKoOb.ico, %A_AppDataCommon%\Zack\GeKoOb.ico										; hier waren 2 \\ vor dem ersten Dir2Paths.exe
if ZackZackOrdnerLogErstellen
	ThreadUeberwachungLog(A_LineNumber-1,A_ThisHotkey,A_ThisLabel,A_ThisFunc,A_ThisMenu,A_ThisMenuItem,A_ThisMenuItemPos)
FileCopy,%A_ScriptDir%\Dir2Paths.exe, %A_AppDataCommon%\Zack\Dir2Paths.exe										; hier waren 2 \\ vor dem ersten Dir2Paths.exe
if ZackZackOrdnerLogErstellen
	ThreadUeberwachungLog(A_LineNumber-1,A_ThisHotkey,A_ThisLabel,A_ThisFunc,A_ThisMenu,A_ThisMenuItem,A_ThisMenuItemPos)
FileCopy,%A_ScriptDir%\TastWatch.exe, %A_AppDataCommon%\Zack\TastWatch.exe										; dito
if ZackZackOrdnerLogErstellen
	ThreadUeberwachungLog(A_LineNumber-1,A_ThisHotkey,A_ThisLabel,A_ThisFunc,A_ThisMenu,A_ThisMenuItem,A_ThisMenuItemPos)
FileDelete, %A_AppDataCommon%\Zack\Dir2Paths.ahk
if ZackZackOrdnerLogErstellen
	ThreadUeberwachungLog(A_LineNumber-1,A_ThisHotkey,A_ThisLabel,A_ThisFunc,A_ThisMenu,A_ThisMenuItem,A_ThisMenuItemPos)
FileAppend, %Dir2Paths%, %A_AppDataCommon%\Zack\Dir2Paths.ahk,utf-16
if ZackZackOrdnerLogErstellen
	ThreadUeberwachungLog(A_LineNumber-1,A_ThisHotkey,A_ThisLabel,A_ThisFunc,A_ThisMenu,A_ThisMenuItem,A_ThisMenuItemPos)
return
SetThisFafCopy:
ThisFafFolderPath:=SkriptDataPath "\!Fav"
Clipboard:=ThisFafFolderPath
MsgBox, 262144, Sicherung Favoriten, Der QuellPfad dieser Favoriten 	`n	%ThisFafFolderPath%`nist im Clipboard.`nBitte `,bei gewuenschter Sicherung`, den ZielSicherungsOrdnerPfad in Edit8 erzeugen und klick auf Button5`n`nweiter mit	OK`n`nHinweis: ein neu zu erzeugender Ordner kann manuell and Edit8 angefuegt werden.
return
GetThisFafCopy:
ThisFafFolderPath:=SkriptDataPath "\!Fav"
MsgBox, 262436, Favoriten Ruecksichern, sollen frueher gesicherte Favoriten restauriert werden?
IfMsgBox,Yes
{
	Edit2Merker:=Edit2
	Edit2=!Fav
	gosub Edit2Festigen
	MsgBox, 262176, Restaurierung Favoriten, Bitte den Quellpfad der frueher gesicherten Favoriten in Edit8 bringen`ndanach weiter mit OK
	IfExist % FuehrendeSterneEntfernen(Edit8)
	{
		; Clipboard:=FuehrendeSterneEntfernen(Edit8)
		; FileDelete,%ThisFafFolderPath%
		MsgBox, 262180, Kopieren bestaetigen, % "Kopieren bestaetigen`n 	" FuehrendeSterneEntfernen(Edit8) "`nnach`n 	" ThisFafFolderPath
		IfMsgBox,Yes
		{
			FileCopyDir,% FuehrendeSterneEntfernen(Edit8),%ThisFafFolderPath%,1
			if ErrorLevel
				MsgBox Fehler beim Kopieren
		}
	}
	Edit2:=Edit2Merker
	gosub Edit2Festigen
}
return
AktuelleStartPfade2Awpf:
AwpfInhalt:=
Loop,% SkriptDataPath "\Wurzel???.txt",1
{
	StartPfadIndex:=SubStr(A_LoopFileName,7,3)
	IfExist % SkriptDataPath "\" StartPfadIndex "*"
	{
		FileRead,SoEingelesen,%A_LoopFileLongPath%
		StringReplace,FastSoEingelesen,SoEingelesen,+,,All
		StringReplace,FastSoEingelesen,FastSoEingelesen,*,,All
		if(SubStr(FastSoEingelesen,-1)="-R")
			StringTrimRight,FastSoEingelesen,FastSoEingelesen,2
		IfExist %FastSoEingelesen%
			AwpfInhalt.=SoEingelesen "`r`n"
	}
	else
	{
		if (not InStr(A_LoopFileLongPath,"Index"))
			FileDelete %A_LoopFileLongPath%
	}
}
StringTrimRight,AwpfInhalt,AwpfInhalt,2
AwpfPfad:=ZackData "\StartPfadeVomAktContainer.Awpf"
MsgBox, 262180, Aktuelle Start-Pfade, Die zu aktualisierenden Start-Pfade`n`n%AwpfInhalt%`n`nsind in `n	%AwpfPfad%`n`nzwischengespeichert:`n`n`nWeiter?
IfMsgBox,No
	return
FileDelete, %AwpfPfad%
FileAppend, %AwpfInhalt%,%AwpfPfad%,UTF-16
if ErrorLevel
{
	MsgBox, 0, SchreibFehler, Konnte `n	%AwpfInhalt%`nnicht anlegen.
}
gosub WurzelVonBekannterDateiHinzuFuegen
return
	; WinWait,ahk_exe Dir2Paths.exe,,%ThisWinWaitMax%
	; ZuLoeschendeWurzelDotTxt:=ThisWurzelTxtPfad
	; if Fehlersuche
	; 	MsgBox loesche im naechsten Schritt: %ZuLoeschendeWurzelDotTxt%
	; gosub WurzelLoeschenBeiVorhandenerWurzelTxt
IeControl: ; wenn IeAnz --> Aktiviert die Explorer-Ansicht. Verschiebt dazu die betroffenen Controls.
if IeAnz
{
	Edit8Sternlos:=FuehrendeSterneEntfernen(Edit8)
	if (substr(Edit8Sternlos,-3)=".lnk")
	{
		FileGetShortcut, %Edit8Sternlos% ,Edit8Sternlos
	}
	IfExist % Edit8Sternlos
	{
		if (InStr(Edit8Sternlos,"http:") or InStr(Edit8Sternlos,"https:") or InStr(Edit8Sternlos,"ftp:") or InStr(Edit8Sternlos,"File:"))  
			WB.Navigate(Edit8Sternlos) ; dieser Zweig wird warscheinlixch nie benutzt
		else
			WB.Navigate(WBvor Edit8Sternlos "\") 
		GuiControl,1: Move, %HwndIe1%, x136	w%Edit5Breite20%	h%Edit5Hoehe%				; x141 	y%Edit5Y0% w350	h240 HWNDHwndIe1 vWB
		GuiControl,1: Move, Edit5, x600 hide
		return
	}
	else if (InStr(Edit8Sternlos,"http:") or InStr(Edit8Sternlos,"https:") or InStr(Edit8Sternlos,"ftp:") or InStr(Edit8Sternlos,"File:"))
	{
		WB.Navigate(Edit8Sternlos) 
		GuiControl,1: Move, %HwndIe1%, x136	w%Edit5Breite20%	h%Edit5Hoehe%				; x141 	y%Edit5Y0% w350	h240 HWNDHwndIe1 vWB
		GuiControl,1: Move, Edit5, x600 hide
		return
	}
}
{
	GuiControl,1: Move, Edit5, x136 	w%Edit5Breite20%	h%Edit5Hoehe%				; x141 	y%Edit5Y0% w350	h240 HWNDHwndIe1 vWB
	GuiControl,1: Move, %HwndIe1%, x600 hide
}
return
RLShift:	; Toggle Explorer-Fensteransicht <---> Pfadlisten-Ansicht
ControlFocus,IeAnz,ahk_id %HwndGuiWin%
ControlClick,IeAnz,ahk_id %HwndGuiWin%
if IeAnz
{
	WinSetTitle,ahk_id %HwndGuiWin%,,ZackZackDateien
	IeAnz:=false
	GuiControl,1:, %HwndCheckK5%, 0 ;  %IeAnz%
}
else
{
	WinSetTitle,ahk_id %HwndGuiWin%,,ZackZackOrdner
	IeAnz:=true
	GuiControl,1:, %HwndCheckK5%, 1 ;  %IeAnz%
}
gosub F5
return
IeAnz:	; Toggle IeAnz und ist reserviert fuer Wintitelaenderung ZackZackOrdner <---> ZackZackDateien
Gui,1:Submit,NoHide
if IeAnz
{
	IeAnz:=true
	GuiControl,1:, %HwndCheckK5%, 1 ;  %IeAnz%
}
else
{
	; WinSetTitle,ahk_id %HwndGuiWin%,,ZackZackOrdner
	IeAnz:=false
	GuiControl,1:, %HwndCheckK5%, 0 ;  %IeAnz%
}
gosub Button1OhneMausPos
return
NormalAnzeige:
if IeAnz
{
	IeAnz:=false
	GuiControl,1:, %HwndCheckK5%, 0 ;  %IeAnz%
	gosub Button1OhneMausPos
}
return
WB:	; wird vom Gui bei aenderung vom IE-Control aufgerufen. Ist momnetan ohne Funktion.
return
Explorer:
return
SucheMenuHandler:	; wird von GuiContextMenu aufgerufen bei Rechtsklicks auf das Gui-Control Suche
;  MsgBox % A_ThisMenuItem "	" A_ThisMenu  "	" ThisGuiControl
If (A_ThisMenuItem="vom VaterDir"  and A_ThisMenu = "SucheMenu")
{
	if (ThisGuiControl="Ordner-`nNamen-Suche")				; Abfrage waere hier nicht mehr notwendig.		; Ordner-`nNamen-Suche
		gosub VomVaterDir
}
else If (A_ThisMenuItem="vom VaterWin"  and A_ThisMenu = "SucheMenu")
{
	if (ThisGuiControl="Ordner-`nNamen-Suche")				; hier ist noch der Falsche Eintrag drin
		gosub VomVaterWin
}
else If (A_ThisMenuItem="vom VaterWin"  and A_ThisMenu = "SuFiMenu")
{
	if (ThisGuiControl="SuFi")				
		gosub VomVaterWin
}
else If (A_ThisMenuItem="Control Infos"  and A_ThisMenu = "SucheMenu")
{
	MsgBox Sie haben auf das Control >%ThisGuiControl%< rechts-geklickt.`nMenueeintrag >%A_ThisMenuItem%<`nMenü >%A_ThisMenu%<
	return
}
return
SuFiMenuHandler:	; wird von GuiContextMenu aufgerufen bei Rechtsklicks auf das Gui-Control SuFi
;  MsgBox % A_ThisMenuItem "	" A_ThisMenu  "	" ThisGuiControl
If (A_ThisMenuItem="vom VaterDir"  and A_ThisMenu = "SucheMenu")
{
	if (ThisGuiControl="Ordner-`nNamen-Suche")				; Abfrage waere hier nicht mehr notwendig.
		gosub VomVaterDir
}
else If (A_ThisMenuItem="vom VaterWin"  and A_ThisMenu = "SucheMenu")
{
	if (ThisGuiControl="Ordner-`nNamen-Suche")				; hier ist noch dr Falsche Eintrag drin
		gosub VomVaterWin
}
else If (A_ThisMenuItem="vom VaterDir"  and A_ThisMenu = "SuFiMenu")
{
	if (ThisGuiControl="SuFi")				
		gosub VomVaterDir
}
else If (A_ThisMenuItem="vom GrossVaterDir"  and A_ThisMenu = "SuFiMenu")
{
	if (ThisGuiControl="SuFi")				
		gosub VomVaterVaterDir
}
else If (A_ThisMenuItem="Control Infos"  and A_ThisMenu = "SuFiMenu")
{
	MsgBox Sie haben auf das Control >%ThisGuiControl%< rechts-geklickt.`nMenueeintrag >%A_ThisMenuItem%<`nMenü >%A_ThisMenu%<
	return
}
return
IntegerMenuHandler:	; wird von GuiContextMenu aufgerufen bei Rechtsklicks auf ein Gui-Control dessen Bennenung als Integer interpraetiert werdene kann. Fuer die Zeilen-Nummern-Zahlen links vom Edit5.
If (A_ThisMenuItem="Explorer"  and A_ThisMenu = "IntegerMenu")
{
	if ThisGuiControl is integer
	{
		Edit3:=ThisGuiControl
		GuiControl,1:, %HwndEdit3%, %Edit3%
		gosub Edit3
		gosub Edit8Explorer
		return
	}
}
else If (A_ThisMenuItem="Neuer_Ordner"  and A_ThisMenu = "IntegerMenu")
{
	if ThisGuiControl is integer
	{
		Edit3:=ThisGuiControl
		GuiControl,1:, %HwndEdit3%, %Edit3%
		gosub Edit3
		gosub Edit8NeuerOrdner	
		return
	}
}
else If (A_ThisMenuItem="zeige_UnterOrdner"  and A_ThisMenu = "IntegerMenu")
{
	if ThisGuiControl is integer
	{
		Edit3:=ThisGuiControl
		GuiControl,1:, %HwndEdit3%, %Edit3%
		gosub Edit3
		gosub Edit8ZeigeUnterOrdner
		return
	}
}
else If (A_ThisMenuItem="Explorer Select"  and A_ThisMenu = "IntegerMenu")
{
	if ThisGuiControl is integer
	{
		Edit3:=ThisGuiControl
		GuiControl,1:, %HwndEdit3%, %Edit3%
		gosub Edit3
		gosub Edit8ExplorerSelect
		return
	}
}
else If (A_ThisMenuItem="Zeige Inhalte"  and A_ThisMenu = "IntegerMenu")
{
	if ThisGuiControl is integer
	{
		Edit3:=ThisGuiControl
		GuiControl,1:, %HwndEdit3%, %Edit3%
		gosub Edit3
		gosub RLShift
		return
	}
}
else If (A_ThisMenuItem="umbenennen"  and A_ThisMenu = "IntegerMenu")
{
	if ThisGuiControl is integer
	{
		Edit3:=ThisGuiControl
		GuiControl,1:, %HwndEdit3%, %Edit3%
		gosub Edit3
		gosub Edit8Umbenennen
		return
	}
}
else If (A_ThisMenuItem="Nur_Nr"  and A_ThisMenu = "IntegerMenu")
{
	if ThisGuiControl is integer
	{
		Edit3:=ThisGuiControl
		GuiControl,1:, %HwndEdit3%, %Edit3%
		return
	}
}
else If (A_ThisMenuItem="+ Stern"  and A_ThisMenu = "Submenu1")
{
	if ThisGuiControl is integer
	{
		Edit3:=ThisGuiControl
		GuiControl,1:, %HwndEdit3%, %Edit3%
		gosub Edit3
		gosub PlusStern	
		return
	}
}
else If (A_ThisMenuItem="- Stern"  and A_ThisMenu = "Submenu1")
{
	if ThisGuiControl is integer
	{
		Edit3:=ThisGuiControl
		GuiControl,1:, %HwndEdit3%, %Edit3%
		gosub Edit3
		gosub MinusStern
		return
	}
}
else If (A_ThisMenuItem="Get Clipboard"  and A_ThisMenu = "Submenu2")
{
	if ThisGuiControl is integer
	{
		if(ThisGuiControl > MaxEditNumber)
		{
			MsgBox, 262192, Edit%ThisGuiControl% not exist, Edit%ThisGuiControl% gibt es noch nicht`n`nAbbruch
			return
		}
		Edit%ThisGuiControl%:=Clipboard
		ThisEditHwnd:=HwndEdit%ThisGuiControl%
		GuiControl,1:, %ThisEditHwnd%, % Edit%ThisGuiControl%
		return
	}
}
else If (A_ThisMenuItem="Set Clipboard"  and A_ThisMenu = "IntegerMenu")
{
	if ThisGuiControl is integer
	{
		Edit3:=ThisGuiControl
		GuiControl,1:, %HwndEdit3%, %Edit3%
		gosub Edit3
		Clipboard:=FuehrendeSterneEntfernen(Edit8)	; ~~~~~~~~~~~~~~~~~1~~~~~~~~~~~~~~~ 
		return
	}
}
else If (A_ThisMenuItem="Set Clipboard"  and A_ThisMenu = "Submenu2")
{
	if ThisGuiControl is integer
	{
		if(ThisGuiControl > MaxEditNumber)
		{
			MsgBox, 262192, Edit%ThisGuiControl% not exist, Edit%ThisGuiControl% gibt es noch nicht`n`nAbbruch
			return
		}
		Gui,1:Submit,NoHide
		Clipboard:=Edit%ThisGuiControl%	; ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ 
		return
	}
}
else If (A_ThisMenuItem="Control Infos"  and A_ThisMenu = "IntegerMenu")
{
	MsgBox Sie haben auf das Control >%ThisGuiControl%< rechts-geklickt.`nMenueeintrag >%A_ThisMenuItem%<`nMenü >%A_ThisMenu%<
	return
}
	MsgBox Sie haben auf das Control >%ThisGuiControl%< rechts-geklickt.`nEs wird jedoch noch nicht mit dem Menueeintrag >%A_ThisMenuItem%<`nim Menü >%A_ThisMenu%< Unterstuetzt.`nWenn Sie eine Sinnvolle Aufgabe wissen, melden Sie sich bei Gerdi
return
ExplorerMenuHandler:
; If (ThisGuiControl="Explorer" and A_ThisMenuItem="Clip-Pfad -> Explorer" and A_ThisMenu = "ExplorerMenu")
If (A_ThisMenuItem="Clip-Pfad -> Explorer" and A_ThisMenu = "ExplorerMenu")
{
	if(StrLen(Clipboard<1000))
	{
		StringSplit,ClipPfad,Clipboard,`n,`r
		if(ClipPfad0=1)
		{
			Edit8OhneStern:=Clipboard
			if ExpSel
				gosub VarEdit8OhneSternGesetztExplorerSelect
			else
				gosub VarEdit8OhneSternGesetztExplorer
		}
		else if(ClipPfad0>1)
			MsgBox Meherere (%ClipPfad0%) Clipboard-Pfade im Explorer oeffnen`, wird hier momentan noch nicht unterstuetzt.
	}
}
return
MenuHandler:	; wird von GuiContextMenu aufgerufen bei Rechtsklicks ins Gui.
If (A_ThisMenuItem="Explorer"  and A_ThisMenu = "MeinMenu")
{
if ThisGuiControl is integer
	{
		Edit3:=ThisGuiControl
		GuiControl,1:, Edit3, %Edit3%
		gosub Edit8Explorer
return
	}
}
else If (A_ThisMenuItem="Neuer_Ordner"  and A_ThisMenu = "MeinMenu")
{
if ThisGuiControl is integer
	{
		Edit3:=ThisGuiControl
		GuiControl,1:, %HwndEdit3%, %Edit3%
		gosub Edit3
		gosub Edit8NeuerOrdner	
		return
	}
}
else If (A_ThisMenuItem="zeige_UnterOrdner"  and A_ThisMenu = "MeinMenu")
{
if ThisGuiControl is integer
	{
		Edit3:=ThisGuiControl
		GuiControl,1:, %HwndEdit3%, %Edit3%
		gosub Edit3
		gosub Edit8ZeigeUnterOrdner
		return
	}
}
else If (A_ThisMenuItem="Explorer Select"  and A_ThisMenu = "MeinMenu")
{
if ThisGuiControl is integer
	{
		Edit3:=ThisGuiControl
		GuiControl,1:, %HwndEdit3%, %Edit3%
		gosub Edit3
		gosub Edit8ExplorerSelect
		return
	}
}
else If (A_ThisMenuItem="Zeige Inhalte"  and A_ThisMenu = "MeinMenu")
{
if ThisGuiControl is integer
	{
		Edit3:=ThisGuiControl
		GuiControl,1:, Edit3, %Edit3%
		gosub Edit3
		gosub RLShift
		return
	}
}
else If (A_ThisMenuItem="Nur_Nr"  and A_ThisMenu = "MeinMenu")
{
	if ThisGuiControl is integer
	{
		Edit3:=ThisGuiControl
		GuiControl,1:, %HwndEdit3%, %Edit3%
		return
	}
}
else If (A_ThisMenuItem="Control Infos"  and A_ThisMenu = "MeinMenu")
{
	MsgBox Sie haben auf das Control >%ThisGuiControl%< rechts-geklickt.`nMenueeintrag >%A_ThisMenuItem%<`nMenü >%A_ThisMenu%<
	return
}
	MsgBox Sie haben auf das Control >%ThisGuiControl%< rechts-geklickt.`nEs wird jedoch noch nicht mit dem Menueeintrag >%A_ThisMenuItem%<`nim Menü >%A_ThisMenu%< Unterstuetzt.`nWenn Sie eine Sinnvolle Aufgabe wissen, melden Sie sich bei Gerdi
return
BeschaeftigtAnf:	; haken setzen bei beschaeftigt
	beschaeftigt:=1
	GuiControl,1:,beschaeftigt,1
return
BeschaeftigtEnd:	; haken entfernen bei beschaeftigt
	beschaeftigt:=0
	GuiControl,1:,beschaeftigt,0
return
GuiContextMenu:	; wird vom Gui aufgerufen wenn rechte Maustaste im Guibereich gedrueckt wurde. Ruft das betreffende Menue auf.
ThisGuiControl:=A_GuiControl
; MsgBox ThisGuiControl %ThisGuiControl%
if ThisGuiControl is integer
	Menu, IntegerMenu, Show 
else if (ThisGuiControl="Ordner-`nNamen-Suche")
	Menu, SucheMenu, Show 
else if (ThisGuiControl="SuFi")
	Menu, SuFiMenu, Show   
else if (ThisGuiControl="Edit5UpDown")
{
	Edit3:=1
	gosub Edit3Festigen
	If Fehlersuche
		TrayTip Edit3, Rueck-gesetzt!
}
else if (ThisGuiControl="Explorer")
{
	Menu, ExplorerMenu, Show 
}
else if (InStr(ThisGuiControl,"Clip"))
{
	TrayTip,Clipboard-Menue,Aufruf-Alternative	[Fenster] + [v]`nauch von ZZO-Fremdfenster aufrufbar,5
	Menu, ClipboardMenu, Show 
}
else
	gosub ResetAllNocontainer
return
W12:	; Verkleinert das Gui auf 1/2
GuiWin12:	; Verkleinert das Gui auf 1/2
ThisGuiBmin:=400
ThisGuiHmin:=300
WinGetPos,ThisGuiX,ThisGuiY,ThisGuiB,ThisGuiH,ahk_id %GuiWinHwnd%
if (ThisGuiB>2*ThisGuiBmin)
	ThisGuiB:=ThisGuiB/2
else
	ThisGuiB:=ThisGuiBmin
if (ThisGuiH>2*ThisGuiHmin)
	ThisGuiH:=ThisGuiH/2
else
	ThisGuiH:=ThisGuiHmin
WinMove,ahk_id %GuiWinHwnd%,,ThisGuiX,ThisGuiY,ThisGuiB,ThisGuiH
return
W23:	; Verkleinert das Gui auf 2/3
GuiWin23:
ThisGuiBmin:=400
ThisGuiHmin:=300
WinGetPos,ThisGuiX,ThisGuiY,ThisGuiB,ThisGuiH,ahk_id %GuiWinHwnd%
if (ThisGuiB>3*ThisGuiBmin/2)
	ThisGuiB:=ThisGuiB*2/3
else
	ThisGuiB:=ThisGuiBmin
if (ThisGuiH>3*ThisGuiHmin/2)
	ThisGuiH:=ThisGuiH*2/3
else
	ThisGuiH:=ThisGuiHmin
WinMove,ahk_id %GuiWinHwnd%,,ThisGuiX,ThisGuiY,ThisGuiB,ThisGuiH
return
W32:	; Vergroesert das Gui auf 3/2 sofern Platz
GuiWin32:	; Vergroesert das Gui auf 3/2 sofern Platz
GuiWinH32:	; Vergroesert das Gui auf 3/2 Horizontal sofern Platz
StarLeiste:=42
ThisGuiBmin:=400
ThisGuiHmin:=300
WinGetPos,ThisGuiX,ThisGuiY,ThisGuiB,ThisGuiH,ahk_id %GuiWinHwnd%
if (ThisGuiB*3/2>A_ScreenWidth-2*StarLeiste)
{
	ThisGuiB:=A_ScreenWidth-2*StarLeiste
	ThisGuiX:=1
}
else
	ThisGuiB:=ThisGuiB*3/2
if (ThisGuiH*3/2>A_ScreenHeight-2*StarLeiste)
{
	ThisGuiH:=A_ScreenHeight-2*StarLeiste
	ThisGuiY:=1
}
else
	ThisGuiH:=ThisGuiH*3/2
If(ThisGuiB + ThisGuiX > A_ScreenWidth-2*StarLeiste)
	ThisGuiX:=A_ScreenWidth-ThisGuiB-StarLeiste
If(ThisGuiH + ThisGuiY > A_ScreenHeight-2*StarLeiste)
	ThisGuiY:=A_ScreenHeight-ThisGuiH-StarLeiste
if(A_ThisLabel="GuiWinH32")
{
	ThisGuiH=
	ThisGuiY=
}
WinMove,ahk_id %GuiWinHwnd%,,ThisGuiX,ThisGuiY,ThisGuiB,ThisGuiH
return
WR:	; Send #{Right}
Send #{Right}
return
WL:	; Send #{Left}
Send #{Left}
return
IfExistCallEExeOrAhk(AhkQuelle,UebergabeParameter*)
{
	IfNotExist %AhkQuelle%
		return
	AnzParam:=UebergabeParameter.MaxIndex()
	Loop, % AnzParam
	{
		Ue%A_Index%:=UebergabeParameter[A_Index]
;		MsgBox % Ue%A_Index%
	}
	StringTrimRight,AhkQuelle4,AhkQuelle,4
	Rueck:=0
	IfExist %AhkQuelle4%.exe
	{
		if ZackZackOrdnerLogErstellen
			ThreadUeberwachungLog(A_LineNumber-2,A_ThisHotkey,A_ThisLabel,A_ThisFunc,A_ThisMenu,A_ThisMenuItem,A_ThisMenuItemPos)
		Rueck:=-1
		if(AnzParam="" or AnzParam=0)
			run, %AhkQuelle4%.exe "%AhkQuelle%",,,Rueck
		else if(AnzParam=1)
			run, %AhkQuelle4%.exe "%AhkQuelle%" "%Ue1%",,,Rueck
		else if(AnzParam=2)
			run, %AhkQuelle4%.exe "%AhkQuelle%" "%Ue1%" "%Ue2%",,,Rueck
		else if(AnzParam=3)
			run, %AhkQuelle4%.exe "%AhkQuelle%" "%Ue1%" "%Ue2%" "%Ue3%",,,Rueck
		else if(AnzParam=4)
			run, %AhkQuelle4%.exe "%AhkQuelle%" "%Ue1%" "%Ue2%" "%Ue3%" "%Ue4%",,,Rueck
		else if(AnzParam=5)
			run, %AhkQuelle4%.exe "%AhkQuelle%" "%Ue1%" "%Ue2%" "%Ue3%" "%Ue4%" "%Ue5%",,,Rueck
		else if(AnzParam=6)
			run, %AhkQuelle4%.exe "%AhkQuelle%" "%Ue1%" "%Ue2%" "%Ue3%" "%Ue4%" "%Ue5%" "%Ue6%",,,Rueck
		else if(AnzParam=7)
			run, %AhkQuelle4%.exe "%AhkQuelle%" "%Ue1%" "%Ue2%" "%Ue3%" "%Ue4%" "%Ue5%" "%Ue6%" "%Ue7%",,,Rueck
		else if(AnzParam=8)
			run, %AhkQuelle4%.exe "%AhkQuelle%" "%Ue1%" "%Ue2%" "%Ue3%" "%Ue4%" "%Ue5%" "%Ue6%" "%Ue7%" "%Ue8%",,,Rueck
		else if(AnzParam=9)
			run, %AhkQuelle4%.exe "%AhkQuelle%" "%Ue1%" "%Ue2%" "%Ue3%" "%Ue4%" "%Ue5%" "%Ue6%" "%Ue7%" "%Ue8%" "%Ue9%",,,Rueck
		else if(AnzParam=10)
			run, %AhkQuelle4%.exe "%AhkQuelle%" "%Ue1%" "%Ue2%" "%Ue3%" "%Ue4%" "%Ue5%" "%Ue6%" "%Ue7%" "%Ue8%" "%Ue9%" "%Ue10%",,,Rueck
		else
		{
			MsgBox %A_LineNumber% Achtung: Quelltext muss fuer mehr Parameter angepasst werden.
			Rueck:=0
		}
	}
	else
	{
		if ZackZackOrdnerLogErstellen
			ThreadUeberwachungLog(A_LineNumber-2,A_ThisHotkey,A_ThisLabel,A_ThisFunc,A_ThisMenu,A_ThisMenuItem,A_ThisMenuItemPos)
		Rueck:=1
		if(AnzParam="" or AnzParam=0)
			run, %AhkQuelle% ,,,Rueck
		else if(AnzParam=1)
			run, %AhkQuelle% "%Ue1%",,,Rueck
		else if(AnzParam=2)
			run, %AhkQuelle% "%Ue1%" "%Ue2%",,,Rueck
		else if(AnzParam=3)
			run, %AhkQuelle% "%Ue1%" "%Ue2%" "%Ue3%",,,Rueck
		else if(AnzParam=4)
			run, %AhkQuelle% "%Ue1%" "%Ue2%" "%Ue3%" "%Ue4%",,,Rueck
		else if(AnzParam=5)
			run, %AhkQuelle% "%Ue1%" "%Ue2%" "%Ue3%" "%Ue4%" "%Ue5%",,,Rueck
		else if(AnzParam=6)
			run, %AhkQuelle% "%Ue1%" "%Ue2%" "%Ue3%" "%Ue4%" "%Ue5%" "%Ue6%",,,Rueck
		else if(AnzParam=7)
			run, %AhkQuelle% "%Ue1%" "%Ue2%" "%Ue3%" "%Ue4%" "%Ue5%" "%Ue6%" "%Ue7%",,,Rueck
		else if(AnzParam=8)
			run, %AhkQuelle% "%Ue1%" "%Ue2%" "%Ue3%" "%Ue4%" "%Ue5%" "%Ue6%" "%Ue7%" "%Ue8%",,,Rueck
		else if(AnzParam=9)
			run, %AhkQuelle% "%Ue1%" "%Ue2%" "%Ue3%" "%Ue4%" "%Ue5%" "%Ue6%" "%Ue7%" "%Ue8%" "%Ue9%",,,Rueck
		else if(AnzParam=10)
			run, %AhkQuelle% "%Ue1%" "%Ue2%" "%Ue3%" "%Ue4%" "%Ue5%" "%Ue6%" "%Ue7%" "%Ue8%" "%Ue9%" "%Ue10%",,,Rueck
		else
		{
			MsgBox %A_LineNumber% Achtung: Quelltext muss fuer mehr Parameter angepasst werden.
			Rueck:=0
		}
	}
	if ZackZackOrdnerLogErstellen
		ThreadUeberwachungLog(A_LineNumber+1,A_ThisHotkey,A_ThisLabel,A_ThisFunc,A_ThisMenu,A_ThisMenuItem,A_ThisMenuItemPos)
	return Rueck					; Rueck:=0 nichts gestartet		Rueck:=Pid
}
UnterordnerUndVorFahrenEdit8:
gosub UnterordnerEdit8
StringSplit,VorFahre,Edit8Dir,\
NaheVerwante:=UnterordnerEdit8
Loop, % VorFahre0
{
	if(A_Index=1)
		NaheVerwante:=NaheVerwante  "`r`n" VorFahre%A_Index%
	else ; if(A_Index=2) 
	{
		IndexWeg1:=A_Index -1
		VorFahre%A_Index%:= VorFahre%IndexWeg1% "\" VorFahre%A_Index%
		NaheVerwante:=NaheVerwante  "`r`n" VorFahre%A_Index%
	}
}
return
ZeigeAnstattVorfahrenUndUnterordnerEdit8:	; Zeigt temporaer die Ordner Drueber den Ordner selbst und die Unterordner von Edit8 in Edit5 an. Der Rest von Edit5 entfaellt. Wird von Edit8ZeigeUnterOrdner aufgerufen
IfExist % FuehrendeSterneEntfernen(Edit8)
{
	gosub UnterordnerUndVorFahrenEdit8
	Edit5:=NaheVerwante
	sort,Edit5,U
	if(SubStr(Edit5,1,5)="`r`n\`r`n")		; Korrektur fuer NetzFregaben  
	{
		StringTrimLeft,Edit5,Edit5,5
		Edit3:=VorFahre0-2	
	}
	else
		Edit3:=VorFahre0
	gosub Edit3Festigen
	Edit5UpDown:=Edit3
	GuiControl,1:,%HwndEdit5%,%Edit5%
}
else
	TrayTip,Warnung,% "der Ordner " FuehrendeSterneEntfernen(Edit8) " existiert nicht (mehr)"
return
UnterordnerEdit8: ; UnterordnerEdit8 <-- ermittelt die UnterOrdner von Edit8
IfExist % FuehrendeSterneEntfernen(Edit8)
{
	UnterordnerEdit8:=FuehrendeSterneEntfernen(Edit8)
	Edit8Dir:=UnterordnerEdit8
	if (Not InStr(FileExist(UnterordnerEdit8),"D")) 	; wenn kein Ordner
	{
		SplitPath,UnterordnerEdit8,,Edit8Dir		; dann geh vom Dir drueber los und hol die unterordner
		UnterordnerEdit8:=Edit8Dir
		Edit8:=Edit8Dir
		gosub Edit8Festigen
	}
	If Rekursiv
	{
		Suchbeginn:=A_TickCount
		SuchbeginnPlus10Sec:=Suchbeginn+10000
		Loop,Files,% Edit8Dir "\*", D R
		{
			UnterordnerEdit8:=UnterordnerEdit8 "`r`n" A_LoopFileLongPath
			if (A_TickCount>SuchbeginnPlus10Sec)
			{
				SuchbeginnPlus10Sec:=9999999999999
				MsgBox, 262180, Unterordner, reichen die ersten %A_Index% Unterordner
				IfMsgBox,Yes
					break
			}
		}
	}
	Else
	{
		Loop,Files,% Edit8Dir "\*", D
			UnterordnerEdit8:=UnterordnerEdit8 "`r`n" A_LoopFileLongPath
	}
}
return
ZeigeAnstattUnterordnerEdit8:	; Zeigt temporaer den Ordner und die Unterordner von Edit8 in Edit5 an. Der Rest von Edit5 entfaellt. Wird von Edit8ZeigeUnterOrdner aufgerufen
IfExist % FuehrendeSterneEntfernen(Edit8)
{
	gosub UnterordnerEdit8
	Edit5:=UnterordnerEdit8
	sort,Edit5,U
	GuiControl,1:,%HwndEdit5%,%Edit5%
}
else
	TrayTip,Warnung,% "der Ordner " FuehrendeSterneEntfernen(Edit8) " existiert nicht (mehr)"
return
FolgePosOfHwnd:	; verschiebt das ZackZsackOrdner-Gui, sodass es die Positionen vom Edit4-Control des Fensters Gegenstaende einnimmt. BefehlsName wird noch geandert zu FolgePosOfGegenstaendeEdit4Hwnd
WinGetPos,FremdGuiPosX,FremdGuiPosY,,,ahk_id %FremdGuiHwnd%
ControlGetPos,FremdControlPosX,FremdControlPosY,FremdControlPosB,FremdControlPosH,Edit4,Gegenstaende
FremdPosX:=FremdGuiPosX + FremdControlPosX
FremdPosY:=FremdGuiPosY + FremdControlPosY
sleep 100
WinMove,ahk_id %GuiWinHwnd%,,FremdPosX,FremdPosY,FremdControlPosB,FremdControlPosH
return
ShowGuiHwndInEdit4:	; zeigt die eindeutige ZackZsackOrdner-Gui-Hwnd im Feld Edit4 an
Edit4:=GuiWinHwnd
GuiControl,1:,%HwndEdit4%,%Edit4%
return
MinSetzen:	; variable Min <-- 1
Min:=true
GuiControl,1:,Min,1
IeAnzFestigen:
GuiControl,1:,IeAnz,%IeAnz%
return
RekurFestigen:
GuiControl,1:,Rekur,%Rekur%
return
AktFestigen:
GuiControl,1:,Akt,%AktAkt%
return
AuAbFestigen:
GuiControl,1:,AuAb,%AuAb%
return
RegExFestigen:
GuiControl,1:,RegEx,%RegEx%
return
SuFiFestigen:
GuiControl,1:,SuFi,%SuFi%
return
ExpSelFestigen:
GuiControl,1:,ExpSel,%ExpSel%
return
SeEnFestigen:
GuiControl,1:,SeEn,%SeEn%
return
SrLiFestigen:
GuiControl,1:,SrLi,%SrLi%
return
BsAnFestigen:
GuiControl,1:,BsAn,%BsAn%
return
WoAnFestigen:
GuiControl,1:,WoAn,%WoAn%
return
beschaeftigtFestigen:
GuiControl,1:,beschaeftigt,%beschaeftigt%
return
OnTopFestigen:	; wird nach der Veraenderung der Variablen OnTop benoetigt, dass diese auch im Gui angezeigt wird (Haken To)
GuiControl,1:,%HwndCheckG0%,%OnTop%
return
MinFestigen:	; funzt ned		wird nach der Veraenderung der Variablen Min benoetigt, dass diese auch im Gui angezeigt wird (Haken Mi)
GuiControl,1:,Min,%Min%
return
Edit1Festigen:	; wird nach der Veraenderung der Variablen Edit2 benoetigt, dass diese auch im Gui angezeigt wird (Edit2 ist Suche)
GuiControl,1:,%HwndEdit1%,%Edit1%
return
Edit2Festigen:	; wird nach der Veraenderung der Variablen Edit2 benoetigt, dass diese auch im Gui angezeigt wird (Edit2 ist Suche)
GuiControl,1:,%HwndEdit2%,%Edit2%
return
Edit3Festigen:	; wird nach der Veraenderung der Variablen Edit3 benoetigt, dass diese auch im Gui angezeigt wird (Edit3 ist Nr. Wahl)
GuiControl,1:,%HwndEdit3%,%Edit3%
return
Edit4Festigen:	; wird nach der Veraenderung der Variablen Edit3 benoetigt, dass diese auch im Gui angezeigt wird (Edit3 ist Nr. Wahl)
GuiControl,1:,%HwndEdit4%,%Edit4%
return
Edit5Festigen:	; wird nach der Veraenderung der Variablen Edit5 benoetigt, dass diese auch im Gui angezeigt wird (Edit5 ist Pfade)
GuiControl,1:,%HwndEdit5%,%Edit5%
return
Edit6Festigen:	; wird nach der Veraenderung der Variablen Edit6 benoetigt, dass diese auch im Gui angezeigt wird (Edit5 ist Abbruch)
GuiControl,1:,%HwndEdit6%,%Edit6%
return
Edit7Festigen:	; wird nach der Veraenderung der Variablen Edit6 benoetigt, dass diese auch im Gui angezeigt wird (Edit5 ist Abbruch)
GuiControl,1:,%HwndEdit7%,%Edit7%
return
Edit8Festigen:	; wird nach der Veraenderung der Variablen Edit8 benoetigt, dass diese auch im Gui angezeigt wird (Edit8 ist ausgwaehler Pfad)
GuiControl,1:,%HwndEdit8%,%Edit8%
return
Edit9Festigen:	; wird nach der Veraenderung der Variablen Edit8 benoetigt, dass diese auch im Gui angezeigt wird (Edit8 ist ausgwaehler Pfad)
GuiControl,1:,%HwndEdit9%,%Edit9%
return
Edit10Festigen:	; wird nach der Veraenderung der Variablen Edit10 benoetigt, dass diese auch im Gui angezeigt wird (Edit10 ist Zusatz)
GuiControl,1:,%HwndEdit10%,%Edit10%
return
GuiSubmit:	; Speichert die Inhalte der Steuerelemente (vom ZackZsackOrdner-Gui) in ihre zugeordneten Variablen und versteckt das Gui.
Gui,1:Submit
return
GuiSubmitNohide:	; Speichert die Inhalte der Steuerelemente (vom ZackZsackOrdner-Gui) in ihre zugeordneten Variablen.
Gui,1:Submit,NoHide
return
GuiWinWaitActive:	; Warted bis das ZackZsackOrdner-Gui aktiv ist, maximal eine Sekundee
WinWaitActive,ahk_id %GuiWinHwnd%,,1
return
SWM:	; minimiert das ZackZsackOrdner-Gui		; 	fuer Befehsdateien bitte die Alternative GuiWinMin verweenden
SelfWinMin:	; minimiert das ZackZsackOrdner-Gui		; 	fuer Befehsdateien bitte die Alternative GuiWinMin verweenden
SelfMin:	; minimiert das ZackZsackOrdner-Gui		; 	fuer Befehsdateien bitte die Alternative GuiWinMin verweenden
GuiWinMin:	; minimiert das ZackZsackOrdner-Gui 
WinMinimize,ahk_id %GuiWinHwnd%
return
Pause:	; Pausiert das Skript
Pause
return
SuspendOn:	; Hotkeys <-- in Betrieb
Suspend, On
return
SuspendOff:	; Hotkeys <-- ausser Betrieb
Suspend, Off
return
Button6:	; Button6, dessen Sichtbarkeit und Nutzbarkeit vom Vorhandensein von Button8.ahk und von der optionalen Button6.txt Befehlsdatei im %A_ScriptDir% abhaengt.
Gui,1:Submit,NoHide
GuiControl,1:,%HwndEdit8%.%Edit8%
GuiControl,1:,%HwndEdit10%.%Edit10%
if (Button6Params="")
{
	IfExist %A_ScriptDir%\Button6.exe
		run, "%A_ScriptDir%\Button6.exe" "%A_ScriptDir%\Button6.ahk" "%Edit8%"  "%Edit10%"
	else IfExist %A_ScriptDir%\Button6.ahk
		run, "%A_ScriptDir%\Button6.ahk" "%Edit8%"  "%Edit10%"
}
else
{
	IfExist %A_ScriptDir%\Button6.exe
		run, "%A_ScriptDir%\Button6.exe" "%A_ScriptDir%\Button6.ahk" "%Edit1%"  "%Edit2%" "%Edit3%" "%Edit4%" "%Edit5%" "%Edit6%" "%Edit7%" "%Edit8%" "%Edit9%" "%Edit10%" 
	else IfExist %A_ScriptDir%\Button6.ahk
		run, "%A_ScriptDir%\Button6.ahk" "%Edit1%"  "%Edit2%" "%Edit3%" "%Edit4%" "%Edit5%" "%Edit6%" "%Edit7%" "%Edit8%" "%Edit9%" "%Edit10%" 
}
return
Button7:
Gui,1:Submit,NoHide
GuiControl,1:,%HwndEdit8%.%Edit8%
GuiControl,1:,%HwndEdit10%.%Edit10%
if (Button7Params="")
{
	IfExist %A_ScriptDir%\Button7.exe
		run, "%A_ScriptDir%\Button7.exe" "%A_ScriptDir%\Button7.ahk" "%Edit8%"  "%Edit10%"
	else IfExist %A_ScriptDir%\Button7.ahk
		run, "%A_ScriptDir%\Button7.ahk" "%Edit8%"  "%Edit10%"
}
else
{
	IfExist %A_ScriptDir%\Button7.exe
		run, "%A_ScriptDir%\Button7.exe" "%A_ScriptDir%\Button7.ahk" "%Edit1%"  "%Edit2%" "%Edit3%" "%Edit4%" "%Edit5%" "%Edit6%" "%Edit7%" "%Edit8%" "%Edit9%" "%Edit10%" 
	else IfExist %A_ScriptDir%\Button7.ahk
		run, "%A_ScriptDir%\Button7.ahk" "%Edit1%"  "%Edit2%" "%Edit3%" "%Edit4%" "%Edit5%" "%Edit6%" "%Edit7%" "%Edit8%" "%Edit9%" "%Edit10%" 
}
return
Button8:
Gui,1:Submit,NoHide
GuiControl,1:,%HwndEdit8%.%Edit8%
GuiControl,1:,%HwndEdit10%.%Edit10%
if (Button8Params="")
{
	IfExist %A_ScriptDir%\Button8.exe
		run, "%A_ScriptDir%\Button8.exe" "%A_ScriptDir%\Button8.ahk" "%Edit8%"  "%Edit10%"
	else IfExist %A_ScriptDir%\Button8.ahk
		run, "%A_ScriptDir%\Button8.ahk" "%Edit8%"  "%Edit10%"
}
else
{
	IfExist %A_ScriptDir%\Button8.exe
		run, "%A_ScriptDir%\Button8.exe" "%A_ScriptDir%\Button8.ahk" "%Edit1%"  "%Edit2%" "%Edit3%" "%Edit4%" "%Edit5%" "%Edit6%" "%Edit7%" "%Edit8%" "%Edit9%" "%Edit10%" 
	else IfExist %A_ScriptDir%\Button8.ahk
		run, "%A_ScriptDir%\Button8.ahk" "%Edit1%"  "%Edit2%" "%Edit3%" "%Edit4%" "%Edit5%" "%Edit6%" "%Edit7%" "%Edit8%" "%Edit9%" "%Edit10%" 
}
return
Button9:
Gui,1:Submit,NoHide
GuiControl,1:,%HwndEdit8%.%Edit8%
GuiControl,1:,%HwndEdit10%.%Edit10%
if (Button9Params="")
{
	IfExist %A_ScriptDir%\Button9.exe
		run, "%A_ScriptDir%\Button9.exe" "%A_ScriptDir%\Button9.ahk" "%Edit8%"  "%Edit10%"
	else IfExist %A_ScriptDir%\Button9.ahk
		run, "%A_ScriptDir%\Button9.ahk" "%Edit8%"  "%Edit10%"
}
else
{
	IfExist %A_ScriptDir%\Button9.exe
		run, "%A_ScriptDir%\Button9.exe" "%A_ScriptDir%\Button9.ahk" "%Edit1%"  "%Edit2%" "%Edit3%" "%Edit4%" "%Edit5%" "%Edit6%" "%Edit7%" "%Edit8%" "%Edit9%" "%Edit10%" 
	else IfExist %A_ScriptDir%\Button9.ahk
		run, "%A_ScriptDir%\Button9.ahk" "%Edit1%"  "%Edit2%" "%Edit3%" "%Edit4%" "%Edit5%" "%Edit6%" "%Edit7%" "%Edit8%" "%Edit9%" "%Edit10%" 
}
return
Button10:
MsgBox % A_LineNumber "	noch zu coden"
return
Button11:
return
Button12:
return
Button13:
return
Button14:
return
Button15:
return
VomVaterVaterDir:	; Edit7 <-- den Ordner ueber dem Ordner der Edit8 enthaelt.
Edit8Sternlos:=FuehrendeSterneEntfernen(Edit8)
SplitPath,Edit8Sternlos, Edit8SternlosFileName, Edit8SternlosDir ; , Edit8SternlosExt, Edit8SternlosNameNoExt
SplitPath,Edit8SternlosDir, , Edit8SternlosDirDir
		Edit7:=Edit8SternlosDirDir
		GuiControl,1:,%HwndEdit7%,%Edit7%
		gosub SufiAn
		gosub F5
return
VomVaterDir:	; Edit7 <-- den Ordner der Edit8 enthaelt.
Edit8Sternlos:=FuehrendeSterneEntfernen(Edit8)
SplitPath,Edit8Sternlos, Edit8SternlosFileName, Edit8SternlosDir ; , Edit8SternlosExt, Edit8SternlosNameNoExt
		Edit7:=Edit8SternlosDir
		GuiControl,1:,%HwndEdit7%,%Edit7%
		gosub SufiAn
		gosub F5
return
VomVaterWin:	; liest vom (Vater-)Explorer-Fenster den Pfad aus und verwendet ihn als Suchmuster fuer Edit7
If (VaterTyp="")
	VaterTyp:="Explorer"
; es sei das VaterHwnd bekannt.
; es sei der VaterTyp bekannt.
If (VaterTyp="Explorer")
{
	ControlFocus,ToolbarWindow323,ahk_class CabinetWClass
	sleep 90
	ControlClick,ToolbarWindow323,ahk_class CabinetWClass
	sleep 90
	ControlGetText,ThisExplorerPath,ToolbarWindow323,ahk_class CabinetWClass
	sleep 30
	gosub SelfActivate
	ThisDotOverDotPos:=InStr(ThisExplorerPath,":")+1
		StringTrimLeft,ThisExplorerPath,ThisExplorerPath,ThisDotOverDotPos
	IfExist %ThisExplorerPath%
	{
		sleep 30
		Edit7:=ThisExplorerPath
		GuiControl,1:,%HwndEdit7%,%Edit7%
		gosub SufiAn
		gosub F5
	}
}
else if (VaterTyp="OrdnungsDB")
{
}
return
HalloWelt(Nummer="")
{
	MsgBox, 262144,%A_ScriptName% at %A_LineNumber% ,Hallo Welt %Nummer%
	return "Hallo Welt " Nummer
}
ThisStringReplace(InputVar,SearchText="",ReplaceText="",All="")	; Kurz:	siehe <a href="http://de.autohotkey.com/docs/commands/StringReplace.htm">StringReplace.htm</a>	Eingang: -
{
	global
StringReplace,OutputVar,InputVar,%SearchText%,%ReplaceText%,%All%
If Fehlersuche
	MsgBox, 262144, %A_ScriptName% at %A_LineNumber% in der Funktion, %SearchText%`,%ReplaceText%`,%All%
 Return OutputVar
}
Schlafe200:
sleep 200
return
FunktionUeberGabestringErzeugen(EingangsString,EingangsStringName="")
{
	Global
	Local GeradeTextUngeradeVar0,GeradeTextUngeradeVar1,GeradeTextUngeradeVar2,GeradeTextUngeradeVar3,GeradeTextUngeradeVar4,GeradeTextUngeradeVar5,GeradeTextUngeradeVar6,GeradeTextUngeradeVar7,GeradeTextUngeradeVar8,GeradeTextUngeradeVar9,GeradeTextUngeradeVar10,GeradeTextUngeradeVar11,Rueckgabe,ThisIndex,ThisVarName,ThisText,ThisVar,AufrufIndex,RueckgabeInhalt,ThisVarInhalt
	if(FunktionUeberGabestringErzeugenIndex="")
		FunktionUeberGabestringErzeugenIndex:=0
	++FunktionUeberGabestringErzeugenIndex
	if Fehlersuche
		MsgBox EingangsString=%EingangsString%
	If (EingangsString="")
		return
	if Fehlersuche
		MsgBox EingangsStringName=%EingangsStringName%
	if(InStr(EingangsString,Hochkomma))
	{
		StringSplit,GeradeTextUngeradeVar,EingangsString,%Hochkomma%	; GeradeTextUngeradeVar1 GeradeTextUngeradeVar2 GeradeTextUngeradeVar3 
		if Fehlersuche
			MsgBox % GeradeTextUngeradeVar0 A_tab GeradeTextUngeradeVar1 A_tab GeradeTextUngeradeVar2 A_tab GeradeTextUngeradeVar3 A_tab GeradeTextUngeradeVar4 A_tab GeradeTextUngeradeVar5 A_tab GeradeTextUngeradeVar6
		Loop % GeradeTextUngeradeVar0 +2
		{
			if (A_Index=1)
			{
				Rueckgabe:=
				continue
			}
			if (Mod(A_Index,2))
				continue
			ThisIndex:=A_Index-1
			ThisVarName:=GeradeTextUngeradeVar%ThisIndex%
			ThisText:=GeradeTextUngeradeVar%A_Index%
			if(ThisVarName<>"")
			{
				if(InStr(ThisVarName,"`%"))
					Transform, ThisVarInhalt, Deref, %ThisVarName% 
				else
					ThisVarInhalt:=%ThisVarName%
				RueckgabeInhalt:=RueckgabeInhalt    ThisVar ThisText
			}
			else
			{
				RueckgabeInhalt:=RueckgabeInhalt  ThisText
			}
			ThisText=
			FunktionUeberGabestringErzeugenRueckgabe%FunktionUeberGabestringErzeugenIndex%:=RueckgabeInhalt
			ThisFunktionUeberGabestringErzeugenRueckgabe=FunktionUeberGabestringErzeugenRueckgabe%FunktionUeberGabestringErzeugenIndex%
			Return RueckgabeInhalt
		}
	}
	else if(InStr(EingangsString,"`%"))
	{
		{
			Transform, RueckgabeInhalt, Deref, %EingangsString% 
			SuperRueckgabeInhalt:=%RueckgabeInhalt%
			Rueckgabe:=SuperRueckgabeInhalt
		}
	}
	else
	{
		if Fehlersuche
			MsgBox Ruck=%EingangsString%
		SuperEingangsString:=%EingangsString%
		return SuperEingangsString
	}
	if Fehlersuche
		MsgBox Rueck=%Rueckgabe%
	return Rueckgabe
}
Super(Var)
{
	global
	local Rueck
	if(Var<>"")
		Rueck:=%Var%
}
SWR:
SelfWinRestore:
GuiWinRestore:
WinRestore,ahk_id %GuiWinHwnd%
return
OnClipboardChange:
if(Clipboard<>FuehrendeSterneEntfernen(Edit8))
	GuiControl,1:Text,%HwndButton3%,└> &Clip
else
	GuiControl,1:Text,%HwndButton3%,┌> &Clip
if (AktionBeiClipChange)
{
	if(GosubClipChange="KopiereOderVerschiebeFilesAndFolders2Edit8")
	{
		if (A_EventInfo=1)
			gosub %GosubClipChange%
	}
}
GosubClipChange:=
AktionBeiClipChange:=false
return
^-::	; kopiere oder verschiebe Pfade die bereits im Clipboard stehen.
TimeStampClipWaitPathes2Edit8:=A_TickCount
KopiereOderVerschiebeFilesAndFolders2Edit8:
if(TimeStampClipWaitPathes2Edit8 < A_TickCount- 60000) ; 1 Minute ueberschritten
	return
DateiPfade:=Clipboard
DateiPfadeWerdenUebergeben:=true
gosub KopiereOderVerschiebeFilesAndFolders
return
^+::	; kopiere oder verschiebe Pfade, vom Clipboard nur wenn ClipboardChange stattgefunden, zum Pfad in Edit8. Dafuer steht eine Minute zur Verfuegung.
ClipWaitPathes2Edit8:	; kopiere oder verschiebe Pfade, vom Clipboard nur wenn ClipboardChange stattgefunden, zum Pfad in Edit8. Dafuer steht eine Minute zur Verfuegung.
TimeStampClipWaitPathes2Edit8:=A_TickCount
AktionBeiClipChange:=true
TrayTip,Wait-Clip-Change,warte bis zu einer Minute auf neue Clipboard-Pfade.
GosubClipChange=KopiereOderVerschiebeFilesAndFolders2Edit8
return
ContainerSkripteUndProgrammeBereitstellen:
IfNotExist  %A_AppDataCommon%\Zack\Dir2Paths.exe
{
	IfExist %A_ScriptDir%\Dir2Paths.exe
		FileCopy,%A_ScriptDir%\Dir2Paths.exe, %A_AppDataCommon%\Zack\Dir2Paths.exe					; dito
	else
		TrayTip, Warnung, %A_ScriptDir%\Dir2Paths.exe fehlt
}
IfNotExist  %A_AppDataCommon%\Zack\Dir2Paths.ahk
{
	gosub BereiteVorDir2Paths
}
IfNotExist %A_AppDataCommon%\Zack\TastWatch.exe
{
	IfExist %A_ScriptDir%\TastWatch.exe
		FileCopy,  %A_ScriptDir%\TastWatch.exe, %A_AppDataCommon%\Zack\TastWatch.exe
	else
		TrayTip, Warnung, %A_ScriptDir%\TastWatch.exe fehlt
}
IfNotExist %A_AppDataCommon%\Zack\TastWatch.ahk
{
	gosub VarTastWatcherzeugen
}
return
VarTastWatcherzeugen: 
TastWatch=
(
#SingleInstance
ifExist `%A_AppData`%\Zack\GeKoRe.ico
	Menu,Tray,icon,`%A_AppData`%\Zack\GeKoRe.ico
else ifExist `%A_ScriptDir`%\GeKoRe.ico
	Menu,Tray,icon,`%A_ScriptDir`%\GeKoRe.ico
DpiKorrektur:=A_ScreenDPI/96
Menu,Tray,Add,WatchCapsLock
TastenUeberwachen:=false
DetectHiddenWindows,On
ZielScriptTitel = ZackZackOrdner ahk_class AutoHotkeyGui
IfWinNotExist, ZackZackOrdner
{
	IfExist, `%A_AppDataCommon`%\Zack\SchnellOrdner.txt
	{
		FileRead,ZackZackOrdnerPath,`%A_AppDataCommon`%\Zack\SchnellOrdner.txt
		IfExist `%ZackZackOrdnerPath`%
			{
				SplitPath,ZackZackOrdnerPath,,ZackZackOrdnerDirPath
				Run,  `%ZackZackOrdnerPath`% Minimized,`%ZackZackOrdnerDirPath`%,Min,SucheOrdnerPID
			}
	}
}
DetectHiddenWindows,Off
SetTimer,Explorer,500
AustauschOrdnerPfad:=A_AppDataCommon "\TaMit"
AusTauschDateiPfad:=AustauschOrdnerPfad  "\TaMit.txt"
Weg=EndKey`:
EnterDotOverDotWeg:=true
LShiftWeg:=false
RShiftWeg:=true
weg1=Max
Loop
{
	if NOT TastenUeberwachen
	{
		Sleep 500
		continue
	}
	if TastaturfocusNurScript
	{
		Input, Einzeltaste, L1, {AppsKey}{F1}{F2}{F3}{F4}{F5}{F6}{F7}{F8}{F9}{F10}{F11}{F12}{Left}{Right}{Up}{Down}{Home}{End}{PgUp}{PgDn}{Del}{Ins}{BS}{Capslock}{Numlock}{PrintScreen}{Pause}{Tab}				;  {LControl}{RControl}{LShift}{RShift}{LAlt}{RAlt}{LWin}{RWin}
		Zusatz:=ErrorLevel
		if(Zusatz="EndKey:Tab")
		{
			TastaturfocusNurScript:=false
			Tastenlog:=false
			ZuSendendeString:=ThisText
			 Gosub SendeZuSendendeString
			; Sende_WM_COPYDATA(ByRef ZuSendendeString, ByRef ZielScriptTitel)
			continue
		}
		else if(Zusatz="EndKey:Right")
		{
			TastaturfocusNurScript:=false
			Tastenlog:=false
			gosub SendeTaste
			continue
		}
	}
	else
	{
		Input, Einzeltaste, L1V, {AppsKey}{F1}{F2}{F3}{F4}{F5}{F6}{F7}{F8}{F9}{F10}{F11}{F12}{Left}{Right}{Up}{Down}{Home}{End}{PgUp}{PgDn}{Del}{Ins}{BS}{Capslock}{Numlock}{PrintScreen}{Pause}{Tab}				;  {LControl}{RControl}{LShift}{RShift}{LAlt}{RAlt}{LWin}{RWin}{Space}
		; MsgBox >`%Einzeltaste`%<`%Zusatz`%>
		Zusatz:=ErrorLevel
		if(Zusatz="EndKey:CapsLock" and LastZusatz="EndKey:CapsLock")
		{
			TastaturfocusNurScript:=true
			Tastenlog:=true
			ErstZeichen:=true
			ThisText=
			FileDelete,c:\temp\LetzteTastenBeginnSchafSS.txt
			; Sende info an andere Programme vorzugsweise Broadcast
			continue
		}
	}
	LastZusatz:=Zusatz
	; MsgBox `% Einzeltaste Zusatz
	if Tastenlog
	{
		If (Zusatz="EndKey:Down")
			Einzeltaste=Down
		If (Zusatz="EndKey:Up")
			Einzeltaste=Up
		; MsgBox >`%Einzeltaste`%<`%Zusatz`%>
		if RShiftWeg
			StringReplace,Zusatz,Zusatz,`%Weg`%RShift,,
		if LShiftWeg
			StringReplace,Zusatz,Zusatz,`%Weg`%LShift,,
		If EnterDotOverDotWeg
			StringReplace,Zusatz,Zusatz,`%Weg`%Enter,``r``n,
		StringReplace,Zusatz,Zusatz,`%Weg`%,,
		StringReplace,Einzeltaste,Einzeltaste,`%weg`%,,
		StringReplace,Zusatz,Zusatz,`%weg1`%,,
		if (Zusatz<>"")
		{
			FileAppend,`%Einzeltaste`%{`%Zusatz`%},c:\temp\LetzteTastenBeginnSchafSS.txt,utf-16
			ThisText:=ThisText  Einzeltaste ; ZuasatzTab
		}
		else
		{
			FileAppend,`%Einzeltaste`%`%ZuasatzTab`%,c:\temp\LetzteTastenBeginnSchafSS.txt,utf-16
			ThisText:=ThisText  Einzeltaste  ; ZuasatzTab
		}
		TrayTip,TastenLog,`%Einzeltaste`%`%Zusatz`%``n``n`%ThisText`%
	}
}
return
SendeZuSendendeString:
IfWinExist,ZackZackOrdner,,ahk_class CabinetWClass
{
	Loop, 5
	{
		ControlSetText,Edit4,`%ZuSendendeString`%.,ZackZackOrdner ahk_class AutoHotkeyGUI
		sleep, 4
		ControlGetText,VonEdit4,Edit4,ZackZackOrdner ahk_class AutoHotkeyGUI
		if(VonEdit4=ZuSendendeString)
		{
			Ergebnis:=true
			return
		}
		else if(VonEdit4=(Edit4 "."))
		{
			Sleep A_Index*10
			continue
		}
		else if(VonEdit4="")
		{
			TrayTip,2*Caps Befehl Tab, kann Ziel-Control Edit4 im Zielfenster ZackZackOrdner nicht erreichen.
			return
		}
		else
		{
			TrayTip,2*Caps Befehl Tab, Der Befehl konnte das Ziel-Control Edit4 im Zielfenster ZackZackOrdner nicht erreichen.
			return
		}
	}
}
return
Explorer:
IfWinActive,ahk_class CabinetWClass
{
	Try Gui,2:Destroy
	WinGetPos,WinX,WinY,WinB,WinH,A
	MausYLL:=MausYL
	MausYL:=MausY
	MausXLL:=MausXL
	MausXL:=MausX
	MouseGetPos,MausX,MausY
	x:=(WinX+WinX+WinB)/2+80
	WinYPlus:=WinY+25
	ExplorerHwnd:=WinExist(A)
	IfWinExist,ButtonGUI
	{
		if(MausXLL-X+WinX<70 and MausYLL-WinYPlus+WinY<70 and MausXLL-X+WinX>-50 and MausYLL-WinYPlus+WinY>-50 and MausX-MausXLL<70 and MausX-MausXLL>-70 and MausY-MausYLL<70 and MausY-MausYLL>-70)
		{
			; naechste Zeile fuer Magneteffekt des Ordner-Buttons scharfschalten
			; WinMove,ahk_id `%GuiWin1Hwnd`%,,MausXLL+WinX-28,MausYLL+WinY-14	; Auskommnetgieren wenn Magneteffekt stoert
			sleep 800
		}
		else
		WinMove,ahk_id `%GuiWin1Hwnd`%,,`%X`%,WinYPlus
	}
	else
	{
		Gui,1:New,+HwndGuiWin1Hwnd   -Border -SysMenu 							; Parent`%ExplorerHwnd`%
		Gui,1:Add, Button, x1 y1  w50 h23 gButton1 , Ordner...
		; Gui, Show,x`%X`% y`%WinY`% w80 h40  AutoSize , ButtonGUI				; AlwaysOnTop AutoSize NoActivate
		Gui,1:Show,x`%X`% y`%WinYPlus`%  AutoSize NoActivate, ButtonGUI				; AlwaysOnTop AutoSize NoActivate
		WinSet,AlwaysOnTop, On,ahk_id `%GuiWin1Hwnd`%
	}
	ControlGetFocus,FocussedControl,A
	if FocussedControl contains ToolbarWindow322,ToolbarWindow323,msctls_progress321,Edit1,DirectUIHWND1
		WinHide,ahk_id `%GuiWin1Hwnd`%
	else
		WinShow,ahk_id `%GuiWin1Hwnd`%
	WinSet,AlwaysOnTop, On,ahk_id `%GuiWin1Hwnd`%
}
else IfWinActive,ZackZackOrdner
{
	try Menu,WortVorschlagsMenu,DeleteAll
	IfNotExist `%A_AppData`%\Zack\WortVorschlagListe.txt
		return
	Gui,2:New,+HwndGui2WinHwnd  ;  -Border -SysMenu 							; Parent`%ExplorerHwnd`%
	Loop 10
	{
		if(A_TimeIdlePhysical<500)
			sleep 50
		else
		{
			IfExist `%A_AppData`%\Zack\WortVorschlagListe.txt
			{
				FileReadLine,WortVorschlagListe, `%A_AppData`%\Zack\WortVorschlagListe.txt,2
				if (WortVorschlagListe="")
				{
					Try Gui,2:Destroy
					return
				}

				StringTrimLeft,WortVorschlagListe,WortVorschlagListe,1
				StringSplit,WortVorschlag,WortVorschlagListe,`,
				loop `% WortVorschlag0
				{
					YB:=A_Index*30-29
						Gui,2:Add, Button, x1 y`%YB`%  w145 h29 gWortVorschlagsMenuHandler`%A_Index`% Left, `% SubStr(WortVorschlag`%A_Index`%,1,-4)
				}
				gosub ZeigeWortVorschlagsMenue
				break
			}
			else
				return
		}
	}
}
else IfWinActive,ahk_id `%GuiWin1Hwnd`%
{
	Try Gui,2:Destroy
}
else
{
	Try Gui,2:Destroy
	WinSet,AlwaysOnTop, Off,ahk_id `%GuiWin1Hwnd`%
	Gui,1:Submit
	WinHide,ahk_id `%GuiWin1Hwnd`%
}
return
##::	; wie  klicken von Ordner im TastWatch Programm zur Ordnerwahl; Ordner ist der bei Explorefenstern zusaetzlich erscheinende Button.
IfWinNotActive,ahk_class CabinetWClass
	{
		IfWinExist,ahk_class CabinetWClass
			WinActivate,ahk_class CabinetWClass
		else
			run, explorer.exe
	}
WinWaitActive,ahk_class CabinetWClass,,5
if ErrorLevel
	return
Button1:
	WinSet,AlwaysOnTop, Off,ahk_id `%GuiWin1Hwnd`%
	Gui,1:Submit
	WinHide,ahk_id `%GuiWin1Hwnd`%
sleep 60
ZuSendendeString:="SASize"
gosub SendeZuSendendeString
return
SendeTaste:
if (AltGrDownForNextInput and (AltGrDownForNextInputTime + 15000 < A_TickCount))
	{
	SendInput {RAlt Down}`%ThisText`%{RAlt Up}
	}
else if (ThisText="Esc")
	SendInput {Esc}
; else if (ThisText="AG")
	; SendInput {RAlt}
else if (ThisText="AG")
{
	; TastaturfocusNurScript:=true
	AltGrDownForNextInput:=true
	AltGrDownForNextInputTime:=A_TickCount
	; SendInput {RAlt Down}
}
else if (ThisText="At")
	SendInput @
else if (ThisText="F1")
	SendInput {F1}
else if (ThisText="F2")
	SendInput {F2}
else if (ThisText="F3")
	SendInput {F4}
else if (ThisText="F4")
	SendInput {F5}
else if (ThisText="F5")
	SendInput {F6}
else if (ThisText="F6")
	SendInput {F7}
else if (ThisText="F7")
	SendInput {F8}
else if (ThisText="F8")
	SendInput {F9}
else if (ThisText="F9")
	SendInput {F2}
else if (ThisText="F10")
	SendInput {F10}
else if (ThisText="F11")
	SendInput {F11}
else if (ThisText="M") ; Menue-Taste Kontext-Menue oder RechtsClick-Menue
	SendInput {AppsKey}
else if (ThisText="F12")
	SendInput {F12}
else if (ThisText="Plus")
	SendInput {LWin Down}<{LWin Up}
else if (ThisText="AF4")	; Alt + F4
	SendInput {LAlt Down}{F4}{LAlt Up}
else if (ThisText=":")
	SendInput ˸
else if (ThisText="°")
	SendInput *
else if (ThisText="\")
	SendInput ►
; else if (ThisText="Euro")
	; SendInput {€}
else if (ThisText="BS")
	SendInput {BackSpace}
else if (ThisText="FS" or ThisText="Del")		; FowardSpace
	SendInput {Delete}
else if (ThisText="LG")		; Linke Geschweifte
	SendRaw {
else if (ThisText="RG")
	SendRaw }
else if (ThisText="LE")		; Linke Eckige
	SendRaw [
else if (ThisText="RE")
	SendRaw ]
else if (ThisText="Kl")		; kleiner
	SendRaw ]
else if (ThisText="/")		; BagSlash
	SendRaw \
else if (ThisText="Gr")		; groesser
	SendRaw >
else if (ThisText="Pipe")
	SendRaw |
return
WatchCapsLock:
if TastenUeberwachen
	TastenUeberwachen:=false
else
	TastenUeberwachen:=true
return
::CapsspaCon::
TastenUeberwachen:=true
return
::CapsspaCoff::
TastenUeberwachen:=false
return

WortVorschlagsMenuHandler1:
WortVorschlagsMenuHandler2:
WortVorschlagsMenuHandler3:
WortVorschlagsMenuHandler4:
WortVorschlagsMenuHandler5:
WortVorschlagsMenuHandler6:
WortVorschlagsMenuHandler7:
WortVorschlagsMenuHandler8:
WortVorschlagsMenuHandler9:
WortVorschlagsMenuHandler10:
StringSplit,WortVorschlag,WortVorschlagListe,`,
TrayTip, WortVorschlag1,`%WortVorschlag1`% ,5
WortVorschlagNummer:=SubStr(A_ThisLabel,0,1)
ZuSendendeString:=SubStr(WortVorschlag`%WortVorschlagNummer`%,1,-4)
ControlSetText,Edit4,`%ZuSendendeString`%.,ZackZackOrdner ahk_class AutoHotkeyGUI
Gui,2:Destroy
return

ZeigeWortVorschlagsMenue:
if(LastZuSendendeString<>ZuSendendeString or LastWortVorschlagListe<>WortVorschlagListe or WortVorschlag0>2  or LastZuSendendeString="")
{
	LastZuSendendeString:=ZuSendendeString
	LastWortVorschlagListe:=WortVorschlagListe
	WinGetPos,ZzoX,ZzoY,,,ZackZackOrdner ahk_class AutoHotkeyGUI
	ZzoXR:=ZzoX-75*DpiKorrektur
	if(ZzoXR<0 and ZzoXR>-85*DpiKorrektur)
		ZzoXR:=1
	ZzoYR:=ZzoY+300*DpiKorrektur
	Gui,2:Show,x`%ZzoXR`% y`%ZzoYR`%  AutoSize NoActivate, WortVorschlaege				; AlwaysOnTop AutoSize NoActivate
	Loop
	{
		Input, Einzeltaste,T1 L1 V, {LControl}{RControl}{LAlt}{RAlt}{LShift}{RShift}{LWin}{RWin}{AppsKey}{F1}{F2}{F3}{F4}{F5}{F6}{F7}{F8}{F9}{F10}{F11}{F12}{Left}{Right}{Up}{Down}{Home}{End}{PgUp}{PgDn}{Del}{Ins}{BS}{Capslock}{Numlock}{PrintScreen}{Pause}
		if (ErrorLevel <> "Timeout" )
			break
		IfWinNotActive,ZackZackOrdner ahk_class AutoHotkeyGUI
			break
	}
	
	
}
return

GuiClose:
ExitApp
)
TastWatchweg=
(
#SingleInstance
; Speichere das folgende Script als "Sender.ahk" und starte es:  Drücke danach den Hotkey WIN+LEERTASTE.
; ZielScriptTitel = Empfänger.ahk ahk_class AutoHotkey
ifExist `%A_AppData`%\GeKoRe.ico
	Menu,Tray,icon,`%A_AppData`%\GeKoRe.ico
else ifExist `%A_ScriptDir`%\GeKoRe.ico
	Menu,Tray,icon,`%A_ScriptDir`%\GeKoRe.ico
; IfWinNotExist,ZackZackOrdner,,ahk_class CabinetWClass
Menu,Tray,Add,WatchCapsLock
TastenUeberwachen:=false
DetectHiddenWindows,On
IfWinNotExist, ZackZackOrdner
{
	IfExist, `%A_AppDataCommon`%\Zack\SchnellOrdner.txt
	{
		FileRead,ZackZackOrdnerPath,`%A_AppDataCommon`%\Zack\SchnellOrdner.txt
		IfExist `%ZackZackOrdnerPath`%
			{
				SplitPath,ZackZackOrdnerPath,,ZackZackOrdnerDirPath
				Run,  `%ZackZackOrdnerPath`% Minimized,`%ZackZackOrdnerDirPath`%,Min,SucheOrdnerPID
			}
	}
}
DetectHiddenWindows,Off
SetTimer,Explorer,500
ZielScriptTitel = ZackZackOrdner ahk_class AutoHotkeyGui
AustauschOrdnerPfad:=A_AppDataCommon "\TaMit"
AusTauschDateiPfad:=AustauschOrdnerPfad  "\TaMit.txt"
Weg=EndKey``:
EnterDotOverDotWeg:=true
LShiftWeg:=false
RShiftWeg:=true
weg1=Max
Loop
{
	if NOT TastenUeberwachen
	{
		Sleep 500
		continue
	}
	if TastaturfocusNurScript
	{
		Input, Einzeltaste, L1, {AppsKey}{F1}{F2}{F3}{F4}{F5}{F6}{F7}{F8}{F9}{F10}{F11}{F12}{Left}{Right}{Up}{Down}{Home}{End}{PgUp}{PgDn}{Del}{Ins}{BS}{Capslock}{Numlock}{PrintScreen}{Pause}{Tab}				;  {LControl}{RControl}{LShift}{RShift}{LAlt}{RAlt}{LWin}{RWin}
		Zusatz:=ErrorLevel
		if(Zusatz="EndKey:Tab")
		{
			TastaturfocusNurScript:=false
			Tastenlog:=false
			ZuSendendeString:=ThisText
			; SoundBeep,250,1000
			 Gosub SendeZuSendendeString
			;  SoundBeep,500,2000
			; Sende_WM_COPYDATA(ByRef ZuSendendeString, ByRef ZielScriptTitel) 
			continue
		}
		else if(Zusatz="EndKey:Right")
		{
			TastaturfocusNurScript:=false
			Tastenlog:=false
			gosub SendeTaste
			continue
		}
	}
	else
	{
		; Input, Einzeltaste, L1  B I  V, {LControl}{RControl}{LAlt}{RAlt}{LShift}{RShift}{LWin}{RWin}{AppsKey}{F1}{F2}{F3}{F4}{F5}{F6}{F7}{F8}{F9}{F10}{F11}{F12}{Left}{Right}{Up}{Down}{Home}{End}{PgUp}{PgDn}{Del}{Ins}{BS}{Capslock}{Numlock}{PrintScreen}{Pause}
		Input, Einzeltaste, L1V, {AppsKey}{F1}{F2}{F3}{F4}{F5}{F6}{F7}{F8}{F9}{F10}{F11}{F12}{Left}{Right}{Up}{Down}{Home}{End}{PgUp}{PgDn}{Del}{Ins}{BS}{Capslock}{Numlock}{PrintScreen}{Pause}{Tab}				;  {LControl}{RControl}{LShift}{RShift}{LAlt}{RAlt}{LWin}{RWin}{Space}
		; MsgBox >`%Einzeltaste`%<`%Zusatz`%>
		Zusatz:=ErrorLevel
		if(Zusatz="EndKey:CapsLock" and LastZusatz="EndKey:CapsLock")
		{
			TastaturfocusNurScript:=true
			Tastenlog:=true
			ErstZeichen:=true
			ThisText=
			FileDelete,c:\temp\LetzteTastenBeginnSchafSS.txt
			; Sende info an andere Programme vorzugsweise Broadcast
			continue
		}
	}
	LastZusatz:=Zusatz
	; MsgBox `% Einzeltaste Zusatz
	if Tastenlog
	{
		If (Zusatz="EndKey:Down")
			Einzeltaste=Down
		If (Zusatz="EndKey:Up")
			Einzeltaste=Up
		; MsgBox >`%Einzeltaste`%<`%Zusatz`%>
		if RShiftWeg
			StringReplace,Zusatz,Zusatz,`%Weg`%RShift,,
		if LShiftWeg
			StringReplace,Zusatz,Zusatz,`%Weg`%LShift,,
		If EnterDotOverDotWeg
			StringReplace,Zusatz,Zusatz,`%Weg`%Enter,``r``n,
		StringReplace,Zusatz,Zusatz,`%Weg`%,,
		StringReplace,Einzeltaste,Einzeltaste,`%weg`%,,
		StringReplace,Zusatz,Zusatz,`%weg1`%,,
/*
		if ErstZeichen
			ZuasatzTab:=A_Tab
		else
			ZuasatzTab:=
		ErstZeichen:=false
*/
		if (Zusatz<>"")
		{
			FileAppend,`%Einzeltaste`%{`%Zusatz`%},c:\temp\LetzteTastenBeginnSchafSS.txt,utf-16
			; ThisText=`%ThisText`%`%Einzeltaste`%`%ZuasatzTab`%
			ThisText:=ThisText  Einzeltaste ; ZuasatzTab
		}
		else
		{
			FileAppend,`%Einzeltaste`%`%ZuasatzTab`%,c:\temp\LetzteTastenBeginnSchafSS.txt,utf-16
			; ThisText=`%ThisText`%`%Einzeltaste`%`%ZuasatzTab`%
			ThisText:=ThisText  Einzeltaste  ; ZuasatzTab
		}
		TrayTip,TastenLog,`%Einzeltaste`%`%Zusatz`%``n``n`%ThisText`%
	}
}
return
SendeZuSendendeString: 
IfWinExist,ZackZackOrdner,,ahk_class CabinetWClass
{
	Loop, 5
	{
		ControlSetText,Edit4,`%ZuSendendeString`%.,ZackZackOrdner ahk_class AutoHotkeyGUI
		sleep, 4
		ControlGetText,VonEdit4,Edit4,ZackZackOrdner ahk_class AutoHotkeyGUI
		if(VonEdit4=ZuSendendeString)
		{
			Ergebnis:=true
			return
		}
		else if(VonEdit4=(Edit4 "."))
		{
			Sleep A_Index*10
			continue
		}
		else if(VonEdit4="")
		{
			TrayTip,2*Caps Befehl Tab, kann Ziel-Control Edit4 im Zielfenster ZackZackOrdner nicht erreichen.
			return
		}
		else
		{
			TrayTip,2*Caps Befehl Tab, Der Befehl konnte das Ziel-Control Edit4 im Zielfenster ZackZackOrdner nicht erreichen.
			return
		}
	}
}
return
Explorer:
IfWinActive,ahk_class CabinetWClass
{
	WinGetPos,WinX,WinY,WinB,WinH,A
	MausYLL:=MausYL
	MausYL:=MausY
	MausXLL:=MausXL
	MausXL:=MausX
	MouseGetPos,MausX,MausY
	x:=(WinX+WinX+WinB)/2+80
	WinYPlus:=WinY+25
	ExplorerHwnd:=WinExist(A)
	IfWinExist,ButtonGUI
	{
		if(MausXLL-X+WinX<70 and MausYLL-WinYPlus+WinY<70 and MausXLL-X+WinX>-50 and MausYLL-WinYPlus+WinY>-50 and MausX-MausXLL<70 and MausX-MausXLL>-70 and MausY-MausYLL<70 and MausY-MausYLL>-70)
		{
			WinMove,ahk_id `%GuiWinHwnd`%,,MausXLL+WinX-28,MausYLL+WinY-14	; Auskommnetgieren wenn Magneteffekt stoert
			sleep 800
		}
		else
		WinMove,ahk_id `%GuiWinHwnd`%,,`%X`%,WinYPlus
	}
	else
	{
		Gui,New,+HwndGuiWinHwnd   -Border -SysMenu 							; Parent`%ExplorerHwnd`%
		Gui, Add, Button, x1 y1  w50 h23 gButton1 , Ordner...
		; Generated using SmartGUI Creator for SciTE
		; Gui, Show,x`%X`% y`%WinY`% w80 h40  AutoSize , ButtonGUI				; AlwaysOnTop AutoSize NoActivate
		Gui, Show,x`%X`% y`%WinYPlus`%  AutoSize NoActivate, ButtonGUI				; AlwaysOnTop AutoSize NoActivate
		WinSet,AlwaysOnTop, On,ahk_id `%GuiWinHwnd`%
	}
	ControlGetFocus,FocussedControl,A
	if FocussedControl contains ToolbarWindow322,ToolbarWindow323,msctls_progress321,Edit1,DirectUIHWND1
		WinHide,ahk_id `%GuiWinHwnd`%
	else
		WinShow,ahk_id `%GuiWinHwnd`%
	WinSet,AlwaysOnTop, On,ahk_id `%GuiWinHwnd`%
	; DetectHiddenWindows,On
	; IfWinNotExist, ZackZackOrdner
		{
			; DetectHiddenWindows,Off
			; SplitPath,ZackZackOrdnerPath,,ZackZackOrdnerDirPath
			; Run,  `%ZackZackOrdnerPath`%,`%ZackZackOrdnerDirPath`%
		}
	; DetectHiddenWindows,Off
}
else IfWinActive,ahk_id `%GuiWinHwnd`%
{
}
else
{
	WinSet,AlwaysOnTop, Off,ahk_id `%GuiWinHwnd`%
	Gui,Submit
	WinHide,ahk_id `%GuiWinHwnd`%
}
return
##::	; wie  klicken von Ordner im TastWatch Programm zur Ordnerwahl; Ordner ist der bei Explorefenstern zusaetzlich erscheinende Button.
IfWinNotActive,ahk_class CabinetWClass
	{
		IfWinExist,ahk_class CabinetWClass
			WinActivate,ahk_class CabinetWClass
		else
			run, explorer.exe
	}
WinWaitActive,ahk_class CabinetWClass,,5
if ErrorLevel
	return
Button1:
	WinSet,AlwaysOnTop, Off,ahk_id `%GuiWinHwnd`%
	Gui,Submit
	WinHide,ahk_id `%GuiWinHwnd`%
sleep 60
ZuSendendeString:="SASize"
gosub SendeZuSendendeString
return
SendeTaste:
if (AltGrDownForNextInput and (AltGrDownForNextInputTime + 15000 < A_TickCount))
	{
	SendInput {RAlt Down}`%ThisText`%{RAlt Up}
	}
else if (ThisText="Esc")
	SendInput {Esc}
; else if (ThisText="AG")
	; SendInput {RAlt}
else if (ThisText="AG")
{
	; TastaturfocusNurScript:=true
	AltGrDownForNextInput:=true
	AltGrDownForNextInputTime:=A_TickCount
	; SendInput {RAlt Down}
}
; else if (ThisText="AGU")
	; SendInput {RAlt Up}
else if (ThisText="At")
	SendInput @
else if (ThisText="F1")
	SendInput {F1}
else if (ThisText="F2")
	SendInput {F2}
else if (ThisText="F3")
	SendInput {F4}
else if (ThisText="F4")
	SendInput {F5}
else if (ThisText="F5")
	SendInput {F6}
else if (ThisText="F6")
	SendInput {F7}
else if (ThisText="F7")
	SendInput {F8}
else if (ThisText="F8")
	SendInput {F9}
else if (ThisText="F9")
	SendInput {F2}
else if (ThisText="F10")
	SendInput {F10}
else if (ThisText="F11")
	SendInput {F11}
else if (ThisText="M") ; Menue-Taste Kontext-Menue oder RechtsClick-Menue
	SendInput {AppsKey}
else if (ThisText="F12")
	SendInput {F12}
else if (ThisText="Plus")
	SendInput {LWin Down}<{LWin Up}
else if (ThisText="AF4")	; Alt + F4
	SendInput {LAlt Down}{F4}{LAlt Up}
else if (ThisText=":")
	SendInput ˸
else if (ThisText="°")
	SendInput *
else if (ThisText="\")
	SendInput ►
; else if (ThisText="Euro")
	; SendInput {€}
else if (ThisText="BS")
	SendInput {BackSpace}
else if (ThisText="FS" or ThisText="Del")		; FowardSpace
	SendInput {Delete}
else if (ThisText="LG")		; Linke Geschweifte
	SendRaw {
else if (ThisText="RG")
	SendRaw }
else if (ThisText="LE")		; Linke Eckige
	SendRaw [
else if (ThisText="RE")
	SendRaw ]
else if (ThisText="Kl")		; kleiner
	SendRaw ]
else if (ThisText="/")		; BagSlash
	SendRaw \
else if (ThisText="Gr")		; groesser
	SendRaw >
else if (ThisText="Pipe")
	SendRaw |
return
WatchCapsLock:
if TastenUeberwachen
	TastenUeberwachen:=false
else
	TastenUeberwachen:=true
return
::CapsspaCon::
TastenUeberwachen:=true
return
::CapsspaCoff::
TastenUeberwachen:=false
return
GuiClose:
ExitApp
)
return
KontainerAnzeigen:
SplitPath,SkriptDataPath,NameSkriptDataPath
StringReplace,VarNameSkriptDataPath,NameSkriptDataPath,%A_Space%,_A_Space_,All
if(NameSkriptDataPath="Start Menu")
{
	IfNotExist %SkriptDataPath%\*_*
	{
		StartMenuStartPfad=%A_AppData%\Zack\StartMenuStartPfade.awpf
		IfNotExist %StartMenuStartPfad%
		{
			StartMenuStartPfade=
(
++%A_StartMenu%\*
++%A_StartMenuCommon%\*
++%A_WinDir%\System32\*.msc
++%MetroAppLinksDir%\*
)
			FileAppend,%StartMenuStartPfade%,%StartMenuStartPfad%,utf-16
		}
		AwpfPfad:=StartMenuStartPfad
		gosub WurzelVonBekannterDateiHinzuFuegen
		StartMenuStartPfadErst:=true
	}
	GrEdit2%VarNameSkriptDataPath%:=0
	Gui,1: Color, DDBBAA; EEAA99
	if (NeueBreite=506)
			gosub GuiWinH32
}
else
	Gui,1: Color, %GuiHintergrundFarbe%
; MsgBox % GrEdit2%VarNameSkriptDataPath%
if (GrEdit2%VarNameSkriptDataPath%<>"")
	GrEdit2:=GrEdit2%VarNameSkriptDataPath%
else
	GrEdit2:=GrEdit2Default
; gosub WorteCacheBefuellen
FavoritenDirPath:=SkriptDataPath "\!Fav"
GuiControl,1:Text,%HwndButton1%,aktualisieren`n[%NameSkriptDataPath%]
if StartMenuStartPfadErst
{
	StartMenuStartPfadErst:=false
	; Exit
}
; ToolTip % A_LineNumber "	" GrEdit2
if (LetzterSkriptDataPath<>SkriptDataPath)
	LetzterSkriptDataPathI:=LetzterSkriptDataPath
	; LetzterSkriptDataPath:=SkriptDataPath
LetzterSkriptDataPath:=SkriptDataPath
; ToolTip % LetzterSkriptDataPathI
return
HauptKontainerAnzeigen:
SkriptDataPath=%WurzelContainer%\Haupt
gosub KontainerAnzeigen
return
TastWatch2Autorun:
MsgBox FileCreateShortcut, %A_AppDataCommon%\Zack\TastWatch.exe, %A_Startup%\TastWatch.exe.lnk
FileCreateShortcut, %A_AppDataCommon%\Zack\TastWatch.exe, %A_Startup%\TastWatch.exe.lnk
if ZackZackOrdnerLogErstellen
	ThreadUeberwachungLog(A_LineNumber-1,A_ThisHotkey,A_ThisLabel,A_ThisFunc,A_ThisMenu,A_ThisMenuItem,A_ThisMenuItemPos)
return
ThreadUeberwachungLog(LineNumber,ThisHotkey,ThisLabel,ThisFunc,ThisMenu,ThisMenuItem,ThisMenuItemPos)
{
	Global ZackZackOrdnerLogErstellen
	FileReadLine,ThisQuellZeile,%A_ScriptFullPath%,LineNumber
	StringReplace,ThisQuellZeile,ThisQuellZeile,`, ThreadUeberwachungLog(A_LineNumber`,A_ThisHotkey`,A_ThisLabel`,A_ThisFunc`,A_ThisMenu`,A_ThisMenuItem`,A_ThisMenuItemPos)
	StringReplace,ThisQuellZeile,ThisQuellZeile,ThreadUeberwachungLog(A_LineNumber`,A_ThisHotkey`,A_ThisLabel`,A_ThisFunc`,A_ThisMenu`,A_ThisMenuItem`,A_ThisMenuItemPos)
	FileAppend, % A_Now A_Tab LineNumber A_Tab ThisQuellZeile A_Tab ThisHotkey A_Tab ThisLabel A_Tab ThisFunc A_Tab ThisMenu A_Tab ThisMenuItem A_Tab ThisMenuItemPos "`r`n" ,%A_Temp%\ZackZackOrdner.Log,utf-16
}
Log:
run,%A_Temp%\ZackZackOrdner.Log
return
Edit82Send:	;	Sendet Inhalt von Edit8, wie auf Tastatur eigegeben.
ThisSend:=FuehrendeSterneEntfernen(Edit8)
send, %ThisSend%
return
Edit82Clip:	;	schreibt Inhalt von Edit8 ins Clipboard
FuerClipboard:=FuehrendeSterneEntfernen(Edit8)
StringReplace,Clipboard,FuerClipboard,`n,`r`n,All
return
Edit52Clip:	;	schreibt Inhalt von Edit5 ins Clipboard
gosub Button3
return
Clip2Edit5:	;	schreibt Inhalt vom Clipboard in Edit5 und Festigt
Edit5:=Clipboard
gosub Edit5Festigen
return
WorteCacheBefuellen:
return 		; momentan deaktiviert
FoldernamesMitVielenDoppelten:=
Loop,Files,%SkriptDataPath%\FolderNames*.txt,F
{
	FileRead,FoldernamesMitDoppelten,%A_LoopFileLongPath%
	FoldernamesMitVielenDoppelten:=FoldernamesMitVielenDoppelten "`r`n" FoldernamesMitDoppelten
}
StringTrimLeft,FolderNames,FoldernamesMitVielenDoppelten,2
Sort,FolderNames,U
return
; < ################################  Vom Gui aufegrufene Functions  #################################### >	@0230
AbfrageFenster(FuncEinstellungen="",FensterTitel="",Frage="",ButtonText1="",ButtonText2="",ButtonText3="",ButtonText4="",ButtonText5="",ButtonText6="",ButtonText7="",ButtonText8="",ButtonText9="")
{
; FuncEinstellungen: 	AbfrageFensterOnTop	DisableMainWindow	EditBeiErstEinfuegenLeeren	EditHatFokus	EditReadOnly	MarkiereEdit  <--- true or false
; FuncEinstellungen: 	DefaultButton	  <--- # or OK 	# ist die Nummer des Buttons
; AufrufBeispiele:
/*
AbfrageFenster()	; warten auf weiter
FuncEinstellungen := {DefaultButton: 7, EditReadOnly: 1}
AntwortButtonNummer:=SubStr(AbfrageFenster(FuncEinstellungen,"AnfangsBuchstabe","mit welchem Buchstabe soll begonnen werden?","a","b","c","d","e",">>>>mit einer Zahl",">>>>>>>>>>>>>>>>Abbruch"),1,1)
MsgBox % "Sie haben mit dem " AntwortButtonNummer ". Button geantwortet"
FuncEinstellungen := {DefaultButton: 2,EditBeiErstEinfuegenLeeren:1,EditHatFokus:1}
Antwort:=AbfrageFenster(FuncEinstellungen,"Notiz","Bitte schreiben Sie in dieses Feld Ihre Notiz in Prosa`n`n`n`nHinweis: das erste Zeichen wird versschluckt.",">>>habe keine Notiz",">>>>>>Notiz Hinterlassen")
FuncEinstellungen := {DefaultButton: 2,EditHatFokus:1,MarkiereEdit:1}
Antwort:=AbfrageFenster(FuncEinstellungen,"Notiz","Bitte schreiben Sie in dieses Feld Ihre Notiz in Prosa`n`n`n`n",">>>habe keine Notiz",">>>>>>Notiz Hinterlassen")
if(SubStr(Antwort,1,1)=2)
	MsgBox % SubStr(Antwort,2)
ExitApp
*/
static 					; alle
BeschaeftigtAnzeige(1)
AbfrageFensterErg:=0
; DefaultEinstellungen
DisableMainWindow:=false
AbfrageFensterOnTop:=true
EditReadOnly:=false
EditBeiErstEinfuegenLeeren:=false
DefaultButton:="OK"
EditHatFokus:=false
MarkiereEdit:=false
FirstEdit:=true
if(IsObject(FuncEinstellungen))
{
For FuncVarName, FuncVarInhalt in FuncEinstellungen
    %FuncVarName% := FuncVarInhalt
}
if(FensterTitel="")
	FensterTitel:=A_ScriptName
if(Frage="")
	Frage:="weiter?"
Frage4711:=Frage
if(ButtonText1="")
	ButtonText1:="OK"
ReadOnly=
If EditReadOnly
	ReadOnly=ReadOnly
StringSplit, Frage4711Array, Frage4711, `n, `r
if LeerZeilenAmEndeWeglassen
{
	Loop
	{
		IF(SubStr(Frage4711, 0,1)="`n")
			StringTrimRight, Frage4711, Frage4711, 1
		Else
			Break
	}
}
Default=
Loop, 10
	{
	If(ButtonText%A_Index%<>"")
		{
		ButtonText4711%A_Index%:=ButtonText%A_Index%
		NeachRechts%A_Index%:=1
		Index:=A_Index
		Loop
		{
			; MsgBox % SubStr(ButtonText4711%Index%, 1,1)
			IF(SubStr(ButtonText4711%Index%, 1,1)=">")
			{
				++NeachRechts%Index%
				StringTrimLeft, ButtonText4711%Index%, ButtonText4711%Index%, 1
			}
			Else
				Break
		}
			If (DefaultButton="OK")
			{
				IF(ButtonText4711%A_Index%="OK")
					Default=Default
				Else
					Default=
			}
			else if DefaultButton is Integer
			{
				if (A_Index=DefaultButton)
					Button%A_Index%Default:=true
				else
					Button%A_Index%Default:=false
			}
		}
	Else
	{
		ButtonText47110:=A_Index - 1
		Break
	}
	}
; Gui, 4:+owner1  ; Make the main window (Gui #1) the owner of the "about box" (Gui #2).
Gui,4:New,+HwndGui4WinHwnd
if DisableMainWindow
	Gui,1: +Disabled  ; Disable main window.
if AbfrageFensterOnTop
	Gui,4:+Resize  AlwaysOnTop
else
	Gui, 4:+Resize  ; Make the window resizable.
loop % ButtonText47110
{
	ThisButtonText:=ButtonText4711%A_Index%
	ThisNeachRechts:=NeachRechts%A_Index%*4
	if DefaultButton is Integer
	{
		if Button%A_Index%Default
			Default=Default
		else
			Default=
	}
	; ThisButtonGoto:=gButton%A_Index%
	If(A_Index=1 And NeachRechts%A_Index%>1)
		Gui, 4:Add, Button, x%ThisNeachRechts%  gG4Button%A_Index% %Default%, %ThisButtonText%	
	Else If(A_Index=1)
		Gui, 4:Add, Button,   gG4Button%A_Index%  HwndHwndG4Button%A_Index% %Default%, %ThisButtonText%
	Else
		Gui, 4:Add, Button, x+%ThisNeachRechts%  gG4Button%A_Index% %Default%, %ThisButtonText%
}
If(Frage4711<>"")
	{
	MaxBreite:=40
	Loop, parse, Frage4711, `n, `r  ; Specifying `n prior to `r allows both Windows and Unix files to be parsed.
		{
		ThisBreite:=strlen(A_LoopField)
		; MsgBox % ThisBreite
		If(MaxBreite<ThisBreite)
			MaxBreite:=ThisBreite
	}
		EditBreite:=MaxBreite*10
		If(A_ScreenWidth<EditBreite)
			EditBreite:=A_ScreenWidth
	Gui, 4:Add, Edit, HwndHwndG4Edit1 vFrage4711 gFrage4711 %ReadOnly% X1 W%EditBreite%  R%Frage4711Array0%	; "WantTab" hätte Tabulatoren im Text zugelassen.
	}
Gui, 4:Show,, %FensterTitel%
; ControlFocus,Edit1,ahk_id %GuiWinHwnd%
if EditHatFokus
	ControlFocus,,ahk_id %HwndG4Edit1%										; Edit fokusieren
If(Frage4711<>"")
	GuiControl,4:, Frage4711, %Frage4711%  ; Put the text into the control.
; sleep 10000	; Zeit für die Eingabe
if MarkiereEdit
{
	ControlFocus,,ahk_id %HwndG4Edit1%										; Edit fokusieren
	Controlsend,Edit1,{Ctrl Down}a{Ctrl Up},ahk_id %Gui4WinHwnd%		; Edit markieren
}
Goto NachRet
4GuiSize:
if ErrorLevel = 1  ; The window has been minimized.  No action needed.
{
    return
}
; Otherwise, the window has been resized or maximized. Resize the Edit control to match.
NewWidth := A_GuiWidth - 2
ControlGetPos , Edit1X, Edit1Y, Edit1Width, Edit1Height, Edit1, %FensterTitel%
ControlGetPos , ,G4Button1Y , ,, ,ahk_id %HwndG4Button1%
; SysGet, TitleBarHeight, 31, SM_CYSIZE
TitleBarHeight:=Edit1Y-G4Button1Y+5*A_ScreenDPI/96
NewHeight := A_GuiHeight   -Edit1Y/A_ScreenDPI*96  +TitleBarHeight/A_ScreenDPI*96   -4*96/A_ScreenDPI
; ToolTip % A_GuiHeight "	" A_GuiHeight "	"  Edit1Y "	" TitleBarHeight "	" G4Button1Y
; TrayTip,FensterGröße, % NewWidth "	" NewHeight,5
GuiControl,4: Move, Edit1, W%NewWidth%  H%NewHeight%
; GuiControl, Focus, Edit1  
return
Frage4711:
if (FirstEdit and EditBeiErstEinfuegenLeeren)
{
	ControlGetFocus, FocusedGuiConntrol,A
	; MsgBox % FocusedGuiConntrol
	if (FocusedGuiConntrol="Edit1")
	{
		Frage4711:=
		GuiControl,,%HwndG4Edit1%,
		FirstEdit:=false
	}
}
return
G4Button9:
++AbfrageFensterErg
G4Button8:
++AbfrageFensterErg
G4Button7:
++AbfrageFensterErg
G4Button6:
++AbfrageFensterErg
G4Button5:
++AbfrageFensterErg
G4Button4:
++AbfrageFensterErg
G4Button3:
++AbfrageFensterErg
G4Button2:
++AbfrageFensterErg
G4Button1:
++AbfrageFensterErg
Gui,4: Submit
; MsgBox %Frage4711%
AbfrageFensterErg=%AbfrageFensterErg%%Frage4711%
4GuiClose:  ; User closed the window.
Gui,4: Destroy
; ExitApp
Gui,1: -Disabled  ; Enable main window.
return AbfrageFensterErg
NachRet:
; WinWaitClose, %FensterTitel%
WinWaitClose, ahk_id %Gui4WinHwnd%
; AbfrageFensterErg=%AbfrageFensterErg%%Frage4711%
Gui,1: -Disabled  ; Enable main window.
BeschaeftigtAnzeige(-1)
return AbfrageFensterErg
}
FunktionGosub(LabelName)
{
	global
	if(IsLabel(LabelName))
	{
		gosub %LabelName%
			return 1
	}
	else
		return 0
}
FunktionIfGosub(Var1,Operator,Var2,JaLabel="",NeinLabel="")
{
	global
	if(Operator="=")
	{
		if(Var1=Var2)
		{
			if(JaLabel="" and NeinLabel="")
			{
				FunktionLoopBreak:=true
				return 1
			}
			if(IsLabel(JaLabel))
			{
				gosub %JaLabel%
					return 1
			}
		}
		else
		{
			if(IsLabel(NeinLabel))
			{
				gosub %NeinLabel%
					return 1
			}
		}
	}
	if(Operator="<>")
	{
		if(Var1<>Var2)
		{
			if(JaLabel="" and NeinLabel="")
			{
				FunktionLoopBreak:=true
				return 1
			}
			if(IsLabel(JaLabel))
			{
				gosub %JaLabel%
					return 1
			}
		}
		else
		{
			if(IsLabel(NeinLabel))
			{
				gosub %NeinLabel%
					return 1
			}
		}
	}
	if(Operator=">")
	{
		if(Var1>Var2)
		{
			if(JaLabel="" and NeinLabel="")
			{
				FunktionLoopBreak:=true
				return 1
			}
			if(IsLabel(JaLabel))
			{
				gosub %JaLabel%
					return 1
			}
		}
		else
		{
			if(IsLabel(NeinLabel))
			{
				gosub %NeinLabel%
					return 1
			}
		}
	}
	if(Operator="<")
	{
		if(Var1<Var2)
		{
			if(JaLabel="" and NeinLabel="")
			{
				FunktionLoopBreak:=true
				return 1
			}
			if(IsLabel(JaLabel))
			{
				gosub %JaLabel%
					return 1
			}
		}
		else
		{
			if(IsLabel(NeinLabel))
			{
				gosub %NeinLabel%
					return 1
			}
		}
	}
	if(Operator="StringRechtsInLinks")
	{
		if(InStr(Var1,Var2))
		{
			if(JaLabel="" and NeinLabel="")
			{
				FunktionLoopBreak:=true
				return 1
			}
			if(IsLabel(JaLabel))
			{
				gosub %JaLabel%
					return 1
			}
		}
		else
		{
			if(IsLabel(NeinLabel))
			{
				gosub %NeinLabel%
					return 1
			}
		}
	}
	return 0
}
FunktionLoop(LoopLabel,Var1)
{
	global
	SoOft:=0
	FunktionLoopBreak:=false
	Loop % Var1
	{
		if(IsLabel(LoopLabel))
		{
			if FunktionLoopBreak
				break
			; MsgBox % LoopLabel
			gosub %LoopLabel%
			++SoOft
		}
	}
	return SoOft
}
; ----------------------------------------------------------------------------------------------------
Sleep(Delay)
{
	sleep, %Delay%
	return
}
; < / ##############################  Vom Gui aufegrufene Functions  #################################### >
; < ################################  Vom Gui aufegrufene Labels  #################################### >	@0250

SoundPlayEdit8:
SoundPlay, % FuehrendeSterneEntfernen(Edit8)
return
SoundPlayClipboard:
KopieClipboard:=Clipboard
Loop,Parse,KopieClipboard,`n,`r
{
	Edit10:=A_LoopField
	gosub Edit10Festigen
	SoundPlay, % FuehrendeSterneEntfernen(A_LoopField),1
}
return
; < ###########################################  Edits  ############################################ >	@0260
Edit1:		;	@0261														; PfadAnzeigeZaehler (so viele Pfade, wuerden bei gross genugem Fenster angezeigt)
HwndEdit1:															; Hauptabhaengig vom SuchEingabeFeld und der Abbrruchs-Nummer
BeschaeftigtAnzeige(1)
if (SucheAbgebrochen and not InStr(Edit1,"("))
{
	Edit1:="(" Edit1 ")"
	gosub Edit1Festigen
}
BeschaeftigtAnzeige(-1)
return
Edit2MitDotDotStattDotOverDot(Edit2)
{
	if(SubStr(Edit2,2,1)=":")
	{
		StringReplace,Rueck,Edit2,:,˸
		return Rueck
	}
	else if(SubStr(Edit2,1,1)=":")
	{
		StringTrimLeft,RueckNachDotOverDot,Edit2,1
		return "˸" RueckNachDotOverDot
	}
	return Edit2
}
Edit2Grau:
BeschaeftigtAnzeige(1)
Edit2Wirksam:=false
; if(LastEdit2Wirksam<>Edit2Wirksam)
{
	Gui,1: Font, csilver Bold ; , Courier  
	GuiControl,1: Font, Edit2  
	; GuiControl ,1: +csilver,Edit2
	; ToolTip,% "(" Edit2 ")",104,85+GuiYAbzuziehen
	; x98 	y78
	; goto Edit2Festigen
	; exit
}
LastEdit2Wirksam:=Edit2Wirksam
BeschaeftigtAnzeige(-1)
return
Edit2Schwarz:
BeschaeftigtAnzeige(1)
Edit2Wirksam:=true
; if(LastEdit2Wirksam<>Edit2Wirksam)
{
	Gui,1: Font, cBlack Bold ; , Courier  
	GuiControl,1: Font, Edit2  
	; GuiControl ,1: +cblack,Edit2
	; ToolTip,
	; goto Edit2Festigen
	; exit
}
LastEdit2Wirksam:=Edit2Wirksam
BeschaeftigtAnzeige(-1)
return
Edit2:		;	@0262														; (wichtigstes Eingabefeld)
HwndEdit2:															; SuchEingabeFeld Filter ueber Ordnername (schnell)
BeschaeftigtAnzeige(1)
; GuiControl ,1: +cblack,Edit2
Gui,1:Submit,NoHide
; GuiControl ,1: +cblack,Edit2
Edit2CaretX:=A_CaretX
Edit2CaretY:=A_CaretY
ControlGetFocus, FocusedGuiConntrol,A
{				
	Edit2Teil0=
	Edit2Teil1=
	Edit2Teil2=
	Edit2Teil%Edit2TeilR2%=
	If(SubStr(Edit2,1,1)=")")
	{										; Sonderbehandlung bei erstem Zeichen =)
		gosub Edit2Schwarz
		RegExBeratungsFormularFuer:="Edit2"
		gosub RegExBeratungsFormular
	}
	else If(SubStr(Edit2,1,8)=FilePatternKenner)	; Sonderbehandlung bei für File-Direkt
	{
		FileDirektPatternPlus:=SubStr(Edit2,9)
		if(InStr(FileDirektPatternPlus,"`,"))
		{
			StringGetPos, LastKommaPos, FileDirektPatternPlus, `, , R
		}
		Ges=
		if LastKommaPos
		{
			FileDirektPattern:=SubStr(FileDirektPatternPlus,1,LastKommaPos)
			NachKomma:=SubStr(FileDirektPatternPlus,LastKommaPos+2)
		}
		if Fehlersuche
			ToolTip,Files	%FileDirektPattern%	%NachKomma%
		Loop,Files,%FileDirektPattern%,%NachKomma%
			Ges.="`r`n" A_LoopFileFullPath
		FileDirektInhalt:=SubStr(Ges,3)
		; ToolTip % FileDirektPath
		Edit5:=FileDirektInhalt
		gosub Edit5Festigen
		BeschaeftigtAnzeige(-1)
		return
	}
	else If(SubStr(Edit2,1,7)=FileKenner)	; Sonderbehandlung bei für File-Direkt
	{
		FileDirektPath:=SubStr(Edit2,8)
		IfExist % FileDirektPath
		{
				FileGetAttrib,FileDirektAttribute,%FileDirektPath%
				if(InStr(FileDirektAttribute,"D"))
				{
					Ges=
					Loop,Files,%FileDirektPath%\*.*,F D
						Ges.="`r`n" A_LoopFileFullPath
					FileDirektInhalt:=SubStr(Ges,3)
				}
				else
					FileRead,FileDirektInhalt,% FileDirektPath
		}
		; ToolTip % FileDirektPath
		Edit5:=FileDirektInhalt
		gosub Edit5Festigen
		BeschaeftigtAnzeige(-1)
		return
	}
	else If (InStr(Edit2,Backslash))
	{										; Sonderbehandlung bei enthaltenem \
		gosub Edit2Schwarz
		Gui,1:Submit,NoHide
		StringSplit,Edit2Teil,Edit2,`\
		AllEdit2TeilBefuellt:=true
		Loop, % Edit2Teil0
		{
			Edit2TeilIndex:=A_Index
			if(Edit2Teil%A_Index%="")
				AllEdit2TeilBefuellt:=false
		}
		; ToolTip, vor if AllEdit2TeilBefuellt
		if AllEdit2TeilBefuellt
		{
			FuerEdit7:=
			Loop, % Edit2Teil0
			{
				if(A_Index=Edit2Teil0-2)
					FuerEdit7:=FuerEdit7 "\" Edit2Teil%A_Index%
				else if(A_Index<(Edit2Teil0-1))
					FuerEdit7:=FuerEdit7 "\" Edit2Teil%A_Index%
			}
			StringTrimLeft,FuerEdit7,FuerEdit7,1
			if(FuerEdit7<>"")
			{
				Edit7:=FuerEdit7
				GuiControl,1:, %HwndEdit7%, %Edit7%
				Edit2TeilR2:=Edit2Teil0-1
				if (Edit2Teil0>2)
				{
					SuFi:=true
					GuiControl,1:, %HwndCheckE0%, 1 
				}
			}
			if(Edit2Teil%Edit2TeilR2%<>"")
			{
				Edit5:=GetPaths(Edit2Teil%Edit2TeilR2%,SucheAbrechen,"Edit5")
				WirksamerFilter:=Edit2Teil%Edit2TeilR2%
			}
			else if(Edit2Teil0=1)
			{
				Edit5:=GetPaths(Edit2,SucheAbrechen,"Edit5")		
				WirksamerFilter:=Edit2
			}
				GuiControl,1:, %HwndEdit5%, %Edit5%  
				Edit8:=GetZeile(Edit5,Edit3)
				GuiControl,1:,%HwndEdit8%,%Edit8%
			LetzerAendererVonEdit5:="Edit2"
			IfExist % FuehrendeSterneEntfernen(Edit8)
			{
				UnterordnerEdit8:=FuehrendeSterneEntfernen(Edit8)
				If Fehlersuche
					ToolTip, % FuehrendeSterneEntfernen(Edit8) Backslash  Edit2Teil%Edit2Teil0% A_Tab FuerEdit7 A_Tab Edit2Teil1 a_tab Edit2Teil2 a_tab Edit2Teil3 a_tab Edit2Teil4 a_tab Edit2Teil5 a_tab AllEdit2TeilBefuellt 
				Loop,Files,% FuehrendeSterneEntfernen(Edit8) Backslash Edit2Teil%Edit2Teil0%, D R
					UnterordnerEdit8:=UnterordnerEdit8 "`r`n" A_LoopFileLongPath
				Edit5:=UnterordnerEdit8
				GuiControl,1:,%HwndEdit5%,%Edit5%
			}
		}
	}
	else if(StrLen(Edit2)>GrEdit2 or FocusedGuiConntrol<>"Edit2")									; keine Sonderbehandlung kein \ vorhanden
	{
		gosub Edit2Schwarz
		Edit5:=GetPaths(Edit2MitDotDotStattDotOverDot(Edit2),SucheAbrechen,"Edit5")
		GuiControl,1:, Edit5, %Edit5%  
		LetzerAendererVonEdit5:="Edit2"
	}
	else
		gosub Edit2Grau
}

gosub Edit5
Gui,1:Submit,NoHide
StringSplit,VorDotOverDot,Edit1,:
if(VorDotOverDot0>1)
{
	AnzahlZeichenLinksWeg:=0
	StringReplace,VorDotOverDot1,VorDotOverDot1,`(
	AnzahlZeilenObenWeg:=VorDotOverDot1-1
	if (AnzahlZeilenObenWeg>0)
	{
		Edit5:=Entferne(Edit5,AnzahlZeichenLinksWeg,AnzahlZeilenObenWeg)
		gosub Edit5Festigen
	}
}
BeschaeftigtAnzeige(-1)
return
Edit3:		;	@0263														; PfadNummernEingabe
HwndEdit3:
BeschaeftigtAnzeige(1)
Gui,1:Submit,NoHide
Edit5UpDown:=Edit3
GuiControl,1:, Edit5UpDown, %Edit5UpDown%  
Edit8:=GetZeile(Edit5,Edit3)
GuiControl,1:, Edit8, %Edit8%  
BeschaeftigtAnzeige(-1)
return
; Edit4 ----> @0264
Edit5:		;	@0265														; Anzeige der Pfade
HwndEdit5:
BeschaeftigtAnzeige(1)
loop,
{
	if(LetzerAendererVonEdit5="Edit5")
		LetzerAendererVonEdit5:=
	IfWinActive,ahk_id %GuiWinHwnd%
	{
		ControlGetFocus, FocusedGuiConntrol,A
		if (FocusedGuiConntrol="Edit5")
		{
			LetzerAendererVonEdit5:="Edit5"
			if(A_TimeIdlePhysical>20)
				break
			else
				sleep 10
		}
		else
			break
	}
	else
		break
}
Gui,1:Submit,NoHide
if(LetzerAendererVonEdit5<>"Edit5")
{
	{
		sort,Edit5,U 
		GuiControl,1:, Edit5, %Edit5%
	}
}

Gui,1:Submit,NoHide
StringSplit,VorDotOverDot,Edit1,:
if(VorDotOverDot0>1)
{
	AnzahlZeichenLinksWeg:=0
	StringReplace,VorDotOverDot1,VorDotOverDot1,`(
	AnzahlZeilenObenWeg:=VorDotOverDot1 ; -1 hier nicht
	Edit1:=AnzahlZeilenObenWeg . ":" . ZaehleZeilen(Edit5) ; +AnzahlZeilenObenWeg
	; Edit5:=Entferne(Edit5,AnzahlZeichenLinksWeg,AnzahlZeilenObenWeg)
	; gosub Edit1Festigen
}
else
	Edit1:=ZaehleZeilen(Edit5)
GuiControl,1:, Edit1, %Edit1% 
gosub Edit3
BeschaeftigtAnzeige(-1)
return
Edit6:		;	@0266														; Schleifenabbruch Nummern Eingabe
HwndEdit6:
BeschaeftigtAnzeige(1)
Gui,1:Submit,NoHide
SucheAbrechen:=Edit6
LetzerAendererVonEdit5:="Edit2"
BeschaeftigtAnzeige(-1)
return
Edit7Farbe:
BeschaeftigtAnzeige(1)
if (not SuFi and NurCacheFolderNr<>Edit7)
{
	; if(Edit7<0)
	; 	GuiControl , +cred,Edit7
	; else
		GuiControl ,1: +csilver,Edit7
}
else if (not SuFi and NurCacheFolderNr=Edit7)
{
	if(Edit7<0)
		GuiControl ,1: +cred,Edit7
	else
		GuiControl ,1: +cblue,Edit7
}
else if(SubStr(Edit7,1,1)="""" and SuFi and not RegEx) 
	GuiControl ,1: +cCC0000,Edit7
else if(SuFi and RegEx) 
	GuiControl ,1: +cff00ff,Edit7
else
	GuiControl ,1: +cGreen,Edit7
; ControlFocus,%HwndEdit7%,ahk_id %HwndGuiWin%
; ControlClick,%HwndEdit7%,ahk_id %HwndGuiWin%
; ControlClick,,ahk_id %HwndEdit7%	; funzt setzt aber Schreibmarke nach rechts
BeschaeftigtAnzeige(-1)
return
Edit7:		;	@0267														; Filter ueber Ges. Pfad (langsam)
HwndEdit7:
BeschaeftigtAnzeige(1)
Gui,1:Submit,NoHide
LetzerAendererVonEdit5:="Edit7"	
NurCacheFolderNr:=0
if Edit7 is Integer			; nur Cache-Ordner-Nr
{
	if(Edit10="Zusatz")
	{
		Edit10:="Start-Pfade: "
		gosub Edit10Festigen
	}
	{
		if not Sufi
		{
			NurCacheFolderNr:=Edit7
			gosub StartPfadAenderung
		}
	}
}
gosub Edit7Farbe
IfWinActive,ahk_id %GuiWinHwnd%
{
 	GuiControlGet, FocussedControl, FocusV				; 20160415090001  FocusV dokumentieren 
	if (LastRegExBeratungsFormularSendTimeStamp="")
		LastRegExBeratungsFormularSendTimeStamp:=0
}
if((A_TickCount-LastRegExBeratungsFormularSendTimeStamp>4000))
{
	if RegEx
	{
		if (FocussedControl="Edit7")
		{
			RegExBeratungsFormularFuer:="Edit7"
			gosub RegExBeratungsFormular
		}
	}
}
BeschaeftigtAnzeige(-1)
return
Edit8:		;	@0268																; Die EinzelpfadAusgabe (wichtigstes Ausgabefeld)
HwndEdit8:
BeschaeftigtAnzeige(1)
Gui,1:Submit,NoHide
if(Clipboard<>FuehrendeSterneEntfernen(Edit8))
	GuiControl,1:Text,%HwndButton3%,└> &Clip
else
	GuiControl,1:Text,%HwndButton3%,┌> &Clip
ControlGetFocus,ThisFocussedControl,A
if(ThisFocussedControl="Edit8") ; damit Edit8 selbst editiert werden kann ohne dass die Schreibmarke abhaut.
{
	; gosub Edit8Festigen
	BeschaeftigtAnzeige(-1)
	return
}
		If (Edit8="" and Edit3=1)
		{
			BeschaeftigtAnzeige(-1)
			return
		}
		else If ((Edit8="" and Edit3<>1) or (Edit8=0 and Edit3<>1))		; hinzugekommene Klammer  or (Edit8=0 and Edit3<>1) PRuefen #############################
		{
			ControlGetFocus,FocusedGuiConntrol,ahk_id %GuiWinHwnd%
			if(FocusedGuiConntrol<>"Edit3")
			{
				Edit3:=1
				GuiControl,1:, %HwndEdit3%, %Edit3% 
			}
		}
if AuAb
{
	If(not instr(Edit8,Edit2))
	{
		If (Edit8="")
		{
			BeschaeftigtAnzeige(-1)
			return
		}
		gosub IeControl
		GuiControl,1:, Edit6, %Edit6% 
		gosub Edit6
	}
}
gosub IeControl
gosub SucheInEdit5Markieren
BeschaeftigtAnzeige(-1)
return
Edit9:		;	@0269																; Anzeige voN der automatisch  hochschalttenden Abbrruchs-Nummer
HwndEdit9:
BeschaeftigtAnzeige(1)
Gui,1:Submit,NoHide
BeschaeftigtAnzeige(-1)
return
Edit10:	; aufgerufen vom ZackZsackOrdner-Gui bei Veraenderung von Edit10 (Zusatz)
HwndEdit10:	; aufgerufen vom ZackZsackOrdner-Gui bei Veraenderung von Edit10 (Zusatz)
Edit10temp:=Edit10
Gui,1:Submit,NoHide
if(StrLen(Edit10temp)>StrLen(Edit10))
	Edit10WirdKleiner:=true
else
	Edit10WirdKleiner:=false
StartPfadAenderung:
BeschaeftigtAnzeige(1)
if(SubStr(Edit10,1,13)="Start-Pfade: ")
{
	IfWinActive,ahk_id %GuiWinHwnd%
	{
		ControlGetFocus, FocusedGuiConntrol,A
		if (FocusedGuiConntrol="Edit10" and Edit10WirdKleiner)
		{
			BeschaeftigtAnzeige(-1)
			return
		}
	}
	DieseStartPfadeUebersichtZeilenAnzeige:="Start-Pfade: "
	Loop,Files,%SkriptDataPath%\*, D
	{
		if not Sufi
		{
			if Edit7 is Integer
			{
				if(Edit7>0)
				{
					if(A_Index<>Edit7)
						continue
				}
				else if(Edit7<0)
				{
					if(A_Index=-Edit7)
						continue			
				}
			}
		}
		if(A_LoopFileName="!Fav")
			DieseStartPfadeUebersichtZeilenAnzeige .= A_Space A_Space A_LoopFileName
		else
		{
			StaPf:=SubStr(A_LoopFileName,5)
			StringReplace,StaPf,StaPf,˸,:,All
			StringReplace,StaPf,StaPf,►,\,All
			StringReplace,StaPf,StaPf,°,*,All
			DieseStartPfadeUebersichtZeilenAnzeige .= A_Space A_Space StaPf
		}
	}
	Edit10:=DieseStartPfadeUebersichtZeilenAnzeige
	gosub Edit10Festigen
}
BeschaeftigtAnzeige(-1)
return
; < / #########################################  Edits  ############################################ >
; < ###########################################  Buttons  ############################################ >	@0270
Button1:	;	@0271
HwndButton1:
BeschaeftigtAnzeige(1)
SuchVerlauf()
if MausGuenstigPositionieren
	MouseMove,134*DpiKorrektur,(Edit5Y0+Edit5Hoehe/2+55)*DpiKorrektur
Gui,1:Submit,NoHide
StringSplit,VorDotOverDot,Edit1,:
if(VorDotOverDot0>1)
{
	AnzahlZeichenLinksWeg:=0
	StringReplace,VorDotOverDot1,VorDotOverDot1,`(
	AnzahlZeilenObenWeg:=VorDotOverDot1-1
	if (AnzahlZeilenObenWeg>0 and SubStr(Edit6,0,1)=5)	; nur wenn Edit6 mit 5 endet wird Edit6 automatisch verstellt.
	{
		if(Edit6<AnzahlZeilenObenWeg+25)
		{
			Edit6:=AnzahlZeilenObenWeg+25
			gosub Edit6Festigen
			sleep 100
		}
		if(Edit6>AnzahlZeilenObenWeg+50)
		{
			Edit6:=AnzahlZeilenObenWeg+25
			gosub Edit6Festigen
			sleep 100
		}
		; ToolTip %A_LineNumber% %VorDotOverDot0%	%AnzahlZeilenObenWeg%
	}
; ToolTip % A_LineNumber "	" VorDotOverDot0 "	" AnzahlZeilenObenWeg  "	" SubStr(Edit6,0,1)

}
AktualisierungAufButton1:=true
Edit5:=
Edit8:=
gosub Edit2
AktualisierungAufButton1:=false
IfWinActive,ahk_id %GuiWinHwnd%
{
	ControlGetFocus, FocusedGuiConntrol,A
	if (FocusedGuiConntrol<>"Edit3")
	{
		ControlFocus,Edit3,ahk_id %GuiWinHwnd%
		ControlSend,Edit3,^a,ahk_id %GuiWinHwnd%
	}
}
BeschaeftigtAnzeige(-1)
return
Button2:	;	@0272
HwndButton2:
BeschaeftigtAnzeige(1)
if(AutoFavorit>0)
	; gosub SetAutoFavorit
	SetAutoFavorit(Edit8,0,FavoritenDirPath,AutoFavorit)
IfNotExist % FuehrendeSterneEntfernen(Edit8)
{
	Edit8OhneStern:=FuehrendeSterneEntfernen(Edit8)
	if(SubStr(Edit8OhneStern,1,4)="http" and InStr(Edit8OhneStern,":"))
	{
		Clipboard:=Edit8OhneStern
		MsgBox, 262160, Fehler, Abbruch`, da eine Weiterverarbeitung von`n%Edit8OhneStern%`nnicht sinnvoll erscheint.`nWenn doch kann der Weblink vom Clipboard geholt werden.
		BeschaeftigtAnzeige(-1)
		return
	}
	if (IfFileOderDirSyntax(Edit8OhneStern))
		; if(((StrLen(Edit8OhneStern)>2 and InStr(Edit8OhneStern,"\")) or (StrLen(Edit8OhneStern)=2)) and ((SubStr(Edit8OhneStern,1,2)="\\"  or  SubStr(Edit8OhneStern,2,1)=":")))
		{
		MsgBox, 262180, Ordner, der Ordner `n	%Edit8OhneStern% `nexistiert nicht`, soll er angelegt werden
		IfMsgBox,Yes
		{
			FileCreateDirAndAutoFav(Edit8OhneStern)
		}
	}
}
ThisAufmerksamkeitHWND:=WinExist("ahk_class #32770")
if(false)
{
 if(BeiGuiWinHwndkeinAutoPop<>ThisAufmerksamkeitHWND)
	{
		if TimerFehlerSuche
		{
			TrayTip, Timer WarteSpeicherOeffnen %A_LineNumber%, BeiGuiWinHwndkeinAutoPop= %BeiGuiWinHwndkeinAutoPop%  =	ThisAufmerksamkeitHWND= %ThisAufmerksamkeitHWND%
			sleep 3000
		}
		Gui,1:Submit,NoHide
	if (Not Akt and not Min and not OnTop)
	{
	}
	else if (Akt and not Min and not OnTop)
	{
	}
	else if (Akt and  Min and  OnTop)
	{
		BeiGuiWinHwndkeinAutoPop:=WinExist("ahk_class #32770")
		WinMinimize,ahk_id %GuiWinHwnd%
	}
	else If Min
	{
		BeiGuiWinHwndkeinAutoPop:=WinExist("ahk_class #32770")
		WinMinimize,ahk_id %GuiWinHwnd%
	}
	else if OnTop
	{
		WinSet,Top,,ahk_id %GuiWinHwnd%
	}
	else if Not Min
		WinMinimize,ahk_id %GuiWinHwnd%
	else 
	{
		BeiGuiWinHwndkeinAutoPop:=WinExist("ahk_class #32770")
		WinMinimize,ahk_id %GuiWinHwnd%
	}
}
}
gosub GuiWinMin
sleep 100
IfWinNotActive,ahk_class #32770
	WinActivate,ahk_class #32770
WinWaitActive,ahk_class #32770,,1
gosub Edit82AWin
BeschaeftigtAnzeige(-1)
return
/*

ControlGetFocus,AktWinFocusedControl,A
ControlGetText,ThisDateiNameText,%AktWinFocusedControl%,A
if SrLi
{
	sleep 5
	send {Home}
	sleep 50
}
if AlleVerwenden
	Loop,Parse,Edit5,`n,`r
	{
		Control,EditPaste, % FuehrendeSterneEntfernen(A_LoopField AnSchreibMarkenAusgabeAnhaengen),%AktWinFocusedControl%,A
		break
	}
else 
{
	If(IsFunc("DateiNamensVorschlag"))
	{
		FuncName=DateiNamensVorschlag
		AnSchreibMarkenAusgabeAnhaengen:=%FuncName%(ThisDateiNameText)
		ControlSetText,%AktWinFocusedControl%, %Edit8%%AnSchreibMarkenAusgabeAnhaengen%,A
	}
	else
	{
		Control,EditPaste, % FuehrendeSterneEntfernen(Edit8 AnSchreibMarkenAusgabeAnhaengen),%AktWinFocusedControl%,A
	}
}
if SendEnterNachSchreibmarkeEinfuegen
{
	sleep 200
	send {Enter}
}
ControlFocus,Edit2,ahk_id %GuiWinHwnd%
GuiControl,1: +Default, %HwndButton4%				
BeschaeftigtAnzeige(-1)
*/
return
Button3:	;	@0273
HwndButton3:
BeschaeftigtAnzeige(1)
Gui,1:Submit,NoHide
if(Clipboard<>FuehrendeSterneEntfernen(Edit8))
{
	Clipboard:=FuehrendeSterneEntfernen(Edit8)
	; GuiControl,Text,%HwndButton3%,┌> &Clip
}
else
{
	; GuiControl,Text,%HwndButton3%,└> &Clip
	StringReplace,FuerClipEdit5,Edit5,`n,`r`n,All
	Clipboard:=FuerClipEdit5
	if(InStr(FuerClipEdit5,"*") or InStr(FuerClipEdit5,A_Tab))
	{
		MsgBox, 262180, Weiter-Verarbeitung, In der Clipboard-Ausgabe sind für die Weiter-Verarbeitung unübliche spezial-Zeichen ("*" oder Tab) von ZackZackOrdner.`nSollen diese entfernt bzw. ersetzt werden?
		IfMsgBox,Yes
		{
			StringReplace,FuerClipEdit5,FuerClipEdit5,*,,All
			StringReplace,FuerClipEdit5,FuerClipEdit5,%A_Tab%,\,All
			Clipboard:=FuerClipEdit5
		}
	}
}
If Min
{
	DeltaLastGuiMinizeTime:=LastGuiMinizeTime - GuiMinizeTime
	LastGuiMinizeTime:=GuiMinizeTime
	GuiMinizeTime:=A_TickCount
	WinMinimize,ahk_id %GuiWinHwnd%
}
BeschaeftigtAnzeige(-1)
return
Button4:	;	@0274
HwndButton4:
BeschaeftigtAnzeige(1)
if(AutoFavorit>0)
	; gosub SetAutoFavorit
	SetAutoFavorit(Edit8,0,FavoritenDirPath,AutoFavorit)
if Fehlersuche
	TrayTip,A_ThisLabel	EinmalKopieDieseDatenkopie, % A_ThisLabel "	" EinmalKopieDieseDatenkopie
if (A_ThisLabel="SASize" or EinmalKopieDieseDatenkopie="SASize")
{
	gosub IfMainGuiMinRestore
	xGutTemp=
	yAtemp=
	WinGetPos,xGutTemp,yGutTemp,bGutTemp,hGutTemp,ahk_id %GuiWinHwnd%
	WinGetPos,xAtemp,yAtemp,bAtemp,hAtemp,ahk_class CabinetWClass
	if(xGutTemp=xAtemp and yGutTemp=yAtemp and bGutTemp=bAtemp and hGutTemp=hAtemp)
	{
		If Min
		{
			DeltaLastGuiMinizeTime:=LastGuiMinizeTime - GuiMinizeTime
			LastGuiMinizeTime:=GuiMinizeTime
			GuiMinizeTime:=A_TickCount
			WinMinimize,ahk_id %GuiWinHwnd%
		}
		else if OnTop
			WinSet,Bottom,,ahk_id %GuiWinHwnd%
		WinActivate,ahk_class CabinetWClass 
		gosub ex
		BeschaeftigtAnzeige(-1)
		return
	}
}
ControlFocus,Edit5,ahk_id %GuiWinHwnd%
if AlleVerwenden
{
	ThisMsgBoxAnswer:=false
		Gui,1:Submit,NoHide
	Loop,Parse,Edit5,`n
	{
		LoopFieldRun:=FuehrendeSterneEntfernen(A_LoopField)
		if (substr(LoopFieldRun,-3)=".lnk")
		{
			FileGetShortcut, %LoopFieldRun% ,LoopFieldRun
		}
		if ExpSel
		{
			if (InStr(LoopFieldRun,"http:") or InStr(LoopFieldRun,"https:") or InStr(LoopFieldRun,"ftp:") or InStr(LoopFieldRun,"File:"))  
				run, %LoopFieldRun%
			else
				run, explorer.exe /select`,"%LoopFieldRun%"
		}
		else
		{
			if (InStr(LoopFieldRun,"http:") or InStr(LoopFieldRun,"https:") or InStr(LoopFieldRun,"ftp:") or InStr(LoopFieldRun,"File:"))  
				run, %LoopFieldRun%
			else
			run, explorer.exe "%LoopFieldRun%"
		}
		if (a_index>2 and not ThisMsgBoxAnswer)
		{
			MsgBox, 262180, Ordner oeffnen, wirklich alle Ordner oeffnen?
			IfMsgBox,No
			{
				BeschaeftigtAnzeige(-1)
				return
			}
			IfMsgBox,Yes
				ThisMsgBoxAnswer:=true
		}
	}
}
else
{
	Edit8Run:=FuehrendeSterneEntfernen(Edit8)
		if (substr(Edit8Run,-3)=".lnk")
		{
			FileGetShortcut, %Edit8Run% ,Edit8Run
		}
	if ExpSel
	{
		if (InStr(Edit8Run,"http:") or InStr(Edit8Run,"https:") or InStr(Edit8Run,"ftp:") or InStr(Edit8Run,"File:"))  
			run, %Edit8Run%
		else
			run, explorer.exe /select`,"%Edit8Run%"
	}
	else
	{
		if (InStr(Edit8Run,"http:") or InStr(Edit8Run,"https:") or InStr(Edit8Run,"ftp:") or InStr(Edit8Run,"File:"))  
			run, %Edit8Run%
		else
		run, explorer.exe "%Edit8Run%"
	}
}
If Min
{
	DeltaLastGuiMinizeTime:=LastGuiMinizeTime - GuiMinizeTime
	LastGuiMinizeTime:=GuiMinizeTime
	GuiMinizeTime:=A_TickCount
	WinMinimize,ahk_id %GuiWinHwnd%
}
BeschaeftigtAnzeige(-1)
return
Button5:	;	@0275
HwndButton5:
if(AutoFavorit>0)
	; gosub SetAutoFavorit
	SetAutoFavorit(Edit8,0,FavoritenDirPath,AutoFavorit)
KopiereOderVerschiebeFilesAndFolders:
BeschaeftigtAnzeige(1)
if(ControlText="")
{
	if not DateiPfadeWerdenUebergeben
	{
		if (Clipboard="")
		{
			MsgBox, 262192, Clipboard leer, Diese Aktion benoetigt wenigstens einen existierenden Pfad im Clipboard:`nBitte Datei(en) und oder Ordner  im Explorer markieren und mit  Tastenkombination Control + C ins Clipboard bringen und Vorgang wiederholen.
			BeschaeftigtAnzeige(-1)
			return
		}
		EinExistierenderPfadGefunden:=false
		Loop,Parse,Clipboard,`n,`r
		{
			IfExist %A_LoopField%
			{
				EinExistierenderPfadGefunden:=true
				break
			}
		}
		if not EinExistierenderPfadGefunden
		{
			MsgBox, 262192, Clipboard enthaelt keine Pfade, Diese Aktion benoetigt wenigstens einen existierenden Pfad im Clipboard:`nBitte Datei(en) und oder Ordner  im Explorer markieren und mit  Tastenkombination Control + C ins Clipboard bringen und Vorgang wiederholen.
			BeschaeftigtAnzeige(-1)
			return
		}
		DateiPfade:=Clipboard
	}
	SumDateien:=0
	SumOrdner:=0
	OriginalErhalten=
	StringSplit,ThisZeilenAnzahl,DateiPfade,`n
	DurchschnittlicheZeichenAnzahlPro6Zeilen:=StrLen(DateiPfade)/ThisZeilenAnzahl0*16
	DateiPfadAnfang:=SubStr(DateiPfade,1,DurchschnittlicheZeichenAnzahlPro6Zeilen)
	StringSplit,ThisZeilenAnzahl,DateiPfadAnfang,`n
	if(ThisZeilenAnzahl>25)
		DateiPfadAnfang:=SubStr(DateiPfadAnfang,1,StrLen(DateiPfadAnfang)/2)
	if(DateiPfade<>DateiPfadAnfang)
		DateiPfadAnfang=%DateiPfadAnfang% ...
	Loop,Parse,DateiPfade,`n,`r
	{
		SplitPath,A_LoopField,,OutDir,OutExt,OutNameNoExt
		OutNameNoExtOrg:=OutNameNoExt
		if ZielPfadWirdUebrgeben
			ThisEdit8:=FuehrendeSterneEntfernen(ZielPfad)
		else 
			ThisEdit8 := FuehrendeSterneEntfernen(Edit8)
		if(ThisEdit8=OutDir) ; if Versioniere
			OutNameNoExt:=OutNameNoExt "[" A_Now "]"
		else
			OutNameNoExt:=OutNameNoExt 
		IfExist,% FuehrendeSterneEntfernen(OutDir "\" OutNameNoExtOrg "." OutExt)
		{
			if (OriginalErhalten="")
			{
				if(ThisEdit8=OutDir) ; if Versioniere
				{
					if(not InStr(OutNameNoExt,"`["))
						OutNameNoExt:=OutNameNoExt "[" A_Now "]"
				}
				else
					OutNameNoExt:=OutNameNoExt 
				if(ThisEdit8=OutDir)
				{
					FuncEinstellungen := {DefaultButton: 1, AbfrageFensterOnTop: 1}
					AbfrageFensterAntwort:=AbfrageFenster(FuncEinstellungen,"Copy to Version / Move to Version","Quellen:`n" DateiPfadAnfang "`n`n-Ordner:`n" ThisEdit8,"Versioniere und behalte Original",">>>>>>>behalte nur Version",">>>>>>>>>>>>>>>>>>>>>Abbruch")
					; MsgBox, 262179, Original, erhalten? (Ziel: %ThisEdit8%)`n`nJa			Original + Version`n`nNein 			nur Version`n`n%DateiPfadAnfang%
				}
				else
				{
					FuncEinstellungen := {DefaultButton: 1, AbfrageFensterOnTop: 1}
					AbfrageFensterAntwort:=AbfrageFenster(FuncEinstellungen,"Copy / Move","Quellen:`n" DateiPfadAnfang "`n`nZiel-Ordner:`n" ThisEdit8,"Kopieren",">>>>>>>Verschieben",">>>>>>>>>>>>>>>>>>>>>Abbruch")		; geprueft OK I
					; MsgBox, 262179, Original, erhalten? (Ziel: %ThisEdit8%)`n`nJa			Original + Kopie`n`nNein 			nur Kopie`n`n%DateiPfadAnfang%
				}
				if(SubStr(AbfrageFensterAntwort,1,1)=2)	; IfMsgBox,No
				{
					OriginalErhalten:=false
				}
				else if(SubStr(AbfrageFensterAntwort,1,1)=1)	; IfMsgBox,Yes
				{
					OriginalErhalten:=true
				}
				else if(SubStr(AbfrageFensterAntwort,1,1)=3)	; IfMsgBox,Cancel
				{
					BeschaeftigtAnzeige(-1)
					return
				}
				else
				{
					BeschaeftigtAnzeige(-1)
					return
				}
			}
			If not OriginalErhalten
			{
				if InStr(FileExist(OutDir "\" OutNameNoExtOrg), "D") 
				{
					IfExist,% FuehrendeSterneEntfernen(OutDir "\" OutNameNoExtOrg)
					{
						if ZielPfadWirdUebrgeben
							ThisEdit8:=FuehrendeSterneEntfernen(ZielPfad)
						else 
							ThisEdit8 := FuehrendeSterneEntfernen(Edit8)
						DieserZielPfad=%ThisEdit8%\%OutNameNoExt%
						SplitPath,DieserZielPfad,,DieserZielDir
						IfNotExist %ThisEdit8%
						{
							; MsgBox % A_LineNumber
							FuncEinstellungen := {DefaultButton: 1, AbfrageFensterOnTop: 1}
							AntwortButtonNummer:=SubStr(AbfrageFenster(FuncEinstellungen,"Zielordner existiert nicht","Fuer die Aktion Ordner veschieben von`n" OutDir "\" OutNameNoExtOrg "`nnach`n" ThisEdit8 "\" OutNameNoExt "`nexistiert der Zielordner `n" DieserZielDir "`nnicht`, soll er angelegt werden?","Ordner anlegen","nicht anlegen und weitermachen",">>>>verschieben abbrechen"),1,1)		; Ordner anlegen geprueft OK
							if(AntwortButtonNummer=1) ; IfMsgBox,Yes
								FileCreateDirAndAutoFav(ThisEdit8)	;	FileCreateDir, %ThisEdit8%
							else if(AntwortButtonNummer=2) ; IfMsgBox, No
								continue
							else
								break
						}
						FileMoveDir,%OutDir%\%OutNameNoExtOrg%,%ThisEdit8%\%OutNameNoExt%,R
						if ErrorLevel
						{
							TrayTip,%A_LineNumber% Warnung, Datei %OutDir%\%OutNameNoExtOrg%.%OutExt% konnte nicht nach %ThisEdit8%\%OutNameNoExt% verschoben werden
							sleep 6000
						}
						else
							SumOrdner++
					}
					continue
				}
				else
				{
					if ZielPfadWirdUebrgeben
						ThisEdit8:=FuehrendeSterneEntfernen(ZielPfad)
					else 
						ThisEdit8 := FuehrendeSterneEntfernen(Edit8)
					DieserZielPfad=%ThisEdit8%\%OutNameNoExt%.%OutExt%
					SplitPath,DieserZielPfad,,DieserZielDir
					IfNotExist %DieserZielDir%
					{
							FuncEinstellungen := {DefaultButton: 1, AbfrageFensterOnTop: 1}
							AntwortButtonNummer:=SubStr(AbfrageFenster(FuncEinstellungen,"Zielordner existiert nicht","Fuer die Aktion Datei Verschieben von`n" OutDir "\" OutNameNoExtOrg "." OutExt "`nnach`n" ThisEdit8 "\" OutNameNoExt "." OutExt "`nexistiert der Zielordner `n" DieserZielDir "`nnicht","Ordner anlegen","nicht anlegen und weitermachen",">>>>verschieben abbrechen"),1,1)		; positiv geprueft II
							if(AntwortButtonNummer=1) ; IfMsgBox,Yes
								FileCreateDirAndAutoFav(ThisEdit8)	;	FileCreateDir, %ThisEdit8%
							else if(AntwortButtonNummer=2) ; IfMsgBox, No
								continue
							else
								break
					}
					FileMove,%OutDir%\%OutNameNoExtOrg%.%OutExt%,%ThisEdit8%\%OutNameNoExt%.%OutExt%
					if ErrorLevel
					{
						TrayTip,%A_LineNumber% Warnung, Datei %OutDir%\%OutNameNoExtOrg%.%OutExt% konnte nicht nach %ThisEdit8%\%OutNameNoExt%.%OutExt% verschoben werden
						sleep 6000
					}
					else
						SumDateien++
				}
			}
			If OriginalErhalten
			{
				if InStr(FileExist(OutDir "\" OutNameNoExtOrg), "D") 
				{
					IfExist,% FuehrendeSterneEntfernen(OutDir "\" OutNameNoExtOrg)
					{
						if ZielPfadWirdUebrgeben
							ThisEdit8:=FuehrendeSterneEntfernen(ZielPfad)
						else 
							ThisEdit8 := FuehrendeSterneEntfernen(Edit8)
						DieserZielPfad=%ThisEdit8%\%OutNameNoExt%
						SplitPath,DieserZielPfad,,DieserZielDir
						IfNotExist %ThisEdit8%
						{
							; MsgBox % A_LineNumber
							FuncEinstellungen := {DefaultButton: 1, AbfrageFensterOnTop: 1}
							AntwortButtonNummer:=SubStr(AbfrageFenster(FuncEinstellungen,"Zielordner existiert nicht","Fuer die Aktion Ordner kopieren von`n" OutDir "\" OutNameNoExtOrg "`nnach`n" ThisEdit8 "\" OutNameNoExt "`nexistiert der Zielordner `n" DieserZielDir "`nnicht`, soll er angelegt werden?","Ordner anlegen","nicht anlegen und weitermachen",">>>>kopieren abbrechen"),1,1)		; geprueft Ordner anlegen OK I	nicht anlegen und weitermachen OK
							if(AntwortButtonNummer=1) ; IfMsgBox,Yes
								FileCreateDirAndAutoFav(ThisEdit8)	;	FileCreateDir, %ThisEdit8%
							else if(AntwortButtonNummer=2) ; IfMsgBox, No
								continue
							else
								break
						}
						FileCopyDir,%OutDir%\%OutNameNoExtOrg%,%ThisEdit8%\%OutNameNoExt%,R
						if ErrorLevel
						{
							TrayTip,%A_LineNumber% Warnung, Datei %OutDir%\%OutNameNoExtOrg% konnte nicht nach %ThisEdit8%\%OutNameNoExt% kopiert werden
							sleep 6000
						}
						else
							SumOrdner++
					}
					continue
				}
				else
				{
					if ZielPfadWirdUebrgeben
						ThisEdit8:=FuehrendeSterneEntfernen(ZielPfad)
					else 
						ThisEdit8 := FuehrendeSterneEntfernen(Edit8)
					DieserZielPfad=%ThisEdit8%\%OutNameNoExt%.%OutExt%
					SplitPath,DieserZielPfad,,DieserZielDir
					IfNotExist %DieserZielDir%
					{
						; MsgBox % A_LineNumber
						FuncEinstellungen := {DefaultButton: 1, AbfrageFensterOnTop: 1}
						AntwortButtonNummer:=SubStr(AbfrageFenster(FuncEinstellungen,"Zielordner existiert nicht","Fuer die Aktion Datei kopieren von`n" OutDir "\" OutNameNoExtOrg "." OutExt "`nnach`n" ThisEdit8 "\" OutNameNoExt "." OutExt "`nexistiert der Zielordner `n" DieserZielDir "`nnicht`, soll er angelegt werden?","Ordner anlegen","nicht anlegen und weitermachen",">>>>kopieren abbrechen"),1,1)		; Ordner anlegen OK II
							if(AntwortButtonNummer=1) ; IfMsgBox,Yes
								FileCreateDirAndAutoFav(ThisEdit8)	;	FileCreateDir, %ThisEdit8%
							else if(AntwortButtonNummer=2) ; IfMsgBox, No
								continue
							else
								break
					}
					FileCopy,%OutDir%\%OutNameNoExtOrg%.%OutExt%,%ThisEdit8%\%OutNameNoExt%.%OutExt%
					if ErrorLevel
					{
						TrayTip,%A_LineNumber% Warnung, Datei %OutDir%\%OutNameNoExtOrg%.%OutExt% konnte nicht nach %ThisEdit8%\%OutNameNoExt%.%OutExt% kopiert werden
						sleep 6000
					}
					else
						SumDateien++
				}
			}
		}
		else
		{
			TrayTip,%A_LineNumber% Warnung, Datei %OutDir%\%OutNameNoExtOrg%.%OutExt% nicht gefunden`nAbbrruch
			BeschaeftigtAnzeige(-1)
			return
		}
	}
	TrayTip,%A_LineNumber% Hinweis, %SumDateien% Dateien / %SumOrdner% Ordner wurden kopiert / verschoben.
	DateiPfadeWerdenUebergeben:=false
	DateiPfade:=
}
BeschaeftigtAnzeige(-1)
return
; < / #########################################  Buttons  ############################################ >
; < ###########################################  Checkboxen  ############################################ >	@0280
AuAb:												; Autoabbruch nach Default 20 Eingelesenen Cache-Dateien
Gui,1:Submit,NoHide
if AuAb
	 GuiControl,1:, AuAb, %AuAb%							; 	
else
	 GuiControl,1:, AuAb, %AuAb%
return
SufiAus:
SuFi:=0
GuiControl,1:, SuFi,0
return
SufiAn:
SuFi:=1
GuiControl,1:, SuFi,1	
GuiControl,1:, %wndCheckE0%,1	
GuiControl,1:, %HwndCheckE0%, 1
return
SuFi:												; Suchmodus NORMAL
Gui,1:Submit,NoHide
if SuFi
{
	GuiControl,1:, SuFi, %SuFi%							;
	; {
	; 	Edit6:=400
	;	gosub Edit6Festigen
	; }
}
else
{
	 GuiControl,1:, SuFi, %SuFi%
	if(Edit6=400)
	{
		Edit6:=20
		gosub Edit6Festigen
	}
}
gosub StartPfadAenderung
gosub Edit7Farbe
ControlClick,,ahk_id %HwndEdit7%
; gosub F5
return
RegEx:												; Suchmodus REGEX
Gui,1:Submit,NoHide
if RegEx
	 GuiControl,1:, RegEx, %RegEx%							; 	
else
	 GuiControl,1:, RegEx, %RegEx%
gosub Edit7Farbe
ControlClick,,ahk_id %HwndEdit7%
return
SeEn:	; Checkbox fuer Button2 bewirkt OK nachsenden bei true Default deqaktiviert
Gui,1:Submit,NoHide
if SeEn
	SendEnterNachSchreibmarkeEinfuegen:=true
else
	SendEnterNachSchreibmarkeEinfuegen:=false
return
SrLi:	; Checkbox fuer Button2 bewirkt Links-Sprung bei true
Gui,1:Submit,NoHide
return
WoAn:	; Checkbox fuer die Suche nur vom Wortanfang
Gui,1:Submit,NoHide
; Auswirkung auf GetPaths()
gosub Edit2
return
BsAn:	; Checkbox fuer Button2 bewirkt Backslash anhaengen bei true
Gui,1:Submit,NoHide
if BsAn
	AnSchreibMarkenAusgabeAnhaengen:="\"
else
	AnSchreibMarkenAusgabeAnhaengen:=
return
OnTop:											; Fenster nicht konsequent On Top 
Gui,1:Submit,NoHide
OnTopSetzen:
if OnTop
{
	WinSet,AlwaysOnTop, On
	GuiControl,1:, OnTop, %OnTop%
}
else
{
	WinSet,AlwaysOnTop, Off
	GuiControl,1:, OnTop, %OnTop%
}
return
Akt:											; Fenster nicht konsequent Aktiv
Gui,1:Submit,NoHide
AktSetzen:
if Akt
	GuiControl,1:, Akt, %Akt%
else
	GuiControl,1:, Akt, %Akt%
return
; < / #########################################  Checkboxen  ############################################ >
; < ###########################################  Haupt-Menue  ############################################ >	@0290
; ---------------------------------------
; Datei	@0291
; ---------------------------------------
; Menu, Dateimenü, 		Add, &Reload					, NeuStarten
NeuStarten:						; hier alle Enden Sammeln und noch speichernswertes pruefen...
R:
Process, Close, %TastWatchPid%
Reload
return
; Menu, Dateimenü, 		Add, &Skript-Ordner oeffnen		, SkriptOrdnerOeffnen	
SkriptOrdnerOeffnen:
run, %A_ScriptDir%
return
; ---------------------------------------
; Menu, Dateimenü, 		Add, &Data-Ordner oeffnen		, DataOrdnerOeffnen	
DataOrdnerOeffnen:					
run, %ZackData%
return
; ---------------------------------------
; Menu, Dateimenü, 		Add, &Testumgebung erzeugen		, TestumgebungErzeugen	
TestumgebungErzeugen:
BeschaeftigtAnzeige(1)
TempSpielw:=ZackData "\TestUmgebung"
IfExist,%TempSpielw%
{
	MsgBox, 262180, Testumgebung, bisherige Testumgebung `n	%TempSpielw%`nloeschen?
	IfMsgBox,Yes
		FileRemoveDir,%TempSpielw%,1
}
IfNotExist %TempSpielw%
	FileCreateDir,%TempSpielw%
Farben=
(
Gelb
Orange
Gruen
Blau
Braun
Schwarz
)
Zahlen=
(
Eins
Zwei
Drei
Vier
Fuenf
Sechs
)
ZahlenTe=
(
erste
zweite
dritte
vierte
fuenfte
sechste
)
Loop,Parse,Farben,`n,`r
{
	DieseFarbe:=A_LoopField
	FileCreateDir,%TempSpielw%\%DieseFarbe%
	Loop,Parse,Zahlen,`n,`r
	{
		DieseZahl:=A_LoopField
		FileCreateDir,%TempSpielw%\%DieseFarbe%\%DieseZahl%
		Loop,Parse,ZahlenTe,`n,`r
		{
			FileAppend,Mein Ausganspunkt ist in ...\%DieseFarbe%\%DieseZahl%`r`ndort bin ich die %A_LoopField% Datei,%TempSpielw%\%DieseFarbe%\%DieseZahl%\%DieseFarbe%_%DieseZahl%_%A_Index%.txt,utf-16
		}
	}
}
run, %TempSpielw%
TestContainerPfad=%ZackData%\WuCont\Testumgebung
IfExist,%TestContainerPfad%
{
	MsgBox, 262180, Testumgebung, bisherigen TestContainer `n	%TestContainerPfad%`nloeschen?
	IfMsgBox,Yes
	{
		FileRemoveDir,%TestContainerPfad%,1
		IfNotExist %TestContainerPfad%
			FileCreateDir,%TestContainerPfad%
		IfExist,%TestContainerPfad%
		{
			SkriptDataPath:=TestContainerPfad
			gosub KontainerAnzeigen
			NeueWurzel:=TempSpielw "\*"
			; WurzelName:=TempSpielw "\*"
			gosub NeueWurzelHinzufuegenBeiVorhandenemWurzelName
		}
	}
}
else
{
	IfNotExist %TestContainerPfad%
	{
		FileCreateDir,%TestContainerPfad%
		SkriptDataPath:=TestContainerPfad
		gosub KontainerAnzeigen
		NeueWurzel:=TempSpielw "\*"
		; WurzelName:=TempSpielw "\*"
		gosub NeueWurzelHinzufuegenBeiVorhandenemWurzelName
	}
}
{
	sleep 2000
	IfExist %ZackData%\WuCont\Testumgebung\Wurzel???.txt
	{
		MsgBox, 262144, gratuliere, der Container `n%ZackData%\WuCont\Testumgebung`nwurde erfolgreich angelegt und der Start-Pfad`n%NeueWurzel%`nwurde eingelesen und aktiviert.`n`n`nMit`nMenue: Container | (Angezeigten) oeffnen`nkann man wieder den bisherigen aktivieren.`n`n`nEs wurden 6 Ordner mit Farbnamen erstellt.`nDiese enthalten jeweils 6 Ordner mit Eins bis Sechs als Namen.`nDiese wiederum enthalten Dateien in denen steht`, wo sie sich urspruenglich (bei Neuaufbau) befanden.`nMit diesen 42 Ordnern und 6*6*6 Dateien kann ZackZackOrdner getestet werden.`nMit nochmaligem Auswaehlen von Menue: Datei | Testumgenung erzeugen kann leicht alles wieder neu aufgebaut werden.
	}
	else IfExist %ZackData%\WuCont\Testumgebung
		MsgBox, 262144, gratuliere, der Container `n%ZackData%\WuCont\Testumgebung`nwurde erfolgreich angelegt.`n`n jedoch der Start-Pfad`n%ZackData%\Testumgebung`nwurde wurde nicht gefunden.
}
BeschaeftigtAnzeige(-1)
return
; ---------------------------------------
; Menu, Dateimenü, 		Add, &Beenden					, GuiClose
GuiClose:
Process, Close, %TastWatchPid%
if ErrorLevel
{
	Process, Close, TastWatch.ahk
	Process, Close, ButtonGui
}
ExitApp
ControlFocus,Edit2,A
return
; ---------------------------------------
; Edit8	@0292
; ---------------------------------------
; Menu, Edit8menue, 		Add, &oeffnen					, Edit8Oeffnen
Edit8Oeffnen:
run, % FuehrendeSterneEntfernen(Edit8)
if ZackZackOrdnerLogErstellen
	ThreadUeberwachungLog(A_LineNumber-1,A_ThisHotkey,A_ThisLabel,A_ThisFunc,A_ThisMenu,A_ThisMenuItem,A_ThisMenuItemPos)
return
; ---------------------------------------
; Menu, Edit8Menue, 		Add, &neuer Ordner				, Edit8NeuerOrdner
Edit8NeuerOrdner:
	Edit8OhneStern := FuehrendeSterneEntfernen(Edit8)
	if (substr(Edit8OhneStern,-3)=".lnk")
	{
		FileGetShortcut, %Edit8OhneStern% ,Edit8OhneStern
	}
	Gui,1:Submit,NoHide
	IfNotExist %Edit8OhneStern%
	{
		Edit10=
		if(not IfFileOderDirSyntax(Edit8OhneStern))		; Pruefungen ob Edit8OhneStern ein Pfad sein
		{
			MsgBox, 262160, Fehler, Der Pfad fuer den neuen Ordner hat Syntax-Fehler`n%Edit8OhneStern%
			return
		}
		FileCreateDirAndAutoFav(Edit8OhneStern)
		return
	}
	else if (Edit10="")
	{
		MsgBox, 262176, Neuer Ordner Name , bitte den neuen Ordnername im Untersten Feld eingeben und Vorgang wiederholen.
		return
	}
	else if (SubStr(Edit10,1,13)="Start-Pfade: ")
	{
		Edit10:=
		gosub Edit10Festigen
		MsgBox, 262176, Neuer Ordner Name , bitte den neuen Ordnername im Untersten Feld eingeben und Vorgang wiederholen.
		return
	}
	else if (Edit10="Zusatz")
	{
		MsgBox, 262436, Neuer Ordner Name , bitte den neuen Ordnername im Untersten Feld eingeben und Vorgang wiederholen.`nOder soll der neue Ordner wirklich Zusatz lauten?
		IfMsgBox,No
			return
	}
	{
		StringSplit,NeuerOrdner,Edit10,|,%A_Space%
		{
			Loop, % NeuerOrdner0
			{
				ThisNeuerOrdner:=NeuerOrdner%A_Index%
				; IfExist %Edit8OhneStern%
				FileGetAttrib,Edit8OhneSternAttrib,%Edit8OhneStern%
				if(InStr(Edit8OhneSternAttrib,"D"))
				{
					FileCreateDirAndAutoFav(Edit8OhneStern "\" ThisNeuerOrdner)
					/*
					; FileCreateDir,%Edit8OhneStern%\%ThisNeuerOrdner%
					if ErrorLevel
					{
						MsgBox, 262176, Fehler, Konnte den Ordner `n`n%Edit8OhneStern%\%ThisNeuerOrdner%`n`nnicht anlegen.
					}
					else
					{
						TrayTip Ordner anlegen, Ordner `n`n%Edit8OhneStern%\%ThisNeuerOrdner%`n`nangelegt!
						Edit8=%Edit8OhneStern%\%ThisNeuerOrdner%
						gosub Edit8Festigen
					}
					*/
				}
				else
				{
					SplitPath,Edit8OhneStern,,Edit8OhneSternDir
					IfExist %Edit8OhneSternDir%
					{
						FileCreateDirAndAutoFav(Edit8OhneSternDir "\" ThisNeuerOrdner)
					}
				}
			}
		}
	}
return
; ---------------------------------------
; Menu, Edit8Menue, 		Add, &zeige Unter-DrueberOrdner		, Edit8ZeigeVorfahrenUndUnterordner
Edit8ZeigeVorfahrenUndUnterordner:
	BeschaeftigtAnzeige(1)
	SuchVerlauf()
	WarteZeitAkzeptiert:=true
	if(SubStr(Edit8,0,1)=":" and Rekursiv)
	{
		WarteZeitAkzeptiert:=false
		MsgBox, 262436, Unterordner eines Drives, Moechten Sie wiklich die frisch ermittelten Unterordner von %Edit8%?`n`nDies kann dauern.
		IfMsgBox,Yes
			WarteZeitAkzeptiert:=true
	}
	if WarteZeitAkzeptiert
	{
		Edit8OhneStern := FuehrendeSterneEntfernen(Edit8)
		gosub ZeigeAnstattVorfahrenUndUnterordnerEdit8
	}
BeschaeftigtAnzeige(-1)
return
Edit8ZeigeUnterOrdner:	; Zeigt temporaer den Ordner und die Unterordner von Edit8 in Edit5 an. Der Rest von Edit5 entfaellt. Ruft dazu auch ZeigeAnstattUnterordnerEdit8 auf.
	BeschaeftigtAnzeige(1)
	Edit8OhneStern := FuehrendeSterneEntfernen(Edit8)
	gosub ZeigeAnstattUnterordnerEdit8
	BeschaeftigtAnzeige(-1)
return
; ---------------------------------------
; Menu, Edit8Menue, 		Add, &Explorer					, Edit8Explorer
Edit8Explorer:	; ubergibt Edit8 an den Explorer
	Edit8OhneStern := FuehrendeSterneEntfernen(Edit8)
VarEdit8OhneSternGesetztExplorer:
	if (substr(Edit8OhneStern,-3)=".lnk")
	{
		FileGetShortcut, %Edit8OhneStern% ,Edit8OhneStern
	}
	if (InStr(Edit8OhneStern,"http:") or InStr(Edit8OhneStern,"https:") or InStr(Edit8OhneStern,"ftp:") or InStr(Edit8OhneStern,"File:"))  
		run, %Edit8OhneStern%
	else
		run, explorer.exe "%Edit8OhneStern%"
	if ZackZackOrdnerLogErstellen
		ThreadUeberwachungLog(A_LineNumber-1,A_ThisHotkey,A_ThisLabel,A_ThisFunc,A_ThisMenu,A_ThisMenuItem,A_ThisMenuItemPos)
return
; ---------------------------------------
; Menu, Edit8Menue, 		Add, &Explorer Select (GetFather)			, Edit8ExplorerSelect
Edit8ExplorerSelect:	; ubergibt Edit8 an den Explorer mit der Aufforderung Edit8 zu Selektieren bzw. markieren.
	Edit8OhneStern := FuehrendeSterneEntfernen(Edit8)
VarEdit8OhneSternGesetztExplorerSelect:
	if (substr(Edit8OhneStern,-3)=".lnk")
	{
		FileGetShortcut, %Edit8OhneStern% ,Edit8OhneStern
	}
	if (InStr(Edit8OhneStern,"http:") or InStr(Edit8OhneStern,"https:") or InStr(Edit8OhneStern,"ftp:") or InStr(Edit8OhneStern,"File:"))  
		run, %Edit8OhneStern%
	else
		run, explorer.exe /select`,"%Edit8OhneStern%"
	if ZackZackOrdnerLogErstellen
		ThreadUeberwachungLog(A_LineNumber-1,A_ThisHotkey,A_ThisLabel,A_ThisFunc,A_ThisMenu,A_ThisMenuItem,A_ThisMenuItemPos)
return
; ---------------------------------------
; Menu, Edit8Menue, 		Add, &Zeige Inhalte				, Edit8ExplorerEingebunden
Edit8ExplorerEingebunden:	; ruft RLShift auf
gosub RLShift
return
; ---------------------------------------
; Menu, Edit8Menue, 		Add, &umbenennen				, Edit8Umbenennen
Edit8Umbenennen:	; benennt den Ordner auf den Edit8 zeigt um in die Auswertung von Edit10
		Edit8OhneStern := FuehrendeSterneEntfernen(Edit8)
		if (substr(Edit8OhneStern,-3)=".lnk")
		{
			FileGetShortcut, %Edit8OhneStern% ,Edit8OhneStern
		}
		IfExist % Edit8OhneStern
		{
			Gui,1:Submit,NoHide
			If (Edit10="Zusatz" or Edit10="" or SubStr(Edit10,1,13)="Start-Pfade: ")
			{
				InputBox,Edit10,Umbenenen,neuer Name,,,,,,,,% Edit8OhneStern
				if ErrorLevel
					return
				GuiControl,1:, %HwndEdit10%, %Edit10%
			}
			If(Not InStr(Edit10,"\"))
			{
				SplitPath,% Edit8OhneStern,,Edit1Dir
				Edit10:= Edit1Dir "\" Edit10
				GuiControl,1:, %HwndEdit10%, %Edit10%
			}
			MsgBox, 36, Umbenennen, Bitte Bestaetigen:`nBenenne`n		%Edit8OhneStern%`num in `n		%Edit10%`n
			IfMsgBox,Yes
			{
				FileMoveDir,% Edit8OhneStern,%Edit10%,R
				if ErrorLevel
					MsgBox, 262192, Fehler beim Umbenennen, konnte 	%Edit8OhneStern%`nnicht in `n		%Edit10%`numbenennen
			}
		}
		else
			MsgBox, 262192, Fehler beim Umbennen, 		%Edit8OhneStern%`nexistiert nicht (mehr).`n`nAbbruch!
		return
return
; ---------------------------------------
; Menu, Edit8Menue, 		Add, &DateiSuche				, DateiSucheAusgehendVonEdit8
DateiSucheAusgehendVonEdit8:
FileSearchPath=%A_ScriptDir%\FileSearch.ahk		; Hier Holle's FileSearch-Pfad eintragen.
IfExist %FileSearchPath%		; wenn Holle's FileSearch vorhanden
{
	FileSearchPathExist:=true
	StringTrimRight,FileSearchIniPath,FileSearchPath,3
	FileSearchIniPath.="ini"
	IfWinNotExist FileSearch
	{
		IfExist %FileSearchIniPath%
		{
			IfExist % FuehrendeSterneEntfernen(Edit8)
			{
				IniWrite,% FuehrendeSterneEntfernen(Edit8),%FileSearchIniPath%,Options,LastFolder
				Run, %FileSearchPath%
				return
			}
		}
		Run, %FileSearchPath%
		return
	}
	else
	{
		WinActivate,FileSearch
		return
	}
}
IfExist %A_ScriptDir%\SucheDateien.ahk
{
	SucheDateienPfadahk=%A_ScriptDir%\SucheDateien.ahk
	if ZackZackOrdnerLogErstellen
		ThreadUeberwachungLog(A_LineNumber-1,SucheDateienPfadahk,A_ThisLabel,A_ThisFunc,A_ThisMenu,A_ThisMenuItem,A_ThisMenuItemPos)
}
IfExist %A_ScriptDir%\..\AdHoc\EigenstaendigeSkripts\SucheDateien.ahk
{
	SucheDateienPfadahk=%A_ScriptDir%\..\AdHoc\EigenstaendigeSkripts\SucheDateien.ahk
	if ZackZackOrdnerLogErstellen
		ThreadUeberwachungLog(A_LineNumber-1,SucheDateienPfadahk,A_ThisLabel,A_ThisFunc,A_ThisMenu,A_ThisMenuItem,A_ThisMenuItemPos)
}
IfExist %A_ScriptDir%\SucheDateien.exe
{
	SucheDateienPfadexe=%A_ScriptDir%\SucheDateien.exe
	if ZackZackOrdnerLogErstellen
		ThreadUeberwachungLog(A_LineNumber-1,SucheDateienPfadexe,A_ThisLabel,A_ThisFunc,A_ThisMenu,A_ThisMenuItem,A_ThisMenuItemPos)
}
IfExist %A_ScriptDir%\..\AdHoc\EigenstaendigeSkripts\SucheDateien.exe
{
	SucheDateienPfadexe=%A_ScriptDir%\..\AdHoc\EigenstaendigeSkripts\SucheDateien.exe
	if ZackZackOrdnerLogErstellen
		ThreadUeberwachungLog(A_LineNumber-1,SucheDateienPfadexe,A_ThisLabel,A_ThisFunc,A_ThisMenu,A_ThisMenuItem,A_ThisMenuItemPos)
}
; if ((SucheDateienPfadahk="" or SucheDateienPfadexe="") and not FileSearchPathExist)
if ((SucheDateienPfadahk="") and not FileSearchPathExist)
{
	MsgBox, 262160, Fehlendes HilfsProgramm, Um diese Funktion zu verwenden muss SucheDateien an einem der zwei folgenden Orte bereit gestellt werden:`n%A_ScriptDir%\SucheDateien.ahk	und exe`n%A_ScriptDir%\..\AdHoc\EigenstaendigeSkripts\SucheDateien.ahk	und exe`n`n..\ bedeutet einen Ordner nach oben. `n`nAlternativ kann auch Holle's FileSearch.ahk in den Skriptordner eingebunden werden.
	return
}
Edit8Sternlos:=FuehrendeSterneEntfernen(Edit8)
If (Rekursiv="R")
	SucheDateienRekursiv:=1
else
	SucheDateienRekursiv:=0
OhneInputOderLeer=
If(SubStr(Edit10,0,1)=".")			; Wenn Edit10 mit einem Punkt endet, dann die Suche gleich abschicken!
{
	OhneInputOderLeer=OhneInput	; fuer die Suche gleich abschicken!
	StringTrimRight,Edit10,Edit10,1
	gosub Edit10Festigen
}
if (Edit10="Zusatz" or SubStr(Edit10,1,11)="Start-Pfade")
	ThisSomeFilterText:=Edit2
else
	ThisSomeFilterText:=Edit10
DoBefehlsDatei=
(
Checkbox0=%SucheDateienRekursiv%
CheckboxTypen=0
%Edit8Sternlos%
Checkbox1=1
Checkbox2=0
CheckboxTxt=0
CheckboxOhneIcon=1
CheckboxSel=0
SomeFilterText=%ThisSomeFilterText%
ButtonFilter
)
DoBefehlsDatei=%DoBefehlsDatei%%OhneInputOderLeer%		; ergaenzt ggf. ButtonFilter
PfadDieserDoBefehlsDatei=%A_temp%\DieseDoBefehlsDatei.do
FileDelete,%A_temp%\DieseDoBefehlsDatei.do
if ZackZackOrdnerLogErstellen
	ThreadUeberwachungLog(A_LineNumber-1,A_ThisHotkey,A_ThisLabel,A_ThisFunc,A_ThisMenu,A_ThisMenuItem,A_ThisMenuItemPos)
FileAppend,%DoBefehlsDatei%,%A_temp%\DieseDoBefehlsDatei.do,utf-16
if ZackZackOrdnerLogErstellen
	ThreadUeberwachungLog(A_LineNumber-1,A_ThisHotkey,A_ThisLabel,A_ThisFunc,A_ThisMenu,A_ThisMenuItem,A_ThisMenuItemPos)
if ZackZackOrdnerLogErstellen
	ThreadUeberwachungLog(A_LineNumber+1,SucheDateienPfadexe,SucheDateienPfadahk,PfadDieserDoBefehlsDatei,A_ThisMenu,A_ThisMenuItem,"vor 8101")
SplitPath,SucheDateienPfadexe,,SucheDateienPfadDir
IfExist %SucheDateienPfadexe%
	Run,%SucheDateienPfadexe% "%SucheDateienPfadahk%" "%PfadDieserDoBefehlsDatei%",%SucheDateienPfadDir%
else
{
	IfExist %SucheDateienPfadahk%
		Run, %SucheDateienPfadahk% "%PfadDieserDoBefehlsDatei%",%SucheDateienPfadDir%
}
if ZackZackOrdnerLogErstellen
	ThreadUeberwachungLog(A_LineNumber-1,A_ThisHotkey,A_ThisLabel,A_ThisFunc,A_ThisMenu,A_ThisMenuItem,"nach 8101")
return
; ---------------------------------------
; Container	@0293
; ---------------------------------------
; Menu, ContainerMenue, 	Add, (Angezeigten) &oeffnen		, WurzelContainerOeffnen  
WurzelContainerOeffnen:
Gui,1: Submit,NoHide
ThisEingangsEdit8:=FuehrendeSterneEntfernen(Edit8)
Gui,1: Submit,NoHide
OnTopMerker:=OnTop
gosub ContainerUebersichtZeigen
OnTop:=OnTopMerker
gosub OnTopFestigen
Gui,1: Submit,NoHide
if(InStr(Edit5,ThisEingangsEdit8))
{
	if(substr(Edit8,-3,4)=".lnk")
	{
		FileGetShortcut, % ThisEingangsEdit8 , SkriptDataPath
		gosub KontainerAnzeigen
	}
	else IfExist % FuehrendeSterneEntfernen(Edit8)
	{
		SkriptDataPath:=Edit8
		gosub KontainerAnzeigen
	}
	else
	{
		Edit8Sternlos:=FuehrendeSterneEntfernen(Edit8)
		MsgBox %A_ScriptName% %A_LineNumber% Unerwareter Programmzweig`nDetail=%Edit8Sternlos%`n`n%Edit5%
	}
}
else
{
	WinGetPos,GuiWinX,GuiWinY,,,ahk_id %GuiWinHwnd%
	OnTopMerker:=OnTop
	OnTop:=0
	gosub OnTopFestigen
	InputBox,Edit3,Container,Bitte geben Sie die Zeilen-`nnummer des zu aktivierenden Containers ein!,,200,154,GuiWinX,GuiWinY,,,1
	if ErrorLevel
		return
	OnTop:=OnTopMerker
	gosub OnTopFestigen
	If Edit3 is Integer
	{
		gosub Edit3Festigen
		sleep 20
		IfExist % FuehrendeSterneEntfernen(Edit8)
		{
			if(substr(Edit8,-3,4)=".lnk")
				FileGetShortcut, % FuehrendeSterneEntfernen(Edit8) , SkriptDataPath
			else
				SkriptDataPath:=Edit8
			gosub KontainerAnzeigen
			sleep 20
			gosub Button1OhneMausPos
			Sleep 20
			Edit3:=1
			gosub Edit3Festigen
		}
	}
}
sleep 50
gosub Button1OhneMausPos
gosub StartPfadAenderung
return
; Menu, ContainerMenue, 	Add, Letzten oeffnen	`tF4	, LetzterContainer  
LetzterContainer:
SkriptDataPath:=LetzterSkriptDataPathI
gosub KontainerAnzeigen
gosub StartPfadAenderung
gosub F5
return
ü:
WurzelContainerUebersichtOeffnen:	; gespeicherte ContainerUebsicht oeffnen
SkriptDataPath:=ZackData
gosub KontainerAnzeigen
gosub Button1OhneMausPos
return
; Menu, ContainerMenue, 	Add, &loeschen ...					, ContainerLoeschen  
ContainerLoeschen:
BeschaeftigtAnzeige(1)
FileSelectFolder,bestehenderWurzelName,*%SkriptDataPath%,,Den zu loeschenden Ordner auswaehlen.
IfExist %bestehenderWurzelName%
{
	MsgBox, 262180, Ordner, %bestehenderWurzelName%`n`nmit allem was enthalten ist wirklich loeschen?
	IfMsgBox,yes
	{
		FileRemoveDir,%bestehenderWurzelName%,1
		if ErrorLevel
			MsgBox, 262192, Container löschen, Das Skript konnte den Container`n	%bestehenderWurzelName%`nnicht Löschen. Bitte manuell löschen.
	}
}
gosub StartPfadAenderung
gosub LetzterContainer
BeschaeftigtAnzeige(-1)
return
WurzelContainerAnlegen:
FileSelectFolder,NeuerContainerName,*SkriptDataPath,,Bitte vorzugsweise hier einen neuen Ordner anlegen.
IfNotExist %NeuerContainerName%
{
if (NeuerContainerName<>"")
	FileCreateDir,%NeuerContainerName%
}
else
{
SkriptDataPath:=NeuerContainerName
gosub KontainerAnzeigen
gosub Button1OhneMausPos
gosub NeueWurzelHinzufuegen
}
return
; Menu, ContainerMenue, 	Add, &anlegen ...					, ContainerAnlegen 
ContainerAnlegen:
FileSelectFolder,NeuerContainerName,*%ZackData%\WuCont,,Bitte vorzugsweise hier einen neuen Ordner anlegen.
IfNotExist %NeuerContainerName%
{
if (NeuerContainerName<>"")
	FileCreateDir,%NeuerContainerName%
}
else
{
SkriptDataPath:=NeuerContainerName
gosub KontainerAnzeigen
gosub Button1OhneMausPos
gosub NeueWurzelHinzufuegen
}
return
WurzelContainerErzeugenAnzeigen:
FileSelectFolder,NeuerContainerName,*%ZackData%\WuCont,,Bitte vorzugsweise hier einen neuen Ordner anlegen.
IfNotExist %NeuerContainerName%
{
if (NeuerContainerName<>"")
	FileCreateDir,%NeuerContainerName%
}
else
{
SkriptDataPath:=NeuerContainerName
gosub KontainerAnzeigen
gosub Button1OhneMausPos
gosub NeueWurzelHinzufuegen
}
return
; ; 20160330225732 ; Menu, ContainerMenue, 	Add, Uebersicht &erzeugen		, WurzelContainerUebersichtErzeugenAnzeigen  
WurzelContainerUebersichtErzeugenAnzeigen:
SkriptDataPath:=ZackData
gosub KontainerAnzeigen
FileDelete,%SkriptDataPath%\Wurzel??.txt
FileDelete,%SkriptDataPath%\Wurzel?.txt
FileDelete,%SkriptDataPath%\WurzelIndex.txt
Loop, 20
{
; ########################################################## geht sicher noch besser ################################################
	FileDelete,%SkriptDataPath%\%A_Index%_C˸►ProgramData►Zack►WuCont►°-R\*.txt			; OK
	FileDelete,%SkriptDataPath%\%A_Index%_E˸►ProgramData►Zack►WuCont►°-R\*.txt			; OK
	FileDelete,%SkriptDataPath%\%A_Index%_F˸►ProgramData►Zack►WuCont►°-R\*.txt			; OK
	FileDelete,%SkriptDataPath%\%A_Index%_G˸►ProgramData►Zack►WuCont►°-R\*.txt			; OK
	FileDelete,%SkriptDataPath%\%A_Index%_H˸►ProgramData►Zack►WuCont►°-R\*.txt			; OK
	FileDelete,%SkriptDataPath%\%A_Index%_I˸►ProgramData►Zack►WuCont►°-R\*.txt			; OK
; ########################################################## geht sicher noch besser ################################################
}
MsgBox, 8192, verarbeite ..., Bitte einen Moment Geduld ...`n`n... schliessst selbstaendig`n`n`ndanach folgt ein Skript-Neustart., 3
NeueWurzel:=WurzelContainer 	"\*-R"			; 	"\*"
gosub NeueWurzelHinzufuegenBeiVorhandenemWurzelName
Reload
sleep 3000
; Scharfschalten nach erfolgter Sicherung
return
; Menu, ContainerMenue,	Add, &Alle loeschen ...				, DelCache
DelCache:
MsgBox, 262436, Cache Loeschen, wollen Sie wirklich`n	%WurzelContainer%`nloeschen?
IfMsgBox Yes
{
	; EnvGet,ComSpec,ComSpec
	MsgBox Das Skript endet hier um alle Recourcen frei zu geben. 
	Run, %ComSpec% /c "RMDIR /S """%WurzelContainer%""""
	goto GuiClose
}
return
; Menu, ContainerMenue,	Add, Uebersicht anzeigen 		, ContainerUebersichtZeigen
ContainerUebersichtZeigen:	; Zeigt ContainerUebersicht an
gosub NormalAnzeige
AlleSkriptDataPath:=
	Loop,Files,%WurzelContainer%\*, D F
	{
		; if(A_LoopFileExt="lnk")
		AlleSkriptDataPath:=AlleSkriptDataPath "`n" A_LoopFileLongPath
		Edit5:=AlleSkriptDataPath
		StringTrimLeft,Edit5,Edit5,1
		GuiControl,1:, %HwndEdit5%, %Edit5%
	}
	If (AlleSkriptDataPath="")
	{
		gosub KontainerAnzeigen
		sleep 2000
		MsgBox, 262180, Kein Container, Kein Container Gefunden!`nSchlage vor Container `n		Start Menu`nanzulegen.
		IfMsgBox, Yes
		{
			; gosub ContainerSkripteUndProgrammeBereitstellen
			; sleep 300
			; gosub SelfActivate
			SkriptDataPath=%WurzelContainer%\Start Menu
			FileCreateDir %SkriptDataPath%
			sleep 300
			gosub KontainerAnzeigen
			WinWaitActive,ahk_exe Dir2Paths.exe,,8
			WinWaitClose,ahk_exe Dir2Paths.exe,,25
			WinWaitActive,ahk_exe Dir2Paths.exe,,6
			WinWaitClose,ahk_exe Dir2Paths.exe,,25
			WinWaitActive,ahk_exe Dir2Paths.exe,,6
			WinWaitClose,ahk_exe Dir2Paths.exe,,25
			; sleep 15000
		}
		sleep 200
		MsgBox, 262180, Kein Haupt-Container, Haupt-Container nicht Gefunden!`nSchlage vor Container `n		Haupt`nanzulegen.
		IfMsgBox, Yes
		{
			gosub ContainerSkripteUndProgrammeBereitstellen
			sleep 300
			gosub SelfActivate
			SkriptDataPath=%WurzelContainer%\Haupt
			FileCreateDir %SkriptDataPath%
			sleep 300
			gosub KontainerAnzeigen
		FuncEinstellungen := {DefaultButton: 1, AbfrageFensterOnTop: 1}
		AntwortButtonNummer:=SubStr(AbfrageFenster(FuncEinstellungen,"Kein Start-Pfad","Kein Start-Pfad Gefunden!`nSchlage vor Start-Pfad anzulegen.`n`n","Start-Pfade von allen Laufwerken anlegen","Start-Pfad manuell eingeben",">>>>spaeter anlegen"),1,1)		; positiv geprueft II
			if(AntwortButtonNummer=1) ; IfMsgBox, Yes	; durch AbfrageFenster() ersetzen
			{
				gosub WurzelVonDateiHinzuFuegen
				gosub KontainerAnzeigen
				sleep 2000
				gosub F5
			}
			else if(AntwortButtonNummer=2) ; IfMsgBox, No
			{
				gosub WurzelHinzuFuegen
				SkriptDataPath=%WurzelContainer%\Haupt
				gosub KontainerAnzeigen
				sleep 2000
				gosub F5
			}
		}
	}
	else If (AlleSkriptDataPath<>"")
	{
	}
	return
; ---------------------------------------
; Start-Pfad	@0294
; ---------------------------------------
; Menu, StartPfadMenue, 	Add, von &Datei einlesen ...	, WurzelVonDateiHinzuFuegen  ; Siehe untere Bemerkungen zu Ctrl+F.
^o:: 	;	Start-Pfad hinzufuegen
StartPfadEinlesen:
WurzelVonDateiHinzuFuegen:
FileSelectFile,AwpfPfad,,%A_AppDataCommon%\Zack\AlleLaufwerke.awpf,Bitte eine Start-Pfad Datei auswaehlen.,Start-Pfade (*.txt;*.awpf)  ; %A_AppDataCommon%\Zack\AlleLaufwerke.awpf
if ErrorLevel
{
	BeschaeftigtAnzeige(-1)
	return
}
WurzelVonBekannterDateiHinzuFuegen:
dummy:=BeschaeftigtAnzeige(1)
{
	NeueWurzel:=AwpfPfad
	gosub StarteDiesesWurzelSkriptOderAlternative
}
gosub StartPfadAenderung
BeschaeftigtAnzeige(-1)
return
; Menu, StartPfadMenue, 	Add, &einlesen ...`tCtrl+O		, WurzelHinzuFuegen  ; Siehe untere Bemerkungen zu Ctrl+F.
WurzelHinzuFuegen:
NeueWurzelHinzufuegen:
If Fehlersuche
	SoundBeep
FileSelectFolder,NeueWurzel,*Desktop,1,Neue Wurzel hinzuladen`nfuer Stringeingabe [Esc] druecken.
If(NeueWurzel="")
	InputBox,NeueWurzel,Stringeingabe,Der neue Start-Pfad kann auch als String eingegeben werden,,400,200,,,,,c:\*
	if ErrorLevel
		return
NeueWurzelHinzufuegenBeiVorhandenemWurzelName:
BeschaeftigtAnzeige(1)
if(InStr(NeueWurzel,"*"))
{
	if not Rekur
	{
		NeueWurzel.="-R"
	}
		gosub StarteDiesesWurzelSkriptOderAlternative
		; run, %A_ScriptDir%\Dir2Pahs.ahk "%NeueWurzel%"
}
else if(NeueWurzel="")
{
	BeschaeftigtAnzeige(-1)
	return
}
else
{
	{
		if(SubStr(NeueWurzel,0,1)="\")
		{
			{
				NeueWurzel:=NeueWurzel "*"
				gosub StarteDiesesWurzelSkriptOderAlternative
			}
				; run, %A_ScriptDir%\Dir2Pahs.ahk "%NeueWurzel%"
		}
		else
		{
			{
				NeueWurzel:=NeueWurzel "\*"
				gosub StarteDiesesWurzelSkriptOderAlternative
			}
		}
	}
}
sleep 1000
gosub StartPfadeUebersicht
gosub StartPfadAenderung
BeschaeftigtAnzeige(-1)
return
StarteDiesesWurzelSkriptOderAlternative:
BeschaeftigtAnzeige(1)
gosub BereiteVorDir2Paths
Dir2PathStartRueck:=IfExistCallEExeOrAhk(A_AppDataCommon "\Zack\Dir2Paths.ahk",SkriptDataPath,NeueWurzel)
If Dir2PathStartRueck
{
	BeschaeftigtAnzeige(-1)
	return
}
		ScriptDirKlammerInhalt:=GetKlammerInhalt(A_ScriptName)
		if(StrLen(ScriptDirKlammerInhalt))
		RunAlternative:=RunOtherAhkScript(A_AppDataCommon "\Zack\Dir2Paths.ahk",SkriptDataPath,NeueWurzel)		;  %A_AppDataCommon%\Dir2Paths.ahk
		if ZackZackOrdnerLogErstellen
			ThreadUeberwachungLog(A_LineNumber-1,A_ThisHotkey,A_ThisLabel,A_ThisFunc,A_ThisMenu,A_ThisMenuItem,A_ThisMenuItemPos)
		If (RunAlternative=0)
		{
			BeschaeftigtAnzeige(-1)
			return
		}
		IfExist %RunAlternative%
		{
			Meldung:=RunOtherAhkScript(RunAlternative,SkriptDataPath,NeueWurzel)
		}
		else
		{
				run, "%A_AppDataCommon%\Zack\Dir2Paths.exe" "%A_AppDataCommon%\Dir2Paths.ahk" "%SkriptDataPath%"  "%NeueWurzel%"
			if ZackZackOrdnerLogErstellen
				ThreadUeberwachungLog(A_LineNumber-1,A_ThisHotkey,A_ThisLabel,A_ThisFunc,A_ThisMenu,A_ThisMenuItem,A_ThisMenuItemPos)
			MsgBox Einlesprogramm %A_AppDataCommon%\Zack\Dir2Paths.ahk nicht gefunden.
			BeschaeftigtAnzeige(-1)
			return
		}
BeschaeftigtAnzeige(-1)
return
WurzelAktualisieren:	; Einzelnen Start-Pfad aktualisieren.
loop, 2
{
	Edit8Sternlos:=FuehrendeSterneEntfernen(Edit8)
	If(InStr(Edit8Sternlos,SkriptDataPath))
	{
		SplitPath,Edit8Sternlos,ThisCacheDateiNanme
		if (ThisCacheDateiNanme="!Fav")
		{
			ThisFafFolderPath:=Edit8Sternlos
			gosub SetThisFafCopy
			gosub GetThisFafCopy
			; MsgBox, 262160, Favoriten, Die Favoriten von irgendwoher Restaurieren`,`nkoennte eine sinnvolle Aktion sein.`nDiese wird aber noch nicht unterstützt.
			return
		}
		StringSplit,ThisWurzelNummer,ThisCacheDateiNanme,_
		FileRead,NeueWurzel,%SkriptDataPath%\Wurzel%ThisWurzelNummer1%.txt
		if Fehlersuche
			MsgBox % NeueWurzel
		if (A_Index=1)
		{
			MsgBox, 262177, Start-Pfad, Start-Pfad`n	%NeueWurzel% `naktualisieren?
			IfMsgBox,Cancel
				return
		}
		break
	}
	else
	{
		WinGetPos,GuiWinX,GuiWinY,,,ahk_id %GuiWinHwnd%
		OnTopMerker:=OnTop
		OnTop:=0
		gosub OnTopFestigen
		gosub StartPfadeUebersicht
		InputBox,Edit3,Start-Pfad,Bitte geben Sie die Zeilen-`nnummer des zu aktualisierenden Start-Pfades ein!,,200,154,GuiWinX,GuiWinY,,,1
		if ErrorLevel
			return
		gosub Edit3Festigen
		OnTop:=OnTopMerker
		gosub OnTopFestigen
		If Edit3 is Integer
		{
			sleep 1500			; Unterprogramm Edit3 ff. zeit lassen vor Loop 2. Durchlauf
		}
		else
			return
	}
}
gosub NeueWurzelHinzufuegenBeiVorhandenemWurzelName
ZuLoeschendeWurzelDotTxt=%SkriptDataPath%\Wurzel%ThisWurzelNummer1%.txt
; gosub WurzelLoeschenBeiVorhandenerWurzelTxt	; loescht die zum Start-Pfad gehoerende Wurzel Datei %ZuLoeschendeWurzelDotTxt% selbst und den darin verlinkten Inhalt des Start-Pfad-Caches. Bei bereits bekanntem Start-Pfad.
gosub StartPfadeUebersicht
return
WurzelnAktualisieren:	; Die StartPfade des Containers %SkriptDataPath% werden neu eingelesen.
gosub AktuelleStartPfade2Awpf
return
WurzelLoeschen:	; loescht die zum Start-Pfad gehoerende Wurzel Datei %ZuLoeschendeWurzelDotTxt% selbst und den darin verlinkten Inhalt des Start-Pfad-Caches. Bei zu erfragendem Start-Pfad.
Rueckfragen:=true
FileSelectFile,ZuLoeschendeWurzelDotTxt,,%SkriptDataPath%,bitte zu entfernende Start-Datei auswaehlen,StartDateien (Wurzel*.txt)
if ErrorLevel
	return
IfNotExist %ZuLoeschendeWurzelDotTxt%
	return
if (not InStr(ZuLoeschendeWurzelDotTxt,SkriptDataPath))
{
	MsgBox in %ZuLoeschendeWurzelDotTxt% ist %SkriptDataPath% nicht enthalten`n`n`nAbbruch
	return
}
WurzelLoeschenBeiVorhandenerWurzelTxt:	; loescht die zum Start-Pfad gehoerende Wurzel Datei %ZuLoeschendeWurzelDotTxt% selbst und den darin verlinkten Inhalt des Start-Pfad-Caches. Bei bereits bekanntem Start-Pfad.
FilesInEigenemOrdner:=false
FileRead,ZuLoeschendeWurzelPath,%ZuLoeschendeWurzelDotTxt%
if(SubStr(ZuLoeschendeWurzelPath,1,1)="+")
{
	StringTrimLeft,ZuLoeschendeWurzelPath,ZuLoeschendeWurzelPath,1
	if(SubStr(ZuLoeschendeWurzelPath,1,1)="+")
	{
		StringTrimLeft,ZuLoeschendeWurzelPath,ZuLoeschendeWurzelPath,1
		FilesInEigenemOrdner:=true
	}
}
Stern=*
SplitPath,ZuLoeschendeWurzelDotTxt,,,,ZuLoeschendeWurzelNameNoExt
StringTrimLeft,ZuLoeschendeWurzelNr,ZuLoeschendeWurzelNameNoExt,6
ThisFilePattern := ZuLoeschendeWurzelPath
	StringReplace,ThisFilePatternSpeicherName,ThisFilePattern,%Stern%,°,All
	StringReplace,ThisFilePatternSpeicherName,ThisFilePatternSpeicherName,:,˸
	StringReplace,ThisFilePatternSpeicherName,ThisFilePatternSpeicherName,%BackSlash%,►,All
	ThisFilePatternSpeicherName=%ZuLoeschendeWurzelNr%_%ThisFilePatternSpeicherName%
	CashPathWNr=%SkriptDataPath%\%ThisFilePatternSpeicherName%				; c:\temp\Zack\WuCont\Haupt\c˸►\AllG\Gegenst
if Rueckfragen
{
	MsgBox, 262436, Loeschbestaetigung, soll der Ordner`n`n	%CashPathWNr%`n`nwirklich geloescht werden?
	IfMsgBox,No
		return
}
	; FileRemoveDir, %CashPathWNr% , 1
	Run, %ComSpec% /c "RMDIR /S """%CashPathWNr%""""
	ErrorLevelDir:=ErrorLevel
	FileDelete, %ZuLoeschendeWurzelDotTxt%
	WuErrorLevel:=ErrorLevel
	ErrorLevelFiles:=0
	FAnzeige:=
	if FilesInEigenemOrdner
	{
		Run, %ComSpec% /c "RMDIR /S """%CashPathWNr%F""""
		; FileRemoveDir, %CashPathWNr%F , 1
		ErrorLevelFiles:=ErrorLevel
		FAnzeige:="[F]"
	}
	if (ErrorLevelDir+ErrorLevelFiles+WuErrorLevel)
	{
		MsgBox, konnte nicht alles in `n`n	%CashPathWNr%%FAnzeige%`n`n Loeschen,`neventuell ist eine Datei geoeffnet?!`nbitte manuell loeschen oder alles schliessen und nochmals versuchen.
	}
	else
	{
		gosub StartPfadeUebersicht
		sleep 5000
		gosub StartPfadAenderung
		return
	}
return			
StartPfadeUebersicht:
gosub NormalAnzeige
DieseStartPfadeUebersicht:=
Edit3:=1
gosub Edit3Festigen
Loop,Files,%SkriptDataPath%\*, D
{
	DieseStartPfadeUebersicht:=DieseStartPfadeUebersicht "`r`n" A_LoopFileLongPath
}
StringTrimLeft,DieseStartPfadeUebersicht,DieseStartPfadeUebersicht,2
Edit5:=DieseStartPfadeUebersicht
gosub Edit5Festigen
Return
; ---------------------------------------
; Favoriten	@0295
; ---------------------------------------
; Menu, FavMenue, 		Add, &speichern ...					, FavoritSpeichern
FavoritSpeichern:
MultiFileInhalt:=TextDir2MultiFileInhalt(SkriptDataPath "\!Fav","txt")
FileSelectFile,MultiFilePath,S,% A_MyDocuments "\" NameSkriptDataPath A_Now ".txt",FavoritenSicherung,FavoritenDateien(*.txt)
if (MultiFilePath="")
	return
SplitPath,MultiFilePath,,,MultiFilePathExt
if(MultiFilePathExt="")
	MultiFilePath.=".txt"
IfExist %MultiFilePath%
{
	MsgBox, 262196, Ueberschreiben, FavoritenSicherung ueberschreiben
	IfMsgBox,Yes
	{
		FileDelete,%MultiFilePath%
	}
	else
		return
}
FileAppend,%MultiFileInhalt%,%MultiFilePath%,utf-16
; gosub SetThisFafCopy
return
; Menu, FavMenue, 		Add, &oeffnen (restaurieren) ...	, FavoritOeffnen
FavoritOeffnen:
FileSelectFile,MultiFilePath,,% A_MyDocuments,FavoritenSicherung,FavoritenDateien(*.txt)
if (MultiFilePath="")
	return
MultiFileInhalt2TextDir(MultiFilePath,SkriptDataPath "\!Fav")
; gosub GetThisFafCopy
return
; Menu, FavMenue, 		Add, &plus *					, PlusStern
PlusStern:
SetFavorit(Edit8,+1,"",FavoritenDirPath,1)
return
; Menu, FavMenue, 		Add, &minus *					, MinusStern
MinusStern:
SetFavorit(Edit8,-1,"",FavoritenDirPath,1)
return
EintragOhneStern:
fehlersuche:=true
SetFavorit(FuehrendeSterneEntfernen(Edit8),"","BehaltePfad",FavoritenDirPath,1)
fehlersuche:=false
return
SetAutoFavorit(PfadMitSternen,OrdnerNeuAnlage,FavoritenDirPath,AutoFavorit)
{
	BeschaeftigtAnzeige(1)
	global Edit8
	; if OrdnerNeuAnlage					; 0 oder 1
	if((StrLen(Edit8)-StrLen(FuehrendeSterneEntfernen(Edit8))) = AutoFavorit)
		SetFavorit(PfadMitSternen,1,"BehaltePfad",FavoritenDirPath,AutoFavorit)
	else if((StrLen(Edit8)-StrLen(FuehrendeSterneEntfernen(Edit8))) < AutoFavorit)
		SetFavorit(PfadMitSternen,1,"BehaltePfad",FavoritenDirPath,AutoFavorit)
	BeschaeftigtAnzeige(-1)
	return
}
; Menu, FavMenue, 		Add, Sternlose loeschen			, SternLoseFavoritenLoeschen
SternLoseFavoritenLoeschen:
; MsgBox %FavoritenDirPath% drinn
if(FavoritenDirPath="")
	return
Loop,%FavoritenDirPath%\*.txt
{
	; MsgBox %A_LoopFileFullPath% drinn 2
	Name:=A_LoopFileName
	FileRead,DieserInhalt,%A_LoopFileFullPath%
	Zeilennummer:=1
	StringTrimLeft,DieserInhalt,DieserInhalt,2
	StringSplit, Zeile,DieserInhalt,`n,`r
	Loop % Zeile0
	{
		if(FuehrendeSterneAnzahl(Zeile%A_Index%)=0)
		{
			SetFavorit(Zeile%A_Index%,-1,"",FavoritenDirPath,AutoFavorit)
		}
	}
}
return
; Menu, FavMenue, 		Add, &AutoFavorit=%AutoFavorit%	, AutoFavoritEingeben
AutoFavoritEingeben:
AutoFavoritVorher:=AutoFavorit
InputBox,AutoFavorit,AutoFavorit,bis zu wieviele Sterne sollen bei Benutzung automatisch Sterne verteilt werden?`n(0 = AutoFavorit deaktiviert),,,,,,,,%AutoFavorit%
if ErrorLevel
	AutoFavorit:=AutoFavoritVorher
AutoFavoritAnzeigen:
if AutoFavorit is not Integer
	AutoFavorit:=AutoFavoritVorher
if (AutoFavorit<-1)
	AutoFavorit:=-1
; Menu, FavMenue, 		Add, &AutoFavorit=%AutoFavorit%	, AutoFavoritEingeben
if (AutoFavoritVorher<>AutoFavorit)
Menu, FavMenue, Rename, &AutoFavorit=%AutoFavoritVorher%,&AutoFavorit=%AutoFavorit%
return
FileCreateDirAndAutoFav(NewDir,Meldungen=1)
{
	global Edit8,AutoFavorit,Fehlersuche,FavoritenDirPath
	IfExist %NewDir%
		return
	IfExist % FuehrendeSterneEntfernen(NewDir)
		return
	else
	{
		NewDirOhneStern:=FuehrendeSterneEntfernen(NewDir)
		if(AutoFavorit=0 and (StrLen(NewDir)>StrLen(NewDirOhneStern) or StrLen(NewDir)=StrLen(NewDirOhneStern)))
		{
			if(NewDir=FuehrendeSterneEntfernen(Edit8))
			{
				Edit8OhneStern:=FuehrendeSterneEntfernen(Edit8)
				Edit8Vorher:=Edit8
				Edit8:=Edit8OhneStern
				; gosub SetAutoFavorit
				; Edit8:=Edit8Vorher
			}
			else
			{
				Edit8Vorher:=Edit8
				Edit8:=NewDirOhneStern
				; gosub SetAutoFavorit
				; Edit8:=Edit8Vorher
			}				
		}
		FileCreateDir, %NewDirOhneStern%
		If Fehlersuche
			MsgBox %A_LineNumber% FileCreateDir, %NewDirOhneStern%
		if ErrorLevel
		{
			if Meldungen
				MsgBox, 262176, Fehler, Konnte den Ordner `n`n%NewDirOhneStern%`n`nnicht anlegen.
			return 0
		}
		else
		{
			if Meldungen
				TrayTip Ordner anlegen, Ordner `n`n%NewDirOhneStern%`n`nangelegt!
			IfExist %NewDirOhneStern%
			{
				; gosub SetAutoFavorit
				SetAutoFavorit(Edit8,1,FavoritenDirPath,AutoFavorit)
				Edit8:=Edit8Vorher
				return NewDirOhneStern
			}
		}
	}
	return 0
}
SetAutoFavorit_VorbereitetZumLoeschen:
fehlersuche:=true
if((StrLen(Edit8)-StrLen(FuehrendeSterneEntfernen(Edit8))) < AutoFavorit)
	SetFavorit(FuehrendeSterneEntfernen(Edit8),AutoFavorit,"BehaltePfad",FavoritenDirPath,1)
fehlersuche:=false
return
; Menu, FavMenue, 		Add, &Ordner oeffnen			, FavoritenOrdnerOeffnen
FavoritenOrdnerOeffnen:
FavoritenOrdner:=FuehrendeSterneEntfernen(SkriptDataPath "\!Fav")
IfExist, % FavoritenOrdner
{
	run, explorer.exe /select`,"%FavoritenOrdner%"
	if ZackZackOrdnerLogErstellen
		 ThreadUeberwachungLog(A_LineNumber-1,A_ThisHotkey,A_ThisLabel,A_ThisFunc,A_ThisMenu,A_ThisMenuItem,A_ThisMenuItemPos)
}
return
; Menu, FavMenue, 		Add, Fav-Vorschlag generieren ...	, FavoritenVorschlagErzeuegen
FavoritenVorschlagErzeuegen:
gosub SpezialOrdnerAnlegen
FavoritenVorschlag=
(
https://autohotkey.com/boards/viewtopic.php?f=10&t=15248`r
https://github.com/Grrdi/ZackZackOrdner/archive/master.zip`r
%DriveNamesPfadList%`r
%A_Desktop%`r
%A_DesktopCommon%`r
%A_MyDocuments%`r
%A_Startup%`r
%A_StartupCommon%
%A_AppDataCommon%\Zack\Clsid\Systemsteuerung alle Tasks.{ED7BA470-8E54-465E-825C-99712043E01C}
%A_AppDataCommon%\Zack\Clsid\Drucker.{2227A280-3AEA-1069-A2DE-08002B30309D}
)
MsgBox, 262180, Vorgeschlagene Favoriten,%A_Tab%%A_Tab%%A_Tab%sollen folgende Favoriten`n%FavoritenVorschlag%`n			erzeugt werden?
IfMsgBox,No
	return
Clipboard:=FavoritenVorschlag
gosub PlusSternClipPfade
return
; Menu, FavMenue, 		Add, plus * Clip-Pfade `t#*			, PlusSternClipPfade
; -----> @0210
; Menu, FavMenue, 		Add, minus * Clip-Pfade				, MinusSternClipPfade
MinusSternClipPfade:
Loop,Parse,Clipboard,`n,`r
{
	if(Trim(A_LoopField)<>"")
		SetFavorit(A_LoopField,-1,"",FavoritenDirPath,1)
}
return
; Menu, FavMenue, 		Add, Loeschen * Clip-Pfade			, LoeschenSternClipPfade
LoeschenSternClipPfade:
BeschaeftigtAnzeige(1)
Loop,Parse,Clipboard,`n,`r
{
	if(Trim(A_LoopField)<>"")
		SetFavorit(A_LoopField,-10,"",FavoritenDirPath,1)
}
BeschaeftigtAnzeige(-1)
return
; Menu, FavMenue, 		Add, plus * &manuell ...			, PlusSternManuell
PlusSternManuell:
if (ThisNewFavorit="")
	ThisNewFavorit=Name|*Pfad
InputBox,ThisNewFavorit,New Favorit,Bitte den FaforitenName |* gefolgt von dem Pfad eingeben,,,,,,,,%ThisNewFavorit%
StringSplit,ThisNewFavoritNameUrl,ThisNewFavorit,|,%A_Space%
if (ThisNewFavoritNameUrl0<>2)
{
	MsgBox, 262160, Fehler, Es muss genau ein`n |`nin der Eingabe Enthalten sein!
	return
}
if (ThisNewFavoritNameUrl1="")
{
	MsgBox, 262160, Fehler, Der Name Fehlt!
	return
}
if (ThisNewFavoritNameUrl2="")
{
	MsgBox, 262160, Fehler, der Pfad Fehlt!
	return
}
IfNotExist % FavoritenDirPath
	FileCreateDir, % SkriptDataPath "\!Fav"
If FehlerSuche
	MsgBox %A_LineNumber%	FileAppend`,%ThisNewFavoritNameUrl2%`,%SkriptDataPath%\!Fav\%ThisNewFavoritNameUrl1%.txt`,utf-16
FileAppend,`r`n%ThisNewFavoritNameUrl2%,%SkriptDataPath%\!Fav\%ThisNewFavoritNameUrl1%.txt,utf-16
return
; Menu, FavMenue, 		Add, SuperFavoriten ♥ bearbeiten	, SuperFaVoritenAnlegenBearbeiten
SuperFaVoritenAnlegenBearbeiten:
IfExist %A_AppData%\Zack
{
	IfExist %SuperFavoritenDateiPfad%
	{
		gosub SuperFaVoritenEinfuehrung
		run %SuperFavoritenDateiPfad%
		return
	}
	else
	{
	}
}
; else
{
	{
		IfNotExist %A_AppDataCommon%\Zack\ClsId\Arbeitsplatz Dieser PC.{20d04fe0-3aea-1069-a2d8-08002b30309d}
			gosub SpezialOrdnerAnlegen
		IfExist %A_AppDataCommon%\Zack\ClsId\Arbeitsplatz Dieser PC.{20d04fe0-3aea-1069-a2d8-08002b30309d}
		{
			gosub SuperFaVoritenEinfuehrung
			FileAppend,`r`n%A_AppDataCommon%\Zack\ClsId\Arbeitsplatz Dieser PC.{20d04fe0-3aea-1069-a2d8-08002b30309d},%SuperFavoritenDateiPfad%,utf-16
			if not ErrorLevel
				run %SuperFavoritenDateiPfad%
		}
		else
		{
			gosub RecentFolderLinks
			SuperFavoritenPfadVorschlaege:=RecentZielPfadListe
			; SuperFavoritenPfadVorschlaege=Bitte eine Leerzeile am Anfang stehen lassen.`r`nDiese Erklaerung und die nicht oft benoetigten Pfade unten entfernen.`r`n%SuperFavoritenPfadVorschlaege%
			; SuperFavoritenPfadVorschlaege=`r`n%SuperFavoritenPfadVorschlaege%
			FileAppend,%SuperFavoritenPfadVorschlaege%,%SuperFavoritenDateiPfad%,utf-16
			IfExist %SuperFavoritenDateiPfad%
			{
				; gosub SuperFaVoritenEinfuehrung
				gosub SuperFaVoritenAnlegenBearbeiten
			}
		}
	}
}
if (RecentZielPfadListe<>"")
{
	; MsgBox, 262148, SuperFavoriten-Datei, Um den Aufbau der Datei im Hintergrund zu zeigen`, wurde aus Ihren haeufig benutzten Ordnern eine Muster-Datei erstellt. Unnuetze Pfade wird diese einige enthalten. Diese sollte alle entfernt werden`, sonst wird Ihr Haupt-Menue nach rechts unuebersichtlich! Die Leerzeile oben bitte stehen lassen.`n`nDer Vorgang benötigt einen Neustart`, nach dem Bearbeiten der Datei. D.h.:`nOK erst nach dem Speichern der Datei 
	FuncEinstellungen := {DefaultButton: 1, AbfrageFensterOnTop: 1}
	AbfrageFensterAntwort:=AbfrageFenster(FuncEinstellungen,"SuperFavoriten-Datei","Um den Aufbau der SuperFavoriten-Datei im Hintergrund zu zeigen`,`nwurde aus Ihren haeufig benutzten Ordnern eine Muster-Datei erstellt.`nUnnuetze Pfade wird diese einige enthalten.`nDiese sollten alle entfernt werden`,`nsonst wird Ihr Haupt-Menue nach rechts unuebersichtlich!`nDie Leerzeile oben bitte stehen lassen.`n`nDer Vorgang benötigt einen Neustart`, nach dem Bearbeiten der Datei.","Die Datei wurde gekürzt und abgespeichert",">>>>>>>Ich starte spaeter neu")
	if (SubStr(AbfrageFensterAntwort,1,1)=1)
		Reload
}
return
; ---------------------------------------
; Macro	@0296
; ---------------------------------------
; Menu, MacroMenue, 		Add, &Ordner oeffnen			, StaOrdnerBefehlsDateiPfadOeffnen
StaOrdnerBefehlsDateiPfadOeffnen:
IfNotExist %A_AppData%\Zack\Macro
	FileCreateDir,%A_AppData%\Zack\Macro
run, %A_AppData%\Zack\Macro
if ZackZackOrdnerLogErstellen
	ThreadUeberwachungLog(A_LineNumber-1,A_ThisHotkey,A_ThisLabel,A_ThisFunc,A_ThisMenu,A_ThisMenuItem,A_ThisMenuItemPos)
return
DiesenBefehlsDateiPfadAusfuehren:							; je Zeile ein Befehl in der Datei mit dme Pfad DieserBefehlsDateiPfad
FileRead,BefehlsMacro,%DieserBefehlsDateiPfad%
BefehlsVariableAusfuehren:						; je Zeile ein Befehl in der Variablen BefehlsMacro
Loop,Parse,BefehlsMacro,`n,`r
{
	Datenkopie:=A_LoopField
	gosub TimerEditUebernahme
	sleep 20
}
return
; Menu, MacroMenue, 		Add, &Starten...				, UserSelBefehlsDateiPfadAusfuehren
UserSelBefehlsDateiPfadAusfuehren:
IfNotExist %A_AppData%\Zack\Macro
	FileCreateDir,%A_AppData%\Zack\Macro,
MacroStartListe=
MacroNameListe=
breakbreak:=false
MacroPlatzIndex:=1
Loop 999
{
	; IfExist, %A_AppData%\Zack\Macro\%A_Index%_*.txt
	MacroPlatz%MacroPlatzIndex%:=false
	Loop,%A_AppData%\Zack\Macro\%MacroPlatzIndex%_*.txt
	{
		MacroPlatz%MacroPlatzIndex%:=A_LoopFileFullPath
		MacroName%MacroPlatzIndex%:=A_LoopFileName
		MacroNameListe.=A_LoopFileName "`r`n"
		++MacroPlatzIndex
		break
	}
	if(MacroPlatzIndex>7)
		break
	if (MacroPlatz%MacroPlatzIndex%=0)
		break
}
--MacroPlatzIndex
Loop,%A_AppData%\Zack\Macro\*.txt
{
	if(Substr(A_LoopFileName,2,1)="_")
	{
		Char1LoopFileName:=Substr(A_LoopFileName,1,1)
		if Char1LoopFileName is Integer
			continue
	}
	if(MacroPlatzIndex>6)
		break
	++MacroPlatzIndex
	MacroPlatz%MacroPlatzIndex%:=A_LoopFileFullPath
	MacroName%MacroPlatzIndex%:=A_LoopFileName
	MacroNameListe.=MacroPlatzIndex "_" A_LoopFileName "`r`n"
}
FuncEinstellungen:=
FuncEinstellungen:={}
Loop % MacroPlatzIndex
{
	ButtonNr:="ButtonText" A_Index
	MacroName:="M" A_Index
	; MacroName:=MacroName%A_Index%
	; FuncEinstellungen:={(ButtonNr):MacroName}
	FuncEinstellungen.Insert(ButtonNr,MacroName)
}
++MacroPlatzIndex
	MacroOrdner:="ButtonText" MacroPlatzIndex
	MacroOrdnerIndex:=MacroPlatzIndex
	MacroName:=">>>>>Macro-Ordner"
	FuncEinstellungen.Insert(MacroOrdner,MacroName)
++MacroPlatzIndex
	ButtonNr:="ButtonText" MacroPlatzIndex
	MacroName:=">>>>>>>>>>abbrechen"
	FuncEinstellungen.Insert(ButtonNr,MacroName)
++MacroPlatzIndex
	ButtonNr:="DisableMainWindow" 
	MacroName:=1
	FuncEinstellungen.Insert(ButtonNr,MacroName)
++MacroPlatzIndex
	ButtonNr:="AbfrageFensterOnTop" 
	MacroName:=1
	FuncEinstellungen.Insert(ButtonNr,MacroName)
AbfrageFensterAntwort:=AbfrageFenster(FuncEinstellungen,"Macro starten",MacroNameListe)
AbfrageFensterAntwortButonNr:=SubStr(AbfrageFensterAntwort,1,1)
; AbfrageFensterAntwortButonNr:=7
if(AbfrageFensterAntwortButonNr<MacroOrdnerIndex)
	DieserBefehlsDateiPfad:=MacroPlatz%AbfrageFensterAntwortButonNr%
else if (AbfrageFensterAntwortButonNr=MacroOrdnerIndex)
{
	FileSelectFile,DieserBefehlsDateiPfad,,%A_AppData%\Zack\Macro,bitte Macro auswaehlen,Macros (*.txt;*.*)
	if ErrorLevel
		return
	If (DieserBefehlsDateiPfad="")
		return
}
else
	return
gosub DiesenBefehlsDateiPfadAusfuehren
return
; Menu, MacroMenue, 		Add, &Muster-Dateien ...		, MusterDateienErzeugen
MusterDateienErzeugen:
MacroDir=%A_AppData%\Zack\Macro
IfNotExist %MacroDir%
	FileCreateDir, %MacroDir%
MacroMusterDateiAnzahl:=11
MacroMusterDateiName1=SchreibtWeltInEdit3.txt
MacroMusterDateiName2=Zeige Control-Infos vom aktiven Fenster an.txt
MacroMusterDateiName3=Zeige Edit Zuordnung.txt
MacroMusterDateiName4=SortierungKurzOben.txt
MacroMusterDateiName5=SortierungNachOrdnerNameOhnePfad.txt
MacroMusterDateiName6=DemoDynamischeVarUndFunktion.txt
MacroMusterDateiName7=ErsetzeInEdit5-e-durch-EeEeEe.txt
MacroMusterDateiName8=EntferneOben23Zeilen.txt
MacroMusterDateiName9=WirksameStartPfadeInEdit10Anzeigen.txt
MacroMusterDateiName10=ZeigeEdit5AlsHtmlTabelle.txt
MacroMusterDateiName11=SaveE8E5Demo.txt
MacroMusterDateiInhalt1=
(
Welt
)
MacroMusterDateiInhalt2=
(
GetAWinInfosHtml
)
MacroMusterDateiInhalt3=
(
e7Edit7
e4Edit4
e3Edit3
e2Edit2
e1Edit1
e6Edit6
e5Edit5
e8Edit8
EDit10=Edit10
)
MacroMusterDateiInhalt4=
(
Edit6Merker=`%Edit6`%
BefehlsMacro=§§FunktionIfGosub§Edit1§"StringRechtsInLinks"§"("§"F5"`%CrLf`%Edit6GleichGefundenePfade
§§FunktionLoop§"BefehlsVariableAusfuehren"§"12"§
SortLen
Edit6=`%Edit6Merker`%
Edit6Festigen
)
MacroMusterDateiInhalt5=
(
SortBS
)
MacroMusterDateiInhalt6=
(
LastChar=e
Name=All
§§HalloWelt§Nam`%LastChar`%
)
MacroMusterDateiInhalt7=
(
§Edit5§ThisStringReplace§Edit5§"e"§"EeEeEe"§"all"
Edit5Festigen
)
MacroMusterDateiInhalt8=
(
AnzahlZeichenLinksWeg=0
AnzahlZeilenObenWeg=23
§Edit5§Entferne§Edit5§AnzahlZeichenLinksWeg§AnzahlZeilenObenWeg
Edit5Festigen
)
MacroMusterDateiInhalt9=
(
Edit10=Start-Pfade: "Dieser Text sollte verschwinden."
)
MacroMusterDateiInhalt10=
(
Edit8=http://randori-stuttgart.de
IeAnz=1
IeControl
ZeigePfadlisteImBrowser
)
MacroMusterDateiInhalt11=
(
§§SaveE8E5
§§HalloWelt§"im Hintergrund kann geaendert werden. Dann OK"
Edit5:=Edit5Last
Edit5Festigen
§Edit8§SaveE8E5§"Get"
Edit8Festigen
)
MusterMacroDateiPfade=
Loop, % MacroMusterDateiAnzahl
{
	FileDelete, % MacroDir "\" MacroMusterDateiName%A_Index%
	if ZackZackOrdnerLogErstellen
		ThreadUeberwachungLog(A_LineNumber-1,A_ThisHotkey,A_ThisLabel,A_ThisFunc,A_ThisMenu,A_ThisMenuItem,A_ThisMenuItemPos)
	FileAppend, % MacroMusterDateiInhalt%A_Index%, % MacroDir "\" MacroMusterDateiName%A_Index%,utf-16
	if ZackZackOrdnerLogErstellen
		ThreadUeberwachungLog(A_LineNumber-1,A_ThisHotkey,A_ThisLabel,A_ThisFunc,A_ThisMenu,A_ThisMenuItem,A_ThisMenuItemPos)
	MusterMacroDateiPfade:=MusterMacroDateiPfade MacroDir "\" MacroMusterDateiName%A_Index% "`n"
}
gosub StaOrdnerBefehlsDateiPfadOeffnen 
sleep 3000
MsgBox % "Folgende Dateien wurden Erzeugt: "  MusterMacroDateiPfade
return
; Menu, MacroMenue, 		Add, &Befehls-Liste				, ListLabels
ListLabels:
LL:
AutoTrim, Off
LabelList:=
if(not IstKompilliert())
{
FileRead,ScriptQuellcode,%A_ScriptFullPath%
Loop,Parse,ScriptQuellcode,`n,`r
{
	if(InStr(A_LoopField,":") and not InStr(A_LoopField,"`="))
	{
		StringSplit,ScriptQuellLabelZeile,A_LoopField,:
		If(InStr(ScriptQuellLabelZeile1,A_Space))
			continue
		If(InStr(A_LoopField,"GuiControl"))
			continue
		If(InStr(A_LoopField,"Gui,1"))
			continue
		If(InStr(ScriptQuellLabelZeile1,A_Tab))
			continue
		if(SubStr(A_LoopField,StrLen(ScriptQuellLabelZeile1)+2,1)=":")
		{
			PlusDop=`::
			if(ScriptQuellLabelZeile0 > 3)
				continue
		}
		else
		{
			PlusDop=`:
			if(ScriptQuellLabelZeile0 > 2)
				continue
		}
		LabelList:=LabelList "`r`n" A_LoopField
	}
}
StringTrimLeft,LabelList,LabelList,2
sort,LabelList,U
}
VorLabelList=
(
Befehle koennen derzeit auf folgende Arten in das Programm gelangen:
 - manuelle Tastatureingabe
 - Macro-Datei
 - Macro Variable
Zu den untenstehenden automatisch generierten Befehlen kommen noch folgende hinzu:
nach der Startsequez 2 maliges druecken der Caps-Lock-Taste wird die weitere Eingabe
bis zur eingabe der Schussequenz Tabulator-Taste vom Proramm verarbeitet:
 - wenn keine nachfolgende Befehle eingegeben werden wird einfach ins suchfeld weitergeleitet.
 - # eine einzelne Ziffer wird als Wunsch interpraetiert das oberste Ausgabefeld zu bestimmen.
 - #* eine Einzelziffer gefogt von Freitext schreibt direkt in das durch # bestimmte Edit-Feld
 - b# b gefolgt von einer Einzelziffer, ist wie wenn der betreffende Button mit der Maus gewahlt wuerde.
 - c?# Haken aendern via Tastatur, nur fuer Experten
 - e#* gleich wie #* mit vorangestelltem e
 Dito etwas grafischer:
 ----------------------------------------------------------------------------------------------------------------------------
; #		->	Edit3						[1:9]								Die # landet in der Nummern-Auswahl (Edit4)
; #*		wie		e#*
; b#	->	Buttonclick					b[1:5]								Der Button mit der Nummer # wird gedrueckt
; c?#	->	Checkbox					c[a|b|c|d|e|f|g|h|j|k]][0:9][0||1]	Die Checkbox mit der ID aus einem Buchstabe und # wird gehakt 1 oder enthkt 0
; e#*	->	Edit	* = Freritext		e[1:9]*								Das Edit mit der Nummer # wird mit dem Text * befuellt.
; andere->	Edit2						*{rest}								Die Suche also Edit2 wird mit * befuellt (* ohne diejenigen die drueber herausgefischt wurden)
BeispielZenario: Sie sind in einem anderen Programm taetig und benoetigen einen Ordner.
Caps Caps a Tab				macht das Zack-Fenster sichtbar. Sie wissen noch im Ordnername kommt Kind vor
Caps Caps kind Tab			es werden ale Ordner die *kind* enthalten angezeigt. Der an 7. Stelle angezeigte Ordner sei der gewunschte
Caps Caps 7 Tab				nun koennen Sie viele weitere Aktionen damit duchfuehren.
Caps Caps b4 Tab			Beispielhaft sei das oeffnen mit dem Explorer gezeigt.
Hinzu kommen:
 - VariablenZuweisungen mit = und mit := 		wie sie auch in den .awpf Dateien verwendet werden koennen.
 - Funkionsaufrufe mit §VarFuersErgebnis§FunktionsName§UbergabeVar1$Uebergabevar2...
 Eine Liste der Funtionen gibt es derzeit noch nicht, die Funktionen koennen jedoch im Quelltext an der Form
 Funktionsname(mit oder ohne kommagetrennte Uebergabevariablen)
 {
	Unterprogrammzeilen
	return MitOderOhneRueckgabeVar
 }
 erkannt werden.
Unten ist eine Automatisch aus dem Quelltext generierte Befehls-Liste fuer Experten.
Diese via Tastatur zu starten, birgt Risiken, bei denen der Schaden nicht zwangsweise auf Programmeigene Inhalte beschraenkt bleiben muss.
P.S. in der Folgenden Befehls-Liste wurden urspruenglich technisch bedingt Kommas durch doppelte Leerzeichen ersetzt, bzw. mit Punkten umgangen. Eventuell sind solche Passagen noch vorhanden.
Legende der Liste unten:
;	auskommentiert
...::	HotKey (... kann auch als Befehl vewendet werden)
...:	Label (... entspricht dem Befehlsname)
#	1. Zeichen ist die Win Taste
^	1. Zeichen ist die Strg Alias Ctrl Taste
!	1. Zeichen ist die Alt Taste
+	1. Zeichen ist die Shift Alias Umsch Taste
z.B.
##::	ist der HotKey [Win]+[#] 
geplant, mit auflisten der Funktionen:
...(..)	Funktionen	(OutVar§...§.. entspricht dem Aufrufbefehl)
################################### Befehlsliste #######################################
)
StringReplace,VorLabelList,VorLabelList,`n,`r`n,All
LabelList:=VorLabelList "`r`n"   LabelList
FileDelete,%A_AppDataCommon%\LabelList.txt
FileAppend,%LabelList%,%A_AppDataCommon%\LabelList.txt,utf-16
if ZackZackOrdnerLogErstellen
	ThreadUeberwachungLog(A_LineNumber-1,A_ThisHotkey,A_ThisLabel,A_ThisFunc,A_ThisMenu,A_ThisMenuItem,A_ThisMenuItemPos)
run, notepad.exe "%A_AppDataCommon%\LabelList.txt"
if ZackZackOrdnerLogErstellen
	ThreadUeberwachungLog(A_LineNumber-1,A_ThisHotkey,A_ThisLabel,A_ThisFunc,A_ThisMenu,A_ThisMenuItem,A_ThisMenuItemPos)
AutoTrim, On
return
Farbe:
GuiControl,1: +BackgroundFF9977, %HwndEdit1%
GuiControl,1: +BackgroundFF9977, %HwndButton1%
return
; ---------------------------------------
; Optionen	@0297
; ---------------------------------------
; Menu, OptionsMenue, 	Add, &Sitzungs-Einst. speichern				, SitzungsEinstellungenMerken
SDE:
SitzungsEinstellungenMerken:
VarEinstellungsVarList=
(
GuiNachHochfahrenMinimieren
MausGuenstigPositionieren
GuiAnzeigeFortgeschritten
SkriptDataPath
AktualisierungAufButton1
Edit2
Edit3
Edit4
Edit6
Edit7
Edit10
AuAb
ExpSel
OnTop
RegEx
AuAb
BsAn
SuFi
)
AllVar=
VarList=
FileDelete,%A_AppData%\Zack\Einstellungen.txt
Loop,Parse,VarEinstellungsVarList,`n,`r
{
	AllVar:=AllVar "`r`n" A_LoopField "=" %A_LoopField%
}
NachBefehle=
(
AuswahlGuiAnzeigeFortgeschritten
KontainerAnzeigen
Button1
Edit10
)
ThisAbarbeiteiten=
(
%AllVar%`r`n
%NachBefehle%
)
Fileappend, %ThisAbarbeiteiten%, %A_AppData%\Zack\Einstellungen.txt,utf-16
if ZackZackOrdnerLogErstellen
	ThreadUeberwachungLog(A_LineNumber-1,A_ThisHotkey,A_ThisLabel,A_ThisFunc,A_ThisMenu,A_ThisMenuItem,A_ThisMenuItemPos)
return
; Menu, OptionsMenue, 	Add, &Sitzungs-Einst. einlesen				, SitzungsEinstellungenEinlesen
SitzungsEinstellungenEinlesen:
FileRead,BefehlsMacro,%A_AppData%\Zack\Einstellungen.txt
gosub BefehlsVariableAusfuehren	
return
SitzungsEinstellungenBeiScriptStartEinlesen:
IfExist %A_AppData%\Zack\AutoEinstellungen.txt
	FileRead,BefehlsMacro,%A_AppData%\Zack\AutoEinstellungen.txt
gosub BefehlsVariableAusfuehren	
return
; Menu, OptionsMenue, 	Add, &Sitzungs-Einst. bearbeiten			, SitzungsEinstellungenBearbeiten
SitzungsEinstellungenBearbeiten:
IfExist  %A_AppData%\Zack\Einstellungen.txt
	run notepad.exe "%A_AppData%\Zack\Einstellungen.txt"
return
; Menu, OptionsMenue, 	Add, Suche &ruecksetzen			, ResetAllNocontainer
ResetAllNocontainer:
If(SkriptDataPath=SuperContainer)
{
	gosub F5
	Sleep 200
	Edit3=000
	gosub Edit3Festigen
	gosub Edit3
}
Edit1:=Edit1Default
gosub Edit1Festigen
Edit2:=Edit2Default
gosub Edit2Festigen
Edit3:=Edit3Default
gosub Edit3Festigen
Edit4:=Edit4Default
gosub Edit4Festigen
Edit5:=Edit5Default
gosub Edit5Festigen
Edit6:=Edit6Default
gosub Edit6Festigen
Edit7:=Edit7Default
gosub Edit7Festigen
Edit9:=Edit9Default
gosub Edit9Festigen
if(SubStr(Edit10,1,13)="Start-Pfade: ")
{
	Edit10:="Start-Pfade: Dieser Text sollte verschwinden."
	gosub Edit10Festigen
}
else
	Edit10:=Edit10Default
gosub Edit10Festigen
; OnTop:=OnTopDefault
; gosub OnTopFestigen
GuiNachHochfahrenMinimieren:=GuiNachHochfahrenMinimierenDefault
IeAnz:=IeAnzDefault
gosub IeAnzFestigen
Rekur:=RekurDefault		; 	g-Name weicht von v-Name ab
gosub RekurFestigen
Min:=MinDefault
gosub MinFestigen
Akt:=AktDefault
gosub AktFestigen
AuAb:=AuAbDefault
gosub AuAbFestigen
RegEx:=RegExDefault
gosub RegExFestigen
SuFi:=SuFiDefault
gosub SuFiFestigen
ExpSel:=ExpSelDefault
gosub ExpSelFestigen
SeEn:=SeEnDefault
gosub SeEnFestigen
SrLi:=SrLiDefault
gosub SrLiFestigen
BsAn:=BsAnDefault
gosub BsAnFestigen
WoAn:=WoAnDefault
gosub WoAnFestigen
WiWa:=WiWaDefault
beschaeftigt:=beschaeftigtDefault
gosub beschaeftigtFestigen
return
; Menu, OptionsMenue, 	Add, ZZO Neueste Version holen				, ZZOAktualisieren
ZZOAktualisieren:
IfExist %A_ScriptDir%\AktualisiereZackZackOrdner.ahk
	Run %A_ScriptDir%\AktualisiereZackZackOrdner.ahk
gosub GuiClose
return
; Menu, OptionsMenue, 	Add, &Einstellungen ...				, Einstellungen
Einstellungen:
MsgBox, 262148, Beginner / Fortgeschrittener, Moechten Sie das ZackZackOrdner-Fenster in der Beginner-Ansicht angezeigt bekommen?
IfMsgBox,No
{
	GuiAnzeigeFortgeschritten:=true
	gosub GuiFortegeschrittenenerModus
}
else
{
	GuiAnzeigeFortgeschritten:=false
	gosub GuiAnfaengerModus
}
return
; ---------------------------------------
; ?	@0298
; ---------------------------------------
; Menu, Hilfsmenü, 		Add, &Verlangsamte Demo			, LangsamDemoToggle
LangsamDemoToggle:
if LangsamDemo
	LangsamDemo:=false
else
{
	MsgBox, 8192, Such-Gimmik, Stark verlangsamte Suche mit ZwischenErgebnisAnzeige `n`nEin`n`nnochmal:	wieder aus.`n`n`nAchtung: Bei kurzen Suchbegriffen und einer hohen  (Schleifen-Iterations)-Abbr-(uch-Zahl) dauert es ewig. `nBetaetigen des Schliess X oben rechts`, sollte jedoch immer`, also auch mitten in der Suchzusammenstellung  funktionieren. Auch das Ausschalten des Demo-Modusses wird mitten in der Suchzusammenstellung unterstuetzt., 60
	LangsamDemo:=true
}
return
; Menu, Hilfsmenü, 		Add, Inf&o						, Info
; ------> @0800
; Menu, Hilfsmenü, 		Add, &Hilfe						, Hilfe
; ------> @0800
; < / ###########################################  Haupt-Menue  ############################################ >
; < #####################################  Eingbundene Unterprogramme  ###################################### >	@0310
; < / #####################################  Eingbundene Unterprogramme  ###################################### >
; < ##################################### Unterprogramme fuer Macros  ###################################### >	@0350
; < / ##################################### Unterprogramme fuer Macros  ###################################### >
; < ###########################################  Unterprogramme  ############################################ >	@0300
; < / ###########################################  Unterprogramme  ############################################ >
; < ######################################   Funktionen  ######################################### >	@0400
; < ################################  Eingbundene Funktionen  #################################### >	@0410
TextDir2MultiFileInhalt(DirPath,OnlyExt="*")
{
	BeschaeftigtAnzeige(1)
	Loop,%DirPath%\*.%OnlyExt%
	{
		FileRead,Inhalt,% A_LoopFileFullPath
		Diff1:=A_LoopFileSize-StrLen(Inhalt)
		Diff2:=A_LoopFileSize-StrLen(Inhalt)*2
		if(Diff1*Diff1<5 or Diff2*Diff2<5)	; Pruefen ob TextDatei
		{
			MultiFileInhalt.=A_LoopFileName "`f" Inhalt  "`f" 
		}
	}
	StringTrimRight,MultiFileInhalt,MultiFileInhalt,1
	BeschaeftigtAnzeige(-1)
	return MultiFileInhalt	
}
MultiFileInhalt2TextDir(MultiFilePath,DirPath)
{
	BeschaeftigtAnzeige(1)
	IfNotExist %DirPath%
		FileCreateDir %DirPath%
	FileRead,MultiFileInhalt,%MultiFilePath%
	StringSplit,Teil,MultiFileInhalt,`f
	Index:=0
	ErzeugeFehler:=0
	Loop, % Teil0/2
	{
		++Index
		++Index
		IndexMinus:=Index-1
		if(Teil%IndexMinus%="")
			MsgBox % A_LineNumber "	unerwartet " Teil%Index%
		FileAppend, % Teil%Index%, % DirPath "\" Teil%IndexMinus%,utf-16
		if ErrorLevel
		{
			TrayTip,Fehler, %  DirPath "\" Teil%IndexMinus% "`nkonnte nicht angelegt werden"
			++ErzeugeFehler
		}
	}
	BeschaeftigtAnzeige(-1)
	return ErzeugeFehler
}
IstKompilliert(OhneWarnMeldung="")
{
	static OhneWarnMeldungStatic
	if(OhneWarnMeldungStatic<>"")
		OhneWarnMeldung:=OhneWarnMeldungStatic
	if(OhneWarnMeldung="")
		OhneWarnMeldung:=false
	if OhneWarnMeldung
	{
		; ToolTip % A_IsCompiled
		if (A_IsCompiled=1)
			return 1
	}
	else
	{
		if (A_IsCompiled=1)
		{
			AbfrageFensterAntwort:=AbfrageFenster(,"Fehler","eine hier benoetigte Funktionalitaet ist in der hier verwendeten kompillierten Version von ZZO nicht verfuegbar","Weiter","Weiter Meldung nicht mehr zeigen","ZZO beenden")
			if(SubStr(AbfrageFensterAntwort,1,1)=1)
				return 1
			else if(SubStr(AbfrageFensterAntwort,1,1)=2)
			{
				OhneWarnMeldungStatic:=true
				return 1
			}
			else if(SubStr(AbfrageFensterAntwort,1,1)=3)
			{
				ExitApp
			}
		}
	}
	return 0
}
; < / ##############################  Eingbundene Funktionen  #################################### >
; < ################################ Funktionen fuer Macros  #################################### >	@0450
Csv2Html(Csv,FeldTrenner=";")
{
	; Csv Variable mit Csv-Datei-Inhalt
	; Aufrufbeispiel
	; Html:=Csv2Html(Csv)
	IfExist %Csv%		; falls der Pfad zur Csv-Datei uebergeben wurde
		FileRead,Csv,%Csv%
	HochKommas="
	StringReplace,Csv,Csv,%HochKommas%,,all
	StringReplace,Csv,Csv,`r,,all
	StringReplace,Csv,Csv,`n,</td></tr>`r`n<tr><td>,all		
	StringReplace,Html,Csv,%FeldTrenner%,</td><td>,all
	StringTrimRight,Html,Html,20
	Vor=<table border="1" width="100`%">`r`n<tr><td>
	Nach=</td></tr>`r`n</table>
	return Vor Html Nach
}
; < / ################################ Funktionen fuer Macros  #################################### >
; < / ######################################   Funktionen  ######################################### >
; < ################################ Sonstige Menues Labels  #################################### >	@0500
; < ###################################### Tray Menue  ########################################## >	@0510
; < / ##################################### Tray Menue  ######################################### >
; < #################################### Clipboard Menue  ######################################## >	@0520
ClipboardMenuHandler1:
Clipboard:=Clipboard
return
ClipboardMenuHandler2:
ClipboardSpeicher1:=Clipboard
return
ClipboardMenuHandler2a:
Send ^c
if(ClipboardSpeicher1<>"")
	ClipboardSpeicher1:=ClipboardSpeicher1  "`r`n" Clipboard
else
	ClipboardSpeicher1:=Clipboard
; MsgBox % ClipboardSpeicher1
return
ClipboardMenuHandler3:
Clipboard:=ClipboardSpeicher1
return
ClipboardMenuHandler3a:
; SendRaw %ClipboardSpeicher1%
Clipboard:=ClipboardSpeicher1
Send ^v
return
ClipboardMenuHandler4:	;  um die Befehlszeile anzuzeigen, mit der der Prozess des aktiven Fensters gestartet wurde.
	Sleep 20
    WinGet pid, PID, A
    ; Ermittelt das WMI-Service-Objekt.
    wmi := ComObjGet("winmgmts:")
    ; Führt eine Abfrage zur Ermittlung von passenden Prozessen aus.
    queryEnum := wmi.ExecQuery(""
        . "Select * from Win32_Process where ProcessId=" . pid)
        ._NewEnum()
    ; Ermittelt den ersten passenden Prozess.
    if queryEnum[process]
	{
        FuerClipboard:= process.CommandLine
		StringReplace,FuerClipboard,FuerClipboard,%Hochkomma%%A_Space%,%A_Space%%A_Space%%A_Space%%A_Space%,All
		StringReplace,Clipboard,FuerClipboard,`",,All
		gosub PlusSternClipPfade
	}
    else
        MsgBox Prozess nicht gefunden!
    ; Alle globalen Objekte freigeben (nicht notwendig, wenn lokale Variablen verwendet werden).
    wmi := queryEnum := process := ""
return
; Win32_Process: http://msdn.microsoft.com/en-us/library/aa394372.aspx
ClipboardMenuHandler5:
gosub PlusSternClipPfade
return
ClipboardMenuHandler6:
Sort,Clipboard,U
return
ClipboardMenuHandler7:
Sort,Clipboard,U \
return
ClipboardMenuHandler8:
Run, % Clipboard 
return
ClipboardMenuHandler10:
if(Clipboard="")
{
	AbfrageFenster(,"Clipboard Anzeige","Das Clipboard ist leer","OK")
	return
}
AbfrageFensterAntwort:=AbfrageFenster(,"Clipboard Editor",Clipboard "`r`n","abbrechen",">>>>>>>>>Aenderungen uebernehmen")
if(SubStr(AbfrageFensterAntwort,1,1)=2)
{
	FuerClipboard:=SubStr(AbfrageFensterAntwort,2)
	StringReplace,Clipboard,FuerClipboard,`n,`r`n,All
	if(SubStr(Clipboard,-1,2)="`r`n")
		StringTrimRight,Clipboard,Clipboard,2
}
return
ClipboardMenuHandler11:
Edit2:=FileKenner  FuehrendeSterneEntfernen(Clipboard)
gosub Edit2Festigen
return
ClipboardMenuHandler12:
gosub Edit82AWin
; listlines
return
F7::	; Toggle Inhalt-Textansicht <---> Pfadlisten-Ansicht
Edit82Edit2:
SuchVerlauf()
gosub NormalAnzeige
If(SubStr(Edit2,1,7)=FileKenner or SubStr(Edit2,1,8)=FilePatternKenner)
{
	; Edit7:=Edit7VorTextAnsicht
	Edit2:=Edit2VorTextAnsicht
	gosub Edit2Festigen
	; sleep 500
	Edit3:=Edit3VorTextAnsicht
	; gosub Edit7Festigen
	gosub Edit3Festigen
	gosub F5
}
else
{
	gosub InhalteInTextFormAnzeigen
}
return
InhalteInTextFormAnzeigen:
	Edit2VorTextAnsicht:=Edit2
; 	gosub Edit2Festigen
	Edit3VorTextAnsicht:=Edit3
; 	gosub Edit3Festigen
Ctrl & Right::
gosub NormalAnzeige
SuchVerlauf()
; Edit7VorTextAnsicht:=Edit7
	Edit8Sternlos:=FuehrendeSterneEntfernen(Edit8)
	IfExist % Edit8Sternlos
	{
		FileGetAttrib,FileDirektAttribute,% Edit8Sternlos
		if(InStr(FileDirektAttribute,"D"))
			Edit2:=FilePatternKenner  Edit8Sternlos "\*.*,DF"
		else
			Edit2:=FileKenner  Edit8Sternlos
		gosub Edit2Festigen
		Edit3:=1
		gosub Edit3Festigen
		gosub Edit3
		Edit1=			; Noch Aussagefaehiger mchen ######################
		gosub Edit1Festigen
	}
return
; < / ################################### Clipboard Menue  ####################################### >
; < / ############################### Sonstige Menues Labels  ################################### >
; ----------------------------------------------------------------------------------------------------
RegExBeratungsFormular:
RegExSuchAnzeigeText=
(
RegEx-Suche	SteuerZeichen: \.*?+[{|()^$	\ davor macht sie zum Zeichen selbst.
Such-Ort:		^[][][]$			^[Zeilenanfang][irgenwo in der Zeile][Zeilenende]$, nicht so [][][] eingebbar
Alternativen: 	ae|ä  oder  Ger(ae|ä)t	zweiteres findet Gerät und Geraet
Syntax / bildlich	Syntax / bildlich		Legende
WildCards				-> wird zu, nicht so -> eingebbar
. -> [^""]{1} 			 	ein beliebiges Zeichen hier dargestellt als NOT ^ Leere-Menge "", nicht so [^""] eingebbar.
.* -> [^""]{0,°°} 	.+ -> [^""]{1,°°} 		°° hier anschaulich Unendlich, nicht so °° eingebbar.
.? -> [^""]{0,1}  	.[^""]{#} 			Statt # ist die Anzahl des Zeichens zuvor einzugeben, nicht so # eingebbar z.B. 0{5} -> 00000
. -> [^""]{1}	.{#1,#2} 			von #1-Zeichenanzahl bis #2-Zeichenanzahl, nicht so # eingebbar
Abkurzungen:
\d -> [0-9]{1} 	\D -> [^0-9]{1}		
\w -> [A-Za-z0-9_]{1}	\w* [^A-Za-z0-9_]{1}
[az] -> [az]{1}	[a-z] -> [abcdefghijklmnopqrstuvwxyz]{1} auch Bereiche koennen negiert werden [^a-z]
\b Wortabgrenzung	\d Ziffer 	\t Tab 	\n `%CR`% 	\r `%LF`%	\s nicht druckbares Zeichen	
)
if(RegExBeratungsFormularFuer="Edit2")
{
	Edit2:=
	gosub Edit2Festigen
	RegExSuchStringEdit2Default=O U i m `n)(^.*	.*$)
	if (RegExSuchStringEdit2="")
	{
		RegExSuchStringEdit2:=RegExSuchStringEdit2Default
	}
	GuiWinVerschoben:=false
	WinGetPos,DieseThisX,DieseThisY,DieseThisB,DieseThisH,ahk_id %GuiWinHwnd%
	If (RegExBeratungsFormularXPos+RegExBeratungsFormularBreite>A_ScreenWidth)
	{
		GuiWinWubschX:=-DieseThisB-RegExBeratungsFormularBreite+A_ScreenWidth
		if ((GuiWinWubschX>=0) and (DieseThisB + RegExBeratungsFormularBreite<=A_ScreenWidth))
		{
			WinMove,ahk_id %GuiWinHwnd%,,GuiWinWubschX,DieseThisY
			RegExBeratungsFormularXPos:=DieseThisB
			GuiWinVerschoben:=true
			RegExBeratungsFormularYPos:=DieseThisY ; -42 ; + DieseThisH -42
		}
	}
	If (DieseThisH + RegExBeratungsFormularHoehe<=A_ScreenHeight and not GuiWinVerschoben)
	{
		GuiWinWubschY:=-DieseThisH-RegExBeratungsFormularHoehe+A_ScreenHeight-42
		if (GuiWinWubschY>=0)
		{
			WinMove,ahk_id %GuiWinHwnd%,,DieseThisX,GuiWinWubschY
			RegExBeratungsFormularYPos:=GuiWinWubschY + DieseThisH ; -42 
			RegExBeratungsFormularXPos:=DieseThisX
		}
	}
	MomentaneWortListe:=FolderNames
	Loop
	{				; loop bis Wortauswahl erfolgt
		InputBox,RegExSuchStringEdit2,RegEx,%RegExSuchAnzeigeText%`nNur Tab ersetzen. Beenden durch anhaengen der max 2-stelligen Positionsnummer gefolgt von OK.	Oder Cancel,,RegExBeratungsFormularBreite,RegExBeratungsFormularHoehe,RegExBeratungsFormularXPos,RegExBeratungsFormularYPos,,,%RegExSuchStringEdit2%
		if ErrorLevel
			return	
		LastCharRegExSuchStringEdit2:=SubStr(RegExSuchStringEdit2,0)
		Last2CharRegExSuchStringEdit2:=SubStr(RegExSuchStringEdit2,-1)
		Edit2RegExAuswahlExist:=false
		if LastCharRegExSuchStringEdit2 is Integer
		{
			if Last2CharRegExSuchStringEdit2 is Integer
			{
				Edit2RegExAuswahl:=Last2CharRegExSuchStringEdit2
				StringTrimRight,RegExSuchStringEdit2,RegExSuchStringEdit2,2
			}
			else
			{
				Edit2RegExAuswahl:=LastCharRegExSuchStringEdit2
				StringTrimRight,RegExSuchStringEdit2,RegExSuchStringEdit2,1
			}
			Edit2RegExAuswahlExist:=true
		}
		LastRegExBeratungsFormularSendTimeStamp:=A_TickCount
		; MsgBox %MomentaneWortListe%
		GefundeneWortePos:=1
		GesamtGefundeneWortePos:=1
		GefilterteWortListe:=
		ThisFundZaehler:=0
		Loop
		{
			GefundeneWorteObjekt:=
			GefundeneWortePos:=RegExMatch(MomentaneWortListe,RegExSuchStringEdit2,GefundeneWorteObjekt,GesamtGefundeneWortePos)
			if GefundeneWortePos
			{
				++ThisFundZaehler
				If (ThisFundZaehler > Edit6*4)
					break
			}
			GesamtGefundeneWortePos:=GefundeneWortePos+GefundeneWorteObjekt.Len(1)
			GefilterteWortListe:=GefilterteWortListe "`r`n" GefundeneWorteObjekt.Value(1)
			if not GefundeneWortePos
				break
		}
		StringTrimLeft,GefilterteWortListe,GefilterteWortListe,2
		edit5:=GefilterteWortListe
		gosub Edit5Festigen
		if Edit2RegExAuswahlExist
			break
	}
	if Edit2RegExAuswahlExist
	{
		StringSplit,GefiltertesWort,GefilterteWortListe,`n,`r
		Edit2:=GefiltertesWort%Edit2RegExAuswahl%
		gosub Edit2Festigen
		gosub F5
	}
	return
}
else if(RegExBeratungsFormularFuer="Edit7")
{
	if (Edit7="" or Edit7=Filter)
		RegExSuchStringDefault=i)^.*%A_Tab%.*$
	else
		RegExSuchStringDefault:=Edit7
	InputBox,RegExSuchString,RegEx,%RegExSuchAnzeigeText%,,850,365,,,,,%RegExSuchStringDefault%
	if ErrorLevel
		return
	LastRegExBeratungsFormularSendTimeStamp:=A_TickCount
	Edit7:=RegExSuchString
	gosub Edit7Festigen
	return
}
return
; ----------------------------------------------------------------------------------------------------------
SuperFavorit0:
gosub SuperFaVoritenAnlegenBearbeiten
return
SuperFavorit1:
SuperFavorit2:
SuperFavorit3:
SuperFavorit4:
SuperFavorit5:
SuperFavorit6:
SuperFavorit7:
SuperFavorit8:
SuperFavorit9:
SuperFavorit10:
SuperFavorit11:
SuperFavorit12:
SuperFavorit13:
SuperFavorit14:
SuperFavorit15:
SuperFavorit16:
SuperFavorit17:
SuperFavorit18:
SuperFavorit19:
SuperFavorit20:
SuperFavorit21:
SuperFavorit22:
SuperFavorit23:
SuperFavorit24:
SuperFavorit25:
SuperFavorit26:
SuperFavorit27:
SuperFavorit28:
SuperFavorit29:
IfExist %SuperFavoritenDateiPfad%
{
	FileRead,SuperFavoritenDateiInhalt,%SuperFavoritenDateiPfad%
	StringSplit,SuperFavoritenPfad,SuperFavoritenDateiInhalt,`n,`r
	ThisSuperFavoritNr:=Substr(A_ThisLabel,13)+1
	If(InStr(SuperFavoritenPfad%ThisSuperFavoritNr%,A_AppData "\Zack\Macro"))
	{														; Macro erkannt
		ToolTip, Macro erkannt
		DieserBefehlsDateiPfad:=SuperFavoritenPfad%ThisSuperFavoritNr%
		gosub DiesenBefehlsDateiPfadAusfuehren
		ToolTip,
		return
	}
	Edit8:=SuperFavoritenPfad%ThisSuperFavoritNr%
	gosub Edit8Festigen
}
return
; < / ##############################  Vom Gui aufegrufene Labels  #################################### >
; < / ##############################    G  u  i    #################################### >
;  ======================================================================================
;  ======================================================================================
; < ####################  I m    e i g e n e n    P r o z e s s     l a u f e n d e   S k r i p t e  ################################# >
; < / ##################  I m    e i g e n e n    P r o z e s s     l a u f e n d e   S k r i p t e  ################################# >
;  ======================================================================================
; < ############################################# U n t e r p r o g r a m m e  ########################################### >
; < / ########################################### U n t e r p r o g r a m m e  ########################################### >
;  ======================================================================================
; < ############################### U n t e r p r o g r a m m e   f u e r   M a c r o s ################################## >
; < / ############################# U n t e r p r o g r a m m e   f u e r   M a c r o s ################################## >
;  --------------------------------------------------------------------------------------------------------------
; < ################################### benutzte Skript-Ordner oeffnen ########################################### >
OeffneAlleSkriptOrdner:
run %A_AppDataCommon%
run %A_AppData%
run %A_ScriptDir%
return
; < / ################################# benutzte Skript-Ordner oeffnen ########################################### >
; ------------------------------------------------------------------------------------------------------------------
Entferne(PfadListe:="",ZeichenLinks="0",ZeilenOben="0")
{
	global Edit5
	if(PfadListe="")
		PfadListe:=Edit5
	if(ZeilenOben="?" or (ZeilenOben=0 and ZeichenLinks=0))
		InputBox,ZeilenOben,Entfernen,anzahl Zeilen von oben?
	; MsgBox %PfadListe%	%ZeichenLinks%	%ZeilenOben%
	if(ZeilenOben>0)
	{
		Loop,Parse,PfadListe,`n,`r
		{
			if(A_Index>ZeilenOben)
			ZwischenPfadListe.=A_LoopField "`r`n"
		}
		StringTrimRight,ZwischenPfadListe,ZwischenPfadListe,2
	}
	else
	{
		ZwischenPfadListe:=PfadListe
	}
	if(ZeichenLinks="?")
		InputBox,ZeichenLinks,Entfernen,anzahl Zeichen von links?
		if(ZeichenLinks>0)
	{
		BeginSpalte:=1+ZeichenLinks
		Loop,Parse,ZwischenPfadListe,`n,`r
		{
			RueckPfadListe.=SubStr(A_LoopField,BeginSpalte) "`r`n"
		}
		StringTrimRight,RueckPfadListe,RueckPfadListe,2
	}
	else
		RueckPfadListe:=ZwischenPfadListe
return RueckPfadListe
}
ZeigePfadlisteImBrowser:
HtmlListe:=PfadListe2HtmlListe(Edit5)
HtmlListePfad:=A_Temp "\HtmlListe.htm"
FileAppend(HtmlListe,HtmlListePfad)
WB.Navigate(HtmlListePfad)
; run % A_Temp "\HtmlListe.htm"
; run  % A_Temp 
return
PfadListe2HtmlListe(PfadListe)
{
	StringReplace,PfadListe,PfadListe,*,,all
	StringReplace,PfadListe,PfadListe,%A_Tab%,\,all
	StringReplace,PfadListe,PfadListe,//,|,all
	StringReplace,PfadListe,PfadListe,/,</td><td>,all
	StringReplace,PfadListe,PfadListe,\\,?,all
	StringReplace,PfadListe,PfadListe,`r,,all
	StringReplace,PfadListe,PfadListe,`n,</td></tr>`r`n<tr><td>,all
	StringReplace,PfadListe,PfadListe,\,</td><td>,all
	StringReplace,PfadListe,PfadListe,?,\\,all
	StringReplace,PfadListe,PfadListe,|,//,all
	Vor=<table border="1" width="100`%">`r`n<tr><td>
	Nach=</td></tr>`r`n</table>
	return Vor PfadListe Nach
}
FileAppend(Inhalt,Pfad,Kodierung="UTF-16")
{
	FileDelete,%Pfad%
	FileAppend,%Inhalt%,%Pfad%,%Kodierung%
	return ErrorLevel
}
RecentFolderLinks:
RecentFolder=%A_AppData%\Microsoft\Windows\Recent
loop,%RecentFolder%\*.lnk
{
	FileGetShortcut, %A_LoopFileFullPath% , RecentZielPfad
	IfExist %RecentZielPfad%
	{
		RecentZielPfadListeAll.="`r`n" RecentZielPfad
		FileGetAttrib, RecentZielPfadAttribute,%RecentZielPfad%
		IfInString, RecentZielPfadAttribute, D
			RecentZielPfadListe.="`r`n" RecentZielPfad
	}
}
Sort,RecentZielPfadListe,U
return
SaveE8E5(GetOderSet="")
{
	static LastErgebnis8
	global Edit5Last,Edit8,Edit5
	if(GetOderSet="")
		GetOderSet=Set
	if(GetOderSet="Get")
		return LastErgebnis8
	else if(GetOderSet="Set")
	{
		Edit5Last:=Edit5
		LastErgebnis8:=Edit8
	}
}
Edit6GleichGefundenePfade:
StringReplace,Edit1Klammerlos,Edit1,(,
StringReplace,Edit1Klammerlos,Edit1Klammerlos,),
; MsgBox % Edit1Klammerlos
DoppeltEdit6:=Edit6*2
if(Edit1Klammerlos<DoppeltEdit6)
	Edit6:=DoppeltEdit6
else
	Edit6:=Edit1Klammerlos
gosub Edit6Festigen
return
; -----------------------------------------------------------------------------------------------------------------
Sleep10000:
Sleep 10000
return
; -----------------------------------------------------------------------------------------------------------------
ClipBoardAnzeige:
if (Clipboard<>"")
	AbfrageFenster(,"Clipboard Anzeige",Clipboard,"OK")
else
	AbfrageFenster(,"Clipboard Anzeige","[Leere Menge]","OK")
return
; < / ############################### U n t e r p r o g r a m m e   f u e r   M a c r o s ################################## >
; ============================================================================================================================
; < #################################################### F u n k t i o n e n ########################################################## >
; < ############################ Hole die dem Suchwort entsprechenden Pfade aus dem Cache####################################### >
GetPaths(Such,SucheAbrechen=20,FruehzeitigRueck="")
{	 
	global WoAn, beschaeftigt, SuchAbbruch,Edit1, Edit2, Edit3, Edit4, Edit5, Edit6, Edit7 ,Edit8,Edit9, SuFi, RegEx,AuAb,AktualisierungAufButton1,TimerBeiErgebnisFalschAktiv,TimerBeiErgeebnisUnsicherAktiv,Fehlersuche, SkriptDataPath, WurzelContainer, ZackData,HwndEdit2, LangsamDemo,AnEdit5Vorbei,FilePaqtternExtender,NurCacheFolderNr,SucheAbgebrochen,WortVorschlaege,WortVorschlagListe,Edit2CaretX,Edit2CaretY

	
	
	SucheAbrechenMal100:=SucheAbrechen*100
	SucheAbgebrochen:=false
	GesPaths:=
	if (FilePaqtternExtender="")
		FilePaqtternExtender:="txt"
	SuchAbbruch:=false
	GuiControl,1: Move, Edit6, 	w40	h16
	BeschaeftigtAnzeige(1)
	
	WortVorschlagsMenuShow:=false
	WortVorschlagListe:=
	FileDelete,%A_AppData%\Zack\WortVorschlagListe.txt
	WurzelIndexPath=%SkriptDataPath%\WurzelIndex.txt
	FileRead,WurzelIndex,% FuehrendeSterneEntfernen(WurzelIndexPath)
	if(SkriptDataPath="") 							; Chinesiche Zeichen Fehler hiermit behoben
	{
		BeschaeftigtAnzeige(-1)
		return
	}
	WortVorschlagAnzahl:=0
	Loop,Files,%SkriptDataPath%\*, D										; nur durchfuehren wenn SkriptDataPath <> ""    Dies war der Chinesiche Zeichen Fehler ; SkriptDataPath=%A_AppDataCommon%\Zack\WuCont\Haupt
	{
		ThisCacheName:=A_LoopFileName
		if(NurCacheFolderNr<0)
		{
			if(NurCacheFolderNr and A_index=-NurCacheFolderNr)
				continue
		}
		else
		{
			if(NurCacheFolderNr and A_index<>NurCacheFolderNr)
				continue
		}
		if WoAn
			FilePattern=%A_LoopFileLongPath%\%Such%*.%FilePaqtternExtender%
		else
			FilePattern=%A_LoopFileLongPath%\*%Such%*.%FilePaqtternExtender%
		if Fehlersuche
		{
			MsgBox % "FilePattern=" FilePattern
		}
			Loop,Files,%FilePattern%, F
			{
				if(A_Index=1)
					SucheAbrechenIndex:=1
				if WortVorschlaege
				{
					if(WortVorschlagAnzahl<9 and Edit2<>"")
					{
						Edit2Len:=StrLen(Edit2)
						if(SubStr(A_LoopFileName,1,Edit2Len)=Edit2 and Edit2Len>0)
						{
							if A_LoopFileName not in %WortVorschlagListe%
							{
								WortVorschlagListe.="," A_LoopFileName 
								++WortVorschlagAnzahl
								; ToolTip,% SubStr(WortVorschlagListe,2)
								; Menu, WortVorschlagsMenu, Add, %A_LoopFileName%, WortVorschlagsMenuHandler%WortVorschlagAnzahl%,P-500
								if WortVorschlagsMenuShow
								;  Menu,WortVorschlagsMenu,Disable,WortVorschlagsMenuHandler%WortVorschlagAnzahl%
								; Menu,WortVorschlagsMenu,Show
								; SoundBeep
								sleep 200
								WinActivate,ahk_id %GuiWinHwnd%
								ControlFocus , Edit2, ahk_id %GuiWinHwnd%
							}
						}
						else
							FileDelete,%A_AppData%\Zack\WortVorschlagListe.txt
					}
					else
						FileDelete,%A_AppData%\Zack\WortVorschlagListe.txt
				}
				if WurzelnAnzeigen
				{
					MsgBox A_LoopFileLongPath,%A_LoopFileLongPath%
					WurzelnAnzeigen:=false
				}
				if Fehlersuche
					MsgBox % "A_LoopFileFullPath=" A_LoopFileFullPath
				FileRead,LoopFieldInhalte,% FuehrendeSterneEntfernen(A_LoopFileFullPath)
				if Fehlersuche
					MsgBox % LoopFieldInhalte
				If SuFi
				{
					If RegEx
					{
						{
							loop,Parse,LoopFieldInhalte,`n,`r
							{
								if(RegExMatch(A_LoopField,Edit7))
								{
									GesPaths.=  "`r`n"  A_LoopField
									++SucheAbrechenIndex
								}
							}
						}
					}
					else
					{
						{
							loop,Parse,LoopFieldInhalte,`n,`r
							{
								if(SubStr(Edit7,1,1)="""")
								{
									IfnotInString,A_LoopField,% SubStr(Edit7,2)
									{
										if(A_LoopField<>"")
										{
											GesPaths.= "`r`n" A_LoopField    ; , 							E2E7(A_LineNumber,Edit2,Edit7,GesPaths,0)
											++SucheAbrechenIndex
										}
									}
								}
								else
								{
									IfInString,A_LoopField,%Edit7%
									{
										GesPaths.= "`r`n" A_LoopField    ; , 							E2E7(A_LineNumber,Edit2,Edit7,GesPaths,0)
										++SucheAbrechenIndex
									}
								}
							}
						}
					}
				}
				Else
				{
					GesPaths:=GesPaths  LoopFieldInhalte  ; , 							E2E7(A_LineNumber,Edit2,Edit7,GesPaths,0)
					++SucheAbrechenIndex
				}
				If (LangsamDemo and A_index<10 and FruehzeitigRueck<>"") ; and SucheAbrechen >200 +++++++++++++++++++++++++++++++++++++++++++++++++++++
				{
					StringTrimLeft,GesPathsOhneCrLf,GesPaths,2
					sort,GesPathsOhneCrLf,U
					%FruehzeitigRueck%:=GesPathsOhneCrLf
					SuperFruehzeitigRueck:=%FruehzeitigRueck%
					GuiControl,1:, %FruehzeitigRueck%, %SuperFruehzeitigRueck%
					sleep 150
				}
				if((SucheAbrechenIndex>SucheAbrechen OR A_Index>SucheAbrechenMal100) and ThisCacheName<>"!Fav") ; rechter Teil: Favoriten immer bis Ende bearbeiten
				{
					If AuAb
					{
						DoubleEdit6:=true
					}
					If Fehlersuche
						MsgBox break
					SucheAbgebrochen:=true
					break
				}
			}
	}
	StringTrimLeft,GesPaths,GesPaths,2
	If not SuchAbbruch
	{
		; Edit1:=ZaehleZeilen(GesPaths)  ; -1		; minus 1 weil ein `r`n zuviel ist noch klaeren Alle stimmt wahrscheinlich nicht
		; GuiControl,1:, Edit1, %Edit1%
	}
	else
	{
		Edit1=?
		GuiControl,1:, Edit1, %Edit1%
	}
	FileDelete,%A_AppData%\Zack\WortVorschlagListe.txt
if (WortVorschlagListe<>"")
	FileAppend,%Edit2CaretX%`,%Edit2CaretY%`r`n%WortVorschlagListe%,%A_AppData%\Zack\WortVorschlagListe.txt
; 	SetTimer,ZeigeWortVorschlagsMenue,-1

If Fehlersuche
	MsgBox Getpaths() return
BeschaeftigtAnzeige(-1)

return GesPaths
/*
geplant:
<	Klammer l
>	Klammer r
&	Und
|	oder
ohne KLammern wird zuerst & dann | gesplittet
A | B & C | D wird <A | B> & <C | D> ausgewertet
*/
}
; < / ########################## Hole die dem Suchwort entsprechenden Pfade aus dem Cache####################################### >
; -------------------------------------------------------------------------------------------------------------------
; < ####################################### Favoriten Hinzufuegen und entfernen ###################################################### >
SetFavorit(PfadMitSternen,DeltaSterne,ExtraAnweisung,FavoritenDirPath,AutoFavorit)
{
	global FehlerSuche
	if FehlerSuche
		MsgBox  % A_LineNumber "Funktion: SetFavorit("	PfadMitSternen "," DeltaSterne "," ExtraAnweisung "," FavoritenDirPath "," AutoFavorit ")"
	; 	PfadMitSternen			C:\Temp oder *C:\Temp
	;	DeltaSterne     		-n ... -2 -1 0 1 2 ... n	DeleteAll	DeleteSterne	BehaltePfad
	;	FavoritenDirPath		C:\ProgramData\Zack\WuCont\Haupt\!Fav
	;	AutoFavorit				-1 0 1 2 3 4 ...
	if(DeltaSterne="")
		DeltaSterne:=0
	IfNotExist % FavoritenDirPath
		FileCreateDir % FavoritenDirPath
	ZeileGeaendert:=false
	ZeileUngeaendert:=false
	Loop,%FavoritenDirPath%\*.txt
	{
		Name:=A_LoopFileName
		FileRead,DieserInhalt,%A_LoopFileFullPath%
		Zeilennummer:=1
		StringTrimLeft,DieserInhalt,DieserInhalt,2
		StringSplit, Zeile,DieserInhalt,`n,`r
		ZeilenVor=
		GeaenderteZeile=
		ZeilenNach=
		Loop % Zeile0
		{
			If (Zeile%A_Index%<>"")
			{
				if not ZeileGeaendert
				{
					; MsgBox % FuehrendeSterneEntfernen(PfadMitSternen)=Zeile%A_Index%)
					if(FuehrendeSterneEntfernen(PfadMitSternen)=FuehrendeSterneEntfernen(Zeile%A_Index%))
					{
						{
							GeaenderteZeile:=ZeilenAenderungen(Zeile%A_Index%,DeltaSterne,ExtraAnweisung,0)
							if(GeaenderteZeile<>Zeile%A_Index%)
							{
								ZeileGeaendert:=true
								ZuAendern:=A_LoopFileFullPath
								if Fehlersuche
									MsgBox innen %ZuAendern%
							}
							else
								ZeileUngeaendert:=true
						}
					}
					else
						ZeilenVor.="`r`n" Zeile%A_Index%
				}
				else
				{
					ZeilenNach.="`r`n" Zeile%A_Index%
				}
				; MsgBox % GeaenderteZeile
			}
		}
		if ZeileGeaendert
		{
			if Fehlersuche
				MsgBox aussen %ZuAendern%
			FileDelete,%ZuAendern%
			if ErrorLevel
				MsgBox % A_LineNumber 		"	Fehler bei Favoriten-Datei-Pfad:`n" NeuAnlegenCachePfad "`nloeschen."
			if(ZeilenVor GeaenderteZeile ZeilenNach <>"")
			{
				FileAppend,% ZeilenVor GeaenderteZeile ZeilenNach,%ZuAendern%
				if ErrorLevel
					MsgBox % A_LineNumber 		"	Fehler bei Favoriten-Datei-Pfad:`n" NeuAnlegenCachePfad "`n`nmit Favoriten-Datei-Inhalt:" ZeilenVor GeaenderteZeile ZeilenNach " anlegen." 
			}
			break
		}
		else if ZeileUngeaendert
			break
	}
	if(not ZeileGeaendert  and  not ZeileUngeaendert)
	{
		if (ExtraAnweisung="DeleteAll")
			return "NotDel"
		else
		{
			if (ExtraAnweisung="BehaltePfad")
				GeaenderteZeile:=ZeilenAenderungen(PfadMitSternen,DeltaSterne,ExtraAnweisung)
			else
				GeaenderteZeile:=ZeilenAenderungen(PfadMitSternen,DeltaSterne,ExtraAnweisung,1)
			if Fehlersuche
				MsgBox % "direkt danach Strlen=" StrLen(GeaenderteZeile) "	" GeaenderteZeile
			; if(GeaenderteZeile<>"")
			if(StrLen(GeaenderteZeile)>0)
			{
				PfadOhneSterne:=FuehrendeSterneEntfernen(PfadMitSternen)
				IfExist % PfadOhneSterne
				{
					SplitPath,PfadOhneSterne,,PfadOhneSterneDir,PfadOhneSterneExt,PfadOhneSterneNameNoExt,PfadOhneSterneDrive
					if FehlerSuche
						MsgBox % PfadOhneSterne 	"	"	PfadOhneSterneDir	"	"  PfadOhneSterneNameNoExt 	"	" PfadOhneSterneDrive
					if(PfadOhneSterneNameNoExt="")
						NeuAnlegenCachePfad:=FavoritenDirPath "\"  NichtErlaubteZeichenErsetzen(PfadOhneSterneDrive,1) ".txt"		; wenn ...Dir leer, dann muss der Drivename zur Bildung des CacheDateinamens herhalten.
					else if(PfadOhneSterneExt="")
						NeuAnlegenCachePfad:=FavoritenDirPath "\" PfadOhneSterneNameNoExt ".txt"
					else
						NeuAnlegenCachePfad:=FavoritenDirPath "\" PfadOhneSterneNameNoExt "." PfadOhneSterneExt ".txt"
					IfExist %NeuAnlegenCachePfad%
						FileRead,BereitsVorhandenePfade,%NeuAnlegenCachePfad%
					else
						BereitsVorhandenePfade=
				}
				else
				{			; Fuer http etc.
					NeuAnlegenCachePfad:=FavoritenDirPath "\" NichtErlaubteZeichenErsetzen(PfadOhneSterne,1) ".txt"
					IfExist %NeuAnlegenCachePfad%
						FileRead,BereitsVorhandenePfade,%NeuAnlegenCachePfad%
					else
						BereitsVorhandenePfade=
				}
				FileAppend,% GeaenderteZeile,%NeuAnlegenCachePfad%
				if ErrorLevel
					MsgBox %A_LineNumber% Fehler bei Favoriten-Datei-Pfad:`n%NeuAnlegenCachePfad%`n`nmit Favoriten-Datei-Inhalt: %GeaenderteZeile%`nanlegen. 
				return BereitsVorhandenePfade GeaenderteZeile
			}
			else
			{
				if(StrLen(GeaenderteZeile)=0)
					MsgBox % A_LineNumber "	Fehler beim loeschen vom Faforiten: `n" PfadMitSternen "`n`n es koennte sich um einen bereits entfernten Favorit handeln."
				else
				MsgBox % A_LineNumber "	Strlen=" StrLen(GeaenderteZeile)
			}
		}
	}
	return ZeilenVor GeaenderteZeile ZeilenNach
}
; < / ####################################### Favoriten Hinzufuegen und entfernen ###################################################### >
NichtErlaubteZeichenErsetzen(PfadOhneSterne,NurDateiNamen="")
{
	global FehlerSuche
	if(NurDateiNamen="")		; nur Dateinamen wurden uebergeben bei 1
		NurDateiNamen:=0		; vollstaendige Pfade wurden uebergeben bei 0
	StringReplace,PfadOhneSterne,PfadOhneSterne,:,˸,All
	StringReplace,PfadOhneSterne,PfadOhneSterne,/,̷⁄,All
	StringReplace,PfadOhneSterne,PfadOhneSterne,?,Ɂ,All
	StringReplace,PfadOhneSterne,PfadOhneSterne,|,│,All
	StringReplace,PfadOhneSterne,PfadOhneSterne,<,˂,All
	StringReplace,PfadOhneSterne,PfadOhneSterne,>,˃,All
	StringReplace,PfadOhneSterne,PfadOhneSterne,*,°,All
	StringReplace,PfadOhneSterne,PfadOhneSterne,*,°,All
	if NurDateiNamen
		StringReplace,PfadOhneSterne,PfadOhneSterne,\,►,All ; darf ich auf Pfad-Ebene nicht machen
	return PfadOhneSterne
}
; ###################### Zeilen-Aenderungen ######### UnterFunktion zu: Favoriten Hinzufuegen und entfernen ######################## >
; Diese Funktion ist nicht fuer den Direktaufruf gedacht.
ZeilenAenderungen(Zeile,DeltaSterne,ExtraAnweisung="",NeuAnlegen="")
{
	global FehlerSuche , AutoFavorit
	if FehlerSuche
		MsgBox  % A_LineNumber "Funktion: ZeilenAenderungen("	Zeile "," DeltaSterne "," ExtraAnweisung ")"
	if NeuAnlegen
		DebugPause=
	; FavoritenPath	C:\ProgramData\Zack\WuCont\Haupt\!Fav\Temp.txt
	; Aenderung	-Zeilennummer	
	; DeltaSterne	-n ... -2 -1 0 1 2 ... n	DeleteAll	DeleteSterne	BehaltePfad
	; ??? ZeilenInhalt
	MaxZulaessigeSterne:=20
	; if DeltaSterne is Integer
	if ((ExtraAnweisung="" or ExtraAnweisung="BehaltePfad" or NeuAnlegen) and not (ExtraAnweisung="DeleteAll"))
	{
		if DeltaSterne is Integer
		{
			AnzahlSterne:=FuehrendeSterneAnzahl(Zeile)
			AnzahlSterneBestellt:=AnzahlSterne+DeltaSterne
			if(AnzahlSterne>=AutoFavorit)
				StehenLassen:=AnzahlSterne
			else
				StehenLassen:=AutoFavorit
			If(AnzahlSterneBestellt>MaxZulaessigeSterne)
				AnzahlSterneBestellt:=MaxZulaessigeSterne
			If(AnzahlSterneBestellt>AnzahlSterne)
			{
				geaendert:=0
				entf:=0
				Loop % AnzahlSterneBestellt-AnzahlSterne
				{
					; if(SubStr(Zeile,1,1)="*")
					{
						Zeile:="*" Zeile
						++geaendert
					}
				}
				if(AnzahlSterneBestellt-AnzahlSterne<>geaendert)
					TrayTip, Sterne entfernen,Problem bei Sterne entfernen.
				if (FuehrendeSterneAnzahl(Zeile)=0)
					return
				else
				{
					if(ExtraAnweisung="BehaltePfad")
						return "`r`n" FuehrendeSterneEntfernenRestLassen(Zeile,StehenLassen)
					else
						return "`r`n" Zeile
				}
			}
			else If(AnzahlSterneBestellt<AnzahlSterne)
			{
				geaendert:=0
				Loop % AnzahlSterne-AnzahlSterneBestellt
				{
					if(SubStr(Zeile,1,1)="*")
					{
						StringTrimLeft,Zeile,Zeile,1
						++geaendert
					}
					else
						break
				}
				; if(AnzahlSterneBestellt-AnzahlSterne<>geaendert)
					; TrayTip, Sterne entfernen,Problem bei Sterne entfernen.
				if (FuehrendeSterneAnzahl(Zeile)=0)
					return
				else
				{
					if(ExtraAnweisung="BehaltePfad")
						return "`r`n" FuehrendeSterneEntfernenRestLassen(Zeile,StehenLassen)
					else
						return "`r`n" Zeile
				}
			}
			else If(AnzahlSterneBestellt=AnzahlSterne)
			{
				if (FuehrendeSterneAnzahl(Zeile)=0 and ExtraAnweisung<>"BehaltePfad")
					return
				else
				{
					if(ExtraAnweisung="BehaltePfad")
						return "`r`n" FuehrendeSterneEntfernenRestLassen(Zeile,StehenLassen)
					else
						return "`r`n" Zeile
				}
			}
		}
		else
			MsgBox %A_LineNumber% Unerwarteter ScriptZweig. >%DeltaSterne%< ist kein Integer.
	}
	else if (ExtraAnweisung = "DeleteAll")
		return
	else if (ExtraAnweisung = "BehaltePfad")
		return "`r`n" FuehrendeSterneEntfernenRestLassen(Zeile,AutoFavorit)
	else
		MsgBox Fehler
}
; / #################### Zeilen-Aenderungen ######### UnterFunktion zu: Favoriten Hinzufuegen und entfernen ######################## >
; ----------------------------------------------------------------------------------------------------------------------------------
; < #################################### Fuehrende Sterne entfernen ############################################## >
FuehrendeSterneEntfernen(Pfad,Max=20)
{
 	global AnzahlEntfernterSterne
	Stern=*
	AnzahlEntfernterSterne:=0
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
; < / #################################### Fuehrende Sterne entfernen ############################################## >
; < ###################################### Fuehrende Sterne zaehlen ############################################## >
FuehrendeSterneAnzahl(Pfad,Max=20)
{
 	global AnzahlEntfernterSterne
	Stern=*
	AnzahlEntfernterSterne:=0
	StringReplace,Pfad,Pfad,%A_Tab%,`\
	Loop
	{
		if not Max
			return AnzahlEntfernterSterne
		First:=SubStr(Pfad,1,1)
		if(First = Stern)
		{
			StringTrimLeft,Pfad,Pfad,1
			++AnzahlEntfernterSterne
		}
		else
		{
			return AnzahlEntfernterSterne
		}
		--Max
	}
	return 
}
; < / #################################### Fuehrende Sterne zaehlen ############################################## >
; < ####################### Fuehrende Sterne bis auf einen definierten Rest entfernen ############################################## >
FuehrendeSterneEntfernenRestLassen(Pfad,Rest,Max=20)
{
 	global AnzahlEntfernterSterne
	Stern=*
	AnzahlEntfernterSterne:=0
	StringReplace,Pfad,Pfad,%A_Tab%,`\
	Loop
	{
		if(FuehrendeSterneAnzahl(Pfad) <= Rest)
		{
			return Pfad
		}
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
; < / ##################### Fuehrende Sterne bis auf einen definierten Rest entfernen ############################################## >
; -------------------------------------------------------------------------------------------------------------------------
; < #################################### Ist Pfad ein benutzbarer Pfad ####################################### >
IfFileOderDirSyntax(Pfad)
{
	if(((StrLen(Pfad)>2 and InStr(Pfad,"\")) or (StrLen(Pfad)=2)) and ((SubStr(Pfad,1,2)="\\"  or  SubStr(Pfad,2,1)=":")))
	{
		First:=SubStr(Pfad,1,1)
		if First is alpha
			BeginntMitChar:=true
		If(BeginntMitChar or SubStr(Pfad,1,1)="\")
			return 1
	}
	return=0
}
; < #################################### Ist Pfad ein benutzbarer Pfad ####################################### >
; < / ################################################## F u n k t i o n e n ########################################################## >
; ===================================================================================================================================
; < ###################################################  H i L f e  ############################################################# >	@0800
Info:
gosub VersionsHistorieEinlesen
FileDelete,%A_ScriptDir%\VersionsHistorie.txt
FileAppend, ZackZackOrdner hilft bei dem schnellen finden von Ordnern.`n`nBeta Version 0.289`nGerdi `n`n`nVersionsHistorie`n`n%VersionsHistorie%,%A_ScriptDir%\VersionsHistorie.txt,utf-16
run notepad.exe "%A_ScriptDir%\VersionsHistorie.txt"
return
VersionsHistorieEinlesen:
BekannteFehler=
(
-	ein . in der Suche erzeugt nicht immer die erwarteten Ergebnisse. Dies ist ein abgeleiteter Fehler von der Dateisuche des Betriebssystems.
	Keine Aenderung in Sicht (Tipps werden jedoch gerne entgeengenommen und geprueft.)
-	auf dem 2.Monitor funzd Rechtsklick auf Pfadnummern Zahlen-Spalte nicht.
-	allgemein sind die Fensterberechnungen noch nicht auf Mehrmonitorbetrieb ausgelegt.
	Diese Problematig wird erst nach einer Stabilisierungs-Phase (wenn nicht mehr laufend neues implementiert wird) in Angriff genommen.
-	Folgefehler vom Mehrmonitorbetriebs_Fehler: wenn der 2. Monitor groesser als der Haupt-Monitor und das Quell-Explorer-Fenster groesser als auf Monitor 1 passend, 
	dann kann nach betaetigen des Button Ordner, das ZackZackOrdner-Fenster, nicht die Positionen vom Quell-Explorer-Fenster uebernehmen. 
	Dadurch klappt dann auch das Rueckschreiben mit Button4 nicht, sondern es wird ein weiteres Explorerfenster mit dem gewuenschten Pfad geoeffnet.
-	vom Suchfilter werden die Drives solo (c: d: e: ...) nicht durchgelassen wenn der : verwendet wird. z.B. bei Filter c: wird c: selbst nicht mehr durchgelassen.
	Dieser Fehler wird voraussichtlich performance bedingt bestehen bleiben. 
	Hintergund : ist im Dateiname nicht erlaubt, deshalb wird intern im Dateiname fuer Drives der hochgestellte ˸ verwendet.
	In Pfaden die mit dem Drive beginnen ist dies nicht notwendig und auch nicht sinnvoll.
	Wenn die einzelnen solo-Drives wirklich ungefiltert sein muessen, z.B. fuer eine automatische Weiterverarbeitung in Befehlsskripten.
	dann kann man das gewuenschte Ergebnis wahrscheinlich mit einem RegEx-Filter der Bauweise
	von		i)c:|c˸		bis		i)\**c˸.*|\**c:.*
	hinbekommen fur c ist der Buchstabe des Drives oder wenn alle gewuenscht sind ein . einzusetzen. 
	Dieser Filter 
	i)^\**.˸.*$|^\**.:.*$
	sollte (ungenuegend geprueft) bis auf die wesentlich laengere Rechenzeit neutral (wie nicht gesetzt) sein,
	wenn sich die Abarbeitungreihenfolge so verhaelt wie ich sie erwarten wuerde. Dabei bedeuten:
	^ filtere von ZeilenBeginn 	\ interpraetiere das naechste Zeichen nicht als Befehl sonder nimm es so wie es dasteht
 	* nehme bel. Anzahl des vorigen Zeichens bzw. Befehlskonstruktes 	| trennt Alternativen 	$ das Zeichen/Befehlkonstrukt endet direkt vor dem Zeilenende
	i) Gross-Buchstaben oder Klein-Buchstaben egal
-	Die Ordner des ZackZackOdner-eigenen Caches verhalten sich beim Suchen und filtern ebenfalls nicht immer wie erwartet.
	Auch hier ist keine Behebung geplant. 
	Hilfreich kann sein zu wissen dass in Cache-Dateinamen 	 ˸ statt :		 ► statt \		° statt *	 verwendet wird.
-	Die blaue Markierung ist nicht immer im Feld welches von Nr. Wahl eingestellt wurde. 
	Dies passiert genau dann wenn der zu Markierende Bereich in einem Pfad weiter oben enthalten ist.
	Da man hierbei jedoch meisst auf den besseren Favoriten-Pfadeintrag mit * hingewiesen wird, bin ich unschluessig ob hier nachgebessert wird.
	Hinweis: dass die Markierung nur bei noch vorhandenen Objekten erscheint ist so gewollt.
-	Das Abbr. Feld wurde urspruenglich bei erfolgtem Abbruch, also eventuell unvollstaendigen Suchergebnis groesser.
-	Warscheinlich aus dem selben Grund funktioniert auch das Feld AutoAb nicht mehr.
	Zur Behebung wird eventuell ein ganz anderer Weg eingeschlagen werden, da der alte Weg eh nicht berauschend war.
-	Der Hotstring :§: wird vom RegEx BeratungsFormular ignoriert. (naeheres siehe VersionsHistorie 0.123)
- erledigt:	Der automatische Start der Hilfe nach Neu-Installationen funktioniert nicht zuverlaessig.
- erledigt:	Allgemein bestehen noch ein paar interne Herausforderungen, welche die Timer betreffen.
	Wenn ZackZackOrdner mal nicht richtig reagiert, kann das Entfernen der Timerhaken WinWait und EdWa Abhilfe bringen,
	es wird jedoch in solchen Faellen immer ein Neustart von ZackZackOrdner empfohlen.
	Nach einem Neustart 10Sekunden warten, dass sich die Timer austoben koennen, ist momentan (Version 0.123) auch empfehlenswert.
)
VersionsHistorie1=
(
0.110	AutoPop Fehler mit leeren Feldern in .ausn Files behoben
	AutoPop Log aussagekraeftig gemacht.
0.111	Hilfe zu AutpPop erstellt	
0.112	GuiDropFile auf Button 2 wird unterstuetzt: File Landet im selben Edit-Feld wie beim betaetigen von Button 2 die Auswahl (also Edit8) landet.
0.113	GuiDropFiles auf Button 2 wird unterstuetzt: Dito fuer mehrere Files.
	VersionsHistorie implementiert.
0.114	Befehle implementiert
	Edit82Send:	;	Sendet Inhalt von Edit8, wie auf Tastatur eigegeben.
	Edit82Clip:	;	schreibt Inhalt von Edit8 ins Clipboard
	Edit52Clip:	;	schreibt Inhalt von Edit5 ins Clipboard
	Clip2Edit5:	;	schreibt Inhalt vom Clipboard in Edit5 und Festigt
0.115	unnoetiges run `%A_Temp`% entfernt
0.116	Button6 auch bei nicht installiertem AHK zugaenglich gemacht
	GuiDropFiles fuer Button6 vorbereitet, benoetigt GuiDropFilesButton6.ahk und .exe
0.117	Der Start-Pfad selbst wird nun auch angezeigt nach dem einlesen.
0.118	Hilfe um Ausgesuchte RegEx Suchfilter ergaenzt.
0.119	RegEx BeratungsFormular erstellt.
0.120	RegEx BeratungsFormular aktiviert bei: 
		Edit7 changes und Haken RegEx und letzes Absenden vom Formular muss 4 Sekunden vorbei sein.
0.121	OrdnerNamensListe in den Cache aufgenommen
0.122	RegEx Vorauswahl fur das Suche-Feld eingerichtet. Zu erreichen via Eingabe von ) ins Suchfeld. 
	Am Eingabe-String alles lassen bis auf den Tabulator
	Beenden mit einer bis zu 2-stelligen Ergebnisauswahl in Form einer Integer-Zahl, die ganz rechts anzufuegen ist.
0.123	3 HotStrings *§* \§\ :§: implementiert um die Zeichen ° ► ˸ direkt eingeben zu koennen.
	Diese sind auch ausserhalb des ZackZackOrdner-Fensters benutzbar, sofern sie von den Fremd-Fenstern verdaut werden.
	Leider verdaut das ZackZackOrdner-interne Fenster RegEx BeratungsFormular den Hochgestellten ˸ nicht und ignoriert ihn. 
	(Falls jemand ne Loesung kennt, dies fuer die Standart InputBox von AutoHotKey zu beheben, bitte beim Autor melden)
0.124	Hilfe korrigiert und ergaenzt.
0.125	TastWatch um zusaetzlichen Ausgang Pfeiltaste Rechts erweitert.
	nun kann mit bspw. Caps Caps Bagslash Right das Zeichen ► an das Control mit dem Fokus gesendet werden 
	bei                ...  ...  :        ...    kommt      ˸       die hochgestellte Variante
	bei                ...  ...  m        ...    klappt das Kontextmenue bzw. das rechte MausTastenMenue auf (die AppKey-Taste fehlt auf einigen Tastaturen).
0.126	BeiExtender.???.ahk ermoeglicht Aktionen die ausgefuehrt werden, wenn es zum momentanen Ordner in Edit8 eine pasende Datei OrdnerPfad.??? gibt.
0.127	Primitv-Beipiel BeiExtender.jpg.ahk implementiert, weches immer wenn ein Ordner mit Bild (mit gleichem Name wie der Ordner nur um .jpg ergaenzt) ausgewaehlt wurde
	poppt dieses jpg-Bild kurz in Fensterbreite auf und wird verleinert noch eine kurze Weile angezeigt. 
0.128	Temporaere Anzeige "Wo bin ich in Ordner Hierarchie" verbessert:
	Von Zeige-UnterOrdner auf Zeige-Drueber-Selbst-Unter (3. Eintrag vom Edit8 Menue) umgestellt, 
	nun kann temporaer (wie im Explorer nur umstaendlicher) auch nach oben und unten gehangelt werden.
	Diese Funktion eignet sich bspw. vor dem setzen von Favoriten, weshalb sie umbenannt auch ueber das Favoriten-Menue erreichbar ist: 
	Zeige temp Pos in Ordner-Struktur
	Hinweis: Der Suchbegriff wird nicht mit veraendert, d.h. Aktualisieren bewirkt (bis auf die geaenderte Auswahl im Feld Nr. Wahl)
	den Zustand wie vorher, egal wo man sich temporaer hingehangelt hat.
0.129	nun sollten bis zu 10 Bewertungssterne auch einzeln loeschbar sein. 
0.130	Hilfe zum Traymenue zugefuegt.
0.131	Hilfe fuer Poweruser um Tips und Tricks ergaenzt.
0.132	HTTP:// Pfade an einigen Stellen unterstuetzt (vorraussichtlich fehlen noch einige aber provisorisch funktioniert einiges).
	Der Haken "Zeige Dateien" muesste nun heissen "zeige Dateien, Ordner oder die Internet-Seite". Wird vorausichtlich "zeige Inhalt"
	"Explorer Select" auf http-Links oeffnet jetzt den Browser mit der verlinkten Seite (selctiert aber nichts) (wie "Explorer" und "oeffnen" dies schon laenger machten).
0.133	bei nicht existierendem Pfad wird der 1. Buchstaben vom aktuellen Pfad von Edit5 statt garnichts markiert.
	Wenn ein internet-Protokoll z.B. http: vorkommt, welches vom IE angezeigt werden kann, wird nicht geprueft, 
	sondern existent voraus gesetzt und die Markierung voll angezeigt.
0.134	https:// wird wieder unterstuetzt
0.135	Ruecksetzen fast (nicht OnTop) aller Haken und Edit Felder implementiert.
0.136	RechtsKlick ins fenster auf ein nicht anderweitig belegtes Control bzw. auf kein Control bewirkt Ruecksetzen fast (nicht OnTop) aller Haken und Edit Felder. Der Container bleibt.
0.137	Fehler bei Drives un Favoriten behoben
0.138	Haken Zeige Dateien in Zeige Inhalte umbenannt
0.139	Nicht mehr aktive Controls versteckt.
0.140	Beginner-Ansicht / Fortgeschrittenen-Ansicht via Menue | Optionen | Einstellungen waehlbar.
	Default: Beginner-Ansicht
0.142	!Fav Ordner Fehler beseitigt
0.143	Tastatur-Umleitung nach CapsLock CapsLock von Dauer-An auf zuschaltbar (Tray-Menue von TastWatch) umgestellt, da zu oft versehentlich ausgeloesst.
0.144	AutoFavorit (Default: 1 (0 ab Vers 0.196)) testweise für Button 2 und 4 implementiert, Pruefen ob durch "Gosub PlusStern" alle gewuenschte AutoFavoriten erwischt werden!
0.145	umgestellt auf EXE-freien Start bei NurExeStartErlaubt:=false
0.146	Beim schreiben ins Pfad Nr. Feld (Edit3) funkt das Skript nicht mehr dazwischen, wenn die Loesungsmenge verlassen wird. Wenn der Fokus woanders ist wird die Pfadnummer nach wie vor auf 1 gesetzt.
0.147	Log optional
0.148	Aufraeum-Arbeiten im Quelltext
0.149	einige TrayTipp's deaktiviert
0.150	Macro Ordner fehlte in der GitHub Version
)
VersionsHistorie2=
(
0.151	Holle's FileSearch.ahk bei Menue | Edit8 | DateiSuche eingebunden. (Manuel muss noch der FileSearchPath eingetragen werden)
0.152	Wenn keine ausn Datei im Data-Ordner, dann Kopie vom Skriptordner 
0.153	Default AutoPop:=false Ersatz: Tastenkombination #n	ruft OpenGuiNebenAktWin auf
0.154	
bis		alle Timer des Hauptskriptes entfernt. QuellText um ca. 2000 Zeilen gekuerzt. Die Hilfe muss noch nachgezogen werden
0.162
0.163	Bei Pfad-gefilterten Suchen musste der Dafaulwert von Edit6 (Anzahl beruecksichtigter Cache-Dateien) hochgesetzt werden. 
		Das automatische Hochsetzen und Rucksetzen ist nur bei den rechts stehenden Defaultwerten aktiv. (gewaehlt wurde 400 statt 20)
		Hierzu draengen sich spezielle Filter auf, welche die Performanz sogar erhoehen, und meist reichen: 
		Die jeweilige Suche auf die einzelnen Start-Pfade beschraenken. (in einer zukuenftigen Version vorgesehen) -> 0.167
0.164	Containermenue verschlankt und uebersichtlicher gestaltet.
0.165	Kontainer -> Container
0.166	Chinesiche Zeichen Fehler bei Erststart behoben, Ursache: Noch nicht gesetzte Variable ergab trotzdem gueltige Pfade, bei denen beliebige Dateien als Cache angesehen wurden.
0.167	Suche auf die einzelnen Start-Pfade beschraenken rudimentaer moeglich, indem im Feld Pfad-Filter die fortlaufende Nummer des Cache-Ordners eingetragen wird, ohne setzen des Filter (SuFi) Hakens.
		Beispiel-Zuordnung: 1 -> !Fav	2 -> 1_C˸►°	3 -> 2_D˸►° ...		Achtung groesser 9 wird nicht wie gewuenscht gezaehlt (Beispiel: 1 10 11 12 13 2 3 4 5 6 7 8 9) behoben -> 0.170
		Via  Menue | Start-Pfad | Uebesicht  kann der einzutragende Integer-Wert ermittelt werden -> Zeilenummer von Edit5.
		Hinweise:	- Dieser "Filter" ist ein "Vor-Filter" der durch weglassen pervormantere Ergebnisse bringt. Merkregel erst wenn der Haken gesetzt ist wirds spuerbar langsamer.
					- "Vor-Filter" ist gleich 0 deaktiviert ihn ebenso wie ein nicht Integer oder leerer Wert. 
					- ein negativer Wert schliesst nur diesen einen aus.
0.168	einige stoerende MsgBox Ausgaben hinter if Fehlersuche gestellt. Hinweise: 
		- Fehlersuche=1 kann beim Testen von Macros nuetzlich sein. Fehlersuche=0 am Macro-Ende nicht vergessen.
		- vor aufwaendigeren Macros wird momentan noch gewarnt, da (zwingende) Syntax- sowie BefehlsAenderungen nicht auszuschliessen sind.
0.169	bei jeder Gui-Groessenaenderung erhaelt Edit 2 den Fokus (ControlFocus,Edit2,ahk_id %GuiWinHwnd% am Ende von SaSize: und GuiSize: eingefuegt)
0.170	ZaehlReihenfolge von 0.167 berichtigt indem der Start-Pfad-Index bei (in Dir2Paths der Startwert fuer WurzelIndex:=100) 100 beginnt.
		Ist zwar bei erreichen der 4. Stelle wieder unschoen. Dafuer aber on the fly moeglich. 
		D.h. aber auch dass der Start-Index von 100 nur bei neuen bzw. erneuerten  Containern wirksam ist.
0.171	Hilfe grossteils ausgelagert nach %A_ScriptDir%\Hilfe\_ZackZackOrdnerHilfe.htm
0.172	Start-Pfad einzeln aktualisieren implementiert. Menue | Start-Pfad | Uebersicht		Pfad auswaehlen 	Menue | Start-Pfad | aktualisieren ... (einzeln)
0.173	Menue | Favoriten | speichern und oeffnen ueberarbeitet. NebenProdukt: Edit8 laesst sich nun Editieren ohne dass staendig die Marierung dazwischenfunkt.
0.174	Menue | Edit8 | neuer Ordner akzeptiert selbigen auch in Edit8 uebergeben. Button2 laesst auch Neue Ordner zu, wenn er an Edit8 angehaengt wird.
0.175	Menue | Macro | Muster-Dateien  aktualisiert.  Ueber Macro nachtraegliche Sortierungs-Alternativen angeboten: Sortierung nach: -StringLaenge des Pfades	-z...a	-OrnerName 
		Eventuell in zukuenftiger Version Sortierungs-Alternativen besser / komfortabler einbinden.
0.176	AutoFavorit wird nun auch unterstuetzt fuer Neue Ordner siehe 0.174
		Hinweis *c:\temp\NeuOrdnerName fuehrt nicht zu einem Stern, da der ja schon im Editier-String ist. 
		D.h. mann sollte nicht nur den neuen OrdnerName anhaengen, sondern auch den * entfernen (eleganteren weg anstreben). 
0.177	#* fuegt Favoriten vom Clipboard ein.		Favoriten werden immer ohne Suchabbruch angezeigt.
0.178	Die Anzahl der Gefundenen Pfade erscheint in Klammer, wenn bei der Suche ein Abbruch vorgekommen ist.
0.179	Button6 auch nur mit Button6.ahk (ohne Button6.exe) verwendbar.
0.180	FuehrendeSterneEntfernen() angepasst, sodass statt dem letztzen \ auch ein Tabulator verdaut wird.
0.181	Zaehler fuer SuchAbbruch, bei gefilterter Suche, zaehlt zum einen nur Funde zum anderen wie bisher gepruefte aber gegen den 100-fachen Wert.
		Dadurch entfaellt das hochsetzen von 0.163
		Dabei aufgefallene Suchunschaerfe "Hans" findet auch "H.ans" (momentan kein Plan ob dies performant aenderbar ist, [1])
		Notbehelf bei Bedarf "Hans" sowohl als Suchbegriff als auch als Filter eingeben.
		[1] eher nicht, da bei der im Skript verwendenten Suche ja nur die Dateisuche vom Betriebssystem missbraucht wird.
0.182	Markierung kann mit Tab statt letztem \ umgehen
0.183	Diverses zu Start-Pfad- und Container-Menue. 
		In WuCont koennen nun auch Verzeichnis-Links sein. 
		Somit kann der Cache von Netzlaufwerken direkt auf dem Netzlaufwerk sein. 
		Dieser ist zwar langsamer aber er Cache kann von mehreren genutzt werden.
		Dir2Paths Aktualisiert nun schon vorhandene Start-Pfade.
		D.h. waehrend des Einlesens des Neuen Caches ist der alte Cache noch uneingeschraenkt nutzbar (doppelte werden eh rausgefiltert).
0.184	Fuktion Entferne(PfadListe,ZeichenLinks,ZeilenOben) und dazugehoeriges Muster-Macro EntferneOben23Zeilen.txt bereitgestellt.
0.185	Menue Eintraege "Explorer Intern" auf "Zeige Inhalte" geaendert
		Bessere Unterstuetzung von CLSID-Ordnern
0.186	Nachbesserungen beim umschalten von der Pfadansicht zur Ie-/Explorer-Ansicht (Zeige Inhalte).
		Der Umwweg uber den Befehl b1. ist allerdings noch drinn. (vorgemerkt fuer zukuenftige Version: b1. ersetzen)
0.187	"Start-Pfade: " in der Zusatz-Zeile (Edit10) eingegeben bewirkt die Anzeige der wirksamen Start-Pfade direkt dahinter.
		Falls mal nicht aktualisiert wurde kann man rechts von "Start-Pfade: " reinschreiben, 
		dieses wird dann vom ZackZackOrdner sofort mit den aktuell wirksamen Start-Pfaden ueberschrieben.		
		Entfernt werden kann die Anzeige durch {Strg} + {a} gefolgt von {Del} oder in dem man links vom ":" löscht oder veraendert. 0.201 oder rechts loescht
		"Start-Pfade: " muss man sich nicht merken, da ein Muster-Macro dafuer ubers Menue erzeugt werden kann.
0.188	Die Up und Down-Schaltflaechen links an Edit5 sollten nun immer die ausgewaehlte Pfadnummer veraendern koennen.
		Edit5 editieren wird besser unterstuetzt. 
		Z.B. anhaengen von \NewDir in die 6. Zeile von Edit5 mit anschliessendem Rechtsklick auf die 6 links von Edit5,
		Auswahl im Kontextmenue "Neuer_Ordner", versucht den Ordner 
		Urspruenglicher-Pfad\NewDir anzulegen.
0.189	utf-16 nur noch schreibend bindend. Danke "Just Me" fuer den Tipp und fuer die vielen Weiteren Tips bzw. Hilfestellungen.
0.190	Unterprogramm ZeigePfadlisteImBrowser mit Macro zugefuegt. 
0.191	Focuse der Edits optimiert, Maus-Positionen dito. Letzteres wird ueber die Einstellungen abschaltbar werden.
0.192	Unterprogramm Button1OhneMausPos erstellt und integriert.
0.193	Die Pfadrueckgabe an den Explorer klappte manchmal bei einem Win 8 Tablett nicht.
		Nun wird diese bis zu 3 mal mit unterschiedlichen Wartezeiten versucht.
		Hinweis: Nach betaetigung von Button4 prueft das Skript, ob ein Explorer-Fenster, 
		mit den gleichen Positionen, wie die vom Skriptfenster, vorhanden ist.
		Wenn Ja wird an dieses uebergeben, wenn Nein ein neues aufgemacht.
		Mit dem Befehl "Ex" statt Button4 wird ohne Ziel-Pruefung nur die Rueckgabe eingeleitet.
0.194	Die Pfadrueckgabe an den Explorer klappte manchmal bei einem Win 8 Tablett nicht zuverlaessig.
		Nun wird diese bis zu 3 mal ohne und mit unterschiedlichen Klicks versucht.
0.195	ClsID-Ordner werden vom Skript erzeugt
0.196	AutoFavorit werden nur noch Sternlos unterstuetzt, d.h. alles was mit Button 2 bearbeitet wird, landet sternlos kopiert im !Fav Cache.
		Wichtiger jedoch:
		AutoFavorit=0 bedeutet nun ein sternloser Favorit wird beim erstellen eines neuen Ordners (der manuell eingegeben wurde) angelegt.
		Dies klappt nicht für Ordner die via Button 5 hinzukommen.
0.197	Fehlender !Fav Ordner wurde nicht immer automatisch (wenn reigeschrieben werden soll) angelegt.
		Beispiel-Button6 wurde so erweitert, dass das Anlegen eines Gegenstandes auch den passenden Favoriten anlegt.
		Dadurch wird das neue Einlesen des Start-Pfades seltener notwendig.
0.198	Sitzungs-Einstellungen auf vordermann gebracht. 
		Einstellungen.txt zu AutoEinstellungen.txt umbenennen, dass sie bei Skriptstart eingelesen wird.
0.199	HotKey [Fenster] + [Space] freigegeben. 
		HotKey [Fenster] + [#] wie Button "Ordner", nur dass vorher ggf. das letzte Explorer-Fenster aktiviert,
		oder wenn keines vorhanden, ein neues erzeugt wird.
0.200	Menue: Datei | Testumgebung erzeugen ueberarbeitet.
)
VersionsHistorie3=
(
0.201	(Enter)-Kennzeichnung der Buttons 2 u. 4 entfernt. Man sieht am dicken Rand nach wie vor welcher Button den Enter-Fokus hat.
0.202	Ordner Button magnetisch und ausgehend, wenn im Explorer-Pfad editiert wird.
		Eventuell muessen noch weitere Aussschluss-ControlClasses in die QuellZeile
			if FocussedControl contains ToolbarWindow322,ToolbarWindow323,msctls_progress321,Edit1,DirectUIHWND1
		von TastWatch.ahk aufgenommen werden.
0.203	bei "zeige Inhalte" war Uebersicht der Container und der Start-Pfade nicht moeglich.
		Vorgehen von aktualisiere Start-Pfade an aktualisiere Container angepasst.
0.204	SuperFavoriten sind ab Version 0.204 immer erreichbare, vom Container unabhaengige Favoriten. 
		Bisher wurden Favoriten mit mehrern Sternen so benannt.
		Angesprochen werden sie mit 00[Pfad-Nummer] in Edit3.
		Zurueck zur bisherigen Funktionalitaet gelangt man mit 000 in Edit3.
		Voraussetzung: Menue: Favoriten | SuperFavoriten bearbeiten wurde durchgefuhrt.
		Dadurch entsteht ein Container namens SuperFavoriten.
		Der den Ordner !Fav erhaelt, der wiederum die Datei SuperFavoriten.txt enthaelt.
		(Ein StartPfad ist in diesem Spezialcontainer nicht notwendig und nicht getestet.)
		SuperFavoriten.txt beginnt mit einer Leerzeile gefolgt von den Pfaden (pro Zeile ein (sternloser) Pfad).
		Die SuperFavoriten werden nicht sortiert in Edit5 angezeigt.
0.205	Cache loeschen ueberarbeitet.
0.206	Pfadfilter um NOT (erstes Zeichen ") ergaenzt.
		Beispiel Such-String ist 'Temp'	Pfad-Filter ist '"Temporary' 	findet c:\temp	nicht jedoch c:\Users\Default\AppData\Local\Temporary Internet Files
0.207	Zeige Inhalte von der Beginner-Ansicht entfernt. Erreichbarkeit via F7 bleibt.
0.208	Dir2Paths.ahk Fehler bei Uebergabe von einem + im anfang des Start-Prades behoben.
		z.B.: Dir2Paths.ahk C:\ProgramData\Zack\WuCont\Haupt +C:\temp\* befuellt den Cache mit gefundenen Ordnern und Dateien
		und schreibt alles in einen Cache-Ordner.
		im gegensatz zu: Dir2Paths.ahk C:\ProgramData\Zack\WuCont\Haupt ++C:\temp\* befuellt den Cache mit gefundenen Ordnern und Dateien
		und schreibt getrennt in einen Datei-Cache-Ordner und in einen Dir-Cache-Ordner und rueckt den Dateiname um Tab nach rechts, 
		sodass Ordner-Pfade von Datei-Pfaden optisch leicht unterscheidbar sind.
0.209	Funktion SaveE8E5() mit Macro SaveE8E5Demo.txt bereitgestellt. Macro SortierungKurzOben.txt sorgt fuer vollstaendige Pfad-Liste.
		Menue Macro nochmals starten entfernt, da nicht verlaesslich.
0.210	Hilfe ergaenzt
0.211	Hilfe ergaenzt SpeicherOrteHtml
0.212	Button3 ifClipboard<>FuehrendeSterneEntfernen(Edit8) Erstfunktion: Clipboard:=FuehrendeSterneEntfernen(Edit8)
		sonst wie bisher Clipboard:=Edit5 (aber nur 2.Funktion)
		Durch diese einfache Aenderung ist endlich der Logische Bruch, dass Button3 der einzige war, der mit Edit8 nichts am Hut hat, entfernt.
0.213	Lauffaehigkeit der nackten Datei SchnellOrdner.ahk unterstutzt. Die Hilfe wird dabei sehr spartanisch.
0.214	KontextMenue fuer Button4 erster Eintrag
0.215	label AutoFavoritAnzeigen eingefuegt und Hilfe zu AutoFavoriten korrigiert.
0.216	AbfrageFenster() erweitert
0.217	AbfrageFenster() erscheint statt MsgBox nach Klick auf Button5 
0.218	weitere MsgBox-Dialoge durch AbfrageFenster() ersetzt.
0.219	SuperFavoriten rechts ans Hauptmenue gebunden
0.220 bis 0.230	Favoriten komplett ueberarbeitet
0.231 bis 0.238	Quelltext aufgeraeumt, sortiert, strukturiert (es bleibt noch einiges tu tun)
0.239	IstKompilliert() implementiert
0.240	Sternlose Favoriten loeschen implementiert
0.241	FehlerSuche verbessert --> FehlerSuche() implementiert 
0.242	MinusSternClipPfade und LoeschenSternClipPfade implementiert
0.243	Container mit Leerzeichen werden unterstuetzt
0.244	Spezial-Container Start Menu implementiert.
		Direktsprung zum letzten Container via Menue oder F4
0.245	Container Start Menu erstellen wird bei jungfraeulichem ZZO-Start angeboten.
0.246	Button6 verschoben nach Button7
		Button6 wurde Run Edit8 hinterlegt.
0.247	BefehlListe: zu viele Eintraege mit QuellZeilen "Gui,1" bzw. "GuiControl" entfernt.
0.248	Der Extender wird bei neuen Favoriten nicht mehr unterschlagen.
0.249	Beschaeftigt Anzeige ueberarbeitet
0.250	Clipboard Menu eingerichtet. Zu erreichen via #v
0.251	Hintergrundfarbe des Fensters aendert sich (Haut-Farbe) wenn Container Start Menu aktiv ist.
0.252	Wenn ein anderer Container aktiv ist wird die Origialfarbe wieder hergestellt.
0.253	Die deutschen Display-Namen sind nun auch suchbar, z.B. Eingabeaufforderung, Benutzer, Systemsteuerung, Dieser PC ...
		Danke Just Me die Funktion GetDisplayName(FileOrFolder) funktioniert auf 64Bit und auf 32Bit Betriebssystemen.
0.254	Alle Links von MetroApps die sich im Ordner MetroAppLinks befinden sind auch via Container Start Menu suchbar.
		Die Links koennen via Drag and Drop von Alle Apps in den Ordner %A_AppDataCommon%\Zack\MetroAppLinks erzeugt werden.
0.255 bis 0.260 Quelltext weiter aufgeraeumt, sortiert, strukturiert (es bleibt noch einiges tu tun)
0.261	unnoetige Wartezeit beim Start-Pfad loeschen entfernt.
0.262	Favoriten speichern und oeffnen ueberarbeitet. (gespeichert wird nur noch eine Datei)
0.263	Dir2Paths liefert den bisherigen Cache-Dateinamen, wenn das Einlesen vom zusaetzlichen GetDisplayName(FileOrFolder) misslingt.
0.264	++%A_WinDir%\System32\*.msc in Start Menu aufgenommen
0.265	eigenen Cache einlesen erschwert z.B. ++c:\* liest nicht mehr C:\ProgramData\Zack\WuCont\Haupt ein.
0.266	Musik wird rudimentär unterstuetzt
0.267	Blaettern in Edit5 via {PgDn} und {PgUp} ermoeglicht
0.268	Fensterfarbe korrigiert
0.269	Andere Pixeldichten als 96DPI, sollten nun lesbar bleiben,gi 192DPI werden rudimentaer unterstuetzt.
0.270	Andere Pixeldichten als 96DPI werden besser unterstuetzt
0.271	nun kann man sogar Drag & Drop auf Edit5 Pfade testen. Die Warnmeldung ist noch vorhenden.
0.272	AbfrageFenster an variable DPI angepasst
0.273	Drag & Drop auf Edit5 Pfade Warnmeldung entfern.
0.274	File:// in Edit2 eingerichtet
0.275	fileP://  in Edit2 eingerichtet F7 schaltet nicht mehr in die interne Explorer-Ansicht sondern in die Zeige Inhalte in TextForm Ansicht.
0.276	Edit8DirName -> Edit5 eingerichtet
0.277	GetAbPos(ZeilenText,ZeilenNummer)
0.278	Die Markierung sollte nun nicht mehr zu frueh erscheinen.
0.279	[Strg] + [F7] versucht die Suche so einzustellen, dass der Vater markiert wird.
0.280	[Strg] + [Left] naeher zur Wurzel. [Strg] + [Right] weg von der Wurzel.
0.281	Menu: DirName -> Edit2 und FatherName -> Edit2 
0.282	Rueckgaengig: [Ctrl] + [z] versucht die Suche wie bei der letzten Aktualisierung (via Button1 oder F5) einzustellen.
		Mehrfach-Betaetigung kuerzer 2 Sekunden Pause wird unterstuetzt.
0.283	Verwandschaftliche Aufrufe auf existierende begrenzt.
0.284	einige Speicherstellen eingerichtet, die mit  [Ctrl] + [z]  wiederhergestellt werden koennen, 
		(unabhaengig von [F5] oder Button1, der manuellen Beauftragung dies zu tun.) 
0.285	Button2 gibt Edit8 -- aehnlich des LieblingsOrdner-Skriptes (in der AHK-Hilfe) von Sean -- ans Fenster zurueck.
		Danke Sean fuer die Vorlage. Nun funktioniert auch die Ruckgabe an Irfan-View. 
		Auch in EingabeAufforderungen kann mit Button2 das Startverzeichnis gewechselt werden
		Auch bei Exloper-Fenstern kann nun Button 2 zur Rueckgabe getestet werden.
0.286 bis 0.288	Hilfsfenster Such-Wort-Vorschlaege eingefuehrt. Beim eintippen des Suchbegriffes (Edit2) werden bis zu 9 moegliche ganze Woerter
		aus dem Cache angezeigt. Angeklickt werden sie als Suchbegriff uebernommen.
0.289	Hilfefenster an verschiedene DPI angepasst.
)
VersionsHistorie=%VersionsHistorie1%`n%VersionsHistorie2%`n%VersionsHistorie3%
return
; -------------------------------------------------------------------------------------------------------------------------
HilfeVorbereiten:
HtmlRegExilfeAngepasst=
(
<h3><a name="RegEx"></a>RegExMatch Suche</h3>
<p>Mit dem Haken <i>RegEx</i> unter dem Filter-Feld ist der RegEx-Filter erreichbar.
An dieser Stelle muss spaetestens der Unterschied der Felder <i>Suche</i> bzw. <i>Filter</i> erklaert werden:<br>
<i>Suche</i> sucht nur im OrdnerName, ist teilweise vorberechnet, (hier ist zumindest momentan kein RegEx direkt* moeglich) (*indirekt als Vorauswahl via Eingbe von ")" kann auch hier RegEx verwendet werden.)<br>
<i>Filter</i> filtert den OrdnerName inklusive Pfad, ist nicht vorbrechnet, kann optional  RegEx-filtern.<br>
</p>
<p>Inwischen ist die RegExWatch-Hilfe von der Standart-AutoHotKey-Hilfe, so gut geworden, dass ich Diese empfehle.
Die folgenden Zeilen jedoch fürs schnelle parat haben drinn lasse. Die Ausgesuchten Beispiele zu RegEx unten gehen jedoch speziell auf RegEx in ZackZackOrdner ein, sodas dies fuer Interessierte auch empfohlen wird.</p>
<p>
Folgender Text zu <i>RegEx</i> ist 1:1 uebernommen aus der Hilfe zu <i>SucheDateien</i>. d.h. dass hier nicht relevant ist, was zu folgenden Begriffen  erwaehnt wird:<br>
 - ersetzen<br>
 - $1<br>
 - $2<br>
 - $3<br>
 - $4<br>
</p>
)
HtmlRegExilfeVonSucheDateien=
(
<pre>
------------------------------------------------- uebernommen aus Hilfe zu Suche Dateien ---------------------------------------------
Die Steuerzeichen:
	\.*?+[{|()^$
benötigen davor ein \ wenn´s normale Zeichen sein sollen
WildCards:
. 	repräsemtiert genau ein Zeichen
.*	repräsemtiert 0 bis viele beliebige Zeichen
Bedeutung der Steuerzeichen:
*	Das zeichen vor * darf 0 bis viele Zeichen mal vorkommen
?	Das zeichen vor ? darf sein, muss aber nicht
+	Das zeichen vor + kann mehrfach vorkommen
^	Das nachfolgende Zeichen muss am Beginn stehen
$	Das zeichen vor $ muss am Ende stehen
(...|...)	oder	z.B. Ger(ae|ä)t	findet Gerät und Geraet
[...]	einzelne Zeichen in der Klammer müssen vorkommen
i)	groß/klein egal
Beispiele:
i)(gerd|Hugo|GeKo)	findet wenn enthält	gerd oder hugo oder geko	groß/klein egal
i)(Manual|Handbuch|Beschreibung|Einf(ü|ue)hrung)	Ineinanderschachtelung möglich
^ItilZertHugo\.TIF$	findet exakt	ItilZertHugo.TIF
i)^ItilZertHugo\.TIF$	findet 	ItilZertHugo.TIF	groß/klein egal
</pre>
)
HtmlHaftungsausschluss=
(
<h2>Haftungsausschluss</h2> 
<p>Es wird keinerlei Haftung für Schäden 
die durch dieses Programm entstehen können übernommen.
Die Benutzung erfolgt auf eigene Gefahr!</p>
<p>Besondere Vorsicht ist bei Befehlsdateien unbekannter Herkunft geboten.</p>
)
return
; -------------------------------------------------------------------------------------------------------------------
Hilfe:
gosub HilfeVorbereiten
IfExist %A_ScriptDir%\Hilfe\FensterElemente.htm
	FileRead, FensterElemente, %A_ScriptDir%\Hilfe\FensterElemente.htm
IfExist %A_ScriptDir%\Hilfe\TastenTabelle.htm
	FileRead, TastenTabelle, %A_ScriptDir%\Hilfe\TastenTabelle.htm
IfExist %A_ScriptDir%\Hilfe\Suche.htm
	FileRead, SucheHtml, %A_ScriptDir%\Hilfe\Suche.htm
IfExist %A_ScriptDir%\Hilfe\ContainerStartPfade.htm
	FileRead, ContainerStartPfade, %A_ScriptDir%\Hilfe\ContainerStartPfade.htm
IfExist %A_ScriptDir%\Hilfe\SpeicherOrte.htm
	FileRead, SpeicherOrteHtml, %A_ScriptDir%\Hilfe\SpeicherOrte.htm
HTML1=
(
<html>
<head>
%FensterElemente% 
%TastenTabelle%
<title>ZackZackOrdner Hilfe</title>
<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1">
</head>
<body bgcolor="#FFFFFF" text="#000000">
<IMG SRC="ZackZackFensterBeispiel.jpg"  ALT="Fenster Beispiel" ALIGN=RIGHT>
<h1>ZackZackOrdner Hilfe</h1>
<h2>Wichtige hinweise</h2>
Die TastenKombination [Win] + [z] oder + [n] oder + [#] zeigt das ZackZackOrdner-Fenster an ([n] versucht neben das bisher aktive Fenster zu gehen, bei [#] wird die gleiche Position eingenommen, [z] aktiviert ohne Positionsaenderung), diese Hotkeys sind immer Wirksam, egal welches Programm aktiv ist. Fast alle anderen Hotkeys, wie z. B. F4 der das Fenster wieder minimiert, wirken nur beim aktivierten Fenster<br>
<br>
Das Skript kann schon verwendet werden, solange noch der Cache befuellt wird.<br>
<br>
Favoriten sind technisch gesehen zusaetzliche Kopien, die wegen des Sterns ganz links beim Sortieren nach vorne kommen. D.h. Favoriten sind doppelt vorhanden: die beim Einlesen erzeugte sternlose Variante, sowie die Bewertete Variante. <br>
Es koennen auch mehrere Favoritensterne pro Eintrag fuer wichtigere Favoriten eingegeben werden.<br>
Schnell erreichbare containerunabhaengige SuperFavoriten werden spaeter noch beschrieben.<br>
<br>
Bei sehr kurzen Suchstrings kann das Ergebnis unvollstaendig sein, erkennbar an der Zahl in Klammern des Feldes gefundene Pfade.<br>
<br>
Befehlsdateien nicht vertrauenswuerdiger Herkunft bieten ein Gefaerdungspotential, vergleichbar einer *.BAT Datei, jedoch nur wenn sie eingelesen werden.<br>
D.h. nur vertrauenswuerdige Befehldateiten einspielen.<br>
<br>
)
HTML2=
(
%SucheHtml%
%ContainerStartPfade%
%SpeicherOrteHtml%
)
loop 10
{
	Index:=A_index+5
	FileRead, ButtonThisHtmlInhalt, % A_ScriptDir "\Button" Index ".htm"
	Button%Index%HtmlInhalt:=ButtonThisHtmlInhalt
}
TastenHtml=
(
<h2>Tastatur-Bedienung</h2>
<h2><a href="%A_ScriptDir%\Hilfe\_ZackZackOrdnerHilfe.html">Diese Hilfe ist Umgezogen</a></h2>
Der hier gebliebene Rest wird Grossteils auch noch umziehen.<br>
Dynamische Dinge mit Bezug auf die lokale PC-Umgebung werden hier bleiben.<br>
<br>
Das heist, das Folgende kann beliebig veraltet sein, aber trotzdem eventuell weiterhelfen.<br>
<br>
<br>
Das Programm hat eine maechtige Tastaturbedienung.
Voraussetzung: TastWatch muss gestartet (geschieht automatisch kurz nach Programmstart) und die Caps-Caps-Ueberwachung aktiviert (im Tray-Menue von TaskWatch oder durch Eingabe an beliebiger Stelle von "CapsspaCon ") sein und noch laufen.<br>
MerkHilfe:<br>
Caps + Caps[seitenverkehrt] + on + [Leerzeichen] --> Caps-Caps-Ueberwachung aktivieren<br>
Caps + Caps[seitenverkehrt] + off + [Leerzeichen] --> Caps-Caps-Ueberwachung deaktivieren<br>
Eine Kurze Einfuehrung erhaelt man via <br>
Menue | Macro | Befehlsliste <br>
oder  <br>
Caps Caps ll Tab<br>					
dieserf2: Text erscheint auch an die Hilfe angehaengt, wenn <br>
Caps Caps hilfe Tab<br>		
folgt.<br>	
Caps ist die Taste um Dauer-Grosschreibung ein oder auszuschalten.
Caps- und die Tabulatortaste befinden sich beide auf deutschen Tastaturen unterhalb der Esc Taste links oben. Alle Tasten werden nacheinander gedrueckt. <br>
Hinweis: die meisten Befehle koennen so auch eingegeben werden, ohne dem Aktiven Fremdprogramm den Fokus zu nehmen, d.h. ohne es zu unterbrechen, d.h. auch ohne Markierungen oder Sonstiges zu verlieren.<br>
<h2>Spezifische Buttons</h2>
ZackZackOrdner unterstuetz in der oberen Buttonreihe bis zu 5 weitere Buttons die je nach Gusto und Programmierkenntnissen funktionalisiert werden koennen.
Eine Leerdatei im Skriptverzeichnis mit dem Namen Button#.ahk (# ist durch 6,7,8,9...,10 zu ersetzen) genuegt um Diesen sichtbar zu machen.
Die Funktionalitaet kommt natuerlich erst mit Inhalt.<br>
Uebergabe-Parameter sind:<br>
Edit8<br>
Edit10<br>
Weitere Daten koennen mit der Befehls-Schnittstelle ausgetauscht werden.<br>
Mit Button#.Txt laesst sich der neue Buttton einfach beschriften.<br>
<br>
Bitte wenn sinnvoll folgende Regeln einhalten: <br>
 - In Feld 10 ist | wie Zeilenschaltung zu werten.<br>
 - HilfeDatei Button#.htm ins Skript-Verzeichnis stellen (Diese erscheint dann ein paar Zeilen Weiter)<br>
 %Button6HtmlInhalt%
 %Button7HtmlInhalt%
 %Button8HtmlInhalt%
 %Button9HtmlInhalt%
 %Button10HtmlInhalt%
 %Button11HtmlInhalt%
 %Button12HtmlInhalt%
 %Button13HtmlInhalt%
 %Button14HtmlInhalt%
 %Button15HtmlInhalt%
<h2>Tips und Tricks</h2>
Dieser Absatz ist Fuer PowerUser gedacht.<br>
Drag and Drop von Explorer-Dateien auf das ZackZackOrdner-Fenster bewirkt Aktionen, abhaengig vom fallengelassen Ort.<br>
Der Fallengelassene Ort besteht aus Fallengelassenem Control und momentan nur bei Edit5, den verwendeten Koordinaten.<br>
Jedes sichtbare Objekt im ZackZackOrdner-Fenster entspricht einem Control:<br>
 - die statischen Texte<br>
 - die Buttons inklusive ihrer Beschriftung<br>
 - die Edit-Felder<br>
 - die Haken inklusive ihrem Text<br>
 Wird kein Ckontrol getroffen, wird gewertet als waere Edit8 getroffen. Was weiterhin bewirkt dass die ankommenden Dateien zum Pfad von Edit kopiert oder verschoben werden.<br>
 Wird eine Zahl der Zahlen-Spalte links von den Pfaden von Edit5 getroffen, wird dahin kopiert oder verschoben.<br>
 Ist bei obigen Aktionen Quell und Zielpfad identisch wird eine Version (Kopie mit anhaengen von Zeitstempel) erzeugt.
 Es folgt eine Auswahl daraus moeglicher aktionen:<br>
  - Drag and Drop nach Edid8 ---> kopieren oder verschieben nach Edit8-Pfad<br>
  - Drag and Drop nach Statischer Text 7 ---> kopieren oder verschieben nach Pfad vom 7. Eintrag von Edit5<br>
  - Drag and Drop nach Statischer Text 3 ---> kopieren oder verschieben nach Pfad vom 3. Eintrag von Edit5<br>
  - ...<br>
Ebenso ist es moeglich das selbe aus dem eigenen Fenster heraus zu tun nach dem vorher der Haken zeige Dateien betaetigt wurde.<br>
Man muss sich dazu allerdings vor setzen des Hakens den momentan gewuenschten Zielpfad-Ort merken, der auch unsichtbar noch gueltig ist. <br>
D.h. QuellPfad-Ordner mit Nr. Wahl auswaehlen, ZielPfad-Ordner-Nummer merken, mittels Haken zeige Dateien oder F7 QuellPfad-Ordner anzeigen, Drag and Drop vom Internen Explorer zur gemerkten Nummer erzeugt besonders bildschirmplatz-spaarsame und effiziente Kopien bzw. Verschiebungen. Mittels Favoriten sind so auch uebersichtlich manuelle Ziel-Verteiler moeglich.<br>
Wichtiger hinweis: in der ZackZackOrdner-eigenen Explorer-Ansicht funktionieren nur Maus-Aktionen, die Tasten wirken auf ZackZackOrdner als waere die  Explorer-lose-Ansicht also die Normal-Ansicht vorhanden.<br>
Dies ist wichtig, wenn man das gerade gelernte von <br>
 + Drag and Drop +<br>
auf <br>
 + Dateien ins Cipboard bringen (via Mausbedienung der ZackZackOrdner-eigenen Explorer-Ansicht) und nach Ziel-Pfad-Aenderung (z.B. mit den Pfeiltasten) und abschliessendem Klick auf Button5 zum Kopieren / Verschieben +<br>
uebertraegt und somit eine weitere alternative Ausfuehruns-Methode fuer soeben gezeigtes erhaelt.<br>
<br>
Weitere Drag and Drop Ziele Folgen demnaechst z.B. die Buttons...<br>
<br>
<br>
%Button6HtmInhalt%
<br>
Fortsetzung folgt<br>	
z.B. zu:<br>	
<pre>
 - Favoriten<br>
 - BefehlsDateien und sonstige interne Dateien muessen Unicode Formatiert sein, sonst bekommt man viele cinesisch aussehnede Zeichen zu sehen.<br>
 - GuiDropFiles (Aktion ist von der Loslasstelle abhaengig)<br>	
 - IndividualMenue bei Rechtsklick auf nicht Edit Controls. (Speziell auf die Zahlen der Pfadnummerierung)<br>
 - Einbindung in andere Programme. z.B. OrdnungsDB<br>	
 </pre>
<h2>Befehle</h2>
Im Prinzip ist fast jeder Klick auf einen Menue-Eintrag ein Befehl. Hier Sind jedoch die sich aus Buchstaben zusammensetzenden Befehle gemeint.
Einfaches lostippen im Suchfeld sind also auch schon Befehle, sie veraendern ja auch das Ergebnis.
Diese sind hiermit erwaehnt und auch nicht oder nur am Rande Gegenstand dieses Absatzes.<br>
Spezielle Eingaben, die einem Befehlsstring entsprechen sind hier gemeint.
Diese Eingaben sind nicht im zentralen Suchfeld moeglich, aber z.B. im Feld rechts davon.
Wenn Sie dort einen Befehl eingeben und mit einem Punkt abschicken, 
versucht das Skript einen sinnvollen Befehl daraus abzuleiten.<br>
Geben Sie <code>ll.</code> gefolgt von <code>Hilfe.</code> ein (den . jeweils am Ende nicht vergessen),
dann sollte die Hilfe mit einer aktuellen Befehlsliste neu zusammengestellt und angezeigt werden.<br>
Wem da Aehnlichkeiten zur Tastatur-Bedienung oben auffallen, dem sei gesagt. dass nur die Eingabemethode sich verandert hat.<br>
Die Tastatur-Bedienung ist in jedem Fenster moeglich, benoetigt jedoch die Start-Sequenz:<br>
Caps Caps<br>
Die Eingabe im Befehlsfeld  benoetigt:<br>
den Fokus, <br>
kann dann aber sofort beginnen.<br>
Beim Befehl unterscheidet sich nichts.<br>
Die Schluss-Sequenz unterscheidet sich wieder, hier ist die Taste: <br>
Tab <br>
beziehungsweise das Zeichen:<br>
. <br>
notwendig.<br>
Der Vollstaendigkeit zuliebe sei noch erwaehnt, dass in Befehlsdateien°/-Variablen (° einzulesen via Menue | Macro | starten...),<br>
jede neue Zeile der Start-Sequenz entspricht,<br>
der ZeilenInhalt dem Befehl<br>
und das Zeilenende der Schluss-Sequenz entspricht.<br>
Oder einfacher ausgedrueckt, dass je Zeile ein Befehl erwartet wird.<br>
<br>
Die Befehle sind nicht auf ZackZackOrdner beschraenkt<br>
<code>e8notepad</code><br>
<code>Edit8Oeffnen</code><br>
startet z.B. den Betriebssystems-Editor.<br>
Deshalb nochmals der Hinweis: <b>nur vertrauenswuerdige Befehlsdateien verwenden</b><br>
<h3>BefehlsListe (HotKeyListe)</h3>
<pre>
%LabelList%
</pre>
</body>
)
HtmlRegExHilfeZack=
(
<h3>Ausgesuchte Beispiele</h3>
<p>
Zur Erinnerung der Filter filtert im kompletten Pfad waehrend die Suche auf den OrdnerName beschraenkt ist.
Fuer die RegEx Filterung muessen beide Haken unterm Filter-Feld gehakt sein.
<p>
<table border="1">
  <tr> 
    <td><b>RegEx Suchfilter</b></td>
    <td><b>Wirkung</b></td>
     <td><b>&nbsp;</b></td>
  </tr>
  <tr> 
    <td><pre>i)Heisse[^\\]*$</pre></td>
    <td>entspricht der Standart -Suche nach <samp>Heisse</samp></td>
    <td>ist jedoch um Potenzen langsamer. Dies liegt daran wie intern bei der Suche vorgegangen wird. Bei Heisse in der Suche werden nur die Objekte die Heisse enthalten richtig angefasst. Bei Heisse im Filter muss alles durchgenudelt werden und dass noch mit einem wesentlich aufwendigeren Algoritmus.<br> <code>[^\\]*</code> bedeutet beliebig haeufiges vorkommen von nicht \<br><code>$</code> bedeutet Zeilenende. </td>
  </tr>
  <tr>
    <td><pre>i)Bilder[^\\]*$|Filme[^\\]*$</pre></td>
    <td>findet Bilder oder Filme im Ordnername</td>
    <td>An diesem Beispiel kann anschaulich gezeigt werden, dass ein zusaetzlicher Eintrag im Suche-Feld von <code>Bilder</code> bei kleinen Abbruch-Zahlen sogar mehr Ergebnisse (allerdings nur noch diejenigen die <code>Bilder</code> enthalten) bringen koennen. Dies ist leicht erklaerbar weil <pre>i)Bilder[^\\]*$|Filme[^\\]*$</pre> alleine gegen die Abbruchbedingung stoesst. 
	Mit <code>Bilder</code> werden jedoch nur relevante Suchstellen bearbeitet und die Abbruchstelle wird erst spaet oder garnicht erreicht.</td>
  </tr>
  <tr> 
    <td><pre>i)^\**.˸\\boot.*$|^\**.:\\boot.*$</pre></td>
    <td>findet nur wenn der erste Unterordner eines Drives mit Boot beginnt.</td>
    <td><code>i)^\**.:.boot.*$</code> Die rechts von | stehende Alternative reicht aus, da hier die Unschaerfe mit dem hochgestellten Doppelpunkt nicht wirksam wird. Siehe auch unter Bekannte Fehler Item <i>vom Suchfilter werden die Drives solo ...</i> </td>
  </tr>
  <tr> 
    <td><pre>i)^\**.˸\\boot\\.*$|^\**.:\\boot\\.*$</pre></td>
    <td>findet nur wenn der erste Unterordner eines Drives Boot lautet.</td>
    <td>Die 2. Alternative reicht auch hier aus.</td>
  </tr>
  <tr> 
    <td><pre>i)^\**.:\\.*boo.*$</pre></td>
    <td>entspricht der Standart -Filterung nach <samp>boo</samp></td>
    <td>Oder schlicht <code>i)boo</code> <br>Hinweis: RegEx ist etwas langsamer.</td>
  </tr>
  <tr> 
    <td><pre>i)^\**.:\\Progra</pre> bei gleichzeitiger Suchfeldeingabe: Temp</td>
    <td>Findet mindestens die Temp und die Temp<font size="-2">lates</font> UnterOrdner von Progra<font size="-2">m Files</font> und Progra<font size="-2">mData</font> </td>
    <td><code>^</code> vom Zeilenanfang, ist hier nicht zwingend<font size="-2">, weil : nur nach eine Drive vorkommt, sollte jedoch das Filtern beschleaunigen.</font><br><code>\**</code> wegen eventuellen Favoriten Sternen<br><code>.:</code> fuer den Drive inklusive :<br><code>\\</code> fuer den Backslash</td>
  </tr>
</table>
)
HtmlReserve=
(
%A_AppData%\%ScriptNamneOhneKlammer%.awpf<br>
%ScriptFullPathOhneKlammer%.%A_ComputerName%.awpf<br>
%ScriptFullPathOhneKlammer%.%A_UserName%.awpf<br>
%ScriptFullPathOhneKlammer%.awpf<br>
koennen OrdnerPfade fuer den Skriptstart eingetragen werden.<br>
)
gosub VersionsHistorieEinlesen
Html:=Html1 HTML2 TastenHtml HtmlRegExilfeAngepasst  HtmlRegExilfeVonSucheDateien HtmlRegExHilfeZack HtmlHaftungsausschluss	"<pre>VersionsHistorie`r`n`r`n"	VersionsHistorie "</pre>"	"<pre>Bekannte Fehler`r`n`r`n" BekannteFehler	"</pre>" ; Hilfe Zusammensetzen
FileDelete,%ScriptFullPathOhneKlammer%.htm
FileAppend,%HTML%,%ScriptFullPathOhneKlammer%.htm,utf-16
if ZackZackOrdnerLogErstellen
	ThreadUeberwachungLog(A_LineNumber-1,A_ThisHotkey,A_ThisLabel,A_ThisFunc,A_ThisMenu,A_ThisMenuItem,A_ThisMenuItemPos)
run, %ScriptFullPathOhneKlammer%.htm
if ZackZackOrdnerLogErstellen
	ThreadUeberwachungLog(A_LineNumber-1,A_ThisHotkey,A_ThisLabel,A_ThisFunc,A_ThisMenu,A_ThisMenuItem,A_ThisMenuItemPos)
return
; < / #################################################  H i L f e  ############################################################# >
; ===================================================================================================================================
; < #################################################### V o r l a g e n ########################################################## >
; < ########################################### Vorlage fuer Cache-Loops ################################################## >
MomentaneWortListeErzeugen:
MomentaneWortListe:=
Loop,Files,%SkriptDataPath%\*,D
{
	Loop,Files,%A_LoopFileLongPath%\*.txt,F
	{
		MomentaneWortListe:=MomentaneWortListe CrLf SubStr(A_LoopFileName,1,-4)
	}
}
StringTrimLeft,MomentaneWortListe,MomentaneWortListe,2
return
; < / ######################################### Vorlage fuer Cache-Loops ################################################## >
; < #################################################### V o r l a g e n ########################################################## >
FehlerSuchEinfuehrung:
; links sind die Grundlagen,									rechts die FunktionsAufrufe FehlerSuche(), die zur Anzeige fuehren.
FehlerAnzeigeMerker:=FehlerAnzeige								; wird nur fuer dieses Beispiel benoetigt, falls ein Log aktiv ist.
FehlerAnzeige=Fehler.Log,MsgBox,ToolTip								; was soll ausgegeben werden
; FileDelete,%A_ScriptFullPath%.Fehler.Log						; neues Logfile anfangen	; ######### nicht vergessen, wenn nicht fortlaufend gelogt werden soll ########
A:="Hallo Welt`r`n1234567890abcdefghijklmnopqrstuvwxyz`r`nABCDEFGHIJKLMNOPQRSTUVWXYZ "		,FehlerSuche(A_LineNumber)	; gibt nur die Quellzeile aus
B:="All"														,FehlerSuche(A_LineNumber)	;	"
StrLenSum:=StrLen(a)+StrLen(B)									,FehlerSuche(A_LineNumber)	;	"
; obige Rechenwerte bleiben erhalten wenn jeweils ne ß-Var zugewiesen Wird
(ß1:=StrLenSum):=(ß2:=StrLen(A))+(ß3:=StrLen(B))				,FehlerSuche(A_LineNumber,ß1,ß2,ß3)		; gibt die Quellzeile und die 3 ß-Variablen aus
; aber die (Teil-)Ergebnisse sind ausgebbar:
; MsgBox % ß1 "	" ß2 "	" ß3
; dies gilt auch fuer Bedingungen:
if (ß1:=((ß2:=a b) <>"")) 										,FehlerSuche(A_LineNumber,ß1,ß2)		; FehlerSuche() wird aufgerufen egal wie die Antwort der IF-Bedingung ist!
; bzw. vorige Zuweisung noch detailierter
	(ß1:=StrLenSum):=(ß2:=StrLen(ß3:=A))+(ß4:=StrLen(ß5:=B))	,FehlerSuche(A_LineNumber,ß1,ß2,ß3,ß4,ß5)
; MsgBox % ß1 "	" ß2 "	" ß3 "	" ß4 "	" ß5
StrLenSum:=StrLen(a)+StrLen(B)									,FehlerSuche(-A_LineNumber,"StrLenSum=",StrLenSum,"a=",a,"b=",b)	; Aufruf-Alternative
run, %A_ScriptFullPath%.Fehler.Log
FehlerAnzeige:=FehlerAnzeigeMerker
ToolTip,,,,19															; 
return
FehlerSuche(QuellLineNumber,ß1="4711",ß2="4711",ß3="4711",ß4="4711",ß5="4711",ß6="4711",ß7="4711",ß8="4711",ß9="4711",ß10="4711",ß11="4711",ß12="4711",ß13="4711",ß14="4711")
{
	global FehlerAnzeige, FehlerAnzeigeMaxStrLen
	if (FehlerAnzeige="")
		return
	if FehlerAnzeigeMaxStrLen is not Integer
		FehlerAnzeigeMaxStrLen:=40
	if QuellLineNumber is not Integer
	{
		MsgBox, 262160, Ubergabe-Fehler, Die 1. Funktions-Uebergabe-Variable`n%QuellLineNumber% `nmuss die QuellZeilenNummer sein!`n`nAbbruch
	}
	AnzeigeVarNameVar:=false
	if (QuellLineNumber < 0)
	{												; Anzeige-Form  VarName=Var  erkannt.
		AnzeigeVarNameVar:=true
		QuellLineNumber:=-QuellLineNumber			; funktionierte auch ohne diese Zeile, will mich aber nicht drauf verlassen!
	}
	KnappHalbe:=FehlerAnzeigeMaxStrLen/2-3
	Ausgabe=
	Loop, 99
	{
		if (ß%A_Index%=4711)
			break
		if(StrLen(ß%A_Index%)>FehlerAnzeigeMaxStrLen)
			ß%A_Index%:=SubStr(ß%A_Index%,1,KnappHalbe) " ... " SubStr(ß%A_Index%,-KnappHalbe)
		if AnzeigeVarNameVar
		{
			if(mod(A_Index,2)=1)
				VarsRueck.=ß%A_Index% 
			else
				VarsRueck.=ß%A_Index% A_Tab
		}
		else
			VarsRueck.=ß%A_Index% A_Tab
	}
	StringTrimRight,VarsRueck,VarsRueck,1
	FileReadLine,QuellZeile, %A_ScriptFullPath%,QuellLineNumber
	Pos:=InStr(QuellZeile,"FehlerSuche")
	if (Pos=0)
		Pos=
	QuellZeile:=RTrim(SubStr(QuellZeile,1,Pos-2))
	StringReplace,VarsRueck,VarsRueck,`r,«,all
	StringReplace,VarsRueck,VarsRueck,`n,▼,all
	if(ß1<>4711 and not AnzeigeVarNameVar)
		Pfeil:="ß1 ß2 ... ->	"
	if(ß1<>4711 and AnzeigeVarNameVar)
		Pfeil:="Vars  ... ->	"
	Ausgabe:="Line	" QuellLineNumber "	" QuellZeile "	" Pfeil "	" VarsRueck
	if(InStr(FehlerAnzeige,"Fehler.Log"))
		FileAppend,% Ausgabe "`r`n", %A_ScriptFullPath%.Fehler.Log,utf-16
	if(InStr(FehlerAnzeige,"ToolTip"))
		ToolTip,% Ausgabe,,,19
	if(InStr(FehlerAnzeige,"MsgBox"))
		MsgBox % Ausgabe
	return
}
BeschaeftigtAnzeige(BeschZaehler)
{
	global beschaeftigt
	static SollZaehler:=0
	SollZaehler+=BeschZaehler
	if (SollZaehler=1)
		gosub BeschaeftigtAnf
	else if (SollZaehler>1)
	{
		; Pruefung ob an
	}
	else if (SollZaehler=0)
		gosub BeschaeftigtEnd
	else if (SollZaehler<0)
	{
		ListLines
		MsgBox %A_LineNumber%	Nicht erwarteteter Skriptzweig	BeschaeftigtZaehler= %SollZaehler%
		SollZaehler:=0
	}
	return beschaeftigt
}

DirName2Edit2:
SuchVerlauf()
Edit8Vorher:=Edit8
Edit8Sternlos:=FuehrendeSterneEntfernen(Edit8)
SplitPath,Edit8Sternlos,,Eit8Dir,,Edit8Name
; if (Edit8Name<>"")
FileGetAttrib,FileDirektAttribute,% FuehrendeSterneEntfernen(Edit8)
Edit1:=
gosub Edit1Festigen
if(InStr(FileDirektAttribute,"D"))

	Edit2:=Edit8Name
else
{
	Edit2:=Eit8Dir
	SplitPath,Eit8Dir,,,,Eit8DirName
	Edit2:=Eit8DirName
}
gosub Edit2Festigen
Edit3:=1
gosub Edit3Festigen
sleep 40
Gefunden:=false
loop,50
{
	sleep 4
	if(Edit8Vorher=Edit8)
	{
		Gefunden:=true
		break
	}
	gosub Down1
}
if not Gefunden
{
	Edit3:=1
	gosub Edit3Festigen
}

return
; BackSpace::
Control & F7::
FatherName2Edit2:
gosub NormalAnzeige
SuchVerlauf()
Edit8Sternlos:=FuehrendeSterneEntfernen(Edit8)
SplitPath,Edit8Sternlos,,Eit8Dir,,Edit8Name
; if (Edit8Name<>"")
FileGetAttrib,FileDirektAttribute,% FuehrendeSterneEntfernen(Edit8)
Edit1:=
{
	Edit2:=Eit8Dir
	SplitPath,Eit8Dir,,,,Eit8DirName,Eit8Drive
	if(Eit8DirName<>"")
		Edit2:=Eit8DirName
	else
		Edit2:=Eit8Drive
}
gosub Edit2Festigen
Edit3:=1
gosub Edit3Festigen
sleep 40
Gefunden:=false
loop,50
{
	sleep 4
	if(Eit8Dir=Edit8)
	{
		Gefunden:=true
		break
	}
	gosub Down1
}
if not Gefunden
{
	Edit3:=1
	gosub Edit3Festigen
}
return
Ctrl & Left::
FatherFilePattern2Edit2:
gosub NormalAnzeige
SuchVerlauf()
Edit8Sternlos:=FuehrendeSterneEntfernen(Edit8)
FileGetAttrib,FileDirektAttribute,% Edit8Sternlos
; if(InStr(FileDirektAttribute,"D"))
; 	Edit8Dir:=Edit8Sternlos
; else
	SplitPath,Edit8Sternlos,,Edit8Dir,,Edit8Name
; FileGetAttrib,FileDirektAttribute,% FuehrendeSterneEntfernen(Edit8)
Edit1Vor:=Edit1
Edit1:=
{
; MsgBox % Edit8Dir
	; Edit2:=Eit8Dir
	; SplitPath,Eit8Dir,,,,Eit8DirName,Eit8Drive
	SplitPath,Edit8Dir,,Eit8DirDir,,Eit8DirName,Eit8Drive
	if(Eit8DirDir<>"")
	{
		IfExist %Eit8DirDir%
			Edit2:=FilePatternKenner Eit8DirDir "\*.*,DF"
		else
		{
			Edit1:=Edit1Vor
			return
		}
	}
	else
	{
		IfExist %Eit8Drive%
			Edit2:=FilePatternKenner Eit8Drive "\*.*,DF"
		else
		{
			Edit1:=Edit1Vor
			return
		}
	}
}
gosub Edit2Festigen
Edit3:=1
gosub Edit3Festigen
return



ctrl & z::
if (A_TickCount-LastSuchLogTime>2000)
{
	SuchVerlaufSchritte:=-1
}
else
{
	--SuchVerlaufSchritte
}
LastSuchLogTime:=A_TickCount

SuchVerlauf(SuchVerlaufSchritte)
return
SuchVerlauf(ZeilenNumer="")
{
	global Edit1,Edit2,Edit3,Edit6,Edit7,SuFi,RegEx
	static LogLineNumber:=1,SuchLogPath:=A_AppData "\Zack\SuchLog.txt",LastSuchLogZeile
	; ToolTip % ZeilenNumer
	if(LogLineNumber=1)
		FileDelete,%SuchLogPath%
	
	if(ZeilenNumer="")
	{
		SuchLogZeile:= Edit1 A_Tab Edit2 A_Tab Edit3 A_Tab Edit6 A_Tab Edit7 A_Tab SuFi A_Tab RegEx
		if(LastSuchLogZeile<>SuchLogZeile)
		{
			if Fehlersuche
				ToolTip,% LastSuchLogZeile "`r`n"	SuchLogZeile
			LastSuchLogZeile:=SuchLogZeile
			FileAppend,%SuchLogZeile%`r`n,%SuchLogPath%
			if ErrorLevel
				return 0
			else 
			{
				++LogLineNumber
				return LogLineNumber
			}
		}
		else
			LastSuchLogZeile:=SuchLogZeile

	}
	else if(ZeilenNumer<0)
	{
		FileReadLine,SuchLogZeile,%SuchLogPath%,LogLineNumber+ZeilenNumer
	}
	else
	{
		FileReadLine,SuchLogZeile,%SuchLogPath%,LogLineNumber-ZeilenNumer
	}
	; ToolTip % SuchLogZeile
	StringSplit,ZeilenElement,SuchLogZeile,%A_Tab%
	Edit1:=ZeilenElement1
	gosub Edit1Festigen
	Edit2:=ZeilenElement2
	gosub Edit2Festigen
	Edit3:=ZeilenElement3
	gosub Edit3Festigen
	Edit6:=ZeilenElement4
	gosub Edit6Festigen
	Edit7:=ZeilenElement5
	gosub Edit7Festigen
	SuFi:=ZeilenElement6
	gosub SuFiFestigen
	RegEx:=ZeilenElement7
	gosub RegExFestigen
	return
}

Edit82AWin:
; abgewandeltes Script von Sean Quelle war FavoriteFolder.ahk aus der Hilfe
; Danke Sean
sleep 500
WinGet, f_window_id, ID, A
WinGetClass, f_class, ahk_id %f_window_id%
if f_class in #32770,ExploreWClass,CabinetWClass  ; Dialog or Explorer.
	ControlGetPos, f_Edit1Pos,,,, Edit1, ahk_id %f_window_id%
if f_class in #32770,ExploreWClass,CabinetWClass  ; Dialog or Explorer.
{
	if f_Edit1Pos =  ; The control doesn't exist, so don't display the menu
		return
}
; else if f_class <> ConsoleWindowClass
;	return ; Since it's some other window type, don't display menu.
; Otherwise, the menu should be presented for this type of window:
; Menu, Favorites, show
; return

; f_OpenFavorite:
; Fetch the array element that corresponds to the selected menu item:
; StringTrimLeft, f_path, f_path%A_ThisMenuItemPos%, 0
Edit8Sternlos:=FuehrendeSterneEntfernen(Edit8)

f_path:=Edit8Sternlos
if f_path =
	return
if f_class = #32770    ; It's a dialog.
{
	if f_Edit1Pos <>   ; And it has an Edit1 control.
	{
		; Activate the window so that if the user is middle-clicking
		; outside the dialog, subsequent clicks will also work:
		WinActivate ahk_id %f_window_id%
		; Retrieve any filename that might already be in the field so
		; that it can be restored after the switch to the new folder:
		ControlGetText, f_text, Edit1, ahk_id %f_window_id%
		ControlSetText, Edit1, %f_path%, ahk_id %f_window_id%
		sleep 40
		ControlSend, Edit1, {End}{Space}{Enter}, ahk_id %f_window_id%
		; Send {Enter}
		Sleep, 200  ; It needs extra time on some dialogs or in some cases.
		ControlSetText, Edit1, %f_text%, ahk_id %f_window_id%
		return
	}
	; else fall through to the bottom of the subroutine to take standard action.
}
else if f_class in ExploreWClass,CabinetWClass  ; In Explorer, switch folders.
{
	if f_Edit1Pos <>   ; And it has an Edit1 control.
	{
		ControlSetText, Edit1, %f_path%, ahk_id %f_window_id%
		; Tekl reported the following: "If I want to change to Folder L:\folder
		; then the addressbar shows http://www.L:\folder.com. To solve this,
		; I added a {right} before {Enter}":
		ControlSend, Edit1, {Right}{Enter}, ahk_id %f_window_id%
		; ControlSend, Edit1, {Right}, ahk_id %f_window_id%
		return
	}
	; else fall through to the bottom of the subroutine to take standard action.
}
else if f_class = ConsoleWindowClass ; In a console window, CD to that directory
{
	WinActivate, ahk_id %f_window_id% ; Because sometimes the mclick deactivates it.
	SetKeyDelay, 0  ; This will be in effect only for the duration of this thread.
	IfExist % f_path
	{
		IfInString, f_path, :  ; It contains a drive letter
		{
			StringLeft, f_path_drive, f_path, 1
			Send %f_path_drive%:{enter}
		}
		Send, cd %f_path%{Enter}
	}
	return
}
; Since the above didn't return, one of the following is true:
; 1) It's an unsupported window type but f_AlwaysShowMenu is y (yes).
; 2) It's a supported type but it lacks an Edit1 control to facilitate the custom
;    action, so instead do the default action below.
Run, Explorer %f_path%  ; Might work on more systems without double quotes.
return

