; Das Skript wurde geschrieben um schnell mit Ordnern umzugehen
; 
; Ordner von  Download:	
; 	https://github.com/Grrdi/ZackZackOrdner/archive/master.zip 
; auspacken
; und 
; 	SchnellOrdner.ahk
; starten.
; Beim Erststart sollte das Skript zum anlegen des Kontainers
; 	Haupt
; auffordern.
; 	Ja
; Dito Startpfad
; Die nun einzugebende Wurzel ist der Start-Pfad in dem anschlissend rekursiv Schnell Ordner gefunden werden koennen.
; Das Einlesen erfolgt in einem eigenen Prozess (filtern ist schon waehrend des Einlesens moeglich)
; Ubers Menue koennen weitere Start-Pfade eingelesen werden.
; Ueber das Feld 
; 	Ordner-Namen-Suche
; werden die angezeigten Ordner gefiltert 
; Aktionen werden mit den obigen Buttons eingeleitet.
; 	Menue | ? | Hilfe 
; erzeugt eine auf die Umgebung zugeschnittene Hilfe und oeffnet sie
; 
;
; #################################################	Timer ####################################################
; # im Hauptteil werden keine Timer mehr benoetigt
; ############################################################################################################
; 20160329095741 ; ; # 		 Label								wirksam							Vorkommen
; 20160329095743 ; ; # Name					Critical	Prio	Intervall	Zweck
; 20160329095744 ; ; #
; 20160329095748 ; ; #
; 20160329095750 ; ; # -----------------------------------------------	MinTinmer ------------------------------------------------
; 20160329095751 ; ; #
; 20160329095753 ; ; # SetTimer,MinTinmer, %MinWaitTakt%			if Min is checked				Min:
; 20160329095754 ; ; # SetTimer,MinTinmer, Off						if Min is unchecked				Min:
; 20160329095755 ; ; # 
; 20160329095756 ; ; # MinTinmer:				Off			-1					MinWaitTakt	minimiert das Gui bei ca. 20s Inaktivitaet der User-Eingaben
; 20160329095757 ; ; #
; 20160329095758 ; ; #
; 20160329095759 ; ; # -----------------------------------------------	TimerEditUebernahme -------------------------------------
; 20160329095800 ; ; #
; 20160329095801 ; ; # SetTimer ,TimerEditUebernahme,-1			ever							MainThread
; 20160329095802 ; ; # SetTimer,TimerEditUebernahme, -1			if EdWa is checked				EdWa:
; 20160329095803 ; ; # SetTimer,TimerEditUebernahme,Off			if EdWa is unchecked			EdWa:
; 20160329095804 ; ; # 
; 20160329095805 ; ; # TimerEditUebernahme:				-1					Warten auf eingehende Befehle von Tastatur, Datei oder Variable
; 20160329095806 ; ; #
; 20160329095807 ; ; #
; 20160329095808 ; ; # -----------------------------------------------	WarteSpeicherOeffnen ------------------------------------
; 20160329095809 ; ; #
; 20160329095810 ; ; # SetTimer, WarteSpeicherOeffnen, 5000		if WiWa is checked				WiWa:
; 20160329095811 ; ; # SetTimer, WarteSpeicherOeffnen, Off			if WiWa is unchecked			WiWa:
; 20160329095812 ; ; #
; 20160329095818 ; ; # WarteSpeicherOeffnen:						5000		Warten auf: Speichern unter, Save As, öffnen, ...
; 20160329095819 ; ; # 
; 20160329095820 ; ; # ------------------------------------------------------------------------------------------------------
; 20160329095820 ; ; # 
; 20160329095821 ; ; # ============================================== Timer-Funktionen ========================================
; 20160329095822 ; ; # 
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
; # 
; #########################################################################################################

#SingleInstance
#NoEnv
#Persistent
FileEncoding,UTF-16
Ue1=%1%
CR=`r
LF=`n
CRLF:=CR LF
DotOverDot:=":"
AutoFavorit:=1
Edit1Default:=
Edit2Default:=
Edit3Default:=1
Edit4Default:="Befehlsentgegennahme"
Edit5Default:=
Edit6Default:="20"
Edit7Default:="Filter"
Edit8Default:=
Edit9Default:=4
Edit10Default:="Zusatz"
RegExBeratungsFormularHoehe:=365
RegExBeratungsFormularBreite:=840
WiWaDefault:=0
; 20160329184541 ; EdWaDefault:=0
OnTopDefault:=0
; 20160329141506 ; FiCaDefault:=1
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
WoAnDefault:=1
beschaeftigtDefault:=0

StringReplace,ZumSpeichernThisAufmerksamkeitText,ThisAufmerksamkeitText,`r`n,`%CRLF`%,All
StringReplace,ZumSpeichernThisAufmerksamkeitText,ZumSpeichernThisAufmerksamkeitText,`n,`%LF`%,All
StringReplace,ZumSpeichernThisAufmerksamkeitText,ZumSpeichernThisAufmerksamkeitText,`r,`%CR`%,All
; GefundeneWorteObjekt:={} ;
; < Hilfe einlesen Individueller Button> 
IfExist  %A_ScriptDir%\Button6.htm	
{
	; run,%A_ScriptDir%\Button6.htm ;
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
Hochkomma="
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
; CoordMode,ToolTip Pixel Mouse Caret Menu , Client ;
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
; 20160329101341 ; IfNotExist %A_AppDataCommon%\Zack\%ScriptNamneOhneKlammer%.ausn
; 20160329101349 ; 	FileCopy,%A_ScriptDir%\%ScriptNamneOhneKlammer%.ausn, %A_AppDataCommon%\Zack\%ScriptNamneOhneKlammer%.ausn	
FileDelete,%A_AppDataCommon%\Zack\SchnellOrdner.txt
FileAppend,%A_ScriptFullPath%,%A_AppDataCommon%\Zack\SchnellOrdner.txt
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
FileDelete,%A_AppDataCommon%\Zack\AlleLaufwerke.awpf
FileAppend,%DriveNamesAwpfList%,%A_AppDataCommon%\Zack\AlleLaufwerke.awpf
WBvor:="file:///"
WichtigeTrayTipsAnzeigen:=true	
if ZackZackOrdnerLogErstellen
	ThreadUeberwachungLog(A_LineNumber,A_ThisHotkey,A_ThisLabel,A_ThisFunc,A_ThisMenu,A_ThisMenuItem,A_ThisMenuItemPos)
; Thread,Priority,1 ;
; SetTimer,zaehle,-1 ;
; TimerFehlerSuche:=true ;
; MsgBox  %A_IconNumber% und %A_IconFile% ;
IfExist GeKoLi.ico
{
	Menu,Tray,icon,GeKoLi.ico
	if ZackZackOrdnerLogErstellen
		ThreadUeberwachungLog(A_LineNumber-1,A_ThisHotkey,A_ThisLabel,A_ThisFunc,A_ThisMenu,A_ThisMenuItem,A_ThisMenuItemPos)
}
; MsgBox % A_IsUnicode ? "Unicode" : "ANSI" ;
; MsgBox % A_PtrSize "	" A_PtrSize ;
FileEncoding,UTF-16
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
IfExist %WurzelContainer%\Haupt
{
	SkriptDataPath=%WurzelContainer%\Haupt				
	SpaeterKontainerAnzeigen:=true
	; gosub KontainerAnzeigen ;
}

SkriptDataPathKurzNachProgrammbeginn:=SkriptDataPath					; diese Variable bitte als Konstante ansehen und ab hier nicht mehr aendern. 
if ZackZackOrdnerLogErstellen
	ThreadUeberwachungLog(A_LineNumber-1,A_ThisHotkey,A_ThisLabel,A_ThisFunc,A_ThisMenu,A_ThisMenuItem,A_ThisMenuItemPos)
IndexierenBeenden:=0
OrdnerEingelesen:=False
Rekursiv=R
gosub WorteCacheBefuellen
Gui,New,+HwndGuiWinHwnd -DPIScale
if ZackZackOrdnerLogErstellen
	ThreadUeberwachungLog(A_LineNumber-1,A_ThisHotkey,A_ThisLabel,A_ThisFunc,A_ThisMenu,A_ThisMenuItem,A_ThisMenuItemPos)
Gui,+Resize ; AlwaysOnTop
Gui, Show, w510 h480, ZackZackOrdner
GuiHeight:=480

Gui, Add, Edit, 	x40 	y111 	w38 	h16 	HwndHwndEdit1	gEdit1 	vEdit1  -Tabstop 		r1	Right	Number 	, 	Anz
Gui, Add,	Text,	x78		y113	w55 	h16 																	,	gefundene
Gui, Add,	Text,	x0		y135 	w70		h32 																	,	ausgewaehlte`nPfad Nr.
; Gui, Add,	Text,	x71		y131 	w20		h52 																	,	_↑¯`n¯↓`n    \
Gui, Add,	Text,	x71		y125 	w25		h65 																	,	_┌─`n`n¯  \`n    ↓
Gui, Add,	Text,	x136	y113 	w30 	h16 																	,	Pfade
Gui, Add,	Text,	x0		y75 	w93 	h32															Right		,	Ordner-`nNamen-Suche

Gui, Add, Edit, 	x98 	y78 	w390 	h20   	HwndHwndEdit2	gEdit2 	vEdit2 				 	r1				, 	Such
Gui, Add,	Text,	x98		y98 	w83 	h16 																	,	Suche vom
Gui, Add, Edit, 	x40 		y150 	w30 	h18 	HwndHwndEdit3	gEdit3 	vEdit3				-Wrap r1	Number 	, 	1
; Gui, Add, UpDown, vEdit3UpDown Range100-1, 1 ;
; Gui, Add,	Text,	x0		y164 	w90 	h16 																	,	nur Nr. ;
Gui, Add, Edit, 	x490 	y78 	w150 	h20 	HwndHwndEdit4	gEdit4 	vEdit4	-Tabstop	-Wrap		 	 	, 	Befehlsentgegennahme
Edit5Y0:=125		; immer ueber diese Variable Y von Edit5 eingeben sonst trifft GuiDropFiles nicht
Gui, Add, Edit, 	x141 	y%Edit5Y0% w350	h240  	HwndHwndEdit5	gEdit5 	vEdit5	-Tabstop	-Wrap	0x100	-VScroll	, 	Ordner
Gui, Add, UpDown, 	x122 	y%Edit5Y0% w8	h240	HwndHwndEdit5UpDown							vEdit5UpDown  gEdit5UpDown  -16 Range100-1, 1
Gui, Add,	Text,	x239	y98 	w82 	h16 																	,	 Abbruch nach
Gui, Add, Edit, 	x309 	y96 	w70		h24  	HwndHwndEdit6	gEdit6 	vEdit6				-Wrap r1	Number 	, 	20
Gui, Add,	Text,	x351	y98 	w55 	h16 																	,	 Iterationen.
GuiControl,, Edit6, 20
Gui, Add, CheckBox, x425 	y108	w80 	h15 	HwndHwndCheckA0			vbeschaeftigt	-Tabstop				, 	beschaeftigt
Gui, Add, CheckBox, x156 	y98	w80 	h15 	HwndHwndCheckA5	gWoAn	vWoAn	-Tabstop						, 	WortAnfang,
; Gui, Add,	Text,	x0	y62 	w130 	h16 																	,	Uebergabeoptionen: ;
Gui, Add,	Text,	x0	y62 	w130 	h16 																	,	Rückgabeopt. →
Gui, Add, CheckBox,	x97 	y62 	w31 	h14  	HwndHwndCheckB2	gBsAn	vBsAn	-Tabstop	Checked		Right	,	..\
BsAn:=true
GuiControl,, BsAn, %BsAn%
Gui, Add, CheckBox,	x132 	y62 	w32 	h14 	HwndHwndCheckB4	gSrLi	vSrLi	-Tabstop	Checked		Right	,	<--
SrLi:=true
GuiControl,, SrLi, %SrLi%
Gui, Add, CheckBox,	x160 	y62 	w33 	h14 	HwndHwndCheckB6	gSeEn  	vSeEn	-Tabstop				Right	,	ok
Gui, Add, CheckBox,	x302 	y62 	w90 	h14 	HwndHwndCheckB8	gExpSel vExpSel	-Tabstop			Right	, 	Selektiert		; Checked
ExpSel:=false
GuiControl,, ExpSel, %ExpSel%
Gui, Add,	Text,	x0		y184 	w90 	h16 																	,	Pfad-Filter
Gui, Add, CheckBox, x0 		y222 	w45 	h16 	HwndHwndCheckE0	gSuFi	vSuFi	-Tabstop						, 	Filter
HwndSuFi:=HwndCheckE0
Gui, Add,	Text,	x0		y243 	w90 	h16 																	,	Fenster
Gui, Add, CheckBox, x47 	y222 	w55 	h16 	HwndHwndCheckE5	gRegEx	vRegEx	-Tabstop						, 	RegEx
Gui, Add, Edit, 	x0 		y200 	w90 	h16 	HwndHwndEdit7	gEdit7 	vEdit7	-Tabstop 	-Wrap r1			, 	Filter
Gui, Add, Edit, 	x0 		y0 		w510	h16 	HwndHwndEdit8 	gEdit8 	vEdit8	-Tabstop 	-Wrap r1 0x100	Center 	, 	EinzelErg		; Right
; Gui, Add,	Text,	x0		y314 	w90 	h32																	,	AutoPop ;
; 20160329103753 ; Gui, Add, CheckBox, x0 		y272 	w90 	h20 	HwndHwndCheckC0	gWiWa	vWiWa	-Tabstop					, 	AutoPop			; Timer fuer Checked das Warten auf Speichern unter ;
WiWa:=false
; 20160329130221 ; GuiControl,, WiWa, %WiWa%
; 20160329105802 ; Gui, Add, CheckBox, x0 		y216 	w60 	h20 	HwndHwndCheckF0	gEdWa	vEdWa	-Tabstop	Checked				, 	EdWa			; Timeer fuer Uebernahme Tastatur
; 20160329105803 ; GuiControl,Hide,EdWa
Gui, Add, CheckBox, x0 		y236 	w65 	h20 	HwndHwndCheckE9	gAuAb	vAuAb	-Tabstop						, 	AutoAbbr
GuiControl,Hide,AuAb
Gui, Add, Edit, 	x62		y235 	w30 	h16 	HwndHwndEdit9	gEdit9	vEdit9	-Tabstop	r1			Number	, 	4
GuiControl,Hide,Edit9
Gui, Add, CheckBox, x0 		y256 	w35 	h20 	HwndHwndCheckG0	gOnTop	vOnTop	-Tabstop						, 	To				; Top (Top -> Min)
Gui, Add, CheckBox, x32 	y256 	w35 	h20 	HwndHwndCheckG3	gAkt	vAkt	-Tabstop	Checked				, 	Ak				; Akt (Akt+Min -> Min; Akt+Top -> Min Akt -> Bottom ; Nichts -> lassen)		Top or Min -> Min    +Akt -Top -Min -> Bottom    -Top -Akt -Min -> lassen
Gui, Add, Edit, 	x122 	y450 	w390 	h20   	HwndHwndEdit10	gEdit10 	vEdit10 				 	r1		, 	Zusatz
; Gui,show ;
; MsgBox ;
; Gui, Color , , red ;
; OnTop:=true ;
GuiControl,, %HwndHwndCheckG3%, 1
; Gui, Add, CheckBox, x62 	y256 	w30 	h20 	HwndHwndCheckG9	gOnTop	vMin	-Tabstop						, 	Mi				; Min (Min gewinnt gegen Top und Akt)
; 20160329110408 ; Gui, Add, CheckBox, x62 	y256 	w35 	h20 	HwndHwndCheckG9			vMin	-Tabstop						, 	Mi				; Min (Min gewinnt gegen Top und Akt)
; 20160329130515 ; Gui, Add, CheckBox, x0 		y276 	w90 	h20 	HwndHwndCheckH0	gFiCa	vFiCa	-Tabstop	Checked 			, 	FileCache
; 20160329130516 ; GuiControl,Hide,FiCa
Gui, Add,	Text,	x0		y314 	w90 	h16 																	,	Pfade einlesen
Gui, Add, CheckBox, x0 		y326 	w90 	h20 	HwndHwndCheckI0	gRekursiv	vRekur 	-Tabstop	Checked			, 	Rekursiv
; 20160329130542 ; Gui, Add, CheckBox, x0 		y316 	w90 	h20 	HwndHwndCheckJ0	gDurchsichtig	vDurchsichtig 	-Tabstop		, 	Glas
; 20160329130551 ; GuiControl,Hide,Durchsichtig
; Gui, Add, CheckBox, x0 		y336 	w90 	h20 	HwndHwndCheckK0	gLeseEin vLeseEin	-Tabstop					, 	lese ein ;
Gui, Add,	Text,	x0		y350 	w90 	h32																	,	Anzeige im`nFeld rechts
Gui, Add, CheckBox, x0 		y376 	w90 	h32 	HwndHwndCheckK5	gIeAnz vIeAnz	-Tabstop						, 	zeige Inhalte √`noder Pfade
Gui, Add, Button,	x0 		y19		w90 	h40 	HwndHwndButton1	gButton1		-Tabstop			 			, 	aktualisieren
Gui, Add, Button, 	x102 	y19 	w90 	h40 	HwndHwndButton2	gButton2  	 									,  	-> &I
Gui, Add, Button, 	x202 	y19 	w90 	h40 	HwndHwndButton3	gButton3										, 	-> &Clip
Gui, Add, Button, 	x302 	y19 	w90 	h40 	HwndHwndButton4	gButton4					Default				,	Explorer (Enter)	; vorzugsweise Default-Button
Gui, Add, Button, 	x402 	y19	 	w90 	h40 	HwndHwndButton5	gButton5		-Tabstop						, 	Copy`nMove
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
		Gui, Add, Button, 	x%ThisButtonX%	y19	 	w90 	h40 	HwndHwndButton%ButtonIndex%	gButton%ButtonIndex%		-Tabstop		, 	%ThisButtonName%
	}
}
Gui Add, ActiveX, x141 	y%Edit5Y0% w350	h240 HWNDHwndIe1 vWB gWB, Shell.Explorer  ; Der letzte Parameter ist der Name der ActiveX-Komponente.
gosub IeControl
if ZackZackOrdnerLogErstellen
	ThreadUeberwachungLog(A_LineNumber-1,A_ThisHotkey,A_ThisLabel,A_ThisFunc,A_ThisMenu,A_ThisMenuItem,A_ThisMenuItemPos)
; Gui, Add, Text, x402 	y10 	w90 	h40 , |¯¯¯¯¯¯¯¯¯¯|`n|     Button     |`n|__________| ;

; <---------------------------------- Fenster-Menue ----------------------------------------->
; Datei ;
; 20160329174024 ; Menu, Dateimenü, 		Add, &Autoload bearbeiten		, AutoLoadBearbeiten   ;
; 20160329174025 ; Menu, Dateimenü,	Disable, &Autoload bearbeiten		; wird seit auf FileCash umgestellt wurde nicht mehr benoetigt. ;
Menu, Dateimenü, 		Add, &Reload					, NeuStarten
Menu, Dateimenü, 		Add, &Skript-Ordner oeffnen		, SkriptOrdnerOeffnen	
Menu, Dateimenü, 		Add, &Data-Ordner oeffnen		, DataOrdnerOeffnen	
Menu, Dateimenü, 		Add, &Testumgebung erzeugen		, TestumgebungErzeugen	
Menu, Dateimenü, 		Add, &Beenden					, GuiClose
; Edit8
Menu, Edit8menue, 		Add, &oeffnen					, Edit8Oeffnen
Menu, Edit8Menue, 		Add, &neuer Ordner				, Edit8NeuerOrdner
; Menu, Edit8Menue, 		Add, &zeige Unter-Ordner		, Edit8ZeigeUnterOrdner ;
Menu, Edit8Menue, 		Add, &zeige Unter-DrueberOrdner		, Edit8ZeigeVorfahrenUndUnterordner
; Menu, Edit8Menue, 		Add, &zeige Vorfahren-Ordner		, Edit8ZeigeVorfahrenOrdner ;
Menu, Edit8Menue, 		Add, &Explorer					, Edit8Explorer
Menu, Edit8Menue, 		Add, &Explorer Select			, Edit8ExplorerSelect
Menu, Edit8Menue, 		Add, &Explorer eingebunden		, Edit8ExplorerEingebunden
Menu, Edit8Menue, 		Add, &umbenennen				, Edit8Umbenennen
Menu, Edit8Menue, 		Add, &DateiSuche				, DateiSucheAusgehendVonEdit8
; Container
; 20160330225719 ; Menu, ContainerMenue, 	Add, &gespeicherte Uebersicht oeffnen	, WurzelContainerUebersichtOeffnen
Menu, ContainerMenue,	Add, Uebersicht anzeigen 		, ContainerUebersichtZeigen
Menu, ContainerMenue, 	Add, Angezeigten &oeffnen		, WurzelContainerOeffnen  
Menu, ContainerMenue, 	Add, &anlegen					, ContainerAnlegen  
Menu, ContainerMenue, 	Add, &loeschen					, ContainerLoeschen  
; 20160330225732 ; Menu, ContainerMenue, 	Add, Uebersicht &erzeugen		, WurzelContainerUebersichtErzeugenAnzeigen  
Menu, ContainerMenue,	Add, &Alle loeschen				, DelCache
; Wurzel
Menu, StartPfadMenue, 	Add, von &Datei einlesen		, WurzelVonDateiHinzuFuegen  ; Siehe untere Bemerkungen zu Ctrl+F.
Menu, StartPfadMenue, 	Add, &einlesen`tCtrl+O			, WurzelHinzuFuegen  ; Siehe untere Bemerkungen zu Ctrl+F.
Menu, StartPfadMenue, 	Add, &aktualisieren ...	(einzeln)	, WurzelAktualisieren ; 
Menu, StartPfadMenue, 	Add, &aktualisieren	(Kontainer)		, WurzelnAktualisieren ; 
Menu, StartPfadMenue, 	Add, &Loeschen ...				, WurzelLoeschen  ; 
Menu, StartPfadMenue, 	Add, &Uebersicht				, StartPfadeUebersicht  ; 
; Menu, WurzelMenue, 	Add, neuer Start-Kontainer 		, WurzelContainerErzeugenAnzeigen   ;
; Favoriten
Menu, FavMenue, 		Add, &speichern					, FavoritSpeichern
Menu, FavMenue, 		Add, &oeffnen					, FavoritOeffnen
Menu, FavMenue, 		Add, &plus *					, PlusStern
Menu, FavMenue, 		Add, &minus *					, MinusStern
Menu, FavMenue, 		Add, &AutoFavorit				, AutoFavoritEingeben
Menu, FavMenue, 		Add, &Ordner oeffnen			, FavoritenOrdnerOeffnen
Menu, FavMenue, 		Add, &Zeige temp Pos in Ordner-Struktur	, Edit8ZeigeVorfahrenUndUnterordner
Menu, FavMenue, 		Add, plus * &manuell			, PlusSternManuell
; Macro
Menu, MacroMenue, 		Add, &Ordner oeffnen			, StaOrdnerBefehlsDateiPfadOeffnen
Menu, MacroMenue, 		Add, &Starten...				, UserSelBefehlsDateiPfadAusfuehren
Menu, MacroMenue, 		Add, &nochmals starten			, BefehlsVariableAusfuehren
Menu, MacroMenue, 		Add, &Muster-Dateien			, MusterDateienErzeugen
Menu, MacroMenue, 		Add, &Befehls-Liste				, ListLabels

; AutoPop ;
; 20160329152524 ; Menu, AutoPopMenue, 	Add, &AutoPop.log anzeigen				, AutoPopLogAnzeigen ;
; 20160329152525 ; Menu, AutoPopMenue, 	Add, &wirksame AutoPop Ausnahmen anzeigen				, WirksameAutoPopAusnahmenAnzeigen ;
; 20160329152525 ; Menu, AutoPopMenue, 	Add, &Ausnahmen bearbeiten				, AutoPopAusnahmenBearbeiten ;

; Optionen
Menu, OptionsMenue, 	Add, &Sitzungs-Einst. speichern				, SitzungsEinstellungenMerken
Menu, OptionsMenue, 	Add, &Sitzungs-Einst. einlesen				, SitzungsEinstellungenEinlesen
Menu, OptionsMenue, 	Add, &Sitzungs-Einst. bearbeiten				, SitzungsEinstellungenBearbeiten
Menu, OptionsMenue, 	Add, &Einstellungen				, Einstellungen
; Hilfe
Menu, Hilfsmenü, 		Add, &Verlangsamte Demo			, LangsamDemoToggle
Menu, Hilfsmenü, 		Add, Inf&o						, Info
Menu, Hilfsmenü, 		Add, &Hilfe						, Hilfe
; ---------------------------------------------------------------------------------
Menu, MeineMenüleiste,	Add, &Datei						, 	:Dateimenü  ; Fügt die oben erstellten Untermenüs hinzu.
Menu, MeineMenüleiste,	Add, &Edit8						, 	:Edit8menue  ; Fügt die oben erstellten Untermenüs hinzu.
Menu, MeineMenüleiste,	Add, &Kontainer					, 	:ContainerMenue
; Menu, MeineMenüleiste,	Add, &Start-Kontainer			, 	:WurzelMenue
Menu, MeineMenüleiste,	Add, &Start-Pfad				, 	:StartPfadMenue
Menu, MeineMenüleiste,	Add, &Favoriten					, 	:FavMenue
Menu, MeineMenüleiste,	Add, &Macro						, 	:MacroMenue
; 20160329152706 ; Menu, MeineMenüleiste,	Add, &AutoPop					, 	:AutoPopMenue
Menu, MeineMenüleiste,	Add, &Optionen					, 	:OptionsMenue
Menu, MeineMenüleiste, 	Add, &?							, 	:Hilfsmenü 
Gui, Menu, MeineMenüleiste
if ZackZackOrdnerLogErstellen
	ThreadUeberwachungLog(A_LineNumber-1,A_ThisHotkey,A_ThisLabel,A_ThisFunc,A_ThisMenu,A_ThisMenuItem,A_ThisMenuItemPos)
; </---------------------------------- Fenster-Menue ----------------------------------------->

; BEISPIEL #2: Dieses Script zeigt, wie ein aufklappbares Menü erstellt werden kann, das angezeigt werden soll, wenn der Benutzer WIN+Z drückt. ;

; BEISPIEL #2: Dieses Script zeigt, wie ein aufklappbares Menü erstellt werden kann, das angezeigt werden soll, wenn der Benutzer WIN+Z drückt. ;

; Erstellt ein aufklappbares Menü durch Hinzufügen von Menüpunkten. ;
; Menu, MeinMenu, Add, Nur_Nr, MenuHandler ;
; Menu, MeinMenu, Add, Neuer_Ordner, MenuHandler ;
; Menu, MeinMenu, Add, zeige_UnterOrdner, MenuHandler ;
; Menu, MeinMenu, Add, Explorer, MenuHandler ;
; Menu, MeinMenu, Add, Explorer Select, MenuHandler ;
; Menu, MeinMenu, Add, Explorer eingebunden, MenuHandler ;
; Menu, MeinMenu, Add, umbenennen, MenuHandler ;
; Menu, MeinMenu, Add  ; Fügt eine Trennlinie ein. ;

; Erstellt ein weiteres Menü, das als Untermenü für das obige Menü dienen soll. ;
; Menu, Submenu1, Add, + Stern, MenuHandler ;
; Menu, Submenu1, Add, - Stern, MenuHandler ;

; Erstellt ein Untermenü im ersten Menü (mit einem nach rechts gerichteten Pfeil). Sobald der Benutzer dieses Untermenü auswählt, wird das zweite Menü angezeigt. ;
; Menu, MeinMenu, Add, Favorit, :Submenu1 ;

; Menu, MeinMenu, Add  ; Fügt eine Trennlinie unterhalb des Untermenüs ein. ;
; Menu, MeinMenu, Add, Control Infos, MenuHandler  ; Fügt einen weiteren Menüpunkt unterhalb des Untermenüs ein. ;

; ----------------------------------------------------------- ;

Menu, IntegerMenu, Add, Nur_Nr, IntegerMenuHandler
Menu, IntegerMenu, Add, Set Clipboard, IntegerMenuHandler
Menu, IntegerMenu, Add, Neuer_Ordner, IntegerMenuHandler
Menu, IntegerMenu, Add, zeige_UnterOrdner, IntegerMenuHandler
Menu, IntegerMenu, Add, Explorer, IntegerMenuHandler
Menu, IntegerMenu, Add, Explorer Select, IntegerMenuHandler
Menu, IntegerMenu, Add, Explorer eingebunden, IntegerMenuHandler
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
; 20160329231618 ; if ZackZackOrdnerLogErstellen
; 20160329231619 ; 	ThreadUeberwachungLog(A_LineNumber-1,A_ThisHotkey,A_ThisLabel,A_ThisFunc,A_ThisMenu,A_ThisMenuItem,A_ThisMenuItemPos)
; Menu, IntegerMenu, Add, Control Infos, IntegerMenuHandler  ; Fügt einen weiteren Menüpunkt unterhalb des Untermenüs ein. ;
; return ; Ende des automatischen Ausführungsbereichs. ;

; -----------------------------------------------------------

Menu, SucheMenu, Add, vom VaterDir, SucheMenuHandler
Menu, SucheMenu, Add, vom VaterWin, SucheMenuHandler
Menu, SucheMenu, Add
Menu, SucheMenu, Add, Control Infos, SucheMenuHandler  ; Fügt einen weiteren Menüpunkt unterhalb des Untermenüs ein.
; 20160329231714 ; if ZackZackOrdnerLogErstellen
; 20160329231717 ; 	ThreadUeberwachungLog(A_LineNumber-1,A_ThisHotkey,A_ThisLabel,A_ThisFunc,A_ThisMenu,A_ThisMenuItem,A_ThisMenuItemPos)
; --------------------------------------------------------------

Menu, SuFiMenu, Add, vom VaterDir, SuFiMenuHandler
Menu, SuFiMenu, Add, vom GrossVaterDir, SuFiMenuHandler
Menu, SuFiMenu, Add, vom VaterWin, SuFiMenuHandler
Menu, SuFiMenu, Add
Menu, SuFiMenu, Add, Control Infos, SuFiMenuHandler  ; Fügt einen weiteren Menüpunkt unterhalb des Untermenüs ein.
; 20160329231738 ; if ZackZackOrdnerLogErstellen
; 20160329231744 ; 	ThreadUeberwachungLog(A_LineNumber-1,A_ThisHotkey,A_ThisLabel,A_ThisFunc,A_ThisMenu,A_ThisMenuItem,A_ThisMenuItemPos)
	; deaktiviert ; #z::Menu, MeinMenü, Show  ; Drücke WIN+Z, um das Menü anzuzeigen. ;

; Menu, MeinKontextMenu, 		Add, &Explorer					,	 Explorer ;
; Menu, ButtonsMenu, 		Add, &Explorer					,	 Explorer ;
; Menu, MeinKontextMenu,	Add, &Button4					, 	:ButtonsMenu ;
; Menu, MeinKontextMenu,	Add, &Button4					, 	Explorer ;
; Gui, Menu, MeinKontextMenu ;

; < ------------------------------ PfadNummern links von Edit5 ins Gui --------------------------------->
if (PfadNrStatisch1YOhne = "")	
PfadNrStatisch1YOhne := 128												; Die Nummern beginnen ab Pixel
if (PfadNrStatisch1YOhneEich = "")
PfadNrStatisch1YOhneEich := 0												; EichSummand	Neeutral := 0
PfadNrStatisch1Y := PfadNrStatisch1YOhne + PfadNrStatisch1YOhneEich			; Erster Y Abstand in Pixel
if (GrundZeilenVersatzYEich = "")
GrundZeilenVersatzYEich := 1											; EichFaktor	Neeutral := 1
if (GrundZeilenVersatzYStandart = "")
GrundZeilenVersatzYStandart := 13												; StandartVersatz in Pixel
ZeilenVersatzY := GrundZeilenVersatzYStandart * GrundZeilenVersatzYEich		; in Pixel
PfadNrStatischAnzahl:=Round((A_ScreenHeight - PfadNrStatisch1Y) / ZeilenVersatzY) -9
if ZackZackOrdnerLogErstellen
	ThreadUeberwachungLog(A_LineNumber-1,A_ThisHotkey,A_ThisLabel,A_ThisFunc,A_ThisMenu,A_ThisMenuItem,A_ThisMenuItemPos)
Loop, % PfadNrStatischAnzahl
{
	ThisIndexPlus1 := A_Index + 1
	ThissPfadNrStatischY := PfadNrStatisch%A_Index%Y
	Gui, Add,	Text	,								x90	y%ThissPfadNrStatischY% w20 h12 Right, %A_Index%
	PfadNrStatisch%ThisIndexPlus1%Y := PfadNrStatisch1Y + (ZeilenVersatzY * A_Index)
}
; </ ------------------------------ PfadNummern links von Edit5 ins Gui --------------------------------->
gosub GuiAnfaengerModus
Edit2:=
GuiControl,, %HwndEdit2%, %Edit2%
if ZackZackOrdnerLogErstellen
	ThreadUeberwachungLog(A_LineNumber+1,A_ThisHotkey,A_ThisLabel,A_ThisFunc,A_ThisMenu,A_ThisMenuItem,A_ThisMenuItemPos)
gosub Edit2
ControlFocus,Edit2,ahk_id %GuiWinHwnd%
; OnTop:=true ;
if ZackZackOrdnerLogErstellen
	ThreadUeberwachungLog(A_LineNumber+1,A_ThisHotkey,A_ThisLabel,A_ThisFunc,A_ThisMenu,A_ThisMenuItem,A_ThisMenuItemPos)
; 20160329104252 ; gosub WiWa
if ZackZackOrdnerLogErstellen
	ThreadUeberwachungLog(A_LineNumber+1,A_ThisHotkey,A_ThisLabel,A_ThisFunc,A_ThisMenu,A_ThisMenuItem,A_ThisMenuItemPos)
; 20160329110503 ; gosub MinTimerSetzen
if ZackZackOrdnerLogErstellen
	ThreadUeberwachungLog(A_LineNumber+1,A_ThisHotkey,A_ThisLabel,A_ThisFunc,A_ThisMenu,A_ThisMenuItem,A_ThisMenuItemPos)
gosub BsAn
; CoordMode,ToolTip Pixel Mouse Caret Menu , Window ;
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
; 20160330010540 ; if (false)	; Pruefen******************************************************************************
; 20160330010545 ; {
; 20160330010546 ; 	if ZackZackOrdnerLogErstellen
; 20160330010547 ; 		ThreadUeberwachungLog(A_LineNumber-2,A_ThisHotkey,A_ThisLabel,A_ThisFunc,A_ThisMenu,A_ThisMenuItem,A_ThisMenuItemPos)
; 20160330010548 ; 	; MsgBox %  WurzelContainer ;
; 20160330010548 ; 	Loop,Files,%WurzelContainer%\*, D
; 20160330010549 ; 	{
; 20160330010550 ; 		; MsgBox %  A_LoopFileLongPath ;
; 20160330010550 ; 		SkriptDataPath:=A_LoopFileLongPath
; 20160330010551 ; 		gosub KontainerAnzeigen
; 20160330010552 ; 		Edit8:=SkriptDataPath
; 20160330010552 ; 		GuiControl,, Edit8, %Edit8%
; 20160330010553 ; 		gosub Button1
; 20160330010554 ; 		IfExist %SkriptDataPath%
; 20160330010554 ; 		{
; 20160330010555 ; 			SoundBeep
; 20160330010605 ; 			SoundBeep
; 20160330010605 ; 			SoundBeep
; 20160330010606 ; 			SoundBeep
; 20160330010607 ; 			SoundBeep
			; gosub WurzelContainerOeffnen ;
; 20160330010611 ; 		}
; 20160330010612 ; 		break
; 20160330010612 ; 	}
; 20160330010613 ; 	If (SkriptDataPath<>"")
; 20160330010614 ; 	{
; 20160330010615 ; 		IfNotExist %SkriptDataPath%
; 20160330010616 ; 		{
; 20160330010620 ; 			SkriptDataPath=%WurzelContainer%\Haupt
; 20160330010621 ; 			gosub KontainerAnzeigen
; 20160330010622 ; 			FileCreateDir %SkriptDataPath%
; 20160330011154 ; 		}
; 20160330011213 ; 	}
; 20160329232922 ; 	else
; 20160329232931 ; 	{
	; SkriptDataPath=%WurzelContainer%\Haupt ;
	; FileCreateDir %SkriptDataPath% ;
; 20160329232936 ; 	}
; 20160330010730 ; }
if ZackZackOrdnerLogErstellen
	ThreadUeberwachungLog(A_LineNumber+1,A_ThisHotkey,A_ThisLabel,A_ThisFunc,A_ThisMenu,A_ThisMenuItem,A_ThisMenuItemPos)
ScriptFullPathKlammmerInhalt:=GetKlammerInhalt(A_ScriptFullPath)
StringReplace,ScriptFullPathMain,A_ScriptFullPath,[%ScriptFullPathKlammmerInhalt%],
if ZackZackOrdnerLogErstellen
	ThreadUeberwachungLog(A_LineNumber+1,A_ThisHotkey,A_ThisLabel,A_ThisFunc,A_ThisMenu,A_ThisMenuItem,A_ThisMenuItemPos)
IfNotExist %ScriptFullPathMain%.htm		; Skript ErstStart erkannt
{
; 20160330010915 ; 	if ZackZackOrdnerLogErstellen
; 20160330010920 ; 		ThreadUeberwachungLog(A_LineNumber-2,A_ThisHotkey,A_ThisLabel,A_ThisFunc,A_ThisMenu,A_ThisMenuItem,A_ThisMenuItemPos)
	; gosub ListLabels ;
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
; 20160329172841 ; 	IfNotExist %A_AppData%\Zack\%ScriptNamneOhneKlammer%.ausn
; 20160329172845 ; 	{
; 20160329172852 ; 		if ZackZackOrdnerLogErstellen
; 20160329172858 ; 			ThreadUeberwachungLog(A_LineNumber+1,A_ThisHotkey,A_ThisLabel,A_ThisFunc,A_ThisMenu,A_ThisMenuItem,A_ThisMenuItemPos)
; 20160329161638 ; 		gosub AutoPopAusnahmeDefaultDateiErstellen
; 20160329172906 ; 	}
; 20160329162012 ; 	Critical, On
; 20160330013043 ; 	if ZackZackOrdnerLogErstellen
; 20160330013047 ; 		ThreadUeberwachungLog(A_LineNumber-1,A_ThisHotkey,A_ThisLabel,A_ThisFunc,A_ThisMenu,A_ThisMenuItem,A_ThisMenuItemPos)
; 20160329160114 ; 	Thread, priority,9999
; 20160330013059 ; 	if ZackZackOrdnerLogErstellen
; 20160330013100 ; 		ThreadUeberwachungLog(A_LineNumber-1,A_ThisHotkey,A_ThisLabel,A_ThisFunc,A_ThisMenu,A_ThisMenuItem,A_ThisMenuItemPos)
	; deaktiviert ; MsgBox, 262436, AutoStart, moechten Sie`, dass die OrdnerUnterstuezung nach der Anmeldung automatisch startet?
; 20160330013113 ; 	IfMsgBox,No
		return
; 20160330013219 ; 	IfMsgBox, Yes
; 20160330013220 ; 	{
; 20160330013221 ; 		return ; deaktiviert
		; MsgBox davor ;
; 20160329233240 ; 		if ZackZackOrdnerLogErstellen
; 20160329233241 ; 			ThreadUeberwachungLog(A_LineNumber+1,A_ThisHotkey,A_ThisLabel,A_ThisFunc,A_ThisMenu,A_ThisMenuItem,A_ThisMenuItemPos)
; 20160329233246 ; 		IfNotExist %A_AppDataCommon%\Zack\TastWatch.exe
; 20160329233247 ; 		{
; 20160329233248 ; 			; FileDelete, %A_AppDataCommon%\TastWatch.exe
; 20160329233249 ; 			if ZackZackOrdnerLogErstellen
; 20160329233250 ; 				ThreadUeberwachungLog(A_LineNumber+1,A_ThisHotkey,A_ThisLabel,A_ThisFunc,A_ThisMenu,A_ThisMenuItem,A_ThisMenuItemPos)
; 20160329233251 ; 			IfExist %A_ScriptDir%\TastWatch.exe
; 20160329233252 ; 			{
; 20160329233253 ; 				FileCopy,  %A_ScriptDir%\TastWatch.exe, %A_AppDataCommon%\Zack\TastWatch.exe
; 20160329233253 ; 				if ZackZackOrdnerLogErstellen
					; 20160329233254 ; ThreadUeberwachungLog(A_LineNumber-1,A_ThisHotkey,A_ThisLabel,A_ThisFunc,A_ThisMenu,A_ThisMenuItem,A_ThisMenuItemPos)
; 20160329233255 ; 			}
; 20160329233256 ; 		}
; 20160329233257 ; 		; MsgBox davor
; 20160329233259 ; 		if ZackZackOrdnerLogErstellen
; 20160329233300 ; 			ThreadUeberwachungLog(A_LineNumber+1,A_ThisHotkey,A_ThisLabel,A_ThisFunc,A_ThisMenu,A_ThisMenuItem,A_ThisMenuItemPos)
; 20160329233300 ; 		IfNotExist %A_Startup%\TastWatch.exe.lnk
; 20160329233301 ; 		{
; 20160329233303 ; 			if ZackZackOrdnerLogErstellen
; 20160329233304 ; 				ThreadUeberwachungLog(A_LineNumber+1,A_ThisHotkey,A_ThisLabel,A_ThisFunc,A_ThisMenu,A_ThisMenuItem,A_ThisMenuItemPos)
; 20160329233305 ; 			gosub TastWatch2Autorun
; 20160329233311 ; 		}
; 20160330013145 ; 	}
; 20160329162113 ; 	Thread, priority,-9999
; 20160330013150 ; 	if ZackZackOrdnerLogErstellen
; 20160330013153 ; 		ThreadUeberwachungLog(A_LineNumber-1,A_ThisHotkey,A_ThisLabel,A_ThisFunc,A_ThisMenu,A_ThisMenuItem,A_ThisMenuItemPos)
; 20160329162117 ; 	Critical,Off
; 20160330013157 ; 	if ZackZackOrdnerLogErstellen
; 20160330013158 ; 		ThreadUeberwachungLog(A_LineNumber-1,A_ThisHotkey,A_ThisLabel,A_ThisFunc,A_ThisMenu,A_ThisMenuItem,A_ThisMenuItemPos)
	; return ;
}

; IfWinNotExist,ButtonGUI ;
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
if ZackZackOrdnerLogErstellen
	ThreadUeberwachungLog(A_LineNumber+1,"vor OnMessage " A_ThisHotkey,A_ThisLabel,A_ThisFunc,A_ThisMenu,A_ThisMenuItem,A_ThisMenuItemPos)
OnMessage(0x4a, "Empfange_WM_COPYDATA")  ; 0x4a ist WM_COPYDATA
if ZackZackOrdnerLogErstellen
	ThreadUeberwachungLog(A_LineNumber-1,"vor OnMessage " A_ThisHotkey,A_ThisLabel,A_ThisFunc,A_ThisMenu,A_ThisMenuItem,A_ThisMenuItemPos)
return	; ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^Ende des automatischen Ausfuhreungsbereiches^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

Empfange_WM_COPYDATA(wParam, lParam)
{
	global FuerEdit1, FuerEdit2, FuerEdit3, FuerEdit4, FuerEdit5, FuerEdit6, FuerEdit7, FuerEdit8, FuerEdit9,Datenkopie
	; Thread,Priority,1 ;
    Stringadresse := NumGet(lParam + 2*A_PtrSize)  ; Ermittelt die Adresse des lpData-Elements in CopyDataStruct.
    ; Stringadresse := NumGet(lParam + 2*A_PtrSize)  ; Ermittelt die Adresse des lpData-Elements in CopyDataStruct.			; original ;
	; VarSetCapacity(Datenkopie,1000,0) ;
    Datenkopie := StrGet(Stringadresse)  ; Kopiert den String aus der Struktur.
	if ZackZackOrdnerLogErstellen
		ThreadUeberwachungLog(A_LineNumber-1,A_ThisHotkey,A_ThisLabel,A_ThisFunc,A_ThisMenu,A_ThisMenuItem,A_ThisMenuItemPos)
    ; Zeige ihn via ToolTip statt MsgBox an, so dass wir rechtzeitig fertig werden:
    ; ToolTip %A_ScriptName%`nhat den folgenden String empfangen:`n%Datenkopie%
	; StringSplit,Nachricht,Datenkopie,%A_Space% ;
	; VarSetCapacity(FuerEdit%Nachricht1%,1000,0) ;
	; FuerEdit%Nachricht1%:=Nachricht2 ;
	; ListVars ;
	SetTimer ,TimerEditUebernahme,-1
	if ZackZackOrdnerLogErstellen
		ThreadUeberwachungLog(A_LineNumber-1,A_ThisHotkey,A_ThisLabel,A_ThisFunc,A_ThisMenu,A_ThisMenuItem,A_ThisMenuItemPos)
	; TrayTip,Edit2	,1`n%Edit2% ;
	; GuiControl,, Edit2, %Edit2% ;
	; TrayTip,Edit2,1`n%Edit2% ;
	; gosub Edit2 ;
	; gosub Button1 ;
	; Gui,Submit,NoHide ;
	; TrayTip,Edit2,1`n%Edit2% ;
	; gosub GuiSubmit ;
	; ListVars ;
	; MsgBox ;
    return true  ; Die Rückgabe einer 1 (wahr) ist der übliche Weg, um diese Nachricht zu bestätigen.
}
; 20160329233748 ; /*
; 20160329233750 ; GuiVonFuncAufr(EditNr,Wert)
; 20160329233751 ; {
; 20160329233752 ; 	global Edit2
; 20160329233753 ; 	Edit%EditNr%:=Wert
; 20160329233754 ; 	TrayTip,Edit%EditNr%, %Tempo%
; 20160329233755 ; 	GuiControl,, Edit%EditNr%, % Edit%EditNr%
; 20160329233755 ; 	Gui,Submit,NoHide
; 20160329233756 ; return
; 20160329233757 ; }
; 20160329233758 ; */
; 20160329233811 ; ListLines

; 20160329104326 ; gosub WiWa
if ZackZackOrdnerLogErstellen
	ThreadUeberwachungLog(A_LineNumber-1,A_ThisHotkey,A_ThisLabel,A_ThisFunc,A_ThisMenu,A_ThisMenuItem,A_ThisMenuItemPos)

OnMessage(0x201, "WM_LBUTTONDOWN")
if ZackZackOrdnerLogErstellen
	ThreadUeberwachungLog(A_LineNumber-1,A_ThisHotkey,A_ThisLabel,A_ThisFunc,A_ThisMenu,A_ThisMenuItem,A_ThisMenuItemPos)
IfExist %SkriptDataPath%					; SkriptDataPath=%A_AppDataCommon%\Zack
{
	; gosub LeseAWPFEin ;
	OrdnerEingelesen:=true
	if ZackZackOrdnerLogErstellen
		ThreadUeberwachungLog(A_LineNumber-1,A_ThisHotkey,A_ThisLabel,A_ThisFunc,A_ThisMenu,A_ThisMenuItem,A_ThisMenuItemPos)
}
;  If Not OrdnerEingelesen ;
return
; < globale Hotkeys HotStrings >
#n::	; AutoPop Ersatz
gosub OpenGuiNebenAktWin
return

#ä::	; fuer Fehlersuche gibt mehr Meldungen aus
Fehlersuche:=true
return

#ß::	; Fehlersuche ListLines
ListLines
return

:*:*§*::°	; HotString: gibt bei Eingabe von *§* den ZackZack-intern in Speichernamen dafuer verwendeten ° aus

:*:\§\::►	; HotString: gibt bei Eingabe von \§\ den ZackZack-intern in Speichernamen dafuer verwendeten ► aus

; 20160329234932 ; /*
; :*::§:::˸				 ;
; :*::§\:::˸ ;
; :*::§:::˸ ;
; :*::§`:::˸		; invalid HotKey ;
; :*::§\`:::˸		; invalid HotKey ;
; :*::§%DotOverDot%::˸	; funzt ned ;
; :::§::				; funzt nur am Anfang oder nach ruecksetzen z.b. mit Mausklick ;
; 20160329234954 ; if (A_EndChar=DotOverDot)
; 20160329234955 ; 	send ˸
; 20160329234956 ; return
; :Z::§::˸			; ein : zuviel  funzt nur am Anfang oder nach ruecksetzen z.b. mit Mausklick ;
; :?::§::˸ ;
; :Z::§::				; funzt nur am Anfang oder nach ruecksetzen z.b. mit Mausklick ;
; 20160329235005 ; if (A_EndChar=DotOverDot)
; 20160329235006 ; 	send ˸
; 20160329235026 ; return
; :Z ?::§::				; OK ;
; 20160329235034 ; if (A_EndChar=DotOverDot)
; 20160329235034 ; 	send ˸
; 20160329235035 ; return
; 20160329235038 ; */

:?::§::	; HotString: gibt bei Eingabe von :§: den ZackZack-intern in Speichernamen dafuer verwendeten hochgestellten Doppelpunkt ˸ aus 
if (A_EndChar=DotOverDot)
	send ˸
return

; 20160330072854 ; :*b0:<em>::</em>{left 5}

::ßß::
gosub Button1
Gui,Submit,NoHide
return

#z::	; hole minimiertes Fenster.	Hinweis: Bewirkt nicht das Gleiche wie Button Ordner oder #n.
gosub SelfActivate
return
; < /globale Hotkeys HotStrings >

StaOrdnerBefehlsDateiPfadOeffnen:
IfNotExist %A_AppData%\Zack\Macro
	FileCreateDir,%A_AppData%\Zack\Macro
run, %A_AppData%\Zack\Macro
if ZackZackOrdnerLogErstellen
	ThreadUeberwachungLog(A_LineNumber-1,A_ThisHotkey,A_ThisLabel,A_ThisFunc,A_ThisMenu,A_ThisMenuItem,A_ThisMenuItemPos)
return

UserSelBefehlsDateiPfadAusfuehren:
IfNotExist %A_AppData%\Zack\Macro
	FileCreateDir,%A_AppData%\Zack\Macro,
FileSelectFile,DieserBefehlsDateiPfad,,%A_AppData%\Zack\Macro,bitte Macro auswaehlen,Macros (*.txt;*.*)
if ErrorLevel
	return
If (DieserBefehlsDateiPfad="")
	return
gosub DiesenBefehlsDateiPfadAusfuehren
return

DiesenBefehlsDateiPfadAusfuehren:							; je Zeile ein Befehl in der Datei mit dme Pfad DieserBefehlsDateiPfad
FileRead,BefehlsMacro,%DieserBefehlsDateiPfad%
BefehlsVariableAusfuehren:						; je Zeile ein Befehl in der Variablen BefehlsMacro
Loop,Parse,BefehlsMacro,`n,`r
{
	Datenkopie:=A_LoopField
	gosub TimerEditUebernahme
	sleep 20
	Loop 100
	{
		if beschaeftigt
			sleep 100
		else
			break		
	}
 	; sleep 500 ;
}
return
Edit4:													; Befehlsentgegennahme. wirkt mit . am Ende wie eine MacroZeile
HwndEdit4:
Gui,Submit,NoHide
if(SubStr(Edit4,0)=".")
{
	StringTrimRight,Edit4,Edit4,1
	GuiControl,, %HwndEdit4%, %Edit4%
	Datenkopie:=Edit4
}
else
	return
TimerEditUebernahme:						; Warten auf eingehende Befehle von Tastatur, Datei oder Variable. Ist kein Timer mehr.
; Thread,Priority,1 ;
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

	; SoundBeep,400,900 ;
	DieseDatenkopieMehrzeilig:=Datenkopie
	Loop,Parse,DieseDatenkopieMehrzeilig,`n,`r
	{
	DieseDatenkopie:=A_LoopField
	; StringReplace,DieseDatenkopie,Datenkopie,%A_tab% ;
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
	; TrayTip,IntegerErstesZeichenDieseDatenkopie,%IntegerErstesZeichenDieseDatenkopie% ;
	; sleep,2000 ;
	ZweitesZeichenDieseDatenkopie:=SubStr(DieseDatenkopie,2,1)
	; MsgBox % ErstesZeichenDieseDatenkopieIstGueltigerLaufwerksBuchstabe "	" ZweitesZeichenDieseDatenkopie "	" ErstesZeichenDieseDatenkopie "	" SkriptDataPath ;
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
		; MsgBox DieseDatenkopie=%DieseDatenkopie% ;
		StringTrimLeft,FurDieseFunktion,DieseDatenkopie,1
		StringSplit,DieseFunktionParameter,FurDieseFunktion,§,%A_Space%
		; MsgBox %DieseFunktionParameter4%	%DieseFunktionParameter5%	%DieseFunktionParameter6% ;
		if(DieseFunktionParameter1<>"")
			DieseFunktionsZuweisungsVariable:=DieseFunktionParameter1
		if(DieseFunktionParameter2<>"")
			DieseFunktion:=DieseFunktionParameter2
		else
		{
			; gosub FehlerBeep  ;
			TrayTip, BefehlsSysntax Fehler, FunktionsName fehlt!
			return
		}
		If (DieseFunktionParameter0=2)
		{
			if(DieseFunktionsZuweisungsVariable="")
				{
				If(IsFunc(DieseFunktion))
				{
					Dummy:=%DieseFunktion%()
					return
				}
			}
			else
			{
				If(IsFunc(DieseFunktion))
				{
					%DieseFunktionsZuweisungsVariable%:=%DieseFunktion%()
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
					return
				}
			}
			else
			{
				If(IsFunc(DieseFunktion))
				{
					%DieseFunktionsZuweisungsVariable%:=%DieseFunktion%(FunktionUeberGabestringErzeugen(DieseFunktionParameter3))
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
					return
				}
			}
			else
			{
				If(IsFunc(DieseFunktion))
				{
					%DieseFunktionsZuweisungsVariable%:=%DieseFunktion%(FunktionUeberGabestringErzeugen(DieseFunktionParameter3),FunktionUeberGabestringErzeugen(DieseFunktionParameter4))
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
					return
				}
			}
			else
			{
				If(IsFunc(DieseFunktion))
				{
					%DieseFunktionsZuweisungsVariable%:=%DieseFunktion%(FunktionUeberGabestringErzeugen(DieseFunktionParameter3),FunktionUeberGabestringErzeugen(DieseFunktionParameter4),FunktionUeberGabestringErzeugen(DieseFunktionParameter5))
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
					return
				}
			}
			else
			{
				If(IsFunc(DieseFunktion))
				{
					%DieseFunktionsZuweisungsVariable%:=%DieseFunktion%(FunktionUeberGabestringErzeugen(DieseFunktionParameter3),FunktionUeberGabestringErzeugen(DieseFunktionParameter4),FunktionUeberGabestringErzeugen(DieseFunktionParameter5),FunktionUeberGabestringErzeugen(DieseFunktionParameter6))
					return
				}
			}
		}
		else If (DieseFunktionParameter0 > 6)
		{
			MsgBox, 262144,%A_ScriptName% at %A_LineNumber% ,Dieser Funktionsaufruf wird Prinzipiell unterstutzt, ist momentan aber noch nicht ausformuliert. Dies ist in der Gegend von der Quelltext-Zeile %A_LineNumber% von  %A_ScriptFullPath% nachzutragen. `n`nDieser Thread endet hier.
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
			GuiControl,,%HwndEdit4%,%Edit4%
		}
		Else if LastZeichen is Integer
		{
			DieseVariable2:=SubStr(DieseDatenkopie,1,-4)
			Transform, DieseVariableDeref, Deref, %DieseVariable2% 
			Edit%LastZeichen%:=%DieseVariableDeref%
			GuiControl,,% HwndEdit%LastZeichen%,% Edit%LastZeichen%
		}
	}
	else if(InStr(DieseDatenkopie,":="))	; Variablen Zuweisung mit := erkannt
	{
		StringReplace,DieseDatenkopieDotOverDotGleich,DieseDatenkopie,:=,%A_Tab%,All
		StringSplit,DieseVariable,DieseDatenkopieDotOverDotGleich,%A_Tab%,%A_Space%
		; MsgBox, %  DieseVariable1 "	" %DieseVariable1% "	"  DieseVariable2 "	" ; %DieseVariable2%  ;
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
					; SuperDieseVariable1:=%DieseVariable2% ;
				}
			}
			; MsgBox,  DieseVariable1 "	"  DieseVariable2 "	""	"   %DieseVariable2% ; DieseVariable2Deref "	" ; %SuperDieseVariable1%   ;
			GuiControl,, %DieseVariable1%, %SuperDieseVariable1%
		}
			; SoundBeep,8000,70 ;
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
				; MsgBox, %  DieseVariable1 "	"   DieseVariable2 "	"   %DieseVariable1% "	" ;   
				
			}
			GuiControl,, %DieseVariable1%, %DieseVariable2%
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
		GuiControl,, %HwndEdit3%, %Edit3%
	}
	else if(IntegerErstesZeichenDieseDatenkopie)	; Set Edit# Feld Variante 1 erkannt
	{							; Edit#:=*
		StringTrimLeft,RestlicheZeichenDieseDatenkopie,DieseDatenkopie,1
		ThhisHwndEditName:=HwndEdit%ErstesZeichenDieseDatenkopie%
		Edit%ErstesZeichenDieseDatenkopie%:=RestlicheZeichenDieseDatenkopie
		GuiControl,, %ThhisHwndEditName%, %RestlicheZeichenDieseDatenkopie%
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
; 20160329235936 ; 		{
			; SoundBeep,250,500 ;
; 20160329235942 ; 		}
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
			; SoundBeep,350,500 ;
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
			; ThhisHwndEdit:=HwndEdit%ZweitesZeichenDieseDatenkopie% ;
			GuiControl,, %superThhisHwndEditName%, %RestlicheZeichenDieseDatenkopie%
			; if TimerFehlerSuche
				; MsgBox Timer TimerEditUebernahme %A_LineNumber% Schreibt in Edit%ZweitesZeichenDieseDatenkopie% %RestlicheZeichenDieseDatenkopie%

		}
		else	; suchfeld also Edit2 befuellen erkannt
		{
			; SoundBeep,450,500 ;
		}
	}
	else if(IsLabel(DieseDatenkopie))
		gosub %DieseDatenkopie%
	else
	{
		Edit2:=DieseDatenkopie
		GuiControl,, %HwndEdit2%, %Edit2%
		; if TimerFehlerSuche ;
			; MsgBox Timer TimerEditUebernahme %A_LineNumber% Schreibt in Edit2 %Edit2% ;
	}
}

; 20160329104457 ; if TimerFehlerSuche
; 20160329104500 ; 	MsgBox Timer TimerEditUebernahme %A_LineNumber% return
return


; 20160330084712 ; ODE:
; 20160330084713 ; DefaultEinstellungenHerstellen:
; 20160330084714 ; return

SitzungsEinstellungenEinlesen:
FileRead,BefehlsMacro,%A_AppData%\Zack\Einstellungen.txt
; MsgBox % BefehlsMacro ;
gosub BefehlsVariableAusfuehren	
return


SitzungsEinstellungenBearbeiten:
IfExist  %A_AppData%\Zack\Einstellungen.txt
	run notepad.exe "%A_AppData%\Zack\Einstellungen.txt"
return

SDE:
SitzungsEinstellungenMerken:

VarEinstellungsVarList=
(
SkriptDataPath
AktualisierungAufButton1
Edit1
Edit2
Edit3
Edit4
AktualisierungAufButton1
Edit1
Edit2
Edit3
AuAb
BsAn
ExpSel
OnTop
RegEx
AuAb
BsAn
)


AllVar=
VarList=
FileDelete,%A_AppData%\Zack\Einstellungen.txt
; 20160330084919 ; if ErrorLevel
; 20160330084920 ; 	TrayTip,FileDelete,%A_AppData%\Zack\Einstellungen.txt

; 20160330084928 ; VarList=
; 20160330084929 ; (
; 20160330084930 ; WoAn
; 20160330084930 ; 0
; 20160330084931 ; ahk_id  
; 20160330084932 ; Akt
; 20160330084933 ; AktualisierungAufButton1
; 20160330084933 ; AktWinFocusedControl  
; 20160330084934 ; AllEdit 
; 20160330084935 ; Edit1
; 20160330084936 ; Edit2
; 20160330084942 ; Edit3
; 20160330084943 ; Edit4
; 20160330084944 ; 2
; 20160330084944 ; 3
; 20160330084945 ; 4
; 20160330084946 ; 5
; 20160330084947 ; 6
; 20160330084956 ; 7
; 20160330084957 ; 8
; 20160330084958 ; 9
; 20160330084959 ; 10
; 20160330085000 ; 11
; 20160330085004 ; AlleVerwenden  
; 20160330085005 ; AllVar 
; 20160330085006 ; AuAb
; 20160330085006 ; BsAn
; 20160330085007 ; ExpSel
; 20160330085008 ; FiCa
; 20160330085009 ; Glas
; 20160330085010 ; OnTop
; 20160330085010 ; RegEx
; 20160330085011 ; AnfTeilWortListe  
; 20160330085012 ; AnfTeilWortPfad  
; 20160330085013 ; AnSchreibMarkenAusgabeAnhaengen
; 20160330085014 ; AnzListvars
; 20160330085017 ; AuAb
; 20160330085018 ; awpfPath  
; 20160330085019 ; AwpfPfad  
; 20160330085030 ; bAtemp  
; 20160330085031 ; BefehlsMacro  
; 20160330085032 ; BeiGuiWinHwndkeinAutoPop 
; 20160330085032 ; beschaeftigt
; 20160330085033 ; bestehenderWurzelName  
; 20160330085035 ; bGutTemp
; 20160330085036 ; BsAn
; 20160330085037 ; ControlText  
; 20160330085038 ; DateiPfade  
; 20160330085038 ; DateiPfadeWerdenUebergeben  
; 20160330085039 ; Datenkopie
; 20160330085040 ; DeltaLastGuiMinizeTime  
; 20160330085041 ; DieseDatenkopie  
; 20160330085041 ; DieseFarbe  
; 20160330085042 ; DieserBefehlsDateiPfad  
; 20160330085045 ; DieseVariable0  
; 20160330085050 ; DieseVariable1  
; 20160330085051 ; DieseVariable2  
; 20160330085051 ; DieseZahl  
; 20160330085052 ; DrittesZeichenDieseDatenkopie  
; 20160330085053 ; DriveNames
; 20160330085054 ; DriveNames1CList
; 20160330085055 ; DriveNamesKommaList
; 20160330085055 ; dummy
; 20160330085056 ; Durchsichtig
; 20160330085057 ; Edit1
; 20160330085101 ; Edit2
; 20160330085101 ; Edit2Merker
; 20160330085102 ; Edit3
; 20160330085103 ; Edit4
; 20160330085104 ; Edit5
; 20160330085105 ; Edit5Breite
; 20160330085105 ; Edit5Hoehe
; 20160330085109 ; Edit5Y0
; 20160330085110 ; Edit6
; 20160330085111 ; Edit6Merker
; 20160330085112 ; Edit7
; 20160330085112 ; Edit7Merker  
; 20160330085113 ; Edit8
; 20160330085114 ; Edit8Ordner0
; 20160330085115 ; Edit8Ordner1
; 20160330085117 ; Edit8Ordner2
; 20160330085118 ; Edit8Ordner3
; 20160330085118 ; Edit8Ordner4
; 20160330085119 ; Edit8Ordner5
; 20160330085120 ; Edit8Run  
; 20160330085121 ; Edit9
; 20160330085122 ; EdWa
; 20160330085130 ; EigenFensterB  
; 20160330085131 ; EigenFensterH  
; 20160330085132 ; EigenFensterX  
; 20160330085133 ; EigenFensterY  
; 20160330085134 ; EinmalKopieDieseDatenkopie  
; 20160330085134 ; EinstelligDieseDatenkopie  
; 20160330085135 ; ErrorLevel
; 20160330085136 ; ErstesZeichenDieseDatenkopie  
; 20160330085137 ; ErstesZeichenDieseDatenkopieIstGueltigerLaufwerksBuchstabe  
; 20160330085138 ; ExplWinB
; 20160330085139 ; ExplWinH
; 20160330085140 ; ExplWinX
; 20160330085141 ; ExplWinY
; 20160330085141 ; ExpSel
; 20160330085142 ; Farben
; 20160330085143 ; Fehlersuche
; 20160330085144 ; FensterTitelText0
; 20160330085145 ; FensterTitelText1
; 20160330085145 ; FensterTitelText2
; 20160330085146 ; FensterTitelTextAusnahmen
; 20160330085147 ; FensterTitelTextZeile0
; 20160330085148 ; FiCa
; 20160330085149 ; FremdFensterB
; 20160330085151 ; FremdFensterH
; 20160330085152 ; FremdFensterX
; 20160330085153 ; FremdFensterY
; 20160330085154 ; FuerClipEdit5
; 20160330085154 ; FuerEdit1
; 20160330085155 ; FuerEdit2
; 20160330085156 ; FuerEdit3
; 20160330085157 ; FuerEdit4
; 20160330085157 ; FuerEdit5
; 20160330085209 ; FuerEdit6
; 20160330085210 ; FuerEdit7
; 20160330085210 ; FuerEdit8
; 20160330085211 ; FuerEdit9
; 20160330085212 ; FuncName
; 20160330085213 ; Glas
; 20160330085213 ; GlobalBenutzerEin2
; 20160330085214 ; GlobalEndEdit1Loop
; 20160330085215 ; GlobalMomentanerFolderVorschlag1
; 20160330085216 ; GlobalMomentanerFolderVorschlag2
; 20160330085217 ; GuiHeight
; 20160330085217 ; GuiMinizeTime
; 20160330085218 ; GuiMinMax
; 20160330085219 ; GuiWinHwnd
; 20160330085220 ; hAtemp
; 20160330085221 ; hGutTemp
; 20160330085221 ; HTML
; 20160330085222 ; HTML_Liste
; 20160330085223 ; HWND
; 20160330085224 ; HwndButton1
; 20160330085225 ; HwndButton2
; 20160330085225 ; HwndButton3
; 20160330085226 ; HwndButton4
; 20160330085227 ; HwndButton5
; 20160330085227 ; HwndCheckA0
; 20160330085228 ; HwndCheckA5
; 20160330085229 ; HwndCheckB2
; 20160330085230 ; HwndCheckB4
; 20160330085230 ; HwndCheckB6
; 20160330085231 ; HwndCheckB8
; 20160330085232 ; HwndCheckC0
; 20160330085233 ; HwndCheckE0
; 20160330085233 ; HwndCheckE5
; 20160330085234 ; HwndCheckE9
; 20160330085235 ; HwndCheckF0
; 20160330085236 ; HwndCheckG0
; 20160330085236 ; HwndCheckG3
; 20160330085237 ; HwndCheckG9
; 20160330085238 ; HwndCheckH0
; 20160330085241 ; HwndCheckI0
; 20160330085242 ; HwndCheckJ0
; 20160330085243 ; HwndCheckK0
; 20160330085244 ; HwndEdit1
; 20160330085245 ; HwndEdit2
; 20160330085245 ; HwndEdit3
; 20160330085246 ; HwndEdit4
; 20160330085247 ; HwndEdit5
; 20160330085255 ; HwndEdit6
; 20160330085256 ; HwndEdit7
; 20160330085256 ; HwndEdit8
; 20160330085257 ; HwndEdit9
; 20160330085258 ; HwndHwndCheckG3
; 20160330085259 ; HwndSuFi
; 20160330085259 ; InAbcListeZweitesZeichenDieseDatenkopie
; 20160330085300 ; IndexierenBeenden
; 20160330085301 ; IntegerDieseDatenkopie
; 20160330085302 ; IntegerDrittesZeichenDieseDatenkopie
; 20160330085302 ; IntegerErstesZeichenDieseDatenkopie
; 20160330085303 ; IntegerZweitesZeichenDieseDatenkopie
; 20160330085304 ; LabelList
; 20160330085305 ; LaengeDieseDatenkopie
; 20160330085306 ; LastAufmerksamkeitText
; 20160330085306 ; LastAufmerksamkeitTitle
; 20160330085307 ; LastGuiMinizeTime
; 20160330085310 ; LastScriptMinimizedUser
; 20160330085311 ; LastSkriptDataPath
; 20160330085312 ; LastThisActiveOpenOrSaveWinWND
; 20160330085313 ; LaufwerksBuchstabe0
; 20160330085314 ; LaufwerksBuchstabe1
; 20160330085314 ; LaufwerksBuchstabe2
; 20160330085315 ; LaufwerksBuchstabe3
; 20160330085320 ; LauscheTast
; 20160330085321 ; LeseEin[1 of 3]: 0
; 20160330085322 ; LetzerAendererVonEdit5[5 of 7]: Edit2
; 20160330085323 ; LoopFieldRun[0 of 0]:  
; 20160330085324 ; LoopFileDirVonDir[0 of 0]:  
; 20160330085324 ; MacroDir[0 of 0]:  
; 20160330085325 ; MacroMusterDateiAnzahl[0 of 0]:  
; 20160330085326 ; MacroMusterDateiInhalt1[0 of 0]:  
; 20160330085327 ; MacroMusterDateiInhalt2[0 of 0]:  
; 20160330085327 ; MacroMusterDateiInhalt3[0 of 0]:  
; 20160330085328 ; MacroMusterDateiName1[0 of 0]:  
; 20160330085329 ; MacroMusterDateiName2[0 of 0]:  
; 20160330085330 ; MacroMusterDateiName3[0 of 0]:  
; 20160330085331 ; Meldung[0 of 0]:  
; 20160330085331 ; Min[1 of 3]: 0
; 20160330085332 ; MinInWork[0 of 0]:  
; 20160330085333 ; MinMaxOut[0 of 0]:  
; 20160330085334 ; MinWaitTakt[4 of 7]: 5000
; 20160330085334 ; MusterMacroDateiPfade[0 of 0]:  
; 20160330085335 ; NeueBreite[3 of 3]: 506
; 20160330085336 ; NeueHoehe[3 of 3]: 282
; 20160330085337 ; NeuerContainerName[0 of 0]:  
; 20160330085337 ; NeueWurzel[0 of 0]:  
; 20160330085338 ; NeueWurzel0[0 of 0]:  
; 20160330085347 ; NewFavoritInhalt[0 of 0]:  
; 20160330085347 ; Nextwpf[0 of 0]:  
; 20160330085348 ; OnTop[1 of 3]: 1
; 20160330085349 ; OrdnerEingelesen[1 of 3]: 0
; 20160330085350 ; OriginalErhalten[0 of 0]:  
; 20160330085351 ; OutDir[0 of 0]:  
; 20160330085352 ; OutExt[0 of 0]:  
; 20160330085353 ; OutNameNoExt[0 of 0]:  
; 20160330085353 ; OutNameNoExtOrg[0 of 0]:  
; 20160330085354 ; PlusDop[0 of 0]:  
; 20160330085355 ; R[0 of 0]:  
; 20160330085356 ; RegEx[1 of 3]: 0
; 20160330085357 ; Rekur[1 of 3]: 1
; 20160330085358 ; Rekursiv[1 of 3]: R
; 20160330085359 ; RestlicheZeichenDieseDatenkopie[0 of 0]:  
; 20160330085401 ; RunAlternative[0 of 0]:  
; 20160330085402 ; ScripKlammerInhalt[2 of 3]: 52
; 20160330085403 ; ScriptDirKlammerInhalt[0 of 0]:  
; 20160330085404 ; ScriptFullPathOhneKlammer[44 of 44]: E:\GeKo2All\ZackZackOrdner\SchnellOrdner.ahk
; 20160330085405 ; ScriptKlammerMitInhalt[4 of 7]: [52]
; 20160330085405 ; ScriptMinimized[0 of 0]:  
; 20160330085406 ; ScriptMinimizedTime[0 of 0]:  
; 20160330085407 ; ScriptNamneOhneKlammer[17 of 17]: SchnellOrdner.ahk
; 20160330085408 ; ScriptQuellcode[0 of 0]:  
; 20160330085409 ; ScriptQuellLabelZeile0[0 of 0]:  
; 20160330085409 ; ScriptQuellLabelZeile1[0 of 0]:  
; 20160330085410 ; SeEn[1 of 3]: 0
; 20160330085411 ; SelectedFile[0 of 0]:  
; 20160330085412 ; SendEnterNachSchreibmarkeEinfuegen[0 of 0]:  
; 20160330085413 ; SkriptDataPath[35 of 63]: C:\ProgramData\Zack\WuCont\Laufwerk
; 20160330085414 ; SkriptDataPathKurzNachProgrammbeginn[0 of 0]:  
; 20160330085414 ; SkriptDataPathTemp[0 of 0]:  
; 20160330085415 ; SkriptVersion[0 of 0]:  
; 20160330085416 ; SofortVerwerfenHwnd[0 of 0]:  
; 20160330085417 ; SrLi[1 of 3]: 1
; 20160330085417 ; SuchAbbruch[1 of 3]: 0
; 20160330085418 ; SucheAbrechen[2 of 3]: 20
; 20160330085419 ; SuFi[1 of 3]: 0
; 20160330085420 ; SuFiMerker[0 of 0]:  
; 20160330085420 ; SumDateien[0 of 0]:  
; 20160330085421 ; superDieseVariable1[0 of 0]:  
; 20160330085422 ; superThhisHwndEditName[0 of 0]:  
; 20160330085423 ; TeilWortListe[0 of 0]:  
; 20160330085424 ; TeilWortPfad[0 of 0]:  
; 20160330085424 ; TeilWortWort[0 of 0]:  
; 20160330085430 ; TempSpielw[0 of 0]:  
; 20160330085431 ; ThhisHwndCheck[0 of 0]:  
; 20160330085432 ; ThhisHwndEditName[0 of 0]:  
; 20160330085433 ; ThisActiveHWND[7 of 63]: 0xb0526
; 20160330085434 ; ThisActiveOpenOrSaveWinWND[3 of 63]: 0x0
; 20160330085435 ; ThisAufmerksamkeitHWND[7 of 63]: 0xb0526
; 20160330085435 ; ThisAufmerksamkeitText[50 of 13095]: Script lines most recently executed (oldest first)
; 20160330085436 ; ThisAufmerksamkeitTitle[72 of 259]: E:\GeKo2All\ZackZackOrdner\SchnellOrdner[52].ahk - AutoHotke...
; 20160330085437 ; ThisAusnahmeInhalte[457 of 502]: 

; 20160330085444 ; Ausführen	Geben Sie den Namen
; 20160330085446 ; Run	Type the Name
; 20160330085447 ; Hilfe
; 20160330085451 ; ...
; 20160330085453 ; ThisAusnahmeTeilInhalte[235 of 235]: Ausführen	Geben Sie den Namen
; 20160330085454 ; Run	Type the Name
; 20160330085455 ; Hilfe
; 20160330085456 ; Hel...
; 20160330085456 ; ThisawpfInhalt[0 of 0]:  
; 20160330085457 ; ThisContainer[0 of 0]:  
; 20160330085458 ; ThisDateiNameText[0 of 0]:  
; 20160330085459 ; ThisHtmlPath[0 of 0]:  
; 20160330085500 ; ThisMarkierfolder[5 of 63]: 2Home
; 20160330085501 ; ThisMsgBoxAnswer[0 of 0]:  
; 20160330085502 ; ThisOpenOrSaveWinWND[3 of 63]: 0x0
; 20160330085502 ; ThisVarInh[0 of 0]:  
; 20160330085503 ; ThisWurzel[0 of 0]:  
; 20160330085504 ; ThisZeile[0 of 0]:  
; 20160330085505 ; TimerBeiErgebnisFalschAktiv[0 of 0]:  
; 20160330085506 ; TimerBeiErgeebnisUnsicherAktiv[0 of 0]:  
; 20160330085507 ; TimerFehlerSuche[0 of 0]:  
; 20160330085508 ; TitelleistenPlusMenuHoehe[2 of 3]: 51
; 20160330085509 ; UserMinimized[0 of 0]:  
; 20160330085510 ; UserMinimizedTime[0 of 0]:  
; 20160330085511 ; VariableSetzen0[0 of 0]:  
; 20160330085519 ; VariableSetzen1[0 of 0]:  
; 20160330085520 ; VariableSetzen2[0 of 0]:  
; 20160330085521 ; VarList[0 of 0]:  
; 20160330085522 ; ViertesZeichenDieseDatenkopie[0 of 0]:  
; 20160330085523 ; VorLabelList[0 of 0]:  
; 20160330085524 ; VorschlagAwpf[0 of 0]:  
; 20160330085524 ; WichtigeTrayTipsAnzeigen[1 of 3]: 1
; 20160330085525 ; WinB[0 of 0]:  
; 20160330085526 ; WinH[0 of 0]:  
; 20160330085527 ; WinMin[0 of 0]:  
; 20160330085528 ; WinX[0 of 0]:  
; 20160330085528 ; WinY[0 of 0]:  
; 20160330085529 ; WirksameFensterTitelTextAusnahmen[109 of 259]: 
; 20160330085530 ; C:\Users\Gerd\AppData\Roaming\Zack\SchnellOrdner.ahk.ausn
; 20160330085531 ; ...
; 20160330085532 ; WiWa[1 of 3]: 1
; 20160330085532 ; WoAn[1 of 3]: 0
; 20160330085533 ; WurzelContainer[26 of 63]: C:\ProgramData\Zack\WuCont
; 20160330085534 ; xAtemp[0 of 0]:  
; 20160330085535 ; xGutTemp[0 of 0]:  
; 20160330085536 ; yAtemp[0 of 0]:  
; 20160330085536 ; YEdit5default[3 of 3]: 176
; 20160330085537 ; yGutTemp[0 of 0]:  
; 20160330085538 ; ZackData[19 of 63]: C:\ProgramData\Zack
; 20160330085539 ; Zahlen[0 of 0]:  
; 20160330085540 ; ZahlenTe[0 of 0]:  
; 20160330085541 ; ZumSpeichernThisAufmerksamkeitText[62 of 62]: 46<br>angezeigte Pfade<br>Nr. Wahl<br>Pfade<br>Suche<br>1<br...
; 20160330085542 ; ZweitesZeichenDieseDatenkopie[0 of 0]:  


; 20160330085613 ; OnTop
; 20160330085614 ; RegEx
; 20160330085614 ; Rekursiv
; 20160330085615 ; SeEn
; 20160330085616 ; SrLi
; 20160330085617 ; SuFi
; 20160330085617 ; WiWa

; 20160330085625 ; )
Loop,Parse,VarEinstellungsVarList,`n,`r
{
	; SuperLoopField:=%A_LoopField% ;
	AllVar:=AllVar "`r`n" A_LoopField "=" %A_LoopField%
	; %A_LoopField% = %SuperLoopField% ;
}
NachBefehle=
(
Button1
)
ThisAbarbeiteiten=
(
%AllVar%`r`n
%NachBefehle%
)
Fileappend, %ThisAbarbeiteiten%, %A_AppData%\Zack\Einstellungen.txt
; 20160330091303 ; run, %A_AppData%\Zack\Einstellungen.txt
if ZackZackOrdnerLogErstellen
	ThreadUeberwachungLog(A_LineNumber-1,A_ThisHotkey,A_ThisLabel,A_ThisFunc,A_ThisMenu,A_ThisMenuItem,A_ThisMenuItemPos)
return

SkriptOrdnerOeffnen:
run, %A_ScriptDir%
return
DataOrdnerOeffnen:					
run, %ZackData%
return

HwndHwndCheckE0:
SuFi:=ViertesZeichenDieseDatenkopie
GuiControl,,%HwndCheckE0%, %ViertesZeichenDieseDatenkopie%
return
HwndHwndCheckE5:
RegEx:=ViertesZeichenDieseDatenkopie
GuiControl,,%HwndCheckE5%, %ViertesZeichenDieseDatenkopie%
return
; noch ffuer alle machen ########################################################################################### ;


; SoundBeep,500,250 ;
; SoundBeep,1500,250 ;
dummy:=
return

LeseEin:
Gui,Submit,NoHide
; SoundBeep, 250 ;
; MsgBox % LeseEin ;
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
; 999999 ;
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
GuiFortegeschrittenenerModus:
GuiControl,Show,Rückgabeopt
GuiControl,Show,..\
GuiControl,Show,<--
GuiControl,Show,ok
GuiControl,Show,Abbruch
GuiControl,Show,Suche vom
GuiControl,Show,WortAnfang
GuiControl,Show,Edit6
GuiControl,Show,AutoPop
GuiControl,Show,ExpSel
GuiControl,Show,Edit4
GuiControl,Show,Abbruchnach
GuiControl,Show,Iterationen
GuiControl,Show,Fenster
GuiControl,Show,RegEx
GuiControl,Show,OnTop
GuiControl,Show,Akt
GuiControl,Show,Min
GuiControl,Show,Pfade einlesen
GuiControl,Show,Rekursiv
GuiControl,Show,Pfadeeinlesen
return

return
GuiAnfaengerModus:
GuiControl,Hide,Rückgabeopt
GuiControl,Hide,..\
GuiControl,Hide,<--
GuiControl,Hide,ok
GuiControl,Hide,Abbruch
GuiControl,Hide,Suche vom
GuiControl,Hide,WortAnfang
GuiControl,Hide,Edit6
GuiControl,Hide,AutoPop
GuiControl,Hide,ExpSel
GuiControl,Hide,Edit4
GuiControl,Hide,Abbruchnach
GuiControl,Hide,Iterationen
GuiControl,Hide,Fenster
GuiControl,Hide,RegEx
GuiControl,Hide,OnTop
GuiControl,Hide,Akt
GuiControl,Hide,Min
GuiControl,Hide,Pfade einlesen
GuiControl,Hide,Rekursiv
GuiControl,Hide,Pfadeeinlesen
return

; 20160329173228 ; AutoLoadBearbeiten:
; 20160329173230 ; IfExist %A_AppData%\%ScriptNamneOhneKlammer%.awpf
; 20160329173230 ; 	run notepad.exe "%A_AppData%\%ScriptNamneOhneKlammer%.awpf"
; 20160329173232 ; else
; 20160329173233 ; {
; 20160329173234 ; 	VorschlagAwpf=
		
		; 20160329173244 ; DriveGet,DriveNames,List
		; MsgBox % DriveNames
; 20160329173247 ; 		Loop,Parse,DriveNames
; 20160329173249 ; 		{
			; OrdnerPfade("Indizieren", A_LoopField ":\*")
; 20160329173251 ; 			VorschlagAwpf:=VorschlagAwpf "`r`n"  A_LoopField ":\*"
; 20160329173253 ; 		}
; 20160329173256 ; 	StringTrimLeft,VorschlagAwpf,VorschlagAwpf,2
; 20160329173258 ; 	FileAppend,%VorschlagAwpf%,%A_AppData%\%ScriptNamneOhneKlammer%.awpf
; 20160329173300 ; 	run notepad.exe "%A_AppData%\%ScriptNamneOhneKlammer%.awpf"
; 20160329173301 ; }

; 20160329173310 ; return
LangsamDemoToggle:
if LangsamDemo
	LangsamDemo:=false
else
{
	MsgBox, 8192, Such-Gimmik, Stark verlangsamte Suche mit ZwischenErgebnisAnzeige `n`nEin`n`nnochmal:	wieder aus.`n`n`nAchtung: Bei kurzen Suchbegriffen und einer hohen  (Schleifen-Iterations)-Abbr-(uch-Zahl) dauert es ewig. `nBetaetigen des Schliess X oben rechts`, sollte jedoch immer`, also auch mitten in der Suchzusammenstellung  funktionieren. Auch das Ausschalten des Demo-Modusses wird mitten in der Suchzusammenstellung unterstuetzt., 60
	LangsamDemo:=true
}
return

Info:
gosub VersionsHistorieEinlesen
FileDelete,%A_ScriptDir%\VersionsHistorie.txt
FileAppend, ZackZackOrdner hilft bei dem schnellen finden von Ordnern.`n`nBeta Version 0.164`nGerdi `n`n`nVersionsHistorie`n`n%VersionsHistorie%,%A_ScriptDir%\VersionsHistorie.txt
run notepad.exe "%A_ScriptDir%\VersionsHistorie.txt"
return

VersionsHistorieEinlesen:
BekannteFehler=
(
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
-	Der automatische Start der Hilfe nach Neu-Installationen funktioniert nicht zuverlaessig.
-	Allgemein bestehen noch ein paar interne Herausforderungen, welche die Timer betreffen.
	Wenn ZackZackOrdner mal nicht richtig reagiert, kann das Entfernen der Timerhaken WinWait und EdWa Abhilfe bringen,
	es wird jedoch in solchen Faellen immer ein Neustart von ZackZackOrdner empfohlen.
	Nach einem Neustart 10Sekunden warten, dass sich die Timer austoben koennen, ist momentan (Version 0.123) auch empfehlenswert.
)
VersionsHistorie=
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
0.116	Button6 auchbei nicht installiertem AHK zugaenglich gemacht
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
0.136	RechtsKlick ins fenster auf ein nicht anderweitig belegtes Control bzw. auf kein Control bewirkt Ruecksetzen fast (nicht OnTop) aller Haken und Edit Felder. Der Kontainer bleibt.
0.137	Fehler bei Drives un Favoriten behoben
0.138	Haken Zeige Dateien in Zeige Inhalte umbenannt
0.139	Nicht mehr aktive Controls versteckt.
0.140	Beginner-Ansicht / Fortgeschrittenen-Ansicht via Menue | Optionen | Einstellungen waehlbar.
	Default: Beginner-Ansicht
0.142	!Fav Ordner Fehler beseitigt
0.143	Tastatur-Umleitung nach CapsLock CapsLock von Dauer-An auf zuschaltbar (Tray-Menue von TastWatch) umgestellt, da zu oft versehentlich ausgeloesst.
0.144	AutoFavorit (Default: 1) testweise für Button 2 und 4 implementiert, Pruefen ob durch "Gosub PlusStern" alle gewuenschte AutoFavoriten erwischt werden!
0.145	umgestellt auf EXE-freien Start bei NurExeStartErlaubt:=false
0.146	Beim schreiben ins Pfad Nr. Feld (Edit3) funkt das Skript nicht mehr dazwischen, wenn die Loesungsmenge verlassen wird. Wenn der Fokus woanders ist wird die Pfadnummer nach wie vor auf 1 gesetzt.
0.147	Log optional
0.148	Aufraeum-Arbeiten im Quelltext
0.149	einige TrayTipp's deaktiviert
0.150	Macro Ordner fehlte in der GitHub Version
0.151	Holle's FileSearch.ahk bei Menue | Edit8 | DateiSuche eingebunden. (Manuel muss noch der FileSearchPath eingetragen werden)
0.152	Wenn keine ausn Datei im Data-Ordner, dann Kopie vom Skriptordner 
0.153	Default AutoPop:=false Ersatz: Tastenkombination #n	ruft OpenGuiNebenAktWin auf
0.154	
bis		alle Timer des Hauptskriptes entfernt. QuellText um ca. 2000 Zeilen gekuerzt. Die Hilfe muss noch nachgezogen werden
0.162
0.163	Bei Pfad-gefilterten Suchen musste der Dafaulwert von Edit6 (Anzahl beruecksichtigter Cache-Dateien) hochgesetzt werden. 
		Das automatische Hochsetzen und Rucksetzen ist nur bei den rechts stehenden Defaultwerten aktiv. (gewaehlt wurde 400 statt 20)
		Hierzu draengen sich spezielle Filter auf, welche die Performanz sogar erhoehen, und meist reichen: 
		Die jeweilige Suche auf die einzelnen Start-Pfade beschraenken. (in einer zukuenftigen Version vorgesehen)
0.164	Kontainermenue verschlankt und uebersichtlicher gestaltet.
)
return
Hilfe:
gosub HilfeVorbereiten
HTML1=
(
<html>
<head>
<title>ZackZackOrdner Hilfe</title>
<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1">
</head>
<body bgcolor="#FFFFFF" text="#000000">
<IMG SRC="ZackZackFensterBeispiel.jpg"  ALT="Fenster Beispiel" ALIGN=RIGHT>
<h1>ZackZackOrdner Hilfe</h1>
<h2>Einleitung</h2>
Das Objekt der Begierde ist hier der Ordner Alias Verzeichnis, nicht wie sonst ueblich die Datei.<br>
(Keinesfalls soll hier der Explorer nachprogrammiert oder gar ersetzt werden, sonder nur -- die nach Autorenmeinung vorhandene schlechte Ordnerhandhabung --  im Zusammenarbeits-Modell verbessert werden.)<br>
<br>
Schnelles auffinden von Ordnern fuer<br>
 - Speichern und Oeffnen Dialoge (Button2),<br>
 - das Oeffnen bzw. das Aendern des Pfades von Explorer- Fenstern (Button4),<br>
 - Kopier-Aktionen (Button5),<br>
ist die Aufgabe dieses Skriptes.<br>
<br>
Waehrend zentral unter den Buttons der Ordner-Suchbegriff eingegeben wird, 
werden drunter schon die dazugehoerigen Pfade angezeigt (sofern sie geladen wurden bspw. mit: Menue | Start-Pfad | einlesen).<br>
Ganz oben wird nur der Pfad der Liste unten angezeigt, dessen Nummer im Feld Pfad Nr. steht.
Dieser Pfad wird bei den meisten Aktionen der Buttons verwendet: ( - von links nach rechts bzw. * im Explorer) <br>
<br>
 - (Button1)  aktualisiert den Pfad selbst --> <b>Klick-Empfehlung</b> oder <b>F5</b> bei jedem interessierenden Zwischenergebnis<br>
 - (Button2)  schnelle Ordnerauswahl in Datei-Auswahl-Fenstern des Betriebsystems <br>
 - (Button3)  Liste --> Clipboard <br>
 - (Button4)  Auswahl in einem (neuen) Explorer-Fenster oeffnen <br>
 - (Button5)  Kopieren/Verschieben von Datein, die in einem Explorer-Fenster vorher manuell markiert wurden 
 und mit der Tastenkombination Control + C ins Clipboard gebracht wurden. (Kopie-Ziel ist die Auswahl also die Zeile ganz oben)<br>
 - (Button6)  Benutzerdefiniertes wenn benutzerspezifisches Skript Button6.ahk vorhanden.<br>
 <br>
 * (Button<i>Ordner</i>)  bei bestehendem aktivem Explorer-Fenster wird durch Klick auf <i>Ordner</i> das ZackZackOrdner-Fenster genau daueber geoeffnet. Das Ergebnis wird nach erfolgter Auswahl mittels (Button4) in das Explorer-Fenster genau darunter zuruckgeschrieben und das urspruengliche Explorer-Fenster wieder aktiviert. <br>
<br>
(Button <i>Ordner</i> ist der einzelne Button, der nur ueber aktivierten Explorer-Fenstern erscheint, er ist mit <i>Ordner</i> beschriftet)
<br>
Eine weitere wichtige Funktion "AutoPop" (wird beendet mit Button2) soll noch kurz gezeigt werden.<br>
Voraussetzung: Haken bei AutoPop° ist gesetzt. (° Nur in der Fortgeschrittenen-Ansicht sichtbar)<br>
Minimiere das ZackZackOrdner Fenster mit F4 und oeffne ein anders Programm, welches Speichern unter oder Datei oeffnen zulaesst. Mach dies und das ZackZackOrdner Fenster sollte aufspringen. dort kann nun wieder ein Ordner vorgewaehlt werden, der jedoch mit dem Button2 -> I direkt vor dem Dateiname eingefuegt wird.<br>
Falls dies beim gewaehlten Programm nicht (vollstaendig) funktioniert (z.B. IrfanView hat die FileSelect-Funktionalitaet auf Bilder optimiert und dadurch den Standart verlassen) kann auch <font size="-1">(nach dem erfolglos mit den Haken° unterm Button2 getestet wurde)</font> der -> Clip Button3 (oder noch gezielter Rechtsklick auf Nummer links vom gewuenschten Pfad: MausKontext-Meue | Set Clipboard)  verwendet werden um das Ergbnis in den Zwischenspeicher zu bringen, aus dem es dann manuell an die richtige Stelle kopiert werden kann.<br>
<br>
Da man ja am Ende doch heaufig eine Datei braucht wurde<br>
Menue | Edit8 | DateiSuche <br>
eingerichtet (Benoetigt: DateiSuche-Skript), diese Suche beginnt im Pfad, der im obersten Feld steht.<br>
Ueber das Zusatz-Feld kann gleich der Datei-Such-Begriff mitgegeben werden.<br>
Wenn der Datei-Such-Begriff mit Punkt endet, wird die Suche auch gleich im DateiSuche-Skript (natuerlich ohne den . am Ende) ohne die sonst noetige Enter-Taste durchgefuehrt.<br>
<br>
Diese Hilfe ist uebers Menue oder mit Taste F1 zu erreichen. Sie erstellt und oeffnet sich automatisch, wenn (noch) keine Datei Namens %ScriptFullPathOhneKlammer%.htm vorhanden ist, also normalerweise beim Erststart.<br>
<h2>Installation</h2>
Kopiere den kompletten ZackZackOrdner an eine beliebige Stelle und starte SucheOrdner.exe.<br>
Im Fallle eines 32Bit Betriebssystems, 
sind saemtliche Exe-Dateien (mit dem gruenen H rechts<IMG SRC="AutoHotkeyIcon.jpg"  ALT="Fenster Beispiel" ALIGN=RIGHT> ), 
durch jeweils die gleiche AutoHotKey.exe fuer 32-Bit Systeme, 
von AhkOrg.net Version 1.Hoechste, zu ersetzen
und so umzubenennen, dass alle Dateinamen wieder wie vorher sind.<br>
<br>
<IMG SRC="GeKoLi.jpg" WIDTH=37  HEIGHT=37 ALT="Haupt-Icon von SchnellOrdner.ahk" ALIGN=RIGHT>
Nach erfolgter Installation und gestartetem Program findet man zu dem Fenster siehe Bild ganz oben rechts auch noch pro Programm ein Icon im Tray-Menue.
Das Tray-Menue ist standartmaessig unten rechts links vom Datum. Meisst ist das Icon erst sichtbar wenn man das kleine weise dreieck,
welches auch als Pfeil nach oben gedeutet werden kann, mit der linken Maustaste klickt. Folgende Icons sollten sichtbar<br>
<IMG SRC="GeKoRe.jpg" WIDTH=37 HEIGHT=37 ALT="Icon von  TastWatch.ahk" ALIGN=RIGHT>
 - Haupt-Icon von SchnellOrdner.ahk (vorwiegend gelb) fuer das HauptProgramm<br>

 - Icon von TastWatch.ahk (vorwiegend blau)  fuer den Ordner Button und die Caps Caps ... Tab Tastatur-Bedinung<br>

bzw. zeitweise sichtbar<br>
 - Icon von Dir2Paths.ahk (vorwiegend weis) fuer die Cache-Befuellung mit den Start-Pfaden<IMG SRC="GeKoOb.jpg" WIDTH=37 HEIGHT=37 ALT="Icon von  Dir2Paths.ahk" ALIGN=RIGHT><br>

 - oder Optional  (vorwiegend gruen) fuer die PlugIns<br>

sein.<br>
Wer meint andere Icons haben zu moechten, der kann diese im Quelltext unter<br> 
<code>Menu,Tray,icon,<i>NeuerDateiname.ico</i></code><br>
auswaehlen.<br>

<IMG SRC="AutoHotkeyIcon.jpg" ALT="Icon von  Button6.ahk" ALIGN=RIGHT><br>
Wenn man die Icons im Tray-Menue rechts-klickt sind <b>folgende Aktionen</b> moeglich:<br>
 - Open		-> zeigt an welche Quellzeilen gerade durchlaufen worden sind / die Variablenbelegung / die Hotkeys und mehr fuer die Fehlersuche.<br>
 - Help		-> zu AutoHotKey (<b>sehr empfehlenswert</b>, funktioniert nur mit installiertem AutoHotKey oder mit einer Kopie von AutoHotkey.chm im Skript-Verzeichnis) <br>
 - Windows Spy 	-> Fenster und Control-Infos  (funktioniert nur mit installiertem AutoHotKey oder mit einer Kopie von AU3_Spy.exe im Skript-Verzeichnis)<br>
 - Reload This Script 	-> <b>Neustart</b> <br>
 - Edit This Script 	-> nur fuer Programmiererfahrene (fuer Anfaenger ist AutoHotKey durch aus geeignet aber mit kleineren Projekten und besser Quellzeilen-Doku)<br>
 - Suspend Hotkeys<br>
 - Pause Script<br>
 - Exit 	-> zum <b>Beenden</b> von Skripten<br>

<h2>Wichtige hinweise</h2>
Die TastenKombination [Win] + [z] zeigt das ZackZackOrdner-Fenster an, dieser Hotkey ist immer Wirksam, egal welches Programm aktiv ist. Fast alle anderen Hotkeys, wie z. B. F4 der das Fenster wieder minimiert, wirken nur beim aktivierten Fenster<br>
<br>
Das Skript kann schon verwendet werden, solange noch der Cache befuellt wird. Nach Menue | Start-Pfad | aktualisieren sollte kurz gewartet werden, bis alle in einem eigenen Pozess laufenden Skripte Dir2Paths gestartet werden.<br>
<br>
Favoriten sind technisch gesehen zusaetzliche Kopien, die wegen des Sterns ganz links beim Sortieren nach vorne kommen. D.h. Favoriten sind doppelt vorhanden: die beim Einlesen erzeugte sternlose Variante, sowie die Bewertete Variante <br>
Es koennen auch mehrere Favoritensterne pro Eintrag fuer SuperFavoriten eingegeben werden.<br>
<br>
Bei sehr kurzen Suchstrings kann das Ergebnis unvollstaendig sein, Abhilfe Zahl im Feld° Abbruch nach [...] Iterationen erhoehen (bewirkt laengere Rechenzeiten).<br>
<br>
Befehlsdateien nicht vertrauenswuerdiger Herkunft bieten ein Gefaerdungspotential, vergleichbar einer *.BAT Datei, jedoch nur wenn sie eingelesen werden.<br>
D.h. nur vertrauenswuerdige Befehldateiten einspielen.<br>
<br>
Haken° zeige Dateien: In der ZackZackOrdner-eigenen Explorer-Ansicht im <b>Explorer-Feld</b> - deckungsgleich mit der Pfad-Liste (Edit5) - funktionieren <b>nur Maus-Aktionen</b>, die Tasten wirken auf ZackZackOrdner als waere die Explorer-lose-Ansicht also die Normal-Ansicht vorhanden. Das umschalten der Ansichten geschieht mit F7 oder ueber den Haken zeige Dateien.
Markiert wird im Explorer-Feld mit der linken Maustaste und ins Clipboard gebracht, geloescht oder sonstiges, mit Rechts-Klick auf eine der markierten Dateien / Ordner.
<font size="-2">Die Ignorierung der Tasten kann sich in zukuentigen Versionen aendern.</font>
)
HTML2=
(
<h2>AutoPop</h2>
<p>Das automatische oeffenen des ZackZackOrdner-Fensters bei Speicher...-Dialog-Fenstern 
  des Betriebssystems </p>
<ol>
  <li>Speichern unter / Save as <img src="SaveAsDialog.jpg"  alt="Fenster Beispiel" align=RIGHT></li>
  <li>Kopie Speichern / Save a copy</li>
  <li>&Ouml;ffnen / open</li>
  <li>...</li>
</ol>
<p>wird hier <i><b>AutoPop</b></i> genannt. Bei solchen Fenstern draengt sich 
  (bei gesetztem AutoPop-Haken°) ZackZackOrdner nach vorne um bei der Ordner-Wahl 
  zu helfen. Diese Speicher...-Dialog-Fenster haben fast alle die Fenster-Klasse 
  #32770. (Die Fensterklasse und viel mehr laesst sich mit AU3_Spy.exe ermitteln, siehe Absatz Installation)<br>
  Leider wird diese Fenster-Klasse nicht ausschlie&szlig;lich fuer Dialoge zum 
  Speichern bzw. oeffnen verwendet.<br>
  Deshalb muss ZackZackOrdner erst lernen, <b>wann es nicht autopoppen soll</b>.<br>
  Zu kleine Fenster und Fenster Fenster ohne editierbares Feld koennen meist automatisch 
  erkannt werden. <br>
  Dennoch bleiben Fenster uebrig die faelschlschlich als AutoPop-sinnvoll erkannt 
  werden.<br>
  Deshalb koennen AutoPop-Ausnahme-Listen vom Benutzer individuell ergaenzt werden:</p>
<p>Menue | <samp>AutoPop</samp> | <samp>Ausnahmen bearbeiten</samp></p>
<p>Was hier einzutragen ist kann mit</p>
<p>Menue | <samp>AutoPop</samp> | <samp>AutoPop.log anzeigen</samp></p>
<p>ermittelt werden. Normalerweise ist der letzte Eintrag zwischen <samp>AutoPop:</samp> 
  und <samp>`%CRLF`%</samp> zu uebernehmen, hier durch<br> 
  <samp>???{Tabulator}???<br>
  </samp>dargestellt:</p>
<p><samp>AutoPop:???????????????????</samp><i>{Tabulator}</i><samp>????????????????????????%CRLF%...</samp></p>
<p>Die ? vor dem Tabulator entsprechen dem Fenster-Titel und die ? danach dem 
  Fenster-Text.<br>
  Allerdings sollte man beim uebernehmen mitdenken, schnell hat man sich AutoPop 
  auch an eigentlich erwuenschten Stellen abgeschaltet. Wenn der Fenstertitel 
  bspw. aus dem Dateiname besteht, der gerade bearbeitet wird, bringt eine Uebernahme 
  hoechtens Schaden.</p>
<p>Hinweise:</p>
<ol>
  <li>In der Ausnahmeliste wird Gro&szlig;-/Klein-Schreibung unterschieden (sonst 
    ist es bei ZackZackOrdner fast ueberall egal).</li>
  <li>Bei <samp>Fenster-Titel</samp> und <samp>Fenster-Text</samp> wird rechts 
    weglassen wie eine Wildcard behandelt. D.h. mit dem Neueintrag<br>
    <kbd>A</kbd><i>{Tabulator}</i><kbd>A</kbd><br>
    wuerde man bei allen Fenstern deren Titel und Text mit <samp>A</samp> beginnen 
    das Aufpoppen verhindern.<br>
    <kbd>A</kbd><br>
    dito ohne den Text zu beruecksichtigen.</li>
</ol>
In folgenden Dateien kann Einfuss auf AutoPop erfolgen<br>
%ScriptFullPathOhneKlammer%.ausn<br>
fuer alle<br>
%ScriptFullPathOhneKlammer%.%A_ComputerName%.ausn<br>
nur fuer Komputername %A_ComputerName%<br>
%ScriptFullPathOhneKlammer%.%A_UserName%.ausn<br>
nur fuer Benutzername %A_UserName%<br>
%A_AppData%\Zack\%ScriptNamneOhneKlammer%.ausn <br>
nur local fuer den Benutzer, Diese Datei wird auch mit Menue | <samp>AutoPop</samp> | <samp>Ausnahmen bearbeiten</samp> geoeffnet. Naeheres siehe oben.
	
<h2>Start-Pfad</h2>
Das Skript benoetigt wenigstens einen Start-Pfad, fuer die rekursive Ordnernamenssuche.
Die momentan wirksamen Start-Pfade sind ueber den waehlbaren Kontainer gezielt einstellbar.
Bei der Ersteinrichtung sollte ein Kontainer mit dem Namen  <br>
Haupt  <br>
eingerichtet und mit wenigstens einem Start-Pfad, z.B.: <br>
C:\* <br>
befuellt werden.
Dieser wird dann nach dem Programmstart automatisch aktiviert.
<h2>Tastatur-Bedienung</h2>
Das Programm hat eine maechtige Tastaturbedienung.
Voraussetzung: TastWatch muss gestartet (geschieht automatisch kurz nach Programmstart) und die Caps-Caps-Ueberwachung aktiviert (im Tray-Menue von TaskWatch oder durch Eingabe an beliebiger Stelle von "CapsspaCon ") sein und noch laufen.<br>
MerkHilfe:<br>
Caps + Caps[seitenverkehrt] + on + [Leerzeichen] --> Caps-Caps-Ueberwachung aktivieren<br>
Caps + Caps[seitenverkehrt] + off + [Leerzeichen] --> Caps-Caps-Ueberwachung deaktivieren<br>
Eine Kurze Einfuehrung erhaelt man via <br>
Menue | Macro | Befehlsliste <br>
oder  <br>
Caps Caps ll Tab<br>					
dieser Text erscheint auch an die Hilfe angehaengt, wenn <br>
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
Html:=Html1 HTML2 HtmlRegExilfeAngepasst  HtmlRegExilfeVonSucheDateien HtmlRegExHilfeZack HtmlHaftungsausschluss	"<pre>VersionsHistorie`r`n`r`n"	VersionsHistorie "</pre>"	"<pre>Bekannte Fehler`r`n`r`n" BekannteFehler	"</pre>" ; Hilfe Zusammensetzen
FileDelete,%ScriptFullPathOhneKlammer%.htm
FileAppend,%HTML%,%ScriptFullPathOhneKlammer%.htm
if ZackZackOrdnerLogErstellen
	ThreadUeberwachungLog(A_LineNumber-1,A_ThisHotkey,A_ThisLabel,A_ThisFunc,A_ThisMenu,A_ThisMenuItem,A_ThisMenuItemPos)
run, %ScriptFullPathOhneKlammer%.htm
if ZackZackOrdnerLogErstellen
	ThreadUeberwachungLog(A_LineNumber-1,A_ThisHotkey,A_ThisLabel,A_ThisFunc,A_ThisMenu,A_ThisMenuItem,A_ThisMenuItemPos)
return

; GuiContextMenu: ;
RechsClickAufControl:
; Menu, MeinMenü, Show  ;
; MsgBox ;

if A_GuiControl is integer
{
	Edit3:=A_GuiControl
	GuiControl,, Edit3, %Edit3%
	gosub Edit3
	gosub Button4
}
; MsgBox % A_GuiControl "`n"  A_EventInfo "`n"   "`n"   "`n"   "`n"   "`n"   "`n"   "`n"   "`n"   "`n"   "`n"   "`n"   "`n"   "`n"   ;

return

MusterDateienErzeugen:
MacroDir=%A_AppData%\Zack\Macro
IfNotExist %MacroDir%
	FileCreateDir, %MacroDir%
MacroMusterDateiAnzahl:=3
MacroMusterDateiName1=SchreibtWeltInEdit3.txt
MacroMusterDateiName2=Zeige Control-Infos vom aktiven Fenster an.txt
MacroMusterDateiName3=Zeige Edit Zuordnung.txt
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
e9Edit9
e7Edit7
e4Edit4
e3Edit3
e2Edit2
e1Edit1
e6Edit6
e5Edit5
e8Edit8
)
MusterMacroDateiPfade=
Loop, % MacroMusterDateiAnzahl
{
	FileDelete, % MacroDir "\" MacroMusterDateiName%A_Index%
	if ZackZackOrdnerLogErstellen
		ThreadUeberwachungLog(A_LineNumber-1,A_ThisHotkey,A_ThisLabel,A_ThisFunc,A_ThisMenu,A_ThisMenuItem,A_ThisMenuItemPos)
	FileAppend, % MacroMusterDateiInhalt%A_Index%, % MacroDir "\" MacroMusterDateiName%A_Index%
	if ZackZackOrdnerLogErstellen
		ThreadUeberwachungLog(A_LineNumber-1,A_ThisHotkey,A_ThisLabel,A_ThisFunc,A_ThisMenu,A_ThisMenuItem,A_ThisMenuItemPos)
	MusterMacroDateiPfade:=MusterMacroDateiPfade MacroDir "\" MacroMusterDateiName%A_Index% "`n"
}
gosub StaOrdnerBefehlsDateiPfadOeffnen 
sleep 3000
MsgBox % "Folgende Dateien wurden Erzeugt: "  MusterMacroDateiPfade
return

GuiSize:
	; AktionBeiClipChange:= ;
	; global  ;
	; WinGetTitle,WinTirle,ahk_id %GuiWinHwnd% ;
	WinGetPos,DieseThisX,DieseThisY,DieseThisB,DieseThisH,ahk_id %GuiWinHwnd%
	Rahmenbreite:=4
	GuiYAbzuziehen := DieseThisH - A_GuiHeight -2*Rahmenbreite
	; TrayTip,GuiYAbzuziehen,%GuiYAbzuziehen% ;
	
	; MsgBox % ThisX "		" ThisY "		" ThisB "			" ThisH "	" WinTirle  "		" A_GuiHeight  ;
	; MsgBox % ThisH "		" A_GuiHeight "		" GuiYAbzuziehen "			" GuiWinHwnd "	" WinTirle ;
	; MsgBox % GuiYAbzuziehen ;
	RegExBeratungsFormularXPos:=DieseThisX+DieseThisB
	; RegExBeratungsFormularYPos:=DieseThisY+DieseThisH ;
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
	; LastOpenOrSaveWinHwnd:=WinExist("ahk_class CabinetWClass") ;
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
; Edit10Y:=NeueHoehe-20 ;
GuiControl, Move, Edit8, 	w%A_GuiWidth%

gosub IeControl

; GuiControl, Move, Edit5, 	w%Edit5Breite20%	h%Edit5Hoehe%				; x141 	y%Edit5Y0% w350	h240 HWNDHwndIe1 vWB ;
GuiControl, Move, Edit5UpDown, 		h%Edit5Hoehe%
GuiControl, Move, Edit4, 	x%Edit5Breite105%
GuiControl, Move, Edit2, 					w%Edit5Breite100% 
GuiControl, Move, Edit10, y%NeueHoehe%	w%Edit5Breite%				
return

Rekursiv:
Gui,Submit,NoHide
if Rekur
	Rekursiv=R
else
	Rekursiv=
return

ExpSel:
Gui,Submit,NoHide
return

; 20160329130702 ; Glas:
; 20160329130703 ; Durch:
; 20160329130704 ; Durchs:
; 20160329130705 ; Durchsichtig:
; 20160329130706 ; Gui,Submit,NoHide
; 20160329130707 ; if Durchsichtig
; 20160329130708 ; {
; 20160329130709 ; 	Gui, Color, FFFFFF
; 20160329130710 ; 	WinSet, TransColor, FFFFFF  ,ahk_id %GuiWinHwnd%
; 20160329130711 ; }
; 20160329130712 ; else
; 20160329130713 ; {
; 20160329130714 ; 	WinSet, TransColor, Off,ahk_id %GuiWinHwnd%
; 20160329130715 ; 	Gui, Color, F1F1F1
; 20160329130716 ; }
; 20160329130717 ; return

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

DelCache:
SkriptDataPath=%A_AppDataCommon%\Zack
gosub KontainerAnzeigen
FileRemoveDir, %SkriptDataPath%\*►ProgramData►Zack►WuCont►°-R , 1					; SkriptDataPath=%A_AppDataCommon%\Zack			3_C˸►ProgramData►Zack►WuCont►°
Sleep, 2000
; SoundBeep ;
FileRemoveDir, %SkriptDataPath%\*►ProgramData►Zack►WuCont►* , 1	
FileDelete,%SkriptDataPath%\Wurzel??.txt
FileDelete,%SkriptDataPath%\Wurzel?.txt
FileDelete,%SkriptDataPath%\WurzelIndex.txt
return

; 20160329161730 ; AutoPopAusnahmenBearbeiten:
; 20160329161731 ; IfExist %A_AppData%\Zack\%ScriptNamneOhneKlammer%.ausn
; 20160329161732 ; 	run, notepad.exe "%A_AppData%\Zack\%ScriptNamneOhneKlammer%.ausn"
; 20160329161733 ; else
; 20160329161734 ; {
; 20160329161735 ; 	MsgBox, 262180, %A_AppData%\Zack\%ScriptNamneOhneKlammer%.ausn fehlt, soll eine neue Ausnahme-Datei `n		%A_AppData%\Zack\%ScriptNamneOhneKlammer%.ausn`nerstellt werden?
; 20160329161735 ; 	IfMsgBox,Yes
; 20160329161736 ; 	{
; 20160329161745 ; 		MsgBox, 262180, %A_AppData%\Zack\%ScriptNamneOhneKlammer%.ausn, soll diese neue Ausnahme-Datei `n		%A_AppData%\Zack\%ScriptNamneOhneKlammer%.ausn`nmit dem Default befuellt werden?
; 20160329161752 ; 		IfMsgBox, Yes
; 20160329161753 ; 			gosub AutoPopAusnahmeDefaultDateiErstellen
; 20160329161754 ; 		else
; 20160329161755 ; 		{
; 20160329161756 ; 			FileAppend,,%A_AppData%\Zack\%ScriptNamneOhneKlammer%.ausn
; 20160329161756 ; 			if ZackZackOrdnerLogErstellen
; 20160329161757 ; 				ThreadUeberwachungLog(A_LineNumber-1,A_ThisHotkey,A_ThisLabel,A_ThisFunc,A_ThisMenu,A_ThisMenuItem,A_ThisMenuItemPos)
; 20160329161758 ; 		}
; 20160329161759 ; 		IfExist %A_AppData%\Zack\%ScriptNamneOhneKlammer%.ausn
; 20160329161800 ; 			run, notepad.exe "%A_AppData%\Zack\%ScriptNamneOhneKlammer%.ausn"
; 20160329161801 ; 	}
; 20160329161801 ; }
; 20160329161803 ; return

; 20160329161810 ; AutoPopLogAnzeigen:
; 20160329161811 ; IfExist %A_AppData%\%A_ScriptName%.Vorschlaege.ausn
; 20160329161812 ; 	run, notepad.exe "%A_AppData%\%A_ScriptName%.Vorschlaege.ausn"
; 20160329161813 ; return

; 20160329161818 ; WirksameAutoPopAusnahmenAnzeigen:
; 20160329161818 ; Edit5:= FensterTitelTextAusnahmen
; 20160329161819 ; GuiControl,, Edit5, %Edit5%
; 20160329161820 ; MsgBox % A_LineNumber	"	Die Ausnahmen werden in Edit5 angezeigt"
; 20160329161821 ; return

; 20160330001617 ; WarteSpeicherOeffnen:
; 20160330001622 ; if Not WiWa
; 20160330001623 ; 	return
; 20160329161909 ; Critical,Off
; Thread,Priority,1 ;
; 20160330001634 ; If (MinWaitTakt="")
; 20160330001634 ; 	MinWaitTakt:=50000
; 20160330001207 ; if(FensterTitelTextAusnahmen="")
; 20160330001208 ; {
; 20160330001209 ; 	IfExist %A_AppData%\Zack\%ScriptNamneOhneKlammer%.ausn
; 20160330001210 ; 	{
; 20160330001210 ; 		WirksameFensterTitelTextAusnahmen=%WirksameFensterTitelTextAusnahmen%`r`n%A_AppData%\Zack\%ScriptNamneOhneKlammer%.ausn
; 20160330001211 ; 		; MsgBox %A_AppData%\Zack\%A_ScriptName%.ausn
; 20160330001212 ; 		If Fehlersuche
; 20160330001213 ; 			MsgBox % "WirksameFensterTitelTextAusnahmen " WirksameFensterTitelTextAusnahmen
; 20160330001214 ; 	}
; 20160330001215 ; 	IfExist %ScriptFullPathOhneKlammer%.%A_UserName%.ausn
; 20160330001215 ; 	{
; 20160330001216 ; 		WirksameFensterTitelTextAusnahmen=%WirksameFensterTitelTextAusnahmen%`r`n%ScriptFullPathOhneKlammer%.%A_UserName%.ausn
; 20160330001217 ; 		If Fehlersuche
; 20160330001225 ; 			MsgBox % "WirksameFensterTitelTextAusnahmen " WirksameFensterTitelTextAusnahmen
; 20160330001226 ; 	}
; 20160330001257 ; 	IfExist %ScriptFullPathOhneKlammer%.%A_ComputerName%.ausn
; 20160330001258 ; 	{
; 20160330001259 ; 		WirksameFensterTitelTextAusnahmen=%WirksameFensterTitelTextAusnahmen%`r`n%ScriptFullPathOhneKlammer%.%A_ComputerName%.ausn
; 20160330001300 ; 		If Fehlersuche
; 20160330001306 ; 			MsgBox % "WirksameFensterTitelTextAusnahmen " WirksameFensterTitelTextAusnahmen
; 20160330001311 ; 	}
; 20160330001329 ; 	IfExist %ScriptFullPathOhneKlammer%.ausn
; 20160330001331 ; 		WirksameFensterTitelTextAusnahmen=%WirksameFensterTitelTextAusnahmen%`r`n%ScriptFullPathOhneKlammer%.ausn
; 20160330001332 ; 	StringTrimLeft,WirksameFensterTitelTextAusnahmen,WirksameFensterTitelTextAusnahmen,2
; 20160330001333 ; 	If Fehlersuche
; 20160330001333 ; 		MsgBox % "WirksameFensterTitelTextAusnahmen " WirksameFensterTitelTextAusnahmen
; 20160330001335 ; 	Loop,Parse,WirksameFensterTitelTextAusnahmen,`n,`r
; 20160330001336 ; 	{
; 20160330001337 ; 		FileRead,ThisAusnahmeTeilInhalte,% FuehrendeSterneEntfernen(A_LoopField)
; 20160330001338 ; 		ThisAusnahmeInhalte:= ThisAusnahmeInhalte	"`r`n"	ThisAusnahmeTeilInhalte
		; sort,ThisAusnahmeInhalte,U Z ;
; 20160330001347 ; 	}
; 20160330001354 ; 	StringTrimLeft,FensterTitelTextAusnahmen,ThisAusnahmeInhalte,2
; 20160330001355 ; 	sort,FensterTitelTextAusnahmen,U
; 20160330001356 ; 	If (FensterTitelTextAusnahmen="" and WiWa)
; 20160330001401 ; 	{
; 20160330001410 ; 		MsgBox, 262448, FensterTitelAusnahmeListe, da keine FensterTitelAusnahmeListe`n%ScriptFullPathOhneKlammer%.%A_UserName%.ausn`n%ScriptFullPathOhneKlammer%.%A_ComputerName%.ausn`n%ScriptFullPathOhneKlammer%.ausn`nexistiert`, wird das automatische Fensteraufpoppen abgeschaltet!`n`nMit  `nMenue | AutoPop | Ausnahmen bearbeiten`nkoennen Ausnahmen bearbeitet werden!
; 20160330001437 ; 		WiWa:=false
; 20160330001437 ; 		GuiControl,, %HwndCheckC0%, 0
; 20160330001438 ; 		Gui,Submit,NoHide
		; gosub Button1 ;
; 20160330001445 ; 	}
; 20160330001446 ; }
; 20160330001448 ; If Fehlersuche
; 20160330001449 ; 	MsgBox %  "FensterTitelTextAusnahmen "FensterTitelTextAusnahmen
; 20160330001654 ; loop,
; 20160330001655 ; {
; 20160330001656 ; 	if NOT WiWa
; 20160330001657 ; 	{
; 20160330001658 ; 		; MsgBox not in Wiwa <%WiWa%>
; 20160330001658 ; 		break
; 20160330001659 ; 	}
; 20160330001700 ; 	else if (Min and (A_TimeIdlePhysical>MinWaitTakt*4))
; 20160330001701 ; 		continue
; 20160330001701 ; 	ThisActiveHWND:=WinExist("A") 
; 20160330001702 ; 	ThisAufmerksamkeitHWND:=ThisActiveHWND
; 20160330001703 ; 	WinGetTitle,ThisAufmerksamkeitTitle,ahk_id %ThisAufmerksamkeitHWND%
; 20160330001703 ; 	WinGetText,ThisAufmerksamkeitText,ahk_id %ThisAufmerksamkeitHWND%
; 20160330001704 ; 	ThisAufmerksamkeitText:=SubStr(ThisAufmerksamkeitText,1,50)
; 20160330001705 ; 	; TrayTip %A_LineNumber%,  (%ThisAufmerksamkeitTitle% <>nix or  %ThisAufmerksamkeitText% <>nix)				; ########################################################
; 20160330001705 ; 	; SoundBeep,200,2000
; 20160330001706 ; 	if(ThisAufmerksamkeitTitle<>"" or ThisAufmerksamkeitText<>"")
; 20160330001707 ; 	{
; 20160330001708 ; 		If((LastAufmerksamkeitTitle<>ThisAufmerksamkeitTitle) and ((strlen(LastAufmerksamkeitText)<>strlen(ThisAufmerksamkeitText))or(ThisAufmerksamkeitText="")))
; 20160330001708 ; 		{
; 20160330001709 ; 			StringReplace,ZumSpeichernThisAufmerksamkeitText,ThisAufmerksamkeitText,`r`n,`%CRLF`%,All
; 20160330001710 ; 			StringReplace,ZumSpeichernThisAufmerksamkeitText,ZumSpeichernThisAufmerksamkeitText,`n,`%LF`%,All
; 20160330001711 ; 			StringReplace,ZumSpeichernThisAufmerksamkeitText,ZumSpeichernThisAufmerksamkeitText,`r,`%CR`%,All
			; FileAppend,%ThisAufmerksamkeitTitle%%A_Tab%%ZumSpeichernThisAufmerksamkeitText%`r`n,%A_AppData%\%A_ScriptName%.Vorschlaege.ausn ;
			; if ErrorLevel ;
				;MsgBox %ThisAufmerksamkeitTitle%%A_Tab%%ZumSpeichernThisAufmerksamkeitText% ;
; 20160330001732 ; 			LastAufmerksamkeitTitle:=ThisAufmerksamkeitTitle, LastAufmerksamkeitText:=ThisAufmerksamkeitText
; 20160330001812 ; 			if ZackZackOrdnerLogErstellen
; 20160330001813 ; 				ThreadUeberwachungLog(A_LineNumber-4,A_ThisHotkey,A_ThisLabel,A_ThisFunc,A_ThisMenu,A_ThisMenuItem,A_ThisMenuItemPos)
; 20160330001814 ; 		}
; 20160330001815 ; 	}
; 20160330001816 ; 	sleep -1
; 20160329161930 ; 	Critical , Off
; 20160330001822 ; 	WinWaitActive,ahk_class #32770 ,,4  ; Weitere 
; 20160330001823 ; 	if ErrorLevel
; 20160330001823 ; 	{
; 20160330001824 ; 		sleep -1
; 20160330001825 ; 		continue
; 20160330001826 ; 	}
; 20160330001827 ; 	ThisActiveHWND:=WinExist("A") 
; 20160330001828 ; 	ThisOpenOrSaveWinWND:=WinExist("ahk_class #32770") 
; 20160330001828 ; 	if (ThisActiveHWND=ThisOpenOrSaveWinWND)
; 20160330001829 ; 		ThisActiveOpenOrSaveWinWND:=ThisOpenOrSaveWinWND
; 20160330001830 ; 	If (ThisActiveOpenOrSaveWinWND=ThisAufmerksamkeitHWND)
; 20160330001831 ; 	{
; 20160330001831 ; 		; ThisAufmerksamkeitHWND:=ThisActiveOpenOrSaveWinWND
; 20160330001832 ; 		; continue
; 20160330001833 ; 	}
; 20160330001834 ; 	else if (LastThisActiveOpenOrSaveWinWND=ThisActiveOpenOrSaveWinWND)	;  nicht wegen selbem Fenster nochmals aufpoppen
; 20160330001838 ; 		continue
; 20160330001839 ; 	else if (Min and (A_TimeIdlePhysical>MinWaitTakt*4))	; nicht nach einer zu langen User-Inaktivitaetszeit aufpoppen
; 20160330001840 ; 		continue
; 20160330001841 ; 	else if(BeiGuiWinHwndkeinAutoPop=ThisActiveOpenOrSaveWinWND) 		; nicht aufpoppen von voriger Runde
; 20160330001842 ; 	{
; 20160329104535 ; 		if TimerFehlerSuche
; 20160329104538 ; 		{
; 20160329104541 ; 			TrayTip, Timer WarteSpeicherOeffnen %A_LineNumber%, BeiGuiWinHwndkeinAutoPop= %BeiGuiWinHwndkeinAutoPop%  =	ThisActiveOpenOrSaveWinWND= %ThisActiveOpenOrSaveWinWND% 
; 20160329104559 ; 				sleep 3000
; 20160329104624 ; 		}
; 20160330001852 ; 		break
; 20160330001853 ; 	}
; 20160330001854 ; 	else
; 20160330001855 ; 	{
; 20160330001856 ; 		ThisAufmerksamkeitHWND:=ThisActiveHWND
; 20160330001857 ; 		WinGetPos,FremdFensterX,FremdFensterY,FremdFensterB,FremdFensterH,ahk_id %ThisAufmerksamkeitHWND%
; ö20160330001858 ; 		if(FremdFensterB<450 or FremdFensterH<400)						; nicht aufpoppen wenn Fenster zu klein
; 20160330001901 ; 			continue
; 20160330001902 ; 		WinGetTitle,ThisAufmerksamkeitTitle,ahk_id %ThisAufmerksamkeitHWND%
; 20160330001903 ; 		WinGetText,ThisAufmerksamkeitText,ahk_id %ThisAufmerksamkeitHWND%
; ö20160330001904 ; 		ThisAufmerksamkeitText:=SubStr(ThisAufmerksamkeitText,1,50)
; 20160330001905 ; 		StringSplit,FensterTitelTextZeile,FensterTitelTextAusnahmen,`n,`r
; 20160330001906 ; 		Loop, % FensterTitelTextZeile0
; 20160330001919 ; 		{
; 20160330001920 ; 			if(BeiGuiWinHwndkeinAutoPop=ThisActiveOpenOrSaveWinWND)
; 20160330001921 ; 			{
; 20160329104652 ; 				if TimerFehlerSuche
; 20160329104656 ; 				{
; 20160329104702 ; 					TrayTip, Timer WarteSpeicherOeffnen %A_LineNumber%, BeiGuiWinHwndkeinAutoPop= %BeiGuiWinHwndkeinAutoPop%  =	ThisActiveOpenOrSaveWinWND= %ThisActiveOpenOrSaveWinWND% 
; 20160329104715 ; 					sleep 3000
; 20160329104726 ; 				}
; 20160330001929 ; 				break
; 20160330001931 ; 			}
; 20160330001932 ; 			FensterTitelText1:=
; 20160330001932 ; 			FensterTitelText2:=
; 20160330001933 ; 			StringSplit,FensterTitelText,FensterTitelTextZeile%A_Index%,%A_Tab%
; 20160330001934 ; 			If (FensterTitelText1="" and FensterTitelText2="")
; 20160330001935 ; 			{
; 20160330001935 ; 				TrayTip,%A_LineNumber% Unerwartet,In der FensterAusnahmeListe sind sowohl Fenster-Titel as auch -Text leer. Diese Zeile wird ignoriert.
; 20160330001936 ; 				continue
; 20160330001937 ; 			}
; 20160330001938 ; 			else If (FensterTitelText2="")								; nicht aufpoppen wenn FensterTitel in der Ausnahmeliste ohne Texteinschraenkung ausgeschlossen wurde.
; 20160330001939 ; 			{
; 20160330001939 ; 				if(InStr(ThisAufmerksamkeitTitle,FensterTitelText1))
; 20160330001940 ; 					SofortVerwerfenHwnd:=ThisAufmerksamkeitHWND
					
; 20160330002000 ; 					StringReplace,ZumSpeichernThisAufmerksamkeitText,ThisAufmerksamkeitText,`r`n,`%CRLF`%,All
; 20160330002008 ; 					StringReplace,ZumSpeichernThisAufmerksamkeitText,ZumSpeichernThisAufmerksamkeitText,`n,`%LF`%,All
; 20160330002012 ; 					StringReplace,ZumSpeichernThisAufmerksamkeitText,ZumSpeichernThisAufmerksamkeitText,`r,`%CR`%,All
; 20160330002015 ; 					FileAppend,break weil %ThisAufmerksamkeitTitle% als Ausnahme %FensterTitelText1% bekannt ist. %A_Tab%%ZumSpeichernThisAufmerksamkeitText%`r`n,%A_AppData%\%A_ScriptName%.Vorschlaege.ausn
					; MsgBox % A_LineNumber "	" ThisAufmerksamkeitTitle " < enthaelt > " FensterTitelText1 ;
; 20160330003636 ; 					break
; 20160330003638 ; 				}
; 20160330003640 ; 			}
; 20160330003641 ; 			else														; nicht aufpoppen wenn FensterTitel FensterTextAnfang in der Ausnahmeliste ausgeschlossen wurde.
; 20160330003643 ; 			{
; 20160330003644 ; 				if(InStr(ThisAufmerksamkeitTitle,FensterTitelText1) and InStr(ThisAufmerksamkeitText,FensterTitelText2))
; 20160330003645 ; 				{
; 20160330003656 ; 					SofortVerwerfenHwnd:=ThisAufmerksamkeitHWND
; 20160330003658 ; 					StringReplace,ZumSpeichernThisAufmerksamkeitText,ThisAufmerksamkeitText,`r`n,`%CRLF`%,All
; 20160330003700 ; 					StringReplace,ZumSpeichernThisAufmerksamkeitText,ZumSpeichernThisAufmerksamkeitText,`n,`%LF`%,All
; 20160330003702 ; 					StringReplace,ZumSpeichernThisAufmerksamkeitText,ZumSpeichernThisAufmerksamkeitText,`r,`%CR`%,All
; 20160330003705 ; 					FileAppend,break weil %ThisAufmerksamkeitTitle%%A_Tab%%ZumSpeichernThisAufmerksamkeitText% als Ausnahme %FensterTitelText1%%A_Tab%%FensterTitelText2% bekannt ist.`r`n,%A_AppData%\%A_ScriptName%.Vorschlaege.ausn
					; MsgBox % A_LineNumber "	" ThisAufmerksamkeitTitle " < enthaelt > " FensterTitelText1 ;
; 20160330003718 ; 					break
; 20160330003721 ; 				}
					
			; 20160330003726 ; }
; 20160330003728 ; 		}
		
; 		if (Min and (A_TimeIdlePhysical>MinWaitTakt*4)) ;
; 			continue ;
; 20160330003740 ; 		If (SofortVerwerfenHwnd=ThisAufmerksamkeitHWND)
; 20160330003743 ; 			continue
; 20160330003746 ; 		else if(BeiGuiWinHwndkeinAutoPop=ThisAufmerksamkeitHWND)
; 20160330003747 ; 		{
; 20160329104804 ; 			if TimerFehlerSuche
; 20160329104806 ; 			{
; 20160329104811 ; 				TrayTip, Timer WarteSpeicherOeffnen %A_LineNumber%, BeiGuiWinHwndkeinAutoPop= %BeiGuiWinHwndkeinAutoPop%  =	ThisAufmerksamkeitHWND= %ThisAufmerksamkeitHWND%
; 20160329104820 ; 				sleep 3000
; 20160329104821 ; 			}
; 20160330003817 ; 			break
; 20160330003818 ; 			WinGet, ThisAufmerksControlList , ControlList, ahk_id %ThisAufmerksamkeitHWND%
; 20160330003819 ; 			MsgBox ThisAufmerksControlList= `n`n%ThisAufmerksControlList%
; 20160330003820 ; 			if (not InStr(ThisAufmerksControlList,"Edit"))				; nicht aufpoppen wenn kein EditFeld vorhanden
; 20160330003821 ; 				break
; 20160330003822 ; 		}
; 20160330003823 ; 	If WichtigeTrayTipsAnzeigen
; 20160330003824 ; 		TrayTip,ZackZackOrdner AutoAktivieren,falls steoerend (Haken bei WinWait weg oder) eine Auswahl von ff. in die FensterAusschlussListe uebernehmen`n `n%ThisAufmerksamkeitTitle%	%ThisAufmerksamkeitTitle%
; 20160330003829 ; 	GuiControl, +Default, %HwndButton2%				
; 20160330003830 ; 	GuiControl, , %HwndButton2%,-> |   (Enter)
; 20160330003830 ; 	GuiControl, , %HwndButton4%,Explorer
; 20160330003831 ; 	StringReplace,ZumSpeichernThisAufmerksamkeitText,ThisAufmerksamkeitText,`r`n,`%CRLF`%,All
; 20160330003832 ; 	StringReplace,ZumSpeichernThisAufmerksamkeitText,ZumSpeichernThisAufmerksamkeitText,`n,`%LF`%,All
; 20160330003833 ; 	StringReplace,ZumSpeichernThisAufmerksamkeitText,ZumSpeichernThisAufmerksamkeitText,`r,`%CR`%,All
; 20160330003834 ; 	FileAppend,AutoPop: %ThisAufmerksamkeitTitle%%A_Tab%%ZumSpeichernThisAufmerksamkeitText% `r`n,%A_AppData%\%A_ScriptName%.Vorschlaege.ausn
; 20160330003834 ; 		gosub IfMainGuiMinRestore
; 20160330003835 ; 		Gui,Submit,NoHide
; 20160330003836 ; 		If OnTop
; 20160330003836 ; 		{
; 20160329104844 ; 			if TimerFehlerSuche
; 20160329104846 ; 			{
; 20160329104847 ; 				TrayTip, Timer WarteSpeicherOeffnen %A_LineNumber%, BeiGuiWinHwndkeinAutoPop= %BeiGuiWinHwndkeinAutoPop%  =	ThisAufmerksamkeitHWND= %ThisAufmerksamkeitHWND%
; 20160329104849 ; 				sleep 3000
; 20160329104850 ; 			}
; 20160330003843 ; 			WinSet,AlwaysOnTop,On,ahk_id %GuiWinHwnd%
; 20160330003844 ; 		}
; 20160330003845 ; 		if Akt			; daueroeffnen verhindern 
; 20160330003846 ; 		{
; 20160330003847 ; 			LastThisActiveOpenOrSaveWinWND:=ThisActiveOpenOrSaveWinWND				; verhindert das sofortige wiederaufpoppen
; 20160330003848 ; 			ThisActiveHWND:=WinExist("A") 											; verhindert das sofortige wiederaufpoppen
; 20160330003849 ; 			ThisOpenOrSaveWinWND:=WinExist("ahk_class #32770") 						; verhindert das sofortige wiederaufpoppen
; 20160330003851 ; 			if (ThisActiveHWND=ThisOpenOrSaveWinWND)								; verhindert das sofortige wiederaufpoppen
; 20160330003852 ; 				ThisActiveOpenOrSaveWinWND:=ThisOpenOrSaveWinWND					; verhindert das sofortige wiederaufpoppen
; 20160330003852 ; 			WinActivate,ahk_id %GuiWinHwnd% 
; 20160330003853 ; 		}
; 20160330003854 ; 		sleep -1
; 20160330003855 ; 		WinGetPos,EigenFensterX,EigenFensterY,EigenFensterB,EigenFensterH,ahk_id %GuiWinHwnd%
; 20160330003856 ; 		WinMove,ahk_id %GuiWinHwnd%,, EigenFensterX,  EigenFensterY,510,482								; Wingroesse begrenzen
; 20160330003856 ; 		WinGetPos,EigenFensterX,EigenFensterY,EigenFensterB,EigenFensterH,ahk_id %GuiWinHwnd%
; 20160329104931 ; 		if TimerFehlerSuche
; 20160329104934 ; 			TrayTip, Timer TimerEditUebernahme %A_LineNumber%,Pos F E`, %FremdFensterX% "<" %EigenFensterX% "<" (%FremdFensterX%+%FremdFensterB%) "	und	" (%FremdFenstery% + %FremdFensterh%  + %EigenFensterh%) "<=" A_ScreenHeight
; 20160330003904 ; 		If ((FremdFensterX < EigenFensterX) and (EigenFensterX < FremdFensterX+FremdFensterB) and (FremdFensterX + FremdFensterB + EigenFensterB <=A_ScreenWidth))
; 20160330003905 ; 		{
; 20160330003906 ; 			; SoundBeep,500
; 20160330003907 ; 			WinMove,ahk_id %GuiWinHwnd%,, FremdFensterX+FremdFensterB,  EigenFenstery ; ,510,322
; 20160329105006 ; 			if TimerFehlerSuche
; 20160329105017 ; 				TrayTip, Timer TimerEditUebernahme %A_LineNumber%, WinMove,ahk_id %GuiWinHwnd%,, %EigenFensterX%,  %FremdFensterY%+%FremdFensterH%
; 20160330003911 ; 		}
; 20160330003912 ; 		else If ((FremdFensterY < EigenFensterY) and (EigenFensterY < FremdFensterY+FremdFensterH) and (FremdFensterY + FremdFensterH + EigenFensterH <=A_ScreenHeight))
; 20160330003913 ; 		{
; 20160330003913 ; 			; SoundBeep,500
; 20160330003914 ; 			WinMove,ahk_id %GuiWinHwnd%,, EigenFensterX,  FremdFensterY+FremdFensterH ; ,510,322
; 20160329105233 ; 			if TimerFehlerSuche
; 20160329105237 ; 				TrayTip, Timer TimerEditUebernahme %A_LineNumber%, WinMove,ahk_id %GuiWinHwnd%,, %EigenFensterX%,  %FremdFensterY%+%FremdFensterH%
; 20160330003918 ; 		}
; 20160330003919 ; 		ControlFocus,Edit2,ahk_id %GuiWinHwnd%
; 20160329105250 ; 		if TimerFehlerSuche
; 20160329105252 ; 			TrayTip, Timer TimerEditUebernahme %A_LineNumber%, ControlFocus`,Edit2`,ahk_id %GuiWinHwnd%
; 20160330003923 ; 	}
; 20160330003923 ; }
; 20160330003924 ; return

OpenGuiNebenAktWin:
	ThisActiveHWND:=WinExist("A") 
	ThisAufmerksamkeitHWND:=ThisActiveHWND
	WinGetPos,FremdFensterX,FremdFensterY,FremdFensterB,FremdFensterH,ahk_id %ThisAufmerksamkeitHWND%
	GuiControl, +Default, %HwndButton2%				
	GuiControl, , %HwndButton2%,-> |   (Enter)
	GuiControl, , %HwndButton4%,Explorer
	gosub IfMainGuiMinRestore
	Gui,Submit,NoHide
	WinGetPos,EigenFensterX,EigenFensterY,EigenFensterB,EigenFensterH,ahk_id %GuiWinHwnd%
	WinMove,ahk_id %GuiWinHwnd%,, EigenFensterX,  EigenFensterY,510,482								; Wingroesse begrenzen
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
	ControlFocus,Edit2,ahk_id %GuiWinHwnd%
return





AuAb:												; Autoabbruch nach Default 20 Eingelesenen Cache-Dateien
Gui,Submit,NoHide
if AuAb
	 GuiControl,, AuAb, %AuAb%							; 	
else
	 GuiControl,, AuAb, %AuAb%
return

SufiAus:
SuFi:=0
GuiControl,, SuFi,0

return
SufiAn:
SuFi:=1
GuiControl,, SuFi,1	
GuiControl,, %wndCheckE0%,1	
GuiControl,, %HwndCheckE0%, 1

return

SuFi:												; Suchmodus NORMAL
Gui,Submit,NoHide
if SuFi
{
	 GuiControl,, SuFi, %SuFi%							;
	if(Edit6=20)
	{
		Edit6:=400
		gosub Edit6Festigen
	}
}
else
{
	 GuiControl,, SuFi, %SuFi%
	if(Edit6=400)
	{
		Edit6:=20
		gosub Edit6Festigen
	}
}
return

RegEx:												; Suchmodus REGEX
Gui,Submit,NoHide

if RegEx
	 GuiControl,, RegEx, %RegEx%							; 	
else
	 GuiControl,, RegEx, %RegEx%
return

; 20160329141319 ; FiCa: 	; Checkbox Historisch bedingt es wird nur noch gehakt unterstuetzt				; FileCache (Es wird nur noch AN unterstuetzt) AUS war Variablen-Cache
; 20160329141322 ; Gui,Submit,NoHide
; 20160329140759 ; if FiCa
; 20160329141326 ; 	 GuiControl,, Edit5, %Edit5%							; 	
; 20160329140931 ; else
; 20160329140933 ; {
; 20160329140934 ; 	 GuiControl,, %HwndEdit2%, %Edit2%
	 ; SoundBeep,8000,70
; 20160329140937 ;  }
; 20160329141337 ; return

; 20160329104114 ; WiWa:	; Checkbox fuer Autopopp bei true												; Timer fuer Speichern unter bemerkenn und verarbeiten
; 20160329104115 ; Gui,Submit,NoHide
; 20160329104116 ; if WiWa
; 20160329104117 ; 	SetTimer, WarteSpeicherOeffnen, 5000
; 20160329104118 ; else
; 2016032910	SetTimer, WarteSpeicherOeffnen, Off
; 20160329104126 ; return

SeEn:	; Checkbox fuer Button2 bewirkt OK nachsenden bei true Default deqaktiviert
Gui,Submit,NoHide
if SeEn
	SendEnterNachSchreibmarkeEinfuegen:=true
else
	SendEnterNachSchreibmarkeEinfuegen:=false
return
SrLi:	; Checkbox fuer Button2 bewirkt Links-Sprung bei true
Gui,Submit,NoHide
; if SrLi ;
	; SendHomeBeiSchreibmarke:=true ;
; else ;
	; SendHomeBeiSchreibmarke:=false ;
return

; 20160329105649 ; EdWa:	; veraltete Checkbox -> gesezt lassen											; Warten auf eingehende Befehle von Tastatur, Datei oder Variable	
; 20160329105650 ; Gui,Submit,NoHide
; 20160329105651 ; if EdWa
; 20160329105652 ; 	SetTimer,TimerEditUebernahme, -1
; 20160329105653 ; else
; 20160329105654 ; 	SetTimer,TimerEditUebernahme,Off
; 20160-329105655 ; return
WoAn:	; Checkbox fuer die Suche nur vom Wortanfang
Gui,Submit,NoHide
; Auswirkung auf GetPaths()
gosub Edit2
return
BsAn:	; Checkbox fuer Button2 bewirkt Backslash anhaengen bei true
Gui,Submit,NoHide
if BsAn
	AnSchreibMarkenAusgabeAnhaengen:="\"
else
	AnSchreibMarkenAusgabeAnhaengen:=
return

OnTop:											; Fenster nicht konsequent On Top 
Gui,Submit,NoHide
OnTopSetzen:
if OnTop
{
	WinSet,AlwaysOnTop, On
	GuiControl,, OnTop, %OnTop%
}
else
{
	WinSet,AlwaysOnTop, Off
	GuiControl,, OnTop, %OnTop%
}
return
Akt:											; Fenster nicht konsequent Aktiv
Gui,Submit,NoHide
AktSetzen:
if Akt
	GuiControl,, Akt, %Akt%
else
	GuiControl,, Akt, %Akt%
return
; 20160329105950 ; Min:											; Fenster nach Befehl und nach 20s Inaktivitaet minimieren
; 20160329105951 ; Gui,Submit,NoHide
; 20160329105952 ; MinTimerSetzen:
; 20160329105954 ; If (MinWaitTakt="")
; 20160329105955 ; 	MinWaitTakt:=5000
; 20160329105956 ; if Min
; 20160329105958 ; 	SetTimer,MinTinmer, %MinWaitTakt%
; 20160329105959 ; else
; 20160329110000 ; 	SetTimer,MinTinmer, Off
; 20160329110001 ; return

; 20160329110030 ; MinTinmer:										; Timer zur Minimierungs-Ueberwachung
; 20160329110031 ; Thread,Priority,-1
; 20160329110032 ; if MinInWork
; 20160329110033 ; 	return
; 20160329110034 ; MinInWork:=true
; 20160329110035 ; Critical , Off
; 20160329110036 ; 
; 20160329110037 ; If (MinWaitTakt="")
; 20160329110038 ; 	MinWaitTakt:=5000
; 20160329110039 ; Loop, 2
; 20160329110040 ; {
; 20160329110041 ; 	if (A_TimeIdlePhysical>MinWaitTakt*4)
; 20160329110041 ; 	{
; 20160329110042 ; 		sleep -1
; 20160329110043 ; 		If Min
; 20160329110044 ; 		{
; 20160329110045 ; 			DeltaLastGuiMinizeTime:=LastGuiMinizeTime - GuiMinizeTime
; 20160329110046 ; 			LastGuiMinizeTime:=GuiMinizeTime
; 20160329110046 ; 			GuiMinizeTime:=A_TickCount
; 20160329110047 ; 			WinMinimize,ahk_id %GuiWinHwnd%
; 20160329110048 ; 		}
; 20160329110049 ; 		sleep -1
; 20160329110050 ; 		WinMin:=true
; 20160329110050 ; 		sleep -1
; 20160329110051 ; 		MinInWork:=false
; 20160329110052 ; 		sleep -1
; 20160329110053 ; 		return
; 20160329110056 ; 	}
; 20160329110057 ; 	else
; 20160329110058 ; 	{
; 20160329110059 ; 		; Sleep %MinWaitTakt%
; 20160329110100 ; 		sleep -1
; 20160329110100 ; 		WinGet,MinMaxOut,MinMax,ahk_id %GuiWinHwnd%
; 20160329110101 ; 		sleep -1
; 20160329110102 ; 		if (MinMaxOut=-1)
; 20160329110103 ; 			WinMin:=true
; 20160329110103 ; 		else
; 20160329110104 ; 			WinMin:=false
; 20160329110105 ; 		sleep -1
; 20160329110106 ; 
; 20160329110107 ; 	}
; 20160329110108 ; }
; 20160329110109 ; MinInWork:=false
; 20160329110110 ; return

Edit1:																; PfadAnzeigeZaehler (so viele Pfade, wuerden bei gross genugem Fenster angezeigt)
HwndEdit1:															; Hauptabhaengig vom SuchEingabeFeld und der Abbrruchs-Nummer
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


Edit2:																; (wichtigstes Eingabefeld)
HwndEdit2:															; SuchEingabeFeld Filter ueber Ordnername (schnell)
Gui,Submit,NoHide
; 20160329134836 ; if FiCa ; es wird nur noch File Cache unterstuetz Alle abgeklemmt
{				
	Backslash=\
	Edit2Teil0=
	Edit2Teil1=
	Edit2Teil2=
	Edit2Teil%Edit2TeilR2%=
	If(SubStr(Edit2,1,1)=")")
	{										; Sonderbehandlung bei erstem Zeichen =)
		RegExBeratungsFormularFuer:="Edit2"
		gosub RegExBeratungsFormular
	}
	else If (InStr(Edit2,Backslash))
	{										; Sonderbehandlung bei enthaltenem \
		Gui,Submit,NoHide
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
				GuiControl,, %HwndEdit7%, %Edit7%
				Edit2TeilR2:=Edit2Teil0-1
				if (Edit2Teil0>2)
				{
					SuFi:=true
					GuiControl,, %HwndCheckE0%, 1 
				}
			}
			; Edit5:=GetPaths(Edit2,SucheAbrechen,"Edit5") ;
			; GuiControl,, %HwndEdit5%, %Edit5%  ;
			; Edit8:=GetZeile(Edit5,Edit2) ;
			if(Edit2Teil%Edit2TeilR2%<>"")
			{
				Edit5:=GetPaths(Edit2Teil%Edit2TeilR2%,SucheAbrechen,"Edit5")
				WirksamerFilter:=Edit2Teil%Edit2TeilR2%
			}
			else if(Edit2Teil0=1)
			{
				Edit5:=GetPaths(Edit2,SucheAbrechen,"Edit5")		
				; Pruefen ob bei Teile drueber Edit2MitDotDotStattDotOverDot(Edit2) rein muss ################### ;
				WirksamerFilter:=Edit2
			}
				GuiControl,, %HwndEdit5%, %Edit5%  
				; MsgBox % "vor " Edit8 ;
				Edit8:=GetZeile(Edit5,Edit3)
				; MsgBox % "nach " Edit8 ;
				GuiControl,,%HwndEdit8%,%Edit8%
			; } ;
			; ToolTip, % "vor LetzerAendererVonEdit5:=Edit2" FuehrendeSterneEntfernen(Edit8) ;
			LetzerAendererVonEdit5:="Edit2"
			IfExist % FuehrendeSterneEntfernen(Edit8)
			{
				UnterordnerEdit8:=FuehrendeSterneEntfernen(Edit8)
				If Fehlersuche
					ToolTip, % FuehrendeSterneEntfernen(Edit8) Backslash  Edit2Teil%Edit2Teil0% A_Tab FuerEdit7 A_Tab Edit2Teil1 a_tab Edit2Teil2 a_tab Edit2Teil3 a_tab Edit2Teil4 a_tab Edit2Teil5 a_tab AllEdit2TeilBefuellt 
				Loop,Files,% FuehrendeSterneEntfernen(Edit8) Backslash Edit2Teil%Edit2Teil0%, D R
					UnterordnerEdit8:=UnterordnerEdit8 "`r`n" A_LoopFileLongPath
			; 	ToolTip % UnterordnerEdit8 ;
				Edit5:=UnterordnerEdit8
				GuiControl,,%HwndEdit5%,%Edit5%

				; gosub ZeigeAnstattUnterordnerEdit8 ;
			}
		}
	}
	else									; keine Sonderbehandlung kein \ vorhanden
	{
		Edit5:=GetPaths(Edit2MitDotDotStattDotOverDot(Edit2),SucheAbrechen,"Edit5")
		GuiControl,, Edit5, %Edit5%  
		LetzerAendererVonEdit5:="Edit2"
	}
	If Fehlersuche
		TrayTip,Edit2, %Edit2%	%Edit5%
}
; 20160329134946 ; else
; 20160329134948 ; {			; nicht FileCache wird nicht mehr unterstuetzt
; 20160329132014 ; 	Edit5:=OrdnerPfade(Edit2)
; 20160329132035 ; 	GuiControl,, Edit5, %Edit5%  
; 20160329132036 ; 	LetzerAendererVonEdit5:="Edit2"
; 20160329132038 ; 	Gosub Edit5
; 20160329134953 ; }
gosub Edit5
return

Edit3:																; PfadNummernEingabe
HwndEdit3:
Gui,Submit,NoHide
Edit5UpDown:=Edit3
GuiControl,, Edit5UpDown, %Edit5UpDown%  
Edit8:=GetZeile(Edit5,Edit3)
GuiControl,, Edit8, %Edit8%  
return

Edit5:																; Anzeige deer Pfade
HwndEdit5:
Gui,Submit,NoHide
sort,Edit5,U
GuiControl,, Edit5, %Edit5%
Edit1:=ZaehleZeilen(Edit5)
GuiControl,, Edit1, %Edit1% 
gosub Edit3
return

Edit6:																; Schleifenabbruch Nummern Eingabe
HwndEdit6:
Gui,Submit,NoHide
; GuiControl,, Edit6, %Edit6%  ;
SucheAbrechen:=Edit6
LetzerAendererVonEdit5:="Edit2"
; gosub Edit2 ;
return

Edit7:																; Filter ueber Ges. Pfad (langsam)
HwndEdit7:
Gui,Submit,NoHide
LetzerAendererVonEdit5:="Edit7"			
; Zeile Drueber muss meventuell wiedER RAUS ;

IfWinActive,ahk_id %GuiWinHwnd%
{
	GuiControlGet, FocussedControl, FocusV
	if (LastRegExBeratungsFormularSendTimeStamp="")
		LastRegExBeratungsFormularSendTimeStamp:=0
	; MsgBox % FocussedControl ;
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
	return
Edit9:																		; Anzeige voN der automatisch  hochschalttenden Abbrruchs-Nummer
HwndEdit9:
Gui,Submit,NoHide
; If AuAb ;
; GuiControl,, Edit9, %Edit9%  ;
return
	
Edit8:																		; Die EinzelpfadAusgabe (wichtigstes Ausgabefeld)
HwndEdit8:
Gui,Submit,NoHide
		If (Edit8="" and Edit3=1)
			return
		else If ((Edit8="" and Edit3<>1) or (Edit8=0 and Edit3<>1))		; hinzugekommene Klammer  or (Edit8=0 and Edit3<>1) PRuefen #############################
		{
			ControlGetFocus,FocusedGuiConntrol,ahk_id %GuiWinHwnd%
			if(FocusedGuiConntrol<>"Edit3")
			{
				Edit3:=1
				GuiControl,, %HwndEdit3%, %Edit3% 
			}
			; gosub Button1 ;
		}
if AuAb
{
	If(not instr(Edit8,Edit2))
	{
		If (Edit8="")
			return
		gosub IeControl
		; Edit6:=Edit6*2 ;
		; SetTimer,BeiErgebnisFalsch,-400 ;
		GuiControl,, Edit6, %Edit6% 
		gosub Edit6
	}
}
gosub IeControl
gosub SucheInEdit5Markieren
return

SucheInEdit5Markieren:
; MarkiereSuchtext(Edit2,"Edit5","A") ;
ThisEdit8Exist:=false
DiesesEdit8Sternlos:=FuehrendeSterneEntfernen(Edit8)
IfExist % FuehrendeSterneEntfernen(Edit8)
	ThisEdit8Exist:=true
OnlyFirstChar:=true
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
	MarkiereSuchtext(FuehrendeSterneEntfernen(Edit8),"Edit5","ahk_id " GuiWinHwnd,1,OnlyFirstChar)
	; SplitPath,Edit8,,,,ThisMarkierfolder ;
	StringSplit,Edit8Ordner,% FuehrendeSterneEntfernen(Edit8),\
	ThisMarkierfolder:=FuehrendeSterneEntfernen(Edit8Ordner%Edit8Ordner0%)
	; StringTrimLeft,ThisMarkierfolder,ThisMarkierfolder,1 ;
	; StringTrimRight,ThisMarkierfolder,ThisMarkierfolder,1 ;
	MarkiereSuchtext(FuehrendeSterneEntfernen(ThisMarkierfolder),"Edit8","ahk_id " GuiWinHwnd,1,OnlyFirstChar)
	if Fehlersuche
	{
		TrayTip Markierung, %ThisMarkierfolder%
		MsgBox % ThisMarkierfolder
	}
}
if StarteOrdnerDetailierungsSkripte
	gosub PrufenUndStarteOrdnerDetailierungsSkripte
; ControlFocus,%HwndEdit5%,AGui, Add, Text, x22 y19 w120 h30 , Text ;
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
	; if (BeiExtender%A_Index%) ;
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

Button1:
HwndButton1:
AktualisierungAufButton1:=true
Edit5:=
Edit8:=
; ControlClick,%HwndButton1% ;

gosub Edit2
; sleep 3000 ;
AktualisierungAufButton1:=false
; SoundBeep,1000,100 ;
; gosub SucheInEdit5Markieren ;
; gosub GuiSize ;
return

Button2:
HwndButton2:
gosub SetAutoFavorit
Thread,Priority,-1
ThisAufmerksamkeitHWND:=WinExist("ahk_class #32770")
 if(BeiGuiWinHwndkeinAutoPop<>ThisAufmerksamkeitHWND)
	{
		if TimerFehlerSuche
		{
			TrayTip, Timer WarteSpeicherOeffnen %A_LineNumber%, BeiGuiWinHwndkeinAutoPop= %BeiGuiWinHwndkeinAutoPop%  =	ThisAufmerksamkeitHWND= %ThisAufmerksamkeitHWND%
			sleep 3000
		}
		Gui,Submit,NoHide
		
	if (Not Akt and not Min and not OnTop)
	{
		; SoundBeep ;
	}
	else if (Akt and not Min and not OnTop)
	{
		; WinSet,Bottom,,ahk_id %GuiWinHwnd% ;
		; WinWaitNotActive,ahk_id %GuiWinHwnd%,,1 ;
		; SoundBeep ;
		; SoundBeep ;
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
WinActivate,ahk_class #32770
WinWaitActive,ahk_class #32770,,1
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
		; MsgBox Control,EditPaste, %Edit8%%AnSchreibMarkenAusgabeAnhaengen%,%AktWinFocusedControl%,A ;
	}
}
if SendEnterNachSchreibmarkeEinfuegen
{
	sleep 200
	; SoundBeep ;
	send {Enter}
}
ControlFocus,Edit2,ahk_id %GuiWinHwnd%


GuiControl, +Default, %HwndButton4%				
GuiControl, , %HwndButton4%,Explorer   (Enter)
GuiControl, , %HwndButton2%,-> | 
; Nach Druecken von Button 2 wir das Gui bei: Top or Min -> Minimiert    +Akt -Top -Min -> gelassen    -Top -Akt -Min -> gelassen ;
return
; 20160330095526 ; /*
; erzeuge eine Datei mit dem Namen DateiNamensVorschlag.ahk  nach folgendem Muster und stelle sie in das Lib-Verzeichnis. ;
; von nun an wird die Funktion DateiNamensVorschlag(ThisDateiNameText) den NamensVorschlag ausarbeiten. ;
; ################################################ Muster-Ausgabe-Funktion #################################### ;
; 20160330095437 ; DateiNamensVorschlag(ThisDateiNameText)
; 20160330095438 ; {
; 20160330095439 ; 	SplitPath,ThisDateiNameText,ThisDateiFileName,ThisDateiDir,ThisDateiExt,FileNameNoExt
; 20160330095439 ; 	if(ThisDateiNameText="")
; 20160330095443 ; 		Return "\*_" A_Now
; 20160330095443 ; 	If (FileNameNoExt="")
; 20160330095444 ; 		FileNameNoExt=*
; 20160330095445 ; 	If (FileNameNoExt<>"")
; 20160330095446 ; 		Return "\" FileNameNoExt "_" A_Now "." ThisDateiExt				; Beispiel mit angehaengem Zeitstempel
; 20160330095447 ; 	else
; 20160330095447 ; 		Return "\" FileNameNoExt "_" A_Now
; 20160330095448 ; }
; ################################################ /Muster-Ausgabe-Funktion #################################### ;
; 20160330095452 ; */

Button3:
HwndButton3:
Gui,Submit,NoHide
StringReplace,FuerClipEdit5,Edit5,`n,`r`n,All
Clipboard:=FuerClipEdit5
If Min
{
	DeltaLastGuiMinizeTime:=LastGuiMinizeTime - GuiMinizeTime
	LastGuiMinizeTime:=GuiMinizeTime
	GuiMinizeTime:=A_TickCount
	WinMinimize,ahk_id %GuiWinHwnd%
}
return
Button4:
HwndButton4:
	if Fehlersuche
		TrayTip,A_ThisLabel	EinmalKopieDieseDatenkopie, % A_ThisLabel "	" EinmalKopieDieseDatenkopie
if (A_ThisLabel="SASize" or EinmalKopieDieseDatenkopie="SASize")
{
	gosub IfMainGuiMinRestore
	xGutTemp=
	yAtemp=
	WinGetPos,xGutTemp,yGutTemp,bGutTemp,hGutTemp,ahk_id %GuiWinHwnd%
	WinGetPos,xAtemp,yAtemp,bAtemp,hAtemp,ahk_class CabinetWClass
	; Und:=A_Space "und" A_Space ;
	; MsgBox % xGutTemp "=" xAtemp Und yGutTemp "=" yAtemp Und bGutTemp "=" bAtemp Und hGutTemp "=" hAtemp ;
	if(xGutTemp=xAtemp and yGutTemp=yAtemp and bGutTemp=bAtemp and hGutTemp=hAtemp)
	{
		; SoundBeep,7000,50 ;
		; SoundBeep,7000,50 ;

		
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
		

		return
	}
}
ControlFocus,Edit5,ahk_id %GuiWinHwnd%
if AlleVerwenden
{
ThisMsgBoxAnswer:=false
	Gui,Submit,NoHide
Loop,Parse,Edit5,`n
{
	LoopFieldRun:=FuehrendeSterneEntfernen(A_LoopField)
;		MsgBox % "drausen 	" substr(Edit8Run,-3) ;
	if (substr(LoopFieldRun,-3)=".lnk")
	{
;			MsgBox drinn ;
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
			return
		IfMsgBox,Yes
			ThisMsgBoxAnswer:=true
	}
}
}
else
{
	Edit8Run:=FuehrendeSterneEntfernen(Edit8)
;		MsgBox % "drausen 	" substr(Edit8Run,-3) ;
		if (substr(Edit8Run,-3)=".lnk")
		{
;			MsgBox drinn ;
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
; ääääääääääääääääääääääääääääääääääääääääääääääääääääääääääääääääää ;
gosub SetAutoFavorit

return
Auto_indoto_Markierte_Datei_Pfade_Versioniere_CabinetWClassDirectUIHWND3:

{
	DeltaLastGuiMinizeTime:=LastGuiMinizeTime - GuiMinizeTime
	LastGuiMinizeTime:=GuiMinizeTime
	GuiMinizeTime:=A_TickCount
	WinMinimize,ahk_id %GuiWinHwnd%
}
; WinSet,Bottom,,ahk_id %GuiWinHwnd% ;
; winhide,ahk_id %GuiWinHwnd% ;
WinWaitNotActive,,ahk_id %GuiWinHwnd%
sleep 200

ControlGetFocus,AktWinFocusedControl,A
ControlGetText,ControlText,%AktWinFocusedControl%,A
Clipboard=
send ^c
ClipWait

Button5:
HwndButton5:
KopiereOderVerschiebeFilesAndFolders:
if(ControlText="")
{
	if not DateiPfadeWerdenUebergeben
	{
		if (Clipboard="")
		{
			MsgBox, 262192, Clipboard leer, Diese Aktion benoetigt wenigstens einen existierenden Pfad im Clipboard:`nBitte Datei(en) und oder Ordner  im Explorer markieren und mit  Tastenkombination Control + C ins Clipboard bringen und Vorgang wiederholen.
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
			return
		}
		DateiPfade:=Clipboard
	}
	SumDateien:=0
	SumOrdner:=0
	OriginalErhalten=
	StringSplit,ThisZeilenAnzahl,DateiPfade,`n
	DurchschnittlicheZeichenAnzahlPro6Zeilen:=StrLen(DateiPfade)/ThisZeilenAnzahl0*6
	DateiPfadAnfang:=SubStr(DateiPfade,1,DurchschnittlicheZeichenAnzahlPro6Zeilen)
	StringSplit,ThisZeilenAnzahl,DateiPfadAnfang,`n
	if(ThisZeilenAnzahl>15)
		DateiPfadAnfang:=SubStr(DateiPfadAnfang,1,StrLen(DateiPfadAnfang)/2)
	if(DateiPfade<>DateiPfadAnfang)
		DateiPfadAnfang=%DateiPfadAnfang% ...
	; MsgBox % DateiPfade ;
	Loop,Parse,DateiPfade,`n,`r
	{
		SplitPath,A_LoopField,,OutDir,OutExt,OutNameNoExt
		OutNameNoExtOrg:=OutNameNoExt
		; MsgBox % A_LoopField ;
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
					OutNameNoExt:=OutNameNoExt "[" A_Now "]"
				else
					OutNameNoExt:=OutNameNoExt 
				if(ThisEdit8=OutDir)
				{
					MsgBox, 262179, Original, erhalten? (Ziel: %ThisEdit8%)`n`nJa			Original + Version`n`nNein 			nur Version`n`n%DateiPfadAnfang%
				}
				else
				{
					MsgBox, 262179, Original, erhalten? (Ziel: %ThisEdit8%)`n`nJa			Original + Kopie`n`nNein 			nur Kopie`n`n%DateiPfadAnfang%
				}
				IfMsgBox,No
				{
					OriginalErhalten:=false
				}
				IfMsgBox,Yes
				{
					OriginalErhalten:=true
				}
				IfMsgBox,Cancel
					return
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
							MsgBox, 262179, Zielordner existiert nicht, Fuer die Aktion Ordner veschieben von`n%OutDir%\%OutNameNoExtOrg%`nnach`n%ThisEdit8%\%OutNameNoExt%`nexistiert der Zielordner `n%DieserZielDir%`nnicht`, soll er angelegt werden?`nJa	legt an.`nnein	legt nicht an`, macht aber weiter.`nCancel	bricht ab
							IfMsgBox,Yes
								FileCreateDir, %ThisEdit8%
							IfMsgBox, Cancel
								break
							IfMsgBox, Abort
								break
							IfMsgBox, No
								continue
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
					; MsgBox %A_LineNumber%	DieserZielDir=%DieserZielDir% ;
					IfNotExist %DieserZielDir%
					; IfNotExist %ThisEdit8% ;
					{
						MsgBox, 262179, Zielordner existiert nicht, Fuer die Aktion Datei Verschieben von`n%OutDir%\%OutNameNoExtOrg%.%OutExt%`nnach`n%ThisEdit8%\%OutNameNoExt%.%OutExt%`nexistiert der Zielordner `n%DieserZielDir%`nnicht`, soll er angelegt werden?`nJa	legt an.`nnein	legt nicht an`, macht aber weiter.`nCancel	bricht ab
						IfMsgBox,Yes
							FileCreateDir, %DieserZielDir%
						IfMsgBox, Cancel
							break
						IfMsgBox, Abort
							break
						IfMsgBox, No
							continue
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
							MsgBox, 262179, Zielordner existiert nicht, Fuer die Aktion Ordner Kopieren von`n%OutDir%\%OutNameNoExtOrg%`nnach`n%ThisEdit8%\%OutNameNoExt%`nexistiert der Zielordner `n%DieserZielDir%`nnicht`, soll er angelegt werden?`nJa	legt an.`nnein	legt nicht an`, macht aber weiter.`nCancel	bricht ab
							IfMsgBox,Yes
								FileCreateDir, %ThisEdit8%
							IfMsgBox, Cancel
								break
							IfMsgBox, Abort
								break
							IfMsgBox, No
								continue
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
					; IfNotExist %ThisEdit8% ;
					; MsgBox %A_LineNumber%	DieserZielPfad=%DieserZielPfad%		DieserZielDir=%DieserZielDir% ;
					IfNotExist %DieserZielDir%
					{
						MsgBox, 262179, Zielordner existiert nicht, Fuer die Aktion Datei kopieren von`n%OutDir%\%OutNameNoExtOrg%.%OutExt%`nnach`n%ThisEdit8%\%OutNameNoExt%.%OutExt%`nexistiert der Zielordner `n%DieserZielDir%`nnicht`, soll er angelegt werden?`nJa	legt an.`nnein	legt nicht an`, macht aber weiter.`nCancel	bricht ab
						IfMsgBox,Yes
							FileCreateDir, %DieserZielDir%
						IfMsgBox, Cancel
							break
						IfMsgBox, Abort
							break
						IfMsgBox, No
							continue
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
			return
		}


	}
	; TrayTip,%A_LineNumber% Hinweis,In %SumDateien% Dateien wurden Zeitstempel eingefguegt. ;
	TrayTip,%A_LineNumber% Hinweis, %SumDateien% Dateien / %SumOrdner% Ordner wurden kopiert / verschoben.
	DateiPfadeWerdenUebergeben:=false
	DateiPfade:=
}
return


; #-::	; deaktiviert ;
; SoundBeep ;
; IndexierenBeenden:=true ;
; return ;

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

; 20160329131028 ; OrdnerPfade(FolderWurzel*)	; wird nicht mehr unterstuetzt			; OrdnerOderPfade="Pfade" oder "Ordner" oder "beides"
; 20160329131032 ; {
; 20160329131033 ; 	global GlobalMomentanerFolderVorschlag1,GlobalMomentanerFolderVorschlag2,GlobalBenutzerEin2,GlobalEndEdit1Loop,IndexierenBeenden, Rekursiv
; 20160329131034 ; 	static AnfTeilWortPfad:=[],TeilWortPfad:=[],TeilWortWort:=[],OrdnerBeziehungen:=[],LastVaterID:=[],LastID:=[]
; 20160329131035 ; 	TeilWorte:=false
; 20160329131036 ; 	AnzParam:=FolderWurzel.MaxIndex()
; 20160329131037 ; 	ListVars
; 20160329131038 ; 	MsgBox Funktion OrdnerPfade(FolderWurzel*) wird nicht mehr unteerstutzt
; 20160329131039 ; If(AnzParam=1)
; 20160329131047 ; {
; 20160329131106 ; 	Abfragemodus:=true
; 20160329131107 ; 	if TeilWorte
; 20160329131108 ; 	{
; 20160329131109 ; 		; LeseEin:=False
; 20160329131110 ; 		GuiControl,, LeseEin, 0 
; 20160329131111 ; 		return TeilWortPfad[FolderWurzel[1]]
; 20160329131112 ; 	}
; 20160329131113 ; 	else
; 20160329131113 ; 	{
; 20160329131114 ; 		if AnzListvars
; 20160329131115 ; 		{
; 20160329131116 ; 			AAA:=AnfTeilWortPfad[FolderWurzel[1]]
; 20160329131117 ; 			AA1:=GlobalMomentanerFolderVorschlag1
; 20160329131118 ; 			AA2:=GlobalMomentanerFolderVorschlag2
; 20160329131119 ; 			ListVars
; 20160329131120 ; 		}
		; sleep 1000 ;
		; LeseEin:=False ;
		; GuiControl,, LeseEin, 0 ;
; 20160329131126 ; 		return AnfTeilWortPfad[FolderWurzel[1]]
; 20160329131128 ; 	}
; 20160329131129 ; }
; 20160329131130 ; else
; 20160329131131 ; 	Abfragemodus:=false
; Loop, % AnzParam-1 ;
; { ;
	; ParamIndex:=A_Index+1 ;
	; FolderWurzel%ParamIndex%:= ;
; } ;
; FolderWurzel0:=2 ;
; FolderWurzel1=c:\G\* ;
; FolderWurzel2=c:\temp\* ;
; WorteOrdner:=[] ;
; MaxWortLaenge:=8 ;
; 20160329131139 ; LeseEin:=True
; 20160329131140 ; GuiControl,, LeseEin, 1

; 20160329131143 ; OrdnerIndex:=0
; 20160329131144 ; WurzelIndex:=0

; 20160329131218 ; Loop, % AnzParam
; 20160329131219 ; { ; Loop ueber die Funktionsuebergabeparameter (Wurzeln)
; 20160329131219 ; 	++WurzelIndex
; 20160329131220 ; 	If (A_Index=1)
; 20160329131221 ; 		continue
; 20160329131222 ; 	FolderWurzelIndex:=A_Index
; 20160329131223 ; 	; WorteOrdner[FolderWurzelIndex]:=[]
; 20160329131224 ; 	ThisFolderWurzel:= FolderWurzel[FolderWurzelIndex]
; 20160329131225 ; 	LastFortschrittsAnzeige:=0
; 20160329131226 ; 	++OrdnerIndex
; 20160329131226 ; 	if (IndexierenBeenden or not LeseEin)
; 20160329131227 ; 	{
; 20160329131228 ; 		; SoundBeep,160,3000
; 20160329131229 ; 		break
; 20160329131230 ; 	}
; 20160329131231 ; 	; MsgBox % ThisFolderWurzel
; 20160329131232 ; 	Loop,Files,%ThisFolderWurzel%, D %Rekursiv%
; 20160329131233 ; 	{													; Loop ueber die Ordner obiger Wurzeln
; 20160329131233 ; 		if(IndexierenBeenden or not leseEin)
; 20160329131234 ; 		return
		; MsgBox % A_LoopFileLongPath ;
		; ThisWurzelLoopFileName:=A_LoopFileName ;
		; ThisWurzelA_LoopFileLongPath:=A_LoopFileLongPath ;
; 20160329131239 ; 		if(A_TickCount-LastFortschrittsAnzeige>20000)
; 20160329131240 ; 		{
; 20160329131241 ; 			if Fehlersuche
; 20160329131242 ; 				TrayTip,Ordner,%A_LoopFileLongPath%
; 20160329131243 ; 			LastFortschrittsAnzeige:=A_TickCount
; 20160329131244 ; 		}
; 20160329131245 ; 		++OrdnerIndex
; 20160329131246 ; 		FolderIndex:=A_Index
; 20160329131247 ; 		WorteOrdner[FolderWurzelIndex][FolderIndex]:=[]
; 20160329131248 ; 		ThisFolderPath:=A_LoopFileLongPath
; 20160329131249 ; 		ThisFolderName:=A_LoopFileName
; 20160329131250 ; 		AnfTeilWortPfad[""]:=AnfTeilWortPfad[""] "`n" ThisFolderPath
; 20160329131251 ; 		; WorteOrdner[FolderWurzelIndex][FolderIndex]["Path"]:=A_LoopFileLongPath		; [ThisFolderPath]		; wird wahscheinlich nicht benoetigt
; 20160329131253 ; 		; WorteOrdner[FolderWurzelIndex][FolderIndex]["Name"]:=A_LoopFileName		; [ThisFolderName]			; wird wahscheinlich nicht benoetigt
; 20160329131254 ; 		ThisTeilwort=
; 20160329131255 ; 		ThisAnfTeilwort=
; 20160329131256 ; 		Loop,Parse,A_LoopFileName
; 20160329131257 ; 		{																			; Loop ueber die Buchstaben der Ordner vorne beginnend
; 20160329131258 ; 			BuchstabenIndex:=A_Index
; 20160329131259 ; 			ThisAnfTeilwort:=ThisAnfTeilwort A_LoopField
			; AnfTeilWortPfad:=AnfTeilWortPfad A_LoopField ;
			; if(ThisAnfTeilwort<=MaxWortLaenge) ;
			; { ;
; 20160329131308 ; 				If(AnfTeilWortPfad[ThisAnfTeilwort]="")
; 20160329131324 ; 					AnfTeilWortPfad[ThisAnfTeilwort]:=ThisFolderPath
; 20160329131327 ; 				else
; 20160329131330 ; 					AnfTeilWortPfad[ThisAnfTeilwort]:=AnfTeilWortPfad[ThisAnfTeilwort] "`n" ThisFolderPath
; 20160329131332 ; 				AnfTeilWortListe:=AnfTeilWortListe " " ThisAnfTeilwort
; 20160329131333 ; 				ThisTeilwort:=ThisAnfTeilwort
			; } ;
; 20160329131338 ; 			if TeilWorte
; 20160329131340 ; 			{
; 20160329131341 ; 				Loop, % StrLen(ThisAnfTeilwort) 
; 20160329131342 ; 				{
					; if(StrLen(ThisAnfTeilwort) > MaxWortLaenge)				; zur Laufzeitverkuerzung ;
						; continue ;
					; ThisTeilwort:=ThisTeilwort A_LoopField ;
; 20160329131351 ; 					If(TeilWortPfad[ThisTeilwort]="")
; 20160329131406 ; 					{
; 20160329131410 ; 						TeilWortPfad[ThisTeilwort]:=ThisFolderPath
; 20160329131411 ; 						TeilWortWort[ThisTeilwort]:=ThisFolderName		; noch ermitteln dito bei else
; 20160329131415 ; 					}
; 20160329131419 ; 					else
; 20160329131421 ; 					{
						; TeilWortPfad[ThisTeilwort]:=TeilWortPfad[ThisTeilwort] "`n" ThisFolderPath ;
; 20160329131426 ; 						SchonVorhandenTeilWortPfad:=TeilWortPfad[ThisTeilwort] "`n" ThisFolderPath
; 20160329131428 ; 						sort,SchonVorhandenTeilWortPfad,U
; 20160329131430 ; 						TeilWortPfad[ThisTeilwort]:=SchonVorhandenTeilWortPfad
; 20160329131431 ; 						SchonVorhandenTeilWortWort:=TeilWortWort[ThisTeilwort] "`n" ThisFolderName
; 20160329131433 ; 						sort,SchonVorhandenTeilWortWort,U
; 20160329131435 ; 						TeilWortWort[ThisTeilwort]:=SchonVorhandenTeilWortWort
; 20160329132826 ; 					}
; 20160329131439 ; 					TeilWortListe:=TeilWortListe " " ThisTeilwort
; MsgBox % TeilWortListe ;
; 20160329131443 ; 					; StringTrimLeft,ThisTeilwort,ThisTeilwort,1
; 20160329131445 ; 				}
; 20160329131447 ; 			}
		
; 20160329131452 ; 			if (IndexierenBeenden or not LeseEin)
; 20160329131453 ; 				break
; 20160329131455 ; 		}
; 20160329131457 ; 		if (IndexierenBeenden or not LeseEin)
; 20160329131458 ; 			break
; 20160329131459 ; 	}
; 20160329131500 ; 	if (IndexierenBeenden or not LeseEin)
; 20160329131501 ; 		break
	

; 20160329131508 ; }
; 20160329131509 ; TempAnfTeilWortPfad:=AnfTeilWortPfad[""]
; 20160329131510 ; if(SubStr(TempAnfTeilWortPfad,0,1)"`n")
; 20160329131511 ; {
	; SoundBeep,500,3000 ;
; 20160329131515 ; 	if(substr(TempAnfTeilWortPfad,1,1)="`n")
; 20160329131516 ; 		StringTrimLeft,TempAnfTeilWortPfad,TempAnfTeilWortPfad,1
; 20160329131518 ; }
; 20160329131519 ; AnfTeilWortPfad[""]:=TempAnfTeilWortPfad
; StringTrimLeft,AnfTeilWortListe,AnfTeilWortListe,1
; StringTrimLeft,TeilWortListe,TeilWortListe,1
; 20160329131524 ; sort,AnfTeilWortListe,U
; 20160329131526 ; sort,TeilWortListe,U
; 20160329131527 ; If Abfragemodus
; 20160329131528 ; {
; 20160329131530 ; 	LeseEin:=False
; 20160329131531 ; 	GuiControl,, LeseEin, 0
; 20160329131532 ; 	return TeilWortPfad[FolderWurzel[1]]
; 20160329131534 ; }
; 20160329131536 ; LeseEin:=false
; 20160329131537 ; GuiControl,, LeseEin, 0
; 20160329131538 ; return
; 20160329131550 ; }


; 20160329131605 ; FolderVVorschlag2FileSel()	; wird nicht mehr unterstuetz
; 20160329131607 ; {
; 20160329131608 ; 	global SelectedFile ,GlobalMomentanerFolderVorschlag1,GlobalMomentanerFolderVorschlag2,GlobalBenutzerEin2,GlobalEndEdit1Loop
	; SetTimer,FileSelAbfrage,-1 ;
	
; 20160329131614 ; 	WinWaitActive,Speichern
	; SelectedFile:="?" ;
; 20160329131618 ; 	ToolTipIndex:=1
; 20160329131619 ; 	Loop
; 20160329131620 ; 	{
; 20160329131621 ; 		if GlobalEndEdit1Loop
; 20160329131622 ; 		{
; 20160329131623 ; 			GlobalEndEdit1Loop:=false
; 20160329131624 ; 			return GlobalMomentanerFolderVorschlag1 "\" GlobalBenutzerEin2
; 20160329131625 ; 		}
; 20160329131626 ; 		ControlGetText,Edit1Text,Edit1,Speichern
; 20160329131627 ; 		StringSplit, BenutzerEin,Edit1Text,\
; 20160329131629 ; 		If(StrLen(BenutzerEin1)>0)
; 20160329131629 ; 		{
; 20160329131630 ; 			{
; 20160329131631 ; 				MomentaneFolderVorschlaege:=OrdnerPfade(BenutzerEin1)
; 20160329131632 ; 				StringSplit,MomentanerFolderVorschlag,MomentaneFolderVorschlaege,`n
; 20160329131633 ; 				GlobalMomentanerFolderVorschlag1:=MomentanerFolderVorschlag1
; 20160329131634 ; 				GlobalMomentanerFolderVorschlag2:=MomentanerFolderVorschlag2
; 20160329131636 ; 				GlobalBenutzerEin2:=BenutzerEin2
; 20160329131637 ; 				If(ToolTipIndex>4)
; 20160329131638 ; 				ToolTipIndex=1
; 20160329131638 ; 				If(BenutzerEin0<5)
					
; 20160329131646 ; 				{
; 20160329131652 ; 					++ToolTipIndex
; 20160329131655 ; 					ToolTip, % MomentaneFolderVorschlaege,,,ToolTipIndex
; 20160329131656 ; 				}
				; TrayTip,Pfad(e),%MomentaneFolderVorschlaege% ;
				; ClickedControlGetHwnd(A_index) ;
			
				; TrayTip,%A_LineNumber% Warte,LinksKlick  ;
				; KeyWait,LButton,T1 D, ; T2 U ;
				; if ErrorLevel ;
; 20160329131703 ; 				{
					
					; LastEdit1Text:=Edit1Text ;
; 20160329131706 ; 					continue
; 20160329131709 ; 				}	 	 	 	  		
; 20160329131710 ; 				MouseGetPos,,,ThisWin,ThisControl
; 20160329131711 ; 				ControlGetText,KlickedFolderPath,%ThisControl%,%ThisWin%
				; ControlGetText,KlickedFolderPath,Edit1,Speichern ;
; 20160329131714 ; 				IfExist % FuehrendeSterneEntfernen(KlickedFolderPath)
; 20160329131716 ; 				{
; 20160329131719 ; 					If Fehlersuche
; 20160329131720 ; 						SoundBeep
; 20160329131723 ; 					MsgBox % KlickedFolderPath
; 20160329131725 ; 					return KlickedFolderPath
; 20160329131727 ; 				}
; 20160329131729 ; 				else
; 20160329131730 ; 				{
; 20160329131733 ; 					++ToolTipIndex
; 20160329131735 ; 					TrayTip , Pfad ,>%KlickedFolderPath%< nicht gefunden
; 20160329131737 ; 					; sleep 1500
; 20160329131739 ; 				}
; 20160329131740 ; 			}
; 20160329131741 ; 			LastEdit1Text:=Edit1Text
; 20160329131742 ; 		}
; 20160329131743 ; 		IfWinNotExist,Speichern
; 20160329131744 ; 			break
		; If(SelectedFile<>"?") ;
			; break ;
; 20160329131748 ; 	}
; 20160329131749 ; 	CopySelectedFile:=SelectedFile
; 20160329131750 ; 	return CopySelectedFile
; 20160329131751 ; }
; run, notepad.exe ;
; OrdnerPfade("Indizieren","c:\G\Gegenst\*") ;
; OrdnerPfade("Indizieren","c:\G\Gegenst\*","c:\users\Gerd\*") ;
; SoundBeep ;
; 20160330100826 ; /*
; 20160330100548 ; loop,
; 20160330100549 ; {
; 20160330100550 ; 	MsgBox % FolderVVorschlag2FileSel()
; 20160330100550 ; 	WinWaitClose,Speicher
; 20160330100551 ; }
; 20160330100552 ; ExitApp
; 20160330100553 ; MsgBox % OrdnerPfade("Ku")
; 20160330100831 ; */

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

; 20160329153548 ; MsgBox % StrReplace(AnfTeilWortListe,"`n",A_Tab)
; 20160329153548 ; MsgBox % StrReplace(TeilWortListe,"`n",A_Tab)
; 20160329153549 ; MsgBox % "die Pfade von |Ku`n`n" AnfTeilWortPfad["Ku"]
; 20160329153550 ; MsgBox % "die Pfade von Ku`n`n" TeilWortPfad["Ku"]
; 20160329153550 ; MsgBox % "die Pfade von |ec`n`n" AnfTeilWortPfad["ec"]
; 20160329153551 ; MsgBox % "die Pfade von ec`n`n" TeilWortPfad["ec"]
; 20160329153551 ; MsgBox % "die Pfade von |hu`n`n" AnfTeilWortPfad["hu"]
; 20160329153552 ; MsgBox % "die Pfade von hu`n`n" TeilWortPfad["hu"] "`n`nmit dem(n) Ordner(n)`n`n" TeilWortWort["hu"]
; 20160329153553 ; MsgBox % "die Pfade von go`n`n" TeilWortPfad["go"] " mit dem Wort " TeilWortWort["go"]

; FileSelAbfrage:
; FileSelectFile,SelectedFile,,c:\G\Gegenst, Zuerst den Ordner ...,TextFiles (*.txt)
; return

RunOtherAhkScript(StartScriptPath,UebergabeParameter*)
{	
	global RunPid, NurExeStartErlaubt
	; MsgBox % A_AhkPath  "	"  StartScriptPath "	" UebergabeParameter.MaxIndex() "	" UebergabeParameter[1]  "	" UebergabeParameter[2] ;
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
	; A_ScriptFullPath  ;
	
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
			; MsgBox % SubStr(StartScriptNameNoExt,0) ;
			If(SubStr(StartScriptNameNoExt,0)="]")
			{
				EckKlamPosZu:=InStr(StartScriptNameNoExt,"]")
				if EckKlamPosZu
				{
					DeltaEckKlamPos:=EckKlamPosZu - EckKlamPosAuf
					EckKlamPlusText:=SubStr(StartScriptNameNoExt,EckKlamPosAuf,DeltaEckKlamPos+1)
					VorEckKlamPlusText:=SubStr(StartScriptNameNoExt,1,EckKlamPosAuf-1)
					; MsgBox %VorEckKlamPlusText%		%EckKlamPlusText% ;
					ThisFilePattern:=StartScriptDir "\" VorEckKlamPlusText "[*].*"   ; StartScriptExt		
					; MsgBox ThisFilePattern	%ThisFilePattern% ;
					; MsgBox % SubStr(StartScriptNameNoExt,	InStr(StartScriptNameNoExt,"[")+1,	InStr(StartScriptNameNoExt,"]") - InStr(StartScriptNameNoExt,"[")-1) ;
					; MsgBox % SubStr(LoopFileLongNameNoExt,	InStr(LoopFileLongNameNoExt,"[")+1,	InStr(LoopFileLongNameNoExt,"]") - InStr(LoopFileLongNameNoExt,"[")-1) ;
					{
						LoopFileAlt:=
						Loop,Files,%ThisFilePattern%, F
						{
							SplitPath,A_LoopFileLongPath,LoopFileLongFileName,LoopFileLongDir,LoopFileLongExt,LoopFileLongNameNoExt
							SubStr(StartScriptNameNoExt,InStr(StartScriptNameNoExt,"["),InStr(StartScriptNameNoExt,"]") - InStr(StartScriptNameNoExt,"[")+1)
							LoopFileInEckKlam:=SubStr(LoopFileLongNameNoExt,	InStr(LoopFileLongNameNoExt,"[")+1,	InStr(LoopFileLongNameNoExt,"]") - InStr(LoopFileLongNameNoExt,"[")-1)
							; MsgBox % A_LoopFileLongPath "    " LoopFileLongFileName "    " LoopFileLongDir "    " LoopFileLongExt "    " LoopFileLongNameNoExt  "    " SubStr("00000" . LoopFileInEckKlam, -4)				; die vier ist um eins kleiner als die Anzahl der Nullen, wenn auch TimeStamps unterstuetzt werden sollen -> SubStr("000000000000000" . LoopFileInEckKlam, -14) aber ein Gemischtwaarenladen muss eh extra abgefackelt werden. NewestLoopFileAlt0 ;
							LoopFileAlt:= SubStr("00000" . LoopFileInEckKlam, -4) A_Tab A_LoopFileLongPath "`n" LoopFileAlt
							
						}
						StringTrimLeft,LoopFileAlt,LoopFileAlt,1
						Sort,LoopFileAlt,U R
						Loop,Parse,LoopFileAlt,`n,`r
						{
							; if(SubStr(A_LoopField,-2)<>"lnk") ;
							Last3Char:=SubStr(A_LoopField,-2)
							if Last3Char not in lnk,bak
							{
								StringSplit,NewestLoopFileAlt,A_LoopField,%A_Tab%
								break
							}
						}
						; MsgBox % "Datei mit hoechstert Nummer " NewestLoopFileAlt2 ;
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
	; MsgBox % "return ( SubStr(" StringMitKlammern ","	Merker+1 ","	InStr(StringMitKlammern,Zu) "-" Merker "-1))" ;
	return (SubStr(StringMitKlammern,	Merker+1,	InStr(StringMitKlammern,Zu) - Merker-1))
}
WurzelContainerOeffnen:
Gui Submit,NoHide
ThisEingangsEdit8:=FuehrendeSterneEntfernen(Edit8)
Gui Submit,NoHide
gosub ContainerUebersichtZeigen
Gui Submit,NoHide
if(InStr(Edit5,ThisEingangsEdit8))
{
	IfExist % FuehrendeSterneEntfernen(Edit8)
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
	; gosub ContainerUebersichtZeigen ;
	WinGetPos,GuiWinX,GuiWinY,,,ahk_id %GuiWinHwnd%
	OnTopMerker:=OnTop
	OnTop:=0
	gosub OnTopFestigen
	InputBox,Edit3,Kontainer,Bitte geben Sie die Zeilen-`nnummer des Kontainers ein!,,200,140,GuiWinX,GuiWinY,,,1		
	OnTop:=OnTopMerker
	gosub OnTopFestigen
	If Edit3 is Integer
	{
		gosub Edit3Festigen
		sleep 20
		IfExist % FuehrendeSterneEntfernen(Edit8)
		{
			SkriptDataPath:=Edit8
			gosub KontainerAnzeigen
			sleep 20
			gosub Button1
			Sleep 20
			Edit3:=1
			gosub Edit3Festigen
		}

	}
}
	; SkriptDataPath=SkriptDataPathKurzNachProgrammbeginn ;
; NeueWurzel:= ;
sleep 50
gosub Button1
return
ü:
WurzelContainerUebersichtOeffnen:	; gespeicherte KontainerUebsicht oeffnen
SkriptDataPath:=ZackData
gosub KontainerAnzeigen
gosub Button1
return
ContainerLoeschen:
FileSelectFolder,bestehenderWurzelName,*%SkriptDataPath%,,Den zu loeschenden Ordner auswaehlen.
IfExist %bestehenderWurzelName%
{
	MsgBox, 262180, Ordner, %bestehenderWurzelName%`n`nmit allem was enthalten ist wirklich loeschen?
	IfMsgBox,yes
		FileRemoveDir,%bestehenderWurzelName%,1
}
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
gosub Button1
gosub NeueWurzelHinzufuegen
}
return
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
gosub Button1
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
gosub Button1
gosub NeueWurzelHinzufuegen
}
return

WurzelContainerUebersichtErzeugenAnzeigen:
SkriptDataPath:=ZackData
gosub KontainerAnzeigen
FileDelete,%SkriptDataPath%\Wurzel??.txt
FileDelete,%SkriptDataPath%\Wurzel?.txt
FileDelete,%SkriptDataPath%\WurzelIndex.txt
; FileDelete,%SkriptDataPath%\1_C˸►ProgramData►Zack►WuCont►°-R\*.txt			; OK ;
; FileDelete,%SkriptDataPath%\?_?˸►ProgramData►Zack►WuCont►°-R\*.txt			; nein ;
; Loop, 20 ;
	; FileDelete,%SkriptDataPath%\%A_Index%_C˸►ProgramData►Zack►WuCont►°-R\*.txt			; OK ;
Loop, 20
{
	FileDelete,%SkriptDataPath%\%A_Index%_C˸►ProgramData►Zack►WuCont►°-R\*.txt			; OK
	FileDelete,%SkriptDataPath%\%A_Index%_E˸►ProgramData►Zack►WuCont►°-R\*.txt			; OK
	FileDelete,%SkriptDataPath%\%A_Index%_F˸►ProgramData►Zack►WuCont►°-R\*.txt			; OK
	FileDelete,%SkriptDataPath%\%A_Index%_G˸►ProgramData►Zack►WuCont►°-R\*.txt			; OK
	FileDelete,%SkriptDataPath%\%A_Index%_H˸►ProgramData►Zack►WuCont►°-R\*.txt			; OK
	FileDelete,%SkriptDataPath%\%A_Index%_I˸►ProgramData►Zack►WuCont►°-R\*.txt			; OK
}

MsgBox, 8192, verarbeite ..., Bitte einen Moment Geduld ...`n`n... schliessst selbstaendig`n`n`ndanach folgt ein Skript-Neustart., 3
NeueWurzel:=WurzelContainer 	"\*-R"			; 	"\*"
gosub NeueWurzelHinzufuegenBeiVorhandenemWurzelName
Reload
sleep 3000
; Scharfschalten nach erfolgter Sicherung
; gosub Button1 ;
return
^o:: 	;	Start-Pfad hinzufuegen
StartPfadEinlesen:
WurzelVonDateiHinzuFuegen:
FileSelectFile,AwpfPfad,,%A_AppDataCommon%\Zack\AlleLaufwerke.awpf,Bitte eine Start-Pfad Datei auswaehlen.,Start-Pfade (*.txt;*.awpf)  ; %A_AppDataCommon%\Zack\AlleLaufwerke.awpf
if ErrorLevel
	return
; 20160329140815 ; if FiCa
{
	NeueWurzel:=AwpfPfad
	; SkriptDataPath=c:\temp ;
	gosub StarteDiesesWurzelSkriptOderAlternative
}
return

WurzelHinzuFuegen:
NeueWurzelHinzufuegen:
If Fehlersuche
	SoundBeep
FileSelectFolder,NeueWurzel,*Desktop,1,Neue Wurzel hinzuladen`nfuer Stringeingabe [Esc] druecken.
If(NeueWurzel="")
	; InputBox,NeueWurzel,Stringeingabe,Die neue Wurzel kann auch als String eingegeben werden,,400,200,,,,,%A_MyDocuments%\Do* ;
	; InputBox,NeueWurzel,Stringeingabe,Die neue Wurzel kann auch als String eingegeben werden,,400,200,,,,,%A_MyDocuments%\Do*\..\* ;
	; InputBox,NeueWurzel,Stringeingabe,Die neue Wurzel kann auch als String eingegeben werden,,400,200,,,,,%A_MyDocuments%\* ;
	InputBox,NeueWurzel,Stringeingabe,Die neue Wurzel kann auch als String eingegeben werden,,400,200,,,,,c:\*
	if ErrorLevel
		return
NeueWurzelHinzufuegenBeiVorhandenemWurzelName:
if(InStr(NeueWurzel,"*"))
{
	; MsgBox % NeueWurzel ;
; 20160329140534 ; 	if FiCa
; 20160329140536 ; 	{
		gosub StarteDiesesWurzelSkriptOderAlternative
; 20160329140538 ; 	}
		; run, %A_ScriptDir%\Dir2Pahs.ahk "%NeueWurzel%"
; 20160329132141 ; 	else
; 20160329132123 ; 		OrdnerPfade("Indizieren",NeueWurzel)
}
else if(NeueWurzel="")
	return
else
{
	; IfExist %NeueWurzel% ;
	{
		if(SubStr(NeueWurzel,0,1)="\")
		{
; 20160329140705 ; 			if FiCa
			{
				NeueWurzel:=NeueWurzel "*"
				; RunOtherAhkScript(A_ScriptDir "\Dir2Pahs.ahk",SkriptDataPath,NeueWurzel "*") ;
				gosub StarteDiesesWurzelSkriptOderAlternative
			}
				; run, %A_ScriptDir%\Dir2Pahs.ahk "%NeueWurzel%"
; 20160329132232 ; 			else
; 20160329132233 ; 				OrdnerPfade("Indizieren",NeueWurzel "*")
		}
		else
		{
; 20160329140720 ; 			if FiCa
			{
				NeueWurzel:=NeueWurzel "\*"
				; RunOtherAhkScript(A_ScriptDir "\Dir2Pahs.ahk",SkriptDataPath,NeueWurzel "\*") ;
				gosub StarteDiesesWurzelSkriptOderAlternative
				; run, %A_ScriptDir%\Dir2Pahs.ahk "%NeueWurzel%" ;
			}
; 20160329132256 ; 			else
; 20160329132257 ; 				OrdnerPfade("Indizieren",NeueWurzel "\*")
		}
	}
	; else ;
; 20160330101711 ; /*
; 20160330101711 ; 	{
; 20160330101712 ; 		TrayTip,Fehler,kann %NeueWurzel% nicht finden 
; 20160330101713 ; 		Rekursiv=
; 20160330101714 ; 		DriveGet,DriveNames,List
		; MsgBox % DriveNames ;
; 20160330101717 ; 		Loop,Parse,DriveNames
; 20160330101718 ; 		{
; 20160330101719 ; 			OrdnerPfade("Indizieren", A_LoopField ":\*")
; 20160330101720 ; 		}
; 20160330101720 ; 		Rekursiv=
; 20160330101721 ; 	}
; 20160330101722 ; */
}
; SoundBeep ;
return
StarteDiesesWurzelSkriptOderAlternative:
gosub BereiteVorDir2Paths
Dir2PathStartRueck:=IfExistCallEExeOrAhk(A_AppDataCommon "\Zack\Dir2Paths.ahk",SkriptDataPath,NeueWurzel)
If Dir2PathStartRueck
	return

		; MsgBox % "ScriptNameKlammerInhalt " ScriptNameKlammerInhalt "	" A_ScriptName ;
		ScriptDirKlammerInhalt:=GetKlammerInhalt(A_ScriptName)
		if(StrLen(ScriptDirKlammerInhalt))
		RunAlternative:=RunOtherAhkScript(A_AppDataCommon "\Zack\Dir2Paths.ahk",SkriptDataPath,NeueWurzel)		;  %A_AppDataCommon%\Dir2Paths.ahk
		if ZackZackOrdnerLogErstellen
			ThreadUeberwachungLog(A_LineNumber-1,A_ThisHotkey,A_ThisLabel,A_ThisFunc,A_ThisMenu,A_ThisMenuItem,A_ThisMenuItemPos)
		If (RunAlternative=0)
			return
		; RunAlternative:=RunOtherAhkScript(A_AppDataCommon "\Dir2Paths[" ScriptDirKlammerInhalt "].ahk",SkriptDataPath,NeueWurzel)		;  %A_AppDataCommon%\Dir2Paths.ahk ;
		; MsgBox % Meldung ;
		; ExitApp ;
		; if(Meldung="FileNotFound") ;
		; RunAlternative:=RunOtherAhkScript(A_ScriptDir "\Dir2Pahs[99999].ahk",SkriptDataPath,NeueWurzel) ;
		; MsgBox RunAlternative=%RunAlternative% ;
		IfExist %RunAlternative%
		{
			Meldung:=RunOtherAhkScript(RunAlternative,SkriptDataPath,NeueWurzel)
		}
		else
		{
			; IfExist %A_AppDataCommon%\Dir2Paths.exe ;
				run, "%A_AppDataCommon%\Zack\Dir2Paths.exe" "%A_AppDataCommon%\Dir2Paths.ahk" "%SkriptDataPath%"  "%NeueWurzel%"
			if ZackZackOrdnerLogErstellen
				ThreadUeberwachungLog(A_LineNumber-1,A_ThisHotkey,A_ThisLabel,A_ThisFunc,A_ThisMenu,A_ThisMenuItem,A_ThisMenuItemPos)
			; else ;
			MsgBox Einlesprogramm %A_AppDataCommon%\Zack\Dir2Paths.ahk nicht gefunden.
			return
		}
return

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

; 20160329132534 ; LeseAWPFEin:
; moegliche Abhaengigkeiten ;
; A_ComputerName ;
; A_UserName ;
; ------------- ;
; A_MyDocuments ;
; 20160329154232 ; Nextwpf:=false
; 20160329154233 ; IfExist %SkriptDataPath%\%A_ScriptName%.awpf			; SkriptDataPath=%A_AppDataCommon%\Zack
; 20160329154235 ; {
; 20160329154237 ; 	awpfPath=%SkriptDataPath%\%A_ScriptName%.awpf
; 20160329132546 ; 	awpfEinlesen(awpfPath)
; 20160329154242 ; }
; 20160329154243 ; else
; 20160329154244 ; 	Nextwpf:=true
; 20160329154245 ; if Nextwpf
; 20160329154248 ; {
; 20160329154248 ; IfExist %A_ScriptFullPath%.%A_ComputerNamE%.awpf
; 20160329154249 ; 	{
; 20160329154250 ; 		awpfPath=%A_ScriptFullPath%.%A_ComputerNamE%.awpf
; 20160329132607 ; 		awpfEinlesen(awpfPath)
; 20160329154253 ; 	}
; 20160329154254 ; }
; 20160329154255 ; else
; 20160329154255 ; 	Nextwpf:=true
; 20160329154257 ; 
; 20160329154258 ; if Nextwpf
; 20160329154259 ; {
; 20160329154300 ; IfExist %A_ScriptFullPath%.%A_UserName%.awpf
; 20160329154301 ; 	{
; 20160329154302 ; 		awpfPath=%A_ScriptFullPath%.%A_UserName%.awpf
; 20160329132632 ; 		awpfEinlesen(awpfPath)
; 20160329154306 ; 	}
; 20160329154307 ; }
; 20160329154308 ; else
; 20160329154309 ; 	Nextwpf:=true

; 20160329154312 ; if Nextwpf
; 20160329154313 ; {
; 20160329154314 ; IfExist %A_ScriptFullPath%.awpf
; 20160329154315 ; 	{
; 20160329154316 ; 		awpfPath=%A_ScriptFullPath%.awpf
; 20160329132654 ; 		awpfEinlesen(awpfPath)
; 20160329154321 ; 	}
; 20160329154321 ; }
; 20160329154322 ; else
; 20160329154323 ; 	Nextwpf:=true
; 20160329154324 ; return

; 20160329132432 ; awpfEinlesen(awpfPath)
; 20160329154329 ; {
; 20160329132505 ; 	global
; 20160329154338 ; 	FileRead,ThisawpfInhalt,%awpfPath%
; 20160329154342 ; 	; MsgBox % ThisawpfInhalt
; 20160329154343 ; 	Loop,Parse,ThisawpfInhalt,`n,`r
; 20160329154344 ; 	{
; 20160329154345 ; 		If(InStr(A_LoopField,">"))
; 20160329154345 ; 		{
; 20160329154346 ; 			StringSplit,VariableSetzen,A_LoopField,>
; 20160329154347 ; 			if(VariableSetzen0=2)
; 20160329154347 ; 			{
; 20160329154348 ; 				%VariableSetzen1%:=VariableSetzen2
; 20160329154349 ; 			}
; 20160329154349 ; 			else
; 20160329154350 ; 				TrayTip SyntaxFehler,in %awpfPath% Zeile %A_Index%
			
; 20160329154358 ; 		}
; 20160329154358 ; 		else
; 20160329154359 ; 		{
; 20160329154400 ; 			ThisWurzel:=A_LoopField
; 20160329154401 ; 			if(InStr(ThisWurzel,"*"))
; 20160329154402 ; 			{
; 20160329132326 ; 				OrdnerPfade("Indizieren",ThisWurzel)
				; MsgBox % "nach *	" ThisWurzel
; 20160329154406 ; 			}
; 20160329154407 ; 			else
; 20160329154408 ; 			{
; 20160329154409 ; 				IfExist %ThisWurzel%
; 20160329154410 ; 				{
					; MsgBox % "nach	" ThisWurzel
; 20160329154420 ; 					if(InStr(ThisWurzel,"*"))
; 20160329154423 ; 					{
						; MsgBox % ThisWurzel
; 20160329132719 ; 						OrdnerPfade("Indizieren",ThisWurzel)
; 20160329154431 ; 					}
; 20160329154433 ; 					else
; 20160329132728 ; 						OrdnerPfade("Indizieren",ThisWurzel "\*")
; 20160329154442 ; 					OrdnerEingelesen:=true
; 20160329154444 ; 				}
; 20160329154445 ; 			}
; 20160329154446 ; 		}
; 20160329154446 ; 	}
; 20160329154447 ; 	return
; 20160329154448 ; }

; 20160330102454 ; /*
; 20160330102455 ; sleep 5000
; 20160330102456 ; ; MarkiereSuchtext("ControlGetText",,,50)
; 20160330102457 ; MsgBox % MarkiereVonBis()
; 20160330102458 ; MarkiereVonBis(1,5)
; 20160330102458 ; MsgBox % GetSel("Poses")
; 20160330102459 ; MsgBox % GetSel("Text","Edit1","ahk_class Notepad")
; 20160330102500 ; MsgBox % GetSel()

; 20160330102504 ; Gui Add, Edit, w300 h300 x5 y5 vText	; Edit1
; 20160330102505 ; Text= Hallo Welt hello world
; 20160330102505 ; Loop 5
; 20160330102506 ; 	Text .= A_Space Text
; 20160330102507 ; GuiControl,, Text, %Text% 
; 20160330102507 ; Gui Show, w310 h310, SelTest
; 20160330102510 ; Return

; 20160330102514 ; #a::	;  deaktiviert	druecke Win + a um das 2. Wort zu markieren
; 20160330102515 ; Gui Submit,NoHide
; 20160330102516 ; pos1:=InStr(Text,A_Space)
; 20160330102516 ; pos2:=InStr(SubStr(Text,Pos1+1),A_Space)+pos1-1
; 20160330102517 ; FirstSel1:=pos1+1
; 20160330102518 ; LastSel1:=pos2
; 20160330102519 ; TrayTip Markiert , von %FirstSel1% bis %LastSel1%
; 20160330102525 ; SendMessage 0xB1, %pos1%, %pos2%, Edit1, SelTest ; EM_SetSel
; 20160330102526 ; return

; 20160330102530 ; #b::	; deaktiviert		; druecke Win + b um die erste und die letzte markierte Position zu erhalten.
; 20160330102530 ; StartPos := -1
; 20160330102531 ; EndPos := -1
; 20160330102532 ; SendMessage 0xB0,&StartPos,&EndPos,Edit1,SelTest  ; EM_GetSel
; 20160330102533 ; FirstSel2 := NumGet(&StartPos)+1
; 20160330102534 ; LastSel2 := NumGet(&EndPos)
; 20160330102534 ; MsgBox % ">" FirstSel2 "<	>" LastSel2 "<" ; "< 	>"		&StartPos "<	>" &EndPos
; 20160330102535 ; return
; 20160330102536 ; */

MarkiereSuchtext(Suchtext,Control="",Win="A",AbPos=1,OnlyFirstChar=0)
{
	If (Win="A")
		Win:="ahk_id " WinExist("A")
	If (Control="")
	{
		ControlGetFocus,ClassNN,%Win%
		Control:=ClassNN
	}
	; WinHWND:=IfWinExist(Win) ;
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
	; Pos1:=InStr(SubStr(ControlText,AbPos),Suchtext)-2+AbPos ;
	; Pos2:=Pos1+StrLen(Suchtext) ;
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
	; MsgBox % A_GuiHeight "	|	" GuiHeight ;
	if (A_GuiHeight>GuiHeight)
		GuiHeight:=A_GuiHeight
    X := lParam & 0xFFFF
    Y := lParam >> 16
	; SoundBeep 4000 ;
	; if(402<x and x<(402+65) and 10<y and y<(10+40))					; x402 	y10 	w90 	h40  ;
	; 	Gosub Button5 ;
	; ToolTip, % A_GuiControl ;
	; if A_GuiControl is integer ;
	; MsgBox % "(" y ">102 and " y "<(" GuiHeight "-45) and " x "<122 and " x ">92)" ;
	If(y>115 and y<(GuiHeight-35) and x<122 and x>92)
	{
		; MsgBox drinn 1 ;
		ThisZeile:=round((((y-123)+6)/13))
		Edit3:=ThisZeile
		GuiControl,, Edit3, %Edit3%
		gosub Edit3
		; SoundBeep 250 ;
		gosub Button2
	}
	else If(y>102  and x<122 and x>92)
	{
		gosub Edit2
		; MsgBox drinn 2 ;
		return
	}
	else if((90+Edit5Hoehe<Y) and x>122)		
		
	{
		if(x<116 and x>92)
		{
			; SoundBeep, 150 ;
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
		; SoundBeep,2000 ;
        Steuerelement := "`n(im Steuerelement " . A_GuiControl . ")"
		ToolTip Sie haben im GUI-Fenster #%A_Gui% auf die Koordinaten %X%x%Y% geklickt.%Steuerelement%
	}
	return
}

GetPaths(Such,SucheAbrechen=20,FruehzeitigRueck="")
{	 
	global WoAn, beschaeftigt, SuchAbbruch,Edit1, Edit2, Edit3, Edit4, Edit5, Edit6, Edit7 ,Edit8,Edit9, SuFi, RegEx,AuAb,AktualisierungAufButton1,TimerBeiErgebnisFalschAktiv,TimerBeiErgeebnisUnsicherAktiv,Fehlersuche, SkriptDataPath, WurzelContainer, ZackData,HwndEdit2, LangsamDemo,AnEdit5Vorbei,FilePaqtternExtender
	; E2E7(A_LineNumber,Edit2,Edit7,Such,-3) ;
	; E2E7(A_LineNumber,Edit2,Edit7,SucheAbrechen,-4) ;
	GesPaths:=
	if (FilePaqtternExtender="")
		FilePaqtternExtender:="txt"
	SuchAbbruch:=false
	GuiControl, Move, Edit6, 	w40	h16
	beschaeftigt:=true
	GuiControl,, beschaeftigt, 1
	; CashPath=%A_AppDataCommon%\DP	 ;
	; CashPath=E:\GeKo2All\ZackZackOrdner\A_AppDataCommon\DP	 ;
	WurzelIndexPath=%SkriptDataPath%\WurzelIndex.txt
	FileRead,WurzelIndex,% FuehrendeSterneEntfernen(WurzelIndexPath)
	; E2E7(A_LineNumber,Edit2,Edit7,WurzelIndex,-1) ;
	; E2E7(A_LineNumber,Edit2,Edit7,WurzelIndex,-1) ;
	Loop,Files,%SkriptDataPath%\*, D										; SkriptDataPath=%A_AppDataCommon%\Zack\WuCont\Haupt
	; Loop, % WurzelIndex-1 ;
	{
		; FileRead,FilePattern,%SkriptDataPath%\Wurzel%A_Index%.txt ;
		if WoAn
			FilePattern=%A_LoopFileLongPath%\%Such%*.%FilePaqtternExtender%
			; FilePattern=%SkriptDataPath%\DP%A_Index%\%Such%*.txt ;
		else
			FilePattern=%A_LoopFileLongPath%\*%Such%*.%FilePaqtternExtender%
			; FilePattern=%SkriptDataPath%\DP%A_Index%\*%Such%*.txt ;
		; E2E7(A_LineNumber,Edit2,Edit7,FilePattern,-1) ;
		; FilePattern=%CashPath%\%Such%*.txt ;
		if Fehlersuche
			MsgBox % "FilePattern=" FilePattern
		; MsgBox % A_LineNumber "	" such "	" FilePattern    "	"   SkriptDataPath    "	"       WurzelContainer ;
			Loop,Files,%FilePattern%, F
			{
				if WurzelnAnzeigen
				{
					MsgBox A_LoopFileLongPath,%A_LoopFileLongPath%
					; SoundBeep,300,2000 ;
					WurzelnAnzeigen:=false
				}
				; E2E7(A_LineNumber,Edit2,Edit7,FilePattern,-1) ;
				 ; FileRead,A_LoopFileFullPath,E:\GeKo2All\ZackZackOrdner\A_AppDataCommon\DP\%Such%*.txt ;
				;  MsgBox % LoopFieldInhalte "=lastLoopFieldInhalte 	A_LoopFileFullPath=" A_LoopFileFullPath ;
				if Fehlersuche
					MsgBox % "A_LoopFileFullPath=" A_LoopFileFullPath
				FileRead,LoopFieldInhalte,% FuehrendeSterneEntfernen(A_LoopFileFullPath)
				; E2E7(A_LineNumber,Edit2,Edit7,LoopFieldInhalte,-1) ;
				if Fehlersuche
					MsgBox % LoopFieldInhalte
				If SuFi
				{
					; E2E7(A_LineNumber,Edit2,Edit7,LoopFieldInhalte,-2) ;
					; MsgBox % A_LineNumber ;
					If RegEx
					{
						; dummy:=E2E7(A_LineNumber,Edit2,Edit7,RegEx,-2) ;
						; if(RegExMatch(A_LoopFileFullPath,Edit7))  ;
						{
							loop,Parse,LoopFieldInhalte,`n,`r
							{
								; E2E7(A_LineNumber,Edit2,Edit7,A_LoopField,-2) ;
								if(RegExMatch(A_LoopField,Edit7))
									GesPaths:=GesPaths  "`r`n"  A_LoopField
								; ListVars ;
								; MsgBox % Edit7 ;
							}
						}
					}
					else
					{
						; SoundBeep, 8000,50 ;
						; dummy:=E2E7(A_LineNumber,Edit2,Edit7,RegEx,-2) ;
						; MsgBox % A_LineNumber ;
						; if(InStr(A_LoopFileFullPath,Edit7)) ;
						{
							; MsgBox % A_LineNumber ;
							loop,Parse,LoopFieldInhalte,`n,`r
							{
								; E2E7(A_LineNumber,Edit2,Edit7,A_LoopField,-2) ;
								; if(InStr(A_LoopField,trim(Edit7))) ;
								 IfInString,A_LoopField,%Edit7%
									GesPaths:=GesPaths "`r`n" A_LoopField    ; , 							E2E7(A_LineNumber,Edit2,Edit7,GesPaths,0)
							}
						}
					}
				}
				Else
				{
					GesPaths:=GesPaths  LoopFieldInhalte  ; , 							E2E7(A_LineNumber,Edit2,Edit7,GesPaths,0)
				}
				If (LangsamDemo and A_index<10 and FruehzeitigRueck<>"") ; and SucheAbrechen >200 +++++++++++++++++++++++++++++++++++++++++++++++++++++
				{
					StringTrimLeft,GesPathsOhneCrLf,GesPaths,2
					sort,GesPathsOhneCrLf,U
					%FruehzeitigRueck%:=GesPathsOhneCrLf
					SuperFruehzeitigRueck:=%FruehzeitigRueck%
					GuiControl,, %FruehzeitigRueck%, %SuperFruehzeitigRueck%
					sleep 150
				}
										
				; MsgBox % GesPaths ;
				if(A_Index>SucheAbrechen)
				{
					If AuAb
					{
						DoubleEdit6:=true
						
					}
					If Fehlersuche
						MsgBox break
					break
					

				}
			}
			; LastGesPaths:=GesPaths ;
		
	
	}
	StringTrimLeft,GesPaths,GesPaths,2

	beschaeftigt:=false
	GuiControl,, beschaeftigt, 0
	If not SuchAbbruch
	{
		Edit1:=ZaehleZeilen(GesPaths)  ; -1		; minus 1 weil ein `r`n zuviel ist noch klaeren Alle stimmt wahrscheinlich nicht
		GuiControl,, Edit1, %Edit1%
	}
	else
	{
		Edit1=?
		GuiControl,, Edit1, %Edit1%
	}
/*
	If AuAb
	{
		if DoubleEdit6
		{
			If(StrLen(Edit2)>=Edit9)
			{
				SoundBeep,5000,200

				Edit6:=Round((Edit1+1)*1.5+1)
				GuiControl,, Edit6,%Edit6%
				DoubleEdit6:=false
			}
		}
	}
*/
	If Fehlersuche
MsgBox Getpaths() return
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
		; TrayTip,LogInhalt2,%LogInhalt% ;
		; sleep 2000 ;
		FileAppend,%LogInhalt%,%A_ScriptFullPath%.Log
	}
	return
}
*/
SASize:		; wird bei jeder Fensterbewegung aufgerufen
; WinActivate,ahk_class CabinetWClass ;
; WinWaitActive,ahk_class CabinetWClass,,2 ;
; if ErrorLevel ;
; { ;
; 	SoundBeep,300,500 ;
;	return ;
; } ;
WinGetPos,ExplWinX,ExplWinY,ExplWinB,ExplWinH,ahk_class CabinetWClass
; ControlGetPos,,ContY,,,ShellTabWindowClass1,ahk_class CabinetWClass ;
; WinGetPos,WinX,WinY,WinB,WinH,ahk_id %GuiWinHwnd% ;
; WinH:=ContY ;
; WinMove,ahk_id %GuiWinHwnd%,,%WinX%,%WinY%,%WinB%,%WinH% ;
if (ExplWinX<>"" and ExplWinY<>"" and ExplWinB<>"" and ExplWinH<>"")
{
	gosub IfMainGuiMinRestore
	if(ExplWinB*1.5<A_ScreenWidth or ExplWinH*1.5<A_ScreenHeight)
		WinMove,ahk_id %GuiWinHwnd%,,%ExplWinX%,%ExplWinY%,%ExplWinB%,%ExplWinH%
}
else
{
	; SoundBeep,300,500 ;
	; SoundBeep,300,500 ;
	; SoundBeep,300,500 ;
}

A:	; aktiviere GuiWin
SA:	; aktiviere GuiWin
SelfActivate:	; aktiviere GuiWin
AktionBeiClipChange:=
If Fehlersuche
	TrayTip,SelfActivate,SelfActivate
gosub IfMainGuiMinRestore
GuiControl, , %HwndButton2%,-> | 
GuiControl, , %HwndButton4%,Explorer (Enter) 

Gui,Submit,NoHide
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
return

NeuStarten:						; hier alle Enden Sammeln und noch speichernswertes pruefen...
R:
Reload
return
GuiClose:
; WinClose, ButtonGui ;
; WinClose, TastWatch.ahk ;
Process, Close, %TastWatchPid%
ExitApp
; sleep 10 ;
ControlFocus,Edit2,A
; MarkiereSuchtext(Edit2,"Edit5","ZackZack" ) ;
return
LV:
ListVars
return


2b2:
Edit2:=Edit2*2
sb2:
		Gui,Submit,NoHide
bs2:
		GuiControl,, %HwndEdit2%, %Edit2%
		; SoundBeep,8000,70 ;
		Gui,Submit,NoHide
		; SoundBeep,1000,90 ;
return
b2:
		Gui,Submit,NoHide
2:
		GuiControl,, %HwndEdit2%, %Edit2%
		; SoundBeep,8000,70 ;
		; Gui,Submit,NoHide ;
		; SoundBeep,2000,90 ;
return

ListLabels:
LL:
AutoTrim, Off
LabelList:=
FileRead,ScriptQuellcode,%A_ScriptFullPath%
Loop,Parse,ScriptQuellcode,`n,`r
{
	; if(InStr(A_LoopField,"::")) ;
	; 	ToolTip %A_LoopField% ;
	if(InStr(A_LoopField,":") and not InStr(A_LoopField,"`="))
	{
		
		StringSplit,ScriptQuellLabelZeile,A_LoopField,:
		If(InStr(ScriptQuellLabelZeile1,A_Space))
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
			
		; LabelList:=LabelList "`r`n" ScriptQuellLabelZeile1 PlusDop ;
		LabelList:=LabelList "`r`n" A_LoopField
		; ToolTip, % SubStr(LabelList,-500) ;
		; sleep 200 ;
	}
}
StringTrimLeft,LabelList,LabelList,2
sort,LabelList,U
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
; StringReplace,LabelList,LabelList,%A_Space%%A_Space%,`,%A_Space%,All ;
StringReplace,VorLabelList,VorLabelList,`n,`r`n,All
LabelList:=VorLabelList "`r`n"   LabelList
; sleep 100 ;
; Gui,Submit,NoHide ;
FileDelete,%A_AppDataCommon%\LabelList.txt
FileAppend,%LabelList%,%A_AppDataCommon%\LabelList.txt
if ZackZackOrdnerLogErstellen
	ThreadUeberwachungLog(A_LineNumber-1,A_ThisHotkey,A_ThisLabel,A_ThisFunc,A_ThisMenu,A_ThisMenuItem,A_ThisMenuItemPos)
run, notepad.exe "%A_AppDataCommon%\LabelList.txt"
if ZackZackOrdnerLogErstellen
	ThreadUeberwachungLog(A_LineNumber-1,A_ThisHotkey,A_ThisLabel,A_ThisFunc,A_ThisMenu,A_ThisMenuItem,A_ThisMenuItemPos)
; Edit5:=LabelList ;
; GuiControl,,%HwndEdit5%,%Edit5% ;
; ControlSetText,ahk_id %HwndEdit5%,%LabelList% ;
; Gui,Submit,NoHide ;
; ToolTip ;
; MsgBox ;
; MsgBox % HwndEdit5 ;
AutoTrim, On
return
Farbe:
GuiControl +BackgroundFF9977, %HwndEdit1%
GuiControl +BackgroundFF9977, %HwndButton1%
return

ExplorerPfadEingeben:
Ex:
; NeueHoehe:=150 ;
; gosub GuiSetSize											; WinH  ShellTabWindowClass1 ;
IfWinActive,ahk_class CabinetWClass
	WinGetPos,ExplWinX,ExplWinY,ExplWinB,ExplWinH,A
; WinGetPos,ExplWinX,ExplWinY,ExplWinB,ExplWinH,ahk_class CabinetWClass ;
; WinGetPos,WinX,WinY,WinB,WinH,ahk_class CabinetWClass ;
; ControlGetPos,,ContY,,,ShellTabWindowClass1,ahk_class CabinetWClass ;
; WinGetPos,WinX,WinY,WinB,WinH,ahk_id %GuiWinHwnd% ;
; WinH:=ContY ;
; WinMove,ahk_id %GuiWinHwnd%,,%WinX%,%WinY%,%WinB%,%WinH% ;
if (ExplWinX<>"" and ExplWinY<>"" and ExplWinB<>"" and ExplWinH<>"")
WinMove,ahk_id %GuiWinHwnd%,,%WinX%,%WinY%,%WinB%,%WinH%
/*
ControlFocus,ComboBox1,ahk_class CabinetWClass
sleep 90
ControlClick,ComboBox1,ahk_class CabinetWClass
sleep 2000

ControlFocus,ComboBoxEx321,ahk_class CabinetWClass
sleep 90
ControlClick,ComboBoxEx321,ahk_class CabinetWClass
sleep 2000

ControlFocus,ToolbarWindow324,ahk_class CabinetWClass
sleep 90
ControlClick,ToolbarWindow324,ahk_class CabinetWClass
sleep 2000
*/
ControlFocus,ToolbarWindow323,ahk_class CabinetWClass
sleep 90
ControlClick,ToolbarWindow323,ahk_class CabinetWClass
/*
sleep 2000

ControlFocus,Breadcrumb Parent1,ahk_class CabinetWClass
sleep 90
ControlClick,Breadcrumb Parent1,ahk_class CabinetWClass
sleep 2000

ControlFocus,msctls_progress321,ahk_class CabinetWClass
sleep 90
ControlClick,msctls_progress321,ahk_class CabinetWClass
sleep 2000

ControlFocus,Address Band Root1,ahk_class CabinetWClass
sleep 90
ControlClick,Address Band Root1,ahk_class CabinetWClass
sleep 2000
*/
Gui,Submit,NoHide
sleep 90
ControlSetText,Edit1,% FuehrendeSterneEntfernen(Edit8),ahk_class CabinetWClass
sleep 20
ControlSend,Edit1,{Enter},ahk_class CabinetWClass
; NeueHoehe:=150 ;
; gosub GuiSetSize ;
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
; FileDelete,%A_AppDataCommon%\Fensterinfo.htm ;
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
FileAppend,%HTML_Liste%,%ThisHtmlPath%
if ZackZackOrdnerLogErstellen
	ThreadUeberwachungLog(A_LineNumber-1,A_ThisHotkey,A_ThisLabel,A_ThisFunc,A_ThisMenu,A_ThisMenuItem,A_ThisMenuItemPos)
; sleep, 600 ;
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
	; FileAppend, %ControlList%, c:\temp\controls.txt ;
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
		;	MsgBox % ThisClassNN "`n" VarNameClassNN  ;
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
				; MsgBox % KorrParentControlListHwnd "`n" KorrParentControlList   "		gleich wie`n" KorrControlHwnd1 "`n" KorrControlclassNN1 "`n" ThisHwnd "`n"   "`n"  "`n"  ;
				Loop, % KorrControlHwnd0
				{
					if(KorrControlHwnd%A_Index%=ThisHwnd) 
					{
						Class_%ThisHwnd%:=KorrControlClassNN%A_Index%
						; MsgBox % Class_%ThisHwnd% ;
						; ControlClassNN%A_Index% ;
					}
				}
			}
			ControlGetText,Text_%ThisHwnd%,,ahk_id %ThisHwnd%
			ControlGetPos,Pos1_%ThisHwnd%,Pos2_%ThisHwnd%,Pos3_%ThisHwnd%,Pos4_%ThisHwnd%,,ahk_id %ThisHwnd%
			ParentClass_%ThisHwnd%:=GetParentClass(ThisHwnd)
			; MsgBox % ParentClass_%ThisHwnd% ;
			ThisParentsAnzeige:=GetParentsHwndList(ThisHwnd)
				StringReplace,Unnuetz,ThisParentsAnzeige, 0x,,UseErrorLevel 
				Anzahl0x:=ErrorLevel
				; if (Anzahl0x>1) ;
					; MsgBox drinn ;
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
				; If (ThisWinTitle<>"") ;
					; MsgBox % ThisWinTitle "drinn" ThisHwnd ;
					ThisWinTitle=<b>%ThisWinTitle%</b>
				VorParent=
				NachParent=
			}
			ThisLine:= VorZeile 	     	VorVar ThisWinTitle VorParent Class_%Last% NachParent " " ThisParentsAnzeige  NachVar            VorVar  VorAnker  ThisHwnd NachAnker VorHervorheben ThisHwnd NachHervorheben NachVar 	VorVar Einrueck Einrueck Einrueck Einrueck  Class_%ThisHwnd% NachVar 	VorVar Pos1_%ThisHwnd% NachVar 	VorVar Pos2_%ThisHwnd% NachVar 	VorVar Pos3_%ThisHwnd% NachVar 	VorVar Pos4_%ThisHwnd% NachVar 		VorVar Text_%ThisHwnd% NachVar			NachZeile
			Lines:=Lines ThisLine
		}
		Gesammt:=	Header	 VorWinTitle WinHwnd "  "  WinClass " " WinTitle NachWinTitle	  TabellenUeberschrift	 Lines Bottom
	; MsgBox % Gesammt ;
	DetectHiddenWindows,%VorDetectHiddenWindows%
	DetectHiddenText,%VorDetectHiddenText%
	return Gesammt
	}
	Return "Error: Die Control_Anzahl aenderte sich waehrend den Abfragen"
}

GetParent(Hwnd)
{
	; If(ParentBisHwnd="") ;
		; ParentBisHwnd:=WinExist("ahk_id" DllCall("GetDesktopWindow")) ; Gibt das oberste HWND zurueck ;
	
	ID := DllCall("GetParent", UInt,WinExist("ahk_id " Hwnd)), ID := !ID ? WinExist("ahk_id " Hwnd) : ID
	; MsgBox % ID ;
	return ID
}
GetParentClass(Hwnd,ParentBisHwnd="")
{
	OldFormat:=A_FormatInteger
	SetFormat,IntegerFast,hex
	; ParentHwnd:=WinExist("ahk_id " GetParent(Hwnd)) ;
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
	; ParentHwnd:=WinExist("ahk_id " GetParent(Hwnd)) ;
	; If(Hwnd<>NullHwnd) ;
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
			; ParentHwnd:=ParentHwnd+0 ;
			If(substr(ParentHwnd+0 ,1)=substr(NullHwnd+0,1))
			{
				HwndIstNull:=true
				; MsgBox ParentHwnd ist NullHwnd erreicht   ; wird mehrfach erreicht ;
				break
			}
			else If(substr(ParentHwnd+0 ,1)=substr(RootHwnd+0 ,1))
			{
				HwndList:=ParentHwnd A_Tab HwndList
				RootErreicht:=true
				; MsgBox Root erreicht ; wird mehrfach erreicht ;
				break
			}
			else if(substr(Hwnd+0 ,1)=substr(ParentHwnd+0 ,1))
			{
				; HwndList:=ParentHwnd A_Tab HwndList ;
				; MsgBox HWND=ParentHwnd wird erreicht    ; wird mehrfach erreicht ;
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
	; else ;
		; MsgBox nullHwnd erkannt ;
	; WinGetClass,ParentClass,ahk_id %LastGoodHwnd% ;
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
;		if(StrLen(T)=1) ;
;			MsgBox naechste Zeile scharfschalten ;
;			T="0" . T ;
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
	; ID := DllCall("GetParent", UInt,WinExist("A")), ID := !ID ? WinExist("A") : ID		; original ;
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
		; ID := DllCall("GetParent", UInt,WinExist("A")), ID := !ID ? WinExist("A") : ID		; original ;
		ID := DllCall("GetParent", UInt,WinExist("ahk_id " Hwnd)), ID := !ID ? WinExist("ahk_id " Hwnd) : ID
		;  If(ID=0) ;
			;  break ;
	; LastID:=ID ;
		SetFormat IntegerFast,h
		gosub CHwnd_Class_Get
		Hwnd:=ID
		Erg2:= "`n" Tabs Erg   Erg2
		WinGetClass, ThisControlClass, ahk_id %ID%
		Erg1:= "`n" TabsW1  ID  "  " ThisControlClass  Erg1
		; MsgBox % Erg1 ;
		If(ID="" or ID=LastID or ID=0)
			break
		LastID:=ID
		I:=A_Index
		StringTrimLeft, Tabs,Tabs,1
	}
	; Zeichen:=(20-I)*2 ;
	; 	StringTrimLeft, Erg1,Erg1,Zeichen ;
	; 	StringTrimLeft, Erg2,Erg2,Zeichen ;
	Erg:=  Erg1 ;  "`n" "Klasse" Erg2
	SetFormat IntegerFast,d
	return 
	
	CHwnd_Sons_Get:
	WinGet, Erg , ControlListHwnd,ahk_id %Hwnd%
	; ControlGet, ThisControlGetHwnd, List , , , ahk_id %Hwnd% ;
	; MsgBox % ">" ThisWinGetHwnd "<`n`n>" ThisControlGetHwnd "<" ;
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
		; Gui,Restore ;
		WinRestore,ahk_id %GuiWinHwnd%
	}
return

zaehle:
; 20160329155429 ; Critical,Off
; 20160329155430 ; Thread,Priority,-1
Loop
{
	sleep -1
	sleep 100
	sleep -1
	ToolTip, % A_index	
}

TestumgebungErzeugen:
TempSpielw:=ZackData "\TestUmgebung"
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
			FileAppend,Mein Ausganspunkt ist in ...\%DieseFarbe%\%DieseZahl%`r`ndort bin ich die %A_LoopField% Datei,%TempSpielw%\%DieseFarbe%\%DieseZahl%\%DieseFarbe%_%DieseZahl%_%A_Index%.txt
		}
	}
}
run, %TempSpielw%
MsgBox, 262145, Kontainer anlegen, Menue: Kontainer. | anlegen`nNamensvorschlag:	Testumgebung`n`n`ndann den neuen Start-Pfad`n`n%TempSpielw%`n`neingeben`n`n`nanschlieessend weiter mit OK
IfMsgBox,OK
{
	IfExist %ZackData%\WuCont\Testumgebung\Wurzel1.txt
	{
		MsgBox, 262144, gratuliere, der Kontainer `n%ZackData%\WuCont\Testumgebung`nwurde erfolgreich angelegt und der Start-Pfad`n%ZackData%\Testumgebung`nwurde eingelsen.`n`n`nNun kann man mit`nMenue: Kontainer | Uebersicht erzeugen`ndiesen dem Programm bekanntgebeen. (hierbei schliesst sich diesee Box wegen des erforderlichen Neustarts des Programmes.`nNach erfolgtetm Neustart`n`nMenue: Kontainer | Uebersicht oeffnen`neingeben der Zeilen-Nummer im Feld NR Wahl`nMenue: Kontainer | oeeffnen
	}
	else IfExist %ZackData%\WuCont\Testumgebung
		MsgBox, 262144, gratuliere, der Kontainer `n%ZackData%\WuCont\Testumgebung`nwurde erfolgreich angelegt.`n`n jedoch der Start-Pfad`n%ZackData%\Testumgebung`nwurde wurde nicht gefunden.
}
else
	return
return

GuiDropFiles:
; gosub GetGuiYAbzuziehen 					; := GetGuiYAbzuziehen()				Wert aus TitelLeistenHoehe + Aktuelle MenueHoehe ;
; MsgBox % A_GuiControl "		" GuiYAbzuziehen "		" DieseThisX "		" DieseThisY "		" DieseThisB "		" DieseThisH ;
; Loop, parse, A_GuiEvent, `n ;
{
	; FileRead,ThisGuiDropInhalt1,%A_LoopField% ;
; 	StringSplit,ThisGuiDropInhalte1,ThisGuiDropInhalt1,e ;
;	FileRead,ThisGuiDropInhalt2,%A_LoopField% ;
; 	StringSplit,ThisGuiDropInhalte2,ThisGuiDropInhalt2,e ;
    ; MsgBox, 4,, Dateinummer %A_Index% ist:`n%A_LoopField%.`nangekommen auf Steuerelement %A_GuiControl%`nan der Stelle %A_GuiX% und %A_GuiY%`nSonstiges:`n%ThisGuiDropInhalt1%`n `n%ThisGuiDropInhalt2%`nWeiter? ;
	; Clipboard:=A_GuiControl ;
	if(A_GuiControl="")
	{
		; ControlGetPos,DieseThisX,DieseThisY,DieseThisB,DieseThisH,ahk_id %HwndCheckK5%  ;
 
 		; MsgBox If((%DieseThisX% < %A_GuiX%) and (%A_GuiX% < (%DieseThisX% + %DieseThisB%))	and 	(%DieseThisY% < (%A_GuiY%-%GuiYAbzuziehen%)) and ((%A_GuiY%-%GuiYAbzuziehen%) < (%DieseThisY% + %DieseThisH%))) ;
 		If((DieseThisX < A_GuiX) and (A_GuiX < (DieseThisX + DieseThisB))	and 	(DieseThisY < (A_GuiY-GuiYAbzuziehen)) and ((A_GuiY-GuiYAbzuziehen) < (DieseThisY + DieseThisH)))
		{
			return
		}
	}
	; MsgBox % A_GuiControl ;
	; Clipboard:=A_GuiControl ;
	If A_GuiControl is Integer
	{
		ZielPfadWirdUebrgeben:=true
		Zielpfad:=GetZeile(Edit5,A_GuiControl)
		DateiPfadeWerdenUebergeben:=true
		DateiPfade:=A_GuiEvent
		gosub KopiereOderVerschiebeFilesAndFolders		
		return		
	}
	else If (A_GuiControl="Edit10")
	{
		If(Edit10="" or Edit10="Zusatz" )  ; ; IfNotExist %Edit10%
		{
			; zu welchem Skript oder Programm sollen die Dateien uebergeben werden?													Text-Dokumente (*.txt; *.doc) ;
			FileSelectFile,UbergabeProgramPfad,,,zu welchem Skript oder Programm sollen die Dateien uebergeben werden?,ausfuehrbare Dateien (*.*; *.ahk; *.exe; *.bat)
			if ErrorLevel
				return
			IfNotExist %UbergabeProgramPfad%
				return
			Edit10:=UbergabeProgramPfad
			gosub Edit10Festigen
		}
		Gui,Submit,NoHide
		; MsgBox % A_GuiEvent ;
		; StringReplace,UebergabePfade,A_GuiEvent,`r`n,%A_Space%, All ;
		StringSplit,GuiDropEinzelPfad,A_GuiEvent,`n,`r
		; UebergabePfade="%UebergabePfade%" ;
		Run, %Edit10% "%GuiDropEinzelPfad1%" "%GuiDropEinzelPfad2%" "%GuiDropEinzelPfad3%" "%GuiDropEinzelPfad4%" "%GuiDropEinzelPfad5%" "%GuiDropEinzelPfad6%" "%GuiDropEinzelPfad7%" "%GuiDropEinzelPfad8%" "%GuiDropEinzelPfad9%" "%GuiDropEinzelPfad10%" "%GuiDropEinzelPfad11%" 
		if ZackZackOrdnerLogErstellen
			ThreadUeberwachungLog(A_LineNumber-1,A_ThisHotkey,A_ThisLabel,A_ThisFunc,A_ThisMenu,A_ThisMenuItem,A_ThisMenuItemPos)
		return
	}
	else	If (A_GuiControl="-> &Clip")							; DopFiles auf Button3: die angekommenen Pfade werden ins Clipboard geschrieben
	{
		; Clipboard:=A_GuiEvent ;
		StringReplace,Clipboard,A_GuiEvent,`n,`r`n,All
		TrayTip GuiDropFiles, dropped Files-Paths on Button3 ---> Clipboard
		return
	}
	else	If (A_GuiControl=Button6Name)							; DopFiles auf Button6: siehe GuiDropFilesButton6.ahk
	{
		IfExist %A_ScriptDir%\GuiDropFilesButton6.ahk
		{
			; A_GuiEvent ;
			; IfExistCallEExeOrAhk(A_ScriptDir "\GuiDropFilesButton6.ahk",A_GuiEvent) ;
			run, "%A_ScriptDir%\GuiDropFilesButton6.exe" "%A_ScriptDir%\GuiDropFilesButton6.ahk"
			
			TrayTip GuiDropFiles, dropped Files-Paths send at GuiDropFilesButton6.ahk
		}
		return
	}
	else	If (A_GuiControl="-> &I" or A_GuiControl="-> |   (Enter)")			; -> |   (Enter)	; DopFiles auf Button 2 wird so interpraetiert als moechte man die Datei im Oeffnen Dialog eines ahk_class #32770-Fensters eingeben.
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
				Gui,Submit,NoHide
				; Clipboard:=DateinamenInHochKommasMitBlankGetrennt ;
				Edit8:=DateinamenInHochKommasMitBlankGetrennt
				gosub Edit8Festigen
				BsAnMerker:=BsAn
				BsAn:=0
				GuiControl,,%HwndCheckB2%,0
				gosub BsAn
				WinWaitActive,ahk_class #32770,,2
				if  ErrorLevel
					return
				Sleep 10
				gosub Button2
				sleep 10
				if BsAnMerker
				{
					; gosub SelfActivate ;
					; sleep 500 ;
					BsAn:=1
					GuiControl,,%HwndCheckB2%,1
					gosub BsAn
				}		
				; BsAn:=BsAnMerker ;
				; GuiControl,,%HwndCheckB2%,%BsAnMerker% ;
			}
			return
		}
		Edit8:=GuiDropEinzelPfad1
		gosub Edit8Festigen
		WinWaitActive,ahk_class #32770,,2
		if  ErrorLevel
			return
		gosub Button2
		return
	}
	else if(True or A_GuiControl="Edit5" Or A_GuiControl="Edit8")	; 	True entfernen wenn weiter aufgeschlüsselt werden soll ###################
	{
		if(A_GuiControl="Edit5")
		{
			ThisZeile:=round((((A_GuiY - GuiYAbzuziehen)-Edit5Y0)+round(ZeilenVersatzY/2))/ZeilenVersatzY)			; Edit5Y0:=125		Die 52 duerfte sich aus Unterkante Menue 50 +irgend ein Rand 2 zusammensetzen	Die TitelleistenPlusMenuHoehe duerfte mt 51 hinkommen
			Edit3:=ThisZeile
			GuiControl,, Edit3, %Edit3%
		gosub Edit3
		}
		; gosub SucheInEdit5Markieren ;
		DateiPfadeWerdenUebergeben:=true
		ControlText:=
		DateiPfade:=A_GuiEvent
		gosub KopiereOderVerschiebeFilesAndFolders
		return
	}
; 20160330105416 ; /*
; 20160330105417 ; 	Loop, parse, A_GuiEvent, `n
; 20160330105419 ; 	{
; 20160330105420 ; 		If(A_GuiY>115 and A_GuiY<(GuiHeight-35) and A_GuiX<122 and A_GuiX>92)
; 20160330105420 ; 		{
; 20160330105421 ; 			ThisZeile:=round((((A_GuiY-123)+6)/13))
; 20160330105422 ; 			Edit3:=ThisZeile
; 20160330105422 ; 			GuiControl,, Edit3, %Edit3%
; 20160330105423 ; 			gosub Edit3
; 20160330105424 ; 			; gosub Button2
; 20160330105441 ; 		}
; 20160330105443 ; 		else If(A_GuiY>102  and A_GuiX<122 and A_GuiX>92)
; 20160330105444 ; 		{
; 20160330105445 ; 			; gosub Edit2
; 20160330105446 ; 			return
; 20160330105447 ; 		}
; 20160330105448 ; 		else if((90+Edit5Hoehe<A_GuiY) and A_GuiX>122)		 ;	381	412  A_GuiHeight
			
; 20160330105451 ; {
; 20160330105453 ; 			if(A_GuiX<116 and A_GuiX>92)
; 20160330105502 ; 			{
; 20160330105503 ; 				; gosub Edit2
; 20160330105504 ; 				; LetzerAendererVonEdit5:="Edit3"
; 20160330105505 ; 				return
; 20160330105520 ; 			}
				
; 20160330105528 ; 			; gosub SucheInEdit5Markieren
; 20160330105529 ; 			; If Fehlersuche
; 20160330105530 ; 			; 	SoundBeep 400
; 20160330105531 ; 			; ControlFocus,Edit5,ahk_id %GuiWinHwnd%
; 20160330105532 ; 		}

; 20160330105535 ; 	else if A_GuiControl
; 20160330105536 ; 	 {
; 20160330105536 ; 		return
; 20160330105537 ; 		; SoundBeep,2000
; 20160330105538 ;         Steuerelement := "`n(im Steuerelement " . A_GuiControl . ")"
; 20160330105539 ; 		ToolTip Sie haben im GUI-Fenster #%A_Gui% auf die Koordinaten %A_GuiX%x%A_GuiY% geklickt.%Steuerelement%
; 20160330105540 ; 	}
; 20160330105541 ; 	return
; 20160330105542 ; */
}

Integer3Hex(Int,NullX="")			; NullX=[|x|X]		leer	->	hex (ohne Ox)		; 		x	->	0xhex		;		X	->	0xHEX
{
	if (NullX="")
		Hex:=Format("{1:x}",Int)
	else 
		Hex:=Format("{1:#" NullX "}",Int)
	return Hex
}

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

IfNotExist % SkriptDataPath "\!Fav"
	FileCreateDir, % SkriptDataPath "\!Fav"
FileAppend,`r`n%ThisNewFavoritNameUrl2%,%SkriptDataPath%\!Fav\%ThisNewFavoritNameUrl1%.txt
return

MinusStern:
Loop,Files,%SkriptDataPath%\!Fav\*.txt, F
{
	LoopFileLongPath:=A_LoopFileLongPath
	SplitPath,A_LoopFileLongPath,LoopFileLongName  ,LoopFileLongDir
	If (LoopFileLongName="")
	{
		LoopFileLongName:=LoopFileLongDir
		LoopFileLongPath:=SubStr(A_LoopFileLongPath,1,-4) LoopFileLongDir ".txt"
		StringReplace,LoopFileLongPath,LoopFileLongPath,:,˸,All
	}
	; SplitPath,% FuehrendeSterneEntfernen(Edit8),ThisEdit8Name  ; ,LoopFileLongDir ;
	SplitPath,% FuehrendeSterneEntfernen(Edit8),ThisEdit8Name,ThisEdit8Dir
	If (ThisEdit8Name="")
		ThisEdit8Name:=ThisEdit8Dir
		StringReplace,ThisEdit8Name,ThisEdit8Name,:,˸,All
		; MsgBox 	>%LoopFileLongName%<	>%ThisEdit8Name%.txt<	%LoopFileLongPath% ;
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
					FileAppend,%NewFavoriteInhalt%,%LoopFileLongPath%
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
	GuiControl,, %HwndEdit3%, %Edit3%
	gosub HwndButton1
return
AutoFavoritEingeben:
AutoFavoritVorher:=AutoFavorit
InputBox,AutoFavorit,AutoFavorit,bis zu wieviele Sterne sollen bei Benutzung automatisch Sterne verteilt werden?`n(0 = AutoFavorit deaktiviert),,,,,,,,%AutoFavorit%
if ErrorLevel
	AutoFavorit:=AutoFavoritVorher
if AutoFavorit is not Integer
	AutoFavorit:=AutoFavoritVorher
if (AutoFavorit<0)
	AutoFavorit:=0
return

SetAutoFavorit:
if((StrLen(Edit8)-StrLen(FuehrendeSterneEntfernen(Edit8))) < AutoFavorit)
	gosub PlusStern
return
	
PlusStern:
IfNotExist %SkriptDataPath%\!Fav
	FileCreateDir %SkriptDataPath%\!Fav
FavoritAngelegt:=false
Loop,Files,%SkriptDataPath%\!Fav\*.txt, F
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
		; MsgBox 	>%LoopFileLongName%<	>%ThisEdit8Name%.txt<	%LoopFileLongPath% ;
	if (LoopFileLongName=ThisEdit8Name ".txt")
	{
		; MsgBox Drinn >%ThisEdit8Name%<	%LoopFileLongPath%	>%LoopFileLongName%< ;
		FileRead,ThisFavoriteInhalt,%LoopFileLongPath%
		OldFavoriteInhalt:=ThisFavoriteInhalt
		ThisFavoriteInhalt:=ThisFavoriteInhalt "`r"
		StringReplace,NewFavoriteInhalt,ThisFavoriteInhalt,% "*" FuehrendeSterneEntfernen(Edit8) "`r", %  "**" FuehrendeSterneEntfernen(Edit8) "`r"
		if(NewFavoriteInhalt=ThisFavoriteInhalt)
			StringReplace,NewFavoriteInhalt,ThisFavoriteInhalt,% "`n" FuehrendeSterneEntfernen(Edit8) "`r", %  "`n*" FuehrendeSterneEntfernen(Edit8) "`r"
		else
			NewFavoriteInhalt:=NewFavoriteInhalt
		StringReplace,NewFavoriteInhalt,NewFavoriteInhalt,`r`n`r,`r,All
		StringTrimRight,NewFavoriteInhalt,NewFavoriteInhalt,1
		if(OldFavoriteInhalt<>NewFavoriteInhalt)
		{
			FileDelete,%LoopFileLongPath%
			if ErrorLevel
			{
				MsgBox, 262192, Fehler, Die Datei `n%LoopFileLongPath%`nkonnte nicht geloescht werden.`nSomit kann auch kein Stern zugefuegt werden.`nBitte manuell den Stern zufuegen.
			}
			else
			{
				FileAppend, %NewFavoriteInhalt%,%LoopFileLongPath%	;	.tmp
				if ErrorLevel
				{
					MsgBox, 262192, Fehler, Die Datei `n%LoopFileLongPath%`nkonnte nicht erstellt werden.`nSomit konnte auch kein Stern zugefuegt werden.`nBitte manuell den Stern zufuegen.
				}
				else
					FavoritAngelegt:=true
			}
		}
		else
		{
			MerkerA_LoopFileDir:=A_LoopFileDir
		}
	}
}
if not FavoritAngelegt
	{
		; SplitPath,A_LoopFileLongPath,LoopFileLongName  ; ,LoopFileLongDir ;
		SplitPath,% FuehrendeSterneEntfernen(Edit8),ThisEdit8Name  ; ,LoopFileLongDir
		If (ThisEdit8Name="")
		ThisEdit8Name:=ThisEdit8Dir
		StringReplace,ThisEdit8Name,ThisEdit8Name,:,˸,All
		; if (LoopFileLongName=ThisEdit8Name) ;
		{
			NewFavoritInhalt:="`r`n*" Edit8
			FileAppend, %NewFavoritInhalt%,%SkriptDataPath%\!Fav\%ThisEdit8Name%.txt	;	.tmp2
			if ErrorLevel
			{
				MsgBox, 262192, Fehler, Die Datei `n%SkriptDataPath%\!Fav\%ThisEdit8Name%.txt`nkonnte nicht erstellt werden.`nSomit kann auch kein Stern zugefuegt werden.`nBitte manuell den Stern zufuegen.
			}
		}
	}
	Edit3:=1
	GuiControl,, %HwndEdit3%, %Edit3%
	gosub HwndButton1
return

; 20160330105933 ; /*

; 20160330105937 ; FaforitEntfernt:=false
; 20160330105938 ; Sternweg:=true
; 20160330105939 ; PlusStern:
; 20160330105939 ; SternSetzen:=true
; 20160330105940 ; FavoritAngelegt:=false
; 20160330105941 ; ; MsgBox % A_LineNumber "	" A_ThisLabel
; 20160330105941 ; ; MsgBox % "Loop,Files," SkriptDataPath "\" FuehrendeSterneEntfernen(ThisMarkierfolder) ".txt", F R
; 20160330105942 ; if (ThisMarkierfolder<>"")
; 20160330105951 ; {
; 20160330105952 ; 	MsgBox % "ThisMarkierfolder=" ThisMarkierfolder
; 20160330105952 ; 	Loop,Files,% FuehrendeSterneEntfernen(SkriptDataPath "\" ThisMarkierfolder) ".txt", F R
; 20160330105953 ; 	{
; 20160330105954 ; 		MsgBox % A_LineNumber "	" A_LoopFileLongPath "	" A_LoopFileDir "	" A_LoopFileName
; 20160330105955 ; 		If (A_ThisLabel="PlusStern")     
; 20160330105955 ; 		{
; 20160330105956 ; 			NewFavoritInhalt:="`r`n*" Edit8
; 20160330105957 ; 		}
; 20160330105957 ; 		else If (A_ThisLabel="MinusStern")
; 20160330105958 ; 		{
; 20160330105959 ; 			NewFavoritInhalt:="`r`n" FuehrendeSterneEntfernen(Edit8,1)
; 20160330105959 ; 		}
; 20160330110000 ; 		MsgBox % A_LineNumber "	"  "NewFavoritInhalt " NewFavoritInhalt
; 20160330110001 ; 		SplitPath,A_LoopFileDir,,LoopFileDirVonDir
; 20160330110001 ; 		IfNotExist % FuehrendeSterneEntfernen(LoopFileDirVonDir "\!Fav")
; 20160330110002 ; 			FileCreateDir,% FuehrendeSterneEntfernen(LoopFileDirVonDir "\!Fav")
; 20160330110007 ; 		 MsgBox, % " ist der da " . FuehrendeSterneEntfernen(LoopFileDirVonDir . "\!Fav\" . A_LoopFileName)
; 20160330110009 ; 		IfExist, % FuehrendeSterneEntfernen(LoopFileDirVonDir "\!Fav\" A_LoopFileName)
; 20160330110010 ; 		{
; 20160330110010 ; 			; if (not InStr(NewFavoritInhalt,"*"))
; 20160330110011 ; 			{
; 20160330110012 ; 				Loop
; 20160330110013 ; 				{				; ueber die Zeilen eines Fav-Files
; 20160330110013 ; zeilenindexFav:=A_Index
; 20160330110014 ; 					if(A_Index=1)
; 20160330110015 ; 						continue
; 20160330110016 ; ThisFavoritEintrag:=
; 20160330110042 ; 					FileReadLine, ThisFavoritEintrag,% FuehrendeSterneEntfernen(LoopFileDirVonDir "\!Fav\" A_LoopFileName),%A_Index%
; 20160330110046 ; 					MsgBox % zeilenindexFav A_Tab A_LoopFileLongPath A_Tab ThisFavoritEintrag
; 20160330110049 ; 					if (ThisFavoritEintrag="")
; 20160330110053 ; 					{
; 20160330110103 ; 						ThisFavoritZeilenAmzahl:=A_Index-1
; 20160330110107 ; 						break
; 20160330110111 ; 					}
; 20160330110115 ; 					if(FuehrendeSterneEntfernen(ThisFavoritEintrag)=FuehrendeSterneEntfernen(Edit8))
; 20160330110121 ; 					{
; 20160330110124 ; 						ZuBearbetedeZeie:=A_Index
; 20160330110126 ; 						ZuBearbetedeZeieInh:=ThisFavoritEintrag
; 20160330110127 ; 						dummy:=FuehrendeSterneEntfernen(ThisFavoritEintrag)
; 20160330110129 ; 						if(AnzahlEntfernterSterne=1)
; 20160330110130 ; 						{
; 20160330110131 ; 							ZuBearbetedeZeieInh%A_Index%:=
; 20160330110132 ; 						}
; 20160330110133 ; 						else
; 20160330110134 ; 						{
; 20160330110135 ; 							ZuBearbetedeZeieInh%A_Index%:=ZuBearbetedeZeieInh
; 20160330110136 ; 							If (A_ThisLabel="PlusStern") 
; 20160330110137 ; 								BearbeitedeZeieInh%A_Index%:="`r`n*"	ZuBearbetedeZeieInh%A_Index%
; 20160330110138 ; 							If (A_ThisLabel="MinusStern")
; 20160330110139 ; 							{
; 20160330110140 ; 								StringTrimLeft,BearbeitedeZeieInh%A_Index%,BearbeitedeZeieInh%A_Index%,1
; 20160330110141 ; 								BearbeitedeZeieInh%A_Index%:="`r`n"BearbeitedeZeieInh%A_Index%
; 20160330110142 ; 							}
; 20160330110143 ; 						}
; 20160330110150 ; 					}
; 20160330110154 ; 					else
; 20160330110156 ; 						continue
; 20160330110158 ; 				}
; 20160330110200 ; 				MsgBox % Halt ThisFavoritZeilenAmzahl=%ThisFavoritZeilenAmzahl%
; 20160330110202 ; 
; 20160330110203 ; 				if (ThisFavoritZeilenAmzahl=2)
; 20160330110203 ; 				dummy:=FuehrendeSterneEntfernen(ZuBearbetedeZeieInh2)
; 20160330110204 ; 				; if(AnzahlEntfernterSterne=1)
; 20160330110205 ; 				{
; 20160330110209 ; 					FileDelete,% FuehrendeSterneEntfernen(LoopFileDirVonDir "\!Fav\" A_LoopFileName)
; 20160330110212 ; 					if ErrorLevel
; 20160330110214 ; 						MsgBox % "die Datei " FuehrendeSterneEntfernen(LoopFileDirVonDir "\!Fav\" A_LoopFileName) "konnte nicht geloescht werden"
; 20160330110216 ; 					else
; 20160330110224 ; 					{
; 20160330110219 ; 						FaforitEntfernt:=true
; 20160330110227 ; 					}
; 20160330110230 ; 				}
				; else ;
				; if (ThisFavoritZeilenAmzahl>2) ;
				

; 20160330110249 ; 				{
; 20160330110252 ; 					; If (A_ThisLabel="PlusStern") 
; 20160330110256 ; 					{
; 20160330110259 ; 						ThisFavoritEintrag:=
; 20160330110300 ; 						FileGetTime,LastChangedTije,%  FuehrendeSterneEntfernen(LoopFileDirVonDir "\!Fav\" A_LoopFileName)
						
; 20160330110304 ; 						loop, % ThisFavoritZeilenAmzahl
; 20160330110306 ; 						{
; 20160330110308 ; 							if (A_Index=1)
; 20160330110309 ; 								continue
; 20160330110310 ; 							ThisFavoritEintrag:=ThisFavoritEintrag BearbetedeZeieInh%A_Index%
; 20160330110312 ; 							MsgBox Drinn ThisFavoritEintrag=%ThisFavoritEintrag%
; 20160330110313 ; 						}
					
; 20160330110333 ; 						FileAppend,%ThisFavoritEintrag%,%  FuehrendeSterneEntfernen(LoopFileDirVonDir "\!Fav\" A_LoopFileName)
; 20160330110336 ; 					}
; 20160330110338 ; 				}
; 20160330110340 ; 			}
; 20160330110341 ; 		}
; 20160330110341 ; 		else
; 20160330110343 ; 								; if (false or true) ; (InStr(NewFavoritInhalt,"*"))
; 20160330110344 ; 		{
; 20160330110346 ; 			FileAppend, %NewFavoritInhalt%,% FuehrendeSterneEntfernen(LoopFileDirVonDir "\!Fav\" A_LoopFileName)
; 20160330110347 ; 			if not ErrorLevel
; 20160330110348 ; 			{
; 20160330110349 ; 				FavoritAngelegt:=true
; 20160330110350 ; 				break
; 20160330110350 ; 			}
; 20160330110351 ; 		}
; 20160330110352 ; 		; MsgBox % A_LineNumber A_Tab NewFavoritInhalt "`," FuehrendeSterneEntfernen(LoopFileDirVonDir "\!Fav\" A_LoopFileName)
; 20160330110353 ; 	}
; 20160330110402 ; 	Edit3:=1
; 20160330110403 ; 	GuiControl,, %HwndEdit3%, %Edit3%
; 20160330110404 ; 	gosub HwndButton1
; 20160330110405 ; 	SternSetzen:=false
; 20160330110406 ; 	Sternweg:=false
; 20160330110407 ; }
; 20160330110407 ; else
; 20160330110408 ; 	MsgBox, 262192, noch nicht moeglich, momentan koennen nur existierende Ordner favorisiert werden!
; 20160330110409 ; return
; 20160330110410 ; */

FavoritenOrdnerOeffnen:
FavoritenOrdner:=FuehrendeSterneEntfernen(SkriptDataPath "\!Fav")
; MsgBox % FavoritenOrdner ;
IfExist, % FavoritenOrdner
{
	run, explorer.exe /select`,"%FavoritenOrdner%"
	if ZackZackOrdnerLogErstellen
		 ThreadUeberwachungLog(A_LineNumber-1,A_ThisHotkey,A_ThisLabel,A_ThisFunc,A_ThisMenu,A_ThisMenuItem,A_ThisMenuItemPos)
}
return

FavoritSpeichern:
Tooltip, Bitte nichts ins ZackZack Fenster eingeben,A_GuiX,A_GuiY
Gui,Submit,NoHide
Edit2Merker:=Edit2
Edit6Merker:=Edit6
Edit7Merker:=Edit7
SuFiMerker:=SuFi
Edit2=
GuiControl,, %HwndEdit2%, %Edit2%
Edit6:=9999999
GuiControl,, %HwndEdit6%, %Edit6%
Edit7=*
GuiControl,, %HwndEdit7%, %Edit7%
SuFi:=true
GuiControl,, SuFi, %SuFi%
gosub HwndButton1
FileDelete,%SkriptDataPath%\Favoriten.txt
FileAppend,%Edit5%,%SkriptDataPath%\Favoriten.txt
if ZackZackOrdnerLogErstellen
	ThreadUeberwachungLog(A_LineNumber-1,A_ThisHotkey,A_ThisLabel,A_ThisFunc,A_ThisMenu,A_ThisMenuItem,A_ThisMenuItemPos)
Edit2:=Edit2Merker
GuiControl,, %HwndEdit2%, %Edit2%
Edit6:=Edit6Merker
GuiControl,, %HwndEdit6%, %Edit6%
Edit7:=Edit7Merker
GuiControl,, %HwndEdit7%, %Edit7%
SuFi:=SuFiMerker
GuiControl,, %HwndCheckE0%, %SuFiMerker%
sleep 500
gosub HwndButton1
Tooltip,
return
FavoritOeffnen:
return

ContainerUebersichtZeigen:	; Zeigt KontainerUebersicht an
AlleSkriptDataPath:=
	Loop,Files,%WurzelContainer%\*, D
	{
		; MsgBox %  A_LoopFileLongPath ;
		AlleSkriptDataPath:=AlleSkriptDataPath "`n" A_LoopFileLongPath
		Edit5:=AlleSkriptDataPath
		StringTrimLeft,Edit5,Edit5,1
		GuiControl,, %HwndEdit5%, %Edit5%
	}
	If (AlleSkriptDataPath="")
	{
		gosub KontainerAnzeigen
		sleep 2000
; 20160331000809 ; 		Thread,Priority,9999
		MsgBox, 262180, Kein Kontainer, Kein Kontainer Gefunden!`nSchlage vor Kontainer `n		Haupt`nanzulegen.`n`n`nBitte nach den Ersteinrichtungen (wenn 10 Sekunden nichts passiert) das Programm neu starten! 
		IfMsgBox, Yes
		{
			gosub ContainerSkripteUndProgrammeBereitstellen
			sleep 300
			gosub SelfActivate
			SkriptDataPath=%WurzelContainer%\Haupt
			FileCreateDir %SkriptDataPath%
			sleep 300
			gosub KontainerAnzeigen
		}
		
; 20160331000520 ; MsgBox, 262180, Kein Start-Pfad, Kein Start-Pfad Gefunden!`nSchlage vor Start-Pfad anzulegen
		MsgBox, 262179, Kein Start-Pfad, Kein Start-Pfad Gefunden!`nSchlage vor Start-Pfad anzulegen.`n`nAlle Laufwerke	Ja	%DriveNamesKommaList%`n		Nein	fuer manuell gewaehlten Pfad`n		Abbruch	Start-Pfad via Menue spaeter einlesen
		IfMsgBox, Yes
		{
			gosub WurzelVonDateiHinzuFuegen
			gosub KontainerAnzeigen
			sleep 2000
			gosub F5
		}
		IfMsgBox, No
		{
			gosub WurzelHinzuFuegen
			SkriptDataPath=%WurzelContainer%\Haupt
			gosub KontainerAnzeigen
			sleep 2000
			gosub F5
		}
	}
	else If (AlleSkriptDataPath<>"")
	{
	}
	; SkriptDataPath=%WurzelContainer%\Haupt ;
	; FileCreateDir %SkriptDataPath% ;
; 20160329155939 ; 	Thread,Priority,-1
	return

Edit5UpDown:
Gui,Submit,NoHide
; TrayTip,Edit5UpDown,%Edit5UpDown% ;
; sleep 3000 ;
ControlGetFocus,ThisFocussedControl,A
; TrayTip,ThisFocussedControl,%ThisFocussedControl% ;
if (ThisFocussedControl="Edit5")
{
	; SoundBeep ;
	return
}
else
{
	Edit3:=Edit5UpDown
	; If(Edit5UpDown>LastEdit5UpDown) ;
	; 	++Edit3 ;
	; else ;
	; 	--Edit3 ;
	; LastEdit5UpDown:=Edit5UpDown ;
	GuiControl,, %HwndEdit3%, %Edit3%
}
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
	; ++Edit5UpDown ;
	; GuiControl,, Edit5UpDown, %Edit5UpDown% ;
	Gui,Submit,NoHide
	if(Edit5UpDown>1)
		--Edit5UpDown
	; TrayTip,Edit5UpDown,%Edit5UpDown% ;
	; sleep 3000 ;
	GuiControl,, %HwndEdit5UpDown%, %Edit5UpDown%
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
	; ++Edit5UpDown ;
	; GuiControl,, Edit5UpDown, %Edit5UpDown% ;
	Gui,Submit,NoHide
	; if(Edit5UpDown>1) ;
		++Edit5UpDown
	; TrayTip,Edit5UpDown,%Edit5UpDown% ;
	; sleep 3000 ;
	GuiControl,, %HwndEdit5UpDown%, %Edit5UpDown%
	gosub Edit5UpDown
}
return
/*	
#IfWinActive,ZackZackOrdner
Up::
ControlGetFocus,ThisFocussedControl,A
if (ThisFocussedControl="Edit5")
{
 	; ControlSend,Edit5,{Up},A ;
	FocusEdit5:=true
}
else
	FocusEdit5:=false
if(Edit3>2)
{
	--Edit3
	GuiControl,, %HwndEdit3%, %Edit3%
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
GuiControl,, %HwndEdit3%, %Edit3%
if FocusEdit5
{
thread,Priority,-20
Critical,Off
; SoundBeep,6000,50 ;
sleep,-1
sleep,-1
sleep,-1
sleep,-1
sleep,-1
sleep,-1
; SoundBeep,6000,50 ;
ControlFocus,Edit5,A
}
return
*/
F1::	; gib die Hilfe aus.
gosub Hilfe
return
F2::	; springe in Edit2 Suche und markiere alles zum ueberschreiben. P.S. anhaengen von \*, an den Suchstring, zeigt bei existierendem Such-Ergebnis, die Unterordner an.
Edit3:=1
GuiControl,, %HwndEdit3%, %Edit3%
ControlFocus,Edit2,A
ControlSend,Edit2,^a,A

Edit31F2:	; Edit3 --> 1 gefolgt von springe in Edit4 Befehlsentgegennahme und markiere alles zum ueberschreiben. 
return
Edit3:=1
GuiControl,, %HwndEdit3%, %Edit3%
#F2::	; springe in Edit4 Befehlsentgegennahme und markiere alles zum ueberschreiben. 
ControlFocus,Edit4,A
ControlSend,Edit4,^a,A
return
#F3::	; springe in Edit7 Filter und markiere alles zum ueberschreiben.
Edit3:=1
GuiControl,, %HwndEdit3%, %Edit3%
ControlFocus,Edit7,A
ControlSend,Edit7,^a,A
return
F3::	; springe in Edit3 Nr. Wahl und markiere alles zum ueberschreiben.
ControlFocus,Edit3,A
ControlSend,Edit3,^a,A
return


F5::	; wie betaetigen von Button1 -> zum aktualisieren einiger Edit-Felder. funktionierte virtuell geklickt nicht immer 100-Prozentig. 
Gui,Submit,NoHide
ThisActiveHwnd:=WinExist("a")
iF(WinExist("a")<>GuiWinHwnd)
{
	gosub SelfActivate
	gosub GuiWinWaitActive
}
ControlFocus,%HwndButton1%
ControlFocus,%HwndButton1%,ahk_id %GuiWinHwnd%
ControlClick,%HwndButton1%
ControlClick,%HwndButton1%,ahk_id %GuiWinHwnd%
gosub HwndButton1
Gui,Submit,NoHide
gosub Button1
gosub Edit2
 Edit4:="b1."								; Notloesung geht sicherlich noch ubersichtlicher
 GuiControl,, %HwndEdit4%, %Edit4%			; Notloesung geht sicherlich noch ubersichtlicher
WinActivate,ahk_id %ThisActiveHwnd%
WinWaitActive,ahk_id %ThisActiveHwnd%,,1
return

F6::	; wie betaetigen von Button2 -> zum einfuegen des WunschOrdners ins Speichern unter bzw Oeffnen-Feldes des Fremdprogramms
gosub HwndButton2
return
; F7:: ;
; gosub HwndButton3 ;
; return ;
F8::	; wie betaetigen von Button4 Explorer
gosub HwndButton4
return
F9::	; wie betaetigen von Button5 Copy-Move
gosub HwndButton5
return

; 20160329173846 ; m11:	; ruft Menu-Spalte 1 Eintrag 1 des GuiMenues auf. Hier Menue | Datei | Autoload bearbeiten. 	Dito fuer die Folgenden m##.
; 20160329173857 ; gosub AutoLoadBearbeiten	
; 20160329173859 ; return		; 		Menu, Dateimenü, 		Add, &Autoload bearbeiten		, AutoLoadBearbeiten  
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
return			; 	Menu, Edit8Menue, 		Add, &Explorer eingebunden		, Edit8ExplorerEingebunden
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

; 20160329152333 ; ; AutoPop
; 20160329152335 ; m71:
; 20160329152336 ; gosub AutoPopLogAnzeigen
; 20160329152337 ; return		; 		Menu, AutoPopMenue, 	Add, &AutoPop.log anzeigen				, AutoPopLogAnzeigen
; 20160329152337 ; m72:
; 20160329152338 ; gosub WirksameAutoPopAusnahmenAnzeigen
; 20160329152339 ; return		; 		Menu, AutoPopMenue, 	Add, &wirksame AutoPop Ausnahmen anzeigen				, WirksameAutoPopAusnahmenAnzeigen
; 20160329152340 ; m73:
; 20160329152340 ; gosub AutoPopAusnahmenBearbeiten
; 20160329152341 ; return		; 		Menu, AutoPopMenue, 	Add, &AutoPop Ausnahmen bearbeiten				, AutoPopAusnahmenBearbeiten
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

SplitPath,ZackZackOrdnerPath,,ZackZackOrdnerDirPath

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
; run %A_temp% ;
; WinWaitActive,%A_temp%,,2 ;
;  sleep 2000 ;
; MsgBox % A_LineNumber ;
; Pause ;
IfWinNotExist,ButtonGUI
{
	WinClose,%A_temp%
	; MsgBox % A_LineNumber ;
	; run, %A_AppDataCommon%\TastWatch.ahk,,,TastWatchPid ;
	FileDelete, %A_AppDataCommon%\Zack\TastWatch.ahk
	FileAppend, %TastWatch%, %A_AppDataCommon%\Zack\TastWatch.ahk
	if ZackZackOrdnerLogErstellen
		ThreadUeberwachungLog(A_LineNumber-1,A_ThisHotkey,A_ThisLabel,A_ThisFunc,A_ThisMenu,A_ThisMenuItem,A_ThisMenuItemPos)
	FileCopy,%A_ScriptDir%\GeKoOb.ico, %A_AppDataCommon%\Zack\GeKoOb.ico
	if ZackZackOrdnerLogErstellen
		ThreadUeberwachungLog(A_LineNumber-1,A_ThisHotkey,A_ThisLabel,A_ThisFunc,A_ThisMenu,A_ThisMenuItem,A_ThisMenuItemPos)
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
	; run %A_AppDataCommon% ;
	WinClose,%A_temp%
	return
}
WinClose,%A_temp%
return
; MsgBox % A_LineNumber ;
BereiteVorDir2Paths:	; erstellt Dir2Path.ahk und kopiert die Dir2Path-Dateien an die benoetigten Orte. Der Dir2Path-Quelltext ist vollstaendig in der Variablen Dir2Paths dieses Skriptes gespeichert. Sodass die Dir2Path.ahk bei Bedarf erzeugt werden kann.


Dir2Paths=
(
#NoEnv
; MsgBox `% A_FileEncoding
FileEncoding,UTF-16
IfExist GeKoOb.ico
	Menu,Tray,icon,GeKoOb.ico
FilePattern0 =`%0`%
if(FilePattern0<2)
; if false			; ################################ wieder weg erledigt pruefen
{
	MsgBoxText=
`(
`%A_ScriptName`% benoetigt 2 Uebergabe-Parameter:
	
 1. Pfad des zu bildenden Caches  (z.B. C:\ProgramData\Zack)
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
	FileRead,SilentStartPfade,`%A_Temp`%\Dir2PathSilentStartPfade.txt	; auslesen der Pfade, bei dene nicht aausgegeben wird 

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

; SkriptDataPath=`%A_AppDataCommon`%\Zack
SkriptDataPath:=FilePattern1
IfNotExist `%SkriptDataPath`%
	FileCreateDir, `%SkriptDataPath`%
; run, explorer.exe /select``,"`%SkriptDataPath`%" ; ###################################################
; run `%SkriptDataPath`%
WurzelIndexPath=`%SkriptDataPath`%\WurzelIndex.txt
; msgbox >`%SkriptDataPath`%<	
WurzelIndex:=1
IfExist `%WurzelIndexPath`%
{
	FileRead,WurzelIndex,`%WurzelIndexPath`%
	FileDelete,`%WurzelIndexPath`%
}
{
	if FehlerSuche
		MsgBox `%WurzelIndexPath`% wuerde nicht existieren
	WurzelIndexFile:=WurzelIndex + FilePattern0 -1		;  berechnet den Index
	FileAppend,`%WurzelIndexFile`%,`%WurzelIndexPath`%	; 	schreibt den Index in WurzelIndex.txt
	
}
; MsgBox `% WurzelIndex
BackSlash=\
Stern=*
FileappendFehlerGes:=0
Loop, `% FilePattern0 
{
	if(A_Index="1")
		continue
	Index:=A_Index
	StringReplace,ThisFilePatternOhnestern,FilePattern`%Index`%,*,,All
	if (SubStr(ThisFilePatternOhnestern,0,1)="\")
		StringTrimRight,ThisFilePatternPath,ThisFilePatternOhnestern,1
	Silent:=false
	If (SilentStartPfade<>"")
	{
		if(InStr(SilentStartPfade,ThisFilePatternPath))
			Silent:=true
	}
	ThisFilePattern:=FilePattern`%Index`%
	FileAppend,`%ThisFilePattern`%,`%SkriptDataPath`%\Wurzel`%WurzelIndex`%.txt
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
	FileappendFehler:=0
	ThisFilePattern:=FilePattern`%Index`%
	Rekursiv:=true
	if(SubStr(ThisFilePattern,-1)="-R")
	{
		Rekursiv:=false
		; StringTrimRight,ThisFilePattern,ThisFilePattern,2
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
			FileAppend,``r``n`%ThisFilePatternPath`%, `%CashPathWNr`%\`%ThisFilePatternDirName`%.txt		; 
			; FileAppend,``r``n*`%ThisFilePatternPath`%, `%CashPathWNr`%\`%ThisFilePatternDirName`%.txt		; eher doch kein Grund-Stern fuer Drives
			ThisFolderNames:=ThisFolderNames "``r``n" ThisFilePatternDirName
		}
		else
		{
			FileAppend,``r``n`%ThisFilePatternPath`%, `%CashPathWNr`%\`%ThisFilePatternSpeichername`%.txt
			; FileAppend,``r``n*`%ThisFilePatternPath`%, `%CashPathWNr`%\`%ThisFilePatternSpeichername`%.txt	; eher doch kein Grund-Stern fuer Drives
			ThisFolderNames:=ThisFolderNames "``r``n" ThisFilePatternSpeichername
		}
	}
	; MsgBox Loop,Files,`%ThisFilePattern`%, D R
	If Rekursiv
	{	
		Loop,Files,`%ThisFilePattern`%, D R
		{
			; Path	A_LoopFileLongPath
			; Dir	A_LoopFileName
			;  MsgBox FileAppend,``r``n`%A_LoopFileLongPath`%, `%CashPathWNr`%\`%A_LoopFileName`%.txt
			FileAppend,``r``n`%A_LoopFileLongPath`%, `%CashPathWNr`%\`%A_LoopFileName`%.txt
			if ErrorLevel
				++FileappendFehlerGes, ++FileappendFehler
			i:=A_Index
			ThisFolderNames:=ThisFolderNames "``r``n" A_LoopFileName
		}
	}
	else
	{
		Loop,Files,`%ThisFilePattern`%, D 
		{
			; Path	A_LoopFileLongPath
			; Dir	A_LoopFileName
			; MsgBox FileAppend,``r``n`%A_LoopFileLongPath`%, `%CashPathWNr`%\`%A_LoopFileName`%.txt
			FileAppend,``r``n`%A_LoopFileLongPath`%, `%CashPathWNr`%\`%A_LoopFileName`%.txt
			if ErrorLevel
				++FileappendFehlerGes, ++FileappendFehler
			i:=A_Index
			ThisFolderNames:=ThisFolderNames "``r``n" A_LoopFileName
		}
	}
		
		if(i="0")
			EinleseZustand=nicht (eventuell Syntax-Fehler im FilePattern dieser Wurzel)
		else If (FileappendFehler="0")
			EinleseZustand=erfolgreich
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
}
StringTrimLeft,ThisFolderNames,ThisFolderNames,2
sort,ThisFolderNames,U
WurzelindexMinus1:=WurzelIndex -1
FileAppend,`%ThisFolderNames`%,`%SkriptDataPath`%\FolderNames`%WurzelindexMinus1`%.txt
if(WurzelIndexFile<>WurzelIndex)
	MsgBox, 262160,`%A_ScriptName`%	`%A_LineNumber`% Fehler, unbekannter Fehler
if not Silent
	{
	run `%CashPath`%	
	}
ExitApp
)
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
FileAppend, %Dir2Paths%, %A_AppDataCommon%\Zack\Dir2Paths.ahk
if ZackZackOrdnerLogErstellen
	ThreadUeberwachungLog(A_LineNumber-1,A_ThisHotkey,A_ThisLabel,A_ThisFunc,A_ThisMenu,A_ThisMenuItem,A_ThisMenuItemPos)
; FileCopy,%A_ScriptDir%\GeKoRe.ico, %A_AppDataCommon%\GeKoRe.ico ;
; run, %A_AppDataCommon%\Dir2Paths.ahk,,,Dir2PathsPid ;

; run %A_AppDataCommon% ;
return

WurzelAktualisieren:	; geplant	Einzelnen Start-Pfad aktualisieren.
MsgBox geplant	Einzelnen Start-Pfad aktualisieren.
return
WurzelnAktualisieren:	; Die StartPfade des Kontainers %SkriptDataPath% werden neu eingelesen.
MsgBox, 262179, Einlesevorgang, Soll so schnell wie moeglich (gleichzeitig) eingelesen werden?`n				Ja`nEs fehlen dann wahrend des lesens Pfade`n`n`nBei der langsameren (nacheinander-) Methode sind temporaer Pfade in den Fundstellen doppelt`, aber es darf nicht mit ZackZackOrdner gearbeitet werden`n`nNur falls das gleichzeitige Einlesen auf Ihrem System zu Fehlern fuehrt, sollte Sie auch mal zweiteres mit `n				Nein `nprobieren
IfMsgBox Yes
	ThisWinWaitMax:=3.6
IfMsgBox,no
	ThisWinWaitMax:=3600
IfMsgBox,Cancel
	return
IfMsgBox,Abort
	return
Rueckfragen:=false
IfExist %SkriptDataPath%\WurzelIndex.txt
	FileRead,WurzelNrMax,%SkriptDataPath%\WurzelIndex.txt
else
{
	MsgBox, 262160, Abbruch, Die Dattei `n`n%SkriptDataPath%\WurzelIndex.txt `n`nfehlt.  Bitte manuell die Container mit den Start-Pfaden richtigstellen bzw loeschen.
	return
}
if WurzelNrMax is not Integer
{
	MsgBox, 262160, Abbruch, Die Dattei `n`n%SkriptDataPath%\WurzelIndex.txt `n`nentaelt nicht nur eine Ganzahl.  Bitte manuell die Container mit den Start-Pfaden richtigstellen bzw loeschen.
	return
}
; MsgBox  %SkriptDataPath%\Wurzel*.txt ;
; Loop,Files,%SkriptDataPath%\Wurzel*.txt,F ;
Loop,% WurzelNrMax-1
{

	ThisWurzelTxtPfad:=SkriptDataPath "\Wurzel" A_Index ".txt"
	IfExist  %ThisWurzelTxtPfad%
		FileRead,ThisStartPfad,%ThisWurzelTxtPfad%
	else
		continue
	NeueWurzel:=ThisStartPfad
	gosub NeueWurzelHinzufuegenBeiVorhandenemWurzelName
	WinWait,ahk_exe Dir2Paths.exe,,%ThisWinWaitMax%
	ZuLoeschendeWurzelDotTxt:=ThisWurzelTxtPfad
	if Fehlersuche
		MsgBox loesche im naechsten Schritt: %ZuLoeschendeWurzelDotTxt%
	gosub WurzelLoeschenBeiVorhandenerWurzelTxt
}
; MsgBox geplant ;
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
FileRead,ZuLoeschendeWurzelPath,%ZuLoeschendeWurzelDotTxt%
BackSlash=\
Stern=*
SplitPath,ZuLoeschendeWurzelDotTxt,,,,ZuLoeschendeWurzelNameNoExt
StringTrimLeft,ZuLoeschendeWurzelNr,ZuLoeschendeWurzelNameNoExt,6
; StringTrimLeft,ZuLoeschendeWurzelNr,ZuLoeschendeWurzelNr,4 ;
ThisFilePattern := ZuLoeschendeWurzelPath
	StringReplace,ThisFilePatternSpeicherName,ThisFilePattern,%Stern%,°,All
	StringReplace,ThisFilePatternSpeicherName,ThisFilePatternSpeicherName,:,˸
	StringReplace,ThisFilePatternSpeicherName,ThisFilePatternSpeicherName,%BackSlash%,►,All
	ThisFilePatternSpeicherName=%ZuLoeschendeWurzelNr%_%ThisFilePatternSpeicherName%
	; CashPathWNr=`%SkriptDataPath`%\DP`%WurzelIndex`%	 ;
	CashPathWNr=%SkriptDataPath%\%ThisFilePatternSpeicherName%				; c:\temp\Zack\WuCont\Haupt\c˸►\AllG\Gegenst
if Rueckfragen
{
	MsgBox, 262436, Loeschbestaetigung, soll der Ordner`n`n	%CashPathWNr%`n`nwirklich geloescht werden?
IfMsgBox,No
	return
}
	FileRemoveDir, %CashPathWNr% , 1
	if ErrorLevel
	{
		MsgBox, konnt nicht alles in `n`n	%CashPathWNr%`n` Loeschen,`neventuell ist eine Dattei geoeffnet?!`nbitte manuell loeschen oder alles schliessen und dnochmals versuchen.
	}
	else
	{
		StringReplace,FolderNames,ZuLoeschendeWurzelDotTxt,Wurzel,FolderNames,UseErrorLevel
		if (ErrorLevel>1)
			MsgBox, konnte %FolderNames% nicht Loeschen, bitte manuell loeschen.
		else
		{
			FileDelete,%FolderNames%
			if ErrorLevel
			{
				MsgBox, konnte %FolderNames% nicht Loeschen, bitte manuell loeschen.
				FolderNamesGeloescht:=false
			}
			else
				FolderNamesGeloescht:=true
		}
		FileDelete,%ZuLoeschendeWurzelDotTxt%
		if ErrorLevel 
		{
			if FolderNamesGeloescht
				MsgBox, konnte %ZuLoeschendeWurzelDotTxt% nicht Loeschen, bitte manuell loeschen
		}
		else if FolderNamesGeloescht
		{
			if Rueckfragen
			MsgBox der Startpfad wurde erfolgreich geloescht
		}
	}
return			

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
		; WB.Navigate(WBvor "C:\Users\Gerd\Videos") ;
		if (InStr(Edit8Sternlos,"http:") or InStr(Edit8Sternlos,"https:") or InStr(Edit8Sternlos,"ftp:") or InStr(Edit8Sternlos,"File:"))  
			WB.Navigate(Edit8Sternlos) ; dieser Zweig wird warscheinlixch nie benutzt
		else
			WB.Navigate(WBvor Edit8Sternlos "\") 
		
		GuiControl, Move, %HwndIe1%, x136	w%Edit5Breite20%	h%Edit5Hoehe%				; x141 	y%Edit5Y0% w350	h240 HWNDHwndIe1 vWB
		GuiControl, Move, Edit5, x600 hide
		return
		; GuiControl,Hide,Edit5 ;
	}
	else if (InStr(Edit8Sternlos,"http:") or InStr(Edit8Sternlos,"https:") or InStr(Edit8Sternlos,"ftp:") or InStr(Edit8Sternlos,"File:"))
	{
		WB.Navigate(Edit8Sternlos) 
		GuiControl, Move, %HwndIe1%, x136	w%Edit5Breite20%	h%Edit5Hoehe%				; x141 	y%Edit5Y0% w350	h240 HWNDHwndIe1 vWB
		GuiControl, Move, Edit5, x600 hide
		return
	}
}

{
	; MsgBox % "<" FuehrendeSterneEntfernen(Edit8) "<" ;
	GuiControl, Move, Edit5, x136 	w%Edit5Breite20%	h%Edit5Hoehe%				; x141 	y%Edit5Y0% w350	h240 HWNDHwndIe1 vWB
	
	GuiControl, Move, %HwndIe1%, x600 hide
	; GuiControl,Hide,%HwndIe1% ;
}

return
F7::	; Toggle Explorer-Fensteransicht <---> Pfadlisten-Ansicht
RLShift:	; Toggle Explorer-Fensteransicht <---> Pfadlisten-Ansicht
LShift & RShift::	; Toggle Explorer-Fensteransicht <---> Pfadlisten-Ansicht 
WinActivate,ahk_id %HwndGuiWin%
ControlFocus,IeAnz,ahk_id %HwndGuiWin%
ControlClick,IeAnz,ahk_id %HwndGuiWin%
; SoundBeep, 8000,100%IeAnz% ;
if IeAnz
{
	WinSetTitle,ahk_id %HwndGuiWin%,,ZackZackDateien
	IeAnz:=false
	GuiControl,, %HwndCheckK5%, 0 ;  %IeAnz%
}
else
{
	WinSetTitle,ahk_id %HwndGuiWin%,,ZackZackOrdner
	
	IeAnz:=true
	GuiControl,, %HwndCheckK5%, 1 ;  %IeAnz%
}
 Edit4Merker:=Edit4
 Edit4:="b1."
 GuiControl,, %HwndEdit4%, %Edit4%
; if (Edit4Merker="") ;
; { ;
;	sleep 500 ;
;	Edit4:="e4." ;
;	GuiControl,, %HwndEdit4%, %Edit4% ;
; } ;
; Edit4:=Edit4Merker ;
; GuiControl,, %HwndEdit4%, %Edit4% ;

; gosub GuiSize ;
return
IeAnz:	; Toggle IeAnz und ist reserviert fuer Wintitelaenderung ZackZackOrdner <---> ZackZackDateien
Gui,Submit,NoHide
if IeAnz
{
	; WinSetTitle,ahk_id %HwndGuiWin%,,ZackZackDateien ;
	IeAnz:=true
	GuiControl,, %HwndCheckK5%, 1 ;  %IeAnz%
}
else
{
	WinSetTitle,ahk_id %HwndGuiWin%,,ZackZackOrdner
	IeAnz:=false
	GuiControl,, %HwndCheckK5%, 0 ;  %IeAnz%
}
 EEdit4Merker:=Edit4
 Edit4:="b1."
 GuiControl,, %HwndEdit4%, %Edit4%

; gosub HwndButton1 ;
;  gosub GuiSize ;
return



WB:	; wird vom Gui bei aenderung vom IE-Control aufgerufen. Ist momnetan ohne Funktion.
; SoundBeep,250,200 ;
return

Explorer:
return
SucheMenuHandler:	; wird von GuiContextMenu aufgerufen bei Rechtsklicks auf das Gui-Control Suche
If (A_ThisMenuItem="vom VaterDir"  and A_ThisMenu = "SucheMenu")
{
	if (ThisGuiControl="Suche")				; Abfrage waere hier nicht mehr notwendig.
		gosub VomVaterDir
		; MsgBox geplant, wie ist die Suche zu befuellen, dass die Anzeige hier nahe der Anzeige des Vaters kommt. ;
}
else If (A_ThisMenuItem="vom VaterWin"  and A_ThisMenu = "SucheMenu")
{
	if (ThisGuiControl="Suche")				; hier ist noch der Falsche Eintrag drin
		gosub VomVaterWin
		; MsgBox geplant, wie ist die Suche zu befuellen, dass die Anzeige hier nahe der Anzeige des Vaters kommt. ;
}
else If (A_ThisMenuItem="vom VaterWin"  and A_ThisMenu = "SuFiMenu")
{
	if (ThisGuiControl="SuFi")				
		gosub VomVaterWin
		; MsgBox geplant, wie ist die Suche zu befuellen, dass die Anzeige hier nahe der Anzeige des Vaters kommt. ;
}
else If (A_ThisMenuItem="Control Infos"  and A_ThisMenu = "SucheMenu")
{
	MsgBox Sie haben auf das Control >%ThisGuiControl%< rechts-geklickt.`nMenueeintrag >%A_ThisMenuItem%<`nMenü >%A_ThisMenu%<
	return
}
return
SuFiMenuHandler:	; wird von GuiContextMenu aufgerufen bei Rechtsklicks auf das Gui-Control SuFi
If (A_ThisMenuItem="vom VaterDir"  and A_ThisMenu = "SucheMenu")
{
	if (ThisGuiControl="Suche")				; Abfrage waere hier nicht mehr notwendig.
		gosub VomVaterDir
		; MsgBox geplant, wie ist die Suche zu befuellen, dass die Anzeige hier nahe der Anzeige des Vaters kommt. ;
}
else If (A_ThisMenuItem="vom VaterWin"  and A_ThisMenu = "SucheMenu")
{
	if (ThisGuiControl="Suche")				; hier ist noch dr Falsche Eintrag drin
		gosub VomVaterWin
		; MsgBox geplant, wie ist die Suche zu befuellen, dass die Anzeige hier nahe der Anzeige des Vaters kommt. ;
}
else If (A_ThisMenuItem="vom VaterDir"  and A_ThisMenu = "SuFiMenu")
{
	if (ThisGuiControl="SuFi")				
		gosub VomVaterDir
		; MsgBox geplant, wie ist die Suche zu befuellen, dass die Anzeige hier nahe der Anzeige des Vaters kommt. ;
}
else If (A_ThisMenuItem="vom GrossVaterDir"  and A_ThisMenu = "SuFiMenu")
{
	if (ThisGuiControl="SuFi")				
		gosub VomVaterVaterDir
		; MsgBox geplant, wie ist die Suche zu befuellen, dass die Anzeige hier nahe der Anzeige des Vaters kommt. ;
}
else If (A_ThisMenuItem="Control Infos"  and A_ThisMenu = "SucheMenu")
{
	MsgBox Sie haben auf das Control >%ThisGuiControl%< rechts-geklickt.`nMenueeintrag >%A_ThisMenuItem%<`nMenü >%A_ThisMenu%<
	return
}
return
IntegerMenuHandler:	; wird von GuiContextMenu aufgerufen bei Rechtsklicks auf ein Gui-Control dessen Bennenung als Integer interpraetiert werdene kann. Fuer die Zeilen-Nummern-Zahlen links vom Edit5.
; GuiContextMenu  UnterOrdner ;
If (A_ThisMenuItem="Explorer"  and A_ThisMenu = "IntegerMenu")
{
	if ThisGuiControl is integer
	{
		Edit3:=ThisGuiControl
		GuiControl,, %HwndEdit3%, %Edit3%
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
		GuiControl,, %HwndEdit3%, %Edit3%
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
		GuiControl,, %HwndEdit3%, %Edit3%
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
		GuiControl,, %HwndEdit3%, %Edit3%
		gosub Edit3
		gosub Edit8ExplorerSelect
		return
	}
}
else If (A_ThisMenuItem="Explorer eingebunden"  and A_ThisMenu = "IntegerMProgress, m2 b zh0, Text hereenu")
{
	if ThisGuiControl is integer
	{
		Edit3:=ThisGuiControl
		GuiControl,, %HwndEdit3%, %Edit3%
		gosub Edit3
		; gosub IeControl ;
		; gosub IeAnz ;
		gosub RLShift
		return
	}
}
else If (A_ThisMenuItem="umbenennen"  and A_ThisMenu = "IntegerMenu")
{
	if ThisGuiControl is integer
	{
		Edit3:=ThisGuiControl
		GuiControl,, %HwndEdit3%, %Edit3%
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
		GuiControl,, %HwndEdit3%, %Edit3%
		return
	}
	
}
else If (A_ThisMenuItem="+ Stern"  and A_ThisMenu = "Submenu1")
{
	if ThisGuiControl is integer
	{
		Edit3:=ThisGuiControl
		GuiControl,, %HwndEdit3%, %Edit3%
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
		GuiControl,, %HwndEdit3%, %Edit3%
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
		GuiControl,, %ThisEditHwnd%, % Edit%ThisGuiControl%
		; gosub Edit%ThisGuiControl% ;
		return
	}
}
else If (A_ThisMenuItem="Set Clipboard"  and A_ThisMenu = "IntegerMenu")
{
	if ThisGuiControl is integer
	{
		Edit3:=ThisGuiControl
		GuiControl,, %HwndEdit3%, %Edit3%
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
		
		Gui,Submit,NoHide
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

MenuHandler:	; wird von GuiContextMenu aufgerufen bei Rechtsklicks ins Gui.
; GuiContextMenu  UnterOrdner ;
If (A_ThisMenuItem="Explorer"  and A_ThisMenu = "MeinMenu")
{
if ThisGuiControl is integer
	{
		Edit3:=ThisGuiControl
		GuiControl,, Edit3, %Edit3%
		gosub Edit8Explorer
return
	}
}
else If (A_ThisMenuItem="Neuer_Ordner"  and A_ThisMenu = "MeinMenu")
{
if ThisGuiControl is integer
	{
		Edit3:=ThisGuiControl
		GuiControl,, %HwndEdit3%, %Edit3%
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
		GuiControl,, %HwndEdit3%, %Edit3%
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
		GuiControl,, %HwndEdit3%, %Edit3%
		gosub Edit3
		gosub Edit8ExplorerSelect
		return
	}
}
else If (A_ThisMenuItem="Explorer eingebunden"  and A_ThisMenu = "MeinMenu")
{
if ThisGuiControl is integer
	{
		Edit3:=ThisGuiControl
		GuiControl,, Edit3, %Edit3%
		gosub Edit3
		; gosub IeControl ;
		; gosub IeAnz ;
		gosub RLShift
		return
	}
}
else If (A_ThisMenuItem="Nur_Nr"  and A_ThisMenu = "MeinMenu")
{
	if ThisGuiControl is integer
	{
		Edit3:=ThisGuiControl
		GuiControl,, %HwndEdit3%, %Edit3%
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
Edit8Oeffnen:
run, % FuehrendeSterneEntfernen(Edit8)
if ZackZackOrdnerLogErstellen
	ThreadUeberwachungLog(A_LineNumber-1,A_ThisHotkey,A_ThisLabel,A_ThisFunc,A_ThisMenu,A_ThisMenuItem,A_ThisMenuItemPos)
return
Edit8NeuerOrdner:
	Edit8OhneStern := FuehrendeSterneEntfernen(Edit8)
	if (substr(Edit8OhneStern,-3)=".lnk")
	{
		FileGetShortcut, %Edit8OhneStern% ,Edit8OhneStern
	}
	; GuiControl,, %HwndEdit8%, %Edit8% ;
	Gui,Submit,NoHide
	if (Edit10="")
	{
		MsgBox, 262176, Neuer Ordner Name , bitte den neuen Ordnername im Untersten Feld eingeben und Vorgang wiederholen.
		return
	}
	else if (Edit10="Zusatz")
	{
		; MsgBox, 262176, Neuer Ordner Name , bitte den neuen Ordnername im Untersten Feld eingeben und Vorgang wiederholen. ;
		MsgBox, 262436, Neuer Ordner Name , bitte den neuen Ordnername im Untersten Feld eingeben und Vorgang wiederholen.`nOder soll der neue Ordner wirklich Zusatz lauten?
		IfMsgBox,No
			return
	}
	; else ;
	{
		StringSplit,NeuerOrdner,Edit10,|,%A_Space%
		{
			Loop, % NeuerOrdner0
			{
				ThisNeuerOrdner:=NeuerOrdner%A_Index%
				FileCreateDir,%Edit8OhneStern%\%ThisNeuerOrdner%
				if ErrorLevel
				{
					MsgBox, 262176, Fehler, Konnte den Ordner `n`n%Edit8%\%ThisNeuerOrdner%`n`nnicht anlegen.
				}
				else
				{
					TrayTip Ordner anlegen, Ordner `n`n%Edit8%\%ThisNeuerOrdner%`n`nangelegt!
				}
			}
		}
	}
return

BeschaeftigtAnf:	; haken setzen bei beschaeftigt
	beschaeftigt:=1
	GuiControl,,beschaeftigt,1
return

BeschaeftigtEnd:	; haken entfernen bei beschaeftigt
	beschaeftigt:=0
	GuiControl,,beschaeftigt,0
return

Edit8ZeigeVorfahrenUndUnterordner:
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
		gosub BeschaeftigtAnf
		Edit8OhneStern := FuehrendeSterneEntfernen(Edit8)
		gosub ZeigeAnstattVorfahrenUndUnterordnerEdit8
		gosub BeschaeftigtEnd
	}
return

Edit8ZeigeUnterOrdner:	; Zeigt temporaer den Ordner und die Unterordner von Edit8 in Edit5 an. Der Rest von Edit5 entfaellt. Ruft dazu auch ZeigeAnstattUnterordnerEdit8 auf.
	gosub BeschaeftigtAnf
	Edit8OhneStern := FuehrendeSterneEntfernen(Edit8)
	gosub ZeigeAnstattUnterordnerEdit8
	gosub BeschaeftigtEnd
return

Edit8Explorer:	; ubergibt Edit8 an den Explorer
	Edit8OhneStern := FuehrendeSterneEntfernen(Edit8)
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
Edit8ExplorerSelect:	; ubergibt Edit8 an den Explorer mit der Aufforderung Edit8 zu Selektieren bzw. markieren.
	Edit8OhneStern := FuehrendeSterneEntfernen(Edit8)
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

Edit8ExplorerEingebunden:	; ruft RLShift auf
gosub RLShift
return

Edit8Umbenennen:	; benennt den Ordner auf den Edit8 zeigt um in die Auswertung von Edit10
		Edit8OhneStern := FuehrendeSterneEntfernen(Edit8)
		if (substr(Edit8OhneStern,-3)=".lnk")
		{
			FileGetShortcut, %Edit8OhneStern% ,Edit8OhneStern
		}
		IfExist % Edit8OhneStern
		{
			Gui,Submit,NoHide
			If (Edit10="Zusatz" or Edit10="" )
			{
				InputBox,Edit10,Umbenenen,neuer Name,,,,,,,,% Edit8OhneStern
				if ErrorLevel
					return
				GuiControl,, %HwndEdit10%, %Edit10%
			}
			If(Not InStr(Edit10,"\"))
			{
				SplitPath,% Edit8OhneStern,,Edit1Dir
				Edit10:= Edit1Dir "\" Edit10
				GuiControl,, %HwndEdit10%, %Edit10%

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
		; gosub IeControl ;
		; gosub IeAnz ;
		return
return


GuiContextMenu:	; wird vom Gui aufgerufen wenn rechte Maustaaste im Guibereich gedrueckt wurde. Ruft das betreffende Menue auf.
ThisGuiControl:=A_GuiControl
if ThisGuiControl is integer
	Menu, IntegerMenu, Show  ; Drücke WIN+Z, um das Menü anzuzeigen.
else if (ThisGuiControl="Suche")
	Menu, SucheMenu, Show  ; Drücke WIN+Z, um das Menü anzuzeigen.
else if (ThisGuiControl="SuFi")
	Menu, SuFiMenu, Show  ; Drücke WIN+Z, um das Menü anzuzeigen.
else if (ThisGuiControl="Edit5UpDown")
{
	Edit3:=1
	gosub Edit3Festigen
	If Fehlersuche
		TrayTip Edit3, Rueck-gesetzt!
}
else
	gosub ResetAllNocontainer

	; Menu, MeinMenu, Show  ; Drücke WIN+Z, um das Menü anzuzeigen. ;

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
	; Beispielaufruf ; IfExistCallEExeOrAhk(A_AppDataCommon "\Dir2Paths.ahk","c:\temp\CacheTest","E:\*")
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
	GuiControl,,%HwndEdit5%,%Edit5%
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
; 	ToolTip % UnterordnerEdit8 ;
}
return
; 20160329151029 ; #ö::	; Zeigt temporaer den Ordner und die Unterordner von Edit8 in Edit5 an. Der Rest von Edit5 entfaellt.
ZeigeAnstattUnterordnerEdit8:	; Zeigt temporaer den Ordner und die Unterordner von Edit8 in Edit5 an. Der Rest von Edit5 entfaellt. Wird von Edit8ZeigeUnterOrdner aufgerufen
IfExist % FuehrendeSterneEntfernen(Edit8)
{
	gosub UnterordnerEdit8
	Edit5:=UnterordnerEdit8
	sort,Edit5,U
	GuiControl,,%HwndEdit5%,%Edit5%
}
else
	TrayTip,Warnung,% "der Ordner " FuehrendeSterneEntfernen(Edit8) " existiert nicht (mehr)"
return

Edit10:	; aufgerufen vom ZackZsackOrdner-Gui bei Veraenderung von Edit10 (Zusatz)
HwndEdit10:	; aufgerufen vom ZackZsackOrdner-Gui bei Veraenderung von Edit10 (Zusatz)
Gui,Submit,NoHide
return

FolgePosOfHwnd:	; verschiebt das ZackZsackOrdner-Gui, sodass es die Positionen vom Edit4-Control des Fensters Gegenstaende einnimmt. BefehlsName wird noch geandert zu FolgePosOfGegenstaendeEdit4Hwnd
; ControlGetPos,FremdHwndPosX,FremdHwndPosY,FremdHwndPosB,FremdHwndPosH,ahk_id %FremdControlHwnd%,ahk_id %FremdGuiHwnd% ;
; MsgBox % FremdHwndPosX A_Tab FremdHwndPosY A_Tab FremdHwndPosB A_Tab FremdHwndPosH ;
WinGetPos,FremdGuiPosX,FremdGuiPosY,,,ahk_id %FremdGuiHwnd%
ControlGetPos,FremdControlPosX,FremdControlPosY,FremdControlPosB,FremdControlPosH,Edit4,Gegenstaende
; MsgBox % FremdHwndPosX A_Tab FremdHwndPosY A_Tab FremdHwndPosB A_Tab FremdHwndPosH ;
; MsgBox % FremdHwnd ;
FremdPosX:=FremdGuiPosX + FremdControlPosX
FremdPosY:=FremdGuiPosY + FremdControlPosY
; WinMove,ahk_id %GuiWinHwnd%,,%FremdHwndPosX%,%FremdHwndPosY%,%FremdHwndPosB%,%FremdHwndPosH% ;
sleep 100
WinMove,ahk_id %GuiWinHwnd%,,FremdPosX,FremdPosY,FremdControlPosB,FremdControlPosH
return

ShowGuiHwndInEdit4:	; zeigt die eindeutige ZackZsackOrdner-Gui-Hwnd im Feld Edit4 an
Edit4:=GuiWinHwnd
GuiControl,,%HwndEdit4%,%Edit4%
return

MinSetzen:	; variable Min <-- 1
Min:=true
GuiControl,,Min,1

; 20160329134248 ; WiWaFestigen:
; 20160329134251 ; GuiControl,,WiWa,%WiWa%
; 20160329134253 ; return
; 20160329134254 ; EdWaFestigen:
; 20160329134255 ; GuiControl,,EdWa,%EdWa%
; 20160329134256 ; return
; 20160329134202 ; FiCaFestigen:
; 20160329134205 ; GuiControl,,FiCa,%FiCa%
; 20160329134206 ; return
IeAnzFestigen:
GuiControl,,IeAnz,%IeAnz%
return
RekurFestigen:
GuiControl,,Rekur,%Rekur%
return
AktFestigen:
GuiControl,,Akt,%AktAkt%
return
AuAbFestigen:
GuiControl,,AuAb,%AuAb%
return
RegExFestigen:
GuiControl,,RegEx,%RegEx%
return
SuFiFestigen:
GuiControl,,SuFi,%SuFi%
return
ExpSelFestigen:
GuiControl,,ExpSel,%ExpSel%
return
SeEnFestigen:
GuiControl,,SeEn,%SeEn%
return
SrLiFestigen:
GuiControl,,SrLi,%SrLi%
return
BsAnFestigen:
GuiControl,,BsAn,%BsAn%
return
WoAnFestigen:
GuiControl,,WoAn,%WoAn%
return
beschaeftigtFestigen:
GuiControl,,beschaeftigt,%beschaeftigt%
return
OnTopFestigen:	; wird nach der Veraenderung der Variablen OnTop benoetigt, dass diese auch im Gui angezeigt wird (Haken To)
GuiControl,,%HwndCheckG0%,1
; SoundBeep , 4000,500 ;
return
MinFestigen:	; funzt ned		wird nach der Veraenderung der Variablen Min benoetigt, dass diese auch im Gui angezeigt wird (Haken Mi)
GuiControl,,Min,%Min%
return

Edit1Festigen:	; wird nach der Veraenderung der Variablen Edit2 benoetigt, dass diese auch im Gui angezeigt wird (Edit2 ist Suche)
GuiControl,,%HwndEdit1%,%Edit1%
return
Edit2Festigen:	; wird nach der Veraenderung der Variablen Edit2 benoetigt, dass diese auch im Gui angezeigt wird (Edit2 ist Suche)
GuiControl,,%HwndEdit2%,%Edit2%
return
Edit3Festigen:	; wird nach der Veraenderung der Variablen Edit3 benoetigt, dass diese auch im Gui angezeigt wird (Edit3 ist Nr. Wahl)
GuiControl,,%HwndEdit3%,%Edit3%
return
Edit4Festigen:	; wird nach der Veraenderung der Variablen Edit3 benoetigt, dass diese auch im Gui angezeigt wird (Edit3 ist Nr. Wahl)
GuiControl,,%HwndEdit4%,%Edit4%
return
Edit5Festigen:	; wird nach der Veraenderung der Variablen Edit5 benoetigt, dass diese auch im Gui angezeigt wird (Edit5 ist Pfade)
GuiControl,,%HwndEdit5%,%Edit5%
return
Edit6Festigen:	; wird nach der Veraenderung der Variablen Edit6 benoetigt, dass diese auch im Gui angezeigt wird (Edit5 ist Abbruch)
GuiControl,,%HwndEdit6%,%Edit6%
return
Edit7Festigen:	; wird nach der Veraenderung der Variablen Edit6 benoetigt, dass diese auch im Gui angezeigt wird (Edit5 ist Abbruch)
GuiControl,,%HwndEdit7%,%Edit7%
return
Edit8Festigen:	; wird nach der Veraenderung der Variablen Edit8 benoetigt, dass diese auch im Gui angezeigt wird (Edit8 ist ausgwaehler Pfad)
GuiControl,,%HwndEdit8%,%Edit8%
return
Edit9Festigen:	; wird nach der Veraenderung der Variablen Edit8 benoetigt, dass diese auch im Gui angezeigt wird (Edit8 ist ausgwaehler Pfad)
GuiControl,,%HwndEdit9%,%Edit9%
return
Edit10Festigen:	; wird nach der Veraenderung der Variablen Edit10 benoetigt, dass diese auch im Gui angezeigt wird (Edit10 ist Zusatz)
GuiControl,,%HwndEdit10%,%Edit10%
return

GuiSubmit:	; Speichert die Inhalte der Steuerelemente (vom ZackZsackOrdner-Gui) in ihre zugeordneten Variablen und versteckt das Gui.
Gui,Submit
return
GuiSubmitNohide:	; Speichert die Inhalte der Steuerelemente (vom ZackZsackOrdner-Gui) in ihre zugeordneten Variablen.
Gui,Submit,NoHide
return
GuiWinWaitActive:	; Warted bis das ZackZsackOrdner-Gui aktiv ist, maximal eine Sekundee
WinWaitActive,ahk_id %GuiWinHwnd%,,1
return
SWM:	; minimiert das ZackZsackOrdner-Gui		; 	fuer Befehsdateien bitte die Alternative GuiWinMin verweenden
SelfWinMin:	; minimiert das ZackZsackOrdner-Gui		; 	fuer Befehsdateien bitte die Alternative GuiWinMin verweenden
SelfMin:	; minimiert das ZackZsackOrdner-Gui		; 	fuer Befehsdateien bitte die Alternative GuiWinMin verweenden
F4::	; minimiert das ZackZsackOrdner-Gui		; 	fuer Befehsdateien bitte die Alternative GuiWinMin verweenden
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
; Critical, On ;
; Thread,Priority,9999 ;
; MsgBox Button6 ;
Gui,Submit,NoHide
GuiControl,,%HwndEdit8%.%Edit8%
GuiControl,,%HwndEdit10%.%Edit10%
if (Buttton6Params="")
{
	; IfExistCallEExeOrAhk(A_ScriptDir "\Button6.ahk",Edit8,Edit10) ;
	run, "%A_ScriptDir%\Button6.exe" "%A_ScriptDir%\Button6.ahk" "%Edit8%"  "%Edit10%"
}
else
{
	; IfExistCallEExeOrAhk(A_ScriptDir "\Button6.ahk",Edit1,Edit2,Edit3,Edit4,Edit6,Edit7,Edit8,Edit9,Edit10) ;
	run, "%A_ScriptDir%\Button6.exe" "%A_ScriptDir%\Button6.ahk" "%Edit1%"  "%Edit2%" "%Edit3%" "%Edit4%" "%Edit5%" "%Edit6%" "%Edit7%" "%Edit8%" "%Edit9%" "%Edit10%" 
}
; MsgBox vor ifexist ;
; Critical, Off ;
; Thread,Priority,-1 ;
return
Button7:
return
Button8:
return
Button9:
return
Button10:
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
		GuiControl,,%HwndEdit7%,%Edit7%
		gosub SufiAn
		gosub F5
		
return
VomVaterDir:	; Edit7 <-- den Ordner der Edit8 enthaelt.
Edit8Sternlos:=FuehrendeSterneEntfernen(Edit8)
SplitPath,Edit8Sternlos, Edit8SternlosFileName, Edit8SternlosDir ; , Edit8SternlosExt, Edit8SternlosNameNoExt
		Edit7:=Edit8SternlosDir
		GuiControl,,%HwndEdit7%,%Edit7%
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
		GuiControl,,%HwndEdit7%,%Edit7%
		gosub SufiAn
		gosub F5
		; MsgBox % ThisExplorerPath ;
	}
}
else if (VaterTyp="OrdnungsDB")
{
	
}

return

HalloWelt(Nummer="")
{
	MsgBox, 262144,%A_ScriptName% at %A_LineNumber% ,Hallo Welt %Nummer%
	; MsgBox Hallo Welt ;
	return "Hallo Welt " Nummer
}

ThisStringReplace(InputVar,SearchText="",ReplaceText="",All="")	; Kurz:	siehe <a href="http://de.autohotkey.com/docs/commands/StringReplace.htm">StringReplace.htm</a>	Eingang: -
{
	global
StringReplace,OutputVar,InputVar,%SearchText%,%ReplaceText%,%All%
 MsgBox, 262144, %A_ScriptName% at %A_LineNumber% in der Funktion, %SearchText%`,%ReplaceText%`,%All%
; MsgBox, 262144, %A_ScriptName% at %A_LineNumber% in der Funktion, %OutputVar%`,%InputVar% ;
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
	MsgBox EingangsString=%EingangsString%
	If (EingangsString="")
		return
	MsgBox EingangsStringName=%EingangsStringName%
	if(InStr(EingangsString,Hochkomma))
	{
		StringSplit,GeradeTextUngeradeVar,EingangsString,%Hochkomma%	; GeradeTextUngeradeVar1 GeradeTextUngeradeVar2 GeradeTextUngeradeVar3 
		MsgBox % GeradeTextUngeradeVar0 A_tab GeradeTextUngeradeVar1 A_tab GeradeTextUngeradeVar2 A_tab GeradeTextUngeradeVar3 A_tab GeradeTextUngeradeVar4 A_tab GeradeTextUngeradeVar5 A_tab GeradeTextUngeradeVar6
		; if(not InStr(DieseFunktionParameter4,Hochkomma)) ;
			; DieseFunktionParameter4:=%DieseFunktionParameter3% ;
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
			; MsgBox %ThisFunktionUeberGabestringErzeugenRueckgabe% ;
			; Return %ThisFunktionUeberGabestringErzeugenRueckgabe% ;
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
		MsgBox Ruck=%EingangsString%
		SuperEingangsString:=%EingangsString%
		return SuperEingangsString
	}
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
; pruefen ob Hotkey von Folgezeile zum Festeruebergreifenden HotKey erhoben werden soll ############## ;
^-::	; kopiere oder verschiebe Pfade die bereits im Clipboard stehen.
TimeStampClipWaitPathes2Edit8:=A_TickCount
KopiereOderVerschiebeFilesAndFolders2Edit8:
if(TimeStampClipWaitPathes2Edit8 < A_TickCount- 60000) ; 1 Minute ueberschritten
	return
DateiPfade:=Clipboard
; MsgBox % DateiPfade ;
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
FileEncoding,UTF-16

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
			FileAppend,`%Einzeltaste`%{`%Zusatz`%},c:\temp\LetzteTastenBeginnSchafSS.txt
			; ThisText=`%ThisText`%`%Einzeltaste`%`%ZuasatzTab`%
			ThisText:=ThisText  Einzeltaste ; ZuasatzTab
		}
		else
		{
			FileAppend,`%Einzeltaste`%`%ZuasatzTab`%,c:\temp\LetzteTastenBeginnSchafSS.txt
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
#space::  ; Hotkey: WIN+LEERTASTE. Drücke ihn, um eine InputBox zur Eingabe eines String anzuzeigen.
InputBox, ZuSendendeString, Text via WM_COPYDATA senden, Tragen Sie den zu sendenden Text ein:
if ErrorLevel  ; Benutzer hat den Abbrechen-Button gedrückt.
    return
SendeZuSendendeStringOhneFenster:
Ergebnis := Sende_WM_COPYDATA(ZuSendendeString, ZielScriptTitel)
if Ergebnis = FAIL
    TrayTip, SendMessage fehlgeschlagen., Gibt es den folgenden Fenstertitel?:``n`%ZielScriptTitel`%
   ; MsgBox SendMessage fehlgeschlagen. Gibt es den folgenden Fenstertitel?:``n`%ZielScriptTitel`%
else if Ergebnis = 0
    TrayTip, Nachricht, wurde gesendet``, aber das Zielfenster hat mit 0 geantwortet``, was bedeuten könnte``, dass sie ignoriert wurde.
    ; MsgBox Nachricht wurde gesendet, aber das Zielfenster hat mit 0 geantwortet, was bedeuten könnte, dass sie ignoriert wurde.
return

Sende_WM_COPYDATA(ByRef ZuSendendeString, ByRef ZielScriptTitel)  ; ByRef verbraucht in diesem Fall weniger Speicher.
; Diese Funktion sendet den angegebenen String zum angegebenen Fenster und gibt die Anwort zurück.
; Die Antwort ist 1, wenn das Zielfenster die Nachricht akzeptiert hat, oder 0, wenn die Nachricht ignoriert wurde.
{
; SoundBeep ; 
; SoundBeep
; SoundBeep

    VarSetCapacity(KopieDatenStrukt, 3*A_PtrSize, 0)  ; Richtet den Speicherbereich der Struktur ein.
    ; VarSetCapacity(KopieDatenStrukt, 3*A_PtrSize, 0)  ; Richtet den Speicherbereich der Struktur ein. original
    ; Zuerst wird das cbData-Element der Struktur auf die Größe des Strings gesetzt, einschließlich dem Null-Terminator.
    GrößeInBytes := (StrLen(ZuSendendeString) + 1) * (A_IsUnicode ? 2 : 1)
    ; GrößeInBytes := (StrLen(ZuSendendeString) + 1) * (A_IsUnicode ? 2 : 1); original
    NumPut(GrößeInBytes, KopieDatenStrukt, A_PtrSize)  ; Muss für das OS getan werden.
    ; NumPut(GrößeInBytes, KopieDatenStrukt, A_PtrSize)  ; Muss für das OS getan werden.
    NumPut(&ZuSendendeString, KopieDatenStrukt, 2*A_PtrSize)  ; Lässt lpData auf den String selbst verweisen.
    ; NumPut(&ZuSendendeString, KopieDatenStrukt, 2*A_PtrSize)  ; Lässt lpData auf den String selbst verweisen.
    Vorher_DetectHiddenWindows := A_DetectHiddenWindows
    Vorher_TitleMatchMode := A_TitleMatchMode
    DetectHiddenWindows On
    SetTitleMatchMode 2
    SendMessage, 0x4a, 0, &KopieDatenStrukt,, `%ZielScriptTitel`%  ; 0x4a ist WM_COPYDATA. Muss Send verwenden, nicht Post.
    DetectHiddenWindows `%Vorher_DetectHiddenWindows`%  ; Stellt die ursprüngliche Einstellung wieder her.
    SetTitleMatchMode `%Vorher_TitleMatchMode`%         ; Hier auch.
    return ErrorLevel  ; Gibt SendMessage's Antwort zum Aufrufer zurück.
}

Explorer:
IfWinActive,ahk_class CabinetWClass
{
	WinGetPos,WinX,WinY,WinB,WinH,A
	x:=(WinX+WinX+WinB)/2+80
	WinYPlus:=WinY+25
	ExplorerHwnd:=WinExist(A)
	IfWinExist,ButtonGUI
	{
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
	WinSet,AlwaysOnTop, On,ahk_id `%GuiWinHwnd`%
	WinShow,ahk_id `%GuiWinHwnd`%
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
	run, explorer.exe
WinWaitActive,ahk_class CabinetWClass,,5
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

; 20160329161211 ; AutoPopAusnahmeDefaultDateiErstellen:
; 20160329161212 ; AutoPopAusnahmeDefaultInhalt=
; 20160329161212 ; (
; 20160329161213 ; Ausführen	Geben Sie den Namen
; 20160329161214 ; Bookmarks	Bookmark:
; 20160329161215 ; Character Map	Ch&aracters to copy :
; 20160329161215 ; Check for Updates	ID_CONTENT
; 20160329161216 ; Delete File	Are you sure you want
; 20160329161216 ; Drucken	A
; 20160329161217 ; Einstellungen	&Seite auswählen:
; 20160329161218 ; Ersetzen von Ordnern	Das Ziel
; 20160329161218 ; Help
; 20160329161219 ; Hilfe
; 20160329161219 ; Lesezeichen	Lesezeichen:
; 20160329161220 ; Manual transfer	Transfer &direction
; 20160329161221 ; Manuelle Übertragung	Übertragungs&richtung
; 20160329161221 ; Open with	Choose the program you want to use
; 20160329161222 ; Print	General
; 20160329161222 ; Run	Type the Name
; 20160329161223 ; seconds remaining	from
; 20160329161223 ; Sekunden verbleibend	von
; 20160329161226 ; Server Manager	Eintrag Auswählen
; 20160329161227 ; Servermanager	Eintrag
; 20160329161228 ; Settings	Select &page:
; 20160329161229 ; Site Manager	&Select 
; 20160329161230 ; Suche nach Updates	ID_CONTENT
; 20160329161230 ; Windows	Windows can't open this file
; 20160329161231 ; Windows Easy Transfer	&Help
; 20160329161232 ; Windows Easy Transfer	&HelpOpen with	Choose the program you 
; 20160329161233 ; ZackZackOrdner
; 20160329161233 ; )
; 20160329161239 ; IfExist %A_AppData%\Zack\%ScriptNamneOhneKlammer%.ausn
; 20160329161240 ; MsgBox, 262180, Ausnahmen vorhanden, %A_AppData%\Zack\%ScriptNamneOhneKlammer%.ausn`nbesteht bereits`,`nsoll sie durch den Defaultwert ersetzt werden?
; 20160329161241 ; 	IfMsgBox, Yes
; 20160329161243 ; 		FileDelete, %A_AppData%\Zack\%ScriptNamneOhneKlammer%.ausn
; 20160329161244 ; MsgBox erstelle `n%A_AppData%\Zack\%ScriptNamneOhneKlammer%.aus`nmit dem Inhalt `n%AutoPopAusnahmeDefaultInhalt%
; 20160329161246 ; FileAppend,%AutoPopAusnahmeDefaultInhalt%,%A_AppData%\Zack\%ScriptNamneOhneKlammer%.ausn
; 20160329161248 ; if ZackZackOrdnerLogErstellen
; 20160329161249 ; 	ThreadUeberwachungLog(A_LineNumber-1,A_ThisHotkey,A_ThisLabel,A_ThisFunc,A_ThisMenu,A_ThisMenuItem,A_ThisMenuItemPos)
; 20160329161250 ; return

KontainerAnzeigen:
SplitPath,SkriptDataPath,NameSkriptDataPath
; MsgBox % NameSkriptDataPath ;
gosub WorteCacheBefuellen
GuiControl,Text,%HwndButton1%,aktualisieren`n[%NameSkriptDataPath%]
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
if ((SucheDateienPfadahk="" or SucheDateienPfadexe="") and not FileSearchPathExist)
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
SomeFilterText=%Edit10%
ButtonFilter
)
DoBefehlsDatei=%DoBefehlsDatei%%OhneInputOderLeer%		; ergaenzt ggf. ButtonFilter
; MsgBox % DoBefehlsDatei ;
PfadDieserDoBefehlsDatei=%A_temp%\DieseDoBefehlsDatei.do
FileDelete,%A_temp%\DieseDoBefehlsDatei.do
if ZackZackOrdnerLogErstellen
	ThreadUeberwachungLog(A_LineNumber-1,A_ThisHotkey,A_ThisLabel,A_ThisFunc,A_ThisMenu,A_ThisMenuItem,A_ThisMenuItemPos)
FileAppend,%DoBefehlsDatei%,%A_temp%\DieseDoBefehlsDatei.do
if ZackZackOrdnerLogErstellen
	ThreadUeberwachungLog(A_LineNumber-1,A_ThisHotkey,A_ThisLabel,A_ThisFunc,A_ThisMenu,A_ThisMenuItem,A_ThisMenuItemPos)
; run %SucheDateienPfad% "%Edit8Sternlos%" ;
; TrayTip,SuchFilter,via Button Filter-Enth. eingeben ;
; RunOtherAhkScript(SucheDateienPfad,Edit8Sternlos) ;
if ZackZackOrdnerLogErstellen
	ThreadUeberwachungLog(A_LineNumber+1,SucheDateienPfadexe,SucheDateienPfadahk,PfadDieserDoBefehlsDatei,A_ThisMenu,A_ThisMenuItem,"vor 8101")
; NurExeStartErlaubt:=true ;
; RunOtherAhkScript(SucheDateienPfadexe,SucheDateienPfadahk,PfadDieserDoBefehlsDatei) ;
SplitPath,SucheDateienPfadexe,,SucheDateienPfadDir
Run,%SucheDateienPfadexe% "%SucheDateienPfadahk%" "%PfadDieserDoBefehlsDatei%",%SucheDateienPfadDir%
; NurExeStartErlaubt:=false ;
if ZackZackOrdnerLogErstellen
	ThreadUeberwachungLog(A_LineNumber-1,A_ThisHotkey,A_ThisLabel,A_ThisFunc,A_ThisMenu,A_ThisMenuItem,"nach 8101")
return

StartPfadeUebersicht:
DieseStartPfadeUebersicht:=
Eddit3:=1
gosub Edit3Festigen
Loop,Files,%SkriptDataPath%\*, D
{
	DieseStartPfadeUebersicht:=DieseStartPfadeUebersicht "`r`n" A_LoopFileLongPath
}
StringTrimLeft,DieseStartPfadeUebersicht,DieseStartPfadeUebersicht,2
Edit5:=DieseStartPfadeUebersicht
gosub Edit5Festigen
Return

ThreadUeberwachungLog(LineNumber,ThisHotkey,ThisLabel,ThisFunc,ThisMenu,ThisMenuItem,ThisMenuItemPos)
; ThreadUeberwachungLog(A_LineNumber,A_ThisHotkey,A_ThisLabel,A_ThisFunc,A_ThisMenu,A_ThisMenuItem,A_ThisMenuItemPos)	; <--- Aufruf via ;
{
	Global ZackZackOrdnerLogErstellen
	FileReadLine,ThisQuellZeile,%A_ScriptFullPath%,LineNumber
	StringReplace,ThisQuellZeile,ThisQuellZeile,`, ThreadUeberwachungLog(A_LineNumber`,A_ThisHotkey`,A_ThisLabel`,A_ThisFunc`,A_ThisMenu`,A_ThisMenuItem`,A_ThisMenuItemPos)
	StringReplace,ThisQuellZeile,ThisQuellZeile,ThreadUeberwachungLog(A_LineNumber`,A_ThisHotkey`,A_ThisLabel`,A_ThisFunc`,A_ThisMenu`,A_ThisMenuItem`,A_ThisMenuItemPos)
	; MsgBox, % ThisQuellZeile ; LineNumber A_Tab ThisHotkey A_Tab ThisLabel A_Tab ThisFunc A_Tab ThisMenu A_Tab ThisMenuItem A_Tab ThisMenuItemPos A_Tab ThisQuellZeile ;
	FileAppend, % A_Now A_Tab LineNumber A_Tab ThisQuellZeile A_Tab ThisHotkey A_Tab ThisLabel A_Tab ThisFunc A_Tab ThisMenu A_Tab ThisMenuItem A_Tab ThisMenuItemPos "`r`n" ,%A_Temp%\ZackZackOrdner.Log
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
. -> [^""]{1}	.{#1,#2} 			von #1-Zeichenanzahl bis #2-Zeichenanzah, nicht so # eingebbar
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
; 20160329160034 ; 	Thread, priority,1
	GuiWinVerschoben:=false
	WinGetPos,DieseThisX,DieseThisY,DieseThisB,DieseThisH,ahk_id %GuiWinHwnd%
	If (RegExBeratungsFormularXPos+RegExBeratungsFormularBreite>A_ScreenWidth)
	{
		; WinGetPos,DieseThisX,DieseThisY,DieseThisB,DieseThisH,ahk_id %GuiWinHwnd% ;
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
	; 	if(SubStr(RegExSuchStringEdit2,0)=) ;
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
			; SoundBeep ;
		}
		; LastRegExSuchStringEdit2:=RegExSuchStringEdit2 ;
		LastRegExBeratungsFormularSendTimeStamp:=A_TickCount
		; gosub MomentaneWortListeErzeugen ;
		; MsgBox %MomentaneWortListe%
		GefundeneWortePos:=1
		GesamtGefundeneWortePos:=1
		GefilterteWortListe:=
		ThisFundZaehler:=0
		Loop
		{
			GefundeneWorteObjekt:=
			; MsgBox % A_LineNumber A_Tab MomentaneWortListe ;
			GefundeneWortePos:=RegExMatch(MomentaneWortListe,RegExSuchStringEdit2,GefundeneWorteObjekt,GesamtGefundeneWortePos)
			if GefundeneWortePos
			{
				++ThisFundZaehler
				If (ThisFundZaehler > Edit6*4)
					break
			}
			GesamtGefundeneWortePos:=GefundeneWortePos+GefundeneWorteObjekt.Len(1)
			; MsgBox % GefundeneWortePos A_Tab GefundeneWorteObjekt.Count(1) A_Tab GefundeneWorteObjekt.Value(1) A_Tab GefundeneWorteObjekt.Value(2) ;
			GefilterteWortListe:=GefilterteWortListe "`r`n" GefundeneWorteObjekt.Value(1)
			if not GefundeneWortePos
				break
		}
		StringTrimLeft,GefilterteWortListe,GefilterteWortListe,2
		edit5:=GefilterteWortListe
		gosub Edit5Festigen
		; MsgBox % Edit5 ;
		if Edit2RegExAuswahlExist
			break
	}
; 20160329160050 ; 	Thread, priority,-1
	if Edit2RegExAuswahlExist
	{
		StringSplit,GefiltertesWort,GefilterteWortListe,`n,`r
		Edit2:=GefiltertesWort%Edit2RegExAuswahl%
		; MsgBox % GefiltertesWort%Edit2RegExAuswahl% A_Tab GefilterteWortListe ;
		gosub Edit2Festigen
		gosub F5
		; SoundBeep,5000 ;
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

MomentaneWortListeErzeugen:
; MsgBox MomentaneWortListeErzeugen ;
MomentaneWortListe:=
Loop,Files,%SkriptDataPath%\*,D
{
	Loop,Files,%A_LoopFileLongPath%\*,F
	{
		MomentaneWortListe:=MomentaneWortListe CrLf SubStr(A_LoopFileName,1,-4)
		; ToolTip,% A_Index,,,2 ;
	}
	; ToolTip,% substr(MomentaneWortListe,-300) ;
	; SoundBeep ;
}
StringTrimLeft,MomentaneWortListe,MomentaneWortListe,2
return

WorteCacheBefuellen:
FoldernamesMitVielenDoppelten:=
; MsgBox %SkriptDataPath%\FolderNames*.txt ;
Loop,Files,%SkriptDataPath%\FolderNames*.txt,F
{
	; MsgBox drinn %A_LoopFileLongPath% ;
	FileRead,FoldernamesMitDoppelten,%A_LoopFileLongPath%
	; MsgBox % FoldernamesMitDoppelten ;
	FoldernamesMitVielenDoppelten:=FoldernamesMitVielenDoppelten "`r`n" FoldernamesMitDoppelten
}
StringTrimLeft,FolderNames,FoldernamesMitVielenDoppelten,2
Sort,FolderNames,U
; MsgBox % FolderNames ;
return

ResetAllNocontainer:
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
Edit10:=Edit10Default
gosub Edit10Festigen

; 20160329184508 ; EdWa:=EdWaDefault
; 20160329134345 ; gosub EdWaFestigen

; OnTop:=OnTopDefault
; gosub OnTopFestigen

; 20160329141450 ; FiCa:=FiCaDefault
; 20160329134336 ; gosub FiCaFestigen

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
; 20160329134509 ; gosub WiWaFestigen

beschaeftigt:=beschaeftigtDefault
gosub beschaeftigtFestigen
return

FuehrendeSterneEntfernen(Pfad,Max=20)
{
 	global AnzahlEntfernterSterne
	Stern=*
	AnzahlEntfernterSterne:=0
	; MsgBox EingangPfad %Pfad% ;
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
			; MsgBox AusgangPfad %Pfad% ;
			return Pfad
		}
		--Max
	}
	return
}
OeffneAlleSkriptOrdner:
run %A_AppDataCommon%
run %A_AppData%
run %A_ScriptDir%
return