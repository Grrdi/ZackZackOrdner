ZZO_Version:="0.669"	; ZZO_LastVersionItem
SetWorkingDir %A_ScriptDir%
; #Warn
#Warn, LocalSameAsGlobal, Off
#InstallKeybdHook
#InstallMouseHook
#UseHook
#InputLevel ,100
#NoEnv  ; Recommended for performance and compatibility with future AutoHotkey releases.
;~ #Warn  ; Recommended for catching common errors.
SendMode Input  ; Recommended for new scripts due to its superior speed and reliability.
#MaxMem 256
global ViaTimerKenner,ViaTimerKennerLen,ViaTimerTargetLabel,GetObjectDetails_Vorfahren,A_SystemDrive,A_USERPROFILE,A_Homedir,
; SetControlDelay -1 ; verhindert das festkleben von Selektionen am Mauszeiger.
WinClose,ahk_exe TastWatch.exe
;Include the language	; 	https://autohotkey.com/boards/viewtopic.php?f=10&t=32363
; FileEncoding,UTF-16
; #include *i C:\Program Files (x86)\ZackZackOrdner\language\language.ahk	; benotigt https://github.com/bichlepa/lang
#include *i language\language.ahk	; benotigt https://github.com/bichlepa/lang
; #Include *i Object to file\objtostring.ahk
;call the initialization routine
lang_init()
if(A_DebuggerName="")
	MouseMoveKenner:=0x200
else
	MouseMoveKenner:=
OnMessage(MouseMoveKenner, "WM_MOUSEMOVE")
OnMessage(0x111, "WM_COMMAND")
; lang_setLanguage("2") ; 2 for English only Main-Menu		1 fuer deutsch
; ObjetDetails :=true
ObjetDetails :=false


if ObjetDetails
	MsgBox % GetObjectDetails(_language)
; < ######################################### Inhalts-Verzeichnis ############################################ > @0010
;	Haupt-Programmm
;{	;	Tipp: [Win] + [b] Aktivierung  ######################################################################
;	Wenn mal schnell ein Pfad benoetigt wird (z.B. im Explorer)
;	kann die Stelle an welcher der Pfad eingefuegt werden soll mit der Maus angeklickt werden
;	und danach die Tastenkombination [Win] + [b] gedrueckt werden.
;	nun versucht ZZO das Beste aus den vorhandenen Informationen zu machen:
;	meist erscheint nun ein Pfad-Wahl-Menue.
;	Je nach getroffener Wahl (z.B. Ordner oder Datei) wird wiederum versucht das Beste daraus zu machen.
;	Die [Win] + [b] Aktivierung kann bei gut gepflegten Favoriten die 80%-Aufgabe loesen, gestartet vorzugsweise in aktiven Explorer-Fenstern bzw. in Speichern Unter Dialogen.
;	[Win] ist die Taste ueblicherweise zwischen [Strg] und [Alt] liegt 
;	(AutoHotKey Schreibweise #b oder {LWin Down}b{LWin Up}).
;}	
;{	;	Tipps zum Quelltext
;	Der hier vorliegende Quelltext enthaelt auch den Quelltext der eigenstaendigen Skripte
;		Dir2Paths.ahk					siehe Label:	BereiteVorDir2Paths
;		TastWatch.ahk					siehe Label:	VarTastWatcherzeugen
;	Ersteres wird bei Bedarf aus mindestens einem Start-Pfad die zugehörigen Cache-Dateien erstellen.
;	Es wird von ZZO aus der Variablen
;		Dir2Paths 
;	erstellt und mit dem Cache-Verzeichnis sowie den Start-Pfaden als Ueberabeparameter gestartet.
;	Zweiteres wird von ZZO aus der Variablen 
;		TastWatch
;	erstellt und gestartet. Es haendelt den Ordner-Button und bei Bedarf vermittelt es die Befehlseingabe ins ZZO-Programm.
;	Dieser Quelltext ist durch seine Laenge unuebersichtlich.
;	Es gibt jedoch Hilfsmittel, mit denen man besser zurecht kommt.
;	Der Quelltext wurde optimiert fuer den Editor Scite4Autohotey.
;	Nach dem Laden des Quelltextes empfehle ich vom SciteMenue | View | Toggle all folds durchzufuehren.
;	Es wurden dafuer ganz viele ;{ und ;} in den Quelltext eingefuegt.
;	Dadurch entstehen in Scite Einklapp-Bereiche die fast frei waehlbar sind.
;	AutoHotKey behandelt diese jeweils 2 Zeichen und den Text rechts davon als Kommentar.
;	Weiterhin bringt dieses Skript selbst einige nuetzliche Hilfen mit:
;	- Der Quelltext laesst sich mit ZZO-Menue | ? | Quelltext anzeigen lesend oeffnen.
;	  Durch die Eingabe eines Suchbegriffs ganz rechts im Eingabefeld,
;	  werden nur noch Zeilen angezeigt, die den Suchbegriff enthalten.
;	  z.B. "Suchbegriff enthalten" eingegeben sollte mindestens diese Zeile und die darueber anzeigen.
;	  bei meinem Test soeben wurde noch die Zeile 12481 mit angezeigt.
;	  Ein Doppelklick darauf oefffnet Scite mit der sichtbaren Zeile 12481 
;	  in der die Text-Stelle "Suchbegriff enthalten" markiert ist. Achtung hier ist schreiben moeglich.
;	  Nun weiss ich auch dass diese Wortwahl auch in den Versionsinformationen vewendet wurde.
;	- Die Menue-Eintraege unterhalb von Quelltext anzeigen sind letzendlich nur 
;	  die gleiche Funktion "Quelltext anzeigen"
;	  mit Vorausgefuellten Suchbegriffen.
;	Wer tiefer eindringen moechte, dem sei die
;		Grundsätzliche Arbeitsweise des ZZO-Fensters
;	aus der Hilfe Menue | ? | Hilfe genau zu lesen empfohlen.
;	Wichtig ist noch, dass die Funktion GetPaths() die
;		relevanten Pfade des Caches
;	besorgt.
;	Einzel-Tipps:
;	Die benutzten Events findet man via  Menu | ? | InhaltsVerzeichnis anzeigen  Doppelklick auf  E v e n t s
;	Den ersten Hauptmenue-Eintrag findet man mit dem Suchbegriff: Menu | Datei | Reload
;	Das zugehoerige Label findet man durch auflappen von	; Menu | Datei | Reload
;}	
;{	Programmierer- Notizen
; umstellen auf:
; FilP://%MusterDirPath%\*%DateiOrdnerNamensMuster1%*,%DFR%%Vorzeichen%%In_Row? %NachFilter1%
; MusterDirPath:="C:\Program Files (x86)\ZackZackOrdner",DateiOrdnerNamensMuster1:="Gerd",DFR:="DF",Vorzeichen:="+",NachFilter1:=""
; welches Programm startet PathWith.Ext
; DiesesProgHwnd := OpenAndGetHwnd("PathWith.Ext")
; z.B. bei F8 aufrufen
; 
; Allgemeine Live-Suche in Planung
; MacroDoFile EvalVars    Anzeige von bzw. wie
; .           .           .
; MacD:// ... EvlVar? ... In_Inh? ... 
; MacD:// ... EvlVar? ... In_Row? ... 
; MacD:// ... EvlVar? ... Nr_Row? ... 
;         MacroDoPath
;         MacroDoVar
;         LeereMenge 
;                     Edit5= ... %Var1% ... %Var2% ...
;                                 Suchbegriff
; text://WTitle? ahk_id %VarContainsHwnd% Contro? %VarContainsClassNN% Nr_Row? 
; file://C:\Program Files (x86)\ZackZackOrdner\SchnellOrdner[0.422].ahk Nr_Row? Suchbegriff[-2,+3]
; Suchbegriff[-2,+3] bedeutet die Fundzeile inclusive die 2 davor und die 3 danach anzeigen. 
; [1,1] wuerde nur die Folgezeile zeigen. [0,0] ist wie ohne klammer.
; file://C:\Program Files (x86)\ZackZackOrdner\SchnellOrdner[0.422].ahk Nr_Row?[-2,+3] Suchbegriff Nr_Row?[+2,+3] Suchbegriff2 unterstuetzen.
;                                                               Anzeige-Range [von,bis]
;                                                                                      Suchbegriff zur Ermittlung der Basis-Zeile
;                                                                                                         Range relativ zur Basiszeilen dem Suchbegriff2 gefunden werden muss
; ToDo:Pfad-Wahl letzter Eintrag ... wenn mehr Fundstellen vorhanden. Klick drauf zeigt die naechsten N an.
; ToDo: Dos Befehl ftype in Verbindung mit assoc ansehen. Welche Dateiendung wird mit welchem Programm gestartet
; Fehler: geoffnetes ExplorerFenster in dem eine Suche aktiv ist mit Doppelklick nicht aktivierbar
; RePro: Im Explorer CabinetWClass eine Suche via DirectUIHWND1 starten. Dieses Fenster in ZZO via Vor-Filter 99 anzeigen lassen. DoppelKlick auf dessen Pfadeintrag. Das Explorer-Fenster sollte aktiv werden
; ToDo: geoffnetes ExplorerFenster in dem eine Suche aktiv ist mit Doppelklick aktivierbar machen, gegebenfalls sprechendere Bezeichner verwenden!
; gosub mFMenu
; C:\Users\All Users\Zack			\	Diese Ordner sind identisch  ToDo: Cache rausholen aus Doppelt vorhandenen Stellen vermutlich steckt ein Junction Point im NTFS sytem dahinter
; C:\ProgramData\Zack				/	Diese Ordner sind identisch
; #Include C:\Program Files (x86)\ZackZackOrdner\Hilfsprogramme\DebugVars.ahk-master\lib\dbgp.ahk
; #Include C:\Program Files (x86)\ZackZackOrdner\Hilfsprogramme\DebugVars.ahk-master\lib\dbgp_console.ahk
; #Include C:\Program Files (x86)\ZackZackOrdner\Hilfsprogramme\DebugVars.ahk-master\TreeListView.ahk
;}	
;{	; < ######################################### Anfangs-Kommentare ######################################## > @0020
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
;}	; < / ######################################## Anfangs-Kommentare ######################################## >
;{	Direktiven
#SingleInstance off
; #SingleInstance
#NoEnv
#Persistent
;}	
/*
Life Suche Beispiele:
FilP://%SkriptDataPath%\Wurzel*.txt*,F in_inh? \	Zeigt die StartPfade des aktuellen Containers
*/
;	;	; < ###################################### H a u p t - P r o g r a m m  ############################### > @0100
; SuperGlobal Vars
global EvalButton1Only:=false, InitiatorButton1:=false
OnExit GuiClose
if 0 = %0%
{
	Ue:={}
	Loop, %0%
		 Ue[A_index]:=%A_Index%
		; Ue.Push([]):=%A_Index%
		; Ue.Push([%A_Index%])
		; Ue.Push([A_Index]:[%A_Index%])
	if ObjetDetails
		MsgBox % GetObjectDetails(Ue,"Ue")			Ue.MaxIndex()
}
; Ue1=%1%
;{	< ########################################## Konstanten ######################################## > @0110
DebugViaBeschLog:=false		; Default -> false
EnvGet,A_SystemDrive,SystemDrive
EnvGet,A_USERPROFILE,USERPROFILE
EnvGet,Temp2,HOMEPath
EnvGet,Temp1,HOMEDRIVE
A_HomeDir:=Temp1 Temp2

A_AppData_100:=FuelleMitLeerzeichenBisSpalte("A_AppData")
A_AppDataCommon_100:=FuelleMitLeerzeichenBisSpalte("A_AppDataCommon")
A_MyDocuments_100:=FuelleMitLeerzeichenBisSpalte("A_MyDocuments")
A_ProgramFiles_100:=FuelleMitLeerzeichenBisSpalte("A_ProgramFiles")
A_Programs_100:=FuelleMitLeerzeichenBisSpalte("A_Programs")
A_ProgramsCommon_100:=FuelleMitLeerzeichenBisSpalte("A_ProgramsCommon")
A_Temp_100:=FuelleMitLeerzeichenBisSpalte("A_Temp")
A_WinDir_100:=FuelleMitLeerzeichenBisSpalte("A_WinDir")
A_WorkingDir_100:=FuelleMitLeerzeichenBisSpalte("A_WorkingDir")
A_SystemDrive_100:=FuelleMitLeerzeichenBisSpalte("A_SystemDrive")
A_HomeDir_100:=FuelleMitLeerzeichenBisSpalte("A_HomeDir")

if (DebugViaBeschLog="")
	DebugViaBeschLog:=false
DebugViaBeschPath:= A_ScriptDir "\" A_UserName "_" A_ComputerName "_DebugBesch.log"
if DebugViaBeschLog
{
	IfExist,%DebugViaBeschPath%
	{
		FileDelete, %DebugViaBeschPath%
		if ErrorLevel
			MsgBox Konnte alten Log %DebugViaBeschPath% nicht loeschen!`r`nErwarte auch Schreib-Probleme.
	}
		
}
IeBildExtList:="bmp,cur,ico,jpg,jpeg,gif,png,tif,tiff,svg,wmf,xar"		; Fehl: ,eps,gem,img,odg,pgm,ps,psd,swf,xaml,xcf
GetGlobalVarAndValueList=Cont`%AktContainerNr`%,Edit2,Edit3,Edit5,Edit8,Edit11,Edit12
Neutr_LM:="Ø"	; (Leere Menge) Zeichen verhaelt sich bei der Live-Suche neutral
Neutr_US:="¯"	; (Upper Score) Zeichen verhaelt sich bei der Live-Suche neutral
Neutr_Ca:="⁞"	; (Caret) Zeichen verhaelt sich bei der Live-Suche neutral
N_PHL:= Neutr_LM Neutr_US 			; Neutraler Platz Halter Links
N_PHR:= Neutr_US Neutr_LM			; Neutraler Platz Halter Rechts
N_PH:= N_PHL N_PHR					; Neutraler Platz Halter
N_PHC:= N_PHL Neutr_Ca N_PHR		; Neutraler Platz Halter mit Caret
N_PPH:=Neutr_LM N_PH Neutr_LM		; Bevorzugter Neutraler Platz Halter
N_PPHC:=Neutr_LM N_PHC Neutr_LM		; Bevorzugter Neutraler Platz Halter mit Caret
NICHT:="¬"
VTab:="`v"
CR=`r
LF=`n
CRLF:=CR LF
Backslash=\
DotOverDot:=":"
PfRe:="→"
ReturnChar:="⏎"
Hochkomma="
Prozent=`%
GetObjectDetails_KKA:="["
GetObjectDetails_KKZ:="]"
GetObjectDetails_VKA:="["""
GetObjectDetails_VKZ:="""]"
ExSelRec:=false
GrEdit11Default:=2
NotWordDefault = $Recycle.Bin,!Fav,$$$,WuCont
; MenuKurzTasten:=true		; fuer Hauptmenue-Bedinung per [ALt]+[a] oder [ALt]+[b] ...] 
GuiNachHochfahrenMinimierenDefault:=0
GuiAnzeigeFortgeschrittenDefault:=0
NurInExistierendenStartPfadenSuchen:=1
NurInExistierendenStartPfadenSuchenDefault:=1
NotShowExistIeAndExplorerWin:=0
NotShowExistIeAndExplorerWinDefault:=0
ExpAutoSterne=*	; Auto-Favoriten-Sterne geoeffneter Explorefenster
StartUrlDefault:=
Edit1Default:=
Edit11efault:=
Edit3Default:=1
Edit4Default:="Befehlsentgegennahme"
Edit5Default:=
Edit6Default:="25"
Edit7Default:="Filter"
Edit8Default:=
Edit9Default:=4
Edit10Default:="Zusatz"
GrossKleinDefault:=false		; true GrossKleinschreibung wird bei der Suche unterschieden
RegExBeratungsFormularHoehe:=365
RegExBeratungsFormularBreite:=840
WiWaDefault:=0
OnTopDefault:=0
IeAnzDefault:=0
RekurDefault:=1	;	StartPfade werden mit Unterordnern eingelesen
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
WortVorschlaegeDefault:=1
beschaeftigtDefault:=0
MausGuenstigPositionierenDefault:=0
PfadFilterAutomatikAus:=true ; aus also auf true lassen, vertraegt sich nicht mit der Neuen-Live-Suche

ProtokollKenner:="://"
ProtokollKennerLen:=StrLen(ProtokollKenner)
HelpQuellKenner:="Help://"
HelpQuellKennerLen:=StrLen(HelpQuellKenner)
HelpKenner:="Help?"	; reserviert fuer Kombination von Kenner drueber und Kenner drunter
HelpKennerLen:=StrLen(HelpKenner)
HelpZuKenner:="LiHelp?"
HelpZuKennerLen:=StrLen(HelpZuKenner)
NrInhaltKenner:="Nr_Inh?"
NrInhaltKennerLen:=StrLen(NrInhaltKenner)
InInhaltKenner:="In_Inh?"
InInhaltQuelleKenner:="InInhQ?"
InInhaltQuelleKennerLen:=StrLen(InInhaltQuelleKenner)
InInhaltKennerNotShowPath:="in_inh?"
InInhaltKennerLen:=StrLen(InInhaltKenner)
InRowKenner:="In_Row?"
InRowKennerLen:=StrLen(InRowKenner)
NrRowKenner:="Nr_Row?"
NrRowKennerLen:=StrLen(InRowKenner)
2ZeilenInhaltKenner:="2Z_Inh?"		; FilP://C:\Users\Gerd\AppData\Local\Temp\Clip\**,DFR2Z_Inh? 
2ZeilenInhaltKennerLen:=StrLen(2ZeilenInhaltKenner)
NrRexKenner:="NrRRex?"
NrRexKennerLen:=StrLen(NrRexKenner)
InNameKenner:="InName?"
InNameKennerLen:=StrLen(InNameKenner)
WinTitleKenner:="WTitle?"
WinTitleKennerLen:=StrLen(WinTitleKenner)
ContainerKenner:="Cont://"
ContainerKennerLen:=StrLen(ContainerKenner)
HwndTextKenner:="HwndT://"
HwndTextKennerLen:=StrLen(HwndTextKenner)
ControlKenner:="Contro?"
ControlKennerLen:=StrLen(ControlKenner)
MacroAufuehrenKenner:="MacrDo?"
MacroAufuehrenKennerLen:=StrLen(MacroAufuehrenKenner)
ControlTextKenner:="CoTe://"
ControlTextKennerLen:=StrLen(ControlTextKenner)
FileKenner:="file://"
FileKennerLen:=StrLen(FileKenner)
FileE5WriteKenner:="fileE5Write?"
FileE5WriteKennerLen:=StrLen(FileE5WriteKenner)
ClipKenner:="clip://"
ClipKennerLen:=StrLen(ClipKenner)
ClipE5WriteKenner:="clipE5Write?"
ClipE5WriteKennerLen:=StrLen(ClipE5WriteKenner)
IeExistKenner:="IeEx://"
IeExistKennerLen:=StrLen(IeExistKenner)
WinMgmtsKenner:="WiMg://"
WinMgmtsKennerLen:=StrLen(WinMgmtsKenner)
FilePatternKenner=FilP://
FilePatternKennerLen:=StrLen(FilePatternKenner)
HTTPSKenner=HTTPS://
HTTPKenner=HTTP://
HTTPKennerLen:=StrLen(HTTPKenner)
HTTPSKennerLen:=StrLen(HTTPSKenner)
SortKenner:="Sort?"
SortKennerLen:=StrLen(SortKenner)
LoopKenner:="Loop?"
LoopKennerLen:=StrLen(LoopKenner)
ViaTimerKenner:="ViaTimer_"
ViaTimerKennerLen:=StrLen(ViaTimerKenner)
OnEventKenner:="OnEvent?"
OnEventKennerLen:=StrLen(OnEventKenner)
ExplorerSelectedKenner:="ExSel://"
ExplorerSelectedKennerLen:=StrLen(ExplorerSelectedKenner)
WinTextKenner:="WinText?"
WinTextKennerLen:=StrLen(WinTextKenner)
2HtmlKenner:="2_HTML?"
2HtmlKennerLen:=StrLen(2HtmlKenner)
AlleInfosKenner:="AllInfo?"
AlleInfosKennerLen:=StrLen(AlleInfosKenner)
MirrorEdit5Kenner:="Mirr05?"
MirrorEdit5KennerLen:=StrLen(MirrorEdit5Kenner)
MirrorEdit8Kenner:="Mirr08?"
MirrorEdit8KennerLen:=StrLen(MirrorEdit8Kenner)
WitchWindowDefKenner:="WWinDef?"		; WWinDef? Fenstertitel,Fenstertext,Titelausnahme,Textausnahme
WitchWindowDefKennerLen:=StrLen(WitchWindowDefKenner)
WitchControlDefKenner:="WConDef?"		; WConDef? Control,Fenstertitel,Fenstertext,Titelausnahme,Textausnahme
WitchControlDefKennerLen:=StrLen(WitchControlDefKenner)
HtmlDiaShowKenner:="HtmDiaShow?"
HtmlDiaShowKennerLen:=StrLen(HtmlDiaShowKenner)
HtmlPathesBilderuebersichtKenner:="HtmPicView?"
HtmlPathesBilderuebersichtKennerLen:=StrLen(HtmlPathesBilderuebersichtKenner)
HtmlPathesOutKenner:="HtmPat?"
HtmlPathesOutKennerLen:=StrLen(HtmlPathesOutKenner)
WinAnWinKenner:="WinAnWin?"
WinAnWinKennerLen:=StrLen(WinAnWinKenner)
WinOverWinKEnner:="WinOverWin?"
WinOverWinKEnnerLen:=StrLen(WinOverWinKEnner)
OldDelNewKenner:="OldDelNew?"
OldDelNewKennerLen:=StrLen(OldDelNewKenner)

NegierBareKenner=
(
NrInhaltKenner
InInhaltKenner
InInhaltQuelleKenner
InRowKenner
NrRowKenner
NrRexKenner
InNameKenner
2ZeilenInhaltKenner
)
Loop,Parse,NegierBareKenner,`n,`r
{
	MinusKennerKommaListe .= "-" . %A_LoopField% ","
}
StringTrimRight,MinusKennerKommaListe,MinusKennerKommaListe,1
StringReplace,PlusKennerKommaListe,MinusKennerKommaListe,-,+,All
FuellLeerzeichen0:=""
FuellLeerzeichen1:="ᵕ"
FuellLeerzeichen2:="ᵕᵕ"
FuellLeerzeichen3:="ᵕᵕᵕ"
FuellLeerzeichen4:="ᵕᵕᵕᵕ"
FuellLeerzeichen5:="ᵕᵕᵕᵕᵕ"
FuellLeerzeichen6:="ᵕᵕᵕᵕᵕᵕ"
FuellLeerzeichen7:="ᵕᵕᵕᵕᵕᵕᵕ"
FuellLeerzeichen8:="ᵕᵕᵕᵕᵕᵕᵕᵕ"
FuellLeerzeichen9:="ᵕᵕᵕᵕᵕᵕᵕᵕᵕ"
FuellLeerzeichen10:="ᵕᵕᵕᵕᵕᵕᵕᵕᵕᵕ"
HalbOunten:="ᵕ"
StrukturenOrdnerPfad:=A_ScriptDir "\Strukturen"
NotWordPath=%A_AppData%\Zack\NotWordList.txt
; <ermittelt SystemVariablen>
EnvGet,SystemLaufwerk,SystemDrive
; <ermittelt ausfuehrbare DateiEndungen>
MacroDir:=A_AppData "\Zack\Macro"
MacroTimerOrEventStartedDir:=MacroDir "\TimerOrEventStarted"
; siehe Label: QuelltextObjektZeilen2Edit5
; file://%A_ScriptFullPath% Nr_Row? %SuchStringFuerObjektAnzeige%
; Folgender String muesste noch Verbesserungspotential haben
IstObjektWenn=.InsertAt(,.MaxIndex(,.RemoveAt(,.Push(,.Pop(,.Delete(,.MinIndex(,Length(,.SetCapacity(,.GetCapacity(,.GetAddress(,._NewEnum(,.HasKey(,.Clone(,ObjRawSet(,.Insert(,.Remove(,IsObject(,For ,[{}]
SuchStringFuerObjektAnzeige=
(
%IstObjektWenn%,{,[,(
%IstObjektWenn%,},],)
%IstObjektWenn%,:=,{},.
%IstObjektWenn%,:=,{},,,
%IstObjektWenn%,{,},[,],.
%IstObjektWenn%,{,},[,],,,
)
EnvGet,AusfuehrbareDotExtListe,Pathext
StringReplace,AusfuehrbareDotExtListe,AusfuehrbareDotExtListe,`;,`,,All
StringReplace,AusfuehrbareExtListe,AusfuehrbareDotExtListe,.,,All
IfNotExist %A_AppDataCommon%\Zack
	FileCreateDir, %A_AppDataCommon%\Zack		; Pfad fuer UnterSkripte Icons etc. und den Cache
ExternalToolTipPath:=A_AppDataCommon "\Zack\ExternalTooltip.ahk"
; </ermittelt ausfuehrbare DateiEndungen>		; die 2 Komma-getrennten Listen sind noch ohne Weiter-Verwendung.
; </ermittelt SystemVariablen>
;		< / ######################################### Konstanten ######################################## >
;}	
;{	############################################ vor Gui ###########################################
ExternalTooltip=
(
#SingleInstance off
Ue0=`%0`%
if not Ue0
	ExitApp
Ue1=`%1`%
if (Ue1="")
	ExitApp
Ue2=`%2`%
Ue3=`%3`%
Kord=`%4`%
CoordMode, ToolTip,`%Kord`%
Dauer=`%5`%
if (Dauer="")
	Dauer:=2500+StrLen(Ue1)*45

if (Ue2="FolgtMaus")
	FolgtMaus:=true
else
{
	if (Ue2<>"")
		x:=Ue2
	if (Ue3<>"")
		y:=Ue3
}
if Not FolgtMaus
	ToolTip,`%Ue1`%,x,y
	Last_TickCount:=A_TickCount
loop, 1000
{
	if((A_TickCount - Last_TickCount) > Dauer)
		break
	if FolgtMaus
		ToolTip,`%Ue1`%,x,y
	Sleep 9
	if(GetKeyState("ESc"))
		break
}
ExitApp
)
FileDelete %ExternalToolTipPath%
FileAppend ,%ExternalTooltip%,%ExternalToolTipPath%,utf-16
; Sleep 3000
RunOtherAhkScriptOrExe(ExternalToolTipPath,"Tooltip Test")

IfExist %A_ScriptDir%\ScitePath.txt
	FileRead,ScitePath,%A_ScriptDir%\ScitePath.txt		; Pfad zu Scite4AHK fuer Quelltexte
IfExist %A_ScriptDir%\NotepadPlusPlusPfad.txt
	FileRead,NotepadPlusPlusPfad,%A_ScriptDir%\NotepadPlusPlusPfad.txt		; Pfad zu NotepadPlusPlusPfad fuer Variablenvergleiche
AutoFavorit:=0
AnzeigeNichtAktualisieren:=false
if (GrossKlein="")
	GrossKlein:=GrossKleinDefault
if GrossKlein
	StringCaseSense, On
else
	StringCaseSense, Off
GrEdit2:=GrEdit11Default
NotWord := NotWordDefault 
; if(A_ScreenDPI<>96)
	DpiKorrektur:=A_ScreenDPI/96
MausGuenstigPositionieren:=MausGuenstigPositionierenDefault
GuiAnzeigeFortgeschritten:=GuiAnzeigeFortgeschrittenDefault
if(MenuKurzTasten="")
{
	if GuiAnzeigeFortgeschritten
		MenuKurzTasten:=true
	else
		MenuKurzTasten:=false	
}
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
MaxEditNumber:=12											; groesste verwendete Edit#
SpaeterKontainerAnzeigen:=false
WortVorschlaege:=true
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
	if(ZZO_Version<>ScripKlammerInhalt)
		RunOtherAhkScriptOrExe(ExternalToolTipPath,"Der DateiName Klammerinhalt`n	" A_ScriptName "`nstimmt nicht mit der Version `n	" ZZO_Version "`nueberein")
		; MsgBox, 262208, Version pflegen, Der DateiName Klammerinhalt`n	%A_ScriptName%`nstimmt nicht mit der Version `n	%ZZO_Version%`nueberein
}
StringReplace,ScriptNamneOhneKlammer,A_ScriptName,%ScriptKlammerMitInhalt%
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
IfExist %A_ScriptDir%\ExternalTooltip.exe
{
	IfNotExist  %A_AppDataCommon%\Zack\ExternalTooltip.exe
		FileCopy,%A_ScriptDir%\ExternalTooltip.exe, %A_AppDataCommon%\Zack\ExternalTooltip.exe
}
FileDelete,%A_AppDataCommon%\Zack\SchnellOrdner.txt
FileAppend,%A_ScriptFullPath%,%A_AppDataCommon%\Zack\SchnellOrdner.txt,utf-16
gosub GetDriveLists
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
		ProgExtDir:=A_AppDataCommon "\Zack\WuCont\Start Menu\ProgExt"
		IfNotExist %ProgExtDir%
		{
			IfExist %A_ScriptDir%\GetRegExt.ahk
			{
				IfExist %A_ScriptDir%\GetRegExt.exe
					Run "%A_ScriptDir%\GetRegExt.exe","A_ScriptDir"
				else
					Run "%A_ScriptDir%\GetRegExt.ahk","A_ScriptDir"
			}
		}

		LetzterSkriptDataPathI:=WurzelContainer "\Start Menu"
		LetzterSkriptDataPath:=WurzelContainer "\Start Menu"
	}
	FavoritenDirPath:=SkriptDataPath "\!Fav"	
	SpaeterKontainerAnzeigen:=true
}
SkriptDataPathKurzNachProgrammbeginn:=SkriptDataPath					; diese Variable bitte als Konstante ansehen und ab hier nicht mehr aendern. 
ExpAutoContainerListe=%SkriptDataPathKurzNachProgrammbeginn%,%WurzelContainer%\Start Menu
if ZackZackOrdnerLogErstellen
	ThreadUeberwachungLog(A_LineNumber-1,A_ThisHotkey,A_ThisLabel,A_ThisFunc,A_ThisMenu,A_ThisMenuItem,A_ThisMenuItemPos)
IndexierenBeenden:=0
OrdnerEingelesen:=False
Rekursiv=R	;	Pendant zum Flag Rekur, bei Rekur ist Wahr sollte Rekursiv gleich R sein
gosub WorteCacheBefuellen
TT:={}
;}	
;	;	; < #########################################    G  u  i    ######################################### >	@0155
;{	; < #########################################  Gui Elemente  ##################################### >	@0160
if(A_ScreenDPI=96)
	Gui,1:New,+HwndGuiWinHwnd -DPIScale
else
{
	Gui,1:New,+HwndGuiWinHwnd  ; -DPIScale
}
; SoundBeep 1200
TT[GuiWinHwnd]:="ZZO HauptFenster   Recht-Klick Suche ruecksetzen"
if ZackZackOrdnerLogErstellen
	ThreadUeberwachungLog(A_LineNumber-1,A_ThisHotkey,A_ThisLabel,A_ThisFunc,A_ThisMenu,A_ThisMenuItem,A_ThisMenuItemPos)
Gui,1:+Resize  ; AlwaysOnTop
Gui,1: Show, w510 h480, ZackZackOrdner
GuiHeight:=480
Gui,1: Add, Edit, 	x8 	y111 	w60 	h16 	HwndHwndEdit1	gEdit1 	vEdit1  -Tabstop 		r1	Right	 	, 	Anz
TT[HwndEdit1]:="Edit1: Anzahl gefundener Pfade"
Gui,1: Add,	Text,	x78		y113	w55 	h16 																	, %	lang("gefundene")
Gui,1: Add,	Text,	x0		y135 	w70		h32 																	,	ausgewaehlte`nPfad Nr.
Gui,1: Add,	Text,	x71		y125 	w25		h65 																	,	_┌─`n`n¯  \`n    ↓
Gui,1: Add,	Text,	x136	y113 	w30 	h16 																	, %	lang("Pfade")
Gui,1: Add,	Text,	x0		y75 	w93 	h32															Right		,	Ordner-`nNamen-Suche
Gui,1: Add, Edit, 	x98 	y78 	w390 	h20   	HwndHwndEdit2	gEdit2 	vEdit2 				 	r1				, 	Such
TT[HwndEdit2]:="Edit2: Such-Text	[F2]"
FuerEdit5UpDown:=1
Gui,1: Add, UpDown, vFuerEdit5UpDown gSuchverlaufAnzeigen  left  Range999999-1, 5
Gui,1: Add,	Text,	x98		y98 	w83 	h16 																	,	Suche vom
Gui,1: Add, Edit, 	x40 		y150 	w30 	h18 	HwndHwndEdit3	gEdit3 	vEdit3				-Wrap r1	Number 	, 	1
TT[HwndEdit3]:="Edit3: Der hier gewaehlte Pfad dient fuer die Weiter-Bearbeitung.   [F3]"
Gui,1: Add, Edit, 	x490 	y78 	w150 	h20 	HwndHwndEdit4	gEdit4 	vEdit4	-Tabstop	-Wrap		 	 	, 	Befehlsentgegennahme
TT[HwndEdit4]:="Edit4: Einzel-Befehls-Eingabe, mit . am Ende abschicken! z.B. StopComputer.   #[F2]"
Edit5Y0:=125		; immer ueber diese Variable Y von Edit5 eingeben sonst trifft GuiDropFiles nicht
Gui,1: Add, Edit, 	x141 	y%Edit5Y0% w350	h240  	HwndHwndEdit5	gEdit5 	vEdit5	-Tabstop	-Wrap 	0x100	 -VScroll  T15	HScroll, 	Ordner ; HScroll
TT[HwndEdit5]:="Edit5: gefundene Pfade / Zeilen / Objekte"
Gui,1: Add, UpDown, 	x122 	y%Edit5Y0% w8	h240	HwndHwndEdit5UpDown							vEdit5UpDown  gEdit5UpDown  -16 Range999999-1, 1
Gui,1: Add,	Text,	x239	y98 	w82 	h16 																	,	 Abbruch nach
Gui,1: Add, Edit, 	x309 	y96 	w70		h24  	HwndHwndEdit6	gEdit6 	vEdit6				-Wrap r1	Number 	, 	25
TT[HwndEdit6]:="Edit6: Suche abbrechen. Hohe Zahl -> spaeter Abbruch"
Gui,1: Add,	Text,	x351	y98 	w55 	h16 																	,	 Iterationen.
GuiControl,1:, Edit6, 25
Gui,1: Add, CheckBox,	x0 	y68 	w55 	h14 	HwndHwndEvalButton1Only	gEvalButton1Only vEvalButton1Only	-Tabstop			Left	, 	 % lang("warte")		; Checked
TT[HwndEvalButton1Only]:="Such-Auswertung wartet auf Button1"
Gui,1: Add, CheckBox, x425 	y108	w95 	h15 	HwndHwndCheckA0	gbeschaeftigt		vbeschaeftigt	-Tabstop				, % lang("beschaeftigt")
Gui,1: Add, CheckBox, x156 	y98	w80 	h15 	HwndHwndCheckA5	gWoAn	vWoAn	-Tabstop						, 	WortAnfang,
Gui,1: Add, CheckBox,	x302 	y62 	w90 	h14 	HwndHwndCheckB8	gExpSel vExpSel	-Tabstop			Right	, 	Selektiert		; Checked
ExpSel:=false
GuiControl,1:, ExpSel, %ExpSel%
Gui,1: Add,	Text,	x0		y184 	w90 	h16 																	,	Pfad-Filter
Gui,1: Add, CheckBox, x0 		y222 	w60 	h16 	HwndHwndCheckE0	gSuFi	vSuFi	-Tabstop						, 	Filter
HwndSuFi:=HwndCheckE0
Gui,1: Add,	Text,	x0		y243 	w90 	h16 																	,	Fenster
Gui,1: Add, CheckBox, x47 	y222 	w55 	h16 	HwndHwndCheckE5	gRegEx	vRegEx	-Tabstop						, 	RegEx
Gui,1: Add, Edit, 	x0 		y200 	w90 	h16 	HwndHwndEdit7	gEdit7 	vEdit7	-Tabstop 	-Wrap r1 			, 	Filter
TT[HwndEdit7]:="Edit7: Pfad-Filter fuer die Cache-Suche   #[F3]`n`,	ODER-Trenner`n``n	UND-Trenner"
Gui,1: Add, Edit, 	x0 		y4000 		w510	h16 	HwndHwndEdit8 	gEdit8 	vEdit8	-Tabstop 	-Wrap r1 0x100	Center 	, 	EinzelErg		; Right
TT[HwndEdit8]:="Edit8: Weiter-BearbeitungsPfad."
Dummy:=16/DpiKorrektur
Dummy2:=24 + 8/DpiKorrektur
Gui,1: Add, ActiveX, w4510 h%Dummy2% x0 y-%Dummy% vdoc, HTMLFile

WiWa:=false
Gui,1: Add, CheckBox, x0 		y236 	w65 	h20 	HwndHwndCheckE9	gAuAb	vAuAb	-Tabstop						, 	AutoAbbr
GuiControl,1:Hide,AuAb
Gui,1: Add, Edit, 	x62		y235 	w30 	h16 	HwndHwndEdit9	gEdit9	vEdit9	-Tabstop	r1			Number	, 	4
GuiControl,1:Hide,Edit9
Gui,1: Add, CheckBox, x0 		y256 	w35 	h20 	HwndHwndCheckG0	gOnTop	vOnTop	-Tabstop						, 	To				; Top (Top -> Min)
Gui,1: Add, CheckBox, x42 	y256 	w35 	h20 	HwndHwndCheckG3	gAkt	vAkt	-Tabstop	Checked				, 	Ak				; Akt (Akt+Min -> Min; Akt+Top -> Min Akt -> Bottom ; Nichts -> lassen)		Top or Min -> Min    +Akt -Top -Min -> Bottom    -Top -Akt -Min -> lassen
Gui,1: Add, Edit, 	x122 	y450 	w390 	h20   	HwndHwndEdit10	gEdit10 	vEdit10 				 	r1		, 	%Edit10Default%
GuiControl,1:, %HwndHwndCheckG3%, 1
Gui,1: Add,	Text,	x0		y314 	w90 	h16 																	,	Pfade einlesen
Gui,1: Add, CheckBox, x0 		y326 	w90 	h20 	HwndHwndCheckI0	gRekursiv	vRekur 	-Tabstop	Checked			, 	Rekursiv
Gui,1: Add,	Text,	x0		y350 	w90 	h32																	,	Anzeige im`nFeld rechts
Gui,1: Add, CheckBox, x0 		y376 	w90 	h32 	HwndHwndCheckK5	gIeAnz vIeAnz	-Tabstop						, 	zeige Inhalte √`noder Pfade
Gui,1: Add, Button,	x0 		y19		w90 	h50 	HwndHwndButton1	gButton1		-Tabstop			 			, 	aktualisieren
TT[HwndButton1]:="Button1: Suche aktualisieren   [F5]"
Gui,1: Add, Button, 	x102 	y19 	w90 	h40 	HwndHwndButton2	gButton2  	 									,  	-> &I
TT[HwndButton2]:="Button2: gefundenen Pfad (Edit8) dem Speichern ... Dialog uebergeben   [F6]"
Gui,1: Add, Button, 	x202 	y19 	w90 	h40 	HwndHwndButton3	gButton3										, 	└> &Clip
TT[HwndButton3]:="Button3: schreibt Edit8 ins Clipboard    Edit5 bei weiterem Klick"
Gui,1: Add, Button, 	x302 	y19 	w90 	h40 	HwndHwndButton4	gButton4					Default				,	Explorer ; (Enter)	; vorzugsweise Default-Button
TT[HwndButton4]:="Button4: uebergibt Edit8 an den Explorer   [F8]"
Gui,1: Add, Button, 	x402 	y19	 	w90 	h40 	HwndHwndButton5	gButton5		-Tabstop						, 	Copy`nMove
TT[HwndButton5]:="Button5: kopiert / verschiebt Pfade im Clipboard nach Edit8   [F9]"
Gui,1: Add, Edit, 	x130 	y58 	w80 	h20   	HwndHwndEdit11	gEdit11 	vEdit11 				 	r1				, 	%Edit11%
TT[HwndEdit11]:="Edit11: Pfad-Muster fuer die Live-Suche   [F11]"
GuiControl, Hide,%HwndEdit11%
Gui,1: Add, Edit, 	x395 	y58 	w80 	h20   	HwndHwndEdit12	gEdit12 	vEdit12 				 	r1				, 	%Edit11%
TT[HwndEdit12]:="Edit12: End-Filter fuer die Live-Suche   [F12]`n`,	ODER-Trenner`n``n	UND-Trenner"
GuiControl, Hide,%HwndEdit12%
; MouseMove,56*DpiKorrektur, 445*DpiKorrektur			; eigentlich unnoetig, Wartezeit damit der Folgebefehl klappt
sleep 200
; PixelGetColor,GuiHintergrundFarbe, 10*DpiKorrektur, 240*DpiKorrektur,RGB
; MsgBox % GuiHintergrundFarbe



ZzoHauptFensterHwndPfad:=% A_AppDataCommon "\Zack\ZzoHauptFensterHwnd.txt"
ZzoHauptFensterButton1HwndPfad:=% A_AppDataCommon "\Zack\ZzoHauptFensterButton1Hwnd.txt"
/*
IfExist % ZzoHauptFensterHwndPfad
{
	FileRead,OldGuiWinHwnd ,% ZzoHauptFensterHwndPfad
	IfWinExist, ahk_id %OldGuiWinHwnd%
	{
		Ue0=%0%
		if not Ue0
		{
			MsgBox, 262180, %A_LineNumber%, Es gibt noch ein ZZO-Fenster`, erzeugt von %A_ScriptFullPath%`nSoll versucht werden es zu schliessen?
			IfMsgBox, Yes
			{
				WinClose, ahk_id %OldGuiWinHwnd%
				WinWaitClose, ahk_id %OldGuiWinHwnd%,,5
				IfWinExist, ahk_id %OldGuiWinHwnd%
					MsgBox %A_LineNumber%	Das ZZO-Fenster`, erzeugt von %A_ScriptFullPath%`, konnte nicht geschlossen werden!
				else
				{
					FileDelete,%ZzoHauptFensterHwndPfad%
					FileAppend,% GuiWinHwnd,% ZzoHauptFensterHwndPfad
				}
			}
		}
	}
	else
	{
		FileDelete,%ZzoHauptFensterHwndPfad%
		FileDelete,%ZzoHauptFensterButton1HwndPfad%
		FileAppend,% GuiWinHwnd,% ZzoHauptFensterHwndPfad
	}
}
else
	FileAppend,% GuiWinHwnd,% ZzoHauptFensterHwndPfad
*/
FileDelete,%ZzoHauptFensterHwndPfad%
FileAppend,% GuiWinHwnd,% ZzoHauptFensterHwndPfad

FileDelete,%ZzoHauptFensterButton1HwndPfad%
FileAppend,%GuiWinHwnd%	%HwndButton1%	%A_Now%`r`n,	%ZzoHauptFensterButton1HwndPfad%
; goto WbTest ; noch nicht ; noch nicht ; noch nicht ; noch nicht ; noch nicht ; noch nicht ; noch nicht ; noch nicht ; noch nicht ; noch nicht ; noch nicht ; noch nicht ; noch nicht ; noch nicht ; noch nicht ; noch nicht ; noch nicht ; noch nicht ; noch nicht


Loop, 10
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
ButtonHoechsteNr:=ButtonIndex

; gosub WbTest


Gui,1: Add, ActiveX, x141 	y%Edit5Y0% w350	h240 HWNDHwndIe1 vWB gWB, Shell.Explorer  ; Der letzte Parameter ist der Name der ActiveX-Komponente. https://msdn.microsoft.com/de-de/library/windows/desktop/bb774094(v=vs.85).aspx 

ComObjConnect(WB, WB_events) 
class WB_events
{
    NavigateComplete2(wb, NewURL)
    {
		global PfadVomInternenExlorer,PfadVomInternenExlorerGesetzt,Edit8
        ; GuiControl,, URL, %NewURL%  ; URL-Eingabefeld aktualisieren.
		PfadVomInternenExlorer:= NewURL
		PfadVomInternenExlorerGesetzt:=true
		Edit8:= NewURL
		gosub Edit8Festigen
		Sleep 100
		; Edit8:=Explorer_GetSelected()
		; ListLines
		PfadVomInternenExlorerGesetzt:=false

    }
}
; InternalExplorer:=WB.Windows
; SelectedItems:=WB.Windows.Document.SelectedItems
; gosub WbTest

gosub IeControl

if ZackZackOrdnerLogErstellen
	ThreadUeberwachungLog(A_LineNumber-1,A_ThisHotkey,A_ThisLabel,A_ThisFunc,A_ThisMenu,A_ThisMenuItem,A_ThisMenuItemPos)
;}	; < / ########################################  Gui Elemente  ##################################### >
;{	; < ######################################### Fenster-Menue ##################################### >	@0170
;{	Dateimenü
mj:=1
Menu, Dateimenü, 		Add, % "Reload	&"	Integer3Hex(mj)						, NeuStarten
++mj
Menu, Dateimenü, 		Add, % lang("Skript-Ordner anzeigen") "	&"	Integer3Hex(mj)		, SkriptOrdnerOeffnen	
++mj
Menu, Dateimenü, 		Add, % lang("Data-Common-Ordner anzeigen") "		&"	Integer3Hex(mj)		, DataCommonOrdnerOeffnen	
++mj
Menu, Dateimenü, 		Add, % lang("Data-Ordner anzeigen") "		&"	Integer3Hex(mj)		, DataOrdnerOeffnen	
++mj
Menu, Dateimenü, 		Add, % lang("Testumgebung erzeugen") "	&"	Integer3Hex(mj)		, TestumgebungErzeugen	
++mj
Menu, Dateimenü, 		Add, % lang("Schleifen abbrechen") "		&"	Integer3Hex(mj)	#Esc, AllesAbbrechen
++mj
Menu, Dateimenü, 		Add, % lang("Beenden") "					&"	Integer3Hex(mj)		, GuiClose
;}	
;{	Edit8menue
mj:=1
Menu, Edit8menue, 		Add, % "Edit8 " lang("oeffnen") "		&"					Integer3Hex(mj)		, Edit8Oeffnen
++mj
Menu, Edit8menue, 		Add, % "Edit8 " lang("oeffnen") A_Space lang("mit")  A_Space lang("Schnellwahl") "	&"		Integer3Hex(mj)		, Edit8ToOeffnenMitSchnellwahl
++mj
Menu, Edit8menue, 		Add, % "Edit8 " lang("oeffnen") A_Space lang("mit") "..." "	&"				Integer3Hex(mj)		, Edit8OeffnenMit
++mj
Menu, Edit8menue, 		Add, % "Edit8 -> " lang("oeffnen") A_Space lang("mit") A_Space lang("Speicher") "	&"		Integer3Hex(mj)	 	, Edit8ToOeffnenSpeicher
Menu, Edit8menue, 		Add
++mj
Menu, Edit8menue, 		Add, % lang("Zeige") A_Space lang("Inhalt") A_Space lang("als") A_Space lang("QuellText") "	&"			Integer3Hex(mj)		, Edit8QuellTextAnzeigen
++mj
Menu, Edit8Menue, 		Add, % lang("Zeige") A_Space lang("Pfade") A_Space lang("des Ordners") " (" lang("Live-Suche") ") 	&"	Integer3Hex(mj)	, ImOrdnerSuchen  
++mj
Menu, Edit8Menue, 		Add, % lang("Zeige") A_Space lang("Such-Text-Zeilen mit Pfaden") A_Space lang("des Ordners") "  	&"	Integer3Hex(mj)	, ImOrdnerTextSuchen  
Menu, Edit8menue, 		Add
++mj
Menu, Edit8Menue, 		Add, % lang("Zeige") A_Space lang("Inhalt") A_Space lang("als") A_Space lang("Text in Edit5") "	&"		Integer3Hex(mj)		, Edit82Edit2
++mj
Menu, Edit8Menue, 		Add, % lang("Zeige") A_Space lang("Inhalt") A_Space lang("im internen Explorer") "	&"	Integer3Hex(mj)		, Edit8ExplorerEingebunden
Menu, Edit8menue, 		Add
++mj
Menu, Edit8Menue, 		Add, % lang("neuer")  A_Space lang("Ordner") "	&"						Integer3Hex(mj)		, Edit8NeuerOrdnerMitRueckFrage
++mj
Menu, Edit8Menue, 		Add, % lang("zeige temporaer")  A_Space lang(" Unter-DrueberOrdner") "	&"			Integer3Hex(mj)		, Edit8ZeigeVorfahrenUndUnterordner
++mj
Menu, Edit8Menue, 		Add, % lang("Edit8 -> Explorer") "	&"							Integer3Hex(mj)		, Edit8Explorer
++mj
Menu, Edit8Menue, 		Add, % lang("Edit8 -> Explorer")  A_Space lang("Select (GetFather)") "		&"		Integer3Hex(mj)		, Edit8ExplorerSelect
++mj
Menu, Edit8Menue, 		Add, % lang("DirName -> Edit2") "	&"					Integer3Hex(mj)		, DirName2Edit2
++mj
Menu, Edit8Menue, 		Add, % lang("FatherName -> Edit2") "		&"			Integer3Hex(mj)		, FatherName2Edit2
++mj
Menu, Edit8Menue, 		Add, % lang("umbenennen") "		&g"							, Edit8Umbenennen
++mj
Menu, Edit8Menue, 		Add, % lang("Diashow") "			&h"										, DiashowImIe
++mj
Menu, Edit8Menue, 		Add, % lang("DateiSuche") "		&i"											, DateiSucheAusgehendVonEdit8
Menu, Edit8Menue, 		Add, % lang("nur Edit8 Anzeige bei Rechts-Klick") "		&j"											, Edit8Festigen
;}	
;{	Pfademenue
mj:=1
; Menu, Edit5Menue, 		Add, zeige Ofad-menu	, ZeigePfadMenu
Menu, Edit5Menue, 		Add, % lang("sortiere")  A_Space lang("Edit5-Zeilen") A_Space lang("kurz") A_Space lang("oben") "	&"	Integer3Hex(mj)		, SortLenAlle
Menu, Edit5Menue, 		Add, % lang("sortiere")  A_Space lang("Edit5-Zeilen") A_Space lang("Aenderungsdatum")  "	&"	Integer3Hex(mj)		, SortMTimeAlle
++mj
Menu, Edit5Menue, 		Add, % lang("sortiere")  A_Space lang("Beste Uebereinstimmung") A_Space lang("oben") "	&"	Integer3Hex(mj)		, SortBestAutoBewertung
++mj
Menu, Edit5Menue, 		Add, % lang("           dabei diese Worte nach ") A_Space lang("oben") A_Space lang("/") A_Space lang("unten") "	&"	Integer3Hex(mj)		, SortBestAutoBewertungNotWordList
; Menu, Edit5Menue, 		Add, Clipboard 2 Text			, ClipboardMenuHandler1 ; reicht im #V-Menu
++mj
Menu, Edit5Menue, 		Add, % lang("Edit5-") A_Space lang("Pfade") A_Space lang(" -> Clipboard") "	&"			Integer3Hex(mj)			, Button3Zweimal
++mj
Menu, Edit5Menue, 		Add, % lang("Clipboard -> Edit5-") lang("Pfade") "	&"			Integer3Hex(mj)			, Clipboard2Edit5
++mj
Menu, Edit5Menue, 		Add, % lang("Inhalt") lang("(Edit8) -> Edit5-")   lang("Pfade") "	&"		Integer3Hex(mj)			, InhaltVonEdit82Edit5
++mj
Menu, Edit5Menue, 		Add, % lang("sortiere")  A_Space lang("Clip-Zeilen nach Ordner-/Datei-Name") "	&"	Integer3Hex(mj)		, ClipboardMenuHandler7
++mj
Menu, Edit5Menue, 		Add, % lang("sortiere")  A_Space lang("Clip-Zeilen") " 	&"				Integer3Hex(mj)			, ClipboardMenuHandler6
++mj
Menu, Edit5Menue, 		Add, % lang("Clipboard")  A_Space lang("anzeigen") lang(" / 2 Text / ") lang("editieren") "	&"	Integer3Hex(mj)			, ClipboardMenuHandler10
++mj
Menu, Edit5Menue,		Add, % lang("Kopiere") " Clippboard-" lang("Pfade") A_Space lang(" 2 Edit8-") A_Space lang("Pfad") "	&"	Integer3Hex(mj)		, Button5
++mj
; Menu, Edit5Menue,		Add, starte Clippboard-Einzel-Pfad	, ClipboardMenuHandler8
Menu, Edit5Menue,		Add, % lang("starte")  A_Space lang("Clippboard-") A_Space lang("Pfade")  A_Space lang("mit") " Edit8" "	&"	Integer3Hex(mj)			, StarteClipboardPfadeMitEdit8
++mj
Menu, Edit5Menue,		Add
Menu, Edit5Menue, 		Add, % lang("Edit5-") lang("Pfade") " ->" A_Space lang("DateiSuche") " 	&"			Integer3Hex(mj)			, DateiSucheAusgehendVonEdit5	; Das Zeichen = im Pfad wird von SucheDateien nicht verdaut! ToDo
++mj
Menu, Edit5Menue, 		Add, % lang("Clipboard-") lang("Pfade") " -> " A_Space lang("DateiSuche") " 	&"		Integer3Hex(mj)		, DateiSucheAusgehendVomClipboard	; = im Pfad wird von SucheDateien nicht verdaut! ToDo
;}	
;{	FilterMenue
mj:=1
; Menu, FilterMenue, 	Add, DirektSuche					, DirektSuche 	; wegen ImOrdnerSuchen deaktiviert 
Menu, FilterMenue, 	Add,  % lang("CacheSuche") "	&"						Integer3Hex(mj)				, CacheSuche  
++mj
Menu, FilterMenue, 	Add,  % lang("Im Ordner direkt suchen") "	&"		Integer3Hex(mj)				, ImOrdnerSuchen  
++mj
Menu, FilterMenue, 	Add,  % lang("Suchassistent Live-Suche") "	&"		Integer3Hex(mj)				, SuchassistentLiveSucheQuelle  

Menu, FilterMenue, 	Add 
++mj
Menu, FilterMenue, 	Add,  % lang("Suchverlauf aus Ansicht verschieben") "	&"			Integer3Hex(mj)				, SuchverlaufLoeschen  

Menu, FilterMenue, 	Add 
++mj
Menu, FilterMenue, 	Add,  % lang("Agezeigte Suche restaurieren") "	&"	Integer3Hex(mj)				, GetAngezeigteSuche  
++mj
Menu, FilterMenue, 	Add,  % lang("Aktuelle Live Suche 2 LnkMacro") "	&"	Integer3Hex(mj)				, AktuelleLiveSuche2Lnk  
++mj
Menu, FilterMenue, 	Add,  % lang("Suchverlauf anzeigen") "	&"			Integer3Hex(mj)				, SuchverlaufAnzeigen  
Menu, FilterMenue, 	Add,  % lang("Suchverlaeufe anzeigen") "	&"			Integer3Hex(mj)				, SuchverlaeufeAnzeigen  
;}	
;{	StukturenMenue
mj:=1
Menu, StukturenMenue, 	Add,  % lang("Stuktur-Vorlage Assistent") "	&"	Integer3Hex(mj)				, StrukturVorlageAssistent  
++mj
Menu, StukturenMenue, 	Add,  % lang("Stuktur bei Edit8 erzeugen") "	&"	Integer3Hex(mj)				, ManuelleStrukturauswahl  
++mj
Menu, StukturenMenue, 	Add,  % lang("Stukturen anzeigen") "		&"		Integer3Hex(mj)				, StukturenAnzeigen  
++mj
Menu, StukturenMenue, 	Add,  % lang("Inhalte zum Vater Ordner vor loeschen") "		&"	Integer3Hex(mj)	, mInhaltzumVaterOrdnerLoeschen  
;}	
;{	ContainerMenue
mj:=1
Menu, ContainerMenue, 	Add,  % lang("Container-Schnell-Wahl") "	&"		Integer3Hex(mj)				, ContainerSchnellWahl  
++mj
Menu, ContainerMenue, 	Add,  % lang("(Angezeigten) oeffnen") "		&"	Integer3Hex(mj)				, WurzelContainerOeffnen  
++mj
Menu, ContainerMenue, 	Add,  % "↑↓ " lang("Letzten oeffnen") "	`tF4	&"	Integer3Hex(mj)				, LetzterContainer  
++mj
Menu, ContainerMenue, 	Add,  % lang("erstellen") " ...	&"				Integer3Hex(mj)				, ContainerAnlegen  
++mj
Menu, ContainerMenue, 	Add,  % lang("loeschen") " ...	&"				Integer3Hex(mj)				, ContainerLoeschen  
++mj
Menu, ContainerMenue,	Add,  % lang("Alle loeschen") " ...		&"		Integer3Hex(mj)				, DelCache
++mj
Menu, ContainerMenue,	Add,  % lang("Uebersicht anzeigen") " 	&"		Integer3Hex(mj)				, ContainerUebersichtZeigen
Menu, ContainerMenue,	Add
++mj
Menu, ContainerMenue,	Add,  % lang("Cache-Struktur anzeigen") " 	&"	Integer3Hex(mj)				, ContStaAnz
;}	
;{	StartPfadMenue
mj:=1
Menu, StartPfadMenue, 	Add,  % lang("Start-Pfad-Schnell-Filter") "	&"	Integer3Hex(mj)				, StartPfadSchnellFilter  ; Siehe untere Bemerkungen zu Ctrl+F.
++mj
Menu, StartPfadMenue, 	Add,  % lang("von Datei einlesen") " ...	&"		Integer3Hex(mj)				, WurzelVonDateiHinzuFuegen  ; Siehe untere Bemerkungen zu Ctrl+F.
++mj
Menu, StartPfadMenue, 	Add,  % lang("einlesen") " ...			&"		Integer3Hex(mj)				, WurzelHinzuFuegen  ; Siehe untere Bemerkungen zu Ctrl+F.
++mj
Menu, StartPfadMenue, 	Add,  % lang("Angezeigten aktualisieren") " ...   (" lang("einzeln") ")			&"	Integer3Hex(mj)	, WurzelAktualisieren ; 
++mj
Menu, StartPfadMenue, 	Add,  % lang("aktualisieren") "    (Container)			&"	Integer3Hex(mj)				, WurzelnAktualisieren ; 
++mj
Menu, StartPfadMenue, 	Add,  % lang("Loeschen") " ...				&"				Integer3Hex(mj)				, WurzelLoeschen  ; 
++mj
Menu, StartPfadMenue, 	Add,  % lang("Uebersicht anzeigen") "			&"		Integer3Hex(mj)				, StartPfadeUebersicht  ; 
;}	
;{	FavoritenMenue
mj:=1
Menu, FavMenue, 		Add,  % lang("speichern") " ...	&"				Integer3Hex(mj)				, FavoritSpeichern
++mj
Menu, FavMenue, 		Add,  % lang("oeffnen") " (" lang("restaurieren") ") ...	&"	Integer3Hex(mj)				, FavoritOeffnen
++mj
Menu, FavMenue, 		Add,  % lang("suchen") " 	&"						Integer3Hex(mj)				, SucheFavInhalte
++mj
Menu, FavMenue, 		Add,  % lang("plus") " *	&"						Integer3Hex(mj)				, PlusStern
++mj
Menu, FavMenue, 		Add,  % lang("minus") " *	&"					Integer3Hex(mj)				, MinusStern
++mj
Menu, FavMenue, 		Add,  % lang("Sternlose loeschen") "	&"			Integer3Hex(mj)				, SternLoseFavoritenLoeschen
++mj
Menu, FavMenue, 		Add,  % "AutoFavorit=" AutoFavorit	"	&"		Integer3Hex(mj)		, AutoFavoritEingeben
++mj
Menu, FavMenue, 		Add,  % lang("Ordner oeffnen") "	&"	Integer3Hex(mj)						, FavoritenOrdnerOeffnen
; Menu, FavMenue, 		Add, &Zeige temp Pos in Ordner-Struktur	, Edit8ZeigeVorfahrenUndUnterordner ; entnommen wegen zu vieler Eintraege
++mj
Menu, FavMenue, 		Add,  % lang("Fav-Vorschlag generieren") " ...	&"	Integer3Hex(mj)			, FavoritenVorschlagErzeuegen
++mj
Menu, FavMenue, 		Add
++mj
Menu, FavMenue, 		Add,  % lang("plus * Clip-Pfade") "		&"		Integer3Hex(mj)				, PlusSternClipPfade
++mj
Menu, FavMenue, 		Add,  % lang("minus * Clip-Pfade") "		&"		Integer3Hex(mj)				, MinusSternClipPfade
++mj
Menu, FavMenue, 		Add,  % lang("Loeschen * Clip-Pfade") "	&"		Integer3Hex(mj)				, LoeschenSternClipPfade
++mj
Menu, FavMenue, 		Add
++mj
Menu, FavMenue, 		Add,  % lang("plus") " * " lang("manuell") " ...	&"		Integer3Hex(mj)				, PlusSternManuell
++mj
Menu, FavMenue, 		Add
SuperFavoritenDateiAlterPfad=%WurzelContainer%\SuperFavoriten\!Fav\SuperFavoriten.txt
SuperFavoritenDateiPfad=%A_AppData%\Zack\SuperFavoriten.txt
IfExist %SuperFavoritenDateiPfad%
{
	Menu, FavMenue, 		Add, % "SuperFavoriten ♥ bearbeiten	&"		Integer3Hex(mj)		, SuperFaVoritenAnlegenBearbeiten
}
else
{
	IfExist %SuperFavoritenDateiAlterPfad%
		FileCopy,%SuperFavoritenDateiAlterPfad%,%SuperFavoritenDateiPfad%
	; MsgBox %ErrorLevel%	%SuperFavoritenDateiAlterPfad%	%SuperFavoritenDateiPfad%
	++mj
	Menu, FavMenue, 	Add,   % "SuperFavoriten ♥ anlegen / bearbeiten&"		Integer3Hex(mj)	, SuperFaVoritenAnlegenBearbeiten
}
;}	
;{	MacroMenue
mj:=1
Menu, MacroMenue, 		Add, % lang("Ordner oeffnen") "	&"		Integer3Hex(mj)				, StaOrdnerBefehlsDateiPfadOeffnen
++mj
Menu, MacroMenue, 		Add, % lang("Starten") "...	&"		Integer3Hex(mj)					, UserSelBefehlsDateiPfadAusfuehren
++mj
Menu, MacroMenue, 		Add, % lang("Starten im DebugModus") "	&"		Integer3Hex(mj)			, UserSelBefehlsDateiPfadAusfuehrenDebug
++mj
Menu, MacroMenue, 		Add, % lang("nochmals starten") "		&"		Integer3Hex(mj)			, BefehlsVariableNochmalsAusfuehren 
++mj
Menu, MacroMenue, 		Add, % lang("Muster-Dateien") " ...	&"		Integer3Hex(mj)				, MusterDateienErzeugen
++mj
Menu, MacroMenue, 		Add, % lang("Befehls-Liste") "	&"		Integer3Hex(mj)					, ListLabels
++mj
Menu, MacroMenue, 		Add, % lang("(Edit8) LnkMacro starten") "	&"		Integer3Hex(mj)			, DoEdit8LnkMacro
;}	
;{	OptionsMenue
mj:=1
Menu, OptionsMenue, 	Add, % lang("Sitzungs-Einst. speichern") "	&"		Integer3Hex(mj)					, SitzungsEinstellungenMerken
++mj
Menu, OptionsMenue, 	Add, % lang("Sitzungs-Einst. einlesen") "	&"		Integer3Hex(mj)					, SitzungsEinstellungenEinlesen
++mj
Menu, OptionsMenue, 	Add, % lang("Sitzungs-Einst. bearbeiten") "	&"		Integer3Hex(mj)				, SitzungsEinstellungenBearbeiten
++mj
Menu, OptionsMenue, 	Add, % lang("Modus: ClipBoard-Anzeige") "	&"		Integer3Hex(mj)				, GetClipboardAnzeigeNewP
++mj
Menu, OptionsMenue, 	Add, % lang("Modus: Explorer Details") "	&"		Integer3Hex(mj)				, GetExplorerSelectDetailsNewP
++mj
Menu, OptionsMenue, 	Add, % lang("Modus: Explorer Details mit Bilder") "	&"		Integer3Hex(mj)				, GetExplorerSelectDetailsPicNewP
++mj
Menu, OptionsMenue, 	Add, % lang("Suche ruecksetzen") "	&"				Integer3Hex(mj)				, ResetAllNocontainer
IfExist %A_ScriptDir%\AktualisiereZackZackOrdner.ahk
{
++mj
	Menu, OptionsMenue, 	Add, % lang("ZZO Neueste Version holen") "	&"	Integer3Hex(mj)					, ZZOAktualisieren
}
++mj
Menu, OptionsMenue, 	Add, % lang("Anfaenger/Fortgeschrittener") " ...	&"				Integer3Hex(mj)					, Einstellungen
;}	
;{	Hilfsmenü
mj:=1
Menu, Hilfsmenü, 		Add, % lang("Verlangsamte Demo") "		&"			Integer3Hex(mj)			, LangsamDemoToggle
++mj
Menu, Hilfsmenü, 		Add, % lang("Info") "		&"						Integer3Hex(mj)						, Info
++mj
Menu, Hilfsmenü, 		Add, % lang("Hilfe") "			&"					Integer3Hex(mj)					, Hilfe
++mj
Menu, Hilfsmenü, 		Add, % lang("Hilfe-Dateien") "		&"				Integer3Hex(mj)				, HilfeDateien
++mj
Menu, Hilfsmenü, 		Add, % lang("Globale Variablen") " -> Notepad++		&"	Integer3Hex(mj)	, LVPP
++mj
Menu, Hilfsmenü, 		Add, 
++mj
Menu, Hilfsmenü, 		Add, % lang("QuellText anzeigen") "		&"			Integer3Hex(mj)			, QuellTextAnzeigen
++mj
Menu, Hilfsmenü, 		Add, % lang("Varablen anzeigen") "		&"			Integer3Hex(mj)			, VariablenAnzeigen
++mj
Menu, Hilfsmenü, 		Add, % lang("Inhaltsverzeichnis anzeigen") "	&"		Integer3Hex(mj)				, QuellTextAnzeigenInhaltsverzeichnis
++mj
Menu, Hilfsmenü, 		Add, % lang("Unterprogramme anzeigen") "	&"			Integer3Hex(mj)				, QuellTextAnzeigenLabels
++mj
Menu, Hilfsmenü, 		Add, % lang("Funktionen anzeigen") "	&"				Integer3Hex(mj)				, QuellTextAnzeigenFunctions
++mj
Menu, Hilfsmenü, 		Add, % lang("HotKeys anzeigen") "	&"				Integer3Hex(mj)				, QuellTextAnzeigenHotkeys
++mj
Menu, Hilfsmenü, 		Add, % lang("Uebersetzungen anzeigen") "	&"				Integer3Hex(mj)				, UebersetzungEnAnzeigen
;}	
Loop, % ButtonHoechsteNr
	Menu, ButtonMenu, 		Add, % "&"				Integer3Hex(A_Index)				, Button%A_Index%
; ---------------------------------------------------------------------------------
;{	HauptMenue-Spalten
mi :=97
if MenuKurzTasten
{
	Menu, MeineMenüleiste,	Add, % "&"			Chr(mi)					, 	:ButtonMenu  ; wie Klick auf Button#
	++mi
}
Menu, MeineMenüleiste,	Add, % lang("Datei")			MenuKurzTaste(mi)					, 	:Dateimenü  ; Fügt die oben erstellten Untermenüs hinzu.
++mi
Menu, MeineMenüleiste,	Add, % "Edit8"			MenuKurzTaste(mi)					, 	:Edit8menue  ; Fügt die oben erstellten Untermenüs hinzu.
++mi
Menu, MeineMenüleiste,	Add, % lang("Pfade")			MenuKurzTaste(mi)					, 	:Edit5menue  ; Fügt die oben erstellten Untermenüs hinzu.
++mi
Menu, MeineMenüleiste,	Add, % lang("Filter")			MenuKurzTaste(mi)					, 	:Filtermenue  ; Fügt die oben erstellten Untermenüs hinzu.
++mi
Menu, MeineMenüleiste,	Add, % lang("Strukturen")		MenuKurzTaste(mi)					, 	:StukturenMenue  ; Fügt die oben erstellten Untermenüs hinzu.
; ++mi
Menu, MeineMenüleiste,	Add, %A_Space%%A_Space%↑									,	ContainerPrev
++mi
Menu, MeineMenüleiste,	Add, % lang("Container")		MenuKurzTaste(mi)					, 	:ContainerMenue
; ++mi
Menu, MeineMenüleiste,	Add, ↓%A_Space%%A_Space%									, 	ContainerNext
; ++mi
Menu, MeineMenüleiste,	Add, %A_Space%%A_Space%&↑									, 	NurLastStartPfad
++mi
Menu, MeineMenüleiste,	Add, % lang("Start-Pfad")		MenuKurzTaste(mi)					, 	:StartPfadMenue
; ++mi
Menu, MeineMenüleiste,	Add, &↓%A_Space%%A_Space%									, 	NurNextStartPfad
++mi
Menu, MeineMenüleiste,	Add, % lang("Favoriten")		MenuKurzTaste(mi)					, 	:FavMenue
++mi
Menu, MeineMenüleiste,	Add, % "Macro"			MenuKurzTaste(mi)					, 	:MacroMenue
++mi
Menu, MeineMenüleiste,	Add, % lang("Optionen")			MenuKurzTaste(mi)					, 	:OptionsMenue
++mi
Menu, MeineMenüleiste, 	Add, % "?"				MenuKurzTaste(mi)					, 	:Hilfsmenü 
; Menu, MeineMenüleiste, 	Add, ♥`:							, 	SuperFavorit0   ; durch nachfolgende bedingte Menues ersetzt
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
			Menu, MeineMenüleiste, 	Add, %FavoritenHerzAnzeige%&%A_Index%							, 	SuperFavorit%A_Index%
			FavoritenHerzAnzeige=
		}
	}
}
Gui,1: Menu, MeineMenüleiste
;}	
if ZackZackOrdnerLogErstellen
	ThreadUeberwachungLog(A_LineNumber-1,A_ThisHotkey,A_ThisLabel,A_ThisFunc,A_ThisMenu,A_ThisMenuItem,A_ThisMenuItemPos)
; </---------------------------------- Fenster-Menue ----------------------------------------->
;{	Sonstige ZZO-Menues
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
Menu, Button3RechtsMenu, Add, Edit8 2 Clip (Drop-Path), Button3RechtsMenuHandler
Menu, Button3RechtsMenu, Add, Edit5 2 Clip (Drop-Pathes), Button3RechtsMenuHandler
Menu, Button3RechtsMenu, Add, Text-Pathes 2 Drop-Pathes, Clipboard2NotText
Menu, Button3RechtsMenu, Add
Menu, Button3RechtsMenu, Add, Edit8 2 Clip (Text-Path), Button3RechtsMenuHandler
Menu, Button3RechtsMenu, Add, Edit5 2 Clip (Text-Pathes), Button3RechtsMenuHandler
Menu, Button3RechtsMenu, Add, Edit5 2 Notepad (Text-Pathes), InNotepadZeigen
Menu, Button3RechtsMenu, Add, Drop-Pathes 2 Text-Pathes, ClipboardMenuHandler1
Menu, Button3RechtsMenu, Add
Menu, Button3RechtsMenu, Add, Add Edit8 2 Clip (Text-Path), Button3RechtsMenuHandler
Menu, Button3RechtsMenu, Add, Add Edit5 2 Clip (Text-Pathes), Button3RechtsMenuHandler
; --------------------------------------------------------------
Menu, SuFiMenu, Add, vom VaterDir, SuFiMenuHandler
Menu, SuFiMenu, Add, vom GrossVaterDir, SuFiMenuHandler
Menu, SuFiMenu, Add, vom VaterWin, SuFiMenuHandler
Menu, SuFiMenu, Add
Menu, SuFiMenu, Add, Control Infos, SuFiMenuHandler  ; Fügt einen weiteren Menüpunkt unterhalb des Untermenüs ein.
Menu, ExplorerMenu, Add, Clip-Pfad -> Explorer, ExplorerMenuHandler
;}	
;}	; < /  ####################################### Fenster-Menue ###################################### >
; --------------------------------------------------------------
;{	; ########################################## ClipboardMenu ###################################### @0180
Menu, ClipboardMenu, Add, Fokusiertes Feld 2 Edit5 	 , WinControlInf2Edit5
Menu, ClipboardMenu, Add, Pfad-Wahl 2 Fokusiertes Feld	`t#b , MachsBesteDrausSchreiben
Menu, ClipboardMenu, Add, Pfad-Wahl 2 Clipboard , Edit5EinzelPfad2clipboard
Menu, ClipboardMenu, Add, Clipboard-Kopie 2 ZZO	 , ClipKopiePfade2Zzo
Menu, ClipboardMenu, Add, Clipboard 2 Text, ClipboardMenuHandler1
Menu, ClipboardMenu, Add, Clipboard 2 Not Text (-> Pfade), Clipboard2NotText
Menu, ClipboardMenu, Add, Clipboard 2 Speicher1, ClipboardMenuHandler2
Menu, ClipboardMenu, Add, Markiertes 2 Clipboard und zu Speicher1 hinzufuegen, ClipboardMenuHandler2a
Menu, ClipboardMenu, Add, MouseOverHwnd 2 Clipboard, MouseOverHwnd2Clipboard
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
Menu, ClipboardMenu, Add, starte Clippboard-Einzel-Pfad	, ClipboardMenuHandler8
Menu, ClipboardMenu, Add
Menu, ClipboardMenu, Add, Edit82AWin (für CMD`, Save as`, Expl.)	, ClipboardMenuHandler12
Menu, ClipboardMenu, Add
Menu, ClipboardMenu, Add, zeige / editiere ClipInhalt	, ClipboardMenuHandler10
IfExist % FuehrendeSterneEntfernen(Clipboard)
	Menu, ClipboardMenu, Add, zeige ClipPathInhalt in Edit5	, ClipboardMenuHandler11


;}	
; < ------------------------------ PfadNummern links von Edit5 ins Gui ---------------------------------> ; ToDo
;{	############################################ nach Gui ##########################################
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
ControlSend,Edit5,{CtrlDown}{Home}{CtrlUp},ahk_id %GuiWinHwnd%
sleep 100
Zeile1Y:=A_CaretY
ControlSend,Edit5,{CtrlDown}{End}{CtrlUp},ahk_id %GuiWinHwnd%
sleep 10
Zeile15Y:=A_CaretY
GrundZeilenVersatzYEich:=(Zeile15Y-Zeile1Y)/(15*GrundZeilenVersatzYStandart*DpiKorrektur)
ZeilenVersatzY := GrundZeilenVersatzYStandart * GrundZeilenVersatzYEich		; in Pixel
PfadNrStatischAnzahl:=Round((A_ScreenHeight - PfadNrStatisch1Y) / ZeilenVersatzY) -9
if ZackZackOrdnerLogErstellen
	ThreadUeberwachungLog(A_LineNumber-1,A_ThisHotkey,A_ThisLabel,A_ThisFunc,A_ThisMenu,A_ThisMenuItem,A_ThisMenuItemPos)
Loop, % PfadNrStatischAnzahl
{
	ThisIndexPlus1 := A_Index + 1
	ThisIndexMinus1 := A_Index - 1
	ThissPfadNrStatischY := PfadNrStatisch%A_Index%Y
	Gui,1: Add,	Text	,								x90	y%ThissPfadNrStatischY% w20 h12 Right, %A_Index%
	PfadNrStatisch%ThisIndexPlus1%Y := PfadNrStatisch1Y + (ZeilenVersatzY * A_Index)
	; ThisGuiControl
}
Loop 10
{
	ThisIndexMinus1 := A_Index - 1
	Menu, IntegerMenue2, Add, %    "# &"	chr(ThisIndexMinus1+48)  A_Space	 , 	IntegerDotMenu
}
Loop 10
{
	ThisIndexMinus1 := A_Index - 1
	Menu, IntegerMenue, Add, %    "&"	chr(ThisIndexMinus1+48) "0" A_Space	 , 	IntegerMenue2
}

; </ ------------------------------ PfadNummern links von Edit5 ins Gui --------------------------------->


; #.::	#.Menu	Win.Menu	WinDotMenu	Menu fuer Hintergrundbedienung, ZZO-Win muss nicht aktiv (notactive) sein.	Schnell-Find-Begriffe links drinn lassen!

mi :=0
if 1 ; MenuKurzTasten
{
Menu, MeineMenueleiste,	Add, %  "&"	Integer3Hex(mi) A_Tab	"Button"				A_Space	A_Space		MenuKurzTaste(mi)		, 	:ButtonMenu  ; wie Klick auf Button#
	++mi
	Menu, MeineMenueleiste, Add
}
Menu, MeineMenueleiste,	Add, %  "&"	Integer3Hex(mi) A_Tab	lang("Datei")			A_Space	A_Space		MenuKurzTaste(mi)		, 	:Dateimenü  ; Fügt die oben erstellten Untermenüs hinzu.
++mi
Menu, MeineMenueleiste,	Add, %  "&"	Integer3Hex(mi) A_Tab		"Edit8"				A_Space	A_Space		MenuKurzTaste(mi)		, 	:Edit8menue  ; Fügt die oben erstellten Untermenüs hinzu.
++mi
Menu, MeineMenueleiste,	Add, %  "&"	Integer3Hex(mi) A_Tab	lang("Pfade") 			A_Space	A_Space		MenuKurzTaste(mi)		, 	:Edit5menue  ; Fügt die oben erstellten Untermenüs hinzu.
++mi
Menu, MeineMenueleiste,	Add, %  "&"	Integer3Hex(mi) A_Tab	lang("Filter")			A_Space	A_Space		MenuKurzTaste(mi)		, 	:Filtermenue  ; Fügt die oben erstellten Untermenüs hinzu.
++mi
Menu, MeineMenueleiste,	Add, %  "&"	Integer3Hex(mi) A_Tab	lang("Strukturen")		A_Space	A_Space		MenuKurzTaste(mi)		, 	:StukturenMenue  ; Fügt die oben erstellten Untermenüs hinzu.
; ++mi
Menu, MeineMenueleiste,	Add, % 	 					A_Tab			" ↑"			A_Space	A_Space								,	ContainerPrev
++mi
Menu, MeineMenueleiste,	Add, %  "&" Integer3Hex(mi) A_Tab	lang("Container")		A_Space	A_Space		MenuKurzTaste(mi)		, 	:ContainerMenue
; ++mi
Menu, MeineMenueleiste,	Add, % 						A_Tab 			" ↓"			A_Space	A_Space								, 	ContainerNext
; ++mi
Menu, MeineMenueleiste,	Add, %						A_Tab		A_Space	" ↑"			A_Space	A_Space								, 	NurLastStartPfad
++mi
Menu, MeineMenueleiste,	Add, %  "&"	Integer3Hex(mi)	A_Tab  	lang("Start-Pfad") 		A_Space	A_Space		MenuKurzTaste(mi)		, 	:StartPfadMenue
; ++mi
Menu, MeineMenueleiste,	Add, %						A_Tab		A_Space	" ↓"			A_Space	A_Space								, 	NurNextStartPfad
++mi
Menu, MeineMenueleiste,	Add, %  "&"	Integer3Hex(mi) A_Tab	lang("Favoriten")	 	A_Space	A_Space		MenuKurzTaste(mi)		, 	:FavMenue
++mi
Menu, MeineMenueleiste,	Add, %  "&"	Integer3Hex(mi)	A_Tab	 "Macro"		 		A_Space	A_Space		MenuKurzTaste(mi)		, 	:MacroMenue
++mi
Menu, MeineMenueleiste,	Add, %  "&"	Integer3Hex(mi) A_Tab	lang("Optionen")	 	A_Space	A_Space		MenuKurzTaste(mi)		, 	:OptionsMenue
++mi
Menu, MeineMenueleiste, Add, %  "&"	Integer3Hex(mi) A_Tab 		"?"					A_Space	A_Space		MenuKurzTaste(mi)		, 	:Hilfsmenü 
Menu, MeineMenueleiste, Add
++mi
Menu, MeineMenueleiste, Add, %  "&"	Integer3Hex(mi) A_Tab 		"[#v]-(Clipboard...)-Menue"	A_Space	A_Space		MenuKurzTaste(mi)		, 	:ClipboardMenu 
++mi
; Menu, MeineMenueleiste, Add, %  "&"	Integer3Hex(mi) A_Tab 		"Integer-Menu"					A_Space	A_Space		MenuKurzTaste(mi)		, 	:FuerIntegerMenu 
++mi
Menu, MeineMenueleiste, Add, %  "&"	Integer3Hex(mi) A_Tab 		"Button3-Rechts-Click-Menu"					A_Space	A_Space		MenuKurzTaste(mi)		, 	:Button3RechtsMenu 
Menu, MeineMenueleiste, Add
++mi
Menu, MeineMenueleiste, Add, %  "&"	Integer3Hex(mi) A_Tab 		"Tray-Menue"					A_Space	A_Space		MenuKurzTaste(mi)		, 	:Tray 
Menu, MeineMenueleiste, Add, %  A_Tab 		"Machs Beste draus -> #b"					A_Space	A_Space			, 	MachsBesteDraus 
Menu,MeineMenueleiste,Disable,%  A_Tab 		"Machs Beste draus -> #b"					A_Space	A_Space		
Menu, MeineMenueleiste, Add
; 

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
			; Menu, MeineMenueleiste, 	Add, %FavoritenHerzAnzeige%&%A_Index%							, 	SuperFavorit%A_Index%
			Menu, MeineMenueleiste, 	Add, %  "&" chr(A_Index	+75) A_Tab "♥"	A_Index					, 	SuperFavorit%A_Index%
			FavoritenHerzAnzeige=
		}
	}
}
Menu, MeineMenueleiste, Add

Menu, MeineMenueleiste, Add, %  "&. Dot"	 A_Tab 		"ZZO aktivieren"							A_Space	A_Space			, 	SA 
Menu, MeineMenueleiste, Add, %  "&- minus"	 A_Tab 		"setPath: Speichern ... Dialog"				A_Space	A_Space			, 	OpenGuiNebenAktWin 
Menu, MeineMenueleiste, Add, %  "&`, Komma"	 A_Tab 		"Pfad des aktiven Explorer aendern"			A_Space	A_Space			, 	SaSize 
Menu, MeineMenueleiste, Add, %  "&# Phis"	 A_Tab 		"Pfad-Nummer-Auswahl"			A_Space	A_Space			, 	:IntegerMenue
Menu, MeineMenueleiste, Add, %  "&W"		 A_Tab 		"reserviert für Win-Aktionen-Untermenu"		A_Space	A_Space			, 	Sa 

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
if ZackZackOrdnerLogErstellen
	ThreadUeberwachungLog(A_LineNumber+1,A_ThisHotkey,A_ThisLabel,A_ThisFunc,A_ThisMenu,A_ThisMenuItem,A_ThisMenuItemPos)
gosub KontainerAnzeigen
if ZackZackOrdnerLogErstellen
	ThreadUeberwachungLog(A_LineNumber+1,A_ThisHotkey,A_ThisLabel,A_ThisFunc,A_ThisMenu,A_ThisMenuItem,A_ThisMenuItemPos)
if ZackZackOrdnerLogErstellen
	ThreadUeberwachungLog(A_LineNumber+1,"vor OnMessage " A_ThisHotkey,A_ThisLabel,A_ThisFunc,A_ThisMenu,A_ThisMenuItem,A_ThisMenuItemPos)
OnMessage(0x4a, "Empfange_WM_COPYDATA")  ; 0x4a ist WM_COPYDATA
OnMessage(0x06, "WinActivateted")  ; 0x06 Fenster wurde Aktiviert
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
	gosub SelfMin
}
gosub ContainerUebersichtZeigen
IfWinActive,ahk_id %GuiWinHwnd%
{
	ControlGetFocus, FocusedGuiConntrol,A
	if (FocusedGuiConntrol<>"Edit2")
	{
		ControlFocus,Edit2,ahk_id %GuiWinHwnd%
		sleep 10
		ControlSend,Edit2,{CtrlDown}a{CtrlUp},ahk_id %GuiWinHwnd%
	}
}

gosub F5
ZueletztFokusieren:=Edit2
SchreibMarkenOrt:="End"
gosub Button1
sleep 50
FokusEdit2Rechts()
; ToDo: noch ein proffesionelles Uebernahme-System implementieren z.B. Ue1 was kommt in Ue2 bis n (z.B. Die Daten).
MacroUebergabe:=false
MacroUebergabeIndex:=0
MacroUebergabeInhalt:={}
MacroNachHochfahrenAusfuehren:={}
Loop, % Ue.MaxIndex()
{
	; MsgBox % Ue[A_Index]
	if(Ue[A_Index]="")
	{
	}
	else if (Ue[A_Index]="</Macro>")
	{
		MacroUebergabe:=false
	}
	else if (Ue[A_Index]="<Macro>")
	{
		MacroUebergabe:=true
		++MacroUebergabeIndex
	}
	else if MacroUebergabe
	{
	}
	else if (Ue[A_Index]="Minimized")
	{
		GuiNachHochfahrenMinimieren:=true
	}
	else IfExist % Ue[A_Index]
	{
		UeTemp:=Ue[A_Index]
		SplitPath,UeTemp,,,UeExt
		if (InStr(FileExist(Ue[A_Index]),"D"))
		{
			Edit8:=Ue[A_Index]
			gosub Edit8Festigen
			gosub ImOrdnerSuchen
			sleep 1000
			ControlFocus,Edit11,ahk_id %GuiWinHwnd%
		}
		else if(Ue[A_Index]= A_Temp "\RunZZOout.txt")
		{
			FileRead,fuerClipboard,% A_Temp "\RunZZOout.txt"
			Loop,Parse,fuerClipboard,`n,`r
				ClipboardZ .= SubStr(A_LoopField,1,-16) "`r`n"
			StringTrimRight,Clipboard,ClipboardZ,2
			Edit8:=Ue[A_Index]
			gosub Edit8Festigen
			Edit2:="clip://	In_Row? "
			gosub Edit2Festigen
; 			gosub Button1
			gosub SitzungsEinstellungenMerken
		}
		else ; if(UeExt="log")
		{
			; SoundBeep
			Edit8:=Ue[A_Index]
			gosub Edit8Festigen
			gosub Edit8QuellTextAnzeigen
			gosub Button1
			gosub SitzungsEinstellungenMerken
		}
	}
	else 
	{
		Edit2:=Ue[A_Index]
		gosub Edit2Festigen
		sleep 1000
		gosub Button1
	}

	if (MacroUebergabe AND NOT Ue[A_Index]="<Macro>")
	{
		MacroUebergabeInhalt[MacroUebergabeIndex].=Ue[A_Index] . "`r`n"
		MacroNachHochfahrenAusfuehren[MacroUebergabeIndex]:=true
	}
}
RunZZO=
(
Random,RD,1000,9999
TickCount:=A_TickCount . RD
IfExist `%A_Temp`%\RunZZOout.txt
	FileAppend, ``r``n`%1`%%A_Tab%%A_Tab%%A_Tab%`%TickCount`%,`%A_Temp`%\RunZZOout.txt
else
	FileAppend, `%1`%%A_Tab%%A_Tab%%A_Tab%`%TickCount`%,`%A_Temp`%\RunZZOout.txt
sleep 500
FileRead,Pfade,`%A_Temp`%\RunZZOout.txt
if(SubStr(Pfade,-10) = SubStr(TickCount,-10))
{
	StringSplit,Pfad,Pfade,``n,``r
	ToolTip `%Pfad0`%	`%0`%	`%1`%	`%2`%	`%3`%		
	if(Pfad0 < 1.5)
	{
		Run,"%A_AhkPath%" "%A_ScriptFullPath%" "`%1`%",%A_ScriptDir%
		sleep 15000
		FileDelete,`%A_Temp`%\RunZZOout.txt
		; SoundBeep 1000
		ExitApp
	}
	else
		Run,"%A_AhkPath%" "%A_ScriptFullPath%" "`%A_Temp`%\RunZZOout.txt",%A_ScriptDir%		
		sleep 15000
		FileDelete,`%A_Temp`%\RunZZOout.txt
		; SoundBeep 2000
}
; SoundBeep 3000
ExitApp

; Run,"%A_AhkPath%" "%A_ScriptFullPath%" "`%1`%",%A_ScriptDir%
)
IfNotExist %A_ScriptDir%\RunZZO.ahk
	FileAppend, %RunZZO%,%A_ScriptDir%\RunZZO.ahk
StringReplace,AhkRegPath,A_AhkPath,\,\\,All
StartScriptPath:=A_ScriptDir "\RunZZO.ahk" 			; Start-Script wird wegen dem Arbeitsverzeichnis benoetigt.
StringReplace,ScriptRegPath,StartScriptPath,\,\\,All
FuerRegDatei=
(
REGEDIT4

[HKEY_CLASSES_ROOT\AllFileSystemObjects\shell\Oeffnen mit ZZO]
@="Oeffnen mit ZZO"

[HKEY_CLASSES_ROOT\AllFileSystemObjects\shell\Oeffnen mit ZZO\command]
@="\"%AhkRegPath%\" \"%ScriptRegPath%\" \"`%1\""
)
OpenWithZzoRegPath=%A_ScriptDir%\OpenWithZZO.reg
IfNotExist %OpenWithZzoRegPath%
	FileAppend, %FuerRegDatei%,%OpenWithZzoRegPath%
; if (Ue.MaxIndex)
; 	MsgBox % GetDetailesOfOjects(MacroUebergabeInhalt,"MacroUebergabeInhalt",MacroNachHochfahrenAusfuehren,"MacroNachHochfahrenAusfuehren")

GoSub, GetHTML
; MsgBox % html
doc.write(html)
; MsgBox % html
; IName   := ComObjType(doc, "Name")
; MsgBox % IName
; S1 := ComObjGet(IName ":")
; IName   := ComObjType(S1, "Name")
; MsgBox % IName



; elem:=doc.getElementById("test")
; doc.all.type.focus
; %Edit8Html% <input id="type" name="type" type="text" value="OrdnerName" />

ComObjConnect(doc, "Doc_")	
elem:=doc.getElementById("type")
; ComObjConnect(elem, "elem_")
; elem.all.type.focus

gosub AutoMacroSetup

#Include *i %A_ScriptDir%\ImHauptPrgAmEnde.ahk
gosub KontainerAnzeigen
Loop, % MacroNachHochfahrenAusfuehren.MaxIndex()
{
	sleep 500
	DiesenBefehlsDateiPfad=%A_AppData%\Zack\Macro\StartUebergabeMacro%A_Index%.txt
	FileDelete, %DiesenBefehlsDateiPfad%
	FileAppend, % MacroUebergabeInhalt[A_Index], %DiesenBefehlsDateiPfad%
	sleep 1000
	gosub DiesenBefehlsDateiPfadAusfuehren
}
; gosub los
if ObjetDetails
	MsgBox % GetObjectDetails(TT,"TT")
OnMessage(0x201, "WM_LBUTTONDOWN")	;{()	;}	
OnMessage(0x202, "WM_LBUTTONUP")
			    ; WM_LBUTTONUP = 0x202
OnMessage(0x203, "WM_LBUTTONDBLCLK")	;{()
FileDelete,%ZzoHauptFensterHwndPfad%
FileAppend,% GuiWinHwnd,% ZzoHauptFensterHwndPfad
; SoundBeep 5000

; gosub WbTest

; gosub IETest
; MsgBox HWND am Ende des Hauptprogramms   %GuiWinHwnd%
return
;}	
;}	
;	;	; < / ##################################### Ende Haupt-Programm ################################### >	 @0199
Empfange_WM_COPYDATA(wParam, lParam)	;{()	
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
;}	
;{	Verwaister Code
if ZackZackOrdnerLogErstellen 
	ThreadUeberwachungLog(A_LineNumber-1,A_ThisHotkey,A_ThisLabel,A_ThisFunc,A_ThisMenu,A_ThisMenuItem,A_ThisMenuItemPos)
; OnMessage(0x201, "WM_LBUTTONDOWN")
if ZackZackOrdnerLogErstellen
	ThreadUeberwachungLog(A_LineNumber-1,A_ThisHotkey,A_ThisLabel,A_ThisFunc,A_ThisMenu,A_ThisMenuItem,A_ThisMenuItemPos)
IfExist %SkriptDataPath%					; SkriptDataPath=%A_AppDataCommon%\Zack
{
	OrdnerEingelesen:=true
	if ZackZackOrdnerLogErstellen
		ThreadUeberwachungLog(A_LineNumber-1,A_ThisHotkey,A_ThisLabel,A_ThisFunc,A_ThisMenu,A_ThisMenuItem,A_ThisMenuItemPos)
}
return
;}	Ende Verwaister Code
; < ######################################## globale Hotkeys HotStrings ####################################### >	@0210

PlusSternClipPfade:	;{	; erstellt Favoriten aus Pfaden im Clipboard	; wird vom Clipboard-Menu aufgerufen
RueckFrageAbAnzClipPfade:=8
gosub WindowsN	;}	ist hier notwendig, da Skript sonst bei naechster Zeile aufhoert.
return
~#*::	;{	Pfade im ClipBoard zu den Favoriten hinzufuegen	;}	
WindowsN:	;{	Pfade im ClipBoard zu den Favoriten hinzufuegen
if (RueckFrageAbAnzClipPfade="")
	RueckFrageAbAnzClipPfade:=10
ClipKopie:=Clipboard
StringSplit,ClipZeile,ClipKopie,`n,`r
if (ClipZeile0 = 1)
{
	SplitPath,ClipZeile1,ClipZeile1FileName
	if(ClipZeile1FileName="")
		ClipZeile1FileName:=ClipZeile1
	ThisNewFavorit:=ClipZeile1FileName "|*" ClipZeile1
	gosub PlusSternManuellVorschlagVorhanden
	return
}
else if(ClipZeile0 > 10)
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
		if(InStr(ThisClipZeile,"|"))	; Sonderbehandlung Name und Pfad bekannt
		{
			ThisNewFavorit:=ThisClipZeile
			gosub PlusSternManuellBekannt
		}
		else ifexist %ThisClipZeile%
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
;}	
SchnellWahl(Caller,Ueberschrift,MenueCrLf)	;{()		; Menue-Abfrage aehnlich machs-Beste-draus
{
	Loop
	{
		if (Ueberschrift<>"")
			Edit2UndEdit5:=Ueberschrift "	     abbrechen [Esc]"  "`r`n------------------------------------------------- "  "`r`n" MenueCrLf
		FMenuAntwort:=FMenu(Edit2UndEdit5)
		; MsgBox % FMenuAntwort
		if(FMenuAntwort="NeuerSuchString")
		{
			; kein Suchstring
		}
		else if(FMenuAntwort="Next")
		{
		}
		else if(FMenuAntwort="Last")
		{
		}
		else if(FMenuAntwort="Aktivieren")
		{
			gosub SelfMin	; Toggle-Aktivieren
			return 0
		}
		else if(FMenuAntwort=0)
			return 0
		else
			break
	}
	if(Caller="ContainerSchnellWahl")
	{
		; DiesePfadAuswahlPfad:=SubStr(FMenuAntwort,7)
		DieseAuswahlNr:=SubStr(FMenuAntwort,1,6)-2
		; MsgBox % DieseAuswahlNr
		; return DiesePfadAuswahlPfad
		return DieseAuswahlNr
	}
return 0
}
;}	
^+c::	;{()	 sendet ^+c haengt neuen Clipboard-Inhalt an besteheden.
; ClipSaveeAll1:=ClipboardAll
; MsgBox % StrLen(ClipSaveeAll) "	" StrLen(ClipboardAll)
ClipSave1:=Clipboard
Clipboard:=
Send {CtrlDown}c{CtrlUp}
if (ClipSave1="")
	return
ClipWait,2
if (SubStr(ClipSave1,0,1)="`n" or InStr(SubStr(ClipSave1,1,2),"`n"))
	Clipboard := ClipSave1 Clipboard
else
	Clipboard := ClipSave1 "`r`n" Clipboard
return
;}	
WinControlInf2Edit5:	;{	
DiesesWinHwnd:=WinExist("A")
; ControlGetFocus,DiesesFocussedControl,A
WinGetTitle,DieserWinTitle,ahk_id %DiesesWinHwnd%
WinGetClass,DieseWinClass,ahk_id %DiesesWinHwnd%
ControlGetFocus,DiesesFocussedControl,ahk_id %DiesesWinHwnd%
ControlGet, DiesesFocussedControlHwnd, Hwnd,, % DiesesFocussedControl, % "ahk_id " DiesesWinHwnd
;}	
;	ohne Return
SysListView3212Edit5:	;{	
Edit2:=ControlTextKenner WinTitleKenner " ahk_id " DiesesWinHwnd A_Space ControlKenner A_Space DiesesFocussedControl A_Space NrRowKenner A_Space
gosub Edit2Festigen
return
;}	
~#b::	; mache das Beste aus dem aktiven -Fenster und -Feld, mit der anschliessenden Pfad-Wahl.
MachsBesteDrausControls:	;{		; mache das Beste aus dem aktiven -Fenster und -Feld, mit der anschliessenden Pfad-Wahl.
DiesesWinHwnd:=WinExist("A")
ControlGetFocus,DiesesFocussedControl,A
ControlGet, DiesesFocussedControlHwnd, Hwnd,, % DiesesFocussedControl, % "ahk_id " DiesesWinHwnd
CaretXBestMerker:=A_CaretX
CaretYBestMerker:=A_CaretY
DieseExplorerSeletions:=Explorer_GetSelected(DiesesWinHwnd)
; MsgBox >%DieseExplorerSeletions%<
WinGetTitle,DieserWinTitle,ahk_id %DiesesWinHwnd%
WinGetClass,DieseWinClass,ahk_id %DiesesWinHwnd%
; MsgBox %  DieseWinClass "	" DiesesFocussedControl "	" CaretXBestMerker "	" CaretYBestMerker
#Include *i MachsBesteDrausControls.ahk
;}	
;	Ohne Return
MachsBesteDraus:	;{		; mache das Beste aus dem aktiven -Fenster und -Feld, mit der anschliessenden Pfad-Wahl.
MachsBesteDrausLesen:	;{		; mache das Beste aus dem aktiven -Fenster und -Feld, mit der anschliessenden Pfad-Wahl.
MachsBesteDrausSchreiben:	;{		; mache das Beste aus dem aktiven -Fenster und -Feld, mit der anschliessenden Pfad-Wahl.
; if(DiesesWinHwnd<>GuiWinHwnd)
;	gosub SelfMin
; MsgBox % A_ThisLabel
if(A_ThisLabel="MachsBesteDrausControls" OR A_ThisLabel="MachsBesteDrausLesen" OR A_ThisLabel="MachsBesteDraus" OR A_ThisLabel="~#b")
{
	; MsgBox % DieseWinClass "	" DiesesFocussedControl
	if(DieseWinClass="CabinetWClass" and DiesesFocussedControl="DirectUIHWND3")	; ExplorerSelektion
	{
		If(DieseExplorerSeletions="" OR DieseExplorerSeletions="ERROR")
		{
		}
		else
		{
			IfExist %DieseExplorerSeletions%
			{
				Edit8:=DieseExplorerSeletions
				gosub Edit8Festigen
				gosub Ctrl & Right
				RunOtherAhkScriptOrExe(ExternalToolTipPath, DieseExplorerSeletions " --> ZZO")
			}
			else
			{
				; Edit5:=DieseExplorerSeletions
				; gosub Edit5Festigen
				FileDelete,%A_AppData%\Zack\ExSel.tmp
				FileAppend,%DieseExplorerSeletions%,%A_AppData%\Zack\ExSel.tmp,utf-16
				Edit2:=FileKenner A_AppData "\Zack\ExSel.tmp" A_Space InRowKenner A_Space
				gosub Edit2Festigen
DieseAnzeige=
(
Die selektierten Pfade wurden in ZZO via Temp-File uebernommen.
Eine Uebernahme abrufbar via WinTitle und Control ist in Planung.
)
				RunOtherAhkScriptOrExe(ExternalToolTipPath, DieseAnzeige)
			}
			return
			
		}
	}
	else if(DieseWinClass="CabinetWClass" and (DiesesFocussedControl="DirectUIHWND1" OR DiesesFocussedControl="DirectUIHWND3"))	; ExplorerSuche
	{	; ExplorerSuche
		; DieseExplorerSelections:=Explorer_GetSelected()
		; If(DieseExplorerSeletions="" OR DieseExplorerSeletions="ERROR")
		{
			Edit2:=
			gosub Edit2Festigen
			UeberwachungExplorerSuchFeldGestartet:=false
			IfExist UeberwachungExplorerSuchFeld.exe
			{
				RunWait, "%A_ScriptDir%\UeberwachungExplorerSuchFeld.exe" "%A_ScriptDir%\UeberwachungExplorerSuchFeld.ahk" einmal
				UeberwachungExplorerSuchFeldGestartet:=true
				; RunOtherAhkScriptOrExe(ExternalToolTipPath, "Suche in ZZO gestartet")
			}
			else IfExist UeberwachungExplorerSuchFeld.ahk
			{
				RunWait, "%A_ScriptDir%\UeberwachungExplorerSuchFeld.ahk" einmal
				UeberwachungExplorerSuchFeldGestartet:=true
				; RunOtherAhkScriptOrExe(ExternalToolTipPath, "Suche in ZZO gestartet")
			}
			if UeberwachungExplorerSuchFeldGestartet
			{
				sleep 20
				gosub Button1
				Loop,100000
				{
					if not beschaeftigt
						break
					Sleep -1
				}
				Vorrang:="ExplorerSelect"
			}
		}
	}
	else if(DieseWinClass="SciTEWindow" and DiesesFocussedControl="Scintilla1") 
	{
		Edit2:=ControlTextKenner "WTitle?  ahk_class SciTEWindow Contro? " DiesesFocussedControl "``vNr_Row? "
		; bei Scite ist die Fenster-Klasse besser, weil eh nur ein Fenster aktiv sein kann
		; bei Notepad ist das Fenster-HWND besser, da es sonst zu ungewuenschten Texten komm(t)(en) (kann).
		; deshalb wurde obige Zeile den drunter vorgezogen.
		; Edit2:=ControlTextKenner "WTitle? ahk_id " DiesesWinHwnd " Contro? " DiesesFocussedControl " Nr_Row? "
		gosub Edit2Festigen
		return
	}
	else if(DieseWinClass="Notepad" and DiesesFocussedControl="Edit1") 
	{
		; Edit2:=ControlTextKenner "WTitle?  ahk_class SciTEWindow Contro? " DiesesFocussedControl " Nr_Row? "
		; bei Scite ist die Fenster-Klasse besser, weil eh nur ein Fenster aktiv sein kann
		; bei Notepad ist das Fenster-HWND besser, da es sonst zu ungewuenschten Texten komm(t)(en) (kann).
		; deshalb wurde obige Zeile den drunter vorgezogen.
		Edit2:=ControlTextKenner "WTitle? ahk_id " DiesesWinHwnd " Contro? " DiesesFocussedControl "``vNr_Row? "
		gosub Edit2Festigen
		return
	}
	else if (DieseWinClass="Chrome_WidgetWin_1") ;  and DiesesFocussedControl="Intermediate D3D Window1") 
	{
		try
		{
			; C:\Program Files (x86)\Google\Chrome\Application\chrome.exe --remote-debugging-port=9222
			oDriverCh:=ChromeGet()

			; oDriverCh:=ComObjCreate("Selenium.ChromeDriver")
			; oDriverCh:=ChromeGet()
			; oDriverCh.get("https://www.google.de/")
			/*
			oDriverCh:=ComObj("::{0277FC34-FD1B-4616-BB19-5D556733E8C9}")
			oDriverCh:=ComObj("{0277FC34-FD1B-4616-BB19-5D556733E8C9}")
			oDriverCh:=ComObjActive(0277FC34-FD1B-4616-BB19-5D556733E8C9)
			oDriverCh:=ComObjActive("0277FC34-FD1B-4616-BB19-5D556733E8C9")
			; oDriverCh:=ComObjActive("::{0277FC34-FD1B-4616-BB19-5D556733E8C9}")
			; oDriverCh:=ComObjActive("0277FC34-FD1B-4616-BB19-5D556733E8C9")
			; ComObjConnect(oDriverCh)
			; ComObjConnect(oDriverCh, "SCD_")
			; url:="https://www.ebay.de/"
			; oDriverCh.get("/")
			; oDriverCh.get(url)
			; ComObjConnect(oDriverCh,"Selenium.ChromeDriver_")
			; ComObjConnect(oDriverCh,"Selenium.ChromeDriver")
			; ComObjConnect(oDriverCh,"CHROME_")
			; ComObjConnect(oDriverCh,"CH_")
			ComObjConnect(oDriverCh,"CH_")
			; ComObjConnect(oDriverCh,this)
			; ComObjConnect(oDriverCh,"ProcessCreate_")
			; ComObjConnect(oDriverCh,"oDriverCh_")
			; ComObjConnect(oDriverCh,oDriverCh_events)
			MsgBox Der Connect zur bestehenden Chrome-Sitzung fehlt noch`n`nschliessen nach Wunschwebsite`n`num den Seiten-Quelltext in Edit5 zu erhalten.
			*/
		}
		catch
		{
			if Not ChromDriverFrageLassen
			{
				MsgBox, 8244, Quelltext, Um den Quelltext einer (Chrome-) Webseite anzuzeigen wird der Seleniun COM Driver --> Selenium.ChromeDriver benoetigt.`nund Chrome mus via PfadZuChrome  --remote-debugging-port=9222 gestartet worden sein`n`nNein	Meldung nicht mehr zeigen
				IfMsgBox,No
					ChromDriverFrageLassen:=true
				return
			}
		}
		; WebSeitenQuelltext1:=oDriverCh.executeScript("return document.getElementByTagName('body').textContent")
		 WebSeitentext:=oDriverCh.executeScript("return document.getElementsByTagName('body')[0].textContent")
		;  WebSeitentext:=oDriverCh.document.documentElement.innerText
		; WebSeitentext:=oDriverCh.executeScript("return document.getElementsByTagName('body')[0].innerhtml")
		; WebSeitentext:=oDriverCh.executeScript("return document.getElementByTagName('body').textContent")
		; MsgBox % WebSeitenQuelltext1 WebSeitenQuelltext2
		; WebSeitenQuelltext:=oDriverCh.executeScript("return document.responseDetails.responseText")
		;  WebSeitenQuelltext:=oDriverCh.executeScript("return document.innerhtml")
		;  MsgBox % WebSeitenQuelltext
		; WebSeitenQuelltext:=oDriverCh.executeScript("return document.innerhtml")
		; WebSeitentext:=WebSeitenQuelltext
		; WebSeitenQuelltext:=oDriverCh.executeScript("return document.innertext")
		StringReplace,WebSeitentext,WebSeitentext,`n,`r`n,All
		FileDelete,%A_Temp%\WebSeitentext.txt
		FileAppend,%WebSeitentext%,%A_Temp%\WebSeitentext.txt
		; Edit5:=WebSeitenQuelltext
		Edit2:=FileKenner A_Temp "\WebSeitentext.txt" A_Space NrRowKenner A_Space 

		; Edit2:=ControlTextKenner "WTitle?  ahk_class SciTEWindow Contro? " DiesesFocussedControl " Nr_Row? "
		; bei Scite ist die Fenster-Klasse besser, weil eh nur ein Fenster aktiv sein kann
		; bei Notepad ist das Fenster-HWND besser, da es sonst zu ungewuenschten Texten komm(t)(en) (kann).
		; deshalb wurde obige Zeile den drunter vorgezogen.
		; Edit2:=ControlTextKenner "WTitle? ahk_id " DiesesWinHwnd " Contro? " DiesesFocussedControl " Nr_Row? "
		gosub Edit2Festigen
		return
	}
 	else if(DiesesFocussedControl="SysListView321")
 	{
		gosub SysListView3212Edit5
		return
	}
}
; MsgBox % A_ThisLabel
if(A_ThisLabel="MachsBesteDrausControls" OR A_ThisLabel="MachsBesteDrausSchreiben" OR A_ThisLabel="MachsBesteDraus" OR A_ThisLabel="~#b")
{
	Loop
	{
		; sleep 1000

		; MsgBox % Edit5
		if (Edit2<>"")
			Edit2UndEdit5:=Edit2 "	Pfad-Wahl aufrufen [Win] + [b]     abbrechen [Esc]"  "`r`n-------- sort("   LastSort ")----------------------------------------------" DieseWinClass "[" DiesesWinHwnd "] --- " DiesesFocussedControl "[" DiesesFocussedControlHwnd "]`r`n" Edit5
		else
			Edit2UndEdit5:="NULL	Pfad-Wahl aufrufen [Win] + [b]     abbrechen [Esc]"  "`r`n----------------------------------------------" DieseWinClass "[" DiesesWinHwnd "] --- " DiesesFocussedControl "[" DiesesFocussedControlHwnd "]`r`n" Edit5
		FMenuAntwort:=FMenu(Edit2UndEdit5)
		; MsgBox % FMenuAntwort
		if(FMenuAntwort="NeuerSuchString")
		{
			; MsgBox drinn 1
			LastSort:="normal"
			if (InStr(Edit2,FilePatternKenner))
				InputBox,Edit2,Suche,Name enthält `nzwischen den * * eingeben,,,,,,,,%Edit2%
			else
				InputBox,Edit2,Suche,Name enthält,,,,,,,,%Edit2%
			; MsgBox drinn 2
			Sleep 20
			gosub Edit2Festigen
			; MsgBox drinn 3
			Sleep 200
			; MsgBox drinn 4
			; gosub Button1
			ControlClick,,ahk_id %HwndButton1%
			; ControlClick,Button1,ahk_id %GuiWinHwnd%
			gosub up1
			Sleep 200
			gosub down1
			; SoundBeep
			; MsgBox drinn 5
			Sleep 200
		}
		else if(FMenuAntwort="Next")
		{
		}
		else if(FMenuAntwort="Last")
		{
		}
		else if(FMenuAntwort="Aktivieren")
		{
			IfWinNotActive, ahk_id %GuiWinHwnd%
			{
				gosub SelfActivate
				; return
			}
			else IfWinActive, ahk_id %GuiWinHwnd%
			{
				gosub SelfMin
				; return
			}
			if (LastSort="" or LastSort="normal")
			{
				gosub SortLenAlle
				LastSort:="SortLenAlle"
			}
			else if(LastSort="SortLenAlle")
			{
				gosub SortBestAutoBewertung
				LastSort:="SortBestAutoBewertung"
			}
			else if(LastSort="SortBestAutoBewertung")
			{
				gosub Button1
				LastSort:="normal"
			}
				
		}
		else if(FMenuAntwort=0)
				return
		else
			break
	}
	if (FMenuAntwort="000000")	; User bricht ab oder klickt woanderst hin
		return
	DiesePfadAuswahl:=SubStr(FMenuAntwort,7)
	if(InStr(DiesePfadAuswahl,"`%E8`%") and IfAlleFileOderDirSyntax(Clipboard))
	{	; es wurde ein Oeffnen mit Favorit gewaehlt und im Clipboard sind nur Sytaktisch gueltige Pfade oder existierende Pfad
		
	;	if(DieseWinClass="CabinetWClass" and (DiesesFocussedControl="DirectUIHWND3" or DiesesFocussedControl="Edit2"))
	;	{
			/*
			Edit3:=SubStr(FMenuAntwort,1,6)-2
			WinActivate,ahk_id %DiesesWinHwnd%
			WinWaitActive,ahk_id %DiesesWinHwnd%
			sleep 500
			; ControlClick,,ahk_id %DiesesWinHwnd%
			ControlClick,ahk_id %DiesesWinHwnd%
			Sleep 50
			ControlFocus,DirectUIHWND,ahk_id %DiesesWinHwnd%
			; ControlFocus,DirectUIHWND3,ahk_id %DiesesWinHwnd%
			; ControlFocus,Edit2,ahk_id %DiesesWinHwnd%
			; ControlFocus,,ahk_id %DiesesWinHwnd%
			sleep 50
			; ControlSend,DirectUIHWND3,^v,ahk_id %DiesesWinHwnd%
			ControlSend,DirectUIHWND,^v,ahk_id %DiesesWinHwnd%
			sleep 2000
			MsgBox % clipboard
			ControlSend,ShellTabWindowClass,^v,ahk_id %DiesesWinHwnd%
			sleep 2000
			MsgBox % clipboard
			ControlSend,DUIViewWndClassName,^v,ahk_id %DiesesWinHwnd%
			sleep 2000
			MsgBox % clipboard
			ControlSend,CtrlNotifySink,^v,ahk_id %DiesesWinHwnd%
			sleep 2000
			MsgBox % clipboard
			ControlSend,NamespaceTreeControl,^v,ahk_id %DiesesWinHwnd%
			sleep 2000
			MsgBox % clipboard
			ControlSend,SysTreeView32,^v,ahk_id %DiesesWinHwnd%
			Pause
			; send ^v
			send {F2}
			sleep 10
			send {Escape}
			sleep 10
			SendInput ^v
			ClipWait,1
			sleep 500
			*/
			sleep 10
			SendInput {CtrlDown}v{CtrlUp}
			ClipWait,1

			Edit8 := DiesePfadAuswahl
			gosub Edit8Festigen
			; gosub Edit3
			sleep 100
			; gosub Button1
			sleep 500
			gosub StarteClipboardPfadeMitEdit8
			; MsgBox ahk_id %DiesesWinHwnd%
		; }
	}
	else if(DiesesWinHwnd=GuiWinHwnd and Initiator="StartPfadSchnellFilter")
	{	; ToDo: umsiedeln zu SchnellWahl()
		DiesePfadAuswahlPfad:=FuehrendeSterneEntfernen(SubStr(FMenuAntwort,7))
		; IfExist %DiesePfadAuswahlPfad%
		{
			; if (InStr(FileExist(DiesePfadAuswahlPfad),"D")) 	; wenn Ordner
			{
				Edit3:=SubStr(FMenuAntwort,1,6)-2
				gosub Edit3Festigen
				gosub Edit3
				sleep 10
				; SoundBeep
				Edit7:=SubStr(FMenuAntwort,1,6)-2
				gosub Edit7Festigen
				sleep 600
				gosub Button1
			}
		}
	}
	else if(DiesesWinHwnd=GuiWinHwnd and InStr(Edit2,NrRowKenner))	;	 and DiesesFocussedControl="Edit12"
	{	; ZZO aktiv und Quelltext-Anzeige
		DiesePfadAuswahlPfad:=FuehrendeSterneEntfernen(SubStr(FMenuAntwort,7))
		; IfExist %DiesePfadAuswahlPfad%
		{
			if (InStr(FileExist(DiesePfadAuswahlPfad),"D")) 	; wenn Ordner
			{
			}
			else
			{
				Edit3:=SubStr(FMenuAntwort,1,6)-2
				gosub Edit3Festigen
				gosub Edit3
				sleep 100
				gosub SciteAtEdit8
			}
		}
	}
	else if(DiesesWinHwnd=GuiWinHwnd and (DiesesFocussedControl="Edit2" or DiesesFocussedControl="Edit11"))
	{	; ZZO aktiv und ZZO-Suchfeld hat Fokus
		DiesePfadAuswahlPfad:=FuehrendeSterneEntfernen(SubStr(FMenuAntwort,7))
		IfExist %DiesePfadAuswahlPfad%
		{
			if (InStr(FileExist(DiesePfadAuswahlPfad),"D")) 	; wenn Ordner
			{
				Edit3:=SubStr(FMenuAntwort,1,6)-2
				gosub Edit3Festigen
				gosub Edit3
				sleep 10
				WunschOrdnerPattern:=DiesePfadAuswahlPfad "\*"
				Edit2:=GetAktuellenDirektSucheFilter(WunschOrdnerPattern,NameFilter,InRowFilter,Optionen%Edit7%)
				gosub Edit2Festigen
			}
			else
			{
				Edit3:=SubStr(FMenuAntwort,1,6)-2
				gosub Edit3Festigen
				gosub Edit3
				sleep 50
				gosub Edit8QuellTextAnzeigen
				sleep 50
				Edit3:=1
				gosub Edit3Festigen
				gosub Edit3
				sleep 50
				IfExist % FuehrendeSterneEntfernen(SubStr(Edit8,11))
				{
					StringReplace,Edit2,Edit2,%NrRowKenner%,%InRowKenner%
					gosub Edit2Festigen
				}
			}
		}
	}
	else if(DiesesWinHwnd=GuiWinHwnd and DiesesFocussedControl="Edit8")
	{	; ZZO aktiv und Edit8 hat Fokus
		DiesePfadAuswahlPfad:=FuehrendeSterneEntfernen(SubStr(FMenuAntwort,7))
		; IfExist %DiesePfadAuswahlPfad%
		{
			; if (InStr(FileExist(DiesePfadAuswahlPfad),"D")) 	; wenn Ordner
			{
				Edit3:=SubStr(FMenuAntwort,1,6)-2
				gosub Edit3Festigen
				gosub Edit3
				sleep 10
			}
		}
	}
	#Include *i MachsBesteDraus.ahk
	else if(Vorrang="ExplorerSelect")
	{	; pruefen ob umsiedeln zu SchnellWahl()
		Vorrang:=
		Edit3:=SubStr(FMenuAntwort,1,6)-2
		sleep 10
		gosub Edit3Festigen
		sleep 90
		gosub Edit8ExplorerSelect
	}
	else if(DieseWinClass="CabinetWClass" and (DiesesFocussedControl="Edit1" or DiesesFocussedControl="NetUIHWND1"  or DiesesFocussedControl="DirectUIHWND3"   or DiesesFocussedControl="SysTreeView321" ))
	{	; explorer ist aktiv und (Feld zum Eingeben des Ordners hat Fokus oder andere nicht suchfeder)
		Edit3:=SubStr(FMenuAntwort,1,6)-2
		gosub Edit3Festigen
		gosub ExplorerPfadEingeben
	}
	else if(instr(DieserWinTitle,"Microsoft Edge") and DiesesFocussedControl="Windows.UI.Core.CoreWindow1")	; Edge
	{	; Edge ist aktiv und das URL-Eingabe/Auswahl-Feld hat Fokus
		ClipboardSic:=ClipboardAll
		Clipboard:=FuehrendeSterneEntfernen(SubStr(FMenuAntwort,7))
		Edit3:=SubStr(FMenuAntwort,1,6)-2
		gosub Edit3Festigen
		sleep 10
		ControlClick,%DiesesFocussedControl%,ahk_id %DiesesWinHwnd%
		sleep 10
		send,{CtrlDown}v{CtrlUp}
		Clipboard:=ClipboardSic
	}
	else if(instr(DieserWinTitle,"Microsoft Edge"))	; Edge
	{	; Edge ist aktiv
		ClipboardSic:=ClipboardAll
		Clipboard:=FuehrendeSterneEntfernen(SubStr(FMenuAntwort,7))
		Edit3:=SubStr(FMenuAntwort,1,6)-2
		gosub Edit3Festigen
		sleep 10
		ControlClick,%DiesesFocussedControl%,ahk_id %DiesesWinHwnd%
		sleep 10
		send,{CtrlDown}v{CtrlUp}
		Clipboard:=ClipboardSic
	}
	else if(DieseWinClass="CabinetWClass" and DiesesFocussedControl="Edit2")	; Datei Umbenennen
	{	; explorer ist aktiv und Feld zum Datei Umbenennen hat Fokus
		Edit3:=SubStr(FMenuAntwort,1,6)-2
		gosub Edit3Festigen
		sleep 10
		ControlSend,DirectUIHWND3,{F2},ahk_id %DiesesWinHwnd%
		sleep 15
		SplitPath,% FuehrendeSterneEntfernen(SubStr(FMenuAntwort,7)),DieserFileName
		ControlSetText,Edit2,% DieserFileName,ahk_id %DiesesWinHwnd%

	}
	else if(DieseWinClass="#32770" and DiesesFocussedControl="Edit1" and (DieserWinTitle="Ausführen" or DieserWinTitle="Run"))
	{	; Start-Ausfuehren-Box und Edit1 hat Fokus
		Edit3:=SubStr(FMenuAntwort,1,6)-2
		gosub Edit3Festigen
		ControlSetText,Edit1,% FuehrendeSterneEntfernen(SubStr(FMenuAntwort,7)),ahk_id %DiesesWinHwnd%
	}
	else if(DieseWinClass="IEFrame" and DiesesFocussedControl="Edit1")
	{	; Explorer-Tool-Fenster und Edit hat
		ClipboardSic:=ClipboardAll
		Clipboard:=FuehrendeSterneEntfernen(SubStr(FMenuAntwort,7))
		Edit3:=SubStr(FMenuAntwort,1,6)-2
		gosub Edit3Festigen
		sleep 10
		WinActivate,ahk_id %DiesesWinHwnd%
		WinWaitActive,ahk_id %DiesesWinHwnd%,,1
		sleep 5
		IfWinActive,ahk_id %DiesesWinHwnd%
		{
			ControlClick,%DiesesFocussedControl%,ahk_id %DiesesWinHwnd%
			MouseClick,L,CaretXBestMerker,CaretYBestMerker
			sleep 20
		}
		IfWinActive,ahk_id %DiesesWinHwnd%
		{
			send {CtrlDown}a{CtrlUp}
			send,{CtrlDown}v{CtrlUp}
		}
		Clipboard:=ClipboardSic
	}
	else if(DieseWinClass="#32770" and (DiesesFocussedControl="Edit1" or DiesesFocussedControl="Edit2" ))
	{	; Explorer-Tool-Fenster
		Edit3:=SubStr(FMenuAntwort,1,6)-2
		gosub Edit3Festigen
		gosub Button2
	}
	else if( DiesesFocussedControl="")
	{	; kein Feld mit Fokus konnte bestimmt werden
		DiesePfadAuswahlPfad:=FuehrendeSterneEntfernen(SubStr(FMenuAntwort,7))
		IfExist %DiesePfadAuswahlPfad%
		{
			if (InStr(FileExist(DiesePfadAuswahlPfad),"D")) 
			{	; wenn Ordner
				Edit3:=SubStr(FMenuAntwort,1,6)-2
				gosub Edit3Festigen
				gosub Edit3
				sleep 10
				gosub Button4
			}
			else
			{	; wenn Datei
				Edit3:=SubStr(FMenuAntwort,1,6)-2
				gosub Edit3Festigen
				gosub Edit3
				sleep 10
				gosub Button4
			}
			Clipboard:=
			MsgBox, 8192, Text /Pfad, Der Pfad / Text unten steht im Clipboard `n`n%DiesePfadAuswahlPfad%, 8
		}
	}
	else
	{	; rest
		ClipboardSic:=ClipboardAll
		Clipboard:=FuehrendeSterneEntfernen(SubStr(FMenuAntwort,7))
		Edit3:=SubStr(FMenuAntwort,1,6)-2
		gosub Edit3Festigen
		sleep 10
		WinActivate,ahk_id %DiesesWinHwnd%
		WinWaitActive,ahk_id %DiesesWinHwnd%,,1
		sleep 5
		IfWinActive,ahk_id %DiesesWinHwnd%
		{
			ControlClick,%DiesesFocussedControl%,ahk_id %DiesesWinHwnd%
			MouseClick,L,CaretXBestMerker,CaretYBestMerker
			sleep 20
		}
		IfWinActive,ahk_id %DiesesWinHwnd%
			send,{CtrlDown}v{CtrlUp}
		Clipboard:=ClipboardSic
	}
	return
}
;}
;}	
;}

~#.::	;{	
WinGetPos,DieseThisX,DieseThisY,DieseThisB,DieseThisH,ahk_id %GuiWinHwnd%
DieseThisBM12:=DieseThisB-12
; ahk_exe AutoHotkey.exe
; ToolTip,ZZO Menue
IfWinActive,ahk_id %GuiWinHwnd%
	Menu, MeineMenueleiste, Show,%DieseThisBM12%,0					;DieseThisX + DieseThisB, 0
else
	Menu, MeineMenueleiste, Show
; ToolTip
return
;}	
NurHauptMenuEin:	;{	
	Gui,6:New,
	Gui,6: Menu, MeineMenüleiste
	Gui,6:+Resize
	Gui,6: Show, w800 h1, ZackZackOrdnerNurMenue
	return
;}	
NurHauptMenuAus:	;{	
Gui,6: Hide
Gui,6: Destroy
return
;}	
~#v::	;{	oeffnet das (Clipboard-) Menue
ControlGetFocus,DiesesFocussedControl,A
DiesesWinHwnd:=WinExist("A")
WinGetTitle,DieserWinTitle,ahk_id %DiesesWinHwnd%
WinGetClass,DieseWinClass,ahk_id %DiesesWinHwnd%
Menu, ClipboardMenu, Show  
return
;}	
~LWin & n::	;{	Oeffnet ZZO neben Speichern Unter Dialog (AutoPop Ersatz)
gosub OpenGuiNebenAktWin
if MausGuenstigPositionieren
	MouseMove,A_CaretX+90*DpiKorrektur,A_CaretY+9*DpiKorrektur
return
;}	
~#ä::	;{	fuer Fehlersuche gibt mehr Meldungen aus
Fehlersuche:=true
return
;}	
~#ß::	;{	Fehlersuche ListLines
ListLines:
ListLines
return
;}	
:*:*§*::°	; HotString: gibt bei Eingabe von *§* den ZackZack-intern in Speichernamen dafuer verwendeten ° aus
:*:\§\::►	; HotString: gibt bei Eingabe von \§\ den ZackZack-intern in Speichernamen dafuer verwendeten ► aus
:?::§::	;{	HotString: gibt bei Eingabe von :§: den ZackZack-intern in Speichernamen dafuer verwendeten hochgestellten Doppelpunkt ˸ aus 
if (A_EndChar=DotOverDot)
	send ˸
return
;}	
~#z::	;{	hole minimiertes Fenster.	Hinweis: Bewirkt nicht das Gleiche wie Button Ordner oder #n.
gosub SelfActivate
if MausGuenstigPositionieren
	MouseMove,A_CaretX+90,A_CaretY+9
return
;}	
; < / ####################################### globale Hotkeys HotStrings ####################################### >
; < #######################################  E v e n t s  #################################################### >	;{
;	Suche				Suchnummer	Funktion
; - Haupt-Menue			@0290		Abhaengig vom Menu-Item
; - Button1 - n			@0270		Abhaengig vom Button
; - Edit1 - n			@0260		Abhaengig vom Feld. Fast alle Editfelder lassen sich sinnvol editieren
; - HakenName1 - n		@0260		Abhaengug vom Haken Kaken setzen oder entfernen
; - GuiDropFiles					Ahaengig von Empfangs-Control/-Pfad --> Kopie nach
; - WM_LBUTTONDBLCLK				Abhaengig vom Pfad
; - WM_LBUTTONDOWN					Abhaengig vom Pfad
; - Rechtsklick						Ahaengig von Empfangs-Control. Control=Integer -> Integermenu. Ohne -> Suche Zurueck setzen
; - onMessage 
; - OnExit							Skriptende
; < / ######################################  E v e n t s  #################################################### >
;}	
Edit4:	;{	@0264			; Befehlsentgegennahme. wirkt mit . am Ende wie eine MacroZeile	;}	
HwndEdit4:	;{	
Gui,1:Submit,NoHide
if(SubStr(Edit4,0)=".")
{
	StringTrimRight,Edit4,Edit4,1
	GuiControl,1:, %HwndEdit4%, %Edit4%
	Datenkopie:=Edit4
}
else
	return
;}	
; ohne Return
TimerEditUebernahme:	;{	BefehlsVerarbeitung.	; Warten auf eingehende Befehle von Tastatur, Datei oder Variable. Ist kein Timer mehr.
BeschaeftigtAnzeige(1)
; < KurzBefehle Uebersicht >	;{
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
;}	
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
		else If (DieseFunktionParameter0=8)
		{
			if(DieseFunktionsZuweisungsVariable="")
				{
				If(IsFunc(DieseFunktion))
				{
					Dummy:=%DieseFunktion%(FunktionUeberGabestringErzeugen(DieseFunktionParameter3),FunktionUeberGabestringErzeugen(DieseFunktionParameter4),FunktionUeberGabestringErzeugen(DieseFunktionParameter5),FunktionUeberGabestringErzeugen(DieseFunktionParameter6),FunktionUeberGabestringErzeugen(DieseFunktionParameter7),FunktionUeberGabestringErzeugen(DieseFunktionParameter8))
					BeschaeftigtAnzeige(-1)
					return
				}
			}
			else
			{
				If(IsFunc(DieseFunktion))
				{
					%DieseFunktionsZuweisungsVariable%:=%DieseFunktion%(FunktionUeberGabestringErzeugen(DieseFunktionParameter3),FunktionUeberGabestringErzeugen(DieseFunktionParameter4),FunktionUeberGabestringErzeugen(DieseFunktionParameter5),FunktionUeberGabestringErzeugen(DieseFunktionParameter6),FunktionUeberGabestringErzeugen(DieseFunktionParameter7),FunktionUeberGabestringErzeugen(DieseFunktionParameter8))
					BeschaeftigtAnzeige(-1)
					return
				}
			}
		}
		else If (DieseFunktionParameter0=9)
		{
			if(DieseFunktionsZuweisungsVariable="")
				{
				If(IsFunc(DieseFunktion))
				{
					Dummy:=%DieseFunktion%(FunktionUeberGabestringErzeugen(DieseFunktionParameter3),FunktionUeberGabestringErzeugen(DieseFunktionParameter4),FunktionUeberGabestringErzeugen(DieseFunktionParameter5),FunktionUeberGabestringErzeugen(DieseFunktionParameter6),FunktionUeberGabestringErzeugen(DieseFunktionParameter7),FunktionUeberGabestringErzeugen(DieseFunktionParameter8),FunktionUeberGabestringErzeugen(DieseFunktionParameter9))
					BeschaeftigtAnzeige(-1)
					return
				}
			}
			else
			{
				If(IsFunc(DieseFunktion))
				{
					%DieseFunktionsZuweisungsVariable%:=%DieseFunktion%(FunktionUeberGabestringErzeugen(DieseFunktionParameter3),FunktionUeberGabestringErzeugen(DieseFunktionParameter4),FunktionUeberGabestringErzeugen(DieseFunktionParameter5),FunktionUeberGabestringErzeugen(DieseFunktionParameter6),FunktionUeberGabestringErzeugen(DieseFunktionParameter7),FunktionUeberGabestringErzeugen(DieseFunktionParameter8),FunktionUeberGabestringErzeugen(DieseFunktionParameter9))
					BeschaeftigtAnzeige(-1)
					return
				}
			}
		}
		else If (DieseFunktionParameter0=10)
		{
			if(DieseFunktionsZuweisungsVariable="")
				{
				If(IsFunc(DieseFunktion))
				{
					Dummy:=%DieseFunktion%(FunktionUeberGabestringErzeugen(DieseFunktionParameter3),FunktionUeberGabestringErzeugen(DieseFunktionParameter4),FunktionUeberGabestringErzeugen(DieseFunktionParameter5),FunktionUeberGabestringErzeugen(DieseFunktionParameter6),FunktionUeberGabestringErzeugen(DieseFunktionParameter7),FunktionUeberGabestringErzeugen(DieseFunktionParameter8),FunktionUeberGabestringErzeugen(DieseFunktionParameter9),FunktionUeberGabestringErzeugen(DieseFunktionParameter10))
					BeschaeftigtAnzeige(-1)
					return
				}
			}
			else
			{
				If(IsFunc(DieseFunktion))
				{
					%DieseFunktionsZuweisungsVariable%:=%DieseFunktion%(FunktionUeberGabestringErzeugen(DieseFunktionParameter3),FunktionUeberGabestringErzeugen(DieseFunktionParameter4),FunktionUeberGabestringErzeugen(DieseFunktionParameter5),FunktionUeberGabestringErzeugen(DieseFunktionParameter6),FunktionUeberGabestringErzeugen(DieseFunktionParameter7),FunktionUeberGabestringErzeugen(DieseFunktionParameter8),FunktionUeberGabestringErzeugen(DieseFunktionParameter9),FunktionUeberGabestringErzeugen(DieseFunktionParameter10))
					BeschaeftigtAnzeige(-1)
					return
				}
			}
		}
		else If (DieseFunktionParameter0=11)
		{
			if(DieseFunktionsZuweisungsVariable="")
				{
				If(IsFunc(DieseFunktion))
				{
					Dummy:=%DieseFunktion%(FunktionUeberGabestringErzeugen(DieseFunktionParameter3),FunktionUeberGabestringErzeugen(DieseFunktionParameter4),FunktionUeberGabestringErzeugen(DieseFunktionParameter5),FunktionUeberGabestringErzeugen(DieseFunktionParameter6),FunktionUeberGabestringErzeugen(DieseFunktionParameter7),FunktionUeberGabestringErzeugen(DieseFunktionParameter8),FunktionUeberGabestringErzeugen(DieseFunktionParameter9),FunktionUeberGabestringErzeugen(DieseFunktionParameter10),FunktionUeberGabestringErzeugen(DieseFunktionParameter11))
					BeschaeftigtAnzeige(-1)
					return
				}
			}
			else
			{
				If(IsFunc(DieseFunktion))
				{
					%DieseFunktionsZuweisungsVariable%:=%DieseFunktion%(FunktionUeberGabestringErzeugen(DieseFunktionParameter3),FunktionUeberGabestringErzeugen(DieseFunktionParameter4),FunktionUeberGabestringErzeugen(DieseFunktionParameter5),FunktionUeberGabestringErzeugen(DieseFunktionParameter6),FunktionUeberGabestringErzeugen(DieseFunktionParameter7),FunktionUeberGabestringErzeugen(DieseFunktionParameter8),FunktionUeberGabestringErzeugen(DieseFunktionParameter9),FunktionUeberGabestringErzeugen(DieseFunktionParameter10),FunktionUeberGabestringErzeugen(DieseFunktionParameter11))
					BeschaeftigtAnzeige(-1)
					return
				}
			}
		}
		else If (DieseFunktionParameter0=12)
		{
			if(DieseFunktionsZuweisungsVariable="")
				{
				If(IsFunc(DieseFunktion))
				{
					Dummy:=%DieseFunktion%(FunktionUeberGabestringErzeugen(DieseFunktionParameter3),FunktionUeberGabestringErzeugen(DieseFunktionParameter4),FunktionUeberGabestringErzeugen(DieseFunktionParameter5),FunktionUeberGabestringErzeugen(DieseFunktionParameter6),FunktionUeberGabestringErzeugen(DieseFunktionParameter7),FunktionUeberGabestringErzeugen(DieseFunktionParameter8),FunktionUeberGabestringErzeugen(DieseFunktionParameter9),FunktionUeberGabestringErzeugen(DieseFunktionParameter10),FunktionUeberGabestringErzeugen(DieseFunktionParameter11),FunktionUeberGabestringErzeugen(DieseFunktionParameter12))
					BeschaeftigtAnzeige(-1)
					return
				}
			}
			else
			{
				If(IsFunc(DieseFunktion))
				{
					%DieseFunktionsZuweisungsVariable%:=%DieseFunktion%(FunktionUeberGabestringErzeugen(DieseFunktionParameter3),FunktionUeberGabestringErzeugen(DieseFunktionParameter4),FunktionUeberGabestringErzeugen(DieseFunktionParameter5),FunktionUeberGabestringErzeugen(DieseFunktionParameter6),FunktionUeberGabestringErzeugen(DieseFunktionParameter7),FunktionUeberGabestringErzeugen(DieseFunktionParameter8),FunktionUeberGabestringErzeugen(DieseFunktionParameter9),FunktionUeberGabestringErzeugen(DieseFunktionParameter10),FunktionUeberGabestringErzeugen(DieseFunktionParameter11),FunktionUeberGabestringErzeugen(DieseFunktionParameter12))
					BeschaeftigtAnzeige(-1)
					return
				}
			}
		}
		else If (DieseFunktionParameter0=13)
		{
			if(DieseFunktionsZuweisungsVariable="")
				{
				If(IsFunc(DieseFunktion))
				{
					Dummy:=%DieseFunktion%(FunktionUeberGabestringErzeugen(DieseFunktionParameter3),FunktionUeberGabestringErzeugen(DieseFunktionParameter4),FunktionUeberGabestringErzeugen(DieseFunktionParameter5),FunktionUeberGabestringErzeugen(DieseFunktionParameter6),FunktionUeberGabestringErzeugen(DieseFunktionParameter7),FunktionUeberGabestringErzeugen(DieseFunktionParameter8),FunktionUeberGabestringErzeugen(DieseFunktionParameter9),FunktionUeberGabestringErzeugen(DieseFunktionParameter10),FunktionUeberGabestringErzeugen(DieseFunktionParameter11),FunktionUeberGabestringErzeugen(DieseFunktionParameter12),FunktionUeberGabestringErzeugen(DieseFunktionParameter13))
					BeschaeftigtAnzeige(-1)
					return
				}
			}
			else
			{
				If(IsFunc(DieseFunktion))
				{
					%DieseFunktionsZuweisungsVariable%:=%DieseFunktion%(FunktionUeberGabestringErzeugen(DieseFunktionParameter3),FunktionUeberGabestringErzeugen(DieseFunktionParameter4),FunktionUeberGabestringErzeugen(DieseFunktionParameter5),FunktionUeberGabestringErzeugen(DieseFunktionParameter6),FunktionUeberGabestringErzeugen(DieseFunktionParameter7),FunktionUeberGabestringErzeugen(DieseFunktionParameter8),FunktionUeberGabestringErzeugen(DieseFunktionParameter9),FunktionUeberGabestringErzeugen(DieseFunktionParameter10),FunktionUeberGabestringErzeugen(DieseFunktionParameter11),FunktionUeberGabestringErzeugen(DieseFunktionParameter12),FunktionUeberGabestringErzeugen(DieseFunktionParameter13))
					BeschaeftigtAnzeige(-1)
					return
				}
			}
		}
		else If (DieseFunktionParameter0=14)
		{
			if(DieseFunktionsZuweisungsVariable="")
				{
				If(IsFunc(DieseFunktion))
				{
					Dummy:=%DieseFunktion%(FunktionUeberGabestringErzeugen(DieseFunktionParameter3),FunktionUeberGabestringErzeugen(DieseFunktionParameter4),FunktionUeberGabestringErzeugen(DieseFunktionParameter5),FunktionUeberGabestringErzeugen(DieseFunktionParameter6),FunktionUeberGabestringErzeugen(DieseFunktionParameter7),FunktionUeberGabestringErzeugen(DieseFunktionParameter8),FunktionUeberGabestringErzeugen(DieseFunktionParameter9),FunktionUeberGabestringErzeugen(DieseFunktionParameter10),FunktionUeberGabestringErzeugen(DieseFunktionParameter11),FunktionUeberGabestringErzeugen(DieseFunktionParameter12),FunktionUeberGabestringErzeugen(DieseFunktionParameter13),FunktionUeberGabestringErzeugen(DieseFunktionParameter14))
					BeschaeftigtAnzeige(-1)
					return
				}
			}
			else
			{
				If(IsFunc(DieseFunktion))
				{
					%DieseFunktionsZuweisungsVariable%:=%DieseFunktion%(FunktionUeberGabestringErzeugen(DieseFunktionParameter3),FunktionUeberGabestringErzeugen(DieseFunktionParameter4),FunktionUeberGabestringErzeugen(DieseFunktionParameter5),FunktionUeberGabestringErzeugen(DieseFunktionParameter6),FunktionUeberGabestringErzeugen(DieseFunktionParameter7),FunktionUeberGabestringErzeugen(DieseFunktionParameter8),FunktionUeberGabestringErzeugen(DieseFunktionParameter9),FunktionUeberGabestringErzeugen(DieseFunktionParameter10),FunktionUeberGabestringErzeugen(DieseFunktionParameter11),FunktionUeberGabestringErzeugen(DieseFunktionParameter12),FunktionUeberGabestringErzeugen(DieseFunktionParameter13),FunktionUeberGabestringErzeugen(DieseFunktionParameter14))
					BeschaeftigtAnzeige(-1)
					return
				}
			}
		}
		else If (DieseFunktionParameter0 > 14)
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
	else if(ErstesZeichenDieseDatenkopie="L" AND ZweitesZeichenDieseDatenkopie="o" AND DrittesZeichenDieseDatenkopie="o" AND ViertesZeichenDieseDatenkopie="p")
	{
		StringReplace,DieseDatenkopie,DieseDatenkopie,``n,`n,All
		StringSplit,ZeilenElement,DieseDatenkopie,`n,`r
		BefehlsMacroVorher:=BefehlsMacro
		BefehlsMacro:=
		Loop, % ZeilenElement0
		{
			if (A_Index <3)
				continue
			BefehlsMacro.=ZeilenElement%A_Index% "`r`n"
		}
		; MsgBox % BefehlsVariable "	" DieseDatenkopie
		Loop % ZeilenElement2
			gosub BefehlsVariableAusfuehren
		BefehlsMacro:=BefehlsMacroVorher
		DieseDatenkopie:=
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
;}	
HwndHwndCheckE0:	;{	
SuFi:=ViertesZeichenDieseDatenkopie
GuiControl,1:,%HwndCheckE0%, %ViertesZeichenDieseDatenkopie%
return
;}	
HwndHwndCheckE5:	;{	
RegEx:=ViertesZeichenDieseDatenkopie
GuiControl,1:,%HwndCheckE5%, %ViertesZeichenDieseDatenkopie%
return
dummy:=
return
;}	
LeseEin:	;{	
Gui,1:Submit,NoHide
If LeseEin
{
}	
else
		IndexierenBeenden:=True
return
;}	
AuswahlGuiAnzeigeFortgeschritten:	;{	
if GuiAnzeigeFortgeschritten
	gosub GuiFortegeschrittenenerModus
else
	gosub GuiAnfaengerModus
return
;}	
GuiFortegeschrittenenerModus:	;{	
; MenuKurzTasten:=true
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
;}	
GuiAnfaengerModus:	;{	
; MenuKurzTasten:=false
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
;}	
GuiSuperAnfaengerModus:	;{	verworfen das gewuenschte deckt [Win] + [b] ab		Stehen lassen als Nachschlagtabelle zum verstecken einzelner Controls. Auch von Macros verwendbar!
WinMove,ahk_id %GuiWinHwnd%,,,,600,150
Loop % 20
	GuiControl,1:Hide,Button%A_Index%
Loop % 60
	GuiControl,1:Hide,%A_Index%
GuiControl,1:Move, Edit2,x10 y10 ; 	w%A_GuiWidth%
GuiControl,1:Hide,gefundene
GuiControl,1:Hide,Ordner-`nNamen-Suche
GuiControl,1:Hide,Pfade
GuiControl,1:Hide,ausgewaehlte`nPfad Nr.
GuiControl,1:Hide,_┌─`n`n¯  \`n    ↓
GuiControl,1:Hide,MeineMenüleiste
GuiControl,1:Hide,Favoriten
GuiControl,1:Hide,FavMenue
GuiControl,1:Hide,Edit5UpDown
GuiControl,1:Hide,Pfad-Filter
GuiControl,1:Hide,Filter
GuiControl,1:Hide,beschaeftigt
GuiControl,1:Hide,Edit1
GuiControl,1:Hide,Edit3
GuiControl,1:Hide,Edit5
GuiControl,1:Hide,Edit7
GuiControl,1:Hide,Edit8
GuiControl,1:Hide,Edit10
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
;}	
RechsClickAufControl:	;{	
if A_GuiControl is integer
{
	Edit3:=A_GuiControl
	GuiControl,1:, Edit3, %Edit3%
	gosub Edit3
	gosub Button4
}
return
;}	
GuiSize:	;{	
	NeuerThread=GuiSize:
	ListLines,Off
	WinGetPos,DieseThisX,DieseThisY,DieseThisB,DieseThisH,ahk_id %GuiWinHwnd%
	Rahmenbreite:=4
	GuiYAbzuziehen := DieseThisH/DpiKorrektur - A_GuiHeight -2*Rahmenbreite/DpiKorrektur
	ListLines,On
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
if (A_TickCount-ContainerAnzeigeTime>5000 and SubStr(Edit10,1,10)="Container:")
{
	Edit10:="Zusatz"
	gosub Edit10Festigen
}
;}	
;	ohne Return
GuiSetSize:	;{	
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
return
;}	
Rekursiv:	;{	
Gui,1:Submit,NoHide
if Rekur
	Rekursiv=R
else
	Rekursiv=
return
;}	
ExpSel:	;{	
Gui,1:Submit,NoHide
return
;}	
OpenGuiNebenAktWin:	;{	
	WinActivate,ahk_class #32770
	WinWaitActive,ahk_class #32770,,1
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
	; SoundBeep 1578/3
	gosub EnterDruecktButton2
return
;}	
SuperFaVoritenEinfuehrung:	;{	
if not AufgerufenSuperFaVoritenBearbeiten
				MsgBox, 262144, SuperFavoriten, SuperFavoriten sind Container-unabhaengige schnell erreichbare Favoriten`,`ndie uebers Haupt-Menue rechts aufrufbar sind.`nBitte beim Bearbeiten die Leerzeile oben drinn lassen.`n`nAenderungen sind erst nach einem ZZO Neustart im Menue rechts sichtbar. 
AufgerufenSuperFaVoritenBearbeiten:=true
return
;}	
SortBS:	;{	Sortieren nach dem Ordnername ohne Pfad
BeschaeftigtAnzeige(1)
sort,Edit5,U \		
gosub Edit5Festigen
BeschaeftigtAnzeige(-1)
return
;}	
SortR:	;{	Sortierung Alphabetisch z...a
BeschaeftigtAnzeige(1)
sort,Edit5,U R
gosub Edit5Festigen
BeschaeftigtAnzeige(-1)
return
;}	
SortLen:	;{	Sortieren nach StrLen
BeschaeftigtAnzeige(1)
sort,Edit5,F NachStrLen
gosub Edit5Festigen
BeschaeftigtAnzeige(-1)
return
;}	
SortMTime:	;{	Sortieren nach Modification Time neu oben
BeschaeftigtAnzeige(1)
sort,Edit5,F NachMTime
gosub Edit5Festigen
BeschaeftigtAnzeige(-1)
return
;}	
SortMTimeR:	;{	Sortieren nach Modification Time alt oben
BeschaeftigtAnzeige(1)
sort,Edit5,F NachMTimeR
; sort,Edit5,F NachStrLen
gosub Edit5Festigen
BeschaeftigtAnzeige(-1)
return
;}	
SortBestAutoBewertung:	;{	Sortieren nach Bewertungskriterien
BeschaeftigtAnzeige(1)
StringReplace,Edit1NurInteger,Edit1,(,,
StringReplace,Edit1NurInteger,Edit1NurInteger,),,
if(Edit1NurInteger>10000+1)
{
	MsgBox, 262436, Sortieren nach Bewertungskriterien, Das Sortieren von %Edit1NurInteger% Fundstellen wird eine merkliche Zeit beanspruchen.`n`nwirklich durchfuehen?`n`n`nTip: Laengeren Suchbergriff in Edit2 verwenden!
	IfMsgBox,No
	{
		BeschaeftigtAnzeige(-1)
		return
	}
}
else if(Edit1NurInteger>1000+1)
{
	Edit10Merker:=Edit10
	Edit10:="Gedult	Gedult	Gedult	Gedult	Gedult	Gedult	Gedult"
	gosub Edit10Festigen
}
sort,Edit5,F AutoBewertung
gosub Edit5Festigen
if(Edit10="Gedult	Gedult	Gedult	Gedult	Gedult	Gedult	Gedult")
{
	Edit10:=Edit10Merker
	gosub Edit10Festigen
}
BeschaeftigtAnzeige(-1)
return
;}	
SortBestAutoBewertungNotWordList:	;{	
BeschaeftigtAnzeige(1)
IfExist %NotWordPath%
{
	; RunWait %NotWordPath% 
}
else
{
	NotWordBeschreibung=
(

Ergebnis-Nachsortierung: 
 - beinflusst durch Suchbegriffe der ersten 2 Zeilen dieser Datei
 - sowie schwaecher wirkendenden Optimierungs-Algorithmen (vorgegeben)

Die Kommagetrennten Listen in der ersten und zweiten Zeile, bestimmen Worte bzw. Wortteile,
die bei der Sortierung nach "Bester Uebereinstimmung",
und (speichern und) schliessen dieses Fensters
nach oben (1.Zeile) bzw. unten (2. Zeile) sortiert werden.

2 Spezial-Faelle:
Wenn in der 1. Zeile der letzte Eintrag ... oder . lautet steht dies fuer Ordner bzw. Dateien nach oben sortieren.
Achtung: bei beiden Spezial-Faellen wird mehrfach die Existenz von Datei-Pfaden geprueft,
Bei Pfaden von langsamen Netzlaufwerken bzw. bei Favoriten deren Pfade mit \\ beginnen kann dies zum Gedultsspiel werden.

Default-Werte erhaelt man durch loeschen von 
	%NotWordPath%

Folgende Worte werden auch oft benutzt:
temporary,.tmp,c:\,d:\

Zeile 1 hat Vorrang vor Zeile 2
d.h.  ein Pfad der Wort-Teile sowohl in der 1. Zeile als auch in der 2. Zeile enthaelt,
landet oben (hinter den Zeilen, die in der 1. Zeile nicht aber in der 2. Zeile Wort-Teile enthalten).

Hier ist Platz fuer Muster-Vorlagen:

Beispiele:
Laufwerk c: bevorzugen:
c:\
$Recycle.Bin,!Fav,$$$

Laufwerk c: und d: benachteiigen:

$Recycle.Bin,!Fav,$$$,c:\,d:\

Ordner bevorzugen:
...
$Recycle.Bin,!Fav,$$$

Dateien bevorzugen:
.
$Recycle.Bin,!Fav,$$$

Achtung:

$Recycle.Bin,!Fav,$$$,...
In der 2. Zeile wird "..." ohne Sonderbehandlung als Suchbegriff interpraetiert.

)
	StringReplace,NotWordBeschreibung,NotWordBeschreibung,`n,`r`n,All
	FileAppend, `r`n%NotWord%`r`n%NotWordBeschreibung%,%NotWordPath%,utf-16
}
IfExist %NotWordPath%
{
	RunWait NotePad.exe %NotWordPath% 
}
gosub SortBestAutoBewertung
BeschaeftigtAnzeige(-1)
return
;}	
AutoBewertung(a,b)	;{()	
{
	Global Edit2,ProtokollKenner,Edit11,Edit12,NotWordPath,NotWord
	WortTrenner=%A_Space%,%A_Tab%,_,-,`,,!,.,/
	IfExist,%NotWordPath%
	{
		FileReadLine,PrefWord,%NotWordPath%,1
		FileReadLine,NotWord,%NotWordPath%,2
	}
		
	abew:=0
	bbew:=0
	GKFakt:=0.3		; Groess/Klein exakt 
	ReFakt:=0.3		; Fund wie weit rechts

	GlFakt:=0.4		; Gesamt Laengen Verhaeltnis
	WtFakt:=0.4		; WortTrenn
	OtFakt:=0.6		; OrdnerTrenn
	if(PrefWord<>"")
	{
		if(SubStr(PrefWord,0)=".")
		{
			if(SubStr(PrefWord,-3)=",..." or PrefWord="...")
			{
				if (InStr(FileExist(a),"D"))
					abew:=abew + 10
				if (InStr(FileExist(b),"D"))
					bbew:=bbew + 10
				if(SubStr(PrefWord,-3)=",...")
					StringTrimRight,PrefWord,PrefWord,4
				else
					StringTrimRight,PrefWord,PrefWord,3
			}
			else if(SubStr(PrefWord,-1)=",." or PrefWord=".")
			{
				if (not InStr(FileExist(a),"D"))
					abew:=abew + 10
				if (not InStr(FileExist(b),"D"))
					bbew:=bbew + 10
				if(SubStr(PrefWord,-1)=",.")
					StringTrimRight,PrefWord,PrefWord,2
				else
					StringTrimRight,PrefWord,PrefWord,1
			}
		}
		if(PrefWord<>"")
		{
			if a contains %PrefWord%
				abew:=abew + 10
			if b contains %PrefWord%
				bbew:=bbew + 10
		}
	}
/*	
	if(NotWord<>"")
	{
		if(SubStr(NotWord,0)=".")
		{
			if(SubStr(NotWord,-3)=",..." or NotWord="...")
			{
				if (InStr(FileExist(a),"D"))
					abew:=abew - 5
				if (InStr(FileExist(b),"D"))
					bbew:=bbew - 5
				if(SubStr(NotWord,-3)=",...")
					StringTrimRight,NotWord,NotWord,4
				else
					StringTrimRight,NotWord,NotWord,3
			}
			else if(SubStr(NotWord,-1)=",." or NotWord=".")
			{
				if (not InStr(FileExist(a),"D"))
					abew:=abew - 5
				if (not InStr(FileExist(b),"D"))
					bbew:=bbew - 5
				else if(SubStr(NotWord,-1)=",.")
					StringTrimRight,NotWord,NotWord,2
				else
					StringTrimRight,NotWord,NotWord,1
			}
		}
*/
		if(NotWord<>"")
		{
			if a contains %NotWord%
				abew:=abew - 5
			if b contains %NotWord%
				bbew:=bbew - 5
		}
;	}

	(IfFileOderDirSyntax(a) and IfFileOderDirSyntax(b))
	{
		

		GesLena:=Strlen(a)
		GesLenb:=Strlen(b)
		SplitPath,a,,,,aName
		if(aName<>"")
		{
			a:=aName
			aNameLen:=StrLen(aName)
		}
		SplitPath,b,,,,bName
		if(bName<>"")
		{
			b:=bName
			bNameLen:=StrLen(bName)

		}
	}
	if(InStr(Edit2,ProtokollKenner))
	{
		a11Pos:=InStr(a,Edit11)
		Vora11Char:=SubStr(a,a11Pos-1,1)
		if Vora11Char in %WortTrenner%
			abew:=abew + WtFakt
		if (Vora11Char="\")
			abew:=abew + OtFakt
		if a11Pos
			abew:=abew+StrLen(Edit11)/aNameLen
		b11Pos:=InStr(b,Edit11)
		Vorb11Char:=SubStr(b,b11Pos-1,1)
		if Vorb11Char in %WortTrenner%
			bbew:=bbew + WtFakt
		if (Vorb11Char="\")
			bbew:=bbew + OtFakt
		if b11Pos
			bbew:=bbew+StrLen(Edit11)/bNameLen
		a12Pos:=InStr(a,Edit12)
		Vora12Char:=SubStr(a,a12Pos-1,1)
		if Vora12Char in %WortTrenner%
			abew:=abew + WtFakt
		if (Vora12Char="\")
			abew:=abew + OtFakt
		if a12Pos
			abew:=abew+StrLen(Edit12)/aNameLen
		b12Pos:=InStr(b,Edit12)
		Vorb12Char:=SubStr(b,b12Pos-1,1)
		if Vorb12Char in %WortTrenner%
			bbew:=bbew + WtFakt
		if (Vorb12Char="\")
			bbew:=bbew + OtFakt
		if b12Pos
			bbew:=bbew+StrLen(Edit12)/bNameLen
		
		
		if(InStr(a,Edit11,1))
			abew:=abew*GKFakt + (a11Pos + StrLen(Edit11)) / aNameLen * ReFakt
		
		if(InStr(b,Edit11,1))
			bbew:=bbew*GKFakt + (b11Pos + StrLen(Edit11)) / bNameLen * ReFakt
		
		if(InStr(a,Edit12,1))
			abew:=abew*GKFakt + (a12Pos + StrLen(Edit12)) / aNameLen * ReFakt
		
		if(InStr(b,Edit12,1))
			bbew:=bbew*GKFakt + (b12Pos + StrLen(Edit12)) / bNameLen * ReFakt
		
	}
	else
	{
		a2Pos:=InStr(a,Edit2)
		Vora2Char:=SubStr(a,a2Pos-1,1)
		if Vora2Char in %WortTrenner%
			abew:=abew + WtFakt
		if (Vora2Char="\")
			abew:=abew + OtFakt
		if a2Pos
			abew:=abew+StrLen(Edit2)/StrLen(a)
		b2Pos:=InStr(b,Edit2)
		Vorb2Char:=SubStr(b,b2Pos-1,1)
		if Vorb2Char in %WortTrenner%
			bbew:=bbew + WtFakt
		if (Vorb2Char="\")
			bbew:=bbew + OtFakt
		if b2Pos
			bbew:=bbew+StrLen(Edit2)/StrLen(b)
		if(InStr(a,Edit2,1))
			abew:=abew + GKFakt
		if(InStr(b,Edit2,1))
			bbew:=bbew + GKFakt
		
		abew:=abew + (a2Pos + StrLen(Edit2)) / (StrLen(a)) * ReFakt
		bbew:=bbew + (b2Pos + StrLen(Edit2)) / (StrLen(b)) * ReFakt
		
	}
	Delta:=(GesLena-GesLenb)/(GesLena+GesLenb)*GlFakt		; (5-10)/(5+10)= -0.333
	abew:=abew - Delta
	bbew:=bbew + Delta										;				= 0.333
	if(abew > bbew)
		return -1
	else if(abew < bbew)
		return 1
	else if(abew = bbew)
		return 0
	else
		MsgBox var nicht besetzt >%a%<	>%b%<
	return 0
}
;}	
SucheInEdit5Markieren:	;{	
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
	DiesesLinkZiel:=DiesesEdit8Sternlos
	; ToolTip,%DiesesLinkZiel%,300,5,19
	IfNotExist %Edit10%
		Edit10:="LinkZiel	" DiesesLinkZiel
	gosub Edit10Festigen
}
else if(SubStr(Edit10,1,8)="LinkZiel")
{
	DiesesLinkZiel:=
	Edit10:=DiesesLinkZiel
	gosub Edit10Festigen
}
if (ThisEdit8Exist or InStr(DiesesEdit8Sternlos,"http:") or InStr(DiesesEdit8Sternlos,"https:") or InStr(DiesesEdit8Sternlos,"ftp:") or or InStr(DiesesEdit8Sternlos,"File:"))
	OnlyFirstChar:=false
{
	ControlGetFocus,ThisFocussedControl,A
	if (ThisFocussedControl="Edit5")
		return
	StringReplace,NurSterneWegEdit8,Edit8,*,,all
	if(instr(Edit8,Hochkomma Hochkomma))
	{
		StringReplace,FuerEdit8Pfad,NurSterneWegEdit8,% Hochkomma Hochkomma,% Hochkomma,All
		StringSplit,EinzelParameter,FuerEdit8Pfad,%Hochkomma%
		IfExist  % EinzelParameter2
		{
			MarkiereSuchtext(EinzelParameter2,"Edit5","ahk_id " GuiWinHwnd,1)
			SplitPath,EinzelParameter2,ThisMarkierName,ThisMarkierfolder
			if(ThisMarkierName<>"")
				MarkiereSuchtext(ThisMarkierName,"Edit8","ahk_id " GuiWinHwnd,1)
			else
				MarkiereSuchtext(ThisMarkierfolder,"Edit8","ahk_id " GuiWinHwnd,1)
			return
		}
		else
			MarkiereSuchtext(EinzelParameter2,"Edit5","ahk_id " GuiWinHwnd,1,OnlyFirstChar)
		
	}
	else IfExist %NurSterneWegEdit8%
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
;}	
imHauptprogrammOrdnerDetailierungsSkripte:	;{	
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
;}	
PrufenUndStarteOrdnerDetailierungsSkripte:	;{	
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
;}	
Button1OhneMausPos:	;{	
MerkerMausGuenstigPositionieren:=MausGuenstigPositionieren
MausGuenstigPositionieren:=false
gosub Button1
MausGuenstigPositionieren:=MerkerMausGuenstigPositionieren
return
;}	
~#ü::	;{	fuer die Fehlersuche, zeigt zeitnah listvars 
AnzListvars:=true
return
;}	



WM_LBUTTONDOWN(wParam, lParam, Meldungsnummer,HWND){	;{()
	global Edit5Hoehe, GuiWinHwnd, GuiHeight, HwndEdit3, DpiKorrektur, Edit5Y0, ZeilenVersatzY,HwndEdit5,Edit3,A_DebuggerName,ExternalToolTipPath,Edit5,Edit5Selected

	If(HWND=HwndEdit5)
	{

		ControlGet,Edit5Selected, Selected,,Edit5, ahk_id %GuiWinHwnd%
	}
}
WM_LBUTTONUP(wParam, lParam, Meldungsnummer,HWND)	;{()
{
	global Edit5Hoehe, GuiWinHwnd, GuiHeight, HwndEdit3, DpiKorrektur, Edit5Y0, ZeilenVersatzY,HwndEdit5,Edit3,A_DebuggerName,ExternalToolTipPath,Edit5,Edit5Selected,Edit8
	If(HWND=HwndEdit5)
	{
		; MsgBox % wParam "	" lParam "	" Meldungsnummer "	" HWND
		; Gui,1:Submit,NoHide
		; Sleep 10
		; SetControlDelay 20 ; verhindert das festkleben von Selektionen am Mauszeiger. ; klapppt hier nicht
		; ControlGet,DieseSelected, Selected,,Edit5, ahk_id %GuiWinHwnd%
		; ControlGet,DieseLineCount, LineCount,,Edit5, ahk_id %GuiWinHwnd%
		ControlGet,DieseCurrentCol, CurrentCol,,Edit5, ahk_id %GuiWinHwnd%
		ControlGet,DieseCurrentLine, CurrentLine,,Edit5, ahk_id %GuiWinHwnd%
		; Sleep 10
		; ControlGet,DieseCurrentCol, CurrentCol,,Edit5, ahk_id %GuiWinHwnd%
		; ControlGet,DieseCurrentLine, CurrentLine,,Edit5, ahk_id %GuiWinHwnd%
		;~ if(Edit5Selected<>"" AND InStr(Edit8,Edit5Selected)) 	  Selektions-Anzige weg gelassen, da Beschraenkung auf "nur bei Darufklicken" so nicht funktioniert
		;~ {
			;~ if(StrLen(Edit5Selected)<60)
				;~ Edit5SelectedAnzeige:=A_Tab Edit5Selected
			;~ else
				;~ Edit5SelectedAnzeige:=A_Tab SubStr(Edit5Selected,1,50) "..." SubStr(Edit5Selected,-5)
		;~ }
		RunOtherAhkScriptOrExe(ExternalToolTipPath,"" DieseCurrentLine ":" DieseCurrentCol Edit5SelectedAnzeige) ; "	" DieseLineCount ">" Selected "<")
		Edit3:=DieseCurrentLine
		gosub Edit3Festigen
		gosub Edit3 
		gosub SucheInEdit5Markieren
	}
	
	return
}
;}	
WM_LBUTTONDBLCLK(wParam, lParam)	;{()	Doppelklick
{
	global Edit5Hoehe, GuiWinHwnd, GuiHeight, HwndEdit3, DpiKorrektur, Edit5Y0, ZeilenVersatzY,HwndEdit5,Edit3,Edit2,Edit8,Edit10,NrRowKenner,NrRexKenner
	IfWinNotActive, ahk_id %GuiWinHwnd%
		return

    X := lParam & 0xFFFF
    Y := lParam >> 16
	MouseGetPos,Xx,Yy
			WinGetPos,DieseThisX,DieseThisY,DieseThisB,DieseThisH,ahk_id %GuiWinHwnd%
	ControlGetPos,xxX,yyY,ThisB,ThisH,,ahk_id %HwndEdit5%
	If( yy>yyy and y<ThisH and yy<DieseThisH-50*DpiKorrektur and xx<DieseThisB-17*DpiKorrektur and xx>xxx) 
	{
		ThisZeile:=Round(y/DpiKorrektur/ZeilenVersatzY+0.5)
		if(ThisZeile<1)
			return 
		Edit3:=ThisZeile
		GuiControl,1:, %HwndEdit3%, %ThisZeile%
		gosub Edit3
		gosub SucheInEdit5Markieren
		
		; Sleep 500
		EckigeKlammerZuPhisPos:=InStr(Edit8,"]#")
		; MsgBox % Edit8 "	" EckigeKlammerZuPhisPos
		DiesesWinAktivieren:=false
		if EckigeKlammerZuPhisPos
		{
			DiesesWinHwnd:=SubStr(Edit8,EckigeKlammerZuPhisPos+2)
			if DiesesWinHwnd is Integer
				DiesesWinAktivieren:=true
		}
		; MsgBox %Edit8%
		if (Edit8="" OR Edit8=0)
			return

		if(InStr(Edit2,NrRowKenner) or InStr(Edit2,NrRexKenner))
		{
			
			if(InStr(Edit2,"SuchbegriffsObenNeu") OR InStr(Edit2,"SuchStringSpeicher") OR InStr(Edit2,"Help_Quell.txt"))
			{
				gosub GetAngezeigteSuche
				return
			}
			else			
			; MsgBox % Edit2
				gosub SciteAtEdit8
		}
		else if DiesesWinAktivieren
		{
			WinActivate,ahk_id %DiesesWinHwnd%
		}
		else 
		{
			IfExist %Edit10%
			{
				gosub Edit8OeffnenMit
			}
			else
				gosub Edit8Oeffnen
		}
		return
	}
	return
}
;}	
EnterDruecktButton2:
ControlFocus,Button2,ahk_id %GuiWinHwnd%
Button2DoNothing:=true
ControlClick,,ahk_id %HwndButton2% ; ,ahk_id %GuiWinHwnd%
return
EnterDruecktButton4:
ControlFocus,Button4,ahk_id %GuiWinHwnd%
Button4DoNothing:=true
ControlClick,,ahk_id %HwndButton4% ; ,ahk_id %GuiWinHwnd%
return
SASize:	;{	wird aufgerufen wenn ZZO positionsgleich wie ein ExplorerFenster werden soll.
WinActivate,ahk_class CabinetWClass
WinWaitActive,ahk_class CabinetWClass,,1 ; 0.3
SetPathExplorerHwnd:=WinExist("A") 
WinGetPos,ExplWinX,ExplWinY,ExplWinB,ExplWinH,ahk_class CabinetWClass ahk_id %SetPathExplorerHwnd%
if (ExplWinX<>"" and ExplWinY<>"" and ExplWinB<>"" and ExplWinH<>"")
{
	gosub IfMainGuiMinRestore
	if(ExplWinB*1.5<A_ScreenWidth or ExplWinH*1.5<A_ScreenHeight)
		WinMove,ahk_id %GuiWinHwnd%,,%ExplWinX%,%ExplWinY%,%ExplWinB%,%ExplWinH%
}
else
{
}
;}	
;	ohne Return
A:	;{	aktiviere GuiWin	;}	
SA:	;{	aktiviere GuiWin	;}	
SelfActivate:	;{	aktiviere GuiWin
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
FokusEdit2Rechts()

if (MausGuenstigPositionieren and A_ThisLabel="SASize")
	MouseMove,A_CaretX+90,A_CaretY+9
gosub EnterDruecktButton4

return
;}	
LV:	;{	
ListVars
return
;}	
2b2:	;{	
;~ Edit2:=Edit2*2
;}	
; ohne Return
sb2:	;{	
		Gui,1:Submit,NoHide
;}	
; ohne Return
bs2:	;{	
		GuiControl,1:, %HwndEdit2%, %Edit2%
		Gui,1:Submit,NoHide
return
;}	
b2:	;{	
		Gui,1:Submit,NoHide
;}	
; ohne Return
2:	;{	
		GuiControl,1:, %HwndEdit2%, %Edit2%
return
;}	
ExplorerPfadEingeben:
Ex:	;{	ExplorerPfad eingeben
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
	{
		; ControlClick,ToolbarWindow323,ahk_class CabinetWClass ; deaktiviert, da sich manchmal Notepad angesprochen fuehlte
	}
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
{
	ControlSend,Edit1,{Enter},A
}
else
{
	IfWinNotActive,ahk_class CabinetWClass
	{
		WinActivate,ahk_class CabinetWClass 	
		WinWaitActive,ahk_class CabinetWClass,,1 
	}
	ControlFocus,ComboBox1,A
	Send {F4}
	Sleep 100
	Send {CtrlDown}a{CtrlUp}
	Sleep 100
	ControlSetText,Edit1,% FuehrendeSterneEntfernen(Edit8),ahk_class CabinetWClass
	Sleep 500
	send {Enter}
	Sleep 500
;	send {F5}
;	sleep 500
}
return
;}	
GetAWinInfosHtml:	;{	
MsgBox FensterDetail-Informationenn:`n`nes ist 10 Sekundden Zeit um nach Ok das gewuenschte Fenster zu oeffnen und das Control zu fokusieren
sleep, 10000
HWND:=WinExist("A")						; wwenn HWND:="" werden Fehlerhafte Infos ueber alle bekannten Controls ausgegeben 
;}	
; ohne Return
FensterHtmlInfos:	;{	
HTML_Liste:=WinConIndex(HWND)
ThisHtmlPath=%A_AppDataCommon%\Fensterinfo_%A_Now%.htm
FileAppend,%HTML_Liste%,%ThisHtmlPath%,utf-16
if ZackZackOrdnerLogErstellen
	ThreadUeberwachungLog(A_LineNumber-1,A_ThisHotkey,A_ThisLabel,A_ThisFunc,A_ThisMenu,A_ThisMenuItem,A_ThisMenuItemPos)
run %ThisHtmlPath%
if ZackZackOrdnerLogErstellen
	ThreadUeberwachungLog(A_LineNumber-1,A_ThisHotkey,A_ThisLabel,A_ThisFunc,A_ThisMenu,A_ThisMenuItem,A_ThisMenuItemPos)
return
;}	
String2Hex(String)	;{()	gibt es sicherlich effizientere Funktionen als diese hier
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
;}	
IfMainGuiMinRestore:	;{	
	WinGet,GuiMinMax,MinMax,ahk_id %GuiWinHwnd%
	if(GuiMinMax=-1)
	{
		WinRestore,ahk_id %GuiWinHwnd%
	}
return
;}	
GuiDropFiles:	;{	
{
	BeschaeftigtAnzeige(1)
	GuiEventIstDir:=false
	GuiEventIstFile:=false
	GuiEventIstFile:=false
	GuiEventIstEinzelPfad:=false
	GuiEventExt:=
	IfExist %A_GuiEvent%
	{
		if(StrLen(A_GuiEvent)>1)
		{
			GuiEventIstEinzelPfad:=true

			if (InStr(FileExist(A_GuiEvent),"D"))
				GuiEventIstDir:=true
			else
			{
				GuiEventIstFile:=true
				SplitPath,A_GuiEvent,,,GuiEventExt
			}
		}
	}
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
		Zielpfad:=FuehrendeSterneEntfernen(Zielpfad)
			DateiPfadeWerdenUebergeben:=true
			DateiPfade:=A_GuiEvent
			if(not OeffnenMitDateiPfade(DateiPfade,Zielpfad))
				gosub KopiereOderVerschiebeFilesAndFolders
		BeschaeftigtAnzeige(-1)		
		return		
	}
	else If (A_GuiControl="Edit1" and GuiEventExt="log")
	{
		Edit8:=A_GuiEvent
		gosub Edit8Festigen
		gosub Edit8QuellTextAnzeigen
		gosub Button1
		gosub SitzungsEinstellungenMerken
		BeschaeftigtAnzeige(-1)
		return
	}
	else If (A_GuiControl="Edit10")
	{
		If(Edit10="" or Edit10="Zusatz"  or  Edit10="Quelltext" )  ; ; IfNotExist %Edit10%
		{
			if(Edit10<>"Quelltext")
			{
				FileSelectFile,UbergabeProgramPfad,,,zu welchem Skript oder Programm sollen die Dateien uebergeben werden? [ESC] für Quelltext Anzeige,ausfuehrbare Dateien (*.*; *.ahk; *.exe; *.bat)
				DieserErrorLevel:=ErrorLevel
			}
			else
				DieserErrorLevel:=1
			if DieserErrorLevel
			{
				; MsgBox %A_GuiEvent%
				IfExist %A_GuiEvent%
				{
					
					
					Edit2:=FileKenner A_GuiEvent A_Space NrRowKenner A_Space DieseSuche
					gosub Edit2Festigen
					SucheAbgebrochen:=false
					Edit1:=ZaehleZeilen(Edit5)	; Change372a
					gosub Edit1Festigen
					ControlSend,Edit2,{End},ahk_id %GuiWinHwnd%
					; OpenWithScitePath:=A_ScriptFullPath
					OpenWithScitePath:=A_GuiEvent
					DieseSuche:=

					if(Edit10<>"Quelltext")
						MsgBox Die Aktion wurde `nals Quelltext in Edit5 anzeigen`n von `n%A_GuiEvent%`n interpraetiert.`nSuchbegriff eingeben um Zeilen zu filtern.
					Edit10:="Quelltext"
					gosub Edit10Festigen
				}
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
		; gosub Edit3
		gosub HwndEdit3
		}
		DateiPfadeWerdenUebergeben:=true
		ControlText:=
		DateiPfade:=A_GuiEvent
		if(not OeffnenMitDateiPfade(DateiPfade,Edit8))
			gosub KopiereOderVerschiebeFilesAndFolders
		BeschaeftigtAnzeige(-1)
		return
	}
}
return	;	Beim Umstellen auf Alles Einklappbar zugefuegt ToDo pruefen ob OK
;}	
Integer3Hex(Int,NullX="")	;{()	NullX=[|x|X]		leer	->	hex (ohne Ox)		; 		x	->	0xhex		;		X	->	0xHEX
{
	if (NullX="")
		Hex:=Format("{1:x}",Int)
	else 
		Hex:=Format("{1:#" NullX "}",Int)
	return Hex
}
;}	
MinusStern_VorbereitetZumLoeschen:	;{	
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
;}	
SpezialOrdnerAnlegen:	;{	
; Arbeitsplatz Dieser PC.{20d04fe0-3aea-1069-a2d8-08002b30309d}
ClsIdVorlage=
(
Haeufig besuchte Orte Zuletzt verwendet Recent Places.{22877A6D-37A1-461A-91B0-DBDA5AAEBC99}
Systemsteuerung alle Tasks.{ED7BA470-8E54-465E-825C-99712043E01C}
Drucker.{2227A280-3AEA-1069-A2DE-08002B30309D}
)
loop,Parse,ClsIdVorlage,`n,`r
{
	FileCreateDir,% A_AppDataCommon "\Zack\ClsId\" A_LoopField
}
return
;}	
DrivesListErzeugen:	;{	
DriveNamesPfadList:=
; EnvGet, windir, windir
DriveGet,DriveNames1CList,List
StringSplit,LaufwerksBuchstabe,DriveNames1CList
Loop, % LaufwerksBuchstabe0
{
	DriveGet, DriveTyp, type,% LaufwerksBuchstabe%A_Index% ":"
	; if (DriveTyp<>"CDROM")		; CDROM wird doch auch benoetigt
	DriveNamesPfadList.=LaufwerksBuchstabe%A_Index% ":`r`n"
	;  MsgBox % LaufwerksBuchstabe%A_Index% ":	" DriveTyp
}
StringTrimRight,DriveNamesPfadList,DriveNamesPfadList,2
return
;}	
Edit5UpDown:	;{	
Gui,1:Submit,NoHide
IfWinActive,ahk_id %GuiWinHwnd%
{
	ControlGetFocus,ThisFocussedControl,A
	if (ThisFocussedControl="Edit5")
	{
		ControlFocus,Edit2,A
		; SoundBeep 2929/2
	}
}
	Edit3:=Edit5UpDown
	GuiControl,1:, %HwndEdit3%, %Edit3%
return
;}	
Up100:	;{	blaettert 100 Zeilen in der PfadListe Edit5 nach oben. Dito fuer die Folgenden Up#
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
;}	
Down100:	;{	blaettert 100 Zeilen in der PfadListe Edit5 nach unten. Dito fuer die Folgenden Down#
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
;}	
#IfWinActive,ZackZackOrdner ahk_class AutoHotkeyGUI	; ------------------ unten Hotkeys nur fuer ZZO ---------------------------::
/*
:*:   ::	; statt 3 Leerzeichen ein Tabulator		Deaktiviert
Clipboardvor:=ClipboardAll
Clipboard:=A_Tab
Send {Control down}v{Control up}
Clipboard:=Clipboardvor
return
*/
:C*:NICHT::¬	; Macht aus NOT daas Zeichen ¬
:*:v   ::	;{	 statt v + 3 Leerzeichen ein vertikaler Tabulator
Clipboardvor:=ClipboardAll
Clipboard:="`v"
Send {Control down}v{Control up}
Clipboard:=Clipboardvor
return
;}		
Up::	;{	eine Zeile hoch bei den Pfadmarkierungen	;}	
ImmerUp:	;{	eine Zeile hoch bei den Pfadmarkierungen
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
;}	
Down::	;{	eine Zeile runter bei den Pfadmarkierungen	;}	
ImmerDown:	;{()	eine Zeile runter bei den Pfadmarkierungen
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
;}	
F1::	;{	gib die Hilfe aus.
gosub Hilfe
return
;}	
^f::	;{	fokussiert und markiert Edit2	;}	
F2::	;{	springe in Edit2 Suche und markiere alles zum ueberschreiben. P.S. anhaengen von \*, an den Suchstring, zeigt bei existierendem Such-Ergebnis, die Unterordner an.
Edit3:=1
GuiControl,1:, %HwndEdit3%, %Edit3%
ControlFocus,Edit2,A
; SoundBeep 3231/3
sleep 10
; ControlSend,Edit2,{CtrlDown}a{CtrlUp},A
FokusEdit2Rechts()
return
;}	
Edit31F2:	;{	Edit3 --> 1 gefolgt von springe in Edit4 Befehlsentgegennahme und markiere alles zum ueberschreiben. 
Edit3:=1
GuiControl,1:, %HwndEdit3%, %Edit3%
;}	
; ohne Return
~#F2::	;{	springe in Edit4 Befehlsentgegennahme und markiere alles zum ueberschreiben. 
ControlFocus,Edit4,A
sleep 10
; ControlSend,Edit4,{Ctrl Down}a{Ctrl Up},A
ControlSend,Edit4,{CtrlDown}a{CtrlUp},A
return
;}	
~#F3::	;{	springe in Edit7 Filter und markiere alles zum ueberschreiben.
Edit3:=1
GuiControl,1:, %HwndEdit3%, %Edit3%
ControlFocus,Edit7,A
sleep 10
ControlSend,Edit7,{CtrlDown}a{CtrlUp},A
return
;}	
F3::	;{	springe in Edit3 Nr. Wahl und markiere alles zum ueberschreiben.
ControlFocus,Edit3,A
sleep 10
ControlSend,Edit3,{CtrlDown}a{CtrlUp},A
return
;}	
F11::	;{	springe in Edit11 Pfad-Muster und markiere alles zum ueberschreiben.
if(NOT InStr(Edit2,ProtokollKenner))
{
	IfExist % (FuehrendeSterneEntfernen(Edit8))
		gosub InhalteInTextFormAnzeigen
	else if (StrLen(Edit8)=1)		; fuer manuelle Eingabe des Laufwerkbuchstabens
	{
		IfExist % Edit8 ":"
		{
			Edit8.=":"
			Edit2Vorher:=Edit2
			gosub Edit8Festigen
			gosub InhalteInTextFormAnzeigen
			Edit11:=Edit2Vorher
			gosub Edit11Festigen
		}
	}
}
ControlFocus,Edit11,A
sleep 10
ControlSend,Edit11,{CtrlDown}a{CtrlUp},A
return
;}	
F12::	;{	springe in Edit11 Pfad-Muster und markiere alles zum ueberschreiben.
if(NOT InStr(Edit2,ProtokollKenner))
{
	IfExist % (FuehrendeSterneEntfernen(Edit8))
		gosub InhalteInTextFormAnzeigen
	else if (StrLen(Edit8)=1)		; fuer manuelle Eingabe des Laufwerkbuchstabens
	{
		IfExist % Edit8 ":"
		{
			Edit8.=":"
			Edit2Vorher:=Edit2
			if (Edit2Vorher="")
			{
				EvalButton1Only:=true
				gosub EvalButton1OnlyFestigen
				Edit11Exist:=true
				Edit12Exist:=true
				GuiControl, Show,%HwndEdit11%
				GuiControl, Show,%HwndEdit12%
				RunOtherAhkScriptOrExe(ExternalToolTipPath,"Warte-Haken gesetzt`nErgebnisse nur nach Button1!")
			}
			gosub Edit8Festigen
			gosub InhalteInTextFormAnzeigen
			Edit11:=Edit2Vorher
			gosub Edit11Festigen
		}
	}
}
ControlFocus,Edit12,A
sleep 10
ControlSend,Edit12,{CtrlDown}a{CtrlUp},A
; ControlSend,Edit12,^a,A
return
;}	
EvalButton1Only:	;{	
Gui,1:Submit,NoHide
return
;}	
beschaeftigt:	;{	
; ControlClick,Button1,ahk_id %GuiWinHwnd%
if not beschaeftigt
	gosub F5
else
	AllesAbbrechen:=true
return
;}	
~#F4::	;{	Oeffnet Edit8
gosub Edit8Oeffnen
return
;}	
F4::	;{	aktiviert letzten Container
gosub LetzterContainerStartMenu  
sleep 100
FokusEdit2Rechts()
return
;}	
F5::	;{	wie betaetigen von Button1 -> zum aktualisieren einiger Edit-Felder. funktionierte virtuell geklickt nicht immer 100-Prozentig.
 ControlClick,,ahk_id %HwndButton1%
return
;}	
F6::	;{	wie betaetigen von Button2 -> zum einfuegen des WunschOrdners ins Speichern unter bzw Oeffnen-Feldes des Fremdprogramms
gosub HwndButton2
return
;}	
F8::	;{	wie betaetigen von Button4 Explorer
gosub HwndButton4
return
;}	
F9::	;{	wie betaetigen von Button5 Copy-Move
gosub HwndButton5
return
;}	
PgDn::	;{	blaettert in Edit5
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
;}	
PgUp::	;{	blaettert in Edit5
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
RWin & Enter::
LWin & Enter::
send %ReturnChar%
return
;}	
;	< ######################################### TastWatch starten ############################################# >
RunTastWatch:	;{	erstellt und kopiert und startet TastWatch.ahk bzw. -exe . Der TastWatch-Quelltext ist vollstaendig in der Variablen TastWatch dieses Skriptes gespeichert. Sodass die TastWatch.ahk bei Bedarf erzeugt wird.
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
	WinClose,%A_AppDataCommon%\Zack\TastWatch
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
	; TastWatchRunRueck:=IfExistCallEExeOrAhk(A_AppDataCommon "\Zack\TastWatch.ahk")
	TastWatchRunRueck:=RunOtherAhkScriptOrExe(A_AppDataCommon "\Zack\TastWatch.ahk")
	If TastWatchRunRueck
	{
		TastWatchPid:=TastWatchRunRueck
		return
	}
	; RunOtherAhkScript(A_AppDataCommon "\Zack\TastWatch.ahk")
	RunOtherAhkScriptOrExe(A_AppDataCommon "\Zack\TastWatch.ahk")
	if ZackZackOrdnerLogErstellen
		ThreadUeberwachungLog(A_LineNumber-1,A_ThisHotkey,A_ThisLabel,A_ThisFunc,A_ThisMenu,A_ThisMenuItem,A_ThisMenuItemPos)
	TastWatchPid:=RunPid
	WinClose,%A_temp%
	return
}
	WinClose,%A_AppDataCommon%\Zack\TastWatch
return
;}	
;{	< ################################ Dir2Paths #################################################### >
BereiteVorDir2Paths:	;{	erstellt Dir2Path.ahk und kopiert die Dir2Path-Dateien an die benoetigten Orte. Der Dir2Path-Quelltext ist vollstaendig in der Variablen Dir2Paths dieses Skriptes gespeichert. Sodass die Dir2Path.ahk bei Bedarf erzeugt werden kann.
Dir2Paths=
(
#NoEnv
; MsgBox `% A_FileEncoding
IfExist GeKoOb.ico
	Try Menu,Tray,icon,GeKoOb.ico
Try Menu,Tray,Add 	; Trennlinie
FilePattern0 =`%0`%
if(FilePattern0<2)
; if false			; ################# wieder weg erledigt pruefen
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
; run, explorer.exe /select``,"`%SkriptDataPath`%" ; #########################
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
		if (SubStr(ThisFilePatternOhnestern,1,1)="+")
			DCEnde:="F"
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
				else
					DisplayName.="_"
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
				else
					DisplayName.="_"
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
			MsgBoxText:= A_ScriptName " meldet: ``n``nDie Wurzel ``n	" ThisFilePattern "``nwurde " EinleseZustand " in den Cache ``n	" CashPathWNr "``neingelesen.``n``n(" FileappendFehler " Einlesefehler von " i " einzulesenden Ordner-/Dateinamen)"
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
;	< / ######################################## Dir2Paths ################################################### >
;}	
;}	
SetThisFafCopy:	;{	
ThisFafFolderPath:=SkriptDataPath "\!Fav"
Clipboard:=ThisFafFolderPath
MsgBox, 262144, Sicherung Favoriten, Der QuellPfad dieser Favoriten 	`n	%ThisFafFolderPath%`nist im Clipboard.`nBitte `,bei gewuenschter Sicherung`, den ZielSicherungsOrdnerPfad in Edit8 erzeugen und klick auf Button5`n`nweiter mit	OK`n`nHinweis: ein neu zu erzeugender Ordner kann manuell and Edit8 angefuegt werden.
return
;}	
GetThisFafCopy:	;{	
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
;}	
AktuelleStartPfade2Awpf:	;{	
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
;}	
IeControl:	;{	wenn IeAnz --> Aktiviert die Explorer-Ansicht. Verschiebt dazu die betroffenen Controls.
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
;}	
RLShift:	;{	Toggle Explorer-Fensteransicht <---> Pfadlisten-Ansicht
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
;}	
IeAnz:	;{	Toggle IeAnz und ist reserviert fuer Wintitelaenderung ZackZackOrdner <---> ZackZackDateien
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
;}	
NormalAnzeige:	;{	
if IeAnz
{
	IeAnz:=false
	GuiControl,1:, %HwndCheckK5%, 0 ;  %IeAnz%
	gosub Button1OhneMausPos
}
return
;}	
WB:	;{	wird vom Gui bei aenderung vom IE-Control aufgerufen. Ist momnetan ohne Funktion.
		; sleep 5000
		WB_Name:=WB[]		; = Microsoft Browsersteuerelement
		MsgBox %  " Name " WB_Name "	" WB.Name
MsgBox % wb.document.getElementsByTagName("span")[1].innerText A_Tab wb.document.getElementsByTagName("span")[2].innerText A_Tab wb.document.getElementsByTagName("span")[3].innerText A_Tab wb.document.getElementsByTagName("span")[4].innerText A_Tab wb.document.getElementsByTagName("span")[5].innerText A_Tab
MsgBox % wb.document.all.primary_nav.innerText
MsgBox % WB.document.documentElement.innerText
MsgBox % A_EventInfo "	" A_GuiEvent 
return
;}	
Explorer:	;{	
return
;}	
Button3RechtsMenuHandler:	;{	wird von GuiContextMenu aufgerufen bei Rechtsklicks auf das Gui-Control Button3
; MsgBox % A_ThisMenuItem
If (A_ThisMenuItem="Edit8 2 Clip (Drop-Path)")
{
	ClipboardM:=FuehrendeSterneEntfernen(Edit8)					; Edit8 bin
	ClipboardSetFiles(clipboardM,"Copy")
	; RunOtherAhkScriptOrExe(ExternalToolTipPath, Clipboard "`n`nmit Rechtsklick an Wunsch-Ort im Explorer erzeugt dort eine Kopie")
	IfExist %ClipboardM%
	RunOtherAhkScriptOrExe(ExternalToolTipPath, "mit Rechtsklick-Einfügen am Wunsch-Ort im Explorer, wird dort eine Kopie von folgendem Pfad erzeugt"  "`n`n" Clipboard)
	else
		RunOtherAhkScriptOrExe(ExternalToolTipPath, "Der Pfad " ClipboardM " existiert nicht")
}
else If (A_ThisMenuItem="Edit5 2 Clip (Drop-Pathes)")
{
	ClipboardM:=FuehrendeSternePathListEntfernen(Edit5)
	DieseAnzahl:=ZaehleZeilen(ClipboardM)
	if (DieseAnzahl> 20)
		MsgBox, 4132, Pfade fuer Explorer-Kopie vorbereiten, sollen %DieseAnzahl% Pfade fuers Kopieren vorbereitet werden?, 8
	IfMsgBox,No
		return
	ClipboardSetFiles(clipboardM,"Copy")
	RunOtherAhkScriptOrExe(ExternalToolTipPath, "mit Rechtsklick-Einfügen am Wunsch-Ort im Explorer, wird dort eine Kopie von folgenden Pfaden erzeugt"  "`n`n" Clipboard)
}
else If (A_ThisMenuItem="Edit8 2 Clip (Text-Path)")
	Clipboard:=FuehrendeSterneEntfernen(Edit8)				; Edit8
else If (A_ThisMenuItem="Edit5 2 Clip (Text-Pathes)")
	Clipboard:=FuehrendeSternePathListEntfernen(Edit5)				; Edit5
else If (A_ThisMenuItem="Add Edit8 2 Clip (Text-Path)")
{
	ClipboardM:=Clipboard
	Clipboard:=  ClipboardM "`r`n" FuehrendeSternePathListEntfernen(Edit8)
}
else If (A_ThisMenuItem="Add Edit5 2 Clip (Text-Pathes)")
{
	ClipboardM:=Clipboard
	Clipboard:=  ClipboardM "`r`n" FuehrendeSternePathListEntfernen(Edit5)
}
return
;}	
SucheMenuHandler:	;{	wird von GuiContextMenu aufgerufen bei Rechtsklicks auf das Gui-Control Suche
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
;}	
SuFiMenuHandler:	;{	wird von GuiContextMenu aufgerufen bei Rechtsklicks auf das Gui-Control SuFi
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
;}	
IntegerMenuHandler:	;{	wird von GuiContextMenu aufgerufen bei Rechtsklicks auf ein Gui-Control dessen Bennenung als Integer interpraetiert werdene kann. Fuer die Zeilen-Nummern-Zahlen links vom Edit5.
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
		gosub Edit8NeuerOrdnerMitRueckFrage	
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
;}	
ExplorerMenuHandler:	;{	
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
;}	
MenuHandler:	;{	wird von GuiContextMenu aufgerufen bei Rechtsklicks ins Gui.
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
		gosub Edit8NeuerOrdnerMitRueckFrage	
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
;}	
BeschaeftigtAnf:	;{	haken setzen bei beschaeftigt
	beschaeftigt:=1
	GuiControl,1:,beschaeftigt,1
return
;}	
BeschaeftigtEnd:	;{	haken entfernen bei beschaeftigt
	beschaeftigt:=0
	GuiControl,1:,beschaeftigt,0
	FocusZueletztFokusieren(ZueletztFokusieren,SchreibMarkenOrt)
	; SoundBeep,250
return
;}	
GuiContextMenu:	;{	wird vom Gui aufgerufen wenn rechte Maustaste im Guibereich gedrueckt wurde. Ruft das betreffende Menue auf.
ThisGuiControl:=A_GuiControl
; MsgBox ThisGuiControl %ThisGuiControl%
if ThisGuiControl is integer
	Menu, IntegerMenu, Show 
else if (ThisGuiControl="Ordner-`nNamen-Suche")
	Menu, SucheMenu, Show 
else if (InStr(ThisGuiControl,"Clip"))
	Menu, Button3RechtsMenu, Show   
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
else if (InStr(ThisGuiControl,"Edit5"))
{
	MsgBox %A_EventInfo%
	Menu, ClipboardMenu, Show
}
else
	gosub ResetAllNocontainer
return
;}	
W12:	;{	Verkleinert das Gui auf 1/2	;}	
GuiWin12:	;{	Verkleinert das Gui auf 1/2
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
;}	
W23:	;{	Verkleinert das Gui auf 2/3	;}	
GuiWin23:	;{	Verkleinert das Gui auf 2/3
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
;}	
W32:	;{	Vergroesert das Gui auf 3/2 sofern Platz	;}	
GuiWin32:	;{	Vergroesert das Gui auf 3/2 sofern Platz	;}	
GuiWinH32:	;{	Vergroesert das Gui auf 3/2 Horizontal sofern Platz
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
;}	
WR:	;{	Send #{Right}
Send #{Right}
return
;}	
WL:	;{	Send #{Left}
Send #{Left}
return
;}	
UnterordnerUndVorFahrenEdit8:	;{	
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
	; < auf AllesAbbrechen reagieren >
		if AllesAbbrechen
		{
			SucheAbgebrochen:=true
			ToolTip,,,,19
			AllesAbbrechen:=false
			break
		}
	; </ auf AllesAbbrechen reagieren >

}
return
;}	
ZeigeAnstattVorfahrenUndUnterordnerEdit8:	;{	Zeigt temporaer die Ordner Drueber den Ordner selbst und die Unterordner von Edit8 in Edit5 an. Der Rest von Edit5 entfaellt. Wird von Edit8ZeigeUnterOrdner aufgerufen
IfExist % FuehrendeSterneEntfernen(Edit8)
{
	gosub UnterordnerUndVorFahrenEdit8
	Edit5:=NaheVerwante
	sort,Edit5,U
	if(SubStr(Edit5,1,5)="`r`n\`r`n")		; Korrektur fuer NetzFreigaben  
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
;}	
UnterordnerEdit8:	;{ ; UnterordnerEdit8 <-- ermittelt die UnterOrdner von Edit8
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
			; < auf AllesAbbrechen reagieren >
			if AllesAbbrechen
			{
				SucheAbgebrochen:=true
				ToolTip,,,,19
				AllesAbbrechen:=false
				break
			}
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
;}	
ZeigeAnstattUnterordnerEdit8:	;{	Zeigt temporaer den Ordner und die Unterordner von Edit8 in Edit5 an. Der Rest von Edit5 entfaellt. Wird von Edit8ZeigeUnterOrdner aufgerufen
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
;}	
FolgePosOfHwnd:	;{	verschiebt das ZackZsackOrdner-Gui, sodass es die Positionen vom Edit4-Control des Fensters Gegenstaende einnimmt. BefehlsName wird noch geandert zu FolgePosOfGegenstaendeEdit4Hwnd
WinGetPos,FremdGuiPosX,FremdGuiPosY,,,ahk_id %FremdGuiHwnd%
ControlGetPos,FremdControlPosX,FremdControlPosY,FremdControlPosB,FremdControlPosH,Edit4,Gegenstaende
FremdPosX:=FremdGuiPosX + FremdControlPosX
FremdPosY:=FremdGuiPosY + FremdControlPosY
sleep 100
WinMove,ahk_id %GuiWinHwnd%,,FremdPosX,FremdPosY,FremdControlPosB,FremdControlPosH
return
;}	
ShowGuiHwndInEdit4:	;{	zeigt die eindeutige ZackZsackOrdner-Gui-Hwnd im Feld Edit4 an
Edit4:=GuiWinHwnd
GuiControl,1:,%HwndEdit4%,%Edit4%
return
;}	
MinSetzen:	;{	variable Min <-- 1
Min:=true
GuiControl,1:,Min,1
return
;}	
IeAnzFestigen:	;{	
GuiControl,1:,IeAnz,%IeAnz%
return
;}	
RekurFestigen:	;{	
GuiControl,1:,Rekur,%Rekur%
return
;}	
AktFestigen:	;{	
GuiControl,1:,Akt,%AktAkt%
return
;}	
AuAbFestigen:	;{	
GuiControl,1:,AuAb,%AuAb%
return
;}	
RegExFestigen:	;{	
GuiControl,1:,RegEx,%RegEx%
return
;}	
SuFiFestigen:	;{	
GuiControl,1:,SuFi,%SuFi%
return
;}	
ExpSelFestigen:	;{	
GuiControl,1:,ExpSel,%ExpSel%
return
;}	
SeEnFestigen:	;{	
GuiControl,1:,SeEn,%SeEn%
return
;}	
SrLiFestigen:	;{	
GuiControl,1:,SrLi,%SrLi%
return
;}	
BsAnFestigen:	;{	
GuiControl,1:,BsAn,%BsAn%
return
;}	
WoAnFestigen:	;{	
GuiControl,1:,WoAn,%WoAn%
return
;}	
EvalButton1OnlyFestigen:	;{	
GuiControl,1:,EvalButton1Only,%EvalButton1Only%
return
;}	
beschaeftigtFestigen:	;{	
GuiControl,1:,beschaeftigt,%beschaeftigt%
return
;}	
OnTopFestigen:	;{	wird nach der Veraenderung der Variablen OnTop benoetigt, dass diese auch im Gui angezeigt wird (Haken To)
GuiControl,1:,%HwndCheckG0%,%OnTop%
return
;}	
MinFestigen:	;{	funzt ned		wird nach der Veraenderung der Variablen Min benoetigt, dass diese auch im Gui angezeigt wird (Haken Mi)
GuiControl,1:,Min,%Min%
return
;}	
Edit1Festigen:	;{	wird nach der Veraenderung der Variablen Edit2 benoetigt, dass diese auch im Gui angezeigt wird (Edit2 ist Suche)
GuiControl,1:,%HwndEdit1%,%Edit1%
return
;}	
Edit2Festigen:	;{	wird nach der Veraenderung der Variablen Edit2 benoetigt, dass diese auch im Gui angezeigt wird (Edit2 ist Suche)
GuiControl,1:,%HwndEdit2%,%Edit2%
return
;}	
Edit11Festigen:	;{	wird nach der Veraenderung der Variablen Edit2 benoetigt, dass diese auch im Gui angezeigt wird (Edit2 ist Suche)
GuiControl,1:,%HwndEdit11%,%Edit11%
return
;}	
Edit12Festigen:	;{	wird nach der Veraenderung der Variablen Edit2 benoetigt, dass diese auch im Gui angezeigt wird (Edit2 ist Suche)
GuiControl,1:,%HwndEdit12%,%Edit12%
return
;}	
Edit3Festigen:	;{	wird nach der Veraenderung der Variablen Edit3 benoetigt, dass diese auch im Gui angezeigt wird (Edit3 ist Nr. Wahl)
GuiControl,1:,%HwndEdit3%,%Edit3%
return
;}	
Edit4Festigen:	;{	wird nach der Veraenderung der Variablen Edit3 benoetigt, dass diese auch im Gui angezeigt wird (Edit3 ist Nr. Wahl)
GuiControl,1:,%HwndEdit4%,%Edit4%
return
;}	
Edit5Festigen:	;{	wird nach der Veraenderung der Variablen Edit5 benoetigt, dass diese auch im Gui angezeigt wird (Edit5 ist Pfade)
GuiControl,1:,%HwndEdit5%,%Edit5%
return
;}	
Edit6Festigen:	;{	wird nach der Veraenderung der Variablen Edit6 benoetigt, dass diese auch im Gui angezeigt wird (Edit5 ist Abbruch)
GuiControl,1:,%HwndEdit6%,%Edit6%
return
;}	
Edit7Festigen:	;{	wird nach der Veraenderung der Variablen Edit6 benoetigt, dass diese auch im Gui angezeigt wird (Edit5 ist Abbruch)
GuiControl,1:,%HwndEdit7%,%Edit7%
return
;}	
Edit8Festigen:	;{	wird nach der Veraenderung der Variablen Edit8 benoetigt, dass diese auch im Gui angezeigt wird (Edit8 ist ausgwaehler Pfad)
GuiControl,1:,%HwndEdit8%,%Edit8%
return
;}	
Edit9Festigen:	;{	wird nach der Veraenderung der Variablen Edit8 benoetigt, dass diese auch im Gui angezeigt wird (Edit8 ist ausgwaehler Pfad)
GuiControl,1:,%HwndEdit9%,%Edit9%
return
;}	
Edit10Festigen:	;{	wird nach der Veraenderung der Variablen Edit10 benoetigt, dass diese auch im Gui angezeigt wird (Edit10 ist Zusatz)
GuiControl,1:,%HwndEdit10%,%Edit10%
return
;}	
GuiSubmit:	;{	Speichert die Inhalte der Steuerelemente (vom ZackZsackOrdner-Gui) in ihre zugeordneten Variablen und versteckt das Gui.
Gui,1:Submit
return
;}	
GuiSubmitNohide:	;{	Speichert die Inhalte der Steuerelemente (vom ZackZsackOrdner-Gui) in ihre zugeordneten Variablen.
Gui,1:Submit,NoHide
return
;}	
GuiWinWaitActive:	;{	Warted bis das ZackZsackOrdner-Gui aktiv ist, maximal eine Sekundee
WinWaitActive,ahk_id %GuiWinHwnd%,,1
return
;}	
SWM:	; minimiert das ZackZsackOrdner-Gui		; 	fuer Befehsdateien bitte die Alternative GuiWinMin verweenden
SelfWinMin:	; minimiert das ZackZsackOrdner-Gui		; 	fuer Befehsdateien bitte die Alternative GuiWinMin verweenden
SelfMin:	; minimiert das ZackZsackOrdner-Gui		; 	fuer Befehsdateien bitte die Alternative GuiWinMin verweenden
GuiWinMin:	;{	minimiert das ZackZsackOrdner-Gui 
WinMinimize,ahk_id %GuiWinHwnd%
return
;}	
Pause:	;{	Pausiert das Skript
Pause
return
;}	
SuspendOn:	;{	Hotkeys <-- in Betrieb
Suspend, On
return
;}	
SuspendOff:	;{	Hotkeys <-- ausser Betrieb
Suspend, Off
return
;}	
Button6:	;{	Button6, dessen Sichtbarkeit und Nutzbarkeit vom Vorhandensein von Button8.ahk und von der optionalen Button6.txt Befehlsdatei im %A_ScriptDir% abhaengt.
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
;}	
Button7:	;{	
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
;}	
Button8:	;{	
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
;}	
Button9:	;{	
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
;}	
Button10:	;{	
MsgBox % A_LineNumber "	noch zu coden `n`nDies koennte Ihr individueller Button werden"
return
;}	
Button11:	;{	
MsgBox % A_LineNumber "	noch zu coden `n`nDies koennte Ihr individueller Button werden"
return
;}	
Button12:	;{	
MsgBox % A_LineNumber "	noch zu coden `n`nDies koennte Ihr individueller Button werden"
return
;}	
Button13:	;{	
MsgBox % A_LineNumber "	noch zu coden `n`nDies koennte Ihr individueller Button werden"
return
;}	
Button14:	;{	
MsgBox % A_LineNumber "	noch zu coden `n`nDies koennte Ihr individueller Button werden"
return
;}	
Button15:	;{	
MsgBox % A_LineNumber "	noch zu coden `n`nDies koennte Ihr individueller Button werden"
return
;}	
VomVaterVaterDir:	;{	Edit7 <-- den Ordner ueber dem Ordner der Edit8 enthaelt.
Edit8Sternlos:=FuehrendeSterneEntfernen(Edit8)
SplitPath,Edit8Sternlos, Edit8SternlosFileName, Edit8SternlosDir ; , Edit8SternlosExt, Edit8SternlosNameNoExt
SplitPath,Edit8SternlosDir, , Edit8SternlosDirDir
		Edit7:=Edit8SternlosDirDir
		GuiControl,1:,%HwndEdit7%,%Edit7%
		gosub SufiAn
		gosub F5
return
;}	
VomVaterDir:	;{	Edit7 <-- den Ordner der Edit8 enthaelt.
Edit8Sternlos:=FuehrendeSterneEntfernen(Edit8)
SplitPath,Edit8Sternlos, Edit8SternlosFileName, Edit8SternlosDir ; , Edit8SternlosExt, Edit8SternlosNameNoExt
		Edit7:=Edit8SternlosDir
		GuiControl,1:,%HwndEdit7%,%Edit7%
		gosub SufiAn
		gosub F5
return
;}	
VomVaterWin:	;{	liest vom (Vater-)Explorer-Fenster den Pfad aus und verwendet ihn als Suchmuster fuer Edit7
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
;}	
HalloWelt(Nummer="")	;{()	
{
	MsgBox, 262144,%A_ScriptName% at %A_LineNumber% ,Hallo Welt %Nummer%
	return "Hallo Welt " Nummer
}
;}	
Schlafe200:	;{	
sleep 200
return
;}	
Schlafe2000:	;{	
sleep 2000
return
;}	
Super(Var)	;{()		
{
	global
	local Rueck
	if(Var<>"")
		Rueck:=%Var%
}
;}	
SWR:
SelfWinRestore:
GuiWinRestore:	;{	
WinRestore,ahk_id %GuiWinHwnd%
return
;}	
OnClipboardChange:	;{	
	NeuerThread=OnClipboardChange:
	ListLines,Off
	GosubLabel:=GetGosubLabel(A_ThisLabel)
	if(IsLabel(GosubLabel))
		gosub %GosubLabel%
if(Clipboard<>FuehrendeSterneEntfernen(Edit8))
	GuiControl,1:Text,%HwndButton3%,└> &Clip
else
	GuiControl,1:Text,%HwndButton3%,┌> &Clip
if(SubStr(Edit2,1,8)="Clip://	" OR SubStr(Edit2,1,8)="Clip://`t")
	gosub Button1
if (AktionBeiClipChange)
{
	if(GosubClipChange="KopiereOderVerschiebeFilesAndFolders2Edit8")
	{
		if (A_EventInfo=1)
			gosub %GosubClipChange%
	}
}
if ShowClipHist
{
	Edit5:=GetObjectDetails(ClipHist(1,1,20,4),"ClipHist")
	; Edit5:=ObjToStr(ClipHist(1,1,14,2))
	gosub Edit5Festigen
}
GosubClipChange:=
AktionBeiClipChange:=false
return
;}	
^-::	;{	kopiere oder verschiebe Pfade die bereits im Clipboard stehen.
TimeStampClipWaitPathes2Edit8:=A_TickCount
KopiereOderVerschiebeFilesAndFolders2Edit8:
if(TimeStampClipWaitPathes2Edit8 < A_TickCount- 60000) ; 1 Minute ueberschritten
	return
DateiPfade:=Clipboard
DateiPfadeWerdenUebergeben:=true
if(not OeffnenMitDateiPfade(DateiPfade,Edit8))
	gosub KopiereOderVerschiebeFilesAndFolders
return
;}	
^+::	;{	kopiere oder verschiebe Pfade, vom Clipboard nur wenn ClipboardChange stattgefunden, zum Pfad in Edit8. Dafuer steht eine Minute zur Verfuegung.
ClipWaitPathes2Edit8:	;{		; kopiere oder verschiebe Pfade, vom Clipboard nur wenn ClipboardChange stattgefunden, zum Pfad in Edit8. Dafuer steht eine Minute zur Verfuegung.
TimeStampClipWaitPathes2Edit8:=A_TickCount
AktionBeiClipChange:=true
TrayTip,Wait-Clip-Change,warte bis zu einer Minute auf neue Clipboard-Pfade.
GosubClipChange=KopiereOderVerschiebeFilesAndFolders2Edit8
return
;}	
;}	
ContainerSkripteUndProgrammeBereitstellen:	;{	
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
;}	
;{	< ################################ TastWatch ################################################### >
VarTastWatcherzeugen:	;{	 
TastWatch1=
(
#SingleInstance
if (SuggestionWords="")
	SuggestionWords:=true
if (OrdnerButton="")
	OrdnerButton:=true
ifExist `%A_AppData`%\Zack\GeKoRe.ico
	Menu,Tray,icon,`%A_AppData`%\Zack\GeKoRe.ico
else ifExist `%A_ScriptDir`%\GeKoRe.ico
	Menu,Tray,icon,`%A_ScriptDir`%\GeKoRe.ico
DpiKorrektur:=A_ScreenDPI/96
Menu,Tray,Add,WatchOrdnerButton
Menu,Tray,Add,WatchCapsLock
Menu,Tray,Add,SuggestionWordsL
TastenUeberwachen:=false
DetectHiddenWindows,On
OnExit GuiClose
SetTimer,IfZackZackNotExist,4000
; Gui,2:New,    +HwndHwndWortVorschlaege +AlwaysOnTop, WortVorschlaege	

ZzoHauptFensterHwndPfad:=`% A_AppDataCommon "\Zack\ZzoHauptFensterHwnd.txt"
IfExist `% ZzoHauptFensterHwndPfad
{
	FileRead,ZzoGuiWinHwnd ,`% ZzoHauptFensterHwndPfad
	IfWinExist, ahk_id `%ZzoGuiWinHwnd`%
	{
		ZielScriptTitel=ahk_id `%ZzoGuiWinHwnd`%
	}
}
else
{
	IfExist, `%A_AppDataCommon`%\Zack\SchnellOrdner.txt
	{
		FileRead,ZackZackOrdnerPath,`%A_AppDataCommon`%\Zack\SchnellOrdner.txt
		IfExist `%ZackZackOrdnerPath`%
		{
			SplitPath,ZackZackOrdnerPath,,ZackZackOrdnerDirPath
			Run,  `%ZackZackOrdnerPath`% Minimized,`%ZackZackOrdnerDirPath`%,Min,ZzoGuiWinHwnd
		}
	}
}
DetectHiddenWindows,Off
SetTimer,Explorer,500
Beginn:
AustauschOrdnerPfad:=A_AppDataCommon "\TaMit"
AusTauschDateiPfad:=AustauschOrdnerPfad  "\TaMit.txt"
Weg=EndKey:
EnterDotOverDotWeg:=true
LShiftWeg:=false
RShiftWeg:=true
weg1=Max
Loop
{
	; soundbeep
	if NOT TastenUeberwachen
	{
		return
		Sleep 500
		; continue
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
		Input, Einzeltaste, L1 V, {AppsKey}{F1}{F2}{F3}{F4}{F5}{F6}{F7}{F8}{F9}{F10}{F11}{F12}{Left}{Right}{Up}{Down}{Home}{End}{PgUp}{PgDn}{Del}{Ins}{BS}{Capslock}{Numlock}{PrintScreen}{Pause}{Tab}				;  {LControl}{RControl}{LShift}{RShift}{LAlt}{RAlt}{LWin}{RWin}{Space}
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
)
TastWatch2=
(
SendeZuSendendeString:
IfWinExist,`%ZielScriptTitel`%
{
	Loop, 5
	{
		ControlSetText,Edit4,`%ZuSendendeString`%.,`%ZielScriptTitel`%
		sleep, 4
		ControlGetText,VonEdit4,Edit4,`%ZielScriptTitel`%
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
if not OrdnerButton
	return
IfWinActive,ahk_id `%HwndWortVorschlaege`%
	return
IfWinNotActive,ahk_class CabinetWClass
{
	Try Gui,2:Destroy
	WinSet,AlwaysOnTop, Off,ahk_id `%GuiWin1Hwnd`%
	Gui,1:Submit
	WinHide,ahk_id `%GuiWin1Hwnd`%
}
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
else IfWinActive,`%ZielScriptTitel`%
{
	if Not SuggestionWords
		return
	ControlGetFocus,FocussedControl,A
	if (FocussedControl<>"Edit2")
	return
	WortVorschlagListe=
	IfNotExist `%A_AppData`%\Zack\WortVorschlagListe.txt
	{
		Try Gui,2:Destroy
		return
	}
	; Gui,2:New,+HwndGui2WinHwnd  ;  -Border -SysMenu 							; Parent`%ExplorerHwnd`%
	Loop 10
	{
		if(A_TimeIdlePhysical<500)
			sleep 50
		else
		{
			IfExist `%A_AppData`%\Zack\WortVorschlagListe.txt
			{
				; loop,9
					; WortVorschlag`%A_Index`%=
				FileReadLine,WortVorschlagListe, `%A_AppData`%\Zack\WortVorschlagListe.txt,2
				if (WortVorschlagListe="")
				{
					Try Gui,2:Destroy
					return
				}
				Try Gui,2:Destroy
					IfWinNotExist,ahk_id `%HwndWortVorschlaege`%
						Gui,2:New,    +HwndHwndWortVorschlaege +AlwaysOnTop, WortVorschlaege	

				StringTrimLeft,WortVorschlagListe,WortVorschlagListe,1
				StringSplit,WortVorschlag,WortVorschlagListe,``,
				loop `% WortVorschlag0
				{
					GIndex:=A_Index
					DieserWortVorschlag:=SubStr(WortVorschlag`%GIndex`%,1,-4)
					StringReplace,DieserWortVorschlag,DieserWortVorschlag,`% A_Space,_,All
					StringReplace,DieserWortVorschlag,DieserWortVorschlag,.,_,All
					StringReplace,DieserWortVorschlag,DieserWortVorschlag,  ⁄⁄⁄  , ⁄ ,All
					StringReplace,DieserWortVorschlag,DieserWortVorschlag,  ⁄⁄  , ⁄ ,All
					StringReplace,DieserWortVorschlag,DieserWortVorschlag,⁄,_,All
					StringSplit,WortTeilVorschlag,DieserWortVorschlag,_
					

					if(WortTeilVorschlag0=1)
					{
						YB:=A_Index*30-29
							Try Gui,2:Add, Button, x1 y`%YB`%  w145 h29 gWortVorschlagsMenuHandler`%GIndex`% Left, `% SubStr(WortVorschlag`%GIndex`%,1,-4)
							WortVorschlagsMenuHandler`%GIndex`%:=`% SubStr(WortVorschlag`%GIndex`%,1,-4)
					}
					else
					{
						YB:=A_Index*30-29
							Try Gui,2:Add, Button, x1 y`%YB`%  w24 h29 gWortVorschlagsMenuHandler`%GIndex`% Left, Ʃ
							WortVorschlagsMenuHandler`%GIndex`%:=`% SubStr(WortVorschlag`%GIndex`%,1,-4)
						YB:=A_Index*30-29
						Loop `% WortTeilVorschlag0
						{
							XB:=A_Index*60-33
							WortVorschlagsMenuHandler`%GIndex`%_`%A_Index`%:=WortTeilVorschlag`%A_Index`%

							Try Gui,2:Add, Button, x`%XB`% y`%YB`%  w59 h29 gWortVorschlagsMenuHandler`%GIndex`%_`%A_Index`% Left, `% WortTeilVorschlag`%A_Index`%
						}
					}
				}
				gosub ZeigeWortVorschlagsMenue
				break
			}
			else
			{
				Try Gui,2:Destroy
				return
			}
		}
	}
}
else IfWinActive,ahk_id `%GuiWin1Hwnd`%
{
	Try Gui,2:Destroy
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
Loop 200
{
	GetKeyState,DieserZustand,LButton
	if DieserZustand = D
		sleep 30
	else
		break
}
sleep 20
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
MsgBox, 262144,Flag, `% "TastenUeberwachen=" TastenUeberwachen,1
return
WatchOrdnerButton:
if OrdnerButton
	OrdnerButton:=false
else
	OrdnerButton:=true
MsgBox, 262144,Flag, `% "OrdnerButton=" OrdnerButton,1
return
SuggestionWordsL:
if SuggestionWords
	SuggestionWords:=false
else
	SuggestionWords:=true
MsgBox, 262144,Flag, `% "SuggestionWords=" SuggestionWords,1
return
::CapsspaCon::	; HotString von Tastwatch: tasten ueberwachen an
TastenUeberwachen:=true
MsgBox, 262144,Flag, `% "TastenUeberwachen=" TastenUeberwachen,1
goto Beginn
return
::CapsspaCoff::	; HotString von Tastwatch: tasten ueberwachen aus
TastenUeberwachen:=false
MsgBox, 262144,Flag, `% "TastenUeberwachen=" TastenUeberwachen,1
return

WortVorschlagsMenuHandler1:
WortVorschlagsMenuHandler1_1:
WortVorschlagsMenuHandler2_1:
WortVorschlagsMenuHandler3_1:
WortVorschlagsMenuHandler4_1:
WortVorschlagsMenuHandler5_1:
WortVorschlagsMenuHandler6_1:
WortVorschlagsMenuHandler7_1:
WortVorschlagsMenuHandler8_1:
WortVorschlagsMenuHandler9_1:
WortVorschlagsMenuHandler10_1:
WortVorschlagsMenuHandler2:
WortVorschlagsMenuHandler1_2:
WortVorschlagsMenuHandler2_2:
WortVorschlagsMenuHandler3_2:
WortVorschlagsMenuHandler4_2:
WortVorschlagsMenuHandler5_2:
WortVorschlagsMenuHandler6_2:
WortVorschlagsMenuHandler7_2:
WortVorschlagsMenuHandler8_2:
WortVorschlagsMenuHandler9_2:
WortVorschlagsMenuHandler10_2:
WortVorschlagsMenuHandler3:
WortVorschlagsMenuHandler1_3:
WortVorschlagsMenuHandler2_3:
WortVorschlagsMenuHandler3_3:
WortVorschlagsMenuHandler4_3:
WortVorschlagsMenuHandler5_3:
WortVorschlagsMenuHandler6_3:
WortVorschlagsMenuHandler7_3:
WortVorschlagsMenuHandler8_3:
WortVorschlagsMenuHandler9_3:
WortVorschlagsMenuHandler10_3:
WortVorschlagsMenuHandler4:
WortVorschlagsMenuHandler1_4:
WortVorschlagsMenuHandler2_4:
WortVorschlagsMenuHandler3_4:
WortVorschlagsMenuHandler4_4:
WortVorschlagsMenuHandler5_4:
WortVorschlagsMenuHandler6_4:
WortVorschlagsMenuHandler7_4:
WortVorschlagsMenuHandler8_4:
WortVorschlagsMenuHandler9_4:
WortVorschlagsMenuHandler10_4:
WortVorschlagsMenuHandler5:
WortVorschlagsMenuHandler1_5:
WortVorschlagsMenuHandler2_5:
WortVorschlagsMenuHandler3_5:
WortVorschlagsMenuHandler4_5:
WortVorschlagsMenuHandler5_5:
WortVorschlagsMenuHandler6_5:
WortVorschlagsMenuHandler7_5:
WortVorschlagsMenuHandler8_5:
WortVorschlagsMenuHandler9_5:
WortVorschlagsMenuHandler10_5:
WortVorschlagsMenuHandler6:
WortVorschlagsMenuHandler1_6:
WortVorschlagsMenuHandler2_6:
WortVorschlagsMenuHandler3_6:
WortVorschlagsMenuHandler4_6:
WortVorschlagsMenuHandler5_6:
WortVorschlagsMenuHandler6_6:
WortVorschlagsMenuHandler7_6:
WortVorschlagsMenuHandler8_6:
WortVorschlagsMenuHandler9_6:
WortVorschlagsMenuHandler10_6:
WortVorschlagsMenuHandler7:
WortVorschlagsMenuHandler1_7:
WortVorschlagsMenuHandler2_7:
WortVorschlagsMenuHandler3_7:
WortVorschlagsMenuHandler4_7:
WortVorschlagsMenuHandler5_7:
WortVorschlagsMenuHandler6_7:
WortVorschlagsMenuHandler7_7:
WortVorschlagsMenuHandler8_7:
WortVorschlagsMenuHandler9_7:
WortVorschlagsMenuHandler10_7:
WortVorschlagsMenuHandler8:
WortVorschlagsMenuHandler1_8:
WortVorschlagsMenuHandler2_8:
WortVorschlagsMenuHandler3_8:
WortVorschlagsMenuHandler4_8:
WortVorschlagsMenuHandler5_8:
WortVorschlagsMenuHandler6_8:
WortVorschlagsMenuHandler7_8:
WortVorschlagsMenuHandler8_8:
WortVorschlagsMenuHandler9_8:
WortVorschlagsMenuHandler10_8:
WortVorschlagsMenuHandler9:
WortVorschlagsMenuHandler1_9:
WortVorschlagsMenuHandler2_9:
WortVorschlagsMenuHandler3_9:
WortVorschlagsMenuHandler4_9:
WortVorschlagsMenuHandler5_9:
WortVorschlagsMenuHandler6_9:
WortVorschlagsMenuHandler7_9:
WortVorschlagsMenuHandler8_9:
WortVorschlagsMenuHandler9_9:
WortVorschlagsMenuHandler10_9:
WortVorschlagsMenuHandler10:

StringSplit,WortVorschlag,WortVorschlagListe,``,
; TrayTip, WortVorschlag1,`%WortVorschlag1`% ,5
; WortVorschlagNummer:=SubStr(A_ThisLabel,0,1)
ZuSendendeString:="e2" `%A_ThisLabel`%

; WortVorschlagNummer:=WortCache`%A_Index`%_`%GIndex`%
; ZuSendendeString:="e2" SubStr(WortVorschlag`%WortVorschlagNummer`%,1,-4)
Gosub SendeZuSendendeString
; ControlSetText,Edit4,`%ZuSendendeString`%.,ZackZackOrdner ahk_class AutoHotkeyGUI
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
	Gui,2:Show, x`%ZzoXR`% y`%ZzoYR`% NoActivate 	; AutoSize 	; AlwaysOnTop AutoSize NoActivate
	Gui,2:Color, FFFFFF
	Gui,2:+Border
	; WinSet, AlwaysOnTop,On,  ahk_id `%HwndWortVorschlaege`% 
	WinSet, TransColor, FFFFFF 255,  ahk_id `%HwndWortVorschlaege`%
	WinSet, AlwaysOnTop,Off,  ahk_id `%HwndWortVorschlaege`%
	Gui,2:-Caption
	Loop
	{
		Input, Einzeltaste,T1 L1 V, {Esc}{LControl}{RControl}{LAlt}{RAlt}{LShift}{RShift}{LWin}{RWin}{AppsKey}{F1}{F2}{F3}{F4}{F5}{F6}{F7}{F8}{F9}{F10}{F11}{F12}{Left}{Right}{Up}{Down}{Home}{End}{PgUp}{PgDn}{Del}{Ins}{BS}{Capslock}{Numlock}{PrintScreen}{Pause}
		Zusatz:=ErrorLevel
		; Tooltip, `%  Einzeltaste "	" Zusatz,,,7
		if(Zusatz="EndKey:Escape")
			{
				Gui,2:Destroy
				; SoundBeep
				continue
			}
		else if (Zusatz = "EndKey:AppsKey" )
		{
			Gui,2:Destroy
			sleep 150
			Send {Esc}
			; SoundBeep
			sleep 20
			ZuSendendeString=WortVorschlaege=0.
			gosub SendeZuSendendeString
			continue
		}
		else if (Zusatz <> "Timeout")
			break
		IfWinNotActive,`%ZielScriptTitel`%
			break
	}
}
return
IfZackZackNotExist:
WinWaitClose,ZackZack ahk_class AutoHotkeyGUI
GuiClose:
ExitApp
)
TastWatch:=TastWatch1 "`r" TastWatch2
return
;	< / ######################################## TastWatch ################################################### >
;}	
;}	
KontainerAnzeigen:	;{	
SplitPath,SkriptDataPath,NameSkriptDataPath
StringReplace,VarNameSkriptDataPath,NameSkriptDataPath,%A_Space%,_A_Space_,All
StringReplace,VarNameSkriptDataPath,VarNameSkriptDataPath,!,,All
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
	; Gui,1: Color, DDBBAA; EEAA99
	if (NeueBreite=506)
			gosub GuiWinH32
}
else
{
	; Transform,GuiFarbe,BitAnd, %GuiHintergrundFarbe%, % Integer3Hex(AktContainerNr)
	; Gui,1: Color, %GuiHintergrundFarbe%
}
; MsgBox % GrEdit2%VarNameSkriptDataPath%
if (GrEdit2%VarNameSkriptDataPath%<>"")
	GrEdit2:=GrEdit2%VarNameSkriptDataPath%
else
	GrEdit2:=GrEdit11Default
; gosub WorteCacheBefuellen
FavoritenDirPath:=SkriptDataPath "\!Fav"
gosub GetAktContainerNr
if(AktContainerNr<>"")
	ContainernummernAnzeige=%AktContainerNr% ; `n
else
	ContainernummernAnzeige=
VarNameSkriptDataPath:=OnlyVarChar(NameSkriptDataPath)
DieseStaPfaNr:=LastStaPfaNr%VarNameSkriptDataPath%			; seltsam Pruefen!!!!!!!!!!!!!!!!!!!
StartPfadZeichen:="`n@"
if DieseStaPfaNr is not Integer
{
	DieseStaPfaNr:=
	StartPfadZeichen:=
}
GuiControl,1:Text,%HwndButton1%,aktualisieren`n[%ContainernummernAnzeige%.%NameSkriptDataPath%]%StartPfadZeichen%%DieseStaPfaNr%
if StartMenuStartPfadErst
{
	StartMenuStartPfadErst:=false
	; Exit
}
; ToolTip % A_LineNumber "	" GrEdit2
if (LetzterSkriptDataPath<>SkriptDataPath)
{
	LetzterSkriptDataPathI:=LetzterSkriptDataPath
	; LetzteAktContainerNr:=AktContainerNr
}
	; LetzterSkriptDataPath:=SkriptDataPath
LetzterSkriptDataPath:=SkriptDataPath
; ToolTip % LetzterSkriptDataPathI
	TestFarbe:=Integer3Hex(15-AktContainerNr)
	GuiFarbe:="0x" "E" . 7 . "E" . TestFarbe . "F" . Integer3Hex(AktContainerNr-1)
 	; MsgBox % AktContainerNr "	" GuiFarbe "		" Integer3Hex(GuiFarbe)
if (AktContainerNr="")
	GuiFarbe:=0xE5E5F9
	Gui,1: Color, %GuiFarbe%

return
;}	
GetContainerNr(ContainerPath)	;{()	
{
	global WurzelContainer
	Loop,Files,%WurzelContainer%\*, D F
	{
		if(ContainerPath=A_LoopFileLongPath)
		return A_Index
		if(ContainerPath=A_LoopFileName)
		return A_Index
	}
	return 0
}
;}	
GetAktContainerNr:	;{	
Loop,% ContainerAnzahl
{
	if(Cont%A_Index%=NameSkriptDataPath)
	{
		AktContainerNr:=A_Index
		break
	}
}
return
;}	
HauptKontainerAnzeigen:	;{	
SkriptDataPath=%WurzelContainer%\Haupt
gosub KontainerAnzeigen
return
;}	
TastWatch2Autorun:	;{	
MsgBox FileCreateShortcut, %A_AppDataCommon%\Zack\TastWatch.exe, %A_Startup%\TastWatch.exe.lnk
FileCreateShortcut, %A_AppDataCommon%\Zack\TastWatch.exe, %A_Startup%\TastWatch.exe.lnk
if ZackZackOrdnerLogErstellen
	ThreadUeberwachungLog(A_LineNumber-1,A_ThisHotkey,A_ThisLabel,A_ThisFunc,A_ThisMenu,A_ThisMenuItem,A_ThisMenuItemPos)
return
;}	
ThreadUeberwachungLog(LineNumber,ThisHotkey,ThisLabel,ThisFunc,ThisMenu,ThisMenuItem,ThisMenuItemPos)	;{()	
{
	Global ZackZackOrdnerLogErstellen
	static LastA_TickCount
	DeltaA_TickCount:=A_TickCount-LastA_TickCount
	FileReadLine,ThisQuellZeile,%A_ScriptFullPath%,LineNumber
	StringReplace,ThisQuellZeile,ThisQuellZeile,`, ThreadUeberwachungLog(A_LineNumber`,A_ThisHotkey`,A_ThisLabel`,A_ThisFunc`,A_ThisMenu`,A_ThisMenuItem`,A_ThisMenuItemPos)
	StringReplace,ThisQuellZeile,ThisQuellZeile,ThreadUeberwachungLog(A_LineNumber`,A_ThisHotkey`,A_ThisLabel`,A_ThisFunc`,A_ThisMenu`,A_ThisMenuItem`,A_ThisMenuItemPos)
	FileAppend, % DeltaA_TickCount A_Tab A_Now A_Tab LineNumber A_Tab ThisQuellZeile A_Tab ThisHotkey A_Tab ThisLabel A_Tab ThisFunc A_Tab ThisMenu A_Tab ThisMenuItem A_Tab ThisMenuItemPos "`r`n" ,%A_Temp%\ZackZackOrdner.Log,utf-16
	LastA_TickCount:=A_TickCount
}
;}	
Log:	;{	
run,%A_Temp%\ZackZackOrdner.Log
return
;}	
Edit82Send:	;{	Sendet Inhalt von Edit8, wie auf Tastatur eigegeben.
ThisSend:=FuehrendeSterneEntfernen(Edit8)
send, %ThisSend%
return
;}	
Edit82Clip:	;{	schreibt Inhalt von Edit8 ins Clipboard
FuerClipboard:=FuehrendeSterneEntfernen(Edit8)
StringReplace,Clipboard,FuerClipboard,`n,`r`n,All
return
;}	
Edit52Clip:	;{	schreibt Inhalt von Edit5 ins Clipboard
gosub Button3
return
;}	
Clip2Edit5:	;{	schreibt Inhalt vom Clipboard in Edit5 und Festigt
Edit5:=Clipboard
gosub Edit5Festigen
return
;}	
WorteCacheBefuellen:	;{	
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
;}	
; < ########################################  Vom Gui aufgrufene Labels  ##################################### >	@0250
SoundPlayEdit8:	;{	
SoundPlay, % FuehrendeSterneEntfernen(Edit8)
return
;}	
SoundPlayClipboard:	;{	
KopieClipboard:=Clipboard
Loop,Parse,KopieClipboard,`n,`r
{
	Edit10:=A_LoopField
	gosub Edit10Festigen
	SoundPlay, % FuehrendeSterneEntfernen(A_LoopField),1
}
return
;}	
; < ##########################################  Edits  ##################################################### >	@0260
Edit1:		;	@0261														; PfadAnzeigeZaehler (so viele Pfade, wuerden bei gross genugem Fenster angezeigt)
HwndEdit1:	;{	Hauptabhaengig vom SuchEingabeFeld und der Abbrruchs-Nummer
BeschaeftigtAnzeige(1)
if (SucheAbgebrochen and not InStr(Edit1,"("))
{
	Edit1:="(" Edit1 ")"
	gosub Edit1Festigen
}
BeschaeftigtAnzeige(-1)
return
;}	
Edit2Grau:	;{	
BeschaeftigtAnzeige(1)
; Edit2Wirksam:=false
; if(LastEdit2Wirksam<>Edit2Wirksam)
; {
	Gui,1: Font, csilver Bold ; , Courier  
	GuiControl,1: Font, Edit2  
	; GuiControl ,1: +csilver,Edit2
	; ToolTip,% "(" Edit2 ")",104,85+GuiYAbzuziehen
	; x98 	y78
	; goto Edit2Festigen
	; exit
; }
; LastEdit2Wirksam:=Edit2Wirksam
BeschaeftigtAnzeige(-1)
return
;}	
Edit2Schwarz:	;{	
BeschaeftigtAnzeige(1)
; Edit2Wirksam:=true
; if(LastEdit2Wirksam<>Edit2Wirksam)
; {
	Gui,1: Font, cBlack Bold ; , Courier  
	GuiControl,1: Font, Edit2  
	; GuiControl ,1: +cblack,Edit2
	; ToolTip,
	; goto Edit2Festigen
	; exit
; }
Edit2LastLastLastLastLastLast:=Edit2LastLastLastLastLast
Edit3LastLastLastLastLastLast:=Edit3LastLastLastLastLast
Edit2LastLastLastLastLast:=Edit2LastLastLastLast
Edit3LastLastLastLastLast:=Edit3LastLastLastLast
Edit2LastLastLastLast:=Edit2LastLastLast
Edit3LastLastLastLast:=Edit3LastLastLast
Edit2LastLastLast:=Edit2LastLast
Edit3LastLastLast:=Edit3LastLast
Edit2LastLast:=Edit2Last
Edit3LastLast:=Edit3Last
Edit2Last:=Edit2
Edit3Last:=Edit3
; LastEdit2Wirksam:=Edit2Wirksam
BeschaeftigtAnzeige(-1)
return
;}	
Edit11:	;{	
if EvalButton1Only
{
	if NOT InitiatorButton1
		return
}
ControlGetFocus,FocusedGuiConntrol,ahk_id %GuiWinHwnd%
; MsgBox % FocusedGuiConntrol
if(FocusedGuiConntrol="Edit11")
;	return
	Gui,1:Submit,NoHide
InRowKennerPos:=InStr(Edit2,InRowKenner)
if (InRowKennerPos OR InInhaltKennerPos)
{
	FirstKommaPos:=InStr(Edit2,"`,",false,0)
	if(InRowKennerPos-FirstKommaPos > 5)
		FirstKommaPos:=0	; ungueltiges Komma gefunden
	NachKomma:=SubStr(Edit2,FirstKommaPos+1,InRowKennerPos + InInhaltKennerPos -FirstKommaPos-2)
	Optionen:=NachKomma
	ZeileEnthaelt:=SubStr(Edit2,InRowKennerPos + InInhaltKennerPos + InRowKennerLen+1)
	FileDirektPattern:=SubStr(Edit2,FilePatternKennerLen+1,FirstKommaPos-1)
	FileDirektPattern1StarPos:=InStr(FileDirektPattern,"*")
		; FileDirektPattern2StarPos:=InStr(FileDirektPattern,"*",,0)
		WunschOrdnerPattern:=SubStr(Edit2,FilePatternKennerLen+1,FileDirektPattern1StarPos)
		; Edit11:=SubStr(FileDirektPattern,FileDirektPattern1StarPos+1,FileDirektPattern2StarPos-FileDirektPattern1StarPos-1)
;	if(FocusedGuiConntrol<>"Edit2")
;	{
		if(FocusedGuiConntrol="Edit11")
		{
			if InRowKennerPos
				Edit2:=GetAktuellenDirektSucheFilter(WunschOrdnerPattern,Edit11,ZeileEnthaelt,NachKomma)
			else if InInhaltKennerPos
				Edit2:=GetAktuellenDirektSucheFilter2(WunschOrdnerPattern,Edit11,ZeileEnthaelt,NachKomma)
			gosub Edit2Festigen
		}
;	}
	; MsgBox % WunschOrdnerPattern "	" Edit11 "	" ZeileEnthaelt "	" NachKomma "	" FileDirektPattern1StarPos

}
return
;}	
Edit12:	;{	
if EvalButton1Only
	if NOT InitiatorButton1
		return
ControlGetFocus,FocusedGuiConntrol,ahk_id %GuiWinHwnd%
; MsgBox % FocusedGuiConntrol
if(FocusedGuiConntrol="Edit12")
;	return
	Gui,1:Submit,NoHide
	
FileKennerPos:=InStr(Edit2,FileKenner)
InRowKennerPos:=InStr(Edit2,InRowKenner)
if InRowKennerPos
{
	FirstKommaPos:=InStr(Edit2,"`,",false,0)
	if(InRowKennerPos-FirstKommaPos > 5)
		FirstKommaPos:=0	; ungueltiges Komma gefunden
	NachKomma:=SubStr(Edit2,FirstKommaPos+1,InRowKennerPos-FirstKommaPos-2)
	Optionen:=NachKomma
	ZeileEnthaelt:=Edit12
	FileDirektPattern:=SubStr(Edit2,FilePatternKennerLen+1,FirstKommaPos-1)
	FileDirektPattern1StarPos:=InStr(FileDirektPattern,"*")
		; FileDirektPattern2StarPos:=InStr(FileDirektPattern,"*",,0)
		WunschOrdnerPattern:=SubStr(Edit2,FilePatternKennerLen+1,FileDirektPattern1StarPos)
		; Edit11:=SubStr(FileDirektPattern,FileDirektPattern1StarPos+1,FileDirektPattern2StarPos-FileDirektPattern1StarPos-1)
;	if(FocusedGuiConntrol<>"Edit2")
;	{
		if(FocusedGuiConntrol="Edit12")
		{
			if FileKennerPos 
			{
				Edit2VorInRowKenner:=SubStr(Edit2,1,InRowKennerPos-2)
				Edit2NachInRowKenner:=SubStr(Edit2,InRowKennerPos+InRowKennerLen+1)
				Edit2:=Edit2VorInRowKenner A_Space InRowKenner A_Space Edit12
			}
			else
			{
				; MsgBox % "Edit2:=GetAktuellenDirektSucheFilter(" WunschOrdnerPattern "," Edit11 "," ZeileEnthaelt "," NachKomma ")" ; 
				Edit2:=GetAktuellenDirektSucheFilter(WunschOrdnerPattern,Edit11,ZeileEnthaelt,NachKomma)
			}
			gosub Edit2Festigen
		}
;	}
	; MsgBox % WunschOrdnerPattern "	" Edit11 "	" ZeileEnthaelt "	" NachKomma "	" FileDirektPattern1StarPos

}
NrRowKennerPos:=InStr(Edit2,NrRowKenner)
NrRexKennerPos:=InStr(Edit2,NrRexKenner)
InInhaltKennerPos:=InStr(Edit2,InInhaltKenner)
if (NrRowKennerPos or NrRexKennerPos or InInhaltKennerPos)
{
	; NrRowPos:=InStr(Edit2,NrRowKenner)
	if NrRexKennerPos
		GuiControl,1: Move, Edit12, w300
	DieserKennerPos:=NrRowKennerPos + NrRexKennerPos +InInhaltKennerPos
	VorNrRow:=SubStr(Edit2,1,DieserKennerPos-2)
;	if(FocusedGuiConntrol<>"Edit2")
;	{
		if(FocusedGuiConntrol="Edit12")
		{
			if NrRowKennerPos
				Edit2:=VorNrRow A_Space NrRowKenner A_Space Edit12
			else if NrRexKennerPos
				Edit2:=VorNrRow A_Space NrRexKenner A_Space Edit12
			else if InInhaltKennerPos
				Edit2:=VorNrRow A_Space InInhaltKenner A_Space Edit12
			; Edit2:=GetAktuellenDirektSucheFilter(WunschOrdnerPattern,Edit11,ZeileEnthaelt,NachKomma)
			gosub Edit2Festigen
		}
;	}
	; MsgBox % WunschOrdnerPattern "	" Edit11 "	" ZeileEnthaelt "	" NachKomma "	" FileDirektPattern1StarPos

}
return
;}	
Edit2:		;	@0262														; (wichtigstes Eingabefeld)
HwndEdit2:	;{	SuchEingabeFeld Filter ueber Ordnername (schnell)
Critical,Off
if EvalButton1Only
	if NOT InitiatorButton1
		return
; MsgBox % A_ThisHotkey "	" A_ThisLabel "	" A_ThisFunc "	" A_ThisMenu "	" A_ThisMenuItem "	" A_ThisMenuItemPos
BeschaeftigtAnzeige(1)
; SoundBeep 3000,100

; Gui,1: Color, DDBBAA; EEAA99
Sleep -1
; Gui,1:Submit,NoHide
; GuiControl ,1: +cblack,Edit2
ControlGetFocus,FocusedGuiConntrol,ahk_id %GuiWinHwnd%
if(FocusedGuiConntrol="Edit2")
	Gui,1:Submit,NoHide
IfExist %SkriptDataPath%\AutoSubstEdit2.txt	; moeglichkeit zur Substitution eines individuellen Suchstrings im Container
{
	FileRead,AutoSubstEdit2Inhalt,%SkriptDataPath%\AutoSubstEdit2.txt
	StringSplit,AutoSubstEdit2InhaltZeile,AutoSubstEdit2Inhalt,`n,`r
	if(not InStr(Edit2,AutoSubstEdit2InhaltZeile2))
	{
		Transform,Edit2temp,Deref,%AutoSubstEdit2InhaltZeile1%
		Edit2:=Edit2temp
		gosub Edit2Festigen
	}
}
; GuiControl ,1: +cblack,Edit2
Edit2CaretX:=A_CaretX
Edit2CaretY:=A_CaretY
; ControlGetFocus, FocusedGuiConntrol,A
	Edit2Teil0=
	Edit2Teil1=
	Edit2Teil2=
	Edit2Teil%Edit2TeilR2%=
/*	
	If(SubStr(Edit2,1,1)=")")
	{										; Sonderbehandlung bei erstem Zeichen =)	; RegEx wird hier nicht mehr unterstuetzt
		gosub Edit2Schwarz
		RegExBeratungsFormularFuer:="Edit2"
		gosub RegExBeratungsFormular
	}
	else 
*/

	if(InStr(Edit2,PfRe))	; verwende Ausgang (Edit5) von links → als Eingang von Rechts 	; Beispiel	temp→In_Row? files→Templates→In_Row? 306 	d.h. temp in Edit2 eingegeben ergibt eine Pfadliste in Edit5 ueber diese wird pro zeile weiter gefiltert nach files ... nach Templates ... nach 306 		Ohne In....? ist die Defaulteinstellung InName?		Anders ausgedrueckt → ist wie | bei DOS.
	{
		if(FocusedGuiConntrol="Edit2")
		{
			BeschaeftigtAnzeige(-1)
			return
		}
		Edit6Merker:=Edit6
		Edit6:=999999
		gosub Edit6Festigen
		StringSplit,Edit2Que,Edit2,%PfRe%
		Edit2:=Edit2Que1
		gosub Edit2Festigen	
		gosub Edit2OhnePipe
		Edit6:=Edit6Merker
		gosub Edit6Festigen
		FileDelete,%A_AppData%\Zack\Edit5_1.tmp
		FileAppend,%Edit5%,%A_AppData%\Zack\Edit5_1.tmp,utf-16
		Loop % Edit2Que0
		{
			if(Edit2Que%A_Index%="")
			{
				BeschaeftigtAnzeige(-1)
				return
			}
			
			IndexPlus1:=A_Index+1
			IndexWeg1:=A_Index-1
			if (A_Index=1)
			{
				continue
			}
			if(InStr(Edit2Que%A_Index%,ProtokollKenner))
			{	;	nur fuer Profies, die genau wissen was sie machen
				Edit2:=Edit2Que1%A_Index%
				gosub Edit2Festigen	
			; 	gosub Edit2OhnePipe
				FileDelete,%A_AppData%\Zack\Edit5_%A_Index%.tmp
				FileAppend,%Edit5%,%A_AppData%\Zack\%A_Index%.tmp,utf-16
				continue
			}
			if(SubStr(Edit2Que%A_Index%,InRowKennerLen,1)="?")
			{
				DieserKenner:=SubStr(Edit2Que%A_Index%,1,InrowKennerLen)
				DieserSuchstring:=SubStr(Edit2Que%A_Index%,InRowKennerLen+2)
				Edit2:=FileKenner A_AppData "\Zack\Edit5_" IndexWeg1 ".tmp " DieserKenner A_Space DieserSuchstring
			}
			else 

			{
 				DieserKenner:=InRowKenner
				DieserSuchstring:=Edit2Que%A_Index%
				Edit2:=FileKenner A_AppData "\Zack\Edit5_" IndexWeg1 ".tmp " DieserKenner A_Space DieserSuchstring
			}
						
			gosub Edit2Festigen
			gosub Edit2OhnePipe
			FileDelete,%A_AppData%\Zack\Edit5_%A_Index%.tmp
			FileAppend,%Edit5%,%A_AppData%\Zack\Edit5_%A_Index%.tmp,utf-16
		}
	}
	else if(InStr(Edit2,ReturnChar))	; verwende Ausgang (Edit5) von links → als Eingang von Rechts 	; Beispiel	temp→In_Row? files→Templates→In_Row? 306 	d.h. temp in Edit2 eingegeben ergibt eine Pfadliste in Edit5 ueber diese wird pro zeile weiter gefiltert nach files ... nach Templates ... nach 306 		Ohne In....? ist die Defaulteinstellung InName?		Anders ausgedrueckt → ist wie | bei DOS.
	{
		if(FocusedGuiConntrol="Edit2")
		{
			BeschaeftigtAnzeige(-1)
			return
		}
		Edit6Merker:=Edit6
		; Edit6:=999999
		; gosub Edit6Festigen
		StringSplit,Edit2Que,Edit2,%ReturnChar%
		FileDelete,%A_AppData%\Zack\Edit5_1.tmp
	; 	FileAppend,%Edit5%,%A_AppData%\Zack\Edit5_1.tmp,utf-16
		Loop % Edit2Que0
		{
			if(Edit2Que%A_Index%="")
			{
				BeschaeftigtAnzeige(-1)
				return
			}
			
			IndexPlus1:=A_Index+1
			IndexWeg1:=A_Index-1
			Edit2:=Edit2Que%A_Index%
			gosub Edit2Festigen	
			gosub Edit2OhnePipe
			; MsgBox % Edit2 "`n" Edit5
			FileAppend,%Edit5%,%A_AppData%\Zack\Edit5_1.tmp,utf-16
		}
		Edit2:=FileKenner A_AppData "\Zack\Edit5_1.tmp " InRowKenner A_Space

 		gosub Edit2Festigen
	}
	else
	{
		gosub Edit2OhnePipe
	}
;	Gui,1: Color,EEAA99 ; DDBBAA; EEAA99
	Gui,1:Submit,NoHide
BeschaeftigtAnzeige(-1)
return
;}	
Edit2OhnePipe:	;{		
BeschaeftigtAnzeige(1)
Edit8HtmlErsetzen:=false
NeueLiveStringAuswertung:=false
if Edit2 contains %PlusKennerKommaListe%,``v,``t,,`v
{
	NeueLiveStringAuswertung:=true
}
else 
	if Edit2 contains %MinusKennerKommaListe%
		NeueLiveStringAuswertung:=true
if NOT NeueLiveStringAuswertung
	SetTimer, TimerEveryFuenfSec,Off

if(NeueLiveStringAuswertung OR (InStr(Edit2,"`v") and InStr(Edit2,ProtokollKenner)) or InStr(Edit2,ControlTextKenner) or InStr(Edit2,ContainerKenner) or InStr(Edit2,WinMgmtsKenner) InStr(Edit2,ExplorerSelectedKenner) or InStr(Edit2,HwndTextKenner) or InStr(Edit2,FileKenner) or InStr(Edit2,IeExistKenner) or InStr(Edit2,HelpQuellKenner) or InStr(Edit2,HelpKenner) or InStr(Edit2,ExplorerSelectedKenner) or (SubStr(Edit2,1,8)="Clip://	") or (InStr(Edit2,"HtmPicView?")))

{
	SucheAbgebrochen:=false
		NeueLiveStringAuswertung:=true
 	SetTimer, TimerEveryFuenfSec,5000 

	StringReplace,Edit2Modi,Edit2,`%VTab`%,`v,All
	StringReplace,Edit2Modi,Edit2Modi,`%A_Tab`%,`t,All
	StringReplace,Edit2Modi,Edit2Modi,````v,,All
	StringReplace,Edit2Modi,Edit2Modi,``v,,All
	StringReplace,Edit2Modi,Edit2Modi,`v,,All
	StringReplace,Edit2Modi,Edit2Modi,``v,`v,All
	StringReplace,Edit2Modi,Edit2Modi,``t,`t,All
	Edit5:=LiveSuchStringAuswertung(Edit2Modi)
	Loop 10
	{
		if(SubStr(Edit5,0,1)="`n" OR SubStr(Edit5,0,1)="`r")
			StringTrimRight,Edit5,Edit5,1
		else
			break
	}
	gosub Edit2Schwarz

	gosub Edit5Festigen
	if(InStr(Edit1,DotOverDot))	
	{
		; Gui,1:Submit,NoHide
		Edit1ungekuerzt:=ZaehleZeilen(Edit5)	

		StringSplit,VorDotOverDot,Edit1,:
		if(VorDotOverDot0>1)
		{
			
			AnzahlZeichenLinksWeg:=0
			StringReplace,VorDotOverDot1,VorDotOverDot1,`(
			StringReplace,VorDotOverDot2,VorDotOverDot2,`)
			Edit1:="(" VorDotOverDot1 ":" Edit1ungekuerzt ")"
			AnzahlZeilenObenWeg:=VorDotOverDot1-1
			if (AnzahlZeilenObenWeg>0)
			{
				Edit5:=Entferne(Edit5,AnzahlZeichenLinksWeg,AnzahlZeilenObenWeg)
				gosub Edit5Festigen
			}
		}
	}
	else
	{
		Edit1:=ZaehleZeilen(Edit5)	; Change372a
	}	
	gosub Edit1Festigen
	gosub Edit3
	BeschaeftigtAnzeige(-1)
	return
}

; MsgBox % SubStr(Edit2,1,FilePatternKennerLen)
	If(SubStr(Edit2,1,FilePatternKennerLen)=FilePatternKenner)	; Sonderbehandlung bei für File-Direkt
	{	; FilP
		; BeschaeftigtAnzeige(0,"A_LineNumber" . A_LineNumber)
		gosub Edit2Schwarz
		SucheAbgebrochen:=false
		Edit2VorVorTextAnsicht:=Edit2VorTextAnsicht
		Edit2VorTextAnsicht:=Edit2
		FileDirektPatternPlus:=SubStr(Edit2,FilePatternKennerLen+1)
		InRowKennerPos:=InStr(Edit2,InRowKenner)
		; MsgBox %A_LineNumber% 	InRowKennerPos %InRowKennerPos%
		InInhaltKennerPos:=InStr(Edit2,InInhaltKenner)
		NrRowKennerPos:=InStr(Edit2,NrRowKenner)
		; InInhaltKenner:="In_Inh?"
		if InRowKennerPos
		{
			; BeschaeftigtAnzeige(0,"A_LineNumber" . A_LineNumber)
			FirstKommaPos:=InStr(SubStr(Edit2,1,InRowKennerPos),"`,",false,0)
			NachKomma:=SubStr(Edit2,FirstKommaPos+1,InRowKennerPos-FirstKommaPos-2)
			; MsgBox %A_LineNumber% 	NachKomma %NachKomma%
			ZeileEnthaelt:=SubStr(Edit2,InRowKennerPos+InRowKennerLen+1)
			FileDirektPattern:=SubStr(Edit2,FilePatternKennerLen+1,FirstKommaPos-FilePatternKennerLen-1)
			FileDirektPattern1StarPos:=InStr(FileDirektPattern,"*")
			FileDirektPattern2StarPos:=InStr(FileDirektPattern,"*",,0)
			ControlGetFocus,FocusedGuiConntrol,ahk_id %GuiWinHwnd%
			if (FocusedGuiConntrol="Edit2")
			{
				Edit11:=SubStr(FileDirektPattern,FileDirektPattern1StarPos+1,FileDirektPattern2StarPos-FileDirektPattern1StarPos-1)
; 				Edit11:=Edit11Erst
				gosub Edit11Festigen
			}
			if (FocusedGuiConntrol="Edit2")
			{
				Edit12:=ZeileEnthaelt
				gosub Edit12Festigen
			}
		}
		else if InInhaltKennerPos
		{
			; BeschaeftigtAnzeige(0,"A_LineNumber" . A_LineNumber)
			FirstKommaPos:=InStr(SubStr(Edit2,1,InInhaltKennerPos),"`,",false,0)
			; FirstKommaPos:=InStr(Edit2,"`,",false,0)
			NachKomma:=SubStr(Edit2,FirstKommaPos+1,InInhaltKennerPos-FirstKommaPos-2)
			; MsgBox %A_LineNumber% 	NachKomma %NachKomma%
			ZeileEnthaelt:=SubStr(Edit2,InInhaltKennerPos+InInhaltKennerLen+1)
			FileDirektPattern:=SubStr(Edit2,FilePatternKennerLen+1,FirstKommaPos-FilePatternKennerLen-1)
			FileDirektPattern1StarPos:=InStr(FileDirektPattern,"*")
			FileDirektPattern2StarPos:=InStr(FileDirektPattern,"*",,0)
			ControlGetFocus,FocusedGuiConntrol,ahk_id %GuiWinHwnd%
			if (FocusedGuiConntrol="Edit2")
			{
				Edit11:=SubStr(FileDirektPattern,FileDirektPattern1StarPos+1,FileDirektPattern2StarPos-FileDirektPattern1StarPos-1)
; 				Edit11:=Edit11Erst
				gosub Edit11Festigen
			}
			if (FocusedGuiConntrol="Edit2")
			{
				Edit12:=ZeileEnthaelt
				gosub Edit12Festigen
			}
		}
		else if NrRowKennerPos
		{
			; BeschaeftigtAnzeige(0,"A_LineNumber" . A_LineNumber)
			FirstKommaPos:=InStr(SubStr(Edit2,1,NrRowKennerPos),"`,",false,0)
			NachKomma:=SubStr(Edit2,FirstKommaPos+1,NrRowKennerPos-FirstKommaPos-2)
			; MsgBox %A_LineNumber% 	NachKomma %NachKomma%
			ZeileEnthaelt:=SubStr(Edit2,NrRowKennerPos+NrRowKennerLen+1)
			FileDirektPattern:=SubStr(Edit2,FilePatternKennerLen+1,FirstKommaPos-FilePatternKennerLen-1)
			FileDirektPattern1StarPos:=InStr(FileDirektPattern,"*")
			FileDirektPattern2StarPos:=InStr(FileDirektPattern,"*",,0)
			ControlGetFocus,FocusedGuiConntrol,ahk_id %GuiWinHwnd%
			if (FocusedGuiConntrol="Edit2")
			{
				Edit11:=SubStr(FileDirektPattern,FileDirektPattern1StarPos+1,FileDirektPattern2StarPos-FileDirektPattern1StarPos-1)
; 				Edit11:=Edit11Erst
				gosub Edit11Festigen
			}
			if (FocusedGuiConntrol="Edit2")
			{
				Edit12:=ZeileEnthaelt
				gosub Edit12Festigen
			}
		}
		else
		{
			; BeschaeftigtAnzeige(0,"A_LineNumber" . A_LineNumber)
			FirstSternDotSternKommaPos:=InStr(FileDirektPatternPlus,"*.*`,")
			FirstSternKommaPos:=InStr(FileDirektPatternPlus,"*`,")
			if FirstSternDotSternKommaPos
				FirstKommaPos:=FirstSternDotSternKommaPos+3
			else if FirstSternKommaPos
				FirstKommaPos:=FirstSternKommaPos+1
			else
			{
				FileDirektPatternExist:=
				Loop, 10	; Max 10 Kommas im FilePattern werden unterstützt Beispiel: FilP://C:\temp\Ger,d - Ko,pie - Kop,ie\Helga.txt,DFR txt
				{	; auch positiv getestet:  FilP://C:\temp\Ger,d - Ko,pie - Kop,ie\Helga*txt,DFR txt
					FirstKommaPos:=InStr(FileDirektPatternPlus,"`,",,,A_Index)
					FileDirektPathProbe:=SubStr(FileDirektPatternPlus,1,FirstKommaPos-1)
					IfExist %FileDirektPathProbe%
					{
						FileDirektPatternExist:=true
						break
					}
				}
				if (FileDirektPatternExist="")
				{
					FileDirektPatternExist:=false
					SucheAbgebrochen:=true
				}
			}
			if FirstKommaPos
			{
				; BeschaeftigtAnzeige(0,"A_LineNumber" . A_LineNumber)
				FileDirektPattern:=SubStr(FileDirektPatternPlus,1,FirstKommaPos-1)
				NachKommaSpacePos:=InStr(SubStr(FileDirektPatternPlus,FirstKommaPos),A_Space)+FirstKommaPos-1
				if(NachKommaSpacePos=0)
					NachKommaSpacePos:=StrLen(FileDirektPatternPlus)+1
				NachKomma:=SubStr(FileDirektPatternPlus,FirstKommaPos+1,NachKommaSpacePos-FirstKommaPos-1)
				NachKommaLen:=StrLen(NachKomma)
				ZeileEnthaelt:=SubStr(FileDirektPatternPlus,FirstKommaPos+NachKommaLen+2)
			}
		}
		if (not Edit11Exist and FileDirektPattern<>"")
			{
			; BeschaeftigtAnzeige(0,"A_LineNumber" . A_LineNumber)
			Edit11Exist:=true
			Edit12Exist:=true
			GuiControl, Show,%HwndEdit11%
			GuiControl, Show,%HwndEdit12%
			}
		else if(FileDirektPattern<>"")
		{			; Pruefen 3.12.17
			; BeschaeftigtAnzeige(0,"A_LineNumber" . A_LineNumber)		
			GuiControl, Show,%HwndEdit11%
			GuiControl, Show,%HwndEdit12%
		}

		Edit5:=		 

		if Fehlersuche
			ToolTip,>Loop`,Files`,%FileDirektPattern%`,%NachKomma%<>%ZeileEnthaelt%<	%FirstKommaPos%	%NachKommaSpacePos%
		RI:=1
		if(SubStr(FileDirektPattern,-2)="\**")
		{
			if (ZeileEnthaelt(SubStr(FileDirektPattern,1,-3),ZeileEnthaelt))
				Edit5:=SubStr(FileDirektPattern,1,-3)
		}
		else if(SubStr(FileDirektPattern,-1)="\*")
		{
			if (ZeileEnthaelt(SubStr(FileDirektPattern,1,-2),ZeileEnthaelt))
				Edit5:=SubStr(FileDirektPattern,1,-2)
		}
		else
			Edit5:=
;		SucheAbgebrochen:=false	; gibts oben schon Pruefen ob alle Faelle
		AbbrBei:=Edit6*3
		; MsgBox %A_LineNumber% 	NachKomma %NachKomma%
		
		Loop,Files,%FileDirektPattern%,%NachKomma%
		{
			; < auf AllesAbbrechen reagieren >
			if AllesAbbrechen
			{
				SucheAbgebrochen:=true
				ToolTip,,,,19
				AllesAbbrechen:=false
				break
			}
			; </ auf AllesAbbrechen reagieren >

			if InRowKennerPos
			{
				; if(InStr(A_LoopFileFullPath,ZeileEnthaelt))	; FilP://G:\*Peter*Alexander*,DFR	FilP://G:\*Peter*Alexander*,DFR Top
				; BeschaeftigtAnzeige(0,"A_LineNumber" . A_LineNumber)
				if (ZeileEnthaelt(A_LoopFileFullPath,ZeileEnthaelt))
				{	; soll: FilP://G:\*Peter*Alexander*,DFR In_Row? Top
					Edit5.="`r`n" A_LoopFileFullPath
					++RI
				}
			}
			else if NrRowKennerPos
			{
					FuellAnz:=10-StrLen(A_Index)
				; BeschaeftigtAnzeige(0,"A_LineNumber" . A_LineNumber)
				if (ZeileEnthaelt(A_LoopFileFullPath,ZeileEnthaelt))
				{
					Edit5.="`r`n" A_Index FuellLeerzeichen%FuellAnz% A_LoopFileFullPath
					++RI
				}
			}
			else if InInhaltKennerPos		; FilP://C:\Users\Gerd\AppData\Roaming\Zack\*SuchbegriffsObenNeu*,DF In_Inh? InhaltsSuchbegriff
			{
				if(InStr(Edit2,InInhaltKennerNotShowPath,1))	; in_inh? klein geschrieben zeigt nicht die FundstellenPfade
					InInhaltKennerShowPath:=false
				else
					InInhaltKennerShowPath:=true				; In_Inh? mindest 1 Buchstabe gross geschrieben zeigt die FundstellenPfade an
				; FileRead,Dieserinhalt,%A_LoopFileFullPath%
				; BeschaeftigtAnzeige(0,"A_LineNumber" . A_LineNumber)
				If(SubStr(A_LoopFileFullPath,-3)=".dll")
				{
					FileAuswahlInhalt:=DllListExports(A_LoopFileFullPath)
					Loop,Parse,FileAuswahlInhalt,`n,`r
					{
						if (ZeileEnthaelt(A_LoopField,ZeileEnthaelt))
						{	
							if InInhaltKennerShowPath
								Edit5.="`r`n"  A_LoopField A_Tab A_LoopFileFullPath
							else
								Edit5.="`r`n" A_LoopField
							++RI
						}
					}
				}
				else
				{
					Loop,Read,%A_LoopFileFullPath%
					{
						; if(InStr(A_LoopReadLine,ZeileEnthaelt))	; FilP://G:\*Peter*Alexander*,DFR	FilP://G:\*Peter*Alexander*,DFR Top
						if (ZeileEnthaelt(A_LoopReadLine,ZeileEnthaelt))
						{	; soll: FilP://G:\*Peter*Alexander*,DFR In_Row? Top
							; BeschaeftigtAnzeige(0,"A_LineNumber" . A_LineNumber)
							if InInhaltKennerShowPath
								Edit5.="`r`n"  A_LoopReadLine A_Tab A_LoopFileFullPath
							else
								Edit5.="`r`n" A_LoopReadLine
							++RI
						}
					}
				}
			}
			else
			{
				; BeschaeftigtAnzeige(0,"A_LineNumber" . A_LineNumber)
				; if(InStr(A_LoopFileName,ZeileEnthaelt))	; FilP://G:\*Peter*Alexander*,DFR	FilP://G:\*Peter*Alexander*,DFR Top
				if (ZeileEnthaelt(A_LoopFileName,ZeileEnthaelt))
				{	; soll: FilP://G:\*Peter*Alexander*,DFR In_Row? Top
					Edit5.="`r`n" A_LoopFileFullPath
					++RI
				}
			}
		if(SubStr(RI,0)=0)
			{
				Critical Off 
;					Edit5:=Ges
				; BeschaeftigtAnzeige(0,"A_LineNumber" . A_LineNumber)
				gosub Edit5Festigen
				Sleep -1
			; < auf AllesAbbrechen reagieren >
				if AllesAbbrechen
				{
					SucheAbgebrochen:=true
					ToolTip,,,,19
					AllesAbbrechen:=false
					break
				}
			; </ auf AllesAbbrechen reagieren >
			}
			else if(RI>AbbrBei) ; or A_TimeIdlePhysical<10)
			{
;				ToolTip % A_TimeIdlePhysical
				SucheAbgebrochen:=true
				ToolTip
				break
			}
			
		}
;		FileDirektInhalt:=SubStr(Ges,3)
;		Edit5:=FileDirektInhalt
		if(SubStr(Edit5,1,2)="`r`n")
			Edit5:=SubStr(Edit5,3)
		gosub Edit5Festigen
		Edit1:=ZaehleZeilen(Edit5)	; Change372a
		gosub Edit1Festigen
		If(Edit1<Edit3)
		{
			; SoundBeep
			Edit3:=1
			gosub Edit3Festigen
		}
		GuiControl,1:, Edit5, %Edit5%  
		Edit8:=GetZeile(Edit5,Edit3)	; neu 06.05.2017
		gosub Edit8Festigen			; neu 06.05.2017
		LetzerAendererVonEdit5:="Edit2"
		if InRowKennerPos
		{
			ZueletztFokusieren:="Edit11"
			SchreibMarkenOrt:="End"
		}
; 		else
;		{
;			ZueletztFokusieren:="Edit11"
;			SchreibMarkenOrt:="End"
;		}
		BeschaeftigtAnzeige(-1)
		; MsgBox % A_LineNumber "`r`n" edit5
		return
	}
	else If(SubStr(Edit2,1,ClipKennerLen)=ClipKenner)	; Sonderbehandlung bei für Clip-Direkt	Clip:// In_Row? *	Clip:// InName? *
	{
		gosub Edit2Schwarz
		Edit2VorTextAnsicht:=Edit2
		; Gui,1:Submit,NoHide
		; ClipAuswahl:=SubStr(Edit2,8)
		FragezeichenPos:=InStr(Edit2,"?")
		ClipAuswahlArt:=SubStr(Edit2,InRowKennerLen+2,FragezeichenPos-InRowKennerLen -1)			; In_Row?		; dies Funktioniert nur solange InRowKennerLen=InNameKennerLen ist bei <> muss nachprogrammiert werden!!!
		; MsgBox >%ClipAuswahlArt%<
		if(ClipAuswahlArt=InRowKenner)				; die Zeile Enthält
		{
			ZeileEnthaelt:=SubStr(Edit2,ClipKennerLen+1+InRowKennerLen+1+1)
			Ges=
			Loop,Parse,Clipboard,`n,`r
			{
				; if(InStr(A_LoopField,ZeileEnthaelt))
				if (ZeileEnthaelt(A_LoopField,ZeileEnthaelt))
				{
						Ges.="`r`n" A_LoopField
				}
			}
			Edit5:=SubStr(Ges,3)
			SucheAbgebrochen:=false
		}
		else if(ClipAuswahlArt=NrRowKenner)				; die Zeile Enthält
		{
			ZeileEnthaelt:=SubStr(Edit2,ClipKennerLen+1+InRowKennerLen+1+1)
			Ges=
			Loop,Parse,Clipboard,`n,`r
			{
				FuellAnz:=10-StrLen(A_Index)
				; if(InStr(A_LoopField,ZeileEnthaelt))
				if (ZeileEnthaelt(A_LoopField,ZeileEnthaelt))
				{
						Ges.="`r`n" A_Index FuellLeerzeichen%FuellAnz%          A_LoopField
				}
			}
			Edit5:=SubStr(Ges,3)
			SucheAbgebrochen:=false
		}
		else if(ClipAuswahlArt=InNameKenner)			; wenn sich der Pfad splitten lässt wird nur im Name gesucht sonst in der Zeile
		{
			NameEnthaelt:=SubStr(Edit2,InNameKennerLen+1+InNameKennerLen+1+1)
			Ges=
			Loop,Parse,Clipboard,`n,`r
			{
				SplitPath,A_LoopField,DieserName
				; if(InStr(DieserName,NameEnthaelt))
				if (ZeileEnthaelt(DieserName,NameEnthaelt))

				{
						Ges.="`r`n" A_LoopField
				}
			}
			Edit5:=SubStr(Ges,3)
			SucheAbgebrochen:=false
		}
		else if(FragezeichenPos=0 and ClipAuswahlArt="")
			Edit5:=Clipboard
		else
			Edit5:=
		gosub Edit5Festigen
		Edit8:=GetZeile(Edit5,Edit3)
		GuiControl,1:, Edit5, %Edit5%  
		LetzerAendererVonEdit5:="Edit2"
		gosub Edit8Festigen
		Edit1:=ZaehleZeilen(Ges)	; Change372a
		gosub Edit1Festigen
		SucheAbgebrochen:=false
		BeschaeftigtAnzeige(-1)
		return
	}
	else If(SubStr(Edit2,1,FileKennerLen)=FileKenner)	; Sonderbehandlung bei für File-Inhalt z.B.: File://Pfad InRow?Suchbegriff
	{
		gosub Edit2Schwarz
		Edit2VorVorTextAnsicht:=Edit2VorTextAnsicht
		Edit2VorTextAnsicht:=Edit2
		; FileAuswahl:=SubStr(Edit2,FileKennerLen+1)
		FragezeichenPos:=InStr(Edit2,"?")
		FileAuswahlArt:=SubStr(Edit2,FragezeichenPos-InRowKennerLen+1,InRowKennerLen )			; In_Row?		; dies Funktioniert nur solange InRowKennerLen=InNameKennerLen ist bei <> muss nachprogrammiert werden!!!
		if FragezeichenPos
			FileAuswahlPfad:=SubStr(Edit2,FileKennerLen+1,FragezeichenPos-InRowKennerLen-1-FileKennerLen)
		else
			FileAuswahlPfad:=SubStr(Edit2,FileKennerLen+1)
		If(SubStr(FileAuswahlPfad,-3)=".dll")
			FileAuswahlInhalt:=DllListExports(FileAuswahlPfad)
		else
			FileRead,FileAuswahlInhalt,%FileAuswahlPfad%
		; MsgBox >%FileAuswahlPfad%< `n>%FileAuswahlArt%<`n%FileAuswahlInhalt%
		if(FileAuswahlArt=InRowKenner)				; die Zeile Enthält
		{
			InRowPos:=InStr(Edit2,InRowKenner)
			ZeileEnthaelt:=SubStr(Edit2,InRowPos+InRowKennerLen+1)
			; MsgBox % ">" ZeileEnthaelt "<	" (InRowPos+InRowKennerLen+2) "<"
			; ZeileEnthaelt:=SubStr(Edit2,FragezeichenPos+2)
			Ges := 
			GesZeileAnzahl:=0
			FileGetAttrib,FileDirektAttribute,%FileAuswahlPfad%
			if(InStr(FileDirektAttribute,"D"))
			{
				Ges := FileDirektPath
				SucheAbgebrochen:=false
				Loop,Files,%FileDirektPath%\*.*,F D
				{
					; < auf AllesAbbrechen reagieren >
					if AllesAbbrechen
					{
						SucheAbgebrochen:=true
						; ToolTip,,,,19
						AllesAbbrechen:=false
						break
					}
					; if(InStr(A_LoopFileFullPath,ZeileEnthaelt))
					if (ZeileEnthaelt(A_LoopFileFullPath,ZeileEnthaelt))				
					{
						++GesZeileAnzahl
						Ges.="`r`n" A_LoopFileFullPath
					}
					if(GesZeileAnzahl>Edit6*3)
					{
						SucheAbgebrochen:=true
						break
					}
				}
				; FileDirektInhalt:=SubStr(Ges,3) 	;  wird bei Ges=%FileDirektPath% nicht mehr benoetigt
			}
			else
			{
				GesZeileAnzahl:=0
				SucheAbgebrochen:=false
				Loop,Parse,FileAuswahlInhalt,`n,`r
				{
					; if(InStr(A_LoopField,ZeileEnthaelt))
					if (ZeileEnthaelt(A_LoopField,ZeileEnthaelt))				
					{
							++GesZeileAnzahl
							Ges.="`r`n" A_LoopField
					}
					if(GesZeileAnzahl>Edit6*3)
					{
							SucheAbgebrochen:=true
							break
					}
				}
				Edit5:=SubStr(Ges,3)
				Edit1:=ZaehleZeilen(Ges)	; Change372a
				gosub Edit1Festigen
				GuiControl, Show,%HwndEdit12%
				GuiControl, Hide,%HwndEdit11%
				if not(FocusedGuiConntrol="Edit12")
				{
					Edit12:=ZeileEnthaelt
					gosub Edit12Festigen
				}
			}
		}
		else if(FileAuswahlArt=NrRowKenner)				; die Zeile Enthält
		{
			ZeileEnthaelt:=SubStr(Edit2,FragezeichenPos+2)
			Ges=
			GesZeileAnzahl:=0
			FileGetAttrib,FileDirektAttribute,%FileAuswahlPfad%
			if(InStr(FileDirektAttribute,"D"))
			{
				Ges=
				Loop,Files,%FileDirektPath%\*.*,F D
				{
					; < auf AllesAbbrechen reagieren >
					if AllesAbbrechen
					{
						SucheAbgebrochen:=true
						ToolTip,,,,19
						AllesAbbrechen:=false
						break
					}
					; if(InStr(A_LoopFileFullPath,ZeileEnthaelt))
					if (ZeileEnthaelt(A_LoopFileFullPath,ZeileEnthaelt))
					{
						++GesZeileAnzahl
						Ges.="`r`n" A_LoopFileFullPath
					}
				}
				FileDirektInhalt:=SubStr(Ges,3)
				Edit1:=ZaehleZeilen(Ges)	; Change372a
				gosub Edit1Festigen
				SucheAbgebrochen:=false

			}
			else
			{
	 			SucheAbgebrochen:=false
				FuellAnz:=1
				GesZeileAnzahl:=0
				Loop,Parse,FileAuswahlInhalt,`n,`r
				{
					FuellAnz:=10-StrLen(A_Index)

					; if(InStr(A_LoopField,ZeileEnthaelt))
					if (ZeileEnthaelt(A_LoopField,ZeileEnthaelt))
					{
							++GesZeileAnzahl
							; Ges.="`r`n" A_Index "	" A_LoopField
							Ges.="`r`n" A_Index FuellLeerzeichen%FuellAnz%          A_LoopField

					}
					++FuellAnz
					if(GesZeileAnzahl>Edit6*3)
					{
							SucheAbgebrochen:=true
							break
					}
				}
				Edit5:=SubStr(Ges,3)
				Edit1:=ZaehleZeilen(Ges)	; Change372a
				gosub Edit1Festigen
				GuiControl, Show,%HwndEdit12%
				GuiControl, Hide,%HwndEdit11%
				if not(FocusedGuiConntrol="Edit12")
				{
					Edit12:=ZeileEnthaelt
					gosub Edit12Festigen
				}
			}
		}
		else if(FileAuswahlArt=NrRexKenner)				; die Zeile Enthält
		{
			InRexPos:=InStr(Edit2,NrRexKenner)
			ZeileEnthaelt:=SubStr(Edit2,InRexPos+NrRexKennerLen+1)
	
			; ZeileEnthaelt:=SubStr(Edit2,FragezeichenPos+2)
			Ges=
			GesZeileAnzahl:=0
			FileGetAttrib,FileDirektAttribute,%FileAuswahlPfad%
			if(InStr(FileDirektAttribute,"D"))
			{
				Ges=
				Loop,Files,%FileDirektPath%\*.*,F D
				{
					; < auf AllesAbbrechen reagieren >
					if AllesAbbrechen
					{
						SucheAbgebrochen:=true
						ToolTip,,,,19
						AllesAbbrechen:=false
						break
					}
					if(RegExMatch(A_LoopFileFullPath,ZeileEnthaelt))
					{
						++GesZeileAnzahl
						Ges.="`r`n" A_LoopFileFullPath
					}
				}
				FileDirektInhalt:=SubStr(Ges,3)
				Edit1:=ZaehleZeilen(Ges)	; Change372a
				gosub Edit1Festigen
				SucheAbgebrochen:=false

			}
			else
			{
	 			SucheAbgebrochen:=false
				FuellAnz:=1
				GesZeileAnzahl:=0
				Loop,Parse,FileAuswahlInhalt,`n,`r
				{
					FuellAnz:=10-StrLen(A_Index)

					if(RegExMatch(A_LoopField,ZeileEnthaelt))
					{
							++GesZeileAnzahl
							; Ges.="`r`n" A_Index "	" A_LoopField
							Ges.="`r`n" A_Index FuellLeerzeichen%FuellAnz%          A_LoopField

					}
					++FuellAnz
					if(GesZeileAnzahl>Edit6*3)
					{
							SucheAbgebrochen:=true
							break
					}
				}
				Edit5:=SubStr(Ges,3)
				Edit1:=ZaehleZeilen(Ges)	; Change372a
				gosub Edit1Festigen
				GuiControl, Show,%HwndEdit12%
				GuiControl, Hide,%HwndEdit11%
				if not(FocusedGuiConntrol="Edit12")
				{
					Edit12:=ZeileEnthaelt
					gosub Edit12Festigen
				}
			}
		}
		else if(FileAuswahlArt=InNameKenner)			; wenn sich der Pfad splitten lässt wird nur im Name gesucht sonst in der Zeile
		{
			NameEnthaelt:=SubStr(Edit2,FragezeichenPos+2)
			Ges=
			Loop,Parse,FileAuswahlInhalt,`n,`r
			{
				SplitPath,A_LoopField,DieserName
				; if(InStr(DieserName,NameEnthaelt))
				if (ZeileEnthaelt(DieserName,NameEnthaelt))				
				{
						Ges.="`r`n" A_LoopField
				}
			}
			Edit5:=SubStr(Ges,3)
			Edit1:=ZaehleZeilen(Ges)	; Change372a
			gosub Edit1Festigen
			SucheAbgebrochen:=false
		}
		else if(FileAuswahlArt=MacroAufuehrenKenner)		; AufrufBeispiel: file://%A_AppData%\Zack\Macro\ZeigeLaufwerkeInEdit5.txt MacrDo? 1
		{
			IfExist %FileAuswahlPfad%
			{
				MacroZeilenNummer:=SubStr(Edit2,FragezeichenPos+2)

				if(MacroZeilenNummer="")
				{
					; MsgBox Macro %FileAuswahlPfad% ausführen
					DiesenBefehlsDateiPfad:=FileAuswahlPfad
					gosub DiesenBefehlsDateiPfadAusfuehren
				}
				else if MacroZeilenNummer is Integer	; Macro-Debug-Modus
				{	; Macro-Start bei Zeilenummer
					DieseZeilenummer:=MacroZeilenNummer
					StringSplit,FileAuswahlInhaltZeile,FileAuswahlInhalt,`n,`r
					Loop % FileAuswahlInhaltZeile0-DieseZeilenummer+1
					{
						
						BefehlsMacro:=FileAuswahlInhaltZeile%DieseZeilenummer%
						MsgBox, 262147, Debug Macro, BefehlsZeile:  %DieseZeilenummer%	>%BefehlsMacro%<  ausfuehren?`n`nvon Macro`n%FileAuswahlPfad%
						IfMsgBox,Yes							
							gosub BefehlsVariableAusfuehren
						IfMsgBox Cancel
							break
						++DieseZeilenummer
					}
				}
			}
		}
		else if(FragezeichenPos=0 ) ; and ClipAuswahlArt="")
		{
			Edit5:=FileAuswahlInhalt
			SucheAbgebrochen:=false
		}
		else
			Edit5:=
		gosub Edit5Festigen
		
		Edit8:=GetZeile(Edit5,Edit3)
		gosub Edit8Festigen
		GuiControl,1:, Edit5, %Edit5%  
		LetzerAendererVonEdit5:="Edit2"
		Edit1:=ZaehleZeilen(Edit5)
		gosub Edit1Festigen
		BeschaeftigtAnzeige(-1)
		return
	}
	else If(SubStr(Edit2,1,ControlTextKennerLen)=ControlTextKenner)	; Sonderbehandlung bei für Control-Text-Inhalt 
	{
		gosub Edit2Schwarz
		Edit2VorVorTextAnsicht:=Edit2VorTextAnsicht
		Edit2VorTextAnsicht:=Edit2
		
		ControlTextKennerPos:=InStr(Edit2,ControlTextKenner)
		WinTitleKennerPos:=InStr(Edit2,WinTitleKenner)
		ControlKennerPos:=InStr(Edit2,ControlKenner)
		WinTitleLen:=ControlKennerPos - WinTitleKennerPos - WinTitleKennerLen
		NrRowKennerPos:=InStr(Edit2,NrRowKenner)
		if NrRowKennerPos
			FileAuswahlArt:=NrRowKenner
		ControlLen:=NrRowKennerPos - ControlKennerPos - ControlKennerLen
		DieserWinTitle:=SubStr(Edit2,WinTitleKennerPos + WinTitleKennerLen +1,WinTitleLen -2)
		DiesesControl:=SubStr(Edit2,ControlKennerPos + ControlKennerLen+1,ControlLen -2)
		if(DiesesControl="SysListView321")
			ControlGet, FileAuswahlInhalt, List, 		, SysListView321,%DieserWinTitle%
		else
			ControlGetText,FileAuswahlInhalt,%DiesesControl%,%DieserWinTitle%
		
		; FileRead,FileAuswahlInhalt,%FileAuswahlPfad%
		; MsgBox >%FileAuswahlPfad%< `n>%FileAuswahlArt%<`n%FileAuswahlInhalt%
		if(FileAuswahlArt=InRowKenner)				; die Zeile Enthält
		{
			ZeileEnthaelt:=SubStr(Edit2,FragezeichenPos+2)
			Ges=
			; FileGetAttrib,FileDirektAttribute,%FileAuswahlPfad%
			; if(InStr(FileDirektAttribute,"D"))
			if 0
			{
				Ges=
				Loop,Files,%FileDirektPath%\*.*,F D
				{
					; < auf AllesAbbrechen reagieren >
					if AllesAbbrechen
					{
						SucheAbgebrochen:=true
						ToolTip,,,,19
						AllesAbbrechen:=false
						break
					}
					; if(InStr(A_LoopFileFullPath,ZeileEnthaelt))
					if (ZeileEnthaelt(A_LoopFileFullPath,ZeileEnthaelt))				
						Ges.="`r`n" A_LoopFileFullPath
				}
				FileDirektInhalt:=SubStr(Ges,3)
			}
			else

			Loop,Parse,FileAuswahlInhalt,`n,`r
			{
				; if(InStr(A_LoopField,ZeileEnthaelt))
				if (ZeileEnthaelt(A_LoopField,ZeileEnthaelt))				
				{
						Ges.="`r`n" A_LoopField
				}
			}
			Edit5:=SubStr(Ges,3)
			Edit1:=ZaehleZeilen(Ges)	; Change372a
			gosub Edit1Festigen
			SucheAbgebrochen:=false
		}
		else if(FileAuswahlArt=NrRowKenner)				; die Zeile Enthält
		{
			ZeileEnthaelt:=SubStr(Edit2,NrRowKennerPos + NrRowKennerLen + 1)
			; ToolTip,%ZeileEnthaelt%
			Ges=
			; FileGetAttrib,FileDirektAttribute,%FileAuswahlPfad%
			; if(InStr(FileDirektAttribute,"D"))
			if 0
			{
				Ges=
				Loop,Files,%FileDirektPath%\*.*,F D
				{
					; < auf AllesAbbrechen reagieren >
					if AllesAbbrechen
					{
						SucheAbgebrochen:=true
						ToolTip,,,,19
						AllesAbbrechen:=false
						break
					}
					; if(InStr(A_LoopFileFullPath,ZeileEnthaelt))
					if (ZeileEnthaelt(A_LoopFileFullPath,ZeileEnthaelt))				
						Ges.="`r`n" A_LoopFileFullPath
				}
				FileDirektInhalt:=SubStr(Ges,3)
				Edit1:=ZaehleZeilen(Ges)	; Change372a
				gosub Edit1Festigen
				SucheAbgebrochen:=false

			}
			else
			FuellAnz:=1
			Loop,Parse,FileAuswahlInhalt,`n,`r
			{
				FuellAnz:=10-StrLen(A_Index)

				; if(InStr(A_LoopField,ZeileEnthaelt))
				if (ZeileEnthaelt(A_LoopField,ZeileEnthaelt))				
				{
						; Ges.="`r`n" A_Index "	" A_LoopField
						Ges.="`r`n" A_Index FuellLeerzeichen%FuellAnz%          A_LoopField

				}
				++FuellAnz
			}
			Edit5:=SubStr(Ges,3)
			Edit1:=ZaehleZeilen(Ges)	; Change372a
			gosub Edit1Festigen
			SucheAbgebrochen:=false
			GuiControl, Show,%HwndEdit12%
			GuiControl, Hide,%HwndEdit11%
			if not(FocusedGuiConntrol="Edit12")
			{
				Edit12:=ZeileEnthaelt
				gosub Edit12Festigen
			}

		}
		else if(FileAuswahlArt=InNameKenner)			; wenn sich der Pfad splitten lässt wird nur im Name gesucht sonst in der Zeile
		{
			NameEnthaelt:=SubStr(Edit2,FragezeichenPos+2)
			Ges=
			Loop,Parse,FileAuswahlInhalt,`n,`r
			{
				SplitPath,A_LoopField,DieserName
				; if(InStr(DieserName,NameEnthaelt))
				if (ZeileEnthaelt(DieserName,NameEnthaelt))				
				{
						Ges.="`r`n" A_LoopField
				}
			}
			Edit5:=SubStr(Ges,3)
			Edit1:=ZaehleZeilen(Ges)	; Change372a
			gosub Edit1Festigen
			SucheAbgebrochen:=false
		}
		else if(FileAuswahlArt=MacroAufuehrenKenner)		; AufrufBeispiel: file://%A_AppData%\Zack\Macro\ZeigeLaufwerkeInEdit5.txt MacrDo? 1
		{
			IfExist %FileAuswahlPfad%
			{
				MacroZeilenNummer:=SubStr(Edit2,FragezeichenPos+2)

				if(MacroZeilenNummer="")
				{
					; MsgBox Macro %FileAuswahlPfad% ausführen
					DiesenBefehlsDateiPfad:=FileAuswahlPfad
					gosub DiesenBefehlsDateiPfadAusfuehren
				}
				else if MacroZeilenNummer is Integer	; Macro-Debug-Modus
				{	; Macro-Start bei Zeilenummer
					DieseZeilenummer:=MacroZeilenNummer
					StringSplit,FileAuswahlInhaltZeile,FileAuswahlInhalt,`n,`r
					Loop % FileAuswahlInhaltZeile0-DieseZeilenummer+1
					{
						
						BefehlsMacro:=FileAuswahlInhaltZeile%DieseZeilenummer%
						MsgBox, 262147, Debug Macro, BefehlsZeile:  %DieseZeilenummer%	>%BefehlsMacro%<  ausfuehren?`n`nvon Macro`n%FileAuswahlPfad%
						IfMsgBox,Yes							
							gosub BefehlsVariableAusfuehren
						IfMsgBox Cancel
							break
						++DieseZeilenummer
					}
				}
			}
		}
		else if(FragezeichenPos=0 ) ; and ClipAuswahlArt="")
		{
			Edit5:=FileAuswahlInhalt
			SucheAbgebrochen:=false
		}
		else
			Edit5:=
		gosub Edit5Festigen
		
		Edit8:=GetZeile(Edit5,Edit3)
		gosub Edit8Festigen
		GuiControl,1:, Edit5, %Edit5%  
		LetzerAendererVonEdit5:="Edit2"
		Edit1:=ZaehleZeilen(Edit5)
		gosub Edit1Festigen
		BeschaeftigtAnzeige(-1)
		return
	}
	else If (InStr(Edit2,HTTPKenner) OR InStr(Edit2,HTTPSKenner))			; Webseite
	{
		gosub Edit2Schwarz
		Edit2VorVorTextAnsicht:=Edit2VorTextAnsicht
		Edit2VorTextAnsicht:=Edit2
		StringSplit,UrlBzwSuche,Edit2,%A_Space%
		if(HtmlTextEnthaelt<>UrlBzwSuche1 OR Trim(HtmlText)="")
			HtmlText:=GetHtmlText(UrlBzwSuche1)
		Ges=
		Loop,Parse,HtmlText,`n,`r
		{
			; if(InStr(A_LoopField,UrlBzwSuche2))
			if (ZeileEnthaelt(A_LoopField,UrlBzwSuche2))
			{
				Ges.="`r`n" A_LoopField
			}
		}
		HtmlTextEnthaelt:=UrlBzwSuche1
		Edit5:=SubStr(Ges,3)
		gosub Edit5Festigen
		Edit1:=ZaehleZeilen(Ges)	; Change372a
		gosub Edit1Festigen
		SucheAbgebrochen:=false
	}
	else If (InStr(Edit2,ProtokollKenner))			; Dieses Protokoll wird noch nicht unterstuetzt
	{
		FileDelete,%A_AppData%\Zack\WortVorschlagListe.txt
		gosub Edit2Grau
	}
	else If (false or InStr(Edit2,Backslash) and not PfadFilterAutomatikAus)	; deaktiviert weil es falsch (vermutlich um einen Ordner verschoben) rechnet
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
				Edit2TeilR2:=Edit2Teil0 -1

				if (not PfadFilterAutomatikAus and 	FuerEdit7Last<>FuerEdit7)
				{
					if(NOT InStr(Edit2,"*"))
					{
						MsgBox, 262179, Filter-Vorschlag, soll der Pfad-Filter %FuerEdit7% gesetzt werden?
						IfMsgBox,Yes
						{
							Edit7:=FuerEdit7
							GuiControl,1:, %HwndEdit7%, %Edit7%
							if (Edit2Teil0>2)
							{
								SuFi:=true
								GuiControl,1:, %HwndCheckE0%, 1 
							}
						}
						IfMsgBox,No
							PfadFilterAutomatikAus:=true
					}
				}
				FuerEdit7Last:=FuerEdit7

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
				gosub GetDerefEdit8
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
		GuiControl, Hide,%HwndEdit11%
		GuiControl, Hide,%HwndEdit12%
		E5AusExplorer:=
		gosub ShowExpWin	;	geoeffnete ExplorerFenter fuer die Anzeige besorgen
		Edit5:=E5AusExplorer . GetPaths(Edit2MitDotDotStattDotOverDot(Edit2),SucheAbrechen,"Edit5")
		GuiControl,1:, Edit5, %Edit5%  
		LetzerAendererVonEdit5:="Edit2"
	}
	else
	{
		FileDelete,%A_AppData%\Zack\WortVorschlagListe.txt
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
;}	
ShowExpWin:	;{	
if not NotShowExistIeAndExplorerWin
{
	if(NurCacheFolderNr=-99 or NurCacheFolderNr<>99)
		return
	; ExpAutoSterne=****	; weit oben definiert
	if SkriptDataPath in %ExpAutoContainerListe%
	if(Ue2="")
		Ue2:=3	; Default Suche nach HWND und Namen

	if (Ue2&1)
		HwndSuche:=true
	if (Ue2&2)
		NameSuche:=true
	if (Ue2&4)
		PfadUrlSuche:=true
	Ue1:=Edit2
	; Listet alle offenen Explorer- und IE-Fenster auf:
	for window in ComObjCreate("Shell.Application").Windows
	{
		try
		{
			if (SubStr(window.LocationURL,1,4)="file")
				UrlOderPfad:=window.document.folder.self.path
			else
				UrlOderPfad:=window.LocationURL
			; MsgBox >%UrlOderPfad%<
			if( (InStr(window.HWND,Ue1)and HwndSuche) or (InStr(window.LocationName,Ue1)and NameSuche) or (InStr(UrlOderPfad,Ue1) and PfadUrlSuche))
			{
			ThisWindowLocationName:=window.LocationName
			; Fenster .= "#" window.HWND "	[" window.LocationName "]	->" UrlOderPfad "`n"
				FensterWeglassen:=false
				if SuFi
				{
					FensterWeglassen:=true
					If RegEx
					{
						; if(RegExMatch(ThisWindowLocationName,Edit7) or RegExMatch(UrlOderPfad,Edit7))	; prüfen ob zweckmäßiger
						if(RegExMatch(UrlOderPfad,Edit7))
							FensterWeglassen:=false
					}
					else
					{
						; If(InStr(ThisWindowLocationName,Edit7) or InStr(UrlOderPfad,Edit7) )	; prüfen ob zweckmäßiger
						If(InStr(UrlOderPfad,Edit7))
							FensterWeglassen:=false
					}
				}
				if not FensterWeglassen
				{
					if (UrlOderPfad="")
						WinGetTitle,UrlOderPfad,% "ahk_Id " window.HWND
					Fenster .= ExpAutoSterne UrlOderPfad "		[" ThisWindowLocationName "]" "#" window.HWND  "`n"
				}
			}
		}
	}
	if(SubStr(Fenster,0,1)="`n")
		StringTrimRight,Fenster,Fenster,1
	Sort,Fenster
	; MsgBox % "zu >" Ue1 "< passende Explorer-Fenster`n`n" Fenster
	window:=
	E5AusExplorer:=Fenster
	Fenster:=
}
return
;}	
Edit3:		;	@0263														; PfadNummernEingabe
HwndEdit3:	;{	
BeschaeftigtAnzeige(1)
Gui,1:Submit,NoHide
Edit5UpDown:=Edit3
GuiControl,1:, Edit5UpDown, %Edit5UpDown%  
Edit8:=GetZeile(Edit5,Edit3)
GuiControl,1:, Edit8, %Edit8%  
gosub GetDerefEdit8
BeschaeftigtAnzeige(-1)
return
;}	
; Edit4 ----> @0264
Edit5:		;	@0265														; Anzeige der Pfade
HwndEdit5:	;{	
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
	sort,Edit5,U 
	GuiControl,1:, Edit5, %Edit5%
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
;}	
Edit6:		;	@0266														; Schleifenabbruch Nummern Eingabe
HwndEdit6:	;{	
BeschaeftigtAnzeige(1)
Gui,1:Submit,NoHide
SucheAbrechen:=Edit6
LetzerAendererVonEdit5:="Edit2"
BeschaeftigtAnzeige(-1)
return
;}	
Edit7Farbe:	;{	
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
;}	
Edit7:		;	@0267														; Filter ueber Ges. Pfad (langsam)
HwndEdit7:	;{	
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
			; RegExBeratungsFormularFuer:="Edit7"
			; gosub RegExBeratungsFormular
		}
	}
}
VarNameSkriptDataPath:=OnlyVarChar(NameSkriptDataPath)
LastStaPfaNr%VarNameSkriptDataPath%:=Edit7
LastSuFi%VarNameSkriptDataPath%:=SuFi

BeschaeftigtAnzeige(-1)
return
;}	
Edit8:		;	@0268																; Die EinzelpfadAusgabe (wichtigstes Ausgabefeld)
HwndEdit8:	;{	
BeschaeftigtAnzeige(1)
Gui,1:Submit,NoHide
; gosub Edit8HtmlFuellen
if(Clipboard<>FuehrendeSterneEntfernen(Edit8))
	GuiControl,1:Text,%HwndButton3%,└> &Clip
else
	GuiControl,1:Text,%HwndButton3%,┌> &Clip
if PfadVomInternenExlorerGesetzt
{
	gosub Edit8HtmlFuellen
	BeschaeftigtAnzeige(-1)
	return
}
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
		else If ((Edit8="" and Edit3<>1) or (Edit8=0 and Edit3<>1))		; hinzugekommene Klammer  or (Edit8=0 and Edit3<>1) ToDo: PRuefen 
		{
			ControlGetFocus,FocusedGuiConntrol,ahk_id %GuiWinHwnd%
			if(FocusedGuiConntrol<>"Edit3")
			{
				; SoundBeep
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
; Html:=Edit8
gosub Edit8HtmlFuellen

BeschaeftigtAnzeige(-1)
return
;}	
Edit9:		;	@0269																; Anzeige voN der automatisch  hochschalttenden Abbrruchs-Nummer
HwndEdit9:	;{	
BeschaeftigtAnzeige(1)
Gui,1:Submit,NoHide
BeschaeftigtAnzeige(-1)
return
;}	
Edit10:	; aufgerufen vom ZackZsackOrdner-Gui bei Veraenderung von Edit10 (Zusatz)
HwndEdit10:	;{	aufgerufen vom ZackZsackOrdner-Gui bei Veraenderung von Edit10 (Zusatz)
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
;}	
; < / #########################################  Edits  ##################################################### >
SchreibeSuchverlauf:
if (Edit2<>"" AND Edit2<>Edit2Button1Last)
{
	if(InStr(Edit2,ProtokollKenner))
		FileAppend, %Edit2%%A_Tab%%A_Tab%%Edit7%%A_Tab%%SuFi%%A_Tab%%A_Now%%A_Tab%%Edit1%`r`n,% A_AppData "\Zack\Suchbegriffs.log",utf-16
	else
	{
		FileAppend, %Edit2%%A_Tab%%NameSkriptDataPath%%A_Tab%%Edit7%%A_Tab%%SuFi%%A_Tab%%A_Now%%A_Tab%%Edit1%`r`n,% A_AppData "\Zack\Suchbegriffs.log",utf-16
		; MsgBox %NameSkriptDataPath%
	}
}
Edit2Button1Last:=Edit2
return
; < ##########################################  Buttons  ################################################### >	@0270
Button1:	;	@0271
HwndButton1:	;{	

Critical,On
BeschaeftigtAnzeige(1)
quick:=false
InitiatorButton1:=true
; SuchVerlauf()
FileDelete,%A_AppData%\Zack\WortVorschlagListe.txt
WortVorschlagListe:=
WinClose,WortVorschlaege
if MausGuenstigPositionieren
	MouseMove,134*DpiKorrektur,(Edit5Y0+Edit5Hoehe/2+55)*DpiKorrektur
Gui,1:Submit,NoHide

if Fehlersuche
	MsgBox % Edit2 "`n" Edit2Button1Last
if Edit6 is not Integer
{
	Edit6:=Edit6Default
	gosub Edit6Festigen
}
gosub SchreibeSuchverlauf
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
Edit5:=
Edit8:=
; gosub HwndEdit2
; SoundBeep 600,100
gosub Edit2

IfWinActive,ahk_id %GuiWinHwnd%
{
	ControlGetFocus, FocusedGuiConntrol,A
;	if (FocusedGuiConntrol<>"Edit3")
;	{
;		ControlFocus,Edit3,ahk_id %GuiWinHwnd%
;		ControlSend,Edit3,^a,ahk_id %GuiWinHwnd%
;	}
	FokusEdit2Rechts()
}
/*
Edit8Pur:=FuehrendeSterneEntfernen(Edit8)
Edit8PathInfo:=GetPathInfo(Edit8Pur)
if(Edit8PathInfo.Name<>"")
{
	if (Edit8PathInfo.IsDir)
	{
		ToolTip %  Edit8PathInfo.Name,240,4
	}
	else
	{
		ToolTip % Edit8PathInfo.Name "." Edit8PathInfo.Ext "     " Edit8PathInfo.Size "Byte",240,4
	}
	; ToolTip % VorText "   " Edit8PathInfo.Name "." Edit8PathInfo.Ext "     " Edit8PathInfo.Size "Byte",240,4
	; ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
}
*/
quick:=true
InitiatorButton1:=false
BeschaeftigtAnzeige(-1)
Critical,Off
return
;}	
Button2:	;	@0272
HwndButton2:	;{	
if Button2DoNothing
{
	; SoundBeep
	Button2DoNothing:=false
	return
}

BeschaeftigtAnzeige(1)
if(AutoFavorit>0)
	; gosub SetAutoFavorit
	SetAutoFavorit(Edit8,0,FavoritenDirPath,AutoFavorit)
if(SubStr(doc.getElementById("type").value,1,1)<>"`\" and StrLen(doc.getElementById("type").value)>0)
		doc.getElementById("type").value:="`\" doc.getElementById("type").value

if(SubStr(doc.getElementById("type").value,1,1)="`\" and StrLen(doc.getElementById("type").value)>1)
{
	gosub Edit8NeuerOrdnerMitRueckFrage
}
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
;}	
Button3:	;	@0273
HwndButton3:	;{	
BeschaeftigtAnzeige(1)
Gui,1:Submit,NoHide
if(Clipboard<>FuehrendeSterneEntfernen(Edit8) and Clipboard<>QuellTextNummernWeg(Edit8))
{
	ClipboardVorlaufig:=QuellTextNummernWeg(Edit8)
	if (ClipboardVorlaufig=Edit8)
		Clipboard:=FuehrendeSterneEntfernen(Edit8)
	else
		Clipboard:=ClipboardVorlaufig
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
			if(SubStr(FuerClipEdit5,10,1)=HalbOunten)
			{
				FuerClipEdit5Gekuerzt:=QuellTextNummernWeg(FuerClipEdit5)
				if(StrLen(FuerClipEdit5Gekuerzt) = StrLen(FuerClipEdit5))
				{
					Clipboard:=FuerClipEdit5
				}
				else if(StrLen(FuerClipEdit5Gekuerzt) < StrLen(FuerClipEdit5))
				{
					Clipboard:=FuerClipEdit5Gekuerzt
					BeschaeftigtAnzeige(-1)
					return					
				}
				else
					MsgBox % A_LineNumber "	Unerwarteter SkriptZweig"
			}
			if(InStr(FuerClipEdit5,A_Tab . A_Tab))
			{
				Loop,Parse,FuerClipEdit5,`n,`r
				{
					DiesesFuerClipEdit5 .= FuehrendeSterneEntfernen(A_LoopField) "`r`n"
				}
				Clipboard:=DiesesFuerClipEdit5
				BeschaeftigtAnzeige(-1)
				return 
			}
			else
			{
				StringReplace,FuerClipEdit5,FuerClipEdit5,*,,All
				StringReplace,FuerClipEdit5,FuerClipEdit5,%A_Tab%,\,All
				Clipboard:=FuerClipEdit5
			}
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
;}	
Button4:	;	@0274
HwndButton4:	;{	
if Button4DoNothing
{
	; SoundBeep
	Button4DoNothing:=false
	return
}
BeschaeftigtAnzeige(1)
if(AutoFavorit>0)
	; gosub SetAutoFavorit
	SetAutoFavorit(Edit8,0,FavoritenDirPath,AutoFavorit)
if Fehlersuche
	TrayTip,A_ThisLabel	EinmalKopieDieseDatenkopie, % A_ThisLabel "	" EinmalKopieDieseDatenkopie
if(InStr(Edit2,"SuchbegriffsObenNeu") OR InStr(Edit2,"SuchStringSpeicher") OR InStr(Edit2,"Hilfe\Help_Quell.txt"))
{
	gosub GetAngezeigteSuche
	BeschaeftigtAnzeige(-1)
	return
}
if (A_ThisLabel="SASize" or EinmalKopieDieseDatenkopie="SASize" or SetPathExplorerHwnd)
{
	gosub IfMainGuiMinRestore
	xGutTemp=
	yAtemp=
	WinGetPos,xGutTemp,yGutTemp,bGutTemp,hGutTemp,ahk_id %GuiWinHwnd%
	WinGetPos,xAtemp,yAtemp,bAtemp,hAtemp,ahk_id %SetPathExplorerHwnd%
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
		WinMove,ahk_id %GuiWinHwnd%,,xGutTemp+20*DpiKorrektur,yGutTemp-20*DpiKorrektur  ; ,%ExplWinB%,%ExplWinH%    DpiKorrektur	2.000000

		SetPathExplorerHwnd:=false
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
else if(InStr(Edit8,A_Tab . A_Tab))		; vorhandenes Explorerfenster aktivieren
{
	TabTabPos:=InStr(Edit8,"]#",,0)
	ThisHwnd:=SubStr(Edit8,TabTabPos+2)
	IfWinExist,ahk_id %ThisHwnd%
		WinActivate,ahk_id %ThisHwnd%
	else
		run, % FuehrendeSterneEntfernen(Edit8)
	; MsgBox %ThisHwnd%
	; return
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
		{
			IfExist %Edit10%
				gosub Edit8OeffnenMit
			else
				run, explorer.exe "%Edit8Run%"
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
;}	
Button5:	;	@0275
HwndButton5:	;{	
if(AutoFavorit>0)
	; gosub SetAutoFavorit
	SetAutoFavorit(Edit8,0,FavoritenDirPath,AutoFavorit)
if(SubStr(doc.getElementById("type").value,1,1)<>"`\" and StrLen(doc.getElementById("type").value)>0)
		doc.getElementById("type").value:="`\" doc.getElementById("type").value

if(SubStr(doc.getElementById("type").value,1,1)="`\" and StrLen(doc.getElementById("type").value)>1)
{
	gosub Edit8NeuerOrdnerMitRueckFrage
}	
KopiereOderVerschiebeFilesAndFolders:
BeschaeftigtAnzeige(1)
Edit8Sternlos:=FuehrendeSterneEntfernen(Edit8)
Edit8Sternlos:=GetPathOrLinkedPath(Edit8Sternlos)
if(Not IsDir(Edit8Sternlos))
; if (Not Edit8Info.1.IsDir) ; AND not DateiPfadeWerdenUebergeben)
{
	IfExist %Edit8Sternlos%
	{
		RunOtherAhkScriptOrExe(ExternalToolTipPath,"Ordner als Ziel Erwartet`n`n" Edit8Sternlos)
		return	
	}
	SplitPath,Edit8Sternlos,,,,,Edit8Drive
	IfNotExist %Edit8Drive%
	{
		RunOtherAhkScriptOrExe(ExternalToolTipPath,"Existierende Wurzel im Ziel Erwartet`n`n" Edit8Drive)
		return	
	}
}
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
		NurEinExistierenderPfadGefunden:=false
		EinExistierenderPfadGefunden:=false
		Loop,Parse,Clipboard,`n,`r
		{
			IfExist %A_LoopField%
			{
				if(A_Index=1)
				{
					EinExistierenderPfad:=A_LoopField
					NurEinExistierenderPfadGefunden:=true
				}
				else
				{
					NurEinExistierenderPfadGefunden:=false
					break
				}
				EinExistierenderPfadGefunden:=true
			}
		}
		if not EinExistierenderPfadGefunden
		{
			MsgBox, 262192, Clipboard enthaelt keine Pfade, Diese Aktion benoetigt wenigstens einen existierenden Pfad im Clipboard:`nBitte Datei(en) und oder Ordner  im Explorer markieren und mit  Tastenkombination Control + C ins Clipboard bringen und Vorgang wiederholen.
			BeschaeftigtAnzeige(-1)
			return
		}
		else if NurEinExistierenderPfadGefunden
		{
			ThisEdit8 := FuehrendeSterneEntfernen(Edit8)
			SplitPath,ThisEdit8,,DirThisEdit8
			SplitPath,EinExistierenderPfad,,DirEinExistierenderPfad
			if(DirThisEdit8=DirEinExistierenderPfad)
			{	; Quell und Zielverzeichnis identisch und nur ein Quellpfad wird als Umbenennen interpaetiert.
				Edit10:=ThisEdit8
				gosub Edit10Festigen
				Edit8:=EinExistierenderPfad
				gosub Edit8Festigen
				gosub Edit8Umbenennen
				BeschaeftigtAnzeige(-1)
				return				
			}
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
		{
			Version_Now:= A_Now
			OutNameNoExt:=OutNameNoExt "[" Version_Now "]"
		}
		else
			OutNameNoExt:=OutNameNoExt 
		IfExist,% FuehrendeSterneEntfernen(OutDir "\" OutNameNoExtOrg "." OutExt)
		{
			if (OriginalErhalten="")
			{
				if(ThisEdit8=OutDir) ; if Versioniere
				{
					if(not InStr(OutNameNoExt,"`["))
					{
						Version_Now:= A_Now
						OutNameNoExt:=OutNameNoExt "[" Version_Now "]"
					}
				}
				else
					OutNameNoExt:=OutNameNoExt 
				if(ThisEdit8=OutDir)
				{
					FuncEinstellungen := {DefaultButton: 1, AbfrageFensterOnTop: 1}
					AbfrageFensterAntwort:=AbfrageFenster(FuncEinstellungen,"ZZO:" A_LineNumber	"   Copy to Version / Move to Version","Quellen:`n" DateiPfadAnfang "`n`n-Ordner:`n" ThisEdit8,"Versioniere und behalte Original",">>>>>>>behalte nur Version",">>>>>>>>erzeuge Link-Ziele",">>>>>>>>>>>>>>>>>>>>>Abbruch")
					; MsgBox, 262179, Original, erhalten? (Ziel: %ThisEdit8%)`n`nJa			Original + Version`n`nNein 			nur Version`n`n%DateiPfadAnfang%
				}
				else
				{
					FuncEinstellungen := {DefaultButton: 1, AbfrageFensterOnTop: 1}
					AbfrageFensterAntwort:=AbfrageFenster(FuncEinstellungen,"ZZO:" A_LineNumber	"   Copy / Move","Quellen:`n" DateiPfadAnfang "`n`nZiel-Ordner:`n" ThisEdit8,"Kopieren",">>>>>>>Verschieben",">>>>>>>>erzeuge Link-Ziele",">>>>>>>>>>>>>>>>>>>>>Abbruch")		; geprueft OK I
					; MsgBox, 262179, Original, erhalten? (Ziel: %ThisEdit8%)`n`nJa			Original + Kopie`n`nNein 			nur Kopie`n`n%DateiPfadAnfang%
				}
				if(AbfrageFensterAntwort=0)
				{
					LinkErzeugen:=false
					BeschaeftigtAnzeige(-1)
					return
				}
				if(SubStr(AbfrageFensterAntwort,1,1)=2)	; IfMsgBox,No
				{
					LinkErzeugen:=false
					OriginalErhalten:=false
				}
				else if(SubStr(AbfrageFensterAntwort,1,1)=1)	; IfMsgBox,Yes
				{
					LinkErzeugen:=false
					OriginalErhalten:=true
				}
				else if(SubStr(AbfrageFensterAntwort,1,1)=3)	; Link
				{
					OriginalErhalten:=true
					LinkErzeugen:= true
				}
				else if(SubStr(AbfrageFensterAntwort,1,1)=4)	; IfMsgBox,Cancel
				{
					LinkErzeugen:=false
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
							AntwortButtonNummer:=SubStr(AbfrageFenster(FuncEinstellungen,"ZZO:" A_LineNumber	"   Zielordner existiert nicht","Fuer die Aktion Ordner veschieben von`n" OutDir "\" OutNameNoExtOrg "`nnach`n" ThisEdit8 "\" OutNameNoExt "`nexistiert der Zielordner `n" DieserZielDir "`nnicht`, soll er angelegt werden?","Ordner anlegen","nicht anlegen und weitermachen",">>>>verschieben abbrechen"),1,1)		; Ordner anlegen geprueft OK
							if(AntwortButtonNummer=0)
								continue
							else if(AntwortButtonNummer=1) ; IfMsgBox,Yes
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
							AntwortButtonNummer:=SubStr(AbfrageFenster(FuncEinstellungen,"ZZO:" A_LineNumber	"   Zielordner existiert nicht","Fuer die Aktion Datei Verschieben von`n" OutDir "\" OutNameNoExtOrg "." OutExt "`nnach`n" ThisEdit8 "\" OutNameNoExt "." OutExt "`nexistiert der Zielordner `n" DieserZielDir "`nnicht","Ordner anlegen","nicht anlegen und weitermachen",">>>>verschieben abbrechen"),1,1)		; positiv geprueft II
							if(AntwortButtonNummer=0)
								continue
							else if(AntwortButtonNummer=1) ; IfMsgBox,Yes
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
						SplitPath,DieserZielPfad,,DieserZielDir
						IfNotExist %ThisEdit8%
						{
							; MsgBox % A_LineNumber
							FuncEinstellungen := {DefaultButton: 1, AbfrageFensterOnTop: 1}
							AntwortButtonNummer:=SubStr(AbfrageFenster(FuncEinstellungen,"ZZO:" A_LineNumber	"   Zielordner existiert nicht","Fuer die Aktion Ordner kopieren von`n" OutDir "\" OutNameNoExtOrg "`nnach`n" ThisEdit8 "\" OutNameNoExt "`nexistiert der Zielordner `n" DieserZielDir "`nnicht`, soll er angelegt werden?","Ordner anlegen","nicht anlegen und weitermachen",">>>>kopieren abbrechen"),1,1)		; geprueft Ordner anlegen OK I	nicht anlegen und weitermachen OK
							if(AntwortButtonNummer=0)
								continue
							else if(AntwortButtonNummer=1) ; IfMsgBox,Yes
								FileCreateDirAndAutoFav(ThisEdit8)	;	FileCreateDir, %ThisEdit8%
							else if(AntwortButtonNummer=2) ; IfMsgBox, No
								continue
							else
								break
						}
					if LinkErzeugen
						{
							FileCreateShortcut,%OutDir%\%OutNameNoExtOrg%, %ThisEdit8%\%OutNameNoExt%.lnk ,%OutDir% 
							if ErrorLevel
								MsgBox %A_LineNumber% fehler bei `nFileCreateShortcut`,%OutDir%\%OutNameNoExtOrg%`, %ThisEdit8%\%OutNameNoExt%.lnk`,%OutDir%
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
					IfNotExist %DieserZielDir%
					{
						FuncEinstellungen := {DefaultButton: 1, AbfrageFensterOnTop: 1}
						AntwortButtonNummer:=SubStr(AbfrageFenster(FuncEinstellungen,"ZZO:" A_LineNumber	"   Zielordner existiert nicht","Fuer die Aktion Datei kopieren von`n" OutDir "\" OutNameNoExtOrg "." OutExt "`nnach`n" ThisEdit8 "\" OutNameNoExt "." OutExt "`nexistiert der Zielordner `n" DieserZielDir "`nnicht`, soll er angelegt werden?","Ordner anlegen","nicht anlegen und weitermachen",">>>>kopieren abbrechen"),1,1)		; Ordner anlegen OK II
							if(AntwortButtonNummer=0)
								continue
							else if(AntwortButtonNummer=1) ; IfMsgBox,Yes
								FileCreateDirAndAutoFav(ThisEdit8)	;	FileCreateDir, %ThisEdit8%
							else if(AntwortButtonNummer=2) ; IfMsgBox, No
								continue
							else
								break
					}
										if LinkErzeugen
						{	
							FileCreateShortcut,%OutDir%\%OutNameNoExtOrg%.%OutExt%, %ThisEdit8%\%OutNameNoExt%.%OutExt%.lnk ,%OutDir% 
							if ErrorLevel
							{
								MsgBox %A_LineNumber% Fehler bei FileCreateShortcut`,%OutDir%\%OutNameNoExtOrg%.%OutExt%`, %ThisEdit8%\%OutNameNoExt%.%OutExt%.lnk `,%OutDir% 
							}
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
;}	
; < / #########################################  Buttons  ################################################### >
; < ##########################################  Checkboxen  ############################################### >	@0280
AuAb:	;{													; Autoabbruch nach Default 20 Eingelesenen Cache-Dateien
Gui,1:Submit,NoHide
if AuAb
	 GuiControl,1:, AuAb, %AuAb%							; 	
else
	 GuiControl,1:, AuAb, %AuAb%
return
;}	
SufiAus:	;{	
SuFi:=0
GuiControl,1:, SuFi,0
return
;}	
SufiAn:	;{	
SuFi:=1
GuiControl,1:, SuFi,1	
GuiControl,1:, %wndCheckE0%,1	
GuiControl,1:, %HwndCheckE0%, 1
return
;}	
SuFi:	;{													; Suchmodus NORMAL
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
VarNameSkriptDataPath:=OnlyVarChar(NameSkriptDataPath)
LastStaPfaNr%VarNameSkriptDataPath%:=Edit7
LastSuFi%VarNameSkriptDataPath%:=SuFi
ControlClick,,ahk_id %HwndEdit7%
; gosub F5
return
;}	
RegEx:	;{													; Suchmodus REGEX
Gui,1:Submit,NoHide
if RegEx
{
	GuiControl,1:, RegEx, %RegEx%	
	if SuFi
	{
		RegExBeratungsFormularFuer:="Edit7"
		gosub RegExBeratungsFormular
	}
}	 ; 	
else
{
	GuiControl,1:, RegEx, %RegEx%

}
gosub Edit7Farbe
ControlClick,,ahk_id %HwndEdit7%
return
;}	
SeEn:	;{	Checkbox fuer Button2 bewirkt OK nachsenden bei true Default deqaktiviert
Gui,1:Submit,NoHide
if SeEn
	SendEnterNachSchreibmarkeEinfuegen:=true
else
	SendEnterNachSchreibmarkeEinfuegen:=false
return
SrLi:	; Checkbox fuer Button2 bewirkt Links-Sprung bei true
Gui,1:Submit,NoHide
return
;}	
WoAn:	;{	Checkbox fuer die Suche nur vom Wortanfang
Gui,1:Submit,NoHide
; Auswirkung auf GetPaths()
; SoundBeep 7000,3000
gosub Edit2
return
;}	
BsAn:	;{	Checkbox fuer Button2 bewirkt Backslash anhaengen bei true
Gui,1:Submit,NoHide
if BsAn
	AnSchreibMarkenAusgabeAnhaengen:="\"
else
	AnSchreibMarkenAusgabeAnhaengen:=
return
;}	
OnTop:	;{	Fenster nicht konsequent On Top 
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
;}	
Akt:	;{	Fenster nicht konsequent Aktiv
Gui,1:Submit,NoHide
AktSetzen:
if Akt
	GuiControl,1:, Akt, %Akt%
else
	GuiControl,1:, Akt, %Akt%
return
;}	
; < / #########################################  Checkboxen  ############################################### >
Edit8ZeigeUnterOrdner:	;{	Zeigt temporaer den Ordner und die Unterordner von Edit8 in Edit5 an. Der Rest von Edit5 entfaellt. Ruft dazu auch ZeigeAnstattUnterordnerEdit8 auf.
	BeschaeftigtAnzeige(1)
	Edit8OhneStern := FuehrendeSterneEntfernen(Edit8)
	gosub ZeigeAnstattUnterordnerEdit8
	BeschaeftigtAnzeige(-1)
return
;}	
; < ########################################  Haupt-Menue  ################################################ >	@0290
; Datei	@0291
;{	; Menu | Datei | Reload
NeuStarten:	;{	hier alle Enden Sammeln und noch speichernswertes pruefen...
R:
RunOtherAhkScriptOrExe(ExternalToolTipPath,".		Das Skript wird neu geladen")

; Process, Close, %TastWatchPid%
Reload
return
;}
;}	
;{	; Menu | Datei | Skript-Ordner oeffnen	
SkriptOrdnerOeffnen:	;{	
; Edit2:=FilePatternKenner  A_ScriptDir "\*.*,DFR" A_Space
Edit2:=FilePatternKenner  A_ScriptDir "\*" N_PPHC "*," N_PHL "DFR" N_PHR "`v" InRowKenner A_Space N_PH
; Edit2:=FilePatternKenner  "**,DFR" A_Space InRowKenner A_Space	Funktionert aber FremdProgramme brauchen einen absoluten Pfad, da sie andere Hautverzeichnisse haben
; FilP://C:\Program Files (x86)\ZackZackOrdner\**,DFR In_Row? 
gosub Edit2Festigen
SplitPath,A_ScriptDir,,SkriptFatherDir
SucheAbgebrochen:=false
Edit1:=ZaehleZeilen(Edit5)	; Change372a
gosub Edit1Festigen

sleep 400
ControlSend,Edit2,{End},ahk_id %GuiWinHwnd%
; gosub Down1
FokusEdit2Rechts()
; Edit2LastLast:=FilePatternKenner  SkriptFatherDir "\*.*,DF"
Edit2LastLast:=ZackZackOrdner
; sleep 600
; gosub DirName2Edit2
Edit3LastLastLast:=1
; gosub F2
; run, %A_ScriptDir%
return
;}	
;}	
DataCommonOrdnerOeffnen:
Edit2:=FilePatternKenner A_AppDataCommon "\Zack" "\*" N_PPHC "*," N_PHL "DF" N_PHR "`v" InRowKenner A_Space N_PH
gosub Edit2Festigen
SucheAbgebrochen:=false
Edit1:=ZaehleZeilen(Edit5)	
gosub Edit1Festigen
SplitPath,ZackData,,DataFatherDir
sleep 400
ControlSend,Edit2,{End},ahk_id %GuiWinHwnd%
; gosub Down1
FokusEdit2Rechts()
; Edit2LastLastLast:=FilePatternKenner  DataFatherDir "\*.*,DF"
; Edit2LastLast:=FilePatternKenner  DataFatherDir "\*.*,DF"
Edit2LastLastLast:="Zack"
; Edit2LastLast:="Zack"
Edit3LastLastLast:=1
; run, %ZackData%
return

return
;{	; Menu | Datei | Data-Ordner oeffnen
DataOrdnerOeffnen:	;{			
Edit2:=FilePatternKenner  ZackData "\*" N_PPHC "*," N_PHL "DF" N_PHR "`v" InRowKenner A_Space N_PH
gosub Edit2Festigen
SucheAbgebrochen:=false
Edit1:=ZaehleZeilen(Edit5)	; Change372a
gosub Edit1Festigen
SplitPath,ZackData,,DataFatherDir
sleep 400
ControlSend,Edit2,{End},ahk_id %GuiWinHwnd%
; gosub Down1
FokusEdit2Rechts()
; Edit2LastLastLast:=FilePatternKenner  DataFatherDir "\*.*,DF"
; Edit2LastLast:=FilePatternKenner  DataFatherDir "\*.*,DF"
Edit2LastLastLast:="Zack"
; Edit2LastLast:="Zack"
Edit3LastLastLast:=1
; run, %ZackData%
return
;}	
;}	
;{	; Menu | Datei | Testumgebung erzeugen
TestumgebungErzeugen:	;{	
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
			NeueWurzel:="+" NeueWurzel		; auch Dateien in den Cache
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
		MsgBox, 262144, Bestaetigung, der Container `n%ZackData%\WuCont\Testumgebung`nwurde erfolgreich angelegt und der Start-Pfad`n%NeueWurzel%`nwurde eingelesen und aktiviert.`n`n`nMit`nMenue: Container | ↑↓ Letzten oeffnen`noder [F4]`nkann man wieder den bisherigen aktivieren.`n`n`nEs wurden 6 Ordner mit Farbnamen erstellt.`nDiese enthalten jeweils 6 Ordner mit Eins bis Sechs als Namen.`nDiese wiederum enthalten Dateien in denen steht`, wo sie sich urspruenglich (bei Neuaufbau) befanden.`nMit diesen 42 Ordnern und 6*6*6 Dateien kann ZackZackOrdner getestet werden.`nMit nochmaligem Auswaehlen von Menue: Datei | Testumgenung erzeugen kann leicht alles wieder neu aufgebaut werden.
	}
	else IfExist %ZackData%\WuCont\Testumgebung
		MsgBox, 262144, gratuliere, der Container `n%ZackData%\WuCont\Testumgebung`nwurde erfolgreich angelegt.`n`n jedoch der Start-Pfad`n%ZackData%\Testumgebung`nwurde wurde nicht gefunden.
}
BeschaeftigtAnzeige(-1)
return
;}	
;}	
;{	; Menu | Datei | Schleifen abbrechen
AllesAbbrechen:	;{ alles Abbrechen ist das Endziel, momentan werden einzelne Schleifen beendet.
if not AllesAbbrechen
	AllesAbbrechen:=true
else
	AllesAbbrechen:=false
ToolTip,AllesAbbrechen=%AllesAbbrechen%,A_ScreenWidth/2/DpiKorrektur,A_ScreenHeight/2/DpiKorrektur,19
if not AllesAbbrechen	; und siehe: < auf AllesAbbrechen reagieren >
{
	Sleep 1000
	ToolTip,,,,19
}
return
;}
;}	
;{	; Menu | Datei | Beenden
GuiClose:	;{	
AllesAbbrechen:=true
 Process, Close, %TastWatchPid%
if ErrorLevel
{
	Process, Close, TastWatch.ahk
	Process, Close, ButtonGui
}
doc := ""
Gui,1: Destroy

ExitApp
return
;}	
;}	
; Edit8	@0292
;{	; Menu | Edit8 | Edit8 als Quelltext oeffnen
Edit8QuellTextAnzeigen:	;{	Pfad von Edit8 als Quelltext in Edit5 zeigen
GuiControl ,1: +T35,Edit5
Edit8Sternlos:=GetPathOrLinkedPath(FuehrendeSterneEntfernen(Edit8))
if RegEx
	Edit2:=FileKenner Edit8Sternlos A_Space NrRexKenner A_Space N_PHC
else
	Edit2:=FileKenner Edit8Sternlos "`v" NrRowKenner A_Space N_PHC
gosub Edit2Festigen
SucheAbgebrochen:=false
Edit1:=ZaehleZeilen(Edit5)	; Change372a
gosub Edit1Festigen
; Change370a
FileDelete,%A_AppData%\Zack\WortVorschlagListe.txt
; ControlSend,Edit2,{End},ahk_id %GuiWinHwnd%
OpenWithScitePath:=Edit8Sternlos
GuiControl ,1: -T35,Edit5
return
;}
;}	
;{	; Menu | Edit8 | Edit8 oeffnen
Edit8Oeffnen:	;{	
; MsgBox %A_LineNumber%	>%Edit8%<
if(InStr(Edit8,"`n") or InStr(Edit8,"`r"))
{
ListLines
MsgBox %A_LineNumber%	unerwarteter Variablen-Inhalt sollte kein CR oder LF enthalten	>%Edit8%<
}
run, % FuehrendeSterneEntfernen(Edit8)
if ZackZackOrdnerLogErstellen
	ThreadUeberwachungLog(A_LineNumber-1,A_ThisHotkey,A_ThisLabel,A_ThisFunc,A_ThisMenu,A_ThisMenuItem,A_ThisMenuItemPos)
return
;}	
;}	
;{	; Menu | Edit8 | Edit8 oeffnen mit
Edit8OeffnenMit:	;{	
if (InStr(NameSkriptDataPath,"Start Menu"))
{
}
else
{
	gosub F4
	return
}
IfExist %Edit10%
{
	Edit8Sternlos:=FuehrendeSterneEntfernen(Edit8)
	Run,  "%Edit8Sternlos%"    "%Edit10%"
	gosub F4
	Edit7:=Edit7VorLetzterContainer%ContainerNummernAnzeige%
	gosub Edit7Festigen
	Edit2:=Edit2VorLetzterContainer%ContainerNummernAnzeige%
	gosub Edit2Festigen
	return
}
if(Edit8OeffnenMitSpeicher="")
{
	gosub Edit8OeffnenSpeicher
}
; notepad "%E8%"
StringReplace,OeffnenMitString,Edit8OeffnenMitSpeicher,`%E8`%,% FuehrendeSterneEntfernen(Edit8),All
if(Edit8OeffnenMitSpeicher="")
	return
if OeffnenMitKontrollFrage
{
	; MsgBox, 262662, So Ausführen?, Run %OeffnenMitString%
	; MsgBox, 258, So Ausführen?, Run %OeffnenMitString%`n`nnochmals nachfragen?

	FuncEinstellungen := {DefaultButton: 1, EditReadOnly: 1, DisableMainWindow: 1}
	DieseAntwort:=AbfrageFenster(FuncEinstellungen, "So Ausführen?",A_LineNumber "`nRun " OeffnenMitString, "OK, mit Nachfrage","OK ohne Nahfrage",">>>>>>>>>>>>>>>>>abbrechen")
; {
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
; MsgBox % DieseAntwort
	if (DieseAntwort=0)
		return
	else if (SubStr(DieseAntwort,1,1)="1")
	{
		Run, %OeffnenMitString%
	}
	else if (SubStr(DieseAntwort,1,1)="2")
	{
		
		OeffnenMitKontrollFrage:=false
	}
	else
		return
}
if not OeffnenMitKontrollFrage
	Run, %OeffnenMitString%
return
;}	
;}		
;{	; Menu | Edit8 | Edit8 --> oeffnen mit Speicher
; siehe Label Edit8ToOeffnenSpeicher
;}	
;{	; Menu | Edit8 | neuer Ordner
Edit8NeuerOrdnerMitRueckFrage:
	if(SubStr(doc.getElementById("type").value,1,1)<>"`\" and StrLen(doc.getElementById("type").value)>0)
		doc.getElementById("type").value:="`\" doc.getElementById("type").value
NeuerOrdnerRueckFrage:=true
Edit8NeuerOrdner:	;{	
	Edit8OhneStern := FuehrendeSterneEntfernen(Edit8)
	if(SubStr(doc.getElementById("type").value,1,1)="`\" and StrLen(doc.getElementById("type").value)>1)
	{
		Edit8:=Edit8OhneStern.=doc.getElementById("type").value
 		gosub Edit8Festigen
		Edit10:=
		gosub Edit10Festigen
	}

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
			NeuerOrdnerRueckFrage:=false
			return
		}
		if NeuerOrdnerRueckFrage
		{
			MsgBox, 262180, Ordner, der Ordner `n	%Edit8OhneStern% `nexistiert nicht`, soll er angelegt werden
			IfMsgBox,Yes
			{
				FileCreateDirAndAutoFav(Edit8OhneStern)
				Edit8:=Edit8OhneStern
				gosub Edit8Festigen
			}
		}
		else
		{
			FileCreateDirAndAutoFav(Edit8OhneStern)
			if ErrorLevel
			{
				MsgBox %A_LineNumber%	Fehler beim neu Anlegen des Ordners %Edit8OhneStern%
				NeuerOrdnerRueckFrage:=false
			}
			else
			{
				Edit8:=Edit8OhneStern
				gosub Edit8Festigen
			}
			return
		}
	}
	else if (Edit10="" AND doc.getElementById("type").value ="")
	{
		MsgBox, 262176, Neuer Ordner Name , bitte den neuen Ordnername in Edit8 rechts oder  im Untersten Feld eingeben und Vorgang wiederholen.
		NeuerOrdnerRueckFrage:=false
		return
	}
	else if (SubStr(Edit10,1,13)="Start-Pfade: ")
	{
		Edit10:=
		gosub Edit10Festigen
		MsgBox, 262176, Neuer Ordner Name , bitte den neuen Ordnername in Edit8 rechts oder im Untersten Feld eingeben und Vorgang wiederholen.
		NeuerOrdnerRueckFrage:=false
		return
	}
	else if (Edit10="Zusatz")
	{
		MsgBox, 262436, Neuer Ordner Name , bitte den neuen Ordnername in Edit8 rechts oder im Untersten Feld eingeben und Vorgang wiederholen.`nOder soll der neue Ordner wirklich Zusatz lauten?
		IfMsgBox,No
		{
			NeuerOrdnerRueckFrage:=false
			return
		}
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
	NeuerOrdnerRueckFrage:=false
return
;}	
;}	
;{	; Menu | Edit8 | zeige Unter-DrueberOrdner
Edit8ZeigeVorfahrenUndUnterordner:	;{	
	BeschaeftigtAnzeige(1)
	; SuchVerlauf()
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
;}	
;}	
;{	; Menu | Edit8 | Explorer
Edit8Explorer:	;{	ubergibt Edit8 an den Explorer
	Edit8OhneStern := FuehrendeSterneEntfernen(Edit8)
	;}	
; ohnr Return
VarEdit8OhneSternGesetztExplorer:	;{	
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
;}	
;}	
;{	; Menu | Edit8 | &Explorer Select (GetFather)
Edit8ExplorerSelect:	;{	ubergibt Edit8 an den Explorer mit der Aufforderung Edit8 zu Selektieren bzw. markieren.
	Edit8OhneStern := FuehrendeSterneEntfernen(Edit8)
	;}	
; ohne Return
VarEdit8OhneSternGesetztExplorerSelect:	;{	
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
;}	
;}	
;{	; Menu | Edit8 | Zeige Inhalte	im internen Explorer
Edit8ExplorerEingebunden:	;{	ruft RLShift auf
gosub RLShift
return
;}	
;}	
;{	; Menu | Edit8 | Zeige Inhalte nur Text in Edit5
; siehe Label Edit82Edit2
;}	
;{	; Menu | Edit8 | DirName -> Edit2
DirName2Edit2:	;{	
; SuchVerlauf()
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
;}	
;}	
;{	; Menu | Edit8 | FatherName -> Edit2
; siehe Label FatherName2Edit2
;}	
;{	; Menu | Edit8 | umbenennen
Edit8Umbenennen:	;{	benennt den Ordner auf den Edit8 zeigt um in die Auswertung von Edit10
		Edit8OhneStern := FuehrendeSterneEntfernen(Edit8)
		;}	
; ohne Return
Edit8SternlosUmbenennen:	;{	
		if (substr(Edit8OhneStern,-3)=".lnk")
		{
			FileGetShortcut, %Edit8OhneStern% ,Edit8OhneStern
		}
		IfExist % Edit8OhneStern
		{
			Gui,1:Submit,NoHide
			If (trim(Edit10)="" OR Edit8OhneStern=Edit10 OR InStr(Edit10,A_Tab) OR InStr(Edit10,"?") OR InStr(Edit10,"*") OR InStr(Edit10,"<")  OR InStr(Edit10,">")  OR InStr(Edit10,A_Space A_Space) OR Edit10="Zusatz" or Edit10="" or SubStr(Edit10,1,13)="Start-Pfade: ")
			{
				Edit10:=
				gosub Edit10Festigen
				InputBox,FuerEdit10,Umbenenen,neuer Name,,,,,,,,% Edit8OhneStern
				if ErrorLevel
					return
				GuiControl,1:, %HwndEdit10%, %Edit10%
				Edit10:=FuerEdit10
				gosub Edit10Festigen
			}
			If(Not InStr(Edit10,"`\"))
			{
				SplitPath,% Edit8OhneStern,,Edit1Dir
				Edit10:= Edit1Dir "\" Edit10
				GuiControl,1:, %HwndEdit10%, %Edit10%
			}
			MsgBox, 36, Umbenennen, Bitte Bestaetigen:`nBenenne`n		%Edit8OhneStern%`num in `n		%Edit10%`n
			IfMsgBox,Yes
			{
				if InStr(FileExist(Edit8OhneStern), "D")
				{
					FileMoveDir,% Edit8OhneStern,%Edit10%,R
					if ErrorLevel
						MsgBox, 262192, Fehler beim Umbenennen, konnte 	%Edit8OhneStern%`nnicht in `n		%Edit10%`numbenennen
				}
				else
				{
					FileMove, %Edit8OhneStern%, %Edit10% 
					; FileMoveDir,% Edit8OhneStern,%Edit10%,R
					if ErrorLevel
						MsgBox, 262192, Fehler beim Umbenennen, konnte 	%Edit8OhneStern%`nnicht in `n		%Edit10%`numbenennen
				}
			}
		}
		else
			MsgBox, 262192, Fehler beim Umbenennen, 		%Edit8OhneStern%`nexistiert nicht (mehr).`n`nAbbruch!
return
;}	
;}	
;{	; Menu | Edit8 | Diashow
Diashow:	;{	
Edit8Sternlos:=FuehrendeSterneEntfernen(Edit8)
Run ,rundll32.exe shimgvw.dll`,ImageView_Fullscreen %Edit8Sternlos%
; Run,rundll32.exe shimgvw.dll`,ImageView_Fullscreen C:\Users\Gerd\Pictures\Camera Roll
MsgBox, 262144, Diashow, Esc`nzum Beenden der gleich startenden Diashow.,4
ControlSend,,{F11},ahk_class Photo_Lightweight_Viewer
sleep 1000
WinWaitClose ahk_class Photo_Slideshow_FrameWindow
sleep 600
WinClose ,ahk_class Photo_Lightweight_Viewer
return
;}	
;}	
DiashowImIe:
	Edit3Merker:=Edit3
	gosub SchreibeSuchverlauf
	Edit8Sternlos:=FuehrendeSterneEntfernen(Edit8)
	BildHoeehe:=round(A_ScreenHeight-14*DpiKorrektur) ;  fuer horrizontale Scroll-Leiste		; round(A_ScreenHeight-50*DpiKorrektur) wenn nicht F11 verwendet wird ; mit den -14*DpiKorrektur geht man nahe ans Henne Ei Problem: nimmt man weniger weg erschein die horrizontale Scroll-Leiste, nimmt man mehr weg bleibt ne Luecke. D. h. optimal geht so nicht
	Edit2:="FilP://" Edit8Sternlos  "\*ØØ¯⁞¯ØØ*,Ø¯DFR¯ØIn_Row? Ø¯⁞¯Ø`vHtmPicView? " BildHoeehe "`vHtmDiaShow?"
	gosub Edit2Festigen
	gosub SchreibeSuchverlauf
	gosub SelfMin
	if(IsObject(AnE5))
	{
		try
			AnE5.NotBusy()
	}
	gosub SA
	WinWaitActive,ahk_id %GuiWinHwnd%,,2
	Sleep 300
	gosub SuchverlaufAnzeigen
	Sleep 1000
	Edit3:=2
	gosub Edit3Festigen
	Sleep 500
	gosub GetAngezeigteSuche
	Edit3:=Edit3Merker
	gosub Edit3Festigen
return
;{	; Menu | Edit8 | DateiSuche
DateiSucheAusgehendVonEdit8:	;{	
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
;}	
; ohne Return
FuerDateiSucheAusgehendVonEdit5:	;{	
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
if(A_ThisLabel="FuerDateiSucheAusgehendVonEdit5")
	return
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
;}	
;}	
; Strukturen
;{	; Menu | Strukturen | Struktur-Vorlage-Assistent
StrukturVorlageAssistent:	;{	HilfsText fuer Strukturvorlagen	
IfNotExist %StrukturenOrdnerPfad%
{
	FileCreateDir %StrukturenOrdnerPfad%
	if ErrorLevel
	{
		MsgBox, %A_LineNumber% Konnte %StrukturenOrdnerPfad% nicht anlegen.`n`nAbbruch
		return 
	}
}
Run, Explorer.exe "%StrukturenOrdnerPfad%"
if ErrorLevel
{
	MsgBox, %A_LineNumber% Konnte %StrukturenOrdnerPfad% nicht oeffnen.`n`nAbbruch
	return 
}
StrukturScriptHilfe=
(
Eine Struktur ist ohne zusaetzliches Skript eine 1 : 1 Ordner-Vorlage`,
die spaeter unter Edit8 (mit den enthaltenen Unterordnern und Dateien`,)`neingefuegt werden kann.

Jeder Unter-Ordner von `n%StrukturenOrdnerPfad% `nrepraesentiert eine solche  1 : 1 Ordner-Vorlage.
Sie koennen also im soeben aufgegangenen Explorer-Fenster einen neuen Ordner anlegen und darunter die Wunsch-Struktur haengen.
Oder nicht mehr benoetigte Ordner-Vorlagen (also die Ordner im soeben aufgegangenen Explorer)  loeschen oder als Sicheung wegverschieben.

Hinweise:
wenn der Vorlage-Ordner-Name mit 1_ beginnt`,`ndann wird er auch an Position 1 angezeigt.
Daraus ergibt sich`, dass jede Ziffer vor dem _ Unterstrich nur einmal
und das ohne Luecken bei 1 anfangend von ZZO unterstuetzt wird!

Mit Skript ist sind fast beliebige Ziel-Strukturen moeglich:
ZZO erwartet das StrukturErzeugungsSkript wie folgt:
Strichpunkt A_Tab GewuenschterInhalZumVarNameVonZzo A_Tab Kommentar <--Die Syntax ist in den ersten 9 Zeilen einzuhalten.
Es muss gleichnamig gefolgt von .ahk wie der Quell-Struktur-Ordner lauten und sich im Skriptverzeichnis befinden.
z.B.: zum Quell-Struktur-Ordner
%A_scriptdir%\Strukturen\Hallo Welt
wird das StrukturErzeugungsScript
%A_scriptdir%\Hallo Welt.ahk
erwartet, aber nur wenn von einer 1:1 Kopie abgewichen werden soll.

  < Beispiel eines Skriptbeginns                                               >
1 ;	QuellPfad	Diese Variable wird von ZZO  als 1. Uebrgabeparaeter erwartet
2 ;	ZielPfad	Diese als 2.
3 ;	A_ScriptFullPath	die als 3.
4 
5 		; Die komplett leere Zeile direkt drueber als Abschluss ist zwingend.
6 QuellPfad=`%1`%	; die Variablen-Namen sind frei und haetten auch MusterPfad
7 ZielPfad=`%2`%	; bzw. KopiePfad lauten koennen.
8 
; ...
# FileCopyDir,`%QuellPfad`%,`%ZielPfad`%
^Zeilennummer, die ist nicht einzugeben!
  ^erste Skript-Spalte
   ^Tabulator hier in den ersten 3 Zeilen
	^VariablenNamen von ZZO (hier in den ersten 3 Zeilen)
	    ^Tabulator (hier in den ersten 3 Zeilen)
		^Beliebiger optionaler Kommentar (hier in den ersten 3 Zeilen)
  </ Beispiel eines Skriptbeginns                                              >
)
; MsgBox, 262144, Neue Struktur anlegen, Eine Struktur ist ohne zusaetzliches Skript eine 1 : 1 Ordner-Vorlage`,`ndie spaeter unter Edit8 (mit den enthaltenen Unterordnern und Dateien`,)`neingefuegt werden kann.`n`nJeder Unter-Ordner von `n%StrukturenOrdnerPfad% `nrepraesentiert eine solche  1 : 1 Ordner-Vorlage.`nSie koennen also im soeben aufgegangenen Explorer-Fenster einen neuen Ordner anlegen und darunter die Wunsch-Struktur haengen.`n`nHinweise:`n wenn der Vorlage-Ordner-Name mit 1_ beginnt`,`ndann wird er auch an Position 1 angezeigt.`nDaraus ergibt sich`, dass jede Ziffer vor dem _ Unterstrich nur einmal`nund das ohne Luecken bei 1 anfangend von ZZO unterstuetzt wird!`n`n Mit Skript ist sind fast beliebige Ziel-Strukturen moeglich:`n%StrukturScriptHilfe%
WinWaitActive,Strukturen,,2
sleep 500
FuncEinstellungen := {DefaultButton: "Last", EditReadOnly: 0}
AbfrageFensterAntwort:=AbfrageFenster(FuncEinstellungen,"Struktur Assistent",StrukturScriptHilfe,"schließen") ; ,"BeispielSkript")
; MsgBox % AbfrageFensterAntwort
return
;}
;}	
;{	; Menu | Strukturen | Struktur bei Edit8 erzeugen
ManuelleStrukturauswahl:	;{	Struktur	;}
;}	
;{	; Menu | Strukturen | Strukturen anzeigen
StukturenAnzeigen:	;{	Vorlage-Strukturen-anzeiegen
IfNotExist %StrukturenOrdnerPfad%
	FileCreateDir,%StrukturenOrdnerPfad%
; MacroStartListe=
StrukturListe=
Loop, 7
{
StrukturPlatz%A_Index%:=
StrukturName%A_Index%:=
}
; MacroNameListe=
StrukturNameListe=
breakbreak:=false
StrukturPlatzIndex:=1
Loop  999
{
	; IfExist, %A_AppData%\Zack\Macro\%A_Index%_*.txt
	StrukturPlatz%StrukturPlatzIndex%:=false
	Loop,Files,%StrukturenOrdnerPfad%\?_*,DF
	{
		StrukturPlatz%StrukturPlatzIndex%:=A_LoopFileFullPath
		StrukturName%StrukturPlatzIndex%:=A_LoopFileName
		StrukturNameListe.=A_LoopFileName "`r`n"
		; MsgBox % StrukturPlatzIndex "	" StrukturNameListe "	" A_LoopFileName
		++StrukturPlatzIndex
		if(StrukturPlatzIndex>6)
			break
	}
	if(StrukturPlatzIndex>7)
		break
	if (StrukturPlatz%StrukturPlatzIndex%="")
		break
}
; --StrukturPlatzIndex
--StrukturPlatzIndex
Loop,Files,%StrukturenOrdnerPfad%\*,DF
{
	if(Substr(A_LoopFileName,2,1)="_")
	{
		Char1LoopFileName:=Substr(A_LoopFileName,1,1)
		if Char1LoopFileName is Integer
			continue
	}
	if(StrukturPlatzIndex>6)
		break
	++StrukturPlatzIndex
	StrukturPlatz%StrukturPlatzIndex%:=A_LoopFileFullPath
	StrukturName%StrukturPlatzIndex%:=A_LoopFileName
	StrukturNameListe.=StrukturPlatzIndex "_" A_LoopFileName "`r`n"
	; MsgBox % StrukturPlatzIndex "	" StrukturNameListe "	" A_Index
}
if (StrukturPlatzIndex<1)
{
	MsgBox, 262208, Macro, Es wurden keine Strukturen gefunden.`n`nEmpfehlung: Legen Sie unter %A_ScriptDir%\Strukturen Vorlage-Ordner an.
	return
}
FuncEinstellungen:=
FuncEinstellungen:={}
if(A_ThisLabel="StukturenAnzeigen")
{
	FuncEinstellungen:={DefaultButton: "Last"}
}
Loop % StrukturPlatzIndex
{
	ButtonNr:="ButtonText" A_Index
	StrukturName:="S" A_Index
	FuncEinstellungen.Insert(ButtonNr,StrukturName)
}
++StrukturPlatzIndex
	StrukturOrdner:="ButtonText" StrukturPlatzIndex
	StrukturOrdnerIndex:=StrukturPlatzIndex
	StrukturName:=">>>>>(weitere) Strukturen vom Dateisystem"
	FuncEinstellungen.Insert(StrukturOrdner,StrukturName)
++StrukturPlatzIndex
	ButtonNr:="ButtonText" StrukturPlatzIndex
	StrukturName:=">>>>>>>>>>abbrechen"
	FuncEinstellungen.Insert(ButtonNr,StrukturName)
++StrukturPlatzIndex
	ButtonNr:="DisableMainWindow" 
	StrukturName:=1
	FuncEinstellungen.Insert(ButtonNr,StrukturName)
++StrukturPlatzIndex
	ButtonNr:="AbfrageFensterOnTop" 
	StrukturName:=1
	FuncEinstellungen.Insert(ButtonNr,StrukturName)
AbfrageFensterAntwort:=AbfrageFenster(FuncEinstellungen,"Struktur anlegen","Welche Stuktur `n`n"StrukturNameListe "`n`nsoll unter`n`n"FuehrendeSterneEntfernen(Edit8) "`n`nangelegt werden?")
if (AbfrageFensterAntwort=0)
	return
AbfrageFensterAntwortButonNr:=SubStr(AbfrageFensterAntwort,1,1)
; AbfrageFensterAntwortButonNr:=7
if(AbfrageFensterAntwortButonNr<StrukturOrdnerIndex)
	DieserStrukturenPath:=StrukturPlatz%AbfrageFensterAntwortButonNr%
else if (AbfrageFensterAntwortButonNr=StrukturOrdnerIndex)
{
	FileSelectFolder,DieserStrukturenPath,*%StrukturenOrdnerPfad%,,Struktur/MusterOrdner auswaehlen
	; FileSelectFile,DiesenBefehlsDateiPfad,,%A_AppData%\Zack\Macro,bitte Macro auswaehlen,Macros (*.txt;*.*)
	if ErrorLevel
		return
	If (DieserStrukturenPath="")
		return
}
else
	return
gosub mErzeugeStruktur
if(SubStr(Struktur%DieseStrukturenPathNr%Name,2,2)="__")	;	2. und 3. Zeichen des Vorlagestruktur-Ordners sind Unterstriche. d.h. Der oberste Ordner selbst soll nicht mit erzeugt werden. dies wurde er aber schon, deshalb wird er wieder entfernt, sofern im Ordner in den eingehaengt wurde keine Doppelten entstuenden.
{
	Edit8:=Edit8Sternlos "\" Struktur%DieseStrukturenPathNr%Name
	gosub Edit8Festigen
	gosub InhaltzumVaterOrdnerLoeschenOhneKontrollfrage
}
return
;}
;}	
InhaltzumVaterOrdnerLoeschenOhneKontrollfrage:	;{	Kopiere OrdnerInnhalte vor dem Loeschen zum Vater ohne KontrollFrage	;}
;{	; Menu | Strukturen | Inhalte zum Vater-Ordner vor loeschen
mInhaltzumVaterOrdnerLoeschen:	;{	Kopiere OrdnerInnhalte vor dem Loeschen zum Vater
BeschaeftigtAnzeige(1)
Edit8Sternlos:=FuehrendeSterneEntfernen(Edit8)
if(A_ThisLabel=mInhaltzumVaterOrdnerLoeschen)
{
	MsgBox, 262180, Ordner loeschen Inhalte behalten, Soll der Ordner`n`n%Edit8Sternlos%`n`ngeloescht werden und die Inhalte an den Vater gehaengt werden?
	IfMsgBox,No
	{
		BeschaeftigtAnzeige(-1)
		return	
	}
}
NichtVerschobenAnz:=InhaltzumVaterOrdnerLoeschen(Edit8Sternlos)
if NichtVerschobenAnz
	MsgBox, 262192, Problem beim Verschieben, %NichtVerschobenAnz% Elemente konnten nicht verschoben werden!
BeschaeftigtAnzeige(-1)
return
;}
InhaltzumVaterOrdnerLoeschen(ZuLoeschenderOrdner)	;{	Kopiere OrdnerInnhalte vor dem Loeschen zum Vater
{
	IfNotExist %ZuLoeschenderOrdner%
		return 0
	SplitPath,ZuLoeschenderOrdner,,ZuLoeschenderOrdnerDir
	NichtVerschobenAnzahl:=VerschiebeDateienUndOrdner(ZuLoeschenderOrdner "\*.*", ZuLoeschenderOrdnerDir)
	if not NichtVerschobenAnzahl
	{
		FileRemoveDir,%ZuLoeschenderOrdner%
		if ErrorLevel
			MsgBox, %A_LineNumber% Fehlermeldung
	}
	return NichtVerschobenAnzahl
}
;}
;}
; Container	@0293
;{	; Menu |   ↑
ContainerPrev:	;{	
gosub ContainerUebersichtZeigen
sleep 100
--AktContainerNr
if(AktContainerNr<1)
	AktContainerNr:=ContainerAnzahl
Edit3:=AktContainerNr
gosub Edit3Festigen
Sleep 20
gosub WurzelContainerOeffnen
VarNameSkriptDataPath:=OnlyVarChar(NameSkriptDataPath)
if(LastSuFi%VarNameSkriptDataPath%<>"")
{
	SuFi:=LastSuFi%VarNameSkriptDataPath%
	gosub SuFiFestigen
}
Edit7:=LastStaPfaNr%VarNameSkriptDataPath%
gosub Edit7Festigen
return
;}	
;{	; Menu | Container | ContainerSchnellWahl
ContainerSchnellWahl:	;{	
Caller:="ContainerSchnellWahl"
gosub ContainerUebersichtZeigen
sleep 10
FuerEdit3:=SchnellWahl(Caller,"Container-Schnell-Wahl",Edit5)
if(FuerEdit3=0)
	return
Edit3:=FuerEdit3
gosub Edit3Festigen
gosub Edit3
sleep 10
gosub WurzelContainerOeffnen
return
;}	
;}	
;{	; Menu | Container | (Angezeigten) oeffnen
WurzelContainerOeffnen:	;{	
Gui,1: Submit,NoHide
ThisEingangsEdit8:=FuehrendeSterneEntfernen(Edit8)
Gui,1: Submit,NoHide
OnTopMerker:=OnTop
gosub ContainerUebersichtZeigen
OnTop:=OnTopMerker
gosub OnTopFestigen
Gui,1: Submit,NoHide
; WurzelContainerLen:=StrLen(WurzelContainer)
IfExist %ThisEingangsEdit8%
	ThisEingangsEdit8Exist:=true		; wird benoetigt damit ein geloeschter Cotainer der noch in Edit5 steht nicht fuer falsche Programmzweige sorgt.
	; z.B. C:\ProgramData\Zack\WuCont\VeralteterContainerName
if(InStr(Edit5,ThisEingangsEdit8) and InStr(ThisEingangsEdit8,WurzelContainer) and (StrLen(ThisEingangsEdit8)>StrLen(WurzelContainer)) and ThisEingangsEdit8Exist)
{
	if(substr(Edit8,-3,4)=".lnk")
	{
		FileGetShortcut, % ThisEingangsEdit8 , SkriptDataPath
		gosub KontainerAnzeigen
	}
	else IfExist % FuehrendeSterneEntfernen(Edit8)
	{
		LetzterSkriptDataPathI:=SkriptDataPath
		SkriptDataPath:=Edit8
		if (InStr(SkriptDataPath,"!Fav")) ; ############################################# weg
			MsgBox % A_LineNumber "	" SkriptDataPath
		; AktContainerNr:=Edit3
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
			{
				LetzterSkriptDataPathI:=SkriptDataPath
				SkriptDataPath:=Edit8
				if (InStr(SkriptDataPath,"!Fav")) ; ############################################# weg
					MsgBox % A_LineNumber "	"  SkriptDataPath

			}
			gosub KontainerAnzeigen
			sleep 20
			gosub Button1OhneMausPos
			Sleep 20
			; AktContainerNr:=Edit3

			Edit3:=1
			gosub Edit3Festigen
		}
	}
}
sleep 50
gosub Button1OhneMausPos
gosub StartPfadAenderung
gosub ResetAllNocontainer
VarNameSkriptDataPath:=OnlyVarChar(NameSkriptDataPath)
if(LastSuFi%VarNameSkriptDataPath%<>"")
{
	SuFi:=LastSuFi%VarNameSkriptDataPath%
	gosub SuFiFestigen
}
Edit7:=LastStaPfaNr%VarNameSkriptDataPath%
gosub Edit7Festigen
gosub F5
return
;}	
;}	
;{	; Menu | Container | Letzten oeffnen
LetzterContainer:	;{	
VorContainerNummernAnzeige:=ContainerNummernAnzeige
Edit8VorLetzterContainer%ContainerNummernAnzeige%:=Edit8
Edit2VorLetzterContainer%ContainerNummernAnzeige%:=Edit2
Edit7VorLetzterContainer%ContainerNummernAnzeige%:=Edit7
TempLetzterSkriptDataPathI:=SkriptDataPath
SkriptDataPath:=LetzterSkriptDataPathI
LetzterSkriptDataPathI:=TempLetzterSkriptDataPathI
gosub KontainerAnzeigen
gosub ResetAllNocontainer
VarNameSkriptDataPath:=OnlyVarChar(NameSkriptDataPath)
if (InStr(NameSkriptDataPath,"Start Menu"))
{
	SplitPath,Edit8VorLetzterContainer%VorContainerNummernAnzeige%,,,Edit2
	gosub Edit2Festigen
	Edit10:=FuehrendeSterneEntfernen(Edit8VorLetzterContainer%VorContainerNummernAnzeige%)
	gosub Edit10Festigen
}
if(LastSuFi%VarNameSkriptDataPath%<>"")
{
	SuFi:=LastSuFi%VarNameSkriptDataPath%
	gosub SuFiFestigen
}

Edit7:=LastStaPfaNr%VarNameSkriptDataPath%
gosub Edit7Festigen

gosub StartPfadAenderung
gosub F5
return
;}	
;}	
;{	; Menu | Container | Letzten oeffnen
LetzterContainerStartMenu:	;{	

VorContainerNummernAnzeige:=ContainerNummernAnzeige
Edit8VorLetzterContainer%ContainerNummernAnzeige%:=Edit8
Edit2VorLetzterContainer%ContainerNummernAnzeige%:=Edit2
Edit7VorLetzterContainer%ContainerNummernAnzeige%:=Edit7
if (InStr(NameSkriptDataPath,"Start Menu"))
{
	TempLetzterSkriptDataPathI:=SkriptDataPath
	SkriptDataPath:=LetzterSkriptDataPathI
	LetzterSkriptDataPathI:=TempLetzterSkriptDataPathI
}
else
{
	; LetzterSkriptDataPathI:=WurzelContainer "\Start Menu"
	; LetzterSkriptDataPath:=WurzelContainer "\Start Menu"
	TempLetzterSkriptDataPathI:=SkriptDataPath
	SkriptDataPath:=WurzelContainer "\Start Menu"
	LetzterSkriptDataPathI:=TempLetzterSkriptDataPathI
}

gosub KontainerAnzeigen
gosub ResetAllNocontainer
VarNameSkriptDataPath:=OnlyVarChar(NameSkriptDataPath)
if (InStr(NameSkriptDataPath,"Start Menu"))
{
	SplitPath,Edit8VorLetzterContainer%VorContainerNummernAnzeige%,,,Edit2
	gosub Edit2Festigen
	Edit10:=FuehrendeSterneEntfernen(Edit8VorLetzterContainer%VorContainerNummernAnzeige%)
	gosub Edit10Festigen
}
if(LastSuFi%VarNameSkriptDataPath%<>"")
{
	SuFi:=LastSuFi%VarNameSkriptDataPath%
	gosub SuFiFestigen
}

Edit7:=LastStaPfaNr%VarNameSkriptDataPath%
gosub Edit7Festigen

gosub StartPfadAenderung
gosub F5
return
;}	
;}	
;{	; Menu | Container | anlegen...
ContainerAnlegen:	;{	
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
gosub ContainerUebersichtZeigen
gosub KontainerAnzeigen
return
;}	
;}	
;{	; Menu | Container | loeschen...
ContainerLoeschen:	;{	
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
gosub ContainerUebersichtZeigen
gosub KontainerAnzeigen
BeschaeftigtAnzeige(-1)
return
;}	
;}	
;{	; Menu | Container | alle loeschen
DelCache:	;{	
MsgBox, 262436, Cache Loeschen, wollen Sie wirklich`n	%WurzelContainer%`nloeschen?
IfMsgBox Yes
{
	; EnvGet,ComSpec,ComSpec
	MsgBox Das Skript endet hier um alle Recourcen frei zu geben. 
	Run, %ComSpec% /c "RMDIR /S """%WurzelContainer%""""
	goto GuiClose
}
return
;}	
;}	
;{	; Menu | Container | Übersicht anzeigen
ContainerUebersichtZeigen:	;{	Zeigt ContainerUebersicht an
gosub NormalAnzeige
AlleSkriptDataPath:=
ContainerAnzahl:=0
WortVorschlagListe=
	Loop,Files,%WurzelContainer%\*, D F
	{
		; if(A_LoopFileExt="lnk")
		; ContainerAnzahl:=A_Index
		AlleSkriptDataPath:=AlleSkriptDataPath "`n" A_LoopFileLongPath
		Edit5:=AlleSkriptDataPath
		StringTrimLeft,Edit5,Edit5,1
		GuiControl,1:, %HwndEdit5%, %Edit5%
		++ContainerAnzahl
		Cont%A_Index%:=A_LoopFileName
		WortVorschlagListe.=A_Index "_" A_LoopFileName "   "
		; MsgBox % Cont%A_Index%
		if(AktHauptContainerNr="" and (WurzelContainer "\Haupt"=A_LoopFileLongPath))
			AktHauptContainerNr:=ContainerAnzahl
		if(AktStartMenuContainerNr="" and (WurzelContainer "\Start Menu"=A_LoopFileLongPath))
			AktStartMenuContainerNr:=ContainerAnzahl
	}
		if(Edit10="Zusatz" or Edit10="")
		{
			Edit10:="Container:  " WortVorschlagListe
			gosub Edit10Festigen
			ContainerAnzeigeTime:=A_TickCount
		}
	; FileAppend,%Edit2CaretX%`,%Edit2CaretY%`r`n%WortVorschlagListe%,%A_AppData%\Zack\WortVorschlagListe.txt,utf-16
	FokusEdit2Rechts()
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
			gosub FavoritenVorschlagErzeuegen

		}
	}
	else If (AlleSkriptDataPath<>"")
	{
	}
	If(AktContainerNr="")
		AktContainerNr:=AktHauptContainerNr
	return
	;}	
;}	
;{	; Menu | Container | CacheStruktur anzeigen
ContStaAnz:	;{	
MomentaneWortListe=
	Loop,Files,%WurzelContainer%\*,D 
	{
		MomentaneWortListe.= CrLf A_LoopFileName
		Loop,Files,%A_LoopFileFullPath%\*,D
			MomentaneWortListe.= CrLf A_Space A_Space A_Space A_Space A_LoopFileName
	}
	StringTrimLeft,MomentaneWortListe,MomentaneWortListe,2
	Edit5:=MomentaneWortListe
	gosub Edit5Festigen
return
;}	
;}	
;{	; Menu | ↓  
ContainerNext:	;{	
gosub ContainerUebersichtZeigen
sleep 100
++AktContainerNr
if(AktContainerNr>ContainerAnzahl)
	AktContainerNr:=1
Edit3:=AktContainerNr
gosub Edit3Festigen
Sleep 20
gosub WurzelContainerOeffnen
VarNameSkriptDataPath:=OnlyVarChar(NameSkriptDataPath)
if(LastSuFi%VarNameSkriptDataPath%<>"")
{
	SuFi:=LastSuFi%VarNameSkriptDataPath%
	gosub SuFiFestigen
}

Edit7:=LastStaPfaNr%VarNameSkriptDataPath%
gosub Edit7Festigen
return
;}	
;}	
; Favoriten	@0295
;{	; Menu |   ↑
NurNextStartPfad:	;{	
^Down::	; Naechster StartPfad
StartPfadAnzahl:=0
Loop,Files,%SkriptDataPath%\*, D
{
	; DieseStartPfadeUebersicht:=DieseStartPfadeUebersicht "`r`n" A_LoopFileLongPath
	++StartPfadAnzahl
}
if(StartPfadAnzahl>1)
{
	if(Edit7<0)
		Edit7:=
	SuFi:=0
	gosub SuFiFestigen
	if Edit7 is Integer
	{
		++Edit7
	}
	else
	{
		Edit7:=2
	}
	if(Edit7=100)
		Edit7:=
	if(Edit7>StartPfadAnzahl)
		Edit7:=99
	VarNameSkriptDataPath:=OnlyVarChar(NameSkriptDataPath)
	LastStaPfaNr%VarNameSkriptDataPath%:=Edit7
	LastSuFi%VarNameSkriptDataPath%:=SuFi
	gosub KontainerAnzeigen
	gosub Edit7Festigen
	gosub F5
}
return
;}	
;}	
;{	; Menu | Start-Pfad | Start-Pfad-Schnell-Filter
StartPfadSchnellFilter:	;{	
Initiator:="StartPfadSchnellFilter"
gosub StartPfadeUebersicht
gosub MachsBesteDrausControls
gosub KontainerAnzeigen
return
;}	
;}	
;{	; Menu | Start-Pfad | von Datei einlesen ...
; siehe Label WurzelHinzuFuegen (ueberuebernaechstes Unterprogramm)
;}	
;{	; Menu | Start-Pfad | einlesen ...
^o:: 	; Start-Pfad hinzufuegen
StartPfadEinlesen:
;}	
WurzelVonDateiHinzuFuegen:	;{	
FileSelectFile,AwpfPfad,,%A_AppDataCommon%\Zack\AlleLaufwerke.awpf,Bitte eine Start-Pfad Datei auswaehlen.,Start-Pfade (*.txt;*.awpf)  ; %A_AppDataCommon%\Zack\AlleLaufwerke.awpf
if ErrorLevel
{
	BeschaeftigtAnzeige(-1)
	return
}
;}	
; ohne Return
WurzelVonBekannterDateiHinzuFuegen:	;{	
dummy:=BeschaeftigtAnzeige(1)
{
	NeueWurzel:=AwpfPfad
	gosub StarteDiesesWurzelSkriptOderAlternative
}
gosub StartPfadAenderung
BeschaeftigtAnzeige(-1)
return
;}	
; Menu, StartPfadMenue, 	Add, &einlesen ...`tCtrl+O		, WurzelHinzuFuegen  ; Siehe untere Bemerkungen zu Ctrl+F.
WurzelHinzuFuegen:
NeueWurzelHinzufuegen:	;{	
If Fehlersuche
	SoundBeep
FileSelectFolder,NeueWurzel,*Desktop,1,Neue Wurzel hinzuladen`nfuer Stringeingabe bzw. fuer Dateien auch einlesen [Esc] druecken.
If(NeueWurzel="")
{	
	Edit8Sternlos:=FuehrendeSterneEntfernen(Edit8)
	if(InStr(FileExist(Edit8Sternlos),"D"))
	{
		if(InStr(Edit8,"]#"))	; geoeffnetes Fenster erkannt
			AuchFiles:=			; Vorschlag: Nur Ordner einlesen
		else
			AuchFiles:="+"		; Vorschlag: Dateien auch einlesen, wenn Edit8 ein Unterordner eines bestehenden Stratpfades ist
		
		if(SubStr(Edit8Sternlos,0,1)="\")
			DieserVorschlag:=AuchFiles . Edit8Sternlos . "*"
		else
			DieserVorschlag:=AuchFiles . Edit8Sternlos . "\*"
	}
	else
		DieserVorschlag:=SystemLaufwerk "\*"
	InputBox,NeueWurzel,Stringeingabe,Der neue Start-Pfad kann auch als String eingegeben werden`n`n+ vor den StartPfad um auch Dateien einzulesen.,,400,200,,,,,%DieserVorschlag%
	if ErrorLevel
		return
}
;}	
; ohne Return
NeueWurzelHinzufuegenBeiVorhandenemWurzelName:	;{	
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
;}	
StarteDiesesWurzelSkriptOderAlternative:	;{	
BeschaeftigtAnzeige(1)
gosub BereiteVorDir2Paths
Dir2PathStartRueck:=RunOtherAhkScriptOrExe(A_AppDataCommon "\Zack\Dir2Paths.ahk",SkriptDataPath,NeueWurzel)
; Dir2PathStartRueck:=IfExistCallEExeOrAhk(A_AppDataCommon "\Zack\Dir2Paths.ahk",SkriptDataPath,NeueWurzel)
If Dir2PathStartRueck
{
	BeschaeftigtAnzeige(-1)
	return
}
return
;}	
;{	; Menu | Start-Pfad | (Angezeigten) aktualisieren ...	(einzeln)
WurzelAktualisieren:	;{	Einzelnen Start-Pfad aktualisieren.
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
;}	
;}	
;{	; Menu | Start-Pfad | aktualisieren (Container)
WurzelnAktualisieren:	;{	Die StartPfade des Containers %SkriptDataPath% werden neu eingelesen.
gosub AktuelleStartPfade2Awpf
return
;}	
;}	
;{	; Menu | Start-Pfad | Loeschen ...
WurzelLoeschen:	;{	loescht die zum Start-Pfad gehoerende Wurzel Datei %ZuLoeschendeWurzelDotTxt% selbst und den darin verlinkten Inhalt des Start-Pfad-Caches. Bei zu erfragendem Start-Pfad.
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
;}	
;}	
; ohne Return
WurzelLoeschenBeiVorhandenerWurzelTxt:	;{	loescht die zum Start-Pfad gehoerende Wurzel Datei %ZuLoeschendeWurzelDotTxt% selbst und den darin verlinkten Inhalt des Start-Pfad-Caches. Bei bereits bekanntem Start-Pfad.
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
		sleep 10
		gosub StartPfadAenderung
		return
	}
return
;}	
;{	; Menu | Start-Pfad | Uebersicht anzeigen
StartPfadeUebersicht:	;{	gibt die Startpfade des Containers aus.	; wie	FilP://Deref%SkriptDataPath%fereD\**,D In_Row? 
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
;}	
;}	
;{	; Menu | ↓  
NurLastStartPfad:	;{	;}	
^Up::	;{	Voriger StartPfad
StartPfadAnzahl:=0
Loop,Files,%SkriptDataPath%\*, D
{
	; DieseStartPfadeUebersicht:=DieseStartPfadeUebersicht "`r`n" A_LoopFileLongPath
	++StartPfadAnzahl
}
if(StartPfadAnzahl>1)
{
	if(Edit7<0)
		Edit7:=
	SuFi:=0
	gosub SuFiFestigen
		if Edit7 is Integer
	{
		--Edit7
	}
	else
	{
		Edit7:=99
	}
	if(Edit7<1)
		Edit7:=
	else if(Edit7=98)
		Edit7:=StartPfadAnzahl
	VarNameSkriptDataPath:=OnlyVarChar(NameSkriptDataPath)
	LastStaPfaNr%VarNameSkriptDataPath%:=Edit7
	LastSuFi%VarNameSkriptDataPath%:=SuFi
	gosub KontainerAnzeigen
	gosub Edit7Festigen
	gosub F5
}
return
;}
;}
; Favoriten
;{	; Menu | Favoriten | speichern ...
FavoritSpeichern:	;{	
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
;}	
;}	
;{	; Menu | Favoriten | oeffnen (restaurieren) ...
FavoritOeffnen:	;{	
FileSelectFile,MultiFilePath,,% A_MyDocuments,FavoritenSicherung,FavoritenDateien(*.txt)
if (MultiFilePath="")
	return
MultiFileInhalt2TextDir(MultiFilePath,SkriptDataPath "\!Fav")
; gosub GetThisFafCopy
return
;}	
;}	
;{	; Menu | Favoriten | plus *
SucheFavInhalte:
Edit2:="FilP://" SkriptDataPath "\!Fav\**,DF`vIn_Inh? "
gosub Edit2Festigen
return
PlusStern:	;{	
if(InStr(Edit8,A_Tab . A_Tab))		; vorhandenes Explorerfenster erkennen
	gosub PlusSternManuell
else
	SetFavorit(Edit8,+1,"",FavoritenDirPath,1)
return
;}	
;}	
;{	; Menu | Favoriten | minus *
MinusStern:	;{	
SetFavorit(Edit8,-1,"",FavoritenDirPath,1)
return
;}	
;}	
;{	; Menu | Favoriten | Sternlose loeschen
SternLoseFavoritenLoeschen:	;{	
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
;}	
;}	
EintragOhneStern:	;{	
fehlersuche:=true
SetFavorit(FuehrendeSterneEntfernen(Edit8),"","BehaltePfad",FavoritenDirPath,1)
fehlersuche:=false
return
;}	
;{	; Menu | Favoriten | AutoFavorit=#
AutoFavoritEingeben:	;{	
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
;}	
;}	
;{	; Menu | Favoriten | Ordner oeffnen			, FavoritenOrdnerOeffnen
FavoritenOrdnerOeffnen:	;{	
FavoritenOrdner:=FuehrendeSterneEntfernen(SkriptDataPath "\!Fav")
IfExist, % FavoritenOrdner
{
	run, explorer.exe /select`,"%FavoritenOrdner%"
	if ZackZackOrdnerLogErstellen
		 ThreadUeberwachungLog(A_LineNumber-1,A_ThisHotkey,A_ThisLabel,A_ThisFunc,A_ThisMenu,A_ThisMenuItem,A_ThisMenuItemPos)
}
return
;}	
;}	
;{	; Menu | Favoriten | Fav-Vorschlag generieren ...
FavoritenVorschlagErzeuegen:	;{	
gosub DrivesListErzeugen
gosub SpezialOrdnerAnlegen
if(InStr(SkriptDataPath,"Haupt"))
{
FavoritenVorschlag=
(
Details ZackZackOrdner AutoHotKey Forum Deutsch|*https://autohotkey.com/boards/viewtopic.php?f=10&t=15248`r
ZackZackOrdner Herunterladen Download GitHub|*https://github.com/Grrdi/ZackZackOrdner/archive/master.zip`r
%DriveNamesPfadList%`r
BiblioTheken Libraries|*%A_AppData%\Microsoft\Windows\Libraries`r
%A_Desktop%`r
%A_DesktopCommon%`r
Eigene Dokumente My Documents|*%A_MyDocuments%`r
Systemsteuerung Alle Tasks Control Panel all Tasks|*%A_AppDataCommon%\Zack\Clsid\Systemsteuerung alle Tasks.{ED7BA470-8E54-465E-825C-99712043E01C}`r
Drucker Printer|*%A_AppDataCommon%\Zack\Clsid\Drucker.{2227A280-3AEA-1069-A2DE-08002B30309D}`r
Zwischenablage Google Suche Clipboard Googl Search|*https://www.google.de/?gws_rd=ssl#q=Deref`%Clipboard`%fereD
Edit10 Zusatz Feld Google Suche Google Search|*https://www.google.de/?gws_rd=ssl#q=Deref`%Edit10`%fereD
)
}
else if(InStr(SkriptDataPath,"Start"))
{
FavoritenVorschlag=
(
Action Info Center|*ms-actioncenter:
Cortana|*ms-cortana:
Edge Internet Browser|*microsoft-edge:
E-Mail schreiben|mailto:
Kontakte|ms-people:
Abmelden Herunterfahren_Neustarten shutdown -i|*shutdown -i -m \\%A_ComputerName%
)
}
else
{
FavoritenVorschlag=
(
Details ZackZackOrdner AutoHotKey Forum Deutsch|*https://autohotkey.com/boards/viewtopic.php?f=10&t=15248`r
ZackZackOrdner Herunterladen Download GitHub|*https://github.com/Grrdi/ZackZackOrdner/archive/master.zip`r
%DriveNamesPfadList%`r
BiblioTheken Libraries|*%A_AppData%\Microsoft\Windows\Libraries`r
%A_Desktop%`r
%A_DesktopCommon%`r
Eigene Dokumente My Documents|*%A_MyDocuments%`r
Systemsteuerung Alle Tasks Control Panel all Tasks|*%A_AppDataCommon%\Zack\Clsid\Systemsteuerung alle Tasks.{ED7BA470-8E54-465E-825C-99712043E01C}`r
Drucker Printer|*%A_AppDataCommon%\Zack\Clsid\Drucker.{2227A280-3AEA-1069-A2DE-08002B30309D}`r
Zwischenablage Google Suche Clipboard Googl Search|*https://www.google.de/?gws_rd=ssl#q=Deref`%Clipboard`%fereD
Edit10 Zusatz Feld Google Suche Google Search|*https://www.google.de/?gws_rd=ssl#q=Deref`%Edit10`%fereD
)	
}
MsgBox, 262180, Vorgeschlagene Favoriten,%A_Tab%%A_Tab%%A_Tab%sollen folgende Favoriten`n%FavoritenVorschlag%`n			erzeugt werden?
IfMsgBox,No
	return
Clipboard:=FavoritenVorschlag
; gosub ClipboardMenuHandler10
gosub PlusSternClipPfade
return
;}	
;}	
;{	; Menu | Favoriten | plus * Clip-Pfade `t#*			, PlusSternClipPfade
; siehe Label PlusSternClipPfade
;}	
; -----> @0210
;{	; Menu | Favoriten | minus * Clip-Pfade
MinusSternClipPfade:	;{	
Loop,Parse,Clipboard,`n,`r
{
	if(Trim(A_LoopField)<>"")
		SetFavorit(A_LoopField,-1,"",FavoritenDirPath,1)
}
return
;}	
;}	
;{	; Menu | Favoriten | Loeschen * Clip-Pfade			, LoeschenSternClipPfade
LoeschenSternClipPfade:	;{	
BeschaeftigtAnzeige(1)
Loop,Parse,Clipboard,`n,`r
{
	if(Trim(A_LoopField)<>"")
		SetFavorit(A_LoopField,-10,"",FavoritenDirPath,1)
}
BeschaeftigtAnzeige(-1)
return
;}	
;}	
;{	; Menu | Favoriten | plus * &manuell ...			, PlusSternManuell
PlusSternManuell:	;{	
if(InStr(Edit8,A_Tab . A_Tab))		; vorhandenes Explorerfenster erkennen
{
	EckKlammerAufPos:=InStr(Edit8,"[",,0)
	EckKlammerZuPos:=InStr(Edit8,"]",,0)
	ThisAnzZeichen:=EckKlammerZuPos-EckKlammerAufPos-1
	ThisCacheName:=SubStr(Edit8,EckKlammerAufPos+1,ThisAnzZeichen)
	StringReplace,ThisCacheName,ThisCacheName,|,!,all
	ThisNewFavorit:=ThisCacheName "|*" FuehrendeSterneEntfernen(Edit8)
}
if (ThisNewFavorit="")
	ThisNewFavorit=Name|*Pfad
;}	
;}	
; ohne Return
PlusSternManuellVorschlagVorhanden:	;{
IfExist %ContainerVorschlagPfad%
{
	DieseContainerNr:=GetContainerNr(ContainerVorschlagPfad)
	; MsgBox % ContainerVorschlagPfad "	" DieseContainerNr
}
else
{
	gosub GetAktContainerNr
	DieseContainerNr:=AktContainerNr
	ContainerVorschlagPfad:=  WurzelContainer "\" Cont%AktContainerNr%
}
if (DieseContainerNr=0 or DieseContainerNr="")
{
	gosub GetAktContainerNr
	DieseContainerNr:=AktContainerNr
}
FuncEinstellungen := {DefaultButton: 1, EditReadOnly: 0, DisableMainWindow: 1}
DieseAntwort:=AbfrageFenster(FuncEinstellungen,New Favorit,ThisNewFavorit "`nanlegen in Container " ContainerVorschlagPfad   " mit der editierbaren ContainerNr.: " DieseContainerNr   "`n`nin der 1. Zeile bitte den `nFavoritenName |* gefolgt von dem Pfad `neingeben bzw. ueberpruefen`n`n" "Container:	1 " Cont1 "		2 " Cont2 "		3 " Cont3  "		4 " Cont4 "		5 " Cont5 "		6 " Cont6 "		7 " Cont7 "		8 " Cont8 "		9 " Cont9 , "OK",">>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>abbrechen")
if(DieseAntwort=0)
	return
StringSplit,DieseAntwortZeile,DieseAntwort,`n,`r
ThisNewFavorit:=SubStr(DieseAntwortZeile1,2)
if not (SubStr(DieseAntwortZeile1,1,1)="1")
	return
WunschContNr:=SubStr(DieseAntwortZeile2,0)
if WunschContNr is not Integer
	WunschContNr:=
;}	
; ohne Return
PlusSternManuellBekannt:	;{	
; MsgBox % ThisNewFavoritNameUrl "	" ThisNewFavorit "		" DieseContainerNr "	" ContainerVorschlagPfad
if(ContainerVorschlagPfad<>"" and DieseContainerNr)
	
	StringSplit,ThisNewFavoritNameUrl,ThisNewFavorit,|,%A_Space%
else
	StringSplit,ThisNewFavoritNameUrl,ThisNewFavorit,|,%A_Space%
if (ThisNewFavoritNameUrl0<>2)
{
	MsgBox, 262160, Fehler, Es muss genau ein`n |`nin der Eingabe Enthalten sein!
	WunschContNr:=
	return
}
if (ThisNewFavoritNameUrl1="")
{
	MsgBox, 262160, Fehler, Der Name Fehlt!
	WunschContNr:=
	return
}
if (ThisNewFavoritNameUrl2="")
{
	MsgBox, 262160, Fehler, der Pfad Fehlt!
	WunschContNr:=
	return
}
if DieseContainerNr
{
	WunschContNr:=DieseContainerNr
	WunschFavoritenDirPath:=ContainerVorschlagPfad "\!Fav"
}
else if (WunschContNr<>"")
{
	if WunschContNr is not Integer
		WunschContNr:=AktStartMenuContainerNr
	if (WunschContNr>ContainerAnzahl)
		WunschContNr:=AktStartMenuContainerNr

	WunschFavoritenDirPath:=WurzelContainer "\" Cont%WunschContNr%  "\!Fav"			; NameSkriptDataPath[5 of 63]: Haupt		SkriptDataPathKurzNachProgrammbeginn[32 of 63]: C:\ProgramData\Zack\WuCont\Haupt
}
else
{
	WunschFavoritenDirPath:=WurzelContainer "\" Cont%AktContainerNr%  "\!Fav"	
}
IfNotExist % WunschFavoritenDirPath
	FileCreateDir, %WunschFavoritenDirPath%
If FehlerSuche
	MsgBox %A_LineNumber%	FileAppend`,%ThisNewFavoritNameUrl2%`,%SkriptDataPath%\!Fav\%ThisNewFavoritNameUrl1%.txt`,utf-16
ThisNewFavoritNameUrl1:=NichtErlaubteZeichenErsetzen(ThisNewFavoritNameUrl1,1)
IfExist %WunschFavoritenDirPath%\%ThisNewFavoritNameUrl1%.txt
{
	run notepad.exe %WunschFavoritenDirPath%\%ThisNewFavoritNameUrl1%.txt
	WinWaitActive,notepad.exe ,,1
	send {Down}*
	MsgBox, 262208, Manuelle Bearbeitung erforderlich, Bitte den Stern manuell in %SkriptDataPath%\!Fav\%ThisNewFavoritNameUrl1%.txt bestätigen durch speichern! 
	return
}
FileAppend,`r`n%ThisNewFavoritNameUrl2%,%WunschFavoritenDirPath%\%ThisNewFavoritNameUrl1%.txt,utf-16
WunschContNr:=
return
;}	
;{	; Menu | Favoriten | SuperFavoriten ♥ bearbeiten	, SuperFaVoritenAnlegenBearbeiten
SuperFaVoritenAnlegenBearbeiten:	;{	
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
		IfNotExist %A_AppDataCommon%\Zack\ClsId\Drucker.{2227A280-3AEA-1069-A2DE-08002B30309D}
			gosub SpezialOrdnerAnlegen
		IfExist %A_AppData%\Zack\Macro\OeffneDieserPcImExplorer.txt
			FileAppend,`r`n%A_AppData%\Zack\Macro\OeffneDieserPcImExplorer.txt,%SuperFavoritenDateiPfad%,utf-16
		IfExist %A_AppDataCommon%\Zack\ClsId\Drucker.{2227A280-3AEA-1069-A2DE-08002B30309D}
		{
			gosub SuperFaVoritenEinfuehrung
			FileAppend,`r`n%A_AppDataCommon%\Zack\ClsId\Drucker.{2227A280-3AEA-1069-A2DE-08002B30309D},%SuperFavoritenDateiPfad%,utf-16
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
	if(AbfrageFensterAntwort=0)
		return
	else if (SubStr(AbfrageFensterAntwort,1,1)=1)
	{
		RunOtherAhkScriptOrExe(ExternalToolTipPath,".			Das Skript wird neu geladen")
		Reload
	}
}
return
;}	
;}	
BefehlsVariableNochmalsAusfuehren:
if(InStr(LastBefehlsMacro,"BefehlsMacro"))
{
	MsgBox, 262452, Makro-Debug, Maros welche die Variable `n	BefehlsMacro `nbenutzen werden noch nicht unterstuetzt.`n`nTrotzdem Makro starten?  (kann bis zum Skriptabsturz fuehren)
	IfMsgBox,Yes
	{
	}
	else
		return
}
BefehlsMacro:=LastBefehlsMacro
if(BefehlsMacro<>"")
gosub BefehlsVariableAusfuehren
return
; Macro	@0296
;{	; Menu | Macro | Ordner oeffnen			, StaOrdnerBefehlsDateiPfadOeffnen
StaOrdnerBefehlsDateiPfadOeffnen:	;{	
IfNotExist %A_AppData%\Zack\Macro
	FileCreateDir,%A_AppData%\Zack\Macro
run, %A_AppData%\Zack\Macro
if ZackZackOrdnerLogErstellen
	ThreadUeberwachungLog(A_LineNumber-1,A_ThisHotkey,A_ThisLabel,A_ThisFunc,A_ThisMenu,A_ThisMenuItem,A_ThisMenuItemPos)
return
;}	
;}	
DiesenBefehlsDateiPfadAusfuehren:	;{	je Zeile ein Befehl in der Datei mit dem Pfad DiesenBefehlsDateiPfad
FileRead,BefehlsMacro,%DiesenBefehlsDateiPfad%
if(BefehlsMacro<>"")
	LastBefehlsMacro:=BefehlsMacro
;}	
; ohne Return
BefehlsVariableAusfuehren:	;{	je Zeile ein Befehl in der Variablen BefehlsMacro	;}
if (InMacro="")
	InMacro:=true
else
	++InMacro
; DiesesBefehlsMacro:=BefehlsMacro
Loop,Parse,BefehlsMacro,`n,`r
{
	Datenkopie:=A_LoopField
	gosub TimerEditUebernahme
	sleep 20
}
--InMacro
if(InMacro<0)
	SoundBeep ; Unerwartet
return
;}	
UserSelBefehlsDateiPfadAusfuehrenDebug:		; Macro-Debug-Modus 
MacroDebug:=true
;{	; Menu | Macro | Starten...				, UserSelBefehlsDateiPfadAusfuehren
UserSelBefehlsDateiPfadAusfuehren:	;{	
if (InMacro="")
	InMacro:=true
else
	++InMacro
; MsgBox % A_ThisLabel
if (A_ThisLabel="UserSelBefehlsDateiPfadAusfuehren")
	MacroDebug:=false
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
if (MacroPlatzIndex<1)
{
	MsgBox, 262208, Macro, Es wurden keine Macros gefunden.`n`nEmpfehlung: Rufen Sie `nMenue: Macro | Muster-Dateien...`nauf um einen Grundstamm an Macros zu bekommen.
	--InMacro
	if(InMacro<0)
		SoundBeep ; Unerwartet

	return
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
if (AbfrageFensterAntwort=0)
{
	--InMacro
	if(InMacro<0)
		SoundBeep ; Unerwartet

	return
}
AbfrageFensterAntwortButonNr:=SubStr(AbfrageFensterAntwort,1,1)
; AbfrageFensterAntwortButonNr:=7
if(AbfrageFensterAntwortButonNr<MacroOrdnerIndex)
	DiesenBefehlsDateiPfad:=MacroPlatz%AbfrageFensterAntwortButonNr%
else if (AbfrageFensterAntwortButonNr=MacroOrdnerIndex)
{
	FileSelectFile,DiesenBefehlsDateiPfad,,%A_AppData%\Zack\Macro,bitte Macro auswaehlen,Macros (*.txt;*.*)
	if ErrorLevel
	{
		--InMacro
		if(InMacro<0)
			SoundBeep ; Unerwartet
		return
	}
	If (DiesenBefehlsDateiPfad="")
	{
		--InMacro
		if(InMacro<0)
			SoundBeep ; Unerwartet
		return
	}
}
else
{
	--InMacro
	if(InMacro<0)
		SoundBeep ; Unerwartet
	return
}
; MsgBox %MacroDebug%
if (MacroDebug)
{
; 	SoundBeep
	Edit2:=FileKenner DiesenBefehlsDateiPfad A_Space MacroAufuehrenKenner A_Space "1"
	gosub Edit2Festigen
}
else
	gosub DiesenBefehlsDateiPfadAusfuehren
	--InMacro
	if(InMacro<0)
		SoundBeep ; Unerwartet

return
;}	
;}	
;{	; Menu | Macro | Muster-Dateien ...		, MusterDateienErzeugen
MusterDateienErzeugen:	;{	
MacroDir=%A_AppData%\Zack\Macro
IfNotExist %MacroDir%
	FileCreateDir, %MacroDir%
MacroMusterDateiAnzahl:=14
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
MacroMusterDateiName12=Edit8OeffnenMitNotepad.txt
MacroMusterDateiName13=ZeigeLaufwerkeInEdit5.txt
MacroMusterDateiName14=OeffneDieserPcImExplorer.txt
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
§§AbfrageFenster
ResetAllNocontainer
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
MacroMusterDateiInhalt12=
(
Edit8OeffnenMitSpeicher:=notepad "```%E8```%"
Edit8OeffnenMit
)
MacroMusterDateiInhalt13=
(
GetDriveLists
DriveNamesCrList:=?5
)
MacroMusterDateiInhalt14=
(
GetDriveLists
DriveNamesCrList:=?5
Edit3=1
Edit3Festigen
Edit8ExplorerSelect
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
;}	
;}
	
;{	; Menu | Macro | Befehls-Liste				, ListLabels
ListLabels:	;{	                                              
LL:	;{	
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
			if(ScriptQuellLabelZeile0 > 3)
				continue
		}
		else
		{
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
##	ist der HotKey [Win]+[#] 
geplant, mit auflisten der Funktionen:
...(..)	Funktionen	(OutVar§...§.. entspricht dem Aufrufbefehl)
   ########### ############ ############### Befehlsliste ############ ################# #############
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
;}	
;}	
;}	
Farbe:	;{	
GuiControl,1: +BackgroundFF9977, %HwndEdit1%
GuiControl,1: +BackgroundFF9977, %HwndButton1%
return
;}	
; Optionen	@0297
;{	; Menu | Optionen | Sitzungs-Einst. speichern				, SitzungsEinstellungenMerken
WennAktContLeerSucheFestigen:
IfExist %SkriptDataPath%\*.txt
	return
else (if InStr(Edit2,ProtokollKenner))
{
	MsgBox, 8228, Suche festigen, Soll diese Suche in diesem Container voreingestellt werden?
	IfMsgBox,Yes
		FileAppend,%Edit2%,%SkriptDataPath%\AutoEdit2.txt
	IfMsgBox,No
		FileAppend,Soll diese Suche in diesem Container voreingestellt werden? No,%SkriptDataPath%\Dummy.txt
}
return
AktuelleLiveSuche2Lnk:
LnkParameter:=Hochkomma "<Macro>" Hochkomma A_Space Hochkomma "Edit8=" A_Tab NameSkriptDataPath Hochkomma A_Space Edit8Festigen   "GetAngezeigteSuche"     A_Space Hochkomma "Edit2=" Edit2 Hochkomma A_Space Hochkomma "Schlafe200" Hochkomma A_Space Hochkomma "Schlafe200" Hochkomma A_Space "Edit2Festigen" A_Space  "WennAktContLeerSucheFestigen" A_Space "</Macro>"
FileSelectFile,LnkVerknuepfung,16,::{20d04fe0-3aea-1069-a2d8-08002b30309d}\schnellOrdnerLiveSucheStart.lnk,Pfad der Lnk-Datei,Link-Dateien (*.lnk)
if (LnkVerknuepfung="")
	return
if  (Not SubStr(LnkVerknuepfung,-2,3)="Lnk")
	LnkVerknuepfung.=".Lnk"
FileCreateShortcut, %A_ScriptFullPath%, %LnkVerknuepfung% , %A_ScriptDir%, %LnkParameter%
return
SDE:	;{	;}
SitzungsEinstellungenMerken:	;{	
VarEinstellungsVarList=
(
GuiNachHochfahrenMinimieren
MausGuenstigPositionieren
GuiAnzeigeFortgeschritten
SkriptDataPath
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
WortVorschlaege
NurInExistierendenStartPfadenSuchen
NotShowExistIeAndExplorerWin
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
AuswahlGuiAnzeigeFortgeschritten`r
KontainerAnzeigen`r
Button1`r
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
;}	
;}	
;{	; Menu | Optionen | Sitzungs-Einst. einlesen				, SitzungsEinstellungenEinlesen
SitzungsEinstellungenEinlesen:	;{	
FileRead,BefehlsMacro,%A_AppData%\Zack\Einstellungen.txt
gosub BefehlsVariableAusfuehren	
return
;}	
;}	
SitzungsEinstellungenBeiScriptStartEinlesen:	;{	
IfExist %A_AppData%\Zack\AutoEinstellungen.txt
{
	FileRead,BefehlsMacro,%A_AppData%\Zack\AutoEinstellungen.txt
	gosub BefehlsVariableAusfuehren	
}
return
;}	
;{	; Menu | Optionen | Sitzungs-Einst. bearbeiten			, SitzungsEinstellungenBearbeiten
SitzungsEinstellungenBearbeiten:	;{	
IfNotExist  %A_AppData%\Zack\Einstellungen.txt
	gosub SitzungsEinstellungenMerken
IfExist  %A_AppData%\Zack\Einstellungen.txt
	run notepad.exe "%A_AppData%\Zack\Einstellungen.txt"
return
;}	
;}	
;{	; Menu | Optionen | Suche &ruecksetzen			, ResetAllNocontainer
ResetAllNocontainer:	;{	
If(SkriptDataPath=SuperContainer)
{
	gosub F5
	Sleep 200
	Edit3=000
	gosub Edit3Festigen
	gosub Edit3
}
LastSort:="normal"
Edit1:=Edit1Default
gosub Edit1Festigen
Edit2:=Edit2efault
IfExist %SkriptDataPath%\AutoEdit2.txt	; moeglichkeit zur Vorgabe eines individuellen Suchstrings im Container
	FileRead,Edit2,%SkriptDataPath%\AutoEdit2.txt
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
Edit11:=Edit11Default
gosub Edit11Festigen
Edit12:=Edit12efault
gosub Edit12Festigen

; OnTop:=OnTopDefault
; gosub OnTopFestigen
GuiNachHochfahrenMinimieren:=GuiNachHochfahrenMinimierenDefault
NurInExistierendenStartPfadenSuchen:=NurInExistierendenStartPfadenSuchenDefault
NotShowExistIeAndExplorerWin:=NotShowExistIeAndExplorerWinDefault

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
LastStaPfaNr%VarNameSkriptDataPath%:=
gosub KontainerAnzeigen
Edit2DefaultAusDateiPfad=%A_ScriptDir%\Zzo%NameSkriptDataPath%Edit2DefaultString.txt
IfExist %Edit2DefaultAusDateiPfad%
{
	FileRead,Edit2%NameSkriptDataPath%Default,%Edit2DefaultAusDateiPfad%	; moeglichkeit zur Vorgabe eines individuellen Suchstrings in A_ScriptDir
	Edit2:=Edit2%NameSkriptDataPath%Default
	gosub Edit2Festigen
}
IfExist %SkriptDataPath%\AutoMacro.txt	; moeglichkeit zur Vorgabe eines individuellen Macros im Container
{
	DiesenBefehlsDateiPfad:= SkriptDataPath "\AutoMacro.txt"
	gosub DiesenBefehlsDateiPfadAusfuehren
}
PfadFilterAutomatikAus:=true ; aus also auf true lassen, vertraegt sich nicht mit der Neuen-Live-Suche
beschaeftigt:=beschaeftigtDefault
gosub beschaeftigtFestigen
return
;}	
;}		
;{	; Menu | Optionen | ZZO Neueste Version holen				, ZZOAktualisieren
ZZOAktualisieren:	;{	
IfExist %A_ScriptDir%\AktualisiereZackZackOrdner.exe
{
	Run %A_ScriptDir%\AktualisiereZackZackOrdner.exe
	ExitApp
}
IfExist %A_ScriptDir%\AktualisiereZackZackOrdner.ahk
	Run %A_ScriptDir%\AktualisiereZackZackOrdner.ahk
gosub GuiClose
return
;}	
;}		
;{	; Menu | Optionen | Einstellungen ...				, Einstellungen
Einstellungen:	;{	
MsgBox, 262148, Beginner / Fortgeschrittener, Moechten Sie das ZackZackOrdner-Fenster in der Beginner-Ansicht angezeigt bekommen? `n`n`nHinweis: `nDie sehr beginnerfreundliche [Win] + [b] Aktivierung / Tastenkobination ist in beiden obigen Faellen (vorzugsweise bei aktiven Explorer-Fenstern sowie Speichern ... Dialogen) erreichbar.`n`nBei [Win] + [b] versucht ZZO das Beste aus den vorhandenen Informationen (welches Feld hatte einleitend den Fokus) zu machen bzw. passend (fuers betreffende Fenster (und Feld)) zurueck zu geben.
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
;}	
;}	
; ?	@0298
;{	; Menu | ? | Verlangsamte Demo			, LangsamDemoToggle
LangsamDemoToggle:	;{	
if LangsamDemo
	LangsamDemo:=false
else
{
	MsgBox, 8192, Such-Gimmik, Stark verlangsamte Suche mit ZwischenErgebnisAnzeige `n`nEin`n`nnochmal:	wieder aus.`n`n`nAchtung: Bei kurzen Suchbegriffen und einer hohen  (Schleifen-Iterations)-Abbr-(uch-Zahl) dauert es ewig. `nBetaetigen des Schliess X oben rechts`, sollte jedoch immer`, also auch mitten in der Suchzusammenstellung  funktionieren. Auch das Ausschalten des Demo-Modusses wird mitten in der Suchzusammenstellung unterstuetzt., 60
	LangsamDemo:=true
}
return
;}	
;}	
;{	; Menu | ? | Info						, Info
; siehe Label Info
;}	
;{	; Menu | ? | Hilfe
; siehe Label Hilfe
;}	
;{	; Menu | ? | Globale Variablen -> Notepad++
; siehe Label LVPP
;}		
;{	; Menu | ? | Unterprogramme anzeigen
; siehe Label QuellTextAnzeigenLabels
;}	
;{	; Menu | ? | Funktionen anzeigen
; siehe Label QuellTextAnzeigenFunctions
;}	
;{	; Menu | ? | HotKeys anzeigen
; siehe Label QuellTextAnzeigenHotkeys
;}	
;{	; Menu | ? | Quelltext anzeigen
; siehe Label QuellTextAnzeigen
;}	

;{	; Menu | ♥1 ... n			Nur wenn Superfavoriten vorhanden. n anzahl der Superfavoriten
; siehe IfExist %SuperFavoritenDateiPfad%
;}		
; < / #######################################  Haupt-Menue  ################################################ >
; < ########################################  Funktionen  a bis z ############################################ >	@0400
AbfrageFenster(FuncEinstellungen="",FensterTitel="",Frage="",ButtonText1="",ButtonText2="",ButtonText3="",ButtonText4="",ButtonText5="",ButtonText6="",ButtonText7="",ButtonText8="",ButtonText9="")	;{()	
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
if(Antwort=0)
	MsgBox Das AbfrageFenster wurde mit dem Schliesskreuz verlassen.
if(SubStr(Antwort,1,1)=2)
	MsgBox % SubStr(Antwort,2)
ExitApp
*/
static 					; alle
BeschaeftigtAnzeige(1,A_ThisFunc)
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
LastButton:=false
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
			else If (DefaultButton="Last")
			{
				LastButton:=true
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
if LastButton
{
	Button%ButtonText47110%Default:=true
	DefaultButton:=ButtonText47110
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
;}	
AWinTitle(WinTitle*)	;{()	
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
;}	
BeschaeftigtAnzeige(BeschZaehler,ThisFunc="")	;{()	
{
	global beschaeftigt,DebugViaBeschLog,DebugViaBeschPath,ThisGlobalVarName,GetGlobalVarAndValueList
	static SollZaehler:=0,testzaehler,Leer
	SollZaehler+=BeschZaehler
	testzaehler+=BeschZaehler
	if DebugViaBeschLog
	{
		DieseLogZeile:=A_Now "	BeschZaehler=" BeschZaehler "	" ThisFunc "	" GetGlobalVarAndValue("ThisFunc") 	GetGlobalVarAndValue("A_ThisLabel")  GetGlobalVarAndValue("A_ThisHotkey")  GetGlobalVarAndValue("A_ThisMenu") GetGlobalVarAndValue("A_ThisMenuItem")	GetGlobalVarAndValue("A_ThisMenuItemPos" ) GetGlobalVarAndValue("A_TimeSinceThisHotkey","-1") GetGlobalVarAndValue("A_TimeSinceThisHotkey","-1")	GetGlobalVarAndValue("A_TimeSincePriorHotkey","-1") GetGlobalVarAndValue("A_GuiEvent")  GetGlobalVarAndValue("A_EventInfo","0") "`r`n"
		StringSplit,DieserGlobalVarName,GetGlobalVarAndValueList,`,
		Loop % DieserGlobalVarName0
		{
			ThisGlobalVarName:=DieserGlobalVarName%A_Index%
			Transform,DieserGlobalVarName,Deref,%ThisGlobalVarName%
			ThisGlobalVarName:=DieserGlobalVarName
			try
				DieseLogZeile.=GetGlobalVarAndValue(ThisGlobalVarName)
		}
		FileAppend, % DieseLogZeile "`r`n", % DebugViaBeschPath,Utf-16
	}
	if (SollZaehler=1)
	{
	gosub BeschaeftigtAnf

	}
	else if (SollZaehler>1)
	{
		; Pruefung ob an
	}
	else if (SollZaehler<0)
	{
		ListLines
		MsgBox %A_LineNumber%	Nicht erwarteteter Skriptzweig	BeschaeftigtZaehler= %SollZaehler%
		SollZaehler:=0
	}
	else if (SollZaehler=0)
		gosub BeschaeftigtEnd
	return beschaeftigt
}
;}	
CHwnd(Hwnd,Was,Ri="Get",Optionen="")	;{()	
{
	static
	If (Optionen<>"")
	{
;		ListLines
;		MsgBox
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
;}
ClipHist(Rueck=0,CChange=0,Zp=10,D=0)	;{()	interne Funktion fuer die Clipboard-Historie
{
static   Index,	H:={}
	H_:={}
	if CChange
	{
		Loop Parse,Clipboard,`n,`r
		{
			H_.Push(SubStr(A_LoopField,1,255))
			if (A_Index>=Zp)
				break
		}
		H.insertAt(1,H_)
		H.Delete(ZP+1)
		; H.Delete(ZP+2)
		Loop, % Zp-1
		{
			delIndex:=A_Index
			Loop, % D
			{
				if (Zp-delIndex*D+A_Index > 1)
					h[delIndex+1].Delete(Zp-delIndex*D+A_Index)
			}		
		}
	}
	if Rueck
		return H
	return
}
;}	
DoEdit8LnkMacro:	;{	Startet ein LnkMacro bei gestartetem ZZO
Edit8OhneStern:=FuehrendeSterneEntfernen(Edit8)
SplitPath,Edit8OhneStern,,,DieseExt
if (DieseExt<>"lnk")
{
	FileSelectFile,Edit8OhneStern,1,::{20d04fe0-3aea-1069-a2d8-08002b30309d}\schnellOrdnerLiveSucheStart.lnk,Pfad der Lnk-Datei,Link-Dateien (*.lnk)
	if(Edit8OhneStern="")
		return
}
IfExist %Edit8OhneStern%
	DoLnkMacro(Edit8OhneStern)
return
;}	
DoLnkMacro(LnkPath)	;{()	Startet ein LnkMacro bei gestartetem ZZO
{
	global DiesenBefehlsDateiPfad
	FileGetShortcut,%LnkPath%,,,MacroH
; 	MsgBox % MacroH
	Index:=0
	MacroUebergabe:=false
	MacroUebergabeIndex:=0
	MacroUebergabeInhalt:={}
	MacroNachHochfahrenAusfuehren:={}

	StringSplit,ZwischenHochkomma,MacroH,"
	Loop, % ZwischenHochkomma0
	{
		if (mod(A_Index,2))		; ungerade
		{		; Zweig ohne Hochkommas

			if (ZwischenHochkomma%A_Index%="" OR ZwischenHochkomma%A_Index%=" ")
			{
				DieserBefehl:=
			}
			else
			{
				StringSplit,ZwischenLeerzeichen,ZwischenHochkomma%A_Index%,%A_Space%
				Loop, % ZwischenLeerzeichen0
				{
					if (ZwischenLeerzeichen%A_Index%<>"")
					{
						; MacroV.=ZwischenLeerzeichen%A_Index% "`r`n"
						DieserBefehl:=ZwischenLeerzeichen%A_Index%
						if (DieserBefehl="</Macro>")
							MacroUebergabe:=false
						else if (DieserBefehl="<Macro>")
							MacroUebergabe:=true, 	++MacroUebergabeIndex
						if (MacroUebergabe AND NOT DieserBefehl="<Macro>")
							MacroUebergabeInhalt[MacroUebergabeIndex].=DieserBefehl . "`r`n" , MacroNachHochfahrenAusfuehren[MacroUebergabeIndex]:=true

					}
				}
			}
		}
		else
		{		; Zweig in Hochkomma eingeschlossene
			; MacroV.=ZwischenHochkomma%A_Index% "`r`n"
			DieserBefehl:=ZwischenHochkomma%A_Index%
			if (DieserBefehl="</Macro>")
				MacroUebergabe:=false
			else if (DieserBefehl="<Macro>")
				MacroUebergabe:=true, 	++MacroUebergabeIndex
			if (MacroUebergabe AND NOT DieserBefehl="<Macro>")
				MacroUebergabeInhalt[MacroUebergabeIndex].=DieserBefehl . "`r`n" , MacroNachHochfahrenAusfuehren[MacroUebergabeIndex]:=true
		}
	}
	Loop, % MacroNachHochfahrenAusfuehren.MaxIndex()
	{
		MsgBox, 8228, Macro starten?, % MacroUebergabeInhalt[A_Index]
;		MsgBox  % MacroUebergabeInhalt[A_Index]
		sleep 500
		DiesenBefehlsDateiPfad=%A_AppData%\Zack\Macro\LnkMacro%A_Index%.txt
		FileDelete, %DiesenBefehlsDateiPfad%
		FileAppend, % MacroUebergabeInhalt[A_Index], %DiesenBefehlsDateiPfad%
		sleep 1000
		gosub DiesenBefehlsDateiPfadAusfuehren
	}
	
	return ; MacroV
}
;}	
Edit2MitDotDotStattDotOverDot(Edit2)	;{()	
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
;}	
Entferne(PfadListe:="",ZeichenLinks="0",ZeilenOben="0")	;{()	
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
;}	
FileCreateDirAndAutoFav(NewDir,Meldungen=1)	;{()	
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
;}	
FocusZueletztFokusieren(DieserZueletztFokusieren="",DieserSchreibMarkenOrt="")	;{()	
{
	global ZueletztFokusieren,SchreibMarkenOrt,GuiWinHwnd
	return	; Deaktiviert
	if(DieserZueletztFokusieren="")
	{
	}
	else
	{
		ControlGetFocus,FocusedGuiConntrol,ahk_id %GuiWinHwnd%
		if (FocusedGuiConntrol<>DieserZueletztFokusieren)
		{
			ControlFocus,%DieserZueletztFokusieren%,ahk_id %GuiWinHwnd%
			; SoundBeep 13535/3
			if(DieserSchreibMarkenOrt="")
			{
			}
			else if (DieserSchreibMarkenOrt="End")
			{
				; sleep 2000
					ControlSend,%DieserZueletztFokusieren%,{End},ahk_id %GuiWinHwnd%
				; 	SoundBeep,
			}
		}
	}
	; Tooltip,% "focus -> " DieserZueletztFokusieren "@ " DieserSchreibMarkenOrt
	ZueletztFokusieren:=
	SchreibMarkenOrt:=
	return
}
;}
; < ########################################## Fuehrende Sterne entfernen ################################### >
FuehrendeSterneEntfernen(Pfad,Max=20)	;{()	
{
 	global AnzahlEntfernterSterne
	Stern=*
	HalbOunten:="ᵕ"
	if(InStr(SubStr(Pfad,1,10),HalbOunten))
		StringTrimLeft,Pfad,Pfad,10
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
;}	
; < / ######################################### Fuehrende Sterne entfernen ################################### >
; < ########################################## Fuehrende Sterne zaehlen #################################### >
FuehrendeSterneAnzahl(Pfad,Max=20)	;{()	
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
;}	
; < / ######################################### Fuehrende Sterne zaehlen #################################### >
; < ########################################## Fuehrende Sterne bis auf einen definierten Rest entfernen############ >
FuehrendeSterneEntfernenRestLassen(Pfad,Rest,Max=20)	;{()	
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
;}	
; < / ##################### Fuehrende Sterne bis auf einen definierten Rest entfernen 
FunktionGosub(LabelName)	;{()	
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
;}	
FunktionIfGosub(Var1,Operator,Var2,JaLabel="",NeinLabel="")	;{()	
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
;}	
FunktionLoop(LoopLabel,Var1)	;{()	
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
;}	
FunktionUeberGabestringErzeugen(EingangsString,EingangsStringName="")	;{()	
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
;}	
GetAbPos(ZeilenText,ZeilenNummer)	;{()	
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
;}	
GetAktuellenDirektSucheFilter(WunschOrdnerPattern="c:\*",InNameFilter="",InRowFilter="",Optionen="DFR")	;{()	erzeuge DirektSuche-String Syntaktisch richtig
{
	global FilePatternKenner,InRowKenner

	if(Optionen="")
		Optionen:="DFR"
	RueckSuchFilter:=FilePatternKenner WunschOrdnerPattern InNameFilter "*," Optionen A_Space InRowKenner A_Space InRowFilter
	return RueckSuchFilter
}
GetAktuellenDirektSucheFilter2(WunschOrdnerPattern="c:\*",InNameFilter="",InRowFilter="",Optionen="DFR")	;{()	erzeuge DirektSuche-String Syntaktisch richtig
{
	global FilePatternKenner,InInhaltKenner

	if(Optionen="")
		Optionen:="DFR"
	RueckSuchFilter:=FilePatternKenner WunschOrdnerPattern InNameFilter "*," Optionen "`v" InInhaltKenner A_Space InRowFilter
	return RueckSuchFilter
}
;}
GetGlobalVarAndValue(GlobalVarVarname="",NotValues*)
{
	global
	local GlobalVarValue,GlobalVarValueAnsicht,index,NotVal
	If (GlobalVarVarname="")
		return
	
	try
		GlobalVarName:=GlobalVarVarname
	catch
		return "	Error"
	if (GlobalVarName="" OR GlobalVarName="0")
		return
	; if (SubStr(GlobalVarName,1,2)="A_")
	; {
	; }
	try
		GlobalVarValue:=%GlobalVarName%
	catch
		return ; GlobalVarName "=NULL"
	for index,NotVal in NotValues
	{
		if (GlobalVarValue=NotVal)
			return
	}

	if (GlobalVarValue<>"")
	{
		StringReplace,GlobalVarValueAnsicht,GlobalVarValue,`r`n,``r``n,all
		StringReplace,GlobalVarValueAnsicht,GlobalVarValue,`n,``n,all
		if (StrLen(GlobalVarValueAnsicht)>40)
			GlobalVarValueAnsicht:=SubStr(GlobalVarValueAnsicht,1,18) " ... " SubStr(GlobalVarValueAnsicht,-17,18) 
		else
			GlobalVarValueAnsicht:=GlobalVarValue
		return A_Tab GlobalVarName "="  GlobalVarValueAnsicht
	}
	return
}
ImageFileInfo2ClipEdit8:
Edit8Sternlos:=FuehrendeSterneEntfernen(Edit8)
ImageFileInfo:=GetImageFileInfo(Edit8Sternlos)
if (ImageFileInfo="")
	return
else
{
	Clipboard:=ImageFileInfo
	gosub ClipboardMenuHandler10
}
return
GetImageFileInfo(ImagePath,ErrorMessage="")	;{()	
{
	global ExternalToolTipPath
Img := ComObjCreate("WIA.ImageFile") 	; Quelle: https://autohotkey.com/board/topic/56987-com-object-reference-autohotkey-v11/://autohotkey.com/board/topic/56987-com-object-reference-autohotkey-v11/page-8?&#entry399185
try
{
	Img.LoadFile(ImagePath)	;	https://msdn.microsoft.com/de-de/library/windows/desktop/ms630506(v=vs.85).aspx
s := "Width = " Img.Width "`n"
    .    "Height = " Img.Height "`n"
    .    "Depth = " Img.PixelDepth "`n"
    .    "HorizontalResolution = " Img.HorizontalResolution "`n"
    .    "VerticalResolution = " Img.VerticalResolution "`n"
    .    "FrameCount = " Img.FrameCount "`n"
}
catch
{
	if ErrorMessage
		RunOtherAhkScriptOrExe(ExternalToolTipPath,ImagePath "`nist kein erkanntes Bild-Format" )
	return
}

If Img.IsIndexedPixelFormat
{
    s := s "Pixel data contains palette indexes" "`n"
}

If Img.IsAlphaPixelFormat
{
    s := s "Pixel data has alpha information" "`n"
}

If Img.IsExtendedPixelFormat
{
    s := s "Pixel data has extended color information (16 bit/channel)" "`n"
}

If Img.IsAnimated
{
    s := s "Image is animated" "`n"
}

If Img.Properties.Exists("40091")
{
    v := Img.Properties("40091").Value
    s := s "Title = " v.String "`n"
}

If Img.Properties.Exists("40092")
{
    v := Img.Properties("40092").Value
    s := s "Comment = " v.String "`n"
}

If Img.Properties.Exists("40093")
{
    v := Img.Properties("40093").Value
    s := s "Author = " v.String "`n"
}

If Img.Properties.Exists("40094")
{
    v := Img.Properties("40094").Value
    s := s "Keywords = " v.String "`n"
}

If Img.Properties.Exists("40095")
{
    v := Img.Properties("40095").Value
    s := s "Subject = " v.String "`n"
}

/*
Dim Img 'As ImageFile
Dim p 'As Property

Set Img = CommonDialog1.ShowAcquireImage

For Each p In Img.Properties
    Dim s 'As String

    s = p.Name & "(" & p.PropertyID & ") = "
    If p.IsVector Then
        s = s & "[vector data not emitted]"
    ElseIf p.Type = RationalImagePropertyType Then
        s = s & p.Value.Numerator & "/" & p.Value.Denominator
    ElseIf p.Type = StringImagePropertyType Then
        s = s & """" & p.Value & """"
    Else
        s = s & p.Value
    End If

    MsgBox s
Next
*/
Hochkomma="

ImgP:=Img.Properties()
if (IsObject(ImgP))
{
	for Key, Val in ImgP
	{
		; MsgBox % Key.Name "(" Key.PropertyID ")=" Val
		if(Key.IsVector)
		{
		}
		else if (Trim(Key.Type)="RationalImagePropertyType")
			MsgBox % Key.Value.Numerator	"/"	Key.Value.Denominator
		else if (Trim(Key.Type)="StringImagePropertyType")
		{
			; MsgBox % Key.Name "	" Hochkomma Key.Value Hochkomma
			if (Trim(Key.Value)<>"")
				s .= Key.Name "	" Hochkomma Key.Value Hochkomma "`n"
		}
		else
		{
			; MsgBox % Key.Name "	" Key.Value
			if (Trim(Key.Value)<>"")
				s .= Key.Name "	"  Key.Value 	"`n"
		}
		; if (Trim(Key.Type))<>""							; OK
			; MsgBox % Key.Type
		; 	s .= "Key.Type = " Key.Type	"`n"			; OK
	}
}
; Img := ComObjCreate("WIA.CommonDialog")	; OK z.B. zum Bilder machen siehe https://msdn.microsoft.com/de-de/library/windows/desktop/ms630826(v=vs.85).aspx#SharedSample007

; MsgBox, % s
return s
}
;}	

GetKlammerInhalt(StringMitKlammern,Auf="[",Zu="]")	;{()	
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
;}
GetDetailesOfOjects(Objects*)			; GetDetailesOfOjects(Obj1,Obj1Name , Obj2,Obj2Name , ...)	
{
	global GetObjectDetails_Zirkel
	for index,Obj in Objects
	{
		if (mod(index,2))			; ungerade
		{
			LastObj:=Obj
		}
		else
		{
			GetObjectDetails_Zirkel:=false
			; ObjName:=Obj
			DetailesOfOjects.=GetObjectDetails(LastObj,Obj) "`n"
			if GetObjectDetails_Zirkel
				DetailesOfOjects.=Obj " hat vermutlich eine Zirkulaere Referenz!`n"
		}
	}
	DetailesOfOjects.="`n"
	return DetailesOfOjects
}
GetObjectDetails(obj,ObjName="Nicht uebergebener Objekt-Name",Tiefe="") ; vor dem Aufruf kann die globale Variable GetObjectDetails_Zirkel:=false gestzt werden. Ist diese nach dem Aufruf true, dan besteht wahrscheinlich ein Zirkelbezug in der Ojekterzeugung. ;  Bases von Classes werden nicht angezeigt.
{
/*	Vor dem Funktionsaufruf koennen diese Variabeln gesetzt werden. fuer die erste 4 reicht eimaliges setzen.
GetObjectDetails_KKA:="["
GetObjectDetails_KKZ:="]"
GetObjectDetails_VKA:="["""
GetObjectDetails_VKZ:="""]"
    fuer [Key]	["Value"]
GetObjectDetails_Zirkel:=false
*/
	Global GetObjectDetails_KKA, GetObjectDetails_KKZ, GetObjectDetails_VKA, GetObjectDetails_VKZ, GetObjectDetails_Zirkel  , GetObjectDetails_Vorfahren ; ObjektPfad
	; static GetObjectDetails_Vorfahren
	if (not IsObject(obj))
	{
		if (StrLen(ObjName)>0)
			return ObjName "=	" obj
		else
			return obj
	}
	else if(ObjName="" or ObjName="Nicht uebergebener Objekt-Name")
	{
		if(obj.Name<>"")
			ObjName:=Obj.Name
	}
		
	else if (ObjName<>"")
	{
		ObjektPfad:=
		ObjektPfad:={}
		ObjektPfad:="RootObjekt"
		GetObjectDetails_Vorfahren := []
	}
; 	MsgBox % ObjektPfad
	If !Vorfahren.Haskey(&Obj)
		GetObjectDetails_Vorfahren[&Obj] := ObjektPfad

	if (StrLen(Tiefe)>25)
	{
		MsgBox %A_LineNumber%	Unerwarteter Programmzweig
		GetObjectDetails_Zirkel:=true
		return
	}
	if (StrLen(ObjName)>0)
	{
		Text:=ObjName "=`n"
		ObjName:=""
		Tiefe.=A_Tab
	}
	DieseTiefe:=Tiefe
	Tiefe.=A_Tab
	try
	{
		For KeyName, KeyValue in obj
		{
			ValDetails:=
			Details:=
			if (IsObject(KeyValue))
			{
				
			If GetObjectDetails_Vorfahren.HasKey(&KeyValue)
            {
               Text .= Tiefe . KeyName . "-> " . GetObjectDetails_Vorfahren[&KeyValue] . "`n"
			   GetObjectDetails_Zirkel:=true
               Continue
            }
				ObjektPfad.= "." KeyName
				Details:=GetObjectDetails(KeyValue,ObjName,Tiefe)
			}
			else
				ValDetails:=KeyValue
			if(ValDetails="")
				Text.=DieseTiefe GetObjectDetails_KKA KeyName GetObjectDetails_kKZ "`n"   Details 
			else
				Text.=DieseTiefe GetObjectDetails_KKA KeyName GetObjectDetails_kKZ "	" GetObjectDetails_VKA ValDetails GetObjectDetails_VKZ "`n"   Details 
		}
	}
	return Text
}

GetParent(Hwnd)	;{()	
{
	ID := DllCall("GetParent", UInt,WinExist("ahk_id " Hwnd)), ID := !ID ? WinExist("ahk_id " Hwnd) : ID
	return ID
}
;}	
GetParentClass(Hwnd,ParentBisHwnd="")	;{()	
{
	OldFormat:=A_FormatInteger
	SetFormat,IntegerFast,hex
	ParentHwnd:= GetParent(Hwnd)
	WinGetClass,ParentClass,ahk_id %ParentHwnd%
	SetFormat,IntegerFast,%OldFormat%
	return ParentHwnd "	" ParentClass
}
;}	
GetParentsHwndList(Hwnd,ParentBisHwnd="")	;{()	
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
;}	
GetPathInfo(Path1,NoCache=0)	;{()	besorgt und chached Zusatzinfos zu Pfaden
{
	; global Edit8Info
	; static PathInfos:={}
	PathInfos:={}
	DotLnkPos:=InStr(Path1,".lnk")
	if DotLnkPos
	{
		Path2:=substr(Path1,1,DotLnkPos+4)			; = DotLinkPath
		IfNotExist %Path2%
		{
			Path2:=FuehrendeSterneEntfernen(Path2)
			IfExist %Path2%
			{
				Path0:=2
			}
			else 
				Path0:=1
		}
		else
			Path0:=2
	}
	else
		Path0:=1
	if (Path0=2)
		Path2:=GetPathOrLinkedPath(Path1)
	loop % Path0
	{
		
		
		AusFuehrPfad%A_Index%:=FindExecutable(Path%A_Index%)
		if (AusFuehrPfad%A_Index%="" or Path%A_Index%="")
		{
			KannAusfuehren%A_Index%:=false
			KannAusgefuehrtWerden%A_Index%:=false
		}
		else if (AusFuehrPfad%A_Index%=Path%A_Index%)
		{
			KannAusfuehren%A_Index%:=true
			KannAusfuehren:=true
			KannAusfuehrenPfad:=AusFuehrPfad%A_Index%
			KannAusgefuehrtWerden%A_Index%:=false
		}
		else if (InStr(AusFuehrPfad%A_Index%,Path%A_Index%) or InStr(AusFuehrPfad%A_Index%,FuehrendeSterneEntfernen(Path%A_Index%)))
		{
			KannAusfuehren%A_Index%:=true
			KannAusfuehren:=true
			KannAusfuehrenPfad:=AusFuehrPfad%A_Index%
			KannAusgefuehrtWerden%A_Index%:=false
		}
		else if (AusFuehrPfad%A_Index%<>"" or Path%A_Index%<>"")
		{
			KannAusgefuehrtWerden%A_Index%:=true
			KannAusgefuehrtWerden:=true
			KannAusgefuehrtWerdenVon:=AusFuehrPfad%A_Index%
			KannAusfuehren%A_Index%:=false
		}
		else
		{
			MsgBox % A_LineNumber "	AusFuehrPfad = " AusFuehrPfad%A_Index%	"`nPfad" A_Index " = " A_Space Path%A_Index% "`nReturnwert noch versuchen zu ermitteln!"
		}
		Path%A_Index%:=FuehrendeSterneEntfernen(Path%A_Index%)
		IfExist % Path%A_Index%
			PathExist%A_Index%:=true
		if(PathExist%A_Index%)
		{
			DieserPfad:=Path%A_Index%
			FileGetAttrib,Attribute%A_Index%,%DieserPfad%
			; PathInfo[Path]["Attrib"]:=Attribute
			FileGetTime,TimeModi%A_Index%,%DieserPfad%
			FileGetTime,TimeCrea%A_Index%,%DieserPfad%,C
			if(InStr(Attribute%A_Index%,"D"))
			{
				IsDir%A_Index%:=true
				Size%A_Index%:=0
				SplitPath,Path%A_Index%,,,,Name%A_Index%
				PathInfos[A_Index] := {PAth: Path%A_Index%,Name: Name%A_Index%,IsDir: IsDir%A_Index%,Size: Size%A_Index%, Attrib: Attribute%A_Index%,TimeModi: TimeModi%A_Index%,TimeCrea: TimeCrea%A_Index%,KannAusfuehren: KannAusfuehren%A_Index%,AusFuehrPfad: AusFuehrPfad%A_Index%,KannAusgefuehrtWerden: KannAusgefuehrtWerden%A_Index%}

			}
			else
			{
				IsDir%A_Index%:=false
				FileGetSize,Size%A_Index%,%DieserPfad%
				SplitPath,DieserPfad,,,Ext%A_Index%,Name%A_Index%
				PathInfos[A_Index] := {PAth: Path%A_Index%,Name: Name%A_Index%,Ext: Ext%A_Index%,IsDir: IsDir%A_Index%,Size: Size%A_Index%, Attrib: Attribute%A_Index%,TimeModi: TimeModi%A_Index%,TimeCrea: TimeCrea%A_Index%,KannAusfuehren: KannAusfuehren%A_Index%,AusFuehrPfad: AusFuehrPfad%A_Index%,KannAusgefuehrtWerden: KannAusgefuehrtWerden%A_Index%}

			}
			; return PathInfos[Path]
/*
		}
		else if(substr(Path,1,7)="http://")
		{
	;		PathInfos[Path]:={}
			; PathInfos[Path] := {Path: Path}
			; Wahr:=true
			; PathInfos[Path] := {Path: Path,IsDir: IsDir,Size: Size, Attrib: Attribute,TimeModi: TimeModi,TimeCrea: TimeCrea}
			PathInfos[Path] := {Path: Path,ILink: 1}
			dummy:=
		}
		else if(substr(Path,1,8)="https://")
		{
	;		PathInfos[Path] := {}
			Wahr:=true
			PathInfos[Path] := {Path: Path,ILink: Wahr}
		}
		else
			PathInfos[Path] := {Path: Path,KannAusfuehren: KannAusfuehren,KannAusgefuehrtWerden: KannAusgefuehrtWerden,AusFuehrPfad: AusFuehrPfad}
		return PathInfos[Path]
*/
		}
	}
	PathInfos[3] := {KannAusgefuehrtWerden: KannAusgefuehrtWerden,KannAusgefuehrtWerdenVon: KannAusgefuehrtWerdenVon,KannAusfuehren: KannAusfuehren,KannAusfuehrenPfad: KannAusfuehrenPfad}

	return PathInfos
}
;}	
;}	
GetPathOrLinkedPath(Path)	;{()	gibt Path zurueck wenn Path kein .lnk ist sonst wird das Verweisziel des Links zurueckgegeben.
{
	SplitPath,Path,,,PathExt
	if (PathExt="lnk")
	{
		IfExist %Path%
		{
			FileGetShortcut,%Path%,NewPath
		}
		else
			NewPath:=Path
	}
	else
		NewPath:=Path
	return NewPath
}
;}	

; < ########################################## Hole die dem Suchwort entsprechenden Pfade aus dem Cache ######## >
GetPaths(Such,SucheAbrechen=20,FruehzeitigRueck="")	;{()	Das ist die Zentrale Funktion, sie holt aus den Caches die Pfade.
{	 
	global WoAn, beschaeftigt, SuchAbbruch,Edit1, Edit2, Edit3, Edit4, Edit5, Edit6, Edit7 ,Edit8,Edit9, SuFi, RegEx,AuAb,TimerBeiErgebnisFalschAktiv,TimerBeiErgeebnisUnsicherAktiv,Fehlersuche, SkriptDataPath, WurzelContainer, ZackData,HwndEdit2, LangsamDemo,AnEdit5Vorbei,FilePaqtternExtender,NurCacheFolderNr,SucheAbgebrochen,WortVorschlaege,WortVorschlagListe,Edit2CaretX,Edit2CaretY,NurInExistierendenStartPfadenSuchen

	
	FileDelete,%A_AppData%\Zack\WortVorschlagListe.txt

	SucheAbrechenMal100:=SucheAbrechen*100
	SucheAbgebrochen:=false
	GesPaths:=
	if (FilePaqtternExtender="")
		FilePaqtternExtender:="txt"
	SuchAbbruch:=false
	GuiControl,1: Move, Edit6, 	w40	h16
	BeschaeftigtAnzeige(1,A_ThisFunc)
	
	WortVorschlagsMenuShow:=false
	WortVorschlagListe:=
	WortVorschlagListeMiddl:=
	; FileDelete,%A_AppData%\Zack\WortVorschlagListe.txt
	WurzelIndexPath=%SkriptDataPath%\WurzelIndex.txt
	FileRead,WurzelIndex,% FuehrendeSterneEntfernen(WurzelIndexPath)
	if(SkriptDataPath="") 							; Chinesiche Zeichen Fehler hiermit behoben
	{
		BeschaeftigtAnzeige(-1,A_ThisFunc)
		return
	}
	WortVorschlagAnzahl:=0
	WortVorschlagMiddleAnzahl:=0
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
		if NurInExistierendenStartPfadenSuchen
		{
			; MsgBox % ThisCacheName
			StartPfadNummer:=SubStr(ThisCacheName,1,3)
			if StartPfadNummer is Integer
			{
				FileRead,DieserStartPfad,%SkriptDataPath%\Wurzel%StartPfadNummer%.txt
				loop,2
				{
					if(SubStr(DieserStartPfad,1,1)="+")
						StringTrimLeft,DieserStartPfad,DieserStartPfad,1
					if(SubStr(DieserStartPfad,0)="*")
						StringTrimRight,DieserStartPfad,DieserStartPfad,1
				}
				IfNotExist %DieserStartPfad%
				{
					; MsgBox % "not exist" ThisCacheName "	" DieserStartPfad
					continue
				}
			}
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
				; < auf AllesAbbrechen reagieren >
				if AllesAbbrechen
				{
					SucheAbgebrochen:=true
					ToolTip,,,,19
					AllesAbbrechen:=false
					break
				}
				if(A_Index=1)
					SucheAbrechenIndex:=1
				if WortVorschlaege
				{
					if((WortVorschlagAnzahl<9 or WortVorschlagMiddleAnzahl<9) and Edit2<>"")
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
								; if WortVorschlagsMenuShow
								;  Menu,WortVorschlagsMenu,Disable,WortVorschlagsMenuHandler%WortVorschlagAnzahl%
								; Menu,WortVorschlagsMenu,Show
								; SoundBeep
								; sleep 200
								; WinActivate,ahk_id %GuiWinHwnd%
							}
						}
						else if(InStr(A_LoopFileName,Edit2))
						{
							if A_LoopFileName not in %WortVorschlagListeMiddl%
							{
								WortVorschlagListeMiddl.="," A_LoopFileName 
								++WortVorschlagMiddleAnzahl
								; ToolTip,% SubStr(WortVorschlagListe,2)
								; Menu, WortVorschlagsMenu, Add, %A_LoopFileName%, WortVorschlagsMenuHandler%WortVorschlagAnzahl%,P-500
								; if WortVorschlagsMenuShow
								;  Menu,WortVorschlagsMenu,Disable,WortVorschlagsMenuHandler%WortVorschlagAnzahl%
								; Menu,WortVorschlagsMenu,Show
								; SoundBeep
								; sleep 200
								; WinActivate,ahk_id %GuiWinHwnd%
							}

							; FileDelete,%A_AppData%\Zack\WortVorschlagListe.txt
						}
					}
					; else
					; 	FileDelete,%A_AppData%\Zack\WortVorschlagListe.txt
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
									IfInString,A_LoopField,http
												
										GesPaths.= "`r`n" A_LoopField "		[" SubStr(A_LoopFileName,1,-4) "]"     ; , 							E2E7(A_LineNumber,Edit2,Edit7,GesPaths,0)
									else
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
											IfInString,A_LoopField,http
												
												GesPaths.= "`r`n" A_LoopField "		[" SubStr(A_LoopFileName,1,-4) "]"     ; , 							E2E7(A_LineNumber,Edit2,Edit7,GesPaths,0)
											else
												GesPaths.= "`r`n" A_LoopField    ; , 							E2E7(A_LineNumber,Edit2,Edit7,GesPaths,0)
												++SucheAbrechenIndex
											
										}
									}
								}
								else
								{
									; IfInString,A_LoopField,%Edit7%		; 
									if(ZeileEnthaelt(A_LoopField,Edit7))
									{
										IfInString,A_LoopField,http
											GesPaths.= "`r`n" A_LoopField "		[" SubStr(A_LoopFileName,1,-4) "]" ; , 							E2E7(A_LineNumber,Edit2,Edit7,GesPaths,0)
										else
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
					IfInString,LoopFieldInhalte,http

						GesPaths:=GesPaths  LoopFieldInhalte  "		[" SubStr(A_LoopFileName,1,-4) "]" ; , 							E2E7(A_LineNumber,Edit2,Edit7,GesPaths,0)
					else
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
	if WortVorschlaege
	{
		FileDelete,%A_AppData%\Zack\WortVorschlagListe.txt
		if(Edit2<>"")
		{
			if (WortVorschlagListe<>"")
				FileAppend,%Edit2CaretX%`,%Edit2CaretY%`r`n%WortVorschlagListe%,%A_AppData%\Zack\WortVorschlagListe.txt,utf-16
			else
			{
				if(Edit2CaretX<>"")
					FileAppend,%Edit2CaretX%`,%Edit2CaretY%`r`n,%A_AppData%\Zack\WortVorschlagListe.txt,utf-16
			}
			if (WortVorschlagListeMiddl<>"")
				FileAppend,%WortVorschlagListeMiddl%,%A_AppData%\Zack\WortVorschlagListe.txt,utf-16
		}
	}
If Fehlersuche
	MsgBox Getpaths() return
BeschaeftigtAnzeige(-1,A_ThisFunc)

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
;}	

	;{()	GetSelectedExplorerItems(ExplorerID="", ByRef Anzahl := 0); Ausgewählte Dateien aus dem übergebenen Explorerfenster auslesen.
; --------------------------------------------------------------------------------------------------
; Danke just me fuer die Vorlage. 	https://autohotkey.com/boards/viewtopic.php?f=9&t=9686
; Ausgewählte Dateien aus dem übergebenen Explorerfenster auslesen.
; wenn keines übergeben, dann aus allen auslesen.
; Die Funktion gibt eine durch "`r`n" getrennte Liste von Dateipfaden zurück.
; Im Parameter Anzahl wird ggf. die Anzahl der Dateien abgelegt.
; --------------------------------------------------------------------------------------------------
GetSelectedExplorerItems(ExplorerID="", ByRef FileAnzahl := 0, ByRef DirAnzahl := 0, ByRef DirPicAnz := 0) {
	global 
	NullOderEins:=false
	if (ExplorerID="")
		NullOderEins:=true
	FileAnzahl := 0
	DirAnzahl := 0
	DirPicAnz := 0			; drausen: DieseExplorerDirPicAnz
	SelectedItems := ""
	For Window In ComObjCreate("Shell.Application").Windows {
		try{
			If (NullOderEins OR (Window.HWND = ExplorerID)) && (Window.Document.SelectedItems.Count > 0) {
				For Item In Window.Document.SelectedItems {
					ItemPath:=Item.Path
					if InStr(FileExist(Item.Path ), "D") 
					{
						DirAnzahl++
						Loop,% ItemPath "\*.*",F
						{
							SplitPath,A_LoopFileLongPath,,,DieserExt
							if DieserExt in %IeBildExtList%
								DirPicAnz++
						}
					}
					else
						FileAnzahl++
					SelectedItems .= ItemPath . "`r`n"
				}
			}
		}
	}
	Return RTrim(SelectedItems, "`r`n") ; letzte 2 Zeichen "`r`n" entfernen
}
; AufrufBeispiele:
; #NoEnv
; ^+s::
;    WinGet, ExplorerID, ID, A
;    ; hier könnte man noch prüfen, ob das überhaupt ein Explorerfenster ist
;    Auswahl1 := GetSelectedItems(ExplorerID, Anzahl)
;    MsgBox, 0, %Anzahl% ausgewählte Datei(en), %Auswahl1%
;    Auswahl2 := GetSelectedItems(, Anzahl)
;    MsgBox, 0, %Anzahl% ausgewählte Datei(en), >%Auswahl2%<
; Return
;}	
; < / ######################################### Hole die dem Suchwort entsprechenden Pfade aus dem Cache ######## >
GetSel(TextOrPoses="Text",Control="",Win="A",AbPos=1)	;{()	
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
		MsgBox TextOrPoses=%TextOrPoses% wird (noch) nicht unterstuetzt.
	return Erg
}
;}	
GetZeile(Ges,Zeilennummer)	;{()	
{
	StringSplit,Zeile,Ges,`n,`r
	if (Zeilennummer=0)
		return 0
	else if(Zeilennummer>Zeile0)
		return 0
	else if (Zeilennummer="")
		return 0
	else if (Zeilennummer<0)
	{
		ListLines
		MsgBox %A_LineNumber% Unerwarteter SkriptZweig. Auffaellig: Zeilennummer >%Zeilennummer%< ist negativ
	}
	else
		return Zeile%Zeilennummer%
}
;}	
IfActiveWinTextOneOf(WinText*)	;{()	
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
;}	
; < ########################################## Ist Pfad ein benutzbarer Pfad ################################### >
IfAlleFileOderDirSyntax(Pfade)	;{()	Prueft Pfade primitiv. prueft vor Ablehnung auf existenz. d.h. kann nicht-Pfade durchlassen.
{
	StringSplit,Pfad,Pfade,`n,`r
	Loop % Pfad0
	{
		if(not IfFileOderDirSyntax(Pfad%A_Index%))
		{
			IfNotExist % Pfad%A_Index%
				return 0
		}
	}
	return 1
}
IfFileOderDirSyntax(Pfad)	;{()		Prueft Pfad primitiv
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
;}	
; < /######################################### Ist Pfad ein benutzbarer Pfad ################################### >
InAktFavSuchbegriffeEinfuegen:
MsgBox % "In " FavoritenDirPath "Es wurden " InFavSuchbegriffeEinfuegen(FavoritenDirPath) "Suchbegriffe ergaenzt"
return
InFavSuchbegriffeEinfuegen(FavDirPath)	;{()	fuegt in Favoiten die Suchbegriffe ein
{
	MsgBox, 262148, Favoriten                   [Suchbegriff], Favoriten `n%FavDirPath%`num Suchbegriffe erweitern?
	IfMsgBox,yes
	{
		DiesesA_now:=A_Now
		FileCopyDir,%FavDirPath%,%FavDirPath%%DiesesA_now%
		if not(InStr(FavDirPath,"!Fav"))
		{
			MsgBox nur Favoriten-Ordner zulaessig
			return 0
		}
		IfExist % FavDirPath
		{
			N:=0
			Loop, Files, %FavDirPath%\*.txt,F
			{
				M:=0
				FavInhaltNeu:=
				FileRead,FavInhalt,%A_LoopFileLongPath%
				Loop,Parse,FavInhalt,`n,`r
				{
					if(trim(A_LoopField)="")
						FavInhaltNeu.="`r`n"
					else if(InStr(A_LoopField,"		["))
						FavInhaltNeu.="`r`n"
					; NichtErlaubteZeichenErsetzen(PfadOhneSterne,NurDateiNamen="")
					else if(InStr(NichtErlaubteZeichenErsetzen(NurFuehrendeSterneWeg(A_LoopField)),SubStr(A_LoopFileName,1,-4)))
						FavInhaltNeu.="`r`n"						
					else
					{
						FavInhaltNeu.=A_LoopField "		[" SubStr(A_LoopFileName,1,-4) "]`r`n"
						++N
						++M
					}
				}
				if (M)
				{
					StringTrimRight,FavInhaltNeu,FavInhaltNeu,2
					FileDelete,%A_LoopFileLongPath%
					if ErrorLevel
						continue
					FileAppend,%FavInhaltNeu%,%A_LoopFileLongPath%,utf-16
				}
				else
					FileRemoveDir,%FavDirPath%%DiesesA_now%
			}
			return N
		}
	}
	return 0
}
;}	
;}	
IsDir(Path)	;{()	wenn Path ein Ordner wird true zurueck gegeben
{
	FileGetAttrib,FileDirektAttribute,% FuehrendeSterneEntfernen(Path)
	return InStr(FileDirektAttribute,"D")
}
;}	
IstKompilliert(OhneWarnMeldung="")	;{()	
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
			if (AbfrageFensterAntwort=0)
				return 0
			else if(SubStr(AbfrageFensterAntwort,1,1)=1)
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
;}	
ListGlobalVars()	;{()	erzeuge eine Liste der globlen Variablen 	von Lexikos
{
    static hwndEdit, pSFW, pSW, bkpSFW, bkpSW
    
    if !hwndEdit
    {
        dhw := A_DetectHiddenWindows
        DetectHiddenWindows, On
        Process, Exist
        ControlGet, hwndEdit, Hwnd,, Edit1, ahk_class AutoHotkey ahk_pid %ErrorLevel%
        DetectHiddenWindows, %dhw%
        
        astr := A_IsUnicode ? "astr":"str"
        ptr := A_PtrSize=8 ? "ptr":"uint"
        hmod := DllCall("GetModuleHandle", "str", "user32.dll", ptr)
        pSFW := DllCall("GetProcAddress", ptr, hmod, astr, "SetForegroundWindow", ptr)
        pSW := DllCall("GetProcAddress", ptr, hmod, astr, "ShowWindow", ptr)
        DllCall("VirtualProtect", ptr, pSFW, ptr, 8, "uint", 0x40, "uint*", 0)
        DllCall("VirtualProtect", ptr, pSW, ptr, 8, "uint", 0x40, "uint*", 0)
        bkpSFW := NumGet(pSFW+0, 0, "int64")
        bkpSW := NumGet(pSW+0, 0, "int64")
    }

    if (A_PtrSize=8) {
        NumPut(0x0000C300000001B8, pSFW+0, 0, "int64")  ; return TRUE
        NumPut(0x0000C300000001B8, pSW+0, 0, "int64")   ; return TRUE
    } else {
        NumPut(0x0004C200000001B8, pSFW+0, 0, "int64")  ; return TRUE
        NumPut(0x0008C200000001B8, pSW+0, 0, "int64")   ; return TRUE
    }
    
    ListVars
    
    NumPut(bkpSFW, pSFW+0, 0, "int64")
    NumPut(bkpSW, pSW+0, 0, "int64")
    
    ControlGetText, text,, ahk_id %hwndEdit%

    RegExMatch(text, "sm)(?<=^Global Variables \(alphabetical\)`r`n-{50}`r`n).*", text)
    return text
}
;}
MarkiereSuchtext(Suchtext,Control="",Win="A",AbPos=1,OnlyFirstChar=0)	;{()	
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
;}	
MarkiereVonBis(Pos1=1,Pos2=99999999,Control="",Win="A",AbPos=1)	;{()	
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
;}	
MultiFileInhalt2TextDir(MultiFilePath,DirPath)	;{()	
{
	BeschaeftigtAnzeige(1,A_ThisFunc)
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
	BeschaeftigtAnzeige(-1,A_ThisFunc)
	return ErzeugeFehler
}
;}	
NachStrLen(a,b)	;{()	
{
	if (StrLen(a)>StrLen(b))
		return 1
	else if (StrLen(a)=StrLen(b))
		return 0
	else
		return -1
}
;}	
NachMTime(a,b)	;{()	neu +1
{
	aa:=FuehrendeSterneEntfernen(a)
	bb:=FuehrendeSterneEntfernen(b)
	FileGetTime,Mta,%aa%
	if ErrorLevel
		Erra:=true
	FileGetTime,Mtb,%bb%
	if ErrorLevel
		Errb:=true
	; MsgBox % aa "	" bb "	" Erra "	" Errb
	if(Erra AND Errb)
		return 0
	if Erra
		return 1
	if Errb
		return -1
	if (Mta>Mtb)
		return -1
	else if (Mta=Mtb)
		return 0
	else
		return 1
}
;}	
NachMTimeR(a,b)	;{()	alt +1
{
	aa:=FuehrendeSterneEntfernen(a)
	bb:=FuehrendeSterneEntfernen(b)
	FileGetTime,Mta,%aa%
	if ErrorLevel
		Erra:=true
	FileGetTime,Mtb,%bb%
	if ErrorLevel
		Errb:=true
	if(Erra AND Errb)
		return 0
	if Erra
		return 1
	if Errb
		return -1
	if (Mta<Mtb)
		return -1
	else if (Mta=Mtb)
		return 0
	else
		return 1
}
;}	
NichtErlaubteZeichenErsetzen(PfadOhneSterne,NurDateiNamen="")	;{()	
{
	global FehlerSuche
	if(NurDateiNamen="")		; nur Dateinamen wurden uebergeben bei 1
		NurDateiNamen:=0		; vollstaendige Pfade wurden uebergeben bei 0
	StringReplace,PfadOhneSterne,PfadOhneSterne,:,˸,All
	StringReplace,PfadOhneSterne,PfadOhneSterne,/,⁄,All
	StringReplace,PfadOhneSterne,PfadOhneSterne,?,Ɂ,All
	StringReplace,PfadOhneSterne,PfadOhneSterne,|,│,All
	StringReplace,PfadOhneSterne,PfadOhneSterne,<,˂,All
	StringReplace,PfadOhneSterne,PfadOhneSterne,>,˃,All
	StringReplace,PfadOhneSterne,PfadOhneSterne,*,°,All
	StringReplace,PfadOhneSterne,PfadOhneSterne,*,°,All
	StringReplace,PfadOhneSterne,PfadOhneSterne,=,ist,All
	if NurDateiNamen
		StringReplace,PfadOhneSterne,PfadOhneSterne,\,►,All ; darf ich auf Pfad-Ebene nicht machen
	return PfadOhneSterne
}
;}	
NurFuehrendeSterneWeg(Path)	;{()	Favoriten-Sterne entfernen
{
Loop 10
{
	if(SubStr(Path,1,1)<>"*")
	{
		SterneWeg:=A_Index-1
		break
	}
}
StringTrimLeft,PathNurSternlos,Path,SterneWeg
return PathNurSternlos
}
;}
OeffnenMitDateiPfade(DateiPfade,Zielpfad)	;{()	
{
	global AllesAbbrechen
	Zielpfad:=FuehrendeSterneEntfernen(Zielpfad)
	Zielpfad:=GetPathOrLinkedPath(Zielpfad)
	ZielpfadInfo:=GetPathInfo(Zielpfad)
	if(ZielpfadInfo.3.KannAusfuehren)
	; if(FileExist(Zielpfad) and not InStr(FileExist(Zielpfad), "D"))
	{
		OeffnenMitKontrollFrage:=true
		StringSplit,DieseDateiPfadAnzahl,DateiPfade,`n,`r
		Loop,Parse,DateiPfade,`n,`r
		{
			; < auf AllesAbbrechen reagieren >
			Sleep -1
			if AllesAbbrechen
			{
				AllesAbbrechen:=false
				break
			}
			if(substr(A_LoopField,-3)=".lnk")
			{
				FileGetShortcut,%A_LoopField%,ThisLoopField
			}
			else
			{
				ThisLoopField:=A_LoopField
			}
			if OeffnenMitKontrollFrage
			{
				FuncEinstellungen := {DefaultButton: 1, EditReadOnly: 1, DisableMainWindow: 1}
				DieseAntwort:=AbfrageFenster(FuncEinstellungen, "So Ausführen?",A_LineNumber "`nVorgesehener Programm-Start (" A_Index " von " DieseDateiPfadAnzahl0 "):`n`nRun " Zielpfad " " ThisLoopField, "OK, mit Nachfrage","überspringen",">>>>>>>>>>>>>>>>>>>>>>>>>>>OK ohne Nachfrage",">>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>abbrechen",">>>>>>>>>>>>>>>>>>>RunWait")
				if (DieseAntwort=0)
					return 1
				else if (SubStr(DieseAntwort,1,1)="1")
				{
					Run "%Zielpfad%"  "%ThisLoopField%"
				}
				else if (SubStr(DieseAntwort,1,1)="3")
				{
					Run "%Zielpfad%"  "%ThisLoopField%"
					OeffnenMitKontrollFrage:=false
				}
				else if (SubStr(DieseAntwort,1,1)="4")
					return 1
				else if (SubStr(DieseAntwort,1,1)="5")
				{
					; MsgBox RunWait "%Zielpfad%"  "%ThisLoopField%"
					RunWait "%Zielpfad%"  "%ThisLoopField%"
					OeffnenMitKontrollFrage:=false
				}

			}
			else if (SubStr(DieseAntwort,1,1)="5")
				{
					RunWait "%Zielpfad%"  "%ThisLoopField%"
				}
			else
				Run "%Zielpfad%"  "%ThisLoopField%" 
		}
		return 1
	}
	else if(InStr(Zielpfad,"`%E8`%"))
	{
		OeffnenMitKontrollFrage:=true
		StringSplit,DieseDateiPfadAnzahl,DateiPfade,`n,`r
		Loop,Parse,DateiPfade,`n,`r
		{
			; < auf AllesAbbrechen reagieren >
			Sleep -1
			if AllesAbbrechen
			{
				AllesAbbrechen:=false
				break
			}
			E8:=A_LoopField
			Transform,ThisLoopField,Deref,%Zielpfad%
			if OeffnenMitKontrollFrage
			{
				FuncEinstellungen := {DefaultButton: 1, EditReadOnly: 1, DisableMainWindow: 1}
				DieseAntwort:=AbfrageFenster(FuncEinstellungen, "So Ausführen?",A_LineNumber "`nVorgesehener Programm-Start (" A_Index " von " DieseDateiPfadAnzahl0 "):`n`nRun " ThisLoopField , "OK, mit Nachfrage","überspringen",">>>>>>>>>>>>>>>>>>>>>>>>>>>OK ohne Nachfrage",">>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>abbrechen",">>>>>>>>>>>>>>>>>>>RunWait")
				if (DieseAntwort=0)
					return 1
				else if (SubStr(DieseAntwort,1,1)="1")
				{
					Run %ThisLoopField%
				}
				else if (SubStr(DieseAntwort,1,1)="3")
				{
					Run %ThisLoopField%
					OeffnenMitKontrollFrage:=false
				}
				else if (SubStr(DieseAntwort,1,1)="4")
					return 1
				else if (SubStr(DieseAntwort,1,1)="5")
				{
					; MsgBox RunWait %ThisLoopField%
					RunWait %ThisLoopField%
					OeffnenMitKontrollFrage:=false
				}
			}
			else if (SubStr(DieseAntwort,1,1)="5")
				{
					RunWait  %ThisLoopField%
				}
			else
				Run %ThisLoopField% 
			

		}
		return 1
	}
	return 0
}
;}	
OnlyVarChar(String)	;{()	
{
	StringSplit,Zeichen,String
	Loop % Zeichen0
	{
		if Zeichen%A_Index% is alnum
			VarNameString .= Zeichen%A_Index%
	}
	return VarNameString	
}
;}
OpenInScite(Path,ZeilenNr,Suchtext)	;{()	
{
	global ScitePath, HochKomma,Edit2,Filekenner,NrRowkenner
	static DieseEditorPid
	; ListVars
	HalbOunten:="ᵕ"
	if(ScitePath="")
	{
		ScitePath=%A_ProgramFiles%\AutoHotkey\SciTE\SciTE.exe
		IfNotExist %ScitePath%
		{
			IfExist %A_ScriptDir%\ScitePath.txt
				FileRead,ScitePath,%A_ScriptDir%\ScitePath.txt
			else
			{
				FileSelectFile,ScitePath,,%A_ProgramFiles%,ProgrammDatei von Scite (zur Not Notepad) wird benoetigt,Proramme(*.exe)
				IfExist %ScitePath%
				{
					FileDelete,%A_ScriptDir%\ScitePath.txt
					FileAppend,%ScitePath%,%A_ScriptDir%\ScitePath.txt
				}
			}
		}
	}
	IfExist %ScitePath%
	{
		{
			if(InStr(Edit2,Filekenner) and InStr(Edit2,NrRowkenner))
			{
				StringTrimLeft,Pfad,Edit2,% StrLen(Filekenner)
				NrRowkennerPos:=InStr(Pfad,NrRowkenner)
				Pfad:=SubStr(Pfad,1,NrRowkennerPos-2)
				IfNotExist %Path%
				{
					IfExist %Pfad%
						Path:=Pfad
				}
				else if (Pfad<>Path)
					MsgBox % A_LineNumber "Hier sollte das Skript nur landen`,wenn ein Falscher Quelltext-Pfad `n>" Path "<`n>" Pfad "<`n uebergeben wurde.`n" A_ThisLabel "`n" A_ThisHotkey "`n" A_ThisMenu "`n"  A_ThisMenuItem "`n" A_ThisMenuItemPos
			}
			else if(Path="")
			{
				; hierher kommt das Skript beim aufrufen einer Quelltext-Zeile im ControlTextKenner (CoTe://) Modus
				; MsgBox % A_LineNumber "Hier sollte das Skript nur landen`,wenn kein Quelltext-Pfad uebergeben wurde.`n" A_ThisLabel "`n" A_ThisHotkey "`n" A_ThisMenu "`n"  A_ThisMenuItem "`n" A_ThisMenuItemPos
			}
		}
		; MsgBox %Edit2%`nRun "%ScitePath%" "%Path%" -goto:%ZeilenNr% -find:%Suchtext%
		if(InStr(ScitePath,"Scite"))
		{			
			if(InStr(Suchtext,Hochkomma))
			{
				; StringSplit,OhneHochKomma,Suchtext," ,,All	; gesucht laengster zusammenhaengender Text ohne Hochkomma					; diese Zeile ist in Version 369 das erste mal gesichtet durchgehend bis Version 0.653 festgestellt via	FilP://C:\Program Files (x86)\ZackZackOrdner\*ØØ¯.ahk¯ØØ*,Ø¯DFR¯Ø`vInInhQ? Ø¯StringSplit`n⁞OhneHochKomma`nSuchtext¯Ø
				; drueber wurde durch drunter ersetzt: testen	testen	testen	testen	testen	testen	testen	testen	testen	testen	testen	testen	testen	testen	testen	testen	testen	testen	testen	testen	testen	testen	testen	testen	testen	testen	testen	testen	testen	testen	testen	testen	testen	testen	testen	testen	testen	testen	testen	testen	testen	testen	testen	testen	testen	testen	testen	testen	testen	testen	testen	
				StringSplit,OhneHochKomma,Suchtext,%HochKomma%,,All	; gesucht laengster zusammenhaengender Text ohne Hochkomma
				; SoundBeep
				OhneHochKommaNr:=1
				loop % OhneHochKomma0+1
				{
					if(a_index=1)
						continue
					if(StrLen(OhneHochKomma%a_index%) > StrLen(OhneHochKomma%OhneHochKommaNr%))
						OhneHochKommaNr:=a_index
				}
				Suchtextgekuerzt:=OhneHochKomma%OhneHochKommaNr%
				ToolTip, % Suchtextgekuerzt
				Run, "%ScitePath%" "%Path%" -goto:%ZeilenNr% `"-find:%Suchtextgekuerzt%`",,,DieseEditorPid	; 				
			}
			else
			{
				Run, "%ScitePath%" "%Path%" -goto:%ZeilenNr% `"-find:%Suchtext%`",,,DieseEditorPid	;
			}

			return 1
		}
		else  if(InStr(ScitePath,"Notepad.exe"))
		{
			Process,Exist,%DieseEditorPid%
			if (ErrorLevel and DieseEditorPid<>"")
			; IfWinExist ahk_pid %DieseEditorPid%
				WinActivate ahk_pid %DieseEditorPid%
			else
				Run, "%ScitePath%" "%Path%" ,,,DieseEditorPid
			; MsgBox % DieseEditorPid
			WinWaitActive,ahk_pid %DieseEditorPid%,,2
			sleep 100
			send {CtrlDown}g{CtrlUp}
			WinWaitActive,G,,1
			IfWinActive G
			{
				sleep 400
				send %ZeilenNr%
			}
			else IfWinActive g
			{
				sleep 400
				send %ZeilenNr%
			}
			return
		}
		else
		{	; hier können Anpassungen fuer andere Editoren gemacht werden. Oder man verwendet ein Adapterskript, welche den Aufruf von ZZO in einen Aufruf Wandelt, welcher vom Zieleditor verstanden wird.
			if(InStr(Suchtext,Hochkomma))								; vom Anwender bearbeitbar
			{										; vom Anwender bearbeitbar
				StringSplit,OhneHochKomma,Suchtext,",,All	; gesucht laengster zusammenhaengender Text ohne Hochkomma	; vom Anwender bearbeitbar
				OhneHochKommaNr:=1							; vom Anwender bearbeitbar
				loop % OhneHochKomma0+1							; vom Anwender bearbeitbar
				{									; vom Anwender bearbeitbar
					if(a_index=1)							; vom Anwender bearbeitbar
						continue							; vom Anwender bearbeitbar
					if(StrLen(OhneHochKomma%a_index%) > StrLen(OhneHochKomma%OhneHochKommaNr%))	; vom Anwender bearbeitbar
						OhneHochKommaNr:=a_index					; vom Anwender bearbeitbar
				}									; vom Anwender bearbeitbar
				Suchtextgekuerzt:=OhneHochKomma%OhneHochKommaNr%				; vom Anwender bearbeitbar
				Run, "%ScitePath%" "%Path%" -goto:%ZeilenNr% `"-find:%Suchtextgekuerzt%`",,,DieseEditorPid	; vom Anwender bearbeitbar		
			}										; vom Anwender bearbeitbar
			else										; vom Anwender bearbeitbar
				Run, "%ScitePath%" "%Path%" -goto:%ZeilenNr% `"-find:%Suchtext%`",,,DieseEditorPid	; vom Anwender bearbeitbar	
			return 1										; vom Anwender bearbeitbar
		}
	}
	else
		return 0
}
;}
PfadListe2HtmlListe(PfadListe)	;{()	
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
;}	
QuellTextNummernWeg(NrQuellText)	;{()	erzeugt Quelltext-Ansicht mit ZeilenNummern
{
	HalbOunten:="ᵕ"
	if(SubStr(NrQuellText,9,2)= HalbOunten HalbOunten)	; Probe ganz vorne
	{
		StringSplit,Zeile,NrQuellText,`n,`r
		if(SubStr(Zeile%Zeile0%,9,2)<> HalbOunten HalbOunten)	; Probe letzte Zeile
			return NrQuellText
		
		Loop % Zeile0
		{
			Ges.=SubStr(Zeile%A_Index%,11) "`r`n"
		}
		return Ges
	}
	else
		return NrQuellText
}
;}
RunOtherAhkScriptOrExe(StartScriptPath,UebergabeParameter*)	;{()	
{
		
	global RunPid, NurExeStartErlaubt

	Hochkomma="
	if(SubStr(A_AhkPath,1,-3) <> SubStr(A_ScriptFullPath,1,-3))
		AhkViaGleichnamigeExeGestartet:=false
	else
		AhkViaGleichnamigeExeGestartet:=true
 	if Fehlersuche
		MsgBox % StartScriptPath  "`n"  SubStr(A_AhkPath,1,-3) "`n" AhkViaGleichnamigeExeGestartet "`n" SubStr(A_ScriptFullPath,1,-3)

	
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
			ThreadUeberwachungLog(A_LineNumber-1,AlleUebergabeParameter,A_ThisLabel,A_ThisFunc,UebergabeParameter[A_Index],A_ThisMenuItem,A_ThisMenuItemPos)
;	if (StartScriptExt="ahk")
;		StartScriptAhkPath:=StartScriptPath
	}
	SplitPath,StartScriptPath,StartScriptFileName,StartScriptDir,StartScriptExt,StartScriptNameNoExt
	if (StartScriptExt="ahk")
	{
		StartScriptAhkPath:=StartScriptPath
		StartScriptExePath:=StartScriptDir "\" StartScriptNameNoExt ".exe"
	}
	else if (StartScriptExt="exe")
	{
		StartScriptAhkPath:=StartScriptDir "\" StartScriptNameNoExt ".ahk"
		StartScriptExePath:=StartScriptPath
	}

	try
	{
		if AhkViaGleichnamigeExeGestartet
			run, %StartScriptExePath% %Hochkomma%%StartScriptAhkPath%%Hochkomma% %AlleUebergabeParameter%,,UseErrorLevel, RunPid
		else
			run, %StartScriptAhkPath% %AlleUebergabeParameter%,,UseErrorLevel, RunPid
	}
;	catch
;	{
;		try
;			run, %StartScriptExePath% %Hochkomma%%StartScriptAhkPath%%Hochkomma% %AlleUebergabeParameter%,,UseErrorLevel, RunPid
;	}
	if (RunPid="")
	{
		IfNotExist %StartScriptAhkPath%
			MsgBox, 262160, %A_LineNumber% Fehler bei Skriptstart, %StartScriptAhkPath% nicht vorhanden!
		if AhkViaGleichnamigeExeGestartet
		{
			IfNotExist %StartScriptExePath%
				MsgBox, 262160, %A_LineNumber% Fehler bei Skriptstart, %StartScriptExePath% nicht vorhanden!
			
		}

	}
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
RunOtherAhkScriptWeg(StartScriptPath,UebergabeParameter*)	;{()	
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
;}	
RunWaitCmdEin(Befehl) {	;{()	startet CMD mit Befehl gibt Ausgabe zurueck
    ; WshShell-Objekt: http://msdn.microsoft.com/en-us/library/aew9yb99
    shell := ComObjCreate("WScript.Shell")
    ; Führt einen einzelnen Befehl via cmd.exe aus. sehr gute Einfuerung in DOS http://www.netzmafia.de/skripten/bs/dos.html
    exec := shell.Exec(ComSpec " /C " Befehl)
    ; Liest die Ausgaben aller Befehle und gibt sie zurück
    return exec.StdOut.ReadAll()
}
;}	
RunWaitPsViele(Befehle) {	;{()	startet CMD mit Befehlen (je Befehl eine Zeile) gibt Ausgabe zurueck			
    shell := ComObjCreate("WScript.Shell")	; https://ss64.com/nt/syntax.html
    ; Öffnet cmd.exe mit deaktivierter Textanzeige
    exec := shell.Exec("Powershell.exe"  " /U /Q /K echo off")
	; SoundBeep
    ; Sendet die Befehle, die ausgeführt werden sollen, getrennt durch Newline
    exec.StdIn.WriteLine(Befehle "`nexit")  ; Immer ein Exit am Ende!
    ; Liest die Ausgaben aller Befehle und gibt sie zurück
    return exec.StdOut.ReadAll()
}
;}	
TestsRunWaitPsEin(Befehl) {	;{()	startet Powershell mit Befehl gibt Ausgabe zurueck	
	global Edit5, Edit1, Edit6
    ; WshShell-Objekt: http://msdn.microsoft.com/en-us/library/aew9yb99
	;  Befehl.="  EXIT"
	; DllCall("AllocConsole")
	; WinHide % "ahk_id " DllCall("GetConsoleWindow", "ptr")
	; Textvergleichs-Beispiel nackter PS Befehl
	; Compare-Object -ReferenceObject $(Get-Content "C:\Program Files (x86)\ZackZackOrdner\SchnellOrdner?0.522Hscroll?.ahk") -DifferenceObject $(Get-Content "C:\Program Files (x86)\ZackZackOrdner\SchnellOrdner?0.524?.ahk") > c:\temp\compareOut.txt
	HK ="
    shell := ComObjCreate("WScript.Shell")
    ; Führt einen einzelnen Befehl via cmd.exe aus
   ; exec := shell.Exec("Powershell.exe" " /C /U /Q /K " Befehl)
;    exec := shell.Exec("Powershell.exe" " /C " Befehl)
   ; exec := shell.Exec("Powershell.exe" " /C /Q " Befehl)
   ; exec := shell.Exec("Powershell.exe" " /C  /Q /K " Befehl)
   ; exec := shell.Exec("Powershell.exe" " /C /U /K " Befehl)
   ; exec := shell.Exec("Powershell.exe" " /C /U /Q " Befehl)
   ; exec := shell.Exec("Powershell.exe" " /C /K " Befehl)
   ; exec := shell.Exec("Powershell.exe" " /C /U " Befehl)
   ; exec := shell.Exec("Powershell.exe" " /C  /K " Befehl)
   ; exec := shell.Exec("Powershell.exe" " /Q /K " Befehl)
   ; exec := shell.Exec("Powershell.exe" " /C /U  " Befehl)
   ; exec := shell.Exec("Powershell.exe" " /K " Befehl)
   ; exec := shell.Exec("Powershell.exe" " /Q  " Befehl)
   ; exec := shell.Exec("Powershell.exe" " /U  " Befehl)
   ; exec := shell.Exec("Powershell.exe" " /C /U /Q /K " Befehl)
   ; exec := shell.Exec("Powershell.exe" A_Space "/C" A_Space HK Befehl HK)
   ; powershell -noexit "& ""C:\my_path\yada_yada\run_import_script.ps1""" (enter)
   ; exec := shell.Exec("Powershell.exe" A_Space "/C" A_Space HK Befehl HK (enter) "EXIT")
   ; PowerShell -Command {Get-EventLog -LogName security}
   ; exec := shell.Exec("Powershell.exe" A_Space "/C" A_Space HK -Command "{" Befehl "}" HK (enter) "EXIT")
   ; exec:=shell.Exec("Powershell.exe /Q /K echo off")
   ;    exec := shell.Exec("Powershell.exe" " /C " Befehl)
exec:=shell.Exec("%comspec%  /K ")
; exec.StdIn.WriteLine("Dir")
; MsgBox vor Powershell
; exec.StdIn.WriteLine("cmd")
; exec.StdIn.WriteLine("echo Hopla")
exec.StdIn.WriteLine("Powershell")
sleep 30
exec.StdIn.WriteLine("CLS")
; exec.StdIn.WriteLine("echo Hopla")

   ;  exec:=shell.Exec("Powershell.exe /C" )
   ; exec.StdIn.WriteLine("Help")
   ; exec.StdIn.WriteLine("exit")
    MsgBox % Befehl
	; Befehl=Dir
   exec.StdIn.WriteLine(Befehl)
   ; exec.StdIn.WriteLine(" -OutputFormat XML " Befehl)
   exec.StdIn.WriteLine("echo Hopla")

   ; exec.StdIn.WriteLine("exit")
    ; Liest die Ausgaben aller Befehle und gibt sie zurück
	ii:=0
	iiEdit5Max:=Edit6*4
	loop {
		DiesePSZeile:=exec.StdOut.ReadLine()
		if (InStr(DiesePSZeile,"Hopla"))
			break
		Edit5.=sOutput "`n" DiesePSZeile
	; 	SoundBeep
		++ii
		if(SubStr(ii,0,1)="0")
		; if(SubStr(ii,-1,2)="00")
		{
			if (A_Index<iiEdit5Max)
				gosub Edit5Festigen
			Edit1:=ii
			gosub Edit1Festigen
		}
	} until exec.StdOut.atEndOfStream
	gosub Edit5Festigen
	gosub Edit1Festigen

	MsgBox Eingelesen
	exec.StdIn.WriteLine("exit")
	exec.StdIn.WriteLine("exit")

     return Edit5
}
;}	

RunWaitPsEin(Befehl) {	;{()	startet Powershell mit Befehl gibt Ausgabe zurueck	
    ; WshShell-Objekt: http://msdn.microsoft.com/en-us/library/aew9yb99
    shell := ComObjCreate("WScript.Shell")
    ; Führt einen einzelnen Befehl via cmd.exe aus
    exec := shell.Exec("Powershell.exe" " /C " Befehl)
	; https://docs.microsoft.com/de-de/powershell/scripting/core-powershell/console/powershell.exe-command-line-help?view=powershell-5.1
    ; Liest die Ausgaben aller Befehle und gibt sie zurück
    return exec.StdOut.ReadAll()
}
;}	
RunWaitCmdViele(Befehle) {	;{()	startet Powershell mit Befehlen (je Befehl eine Zeile) gibt Ausgabe zurueck		
    shell := ComObjCreate("WScript.Shell")
    ; Öffnet cmd.exe mit deaktivierter Textanzeige
    exec := shell.Exec(ComSpec " /U /Q /K echo off")
	; SoundBeep
    ; Sendet die Befehle, die ausgeführt werden sollen, getrennt durch Newline
    exec.StdIn.WriteLine(Befehle "`nexit")  ; Immer ein Exit am Ende!
    ; Liest die Ausgaben aller Befehle und gibt sie zurück
    return exec.StdOut.ReadAll()
}
;}	
SaveE8E5(GetOderSet="")	;{()	
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
;}	
SetAutoFavorit(PfadMitSternen,OrdnerNeuAnlage,FavoritenDirPath,AutoFavorit)	;{()	
{
	BeschaeftigtAnzeige(1,A_ThisFunc)
	global Edit8
	; if OrdnerNeuAnlage					; 0 oder 1
	if((StrLen(Edit8)-StrLen(FuehrendeSterneEntfernen(Edit8))) = AutoFavorit)
		SetFavorit(PfadMitSternen,1,"BehaltePfad",FavoritenDirPath,AutoFavorit)
	else if((StrLen(Edit8)-StrLen(FuehrendeSterneEntfernen(Edit8))) < AutoFavorit)
		SetFavorit(PfadMitSternen,1,"BehaltePfad",FavoritenDirPath,AutoFavorit)
	BeschaeftigtAnzeige(-1,A_ThisFunc)
	return
}
;}	
SetFavorit(PfadMitSternen,DeltaSterne,ExtraAnweisung,FavoritenDirPath,AutoFavorit)	;{()	
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
;}	
Sleep(Delay)	;{()	
{
	sleep, %Delay%
	return
}
;}	
ThisStringReplace(InputVar,SearchText="",ReplaceText="",All="")	;{()	Kurz:	siehe <a href="http://de.autohotkey.com/docs/commands/StringReplace.htm">StringReplace.htm</a>	Eingang: -
{
	global
StringReplace,OutputVar,InputVar,%SearchText%,%ReplaceText%,%All%
If Fehlersuche
	MsgBox, 262144, %A_ScriptName% at %A_LineNumber% in der Funktion, %SearchText%`,%ReplaceText%`,%All%
 Return OutputVar
}
;}	
TextDir2MultiFileInhalt(DirPath,OnlyExt="*")	;{()	
{
	BeschaeftigtAnzeige(1,A_ThisFunc)
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
	BeschaeftigtAnzeige(-1,A_ThisFunc)
	return MultiFileInhalt	
}
;}	
; WinActivateted()	;{()	; Auskommentiert zu Gunsten des Debuggers: wo beginnt ein neuer Thread
; {
; global HwndEdit2
; ; ControlFocus,,ahk_id %HwndEdit2%	; Edit2 erhält beim Aktivieren den Fokus
; FokusEdit2Rechts()
; return
; }
;}	
WinConIndex(WinHwnd="",GetLocalVar="")	;{()	1.) indiziert Variablen mit Control-Informationen und erstellt daraus eine moeglichst uebersichtiche HTML-Tabelle  2.) speichert die Variablen und gibt sie auf verlangen aus. Die 1. Uebergabe-Variable ist in diesem Falle zwar zu uebergeben (als Dummy), sie wird jedoch momentan weder einwaerts noch auswaerts benutzt.
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
;}	
ZaehleZeilen(Ges)	;{()	
{
	StringReplace,dummy,Ges,`n,,UseErrorLevel
	ZeilenZahl:=ErrorLevel+1
	If(Ges="")
		ZeilenZahl:=0
	return ZeilenZahl
}
;}
ZeileEnthaelt(Zeile,SuchListCR)	;{()	Wichtige Funktiom zum Nachfiltern mit , -> ODER-Trenner 	`n -> UND-Trenner
; ZeileEnthaelt1or0SuchListCR(Zeile,SuchListCR)	;{()	Wichtige Funktiom zum Nachfiltern mit , -> ODER-Trenner 	`n -> UND-Trenner

{
	global GrossKlein
	Komma=,
	try
		Transform,SuchListCR,Deref,%SuchListCR%
	if(InStr(SuchListCR,Komma) OR InStr(SuchListCR,"`n"))
	{
		Loop, Parse,SuchListCR,`n,`r
		{
			i:=A_Index
			DieseZeile:=false
			Pos%i%:=InStr(A_LoopField,",¬")
			if (Pos%i%="¬" or SubStr(A_LoopField,1,1)="¬")
			{
				Loop,Parse,A_LoopField,`,
				{
					if (SubStr(A_LoopField,1,1)="¬" AND NOT InStr(Zeile,SubStr(A_LoopField,2),GrossKlein))	
					{
						DieseZeile:=true
						break
					}
					if (NOT SubStr(A_LoopField,1,1)="¬" AND InStr(Zeile,SubStr(A_LoopField,2),GrossKlein))	
					; else if(InStr(Zeile,A_LoopField,GrossKlein))
					{
						DieseZeile:=true
						break
					}
				}
				if Not DieseZeile
					return false
			}
			else
			{
				if Zeile contains %A_LoopField%
				{
;					return true
				}
				else
					return false
			}
		}

		return true
	}
	else
	{
		if (SubStr(SuchListCR,1,1)="¬" AND NOT InStr(Zeile,SubStr(SuchListCR,2),GrossKlein))	
			return true
		if(InStr(Zeile,SuchListCR,GrossKlein))
		{
			return true
		}
	}
	return false
}
/*
ZeileEnthaeltWeg(Zeile,SuchListCR)	;{()	Wichtige Funktiom zum Nachfiltern mit , -> ODER-Trenner 	`n -> UND-Trenner
{
	global GrossKlein
	Komma=,
	try
		Transform,SuchListCR,Deref,%SuchListCR%
	if(InStr(SuchListCR,Komma) OR InStr(SuchListCR,"`n"))
	{
		Loop, Parse,SuchListCR,`n,`r
		{
			if(SubStr(A_LoopField,1,1)="-")
			{
				StringTrimLeft,LoopField,A_LoopField,1
				if Zeile contains %A_LoopField%
					return false
				else
					return true
			}
			if Zeile not contains %A_LoopField%
				return false
		}

		return true
	}
	else
	{
		if(SubStr(SuchListCR,1,1)="-")
		{
			StringTrimLeft,SuchListCR,SuchListCR,1
			if(NOT InStr(Zeile,SuchListCR,GrossKlein))
				return true
		}
		else if(InStr(Zeile,SuchListCR,GrossKlein))
		{
			return true
		}
	}
	return false
}
;}
*/
ZeilenAenderungen(Zeile,DeltaSterne,ExtraAnweisung="",NeuAnlegen="")	;{()	
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
;}	
; < / ####################################### Funktionen a bis z ############################################## >
; < ######################################## Funktionen fuer Macros  ######################################### > @0450
Csv2Html(Csv,FeldTrenner=";")	;{()	
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
;}	
; < / ####################################### Funktionen fuer Macros  ######################################### >
; < ######################################## Clipboard Menue  ############################################## > @0520
ClipboardMenuHandler1:	;{	
Clipboard:=Clipboard
return
;}	
ClipboardMenuHandler2:	;{	
ClipboardSpeicher1:=Clipboard
return
;}	
ClipboardMenuHandler2a:	;{	
Send {CtrlDown}c{CtrlUp}
if(ClipboardSpeicher1<>"")
	ClipboardSpeicher1:=ClipboardSpeicher1  "`r`n" Clipboard
else
	ClipboardSpeicher1:=Clipboard
; MsgBox % ClipboardSpeicher1
return
;}	
ClipboardMenuHandler3:	;{	
Clipboard:=ClipboardSpeicher1
return
;}	
ClipboardMenuHandler3a:	;{	
; SendRaw %ClipboardSpeicher1%
Clipboard:=ClipboardSpeicher1
Send {CtrlDown}v{CtrlUp}
return
;}	
ClipboardMenuHandler4:	;{	um die Befehlszeile anzuzeigen, mit der der Prozess des aktiven Fensters gestartet wurde.
	WinActivate
	sleep 300
	; WinGet,WindowsHwndListe,List
	; MsgBox % WindowsHwndListe1 "	" WindowsHwndListe2 "	" WindowsHwndListe3 "	" WindowsHwndListe4 "	" WinExist("A") 
	; Sleep 400
	; ControlGetText,DieserPfad,ComboBox1,A
	; MsgBox % DieserPfad
	IfWinActive,ahk_class CabinetWClass 	; Sonderbehandlung Explorer
	{
		DieserPfad:=
		ClipMerker:=ClipboardAll
		; ControlGetText,ComboBox1,Edit1,A
		ControlGetText,DieserPfad, ToolbarWindow323,A
		DopPos:=InStr(DieserPfad,":")
		DieserPfad:=SubStr(DieserPfad,DopPos+2)
		; ControlGetText,DieserPfad,Edit1,A
		; ControlFocus,ToolbarWindow323,A
		; sleep 300
		; ControlGetText,DieserPfad,Edit1,A

		if(DieserPfad="")
		{
			sleep 50
			ControlFocus,Edit1,A
			; ControlClick,Edit1,A
			sleep 600
			ControlGetText,DieserPfad,Edit1,A
			if(DieserPfad="")
			{
				IfWinActive,ahk_class CabinetWClass 	
				{
					ControlFocus,ComboBox1,A
					Sleep 100
					Send {F4}
					Sleep 100
					Send {CtrlDown}a{CtrlUp}
					Sleep 100
					Send {CtrlDown}c{CtrlUp}
					ClipWait,2
					if not ErrorLevel
					{
						DieserPfad:=Clipboard
						Send {Escape}
					}
				}
			}
			if(DieserPfad="")
			{
				IfWinActive,ahk_class CabinetWClass 	
				{
					ControlFocus,ComboBox1,A
					Sleep 100
					; ControlClick,ComboBox1,A
					Send {Down}
					Sleep 300
					Send {BackSpace}
					Sleep 600
					send {CtrlDown}c{CtrlUp}
					ClipWait,2
					if not ErrorLevel
						DieserPfad:=Clipboard
					; MsgBox % A_LineNumber "	" DieserPfad
				}
			}			
		}
		if(DieserPfad="")
		{
			MsgBox % A_LineNumber "	Favorit anlegen missglueckt!"
			return
		}
		Clipboard:=DieserPfad
		; MsgBox % DieserPfad
		gosub ClipboardMenuHandler5
		Clipboard:=ClipMerker
		return
	}
	IfWinActive,ahk_class IEFrame	; Sonderbehandlung InternetExplorer
	{
		ControlGetText,DieseUrl,Edit1,A
		if(DieseUrl="")
			ControlGetText,DieseUrl,Edit2,A

		WinGetTitle,DieserTitel,A
		StringTrimRight,DieserTitel,DieserTitel,20
		DieserTeilTitel:=SubStr(DieserTitel,1,60)
		StringReplace,DieserTeilTitel,DieserTeilTitel,|,!,all
		ThisNewFavorit:=DieserTeilTitel "|*" DieseUrl
		gosub PlusSternManuell
		return
	}
	else
	{
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
			FuerClipboardOrg:=FuerClipboard
			StringSplit,DummyArray,FuerClipboard,%Hochkomma%
			Hochkomma2Pos:= InStr(FuerClipboard,Hochkomma,,3)
			; Clipboard:= process.CommandLine
			StringReplace,FuerClipboard,FuerClipboard,%Hochkomma%%A_Space%,%A_Space%%A_Space%%A_Space%%A_Space%,All
			StringReplace,FuerClipboard,FuerClipboard,`",,All
			ThisPfad:=SubStr(FuerClipboard,1,Hochkomma2Pos-2)
			SplitPath,ThisPfad,ThisFileName
			if(DummyArray0=3)
			{
				ThisUebergabeParameter:=SubStr(FuerClipboard,Hochkomma2Pos+3)
				StringSplit,EinzelParameter,ThisUebergabeParameter,%A_space%
				EinzelParamenterUebertag:=
				Index:=1
				Loop, % EinzelParameter0
				{
					IfExist % EinzelParameter%A_Index%
					{
						EinzelParameterBearb%Index%:=Hochkomma Hochkomma EinzelParameter%A_Index% Hochkomma Hochkomma 
						EinzelParamenterUebertag:=
						++Index
					}
					else IfExist % EinzelParamenterUebertag A_Space EinzelParameter%A_Index%
					{
						EinzelParameterBearb%Index%:=EinzelParamenterUebertag A_Space EinzelParameter%A_Index%
						++Index
					}		
					else
					{
						EinzelParamenterUebertag.=EinzelParameter%A_Index% A_Space
					}
				}
				; ThisNewFavorit:=ThisFileName "|*" ThisPfad Hochkomma SubStr(FuerClipboard,Hochkomma2Pos+3) Hochkomma
				ThisNewFavorit:=ThisFileName "|*" Hochkomma Hochkomma ThisPfad Hochkomma Hochkomma
				Loop % Index
					ThisNewFavorit.=A_Space EinzelParameterBearb%A_Index%
				ThisNewFavorit.=A_Space EinzelParamenterUebertag
				gosub PlusSternManuell
			}
			else if(DummyArray0=5 or DummyArray0=7 or DummyArray0=9 or DummyArray0=11 or DummyArray0=13 or DummyArray0=15)
			{
				StringReplace,FuerClipboard,FuerClipboardOrg,%Hochkomma%,%Hochkomma%%Hochkomma%,All
				ThisNewFavorit:=ThisFileName  "|*" FuerClipboard
				gosub PlusSternManuell
			}
			else
			{
				Clipboard:=FuerClipboard
				gosub PlusSternClipPfade
			}
			; MsgBox % Clipboard
				; 		ThisNewFavorit:=ThisClipZeile
			; gosub PlusSternManuellBekannt

			
;			
		}
		else
			MsgBox Prozess nicht gefunden!
		; Alle globalen Objekte freigeben (nicht notwendig, wenn lokale Variablen verwendet werden).
		wmi := queryEnum := process := ""
	}
return
;}	
; Win32_Process: http://msdn.microsoft.com/en-us/library/aa394372.aspx
ClipboardMenuHandler5:	;{	
gosub PlusSternClipPfade
return
;}	
ClipboardMenuHandler6:	;{	
Sort,Clipboard,U
return
;}	
ClipboardMenuHandler7:	;{	
Sort,Clipboard,U \
return
;}	
ClipboardMenuHandler8:	;{	
Run, % Clipboard 
return
;}	
SuchenErsetzen(Eingang,Suchen="",Ersetzen="")
{
	if (Suchen="")
	{
		SuchePipeErsetzen:=false
		SucheParagraphErsetzen:=false
		SucheIstgleichErsetzen:=false
		IfExist %A_AppData%\Zack\SuchePipeErsetzen.txt
		{
			SuchePipeErsetzen:=true
		}
		else IfExist %A_AppData%\Zack\SucheParagraphErsetzen.txt
		{
			SucheParagraphErsetzen:=true
		}
		else IfExist %A_AppData%\Zack\SucheIstgleichErsetzen.txt
		{
			SucheIstgleichErsetzen:=true
		}
		if(SuchePipeErsetzen + SucheParagraphErsetzen + SucheIstgleichErsetzen = 0)
		{
SuchenUndErsetzenVorschlag=
(
; nach schliessen dieses Fensters gehts weiter		mehrere Zeilen erlaubt
; Mit PipeepiP kann das Pipezeichen selbst ersetzt oder eingefuegt werden.
; unten ist ein Vorschlag um gängige Sonderzeichen zu ersetzen
;
; suchen|ersetzen
; Dict|ASCII
&auml;|ä
&Auml;|Ä
&ouml;|ö
&Ouml;|Ö
&uuml;|ü
&Uuml;|Ü
&szlig;|ß
â€|"
Ã¼|ü
Ã¶|ö
Ã&#159;|ß
ÃŸ|ß
Ã¤|ä
Ã&#132;|Ä
Ã„|Ä
Ã–|Ö
Ã&#156;|Ü
Ãœ|Ü
Ã©|é
Ã¨|è
Ã­|í
Ãª|ê
Ã¡|á
Ãº|ú
Ã±|ñ
Ã³|ó
Ã§|ç
Ã&#135;|Ç
Ä±|ı
Ã´|ô
Ã&#128;|À
Ã»|û
Ã®|î
Å&#130;|ł
Å&#159;|ş
Ã¢|â
Å¾|ž
Å¡|š
Ä&#155;|ě
Å&#153;|ř
Ã&#154;|Ú
Ãµ|õ
Ã¥|å
Ã«|ë
Ã&#150;|Ö
Ã&#133;|Å
Ã¯|ï
Ã¬|ì
Ã£|ã
Â²|²
Â³|³
-|-
Î&#148;|Δ
Â°|°
Â·|·
Â»|»
&#158;|"
â&#128;|"
&#136;|~
â&#137;|~
Î£|Σ
Î±|α
Î²|β
Î³|γ
Î´|δ
Îµ|ε
Î¶|ζ
Î·|η
Î¹|ι
Îº|κ
Î»|λ
Î¼|μ
Î½|ν
Î¾|ξ
Î¿|ο
Ï&#128;|π
Ï&#131;|σ
Ï&#134;|φ
Ï&#135;|χ
Î¸|θ
Ï|ρ
Ï&#132;|τ
Ï&#133;|υ
Ï&#136;|ψ
Ï&#137;|ω
Î©|Ω
)
			FileAppend,%SuchenUndErsetzenVorschlag%,%A_AppData%\Zack\SuchePipeErsetzen.txt,utf-16
			SuchePipeErsetzen:=true
		}
		if SuchePipeErsetzen
			RunWait,%A_AppData%\Zack\SuchePipeErsetzen.txt
		else if SucheParagraphErsetzen
			RunWait,%A_AppData%\Zack\SucheParagraphErsetzen.txt
		else if SucheIstgleichErsetzen
			RunWait,%A_AppData%\Zack\SucheIstgleichErsetzen.txt
		if SuchePipeErsetzen
		{
			SuchePfadErsetzen:=SuchePipeErsetzen
			Trennzeichen:="|"
			TrennzeichenAscii:="Pipe"
			TrennzeichenErsatz:="PipeepiP"								 
		}
		else if SucheParagraphErsetzen
		{
			SuchePfadErsetzen:=SucheParagraphErsetzen
			Trennzeichen:="§"
			TrennzeichenAscii:="Paragraph"
			TrennzeichenErsatz:="ParagraphhpargaraP"										   
		}
		else if SucheIstgleichErsetzen
		{
			SuchePfadErsetzen:=SucheIstgleichErsetzen
			Trennzeichen:="="
			TrennzeichenAscii:="Istgleich"
			TrennzeichenErsatz:="Istgleich"								  
		}
		IfExist %A_AppData%\Zack\Suche%TrennzeichenAscii%Ersetzen.txt
		{
			FileRead,Inhalt,%A_AppData%\Zack\Suche%TrennzeichenAscii%Ersetzen.txt
			Loop,Parse,Inhalt,`n,`r
			{
				if (substr(A_LoopField,1,1)=";")
					continue
				else if(instr(A_LoopField,Trennzeichen))
				{
					StringSplit,SuchErsArray,A_LoopField,%Trennzeichen%
					if (SuchErsArray0=2 and SuchErsArray1<>"" and SuchErsArray2<>"" )
					{
						StringReplace,SuchErsArray1,SuchErsArray1,%TrennzeichenErsatz%,%Trennzeichen%,All	; fuers Trennzeichen selbst
						StringReplace,SuchErsArray2,SuchErsArray2,%TrennzeichenErsatz%,%Trennzeichen%,All	; fuers Trennzeichen selbst
						StringReplace,Eingang,Eingang,%SuchErsArray1%,%SuchErsArray2%,All
					}
					; else
						; SoundBeep,5000
						
				}
			}
		}
	}
	else
	{
		StringReplace,Eingang,Eingang,%Suchen%,%Ersetzen%,All
	}
	Ausgang:=Eingang
	return Ausgang
}
ClipboardMenuHandler10:	;{	
if(Clipboard="")
{
	AbfrageFenster(,"Clipboard Anzeige","Das Clipboard ist leer","OK")
	return
}
DiesesClipboard:=Clipboard
Loop
{
	AbfrageFensterAntwort:=AbfrageFenster(,"Clipboard Editor",DiesesClipboard,"abbrechen",">>>>>suchen und ersetzen ...",">>>>>>>>>Aenderungen uebernehmen")
	if(SubStr(AbfrageFensterAntwort,1,1)=2)
	{
		FuerClipboard:=SubStr(AbfrageFensterAntwort,2)
		DiesesClipboard:=SuchenErsetzen(FuerClipboard)
		if(SubStr(DiesesClipboard,-1,2)="`r`n")
			StringTrimRight,DiesesClipboard,DiesesClipboard,2
	}
	else if(SubStr(AbfrageFensterAntwort,1,1)=3)
	{
		DiesesClipboard:=SubStr(AbfrageFensterAntwort,2)
		StringReplace,DiesesClipboard,DiesesClipboard,`n,`r`n,All
		Clipboard:=DiesesClipboard
		break
	}
	else
		break
}
return
;}	
ClipboardMenuHandler11:			; zeige ClipPathInhalt in Edit5
ZeigeClipPathInhaltInEdit5:	;{	
Clipboard:=GetPathOrLinkedPath(FuehrendeSterneEntfernen(Clipboard))
IfExist %Clipboard%
{
	Edit2:=FileKenner . FuehrendeSterneEntfernen(Clipboard) . A_Space InRowKenner A_Space

	gosub Edit2Festigen
	SucheAbgebrochen:=false
	Edit1:=ZaehleZeilen(Edit5)	; Change372a
	gosub Edit1Festigen
	FokusEdit2Rechts()
	Edit1:=ZaehleZeilen(Edit5)	; Change372a
	gosub Edit1Festigen
}
return
;}	
ClipboardMenuHandler12:	;{	
gosub Edit82AWin
; listlines
return
;}	
F7::	; Toggle Inhalt-Textansicht <---> Pfadlisten-Ansicht
InhaltVonEdit82Edit5:
Edit82Edit2:	;{	
; SuchVerlauf()
Edit8:=GetPathOrLinkedPath(FuehrendeSterneEntfernen(Edit8))
gosub Edit8Festigen
gosub NormalAnzeige
; If(SubStr(Edit2,1,7)=FileKenner or SubStr(Edit2,1,8)=FilePatternKenner)
If(SubStr(Edit2,4,3)="://)")
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
;}	
InhalteInTextFormAnzeigen:	;{	
; MsgBox InhalteInTextFormAnzeigen:
	Edit2VorTextAnsicht:=Edit2
; 	gosub Edit2Festigen
	Edit3VorTextAnsicht:=Edit3
; 	gosub Edit3Festigen
Ctrl & Right::	; Ordner tiefer bezuelich Edit8 oder in die Details / Inhalt anzeigen
Edit8:=GetPathOrLinkedPath(FuehrendeSterneEntfernen(Edit8))
gosub Edit8Festigen
if WortVorschlaege
	FileDelete,%A_AppData%\Zack\WortVorschlagListe.txt

gosub NormalAnzeige
; SuchVerlauf()
; Edit7VorTextAnsicht:=Edit7
	Edit8Sternlos:=FuehrendeSterneEntfernen(Edit8)
	IfExist % Edit8Sternlos
	{
		Edit2VorTextAnsicht:=Edit2
		Edit3VorTextAnsicht:=Edit3
		FileGetAttrib,FileDirektAttribute,% Edit8Sternlos
		if(InStr(FileDirektAttribute,"D"))
		{
			Edit2:=FilePatternKenner  Edit8Sternlos "\*" N_PPHC "*," N_PHL "DFR" N_PHR "`v"  InRowKenner A_Space N_PHC
			gosub Edit2Festigen
			SucheAbgebrochen:=false
			Edit1:=ZaehleZeilen(Edit5)	; Change372a
			gosub Edit1Festigen
		}
		else
			Edit2:=FileKenner  Edit8Sternlos "`v" InRowKenner A_Space N_PHC
		gosub Edit2Festigen
		Edit3:=1
		gosub Edit3Festigen
		gosub Edit3
		Edit1:=1			; Noch Aussagefaehiger machen ######################
		gosub Edit1Festigen
		FokusEdit2Rechts()
	}
	else if(InStr(Edit8Sternlos,HTTPkenner) OR InStr(Edit8Sternlos,HTTPSkenner))
	{
		Edit2:=Edit8Sternlos A_Space
				gosub Edit2Festigen
		Edit3:=1
		gosub Edit3Festigen
		gosub Edit3
		Edit1:=1			; Noch Aussagefaehiger machen ######################
		gosub Edit1Festigen
		FokusEdit2Rechts()
	}
return
;}	
; < / ####################################### Clipboard Menue  ############################################## >
; < / ####################################### Sonstige Menues Labels  ######################################## >
RegExBeratungsFormular:	;{	
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
	RegExSuchStringEdit11efault=O U i m `n)(^.*	.*$)
	if (RegExSuchStringEdit2="")
	{
		RegExSuchStringEdit2:=RegExSuchStringEdit11efault
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
;}	
SuperFavorit0:	;{	
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
		DiesenBefehlsDateiPfad:=SuperFavoritenPfad%ThisSuperFavoritNr%
		gosub DiesenBefehlsDateiPfadAusfuehren
		ToolTip,
		return
	}
	Edit8:=SuperFavoritenPfad%ThisSuperFavoritNr%
	gosub Edit8Festigen
}
return
;}	
; < / #######################################  Vom Gui aufgerufene Labels  #################################### >
; < / #################################################    G  u  i    ########################################## >
; < ######################################## benutzte Skript-Ordner oeffnen ################################### >
OeffneAlleSkriptOrdner:	;{	
run %A_AppDataCommon%
run %A_AppData%
run %A_ScriptDir%
return
;}	
; < / ####################################### benutzte Skript-Ordner oeffnen ################################### >
ZeigePfadlisteImBrowser:	;{	
if(NOT InStr(SubStr(Edit5,1,400),"<html>"))
{
	HtmlListe:=PfadListe2HtmlListe(Edit5)
	IstSchonHtml:=false
}
else
{
	HtmlListe:=Edit5
	IstSchonHtml:=true
}
if IstSchonHtml
	HtmlSeite:=HtmlListe
else
{
HtmlSeite=
(
<html>
<head>
<title>%DieserHtmlTitel%</title>
<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1">
</head>

<body bgcolor="#FFFFFF" text="#000000">
%HtmlListe%
</body>
</html>
)
}



HtmlSeitePfad:=A_Temp "\HtmlSeite.htm"
FileDelete,%HtmlSeitePfad%
FileAppend(HtmlSeite,HtmlSeitePfad)
if IeAnz
	WB.Navigate(HtmlSeitePfad)
else
{
	if (HtmlSeiteLast<>HtmlSeite)
	{
		; Process, Exist , BrowserPID
		; Process, wait,ahk_id %BrowserPID%, 0.5
		IfWinExist,ahk_id %BrowserPID%
		{
			; WinActivate,ahk_id %BrowserPID%
			ControlSend,,{F5},ahk_id %BrowserPID%
		}
		else
		{
			; gosub GuiWinMin
			; SoundBeep
			Run, file:///%HtmlSeitePfad%   ; ,,,BrowserPID		; BrowserPID wegen File:// Protokoll indirekt ind somit so nicht ermittelbar.
			sleep 2000 
			BrowserPID:=WinExist("A")
		}
	}
	HtmlSeiteLast:=HtmlSeite
}
; run % A_Temp "\HtmlListe.htm"
; run  % A_Temp 
return
;}	
FileAppend(Inhalt,Pfad,Kodierung="UTF-16")
{
	FileDelete,%Pfad%
	FileAppend,%Inhalt%,%Pfad%,%Kodierung%
	return ErrorLevel
}
RecentFolderLinks:	;{	
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
;}	
Edit6GleichGefundenePfade:	;{	
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
;}	
Sleep10000:	;{	
Sleep 10000
return
;}	
ClipBoardAnzeige:	;{	
if (Clipboard<>"")
	AbfrageFenster(,"Clipboard Anzeige",Clipboard,"OK")
else
	AbfrageFenster(,"Clipboard Anzeige","[Leere Menge]","OK")
return
;}	
; < #########################################  H i L f e  #################################################### >	@0800
; < ############################################  Info  #################################################### >	@0806
Info:	;{	
gosub VersionsHistorieEinlesen
FileDelete,%A_ScriptDir%\VersionsHistorie.txt
; 	@0809
ThisAppend=ZackZackOrdner hilft bei dem schnellen finden von Ordnern und inzwischen auch von Dateien.`n`nBeta-Version %ZZO_Version%`nGerdi `n`n`nVersionsHistorie`n`n%VersionsHistorie%
StringReplace,ThisAppend,ThisAppend,`n,`r`n,all
FileAppend,%ThisAppend% ,%A_ScriptDir%\VersionsHistorie.txt,utf-16
run notepad.exe "%A_ScriptDir%\VersionsHistorie.txt"
return
;}	
; < ############################################  Versionshistorie  ########################################## > ;{
VersionsHistorieEinlesen:	;{	
; < ############################################  bekannte Fehler  ########################################## >	@0807
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
0.344	0.122->Deaktiviert	RegEx Vorauswahl fur das Suche-Feld eingerichtet. Zu erreichen via Eingabe von ) ins Suchfeld. 
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
0.126	BeiExtender.???.ahk ermoeglicht Aktionen die ausgefuehrt werden, wenn es zum momentanen Ordner in Edit8 eine passende Datei OrdnerPfad.??? gibt.
0.127	Primitv-Beipiel BeiExtender.jpg.ahk implementiert, weches immer wenn ein Ordner mit Bild (mit gleichem Name wie der Ordner nur um .jpg ergaenzt) ausgewaehlt wurde
	poppt dieses jpg-Bild kurz in Fensterbreite auf und wird verkleinert noch eine kurze Weile angezeigt. 
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
0.175	Menue | Macro | Muster-Dateien  aktualisiert.  Ueber Macro nachtraegliche Sortierungs-Alternativen angeboten: Sortierung nach: -StringLaenge des Pfades	-z...a	-OrdnerName 
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
		im gegensatz zu: Dir2Paths.ahk C:\ProgramData\Zack\WuCont\Haupt +C:\temp\* befuellt den Cache mit gefundenen Ordnern und Dateien
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
0.264	+%A_WinDir%\System32\*.msc in Start Menu aufgenommen
0.265	eigenen Cache einlesen erschwert z.B. +c:\* liest nicht mehr C:\ProgramData\Zack\WuCont\Haupt ein.
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
		aus dem Cache angezeigt. Angeklickt werden sie als Suchbegriff uebernommen. Die erscheinenden Worte sind die ersten gefunden Cache-Datei-Namen,
		die mit dem Suchbegriff-Beginn uebereinstimmen. D.H. hat ein Name einen deutschen Display-Name und das englische Original,
		dann wird zuerst der Display-Name erwartet. 
		Z.B. im Container Start Menu wird nach der Eingabe "ei" der Such-Wort-Vorschlag  "EingabeaufforderungCommand Prompt.lnk"  angezeigt.
0.289	Hilfsfenster an verschiedene DPI angepasst.
0.290	Bug bei der Komunikation von TastWatch mit ZZO beseitigt.
0.291 bis 0.293	Such-Wort-Vorschlaege weiter unterteilt. _ Leerzeichen und . werden als Worttrenner angesehen.
		Such-Wort-Vorschlaege koennen einmalig unterdrueckt werden, indem man einen * im Suchbegriff verwendet.
		Der * am Anfang oder am Ende des Suchbegriffs ist Fundstellen-Neutral.
		Mit WortVorschlaege=0 in den Sizungs-Einstellungen 
		und anschliessedem umbenennen von Einstellungen.txt zu AutoEinstellungen.txt,
		kann dies auch voreingestellt werden.
		Bei den Such-Wort-Vorschlaegen sind noch Veraendeungen geplant.
0.294	FremdProgramme koennen ueber die Datei %A_AppDataCommon%\Zack\ZzoHauptFensterHwnd.txt
		das eindeutige HWND des ZZO-Hauptfensters erfragen.
		Ebenso wird dies von TastWatch.ahk genutzt.
0.295	Such-Wort-Vorschlaege nur wenn Edit2 nicht grau
0.296	Fenster Such-Wort-Vorschlaege auf Buttons reduziert.
0.297	Such-Wort-Vorschlaege kann mit Escape kurzfristig ausgeblendet werden. Mit Shift wieder geholt.
		Alternativ koennen mit Klick auf die ZZO-Titelzeile die Such-Wort-Vorschlaege nach hinten gedraengt werden.
		Hinweis: Die Such-Wort-Vorschlaege werden nur angezeigt, wenn der Schreib-Fokus im Feld Edit2 ist. 
0.298	Wenn Such-Wort-Vorschlaege angezeigt wird kann mit AppsKey diese Funktionalität bis zum Neustart unterbunden werden.
0.299	= in FaforitenCacheNames durch ist ersetzt
0.300	⁄ fuehrt auch zur Worttrennung
0.301	Die Erzeugung eines Favoriten vom momentan aktiven InternetExplorer-Inhalt 
		wird ueber	[Win]+[v] 	Aktives Fenster als ZZO-Favorit einrichten	gezielt unterstuetzt.
0.302	Die deutschen Dispaynamen werden nun bei den Such-Wort-Vorschlaegen getrennt von den englischen Originalen angezeigt. (Die Startpfade muessen dazu neu eingelesen werden.)
0.303	Die Erzeugung eines Favoriten vom momentan aktiven Explorer-Inhalt 
		wird ueber	[Win]+[v] 	Aktives Fenster als ZZO-Favorit einrichten	gezielt unterstuetzt.
0.304	Navigieren in den Containern verbessert. Cache Struktur Anzeige
0.305	Deref`%Umgebung`%fereD moeglich in Favoriten siehe Google-Deref-FavoritenVorschlag,
		wenn man diesen Favorit oeffnet, wird der Clipboard-Inhalt in die URL eingefuegt,
		dies wiederum fuehrt in diesem Beispiel dazu, dass die Google-Suche angewiesen wird danach zu suchen.
		Hinweise: 
		- der Clipboard-Inhalt sollte dazu einzeilig sein.
		- Deref Clipboard weigert sich bei der um Favorisierung oder Loeschung,
		  mit dem Trick vorher etwas Merzeiliges ins Clipboard zu nehmen, sollte es doch klappen. Benoetigt Version 0.306
0.306	Mehrzeilige Ersetzungen in Deref unterbunden.
		Deref Beispiel:
		wenn "Open" vom Tray-Menu ausgefuehrt wurde und Edit2
		CoTe://WTitle? Deref`%A_ScriptFullPath`%fereD Contro? Edit1 Nr_Row? Sleep
		enthaelt. Dann werden alle gespeicherten vom Skript durchlaufenen Quelltextzeilen die "Sleep" enthalten in Edit5 angezeigt
0.307	FaforitenVorschlaege ueberabeitet.
0.308	FaforitenVorschlaege in Erststart aufgenommen
0.309	[Win]+[v] Aktives Fenster als ZZO-Favorit einrichten ueberabeitet.
0.310	Markierungen an 0.309 angepasst.
0.311	Favoriten-Vorschlag zur Google-Suche nach Edit10 hinzugefuegt. Zu erreihen ueber die Suchworte Edit10 Zusatz Feld Google Suche Search
0.312	Macro | starten... ohne vorhandene Macros, wird mit Hinweis auf die Macro-Muster-Dateien, abgefangen.
0.313 0.214	Button4 (F8) beim rueckschreiben in bestehendes Exolorerfenster ueberarbeitet.
0.315	Favritenvorschag enthaelt auch die Drives
0.316	RunOtherAhkScriptOrExe ueberarbeitet. Bei nicht installiertem AHK reicht es nun die Datei AutohHotKey.exe umbenannt zu SchnellOrdner.exe im selben Ordner beizustellen. Dir2Paths.exe und TastWatch.exe werden bei Bedarf vom Haupt-Skript aus SchnellOrdner.exe erzeugt. Hinweis: Kompilierte EXE-Dateien werden von ZZO nicht unterstuetzt.
0.317	Hauptmenue: Edit8 | Diashow ruft die Diashow des Betriebssystems auf. Hinweis Win 10 hat ein Darstellungsproblem wenn eine benutzerdefinierte Skalieungsstufe abweichend von 100`% eingestellt ist.
0.318	Das Pipe-Zeichen | in der Titelzeile des Internetexplorers führt beim Favoriten Anlegen nicht mehr zu einer Fehlermldung, da es durch ein Ausrufezeichen ersetzt wird.
0.319	Vorhandene Explorerfenster führen in den Containern Haupt und Start Menu zu Ad-Hock-Einträgen. 
		Zu erkennen an der Form:	
		Pfad		[Name]#HWND
		Pfad (der vom Ordner des ExplorerFensters)	Name (in denen wird gesucht)	HWND eindetige Fenster-Nummer
		Dieses neue Format ohne #HWND ist für bestehende und weitere Aufgaben vorgesehen.
0.320	Vorbereitungen fuer Oeffnen mit
0.321	Try in ShowExpWin: eingefuegt, genaueres muss noch untersucht werden
0.322	Default von Menu StartPfad einlesen bei Stringeingabe geaendert. 
		Wenn Edit8 einen Ordner repräsentiert, wird dieser als StartPfad vorgeschlagen.
		Wenn Edit8 einen UnterOrdner eines bestehenden Startpfades repräsentiert wird auch Dateien einlesen vorgeschlagen.
0.323	Edit2 erhält beim Aktivieren den Fokus
0.324	HTML-Links werden wie in 0.319 angekündigt mit Suchnamen in eckiger Klammer angezeigt.
0.325	Favoriten-Vorschlaege ueberarbeitet
0.326 0.327	Offnen mit komfortarm eingeführt
0.328	LinksKlick in die Pfadliste (Edit5) wählt den geklickten Pfad aus.
0.329	DoppelKlick links startet das Angeklickte
)
VersionsHistorie4=
(
0.330 0.331 ShowExpWin ist nun auch filterbar (Edit7)
0.332	DropDown auf PfadNummern mit Pfaden die keine Ordner sind wird als oeffnen mit interpraetiert.
0.333	weitere DropDown Unterstuetzung
0.334	NurInExistierendenStartPfadenSuchen:=true bewirkt, 
		das Fundstellen aus Caches von nicht angeschlossenem Speicher auch nicht mehr angezeigt wird. 
		Hinweis: es wird dann bei jeder Suche bei jedem StartPfad des Containers
		die Existenz der StartPfadWurzel ueberprueft (verlangsamt). 
		Dafür werden aktuell nicht vorhandene Caches in Ruhe gelassen (beschlaeunigt).
		Bei Netzlaufwerken mit langen Antwort-Zeiten kann NurInExistierendenStartPfadenSuchen=0
		in der Datei AutoEinstellungen.txt (siehe 0.198) helfen.
0.335	oeffnen mit verbessert
0.336	oeffnen mit Favorit implementiert
0.337	oeffnen mit Favorit verbessert
0.338	Flag NotShowExistIeAndExplorerWin default := false 
		0.319 ist somit via 
		Menue|Options|Sitzungs- Einst. bearbeiten 
		deaktivierbar. Dauerhaft siehe 0.198
0.339	Pfade Menu eigefuehrt. Es befinden sich Edit5- und Clipboard- Aktionen darin.
		Es aehnelt dem via #V erhaeltlichen Menu.
		Ist intuitiver zu Bedienen, kann dafuer aber nur bei Aktivem ZZO-Fenster aufgerufen werden
0.340	An Suche Dateien koenen nun auch Pfade uebergeben werden.
		Es lassen sich auch Ordner-Pfade uebergeben, deren Dateien dann vollstaendig eingelesen werden.
		Dadurch koenen bei ungeschickter Wahl leicht lange Ladezeiten (mit einigen Doppelten) entstehen.
		Gedacht ist diese Uebergabe fuer Datei-Pfade, die dann z.B. via Klick auf die Spalten-Ueberschriften,
		sortiert werden koennen.
0.341	Ersatz fuer Macro sortieren Kurz nach oben ins 0.339 Menu gestellt.
		Hinweis: Die Sortierung Kurz nach oben ist nur verlaesslich, 
		wenn die gefundene Pfade-Anzahl nicht in Klammern steht,
		also die Suche nicht vorzeitig abgebrochen wurde. 
		Deshalb wird Anzahl bis zum Suchabbruch temporaer drastisch erhoeht.
		D.h. bei kurzen Such-Strings (Edit2) ist mit Wartezeiten zu rechnen.
		Sollte dabei eine Variable an die Speicher-Kapazitaet anstossen,
		kann vorzugsweise die Suche praezisiert werden oder #MaxMem hochgesetzt werden.
0.342	Drag and Drop auf Oeffnen Mit Favoriten werden interpraetiert,
		dass `%E8`% jeweils durch den Einzelpfad (von Drag und Drop) ersetzt wird.
0.343	Menu | Pfade | Starte Clipboard-Pfade mit Edit8
0.344	ShowExpWin (0.330 0.331) ist nun auch vor-filterbar (Edit7)
		99 und -99 sind die Vor-Filter. 
		Zur Erinnerung positiv Integer -> nur	negativ Integer -> ohne
		D.h wen die Anzeige der Explorer-Fenster stört kann sie mit -99 im Pfadfilter verhindern.
		Dauerhaft ist das Flag NotShowExistIeAndExplorerWin besser geeignet.
0.344	0.122 -> Deaktiviert
0.345	Macro-Vorschlag um Edit8OeffnenMitNotepad.txt ergaenzt.
		Gedacht als Vorlage fuer eienen Supervaforiten.
		Hinweis: wenn ein Macro als Superfavorit eingerichet ist, wird es beim Aufruf gleich gestartet.
		Statt Notepad wird hier ein HexEditor oder Notepad++ empfohlen.
0.346	Nach dem Sortieren in Kurz oben (SortLenAlle) wird auf die Pfadnummer 1 zurueckgesetzt.
0.347	Vorfilterung nach Start-Pfaden komfortabel ueber die Pfeile neben Menu Start-Pfad erreichbar.
		dito via Tastenkombinationen ^{Down} bzw. ^{Up}
0.348	Die Filter werden je Container gespeichert und bei Containerwechsel restauriert.
0.349	Fehler in Clipboard-Ausgabe bei Explorerpfaden behoben.
0.350	Update via  Menu | Optionen |ZZO neueste Version holen  fuer Proxyumgebungen verbessert.
0.351	Ordner... Button verbessert
0.352 - 0.353 Aufraeumareiten bei den Log-Files
0.353	keine Anzeige der Start-Pfad-Nr auf dem Button1 funktioniert nun auch nach Menu | Optionen | Suche ruecksetzen
0.354	Tastenkombination [Strg] + [f] fokussiert und markiert Edit2, dito wie schon lange F2
		F2 bitte nicht mehr in Macros verwenden!
0.355	AktContainerNr ist nun auch nach Neustart gesetzt.
0.356	Lesbarkeit von Listlines erhoeht. Ausgewaehlte Neue Threads die von einem Ereignis ausgloesst wurden werden nicht weiterverfolgt. Z.B.:
		OnClipboardChange:
		NeuerThread=OnClipboardChange:
		ListLines,Off
		Samlung der von Listline unterbrochenen Ausgaben:
		OnClipboardChange,GuiSize	; bitte hier auch zukuenftige unterbrochenen Ausgaben dokumentieren.
0.357	clip:// InRow? *	clip:// InName? * wird vom Suchfeld Edit2 unterstützt.
		Nach dieser Eingabe wird im Clipboard gesucht statt im Cache. 
		Wobei statt des Sterns der Suchtext erwartet wird. 
		Bei InName wird versucht je Clipboard-Zeile einen Datei- bzw. Ordner-Name zu extrahieren,
		ueber den dann gesucht wird. 
		Wenn nicht extrahierbar wird wie bei InReihe (Synonym: InRow) die ganze Zeile durchsucht.
0.358	clip:// InName? * ist via Menu | Pfade | Clipboard 2 Edit5 Pfade erreichbar,
		wobei ein vorhandener Suchbegriff an der Stelle des Sterns uebernommen wird.
0.359	fehlte in der Funktion GetZeile() fehlte ein `r
0.360 - 0.362	File://Pfad InName? * wird vom Suchfeld Edit2 unterstützt.
		Nach dieser Eingabe wird in der Datei mit dem Pfad gesucht statt im Cache. 
		Wobei statt des Sterns der Suchtext erwartet wird.
		Nur absolute Pfade sind geprueft. Beispiel:
		File://C:\temp\Test2.txt InName? Ge 
		wenn sich in der Datei C:\temp\Test2.txt in einer Zeile bspw. ein Pfadverweis auf C:\temp\Gerd.txt befindet,
		dann wird dieser Pfadverweis C:\temp\Gerd.txt angezeigt. 
		Plus weitere Zeilen welche den Suchbegriff Ge im Namen enthalten.
		Eine Kombination mit dem Pfadfilter wird nicht unterstuetzt (d.h. ignoriert).
		Dies ist wegen der Option In_Row? (irgendwo in der Zeile) statt InName? auch nicht wirklich notwendig.
		Ein weglassen der Option und Suchbegriff
		File://C:\temp\Test2.txt  
		führt zur 1:1 Anzeige des Inhaltes von Pfad in Edit5. Alternativmethode: File://C:\temp\Test2.txt
0.363 - 0.366	(speziell AHK-) Quelltexte werden unterstutzt.  Menu | Edit8 | Edit8 als QuellText oeffnen:
		Anzeige mit ZeilenNummer in Edit5
		Beim Eingeben eines Suchbegriffes in Edit2 hinter Nr_Row?, werden alle Zeilen angezeigt in denen der Suchbegriff enthalten ist.
		Beim Doppelclick auf eine QuellTextZeile, oeffnet sich der Editor (wenn er dennn installiert ist) Scite4AHK mit aktivierter Zeile und markiertem Suchbegriff.
		Beispiele: Menu | ? | HotKeys anzeigen oder QuellText anzeigen
0.367	FilP://OrdnerPfad\*.*,DF wird vom Suchfeld Edit2 mit Suchwort
		FilP://OrdnerPfad\*.*,DF [SuchWort] 
		unterstützt, siehe: Menu | Datei | Data-Ordner oeffnen und Skript-Ordner oeffnen
0.368	ZackZackOrdner muesste nun ZackZackOrdnerUndDateien oder einfacher ZackZack heisen.
		Beim StartPfad Einlesen wird darauf hingewiesen, dass mit [Esc] und fuerendem ++ auch Dateien eingelesen werden koennen.
		Beispiel:	+C:\*
		Hinweis: bei genau diesem StartPfad wird empfohlen vorher den Papierkorb zu leeren,
		weil die Funstellen aus dem Papierkorb, nicht so stark wie Favoriten aber dennoch ahnlich, nach oben sortiert werden.
0.369	Notfallmaessig kann auch der Pfad von Notepad als Quelltext-Editor in ScitePath.txt im SkriptOrdner eingetragen werden.
		Der Sprung in die Zeile sollte klappen. Den Suchtext Markiern wird bei Notepad von ZZO nicht unterstuetzt.
0.370	In Edit10 (unterstes Eingabefeld) Quelltext eingetragen 
		und dann aus dem Explorer eine Einzeldatei per Drag and Drop darauf abgelegt,
		oeffnet Diese als Quelltext.
0.371	In Quelltexten nach " filtern war seit 0.363 moeglich,
		aber bei der Uebergabe zu Scite4Ahk sind seltsame Dinge passiert.
		Da ich es nicht herausfand, wie genau zu Maskieren ist (Tipps willkommen), 
		dass der gesammte SuchString inclusive " in eienem UebergabeParameter platz findet,
		schickt ZZO nur den groessten SuchStringTeil ohne " zu Scite4Ahk. 
		Somit kann Scite4Ahk auch nur diesen Teil markieren.
0.372	#V ClipboardMenu | Clipboard 2 ZZ0 versucht das Clippboard sinnvoll in ZZO Darzustellen.
		Abhaengig von 
		Einzeilig 
			Pfad existiert
 			Pfad existiert nicht
		Mehrzeilig
0.373	Quelltext-Fuellzeichen rechts neben der Zeilen Nummer auf ein kleines halbes o geaendert,
		wegen der besseren Weiterverarbeitung.
0.374	Unterprogramm GetDriveLists erstellt. Wenn man mehrfach [Ctr] + [Left] drueckt 
		sollten irgendwann die Laufwerke in Edit5 angezeigt werden.
		Dies klappt nur wenn immer ein "Vater" ermittelt werden kann.
		Oder wenn man vorher C: in Edit8 oder Edit2 eintraegt.
0.375	Uebergabe-Parameter fuer anderen Fremd-Editor als Scite ergaenzt.
		zur Bearbeitung fuer den Anwender Freigegeben.
		Siehe Quelltext mit Filter: ; vom Anwender bearbeitbar
0.376	bei der Schreibweise FilP://OrdnerPfad\*.*,DFR Filter ist nun auch das R fuer Rekursiv moeglich,
		aber mit Vorsicht zu gebrauchen, da alles direkt gefiltert wird ohne die Verwendung des Caches.
		Ein Komma im Filter sollte nun auch korrekt behandelt also gefunden werden.
0.377	Debuggen von Macros wird mit 
		file://MacroPath MacrDo? BeginnZeilenNummer
		in Edit2 unterstuetzt
		AufrufBeispiel:	file://%A_AppData%\Zack\Macro\ZeigeLaufwerkeInEdit5.txt MacrDo? 1
		Achtung:      	file://MacroPath MacrDo? BeginnZeilenNummer		ohne BeginnZeilenNummer fuehrt sofort aus.
0.378	Kommas und Leerzeichen in Datei-/Ordner-Pfaden werden zumindest fuer meine getesteten Faelle von FilP:// unterstuetzt
		FilP://C:\temp\Ger,d - Ko,pie - Kop,ie\Helga*txt,DF txt		findet z.B.
		C:\temp\Ger,d - Ko,pie - Kop,ie\Helga - Kopie.txt		Datei
		C:\temp\Ger,d - Ko,pie - Kop,ie\Helga.2txt			Ordner
		C:\temp\Ger,d - Ko,pie - Kop,ie\Helga.txt			Datei
		PS. in Windows kann ein Dateiname und ein OrdnerName nicht den gleichen Pfad haben!
0.379 - 0.380	Kopieren Verschieben Versionieren Umbenennen weiter automatisiert. 
		Z.B. Kopieren von Dateien im selben Ordner wird als Versionierungswunsch interpraetiert.
		Kopien mit Dateizielen, bei denen Ordner-Ziele erwartet werden, werden moeglichst frueh abgelehnt.
		Kopie von einer Einzeldatei zu einer anderen nicht existierenden Einzeldatei im selben Ordner wird als Umbenennenwunsch interpraetiert.
		Dies gilt sowohl fuer Button5- Menu- als auch Maus-Eingeleitete-(Kopier-)Aktionen.
		Versionieren wird eingeleitet mit dem Ordner als Zieleingabe, in dem die Quell-Objekte sind.
		Umbenennen wird eingeleitet mit 2 Datei-Pfaden (Quell-und ZielPfad), die sich im selben Ordner befinden,
		oder direkt via Menu | Edit8 | umbenennen. Ich bevorzuge die Umbenenn-Methode 
		bei der ein Pfad in Edit8 Angezeigt wird, der umbenannt werden soll.
		Klick auf Button3 Clip
		in Edit8 editieren des Wunsch Pfades
		Klick auf Button5 Copy/Move
0.381	F6 in Scite gedrueckt Fokussiert und zentriert die Eingabe-Y-Position von Scite
0.382	Direkt- Echtzeit- Suche getestet. 
		Bei elektronischen Festplatten muss nicht mehr zwangslaeufig ein Cache engelesen werden.
		Die direkte Suche ist dermaßen Schnell geworden, Dass ein Cache-Freies suchen 
		nicht immer gleich eine Kaffee-Pause erzwingt. 
		Zeiten deutlich unter einer Minute fuer eine Suche ueber c:\* ist
0.383	Direkt- Echtzeit- Suche mit dem FilePatternKenner %FilePatternKenner% implementiert.
		Filter-Menu eingefuehrt. als Inhalt sind 
		- Umwandlungen von Cache-Suche zu Direkt- Echtzeit- Suche 
		- Verwaltung und Ummgang mit Suchstrings
		geplant.
		2 Edit-Felder bedarfsweise sichtbar eingerichtet. 
		Das linke Feld der Direkt- Echtzeit- Suche (ueber Edit2) entspricht weitgehend dem Suchfeld Edit2 von der Cache-Suche
		Das rechte entspricht dem Filter.
		Sie erleichtern die Arbeit mit dem komplizierten Suchstring bei vorhandenem  %FilePatternKenner%  mit %InRowKenner% vom Feld darunter.
0.384	Fehler bei den Suchabbruechen der Direkt- Echtzeit- Suche behoben.
0.385	%InRowKenner% Option auch bei %FilePatternKenner%
0.386	diverse Aufraeum- und Kleinaktionen.
0.387	Button1 und F5 erneuert.
0.388	Focus auf Edit2 Schreibmarke nach rechts ueberarbeitet.
0.389	die meisten Loop,Files Schleifen sind nun mit #Esc abbrechbar. Dito uebers Datei-Menu.
0.390	#6 oder #Numpad6 fuegt an der Schreibmarke das Zeichen %PfRe% ein. 
		Im Suchfeld (Edit2) eingegeben bewirkt dies eine Verkettung der Edit5-Ausgabe von links vom Pfeil,
		mit dem Filter rechts vom Pfeil. Beispiel: 
		Autohotkey%PfRe%ahk 
		findet nur Objekte, die beide Begriffe Reihenfolge (fast) egal enthalten. Empfehlung: 
		Laengerer Suchbegriff als erstes ist Schnitt performanter.
		Wenn der 2. Suchbegriff fast wie der Pfad-Filter (Edit7) wirken soll ist %InRowKenner% zu verwenden:
		Autohotkey%PfRe%%InRowKenner% ahk
		%InRowKenner% alleine vor dem jeweiligen Suchfilter, darf %InRowKenner% nicht im ersten (also ganz links) benutzt werden.
		%InRowKenner% ahk%PfRe%Autohotkey fuehrt nicht zum gewuenschten Ergebnis. 
		Die ausfuehliche Schreibweise ist vorne jedoch erlaubt: 
		FilP://c:\*ahk*,DFR In_Row?%PfRe%Autohotkey. 
		Die ausfuehliche Schreibweise weiter rechts zu verwenden ist nur was fuer Profis.
		Wichtiger Hinweis: mit dem Pfeil nach rechts beginnen verhindert die Auswertung waehrend der Eingabe.
		Auch wenn zuletzt kein Pfeil nach rechts mehr drinn sein soll. Beispiel:
		%PfRe%DonauDampfSchifffahrtsGesellschaftsKapitaen
		Die Suche wird dann mit der Taste [Pos1] gefolgt von Taste [Entf] gefolgt von Taste [F5] abgeschickt.
0.391	Ein Container kann Cachefrei oder anderst ausgedrueckt im Direkt-Such-Modus betrieben werden.
		Dazu wird die Datei 
		`%A_ScriptDir`%\Zzo`%NameSkriptDataPath`%Edit2DefaultString.txt
		z.B.:
		%A_scriptdir%\ZzoOrdnungEdit2DefaultString.txt 
		benoetigt.
		der Inhalt koennte wie folgt aussehen:
		FilP://E:\Gegenst\**,DFR In_Row? 
		um E:\Gegenst mit Unterordnern in Echtzeit durchsuchen zu koennen.
0.392	Im Clipboad Menu #v wurde der Eintrag Clipboard 2 ZZO durch Clippboard-Kopie 2 ZZO ersetzt.
0.393	Weiterhin wurde bei Clip-Pfade 2 ZZO Favoriten (Plus *),
		wenn nur ein Pfad uebergeben wird, eine Editier-Moeglichkeit eingerichtet.
		Diese besteht nachtraeglich ueber das oeffnen des !Fav Ordners,
		Anzeige: Neueste Dateien nach oben, Umbenennen. 
		Der Dateiname wird bei der Suche verwendet, 
		der Datei-Inhalt listet den oder die Pfad(e) auf.
0.394	UniversalMenu vorbereitet
0.395	UniversalMenu Gehversuche
0.395	UniversalMenu implementiert
0.396	Pfad-Wahl tests	
0.397	Pfad-Wahl 2 Clipboard
		Die ersten 15 Edit5-Pfade koennen via #v und anschliessendem Mausklick auf Pfad-Wahl 2 Clipboard
		und klick auf den gewaehlten Pfad ins Clipboard gebracht werden.
0.398 - 0.403 Test mit ParalellSuche durchgefuehrt.
		UeberwachungExplorerSuchFeld[5].ahk
)
VersionsHistorie5=
(
0.404	Pfad-Wahl 2 fokussiertes Feld
		Die ersten 15 Edit5-Pfade koennen via #v und anschliessendem Mausklick auf Pfad-Wahl 2 fokussiertes Feld
		und klick auf den gewaehlten Pfad verwendet werden. 
		Die Aktion haengt vom Aktiven Fenster und vom fokussierten Feld ab.
		Momentan werden Explorer-Fenster mit den wichtigsten Eingabe-Feldern unterstuetzt.
		Es kann jedoch bei beliebigen anderen Eingabe-Feldern getestet werden ob sich ein ZZO-Pfad uebernehmen laesst. 
0.405	Fehlerbereinigung fuer Pfadnummern groesser 9
0.406	#b fuer schnelle Pfad-Wahl in FremdFenstern --> nach #b von 404 nur der letzte Mausclick.
		Sinnvoll beispielsweise fuer 15 gepflegte Favoriten mit jungfraeulichem ZZO-Fenster.
		Dann koennte man auch Favoriten-Schnell-Wahl dazu sagen.
0.407	ueber die Dateien MachsBesteDrausControls.ahk und MachsBesteDraus.ahk koennen eigene (Spezial-) Faelle für 0.404 bis 0.406 implementiert werden.
0.408	ueber WeitereUnterprogrammeFunktionen.ahk konnen ganz allgemein individuelle Unterprogramme und oder Funktionen integriert werden.
0.409	#b fuer schnelle Pfad-Wahl jetzt auch fuer das ZZO-eigene Edit2-Feld verwendbar:
		- wenn ein Ordner gewaehlt wurde, wird in den Direkt-Suchen-Modus in dem Ordner umgeschalten.
		- wenn eine Datei gewaehlt wurde, wird der Inhalt angezeigt
			- wenn die 1. Zeile kein existierender Pfad ist, im Quelltext-Modus.
			- wenn die 1. Zeile ein existierender Pfad ist, in einem Modus 
			  der z.B. fuer Favoriten-Gruppen geeignet ist.
		PS. wenn direkt oberhalb Edit2 Eingabe-Felder aufgehen, kann darin die Suche verfeinert werden:
		- Linkes Feld ist ein Namen-Filter
		- rechtes Feld ein Zeilen- oder Pfad-Filter
0.410	Fehler bei 0.409 bereinigt.
0.411	das Pfad-Wahl-Menu springt (sofern Platz vorhanden) knapp unter der Schreibmarke auf.
		Dies kann als Kontrolle verwendet werden, welches Feld den Fokus hat.
0.412 0.413	Die Pfad-Wahl wurde oben um 2 Eintraege erweitert. 
		- Aktueller Suchbergriff	-->	Suchbegriff editieren
		- Trennstrich	-->	ZZO-Fenster aktivieren
0.413 0.414	Das Suchfeld vom Explorer kann mit #b in die ZZO-Suche uebernommen werden.
		Es handelt sich hier um eine Direkt-Suche (ohne Cache) deshalb vorsicht bei langsamen (Netz-) Laufwerken.
0.415	von #b wird auch #32770 (Speichern unter) das Feld Edit2 wie Edit1 unterstuetzt.
0.416 bis 0.432 Quelltext aufgeraeumt und umsortiert
0.433	Pfad-Wahl intern auf ######PPPPPPPPPPPPP... umgestellt # ist eine Integer-Ziffer	P ist der Pfad 
		in ###### steht soweit rechts geht die Pfadnummer als Integer, links mit Nullen gefüllt
0.434	Pfad-Wahl blaetterbar
0.435	Ergaenzungen beim Struktur-Vorlage-Assistent
0.436 bis 0.442 Quelltext aufgeraeumt, kleinere Fehler behoben sowie kleine Ergaenzungen durchgefuehrt.
0.443	oeffnen mit zusaetzlich RunWait implementiert.
0.444	#b erweitert auf: im Clipboard sind Pfade und bei der Pfad-Wahl wird ein Oeffnen-Mit-Favorit (enthaelt `%E8`%) gewaehlt.
		Es wird versucht die Clip-Pfade durch jeweiliges einsetzen in `%E8`% zu starten.
0.445	Fehler bei \ im Suchstring duch deaktivieren entfernt.
0.446	HintergrudFarbe Gui hell
0.447 bis 0.449	Container-Schnellwahl
o.450	Edit11 und Edit12 wird auch Suche-Rueckgesetzt
0.451	Suchverlauf oben die neuen Eintraege
0.452	Zeige Inhalte im Menu zusammen sortiert
0.453	Fehler bei der ContainerNr. beim Anlegen von Favoriten beseitigt.
0.454	Versionierung von ZZO selbst vereinfacht. Unvertiges BeispielSkript auskommentiert.
0.455	Tastaturbedienung bei der Schnellwahl erleichtert
0.456	Tastaturbedienung beim Hauptmenue erleichtert 
		Das ZZO-Hauptmenue ist nun auch separat,
		also auch bei aktivierten Fremdfenstern via #m, das heist via [Win] + [m] aufrufbar.
		Beim Aktivieren via #m schrumpft das sonst horrizontal liegende Menue allerdings auf einen senkrechten schlanken Balken zusammen.
		Das a bleibt jedoch das Datei-Menue, das b das Edit8-Menue etc.
		Das bisherige Menue hat eine neue 1. Spalte links vom Datei-Menue bekommen, sie dient als Alternative die Buttons zu bedienen.
		Per Tastatur ist diese aller erste Spalte via #m gefolgt von der Leerzeichen-Taste aufrufbar.
		Das in Win7 sichtbare Zeichen ist also kein Unterstrich, sondern es ist ein unterstrichenes Leerzeichen.
		Die anderen Spalten und die Eintraege muessten selbsterklaerend sein.
		#m   a   1	startet z.B. ZZO neu. 
		Hinweis: Ein Neustart kann schneller und zielfuehrender sein als zurueck zum HauptKontainer und Suche ruecksetzen.
		Dieser Neustart kann bei der Verwendung von #b einiges erleichtern, 
		es muss allerdings wenn mit #b schon eingeleitet wurde,
		zuerst [Esc] zum schliessen des Schnell-Wahl-Menues und dann #m   a   1	gedrueckt werden.
		(bei Win10 funktionierte bei mir die reine Tastaturbedienung. Bei Win7 nicht immer, 
		nach #m gefolgt von einem Buchstaben danach mit der Maus weiter klappte meisst). 
0.457	Schnell-Wahl zeigt Next nur wenn noetig an
0.458	Schnell-Wahl versucht auch noch nach Suchstringaenderung an der richtigen Stelle aufzupoppen.
0.459	Fuer Cachelose Direkt-Such-Container kann eine Datei mit Dem Namen AutoEdit2.txt 
		mit einem Suchstring als Inhalt in den Container-Ordner kopert werden. 
		Z.B. %WurzelContainer%\ContainerName\AutoEdit2.txt
		Bei jedem Ruecksetzen der Suche, wird dann der Inhalt nach Edit2 kopiert.
		Beispielinhalt: FilP://D:\Gegenst\**,DFR In_Row? 
		fuer Direkt-Suche in D:\Gegenst rekursiv von Dateien und Ordnern mit der moeglichkeit zwischen den Sternen
		nach dem Namen und am Stringende im ganzen Pfad zu suchen.
0.460	Fehler im Quelltext-Uebergabe-Pfad zu Scite behoben.
0.461	Dieser PC als Macro-Vorschlag und als SuperFavoritenPfad-Vorschlag angeboten.
		letzteres nur wenn keine Datei mit dem SuperFavoritenPfad existiert 
		und der Macro-Vorschlag schon erfolgreich ausgefuehrt wurde.
0.462 und 0.463	Doppelte Auswertung von Edit2, im Zusammenhang mit Edit11 undEdit12, entfernt.
0.464	Edit8 wurde bei 0.462/3 nicht ueberall nachgezogen
0.465	Nicht Freigegeben: #b bei Fokus auf Scite Haupt-Edit-Feld schreibt z.B. 
		CoTe://WTitle? ahk_id 0xb0dd6 Contro? Scintilla1 Nr_Row?
		nach Edit2
0.466	Nicht Freigegeben: erste geglueckte Auswertungesversuche von 0.465
		auch Notepad-Edit1-Inhalt
		CoTe://WTitle? ahk_class Notepad Contro? Edit1 Nr_Row? 
		wird angezeigt.
0.467	Fehler von 0.466 behoben, erstes Zeichen vom Suchbegriff wurde bei den Fundstellen nicht ausgewertet.
0.468	Macro-Debug-Modus nach Fehlerbereinigung freigegeben. Siehe Menu | Macro | ...
0.469	Clipboard-Pfade 2 ZZO-Favoriten wurde ein unvollstaendiger Pfad 
		gegen einen Vollstaendigen ausgetauscht.
0.470	Favoriten verstaendlicher gestalten vorbereitet 
		(Label InAktFavSuchbegriffeEinfuegen Funktion InFavSuchbegriffeEinfuegen(FavDirPath)
0.471	Suchabbruch bei Direkt-Suche eingefuehrt. ToDo: alle bleibenden Protokolle nachziehen.
0.472	Suchabbruch bei in Edit2 vorhandenem → temporaer auf 999999
		Doppelte bei → enfernt.
0.473	GetPathOrLinkedPath(Path) erstellt und bei 
		Edit8 ... 2 ... Edit5 
		Aufrufen dazwischengeschleift. Die Funktion kann jedoch allgemeinere Verwendung erhalten.
0.474	Suchen und Ersetzen beim Clipboard-Editor implementiert.
0.475	Direkteintrag in Edit11 und Edit12 an weiteren Stellen unterstuetzt.
0.476	Protokolle vereinheitlicht:
		links nicht mehr unterstutzt  					weiterhin unterstuetzt
		FilP://c:\temp\*Suchbegriff1*,DFR Suchbegriff2  ersetzt durch 	FilP://c:\temp\*Suchbegriff1*,DF In_Row? Suchbegriff2  
		file://c:\temp\Change.Log Suchbegriff  		ersetzt durch	file://c:\temp\Change.Log In_Row? Suchbegriff  
		FilP://c:\temp\**,DFR InName? Suchbegriff			FilP://c:\temp\*Suchbegriff*,DFR InName?
		in der ErprobungsPhase ob weiterhin benoetigt			bester Ersatz
		file://c:\temp\Change.Log InName? Suchbegriff			file://c:\temp\Change.Log In_Row? Suchbegriff
0.477	Funktionen fuer CMD und fuer PowerShell fuer erste Tests implementiert. 
		Diese sind nicht freigegeben!
0.478	Sortiere Beste Uebreinstimmung nach oben (Label SortBestAutoBewertung) implementiert.
		Erster Wurf beim Optimum ist viel denkbar.
0.479	%SkriptDataPath%\AutoMacro.txt  Moeglichkeit zur Vorgabe eines individuellen Macros im Container.
		Wird bei Suche Ruecksetzen ausgefuehrt.
		Zum Vergleich:
		%Edit2DefaultAusDateiPfad%	 Moeglichkeit zur Vorgabe eines individuellen Suchstrings in A_ScriptDir
		%SkriptDataPath%\AutoEdit2.txt	 Moeglichkeit zur Vorgabe eines individuellen Suchstrings im Container
		vorhanden.
0.480 0.481 Optimierungen an SortBestAutoBewertung. interne NotWord-Liste eingefuhrt
0.482	Im Schnell-Wahl-Menu wurden bisher Eintraege laenger 200 Zeichen weggelassen.
		Nach einer laengeren Fehlersuche, nach Fehlern, 
		die keine waren wird folgendermassen vorgegangen:
		Nun werden sie nicht mehr wegelassen sondern nur noch das was laenger als 240 Zeichen ist
		bei der Anzeige weggelassen. Aufrufbar aus ZZO Sicht sind Sie,
		aber wenn das Betriebssystem an die maximale Pfadlaenge stoest(in Win 10 abschaltbar)
		kann ich keine Vorhersagen machen wie das Verhalten ist.
0.483	bei FilP:// nun auch der Start-Pfad ohne * und ohne \ dem bisherigen Ergebnis voangestellt.
0.484	Ordner oder Dateien nachtraeglich nach oben sortieren in 
			Menu | Pfade |       Dabei diese Worte nach oben/unten
		integriert.
		Hinweis: die Nachtraegliche Sortierung ist fuer unter 1000 Pfad-Fundstellen gedacht.
		Vorher sollten die Fundstellen durch laengere Suchbegriffe etc. minimiert werden.
		Trotzdem benoetigt die Nachtraegliche Sortierung meist volltaendige Pfad-Fund-Stellen (Edit5),
		d.h. Edit1 sollte Klammerlos sein.
		PS. Eine Vollstaendige Pfadliste erhaelt man als Nebenprodukt, 
		nach Eingabe eines brauchbaren Suchbegriffs, durch
			Menu | Pfade | sortiere Edit5-Zeilen kurz oben
0.485	RegEx Suche fuer Quelltexte oder Logfiles
		i)(.*edit11.*)(.*Edit12.*)|(.*edit12.*)(.*Edit11.*)    findet Edit11 UND Edit12 Reihenfolge egal
		muesste auch Edit12 vor Edit11 finden
0.486	LogFileUnterstuetzung:
		Eine Datei mit der Endung .log wird uebergeben
		 - bei Programmstart (Ue1)
		 - per Drag and Drop auf Edit1
		als Quelltext geoeffnet. 
0.487	%A_ScriptDir%\ImHauptPrgAmEnde.ahk mit diesem Include sind 
		individuelle Aenderungen am Ende des Hauptprogrammes moeglich.
0.488	Funktion GetPathInfo(Path) erstellt, sie besorgt Infos zu Pfaden und cached diese.
0.489	Stoerenden Tooltip entfernt
0.490 0.492	MachsBesteDraus im #v Menue aufgeteilt bzw. vorbereitet zum aufteilen: 	- vom fokusierten Control wird gelesen (Label MachsBesteDrausLesen) 	- ins fokusierte Control wird geschrieben (Label MachsBesteDrausSchreiben). (Die Aufteilung sollte noch konsequenter werden!)
0.493	offene Baustelle mit Textinhalt von Browserfenster
0.494	Hauptmenue Tasteturbedienung konfigurierbar via Variable MenuKurzTasten
0.495 0.496	Mehrsprachige Menues begonnen
0.497	Menu | Start-Pfad | Start-Pfad-Schnell-Filter zeigt jetzt wieder an.
0.498	Such Historie benutzerfreundlicher gestaltet:
		1. Such-Historien-Eintrag mit UpDown Button-(links an Edit2) auswaehlen
		2. alte Suche mit Return zurueck in Edit2 bringen
		oder
		2. DoppelKlick auf Such-Historien-Eintrag
		oder
		2. Menu | Filter | angezeigte Suche restaurieren
0.499	SuchBegriffs-Log um Anzahl der Fundstellen erweitert.
0.500	SuchBegriffs-Log-Eintrag nur wenn er sich vom Vorigen unterscheidet.
)
VersionsHistorie6=
(
0.501	Flags von TastWatch.ahk ueberarbeitet. Einzeln via Tray-Menu schaltbar.
0.502	Suchbegriffe der Art 
		Gerdi%ReturnChar%Gerda
		werden als Vereinigungs-Menge von Gerdi und Gerda interpraetiert.
		Eine Auswertung erfolgt wie bei %Pfre% (Differenz-Menge) erst nach Aktualisierung via Button1. 
		Eine Kombination von %ReturnChar% und %Pfre% wird momentan nicht unterstuetzt.
		Beispiel fuer Geduldige:
		FilP://c:\**,DFR In_Row? Gerdi%ReturnChar%FilP://d:\**,DFR In_Row? Gerdi%ReturnChar%FilP://f:\**,DFR In_Row? Gerdi
		FilP://c:\*Gerdi*,DFR In_Row? %ReturnChar%FilP://d:\*Gerdi*,DFR In_Row? %ReturnChar%FilP://f:\*Gerdi*,DFR In_Row?
0.503	Der Focus wird in FokusEdit2Rechts() nur noch bei aktivem ZZO-Fenster gesetzt.
		pruefen ob weitere Focus-Setzungen auf das aktive ZZO-Fenster begrenzt werden muessen! Es gab Schreibbprobleme bei #b wenn der oberste Menuepunkt aufgerufen wurde und das ZZO-Hauptfenster miniemiert war.
0.504	Die SuchverlaufsAnsicht wird nun auf Wunsch aus der Ansicht verschoben (technisch gesehen versioniert) nicht wie bisher geloescht.
0.505 bis 0.507	Inhalte von mehreren Dateien anzeigbar. Siehe 
		Menu | Filter | Suchverlaufe anzeigen
		Dazu wurde der Kenner 
		InInhaltKenner = %InInhaltKenner% 
		implementiert. Dieser wird voraussichtlich nur mit dem Kenner
		FilePatternKenner = %FilePatternKenner%
		unterstuetzt.
0.508	Mit 
		Menu | Edit8 | Zeige Such-Text-Zeilen mit Pfaden des Ordners
		kann nach Textinhalten von Dateien in ganzen Ordnern gesucht werden.
		Eine Text-Extraktion erfolgt dabei nur in sofern, wie Autohotkey Dateien als Text einliest.
0.509	Mit 
		Menu | Favoriten | suchen
		koennen Favoriten im aktiven Container gesucht werden.
		In Ergaenzung zur Edit2 Direkt-Suchstring-Eingabe koennen auch Faforiten ueber ihre Inhalte gefunden werden.
		Dazu ist das rechte Suchfeld verwendbar. Das linke Suchfeld wirkt aehnlich bis identisch wie die Direkt-Suchstring-Eingabe.
0.510	Eine Datei namens 
		SuchStringSpeicher.BeliebigerExt
		wird von ZZO unterstuetzt um je Zeile eine Suche zu speichern.
		Beispielweise kann ein Container erstellt werden der die 2 Dateien 
		- AutoEdit2.txt
		- SuchStringSpeicher.txt
		enthaelt. In der ersten Datei steht der Pfad zur zweiten Datei. Die koennte wie folgt aussehen:
		file://C:\Portabel\ahk-unicode-enter-master\unicode definitions\unicode definitions.txt Nr_Row? 
		FilP://C:\Program Files (x86)\ZackZackOrdner\*SchnellOrdner*,DF In_Inh? 
		...
		Der Containername
		SuchStringSpeicher
		sollte auch das Suchspeicher-geeignete oeffnen via Doppelklick oder [Return] bewirken.
0.511	Die Such-Historie enthaelt bei Cache-Suchen den Container.
0.512	Die Such-Historie enthaelt bei Cache-Suchen die Start-Pfad-Nummer oder andere Filter.
0.513	Mit  der Datei
		%SkriptDataPath%\AutoSubstEdit2.txt
		kann der Suchbegriff von Edit2 automatisch durch die Zeile 1 ersetzt werden.
		dies aber nur wenn Zeile 2 nicht im Suchbegriff vorkommt.
		Beispiel-Datei-Inhalt:
		FilP://C:\Users\%A_UserName%\*`%Edit2`%*,DR In_Row? 
		://
		Zeile 2 ist notwendig um eine Endlosschleife zu verhindern.
0.514	[Win]+[Enter] erzeugt %ReturnChar% in ZZO-Edit-Feldern. Siehe 0.502
		Mit %ReturnChar% kann man auch die direkte Auswertung waehrend der Eingabe verhindern.
		Die letzte Aktion ist dann das Loeshen von %ReturnChar%.
0.515	Funktion GetObjectDetails() erstellt. 
		Parameter 1: das Objekt der Informations-Begierde
		Parameter 2: optional der Objektname
		Ruekgabe: Zeilenweise Key - Value Werte Hierarchisch eingerueckt
		(Nur fuer Power-User)
0.516	[Strg] + [Shift] + [c] 	 wie 	 [Strg] + [c]	aber der neue Text wird im Clipboard unten angehaengt.
0.517	Haupt-Menu | ? | Variablen anzeigen
		zeigt alle im Skript verwendeten globalen Variablen + deren Kurz-Inhalte an (oder Dito gefiltert, wenn Edit2 ergaenzt wird).
		Durch anhaengen von "Haupt" werden nur noch Variablen, die Haupt im Inhalt oder im Namen enthalten, angezeigt. 
		Hinweis: Objekt-Inhalte werden nicht angezeigt, sonst nur die ersten 59 Zeichen!
		Edit2 kann auch als Muster fuer andere anzuzeigende Controls dienen. 
		Die Werte "Wintitle" und "Control" koennen mit Tray-Menu | Windows Spy ermittelt werden.
		Hinweis: nicht jedes Control laesst den Textinhalt auf diese Weise ablesen.
0.518	Programm-Start-Uebergabe-Parameter <Macro> und </Macro> werden unterstuetzt.
		D.h. alle Parameter dazwischen werden als Macro nach dem vollstaendigen Programmstart ausgefuehrt.
		"%A_ScriptFullPath%" <Macro> ZZOAktualisieren </Macro>
		beendet ZZO und versucht die neueste Version zu Downloaden und zu Installieren.
		"%A_ScriptFullPath%" <Macro> "DiesenBefehlsDateiPfad=%A_AppData%\Zack\Macro\1_Zeige Edit Zuordnung.txt" DiesenBefehlsDateiPfadAusfuehren </Macro>
		Hier wird gezeigt wie eine Macro-Datei beim Start aufrufbar ist.
		PS. Es sind auch mehrere <Macro> ... </Macro> Paare zulaessig.
		wenn das Letzte </Macro> fehlt wird bis zum letzten Programm-Start-Uebergabe-Parameter als Macro interpraetiert.
0.519	SuperGlobal Flag EvalButton1Only teil-implementiert.
		☑warte	 	Evaluiert wird erst nach betaetigen von Button1 bzw. [F5]
0.520	Eine aktuelle Live Suche kann mit  HauptMenu | Filter | aktuelle Live Suche 2 LnkMacro
		fuer den Programmstart in einer Verknuepfung gespeichert werden. 
		Nach dem Start ueber die Verknuepfung wird der Container und die Suche wiederhergestellt. 
		Falls der Container komplett leer ist, wird nachgefragt,
		ob diese Suche fuer diesen Container voreingestellt werden soll.
0.521	HauptMenu | Macro | (Edit8) LnkMacro starten 
		Damit die in 0.520 erstellten LnkMacro-Dateien auch bei laufendem ZZO ausgefuehrt werden koennen.
		Benutzes Label DoEdit8LnkMacro bzw. benutzte Funktion DoLnkMacro(LnkPath)
0.522	ShowClipHist:=true. in Edit4 eigegeben Zeigt in Edit5 eine gekuertzte Clipboard-Historie, 
		die sich bei Clipchange aktualisiert. Edit4 wird im Expertenmodus sichtbar. 
		Alternativ ein Macro mit dem Inhalt 
		ShowClipHist:=true 
		zum Einschalten und 
		ShowClipHist:=false 
		zum Ausschalten erstellen.
0.523	Ein im Explorer selektierter Pfad kann mit [Win] + [b] als Wurzel fuer die Live-Suche von ZZO gemacht werden.
0.524	interner Log eingefuehrt: 
		DebugViaBeschLog := false    und es gibt ihn nicht (false ist Voreingestellt).
		GetGlobalVarAndValueList erwartet Kommagetrennte Liste der Variablen-Namen, 
		die zusaetzlich mit Kurzinhalten (18 Anfangs-Buchstaben  ...  17 End-Buchstaben) ausgegeben werden sollen. 
		Dynamische Variablen erhalten hier vor jedem `% ein `,
		damit nicht hier und jetzt ausgewertet wird, sondern benutzungs-nahe.
		Jedesmal wenn die Fuktion
		BeschaeftigtAnzeige(BeschZaehler,ThisFunc)
		aufgerufen wird ruft diese wiederum die Funktion beispielweise so
		GetGlobalVarAndValue("A_EventInfo","0")
		auf. Die 0 besagt, dass bei diesem Ergebniss der ganze Eintrag weggelassen wird. 
		Es ist auch 
		GetGlobalVarAndValue("A_EventInfo","0" ","1" ","2" ","3" ","4") 
		erlaubt. Hier werden die Ergebnmisse 0; 1; 2; 3; 4 wegelasen.
		Fehlersuchende koennen Je ein Macro
		DebugViaBeschLog:=true		mit dem Name FunktionenUndUnterprogrammeProtokollBeginn.txt
		DebugViaBeschLog:=false		mit dem Name FunktionenUndUnterprogrammeProtokollEnde.txt
		erstellen.
0.525	Tests mit der Powershell durchgefuehrt. TestsRunWaitPsEin(Befehl) <-- wird noch umbenannt
0.526	Fuer Macros wurden die Labels StopComputer und StopComputerForce zum Herunterfahren des PC's bei Marcroende.
0.527	Neues Miniskript ExternalTooltip.ahk implementiert fuer kurzfristige Text-Anzeigen.
0.528	*send ^[Buchstabe] durch *send {CtrlDown}[Buchstabe]{CtrlUp} Projektweit ersetzt.
		Weil ein ControlSend ... ^a ... die Ctrl-Taste virtuell untengehalten hat.
		Quelltext aufgeraeumt.
0.529	fehlerhaftes ersetzen bei 0.528 korigiert, sodass Klicks auf Pfade in Edit5 wieder funktionieren sollten.
0.530	Optimierungen bei MachsBesteDraus und bei Edit11 und Edit12
		ToDo: MachsBesteDraus sollte grundsaetzlich ueberarbeitet werden.
0.531	Funktion IsBefore(St1,St2) liefert wahr, wenn St1 Alphabetisch vor St2 kommt.
0.532	Fehler bei MachsBesteDraus via UebrwachungExplorerSuchFeld.exe behoben.
0.533	HauptMenu | Pfade | sortiere Editzeilen Aenderungsdatum		(Label: SortMTimeAlle)
		Sortiert nach dem aktuellen Aenderungsdatum°, erhoeht vorher drastisch die Anzahl der "erwarteten Fundstellen vor Suchabbruch" (Edit6). 
		(° wird auch bei der CacheSuche frisch abgefragt)
		Hinweis: Die vergleichbare Aktion, auf einer elektronischen Festplatte bzw. auf einem Netzlaufwerk,
		kann Bearbeitungszeiten im Sekunden-Bereich bzw. Stunden-Bereich benoetigen.
		Dieser Zeitunterschied tritt besonders beim Sortieren mit Live-Abfragen auf, 
		da diese Live-Abfragen pro Pfad mehrfach durchgefuehrt werden.
0.534	Labels: SortMTime SortMTimeR SortMTimeAlle SortMTimeAlleR
		ergaenzt fuer Macroaufrufe		Sort-> sortieren		M-> Modification Time		 R-> Reverse (Alt oben)
		Alle-> setzt temporaer Edit6 hoch und Startet dann die Suche erneut.
0.535 0.536	Edit8 mit viel maechtigerem HtmlFile-Edit8 ergaenzt bzw. in der Anzeige ersetzt.
		Die neue Edit8-Anzeige unterstuetzt Pfadteilabhaengige Mausklicks (links und rechts).
		Beispiel:	Edit8 = c:\temp\AhkHelp		linksklick auf temp oeffnet c:\temp im Explorer
		Rechtsklick fraegt was mit c:\temp geschehen soll. 
		Programmtechnisch gesehen ist die neue Anzeige,
		ein Pfad der in eienem einzeiligen Internet-Explorer-Fenster dargestellt wird. 
		Nun kann jeder Link dedizierte Aktionen ausloesen,
		momentan Unterstuetzte Pfadteile:
		Laufwerk	uebergibt Laufwerk dem Explorer
		Netzlaufwerk	uebergibt Netzlaufwerk dem Explorer
		OrdnerName	uebergibt Ordnerpfad dem Explorer
		Dateiname	uebergibt Gesammtpfad dem Explorer
		Extender	oeffnet Gesammtpfad
		Edit8	GesammtPfad als Explorer Select
		Nicht (mehr) existierende Pfadteile werden schwarz dargestellt, d.h. nicht mit Links versehen
		momentane Fehler:
		Favoriten die HTTP:// HTTPS:// FTP:// enthalten werden doppelt geoeffnet.
		Hinweis: Das automatische Anlegen von Ordnern mit Nachfrage, laesst sich nun nicht mehr via Edit8 editieren erledigen (ab 0.538 wieder direkt eingebbar).
		Via editieren der richtigen (die in Edit3 stehende) Zeile in Edit5, sollte es uebergangsweise weiterhin funktionieren.
0.537	#?:: Hotkeys auf ~#?:: Hotkeys umgestellt
0.538	neues Eingabefeld fuer neue Ordner eingefuehrt.
		Erscheint nur bei Ordnern rechts in Edit8-Anzeige
0.539	Edit8NeuerOrdner auf neues Eingabefeld angepasst
0.540	Kurztaste von Menu | Edit8 | umbenennen richtiggestellt.
0.541	SetPathsInClipAllTime zum setzen von Zeitstempeln wartet auf Macro-Einsatz.
0.542 bis 0.546 Live Suche Edit12 auf Mehrere Suchbegriffe umgestellt
		Mit ODER vereinigte Begriffe koennen nun durch Komma getrennt eingeben werden
		Katze,Maus	findet sowohl Katze als auch Maus
		Mit UND vereinigte Begriffe koennen nun durch ``n (Zeilenvorschub) getrennt eingegeben werden.
		Katze``nMaus	findet nur Fundstellen die beides enthalten.
		Eine beliebige Schachtelung ist moeglich:
			Katze,Maus
			Jaeger,Gejagter
		(Zur uebersichtlicheren Darstellung wurde ``n durch eine neue Zeile Dargestellt.)
		Findet das Gesuchte wenn sowohl Katze oder Maus als auch Jaeger oder Gejagter in der Such-Quelle ethalten ist.
		(Katze ODER Maus) UND (Jaeger ODER Gejagter)
		Beispiel:
		file://SchnellOrdner.ahk Nr_Row? ::``nF1,F2,F3,F4,F5,F6,F7,F8,F9,F0
		Zeigt alle Funktionstasten-Hotkeys an.
		Hierarchie:
			a,b,c,d
			e,f,g,h
			i,j,k,l
		-->
			(a ODER b ODER c ODER d)
				UND
			(e ODER f ODER g ODER h)
				UND
			(i ODER j ODER k ODER l)
		Das wirkliche setzen von Klammern wird nicht unterstuetzt.
		Das Komma-Zeichen selbst kann mit 2 Kommas erzeugt werden.
0.547 0.548	Dito wie 0.542 fuer Edit7
0.549	Nach Skriptstart oder in Zeit-Intervallen koennen Macros gestartet werden.
		Dazu ist der Ordner 
		%MacroTimerOrEventStartedDir% 
		zu erstellen 
		und wenigstens ein Macro mit folgender Namens-Konvention ein zu fuegen.
		Start_Asap_Macro_Beliebiger Macroname.txt	
		fuer nach Skriptstart einmalig auszufuehrendes bzw.
		Start_Every_IntegerintervallInMilliSec_Macro_Beliebiger Macroname.txt	
		fuer mehrfach auszufuehrendes.
		Weitere in Planung.
		Beispiel:
		Start_Asap_Macro_Freier Speiherplatz auf C Pruefung.txt
		mit dem Inhalt
		Edit5MeldungWennWenigSpeicherAufC
		welcher das gleichnamige Label aufruft. 
		Dann wird nach jedem Skriptstart geprueft ob das Betribssystem atmen kann.
		Reichen die in ZZO zur verfuegung gestellten Macro-Befehle nicht aus koennen via 
		%A_AppData%\Zack\Macro\TimerOrEventStarted\include1.ahk
		Labels oder Funktionen hinzugefuegt werden. 
		Achtung: hierbei wird keinerlei Sicherheitspruefung durchgefuehrt,
		alles was AHK nach dem Hauptprogramm anbietet kann benutzt werden.
0.550	Funktionsaufrufe via §Variable§FunktionsName§Parameter1§Parameter2§... auf bis zu 14 Parameter erhoeht.
0.551	Loop fuer Macros implementiert:
		Loop``nIntegerSchleifenAnzahl``nBefehl1``nBefehl2``n...
		Beispiel: Loop``n15``nDown1``nSchlafe200
0.552	Wenn(Variable1,Bedingung,Variable2,JaBefehl1,JaBefehl2,...,"else",NeinBefehl,NeinBefehl2,...) fuer Macros implementiert
		Aufruf in Macros via
		§§Wenn§Variable1§Bedingung§Variable2§JaBefehl1§JaBefehl2§...§"else"§NeinBefehl$NeinBefehl2§...
		Momentan vorhandene Bedingungen:
		IstGleich
		IstUnGleich
		IstGroesser
		IstKleiner
		IstInStr
		Beispiel: §§wenn§Edit3§"IstGroesser"§"5"§"Piep9"	Label Piep9 muss dazu siehe 0.549 includiert sein
0.553	SendMail() implementiert naeheres siehe Komentare in der Funktion im Quelltext.
		Hinweis der fest verdrahtete Sendmai-Include-Pfad ist keine Einschraenkung. 
		Er kann mit weiterem include auf einen moeglichst sicheren Pfad umgebogen werden.
		Somit muessten alle Voraussetzungen vorhanden sein um eine ServerUeberwachung,
		(Plattenplatz, LogfileEintrage, Sonstige Ereignisse) automatisiert mit ZZO durchfuehren zu koennen.
		Bei Beratungsbedarf bitte einen Forenbeitrag in https://autohotkey.com/boards/viewtopic.php?f=10&t=15248 erstellen.
0.554	Hotkey ~#n auf ~LWin & n umgestellt
0.555	Fehler bei Klick auf Objekt vor dem Hauptfenster entfernt.
		Button5 kann optional Links erzeugen. Dito fuer Drag and Drop auf Edit5.
0.556	FindExecutable() eingebunden
0.557	Edit8 Anzeige Symbol Zahnrad ⚙ eingefuehrt: 
		⚙ Diese Datei laesst sich mit einem anderen Programm starten.
		⚙⚙ Diese Datei kann selbst starten.
		Fuer Macro-Ersteller
		⚙		entspricht Flag 	Edit8Info.3.KannAusgefuehrtWerden 
		bspw. vom Programm mit dem Pfad 	Edit8Info.3.AusFuehrPfad
		⚙⚙		entspricht Flag 	Edit8Info.3.KannAusfuehren
0.558	FindExecutable() auf Langnamen (8+3 Begrenzung entfernt) umgestellt.
0.559	Bei der Anzeige von Edit8 werden mehrere IfExist-Abfragen gemacht.
		Diese sind nun vorzeitig durch neuere Eingaben beendbar. 
		Mit Button1 ist diese Abbruchmoeglichkeit nicht moelich.
)
VersionsHistorie7=
(
0.560- 0.562	"Kenner" von Live-Suche ueberarbeitet.
		Fehler bei WTitle? beseitigt.
		Hinweis: WTitle? benoetigt wie das Original WinTitle in AHK 
		eine exakte Gross-Klein-Schhreibung.
		D.H. zwei Zeilen tiefer wird zwingend Variables mit gossgeschriebenem V erwartet.
		SysListView321-Controls werden unterstuetzt.
		CoTe://WTitle? Variables Contro? SysListView321 Nr_Row? zeigt Fensterinhalte von
		DebugVars.ahk		https://github.com/Lexikos/DebugVars.ahk
		an. Wenn DebugVars.ahk-Master mit Lib im Skriptordner ist wird  
		DebugVars.ahk
		auch von
		HauptMenu | ? | Variablen anzeigen
		verwendet. Diese Ansicht kann wie gewohnt gefiltert werden.
		Lib		[dbgp.ahk](https://github.com/Lexikos/dbgp)
		PS. DebugVars.ahk ist sehr empfehlenswert fuer die Fehlesuche in AHK-Skripten.
		Mit #b koennen auch aktive Unterfenster mit Fokus auf SysListView321 von DebugVars.ahk gefiltert werden.
0.563	In der Edit8 Anzeige werden Ordner deren Zugriff verweigert wird rot Hinterlegt.
		Zur Erinnerung existente Ordner werden gelb hinterlegt.
		Dateien sind nicht d.h. weis hinterlegt.
0.564	Bei mehreren Selektierten Dateien im aktiven Explorer-Fenster, uebernimmt #b diese in Edit5.
0.565	UmstellungsBeginn F4 mit anschliessendem HauptMenu | Edit8 | oeffnen mit
		benoetigt den manuellen Start von GetRegExt.ahk
0.566 0.567	Oeffnen mit auf 2 Schritte umgestellt
		Kurz: 	
		zustartende Datei waehlen 	Start mit Programm 	wahlen
		Detailiert:
		1.) Aufruf von Oeffnen mit (in allen Containern ausser Start Menu)
		Sprung in Container Start Menu mit vorausgefuelltem (=Extender) Suchstring.
		2.) Wahl des Oeffnen Mit Programms. Bestaetigung durch nochmal Oeffnen Mit.
		oeffnet Edit8 von 1.) mit Programm von 2.) 
		und zeigt anschliessend wieder den Ursprungs-Container an.
		Alternativ kann auf ⚙ oder ... geklickt werden.
		Achtung: LinksKlick startet sofort. Rechtsklick auf ... wartet auf Escape oder Enter.
		Wenn diese Tasten nicht zeitnah gedrueckt werden, kann das spaeter aufsprigende Kontext-Menu nicht mehr zugeordnet werden, bei zufaelliger Eingabe von Escape oder Enter.
		Veraltet: 
		Oeffnen Mit Speicher und `%E8`%. <- Wird fuer Macros vorerst drinnen gelassen.
		und Spaeter entschieden ob weiter benoetigt.
0.567 0.568	Der Cache %ProgExtDir% fuer Oeffnen Mit wird mit dem noetigsten gefuellt.
		Es wird empfohlen im Container Start Menu weitere Favoriten nach folgendem Schema anzulegen:
		DateiName	.Ex1.Ex2.Ex3.Ex4.Ex5.Ex6.ProgrammName.Ext.Txt
		DateiInhalt	VollstaendigerExePfad 	in der 2. Zeile (Die Erste Zeile ist leer)
		Danach ist dieses Programm bei den Extendern Ex1 bis Ex6 mit im Oefnnen Mit Rennen.
0.569	Konstante Prozent erstellt, sie enthaelt das Prozent-Zeichen. 
		Seit 0.546 werden von Prozent-Zeichen umgebene Variablen versucht vor der Suche zu Evaluieren.
		Nun kann auch nach dem Prozent-Zeichen selbst gesucht werden.
		Beispiel: Hauptmenu | ? | Quelltext anzeigen	F12 druecken	`%Prozent`% eingeben
		findet alle Quelltextzeilen die `% enthalten.
		`%Prozent`%A_ScriptDir`%Prozent`% findet Zeilen mit `%A_ScriptDir`%
0.570	file://PfadVonBeliebigerDll In_Row? 	zeigt DLL-Aufruf-Strings an
		Beispiel:
		file://C:\Windows\System32\msrating.dll In_Row? pages
		zeigt
		RatingAddPropertyPages
		Dies sollte fuer fast alle Fundstellen von
		filp://%A_WinDir%\*.dll,FR In_Row? 
		mit der Tastenkombination
		^Right
		funktionieren.
0.571	FilP://%A_WinDir%\*.dll,FR In_Inh? 	zeigt in welchen dll's kommen welche Aufrufstrings vor.
		Beispiel:
		FilP://%A_WinDir%\*.dll,FR In_Inh? get_parent
		Ich habe jedoch keine Ahnung ob gleiche Aufrufstrings verschiedener DLL's identische Aufgaben bewaeltigen koennen.
		PS. momentan unterscheidet ZZO bei der DLL-Abfrage nicht, zwischen gross und klein-Schreibung.
		Bei DLL-Abfragen jedoch, wird sehrwohl unterschieden.
0.572	oeffnen mit weiter vereinfacht
		1 zu oeffende Datei auswaehlen 				(alle Container ausser Start Menu)
		2 F4
		3 Programm zum Oeffnen auswaehlen			(im Container Start Menu)
		4 Return
		Statt 3 und 4 kann auch ein Doppelklick auf das Programm zum Oeffnen getaetigt werden.
		Wer sich fuer 2 nicht F4 merken kann, der kann fuer 2 und 4 auch jeweils  Hauptmenu | Edit8 | oeffnen mit  benutzen.
		RegGetExt.ahk kann jetzt auch mit mehreren OpenWith-Programme pro Extender umgehen.
		Zum Aktualisieren:
		Entweder RegGetExt.ahk manuell starten oder Ordner %A_AppDataCommon%\Zack\WuCont\Start Menu\ProgExt mit Inhalt loeschen.
		ZZO neu starten.
0.573	Vorbereitungen zur aufwertung des internen Explorers begonnen.
0.574	Fehler bei der Startart ohne AHK-Installation behoben.
		genauer: wenn SchnellOrdner.ahk nicht direkt gestartet wird, sondern ueber die gleichnamig umbenannte AutoHotKey.exe,
		dann sollten jetzt alle anderen AHK-Unter-Skripte auf die selbe Weise gestartet werden,
		egal ob AHK installiert ist, sofern jeweils die gleichnamige AHK.Exe im jeweiligen Verzeichnis vorgefunden wird.
0.575	RunZZO.ahk
		OpenWithZZO.reg
		warten in %A_ScriptDir% auf den Einsatz. Leztere zusammnegefuehrt (in die Registrier-Datenbank)
		ermoeglicht es, ZZO mit einem Explorer-Eintrag via RechtsKlick zu starten.
		Rechtsklick auf Ordner und Oeffnen mit ZZO startet ZZO mit file://OrdnerPfad Nr_Row? 
		Rechtsklick auf Datei und Oeffnen mit ZZO startet ZZO mit file://DateiPfad Nr_Row?
		zeigt also jeweils die Inhalte.
0.576	wie 0.576 jedoch auch mehrere Elemente uebermittelbar.
		Die Pfadansicht wird dabei ins Clipboard gespeichert.
0.577	Flag ObjectDetails zur Fehlersuche bei true
0.478	Flag GrossKlein fuer Suchunterscheidung teilweise implementiert. 
		Es werden weitere hinzukommen.
		Augeschlossen bleiben die Suchen, in denen intern FilePattern verwendet werden.
		HilfsRegel: in Sucheingabe-Bereichen in denen UND oder ODER Vereinigungen moeglich sind
		sollte auch eine Suchunterscheidung zwischen Gross und Kleinschreibung moeglich sein.
		Momentan kann GrossKlein nur via Befehl, Macro oder im Quelltext gesetzt werden.
		Hinweis: um bei der Cachesuche zwischen Gross un Klein zu unterscheiden,
		kann man den Edit2 Inhalt in Edit7 (Pfad-filter) wiederholen.
0.579 0.580	Genealueberholung Live Suche begonnen. 2 uebersichtliche Funktionen 
		LiveSuchStringAuswertung(LiveSuchString)
		LiveSuchUnterAuswertung(ges,KombiBefehl)
		sollen Bandwurm Unterprogramm abloessen
0.581	Tests mit 
		Cont://ContainerName[Tab]CacheSuchstring[Tab]KommaGetrennteListeDerStartPfadNummern[vTab]In_Inh?[Space]NachFilter
		z.B.
		Cont://Haupt	gerd	1,2,3In_Inh? baum
		Spezial Fall fuer Oeffnen Mit:
		Cont://Start Menu\ProgExt	.jpg
		PS. ein [Tab] kann in Edit2 mit 3 Leerzeichen erzeugt werden. (AHK Schreibweise `t)
		Ein [vTab] dito mit einem v davor. (AHK Schreibweise `v)
0.582	Nicht Belegug von Flag entfernt
0.583	InName?
0.584	-Nachfilter		- ist wie nicht zu lesen.
		z.B.
		Cont://Start Menu\ProgExt-InName? exe		Zeige alle Oeffnen Mit Eintraege die nicht EXE enthalten
		das nicht (=Minus) Zeichen wird anstatt dem vertikalen Tab verwendet.
0.585	FilP://%A_Temp%\Clip\**.txt,DFR2Z_Inh?%A_Space% 
		max 2 Zelige Inhaltsanzeige.
		ClipHist.ahk	muss gestartet sein und seither das Clipboard benutzt.
0.586	statt vTab ist nun auch + moeglich (z.B. FilP://C:\Users\Gerd\AppData\Local\Temp\Clip\**.txt,DFR+2Z_Inh? )
		+ oder - Nachfilter erzwingt die neue LiveSuche.
		In der neuen LiveSuche sind wesentlich mehr Kombinationen als bisher funktionsfaehig.
		momentan erfolgt kein Suchabbruch. Edit1 zeigt dia Anzahl der Zeilen.
0.587	unnoetige Leerzeilen am Ende von Edit5 entfernt.
		%FilePatternKenener% zeigt filterbar auch eigenen Ordner an
		FilP://%A_ScriptDir%\**,DFR-In_Row? .bak+In_Row? .ahk 	zeigt AHK-Skripte ohne BAk-Dateien
		FilP://%A_ScriptDir%\**,DFR+In_Row? .ahk-In_Row? .bak 	haette auch AHK-Skripte ohne BAk-Dateien anzeigen sollen,
		ist momnetan jedoch noch Fehlerhaft(das 2. minus wird als + interpraetiert.)
0.588 bis 0.590	Plus und Minus aus LiveSuche entfernt. Stattdessen
		¬		`%NOT`%
		direkt links am Filter angeordnet.
		obiges Beispil wird zu
		FilP://%A_ScriptDir%\**,DFRIn_Row? ¬.bakIn_Row? .ahk
		FilP://%A_ScriptDir%\**,DFRIn_Row? `%NOT`%.bakIn_Row? .ahk
		(beide Schreibweisen erlaubt)
0.591	HwndT://In_Row? uhr
0.592 0.593	HwndT:// holt viele Texte vieler Controls. (Geduld es wird eine Schleife mit FFFFFF Loops abearbeitet)
		HwndT://ControlHwnd holt Texte des Controls mit der ControlHwnd
		Ausgabe-Schema:
		(ParentHwnd)Hwnd[TextZeilenAnzahl] ----> Class	Title	Path	PosX PosY Breite Hoehe
		TextZeilen (des eigentlichen Textes)
		naechstes Hwnd mit gleichem Schema
		...
0.594	CoTe://	WTitle? ahk_class SciTEWindow	Contro? Scintilla1Nr_Row? zzo`nmenu
0.595	Sort? KurzOben
		z.B. FilP://%A_ScriptDir%\**,DFRIn_Row? Sort? KurzOben
		Vermutlich ist in AutoHotKey ein Bug.
		
		Ich habe zumindest keine andere Erklaerung gefunden, weshalb ich
		Sort? NachMTime
		Sort? NachMTimeR
		in diesem Kontext nicht zum Laufen gebracht habe.
		Details: in NachMTime() funktioniert FileGetTime nicht, liefert nur Error
0.596	Zur Umschiffung des Bugs von 0.595 wurde 
		Sort? ViaTimer_LabelName
		eingefuhrt. Z.B.
		FilP://%A_ScriptDir%\**,DFRIn_Row? Sort? ViaTimer_SortMTime
		Einschraenkungen: 
		Sortieren via Timer wird nur als letzeter Live-Suche-Therm unterstutzt.
		Die Verwendung in Macros wird nicht unterstuetzt, aber auch nicht unterbunden.
		Flexibilitaet: 
		da nach ViaTimer_ rein technisch gesehen jedes Label moeglich ist
		kann diese Verwendungsart sehr maechtig sein, 
		jedoch mit schwierig kalkulierbarem Risiko und Nebenwirkungen,
		wenn ein nicht-Sortier-Label verwendet wird.
		Sortier Labels				Wirkung
		Sort					Alphabetisch
		SortR					Dito Recursiv
		SortLen					nach Stringlaenge
		SortMTime				nach ModificationTime
		SortMTimeR				dito Recursiv
		SortLenAlle				SortLen liefert schneller
		SortMTimeAlle				SortMTime liefert schneller
		SortMTimeAlleR				SortMTimeR liefert schneller
		SortBestAutoBewertung			ist nicht fuer diese Anwendungsart geeicht
		SortBestAutoBewertungNotWordList	koennte vernuenftige Ergebnisse bringen
0.597	OnEvent? OnClipboardChange	Gosub F5clip://
		wird zukuenftig 
		clip://	In_Row? 
		ersetzen.
		Hinweise:
		OnEvent? wird am Anfang und nur einmal erwartet
		Statt F5 kann auch ein anders Label angesprungen werden.
		Andere Label sind nicht getestet. Risiken und Nebenwirkungen ...
0.598 0.599	mit
		OnEvent? WM_COMMAND_17 Gosub Labelname
		in Edit2 lauscht ZZO auf ein Ereignis von einem Fremdscript 
		siehe Kommentar und Muster-Skript am Ende von WM_COMMAND()
0.600 bis 0.602	ExSel://`vIn_Inh? 
		Dem Ziel naeher gebracht Infos zu Selektionen im Explorer anzuzeigen.
		Unterstuetzung begonnen fuer:
		.Lnk
			LinkZiel
		.dll
			bereitgestellte Funktonen
		Bilder
			Properties
		Ordner
			DisplayNane
			Inhalt
		Dateien
			DisplayNane
			Properties
			Inhalt
		Ziel ist es viele informationen zu Selektierten Objekten im Explorer bereit zu stellen.
0.603	Fehler in ZeileEnthaelt(Zeile,SuchListCR) entfernt
0.604	Datei-/Ordner-/Eigenschaften-Vorschau:
		ExSel://`vIn_Inh? `vSort? ViaTimer_-Edit2
		bzw. gefiltert
		ExSel://`vIn_Inh? Nachfilter`vSort? ViaTimer_-Edit2
		Provisorische-Endlos Explorer-Select-Inhalts/Info-Ansicht.
		obere Zeile in Edit2 einfuegen, ein Explorerfenster oeffnen
		und eine Datei oder einen Ordner selektieren und beobachten was sich im ZZO-Fenster abspielt.
0.605	Doppelklick ins Leere von Edit5 erzeugt keine Fehlermeldung mehr.
0.606	bei 600 wird auch versucht Textinhalte von Binaer-Dateien anzuzeigen.
0.607	In der neuen LiveSuche kann auch nach dem Tabulatorzeichen gesucht werden:
		TabbaT
		Beispiel:
		siehe Hauptmenu | ? | Unterprogramme anzeigen
0.608	%WinTextKenner% aehnlich WinText-Option von AhK. Wird normalerweise nicht benoetigt.
		Bispiel:
		ExSel://`tWTitle? ahk_class CabinetWClass`tWinText? UIRibbonDockTop`vIn_Inh?
		%2HtmlKenner% HtmleitenTitel 	ubergibt Edit5 (html aufbereitet) an den StandartBrowser
		Beispiele:
		FilP://%A_ScriptDir%\**,DFIn_Row? 2_HTML? Skript Ordner
		wobei "Skript Ordner" der Titel der zu generierenden HTML-Seite wird (im Browser-Tab angezeigt).
		file://%A_ScriptDir%\Hilfe\LiveSuche.htmIn_Row? 2_HTML?				ungefiltert
		file://%A_ScriptDir%\Hilfe\LiveSuche.htmIn_Row? filP2_HTML?			gefiltert nach filP
		Der Filter funktioniert nur brauchbar, wenn die Zeilen im HTML-Quelltext den angezeigten Zeilen entsprechen (das tut es hier nicht).
		Merkregel normaler (horrizontaler) Tab versus Vertikaler Tab:
		Zusammengehoerende Dinge werden mit normalem Tab unterteilt.
		Fuer sich Auswertbares wird mit vertikalem Tab unterteilt.
		Beispiel:
		ExSel://`tWTitle? ahk_class CabinetWClass`tWinText? UIRibbonDockTop`vIn_Inh?
		ExSel://`tWTitle? ahk_class CabinetWClass`tWinText? UIRibbonDockTop 	wird als Gesamt-Information ausgewertet.
		Auf das Ergebnis wird dann In_Inh? angewendet.
0.609	%AlleInfosKenner% ersetzt %InInhaltKenner% welches selbst auf Inhalte gekuerzt wurde.
0.610	Blaettern in der LiveSuche PageUP und PageDown Taste moeglich.
0.611	Class wBr (WebBrower) eingebunden
0.612	IE_Browser Inhalte koennen nun auch als Live-Such-Quelle dienen:
		%IeExistKenner%Tag-Einschraenkung
		z.B.:
		%IeExistKenner%aIn_Row?
		Sucht im obersten IE-Fenster-Reiter alle Links und gibt sie mit linksbuendigem Tag-Pfad   HTML-formatiert zeilenweise aus.
		Achtung: der so uebernommene Browser-Reiter schliesst sich mit ZZO. Falls dies nicht gewuenscht ist,
		kann vorher behelfsmaessig der Reiter mit ^k dupliziert werden oder nachtraeglich in ZZO die Suche mit der zwischengespeicherten Url wieder geoeffnet werden.
		IeEx://in_Row? ¬<html``n¬<head``n¬<body		laesst die meisten zu grossen Tags weg.
		IeEx://ain_Row? ¬<html``n¬<head``n¬<body2_Html? 		Tabellarische-Linkliste, jedoch mit nicht funktionierenden lokalen Links. Letzteres kann sich noch aendern.
0.613	das Tag von 0.612 hat optional Vorzeichen - oder + bekommen
		-Tag	zeigt	TagHierarchie <Tag>
		Tag	zeigt	TagHierarchie  Text des Tag's
		+Tag	zeigt	TagHierarchie  HTML des Tag's
0.614	In der neuen Live-Suche sind 
		¯		[Alt Down]0175[Alt Up]		Oberstrich
		Ø		[Alt Down]0216[Alt Up]		Durchgesrichenes O oder Leere Menge
		Neutrale Zeichen moeglich, diese wirken wie nicht geschrieben.
		Sie werden zukuenftig anzeigen, wo vorzugsweise Eingaben moeglich bzw. sinnvoll sind:
		ØØ¯¯ØØ	so werden beschlaeunigend wirkende Eingabestellen gekennzeichnet
		Ø¯¯Ø 	so werden weitere Eingabestellen gekennzeichnet
		ob eine Suche wirklich schneller wird, haengt allerdings auch noch von der Zusammensetzung der Gesammt-Suche ab.
		Als Faustregel gilt, je weiter links die Eingabemoeglichkeit ist, desto schneller sollte die Suche sein.
		z.B.
		FilP://%A_ScriptDir%\*ØØ¯ahk¯ØØ*,ØØ¯DFR¯ØØIn_Row? Ø¯beta¯Ø
		1. Eingabe-Moeglichkeit schraenkt hier die Datei-/Ordner-Namen bei der Quellauswahl auf ahk ein.
		2. Eingabe-Moeglichkeit sagt hier weches die zu suchenden Objekte sind. (D=Directories	F=Dateien	R=Rekursiv (in Unterordnern))
		3. Eingabe-Moeglichkeit filtert hier nachtraeglich nach beta.
		Die Felder Edit11 und Edit12 der alten Live-Suche sind somit ueberfluessig.
0.615	Optimierugen bei der Zusammenarbeit mit dem IE
0.616	Neue Include-Stelle fuer AHK-Macros eingefuegt:
		%A_AppData%\Zack\Macro\Ahk\include1.ahk
		Hinweise:
		 -	Nur Labels oder Functions sind verwendbar
		 -	in den Labels werden Eigene Variablen mit Macro_ beginnend empfohlen
		 -	ein herkoemmliches StartMacro mit dem Label- oder Funktionsaufruf wird zusaetzlich benoetigt:
			 - beim Label-Aufruf muss nur der Label-Name in der .txt Datei stehen
			 - bei Funktions-Aufrufen wird 	§EmpfaengerVar§FunktionsName§Parameter1§Parameter2§... 	erwartet.
		 -	erst nach ZZO Neustart ist das AHK-Macro vorhanden
		 -	weitere Macros koennen auch mit weiteren   #include *i Pfad  -Stellen separat gehalten werden.
0.617	WiMg://In_Row? 		zeigt Ausschnitte vom Taskmanager.
0.618	HWND's hinzugefuegt
0.619	HWND's in MachsBesteDraus-Ansicht aufgenommen
)
VersionsHistorie8=
(
0.620	ExternalTooltip	Pfad korrigiert, jetzt sollte auch der AHK-Installationslose Start von SchnellOrdner.Exe
		Fehlerfrei moeglich sein. Vorraussetzung: in %A_ScriptDir% ist von jedem AHK-Script, welches ZZO verwendet,
		eine Kopie von AutoHotkey.exe vorhanden. Die Kopie muss dazu vor dem Extender gleichnamig gemacht werden, 
		wie das jeweilige AHK-Script.
0.621	RechtsKlick auf Button3 ermöglicht nun auch die Aufbereitung des ClipboardInhaltes, 
		als haette es der Explorer mit drag and drop oder mit ^v gemacht.
		D.h. Rechtsklich auf Button3 und Auswahl 1. oder 2. Menu-item, erzeugt Clipbordeinträge, 
		die im Explorer via Rechtsklick Auwahl: Einfügen 
		eine Kopie der Clipboardeinträge erzeugt.
0.622	Die Funktionalitaet von 0.621 auch dem Cipboard-Menu #v hinzugefuegt:
		Clipboard 2 Not Text (-> Pfade)
		Somit kann man
		Cliboard 2 Text
		wenn es Pfade waren wieder rueckgaengig machen.
0.623	Pfade addieren Button3 Rechtsklick.
0.624	Ampel vorbereitet
0.625	Quelltext aufgeraeumt
0.626	0.614 und %Neutr_Ca% Schreib-Marke, Einfüge-Marke oder Caret fuer einige Live Suche-Beispiele integriert.
		Wenn in Edit2 ein %Neutr_Ca% drinn steht, dann kann mit F2 zu dieser Stelle gesprungen werden.
0.627	Wartezeiten von 0.626 reduziert.
0.628	Die Live-Suche kann nun gespiegelt werden:
		In ein beliebiges Control welches den AHK-Befehl
			ControlSetText,,bel. zu sendender Text,ahk_id `%ZielHwnd`%
		unterstuetzt. In der Live-Suche lautet die Schreibweise so:
			`vMirr05? `%ZielHwnd`%
		das HWND des Zieles erhaelt man bspw. so:
		- Oeffnen eines leeren Notepad Fensters
		- [Win] + [v]
		- MouseOverHwnd 2 Clipboard
		- Maus ueber den beschreibbaren Teil des Notepad-Fensters bringen
		- beliebige Taste druecken
		- hinter einen bestehenden Live-Such-String   `vMirr05?   eingeben
		- mit ^v fertigstellen.
		bei Verwendung der Quelltext-Anzeige koennte dies folgendermassen aussehen:
		file://%A_ScriptFullPath%In_Row? Ø¯¯Ø`vMirr05? 0x6b0846
		Ein Duplikat von Edit5 ist nun auch in Notepad zu sehen.
		Das Beispiel ist nur so lange funktional, wie dieses Notepad-Fenter erhalten bleibt.
		D.h. bei einem neuen Fenster muss auch das ZielHwnd neu besorgt werden.
		Das Ganze ist jedoch viel universeller, mit
		file://%A_ScriptFullPath%In_Row? Ø¯kenner¯Ø`vMirr05? 0x6b0846In_Row? Ø¯rex⁞¯Ø
		kann man die Erstfilterung nach "Kenner" in Notepad betrachten 
		und die Zweitfilterung nach "rex" in Edit5. 
		PS. wenn das Zwischenergebnis belanglos ist, haette
		file://%A_ScriptFullPath%In_Row? Ø¯kenner``nrex¯Ø
		einfacher zum selben Endergebnis gefuehrt.
0.629	ControlDefinierer, mit den von AHK bekannten 5 Eingabemoeglichkeiten 
		WConDef? Control,Fenstertitel,Fenstertext,Titelausnahme,Textausnahme
		eingefuehrt. (Die Verwendung globaler Variablen zwischen den Kommas ist erlaubt, rechnen nicht.)
		Z.B.:
		file://%A_ScriptFullPath%In_Row? Ø¯¯Ø`vMirr05? WConDef? Edit1,ahk_exe notepad.exe
		sollte das oberste Notepad Fenster befuellen. 
		Achtung: Der Befehl kuemmert sich nicht darum, ob der bisherige Inhalt schon gespeichert wurde!!!
		Sicherer ist imemer das HWND des Controls zu verwenden.
		file://%A_ScriptFullPath%In_Row? Ø¯¯Ø`vMirr05? WConDef? ,ahk_id 0x605de
		ist das Selbe, wie Beipiel 1 von 0.628
		WConDef? ist momentan nach
		CoTe://
		Mirr05?
		Mirr08?
		fruchtbar. Zwischen CoTe:// und WConDef? ist im Gegensatz zu den anderen 2 kein Leerzeichen.
		Auch abholen und weiterleiten ist moeglich
		CoTe://WConDef? ...`vMirr05? WConDef? ...
		Auch abholen und gefiltert weiterleiten ist moeglich
		CoTe://WConDef? ...`vIn_Row? FilterBegriff`vMirr05? WConDef? ...
0.630	Events von Browser IE versucht zu koppeln, noch gescheitert bei MausKlicks in IE-Fenster 
		die nicht mit gem Gui verbundn sind.
0.631	GlobalDeref(ZK) interne Funktion
0.632	Live-Suche: HtmPat? Ausgabe in den Internet-Explorer (aehnlich wie Spiegeln)
0.633	Html Erzeugung zugeschnitten auf HtmPat? begonnen zu ueberarbeiten 
0.634 0.635	Live-Such-Assistent erstellt:
		Menü | Filter | Suchassistent Live-Suche 
		Schrit fuer Schrit kann damit der Live-Suche-String verlaengert werden:
		- Aussuchen des passenden Teil-Strings
		- Uebernehmen des Teil-Strings durch erneuten Menue-Aufruf
		- so oft bis der Roh-String vertig gestellt ist
		- Uebernehmen nach Edit2 mit Button 4
		- ggf. ergaenzen von Pfaden, HWD's, Controls, Wintitles etc.
0.636	mit ``vclipE5Write? kann das Cipboard nun auch beschrieben werden.
0.637 0.638	`vWinAnWin? WWinDef? ahk_id 0x80404 WWinDef? ahk_id 0x230554`vLoop? ViaTimer_-Edit2
		in 0.640 folgt ein Label fuer die Nutzung von 0.637
0.639	%OldDelNewKenner% faengt eine neue Suche an. 
		Das heist in manchen Faellen koennen mehere LiveSuchen mit einem Ausloese-Event durchgefuehr werden.
		Mit folgendem SuchString konnten 2 Explorer jeweils mit Detailanzeige mit ZZO betrieben werden. 
		ExSel://	WTitle? ahk_id 0x350416AllInfo?Mirr05? WConDef? Edit1,ahk_pid 9792WinAnWin? WWinDef? ahk_id 0x350416 WWinDef? ahk_pid 9792OldDelNew?ExSel://	WTitle? ahk_id 0xd0a3eAllInfo?Mirr05? WConDef? Edit1,ahk_pid 1888WinAnWin? WWinDef? ahk_id 0xd0a3e WWinDef? ahk_pid 1888Loop? ViaTimer_-Edit2
		Bisher ist nur dieses Beispiel mit %OldDelNewKenner% getestet.
0.640	Label GetExplorerSelectDetails  erstellt
0.641	Haupt Menu | Optionen | Modus: Explorer Deails
		Tastatur-Alternativ-Aufruf:
		[Win]+[.]		[a]		[4]
		bzw. in AHK-Notation:
		#.		a		4
0.642	Ein Traktor- oder Mirror-Fenster wird wenn es aktiv ist weder wegverschoben noch der Inhalt des Controls veraendert.
		fuer 0.641 erledigt. Weitere folgen. Zweck: Um Inhalte ins Clipboard bringen zu koennen.
0.643	Clipboard Anzeige Modus und Explorer select Modus jeweils im eigeenen Prozess.
		Haupt Menu | Optionen | Modus: ...
		Hinweise:
		Nach Menu-Auswahl wird das Modus-Fenster minimiert und ein Neues gestartet.
		Ein Modus-Fenster braucht nicht angefasst zu werden, ausser man moechte Filtern.
		Die Modus-Instanzen sind nicht via Hotkeys erreichbar.
		Wenn das Sklaven-Fenster geschlossen wird, schliesst sich auch das Modus-Fenster. Anderst herum nicht.
		Die Rueckwandlung eines Modus-Fensters wird nicht unterstutzt (einfach schliessen).
0.644	Ueber die WinTitle-Texte sind nun auch die Zuordnungen von ZZO zu Sklave erkennbar
0.645	Fehler beim Multi-Instant-Betrieb entfernt
0.646	`vHtmPat? zeigt auch Bilder an													
0.647	HtmPicView? <BildHoehe in Pixel> zeigt nur Bilder
		Beispiele:
		FilP://%A_ProgramFiles%\*ØØ¯.ico¯ØØ⁞,Ø¯DFR¯Ø`vIn_Row? Ø¯¯Ø`vHtmPicView? 40
		FilP://%A_USERPROFILE%\Pictures\*ØØ¯.¯ØØ*⁞,Ø¯DFR¯Ø`vIn_Row? Ø¯¯Ø`vHtmPicView? 150
		PS. Mit Rechsklick auf ein Bild und Auswahl "Element untersuchen" kann man den Pfad ermitteln.
0.648	Fehler mit Text von SysListView321 entfernt
0.649	Win-Dot-Menu (erreichbar via [Win]+[.]) ausgeweitetet:
		Es enthaelt von oben nach unten:
		_________________________________________________
		| 0 Button-(wie Maus)-Klicks                     |
		| -----------------------------------------------|
		| 1 HauptMenu-Spalten als Hauptmenu-Zeilen       |
		| . ...                                          |
		| -----------------------------------------------|(+ 2 so wie so vorhandene Menues)
		| c [Win]+[v] (Clipboard...)-Menu                |
		| e Button3-Rechts-Klick-Menu                    |
		| -----------------------------------------------|( und das Tray-Menu)
		| f Tray-Menu                                    |
		|       Machs Beste Draus -> #b                  |(sowie der nicht auswaehlbare Hiweis fuer diese Funktion doch direkt #b zu verwenden)
		| -----------------------------------------------|( und wenn Super-Favoriten eigerichtet sind:)
		| L ♥1                                           |
		| M ♥2                                           |
		| . ♥...                                         |
		| -----------------------------------------------|(Sowie die momentan noch via Hotkey erreichbaren Grundfunktionen) 
		| . Dot         ZZO aktivieren                   |
		| - minus       setPath: Speichern... Dialog     |
		| , Komma       Pfad des aktiven Explorer aendern|
		¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯
		
		ZZO laesst sich damit auch im Hintergrund oder minimiert bedienen. Beispiele:
		[Win]+[.]	[0]	[1]		Wie Klick auf Button 1 (Aktualisieren) (F5 ist schneller funktioniert aber nur bei Aktivem ZZO-Fenster.)
		[Win]+[.]	[1]	[1]		startet das Skript neu
		[Win]+[.]	[L]			ruft den ♥1. Super-Favoriten auf (wenn der auf ein Macro im Marco-Ordner zeigt, 
		wird es auch gleich gestartet.)
0.650	HaupMenu | Edit8 | Diashow ruft nicht mehr den in Win 10 maessig eingerichteten Foto unn Bildbetrachter auf. Sondern
		Zeigt die Diashow im IE
		Hinweise:
		mit F11 wechselt man zur Maximalansicht und wieder zurueck
		wenn Bilder nebeneinander passen werden sie gleichzeitig dargestellt
		Esc beendet fruehzeitig
0.651	Optimierungen Diashow
0.652	Suchassistent Live-Suche bereinigt gepflegt und optimiert.
0.653	Suchassistent Live-Suche verarbeitet Infos zu MouseOver als auch ExplorerSelectionen
		und bietet sie auch an.
0.654	Edit5 2 Notepad via rechts-Click-Menu auf Button3
0.655	im Suchassistent Live-Suche werden ExplorerSelectionen wieder angezeigt
0.656	Pfadnummern-Auswahl via #. Menu moeglich
		z.B.:
		[Win]+[.]	[#]	[0]	[6]
		selektiert die 6. PfadZeile auch im Hintergrund.
0.657	Mehrere ZZO_Instanzen Problem behoben. Ein neu-Start von ZZO hat in speziaellen Faellen 
		ein via wBr erzeugtes IE-Fenster geschlossen.
0.658	ExplorerSelect Detail-Anzeige die auch Bilder kann:
		HauptMenu | Optionen | Modus: Explorer Details mit Bildern
0.659	ViaTimer? ergaenzt
0.660	Die Funktion	GetSelectedExplorerItems()	 zaehlt nun getrennt 
		selekterte Dateien, selektierte Ordner, Bild-Dateen im selektierten Ordner ohne UnterOrdner.
0.661	BildHoehe Auto versucht die Bildhoehe etwa so zu Waehlen, das alle Bilder angezeigt werden
0.662 0.663	Umgang mit Controls stabilisiert
		intern werden jetzt immer HWND verweise verwendet.
		Die Hwnd's werden dan von GetWinHwndVonLiveSucheTeilstring(LiveSucheTeilstring) verarbeitet.
0.664	Einfach-Mausklick-Links auf Edit5 umgestellt von Koordinatenberechnung auf Verwendung der Klick-Position
		Vorteile: einfacher, sicherer, schneller, keine Herausforderung bei MehrMonitorAnzeige
		DoppelKlick wird folgen
0.665	0.663 auch bei ExSel:// umgestellt.
0.666	Diverse Optimierungen und Stablisierungen
0.667	Loop ViaTimer vereinfacht und stabilisiert. Er sollte jetz nicht mehr haengen bleiben.
0.668	Der SuchVerlauf ist nun wieder Sichtbar.
0.669	Haupt-Menu:	 Datei | Data-Common-Ordner anzeigen
		Tipp: anschliessend F8 zum oeffnen im Explorer druecken
)	; ZZO_LastVersionItem	;	ZZO_Version




VersionsHistorie=%VersionsHistorie1%`n%VersionsHistorie2%`n%VersionsHistorie3%`n%VersionsHistorie4%`n%VersionsHistorie5%`n%VersionsHistorie6%`n%VersionsHistorie7%`n%VersionsHistorie8%
return
;}	
; < / ###########################################  Versionshistorie  ########################################### >
;}	
; < ############################################  HtmlHilfe  ################################################# > ;{
HilfeVorbereiten:	;{	

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
;}	
; < ############################################  Haftungsausschluss  ######################################### > ;{
HtmlHaftungsausschluss=
(
<h2>Haftungsausschluss</h2> 
<p>Es wird keinerlei Haftung für Schäden 
die durch dieses Programm entstehen können übernommen.
Die Benutzung erfolgt auf eigene Gefahr!</p>
<p>Besondere Vorsicht ist bei Befehlsdateien unbekannter Herkunft geboten.</p>
)
return
;}	
HilfeDateien:	;{	
Edit2:="FilP://" A_ScriptDir "\Hilfe\*.htm*,F In_Row? "
gosub Edit2Festigen
Edit10:="[F8] --> startet die gewaehlten Datei"
gosub Edit10Festigen
return
;}	
;}	
;}	
Hilfe:	;{	
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
Die TastenKombination [Win] + [z] oder + [n] oder + [#] zeigt das ZackZackOrdner-Fenster an ([n] versucht neben das bisher aktive Fenster zu gehen, bei [#] wird die gleiche Position eingenommen, [z] aktiviert ohne Positionsaenderung), diese Hotkeys sind immer Wirksam, egal welches Programm aktiv ist. Fast alle anderen Hotkeys, wie z. B. F4 der zum letzten Container umschaltet, wirken nur beim aktivierten Fenster<br>
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
Voraussetzung: TastWatch muss gestartet (geschieht automatisch kurz nach Programmstart) und die Caps-Caps-Ueberwachung aktiviert (im Tray-Menue von TastWatch oder durch Eingabe an beliebiger Stelle von "CapsspaCon ") sein und noch laufen.<br>
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
;}	
; < #########################################  H i L f e  ####################################################### >
; < ######################################### V o r l a g e n ##################################################### >
; < ########################################### Vorlage fuer Cache-Loops ########################################## >
MomentaneWortListeErzeugen:	;{	
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
;}	
; < / ########################################## Vorlage fuer Cache-Loops ########################################### >
; < ######################################### V o r l a g e n ####################################################### >
FehlerSuchEinfuehrung:	;{	
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
;}	
Control & F7::	;{	schreibe Vater in Edit2	;}	
FatherName2Edit2:	;{	
gosub NormalAnzeige
; SuchVerlauf()
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
	sleep 1
	ControlFocus,Edit2,ahk_id %GuiWinHwnd%
	; SoundBeep 12273/3
	if(Eit8Dir=FuehrendeSterneEntfernen(Edit8))
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
Ctrl & Left::	; Vater Ordner oder raus aus den Details / Inhalt nicht mehr anzeigen
if WortVorschlaege
	FileDelete,%A_AppData%\Zack\WortVorschlagListe.txt
Edit8Sternlos:=FuehrendeSterneEntfernen(Edit8)
IfNotExist % Edit8Sternlos
{
	; MsgBox Edit2VorTextAnsicht %Edit2VorTextAnsicht%		Edit3VorTextAnsicht %Edit3VorTextAnsicht%	
; MsgBox % ">" Edit2 "<`n>" Edit2Last "<`n>" Edit2LastLast "<`n>" Edit2LastLastLast "<`n>" Edit2LastLastLastLast "<`n>" Edit2LastLastLastLastLast  "<`n>"  Edit2LastLastLastLastLastLast
	if(InStr(Edit2,ProtokollKenner))
	{
		if(Edit2=Edit2Last and Edit2=Edit2LastLastLastLastLast )
		{
			Edit2:=Edit2LastLastLastLastLastLast
			Edit3:=Edit3LastLastLastLastLastLast
		}
		else if(Edit2=Edit2Last and Edit2=Edit2LastLastLast)
		{
			Edit2:=Edit2LastLastLastLast
			Edit3:=Edit3LastLastLastLast
		}
		else
		{
			Edit2:=Edit2LastLast
			Edit3:=Edit3LastLast
		}
		gosub Edit2Festigen
		gosub Edit3Festigen
	}
	else ; if Edit8 not contains http://,https://,ftp://,mailto://,Gopher://
	{
		gosub Drives2Edit5
		if SetDrives2Edit5
			return
		if(Edit2<>Edit2VorTextAnsicht)
			Edit2:=Edit2VorTextAnsicht
		else
			Edit2:=Edit2VorVorTextAnsicht
		gosub Edit2Festigen
		Edit3:=Edit3VorTextAnsicht
		gosub Edit3Festigen
		; gosub FatherFilePattern2Edit2
	}
	; MsgBox % Edit2 "	" Edit3
	; gosub Edit2
}
else
{
	gosub Drives2Edit5
	; FileGetAttrib,FileDirektAttribute,% Edit8Sternlos
	if not SetDrives2Edit5
		gosub FatherName2Edit2

}
return
;}	
FatherFilePattern2Edit2:	;{	neu ueberarbeiten ToDo	Ctrl & Left soll Ctrl & Right rueckgaengig machen!!!
gosub NormalAnzeige
; SuchVerlauf()
Edit8NurSternlos:=NurFuehrendeSterneWeg(Edit8)
if(SubStr(Edit8NurSternlos,5,3)="")
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
	SplitPath,Edit8Dir,,Edit8DirDir,,Eit8DirName,Eit8Drive
	if(Edit8DirDir<>"")
	{
		IfExist %Edit8DirDir%
		{
			Edit2:=FilePatternKenner Edit8DirDir "\*" N_PPHC "*," N_PHL "DF" N_PHR A_Space N_PH
			gosub Edit2Festigen
			SucheAbgebrochen:=false
			Edit1:=ZaehleZeilen(Edit5)	; Change372a
			gosub Edit1Festigen
			sleep 20
			ControlSend,Edit2,{End},ahk_id %GuiWinHwnd%
		}
		else
		{
			Edit1:=Edit1Vor
			return
		}
	}
	else
	{
		IfExist %Eit8Drive%
		{
			Edit2:=FilePatternKenner Eit8Drive "\*.*,DF" A_Space
			gosub Edit2Festigen
			SucheAbgebrochen:=false
			Edit1:=ZaehleZeilen(Edit5)	; Change372a
			gosub Edit1Festigen
			sleep 20
			ControlSend,Edit2,{End},ahk_id %GuiWinHwnd%
		}
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
;}	
Edit82AWin:	;{	
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
;}	
GetDerefEdit8:	;{	
if((fereDPos:=InStr(Edit8,"fereD",true)) and (DerefPos:=InStr(Edit8,"Deref",true)) and (DerefPos<fereDPos))
{
	LastEDit8EinschlfereD:=
	EDit8EinschlfereD:=
	Edit8Uebertrag:=
	Edit8Part:=Edit8
	Loop
	{
;		if(InStr(Edit8Part,CR))
;		{
;			MsgBox, 262160, %A_ScriptName% %A_LineNumber%, Mehrzeilige Deref-Bereiche werden (momentan) nicht unterstuetzt.`nD.h. nicht dereffereziert.
;			return
;		}
		Edit8VorDeref:=SubStr(Edit8Part,1,DerefPos-1)
		Edit8ToDerefLen:=fereDPos-DerefPos
		Edit8ToDeref:=SubStr(Edit8Part,DerefPos+5,Edit8ToDerefLen-5)
		Transform,Edit8DerefPart,Deref,%Edit8ToDeref%
		if(InStr(Edit8DerefPart,CR))
		{
;			MsgBox, 262160, %A_ScriptName% %A_LineNumber%, Mehrzeilige Deref-Bereiche werden (momentan) nicht unterstuetzt.`nD.h. nicht dereffereziert.
			TrayTip, %A_ScriptName% %A_LineNumber%, Mehrzeilige Deref-Bereiche werden (momentan) nicht unterstuetzt.`nD.h. nicht dereffereziert.
			return
		}
		; MsgBox % Edit8ToDeref "`n`n`n" Edit8DerefPart
		Edit8NachDeref:=SubStr(Edit8Part,fereDPos+5)
		LastEDit8EinschlfereD:=EDit8EinschlfereD
		EDit8EinschlfereD:=Edit8VorDeref Edit8DerefPart
		if((fereDPos:=InStr(Edit8NachDeref,"fereD",true)) and (DerefPos:=InStr(Edit8NachDeref,"Deref",true)) and (DerefPos<fereDPos))
		{
			Edit8Part:=Edit8NachDeref
			Edit8Uebertrag.=EDit8EinschlfereD
		}
		else
		{
			Edit8Deref:=Edit8Uebertrag Edit8VorDeref Edit8DerefPart Edit8NachDeref
			Edit8:=Edit8Deref
			break
		}
	}
	gosub Edit8Festigen
}
return
;}	
OeffnenSpeicherToFavorit:	;{	deaktiviert
SplitPath,% (SubStr(Edit8OeffnenMitSpeicher,1,-8)),,,,ThisName
ThisNewFavorit:=ThisName " |*" Edit8OeffnenMitSpeicher
IfNotExist %A_AppDataCommon%\Zack\WuCont\oeffnen mit\!Fav
	FileCreateDir %A_AppDataCommon%\Zack\WuCont\oeffnen mit\!Fav
ContainerVorschlagPfad=%A_AppDataCommon%\Zack\WuCont\oeffnen mit
gosub PlusSternManuellVorschlagVorhanden
ContainerVorschlagPfad=
return
;}	
Edit8ToOeffnenMitSchnellwahl:	;{	

; WieEdit2:= ; "FilP://" A_AppDataCommon "\Zack\WuCont\oeffnen mit\!Fav\*.txt,FR In_Row? "
WieEdit5:=
; StringTrimRight,WieEdit5Zeile,WieEdit5Zeile,2
Loop
{
	WieEdit5:=
	; Loop,Files,%A_AppDataCommon%\Zack\WuCont\oeffnen mit\!Fav\*.txt, F
	Loop,Files,%A_AppDataCommon%\Zack\WuCont\oeffnen mit\!Fav\*%WieEdit2%*.txt, F
	{
		FileRead, WieEdit5Zeile,%A_LoopFileLongPath%
		WieEdit5 .= WieEdit5Zeile 
	}
	; MsgBox % Edit5
	if (WieEdit2<>"")
		WieEdit2UndEdit5:=WieEdit2 "		abbrechen [Esc]"  "`r`n----------------------------------------------" DieseWinClass " --- " DiesesFocussedControl "`r`n" WieEdit5
	else
		WieEdit2UndEdit5:="NULL		 abbrechen [Esc]"  "`r`n----------------------------------------------" DieseWinClass " --- " DiesesFocussedControl "`r`n" WieEdit5
	FMenuAntwort:=FMenu(WieEdit2UndEdit5)
	if(FMenuAntwort="NeuerSuchString")
	{
		if (InStr(Edit2,FilePatternKenner))
			InputBox,WieEdit2,Suche,Name enthält `nzwischen den * * eingeben,,,,,,,,%WieEdit2%
		else
			InputBox,WieEdit2,Suche,Name enthält,,,,,,,,%WieEdit2%
		; gosub Edit2Festigen
		; gosub Button1
	}
	else if(FMenuAntwort="Next")
	{
	}
	else if(FMenuAntwort="Last")
	{
	}
	else if(FMenuAntwort="Aktivieren")
	{
		gosub SelfActivate
		return
	}
	else
		break
}
if (FMenuAntwort="000000")
	return

Edit8OeffnenMitSpeicher:=FuehrendeSterneEntfernen(SubStr(FMenuAntwort,7))
; Edit3:=SubStr(FMenuAntwort,1,6)-2
gosub Edit8OeffnenMit


return
;}	
;}	
Edit8ToOeffnenSpeicher:	;{	
Edit8OeffnenMitSpeicherVorher:=Edit8OeffnenMitSpeicher
if(InStr(Edit8,"mediamonkey"))			; ToDo: Optionen noch programmspeziefisch unterstützen, nicht wie hier hartverdrahtet.
{
	ThisOption:=" /Next "
	ThisOption2:=
}
else if(InStr(Edit8,"vlc"))			; ToDo: Optionen noch programmspeziefisch unterstützen, nicht wie hier hartverdrahtet.
{
	ThisOption:=" -f "
	ThisOption2:=" vlc://quit "
}
else
{
	ThisOption:=
	ThisOption2:=
}
if(InStr(Edit8,"%E8%"))			;
	Edit8OeffnenMitSpeicher:=FuehrendeSterneEntfernen(Edit8)
else if(SubStr(FuehrendeSterneEntfernen(Edit8),0,1)=":")
	Edit8OeffnenMitSpeicher:=FuehrendeSterneEntfernen(Edit8) . A_Space ThisOption `%E8`% ThisOption2
else
	Edit8OeffnenMitSpeicher:=FuehrendeSterneEntfernen(Edit8) . A_Space ThisOption """`%E8`%""" ThisOption2
OeffnenMitKontrollFrage:=true
ThisOption:=
ThisOption2:=
;}	
;	Ohne Return
Edit8OeffnenSpeicher:	;{	
if (A_ThisLabel="Edit8OeffnenSpeicher")
	Edit8OeffnenMitSpeicherVorher:=Edit8OeffnenMitSpeicher
if(Edit8OeffnenMitSpeicher="")
{
	if(InStr(Edit8,"http"))
		Edit8OeffnenMitSpeicher=microsoft-edge:`%E8`%
	else
		Edit8OeffnenMitSpeicher=notepad "`%E8`%"
}
;}	
Edit8OeffnenSpeicherBekannt:	;{	
FuncEinstellungen := {DefaultButton: 1, EditReadOnly: 0, DisableMainWindow: 1}
DieseAntwort:=AbfrageFenster(FuncEinstellungen,"Edit8OeffnenMitSpeicher","Run " Edit8OeffnenMitSpeicher "`n`n`nBeispiele:`nnotepad ""`%E8`%"" `nmicrosoft-edge:`%E8`%", "OK",">>>>>OK + Favorit","Link-Ziel statt Link",">>>>>>>>>>>>>>>>>abbrechen")
if (DieseAntwort=0)
{
	Edit8OeffnenMitSpeichpluser:=Edit8OeffnenMitSpeicherVorher
	ContainerVorschlagPfad:=
	DieseContainerNr:=
	return
}

StringSplit,DieseAntwortZeile,DieseAntwort,`n,`r
DieserAntwortPfad:=SubStr(DieseAntwortZeile1,2)
StringReplace,DieserAntwortPfad,DieserAntwortPfad,`%E8`%,,All
StringReplace,DieserAntwortPfad,DieserAntwortPfad,/Next,,All
StringReplace,DieserAntwortPfad,DieserAntwortPfad,Run%A_Space%,,All
StringReplace,DieserAntwortPfad,DieserAntwortPfad,",,All
DieserAntwortPfad:=FuehrendeSterneEntfernen(DieserAntwortPfad)
SplitPath,% DieserAntwortPfad,,,,SuchName
if(SuchName="" or SuchName=" ")
	SuchName:=DieserAntwortPfad
if (SubStr(DieseAntwort,1,1)="1")
{
	
	Edit8OeffnenMitSpeicher:=SubStr(DieseAntwortZeile1,6)
	OeffnenMitKontrollFrage:=true
}
else if (SubStr(DieseAntwort,1,1)="2")
{
	ThisNewFavorit:=SuchName "|*" SubStr(DieseAntwortZeile1,6)
	ContainerVorschlagPfad=%A_AppDataCommon%\Zack\WuCont\oeffnen mit
	IfNotExist %A_AppDataCommon%\Zack\WuCont\oeffnen mit\!Fav
	{
		FileCreateDir %A_AppDataCommon%\Zack\WuCont\oeffnen mit\!Fav
		if ErrorLevel
			MsgBox, 262192, Fehler, konnte nicht den Ordner`n`n%A_AppDataCommon%\Zack\WuCont\oeffnen mit\!Fav`n`nanlegen. Bitte manuell durchfuehren
	}
	WunschContNr:=GetContainerNr(ContainerVorschlagPfad)
	gosub PlusSternManuellVorschlagVorhanden
	WunschContNr:=
	OeffnenMitKontrollFrage:=true
}
else if (SubStr(DieseAntwort,1,1)="3")
{
	DieseLnkPosHochkomma:=InStr(DieseAntwortZeile1,".lnk" . Hochkomma)
	DieseLnkPos:=InStr(DieseAntwortZeile1,".lnk")
	if DieseLnkPosHochkomma
	{
		Edit8OeffnenMitRest:=SubStr(DieseAntwortZeile1,DieseLnkPos+6)
		Edit8OeffnenMitSpeicherVorl:=SubStr(DieseAntwortZeile1,7,DieseLnkPos-1)
	}
	else if DieseLnkPos
	{
		Edit8OeffnenMitRest:=SubStr(DieseAntwortZeile1,DieseLnkPos+4)
		Edit8OeffnenMitSpeicherVorl:=SubStr(DieseAntwortZeile1,6,DieseLnkPos-1)
	}
	else
	{
		MsgBox Der Link konnte nicht aufgeloesst werden!
		ContainerVorschlagPfad:=
		DieseContainerNr:=
		return
	}
	FileGetShortcut,%Edit8OeffnenMitSpeicherVorl%,Edit8OeffnenMitPfad
	Edit8OeffnenMitSpeicher:=Edit8OeffnenMitPfad . Edit8OeffnenMitRest
	gosub Edit8OeffnenSpeicherBekannt
	ContainerVorschlagPfad:=
	DieseContainerNr:=	
	return
	; Edit8OeffnenMitSpeicher:=Edit8OeffnenMitSpeicherVorher
}
else if (SubStr(DieseAntwort,1,1)="4")
{
	Edit8OeffnenMitSpeicher:=Edit8OeffnenMitSpeicherVorher
}
else
{
	Edit8OeffnenMitSpeicher:=Edit8OeffnenMitSpeicherVorher
	ContainerVorschlagPfad:=
	DieseContainerNr:=
	return
}
ContainerVorschlagPfad:=
DieseContainerNr:=

return
;}	
StarteClipboardPfadeMitEdit8:	;{	
if(not OeffnenMitDateiPfade(Clipboard,Edit8))
{
	if (SubStr(Edit8,0,1)=":" )
	{
		if(not OeffnenMitDateiPfade(Clipboard,Edit8 . A_Space .  "`%E8`%" ))
			MsgBox, 262192, Hiweis, Starten mit`n`n%Edit8%`n`nwird noch nicht unterstützt!`n`nmomentan Unterstützte Ziele:`nWorte`nexistierende DateiPfade`nöffnen mit Favoriten
	}
	else if (not InStr(Edit8,"/") and  not InStr(Edit8,"\")) ;  and  not InStr(Edit8,A_Space))
	{
		if(not OeffnenMitDateiPfade(Clipboard,Edit8 . A_Space . Hochkomma "`%E8`%" Hochkomma))
			MsgBox, 262192, Hiweis, Starten mit`n`n%Edit8%`n`nwird noch nicht unterstützt!`n`nmomentan Unterstützte Ziele:`nWorte`nexistierende DateiPfade`nöffnen mit Favoriten
	}
	else
		MsgBox, 262192, Hiweis, Starten mit`n`n%Edit8%`n`nwird noch nicht unterstützt!`n`nmomentan Unterstützte Ziele:`nWorte`nexistierende DateiPfade`nöffnen mit Favoriten

}
return
;}	
DateiSucheAusgehendVonEdit5:	;{	
PfadDieserDoBefehlsDatei=%A_temp%\DieseDoBefehlsDatei.do
StringReplace,DiesePfadAnzahl,Edit1,(,,all
StringReplace,DiesePfadAnzahl,DiesePfadAnzahl,),,all
if(DiesePfadAnzahl>20)
{
	MsgBox, 262212, Pfadanzahl, zur Dateisuche werden %DiesePfadAnzahl% Pfade gesendet`, bei zu langen Wartezeiten kann die Weiterverarbeitung uebers Schliesskreuz abgewuergt werden.`n`nPfade senden?
	IfMsgBox,No
		return
}
gosub FuerDateiSucheAusgehendVonEdit5
FileDelete,%PfadDieserDoBefehlsDatei%
FileDelete,%PfadDieserDoBefehlsDatei%
	StringReplace,FuerClipEdit5,Edit5,`n,`r`n,All
	StringReplace,FuerClipEdit5,FuerClipEdit5,*,,All
	StringReplace,FuerClipEdit5,FuerClipEdit5,%A_Tab%,\,All
	FileAppend,%FuerClipEdit5%,%PfadDieserDoBefehlsDatei%
	FileAppend,`r`nButtonOpti,%PfadDieserDoBefehlsDatei%
IfExist %SucheDateienPfadexe%
	Run,%SucheDateienPfadexe% "%SucheDateienPfadahk%" "%PfadDieserDoBefehlsDatei%",%SucheDateienPfadDir%
else
{
	IfExist %SucheDateienPfadahk%
		Run, %SucheDateienPfadahk% "%PfadDieserDoBefehlsDatei%",%SucheDateienPfadDir%
}
return
;}	
DateiSucheAusgehendVomClipboard:	;{	
PfadDieserDoBefehlsDatei=%A_temp%\DieseDoBefehlsDatei.do
; StringReplace,DiesePfadAnzahl,Edit1,(,,all
; StringReplace,DiesePfadAnzahl,DiesePfadAnzahl,),,all
; if(DiesePfadAnzahl>20)
; {
; 	MsgBox, 262212, Pfadanzahl, zur Dateisuche werden %DiesePfadAnzahl% Pfade gesendet`, bei zu langen Wartezeiten kann die Weiterverarbeitung uebers Schliesskreuz abgewuergt werden.`n`nPfade senden?
; 	IfMsgBox,No
; 		return
; }
gosub FuerDateiSucheAusgehendVonEdit5
FileDelete,%PfadDieserDoBefehlsDatei%
FileDelete,%PfadDieserDoBefehlsDatei%
	StringReplace,FuerClipEdit5,Clipboard,`n,`r`n,All
	StringReplace,FuerClipEdit5,FuerClipEdit5,*,,All
	StringReplace,FuerClipEdit5,FuerClipEdit5,%A_Tab%,\,All
	FileAppend,%FuerClipEdit5%,%PfadDieserDoBefehlsDatei%
	FileAppend,`r`nButtonOpti,%PfadDieserDoBefehlsDatei%
	

IfExist %SucheDateienPfadexe%
	Run,%SucheDateienPfadexe% "%SucheDateienPfadahk%" "%PfadDieserDoBefehlsDatei%",%SucheDateienPfadDir%
else
{
	IfExist %SucheDateienPfadahk%
		Run, %SucheDateienPfadahk% "%PfadDieserDoBefehlsDatei%",%SucheDateienPfadDir%
}
return
;}	
Button3Zweimal:	;{	
gosub Button3
sleep 200
gosub Button3
return
;}	
Clipboard2Edit5Direkt:	;{	
Edit5:=Clipboard
gosub Edit5Festigen
gosub Edit3
return
;}	
Clipboard2Edit5:	;{	
if(InStr(Edit2,"://"))
	Edit2:=ClipKenner . A_Space . "InName?" . A_Space
else
	Edit2:=ClipKenner . A_Space . "InName?" . A_Space . Edit2
gosub Edit2Festigen
gosub Edit2
SucheAbgebrochen:=false
Edit1:=ZaehleZeilen(Edit5)	; Change372a
gosub Edit1Festigen
return
;}	
InhaltVonEdit82Edit5Deaktiviert:	;{	wegen F7	Edit82Edit2:	InhaltVonEdit82Edit5: ; Toggle Inhalt-Textansicht <---> Pfadlisten-Ansicht deaktiviert
Edit8OhneStern:=FuehrendeSterneEntfernen(Edit8)
IfExist % Edit8OhneStern
{
	Edit2:=FileKenner . Edit8OhneStern . A_Space . "InName?" . A_Space
	gosub Edit2Festigen
	gosub Edit2
	; SoundBeep 7000,3000
	SucheAbgebrochen:=false
	Edit1:=ZaehleZeilen(Edit5)	; Change372a
	gosub Edit1Festigen
}
return
;}	
SortLenAlle:	;{	
BeschaeftigtAnzeige(1)
gosub Button1	; ToDo Wird hier benötigt, da teilweise erst der Aktualisieren-Befehl bei der 2.-Ausführung erledigt wird. Herausfinden wo der 1.Aufruf hängen bleibt!!!!!!!!!!!!!!!!

Edit6Merker:=Edit6
if(Edit6<30000)
{
	Edit6:=30000
	; SucheAbrechen:=9999		; eventuell auch relevant bei hängendem Aufruf!!!!!!!!!!!!!!!!!!!
}
gosub Edit6Festigen
; Gui,1:Submit,NoHide
sleep 10	; ToDo Wird hier benötigt, da teilweise erst der Aktualisieren-Befehl bei der 2.-Ausführung erledigt wird. Herausfinden wo der 1.Aufruf hängen bleibt!!!!!!!!!!!!!!!!
; SoundBeep
gosub Button1
; Sleep 2000
; SoundBeep
gosub Edit5Festigen		; weg
; sleep 2000
gosub SortLen
; Sleep 2000
Edit6:=Edit6Merker
gosub Edit6Festigen
Edit3:=1
gosub Edit3Festigen
BeschaeftigtAnzeige(-1)
return
;}	
SortMTimeAlleR:	;{	sortiert nach modification Time recursiv
MTimeAlleReverse:=true
;}	
;	Ohne Return
SortMTimeAlle:	;{	sortiert nach modification Time 
BeschaeftigtAnzeige(1)
gosub Button1	; ToDo Wird hier benötigt, da teilweise erst der Aktualisieren-Befehl bei der 2.-Ausführung erledigt wird. Herausfinden wo der 1.Aufruf hängen bleibt!!!!!!!!!!!!!!!!

Edit6Merker:=Edit6
if(Edit6<30000)
{
	Edit6:=30000
	; SucheAbrechen:=9999		; eventuell auch relevant bei hängendem Aufruf!!!!!!!!!!!!!!!!!!!
}
gosub Edit6Festigen
; Gui,1:Submit,NoHide
sleep 10	; ToDo Wird hier benötigt, da teilweise erst der Aktualisieren-Befehl bei der 2.-Ausführung erledigt wird. Herausfinden wo der 1.Aufruf hängen bleibt!!!!!!!!!!!!!!!!
; SoundBeep
gosub Button1
; Sleep 2000
; SoundBeep
gosub Edit5Festigen		; weg
; sleep 2000
if MTimeAlleReverse
	gosub SortMTimeR
else
	gosub SortMTime
MTimeAlleReverse:=false
; Sleep 2000
Edit6:=Edit6Merker
gosub Edit6Festigen
Edit3:=1
gosub Edit3Festigen
BeschaeftigtAnzeige(-1)
return
;}	
UebersetzungEnAnzeigen:	;{	Uebersetzungen anzeigen
Edit2:="file://language\en.ini In_Row? " N_PHC
gosub Edit2Festigen
return
;}	
QuellTextAnzeigenHotkeysLabelsFunctiones:	;{	
DieseSuche:="`;{"
gosub QuellTextGemeinsames
return
;}
QuellTextAnzeigenHotkeys:	;{	
DieseSuche:="::TabbaT"
gosub QuellTextGemeinsames
return
;}
QuellTextAnzeigenInhaltsverzeichnis:	;{	
DieseSuche1:="#################"
DieseSuche:=DieseSuche1 DieseSuche1
gosub QuellTextGemeinsames
return
;}	
QuellTextAnzeigenLabels:	;{	
DieseSuche:=":TabbaT;{TabbaT"
gosub QuellTextGemeinsames
return
;}
QuellTextAnzeigenFunctions:	;{	
DieseSuche:=")TabbaT`;{()TabbaT"
gosub QuellTextGemeinsames
return
;}
QuellTextAnzeigen:	;{	
GuiControl ,1: +T35,Edit5
DieseSuche:=
gosub QuellTextGemeinsames
return
;}
VariablenAnzeigen:	;{	
; GuiControl ,1: +T35,Edit5
if (DebugVarsPath="")
	DebugVarsPath:=A_ScriptDir "\DebugVars.ahk-master\DebugVars.ahk"
IfExist %DebugVarsPath%
{
	SplitPath,DebugVarsPath,,DebugVarsPathDir
	IfWinExist Variables
		WinActivate Variables
	else
		Run, %DebugVarsPath%,%DebugVarsPathDir%,,DiesesWinHwnd
	sleep 1000
	; CoTe://WTitle? ahk_id 0x791742 Contro? SysListView321 Nr_Row?
	Edit2:=ControlTextKenner WitchControlDefKenner A_Space "SysListView321,Variables" "`v" NrRowKenner A_Space
	; Edit2:=ControlTextKenner WinTitleKenner " Variables"  A_Space ControlKenner A_Space "SysListView321" "`v" NrRowKenner A_Space N_PHC
	gosub Edit2Festigen
	
	; gosub WinControlInf2Edit5

}
else
{
	ListVars
	Edit2:="CoTe://WTitle? " A_ScriptFullPath " Contro? Edit1 Nr_Row? "
	gosub Edit2Festigen
	gosub SelfActivate
}
return
;}
QuellTextGemeinsames:	;{	
if Edit6 is not Integer
{
	Edit6:=Edit6Default
	gosub Edit6Festigen
}
Edit2:=FileKenner A_ScriptFullPath "`v" NrRowKenner A_Space N_PHL DieseSuche Neutr_Ca N_PHR
gosub Edit2Festigen
SucheAbgebrochen:=false
Edit1:=ZaehleZeilen(Edit5)	; Change372a
gosub Edit1Festigen
FileDelete,%A_AppData%\Zack\WortVorschlagListe.txt
; ControlSend,Edit2,{End},ahk_id %GuiWinHwnd%
OpenWithScitePath:=A_ScriptFullPath
GuiControl ,1: -T35,Edit5
; Sleep 2000
gosub F5
DieseSuche:=
return
;}
; "C:\Program Files\AutoHotkey\SciTE\SciTE.exe" "C:\Program Files (x86)\ZackZackOrdner\SchnellOrdner[365].ahk" -goto:458 -find:dateimenü
SciteAtEdit8ThisQuelltext:	;{	;}
SciteAtEdit8:	;{	
; if(A_ThisLabel="SciteAtEdit8ThisQuelltext")
; 	OpenWithScitePath:=A_ScriptFullPath
; else
;	OpenWithScitePath:=FuehrendeSterneEntfernen(Edit8)
; StringSplit,SciteZeilenNr,Edit8,A_Tab A_Space
; SciteZeilenNr:=SciteZeilenNr1					; koennte AHK Bug sein
SciteZeilenNr:=
; GuiControl ,1: +T35,Edit5
Loop 10
{
	DieseZiffer:=SubStr(Edit8,A_Index,1)
	if DieseZiffer is Integer
		SciteZeilenNr.=DieseZiffer
	else
		break
}
if(InStr(Edit2,Filekenner) and InStr(Edit2,NrRowkenner))
{
	StringTrimLeft,OpenWithScitePath,Edit2,% StrLen(Filekenner)
	NrRowkennerPos:=InStr(OpenWithScitePath,NrRowkenner)
	OpenWithScitePath:=SubStr(OpenWithScitePath,1,NrRowkennerPos-2)
	IfNotExist %OpenWithScitePath%
	{
		MsgBox % A_LineNumber "	Quelltext-Pfad`n>" "<`nkonnte nicht ermittelt werden`nThislabel=" A_ThisLabel "	" A_ThisMenu "	" A_ThisMenuItemPos "	" A_ThisMenuItem

	}
}

NrRowPos:=InStr(Edit2,NrRowKenner)
Suchtext:=substr(Edit2,NrRowPos+NrRowKennerLen+1)
; ListVars
; MsgBox % OpenWithScitePath "`n"`SciteZeilenNr "`n"`Suchtext
OpenInScite(OpenWithScitePath,SciteZeilenNr,Suchtext)
return
;}
LVPP:	;{	Globale Variablen -> Notepad++	
Now:=A_Now
FileAppend, % ListGlobalVars(),%A_Temp%\GlobalVarsZzo%Now%.txt
IfExist %NotepadPlusPlusPfad%
	Run, %NotepadPlusPlusPfad% %A_Temp%\GlobalVarsZzo%Now%.txt
return
;}
LVPPQ:	;{	Globale Variablen als QullText anzeigen. ToDo coden
return
;}
LVPPO:	;{	Speicherort von LVPP oeffnen
Run %A_Temp%
return
;}
ClipKopiePfade2Zzo:	;{	erzeuge eine Clipboard-(Pfad-)Kopie zeige diese in Edit5
if (Clipboard<>"")
{
	gosub ClipboardMenuHandler1	;	Cipboard2Text
	ClipWait,5
	sleep 20
	DiesesA_Now:=A_Now
	DieserClip2DateiPfad=%A_AppData%\Zack\ClipKopie%DiesesA_Now%.tmp
	DieseClipKopie:=Clipboard
	FileAppend,%DieseClipKopie%,%DieserClip2DateiPfad%

	StringSplit,ClipZeile,DieseClipKopie,`n
; MsgBox % ClipZeile0
if(ClipZeile0=0)
	return
else if (ClipZeile0=1)
{
	ClipSternlos:=FuehrendeSterneEntfernen(DieseClipKopie)
	IfExist %ClipSternlos%
	{
		FileGetAttrib,ClipDirektAttribute,%DieseClipKopie%
		if(InStr(ClipDirektAttribute,"D"))
		{	; Ordner
			gosub SelfActivate
			Edit2:=FilePatternKenner  ClipSternlos "\*.*,DF" A_Space 
			SucheAbgebrochen:=false
			gosub Edit2Festigen
			SplitPath,ClipSternlos,,ClipFatherDir
			sleep 400
			FokusEdit2Rechts()
			SucheAbgebrochen:=false
			Edit1:=ZaehleZeilen(Edit5)	; Change372a
			gosub Edit1Festigen
		}
		else
		{	; Datei
			gosub ZeigeClipPathInhaltInEdit5 
		}
	}
	else
	{
	gosub SelfActivate
	Edit2:=FileKenner DieserClip2DateiPfad A_Space InNameKenner A_Space N_PHC
	gosub Edit2Festigen
	FokusEdit2Rechts()
	}
	return
}
else	;	ClipZeile0 > 1
{
	gosub SelfActivate
	Edit2:=FileKenner DieserClip2DateiPfad A_Space InNameKenner A_Space
	gosub Edit2Festigen
	FokusEdit2Rechts()
	return
}
return
}
return
;}
ClipPfade2ZzoDeaktiviert:	;{ versucht den Clipboard-Inhalt als Grundlage fuer ZZO zu verwenden
StringSplit,ClipZeile,Clipboard,`n
; MsgBox % ClipZeile0
if(ClipZeile0=0)
	return
else if (ClipZeile0=1)
{
	ClipSternlos:=FuehrendeSterneEntfernen(Clipboard)
	IfExist %ClipSternlos%
	{
		FileGetAttrib,ClipDirektAttribute,%Clipboard%
		if(InStr(ClipDirektAttribute,"D"))
		{	; Ordner
			gosub SelfActivate
			Edit2:=FilePatternKenner  ClipSternlos "\*.*,DF" A_Space 
			SucheAbgebrochen:=false
			gosub Edit2Festigen
			SplitPath,ClipSternlos,,ClipFatherDir
			sleep 400
			FokusEdit2Rechts()
			SucheAbgebrochen:=false
			Edit1:=ZaehleZeilen(Edit5)	; Change372a
			gosub Edit1Festigen
		}
		else
		{	; Datei
			gosub ZeigeClipPathInhaltInEdit5 
		}
	}
	else
	{
	gosub Clipboard2Edit5
	}
	gosub SelfActivate
	return
}
else	;	ClipZeile0 > 1
{
	gosub SelfActivate
	; gosub ZeigeClipInhaltInEdit5
	gosub Clipboard2Edit5
	FokusEdit2Rechts()
	return
}
return
;}
; #Esc::
mFokusEdit2Rechts:	;{	fokussiere Edit2 und setze Schreibmarke nach rechts
FokusEdit2Rechts()
return
FokusEdit2Rechts2017()
{
	global GuiWinHwnd,Edit11Exist,Edit12Exist
	IfWinNotActive,ahk_id %GuiWinHwnd%
		return
	ControlGetFocus,FocusedGuiConntrol,ahk_id %GuiWinHwnd%
	; tooltip, % A_CaretX "	" A_CaretY
	if(FocusedGuiConntrol<>"Edit2")
	{
		if (Edit11Exist and Not FocusedGuiConntrol="Edit11" and Not FocusedGuiConntrol="Edit12")
		{
			; MsgBox % FocusedGuiConntrol
			; ControlClick,,ahk_id %HwndEdit2%
			ControlClick,Edit11,ahk_id %GuiWinHwnd%
			; SoundBeep 13332/3
			ControlFocus,Edit11,ahk_id %GuiWinHwnd%
			; SoundBeep 13329/3
			return
			sleep 10
			ControlSend,Edit11,{End},ahk_id %GuiWinHwnd%
;			Sleep 5
;			gosub Down1
;			Sleep 3
;			gosub Up1
;			Sleep 3
		}
		else if(Not FocusedGuiConntrol="Edit11" and Not FocusedGuiConntrol="Edit12") ; steht oben schon -> if(Not FocusedGuiConntrol="Edit2")
		{
			Sleep 20
			ControlFocus,Edit2,ahk_id %GuiWinHwnd%
			; SoundBeep 13344/3
			ControlClick,,ahk_id %HwndEdit2%
			; SoundBeep 13350/3
			sleep 10
			ControlSend,Edit2,{End},ahk_id %GuiWinHwnd%
;			Sleep 5
;			gosub Down1
;			Sleep 3
;			gosub Up1
;			Sleep 3 
		}
	}
	else if (A_CaretX=212)
	{
		ControlFocus,Edit2,ahk_id %GuiWinHwnd%
		ControlSend,,{End},ahk_id %GuiWinHwnd%
		; gosub ^f
;		ControlClick,,ahk_id %HwndEdit2%
;		sleep 10
;		ControlSend,Edit2,{End},ahk_id %GuiWinHwnd%
;		Sleep 5
;		gosub Down1
;		Sleep 3
;		gosub Up1
;		Sleep 3
		
	}
	return	
}
;}
GetDriveLists:	;{	besorge existierende Laufwerke
DriveNamesCrList:=
DriveNamesKommaList:=
DriveNamesDoppelpunktKommaList:=
DriveNamesAwpfList:=
DriveGet,DriveNames1CList,List
StringSplit,LaufwerksBuchstabe,DriveNames1CList
Loop, % LaufwerksBuchstabe0
{
	DriveNamesCrList:=DriveNamesCrList LaufwerksBuchstabe%A_Index% ":`r`n" 
	DriveNamesKommaList:=DriveNamesKommaList "," LaufwerksBuchstabe%A_Index%
	DriveNamesDoppelpunktKommaList:=DriveNamesDoppelpunktKommaList "," LaufwerksBuchstabe%A_Index% ":"
	DriveNamesAwpfList.=LaufwerksBuchstabe%A_Index% ":\*`r`n" 
}
StringTrimLeft,DriveNamesKommaList,DriveNamesKommaList,1
StringTrimRight,DriveNamesAwpfList,DriveNamesAwpfList,2
return
;}
Drives2Edit5:	;{	Laufwerke in Edit5 auflisten
	Edit8Sternlos:=FuehrendeSterneEntfernen(Edit8)
	Edit2Sternlos:=FuehrendeSterneEntfernen(Edit2)
	if Edit8Sternlos in %DriveNamesDoppelpunktKommaList%
		This8Exist:=true
	else
		This8Exist:=false
	if Edit2 in %DriveNamesDoppelpunktKommaList%
		This2Exist:=true
	else
		This2Exist:=false
	if((StrLen(Edit2Sternlos)=2 and This2Exist) or This8Exist)
	{	; Listet die Drives auf, die aktuell existierten.
		IfExist %A_AppData%\Zack\Macro\ZeigeLaufwerkeInEdit5.txt
		{
			Edit2:="file://" A_AppData "\Zack\Macro\ZeigeLaufwerkeInEdit5.txt MacrDo? "
			gosub Edit2Festigen
		}
		else
		{
			gosub GetDriveLists
			; ToDo: Edit2:=MacroKenner PfadZumDriveNamesCrListMacro
			; ToDo: gosub Edit2Festigen
			Edit8:=
			gosub Edit3Festigen

			Edit2:=
			gosub Edit2Festigen
			sleep 100
			Edit5:=DriveNamesCrList
			gosub Edit5Festigen
			Edit3:=1
			gosub Edit3Festigen
		}
		SetDrives2Edit5:=true
		
	}
	else
		SetDrives2Edit5:=false
return
;}
DirektSuche:	;{ Es wird direkt im Dateisystem gesucht gegensatz zu CacheSuche
; SoundBeep,4000
; IfExist 
BeschaeftigtAnzeige(1)
StartPfadNr:=1
WunschOrdnerPattern:="C:\*"
Loop,Files,%SkriptDataPath%\*, D
{
	StringReplace,ThisStartPfadFilePattern,A_LoopFileName,°,*,All
	StringReplace,ThisStartPfadFilePattern,ThisStartPfadFilePattern,˸,:
	StringReplace,ThisStartPfadFilePattern,ThisStartPfadFilePattern,►,%BackSlash%,All
	; StringReplace,ThisStartPfadFilePattern,ThisStartPfadFilePattern,°,`*,All
	StringTrimLeft,ThisStartPfadFilePattern,ThisStartPfadFilePattern,4
	; FileRead,DieserStartPfad,% A_LoopFileLongPath
	StartPfadFilePattern%StartPfadNr%:=ThisStartPfadFilePattern
	if(SubStr(ThisStartPfadFilePattern,0,1)="F")
	{
		StringTrimRight,ThisStartPfadFilePattern,ThisStartPfadFilePattern,1
		StaPfEnthaeltDateien%StartPfadNr%:=true
		Optionen:="DFR"
	}
	else
	{
		StaPfEnthaeltDateien%StartPfadNr%:=false
		Optionen%StartPfadNr%:="DR"
	}
	++StartPfadNr
}
StartPfadNrHoechste:=StartPfadNr
if(not InStr(EDit2,ProtokollKenner))
	NameFilter:=Edit2
if SuFi
	InRowFilter:=Edit7
Else
{
	InRowFilter:=
	if Edit7 is Integer
	{
		if(Edit7>1 and Edit7<=StartPfadNrHoechste)
		{
			WunschOrdnerPattern:=StartPfadFilePattern%Edit7%
		}
	}
}
Edit2:=GetAktuellenDirektSucheFilter(WunschOrdnerPattern,NameFilter,InRowFilter,Optionen%Edit7%)
gosub Edit2Festigen
ZueletztFokusieren:="Edit11"
SchreibMarkenOrt:="End"
BeschaeftigtAnzeige(-1)
return
;}
ImOrdnerSuchen:	;{	Direkt-Suche
BeschaeftigtAnzeige(1)
Edit8Sternlos:=FuehrendeSterneEntfernen(Edit8)
if InStr(FileExist(Edit8Sternlos), "D") 
{
	OrdnerPattern:=Edit8Sternlos "\*"
}
else IfExist %Edit8Sternlos%
{
	SplitPath,Edit8Sternlos,,Edit8SternlosDir
	OrdnerPattern:=Edit8SternlosDir "\*"
}
Edit2:=GetAktuellenDirektSucheFilter(OrdnerPattern,"","","DFR")
Edit3:=1
gosub Edit2Festigen
gosub Edit3Festigen
Sleep 15
ControlFocus,Edit11,ahk_id %GuiWinHwnd%
BeschaeftigtAnzeige(-1)
return
;}
ImOrdnerTextSuchen:	;{	Direkt-Suche
Edit8Sternlos:=FuehrendeSterneEntfernen(Edit8)
if InStr(FileExist(Edit8Sternlos), "D") 
{
	OrdnerPattern:=Edit8Sternlos "\*"
}
else IfExist %Edit8Sternlos%
{
	SplitPath,Edit8Sternlos,,Edit8SternlosDir
	OrdnerPattern:=Edit8SternlosDir "\*"
}
Edit2:=GetAktuellenDirektSucheFilter2(OrdnerPattern,"","","DFR")
Edit3:=1
gosub Edit2Festigen
gosub Edit3Festigen
Sleep 15
ControlFocus,Edit11,ahk_id %GuiWinHwnd%
return
;}
CacheSuche:	;{	Es wird im Cache gesucht gegensatz zu DirektSuche
gosub ResetAllNocontainer
MsgBox eine detailiertere Umstellung Direktsuche -> Cache-Suche ist geplant.`nMomentan werden nur die Sucheinstellungen zurückgesetzt.
return
;}
~#Esc::	;{ alles Abbrechen ist das Endziel, momentan werden einzelne Schleifen beendet. 
gosub AllesAbbrechen
return
;}
~#Numpad6::
~#6::	;{	sendet Pfeil nach rechts
send %PfRe%
return
;}
SuchverlaeufeAnzeigen:	;{	berucksichtigt auch alte Suchverlaeufe
Edit2:="FilP://" A_AppData "\Zack\*SuchbegriffsObenNeu*,DF`vIn_Inh? "
gosub Edit2Festigen
return
;}	
SuchverlaufAnzeigen:	;{	
FileRead,SuchverlaufInhalt,% A_AppData "\Zack\Suchbegriffs.log",utf-16
ges:=
Loop,Parse,SuchverlaufInhalt,`n,`r
	ges := A_LoopField "`r`n" ges
if(SubStr(ges,1,2)="`r`n")
	StringTrimleft,ges,ges,2
gosub SuchverlaufObenNeuLoeschen
FileAppend %ges%, % A_AppData "\Zack\SuchbegriffsObenNeu.log",utf-16
Edit2:=FileKenner A_AppData "\Zack\SuchbegriffsObenNeu.log" "`v" NrRowKenner A_Space
gosub Edit2Festigen
Edit3:=FuerEdit5UpDown
gosub Edit3Festigen

return
;}
SuchverlaufLoeschen:	;{	Aktuellen Suchverlauf beenden
FileMove, %A_AppData%\Zack\Suchbegriffs.log, %A_AppData%\Zack\Suchbegriffs[%A_Now%].log
;}
; ohne Return
SuchverlaufObenNeuLoeschen:	;{	
FileMove, % A_AppData "\Zack\SuchbegriffsObenNeu.log", % A_AppData "\Zack\SuchbegriffsObenNeu[" A_Now "].log"
return
;}	
GetAngezeigteSuche:	;{	restauriert angezeigte Suche
if(InStr(Edit8,ProtokollKenner))
{
	Edit2:=FuehrendeSterneEntfernen(Edit8)
	gosub Edit2Festigen
	return
}
else
{
	StringSplit,LogZeilenElement,Edit8,%A_Tab%
	if (LogZeilenElement2="" OR SubStr(LogZeilenElement2,1,2)="20" AND StrLen(LogZeilenElement2)=14)
	{
		Edit2:=FuehrendeSterneEntfernen(Edit8)
		gosub Edit2Festigen
	}
	else IfExist %WurzelContainer%\%LogZeilenElement2%
	{
		if(NameSkriptDataPath<>LogZeilenElement2)
		{
			loop, % ContainerAnzahl
			{
				if(Cont%A_Index%=LogZeilenElement2)
				{
					WunschContainerNr:=A_Index
					break
				}
			}
			gosub ContainerUebersichtZeigen
			Sleep 10
			Edit3:=WunschContainerNr
			gosub Edit3Festigen
			gosub Edit3
			sleep 10
			gosub WurzelContainerOeffnen
		}
		Sleep 10
		Edit2:=FuehrendeSterneEntfernen(LogZeilenElement1)
		gosub Edit2Festigen
		Edit7:=LogZeilenElement3
		gosub Edit7Festigen
		SuFi:=LogZeilenElement4
		gosub SuFiFestigen
	}
	return
}
;}		
mErzeugeStruktur:	;{	erzeugt neue 1:1 Struktur von Vorlage
StrukturenPath:=A_ScriptDir "\Strukturen"
IfNotExist %StrukturenPath%
{
	FileCreateDir,%StrukturenPath%
	Run "%StrukturenPath%"
MsgBox, 262148, Struktur anlegen, Bitte erzeugen Sie in %StrukturenPath% einen Ordner mit dem Namen Ihrer Struktur `noefnen ihn und erzeugen darin Ihre MusterStruktur.`n`nund bestaetigen anschliessend mit OK.
}
Loop,Files,%StrukturenPath%\*,DF
{
	Struktur%A_Index%Pfad:=A_LoopFileFullPath
	Struktur%A_Index%Name:=A_LoopFileName ;  "." A_LoopFileExt
	if(DieserStrukturenPath=A_LoopFileFullPath)
		DieseStrukturenPathNr:=A_Index
	IfExist %A_ScriptDir%\%A_LoopFileName%.ahk
	{
		NurUebergeben%A_Index%:=true
		UserStrukturSkriptPfad%A_Index%=%A_ScriptDir%\%A_LoopFileName%.ahk
	}
	else
	{
		NurUebergeben%A_Index%:=false
		UserStrukturSkriptPfad%A_Index%:=
	}
	StrukturenAnzahl:=A_Index
}
if 0 ; (StrukturenAnzahl=1)
{
	Edit8Sternlos:=FuehrendeSterneEntfernen(Edit8)
	ErzeugeStruktur(Struktur1Pfad,Edit8Sternlos "\" Struktur1Name,UserStrukturSkriptPfad1)
}
else
{
	Edit8Sternlos:=FuehrendeSterneEntfernen(Edit8)
	; MsgBox,% DieseStrukturenPathNr "	" Struktur%DieseStrukturenPathNr%Pfad "	" DieserStrukturenPath
	ErzeugeStruktur(Struktur%DieseStrukturenPathNr%Pfad,Edit8Sternlos "\" Struktur%DieseStrukturenPathNr%Name,UserStrukturSkriptPfad%DieseStrukturenPathNr%)
}
return
;}
ErzeugeStruktur(QuellPfad,ZielPfad,VerwendeAhkPfad="",ZusatzInfos*)	;{()	erzeugt neue 1:1 Struktur von Vorlage
{
; ZZO erwartet das StrukturErzeugungsSkript wie folgt:
; Strichpunkt A_Tab GewuenschterInhalZumVarNameVonZzo A_Tab Kommentar <--Die Syntax ist in den ersten 9 Zeilen einzuhalten.
; Es muss gleichnamig gefolgt von .ahk wie der Quell-Struktur-Ordner lauten und sich im Skriptverzeichnis befinden.
; z.B.: zum Quell-Struktur-Ordner
; C:\Program Files (x86)\ZackZackOrdner\Strukturen\Hallo Welt
; wird das StrukturErzeugungsScript
; C:\Program Files (x86)\ZackZackOrdner\Hallo Welt.ahk
; erwartet, aber nur wenn von einer 1:1 Kopie abgewichen werden soll.

;	  < Beispiel eines Skriptbeginns                                               >
;	1 ;	QuellPfad	Diese Variable wird von ZZO  als 1. Uebrgabeparaeter erwartet
;	2 ;	ZielPfad	Diese als 2.
;	3 ;	A_ScriptFullPath	die als 3.
;	4 
;	5 		; Die komplett leere Zeile direkt drueber als Abschluss ist zwingend.
;	6 QuellPfad=%1%	; die Variablen-Namen sind frei und haetten auch MusterPfad
;	7 ZielPfad=%2%	; bzw. KopiePfad lauten koennen.
;	8 
;	; ...
;	# FileCopyDir,%QuellPfad%,%ZielPfad%
;	^Zeilennummer, die ist nicht einzugeben!
;	  ^erste Skript-Spalte
;	   ^Tabulator hier in den ersten 3 Zeilen
;		^VariablenNamen von ZZO (hier in den ersten 3 Zeilen)
;		VarName^Tabulator (hier in den ersten 3 Zeilen)
;		VarName Tabulator^Beliebiger optionaler Kommentar (hier in den ersten 3 Zeilen)
;	  </ Beispiel eines Skriptbeginns                                              >

	if (VerwendeAhkPfad<>"")
	{
		IfExist %VerwendeAhkPfad%
		{
			UebergabeParameterPfad:=VerwendeAhkPfad
			IfExist %UebergabeParameterPfad%
			{
				FileRead,ParsInhalt,%UebergabeParameterPfad%
				loop,Parse,ParsInhalt,`n,`r
				{
					; DiesesUeOut:=SubStr(A_LoopField,3)
					StringSplit,DiesesUeOut,A_LoopField,%A_Tab% ; ,A_Space Muss raus warum auch immer???????????
					; if(DiesesUeOut2<>"")
					; MsgBox % DiesesUeOut0 "	"  DiesesUeOut1 "	"  DiesesUeOut2 "	"  DiesesUeOut3 "	" 
					if(DiesesUeOut0>1)
						Ue%A_Index%Out:=%DiesesUeOut2%
					else
						break
					Loop 9
						DiesesUeOut%A_Index%:=
				}
				Run,"%VerwendeAhkPfad%" "%Ue1Out%" "%Ue2Out%" "%Ue3Out%" "%Ue4Out%" "%Ue5Out%" "%Ue6Out%" "%Ue7Out%" "%Ue8Out%" "%Ue9Out%"
				if ErrorLevel
				{
					MsgBox, %A_LineNumber% Fehlermeldung
					return 
				}
			}
			else
			{
				Run,"%VerwendeAhkPfad%" "%QuellPfad%" "%ZielPfad%"
				if ErrorLevel
				{
					MsgBox, %A_LineNumber% Fehlermeldung
					return 
				}
			}
		}
		return
	}
	IfNotExist %QuellPfad%
	{
		MsgBox, %A_LineNumber% Fehlermeldung `nQuellPfad <%QuellPfad%>
		return 
	}
	
	if (InStr(FileExist(QuellPfad),"D"))
		QuellIstOrdner:=true
	else
		QuellIstOrdner:=false
	if (InStr(FileExist(ZielPfad),"D"))
		ZielIstOrdner:=true
	else
		ZielIstOrdner:=false
	if QuellIstOrdner
	{
		IfNotExist %ZielPfad%
		{
			BackSlashPosR:=InStr(ZielPfad,"\",,0)
			if(not InStr(ZielPfad,".",,BackSlashPosR))
				ZielIstOrdner:=true
		}
	}
;	MsgBox %A_LineNumber%  ziel ist ordner %ZielIstOrdner% `n%QuellPfad%	%ZielPfad%
	if QuellIstOrdner
	{
		if ZielIstOrdner
		{
			IfNotExist %ZielPfad%
			{
;				FileCreateDir %ZielPfad%
;				if ErrorLevel
;					{
;						MsgBox, %A_LineNumber% Fehlermeldung
;						return 
;					}
				}
			FileCopyDir,%QuellPfad%,%ZielPfad%
			if ErrorLevel
			{
				MsgBox, %A_LineNumber% Fehlermeldung
				return 
			}
		}
		else
		{
			MsgBox, %A_LineNumber% Wird noch nicht unterstuetzt
			return 
		}
	}
	else
	{	;	Quelle ist Datei
		if ZielIstOrdner
		{
			IfNotExist %ZielPfad%
			{
				FileCreateDir %ZielPfad%
				if ErrorLevel
				{
					MsgBox, %A_LineNumber% Fehlermeldung
					return 
				}
			}
			FileCopy,%QuellPfad%,%ZielPfad%
			if ErrorLevel
			{
				MsgBox, %A_LineNumber% Fehlermeldung
				return 
			}
		}
		else
		{	;	Ziel ist Datei
			ZwischenZiel:= A_Temp "\QuellDatei"

			FileCopy,%QuellPfad%,%ZwischenZiel%,1		;
			if ErrorLevel
			{
				MsgBox, %A_LineNumber% Fehlermeldung
				return 
			}
			SplitPath,ZielPfad,,ZielPfadDir
			IfNotExist %ZielPfadDir%
				FileCreateDir %ZielPfadDir%
			FileMove,%A_Temp%\QuellDatei,%ZielPfad%
			if ErrorLevel
			{
				MsgBox, %A_LineNumber% Fehlermeldung
				return 
			}
			FileMove,%ZwischenZiel%,%ZielPfad%
		}
	}
	return
}
;}
GG:	;{ Fuer Test mit relativen Pfaden
SetWorkingDir, E:\Gegenst
edit2=FilP://**,DFR In_Row?%A_Space%
gosub Edit2Festigen
return
;}
-GG:	;{ Fuer Test mit relativen Pfaden
SetWorkingDir:=A_ScriptDir
edit2=FilP://**,DFR In_Row?%A_Space%
gosub Edit2Festigen
return
;}
VerschiebeDateienUndOrdner(Quellmuster, Zielordner, Überschreiben = false)	;{()	Verschiebt alle Dateien und Ordner vom Quellmuster in dem Zielordner 
; und gibt die Anzahl an Dateien/Ordnern zurück, die nicht verschoben werden konnten. Diese Funktion benötigt v1.0.38+, weil sie Modus 2 von FileMoveDir verwendet.
{
	BeschaeftigtAnzeige(1,A_ThisFunc)
    if Überschreiben = 1
        Überschreiben = 2  ; Siehe FileMoveDir zum Thema Modus 1 vs 2.
    ; Zuerst alle Dateien verschieben (aber nicht die Ordner):
    FileMove, %Quellmuster%, %Zielordner%, %Überschreiben%
    Fehleranzahl := ErrorLevel
    ; Jetzt alle Ordner verschieben:
    Loop, %Quellmuster%, 2  ; 2 bedeutet "nur Ordner".
    {
        FileMoveDir, %A_LoopFileFullPath%, %Zielordner%\%A_LoopFileName%, %Überschreiben%	; Befehl ist sehr langsam 10sec
        Fehleranzahl += ErrorLevel
        if ErrorLevel  ; Jeden Problemordner mit Namen anzeigen.
            MsgBox %A_LoopFileFullPath% kann nicht nach %Zielordner% verschoben werden.
    }
	BeschaeftigtAnzeige(-1,A_ThisFunc)
    return Fehleranzahl
}
;}
Edit5EinzelPfad2clipboard:	;{	schreibt Ergebnis von Pfad-Wahl ins ClipBoard
FMenuAntwort:=FMenu(Edit5)
Clipboard:=FuehrendeSterneEntfernen(SubStr(FMenuAntwort,7))
Edit3:=SubStr(FMenuAntwort,1,6)+0
gosub Edit3Festigen
return
;}
ZeigePfadMenu:	;{	fuer Tests
MsgBox % FMenu(Edit5)
return
;}
FMenu(MenuEintrag*)	;{
{
	global My1SubmenuReturn,CaretXBestMerker,CaretYbestMerker,DpiKorrektur,DiesesWinHwnd ; ,ErstesItemText
	static DeltaIndex:=0,ErstesItemText
	; MsgBox % A_LineNumber "	" CaretXBestMerker "	" CaretYBestMerker 
	try
		Menu,FMenu,DeleteAll
	Loop, 15
	{	
		; if (not (DeltaIndex and A_Index<3))
		{
			try
				Menu,My%A_Index%Submenu,DeleteAll
		}
	}
	My1SubmenuReturn:=
	MaxSubMenuItems:=15
	Loop, % MenuEintrag.MaxIndex()
	{
		Edit5index:=A_Index+DeltaIndex
		index:=A_Index
		
		; MsgBox % A_LineNumber "	" index "	" Edit5index ; "	" MenuEintrag[Edit5index]
		DieserMenuEintrag:=MenuEintrag[index]
		; MsgBox % DieserMenuEintrag
; 			MsgBox -%DieserMenuEintrag%-
		StringSplit,bMenuSubEintr,DieserMenuEintrag,`n,`r
;			MsgBox % bMenuSubEintr0 "	" index "	" bMenuSubEintr1 "	" bMenuSubEintr2
		if (bMenuSubEintr0=1)
			Menu, FMenu, Add, % bMenuSubEintr1, FMenu%Index%
		else
		{
/*
			if(MaxSubMenuItems>bMenuSubEintr0)
			{
				SubMenuItems:=bMenuSubEintr0
				; NextAnzeige:=false
			}
			else
			{
				SubMenuItems:=MaxSubMenuItems
				; NextAnzeige:=true
			}
*/
			if(MaxSubMenuItems+DeltaIndex>bMenuSubEintr0)
			{
				SubMenuItems:=bMenuSubEintr0-DeltaIndex
				NextAnzeige:=false
			}
			else
			{
				SubMenuItems:=MaxSubMenuItems
				NextAnzeige:=true
			}
			Loop, % SubMenuItems
			{
				DieserIndex:=A_Index  +DeltaIndex
				if(DieserIndex=1)
					ErstesItemText:=bMenuSubEintr%DieserIndex%
				if (A_Index=2 and DieserIndex>2)
					bMenuSubEintr%DieserIndex%:="Last"
				if(A_Index=1 and DieserIndex>1)
					bMenuSubEintr%DieserIndex%:=ErstesItemText
				if(A_Index=1 and MenuEintrag.MaxIndex()<>1)
				{
				}
				else if(StrLen(bMenuSubEintr%DieserIndex%)<240)
					Menu,My%Index%Submenu, add, % "&" Integer3Hex(A_Index) "   " SubStr(bMenuSubEintr%DieserIndex%,1,240),My%Index%Submenu 
				else if(StrLen(bMenuSubEintr%DieserIndex%)>=240)
										Menu,My%Index%Submenu, add, % "&" Integer3Hex(A_Index) "   " SubStr(bMenuSubEintr%DieserIndex%,1,240) " . . .",My%Index%Submenu 

			}
			if(DieserMenuEintrag<>"")
				Menu, FMenu, add, &%A_Index% %bMenuSubEintr1%, :My%Index%Submenu
			; MsgBox %  A_LineNumber "	" bMenuSubEintr1 "	" 
		}
	}
	if(MenuEintrag.MaxIndex()=1)
	{
		if NextAnzeige
			Menu,My%Index%Submenu, add,&g   Next,My%Index%Submenu 
;		if CaretXBestMerker is not Integer
;			MsgBox Menu,My1Submenu,Show,%CaretXBestMerker%,(%CaretYBestMerker%+%SubMenuItems%*15)
		WinActivate,ahk_id %DiesesWinHwnd%	; Damit CaretXBestMerker und CaretYBestMerker trift
		WinWaitActive,ahk_id %DiesesWinHwnd%,,1
		Menu,My1Submenu,Show,% CaretXBestMerker,% (CaretYBestMerker+15*DpiKorrektur)
		if (My1SubmenuReturn="Next")
		{
			DeltaIndex:=DeltaIndex+13
			; MsgBox % A_LineNumber "	DeltaIndex=" DeltaIndex ;13, 26, 39, 52 
			return "Next"
		}
		else if (My1SubmenuReturn="Last")
		{
			DeltaIndex:=DeltaIndex-13
			return "Last"
		}
		else if (My1SubmenuReturn="NeuerSuchString")
		{
			return "NeuerSuchString"
		}
		else if (My1SubmenuReturn="Aktivieren")
		{
			return "Aktivieren"
		}
		else
		{
			DieseAuswahlKurz:=My1SubmenuReturn+DeltaIndex
			DieseAuswahlLen:=StrLen(DieseAuswahlKurz)
			DieseAuswahl:=DieseAuswahlKurz
			Loop % 6-DieseAuswahlLen
				DieseAuswahl:="0" DieseAuswahl
			DeltaIndex:=0
			; MsgBox % DieseAuswahl bMenuSubEintr%DieseAuswahlKurz%
			return DieseAuswahl bMenuSubEintr%DieseAuswahlKurz%
		}
	}
	else
	{
		; Menu, FMenu, add, ..., :My%Index%Submenu

		; Menu,My%Index%Submenu, add,...,My%Index%Submenu%A_Index% 
		Menu, FMenu,Show
	}

return  ; MenuEintrag[z]
My1Submenu:
if(A_ThisMenuItemPos=1)
	My1SubmenuReturn:="NeuerSuchString"
else if(A_ThisMenuItemPos=2)
{
	if (DieserIndex<16)
		My1SubmenuReturn:="Aktivieren"
	else
		My1SubmenuReturn:="Last"
}
else if(A_ThisMenuItemPos=16)
	My1SubmenuReturn:="Next"
else
	My1SubmenuReturn:=A_ThisMenuItemPos
return
MsgBox % "Thislabel=" A_ThisLabel "	" A_ThisMenu "	" A_ThisMenuItemPos "	" A_ThisMenuItem
My1SubmenuReturn:=SubStr(A_ThisLabel,-1,2)		; +DeltaIndex
return
My1Submenu0:
My2Submenu1:
My2Submenu2:
My2Submenu3:
My2Submenu4:
Item0:
Item1:
Item2:
FMenu0:
FMenu1:
FMenu2:
FMenu3:
FMenu4:
FMenu5:
FMenu6:
FMenu7:
FMenu8:
FMenu9:
FMenu10:
FMenu11:
FMenu12:
FMenu13:
FMenu14:
FMenu15:
FMenu16:
FMenu17:
FMenu18:
FMenu19:
; MsgBox % A_ThisLabel
return A_ThisLabel
}
;}
#IfWinActive,ahk_class SciTEWindow	; ------------------ unten HotStrings nur fuer Scite ---------------------------::
:*:`;`{l::`t`;{{}`t	;	Strichpunkt Geschweifte-Klammer-Auf l	um Labels einklappen zu koennen
:*:`;`{f::`t`;{{}()`t	;	Strichpunkt Geschweifte-Klammer-Auf f	um Functiones einklappen zu koennen
:*:`;`}::`;{}}`t	;	Strichpunkt Geschweifte-Klammer-Zu	um das Einklapp-Ende zu kennzeichnen
; #IfWinActive, ahk_class SciTEWindow
F6::	;{	Fokussiert und zentriert die Eingabe-Y-Position von Scite	;}	
SciteMittig:	;{	Fokussiert und zentriert die Eingabe-Y-Position von Scite
BlockInput,On
ControlSend,,{F6}, ahk_class SciTEWindow
sleep 200
WinGetPos,SciteX,SciteY,SciteW,SciteH, ahk_class SciTEWindow
sleep 200
loop 10
{
	if(SciteY+SciteH-A_CaretY <100)
	{
		sleep 100
	}
	else
		break
	sleep 100
}
sleep 200
if(A_CaretY<SciteY+SciteH/2)
{
	Ups:=round((SciteY+SciteH/2-A_CaretY-100)/22/DpiKorrektur)
	loop % Ups
	{
		ControlSend,Scintilla1,{Control Down}{Up}{Control Up}, ahk_class SciTEWindow
		sleep 20
	}
}
else
{
	Downs:=round((A_CaretY-SciteY-SciteH/2-100)/15/DpiKorrektur)
	loop % Downs
	{
		ControlSend,Scintilla1,{Control Down}{Down}{Control Up}, ahk_class SciTEWindow
		sleep 20
	}
}
BlockInput,Off
return
;}	
;}	
#Include *i WeitereUnterprogrammeFunktionen.ahk
; Prüfen ob noch benötigt?
WurzelContainerUebersichtErzeugenAnzeigen:	;{	
SkriptDataPath:=ZackData
gosub KontainerAnzeigen
FileDelete,%SkriptDataPath%\Wurzel??.txt
FileDelete,%SkriptDataPath%\Wurzel?.txt
FileDelete,%SkriptDataPath%\WurzelIndex.txt
Loop, 20
{
;  ############################################ geht sicher noch besser #############################################
	FileDelete,%SkriptDataPath%\%A_Index%_C˸►ProgramData►Zack►WuCont►°-R\*.txt			; OK
	FileDelete,%SkriptDataPath%\%A_Index%_E˸►ProgramData►Zack►WuCont►°-R\*.txt			; OK
	FileDelete,%SkriptDataPath%\%A_Index%_F˸►ProgramData►Zack►WuCont►°-R\*.txt			; OK
	FileDelete,%SkriptDataPath%\%A_Index%_G˸►ProgramData►Zack►WuCont►°-R\*.txt			; OK
	FileDelete,%SkriptDataPath%\%A_Index%_H˸►ProgramData►Zack►WuCont►°-R\*.txt			; OK
	FileDelete,%SkriptDataPath%\%A_Index%_I˸►ProgramData►Zack►WuCont►°-R\*.txt			; OK
;  ############################################ geht sicher noch besser #############################################
}
MsgBox, 8192, verarbeite ..., Bitte einen Moment Geduld ...`n`n... schliessst selbstaendig`n`n`ndanach folgt ein Skript-Neustart., 3
NeueWurzel:=WurzelContainer 	"\*-R"			; 	"\*"
gosub NeueWurzelHinzufuegenBeiVorhandenemWurzelName
Reload
sleep 3000
; Scharfschalten nach erfolgter Sicherung
return
;}	
WurzelContainerAnlegen:	;{	
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
;}	
ü:	;{	
WurzelContainerUebersichtOeffnen:	; gespeicherte ContainerUebsicht oeffnen
SkriptDataPath:=ZackData
gosub KontainerAnzeigen
gosub Button1OhneMausPos
return
;}	
WurzelContainerErzeugenAnzeigen:	;{
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
;}	
SetAutoFavorit_VorbereitetZumLoeschen:	;{	
fehlersuche:=true
if((StrLen(Edit8)-StrLen(FuehrendeSterneEntfernen(Edit8))) < AutoFavorit)
	SetFavorit(FuehrendeSterneEntfernen(Edit8),AutoFavorit,"BehaltePfad",FavoritenDirPath,1)
fehlersuche:=false
return
;}	
 ; .&"			Chr(mi)
 MenuKurzTaste(mi){
	global MenuKurzTasten
	if MenuKurzTasten
	{
		return " .&" Chr(mi)
	}
	else
		return
}
 /*
	Quelle: https://autohotkey.com/board/topic/60985-get-paths-of-selected-items-in-an-explorer-window/
	Library for getting info from a specific explorer window (if window handle not specified, the currently active
	window will be used).  Requires AHK_L or similar.  Works with the desktop.  Does not currently work with save
	dialogs and such.
	
	
	Explorer_GetSelected(hwnd="")   - paths of target window's selected items
	Explorer_GetAll(hwnd="")        - paths of all items in the target window's folder
	Explorer_GetPath(hwnd="")       - path of target window's folder
	
	example:
		F1::
			path := Explorer_GetPath()
			all := Explorer_GetAll()
			sel := Explorer_GetSelected()
			MsgBox % path
			MsgBox % all
			MsgBox % sel
		return
	
	Joshua A. Kinnison
	2011-04-27, 16:12
*/
Explorer_GetPath(hwnd="")
{
	if !(window := Explorer_GetWindow(hwnd))
		return ErrorLevel := "ERROR"
	if (window="desktop")
		return A_Desktop
	path := window.LocationURL
	path := RegExReplace(path, "ftp://.*@","ftp://")
	StringReplace, path, path, file:///
	StringReplace, path, path, /, \, All 
	
	; thanks to polyethene
	Loop
		If RegExMatch(path, "i)(?<=%)[\da-f]{1,2}", hex)
			StringReplace, path, path, `%%hex%, % Chr("0x" . hex), All
		Else Break
	return path
}
Explorer_GetAll(hwnd="")
{
	return Explorer_Get(hwnd)
}
Explorer_GetSelected(hwnd="")
{
	return Explorer_Get(hwnd,true)
}
Explorer_GetWindow(hwnd="")
{
	; thanks to jethrow for some pointers here
    WinGet, process, processName, % "ahk_id" hwnd := hwnd? hwnd:WinExist("A")
    WinGetClass class, ahk_id %hwnd%
	
	if (process!="explorer.exe")
		return
	if (class ~= "(Cabinet|Explore)WClass")
	if (class ~= "(Cabinet|Explore)WClass")
	{
		try
		{
			for window in ComObjCreate("Shell.Application").Windows
				if (window.hwnd==hwnd)
					return window
		}
		return
	}
	else if (class ~= "Progman|WorkerW") 
		return "desktop" ; desktop found
}
Explorer_Get(hwnd="",selection=false)
{		; Alternative: https://autohotkey.com/boards/viewtopic.php?t=77
	if !(window := Explorer_GetWindow(hwnd))
		return ErrorLevel := "ERROR"
	if (window="desktop")
	{
		ControlGet, hwWindow, HWND,, SysListView321, ahk_class Progman
		if !hwWindow ; #D mode
			ControlGet, hwWindow, HWND,, SysListView321, A
		ControlGet, files, List, % ( selection ? "Selected":"") "Col1",,ahk_id %hwWindow%
		base := SubStr(A_Desktop,0,1)=="\" ? SubStr(A_Desktop,1,-1) : A_Desktop
		Loop, Parse, files, `n, `r
		{
			path := base "\" A_LoopField
			IfExist %path% ; ignore special icons like Computer (at least for now)
				ret .= path "`n"
		}
	}
	else
	{
		if selection
			collection := window.document.SelectedItems
		else
			collection := window.document.Folder.Items
		for item in collection
			ret .= item.path "`n"
	}
	return Trim(ret,"`n")
}
StopComputerForce:	;{	
Befehl:="Stop-Computer -Force"
RunWaitPsEin(Befehl) 
return
;}	
StopComputer:	;{	
Befehl:="Stop-Computer"
RunWaitPsEin(Befehl) 
return
;}	
TimerEveryFuenfSec:
TimerEveryFuenfSec()
return
; ööööööööööööööööööööööööööööööööööööööööööööö
TimerEveryFuenfSec(){
		global ViaTimerKenner,ViaTimerKennerLen, Edit2,HwndButton1,ViaTimerTargetLabel
	; SoundBeep
	; if (wParam=23)
	; {		; OnEvent? WM_COMMAND_17	Gosub F5clip://In_Row? Edit6
		; SoundBeep, 300
		StringReplace,Edit2Modi,Edit2,``v,`v,All

		if(InStr(Edit2Modi,ViaTimerKenner))
		{			; OnEvent? OnClipboardChange`tGosub F5`vclip://
				Pos:=InStr(Edit2Modi,ViaTimerKenner)
				; Pos2:=InStr(SubStr(Edit2Modi,Pos1),"")
				DiesesLabel:=SubStr(Edit2Modi,Pos+ViaTimerKennerLen+1)
				; MsgBox %DiesesLabel%
				if(IsLabel(DiesesLabel))
				{
					; SoundBeep 2400
					; sleep 1000
					; gosub %DiesesLabel%
					ViaTimerTargetLabel:=DiesesLabel
					SetTimer,ViaTimer,-1000
				}
			
			
		}
	; }
	return
}

WM_COMMAND(wParam, lParam, msg, hwnd) ;{()	allgemeiner Event
{		; https://ahkde.github.io/docs/misc/SendMessage.htm
	global OnEventKenner, Edit2,HwndButton1
	; SoundBeep
	if (wParam=23)
	{		; OnEvent? WM_COMMAND_17	Gosub F5clip://In_Row? Edit6
		; SoundBeep, 300
		StringReplace,Edit2Modi,Edit2,``v,`v,All

		if(InStr(Edit2Modi,OnEventKenner))
		{			; OnEvent? OnClipboardChange`tGosub F5`vclip://
			; SoundBeep 600
			if(InStr(Edit2Modi,"WM_COMMAND_17")) ; AND AufRufEvent="WM_COMMAND")	
			{		; OnEvent? OnClipboardChange	Gosub F5clip://In_Row? Edit6
				; SoundBeep 1200
				Pos1:=InStr(Edit2Modi,"Gosub")+5
				Pos2:=InStr(SubStr(Edit2Modi,Pos1),"")
				DiesesLabel:=SubStr(Edit2Modi,Pos1+1,Pos2-2)
				; MsgBox %DiesesLabel%
				if(IsLabel(DiesesLabel))
				{
					; SoundBeep 2400
					; sleep 1000
					; gosub %DiesesLabel%
					ViaTimerTargetLabel:=DiesesLabel
					SetTimer,ViaTimer,-1000
				}
			}
			
		}
	}
	return
	/*
; Fremd-Beispielskript zur Even-Ausloesung in ZZO
; Drueckt alle 10 sec Button 1 vn ZZO wenn in Edit2 z.B.
; OnEvent? WM_COMMAND_17	Gosub F5clip://
; drinn steht
Loop
{				; OnEvent? WM_COMMAND_17	Gosub F5clip://
	ZzoHauptFensterButton1HwndPfad:=% A_AppDataCommon "\Zack\ZzoHauptFensterButton1Hwnd.txt"
	FileRead,ZzoInfos,%ZzoHauptFensterButton1HwndPfad%
	loop, Parse, ZzoInfos,`n
	{	
		Wert:= 	StrSplit(ZzoInfos,A_Tab)
		IfWinExist, % "ahk_id " Wert[A_Index]
			break
	}
	; MsgBox % ZzoInfos "`r`n" wert.1  A_Tab Wert.2
		SendMessage,0x111,0x17,% "ahk_id" Wert.2
	;  	MsgBox % HwndButton1 A_Tab wParam A_Tab lParam A_Tab  msg A_Tab  hwnd
		sleep 5000
}
ExitApp
	*/
}
;}	
/*
	
	global HwndButton1
	; ListLines
	; meldet Gui Add und weitere
	; benoetigt: OnMessage(0x111, "WM_COMMAND")
 	; MsgBox % HwndButton1 A_Tab wParam A_Tab lParam A_Tab  msg A_Tab  hwnd
	if (wParam=23)
		MsgBox % wParam A_Tab lParam A_Tab  msg A_Tab  hwnd
	; SoundBeep
	return
}
*/
WM_MOUSEMOVE()	;{()	MouseOver Hilfe
{
	; global
	global TT, ExternalToolTipPath, beschaeftigt
	static LastKey, LastToolTipTime:=0 , WmBeschaftigt ,i ;  , DiesesMouseOverHWND, 
	if beschaeftigt
		return
	if WmBeschaftigt
		return
	WmBeschaftigt:=true
	if (i="")
		i=0
	++i
	if (i>18)
		i:=1
	; SoundBeep 400
	sleep 100
; 	if (At:=A_TimeIdlePhysical > 500)
	{
		if (A_TickCount - LastToolTipTime > 1000)
		{
			; SoundBeep 800
			; sleep 100
			MouseGetPos,,,, DiesesMouseOverHWND,2	; wiso kann das HWND nicht ausgelesen werden
			; ToolTip % DiesesMouseOverHWND ">"
			if(TT.HasKey(DiesesMouseOverHWND))
			{
				sleep 200
				MouseGetPos,,,, DiesesMouseOverHWND2,2	; wiso kann das HWND nicht ausgelesen werden
				if(DiesesMouseOverHWND=DiesesMouseOverHWND2 AND TT.HasKey(DiesesMouseOverHWND))
				{
					; SoundBeep 1600
					sleep 100
					if(DiesesMouseOverHWND<>LastKey)
					{
						; SoundBeep 3200
						sleep 100
						RunOtherAhkScriptOrExe(ExternalToolTipPath,TT[DiesesMouseOverHWND])
						LastToolTipTime:=A_TickCount
						LastKey:=DiesesMouseOverHWND
					}
				}
			}
		}
		else if(A_TimeIdlePhysical >3000)
			LastKey:=
	}
;	else
;		SoundBeep
;	ToolTip, % AT "	1	" A_TickCount - LastToolTipTime "	2	"LastKey "	3	" DiesesMouseOverHWND "	4	" LastToolTipTime,10,1000+30*i,i
	WmBeschaftigt:=false

	return
}
;}	
isBefore(ST1,ST2)	;{()	ist String1 im Alphabet vor String2
{
	if(St1="" and St2="")
		Return "Error"
	else if (St1="")
		return false
	else if (St2="")
		return true
	Gvor:=g:= St1 . "`n" . St2
	sort,g
	if(Gvor=g)
		return true
	else
		return false
}
;}	
Edit8HtmlFuellen2:	;{	internes Label fuer die Edit8-Anzeige
if (A_TimeIdlePhysical<600)
	return
quick:=false
; SoundBeep
Edit8HtmlFuellen:
Thread, Priority,-256
Thread, Interrupt,0,0
if (quick AND NOT InMacro)
{
; 	SoundBeep
	Edit8Info:=Edit8
	SetTimer,Edit8HtmlFuellen2,-1000
}
else
	Edit8Info:=GetPathInfo(FuehrendeSterneEntfernen(Edit8))
if ObjetDetails
; if (IsObject(Edit8Info))
 	MsgBox % GetObjectDetails(Edit8Info,"Edit8Info")
Edit8Html := GetHtmlPath(Edit8)
quick:=true
GoSub, GetHTML
gosub ResetHTML
return
;}	
Doc_OnClick(doc) {	;{()	interne Fuktion fuer Edit8 Events
	global Edit8,Edit8AusLink,PfadAnfang1,PfadAnfang2,PfadAnfang3,PfadAnfang4,PfadAnfang5,PfadAnfang6,PfadAnfang7,PfadAnfang8,PfadAnfang9,PfadAnfang10,PfadAnfang11,PfadAnfang12,PfadAnfang13,PfadAnfang14,PfadAnfang15,PfadAnfang16,PfadAnfang17,PfadAnfang18,PfadAnfang19,PfadAnfang20,ie,AnE5E8
	; SoundBeep 6000
	id := doc.parentWindow.event.srcElement.id
	
	if (Id="E8")
	{
		Edit8:=Edit8AusLink
		gosub Edit8Festigen
		gosub Edit8ExplorerSelect
		return
	}
	else if(Id="OpenWith0")
	{
		ExtClick:=false
		gosub LetzterContainerStartMenu
		gosub Edit8OeffnenMit
		return
	}
	else if(Id="type")
	{
		; Neuer Ordner Eintrag interresiert hier nicht.
		return
	}
	else if (SubStr(id,1,1) = "L" AND SubStr(id,3,1) = "Z")
	{
		; Loop, % SubStr(id,2,1)
		; 	SoundBeep
		PfadAnfangIndex:=SubStr(id,2,1)
		; doc.write(html)
		; gosub ResetHTML
	}
	else if (SubStr(id,1,1) = "L" AND SubStr(id,4,1) = "Z")
	{
		; Loop, % SubStr(id,2,2)
		; 	SoundBeep
		PfadAnfangIndex:=SubStr(id,2,2)
	}
	ExtClick:=false
	if(PfadAnfang%PfadAnfangIndex%="EXT")
	{
		ExtClick:=true
		--PfadAnfangIndex
	}
	IfExist % PfadAnfang%PfadAnfangIndex%
	{
		Edit8:=PfadAnfang%PfadAnfangIndex%
		gosub Edit8Festigen
		; gosub Edit8HtmlFuellen
	}
	if ExtClick
		gosub Edit8Oeffnen
	else
		gosub Edit8Explorer
	; MsgBox % Edit8
	; Menu, Edit8Menue, Show
}
;}	
DocX_oncontextmenu(doc) {
	Menu, Edit8Menue, Show
	; SoundBeep 2000
}
Doc_oncontextmenu(doc) {
	global Edit8,Edit8AusLink,PfadAnfang1,PfadAnfang2,PfadAnfang3,PfadAnfang4,PfadAnfang5,PfadAnfang6,PfadAnfang7,PfadAnfang8,PfadAnfang9,PfadAnfang10,PfadAnfang11,PfadAnfang12,PfadAnfang13,PfadAnfang14,PfadAnfang15,PfadAnfang16,PfadAnfang17,PfadAnfang18,PfadAnfang19,PfadAnfang20,ExternalToolTipPath
	; SoundBeep
	id := doc.parentWindow.event.srcElement.id
	; MsgBox % id
	if (Id="E8")
	{
		Edit8:=Edit8AusLink
		gosub Edit8Festigen
	}
	else if(SubStr(Id,1,8)="OpenWiths")
	{
		ExtClick:=false
		gosub LetzterContainerStartMenu
		RunOtherAhkScriptOrExe(ExternalToolTipPath,"Nach betaetigen der Escape-Taste `noeffnet sich das Kontext-Menu, welches durch Rechts-Klick auf ... eingeleitet wurde")
		input,D,V,{Enter}{esc}{tab}
	}
	else if (SubStr(id,1,1) = "L" AND StrLen(Id)=2)
	{
		; Loop, % SubStr(id,2,1)
		; 	SoundBeep
		PfadAnfangIndex:=SubStr(id,2,1)
		; doc.write(html)
		; gosub ResetHTML
	}
	else if (SubStr(id,1,1) = "L" AND StrLen(Id)=3)
	{
		; Loop, % SubStr(id,2,2)
		; 	SoundBeep
		PfadAnfangIndex:=SubStr(id,2,2)
	}
	IfExist % PfadAnfang%PfadAnfangIndex%
	{
		Edit8:=PfadAnfang%PfadAnfangIndex%
		gosub Edit8Festigen
		; gosub Edit8HtmlFuellen
	}
	; MsgBox % Edit8
	Menu, Edit8Menue, Show
	gosub Edit8Festigen			; wird mit sleep 200 benoetigt, dass das Originalkontextmenue von Edit8Anzeige nicht aufspringt
	; SoundBeep
	sleep 200		; wird mit gosub Edit8Festigen benoetigt, dass das Originalkontextmenue von Edit8Anzeige nicht aufspringt
	return
}
ResetHTML:	;{	
{
   doc.body.innerHTML := html
   return
}
;}	
GetHTML:	;{	
{
	if(Edit8Info.1.IsDir)
	{
		NewDirExtraFeld=<input id="type" name="type" type="text" value="%NewDir%" />
		if(Edit8Info.1.TimeModi)
		{
			DieseEigenschaften:=A_Space  "&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; ✎🕔: " Edit8Info.1.TimeModi "`," " 🔨🕔: " Edit8Info.1.TimeCrea "`," " Attrib:" Edit8Info.1.Attrib
		}
		else
		{
			DieseEigenschaften:=
		}
	}
	else
	{
			
		if(Edit8Info.3.KannAusfuehren)
			KannAusfuehrenChar:="⚙⚙"
		else if(Edit8Info.3.KannAusgefuehrtWerden)
		{
			HK="
			KannAusfuehrenChar:="⚙" "<a href=" HK "C:\" HK A_Space "rel=" HK "noopener" HK A_Space "target=" Hk  "" HK A_Space "id=" HK "OpenWith" Edit3 HK ">" "..." "</a>"
		}
;		else
;			KannAusfuehrenChar:="."
		else
			KannAusfuehrenChar:="."
	
		NewDirExtraFeld:=
		if(Edit8Info.1.TimeModi)
			DieseEigenschaften:=A_Space KannAusfuehrenChar   "&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; ∑: " Edit8Info.1.Size "`," " ✎🕔: " Edit8Info.1.TimeModi "`," " 🔨🕔: " Edit8Info.1.TimeCrea "`," " Attrib:" Edit8Info.1.Attrib
		else if(Edit8Info.3.KannAusgefuehrtWerden or Edit8Info.3.KannAusfuehren)
			DieseEigenschaften:=A_Space KannAusfuehrenChar
		else
			DieseEigenschaften:=
	}
	if Edit8HtmlErsetzen{
		StringReplace,Edit8HtmlExt,Edit8Html,>Edit8</a> =,></a>
		if (AnE5E8Edit3Last AND (AnE5E8Edit3Last<>Edit3))
		{
			; SoundBeep 3000 300
				RunOtherAhkScriptOrExe(ExternalToolTipPath,AnE5E8Edit3Last)
				; MsgBox % "Edit8HtmlExtLast=" Edit8HtmlExtLast
				; ListVars
			AnE5E8.GetSetOneOfAllTags("/ID=z" AnE5E8Edit3Last,,"innerHtml",,"<div ID='z" AnE5E8Edit3Last "z' "  ">" BildUebersicht2Html(LastDiesesEdit8Sternlos,16)  Edit8HtmlExtLast A_Space NewDirExtraFeldLast " &nbsp; " DieseEigenschaftenLast "</div>`r`n")
		}
		; MsgBox % "Edit8HtmlExt=" Edit8HtmlExt
		AnE5E8.GetSetOneOfAllTags("/ID=z" Edit3,,"innerHtml",,"<div ID='z" Edit3 "z' " AnE5E8HgF ">" BildUebersicht2Html(DiesesEdit8Sternlos,150) Edit8HtmlExt A_Space NewDirExtraFeld " &nbsp; " DieseEigenschaften "</div>`r`n")
		; SoundBeep 6000 300
		if (AnE5E8Edit3Last=Edit3)
		{
			if AnE5E8Edit3Last
			{
				AnE5E8HgFLastLast:=AnE5E8HgFLast
				AnE5E8HgFLast:=AnE5E8HgF4Last
			}
			else
			{
				AnE5E8HgFLast:=AnE5E8HgF4Last
			}
			Edit8HtmlExtLast:=Edit8HtmlExt
			NewDirExtraFeldLast:= ; NewDirExtraFeld
			DieseEigenschaftenLast:=DieseEigenschaften
		}
		AnE5E8Edit3Last:=Edit3
		LastDiesesEdit8Sternlos:=DiesesEdit8Sternlos	
	}

   html =
   (
      <html>
         <body bgcolor="white">
		 <a name="oben"></a>
			%Edit8Html% %NewDirExtraFeld% %DieseEigenschaften%
         </body>
      </html>
   )
   return
   ; 			%Edit8Html% <input id="test" type="text" value="Select me!" />

}
;}
GuiCloset:	;{
{
 }
ExitApp
;}	
GetHtmlPath(Path)	;{()	
{
	global InMacro,quick,Edit8Info,Edit8AusLink,PfadAnfang1,PfadAnfang2,PfadAnfang3,PfadAnfang4,PfadAnfang5,PfadAnfang6,PfadAnfang7,PfadAnfang8,PfadAnfang9,PfadAnfang10,PfadAnfang11,PfadAnfang12,PfadAnfang13,PfadAnfang14,PfadAnfang15,PfadAnfang16,PfadAnfang17,PfadAnfang18,PfadAnfang19,PfadAnfang20,Edit3
	HK = "
	Path:=FuehrendeSterneEntfernen(Path)
	Edit8AusLink:=Path
	LastChar:=SubStr(Path,0,1)
	if (IfFileOderDirSyntax(Path))	;		Prueft Pfad primitiv
	{		
		if(SubStr(Path,1,2)="\\")
		{
			NetzLaufWerk:="\\"
			StringTrimLeft,Path,Path,2
		}
		StringSplit,Dir,Path,\
		Loop, % Dir0
		{
			if(Dir0=A_Index)
			{
				if(Edit8Info.1.IsDir)
				{
					IfExist %Path%\*.*
						HGF:="#FFFF77"
					else
						HGF:="#FFBBBB"
				}
				else
					HGF:="#FFFFFF"
				ba:="<span style='background-color: " HGF ";'><b>"
				be:="</b></span>"
			}
			PfadAnfang.= NetzLaufWerk Dir%A_Index%
			PfadAnfang%A_Index%:=PfadAnfang
			DieserPfad:=false
			if (InMacro OR not quick )
			{
				IfExist % PfadAnfang
					DieserPfad:=true
			}
; 			else
; 				SoundBeep,3000				
			if(DieserPfad or NetzLaufWerk="\\")
			{
				if(Dir0=A_Index AND InStr(Dir%A_Index%,"."))
				{
					IndexP1:=Dir0+1
					PfadAnfang%IndexP1%:= "EXT"
					DiesePos:=InStr(Dir%A_Index%,".",,0)
					FileName:= SubStr(Dir%A_Index%,1,DiesePos-1)
					FileExt:=SubStr(Dir%A_Index%,DiesePos+1)
					Html.= ba "<a href=" HK PfadAnfang HK A_Space "rel=" HK "noopener" HK A_Space "target=" Hk  "" HK A_Space "id=" HK "L" A_Index "Z" Edit3 HK ">" NetzLaufWerk FileName "</a>"  be "."
					Html.= ba "<a href=" HK PfadAnfang HK A_Space "rel=" HK "noopener" HK A_Space "target=" Hk  "" HK A_Space "id=" HK "L" (A_Index+1) "Z" Edit3 HK ">" NetzLaufWerk FileExt "</a>"  be "\"
					
				}
				else
					Html.= ba "<a href=" HK PfadAnfang HK A_Space "rel=" HK "noopener" HK A_Space "target=" Hk  "" HK A_Space "id=" HK "L" A_Index "Z" Edit3 HK ">" NetzLaufWerk Dir%A_Index% "</a>"  be "\"
				; Html.="<a href=" HK "#oben" HK A_Space "target=" Hk HK A_Space "id=" HK "L" A_Index HK ">" ba Dir%A_Index% be "</a>\"
			}
			else
				Html.= NetzLaufWerk Dir%A_Index% "\"
			PfadAnfang.= "\"
			NetzLaufWerk:=
		}
		LastHtmlChar:=SubStr(Html,0,1)
		if(LastChar<>LastHtmlChar)
			StringTrimRight,Html,Html,1
	}
	else if(InStr(Path,"tps://") OR InStr(Path,"tp://"))
		Html:="<a href=" HK Path HK A_Space  "rel=" HK "noopener" HK A_Space "target=" Hk  HK A_Space "id=" HK "L1" HK ">" Path "</a>"
	else
		return Path
	Html:= "<a href=" HK Edit8AusLink HK A_Space  "rel=" HK "noopener" HK A_Space "target=" Hk  HK A_Space "id=" HK "E8" HK ">" "Edit8" "</a> = " Html
	return Html
}
;}	
SetPathsInClipAllTime:	;{	Alle Zeitstempel der Dateien und Ordner auf welche die Pfade im Clipboard zeigen neu setzten. Statt der Pfade sind auch Pfadmuster (mit Wildcards) erlaubt, diese werden jedoch nicht rekursiv verarbeitet.
InputBox,Time,Zeitstempel,Zeitstempel aller bearbeitbarer Dateien und Ordner von Clipboard setzten auf:,,,,,,,,%A_Now%
if ErrorLevel
	return
MsgBox, 262436,Zeitstempel,setze Zeitstempel auf %Time% von `n%Clipboard%
IfMsgBox,Yes
	SetObjectTime(Clipboard,Time,"All")
return
;}	
SetObjectTime(PfadListe,Time="",WitchTime="M",Delimiter="`n",OmitChars="`r")
{
	if (Time="")
		Time:=A_Now
	if(WitchTime="All")
	{
		Loop,Parse,PfadListe,%Delimiter%,%OmitChars%
		{
			FileSetTime,%Time%,%A_LoopField%,C,1
			FileSetTime,%Time%,%A_LoopField%,M,1
			FileSetTime,%Time%,%A_LoopField%,A,1
		}
	}
	else
	{
		Loop,Parse,PfadListe,%Delimiter%,%OmitChars%
		{
			FileSetTime,%Time%,%A_LoopField%,%WitchTime%,1
		}
	}
}

GetHtmlText(Url)
{
	UrlSternlos:=FuehrendeSterneEntfernen(Url)
	if(not InStr(UrlSternlos,"tp://"))
		return
	/*
; 	if (NOT IsObject(owb))
	{
		owb := ComObjCreate("InternetExplorer.Application")
		SoundBeep 3000
	}
	; if (sichtbar="" OR not sichtbar)
	; 	wb.Visible := false
	; else if sichtbar
		owb.Visible := true
	owb.Navigate(UrlSternlos)
	while (owb.busy || owb.readystate != 4)
	{
		sleep , 100
		if (A_Index > 600)
		{
			SoundBeep, 250
			break
		}
	}
	; sleep 5000
	; text := wb.document.all.primary_nav.innerText
	Htmltext := owb.document.documentElement.innerText		; Quelle https://autohotkey.com/board/topic/32012-ie-and-gui-browser-com-tutorial/
	; if (trim(Htmltext)="" AND sichtbar="")
	; {
	;	wb.Navigate(UrlSternlos)
	;	while (wb.busy || wb.readystate != 4)
	;		sleep , 100
	;	Htmltext := wb.document.documentElement.innerText		; Quelle 
	; }
	owb.quit
	owb.quit()
	; owb.exit()
	; owb.stop()
	; owb:=""
	; sleep 10000
	; wb.Visible := false
	; MsgBox laeuft IE noch?
	; Return Htmltext
	return
	

	return ReturnText
	;// open Standard Internet Explorer	Quelle: https://autohotkey.com/board/topic/56987-com-object-reference-autohotkey-v11/://autohotkey.com/board/topic/56987-com-object-reference-autohotkey-v11/page-2?&#entry362159
	*/
WebRequest :=	ComObjCreate("WinHttp.WinHttpRequest.5.1") 	; Quelle: https://autohotkey.com/boards/viewtopic.php?t=77
WebRequest.Open("GET", UrlSternlos)
; WebRequest.Open("POST", UrlSternlos)
; HTTPREQUEST_SETCREDENTIALS_FOR_SERVER := 0
; HTTPREQUEST_SETCREDENTIALS_FOR_PROXY := 1
WebRequest.Send()
ReturnText:=WebRequest.ResponseText
; WebRequest.quit
WebRequest :=	""
return ReturnText
/*
RegExMatch(WebRequest.ResponseText, "(?<=<h2>).*?(?=</h2>)", ver)
MsgBox %	ver

mit Login				siehe auch: https://autohotkey.com/boards/viewtopic.php?t=92
HTTPREQUEST_SETCREDENTIALS_FOR_SERVER := 0
HTTPREQUEST_SETCREDENTIALS_FOR_PROXY := 1
    WebRequest.SetCredentials("username", "password", HTTPREQUEST_SETCREDENTIALS_FOR_PROXY)
To authenticate with both the server and the proxy, the application must call SetCredentials twice; first with the Flags parameter set to HTTPREQUEST_SETCREDENTIALS_FOR_SERVER, and second, with the Flags parameter set to HTTPREQUEST_SETCREDENTIALS_FOR_PROXY.
https://autohotkey.com/board/topic/56987-com-object-reference-autohotkey-v11/page-14

wb := ComObjCreate("InternetExplorer.Application") ;// create IE

wb.Visible := true ;// show IE
wb.GoHome() ;// Navigate Home

;// the ReadyState will be 4 when the page is loaded
while wb.ReadyState <> 4
    continue

;// get the Name & URL of the site
; MsgBox % "Name: " wb.LocationName
;     . "`nURL: " wb.LocationURL
;     . "`n`nLet's Navigate to Autohotkey.com..."

;// get the Document - which is the webpage
document := wb.document

;// Navigate to UrlSternlos
wb.Navigate(UrlSternlos) ;// 2nd param - see NavConstants

;// the Busy property will be true while the page is loading
while wb.Busy
    continue
MsgBox % document.Text
ReturnText:=document.Text

MsgBox Page Loaded...Going Back Now

;// Go Back
wb.GoBack()

while wb.Busy
    continue
MsgBox The page is loaded - now we will refresh it...

;// Refresh the page
wb.Refresh()
while wb.Busy
    continue
MsgBox Now that the page is Refreshed, we will Select All (^a)...

;// Execute Commands with ExecWB()
SelectAll := 17 ;// see CMD IDs
wb.ExecWB(SelectAll,0) ;// second param as "0" uses default options

Sleep 2000
MsgBox Now that we are done, we will exit Interent Explorer
;// Quit Internet Explorer
wb.Quit()
return ReturnText
*/
}

AutoMacroSetup:	;{	
AutoMacroIndex:=0
Loop,Files,%MacroTimerOrEventStartedDir%\*.txt,F
{
	StringSplit,MacroStartDetail,A_LoopFileName,_
	loop, % MacroStartDetail0
	{
		IndexPlus1:=A_Index + 1
		if (MacroStartDetail%A_Index%="Every")
		{
			++AutoMacroIndex
			if (AutoMacroIndex > 9)
			{
				MsgBox % A_LineNumber "	momentan werden nur 2 Timergesteuerte Macros unterstuetzt"
				return
			}
			DiesenBefehlsDateiPfad%AutoMacroIndex%:=A_LoopFileLongPath
			SetTimer , MacroTimerOrEventStarted%AutoMacroIndex%,% MacroStartDetail%IndexPlus1%
		}
		else if (MacroStartDetail%A_Index%="Asap" AND MacroStartDetail%IndexPlus1%="Macro")
		{
			++AutoMacroIndex
			if (AutoMacroIndex > 9)
			{
				MsgBox % A_LineNumber "	momentan werden nur 2 Timergesteuerte Macros unterstuetzt"
				return
			}
			DiesenBefehlsDateiPfad%AutoMacroIndex%:=A_LoopFileLongPath
			SetTimer , MacroTimerOrEventStarted%AutoMacroIndex%,-2000
		}
	}		
}
return
#include *i %A_AppData%\Zack\Macro\TimerOrEventStarted\include1.ahk
#include *i %A_AppData%\Zack\Macro\Ahk\include1.ahk


MacroTimerOrEventStarted1:
DiesenBefehlsDateiPfad:=DiesenBefehlsDateiPfad1
gosub DiesenBefehlsDateiPfadAusfuehren
return
MacroTimerOrEventStarted2:
DiesenBefehlsDateiPfad:=DiesenBefehlsDateiPfad2
gosub DiesenBefehlsDateiPfadAusfuehren
return
MacroTimerOrEventStarted3:
DiesenBefehlsDateiPfad:=DiesenBefehlsDateiPfad3
gosub DiesenBefehlsDateiPfadAusfuehren
return
MacroTimerOrEventStarted4:
DiesenBefehlsDateiPfad:=DiesenBefehlsDateiPfad4
gosub DiesenBefehlsDateiPfadAusfuehren
return
MacroTimerOrEventStarted5:
DiesenBefehlsDateiPfad:=DiesenBefehlsDateiPfad5
gosub DiesenBefehlsDateiPfadAusfuehren
return
MacroTimerOrEventStarted6:
DiesenBefehlsDateiPfad:=DiesenBefehlsDateiPfad6
gosub DiesenBefehlsDateiPfadAusfuehren
return
MacroTimerOrEventStarted7:
DiesenBefehlsDateiPfad:=DiesenBefehlsDateiPfad7
gosub DiesenBefehlsDateiPfadAusfuehren
return
MacroTimerOrEventStarted8:
DiesenBefehlsDateiPfad:=DiesenBefehlsDateiPfad8
gosub DiesenBefehlsDateiPfadAusfuehren
return
MacroTimerOrEventStarted9:
DiesenBefehlsDateiPfad:=DiesenBefehlsDateiPfad9
gosub DiesenBefehlsDateiPfadAusfuehren
return
;}	
GetDriveSpaceFree(Drive="c:\")	;{
{
	DriveSpaceFree, FreeSpace, %Drive%
	return FreeSpace
}
;}	
Edit5MeldungWennWenigSpeicherAufC:	;{()
FreeSpace:=GetDriveSpaceFree()
if (FreeSpace < 12000)
{
	DriveGet, HoleSpace, Cap , C:\
	Edit5:= "Warnung:`nLaufwerk C:\ hat nur noch`n	" FreeSpace " MB`nvon`n	" HoleSpace " MB`nSpeicherkapazitaet frei!"
	gosub Edit5Festigen
	sleep -1
	SoundBeep ,500, 500
}
return
;}	
Wenn(Li,Bed,Re,Params*)	;{()	aehnelt if in AHK nur fuer Macros gedacht. Vorsicht, wenn  ineinander geschachtelte Wenn() bzw Schleife() Macros noetig werden, sind Abarbeitungsfehler zu erwarten. Spaetestens dann sollte ueber AHK-include-Macros nachgedacht werden
{
	global BefehlsMacro
	TrueZweig:=true
	BefehlsMacroZuvor:=BefehlsMacro
	for index,param in params
	{
		if (Param="else")
		{
			TrueZweig:=false
			continue
		}
		if  TrueZweig
			Wahr.=param "`r`n"
		else
			falsch.=param "`r`n"
	}
	if (Bed="IstGleich" AND Li = Re)
	{
		BefehlsMacro:= Wahr
		gosub BefehlsVariableAusfuehren
		BefehlsMacro:=BefehlsMacroZuvor
		return Wahr
	}
	else if (Bed="IstGleich" AND NOT Li = Re)
	{
		BefehlsMacro:= Falsch
		gosub BefehlsVariableAusfuehren
		BefehlsMacro:=BefehlsMacroZuvor
		return Falsch
	}
	else if (Bed="IstUnGleich" AND Li <> Re)
	{
		BefehlsMacro:= Wahr
		gosub BefehlsVariableAusfuehren
		BefehlsMacro:=BefehlsMacroZuvor
		return Wahr
	}
	else if (Bed="IstUnGleich" AND NOT Li <> Re)
	{
		BefehlsMacro:= Falsch
		gosub BefehlsVariableAusfuehren
		BefehlsMacro:=BefehlsMacroZuvor
		return Falsch
	}
	else if (Bed="IstGroesser" AND Li > Re)
	{
		BefehlsMacro:= Wahr
		gosub BefehlsVariableAusfuehren
		BefehlsMacro:=BefehlsMacroZuvor
		return Wahr
	}
	else if (Bed="IstGroesser" AND NOT Li > Re)
	{
		BefehlsMacro:= Falsch
		gosub BefehlsVariableAusfuehren
		BefehlsMacro:=BefehlsMacroZuvor
		return Falsch
	}
	else if (Bed="IstKleiner" AND Li < Re)
	{
		BefehlsMacro:= Wahr
		gosub BefehlsVariableAusfuehren
		BefehlsMacro:=BefehlsMacroZuvor
		return Wahr
	}
	else if (Bed="IstKleiner" AND NOT Li < Re)
	{
		BefehlsMacro:= Falsch
		gosub BefehlsVariableAusfuehren
		BefehlsMacro:=BefehlsMacroZuvor
		return Falsch
	}
	else if (Bed="IstInStr" AND InStr(Li , Re))
	{
		BefehlsMacro:= Wahr
		gosub BefehlsVariableAusfuehren
		BefehlsMacro:=BefehlsMacroZuvor
		return Wahr
	}
	else if (Bed="istInStr" AND NOT InStr(Li , Re))
	{
		BefehlsMacro:= Falsch
		gosub BefehlsVariableAusfuehren
		BefehlsMacro:=BefehlsMacroZuvor
		return Falsch
	}
	else if (Bed="istVorhanden" AND FileExist(Li)<>"")
	{
		BefehlsMacro:= Wahr
		gosub BefehlsVariableAusfuehren
		BefehlsMacro:=BefehlsMacroZuvor
		return Wahr
	}
	else if (Bed="istVorhanden" AND NOt FileExist(Li)<>"")
	{
		BefehlsMacro:= Falsch
		gosub BefehlsVariableAusfuehren
		BefehlsMacro:=BefehlsMacroZuvor
		return Falsch
	}
	else
		MsgBox %A_LineNumber% Die Bedingung %Bed% wird noch nicht untertuetzt.
}
;}	
Sendmail(To,BCC="",CC="",Subject="",TextBody="",From="",sendusername="",sendpassword="",sAttach="",smtpserver="",smtpserverport="")
{
#Include *i %A_ScriptDir%\SendmailDetails.ahk
; Quelle:	https://autohotkey.com/boards/viewtopic.php?t=7736
pmsg 							:= ComObjCreate("CDO.Message")
pmsg.From 						:= From										; Absender
pmsg.To 						:= To										; Empfaenger mehrere Kommagetrennt
pmsg.BCC 						:= BCC   									; fuer andere nicht sichtbarer Empfaenger
pmsg.CC 						:= CC										; Kopi-Empfaenger
pmsg.Subject 					:= Subject
pmsg.TextBody 					:= TextBody
; pmsg.HtmlBody 					:= "<html>...</html>"
sAttach   						:= sAttach 										; can add multiple attachments, the delimiter is |
fields 							:= Object()
fields.smtpserver   			:= smtpserver 								; specify your SMTP server
fields.smtpserverport   		:= smtpserverport 							; 25	465	587	939	995
; fields.smtpusetls  		    := true
fields.smtpusessl      			:= True 									; False
fields.sendusing     			:= 2   										; cdoSendUsingPort
fields.smtpauthenticate 		:= 1  										; cdoBasic
fields.sendusername 			:= sendusername
fields.sendpassword 			:= sendpassword
fields.smtpconnectiontimeout		:= 60
schema 						:= "http://schemas.microsoft.com/cdo/configuration/"
								
pfld 						:=  pmsg.Configuration.Fields
For field,value in fields
	pfld.Item(schema . field) 		:= value
pfld.Update()
Loop, Parse, sAttach, |, %A_Space%%A_Tab%
	pmsg.AddAttachment(A_LoopField)
pmsg.Send()
return
}


; File Open Utilities ;{	
; Quelle: http://www.enhgo.com/snippet/autohotkey/file-open-utilsahk_jasonsparc_autohotkey

MsgBox % FindExecutable("notepad")
MsgBox % FindExecutable("notepad.exe")

OpenAndGetHwnd(sDocument, sParams:="", sValidHwndPredicate:="IsValidWinTitleText", sTimeout:=10) 
{
	AssociatedExe := sDocument
	SplitPath, sDocument, , , OutExt
	if (not OutExt = "exe") 
	{
		AssociatedExe := FindExecutable(sDocument)
		if (not AssociatedExe) 
		{
			IfNotExist sDocument
			{
				MsgBox 0, Error, %sDocument%`n`nThe specified file was not found.
			} 
			else 
			{
				MsgBox 0, Error, %sDocument%`n`nCould not find the associated executable for the specified document.
			}
			return 0
		} 
	else if (sParams) 
	{
		sParams = "%sDocument%" %sParams%
	} 
	else 
	{
		sParams = "%sDocument%"
	}
}

return RunAndGetHwnd(AssociatedExe, sParams, sValidHwndPredicate, sTimeout)
}

RunAndGetHwnd(sExe, sParams:="", sValidHwndPredicate:="IsValidWinTitleText", sTimeout:=10) {
sTargetWin = ahk_exe %sExe%

OldIDs := GetValidWinIDs(sTargetWin, sValidHwndPredicate)
Run %sExe% %sParams%

Retries := sTimeout / 0.5
FailInterval := 500

Loop %Retries% {
WinWait %sTargetWin%,, sTimeout

if ErrorLevel ; Check for timeout
break

TestIDs := GetValidWinIDs(sTargetWin, sValidHwndPredicate)
NewIDs := GetNewEntries(OldIDs, TestIDs)
;MsgBox % GetWinTitleText("ahk_id " . FirstKey(NewIDs))
;MsgBox % EntriesToString(NewIDs)

if (NewIDs.Length()) {
return FirstKey(NewIDs)
}

Sleep FailInterval
}

return ""
}

; Additional Utility Functions

GetInternetShortcutUrl(sInternetShortcutFile) {
IniRead OutUrl, %sInternetShortcutFile%, InternetShortcut, Url, % ""
Return OutUrl
}

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
	
GetWinTitleText(sWinTitle) 
{
	WinGetTitle Out, %sWinTitle%
	return Out
}

IsValidWinTitleText(sWinTitle) 
{
	WinGetTitle Out, %sWinTitle%

	; Checks if invalid window.
	; Add more checks below.
	if (not Out or Out ~= "Opening - (Excel|Word)") 
	{
		return ""
	}
	return Out
}

GetValidWinIDs(sWinTitle, sPredicate:="IsValidWinTitleText") {
WinGet FoundIDs, List, %sWinTitle%
IDMap := {}
i := 0
Loop %FoundIDs%
{
FoundID := FoundIDs%A_Index%
if (%sPredicate%("ahk_id " . FoundID))
IDMap[FoundID] := ++i
}
return IDMap
}

; Utility Map Functions

GetNewEntries(sTargetMap, sTestMap) {
Ret := {}
i := 0
For k,v in sTestMap
if not sTargetMap[k]
Ret[k] := ++i
return Ret
}

FirstKey(sMap) {
For i,v in sMap {
return i
}
return ""
}

EntriesToString(sMap, sSep:="`n") {
Out := ""
For i,v in sMap
Out .= i . " := " . v . sSep
return Out
}
;}		

ChromeGet(IP_Port := "127.0.0.1:9222")
; die zu uebernehmende Sitzung muss mit folgender Option gestartet worden sein
; C:\Program Files (x86)\Google\Chrome\Application\chrome.exe --remote-debugging-port=9222
; Quelle: https://www.youtube.com/watch?v=y4GpudF4wTI
; ChromeGet(IP_Port := "127.0.0.1:9515")
{
	driver := ComObjCreate("Selenium.ChromeDriver")
	driver.SetCapability("debuggerAddress",IP_Port)
	driver.Start()
	return driver
}

/*
 _      _    _               __ __      _      _                      _         _                        
| |__  | |_ | |_  _ __  _   / // /__ _ | |__  | | __ ___   ___  _ __ (_) _ __  | |_     ___   _ __  __ _ 
| '_ \ | __|| __|| '_ \(_) / // // _` || '_ \ | |/ // __| / __|| '__|| || '_ \ | __|   / _ \ | '__|/ _` |
| | | || |_ | |_ | |_) |_ / // /| (_| || | | ||   < \__ \| (__ | |   | || |_) || |_  _| (_) || |  | (_| |
|_| |_| \__| \__|| .__/(_)_//_/  \__,_||_| |_||_|\_\|___/ \___||_|   |_|| .__/  \__|(_)\___/ |_|   \__, |
                 |_|                                                    |_|                        |___/ 
DllListExports() - List of Function exports of a DLL  |  http://ahkscript.org/boards/viewtopic.php?t=4563
Author: Suresh Kumar A N ( arian.suresh@gmail.com )   
Quelle https://autohotkey.com/boards/viewtopic.php?f=6&t=4563
_________________________________________________________________________________________________________
*/

DllListExports( DLL, Hdr := 0 ) {   ;   By SKAN,  http://goo.gl/DsMqa6 ,  CD:26/Aug/2010 | MD:14/Sep/2014         

Local LOADED_IMAGE, nSize := VarSetCapacity( LOADED_IMAGE, 84, 0 ), pMappedAddress, pFileHeader
    , pIMGDIR_EN_EXP, IMAGE_DIRECTORY_ENTRY_EXPORT := 0, RVA, VA, LIST := ""  
    , hModule := DllCall( "LoadLibrary", "Str","ImageHlp.dll", "Ptr" ) 

  If ! DllCall( "ImageHlp\MapAndLoad", "AStr",DLL, "Int",0, "Ptr",&LOADED_IMAGE, "Int",True, "Int",True )
    Return                

  pMappedAddress := NumGet( LOADED_IMAGE, ( A_PtrSize = 4 ) ?  8 : 16 )
  pFileHeader    := NumGet( LOADED_IMAGE, ( A_PtrSize = 4 ) ? 12 : 24 )
 
  pIMGDIR_EN_EXP := DllCall( "ImageHlp\ImageDirectoryEntryToData", "Ptr",pMappedAddress 
                           , "Int",False, "UShort",IMAGE_DIRECTORY_ENTRY_EXPORT, "PtrP",nSize, "Ptr" )

  VA  := DllCall( "ImageHlp\ImageRvaToVa", "Ptr",pFileHeader, "Ptr",pMappedAddress, "UInt"
, RVA := NumGet( pIMGDIR_EN_EXP + 12 ), "Ptr",0, "Ptr" )

  If ( VA ) {
     VarSetCapacity( LIST, nSize, 0 )
     Loop % NumGet( pIMGDIR_EN_EXP + 24, "UInt" ) + 1
        LIST .= StrGet( Va + StrLen( LIST ), "" ) "`n"
             ,  ( Hdr = 0 and A_Index = 1 and ( Va := Va + StrLen( LIST ) ) ? LIST := "" : "" )  
  }
    
  DllCall( "ImageHlp\UnMapAndLoad", "Ptr",&LOADED_IMAGE ),   DllCall( "FreeLibrary", "Ptr",hModule )

Return RTrim( List, "`n" )
}
; - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

ExtGetAppPath(vExt)
{ ; siehe https://autohotkey.com/boards/viewtopic.php?f=5&t=38777&p=187812#p187812
	if (substr(vExt,1,1)<>".")
		vExt:="." vExt
; vExt := ".jpeg"
DllCall("shlwapi\AssocQueryString", Int,0, Int,2, Str,vExt, Ptr,0, Ptr,0, UIntP,vChars)
VarSetCapacity(vPath, vChars << !!A_IsUnicode, 0)
DllCall("shlwapi\AssocQueryString", Int,0, Int,2, Str,vExt, Ptr,0, Str,vPath, UIntP,vChars)
; MsgBox, % vPath
return vPath
}

QuelltextObjektZeilen2Edit5:	;{	
Edit2=file://%A_ScriptFullPath% Nr_Row? `%SuchStringFuerObjektAnzeige`%
gosub Edit2Festigen
return
Los:
; Edit5:= LiveSuchStringAuswertung("File://C:\temp\test.txt`vIn_Row? tree,tc`vNr_Inh? Alexander")
; Edit5:= LiveSuchStringAuswertung("FilP://C:\ProgramData\Zack\WuCont\Haupt\*Hug*,DFR`vIn_Inh? ")	; enspricht Hug im HauptContainer
; Edit5:= LiveSuchStringAuswertung("FilP://C:\ProgramData\Zack\WuCont\Haupt\*gerd*,FR`vIn_Inh? ")	; enspricht gerd im HauptContainer
; Edit5:= LiveSuchStringAuswertung("FilP://C:\ProgramData\Zack\WuCont\Haupt\*gerd*,FR`tIn_Inh? ")	; 
; Edit5:= LiveSuchStringAuswertung("FilP://C:\ProgramData\Zack\WuCont\Haupt\**,FR`vIn_Inh? gerd")	; 
;  Edit5:= LiveSuchStringAuswertung("FilP://C:\ProgramData\Zack\WuCont\Haupt\!Fav\*gerd*,F")		; 
; Edit5:= LiveSuchStringAuswertung("FilP://C:\ProgramData\Zack\WuCont\Haupt\!Fav\*gerd*,F`vIn_Inh? ")	; enspricht gerd im HauptContainer Favoriten
; Edit5:= LiveSuchStringAuswertung("FilP://C:\ProgramData\Zack\WuCont\Haupt\164_J˸►°\*gerd*,F`vIn_Inh? ")	; enspricht gerd im HauptContainer Favoriten
;  Edit5:= LiveSuchStringAuswertung("FilP://C:\ProgramData\Zack\WuCont\Haupt\!Fav\*gerd*,F`tIn_Inh? ")	; 
; Edit5:= LiveSuchStringAuswertung("FilP://C:\ProgramData\Zack\WuCont\Haupt\!Fav\*gerd*,F`vFilP://C:\ProgramData\Zack\WuCont\Haupt\164_J˸►°\*gerd*,F`vIn_Inh? ")	; entspricht der Vereinigung der 2Caches in Haupt
; Cont://ContainerName	-1,-3 		; alle auser den Startpfaden
; Cont://ContainerName	2,5			; nur
; Edit5:= LiveSuchStringAuswertung(Cont2FilP("Cont://Haupt	1,3,2","rd b"))
; Edit5:= LiveSuchStringAuswertung(Cont2FilP("Cont://Start Menu\ProgExt",".jpg"))			; fuer oeffnen mit geeignet
Edit5:= LiveSuchStringAuswertung("Cont://Start Menu\ProgExt	.jpg")			; fuer oeffnen mit geeignet
; C:\ProgramData\Zack\WuCont\Start Menu\ProgExt
gosub Edit5Festigen
return
;}	

Cont2FilP(ContSuchString,DieseSuche="")
{
	global WurzelContainer,ContainerKenner
	StringSplit,1ContainerName2StartPfade,ContSuchString,%A_Tab%
	ContainerPfad:=WurzelContainer "\" SubStr(1ContainerName2StartPfade1,8)
	FilpContainerPfad=FilP://%ContainerPfad%
	Pattern=\*%DieseSuche%*
	if(1ContainerName2StartPfade2="")
		return FilpContainerPfad . Pattern . ",FR" ; . "`vIn_Inh? "
	else
	{
		; StringSplit,Stapf,1ContainerName2StartPfade2
		Loop, Files, %ContainerPfad%\*,D					; % Stapf0
		{
			if A_Index in %1ContainerName2StartPfade2%
				rueck .= FilpContainerPfad "\" A_LoopFileName . Pattern . ",F`v"
		}
;		StringTrimRight,rueck,rueck,1
		return rueck  . "In_Inh? "
	}
}
SuchassistentLiveSucheQuelle:
gosub GetMouseOverInfos
if(InStr(Edit2,"Help_Quell.txt"))
{
	; gosub LiveSuchAssistentAnzeigeVar
	BehalteVonLiveSucheAufbauString:=StrSplit(Edit8,";",A_Tab)
	if(BehalteVonLiveSucheAufbauString.1=".")
		LiveSucheAufbauString:=
	else
		LiveSucheAufbauString.=BehalteVonLiveSucheAufbauString.1
	if(instr(LiveSucheAufbauString,"<LiveSucheAufbauString>") and StrLen(LiveSucheAufbauString)>25 )
		StringTrimLeft,LiveSucheAufbauString,LiveSucheAufbauString,23
}
else if (InStr(Edit2,ProtokollKenner))
	LiveSucheAufbauString:=Edit2
Edit2:=HelpQuellKenner
gosub Edit2Festigen
return

LiveSuchStringAuswertung(LiveSuchString)
{
	global ProtokollKenner,InRowKenner,NrRowKenner,InInhaltKenner,ContainerKenner,ExternalToolTipPath,FilePatternKenner,FileKenner,ClipKenner,HwndTextKenner,IeExistKenner,IeExistKennerLen,IeEx,Neutr_Ca,Neutr_US,Neutr_LM
	static WarnungAbStrLen:=500000
; ööööööööööööööööööööööööööööööööööö
	; NachFilterListe=%InRowKenner%,%NrRowKenner%,%InInhaltKenner%
	StringReplace,LiveSuchString,LiveSuchString,%Neutr_US%,,All
	StringReplace,LiveSuchString,LiveSuchString,%Neutr_LM%,,All
	StringReplace,LiveSuchString,LiveSuchString,%Neutr_Ca%,,All

	; Negiert:=GetMinusPosses(LiveSuchString)
	; LiveSuchStringOrg:=LiveSuchString
	; LiveSuchString:=Negiert.VergleichsString
	StringReplace,LiveSuchString,LiveSuchString,`v,,All
	StringSplit,KombiBefehl,LiveSuchString,
	Loop, % KombiBefehl0
	{
		index:=A_Index
		; if(Negiert[A_Index])
		; 	vTabMinus:="-"
		; else
		;	vTabMinus:="`v"
		; if(Negiert[A_Index+1])
		; 	vTabMinus2:="-"
		; else
		;	vTabMinus2:="`v"
		if (InStr(KombiBefehl%A_Index%,ContainerKenner)) 
		{
			StringSplit,1ContSuchString2DieseSuche,KombiBefehl%index%,%A_Tab%
			gesLiveSuchString.=Cont2FilP(1ContSuchString2DieseSuche1,1ContSuchString2DieseSuche2)  . "`v" ; . vTabMinus2
		}
		; else if KombiBefehl%A_Index% contains %FilePatternKenner%,%FileKenner%,%ClipKenner%    ; ,%HTTPSKenner%,%HTTPKenner%
			; gesLiveSuchString.=   KombiBefehl%A_Index% ; . vTabMinus2
		else
			gesLiveSuchString.=   KombiBefehl%A_Index% . "`v"
	}
	
	if(SubStr(gesLiveSuchString,0)="`v")
		StringTrimRight,gesLiveSuchString,gesLiveSuchString,1
	LiveSuchString:=gesLiveSuchString
	; MsgBox %LiveSuchString%
	If FehlerSuche
		RunOtherAhkScriptOrExe(ExternalToolTipPath,LiveSuchString)
	
	; Negiert:=GetMinusPosses(LiveSuchString)
	; LiveSuchStringOrg:=LiveSuchString
	; LiveSuchString:=Negiert.VergleichsString

	StringSplit,KombiBefehl,LiveSuchString,`v
	Loop, % KombiBefehl0
	{
		index:=A_Index
		StringSplit,Aufgabe,KombiBefehl%index%,%A_Tab%
		BefehlFolgt:=false
		if(KombiBefehl0 > index)
			BefehlFolgt:=true
		ges := LiveSuchUnterAuswertung(ges,KombiBefehl%index%,BefehlFolgt) ; ,Negiert[index])
		; MsgBox %ges%
	}
	if (SubStr(ges,1,2)="`r`n")
		StringTrimLeft,ges,ges,2
	
	if((gesLen:=StrLen(ges)) > WarnungAbStrLen)
	{
		RunOtherAhkScriptOrExe(ExternalToolTipPath,gesLen " = StrLen(ges) > " WarnungAbStrLen "`n" SubStr(ges,1,26) "...")
		if (WarnungAbStrLen<1000000000)
			WarnungAbStrLen:=WarnungAbStrLen*4
	}
	else
	{
		if (WarnungAbStrLen>400000)
			WarnungAbStrLen:=WarnungAbStrLen/1.1

	}
	return ges
}
LiveSuchUnterAuswertung(ges,KombiBefehl,BefehlFolgt) ; ,Negiert:=false)
{
	global ProtokollKenner,ProtokollKennerLen,ClipKenner,FilePatternKenner,FileKenner,NrRowKenner,InInhaltKenner,InRowKenner,NrInhaltKenner,ContainerKenner,InNameKenner,2ZeilenInhaltKenner,HwndTextKenner,ControlTextKenner,ControlTextKennerLen,WinTitleKenner,WinTitleKennerLen,ControlKenner,ControlKennerLen,LoopKenner,LoopKennerLen,SortKenner,SortKennerLen,Edit2,Edit3,Edit5,Edit6,Edit8,ExplorerSelectedKenner,ExplorerSelectedKennerLen,WinTextKenner,WinTextKennerLen,SucheAbgebrochen,AllesAbbrechen,2HtmlKenner,2HtmlKennerLen,HtmlListe,DieserHtmlTitel,AlleInfosKenner,AlleInfosKennerLen,VorDotOverDot1,IeExistKenner,IeExistKennerLen,IeEx,Edit10,StartUrlDefault,BestehendeUrl,WinMgmtsKenner,WinMgmtsKennerLen,MirrorEdit5Kenner,MirrorEdit5KennerLen,MirrorEdit8Kenner,MirrorEdit8KennerLen,WitchWindowDefKenner,WitchWindowDefKennerLen,WitchControlDefKenner,WitchControlDefKennerLen,HtmlPathesOutKenner,HtmlPathesOutKennerLen,HtmlPathesBilderuebersichtKenner,HtmlDiaShowKenner,HtmlDiaShowKennerLen,HtmlPathesBilderuebersichtKennerLen,EDit5ErsetzHtml,Edit8HtmlErsetzen,AnE5E8HgF,ExternalToolTipPath,GuiWinHwnd,HelpQuellKennerLen,HelpKennerLen,HelpZuKennerLen,HelpQuellKenner,HelpKenner,HelpZuKenner,HTTPSKennerLen,HTTPSKenner,HTTPKennerLen,HTTPKenner,InInhaltQuelleKenner,InInhaltKennerNotShowPath,MacroAufuehrenKenner,NrRexKenner,WitchWindowDefKenner, InInhaltQuelleKennerLen,InInhaltKennerNotShowPathLen,MacroAufuehrenKennerLen,NrRexKennerLen,WitchWindowDefKennerLen,OnEventKenner,OnEventKennerLen,LiveSucheAufbauString,ClipE5WriteKenner,ClipE5WriteKennerLen,FileE5WriteKenner,FileE5WriteKennerLen,WinAnWinKenner,WinOverWinKEnner,WinAnWinKennerLen,WinOverWinKEnnerLenOldDelNewKenner,OldDelNewKennerLen,IeBildExtList,Help_Quell_Inhalt,AllExplorerSelections,AllExplorerFileSelectionsAnz,AllExplorerDirSelectionsAnz,DieseExplorerSeletions,DieseExplorerFileSeletionsAnz,DieseExplorerDirSeletionsAnz,DpiKorrektur,DieseExplorerDirPicAnz,ExSelRec

	static LastGesTickCount:=0
	; StringReplace,KombiBefehl,KombiBefehl,¯,,All
	if VorDotOverDot1 is Integer
	{
		; SoundBeep
		Edit6Mal3:=Edit6 * 3 + VorDotOverDot1
		; ToolTip % Edit6Mal3 "	" Edit6 "	" VorDotOverDot1
	}
	else
		Edit6Mal3:=Edit6 * 3
	StringSplit,Aufgabe,KombiBefehl,%A_Tab%
	ProtokollKennerPos:=InStr(Aufgabe1,ProtokollKenner)
	if ProtokollKennerPos
	DieserKennerInhalt:=SubStr(Aufgabe1,ProtokollKennerPos+ProtokollKennerLen)
	FragezeichenPos:=InStr(Aufgabe1,"?")
	if FragezeichenPos
		DieserKennerInhalt:=SubStr(Aufgabe1,FragezeichenPos+2)
	if ProtokollKennerPos
		DieserKenner:=SubStr(Aufgabe1,1,ProtokollKennerPos + ProtokollKennerLen-1)
	else if FragezeichenPos
		DieserKenner:=SubStr(Aufgabe1,1,FragezeichenPos)
	if (DieserKenner=ClipKenner)
		return Clipboard
	if (DieserKenner=IeExistKenner)		; IeEx://aNr_Row? 
	{		; IeEx://aNr_Row? 2_HTML?
		if(Not WinExist("ahk_exe iexplore.exe")) 	; IeEx://in_Row? ¬<html`n¬<head`n¬<body`n¬<script`n¬<style
		{
			if(IsObject(IeEx))
				IeEx:=""
			IeEx := new wBr("IE_IeEx")
			IeEx.visible()
			Sleep 1000
			if(BestehendeUrl="")
			{
				IfExist %A_Temp%\BestehendeUrl.txt
					FileRead,BestehendeUrl,%A_Temp%\BestehendeUrl.txt
				if(BestehendeUrl="")
					BestehendeUrl:=StartUrlDefault
			}
			IeEx.Navigate(BestehendeUrl)
			Sleep 10
		}
		else
		{
			try
			{
				BestehendeUrl:=IeEx.getUrl()
			}
			catch
				IeEx:=""
			if(BestehendeUrl="")	
			{
				IeEx:=""
				WinActivate,ahk_exe iexplore.exe
				WinWaitActive,ahk_exe iexplore.exe,,2
				Sleep 100
				IeEx := new wBr("IE_")
			}
		}
		BestehendeUrl:=IeEx.getUrl()
		FileDelete,%A_Temp%\BestehendeUrl.txt
		FileAppend,%BestehendeUrl%,%A_Temp%\BestehendeUrl.txt
		Edit10Anzeige:="<" DieserKennerInhalt ">	" BestehendeUrl
		Edit10:=Edit10Anzeige
		gosub Edit10Festigen
		
	;	test:= IeEx.GetElementsHtmlByTagName(DieserKennerInhalt,,0)
	;	test:= IeEx.GetElementsHtmlByTagName(DieserKennerInhalt,,0)
		if BefehlFolgt
			ElementsHtmlByTagName := IeEx.GetElementsHtmlByTagName(DieserKennerInhalt)
		else
			ElementsHtmlByTagName := IeEx.GetElementsHtmlByTagName(DieserKennerInhalt,,,Edit6Mal3)
		if (SubStr(ElementsHtmlByTagName,-1)="`r`n")
			SucheAbgebrochen:=true
		return ElementsHtmlByTagName
	}
	else if (DieserKenner=HelpQuellKenner) {
		global A_AppData_100,A_AppDataCommon_100,A_MyDocuments_100,A_ProgramFiles_100,A_Programs_100,A_ProgramsCommon_100,A_Temp_100,A_WinDir_100,A_WorkingDir_100,A_SystemDrive_100,A_HomeDir_100, MouseOverWinClassNN, MouseOverControlClassNN, MouseOverWinHwnd, MouseOverControlHwnd,MouseOverControlText,MouseOverWinTitle
	; MsgBox % MouseOverControlText "," MouseOverWinTitle "," MouseOverWinHwnd "," MouseOverControlHwnd "," MouseOverWinClassNN "," MouseOverControlClassNN
	;	if(SubStr(LiveSucheAufbauString,0)="`n")
	;		StringTrimRight,LiveSucheAufbauString,LiveSucheAufbauString,1
	;	if(SubStr(LiveSucheAufbauString,0)="`r")
	;		StringTrimRight,LiveSucheAufbauString,LiveSucheAufbauString,1
		if (LiveSucheAufbauString="")
			LiveSucheAufbauString:="<LiveSucheAufbauString>"
		AllExplorerSelections:=GetSelectedExplorerItems(,AllExplorerFileSelectionsAnz,AllExplorerDirSelectionsAnz,DieseExplorerDirPicAnz)
		gosub LiveSuchAssistentAnzeigeVar
		FileDelete, % A_ScriptDir "\Hilfe\Help_Quell.txt"
		FileAppend,%Help_Quell_Inhalt%,% A_ScriptDir "\Hilfe\Help_Quell.txt",Utf-16
		Edit2:="file://" A_ScriptDir "\Hilfe\Help_Quell.txt`vIn_Row? Ø¯⁞¯Ø"
		gosub Edit2Festigen
		ges:=LiveSuchStringAuswertung(Edit2)
		return ges
	}
	else if (DieserKenner=HelpZuKenner) {	; Hilfe zum naechsten Kenner links 
	}
	else if (DieserKenner=HelpKenner) {
		RunOtherAhkScriptOrExe(ExternalToolTipPath,"reseviert	bitte stattdessen " HelpQuellKenner " oder "  HelpZuKenner " verwenden")
	}
	else if (DieserKenner=FileKenner)
	{
		FileRead,FileInhalt,%DieserKennerInhalt%
		FileGetSize,Size,%DieserKennerInhalt%
		if(StrLen(A_Space . FileInhalt)*4 < Size)
		{
			; SoundBeep
			FileInhalt:= ReadTextFromBinary(DieserKennerInhalt)
		}
		return FileInhalt
	}
	else if (DieserKenner=ExplorerSelectedKenner)	; ExSel://`tWTitle? ahk_class CabinetWClass
	{										; ExSel://`tWTitle? ahk_class CabinetWClass`vIn_Inh?
		DieserControlInhaltBefuellt:=false
		DiesesWinHwndBefuellt:=false
		Loop, % Aufgabe0
		{
			if(Not DieserControlInhaltBefuellt AND SubStr(Aufgabe%A_Index%,1,ControlKennerLen)=ControlKenner){
				ControlInhalt:=SubStr(Aufgabe%A_Index%,ControlKennerLen+2)
				if(ControlInhalt<>"")
					DieserControlInhaltBefuellt:=true
			}
			else if Not DiesesWinHwndBefuellt{
				DiesesWinHwnd:=GetWinHwndVonLiveSucheTeilstring(Aufgabe%A_Index%,,DieserControlKennerInhalt)
				if (DieserControlKennerInhalt<>"")
					DieserControlInhaltBefuellt:=true
				DiesesWinHwndBefuellt:=true
			}

		}

		DieseExplorerSeletions:=GetSelectedExplorerItems(DiesesWinHwnd,DieseExplorerFileSeletionsAnz,DieseExplorerDirSeletionsAnz,DieseExplorerDirPicAnz)
		return DieseExplorerSeletions  
	}
	else if (DieserKenner=ExplorerSelectedKenner_Deaktiviert)	; ExSel://`tWTitle? ahk_class CabinetWClass
	{										; ExSel://`tWTitle? ahk_class CabinetWClass`vIn_Inh?
		Loop, % Aufgabe0				; ExSel://`tWTitle? ahk_class CabinetWClass`tWinText? C:\temp`vIn_Inh?
		{							; ExSel://`vAllInfo? 2_HTML?`vSort? ViaTimer_-Edit2
			if(SubStr(Aufgabe%A_Index%,1,ExplorerSelectedKennerLen)=ExplorerSelectedKenner)
				StringTrimLeft,Aufgabe%A_Index%,Aufgabe%A_Index%,ExplorerSelectedKennerLen
			
			if(InStr(SubStr(Aufgabe%A_Index%,1,WitchControlDefKennerLen+1),WitchControlDefKenner)){
				StringReplace, Aufgabe%A_Index%, Aufgabe%A_Index%,% WitchControlDefKenner
				Def:=StrSplit(Aufgabe%A_Index%,",")
				WinGet,DiesesWinHwnd,ID,% trim(Def.2),% Def.3,% Def.4,% Def.5
				IfWinExist,ahk_id %DiesesWinHwnd%
					break
			}
			else if(InStr(SubStr(Aufgabe%A_Index%,1,WitchWindowDefKennerLen+1),WitchWindowDefKenner)){
				StringReplace, Aufgabe%A_Index%, Aufgabe%A_Index%,% WitchWindowDefKenner
				Def:=StrSplit(Aufgabe%A_Index%,"`,")
				WinGet,DiesesWinHwnd,ID,% Def.1,% Def.2,% Def.3,% Def.4
				IfWinExist,ahk_id %DiesesWinHwnd%
					break
			}
			else if(SubStr(Aufgabe%A_Index%,1,WinTitleKennerLen)=WinTitleKenner)
				WinTitleInhalt:=SubStr(Aufgabe%A_Index%,WinTitleKennerLen+2)
			else if(SubStr(Aufgabe%A_Index%,1,WinTextKennerLen)=WinTextKenner)
				WinTextInhalt:=SubStr(Aufgabe%A_Index%,WinTextKennerLen+2)
		}
		IfWinNotExist,ahk_id %DiesesWinHwnd%
		{
			if(WinTitleInhalt="" and WinTextInhalt="") ; ExSel://`vin_inh?
				WinTitleInhalt:="ahk_class CabinetWClass"
			if(WinTextInhalt="") ; ExSel://`vin_inh?
				WinGet,DiesesWinHwnd,ID,%WinTitleInhalt%
			else
				WinGet,DiesesWinHwnd,ID,%WinTitleInhalt%,%WinTextInhalt%
			; MsgBox % DiesesWinHwnd "	" WinTitleInhalt "	" WinTextInhalt
		}
		DieseExplorerSeletions:=GetSelectedExplorerItems(DiesesWinHwnd,DieseExplorerFileSeletionsAnz,DieseExplorerDirSeletionsAnz,DieseExplorerDirPicAnz)
		return DieseExplorerSeletions        
	}	; WitchControlDefKenner:="WConDef?"                                      CoTe://             WConDef?
	
/*
	else if (SubStr(KombiBefehl,1,ControlTextKennerLen+WitchControlDefKennerLen)=(ControlTextKenner . WitchControlDefKenner) OR SubStr(KombiBefehl,1,ControlTextKennerLen+1+WitchControlDefKennerLen)=(ControlTextKenner "`t" WitchControlDefKenner))	; CoTe://`tWTitle? ahk_class SciTEWindow`tContro? Scintilla1`vNr_Row?
	{		; CoTe://	WTitle? ahk_class SciTEWindow	Contro? Scintilla1Nr_Row? 
	;	MsgBox %DieserKennerInhalt%
; WitchWindowDefKenner:="WWinDef?"		; WWinDef? Fenstertitel,Fenstertext,Titelausnahme,Textausnahme
; WitchWindowDefKennerLen:=StrLen(WitchWindowDefKenner)
; WitchControlDefKenner:="WConDef?"		; WConDef? Control,Fenstertitel,Fenstertext,Titelausnahme,Textausnahme
; WitchControlDefKennerLen:=StrLen(WitchControlDefKenner)
; Cote://WConDef? Control,Fenstertitel,Fenstertext,Titelausnahme,Textausnahme
		If (DieserKennerInhalt="")
			DieserKennerInhalt:=SubStr(KombiBefehl,2+ControlTextKennerLen+1+WitchControlDefKennerLen)
		Def:=
		Def:=StrSplit(DieserKennerInhalt,"`,")
		Loop % Def.MaxIndex()
			Def[A_Index]:=GlobalDeref(Def[A_Index])
		if(Def.1="SysListView321")
			ControlGet, DieserControlInhalt, List, 		, SysListView321,% Def.2,% Def.3,% Def.4,% Def.5
		else
			ControlGetText, DieserControlInhalt ,% Def.1,% Def.2,% Def.3,% Def.4,% Def.5
		return DieserControlInhalt
	}	
	else if (DieserKenner=ControlTextKenner)	; CoTe://`tWTitle? ahk_class SciTEWindow`tContro? Scintilla1`vNr_Row?
	{		; CoTe://	WTitle? ahk_class SciTEWindow	Contro? Scintilla1Nr_Row? 
		Loop, % Aufgabe0
		{	; CoTe://`tWTitle? Variables`tContro? SysListView321`vNr_Row? 			; funced ned mit VariablDedebug.ahk
			if(SubStr(Aufgabe%A_Index%,1,WinTitleKennerLen)=WinTitleKenner)
				WinTitleInhalt:=SubStr(Aufgabe%A_Index%,WinTitleKennerLen+2)
			else if(SubStr(Aufgabe%A_Index%,1,ControlKennerLen)=ControlKenner)
				ControlInhalt:=SubStr(Aufgabe%A_Index%,ControlKennerLen+2)
		}	; bis hiersiht alles OK aus aber DieserControlInhalt wird nicht eingelesen
		; MsgBox % ">" ControlInhalt "<	>" WinTitleInhalt "<"
		if(ControlInhalt="SysListView321")
			ControlGet, DieserControlInhalt, List, 		, SysListView321,%WinTitleInhalt%
		else
			ControlGetText,DieserControlInhalt,% ControlInhalt,% WinTitleInhalt
		return DieserControlInhalt
	}
	*/
	
	else if (DieserKenner=ControlTextKenner){	; CoTe://...					; CoTe://`tWTitle? ahk_class SciTEWindow`tContro? Scintilla1`vNr_Row?
		DieserControlInhaltBefuellt:=false
		DiesesWinHwndBefuellt:=false
		Loop, % Aufgabe0
		{
			if(Not DieserControlInhaltBefuellt AND SubStr(Aufgabe%A_Index%,1,ControlKennerLen)=ControlKenner){
				ControlInhalt:=SubStr(Aufgabe%A_Index%,ControlKennerLen+2)
				if(ControlInhalt<>"")
					DieserControlInhaltBefuellt:=true
			}
			else if Not DiesesWinHwndBefuellt{
				DiesesWinHwnd:=GetWinHwndVonLiveSucheTeilstring(Aufgabe%A_Index%,,DieserControlKennerInhalt)
				if (DieserControlKennerInhalt<>"")
					DieserControlInhaltBefuellt:=true
				DiesesWinHwndBefuellt:=true
			}
			if DiesesWinHwndBefuellt AND DieserControlInhaltBefuellt
			{
				if(DieserControlKennerInhalt="SysListView321")
				{
					ControlGet, DieserControlInhalt, List, 		,  SysListView321,ahk_id %DiesesWinHwnd%
					if ErrorLevel
					{
						DiesesWinHwnd:=GetParent(DiesesWinHwnd)
						ControlGet, DieserControlInhalt, List, 		,  SysListView321,ahk_id %DiesesWinHwnd%
					}
					return DieserControlInhalt
				}

				break
			}
		}
		if(DieserControlKennerInhalt="SysListView321")
			ControlGet, DieserControlKennerInhalt, List, 		, SysListView321,ahk_id %DiesesWinHwnd%
		else
		{
			ControlGetText,DieserControlInhalt,,ahk_id %DiesesWinHwnd%
		}
		return DieserControlInhalt

	}
	else if (DieserKenner=HwndTextKenner)
	{

		if  (DieserKennerInhalt<>"")
		{
			Loops:=1
		}
		else
		{
			Loops:=16777215
		}
		loop % Loops
		{
			if (A_Index<>1)
				DieserKennerInhalt:=A_Index
			ParentId:=GetParent(DieserKennerInhalt)
			ControlGet, DieserControlInhalt, List, 		, ,ahk_id %DieserKennerInhalt%
			ControlGetPos , X, Y, Breite, Hoehe,, ahk_id %DieserKennerInhalt%
			StatusBarGetText, StatusBarText, , ahk_id %DieserKennerInhalt%
			WinGetClass,DieseWinClass,ahk_id %DieserKennerInhalt%
			WinGetTitle,DieserWinTitle,ahk_id %DieserKennerInhalt%
			WinGet, DieserProcessPath , ProcessPath, ahk_id %DieserKennerInhalt%
			if(DieserControlInhalt="")
				ControlGetText, DieserControlInhalt ,,ahk_id %DieserKennerInhalt%
			if (DieserControlInhalt<>"" or DieseWinClass<>"" or DieserWinTitle<>"" or DieserProcessPath<>"")
			{
				AZ:=ZaehleZeilen(DieserControlInhalt)
				ControlInhalt.="(" ParentId ")" DieserKennerInhalt "[" AZ "] ----> " DieseWinClass A_Tab DieserWinTitle A_Tab DieserProcessPath A_Tab StatusBarText A_Tab X A_Space  Y A_Space Breite A_Space Hoehe "`r`n" DieserControlInhalt  "`r`n"
			}
		} 
	return ControlInhalt
	}	
	else if (DieserKenner=FilePatternKenner)
	{
		LastKommaPos:=InStr(DieserKennerInhalt,"`,",0,0)
		FilePattern:=SubStr(DieserKennerInhalt,1,LastKommaPos-1)
		LoopOptionen:=SubStr(DieserKennerInhalt,LastKommaPos+1)
		SplitPath,FilePattern,,FilePatternDir ; ,,FilePatternDirName
		SplitPath,FilePatternDir,,,,FilePatternDirName
		StringSplit,ZwischenSternen,FilePattern,*
		if (ZeileEnthaelt(FilePatternDirName,ZwischenSternen2) AND ZeileEnthaelt(FilePatternDir,ZwischenSternen2))
		{
			ges .= FilePatternDir "`r`n"
		}
		Loop, Files, % FilePattern, % LoopOptionen
		{
			ges .= A_LoopFileLongPath "`r`n"
		}
		; StringTrimRight,ges,ges,2
		return ges
	}
	else if (DieserKenner=WinMgmtsKenner)	; WiMg://
	{
	WinGet,HwndList,List
	Loop % HwndList{
		; MsgBox % HwndList
		WinGet pid, PID, % "ahk_id " HwndList%A_Index%
		WinGetTitle,WinTTitle, % "ahk_id " HwndList%A_Index%
		; Ermittelt das WMI-Service-Objekt.
		wmi := ComObjGet("winmgmts:")
		; Führt eine Abfrage zur Ermittlung von passenden Prozessen aus.
		queryEnum := wmi.ExecQuery(""
			. "Select * from Win32_Process where ProcessId=" . pid)
			._NewEnum()
		; Ermittelt den ersten passenden Prozess.
		if queryEnum[process]
			; MsgBox 0, Befehlszeile, % process.CommandLine
			ges.=process.ProcessId "	" process.Status "	" round(process.WorkingSetSize/1024)  "	" WinTTitle "	" process.Name  "	" process.CommandLine "`r`n"	;  "	" process.Caption "	" process.Description 
		; else
			; MsgBox Prozess nicht gefunden!
		; Alle globalen Objekte freigeben (nicht notwendig, wenn lokale Variablen verwendet werden).
		wmi := queryEnum := process := ""
}
	; MsgBox % ges
	return ges
	; Win32_Process: http://msdn.microsoft.com/en-us/library/aa394372.aspx
	}
	else if(DieserKenner=InRowKenner)
	{
		StringReplace,DieserKennerInhalt,DieserKennerInhalt,TabbaT,%A_Tab%,All
		Loop,Parse,ges,`n,`r
		{
			if (ZeileEnthaelt(A_LoopField,DieserKennerInhalt)) ; -Negiert)
				DiesesGes .= A_LoopField "`r`n"
		}
;		StringTrimRight,ges,ges,2
		return DiesesGes
	}
	else if(DieserKenner=InNameKenner)
	{
		StringReplace,DieserKennerInhalt,DieserKennerInhalt,TabbaT,%A_Tab%,All
		Loop,Parse,ges,`n,`r
		{
			SplitPath,A_LoopField,,,,LoopFieldNameNoExt
			if(LoopFieldNameNoExt<>"")
			{
				if (ZeileEnthaelt(LoopFieldNameNoExt,DieserKennerInhalt)) ; -Negiert)
					DiesesGes .= A_LoopField "`r`n"
			}
			else
			{
				if (ZeileEnthaelt(A_LoopField,DieserKennerInhalt)) ; -Negiert)
					DiesesGes .= A_LoopField "`r`n"
			}
		}
;		StringTrimRight,ges,ges,2
		return DiesesGes
	}
	else if(DieserKenner=AlleInfosKenner)
	{			; ExSel://`vAllInfo? 2_HTML?`vSort? ViaTimer_-Edit2
		ExSelRec:=true
		If(SubStr(DieserKennerInhalt,1.12)="NotRecceRtoN")
		{
			ExSelRec:=false
			StringReplace,DieserKennerInhalt,DieserKennerInhalt,NotRecceRtoN
		}
		StringReplace,DieserKennerInhalt,DieserKennerInhalt,TabbaT,%A_Tab%,All
		Suchbeginn:=A_TickCount
		DiesesGes:=
		Loop,Parse,ges,`n,`r
		{
			; if (ZeileEnthaelt(A_LoopField,DieserKennerInhalt))
			Loopfield:=A_LoopField
			If(Trim(A_LoopField)<>"")
			{
				if(IsDir(A_LoopField))
				{

					if (ZeileEnthaelt(A_LoopField,DieserKennerInhalt))
					{
						StringUpper,LoopFieldUpper,A_LoopField
						DiesesGes .= LoopFieldUpper "`r`n"
					}
					DisplayName:=GetDisplayName(A_LoopField)
					if(InStr(A_LoopField,DisplayName))
						DisplayName:=
					else
					{
						SplitPath,A_LoopField,,LoopDir
						DisplayName:=LoopDir "\" DisplayName
					}
					if ( DisplayName<>"" AND   ZeileEnthaelt(DisplayName,DieserKennerInhalt))
					{
						; StringUpper,LoopFieldUpper,DisplayName
						; DiesesGes .= LoopFieldUpper "`r`n"
						DiesesGes .= DisplayName "`r`n"
					}
					if ExSelRec
						ROderLeer:="R"
					else
						ROderLeer:=
					DF:=0
					Loop, Files, % A_LoopField "\**", DF%ROderLeer%
					{
						if (c:=(a:=ZeileEnthaelt(A_LoopFileLongPath,DieserKennerInhalt)))
						{
							DiesesGes .= A_LoopFileLongPath "`r`n"
							++DF
							if(SubStr(A_Index,-2)="000")
								if(A_TickCount - Suchbeginn > 60000)
									SucheAbbrechen:=true
							if(DF>Edit6Mal3 OR AllesAbbrechen OR SucheAbbrechen)
							{
								SucheAbgebrochen:=true
								SucheAbbrechen:=false
								break
							}
						}
					}
					; StringTrimRight,ges,ges,2
					; return DiesesGes

				}
				else
				{	; ist Datei
					if (ZeileEnthaelt(A_LoopField,DieserKennerInhalt))
					{
						StringUpper,LoopFieldUpper,A_LoopField
						DiesesGes .= LoopFieldUpper "`r`n"
					}
					; DisplayName:=GetDisplayName(A_LoopField)
					
					
					DisplayName:=GetDisplayName(A_LoopField)
					if(InStr(A_LoopField,DisplayName))
						DisplayName:=
					else
					{
						SplitPath,A_LoopField,,LoopDir
						DisplayName:=LoopDir "\" DisplayName
					}
					if ( DisplayName<>"" AND   ZeileEnthaelt(DisplayName,DieserKennerInhalt))
					{
						DiesesGes .= DisplayName "`r`n"
					}
					
					; if(DisplayName=A_LoopField)
					; 	DisplayName:=
					oZielpfadInfo:=GetPathInfo(LoopField)
					ZielpfadInfo:="Size=" oZielpfadInfo.1.Size " B     Time=" oZielpfadInfo.1.TimeModi "     Ext=" oZielpfadInfo.1.Ext "     Attrib=" oZielpfadInfo.1.Attrib "               ˅     ˅     ˅     ˅     ˅     ˅     ˅     ˅     ˅     ˅     ˅     ˅     ˅     ˅     ˅     ˅     ˅     ˅     ˅     ˅     ˅     ˅     ˅`r`n"
					ImageProp := GetImageFileInfo(LoopField)
					LinkZiel:=

					if(oZielpfadInfo.1.Ext="lnk")
					{
						FileGetShortcut,% LoopField, LinkZiel
					}
					if(oZielpfadInfo.1.Ext="dll")
					{
						DllList:=DllListExports(LoopField) . "r`n"
						; FileGetShortcut,% LoopField, LinkZiel
					}
	
					If(StrLen(ImageProp)>1)
					{
						; FileInhalt:= ImageProp
					}
					else if(oZielpfadInfo.1.Size < 100000000)
					{
						
						FileRead,FuerFileInhalt,%A_LoopField%
						if(StrLen(A_Space . FuerFileInhalt)*4 < oZielpfadInfo.1.Size)
						{
							; SoundBeep
							FuerFileInhalt:="Binary:	" ReadTextFromBinary(A_LoopField)
						}
					}
					
					DF:=0
					FileInhalt:= "ZeilennelieZ" ZielpfadInfo ImageProp LinkZiel DllList FuerFileInhalt 
;					if(Trim(FileInhalt)<>"")
					{
						Loop,Parse,FileInhalt,`n,`r
						{
; 							if(Trim(A_LoopField)<>"")
							{
								if (c:=(a:=ZeileEnthaelt(A_LoopField,DieserKennerInhalt))) ; -(b:=Negiert))
								{
									++DF
									DiesesGes .= A_LoopField "`r`n"
								}
							}
						}
					}
					--DF
					StringReplace, DiesesGes, DiesesGes, ZeilennelieZ,%DF% Zeilen%A_Space%%A_Space%%A_Space%%A_Space%%A_Space%
				}
			}
		}
;		StringTrimRight,ges,ges,2
		return	DiesesGes
	}
	else if(DieserKenner=InInhaltKenner)
	{
		StringReplace,DieserKennerInhalt,DieserKennerInhalt,TabbaT,%A_Tab%,All
		Suchbeginn:=A_TickCount
		DiesesGes:=
		Loop,Parse,ges,`n,`r
		{
			; if (ZeileEnthaelt(A_LoopField,DieserKennerInhalt))
			Loopfield:=A_LoopField
			If(Trim(A_LoopField)<>"")
			{
				if(IsDir(A_LoopField))
				{

					if (ZeileEnthaelt(A_LoopField,DieserKennerInhalt))
					{
						StringUpper,LoopFieldUpper,A_LoopField
						DiesesGes .= LoopFieldUpper "`r`n"
					}
					DisplayName:=GetDisplayName(A_LoopField)
					if(InStr(A_LoopField,DisplayName))
						DisplayName:=
					else
					{
						SplitPath,A_LoopField,,LoopDir
						DisplayName:=LoopDir "\" DisplayName
					}
					if ( DisplayName<>"" AND   ZeileEnthaelt(DisplayName,DieserKennerInhalt))
					{
						; StringUpper,LoopFieldUpper,DisplayName
						; DiesesGes .= LoopFieldUpper "`r`n"
						DiesesGes .= DisplayName "`r`n"
					}

					DF:=0
					Loop, Files, % A_LoopField "\**", DFR
					{
						if (c:=(a:=ZeileEnthaelt(A_LoopFileLongPath,DieserKennerInhalt)))
						{
							DiesesGes .= A_LoopFileLongPath "`r`n"
							++DF
							if(SubStr(A_Index,-2)="000")
								if(A_TickCount - Suchbeginn > 60000)
									SucheAbbrechen:=true
							if(DF>Edit6Mal3 OR AllesAbbrechen OR SucheAbbrechen)
							{
								SucheAbgebrochen:=true
								SucheAbbrechen:=false
								break
							}
						}
					}
					; StringTrimRight,ges,ges,2
					; return DiesesGes

				}
				else
				{	; ist Datei
					if (ZeileEnthaelt(A_LoopField,DieserKennerInhalt))
					{
						StringUpper,LoopFieldUpper,A_LoopField
						DiesesGes .= LoopFieldUpper "`r`n"
					}
					; DisplayName:=GetDisplayName(A_LoopField)
					
					
					DisplayName:=GetDisplayName(A_LoopField)
					if(InStr(A_LoopField,DisplayName))
						DisplayName:=
					else
					{
						SplitPath,A_LoopField,,LoopDir
						DisplayName:=LoopDir "\" DisplayName
					}
					if ( DisplayName<>"" AND   ZeileEnthaelt(DisplayName,DieserKennerInhalt))
					{
						DiesesGes .= DisplayName "`r`n"
					}
					
					; if(DisplayName=A_LoopField)
					; 	DisplayName:=
					oZielpfadInfo:=GetPathInfo(LoopField)
					; ZielpfadInfo:="Size=" oZielpfadInfo.1.Size " B     Time=" oZielpfadInfo.1.TimeModi "     Ext=" oZielpfadInfo.1.Ext "     Attrib=" oZielpfadInfo.1.Attrib "               ˅     ˅     ˅     ˅     ˅     ˅     ˅     ˅     ˅     ˅     ˅     ˅     ˅     ˅     ˅     ˅     ˅     ˅     ˅     ˅     ˅     ˅     ˅`r`n"
					ImageProp := GetImageFileInfo(LoopField)
					LinkZiel:=

					if(oZielpfadInfo.1.Ext="lnk")
					{
						FileGetShortcut,% LoopField, LinkZiel
					}
					if(oZielpfadInfo.1.Ext="dll")
					{
						DllList:=DllListExports(LoopField) . "r`n"
						; FileGetShortcut,% LoopField, LinkZiel
					}
	
					If(StrLen(ImageProp)>1)
					{
						; FileInhalt:= ImageProp
					}
					else if(oZielpfadInfo.1.Size < 100000000)
					{
						
						FileRead,FuerFileInhalt,%A_LoopField%
						if(StrLen(A_Space . FuerFileInhalt)*4 < oZielpfadInfo.1.Size)
						{
							; SoundBeep
							FuerFileInhalt:="Binary:	" ReadTextFromBinary(A_LoopField)
						}
					}
					
					DF:=0
					FileInhalt:= ZielpfadInfo ImageProp LinkZiel DllList FuerFileInhalt 
;					if(Trim(FileInhalt)<>"")
					{
						Loop,Parse,FileInhalt,`n,`r
						{
; 							if(Trim(A_LoopField)<>"")
							{
								if (c:=(a:=ZeileEnthaelt(A_LoopField,DieserKennerInhalt))) ; -(b:=Negiert))
								{
									++DF
									DiesesGes .= A_LoopField "`r`n"
								}
							}
						}
					}
					--DF
					; StringReplace, DiesesGes, DiesesGes, ZeilennelieZ,%DF% Zeilen%A_Space%%A_Space%%A_Space%%A_Space%%A_Space%
				}
			}
		}
;		StringTrimRight,ges,ges,2
		return	DiesesGes
	}
	else if(DieserKenner=2ZeilenInhaltKenner)
	{
		StringReplace,DieserKennerInhalt,DieserKennerInhalt,TabbaT,%A_Tab%,All
		DiesesGes:=
		Loop,Parse,ges,`n,`r
		{
			; if (ZeileEnthaelt(A_LoopField,DieserKennerInhalt))
			Loopfield:=A_LoopField
			If(Trim(A_LoopField)<>"")
			{
				N:=1
				EndAngabe:=false
				FileRead,FileInhalt,%A_LoopField%
				if(Trim(FileInhalt)<>"")
				{
					Loop,Parse,FileInhalt,`n,`r
					{
						if(Trim(A_LoopField)<>"")
						{
							if (N>2)
							{
								EndAngabe:=true
							 	DiesesGes .=  " . . . . . . . . . . . . . . . . " Loopfield " . . . . . . . . . . . . . . . . `r`n"
							;	DiesesGes .=  "."
							;	continue
								break
							}
							if (c:=(a:=ZeileEnthaelt(A_LoopField,DieserKennerInhalt))) ; -(b:=Negiert))
							{
								++N
								DiesesGes .= A_LoopField "`r`n"
							}
						}
					}
				if (not EndAngabe and N>1)
					DiesesGes .=  "________________" Loopfield "_______________`r`n"

				}
			}
		}
;		StringTrimRight,ges,ges,2
		return DiesesGes
	}
	else if(DieserKenner=InInhaltQuelleKenner)
	{
		StringReplace,DieserKennerInhalt,DieserKennerInhalt,TabbaT,%A_Tab%,All
		DiesesGes:=
		Loop,Parse,ges,`n,`r
		{
			; if (ZeileEnthaelt(A_LoopField,DieserKennerInhalt))
			Loopfield:=A_LoopField
			FileRead,FileInhalt,%A_LoopField%
			Loop,Parse,FileInhalt,`n,`r
			{
				if (ZeileEnthaelt(A_LoopField,DieserKennerInhalt)) ; -Negiert)
					DiesesGes .= A_LoopField "	" Loopfield "`r`n"
			}
		}
;		StringTrimRight,ges,ges,2
		return DiesesGes
	}
	else if(DieserKenner=NrInhaltKenner)
	{
		StringReplace,DieserKennerInhalt,DieserKennerInhalt,TabbaT,%A_Tab%,All
		DiesesGes:=
		Loop,Parse,ges,`n,`r
		{
			; if (ZeileEnthaelt(A_LoopField,DieserKennerInhalt))
			Loopfield:=A_LoopField
			FileRead,FileInhalt,%A_LoopField%
			Loop,Parse,FileInhalt,`n,`r
			{
				FuellAnz:=10-StrLen(A_Index)
				if (ZeileEnthaelt(A_LoopField,DieserKennerInhalt)) ; -Negiert)
					DiesesGes .=  A_Index FuellLeerzeichen%FuellAnz% A_LoopField "	" Loopfield "`r`n"
			}
;			StringTrimRight,ges,ges,2
		}
;		StringTrimRight,ges,ges,2
		return DiesesGes
	}
	else if(DieserKenner=NrRowKenner)
	{
		StringReplace,DieserKennerInhalt,DieserKennerInhalt,TabbaT,%A_Tab%,All
		DiesesGes:=
		Loop,Parse,ges,`n,`r
		{
			FuellAnz:=10-StrLen(A_Index)
			; if(InStr(A_LoopField,ZeileEnthaelt))
			if (ZeileEnthaelt(A_LoopField,DieserKennerInhalt)) ; -Negiert)
			{
					DiesesGes.= A_Index FuellLeerzeichen%FuellAnz%          A_LoopField "`r`n"
			}
		}
;		StringTrimRight,ges,ges,2
		return DiesesGes
	}
	else if(DieserKenner=2HtmlKenner)
	{			; 2_HTML?
		HtmlListe:=""
		if(SubStr(ges,-1)="`r`n")
			StringTrimRight,ges,ges,2
		Edit5:=ges
		gosub Edit5Festigen
		DieserHtmlTitel:=DieserKennerInhalt
		gosub ZeigePfadlisteImBrowser
		; file://C:\Program Files (x86)\ZackZackOrdner\Hilfe\_ZackZackOrdnerHilfe.html2_HTML? 
		return HtmlListe
	}
	else if(DieserKenner=HtmlDiaShowKenner)
	{
		global AnE5
		if (NOT IsObject(AnE5))
		{
			AnE5 := new wbr("IE_AnE5")
			AnE5.Visible(1)
		}
		AnE5.Navigate( A_Temp "\ZzoAnE5.htm")
		if DieserKennerInhalt is NOT Integer
			DieserKennerInhalt:=4500
		AnE5.ScrollView("img",-DieserKennerInhalt)
		gosub SelfMin
		return ges
	}
	else if(DieserKenner=HtmlPathesBilderuebersichtKenner)
	{
		global AnE5,ExSelRec
		; MsgBox >%ges%<
		inde:=0
		if(InStr(DieserKennerInhalt,"Auto") AND (StrLen(DieserKennerInhalt)<=6))
		{
			if(DieseExplorerDirSeletionsAnz<1)
				DieseBildHoehe:=Round((A_ScreenHeight-70*DpiKorrektur)/Sqrt(DieseExplorerFileSeletionsAnz+1))
			else
				if ExSelRec
					DieseBildHoehe:=Round((A_ScreenHeight-130*DpiKorrektur)/Sqrt(DieseExplorerFileSeletionsAnz+1+20*(DieseExplorerDirSeletionsAnz)))
				else
					DieseBildHoehe:=Round((A_ScreenHeight-130*DpiKorrektur)/Sqrt(DieseExplorerFileSeletionsAnz +DieseExplorerDirPicAnz))
		}
		else
		{
			if DieserKennerInhalt is not Integer
				DieseBildHoehe:=80
			else
				DieseBildHoehe:=DieserKennerInhalt
		}
		Loop,Parse,ges,`n,`r
		{
			DiesesEinzel:=BildUebersicht2Html(A_LoopField,DieseBildHoehe)
			if(DiesesEinzel<>"")
				++inde
			DiesesGes.=DiesesEinzel
		}
		/*
		; if(inde < 2)
		if(DieseExplorerFileSeletionsAnz<=1 AND DieseExplorerDirSeletionsAnz=0)
		{
			DiesesGes:=
			Loop,Parse,ges,`n,`r
				DiesesGes.=BildUebersicht2Html(A_LoopField,A_ScreenHeight-16*DpiKorrektur)
		}
		*/
		; MsgBox %inde%>%DiesesGes%<

		FileDelete,% A_Temp "\ZzoAnE5.htm"
		FileAppend,% DiesesGes,% A_Temp "\ZzoAnE5.htm"
		if (NOT IsObject(AnE5))
		{
			AnE5:= new wbr("IE_AnE5")
;			if ((A_ScreenWidth -DieseThisX -DieseThisB) > ( A_ScreenWidth/4))
;				AnE5.setWinPosses(DieseThisX +DieseThisB -24,DieseThisY,DieseThisB,DieseThisH)
			ie := AnE5.getCom()
			; doc := ie.Document
			; ComObjConnect(ie, "IEX_") ; OK OK OK OK
			AnE5.Visible(1)
		}
		AnE5.Navigate( A_Temp "\ZzoAnE5.htm")
		return ges
		; return DiesesGes		; eventuell werden 2 Kenner benoetigt ein zusatzlicher der DiesesGes zurueck gibt
	}
	else if(DieserKenner=HtmlPathesOutKenner)
	{			; FilP://C:\Program Files (x86)\ZackZackOrdner\*ØØ¯⁞¯ØØ*,Ø¯DFR¯ØIn_Row? Ø¯¯Ø`vHtmPat?
		global AnE5E8,AnE5E8HgF,AnE5E8HgF4Last,AnE5E8Edit3Last		; ie erzeugt Fehlermeldung nach einfuehrung von HtmlPathesBilderuebersichtKenner
		HtmlListe:=""
		Edit8HtmlErsetzen:=true
		if(SubStr(ges,-1)="`r`n")
			StringTrimRight,HtmlListe,ges,2
		i:=-1
		AnE5E8Edit3Last:=0
		AnE5E8HgF:=" style='background-color: rgb(200,255,255); '"
		Loop, Parse,HtmlListe,`n,`r
		{
			++i
			if(i>1)
				i:=0
			R1:=35+i*20
			R2:=55-i*10
			if(A_Index=Edit3)
				R3:=200
			else
				R3:=255
			Transform,LoopField,HTML,%A_LoopField%,2
			AnE5E8HgF4Last:=" style='background-color: rgb(" R3 ", 2" R2 ", 2" R1 "); '>"
			gesHtmlListe.="<div ID='z" A_Index "'style='background-color: rgb(255, 2" R2 ", 2" R1 "); '>" ifBildImPfad2Html(LoopField) "</div>`r`n"
			; gesHtmlListe.="<div ID='z" A_Index "'style='background-color: rgb(255, 2" R2 ", 2" R1 "); '>" BildUebersicht2Html(LoopField) "</div>`r`n"
/*
			SchoenAnzeigeZanz:=15000
			if(StrLen(gesHtmlListe)>SchoenAnzeigeZanz)
			{
				gesHtmlListe1:=SubStr(gesHtmlListe,1,SchoenAnzeigeZanz)
				Transform,gesHtmlListe1,HTML,%gesHtmlListe1%,2
				gesHtmlListe2:=SubStr(gesHtmlListe,SchoenAnzeigeZanz +1)
				gesHtmlListe:=gesHtmlListe1 . gesHtmlListe2
			}
			else
				Transform,gesHtmlListe,HTML,%gesHtmlListe%
*/				
			
		}
HtmlQuelltext=
(
	<!DOCTYPE html>
<html  lang='de-de' >
<head>
<meta charset='utf-16' />
<title>Pfad-Anzeige</title>
<meta name='robots' content='noindex' />
</head>
<body>
%gesHtmlListe%
</body>
</html>
)
		WinGetPos,DieseThisX,DieseThisY,DieseThisB,DieseThisH,ahk_id %GuiWinHwnd%
		FileDelete,%A_Temp%\ZzoE5.htm
		FileAppend,%HtmlQuelltext%,%A_Temp%\ZzoE5.htm
		if (NOT IsObject(AnE5E8))
		{
			AnE5E8:= new wbr("IE_AnE5E8")
			if ((A_ScreenWidth -DieseThisX -DieseThisB) > ( A_ScreenWidth/4))
				AnE5E8.setWinPosses(DieseThisX +DieseThisB -24,DieseThisY,DieseThisB,DieseThisH)
			ie := AnE5E8.getCom()
			; doc := ie.Document
			; ComObjConnect(ie, "IEX_") ; OK OK OK OK
			AnE5E8.Visible(1)
		}
		AnE5E8.Navigate( A_Temp "\ZzoE5.htm")
		;AnE5E8.setSourceCode(HtmlQuelltext)
		; doc.write(HtmlQuelltext)
		; sleep 2000
			DiesesinnerHtml:=AnE5E8.GetSetOneOfAllTags("/ID=z" Edit3,,"innerHtml")
			; MsgBox % DiesesinnerHtml
			AnE5E8.GetSetOneOfAllTags("/ID=z" Edit3,,"innerHtml",,"<div ID='z" Edit3 "z' " AnE5E8HgF ">" ifBildImPfad2Html(DiesesinnerHtml) "</div>")

		; docX := AnE5E8.getDocument()
		ComObjConnect(AnE5E8.getDocument(), "DocX_")
		; ComObjConnect(docX, "DocX_")
		; ie := AnE5E8.getCom()
		; ComObjConnect(ie, "Doc_")
		; sleep 200
		; AnE5E8.GetSetOneOfAllTags("/ID=z" Edit3,,"innerHtml",,"<div ID='z" Edit3 "'>" Neutext "</div>`r`n")
		return  ges
	}
	else if (SubStr(KombiBefehl,1,MirrorEdit5KennerLen+1+WitchControlDefKennerLen)=(MirrorEdit5Kenner . A_Space . WitchControlDefKenner))	; 
	{		
		StringTrimLeft,FuerDef,DieserKennerInhalt,MirrorEdit5KennerLen + 2
;		MsgBox %DieserKennerInhalt%
		Def:=
		Def:=StrSplit(FuerDef,"`,")
		Loop % Def.MaxIndex()
		{
			Def[A_Index]:=GlobalDeref(Def[A_Index])
			; Transform, % Def[A_Index],Deref, % Def[A_Index]
;			MsgBox % Def[A_Index]
		}
;		SoundBeep 600
		if(SubStr(Def.1,1,WitchControlDefKennerLen)=WitchControlDefKenner)
		{
			Def.RemoveAt(0) 
;			SoundBeep 700
		}
		IfWinNotActive,% Def.2,% Def.3,% Def.4,% Def.5
			ControlSetText,% Def.1,% ges,% Def.2,% Def.3,% Def.4,% Def.5
		return ges
	}
	else if(DieserKenner=OldDelNewKenner)
	{
		ges:=""			; eine Neue Suche kann bewinnen.
	}
	else if(DieserKenner=WinAnWinKenner)
	{	; ExSel://AllInfo?Mirr05? WConDef? ,ahk_id 0x50034WinAnWin? WWinDef? C:\Program Files (x86)\ZackZackOrdner WWinDef? ahk_exe notepad.exe
		; ExSel://AllInfo?Mirr05? WConDef? ,ahk_id 0x50034WinAnWin? WWinDef? ahk_id 0x80404 WWinDef? ahk_id 0x230554
		; MsgBox %DieserKennerInhalt%
		TrennPos:=InStr(DieserKennerInhalt,WitchWindowDefKenner,,2)-1
		WinDefsLinks:=substr(DieserKennerInhalt,WitchWindowDefKennerLen+2,TrennPos-2 -WitchWindowDefKennerLen)
		WinDefsRechts:=substr(DieserKennerInhalt,TrennPos+WitchWindowDefKennerLen+2)
		if (SubStr(WinDefsRechts,0)=A_Space)
			StringTrimRight,WinDefsRechts,WinDefsRechts,1
		WinDefLinks:=StrSplit(WinDefsLinks,",")
		WinDefRechts:=StrSplit(WinDefsRechts,",")
		WinGetPos,WinLiX,WinLiY,WinLiB,WinLiH,% WinDefLinks.1,% WinDefLinks.2,% WinDefLinks.3,% WinDefLinks.4
		WinGetPos,WinReX,WinReY,WinReB,WinResH,% WinDefRechts.1,% WinDefRechts.2,% WinDefRechts.3,% WinDefRechts.4
;		IfWinActive,% WinDefLinks.1,% WinDefLinks.2,% WinDefLinks.3,% WinDefLinks.4
		{
			if Fehlersuchee
			{
				SoundBeep
				RunOtherAhkScriptOrExe(ExternalToolTipPath, WinDefRechts.1 "	"  WinDefRechts.2 "	" WinLiX+WinLiB-24 "	" WinLiY "	" WinLiB "	" WinLiH)
			}
			IfWinNotActive,% WinDefRechts.1,% WinDefRechts.2,% WinDefRechts.3,% WinDefRechts.4
			{
				if (InStr(Edit2,HtmlPathesBilderuebersichtKenner) AND NOT InStr(Edit2,MirrorEdit5Kenner))
						WinB:=A_ScreenWidth - WinLiX - WinLiB 
					else
						WinB:=WinLiB
				if ((WinReX=WinReY and WinReX < -5000) OR (WinReB-A_ScreenWidth)<20 AND (WinResH-A_ScreenWidth)<20)
					WinRestore,% WinDefRechts.1,% WinDefRechts.2,% WinDefRechts.3,% WinDefRechts.4
				WinMove,% WinDefRechts.1,% WinDefRechts.2,WinLiX+WinLiB-24,WinLiY,WinB,WinLiH,% WinDefRechts.3,% WinDefRechts.4
			}
		}
		return ges
	}
	else if(DieserKenner=MirrorEdit5Kenner)	; FilP://C:\Program Files (x86)\ZackZackOrdner\*ØØ¯⁞ind¯ØØ*,Ø¯DFR¯Ø`vMirr05? 0x209c2In_Row? Ø¯1.7¯Ø`vSort? ViaTimer_SortLenAlle
	{	; FilP://C:\Program Files (x86)\ZackZackOrdner\*ØØ¯⁞¯ØØ*,Ø¯DFR¯ØIn_Row? Ø¯¯Ø`vMirr05? 0x209c2
		ZielHwnd:=DieserKennerInhalt
		ControlSetText,,%ges%,ahk_id %ZielHwnd%
		return ges
	}
	else if(DieserKenner=ClipE5WriteKenner)
	{
		ZielClipE5WritePfad:=DieserKennerInhalt
		Clipboard:=ges
		return ges
	}
	else if(DieserKenner=FileE5WriteKenner)
	{
		ZielFileE5WritePfad:=DieserKennerInhalt
		SplitPath,ZielFileE5WritePfad,,ZielFileE5WritePfadDir
		IfNotExist %ZielFileE5WritePfadDir%
		{
			FileCreateDir,%ZielFileE5WritePfadDir%
			if ErrorLevel
			{
				ToolTip, % A_LineFile A_LineNumber	"Der Ordner " "ZielFileE5WritePfadDir konnte nicht erstellt werden.`n`nDas Skript geht auf Not-Halt"
				Pause
				ExitApp
			}
		}
		IfExist %ZielFileE5WritePfad%
			FileDelete,%ZielFileE5WritePfad%
		FileAppend,%ges%,%ZielFileE5WritePfad%
		if ErrorLevel
		{
			ToolTip, % A_LineFile A_LineNumber	"Die Datei " "ZielFileE5WritePfad konnte nicht erstellt werden.`n`nDas Skript geht auf Not-Halt"
			Pause
			ExitApp
		}
		return ges
	}
	else if (SubStr(KombiBefehl,1,MirrorEdit8KennerLen+1+WitchControlDefKennerLen)=(MirrorEdit8Kenner . A_Space . WitchControlDefKenner))	; 
	{		
		; Clip://`vMirr05? WConDef? Edit1,ahk_exe notepad.exe,,Titelausnahme,Textausnahme
		StringTrimLeft,FuerDef,DieserKennerInhalt,MirrorEdit8KennerLen + 2

;		MsgBox %DieserKennerInhalt%
		Def:=
		Def:=StrSplit(FuerDef,"`,")
		Loop % Def.MaxIndex()
		{
			Def[A_Index]:=GlobalDeref(Def[A_Index])
;			MsgBox % ">" Def[A_Index] "<"
		}
;		SoundBeep 1600
		if(SubStr(Def.1,1,WitchControlDefKennerLen)=WitchControlDefKenner)
		{
			Def.RemoveAt(0)
		}
			Edit5:=ges
			gosub Edit5Festigen
			
			Edit8:=GetZeile(Edit5,Edit3)
			gosub Edit8Festigen
			; MsgBox % "0>" Def[1] "<" "1>" Edit8 "<" "2>" Def[2] "<" "3>" Def[3] "<" "4>" Def[4] "<" 
			ControlSetText,% Def.1,% Edit8,% Def.2,% Def.3,% Def.4,% Def.5
			Edit5:=
		
		return ges
	}
	else if(DieserKenner=MirrorEdit8Kenner)
	{	; FilP://C:\Program Files (x86)\ZackZackOrdner\*ØØ¯⁞¯ØØ*,Ø¯DFR¯ØIn_Row? Ø¯¯Ø`vMirr08? 0x209c2
		Edit5:=ges
		gosub Edit5Festigen
		Edit8:=GetZeile(Edit5,Edit3)
		gosub Edit8Festigen
		ZielHwnd:=DieserKennerInhalt
		Edit5:=
		return ges
	}
	else if(DieserKenner=SortKenner or DieserKenner=LoopKenner)	; Sort? KurzOben
	{
		if(DieserKennerInhalt="KurzOben")
		{
			sort,ges,F NachStrLen
			return ges
		}
		else if(SubStr(DieserKennerInhalt,1,ViaTimerKennerLen)=ViaTimerKenner)	; Sort? ViaTimer_SortMTimeAlle
		{
			ViaTimerTargetLabel:=SubStr(DieserKennerInhalt,ViaTimerKennerLen+1)
			; ViaTimerInteger:=
			
				
			if(A_TickCount-LastGesTickCount>2000)
			{
				SetTimer,ViaTimer, -1000
			}
			; LastGes:=ges
			LastGesTickCount:=A_TickCount
			return ges
		}
 /*
					; macht es nicht 
		else if(DieserKennerInhalt="NachMTimeR")
		{
			sort,ges,F NachMTimeR
			return ges
		}
		else if(DieserKennerInhalt="NachMTime")	; FilP://C:\Program Files (x86)\ZackZackOrdner\**,DFRIn_Row? Sort? NachMTime
		{			; auch nicht via Label
			Edit5:=ges
			gosub Edit5Festigen
			gosub SortMTimeR
		;	MsgBox % ges
		;	StringUpper,ges,ges
		;	sort,ges,F NachMTime
		;	StringLower,ges,ges
		;	MsgBox % ges
			ges:=Edit5
			return ges
		}
 */

	}
return
}

DemoMode:	;{	
Sleep 6000
FileRead,Suchlog,%A_AppData%\Zack\SuchbegriffsObenNeu.log
SuchlogZeilenAnz:=zaehleZeilen(Suchlog)
SuchlogZeile:=StrSplit(Suchlog,"`n","`r")
Loop,
{
	Random,iR,1,SuchlogZeilenAnz
	Edit8:=SuchlogZeile[iR]
	gosub Edit8Festigen
	; Edit3:=1
	; gosub Edit3Festigen
	; gosub Edit5
	sleep 500
	gosub SA
	gosub GetAngezeigteSuche
	loop 10
	{
		sleep 1000
		if (A_TimeIdlePhysical < 5000)
			break
	}
	if (A_TimeIdlePhysical < 5000)
		break
}
return
;}	

ViaTimer:
; MsgBox nach Label ViaTimer
; SoundBeep 680
if(SubStr(ViaTimerTargetLabel,1,1)="-")
{		; ExSel://`vIn_Inh?`vSort? ViaTimer_-Edit2
	StringTrimLeft,ViaTimerTargetLabel,ViaTimerTargetLabel,1
	; SoundBeep 1000
	EndlosViaTimer:=true
}
else
{
if (IsLabel(ViaTimerTargetLabel))
	; SoundBeep 1410
	gosub %ViaTimerTargetLabel%
}
if EndlosViaTimer
{
	Sleep 1000
	; SoundBeep 2000
	
	if(InStr(Edit2,ExplorerSelectedKenner))
	{
		Sleep,A_TimeIdlePhysical/25000
		WinWaitActive,ahk_class CabinetWClass,,A_TimeIdlePhysical/1000
		; SoundBeep 3000
		gosub WennAnE5WegGuiClose
	}
	EndlosViaTimer:=false
	if (IsLabel(ViaTimerTargetLabel))
	{
		; SoundBeep 4000
		goto %ViaTimerTargetLabel%
	}

}
; SoundBeep 6000
return


GetGosubLabel(AufRufEvent)	; Diese Funktion wird innerhalb Event Functions oder Event Labels aufgerufen
{	;  WM_COMMAND 0x111 	; https://ahkde.github.io/docs/misc/SendMessage.htm
	global OnEventKenner, Edit2
	; SoundBeep
	StringReplace,Edit2Modi,Edit2,``v,`v,All

	if(InStr(Edit2Modi,OnEventKenner))
	{			; OnEvent? OnClipboardChange`tGosub F5`vclip://
		if(InStr(Edit2Modi,"OnClipboardChange") AND AufRufEvent="OnClipboardChange")	
		{		; OnEvent? OnClipboardChange	Gosub F5clip://In_Row? Edit6
			Pos1:=InStr(Edit2Modi,"Gosub")+5
			Pos2:=InStr(SubStr(Edit2Modi,Pos1),"")
			DiesesLabel:=SubStr(Edit2Modi,Pos1+1,Pos2-2)
			; MsgBox %DiesesLabel%
			if(IsLabel(DiesesLabel))
				gosub %DiesesLabel%
		}
		
	}
		
	; MsgBox %EventInfo% 	%A_Gui% 	%A_GuiControl%	 %A_GuiEvent% und %A_EventInfo%.
	
}

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

DownloadToString(url, encoding="utf-8")
{		; Danke Bentschi	; Quelle  https://autohotkey.com/board/topic/89198-simple-download-bin-tostring-und-tofile/ 
  static a := "AutoHotkey/" A_AhkVersion
  if (!DllCall("LoadLibrary", "str", "wininet") || !(h := DllCall("wininet\InternetOpen", "str", a, "uint", 1, "ptr", 0, "ptr", 0, "uint", 0, "ptr")))
    return 0
  c := s := 0, o := ""
  if (f := DllCall("wininet\InternetOpenUrl", "ptr", h, "str", url, "ptr", 0, "uint", 0, "uint", 0x80003000, "ptr", 0, "ptr"))
  {
    while (DllCall("wininet\InternetQueryDataAvailable", "ptr", f, "uint*", s, "uint", 0, "ptr", 0) && s>0)
    {
      VarSetCapacity(b, s, 0)
      DllCall("wininet\InternetReadFile", "ptr", f, "ptr", &b, "uint", s, "uint*", r)
      o .= StrGet(&b, r>>(encoding="utf-16"||encoding="cp1200"), encoding)
    }
    DllCall("wininet\InternetCloseHandle", "ptr", f)
  }
  DllCall("wininet\InternetCloseHandle", "ptr", h)
  return o
}

DownloadToFile(url, filename)
{		; Danke Bentschi	; Quelle  https://autohotkey.com/board/topic/89198-simple-download-bin-tostring-und-tofile/ 
  static a := "AutoHotkey/" A_AhkVersion
  if (!(o := FileOpen(filename, "w")) || !DllCall("LoadLibrary", "str", "wininet") || !(h := DllCall("wininet\InternetOpen", "str", a, "uint", 1, "ptr", 0, "ptr", 0, "uint", 0, "ptr")))
    return 0
  c := s := 0
  if (f := DllCall("wininet\InternetOpenUrl", "ptr", h, "str", url, "ptr", 0, "uint", 0, "uint", 0x80003000, "ptr", 0, "ptr"))
  {
    while (DllCall("wininet\InternetQueryDataAvailable", "ptr", f, "uint*", s, "uint", 0, "ptr", 0) && s>0)
    {
      VarSetCapacity(b, s, 0)
      DllCall("wininet\InternetReadFile", "ptr", f, "ptr", &b, "uint", s, "uint*", r)
      c += r
      o.rawWrite(b, r)
    }
    DllCall("wininet\InternetCloseHandle", "ptr", f)
  }
  DllCall("wininet\InternetCloseHandle", "ptr", h)
  o.close()
  return c
}

DownloadBin(url, byref buf)
{		; Danke Bentschi	; Quelle  https://autohotkey.com/board/topic/89198-simple-download-bin-tostring-und-tofile/ 
  static a := "AutoHotkey/" A_AhkVersion
  if (!DllCall("LoadLibrary", "str", "wininet") || !(h := DllCall("wininet\InternetOpen", "str", a, "uint", 1, "ptr", 0, "ptr", 0, "uint", 0, "ptr")))
    return 0
  c := s := 0
  if (f := DllCall("wininet\InternetOpenUrl", "ptr", h, "str", url, "ptr", 0, "uint", 0, "uint", 0x80003000, "ptr", 0, "ptr"))
  {
    while (DllCall("wininet\InternetQueryDataAvailable", "ptr", f, "uint*", s, "uint", 0, "ptr", 0) && s>0)
    {
      VarSetCapacity(b, c+s, 0)
      if (c>0)
        DllCall("RtlMoveMemory", "ptr", &b, "ptr", &buf, "ptr", c)
      DllCall("wininet\InternetReadFile", "ptr", f, "ptr", &b+c, "uint", s, "uint*", r)
      c += r
      VarSetCapacity(buf, c, 0)
      if (c>0)
        DllCall("RtlMoveMemory", "ptr", &buf, "ptr", &b, "ptr", c)
    }
    DllCall("wininet\InternetCloseHandle", "ptr", f)
  }
  DllCall("wininet\InternetCloseHandle", "ptr", h)
  return c
}



FindInBinaryFile(FilePath, SearchStr) {
   FileGetSize, FileSize, %FilePath%
    FileRead, FileContent, *c %FilePath%
   ; FileRead, FileContent, %FilePath% ; ,CP28591
   Length := StrLen(SearchStr)
   FirstChar := Asc(SubStr(SearchStr, 1, 1))
   Offset := 0
   MaxOffset := FileSize - Length
   Found := 0
   While (Offset < MaxOffset) 
   {
      If (A:=NumGet(FileContent, Offset, "UChar") = FirstChar)  && (B:=StrGet(&FileContent + Offset, Length, "CP0") == SearchStr) 
	  {
         Found := Offset + 1
         Break
      }
      Offset++
   }
   Return Found
}
ReadTextFromBinary(filepath)
{ ; Danke IsNull	; http://ahkscript.org/germans/forums/viewtopic.php?p=54138

FileRead, binary, *c %filepath% 
FileGetSize,size,%filepath% 

ExtractedText := "" 
   Loop, % size      ;for each byte 
   { 
      NextByte := NumGet(binary,A_index-1,"char") 
      ; if(NextByte > 31){ ; OriginalZeile
      if(NextByte > 0){ ; Aenderung Gerdi um allles ausser 0 zu bekommen
         ExtractedText .= chr(NextByte) 
      } 
   } 
Return, ExtractedText 
} 

#include *i %A_ScriptDir%\wBr\wBr.ahk
	;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
	/*
		Author: Joshua A. Kinnison 2011-04-27, 16:12
		Function: Explorer_GetWindow
			Purpose: Get explorer window COM object
		Parameters
			hWnd=""
	*/
	Explorer_GetWindow2(hwnd="")
	{
		hwnd := hwnd ? hwnd : WinExist("A")
		WinGetClass class, ahk_id %hwnd%

		if (class="CabinetWClass" or class="ExploreWClass" or class="Progman")
			for window in ComObjCreate("Shell.Application").Windows
			{
				if (window.hwnd==hwnd)
					return window
			}
	}
	;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
/*
SelectedItems:
; https://autohotkey.com/board/topic/19039-explorer-windows-manipulations/page-7
; https://ahkde.github.io/docs/commands/For.htm
; InternalExplorer := Explorer_GetWindow2(HwndIe1)
InternalExplorer := Explorer_GetWindow2()
InternalExplorer.Navigate2[A_ScriptDir]
; InternalExplorer:=WB.Windows
SelectedItems:=InternalExplorer.Document.SelectedItems
MsgBox % SelectedItems
return
*/
Clipboard2NotText:	;{	
ClipboardM:=FuehrendeSternePathListEntfernen(Clipboard)
ClipboardSetFiles(ClipboardM)
return
;}	
FuehrendeSternePathListEntfernen(PathList,EndLeerZeile=0){
	HK= "
	Loop,Parse,PathList,`n,`r
	{
		DiesesFuerClipEdit5 .= FuehrendeSterneEntfernen(strReplace(A_LoopField,HK,,All)) "`r`n"
	}
	if not EndLeerZeile
		StringTrimRight,DiesesFuerClipEdit5,DiesesFuerClipEdit5,2
	return DiesesFuerClipEdit5
}
; Danke just me
ClipboardSetFiles(FilesToSet, DropEffect := "Copy") {
   Static SizeT := A_IsUnicode ? 2 : 1 ; size of a TCHAR
   Static PreferredDropEffect := DllCall("RegisterClipboardFormat", "Str", "Preferred DropEffect")
   Static DropEffects := {1: 1, 2: 2, Copy: 1, Move: 2}
   ; -------------------------------------------------------------------------------------------------------------------
   ; Count files and total string length
   TotalLength := 0
   FileArray := []
   Loop, Parse, FilesToSet, `n, `r
   {
      If (Length := StrLen(A_LoopField))
         FileArray.Push({Path: A_LoopField, Len: Length + 1})
      TotalLength += Length
   }
   FileCount := FileArray.Length()
   If !(FileCount && TotalLength)
      Return
   ; -------------------------------------------------------------------------------------------------------------------
   ; Add files to the clipboard
   If DllCall("OpenClipboard", "Ptr", A_ScriptHwnd) && DllCall("EmptyClipboard") {
      ; hMem format ---------------------------------------------------------------------------------------------------
      ; 0x42 = GMEM_MOVEABLE (0x02) | GMEM_ZEROINIT (0x40)
      hMem := DllCall("GlobalAlloc", "UInt", 0x42, "UInt", 20 + (TotalLength + FileCount + 1) * SizeT, "UPtr")
      pMem := DllCall("GlobalLock", "Ptr", hMem)
      Offset := 20
      NumPut(Offset, pMem + 0, "UInt")         ; DROPFILES.pFiles = offset of file list
      NumPut(!!A_IsUnicode, pMem + 16, "UInt") ; DROPFILES.fWide = 0 --> ANSI, fWide = 1 --> Unicode
      For Each, File In FileArray
         Offset += StrPut(File.Path, pMem + Offset, File.Len) * SizeT
      DllCall("GlobalUnlock", "Ptr", hMem)
      DllCall("SetClipboardData", "UInt", 0x0F, "UPtr", hMem) ; 0x0F = CF_HDROP
      ; Preferred DropEffect format ------------------------------------------------------------------------------------
      If (DropEffect := DropEffects[DropEffect]) {
         hMem := DllCall("GlobalAlloc", "UInt", 0x42, "UInt", 4, "UPtr")
         pMem := DllCall("GlobalLock", "Ptr", hMem)
         NumPut(DropEffect, pMem + 0, "UChar")
         DllCall("GlobalUnlock", "Ptr", hMem)
         DllCall("SetClipboardData", "UInt", PreferredDropEffect, "Ptr", hMem)
      }
      DllCall("CloseClipboard")
   }
   Return
}
SvgAmpel(LeuchtFarbe="green",AmpelHoehe="100") {
	LF1:="#330000"
	LF2:="#333300"
	LF3:="#003300"
; Loop 3
; 	LF%A_Index%:="grey"
if (LeuchtFarbe="green" OR LeuchtFarbe="")
	LF3:="#aaff80"
else if (LeuchtFarbe="yellow")
	LF2:="#ffff80"
else if (LeuchtFarbe="red")
	LF1:="#ff8080"
AmpelBreite:=AmpelHoehe/3
Strichstaerke:=AmpelHoehe/80
cx:=AmpelBreite/2
cy1:=cx-Strichstaerke
cy2:=AmpelHoehe/2
Cy3:=AmpelHoehe-cx+Strichstaerke
r:=cx-2*Strichstaerke
AmpelRueck=
(
<svg height='%AmpelHoehe%' width='%AmpelBreite%'>
<rect style='stroke-width:%Strichstaerke%' width='%AmpelBreite%'  height='%AmpelHoehe%'  x='0'  y='0' />
<circle cx='%cx%' cy='%cy1%'  r='%r%' stroke='black' stroke-width='%Strichstaerke%' fill='%LF1%' />
<circle cx='%cx%' cy='%cy2%'  r='%r%' stroke='black' stroke-width='%Strichstaerke%' fill='%LF2%' />
<circle cx='%cx%' cy='%cy3%'  r='%r%' stroke='black' stroke-width='%Strichstaerke%' fill='%LF3%' />
</svg>
) 	; https://www.w3schools.com/graphics/svg_intro.asp
return AmpelRueck
}
; SchreibMarkeTo()
FokusEdit2Rechts()
{
	global Edit2,GuiWinHwnd,Neutr_Ca
	NullSp:="​"
	; Neutr_Ca:="⁞"
	Gui,1:Submit,NoHide
	; Sleep 600
	Offset:=0
	Pos:=InStr(Edit2,Neutr_Ca)
	if Pos
	{
		ControlFocus,Edit2,ahk_id %GuiWinHwnd%
		Controlget,IstPos,CurrentCol, ,Edit2,ahk_id %GuiWinHwnd%
		IstPosM1:=IstPos-1
		IstPosM2:=IstPos-2
		Pos:=Pos+Offset
		PosM1:=Pos-1
		Delta:=PosM1-IstPosM1
		DeltaM:=-Delta
		if Fehlersuche
			ToolTip % IstPosM1 " <	> " PosM1 "	" Delta

		if NOT Delta
			return
		if (IstPosM1=StrLen(Edit2))
		{
			; ControlSend,Edit2,{Left %DeltaM%},ahk_id %GuiWinHwnd%
			Edit_Select(PosM1, PosM1,"Edit2","ahk_id" GuiWinHwnd)
			return			
		}
			
		if NOT IstPosM1
		{
			; ControlSend,Edit2,{Right %PosM1%},ahk_id %GuiWinHwnd%
			Edit_Select(PosM1, PosM1,"Edit2","ahk_id" GuiWinHwnd)
			return			
		}
		; MsgBox % SubStr(Edit2,IstPosM1,1)
		if(NOt SubStr(Edit2,IstPosM1,1)=Neutr_Ca)
		{
			; sleep 300
			; SoundBeep,4000
			StringReplace,Edit2,Edit2,%Neutr_Ca%,,All
			gosub Edit2Festigen
			; sleep 300
			if (Delta<0)
			{
				; ControlSend,Edit2,{Right %IstPosM2%},ahk_id %GuiWinHwnd%
				Edit_Select(IstPosM2, IstPosM2,"Edit2","ahk_id" GuiWinHwnd)
				; sleep 700
				Control, EditPaste, %Neutr_Ca% ,Edit2,ahk_id %GuiWinHwnd%
				; sleep 300 
				; gosub Edit2Festigen
				ControlSend,Edit2,{Left},ahk_id %GuiWinHwnd%
			}
			else
			{
				; ControlSend,Edit2,{Right %IstPosM1%},ahk_id %GuiWinHwnd%
				Edit_Select(IstPosM1, IstPosM1,"Edit2","ahk_id" GuiWinHwnd)

				; sleep 700
				Control, EditPaste, %Neutr_Ca% ,Edit2,ahk_id %GuiWinHwnd%
				; sleep 300
			;	SoundBeep ,,2000
				; gosub Edit2Festigen
				ControlSend,Edit2,{Left},ahk_id %GuiWinHwnd%
			}
		}
	}
}
Edit_Standard_Params(ByRef Control, ByRef WinTitle) {  ; Helper function. ; Quelle: https://autohotkey.com/board/topic/20981-edit-control-functions/
    if (Control="A" && WinTitle="") { ; Control is "A", use focused control.
        ControlGetFocus, Control, A
        WinTitle = A
    } else if (Control+0!="" && WinTitle="") {  ; Control is numeric, assume its a ahk_id.
        WinTitle := "ahk_id " . Control
        Control =
    }
}
Edit_Select(start=0, end=-1, Control="", WinTitle="")
{	; Quelle: https://autohotkey.com/board/topic/20981-edit-control-functions/
    Edit_Standard_Params(Control, WinTitle)
    SendMessage, 0xB1, start, end, %Control%, %WinTitle%  ; EM_SETSEL
    return (ErrorLevel != "FAIL")
}

; Hier folgen Links die ich gefunden habe, die interressant  wichtig oder dergleichen sind oder sein koennten,
; fuer die aber noch nicht genuegend Sichtungszeit oder Test-Zeit vorhanden war:
; https://getawesomeness.herokuapp.com/get/autohotkey	Linksammelung "genialer" AutoHotKey Libraries
; https://github.com/AHK-just-me/LBEX/blob/master/Sources/LBEX.ahk	Sammlung Sendmeesage-Befehle fuer Listboxen	by just me
; https://autohotkey.com/boards/viewtopic.php?t=3068	Nuetzliches zu Menues	von just me
; http://the-automator.com/category/com/
getMouseOverHwnd(){
Input, Einzeltaste, L1, {LControl}{RControl}{LAlt}{RAlt}{LShift}{RShift}{LWin}{RWin}{AppsKey}{F1}{F2}{F3}{F4}{F5}{F6}{F7}{F8}{F9}{F10}{F11}{F12}{Left}{Right}{Up}{Down}{Home}{End}{PgUp}{PgDn}{Del}{Ins}{BS}{Capslock}{Numlock}{PrintScreen}{Pause}
MouseGetPos, , , , MausOverHwnd, 2
return MausOverHwnd
}
MouseOverHwnd2Clipboard:
ToolTip Maus über gewünschtes Control platzieren`nund bel. Taste drücken!
Clipboard:=getMouseOverHwnd()
ToolTip
RunOtherAhkScriptOrExe(ExternalToolTipPath, Clipboard "`n`n`ngespeichert`n`nVerwendungs-Beispiel:`n`nMirr05? " Clipboard)
return

GlobalDeref(ZK){
	global
	Transform,DerefZK,Deref,% ZK
	return DerefZK
}

IETest:
iePlus := new wbr("IE_ie")
ie := iePlus.getCom()
; ie := ComObjCreate("InternetExplorer.Application")

; Verbindet Ereignisse mit entsprechenden Skript-Funktionen, die den Präfix "IE_" haben.
ComObjConnect(ie, "IEX_")

iePlus.Visible(1)  ; Funktioniert bekanntlich nicht mit IE7.
; ie.Visible := true  ; Funktioniert bekanntlich nicht mit IE7.
iePlus.Navigate("https://autohotkey.com/")
; ie.Navigate("https://autohotkey.com/")


IEX_DocumentComplete(ieEventParam, url, ieFinalParam) {
    global ie,AnE5E8
	; SoundBeep 800
	; MsgBox % ieEventParam	"`n"	url		"`n"	ieFinalParam
	return
    if (ie != ieEventParam)
        s .= "Erster Parameter ist ein neues Wrapper-Objekt.`n"
    if (ie == ieFinalParam)
        s .= "Letzter Parameter ist das originale Wrapper-Objekt.`n"
    if ((disp1:=ComObjUnwrap(ieEventParam)) == (disp2:=ComObjUnwrap(ieFinalParam)))
        s .= "Beide Wrapper-Objekte verweisen auf die gleiche IDispatch-Instanz.`n"
    ObjRelease(disp1), ObjRelease(disp2)
    MsgBox % s . "Das Laden von " ie.Document.title " @ " url " wurde abgeschlossen."
    ie.Quit()
    ExitApp
}
return
DocX_OnClick(doc){
	
	; SoundBeep 333
	return
}

GetExplorerSelectDetailsNewP:
GetExplorerSelectDetails:
if(isDir(FuehrendeSterneEntfernen(Edit8)))
{
	Edit8Sternlos:=FuehrendeSterneEntfernen(Edit8)
	Run,% "Explorer.exe" A_Space HK Edit8Sternlos HK,,,DieseExplorerVarPID
}
else
	Run,% "Explorer.exe" ,,,DieseExplorerVarPID
u:=0
sleep 2000
DieseExplorerVarHwnd:=WinExist("A")
WinGetPos,DieseExplorerWinLiX,DieseExplorerWinLiY,DieseExplorerWinLiB,DieseExplorerWinLiH,ahk_id %DieseExplorerVarHwnd%
if(DieseExplorerWinLiX+2*DieseExplorerWinLiB>A_ScreenWidth)
{
	if(DieseExplorerWinLiB>A_ScreenWidth/2)
		DieseExplorerWinLiB:=A_ScreenWidth/2
	WinMove,ahk_id %DieseExplorerVarHwnd%,,0,,DieseExplorerWinLiB
}
IfNotExist %A_Temp%\Explorer-selected-Detail-Anzeige.txt
	FileAppend,Explorer-selected-Detail-Anzeige,%A_Temp%\Explorer-selected-Detail-Anzeige.txt,utf-16
IfNotExist %A_Temp%\Explorer-selected-Detail-Anzeige.txt
	MsgBox, 262144, Empfehlung:, Bitte folgende Frage mit Ja bestaetigen!, 5
Run,% "Notepad.exe" A_Space HK A_Temp "\Explorer-selected-Detail-Anzeige.txt" HK,,,DieseNotepadVarPID

; Run,% "Notepad.exe",,,DieseNotepadVarPID
WinWaitActive,ahk_pid %DieseNotepadVarPID%,,4
sleep 1000
if ErrorLevel
	MsgBox %A_LineNumber%  stop
Sleep 100
DieseNotepadWinHwnd:=WinExist("A")
; MsgBox % DieseExplorerVarHwnd "	" DieseNotepadWinHwnd
WinSetTitle, ahk_id %GuiWinHwnd%,,Modus: Explorer-selected-Detail-Anzeige fuer %DieseNotepadVarPID%
; DieseNotepadVarHwnd := DllCall("OpenProcess", "UInt", 0x0400, "Int", false, "UInt", DieseExplorerVarPID, "Ptr")
;Edit2:="ExSel://AllInfo?Mirr05? WConDef? Edit1,ahk_pid " DieseNotepadVarPID "WinAnWin? WWinDef? ahk_id " DieseExplorerVarHwnd " WWinDef? ahk_pid " DieseNotepadVarPID "Loop? ViaTimer_-Edit2"
Edit2:="ExSel://WConDef? ,ahk_id " DieseExplorerVarHwnd "AllInfo?Mirr05? WConDef? Edit1,ahk_id " DieseNotepadWinHwnd "WinAnWin? WWinDef? ahk_id " DieseExplorerVarHwnd " WWinDef? ahk_pid " DieseNotepadVarPID "Loop? ViaTimer_-Edit2"
gosub Edit2Festigen
sleep 1000
WinActivate,ahk_id %DieseExplorerVarHwnd%
sleep 1000
gosub GuiWinMin
send {Down}{Home}
WinSetTitle,% "ahk_pid " DieseNotepadVarPID, ,Explorer-selected-Detail-Anzeige %DieseNotepadVarPID%,
; WinSetTitle,% "ahk_pid " DieseNotepadVarPID,,Clipboard-Anzeige %DieseNotepadVarPID%
if(A_ThisLabel="GetExplorerSelectDetailsNewP")
	gosub ZzoNewProcess
WinWaitClose,% "ahk_pid " DieseNotepadVarPID
; FileDelete,%ZzoHauptFensterHwndPfad%
; FileAppend,% GuiWinHwnd,% ZzoHauptFensterHwndPfad
goto GuiClose
return
GetExplorerSelectDetailsPicNewP:
GetExplorerSelectDetailsPic:
; SetTitleMatchMode,1
; SetTitleMatchMode,Slow
if Not (IsObject(AnE5))
{
	gosub SA
	WinWaitActive,ahk_id %GuiWinHwnd%,,7
	AnE5 := new wbr("IE_AnE5")
	AnE5.Visible(1)
	Sleep 1000
	DieseIeWinHwnd:=GetParent(AnE5.getWinHwnd())
	WinActivate,ahk_id %DieseIeWinHwnd%
	WinWaitActive,ahk_id %DieseIeWinHwnd%,,40
	sleep 200
	ProbeDieseIeWinHwnd:=WinExist("A")
	if(DieseIeWinHwnd<>ProbeDieseIeWinHwnd){
		SoundBeep 350
		; SoundBeep 350
		; SoundBeep 350
	}
	; WinWaitActive, ahk_id %DieseIeWinHwnd%
	; SoundBeep 4000
	sleep 1000
}
if(isDir(FuehrendeSterneEntfernen(Edit8)))
{
	Edit8Sternlos:=FuehrendeSterneEntfernen(Edit8)
	Run,% "Explorer.exe" A_Space HK Edit8Sternlos HK,,,DieseExplorerVarPID
}
else
	Run,% "Explorer.exe" ,,,DieseExplorerVarPID
; WinWaitActive,ahk_pid %DieseExplorerVarPID%,,9
; WinWaitActive,ahk_exe explore.exe,,9	; funced ned
; if ErrorLevel
;	MsgBox  %A_LineNumber%  stop
u:=0
sleep 2000
	DieseExplorerVarHwnd:=WinExist("A")

	
; WinWaitActive,ahk_id %DieseExplorerVarHwnd%,,90
; if ErrorLevel
; 	MsgBox %A_LineNumber%  stop

WinGetPos,DieseExplorerWinLiX,DieseExplorerWinLiY,DieseExplorerWinLiB,DieseExplorerWinLiH,ahk_id %DieseExplorerVarHwnd%
if(DieseExplorerWinLiX+2*DieseExplorerWinLiB>A_ScreenWidth)
{
	if(DieseExplorerWinLiB>A_ScreenWidth/2)
		DieseExplorerWinLiB:=A_ScreenWidth/2
	WinMove,ahk_id %DieseExplorerVarHwnd%,,0,,DieseExplorerWinLiB
}
IfNotExist %A_Temp%\Explorer-selected-Detail-Anzeige.txt
	FileAppend,Explorer-selected-Detail-Anzeige,%A_Temp%\Explorer-selected-Detail-Anzeige.txt,utf-16
IfNotExist %A_Temp%\Explorer-selected-Detail-Anzeige.txt
	MsgBox, 262144, Empfehlung:, Bitte folgende Frage mit Ja bestaetigen!, 5
Run,% "Notepad.exe" A_Space HK A_Temp "\Explorer-selected-Detail-Anzeige.txt" HK,,,DieseNotepadVarPID
; Run,% "Notepad.exe",,,DieseNotepadVarPID
WinWaitActive,ahk_pid %DieseNotepadVarPID%,,4
if ErrorLevel
	MsgBox %A_LineNumber%  stop
Sleep 100
DieseNotepadWinHwnd:=WinExist("A")

WinSetTitle, ahk_id %GuiWinHwnd%,,Modus: Explorer-selected-Detail-Anzeige fuer %DieseNotepadVarPID%
; DieseNotepadVarHwnd := DllCall("OpenProcess", "UInt", 0x0400, "Int", false, "UInt", DieseExplorerVarPID, "Ptr")
;Edit2:="ExSel://AllInfo?Mirr05? WConDef? Edit1,ahk_pid " DieseNotepadVarPID "WinAnWin? WWinDef? ahk_id " DieseExplorerVarHwnd " WWinDef? ahk_pid " DieseNotepadVarPID "Loop? ViaTimer_-Edit2"
; MsgBox %     DieseExplorerVarHwnd  " " DieseNotepadWinHwnd " " DieseIeWinHwnd " "
Edit2:="ExSel://WConDef? ,ahk_id " DieseExplorerVarHwnd "AllInfo? NotRecceRtoNMirr05? WConDef? Edit1,ahk_id " DieseNotepadWinHwnd "WinAnWin? WWinDef? ahk_id " DieseExplorerVarHwnd " WWinDef? ahk_id " DieseNotepadWinHwnd "`vHtmPicView? Auto" "WinAnWin? WWinDef? ahk_id " DieseNotepadWinHwnd " WWinDef? ahk_id " DieseIeWinHwnd "Loop?  ViaTimer_-Edit2"
; Edit2:="ExSel://`tWTitle? ahk_id " DieseExplorerVarHwnd  "`vHtmPicView? 150" "AllInfo?Mirr05? WConDef? Edit1,ahk_pid " DieseNotepadVarPID "WinAnWin? WWinDef? ahk_id " DieseExplorerVarHwnd " WWinDef? ahk_pid " DieseNotepadVarPID "WinAnWin? WWinDef? ahk_pid " DieseNotepadVarPID " WWinDef? ahk_id " AnE5.getWinHwnd() "Loop? ViaTimer_-Edit2"
gosub Edit2Festigen
sleep 1000
WinActivate,ahk_id %DieseExplorerVarHwnd%
sleep 1000
gosub GuiWinMin
send {Down}{Home}
WinSetTitle,% "ahk_pid " DieseNotepadVarPID, ,Explorer-selected-Detail-Bild-Anzeige %DieseNotepadVarPID%,
; WinSetTitle,% "ahk_pid " DieseNotepadVarPID,,Clipboard-Anzeige %DieseNotepadVarPID%
if(A_ThisLabel="GetExplorerSelectDetailsPicNewP")
	gosub ZzoNewProcess
WatchAnE5WinClose:=true
WinWaitClose,% "ahk_pid " DieseNotepadVarPID
; FileDelete,%ZzoHauptFensterHwndPfad%
; FileAppend,% GuiWinHwnd,% ZzoHauptFensterHwndPfad
Edit2:="ExSel://WConDef? ,ahk_id " DieseExplorerVarHwnd "AllInfo? NotRecceRtoN" IeBildExtList "`vHtmPicView? Auto" "WinAnWin? WWinDef? ahk_id " DieseExplorerVarHwnd " WWinDef? ahk_id " GetParent(AnE5.getWinHwnd()) "Loop? ViaTimer_-Edit2"
; Edit2:="ExSel://`tWTitle? ahk_id " DieseExplorerVarHwnd "`vHtmPicView? 150" "AllInfo? " "WinAnWin? WWinDef? ahk_id " DieseExplorerVarHwnd " WWinDef? ahk_id " GetParent(AnE5.getWinHwnd()) "Loop? ViaTimer_-Edit2"
gosub Edit2Festigen
WinWaitClose,% "ahk_id " AnE5.getWinHwnd()
goto GuiClose
return
WennAnE5WegGuiClose:
if WatchAnE5WinClose
{
WinWaitClose,% "ahk_id " AnE5.getWinHwnd(),,1
if ErrorLevel
	return
goto GuiClose
}
return
GetClipboardAnzeigeNewP:
GetClipboardAnzeige:
IfNotExist %A_Temp%\Clipboard-Anzeige.txt
	FileAppend,Clipboard-Anzeige,%A_Temp%\Clipboard-Anzeige.txt,utf-16
IfNotExist %A_Temp%\Clipboard-Anzeige.txt
	MsgBox, 262144, Empfehlung:, Bitte folgende Frage mit Ja bestaetigen!, 5
Run,% "Notepad.exe" A_Space HK A_Temp "\Clipboard-Anzeige.txt" HK,,,DieseNotepadVarPID
WinWaitActive,ahk_pid %DieseNotepadVarPID%,,4
WinSetTitle, ahk_id %GuiWinHwnd%,,Modus: Clipboard-Anzeige fuer %DieseNotepadVarPID%
Sleep 100
Edit2:="Clip://`tMirr05? WConDef? Edit1,ahk_pid " DieseNotepadVarPID
gosub Edit2Festigen
sleep 1000
gosub GuiWinMin
WinSetTitle,% "ahk_pid " DieseNotepadVarPID,,Clipboard-Anzeige %DieseNotepadVarPID%
if(A_ThisLabel="GetClipboardAnzeigeNewP")
	gosub ZzoNewProcess
WinWaitClose,% "ahk_pid " DieseNotepadVarPID
; FileDelete,%ZzoHauptFensterHwndPfad%
; FileAppend,% GuiWinHwnd,% ZzoHauptFensterHwndPfad
goto GuiClose
return

ZzoNewProcess:
; FileDelete,%ZzoHauptFensterHwndPfad%
if ErrorLevel
	SoundBeep 300
; SoundBeep 600
RunOtherAhkScriptOrExe(A_ScriptFullPath,"Minimized")
Suspend,On
return

ifBildImPfad2Html(Pfad) {
	global IeBildExtList
	SplitPath,Pfad,,,Ext
	if Ext in %IeBildExtList%
	{
		return "<img src='" Pfad "' height='16' border='0'/>" A_Space Pfad
	}
	else
		return Pfad
}
BildUebersicht2Html(Pfad,Heigt=100) {
	global IeBildExtList
	SplitPath,Pfad,,,Ext
	StringReplace,Pfad,Pfad,<br>,,All
	if Ext in %IeBildExtList%
	{
		return "<img src='" Pfad "' height='" Heigt "' border='0'/>"
	}
	else
		return 
}


FuerIntegerMenu:
; pruefen ob sinnvoll in #. Menu anzubieten?
; ...
gosub IntegerMenuHandler
return

FuelleMitLeerzeichenBisSpalte(VarName,Spalte=100){
	global
	FuelleMitLeerzeichenBisSpalte_Rueck:=A_Space "                                                                                                                                                                                                                                                                                                            " A_space
	GefuelltAnz:=StrLen(%VarName%)
	ungefuelltAnz:=(Spalte-GefuelltAnz)*1.8
	try
	return %VarName% . SubStr(FuelleMitLeerzeichenBisSpalte_Rueck,1,ungefuelltAnz) ; . "````t"
}
GetMouseOverInfos:
; sleep 2000
MouseGetPos, MouseOverX, MouseOverY, MouseOverWinHwnd, MouseOverControlClassNN
; MsgBox % MouseOverX "," MouseOverY "," MouseOverWinHwnd "," MouseOverWinHwnd "," MouseOverWinClassNN "," MouseOverControlClassNN

; MouseGetPos, MouseOverX, MouseOverY, MouseOverWinClassNN, MouseOverControlClassNN,1
; MsgBox % MouseOverX "," MouseOverY "," MouseOverWinHwnd "," MouseOverWinHwnd "," MouseOverWinClassNN "," MouseOverControlClassNN
MouseGetPos, MouseOverX, MouseOverY, , MouseOverControlHwnd,2
; MsgBox % MouseOverX "," MouseOverY "," MouseOverWinHwnd "," MouseOverWinHwnd "," MouseOverWinClassNN "," MouseOverControlClassNN

; Sleep 2000
; MouseGetPos, MouseOverX, MouseOverY, MouseOverWinHwnd, MouseOverControlHwnd,3
; MsgBox % MouseOverX "," MouseOverY "," MouseOverWinHwnd "," MouseOverWinHwnd "," MouseOverWinClassNN "," MouseOverControlClassNN

ControlGetText,MouseOverControlText,,ahk_id %MouseOverControlHwnd%

WinGetTitle, MouseOverWinTitle, ahk_id %MouseOverWinHwnd%
WinGetClass, MouseOverWinClassNN, ahk_id %MouseOverWinHwnd%

; MsgBox % MouseOverControlText "," MouseOverWinTitle "," MouseOverWinHwnd "," MouseOverControlHwnd "," MouseOverWinClassNN "," MouseOverControlClassNN
return

getAllExplorerSelections(){

AllExplorerSeletions.=Explorer_GetSelected(DiesesWinHwnd)
for window in ComObjCreate("Shell.Application").Windows
{
	AllExplorerSeletions.=Explorer_GetSelected(window.hwnd) . "`r`n"
}
StringTrimRight,AllExplorerSeletions,AllExplorerSeletions,2
return AllExplorerSeletions
}

InNotepadZeigen:

IfWinNotExist % "ahk_pid " DieseNotepadVarPID
{
	Run,% "Notepad.exe" ,,,DieseNotepadVarPID
	WinWait,% "ahk_pid " DieseNotepadVarPID,,4
}
; sleep 600
if(InStr(Edit2,"Help_Quell.txt"))
	WinSetTitle,% "ahk_pid " DieseNotepadVarPID,,Assistent: Live-Suche     Inhalt noch nicht gespeichert!
else
	WinSetTitle,% "ahk_pid " DieseNotepadVarPID,,% "Edit5: " A_Now "    Inhalt noch nicht gespeichert!"
; sleep 300
if not(instr(Edit5,"`r"))
	StringReplace,Edit5A,Edit5,`n,`r`n,All
else
	Edit5A:=Edit5
ControlSetText,Edit1, %Edit5A%,% "ahk_pid " DieseNotepadVarPID
return


LiveSuchAssistentAnzeigeVar:
Help_Quell_Inhalt=
(
%LiveSucheAufbauString%
.	; ^clear^
.	; Anleitung:	F2 druecken und	Zeilen  mit >Teil-Begriffen< filtern wie sonst auch, Filter-Vorschlag 1 >:/<		folgende >?<
	; (z.B:	Clip,Win,Control,Text,File,Dir,Htm,Mirr,Path,Sel,Hwnd,Title,Pic,Inhalt,Name,Row,Edit,Loop,IE,Pattern)
.	; mit (den Pfeiltasten) zum gewünschten Eintrag und erneut   Menü | Filter | Suchassistent Live-Suche   aufrufen,
.	; so oft bis <LiveSucheAufbauString> oben fertig. Dann die 1. Zeile auswaehlen und mit [Button Explorer] übernehmen.
; Inhalt:	Hilfs-Assistent der Live-Suche: 	oben Quellen der Suche (erkennbar an ://)	darunter die Filter, Methoden etc. (erkennbar am Fragezeichen?)
.	;	Da war die Maus drueber ---------------------------------------------------
%WitchControlDefKenner%%A_Space%%MouseOverControlClassNN%,ahk_class %MouseOverWinClassNN%
%WitchControlDefKenner%%A_Space%%MouseOverControlClassNN%,%MouseOverWinTitle%
%WitchControlDefKenner%%A_Space%%MouseOverControlClassNN%,ahk_id %MouseOverWinHwnd%
%WitchControlDefKenner%%A_Space%,ahk_id %MouseOverControlHwnd%
.	;	Clipboard: ------------------------------------------------------------
%ClipKenner%						;	Der Clipboard-Inhalt wird hier (in Edit5) angezeigt
%ClipKenner%``t						;	dito selbst aktualisierend
%ClipKenner%``v%InRowKenner%%A_Space%Ø¯⁞¯Ø		;	nur Zeilen die den ⁞-Begriff enthalten werden angezeigt.
`v%ClipE5WriteKenner%				;	beschreibt das Clipboard
.	;	Einzel-Datei: ------------------------------------------------------------
%FileKenner%						;	Gesucht wird in einer Datei
%FileKenner%<Pfad>				;	mit dem Pfad
%FileKenner%%A_ScriptFullPath%``vNr_Row? Ø¯⁞¯Ø			;	Nummeriere Anzeige; gesucht wird der vor ⁞ einzugebende Begriff in der ganzen Zeile
.	;	Datei-/Ordner-Bündel: ------------------------------------------------------------
%FilePatternKenner%						;	+++++++<StartDirPath><Muster>,<Optionen>		->		+++++++<StartDirPath>\*ØØ¯⁞¯ØØ*,Ø¯DFR¯Ø			AlternativBezeichnung: <FilePattern> = <StartDirPath><Muster> = <StartDirPath>\*ØØ¯⁞¯ØØ*
\*ØØ¯⁞¯ØØ*,Ø¯DFR¯Ø	; %FilePatternKenner%<StartDirPath>+++++++++++++++
	;  ^welche^ Dateien werden beruecksichtigt.
``tIn_Row? Ø¯¯Ø			;	%FilePatternKenner%	StartDirPath><Muster>,<Optionen>++++++++++++++							Anschliessend ist noch NachFilter ueblich
.		weitere Erklaerungen folgen: ------------------------------------------------------------
%ControlTextKenner%%WitchControlDefKenner%%A_Space%<Control>,<WTitle>,<WText>			;	ControlTextKenner
CoTe://WConDef? Edit10,A	;	Funktionierendes Beispiel: Spiegelt Edit10 nach Edit5
%ContainerKenner%						;	ContainerKenner (damit kann die Cacchesuche nachgebildet werden)
%ExplorerSelectedKenner%					;	ExplorerSelectedKenner zur Anzeige muss wenigstens eine Datei im obersten Explorer selektiert sein.
%IeExistKenner%						;	IeExistKenner zur Anzeige muss ein Internet Explorer geoeffnet sein. Internet, Explorer, Browser, Html, Https, ftp 
%HwndTextKenner%<Quell_HWND>	;	HwndTextKenner dazu muss jeweis ein frisches HWND bspw. mit [Win] + [v] besorgt werden.
%WinMgmtsKenner%					;	WinMgmtsKenner (primitiv Task-Manager)
%HTTPKenner%ok.de				;	HTTPKenner
.	;	NachFilter und mehr -------------------------------------------------------------------
``v%2HtmlKenner%				;	versucht das Ergebnis als HTML-Tabelle auszugeben
``vHtmPicView? 300		;	zeigt Bilder im IE von Pfaden, hier Bildhoehe 300 Pixel
``vHtmPicView? %A_ScreenHeight%``vHtmDiaShow? 	;	zeigt Dia Show im IE
``v%2ZeilenInhaltKenner%					;	gibt Inhalte gekuerzt aus 
``v%AlleInfosKenner%					;	gibt viele Daten zu Pfaden aus
``v%HtmlPathesOutKenner%					;	gibt Pfade im IE aus
``v%HtmlPathesBilderuebersichtKenner%			;	gibt Bilder und sonst nichts im IE aus
``v%InInhaltKenner% Ø¯⁞¯Ø			;	gibt Inhalte aus und filtert nach Inhalt
``v%InInhaltQuelleKenner% Ø¯⁞¯Ø			;	gibt Inhalte und QuellPfad aus und filtert nach Inhalt
``v%InNameKenner% Ø¯⁞¯Ø			;	Filtert nach Ordner-/Dateiname
``v%InRowKenner% Ø¯⁞¯Ø			;	gibt (Pfade) aus filtert ueber die gesammte (Pfad-)Zeile
``v%MacroAufuehrenKenner%  			   ;	wird intern benoetigt, um Macros in Einzelschritten ab zu arbeiten.
``v%MirrorEdit5Kenner% <Ziel_HWND>		;	oder		;	spiegelt das (Zwischen-) Ergebnis von Edit5 zu einem Control
``v%MirrorEdit5Kenner% %WitchControlDefKenner% <Control>,<Fenstertitel>,<Fenstertext>,<Titelausnahme>,<Textausnahme>
``v%MirrorEdit8Kenner% <Ziel_HWND>	;	spiegelt das (Zwischen-) Ergebnis von Edit8 zu einem Control
``v%NrInhaltKenner% Ø¯⁞¯Ø			;	gibt Nummeriert aus filtert ueber die Inhalts-Zeilen
``v%NrRexKenner% Ø¯⁞¯Ø		;	noch nicht auf die neue Live-Suche portiert.
``v%NrRowKenner% Ø¯⁞¯Ø		;	gibt Nummeriert aus filtert ueber die gesammte (Pfad-)Zeile
``v%LoopKenner% %ViaTimerKenner%_-Edit2	;	Endlosschleife mit Aktualisierung
``v%SortKenner% %ViaTimerKenner%			;	der Timer wird momentan fuers Sortieren benoetigt
``v%SortKenner% %ViaTimerKenner%SortLenAlle	;	sortiert nach StrLen 
SortBS						;	Sortieren nach dem Ordnername ohne Pfad
SortR						;	Sortierung Alphabetisch z...a
SortLen					;	Sortieren nach StrLen
SortMTime					;	Sortieren nach Modification Time neu oben
SortMTimeR				;	Sortieren nach Modification Time alt oben
SortBestAutoBewertung	;	Sortieren nach Bewertungskriterien	; die AutoBewertung ist nicht fuer die Livesuche programmiert!
SortLenAlle
SortMTimeAlle			;	sortiert nach modification Time 
SortMTimeAlleR			;	sortiert nach modification Time recursiv
%WitchControlDefKenner% Ø¯⁞¯Ø,Ø¯¯Ø,Ø¯¯Ø,Ø¯¯Ø,Ø¯¯Ø		;	<Control>,<Fenstertitel>,<Fenstertext>,<Titelausnahme>,<Textausnahme>	Die nicht benötigten Elemente können samt Komma weggelassen weerden.
%ControlKenner% Ø¯⁞¯Ø	; <Control>
%WinTextKenner% Ø¯⁞¯Ø 		;	<Fenstertext>
%WinTitleKenner% Ø¯⁞¯Ø		;	<Fenstertitel>
``v%WinAnWinKenner% %WitchWindowDefKenner%,,,%A_Tab%%WitchWindowDefKenner%,,,
``V%WinOverWinKEnner% %WitchWindowDefKenner%,,,%A_Tab%%WitchWindowDefKenner%,,,
%WinAnWinKenner% %WitchWindowDefKenner%111,222,333,444 %A_Tab%%WitchWindowDefKenner%aaa,bbb,ccc,ddd
Ø¯⁞¯Ø		Ziel fuer Schreibmarke, Caret. wenn Fokus ausserhalb Edit2. Wenn F2 gedrueckt wird springt die Schreibmarke direkt vor ⁞, innerhalb springt ⁞ zur Schreibmarke
ØØ¯⁞¯ØØ		Dito, wobei die Suche bei Verwendung (wesentlich) schneller wird. Die Zeichen selbst sind suchneutral, d.h. sie werden vor der eigentlichen Suche entfernt.
.		in Planung ------------------------------------------------------------
``v%InInhaltKennerNotShowPath%   			;   reserviert
``v%HelpZuKenner%       		 ;   reserviert
``v%HelpKenner%				; reserviert fuer Kombination von Kenner drueber und Kenner drunter
``v%OnEventKenner%   		    ;   reserviert
%WitchWindowDefKenner% Fenstertitel,Fenstertext,Titelausnahme,Textausnahme          reserviert
%HTTPSKenner%					;	HTTPSKenner   Reserviert
ftp://					;	reserviert
mailto://				;	reserviert
sendto?					;	reserviert
.	;	Suchspeicher -------------------------------------------------------------
clip://	``vMirr05? WConDef? ,ahk_id 0x10209a8		;	leitet eine Selbst aktualisierende Clipboard-Anzeige an das Control mit der HWND 0x10209a8 weiter (positiv getestet mit Notepad)
ExSel://`vAllInfo?		; 	gibt infos aus, zu selectierten Explorerpfaden
ExSel://`vAllInfo?`vLoop? ViaTimer_-Edit2		; dito in endlos-Schleife
FilP://%HomeDir%\Pictures\*ØØ¯⁞¯ØØ*,Ø¯DFR¯ØIn_Row? Ø¯⁞¯ØHtmPicView? %A_ScreenHeight%HtmDiaShow? 
FilP://C:\Program Files (x86)\ZackZackOrdner\*ØØ¯.ahk¯ØØ*,Ø¯DFR¯Ø`vInInhQ? Ø¯StringSplit`n⁞OhneHochKomma`nSuchtext¯Ø		; in welchen ScriptVersionen kamen die 3 Begriffe 	StringSplit	OhneHochKomma	Suchtext	 in einer Zeile vor. Ergebnis seit Version 0.369
WiMg://``vFileE5Write? C:\Temp\Schreibtest\Clipboard.txt		;  Achtung hier wird eine Datei falls vorhanden gelöscht und dann neu beschrieben.
			; 	bei Handbefuellung von Edit2 muss der Haken warte gesetzt sein, damit waehrend des schreibens c:\... nichts schlimmes passiert.
.	;	Labels ----------------------------------------------------------------- zum Starten Label im nicht Anfaenger Modus in Edit4 gefolgt von einem Punkt eingeben. Alternativ Label in ein Macro schreiben.
GetClipboardAnzeigeNewP									;	Clipboard-Spiegelung in Notepad
GetExplorerSelectDetailsNewP							;	infos zu Selektierten Explorer-Pfaden
GetExplorerSelectDetailsPicNewP							;	infos zu Selektierten Explorer-Pfaden + Bilder-Ueberblick	; wenn Notepad geschlossen wird: Nur Bilder-Ueberblick von selektierten Explorer-Pfaden 	
.	;	Pfade ------------------------------------------------------------------
%A_AppData_100%	PFadListe	PathList
%A_AppDataCommon_100%	PFadListe	PathList
%A_MyDocuments_100%	PFadListe	PathList
%A_ProgramFiles_100%	PFadListe	PathList
%A_Programs_100%	PFadListe	PathList
%A_ProgramsCommon_100%	PFadListe	PathList
%A_Temp_100%	PFadListe	PathList
%A_WinDir_100%	PFadListe	PathList
%A_WorkingDir_100%	PFadListe	PathList
%A_SystemDrive_100%	PFadListe	PathList
%A_HomeDir_100%	PFadListe	PathList
%AllExplorerSelections%
%ControlTextKenner%%WitchControlDefKenner%%A_Space%%MouseOverControlClassNN%,ahk_class %MouseOverWinClassNN%			ControlTextKenner,WitchControlDefKenner,MouseOverControlClassNN,ahk_class MouseOverWinClassNN
%ControlTextKenner%%WitchControlDefKenner%%A_Space%%MouseOverControlClassNN%,%MouseOverWinTitle%			ControlTextKenner,WitchControlDefKenner,MouseOverControlClassNN,MouseOverWinTitle
%ControlTextKenner%%WitchControlDefKenner%%A_Space%%MouseOverControlClassNN%,ahk_id %MouseOverWinHwnd%			ControlTextKenner,WitchControlDefKenner,MouseOverControlClassNN,ahk_id MouseOverWinHwnd
%ControlTextKenner%%WitchControlDefKenner%%A_Space%,ahk_id %MouseOverControlHwnd%			ControlTextKenner,WitchControlDefKenner,ahk_id MouseOverControlHwnd

``v%MirrorEdit5Kenner% %WitchControlDefKenner%%A_Space%%MouseOverControlClassNN%,ahk_class %MouseOverWinClassNN%			MirrorEdit5Kenner,WitchControlDefKenner,MouseOverControlClassNN,ahk_class MouseOverWinClassNN
``v%MirrorEdit5Kenner% %WitchControlDefKenner%%A_Space%%MouseOverControlClassNN%,%MouseOverWinTitle%			MirrorEdit5Kenner,WitchControlDefKenner,MouseOverControlClassNN,MouseOverWinTitle
``v%MirrorEdit5Kenner% %WitchControlDefKenner%%A_Space%%MouseOverControlClassNN%,ahk_id %MouseOverWinHwnd%			MirrorEdit5Kenner,WitchControlDefKenner,MouseOverControlClassNN,ahk_id MouseOverWinHwnd
``v%MirrorEdit5Kenner% %WitchControlDefKenner%%A_Space%,ahk_id %MouseOverControlHwnd%			MirrorEdit5Kenner,WitchControlDefKenner,ahk_id MouseOverControlHwnd
)
return


IntegerDotMenu:
Edit3:=A_ThisMenuItemPos
gosub Edit3Festigen
ThisGuiControl:=ThisGuiControl + (A_ThisMenuItemPos-1)
if(ThisGuiControl=0)
{
	if IntegerRechtsKlickMenu
		IntegerRechtsKlickMenu:=false
	else
		IntegerRechtsKlickMenu:=true
	Menu, IntegerMenue,Show
	Exit
}
else if IntegerRechtsKlickMenu
{
	gosub IntegerMenuHandler
	Menu, IntegerMenu, Show 
}
else
{
	Edit3:=ThisGuiControl
	gosub Edit3Festigen
}
IntegerRechtsKlickMenu:=false
return

; IntegerMenuHandler
	
IntegerMenue2:
ThisGuiControl:=(A_ThisMenuItemPos-1)*10
Menu, IntegerMenue2, Show 
IntegerRechtsKlickMenu:=false

return

GetWinHwndVonLiveSucheTeilstring(LiveSucheTeilstring,BeginnKennerIgnorierListe="",ByRef DieserControlKennerInhalt=""){
	global
	local Def,Aufgabe,Erg,Ig,Pos,WinTextKennerInhalt,Super,Super2
	if Fehlersuche
	{
		RunOtherAhkScriptOrExe(ExternalToolTipPath,"Eingang Funktion GetWinHwndVonLiveSucheTeilstring(" LiveSucheTeilstring "," BeginnKennerIgnorierListe "," DieserControlKennerInhalt)
		Sleep 10000
	}
	Aufgabe:=LiveSucheTeilstring
	if (BeginnKennerIgnorierListe="")
		BeginnWortIgnorierListe:="ExplorerSelectedKenner,ControlTextKenner"
	Ig:=StrSplit(BeginnWortIgnorierListe,",")
	Loop % Ig.MaxIndex(){
		DieserLenKenner:=Ig[A_Index] . "Len"
		Super:=Ig[A_Index]
		Super:=%Super%
		Super2:=%DieserLenKenner%
		
		if(SubStr(Aufgabe,1,%DieserLenKenner%)=Super){
			StringTrimLeft,Aufgabe,Aufgabe,%Super2%
			Aufgabe:=Trim(Aufgabe)
		}
	}
	
	if(InStr(SubStr(Aufgabe,1,WitchControlDefKennerLen+1),WitchControlDefKenner)){	; CoTe://WConDef? ,ahk_id 0x90030
		StringReplace, Aufgabe, Aufgabe,% WitchControlDefKenner
		Def:=StrSplit(Aufgabe,",")
		DieserControlKennerInhalt:=trim(Def.1)
		; WitchControlDefKenner:=DieserControlKennerInhalt
		Def2:=Def.2
		Def3:=Def.3
		Def4:=Def.4
		Def5:=Def.5
		if(InStr(Def2,"ahk_id ") AND DieserControlInhalt="" AND Def3="" AND Def3="" AND Def4="" AND Def5="")
		{
			StringReplace,DiesesWinHwnd,Def2,ahk_id
			DiesesWinHwnd:=Trim(DiesesWinHwnd)
			DieseControlClass:=GetClassName(DiesesWinHwnd)
			if(DieseControlClass="SysListView32")
				DieseControlClass:="SysListView321"
			DieserControlKennerInhalt:=DieseControlClass
			return DiesesWinHwnd
			; WinGet, DieserControlInhalt ,List,,ahk_id %DieserKennerInhalt%		; liefert die 1 wenn HWND gueltig
			; WinGet, DieserControlInhalt ,ID,,ahk_id %DieserKennerInhalt%		; liefert die win Parend  HWND  wenn HWND gueltig
			; WinGetClass,holla,ahk_id %DiesesWinHwnd%
			; WinGetClass,ParentClass,ahk_id %ParentHwnd%
		}
		ControlGet,DiesesWinHwnd,HWND, ,% DieserControlKennerInhalt, % Def2 , % Def3 , % Def4 , % Def5 
		; WinGet,DiesesWinHwnd,ID, % DieserControlKennerInhalt, % Def2 , % Def3 , % Def4 
		IfWinExist,ahk_id %DiesesWinHwnd%
			Erg:=true
	}
	else if(InStr(SubStr(Aufgabe,1,WitchWindowDefKennerLen+1),WitchWindowDefKenner)){
		StringReplace, Aufgabe, Aufgabe,% WitchWindowDefKenner
		Def:=StrSplit(Aufgabe,"`,")
		WinGet,DiesesWinHwnd,ID,% Def.1,% Def.2,% Def.3,% Def.4
		IfWinExist,ahk_id %DiesesWinHwnd%
			Erg:=true
	}
		else if(InStr(SubStr(Aufgabe,1,WinTitleKennerLen+1),WinTitleKenner) AND InStr(Aufgabe,WinTextKenner)){
		; StringReplace, Aufgabe, Aufgabe,% WinTitleKenner ; weglassen da unten behandelt
		Pos:=InStr(Aufgabe,WinTextKenner)
		if Pos{
			WinTitleKennerInhalt:=SubStr(Aufgabe,WinTitleKennerLen,Pos-1)
			WinTextKennerInhalt:=SubStr(Aufgabe,Pos+WinTextKennerLen)
			WinGet,DiesesWinHwnd,ID,% WinTitleKennerInhalt,% WinTextKennerInhalt
			IfWinExist,ahk_id %DiesesWinHwnd%
				Erg:=true
		}
		else if(InStr(SubStr(Aufgabe,1,WinTitleKennerLen+1),WinTitleKenner)){
		; tringReplace, Aufgabe, Aufgabe,% WinTitleKenner ; weglassen da unten behandelt
			WinTitleKennerInhalt:=SubStr(Aufgabe,WinTitleKennerLen)
			WinGet,DiesesWinHwnd,ID,% WinTitleKennerInhalt
			IfWinExist,ahk_id %DiesesWinHwnd%
				Erg:=true
		}
	}		
	if Erg
		return DiesesWinHwnd
	else
	{
		RunOtherAhkScriptOrExe(ExternalToolTipPath,"WinHwnd konnte nicht aus`n`n>" LiveSucheTeilstring "<`n`nermittelt werden")
		return "Error"
	}
}
;http://www.autohotkey.com/board/topic/45515-remap-hjkl-to-act-like-left-up-down-right-arrow-keys/#entry283368
GetClassName( hwnd )
{ ; returns HWND's class name without its instance number, e.g. "Edit" or "SysListView32"
	VarSetCapacity( buff, 256, 0 )
	DllCall("GetClassName", "uint", hwnd, "str", buff, "int", 255 )
	return buff
}