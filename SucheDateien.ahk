; Hauptprogramm ############################################
#SingleInstance off

; MsgBox % A_IsUnicode ? "Unicode" : "ANSI"

VlCWaitListVorlage=mov,avi,m2t,mpg,mpeg,asf,wmv,ts,mp4
VlCWaitList=%VlCWaitListVorlage%
BildEigenListVorlage=jpg,bmp,gif
BildEigenList:=BildEigenListVorlage
MusikEigenList=mp3,wav
DefaultWarteBildEigen:=3000
WarteVomScriptDefault:=7123
IfExist SucheDateien.ico
	Menu,Tray,icon,SucheDateien.ico

; +++++++++++++ Checkbox-Übersicht +++++++++++++
; sub	Checkbox0=1		in mit Unterordner
; Typen	CheckboxTypen=0		in nur Typen
; +	CheckboxF=1		in auch Folder
; -Icon	CheckboxOhneIcon=1	in mit Icons
; 1	Checkbox1=0		Filter: Name
; 2	Checkbox2=0		Filter: Folder
; txt	CheckboxTxt=0		Filter: Typ
; sel	CheckboxSel=0		filtern: behalten/markieren/markierte erneut filtern
; r	CheckboxR=0		Befehle aufzeichnen

HtmlHilfe1=
(
<html>
<head>
<title>SucheDateien</title>
<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1">
</head>

<body bgcolor="#FFFFFF" text="#000000">
<h1>SucheDateien </h1>
<p>ist ein Programm zur ordner&uuml;bergreifenden Anzeige von Dateien. Mit m&auml;chtigen
  Filtern kann man die Anzeige leicht auf die gesuchten einschr&auml;nken.</p>
<h2>Bedienung</h2>
<p>Mit dem Button <i><b>Load Folder</b></i> l&auml;d man sich alle Dateien eines
  Ordners (<i>sup</i> gehakt inklusive Unterordner) zu den bestehenden in die
  Anzeigeliste, wenn <i>Typen</i> gehakt ist nur Dateien mit Endungen die zuvor mit
  dem Button <i>Typ</i> eingestellt wurden (Hinweis: wenn die Typ-Abfrage mit
  Cancel verlassen wird, werden die Typen gesetzt, aber nicht gefiltert.).<br>
  Mit den Button&acute;s <i><b>Filter/<a href="#RegEx">Spez</a>/Typ</b></i> entfernt
  man nicht den Filterkriterien entsprechende Einträge.<br>
  Was durchsucht wird kann mit den Haken <i>1</i>, <i>2</i> und <i>txt</i> beeinflusst
  werden (gilt nicht f&uuml;r Typ).
<table border="1">
  <tr>
    <td><b>Haken</b></td>
    <td><b>1</b></td>
    <td><b>2</b></td>
    <td><b>txt</b></td>
  </tr>
  <tr>
    <td rowspan="2"><b>Wirkung</b></td>
    <td>Spalte<br>
      <b>Name</b> </td>
    <td>Spalte<br>
      In <b>Folder</b></td>
    <td><b>Text-Inhalt</b><br>
      (bei ausgew&auml;hlten Dateitypen, siehe Rechtsklick auf <i>txt</i>)</td>
  </tr>
  <tr>
    <td colspan="3">
      <div align="center">wird durchsucht. <br>Wenn nichts gehakt ist, wird die Suche nach <b>Änderungszeit</b> und <b>Dateigröße</b> möglich.</div>
    </td>
  </tr>
</table>
<p>Mit dem Haken <i>-Icon</i> kann in einigen Fällen ein deutliche Performanze-Steigerung
  erreicht werden, dabei verliert man allerdings 
  (wie bei einigen anderen Aktionen) die Icons. <br>
  Ohne Haken steigt das Skript bei vielen Bild-Dateien ohne Meldung aus, 
  ich vermute, dass der betriebsystemseitige Speicher für Vorschaubilder begrenzt ist.</p>
<p>Mit dem Haken <i>sel</i> werden die Fundstellen nur markiert.
  Zweimaliges anklicken von <i>sel</i> sucht nur in den Markierten. </p>
<p>Mit dem Button <b>Opti</b> werden die Spaltenbreiten der Listenansicht veraendert:<br>
- Linkklick -> Spaltenbreite an Inhalte anpassen<br>
- Rechtklick -> Anzeige innerhalb der Listenansicht (Kompromiss).<br>
Button <b>Switch</b> schaltet zwischen <i>grossen Icons</i> und <i>Details</i> bei der Liste um.</p>
<p><b>Drag and Drop</b> von Dateien oder Ordnern in die Anzeigeliste f&uuml;gt
  die gedropten hinzu.</p>
<p><b>Rechtsklick</b> in die Anzeigeliste zeigt weitere Befehle an.
Die Befehle werden mit allen selektierten Listenelementen durchgeführt.
Nach 5 mal kommt bei manchen eine Sicherheits-Abfrage.<br>
Mit den Tasten <i>Return</i> oder <i>Enter</i>
(bzw. Doppelkick auf ein Listenelement) wird <b>Open</b> vom Kontextmenü aufgerufen,
allerdings nur mit dem einen Listenelement im Fokus.</p>
<p>Mit <b>Rechtsklick</b> auf Button <b>Load folder</b> lassen sich Google-Fundstellen herunterladen und genauer untersuchen.<br>
(Hinweise: -Klappt nicht bei manchen Proxy-Einstellungen<br>
- zeitintensiv)</p>
<h2>Speichern</h2>
<p>Mit den Buttons <b><i>Sichern</i></b> und <b><i>Wiederherstellen</i></b> kann
  ein Sicherungsstand im Hauptspeicher verwaltet werden.</p>
<p>Mit den Buttons <i><b>save</b></i> und <b><i>open</i></b> k&ouml;nnen im Dateisystem
</p>
<ol>
  <li>Sicherungsst&auml;nde verwaltet werden (Endung: <b>lst</b>)</li>
  <li>Automatische Suchen ge&ouml;ffnet werden (Endung: <b>do</b>)</li>
  <li>Filter verwaltet werden (Endungen <b>filter</b>, <b>spez</b>, <b>typ</b>)</li>
  <li>Vordefinierte Ausgabedateien (momentan nur <b>m3u</b>) erzeugt werden</li>
  <li>flexible Ausgabedateien (andere Endungen) erzeugt werden,<br>
    dabei kann das Ausgabeformat ver&auml;ndert werden:<br>
    <samp>%S2%\%S1%%A_Tab%%S3%%A_Tab%%S4%%A_Tab%%S5%%CR%</samp><br>
    <table border="1">
      <tr>
        <td><b>Code</b></td>
        <td><b>Bedeutung</b></td>
      </tr>
      <tr>
        <td><code>%S#%</code></td>
        <td>Element aus Spalte #</td>
      </tr>
      <tr>
        <td><code><samp>%A_Tab%</samp></code></td>
        <td>Tabulator-Zeichen</td>
      </tr>
      <tr>
        <td><code><samp>%A_Space%</samp></code></td>
        <td>
          <p>Leerzeichen</p>
        </td>
      </tr>
      <tr>
        <td><code><samp>%CR%</samp></code></td>
        <td>Neue Zeile</td>
      </tr>
      <tr>
        <td>andere Zeichen</td>
        <td>die Zeichen selbst</td>
      </tr>
    </table>
  </li>
</ol>
<p>Beim speichern mit Fremd-Endungen wird noch f&uuml;r 10sec gefragt ob die frisch
  erzeugte Datei der Standart-Anwendung &uuml;bergeben werden soll. Dies ist z.B.
  f&uuml;r <b>m3u</b> zum Ansehen/-h&ouml;ren von Multimedia-Dateien sinnvoll.</p>
<p>Hinweise: </p>
<ul>
  <li>Dateien k&ouml;nnen auch per Drag and Drop auf den Button <b><i>Open</i></b>
    gezogen werden</li>
  <li>Mit Rechtsklick auf Button <i><b>Save</b></i> l&auml;sst sich das Augabeformat
    (5.) editieren.</li>
  <li>Bei allen R&uuml;ck-Speicherarten gehen die Icons verloren.</li>
</ul>
<h2>Multimedia</h2>
<p>Bild- und Ton-Dateien, die das Betriebssystem unterstützt, 
können von jeweils einem Skript eigenen Player wiedergegeben werden:<br>
Rechtsclick auf markierte Dateien | Öffnen<br>
Film-Dateien, die von VLC unterstützt werden,
können an VLC weitergereicht werden:<br>
Rechtsclick auf markierte Dateien | Öffnen</p>
<p>Die jeweiligen Variablen<br>

BildEigenList (Voreinstellung: %BildEigenList%)<br>
MusikEigenList (Voreinstellung: %MusikEigenList%)<br>
VlCWaitList (Voreinstellung: %VlCWaitList%)<br>

geben an welche Datei-Typen womit unterstützt werden.

 </p>
<p></p>
<p></p>
)
HtmlHilfe2=
(
<h2>F&uuml;r Poweruser</h2>
<h3>Folder.txt</h3>
<p>Mit der Datei<br>
  &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<samp>%A_MyDocuments%\SucheDateien\Folder.txt</samp><br>
  l&auml;sst sich bei <i>Load folder</i> das Einlesen vordefinierter Ordner 
  unterst&uuml;tzen. Eine Zeile von Folder.txt hat folgende Syntax:<br>
  <samp>ZeilenNr: Tabulator OrdnerGesamtPfad</samp><br>
  Die Zeilennummer muss der realen Zeilennummer beginnend mit 1 entsprechen.<br>
  Danch folgt Tabulatorgetrennt der vollst&auml;ndige Pfad des Ordners, der durch 
  die Eingabe der Zeilennummer vorausgew&auml;hlt werden kann. Im vollst&auml;ndigen 
  Pfad des Ordners sind Variablen erlaubt.</p>
<p>Beispiel f&uuml;r <samp>Folder.txt</samp>:<br>
  ----------------------------</p>
<pre>
1	c:\temp
2	%A_WinDir%
3	%A_ProgramFiles%
4	%A_AppData%
5	%A_AppDataCommon%
6	%A_StartMenu%
7	%A_StartMenuCommon%
8	`%A_MyDocuments`%
9
andere letzten Ordner verwenden</pre>
<p>----------------------------</p>
<p>Nach klick auf <i>Load folder</i> kommt eine Ordner-Vorauswahl-Box. In diese 
  lassen sich dann die Zeilennummer(n) eintragen. Mehrere werden Leeerzeichen-getrennt. 
  Auch an eienen einzelnen Ordner kann ein Leerzeichen angeh&auml;ngt werden. 
  Dadurch beginnt das Einlesen vordefinierter Ordner sofort. Der direkte Pfadeintrag eines Ordners ist hier auch erlaubt (Pfad ausschließlich oder Nummern).<br>
  <b>Doppelte Dateien suchen</b> kann man, wenn am Zeilenbeginn ein ":" eingetragen wird.<br>
  Z.B.<br>
  <b>:</b>c:\temp<br>
  Achtung:<br> :1 3 4<br>
  Liefert nacheinander nur die Doppelten von der Auswahl 1 getrennt von der Auswahl 3 getrennt von der Auswahl 4.<br>
  <b>Doppelte Dateien durch Links ersetzen</b> kann man,
  indem man die Dateien gleichen Hash-Codes Markiert 
  und mittels Rechtsklick auf <i>ErzeugeMehrfachLink</i> bearbeitet.
  Die Datei mit dem Fokus bleibt original 
  (bzw. erhält zusätzlich den Hashcode im Dateiname, 
  nur wenn die Variable <code>HaschEinfuegen=ja</code> gesetzt wurde),
  alle anderen werden zu Links die auf die Fokus-Datei verweisen.
  Den Fokus erhält die Datei auf die der Rechtsklick erfogt, 
  wenn keine Taste dabei gedrückt wird.<br>
  Zum Rückgängig machen d.h. <b>Aus Links die Originale erzeugen</b>
  kann auf die markierten Links (Rechtsklick) <i>Link2Org</i> angewand werden.
  Die Frage nach dem Speicher-Ordner für die Originale ist dann mit Button <i>Cancel/Abbrechen</i> zu verlassen.</p>
<h3>Fenstertitel-Merker</h3>
<p>Mit einem Rechtklick auf den Fensterrand, 
laesst sich der Fenstertitel aendern.
Dies ist bei laenger dauernden Suchen (oder mehreren offenen Suchfenstern) sinnvoll 
um den Ueberblick zu behalten. <br>
Hinweise:<br>
- Rechtsklick auf den Fenstertitel selbst funktioniert momentan leider nicht!<br>
- Der Fenstertitel kann meist auch gesetzt werden während <i>besch&auml;ftigt</i> angezeigt wird.
</p>
<h3>Beliebige Variable setzen</h3>
<p>
Mittels Rechtsklick in die Listenansicht und auswahl <i>Replace...</i> oder <i>Rename...</i>
kann eine Variable gesetzt werden. Dazu löscht man aus der Eingabe-Box alle Variablen und traegt die gewuenschte in der Schreibweise<br>
VariablenName=VariablenInhalt<br>
ein.
Man sollte allerdings genau wissen was man macht, denn es erfolgt keine Sicherheitspruefung. 
</p>
<h3>Automatisierte Suche</h3>
<p>Man kann sich wiederholende Suchvorg&auml;nge skripten, dazu dienen *.do Dateien.<br>
  Aufbau:</p>
<table border="1">
  <tr>
    <td><b>Erlaubt</b></td>
    <td><b>Wirkung</b></td>
  </tr>
  <tr>
    <td>Variable=Wert</td>
    <td>Setzt die Variable</td>
  </tr>
  <tr>
    <td>Fullpath</td>
    <td>L&auml;d die Datei oder den Ordner</td>
  </tr>
  <tr>
    <td>Label</td>
    <td> Gosub Label</td>
  </tr>
</table>
<p>Beispiel:<br>
</p>
<table border="1">
  <tr>
    <td><b>Quelltext</b></td>
    <td><b>Wirkung</b></td>
  </tr>
  <tr>
    <td>ButtonClear<br>
      CheckboxSub=1<br>
      CheckboxTypen=0<br>
      C:\Users\Gerd\Eigene Dateien<br>
      \\Server\Freigabe<br>
      F:<br>
      CheckboxOhneIcon=1<br>
      Checkbox1=1<br>
      Checkbox2=1<br>
      CheckboxTxt=1<br>
      SomeFilterTextSpez=i)(Release|Update|Version).*?(Liste|Plan|Konzept)<br>
      ButtonSpezOhneInput</td>
    <td>
      <p>leert Liste<br>
        hakt sub<br>
        enthakt Typen<br>
        l&auml;d Ordner<br>
        l&auml;d Ordner<br>
        l&auml;d Ordner<br>
        hakt -Icon<br>
        hakt 1<br>
        hakt 2<br>
        hakt txt<br>
        setzt Filer-Variable<br>
        springt zu Button Spez nach die Eingabe</p>
    </td>
  </tr>
</table>
<p>Die Erstellung von *.do-Dateien kann mit dem Haken vor <b><i>r</i></b> unterst&uuml;tzt 
  werden:</p>
<ul>
  <li>gehakt -&gt; zeichnet <a href="#AA">ausgew&auml;hlte Aktionen</a> auf</li>
  <li>Rechtsklick auf <b><i>r</i></b> erzeugt die *.Do-Datei<br>
    - Cancel in der Dateiauswahl erm&ouml;glicht es die Aufzeichnung zu verwerfen.</li>
</ul>
<p><a name="AA"></a>Ausgew&auml;hlte Aktionen -&gt; momentan werden unterst&uuml;tzt:</p>
<ol>
  <li>Button <i>Load Folder</i></li>
  <li>Button <i>Clear List</i></li>
  <li>Button <i>Filter</i></li>
  <li>Button <i>Spez</i></li>
  <li>Button <i>Typ</i></li>
  <li>alle Haken au&szlig;er <i>r</i> (Die Haken werden nur tempor&auml;r nicht 
    sichtbar beim Skriplauf gesetzt)</li>
  <li>Kontextmen&uuml; <i>Select All</i></li>
  <li>Kontextmen&uuml; <i>DeSelect All</i></li>
  <li>Kontextmen&uuml; <i>Erzeuge Link</i></li>
  <li>Kontextmen&uuml; <i>FileCopy</i> </li>
</ol>
<h3><a name="RegEx"></a>RegExMatch Suche</h3>

<p>Mit dem Button <i>Spez</i> ist die RegEx Suche erreichbar:
<pre>
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
i)(Grrdi|Gerdi|Gerda)	findet wenn enthält	Grrdi oder Gerdi oder Gerda	groß/klein egal
i)(Manual|Handbuch|Beschreibung|Einf(ü|ue)hrung)	Ineinanderschachtelung möglich
^ItilZertGrrdi\.TIF$	findet exakt	ItilZertGrrdi.TIF
i)^ItilZertGrrdi\.TIF$	findet 	ItilZertGrrdi.TIF	groß/klein egal
</pre>

<h2>Haftungsausschluss</h2> 
<p>Es wird keinerlei Haftung für Schäden 
die durch dieses Programm entstehen können übernommen.
Die Benutzung erfolgt auf eigne Gefahr!</p>
<p>Besondere Vorsicht ist bei den Kontext-Menü-Befehlen (Rechtsklick in die Listenansicht) geboten,
die von jeweils 2 Waagerechten Linien umschlossen sind.</p>
)
HtmlHilfe3=
(
<h2>Doppelte</h2>
<p>Doppelte Dateien können über den Button <i>Load Folder</i> gefunden werden,
indem man als erste Zeichen der Ordner-Vorauswalbox einen Doppelpunkt ":" verwendet.</p>
<h3>Doppelte ordneruebergreifend</h3>
<p>Mit obigem ":" kann man auch ordnerübergreifend Doppelte finden:<br>
- Button <i>Befehle f. Experten</i><br>
- Button <i>Doppelte</i><br>
- von Button <i>Beginn Doppelte Ordnerübergreifend</i> die Buttons nach rechts durcharbeiten.<br>
Dabei wird der Button <i>Load a Folder</i> mehrfach aufgerufen.</p>
)
HtmlHilfe4=
(
<h1>Möchte Noch</h1>
<p>Datei Öffen/Properties ... sauber im Quellcode trennen -> fast erledigt</p>
<p>[Windows]-[Y] gefolgt von Taste Dokumentieren -> erledigt, die Pfad-Aufruf-Prio fehlt noch</p>
<p>[Windows]-[Y]-Aufruf-Datei-Templates ins Hauptprogramm bringen. -> erledigt</p>
<p>Die Multimedia Unterstützung dokumentieren</p>
<p>Die Automatische Scripterstellung (auf neue Funktionen) ausdehenen</p>
<p>Musik (MP3) Player dokumentieren</p>
<p>Multimedia: Bild mit zugehörigem Ton (z.B. DITO.WAV) unterstützen -> erledigt</p>
<p>Multimedia: Steuer-Dateien (DITO.WIE) unterstützen. z.B. - Anzeigedauer der einzelnen Bilder - Filmauschnitt von bis</p>
<p>In Text-Dateien Absolute Links durch Relative Links ersetzen</p>
<p>Funktionen in Steuer-Dateien zulassen</p>
<p>Unterprogramme und Funktionen von AdHoc einbinden</p>
<p></p>
<p></p>
<p></p>
<p></p>
<p>Den Quellcode sauber Dokumentieren</p>
</body>
</html>
)
; loop, 100
	; HtmlTastAll:=HtmlTastAll . HtmlTast%A_index%
; HtmlHilfe=%HtmlHilfe1%%HtmlHilfe2%%HtmlTastAll%%HtmlHilfe3%
;
; Variablen vorbelegen
BildschirmPixelX:=A_ScreenWidth
BildschirmPixelY:=A_ScreenHeight
; BildZeilen:=3
; BildSpalten:=3
#MaxMem 512
VlcStopKenner=VLC media player
MindestOriginalSize:=4000
SomeFilterTextSpez=i)
SomeFilterTextTyp=htm,html,txt,ahk,bat,lnk,pdf,ppt,doc,xls,jpg,jpeg,gif,png,mov,avi,m2t,mpg,mpeg
TextTypList=txt,htm,html,ahk,js,bat,vcf,svg,do,filter,spez,typ,java,rtf,xml,tex,mht,js,csv		; Dateien die bei der Textsuche berücksichtigt werden
NotRunTypList=lst,do,filter,spez,typ
TonTypListZuBild=mp3,wav
; VlcWaitClose=ahk_class ShImgVw:CPreviewWnd
ZielVonLinkOeffnen=ja
ImageNr=0
CR=`r`n
Gleich:="~"
Pipe=|
OpenWith=%A_ProgramFiles%
AdminUser=A_%A_UserName%
Rename=NewName=`%OldName`%|NewExt=`%OldExt`%|Suchen=|Ersetzen=|RegSuchen=|RegErsetzen=
RenameOrg:=Rename
RePlace=Suchen=|Ersetzen=|RegSuchen=|RegErsetzen=
Ausgabe=`%S2`%`\`%S1`%`%A_Tab`%`%S3`%`%A_Tab`%`%S4`%`%A_Tab`%`%S5`%`%CR`%
TempPath=%A_Temp%\SucheDateien
IfNotExist %TempPath%
	FileCreateDir, %TempPath%
EndAusListPath=%TempPath%\List.txt
; EndAusListPath=%A_Temp%\aktobjekt.txt
HashMd5Path=%A_Scriptdir%\..\FremdProgramme\MD5.exe
EndAusListSelektPath=%TempPath%\Selekt.txt
EndAusListFokusPath=%TempPath%\Fokus.txt
FolgebildWartetTonEnde=Wait
Abfrage=Suchbegriff1+...
NextIconNumber:=1
DoMitschrieb=
ImageNrA:=1
ImageNrB:=0
WarteBildEigen=%DefaultWarteBildEigen%
TonZuBild=nein
BildZeilen=1
BildSpalten=1

Gosub GetMonitorWorkArea
WunschMonitorNr:=MonitorCount


FileSelectFileUeberspringen=False
HaschEinfuegen=nein		; In die Originale von Mehrfachlinks können Hash-Codes eigefügt werden.
SuchmusterVorlage=VonB=0 BisB=9999999999 VonGeaendert=19680101123456 BisGeaendert=%A_Now%
IfExist %A_MyDocuments%
	EigeneDateien=%A_MyDocuments%
Else
	EigeneDateien=%A_AppData%

DefaultFolder=
(
1	%EigeneDateien%
2	%A_WinDir%
3	%A_ProgramFiles%
4	%A_AppData%
5	%A_AppDataCommon%
6	%A_StartMenu%
7	%A_StartMenuCommon%
8	
9	%A_Temp%
10	%A_Desktop%
11	%A_DesktopCommon%
12	c:\temp

andere	letzten Ordner verwenden;  Mit : davor werden doppelte Dateien gesucht.
)

; ###################### beginn Key-Templates ####################################
HtmlTast1=
(
<h2>Schnell-Tasten</h2>
<p>Nach F5 wartet die Dateisuche auf einen Tastendruck (oder skript-abhängig mehrere Tastendrücke).
Erfolgt dieser wird das Skript Key-<i>Keyname</i>.do des Ordners %EigeneDateien%\SucheDateien aufgerufen.
Für einige Tasten existieren Vorlagen:</p>
<pre>
)
ThisHtmlTast:=Asc("1")
HtmlTast%ThisHtmlTast%=1	Übersichts-Bild-1 --> Vollanzeige<br>
Key1=					; Übersichts-Bild-1 --> Vollanzeige 
(
TonZuBild=ja
WarteAufFilmEnde=Nein
FensterNr=1
BildAufVolleGroesseFensternummer
)
ThisHtmlTast:=Asc("2")
HtmlTast%ThisHtmlTast%=2	Übersichts-Bild-2 --> Vollanzeige<br>
Key2=
(
TonZuBild=ja
WarteAufFilmEnde=Nein
FensterNr=2
BildAufVolleGroesseFensternummer
)
ThisHtmlTast:=Asc("3")
HtmlTast%ThisHtmlTast%=3	Übersichts-Bild-3 --> Vollanzeige<br>
Key3=
(
TonZuBild=ja
WarteAufFilmEnde=Nein
FensterNr=3
BildAufVolleGroesseFensternummer
)
ThisHtmlTast:=Asc("4")
HtmlTast%ThisHtmlTast%=4	Übersichts-Bild-4 --> Vollanzeige<br>
Key4=
(
TonZuBild=ja
WarteAufFilmEnde=Nein
FensterNr=4
BildAufVolleGroesseFensternummer
)
ThisHtmlTast:=Asc("5")
HtmlTast%ThisHtmlTast%=5	Übersichts-Bild-5 --> Vollanzeige<br>
Key5=
(
TonZuBild=ja
WarteAufFilmEnde=Nein
FensterNr=5
BildAufVolleGroesseFensternummer
)
ThisHtmlTast:=Asc("6")
HtmlTast%ThisHtmlTast%=6	Übersichts-Bild-6 --> Vollanzeige<br>
Key6=
(
TonZuBild=ja
WarteAufFilmEnde=Nein
FensterNr=6
BildAufVolleGroesseFensternummer
)
ThisHtmlTast:=Asc("7")
HtmlTast%ThisHtmlTast%=7	Übersichts-Bild-7 --> Vollanzeige<br>
Key7=
(
TonZuBild=ja
WarteAufFilmEnde=Nein
FensterNr=7
BildAufVolleGroesseFensternummer
)
ThisHtmlTast:=Asc("8")
HtmlTast%ThisHtmlTast%=8	Übersichts-Bild-8 --> Vollanzeige<br>
Key8=
(
TonZuBild=ja
WarteAufFilmEnde=Nein
FensterNr=8
BildAufVolleGroesseFensternummer
)
ThisHtmlTast:=Asc("9")
HtmlTast%ThisHtmlTast%=9	Übersichts-Bild-9 --> Vollanzeige<br>
Key9=
(
TonZuBild=ja
WarteAufFilmEnde=Nein
FensterNr=9
BildAufVolleGroesseFensternummer
)
ThisHtmlTast:=Asc("ü")
HtmlTast%ThisHtmlTast%=ü	zeige 9-Übersichts-Bilder auf einer Seite, weiterblätternd<br>
Keyü=					; Diaschow Übersicht
(
ImageNrA=1
ImageNrB=0
DauerwiederholungWindowsY=WindowsYNachTaste
WarteWindowsY=6000
WarteAufFilmEnde=Nein
WarteBildEigen=0
TonZuBild=nein
BildZeilen=3
BildSpalten=3
ToolTipZeigen=nein
MarkiereNZeilenAbFokusierter
BildEigenList=%BildEigenListVorlage%
VlCWaitList=%VlCWaitListVorlage%
Oeffnen=ja
ContextOpenFile
Oeffnen=nein
)
ThisHtmlTast:=Asc("h")
HtmlTast%ThisHtmlTast%=h	zeige Hintergrundbild (schwarz), vor vielen Anzeige-Modis sinnvoll.<br>
Keyh=
(
DauerwiederholungWindowsY=WindowsY
HintergrundBild
)
ThisHtmlTast:=Asc("m")
HtmlTast%ThisHtmlTast%=m	Multimediashow, weiterblätternd<br>	(Diashow, Musikplayer abhängig von den Datei-Typen in der Liste)<br>
Keym=					; Multimediaschow
(
ImageNrA=1
ImageNrB=0
DauerwiederholungWindowsY=WindowsYNachTaste
WarteWindowsY=0
WarteAufFilmEnde=Ja
WarteBildEigen=%DefaultWarteBildEigen%
TonZuBild=ja
BildZeilen=1
BildSpalten=1
ToolTipZeigen=nein
MarkiereNZeilenAbFokusierter
BildEigenList=%BildEigenListVorlage%
VlCWaitList=%VlCWaitListVorlage%
Oeffnen=ja
ContextOpenFile
Oeffnen=nein
)
ThisHtmlTast:=Asc("k")
HtmlTast%ThisHtmlTast%=k	Erzeuge Link auf BildVolleGroesse Datei im zuvor gewählten Ordner<br>
Keyk=					; Erzeuge Link auf BildVolleGroesse Datei im zuvor gewählten Ordner
(
DauerwiederholungWindowsY=WindowsY
LinkBildVolleGroesseFensternummer
)
ThisHtmlTast:=Asc("l")
HtmlTast%ThisHtmlTast%=l	Erzeuge Link auf Markierte Datei(en) im zuvor gewählten Ordner<br>
Keyl=					; Erzeuge Link auf Markierte Datei(en) im zuvor gewählten Ordner
(
DauerwiederholungWindowsY=WindowsY
EinstiegLinkUebergebenerOrdner
)
ThisHtmlTast:=Asc("+")
HtmlTast%ThisHtmlTast%=+	Übersichts-Bild # --> Vollanzeige (mit Bildnummernabfrage #)<br>
Keymit=					; + Bild auf volle Größe
(
DauerwiederholungWindowsY=nein
TonZuBild=ja
BildAufVolleGroesse
DauerwiederholungWindowsY=WindowsY
)
ThisHtmlTast:=Asc("-")
HtmlTast%ThisHtmlTast%=-	Vollanzeige --> ursprüngliche Größe<br>
Keyohne=				; - volle Größe Bild --> ursprüngliche Größe
(
TonZuBild=nein
BildAufUrsprungsGroesse
)
ThisHtmlTast:=10
HtmlTast%ThisHtmlTast%=Esc	abbrechen (Taste wird zusätzlich in einigen Schleifen abgehört)<br>
KeyEsc=					; Abbrechen
(
DauerwiederholungWindowsY=nein
SplashImageOff
)
ThisHtmlTast:=Asc("q")
HtmlTast%ThisHtmlTast%=q	abbrechen und Bilder nicht mehr anzeigen <br>
Keyq=					; Abbrechen
(
DauerwiederholungWindowsY=nein
SplashImageOff
WarteBildEigen=%DefaultWarteBildEigen%
)
ThisHtmlTast:=Asc("r")
HtmlTast%ThisHtmlTast%=r	Kontext-Menü vom größergestellten Bild <br>	(per Rechtklick auf die Vollanzeige lässt sich das Kontextmenü noch nicht erreichen)<br>	entspricht Rechtskick auf markierte(s) Listenelement(e)<br>
Keyr=					; wie Rechtskick auf markierte(s) Bild / Listenelement(e)
(
MarkiereVolleGroesseBild
)
ThisHtmlTast:=Asc("w")
HtmlTast%ThisHtmlTast%=w	abgebrochene *.do Datei Rest abarbeiten<br>
Keyw=					; weiter
(
RestlicheBefehleAbarbeiten
)
ThisHtmlTast:=Asc("z")
HtmlTast%ThisHtmlTast%=z	zufälliges vertauschen aller Listenelemente <br>
Keyz=					; Zeilesortierung zufällig
(
SortRandomAll
)
ThisHtmlTast:=15
HtmlTast%ThisHtmlTast%=Down	(weiterblättern und) 9 Übersichts-Bilder auf einer Seite anzeigen <br>
KeyDown=				; 9-Bilder weiterblättern
(
ImageNrA=1
ImageNrB=0
DauerwiederholungWindowsY=WindowsY
TonZuBild=nein
WarteAufFilmEnde=Nein
BildZeilen=3
BildSpalten=3
ToolTipZeigen=nein
MarkiereNZeilenAbFokusierter
BildEigenList=%BildEigenListVorlage%
VlCWaitList=%VlCWaitListVorlage%
Oeffnen=ja
ContextOpenFile
Oeffnen=nein
)
ThisHtmlTast:=Asc(".")
HtmlTast%ThisHtmlTast%=.	(weiterblättern und) 4 Übersichts-Bilder auf einer Seite anzeigen <br>
KeyDot=				; 4-Bilder weiterblättern
(
ImageNrA=1
ImageNrB=0
DauerwiederholungWindowsY=WindowsY
TonZuBild=nein
WarteAufFilmEnde=Nein
BildZeilen=2
BildSpalten=2
ToolTipZeigen=nein
MarkiereNZeilenAbFokusierter
BildEigenList=%BildEigenListVorlage%
VlCWaitList=%VlCWaitListVorlage%
Oeffnen=ja
ContextOpenFile
Oeffnen=nein
)
ThisHtmlTast:=Asc(":")
HtmlTast%ThisHtmlTast%=:	(weiterblättern und) 2 Übersichts-Bilder auf einer Seite anzeigen <br>
KeyDoppelpunkt=				; 2-Bilder weiterblättern
(
ImageNrA=1
ImageNrB=0
DauerwiederholungWindowsY=WindowsY
TonZuBild=nein
WarteAufFilmEnde=Nein
BildZeilen=1
BildSpalten=2
ToolTipZeigen=nein
MarkiereNZeilenAbFokusierter
BildEigenList=%BildEigenListVorlage%
VlCWaitList=%VlCWaitListVorlage%
Oeffnen=ja
ContextOpenFile
Oeffnen=nein
)
ThisHtmlTast:=Asc(";")
HtmlTast%ThisHtmlTast%=;	(weiterblättern und) 3 Übersichts-Bilder auf einer Seite anzeigen <br>
KeyStrichpunkt=				; 3-Bilder weiterblättern
(
ImageNrA=1
ImageNrB=0
DauerwiederholungWindowsY=WindowsY
TonZuBild=nein
WarteAufFilmEnde=Nein
BildZeilen=1
BildSpalten=3
ToolTipZeigen=nein
MarkiereNZeilenAbFokusierter
BildEigenList=%BildEigenListVorlage%
VlCWaitList=%VlCWaitListVorlage%
Oeffnen=ja
ContextOpenFile
Oeffnen=nein
)
ThisHtmlTast:=20
HtmlTast%ThisHtmlTast%=Right	(weiterblättern und) ein Bild anzeigen<br>
KeyRight=				; 1-Bild weiterblättern
(
ImageNrA=1
ImageNrB=0
DauerwiederholungWindowsY=WindowsY
TonZuBild=ja
WarteAufFilmEnde=Nein
FolgebildWartetTonEnde=
BildZeilen=1
BildSpalten=1
WarteBildEigen=0
ToolTipZeigen=nein
MarkiereNZeilenAbFokusierter
BildEigenList=%BildEigenListVorlage%
VlCWaitList=%VlCWaitListVorlage%
Oeffnen=ja
ContextOpenFile
Oeffnen=nein
FolgebildWartetTonEnde=Wait
)
ThisHtmlTast:=17
HtmlTast%ThisHtmlTast%=Up	(zurückblättern und) 9 Übersichts-Bilder auf einer Seite anzeigen <br>
KeyUp=					; 9-Bilder zurückblättern
(
ImageNrA=1
ImageNrB=0
TonZuBild=nein
WarteAufFilmEnde=Nein
BildZeilen=3
BildSpalten=3
ToolTipZeigen=nein
MarkiereNZeilenVorFokusierter
BildEigenList=%BildEigenListVorlage%
VlCWaitList=%VlCWaitListVorlage%
DauerwiederholungWindowsY=WindowsY
Oeffnen=ja
ContextOpenFile
Oeffnen=nein
)
ThisHtmlTast:=Asc(",")
HtmlTast%ThisHtmlTast%=,	(zurückblättern und) 4 Übersichts-Bilder auf einer Seite anzeigen <br>
KeyKomma=					; 4-Bilder zurückblättern
(
ImageNrA=1
ImageNrB=0
TonZuBild=nein
WarteAufFilmEnde=Nein
BildZeilen=2
BildSpalten=2
ToolTipZeigen=nein
MarkiereNZeilenVorFokusierter
BildEigenList=%BildEigenListVorlage%
VlCWaitList=%VlCWaitListVorlage%
DauerwiederholungWindowsY=WindowsY
Oeffnen=ja
ContextOpenFile
Oeffnen=nein
)
ThisHtmlTast:=22
HtmlTast%ThisHtmlTast%=Left	(zurückblättern und) ein Bild anzeigen<br>
KeyLeft=					; 1-Bilder zurückblättern
(
ImageNrA=1
ImageNrB=0
FolgebildWartetTonEnde=
TonZuBild=ja
WarteAufFilmEnde=Nein
BildZeilen=1
BildSpalten=1
ToolTipZeigen=nein
MarkiereNZeilenVorFokusierter
BildEigenList=%BildEigenListVorlage%
VlCWaitList=%VlCWaitListVorlage%
DauerwiederholungWindowsY=WindowsY
Oeffnen=ja
ContextOpenFile
Oeffnen=nein
FolgebildWartetTonEnde=Wait
)
ThisHtmlTast:=256
HtmlTast%ThisHtmlTast%=</pre>
; ###################### end Key-Templates ####################################
IfExist, %A_ScriptName%
	{
	If Not (A_IsCompiled)
		{
		FileGetTime, ScriptNameModificate , %A_ScriptName%, M
		FileGetTime, SucheDateienModificate , SucheDateien.ahk, M
		If(ScriptNameModificate >= SucheDateienModificate + 50)	; nur bei neuerer Datei
			FileCopy, %A_ScriptName%, SucheDateien.ahk, 1		; Kopie Immer Aktuell anlegen
		}
	}
; SetTimer, UeberwacheVariablenAenderung, 5
IfNotExist, %NPP%
	NPP=%A_ProgramFiles%\Notepad++\notepad++.exe
IfNotExist, %NPP%
	NPP=%A_Scriptdir%\..\..\Notepad++\notepad++.exe
IfNotExist,%A_StartMenu%\..\sendto\SucheDateien.lnk
	FileCreateShortcut,%A_ScriptDir%\SucheDateien.ahk, %A_StartMenu%\..\sendto\SucheDateien.lnk, %A_ScriptDir%
TrayTip,Start-Übergabe,"%1%",5
;
;
; Fensterverwaltung + Hauptprogramm
; Allow the user to maximize or drag-resize the window:
Gui +Resize
;
; Create some buttons:
; Gui, Add, Button,, CheckAll
Gui, Color,D8D8CB
Gui, Font, bold
; Gui, Color, EEAA99
; Gui, Add, Text,x+0 cFFFF00, in /`nout:
Gui, Add, Text,x+0, in /`nout:
Gui, Font, norm
Gui, Add, Checkbox,x+2 y-1 vCheckbox0 Checked,s&ub
Checkbox0_TT:="Button Load Folder fügt inklusive Unterordner hinzu"
; Gui, Add, Checkbox, cFFFF00 vCheckboxTypen,Type&n
Gui, Add, Checkbox, vCheckboxTypen,Type&n
CheckboxTypen_TT:="Button Load Folder fügt nur die mit Button Typ gewählten Endungen hinzu"
Gui, Add, Checkbox,x85 y-1 vCheckboxF,+
CheckboxF_TT=Ordner werden auch als Listenelemente geladen.`num Links auf Ordner erstellen zu können`nFunktion im Beta-Test:`nkeine Dateikopie machen
Gui, Add, Button, x+0 y-0 gButtonLoadFolder vButtonLoadFolder, &Load`nfolder
ButtonLoadFolder_TT=fügt die Dateien (eines) Ordners der Liste hinzu`nRechtsKlick fügt die Dateien (werden heruntergeladen) einer GoogleSuche der Liste hinzu
Gui, Add, Button, x+5 vsave, sa&ve
Save_TT=Speichert ins Dateisystem`nGesamtListen	lst`nSuchMacros	do`nFilter		filter`,spez`,typ`nPlaylists		m3u`n`nund andere`nmit Rechtsklick verändert man das Ausgabeformat für die "Anderen" (hier nicht unterstütze Dateitypen).
Gui, Add, Button, x+1, &open
Open_TT=holt mit Save gespeichertes aus Dateisystem`nDrag and Drop auf open öffnet die Datei (do`,filter`.spez`,typ)`noder fügt den Ordner / die Datei der Liste hinzu
Gui, Add, Button, x+20 gButtonClear vButtonClear, &Clear`nList
ButtonClear_TT=leert die Liste
Gui, Font, bold
Gui, Add, Text,x+20, View:
Gui, Font, norm
Gui, Add, Button, x+1 gButtonOpti vButtonOpti, O&pti`nRow
ButtonOpti_TT=passt die Spaltenbreiten an die ListenInhalte an`nRechtsKlick: Kompromiss für zu Breite Inhalte
Gui, Add, Checkbox, x+2 vCheckboxOhneIcon Checked,-&Icon
CheckboxOhneIcon_TT=beschleunigt alle Aktionen`nindem auf Icons verzichtet wird
Gui, Add, Button, x+1, Switch
Switch_TT=wechselt zwischen DetailAnsicht und IconAnsicht
Gui, Font, bold
Gui, Add, Text,x+20 , Filter:
Gui, Font, norm
; Gui, Add, Text,x+0 y+6, Spalten:
Gui, Add, Checkbox, x+1 vCheckbox1 Checked,&1
Checkbox1_TT=berücksichtigt den DateiName beim Filtern
Gui, Add, Checkbox,  vCheckbox2,&2
Checkbox2_TT=berücksichtigt den DateiOrdner beim Filtern
Gui, Add, Checkbox, x+3 y-0 vCheckboxTxt,t&xt
CheckboxTxt_TT=TextSuche`nBerücksichtigt den DateiInhalt beim Filtern`nfür Dateien die sich mit RechtsKlick einstellen lassen.
Gui, Add, Checkbox, vCheckboxSel Check3,sel
CheckboxSel_TT=selektiert die Treffer nur`nOhne Haken bleiben nur die Treffer stehen.`nDiese Funktionalität wird gerade entwickelt`nund ist nur für wenige Konstelationen vorhanden.
; Gui, Add, Checkbox, x+1 vCheckbox3,3
; Gui, Add, Checkbox, x+1 vCheckbox4,4
Gui, Add, Button, x+1 y-0 gButtonFilter vButtonFilter, &Filter`nenth.
ButtonFilter_TT=filtert 1:1 (GROSS/klein egal)
Gui, Add, Button, x+5 gButtonSpez vButtonSpez, Filter`n&spez
ButtonSpez_TT=filtert nach der RegEx Notation	näheres siehe Button Hilfe`n)i	(GROSS/klein egal)`n.*	repräsemtiert 0 bis viele beliebige Zeichen`n(ä|ae)	Alternativen
; Gui, Add, Button, x+1, Help
Gui, Add, Button, x+5 gButtonTyp vButtonTyp, Filter`n&Typ
ButtonTyp_TT=filtert nur nach Dateiendung
; Gui, Add, Button, x+20, Explorer
Gui, Font, bold
Gui, Add, Text,x+20 , temp:
Gui, Font, norm
Gui, Add, Button, x+1 y-0, Sich&ern
Sichern_TT=Liste -> Hauptspeicher
Gui, Add, Button, x+1, &Wiederherstellen
Wiederherstellen_TT=Hauptspeicher -> Liste
Gui, Add, Button, x+20, &Hilfe
Hilfe_TT=zeigt allg. Hilfe
Gui, Add, Edit, x+5 R1 W65 ReadOnly vZeigeDateiAnzahl
ZeigeDateiAnzahl_TT=ZeigeDateiAnzahl|Anzahl ListenElemente
Gui, Add, Checkbox, x+20 vCheckboxR gAufnahme,&r
CheckboxR_TT=Macro Aufzeichnung aktiv`nRechtsKlick Macro speichern
Gui, Add, Button, x+10 y-0 gButtonBefehle vButtonBefehle, Befehle f.`nExperten
ButtonBefehle_TT=sonstige Befehle / Befehle für Experten
Gui, Add, Button, x+1 Hidden Default, OK
; Gui, Add, Button, x+1 Default, OK


; Create the ListView and its columns:
Gui, Color, ,FFF0F0
Gui, Add, ListView, xm r20 w700 vMyListView gMyListView, Name|In Folder|Size|Type|Last Change / Hash
MyListView_TT=Drag and Drop auf die Liste fügt hinzu`nRechtsclick auf ListenElement siehe KontextMenü.
LV_ModifyCol(3, "Integer")  ; For sorting, indicate that the Size column is an integer.

; Create an ImageList so that the ListView can display some icons:
ImageListID1 := IL_Create(10)
ImageListID2 := IL_Create(10, 10, true)  ; A list of large icons to go with the small ones.

; Attach the ImageLists to the ListView so that it can later display the icons:
LV_SetImageList(ImageListID1)
LV_SetImageList(ImageListID2)

; Create a popup menu to be used as the context menu:
Menu, MyContextMenu, Add, Open, ContextOpenFile
Menu, MyContextMenu, Add, Open spez, ContextOpenFileSpez
Menu, MyContextMenu, Add, Edit, ContextEdit
Menu, MyContextMenu, Add, Explorer, ContextOpenExplorer
Menu, MyContextMenu, Add, Properties, ContextProperties
Menu, MyContextMenu, Add  ; Separator line.
Menu, MyContextMenu, Add, Copy, ContextCopy
Menu, MyContextMenu, Add, Copy FullPath, ContextFullPath
Menu, MyContextMenu, Add, Paste, ContextPaste
Menu, MyContextMenu, Add  ; Separator line.
Menu, MyContextMenu, Add, Select All, ContextSelectAll
Menu, MyContextMenu, Add, DeSelect All, ContextDeSelectAll
Menu, MyContextMenu, Add, invert Selected, ContextInvertSelect
Menu, MyContextMenu, Add, Select next MehrfachLink, ContextAutoSelectNextMehrfachLink
Menu, MyContextMenu, Add, Selected up, ContextSelectUp
Menu, MyContextMenu, Add, Suche tote Links in Verknuepfungen,ContextSucheToteLinksInVerknuepfungen
Menu, MyContextMenu, Add, Clear from ListView, ContextClearRows
Menu, MyContextMenu, Add  ; Separator line.
Menu, MyContextMenu, Add, FileCopy, ContextFileCopy
Menu, MyContextMenu, Add, ErzeugeLink, ContextErzeugeLink
Menu, MyContextMenu, Add  ; Separator line.
Menu, MyContextMenu, Add  ; Separator line.

Menu, MyContextMenu, Add, Links Aktualisieren,ContextLinksAktualisieren
Menu, MyContextMenu, Add, ErzeugeMehrfachLink, ContextErzeugeMehrfachLink
Menu, MyContextMenu, Add, Link2Org, ContextLink2Org
Menu, MyContextMenu, Add, Rename at FileSystem, ContextRenameFiles
Menu, MyContextMenu, Add, Replace Text (or set Timestamp) in selectet Files, ContextRePlaceText
Menu, MyContextMenu, Add, Delete Org bei selektierten Links, ContextDelNearLinkFiles
Menu, MyContextMenu, Add, Delete from FileSystem, ContextDelFiles
Menu, MyContextMenu, Add  ; Separator line.
Menu, MyContextMenu, Add  ; Separator line.
Menu, MyContextMenu, Default, Open  ; Make "Open" a bold font to indicate that double-click does the same thing.



; Display the window and return. The OS will notify the script whenever the user
; performs an eligible action:
Gui, Submit 
Gui, Show
OnMessage(0x200, "WM_MOUSEMOVE")
Ue1=%1%
BefehlsDateiVerarbeiten:
BefehlsDateiVerarbeitenBeenden=
IfExist %Ue1%
{
    SplitPath, Ue1, Ue1OutFileName, Ue1OutDir, Ue1OutExtension, Ue1OutNameNoExt, Ue1OutDrive
    if (Ue1OutExtension="lst")
    {
        SelectedFile:=Ue1
        Goto ButtonOpenNachFileSelect
    }
    if InStr(FileExist(Ue1), "D")
    {
        Folder=%Ue1%
        ; MsgBox Folder = %Folder%
        Goto EinstiegUebergebenerOrdner
    }
    else
    {
        FileRead, Inhalt1,%Ue1%
	; If (Ue1OutExtension="do")
	;	Inhalt1:=InnereVariablenExtrahieren(Inhalt1)
	If (ue1=SelectedFile)
		{
        	RestlicheBefehle:=Inhalt1
		MitZaehler:=1
        	; MsgBox frisch:	%ue1%=%SelectedFile%
		}
        Loop, parse, Inhalt1, `n,`r
        {
	    If(BefehlsDateiVerarbeitenBeenden="ja")
		{
		BefehlsDateiVerarbeitenBeenden=
		; Break
		Exit
		}
	    If (A_Index=MitZaehler AND NextNot<>"Ja")
		{
		LastMitZaehler:=MitZaehler
		MitZaehler:=MitZaehler+1
                StringReplace,RestlicheBefehle,RestlicheBefehle,%A_LoopField%
		; MsgBox % ue1 "`n" RestlicheBefehle
		}
	    Else If (LastMitZaehler=A_Index-1)
		NextNot=Ja
	    Else
		NextNot=Nein
        	; MsgBox %A_index% drinn:	%ue1%=%SelectedFile%
	    If (InStr(A_LoopField,"(") > 0  AND  InStr(A_LoopField,"(") < InStr(A_LoopField,")")  AND  InStr(A_LoopField,")") = StrLen(A_LoopField))
		{
		If(SubStr(A_LoopField,1,1)="^")
			{
			AktLabel:=InnereVariablenExtrahieren(A_LoopField)
			StringTrimLeft, AktLabel, AktLabel, 1
			}
		Else
			AktLabel:=A_LoopField
		
		Gosub FunktionsaufrufErzeugenUndAufrufen
		}

            Else if InStr(A_LoopField,"=")
            {
		If(SubStr(A_LoopField,1,1)="^")
			{
			AktLabel:=InnereVariablenExtrahieren(A_LoopField)
			StringTrimLeft, AktLabel, AktLabel, 1
			}
		Else
			AktLabel:=A_LoopField
                Loop, parse, AktLabel,=,%A_Space%
                {
                    Variable%A_Index%=%A_LoopField%
; MsgBox % Variable%A_Index%
                }
                ; MsgBox %Variable1%=%Variable2%
                if Variable1 not contains`>,`<,`|,`;,,,, ,	,`#
                    {
                    %Variable1%=%Variable2%
		    ; Listlines
                    ; MsgBox % %Variable1% " == " %Variable2% ; ####################
                    }
                Else
                    continue                    
            }
            Else if InStr(FileExist(A_LoopField), "D") 
            {
                ; MsgBox Ordner: %A_LoopField%
                Folder=%A_LoopField%
                Folder:=Rel2AbsPath(Folder)	; Funktion wurde Programmiert, da Relative Pfade extrem langsam verarbeitet werden.
                Gosub EinstiegUebergebenerOrdnerNachSubmit
            }
            else if FileExist(A_LoopField)
            {
                ; MsgBox Datei: %A_LoopField%
                FileName=%A_LoopField%
                Gosub NurFileNameNachSubmit       
            }
            else If IsLabel(A_LoopField)
            {
                Gosub %A_LoopField%
            }
            FileGetAttrib, OutputVarTemp , %A_LoopField%
            ; MsgBox % A_LoopField " Atribute: " FileExist(A_LoopField) " " OutputVarTemp
        }
        NextNot=Nein
    }

}
Else
{	; ListenEinträge von der letzten Sitzung restaurieren
    FileGetSize, EndAusListSize , %EndAusListPath%
    ; MsgBox %EndAusListSize%
    If (EndAusListSize>700000)
    {
        MsgBox, 4, ,RestaurierungsDateiGröße = %EndAusListSize% `n`nDas Restaurieren vortsetzen?`n`nContinue?
        IfMsgBox, No, return        
    }
    IfExist,%EndAusListPath%
        FileRead, Aktobjekt,%EndAusListPath%
    Else
        Return
    ToolTip,beschäftigt,4,4
    Loop, parse, Aktobjekt, `n, `r  ; Specifying `n prior to `r allows both Windows and Unix files to be parsed.
    {
        ; MsgBox, 4, , Line number %A_Index% is %A_LoopField%.`n`nContinue?
        ; IfMsgBox, No, break
        Loop, parse, A_LoopField, %A_Tab%
        {
            Spalte%A_Index%:=A_LoopField
        }
        LV_Add("",Spalte1,Spalte2,Spalte3,Spalte4,Spalte5)
    }
    Gosub ButtonOpti
;
    IfExist,%EndAusListSelektPath%
    {					; selektierte ListenEinträge restaurieren
        FileRead, Aktobjekt,%EndAusListSelektPath%
        Loop, parse, Aktobjekt, `n, `r  ; Specifying `n prior to `r allows both Windows and Unix files to be parsed.
        {
            Loop, parse, A_LoopField, %A_Tab%
                {
                Spalte%A_Index%:=A_LoopField
                }
            LV_Modify(Spalte1, "Select")
        }   
    } 
;
    IfExist,%EndAusListFokusPath%	; ListenEintrag mit Fokus restaurieren
        FileRead, Aktobjekt,%EndAusListFokusPath%
    Else
        Return
    StringSplit, RowNumber, Aktobjekt , %A_TAB%
    LV_Modify(RowNumber1, "Focus")
    ToolTip,

}
return  ; Ende Hauptprogramm
;
RestlicheBefehleAbarbeiten:
; MsgBox % RestlicheBefehle
If (RestlicheBefehle<>"")
	{
	RestlicheBefehlePfad=%A_AppData%\SucheDateien\RestlicheBefehle.do
	FileCreateDir, %A_AppData%\SucheDateien
	FileDelete,%RestlicheBefehlePfad%
	FileAppend , %RestlicheBefehle%, %RestlicheBefehlePfad%
	ue1:=RestlicheBefehlePfad
	Gosub BefehlsDateiVerarbeiten
	}
Else
	TrayTip , Hinweis, keine restlichen Befehle vorhanden,8
listlines
Return
;

HintergrundBild:
Gosub GetMonitorWorkArea
ScreenWidth:=Mon%WunschMonitorNr%Width
ScreenHeight:=Mon%WunschMonitorNr%Height
ThisXVersatzEintrag:="X" Mon%WunschMonitorNr%Left
ThisYVersatzEintrag:="Y" Mon%WunschMonitorNr%Top
SplashImage,10:%A_ScriptDir%\SucheDateien\Hintergrund.bmp, A b ZH%ScreenHeight% ZW%ScreenWidth% %ThisXVersatzEintrag% %ThisYVersatzEintrag%
return

SplashImageOff:
	Loop,10
		SplashImage, %A_index%:Off
	BildFenster=zu
return

MarkiereZeileNachFokusierter:
If(FocusedRowNumber<=LV_GetCount())
	{
	FocusedRowNumber := LV_GetNext(0, "F")
	LV_Modify(FocusedRowNumber, "-Select")
	++FocusedRowNumber
	LV_Modify(FocusedRowNumber, "Focus")
	LV_Modify(FocusedRowNumber, "Select")
	}
else
	{
	ToolTip,
	DauerwiederholungWindowsY=nein
	MsgBox Listenende erreicht
	Loop,1
		SplashImage, %A_index%:Off
	}
return


MarkiereNZeilenVorFokusierter:
NZeilen:=BildZeilen * BildSpalten
FocusedRowNumber := LV_GetNext(0, "F")
If (FocusedRowNumber = 0)
	{
	FocusedRowNumber := LV_GetCount() - NZeilen +1
	LV_Modify(FocusedRowNumber, "Focus")
	Goto MarkiereNZeilen
	}
FocusedRowNumber := LV_GetNext(0, "F") - NZeilen * 2
If Not(FocusedRowNumber>0)
	{
	FocusedRowNumber := 1
	TrayTip,Suche Dateien, Listen-Anfang erreicht!
	}
Goto MarkiereNZeilen

MarkiereNZeilenAbFokusierter:
NZeilen:=BildZeilen * BildSpalten
FocusedRowNumber := LV_GetNext(0, "F")
If (FocusedRowNumber = 0)
	{
	LV_Modify(1, "Focus")
	FocusedRowNumber := 1
	}
MarkiereNZeilen:
; If(FocusedRowNumber<=LV_GetCount()-NZeilen)
	{
	
	LV_Modify(0, "-Select")
	; ++FocusedRowNumber
	MarkRowNumber:=FocusedRowNumber

	Loop % NZeilen
		{
		LV_Modify(MarkRowNumber, "Select")
		If(MarkRowNumber=LV_GetCount())
			{
			TrayTip,Suche Dateien, Listen-Ende erreicht!
			break
			}
		++MarkRowNumber
		}
	LV_Modify(MarkRowNumber, "Focus")
	}
If Not(FocusedRowNumber<=LV_GetCount()-NZeilen)
	{
	ToolTip,
	DauerwiederholungWindowsY=nein
	; MsgBox Listenende erreicht
	; Loop % NZeilen
	;	SplashImage, %A_index%:Off
	; SplashImage, 10:Off
	; exit
	}
return

MarkiereZeileVorFokusierter:
If(FocusedRowNumber>=1)
	{
	FocusedRowNumber := LV_GetNext(0, "F")
	LV_Modify(FocusedRowNumber, "-Select")
	--FocusedRowNumber
	LV_Modify(FocusedRowNumber, "Focus")
	LV_Modify(FocusedRowNumber, "Select")
	}
else
	{
	ToolTip,
	DauerwiederholungWindowsY=nein
	MsgBox Listenanfang erreicht
	Loop,1
		SplashImage, %A_index%:Off
	}
return

BildAufVolleGroesse:
IF(BildSpalten=1 AND BildZeilen=1)
	FensterNr:=1
Else
	Inputbox,FensterNr , Fensternummer, geben Sie die Fensterummer (1 bis 9) an`ndie bildfüllend dargestellt werden soll!
BildAufVolleGroesseFensternummer:
if FensterNr is integer
	{
	if FensterNr between 1 and %NZeilen%
		{
		ThisFensterNr:=FensterNr
		; MsgBox ThisFensterNr = %ThisFensterNr%
		ThisRowNumber:=FensterNrZuordnung%FensterNr%
		LV_GetText(FileName, ThisRowNumber, 1) ; Get the text of the first field.
		LV_GetText(FileDir, ThisRowNumber, 2)  ; Get the text of the second field.
		If(FileDir<>"")
		    BildGrossFileFulNlName=%FileDir%\%FileName%
		Else
		    BildGrossFileFulNlName=%FileName%
		; BildGrossFileFulNlName=%FileDir%\%FileName%
		; MsgBox danach Bombe
		LV_GetText(FileTyp, ThisRowNumber, 4)

		If InStr(FileExist(BildGrossFileFulNlName),"D")
		    {
ThisDo=
(
ButtonClearNachSubmit
Checkbox1=0
Checkbox2=0
CheckboxTxt=0
CheckboxOhneIcon=1
CheckboxTypen=1
SomeFilterTextTyp=jpg,jpeg,gif,mov,avi,m2t,mpg,mpeg,mp4,wmv
ButtonTypOhneInput
Checkbox0=1
CheckboxTypen=1
%BildGrossFileFulNlName%
Checkbox1=0
Checkbox2=0
CheckboxTxt=0
Suchmuster=VonB~50000 BisB~9999999999 VonGeaendert~19680101123456 BisGeaendert~20910318104306
ButtonFilterOhneInput
Key=Right
BeendenBeiListEnde=10000
ThisWinTitle=%BildGrossFileFulNlName%
WinSetTitle
WindowsYnachKey
)
		    FileDelete, %EigeneDateien%\SucheDateien\This.do
	    	    FileAppend ,%ThisDo% ,%EigeneDateien%\SucheDateien\This.do

		    ; RunWait %A_ScriptFullPath% %BildGrossFileFulNlName% %EigeneDateien%\SucheDateien\Key-m.do
		    RunWait "%A_ScriptFullPath%" "%EigeneDateien%\SucheDateien\This.do"
		    Return
		    }
		If FileTyp in %BildEigenList%
		    {
		    ; MsgBox SplashImage`,%FensterNr%:%BildGrossFileFulNlName%`, A b ZH%BildschirmPixelY% ZW-1
		    ; SplashImage,%FensterNr%:%BildGrossFileFulNlName%, A b ZH%BildschirmPixelY% ZW-1
		    ThisMonLeft:=Mon%WunschMonitorNr%Left
		    ThisMonTop:=Mon%WunschMonitorNr%Top
		    ThisMonWidth:=Mon%WunschMonitorNr%Width
		    ThisMonHeight:=Mon%WunschMonitorNr%Height
		    ; msgbox % ThisMonLeft "	" ThisMonTop "	" ThisMonWidth "	" ThisMonHeight
                      SplashImage,%FensterNr%:%BildGrossFileFulNlName%, A b ZH%ThisMonHeight% ZW-1 X%ThisMonLeft% Y%ThisMonTop%
		    ; MsgBox SplashImage`,%FensterNr%:%BildGrossFileFulNlName%`, A b ZH%BildschirmPixelY% ZW-1
		    BildFenster=offen
			StringReplace, FileNameDotNoExt, FileName, %FileTyp%
		    ; MsgBox % BildFenster
			If (TonZuBild="ja")
				{
					
					StringSplit, TonTypListZuBildArray, TonTypListZuBild ,`,
					Loop % TonTypListZuBildArray0
					{
						ThisTonTypListZuBild:=TonTypListZuBildArray%A_Index%
						IfExist %FileDir%\%FileNameDotNoExt%%ThisTonTypListZuBild%
						{
							SoundPlay, %FileDir%\%FileNameDotNoExt%%ThisTonTypListZuBild%
							; MsgBox "%FileDir%\%FileNameDotNoExt%%ThisTonTypListZuBild%"
							WarteWindowsY=0
						}
					}
				
				}		
		    }
		Else
                            {
			    ThisObjekt=%FileDir%\%FileName%
			    IfExist %ThisObjekt%.com
				{
				FileRead, CommandLine, %ThisObjekt%.com
				CommandLine:=InnereVariablenExtrahieren(CommandLine)
				; MsgBox % CommandLine
				}
			    Else
				{
				CommandLine=
				}
	                    Run "%VlcPfad%" "%FileDir%\%FileName%" %CommandLine%,, UseErrorLevel
			    ; MsgBox % FileTyp
                            sleep 700
			    ; SplashImage, Off
			    ; WinWait,%VlcWaitClose%,,5
			    ; WinWaitActive ,%VlcWaitClose%,,20
                            WinSet, Bottom,, ahk_class ShImgVw:CPreviewWnd
			    sleep 5000
			    WinWaitClose,%FileName%
		       	    ; WinWait ,%VlcStopKenner%	;,,60+60*Warte*3
			    WarteWindowsY=0
                            ; WinSet, AlwaysOnTop, On, ahk_class ShImgVw:CPreviewWnd
			    ; WinClose,%VlcStopKenner%
			    ; WinMinimize,%VlcStopKenner%
                            }
		}
	Else
	MsgBox die Fensternummer muss zwischen 1 und %NZeilen% liegen!
	}
else
	MsgBox Nur Ganz-Zahlen erlaubt
return

LinkBildVolleGroesseFensternummer:
LV_GetText(FileName, ThisRowNumber, 1) ; Get the text of the first field.
LV_GetText(FileDir, ThisRowNumber, 2)  ; Get the text of the second field.
FileDirFileName=%FileDir%\%FileName%
IfExist %FileDirFileName%
	{
        LinkInFolderFileName=%LinkInFolder%\%FileName%
        RelLink:= PfadAbs2Rel(LinkInFolderFileName,FileDirFileName)
        RelLinkComent=href="%RelLink%"
	FileCreateShortcut, %FileDirFileName%,%LinkInFolder%\%FileName%.lnk,%FileDir%,,%RelLinkComent%
	}
Return

MarkiereVolleGroesseBild:
If(ThisRowNumber<>"")
	{
	LV_Modify(0, "-Select")
	LV_Modify(ThisRowNumber, "Select")
	LV_Modify(ThisRowNumber, "Focus")
	}
DauerwiederholungWindowsY=nein
; WinActivate,SucheDateien,Load Folder
Menu, MyContextMenu, Show, %A_GuiX%, %A_GuiY%
BildFenster=NichtSchliessen
Return

BildAufUrsprungsGroesse:
FensterNr:=ThisFensterNr
BildPixelX:=BildPixelXZuordnung%FensterNr%
BildPixelY:=BildPixelYZuordnung%FensterNr%
XVersatz:=XVersatzZuordnung%FensterNr%
YVersatz:=YVersatzZuordnung%FensterNr%
LV_GetText(FileTyp, ThisRowNumber, 4)
If FileTyp in %BildEigenList%
        {
	SplashImage,%FensterNr%:%BildGrossFileFulNlName%, A b ZH%BildPixelY% ZW-1 X%XVersatz% Y%YVersatz%
        ; SplashImage,%FensterNr%:%FileDir%\%FileName%, A b ZH%BildPixelY% ZW-1 %XVersatzEintrag% %YVersatzEintrag%
	; MsgBox SplashImage`,%FensterNr%:%BildGrossFileFulNlName%`, A b ZH%BildPixelY% ZW-1 X%XVersatz% Y%YVersatz%
	BildFenster=offen
	}
return

SortRandomAll:
ToolTip,beschäftigt,4,4
Reihe=
loop % LV_GetCount()
	{
	Reihe=%Reihe%%A_Index%|
	}
StringTrimRight,Reihe,Reihe,1
Sort, Reihe , Random D| 

; MsgBox % Reihe
StringSplit, Reihe, Reihe ,|

loop % LV_GetCount()
	{
	If (getauscht%A_index%<>1)
		{
		getauscht%A_index%=
		Index:=A_index
		Loop % 5
			{
			LV_GetText(ThisText%A_index%, Index, A_index)
			LV_GetText(ThatText%A_index%, Reihe%Index%, A_index)
			}
		LV_Modify(Reihe%Index% , "Icon" . "9999999", ThisText1, ThisText2, ThisText3, ThisText4, ThisText5) 
		LV_Modify(Index , "Icon" . "9999999", ThatText1, ThatText2, ThatText3, ThatText4, ThatText5) 
		GegenRowNumber:=Reihe%Index%
		getauscht%GegenRowNumber%:=1
		}
	}
getauscht%A_index%=
ToolTip,
Return


SelectUp:
{
	; #######################################
	ToolTip,beschäftigt,4,4
	Mehrfach:=0
	; MsgBox Los
	; RowNumberSelect := LV_GetNext(0)
	Loop % LV_GetCount()
	    {
	    RowNumber := A_Index 
	    RowNumberSelect := LV_GetNext(RowNumber-1)
	    ; MsgBox RowNumber = %RowNumber%	%A_Index%	%RowNumberSelect%
	    If Not (RowNumberSelect = RowNumber)
		{
		RowNumberSelect := LV_GetNext(RowNumber)
		If (RowNumberSelect = 0)
			Break
		loop,5
			{
			LV_GetText(Spalte%A_Index%, RowNumber, A_Index) 
			; Zeile:=Zeile Spalte%A_Index% A_Tab
			}
		loop,5
			{
			LV_GetText(SpalteSel%A_Index%, RowNumberSelect, A_Index) 
			; Zeile:=Zeile SpalteSel%A_Index% A_Tab
			}
		LV_Modify(RowNumber, Options , SpalteSel1, SpalteSel2,SpalteSel3, SpalteSel4,SpalteSel5) 
		LV_Modify(RowNumber, "Select")
		LV_Modify(RowNumberSelect, Options , Spalte1, Spalte2,Spalte3, Spalte4,Spalte5) 
		LV_Modify(RowNumberSelect, "-Select")
		}
	    }
	LV_Modify(1, "Focus")
	ControlFocus , SysListView321, ahk_class AutoHotkeyGUI
	ToolTip,
	Return
}
;
; Buttons
;
ButtonOK:   ; Startet die Listview-Datei die den Fokus hat
{
	GuiControlGet, FocusedControl, FocusV
	if FocusedControl <> MyListView
	    return
	; MsgBox % "Enter was pressed. The focused row number is " . LV_GetNext(0, "Focused")
	Gosub ContextOpenFokusedFile
	; Gosub ContextOpenFile
	return
}

; ButtonCheckAll: ; Alle Haken setzen
{
	; LV_Modify(0, "Check")       ; funzt ned     wahrscheinlich für Checkboxen in der ListView gedacht
	; GuiControl,1:,IX2,0
	; Gui, Submit,NoHide
	; Return
}
;

LoadFolderOrFilesMitVorschlaegen(VorschlagListenPfad="",Optionen="0",FolderAddListPfad="",AnzeigeText="")
{
; VorschlagListenPfad	Pfad zur Datei in der eignene Vorschläge pflegbar sind
; Optionenen
; 	 0	Optionen0=0			Mehrere Rückgabeobjekte erlaubt
; 	 1	Optionen0=1			0 oder 1 Rückgabeobjekt erlaubt
;	 2	Optionen1=1			0 oder 2 Rückgabeobjekte erlaubt
;	 3	Optionen0=1 Optionen1=1		0, 1 oder 2 Rückgabeobjekte erlaubt
; --------------------------------------------------------
;	 0	Optionen2=0			Objekt muss nicht existieren
;	 4	Optionen2=1			Objekt muss existieren
; --------------------------------------------------------
;	 0	Optionen3=0			Vorschläge aus geöffneten Fenstern generieren
;	 8	Optionen3=1			keine Vorschläge aus geöffneten Fenstern generieren
; --------------------------------------------------------
;	 0	Optionen4=0			
;	16	Optionen4=1			Nur Ordner 
; --------------------------------------------------------
;	 0	Optionen5=0			
;  	32	Optionen5=1			Nur Dateien Reserviert, Wird momentan nicht Unterstütz
; --------------------------------------------------------
;
; z.B.:
;	21					Ein existierender Ordner soll zurückgegeben werden
Global EigeneDateien
Static LastDefaultFolder
If(EigeneDateien="")
	EigeneDateien:=A_MyDocuments
;--------------------------------------------------------
Loop 6
	{
	Index:=6-A_Index
	OptionenNeu:=Optionen-(2**(Index))
	; Msgbox % Optionen "	" OptionenNeu
	If(OptionenNeu>=0)
		{
		Optionen%index%:=1
		Optionen:=OptionenNeu
		}
	Else
		Optionen%index%:=0

	}
; -------------------------------------------------------
IfNotExist %VorschlagListenPfad%
	{
	VorschlagListenPfad=%EigeneDateien%\SucheDateien\Folder.txt
	IfNotExist %VorschlagListenPfad%
		{
		IfNotExist %EigeneDateien%\SucheDateien
		FileCreateDir, %EigeneDateien%\SucheDateien
		FileAppend , %DefaultFolder%, %VorschlagListenPfad%
		}
	}
FileRead, DefaultFolder, %VorschlagListenPfad%
FileRead, WindowInfo, %FolderAddListPfad%
; -------------------------------------------------------
ThisAufrufNummer:=0
Loop, parse, DefaultFolder, `n, `r
	{
	++ThisAufrufNummer
	}
; -------------------------------------------------------
If(Optionen3="0")
	{
	Loop, HKEY_CURRENT_USER, Software\Microsoft\Windows\CurrentVersion\Explorer\ComDlg32\OpenSaveMRU
		{
		if a_LoopRegType = key
		value =
		else
			{
        		RegRead, value
        		if ErrorLevel
            			value = *error*
    			}
    		; MsgBox, 4, , %a_LoopRegName% = %value% (%a_LoopRegType%)`n`nContinue?
    		; IfMsgBox, NO, break
		IfExist %value% 
			{
			WindowInfo=%WindowInfo%`r`n%value%
			}
		}
	}
; MsgBox % WindowInfo
; -------------------------------------------------------
If(Optionen3="0")
	{
	WinGet, id, list,,, Program Manager
	Loop, %id%
		{
		this_id := id%A_Index%
		; WinActivate, ahk_id %this_id%
		; WinGetClass, ThisWindowClass, ahk_id %this_id%
		WinGetTitle, ThisWindowTitle, ahk_id %this_id%
		WindowInfo=%WindowInfo%`r`n%ThisWindowTitle%
		WinGetText, ThisWindowText , ahk_id %this_id%
		StringLeft,ThisWindowText,ThisWindowText, 1000
		WindowInfo=%WindowInfo%`r`n%ThisWindowText%
		ControlGetText, ThisControlText, , ahk_id %this_id%
		StringLeft,ThisControlText,ThisControlText, 1000
		WindowInfo=%WindowInfo%`r`n%ThisControlText%
		}
	}
Loop, parse, WindowInfo, `n, `r
	{
	If Not(instr(A_LoopField,"="))
		{
		If Not(instr(A_LoopField,"?"))
			{
			If Not(instr(DefaultFolder,A_LoopField))
				{
				If((FileExist(A_LoopField)AND(Optionen4="0")) OR (InStr(FileExist(A_LoopField),"D")AND(Optionen4="1")))
					{
					++ThisAufrufNummer
					DefaultFolder=%DefaultFolder%`r`n%ThisAufrufNummer%	%A_LoopField%
					}
				}
			}
		}
	}
; MsgBox % DefaultFolder
If (AnzeigeText="")
	AnzeigeText=Ordner-VorAuswahl-Nummer eingeben (mehrere Ordner Leerzeichen-getrennt, -... Ordner drüber, +... händisch weiter)
InputBox, DefaultFolderRueck,%AnzeigeText%,%DefaultFolder%,,800,800,,,,,%LastDefaultFolder%
If ErrorLevel
	{
	; Pause
	Return
	}
LastDefaultFolder:=DefaultFolderRueck
StringReplace,DefaultFolderRueck,DefaultFolderRueck,``%A_Space%,`%A_Space`%,All			; `Leerzeichen-->%A_Space%

FileDelete,%VorschlagListenPfad%.tmp
FileAppend,%DefaultFolder%,%VorschlagListenPfad%.tmp

StringSplit, OutputArrayDefaultFolderRueck, DefaultFolderRueck ,%A_Space%
; Msgbox % OutputArrayDefaultFolderRueck0 "	" OutputArrayDefaultFolderRueck1 "	" OutputArrayDefaultFolderRueck2
Loop %OutputArrayDefaultFolderRueck0%
	{
	ThisDefaultFolderRueck:=OutputArrayDefaultFolderRueck%A_Index%
	ThisDefaultFolderRueck := RegExReplace(ThisDefaultFolderRueck, "\\$")		; Ordner ohne ...\
	OrdnerNaeherWurzel:=0
	OrdnerHaendisch=Nein
	DoppeltenSuchePrefix=
	Loop
		{
		If(SubStr(ThisDefaultFolderRueck,1,1)="+")
			{
			OrdnerHaendisch=Ja
			StringTrimLeft, ThisDefaultFolderRueck, ThisDefaultFolderRueck,1
			}
		Else If(SubStr(ThisDefaultFolderRueck,1,1)="-")
			{
			++OrdnerNaeherWurzel
			StringTrimLeft, ThisDefaultFolderRueck, ThisDefaultFolderRueck,1
			}
		Else If(SubStr(ThisDefaultFolderRueck,1,1)=":")
			{
			DoppeltenSuchePrefix:=":"
			StringTrimLeft, ThisDefaultFolderRueck, ThisDefaultFolderRueck,1
			}
		Else
			Break
		}
	StringReplace,ThisDefaultFolderRueck,ThisDefaultFolderRueck,`%A_Space`%,%A_Space%,All	; %A_Space%-->Leerzeichen
	; MsgBox % ThisDefaultFolderRueck
	If (ThisDefaultFolderRueck = "" AND OrdnerHaendisch="Nein")
		{
		Break
		}
	; Else IfExist %ThisDefaultFolderRueck%
	Else if ThisDefaultFolderRueck is not integer
		{

		Loop % OrdnerNaeherWurzel
			{
			LastBackslash:=InStr(ThisDefaultFolderRueck,"\","",0)-1
			StringMid,ThisDefaultFolderRueck,ThisDefaultFolderRueck,1,%LastBackslash%
			}
		If(OrdnerHaendisch="Ja")
			{
			FileSelectFolder, ThisDefaultFolderRueck,*%ThisDefaultFolderRueck%\, 3, wähle den Unterordner ...
			If ErrorLevel
				{
				; Pause
				Return
				}
			}
		; MsgBox % ThisDefaultFolderRueck

		if((Optionen2="0") Or (FileExist(ThisDefaultFolderRueck)AND(Optionen4="0")) OR (InStr(FileExist(ThisDefaultFolderRueck),"D")AND(Optionen4="1")))
			{
			If (A_Index = "1")
				{
				Folder=%DoppeltenSuchePrefix%%ThisDefaultFolderRueck%
				}
			Else
				{
				Folder=%Folder%`r`n%DoppeltenSuchePrefix%%ThisDefaultFolderRueck%
				}
			}
		}
	Else
		{
		FileReadLine, NumberAndFolder, %VorschlagListenPfad%.tmp, %ThisDefaultFolderRueck%
		TabPos:=InStr(NumberAndFolder, A_Tab)
		StringTrimLeft, FolderVorschlag, NumberAndFolder, %TabPos%
		; MsgBox % FolderVorschlag

		FolderVorschlag:=InnereVariablenExtrahieren(FolderVorschlag)

		Loop % OrdnerNaeherWurzel
			{
			LastBackslash:=InStr(FolderVorschlag,"\","",0)-1
			StringMid,FolderVorschlag,FolderVorschlag,1,%LastBackslash%
			}
		If(OrdnerHaendisch="Ja")
			{
			FileSelectFolder, FolderVorschlag,*%FolderVorschlag%,3, wähle den Unterordner ...
			If ErrorLevel
				{
				; Pause
				Return
				}
			}
		if((Optionen2="0") Or (FileExist(FolderVorschlag)AND(Optionen4="0")) OR (InStr(FileExist(FolderVorschlag),"D")AND(Optionen4="1")))
			{
			If (A_Index = "1")
				{
				Folder=%DoppeltenSuchePrefix%%FolderVorschlag%
				}
			Else
				{
				Folder=%Folder%`r`n%DoppeltenSuchePrefix%%FolderVorschlag%
				}
		       	}
		}
	}

FolderOrFiles:=Folder
; MsgBox % Folder
If(SubStr(FolderOrFiles,1,2)="`r`n")
	StringTrimLeft,FolderOrFiles,FolderOrFiles,2
FolderOrFilesAnz:=0
Loop, parse, FolderOrFiles, `n, `r
	{
	++FolderOrFilesAnz
	}

If(Optionen0="1" AND Optionen1="0")
	{
	If(FolderOrFilesAnz > "1")
		{
		MsgBox zu viele Ordner (max 1)
		Return
		}
	}
Else If(Optionen0="0" AND Optionen1="1")
	{
	If(FolderOrFilesAnz <> "2" OR FolderOrFilesAnz <> "0")
		{
		MsgBox nur 2 Ordner erlaubt
		Return
		}
	}
Else If(Optionen0="1" AND Optionen1="1")
	{
	If(FolderOrFilesAnz > "2")
		{
		MsgBox zu viele Ordner (max 2)
		Return		
		}
	}
; MsgBox % "|" FolderOrFiles "|"
Return FolderOrFiles		; Pro Zeile ein Objekt
}


ButtonLoadFolder: ; LinksKlick auf Button Load folder
Gui +OwnDialogs  ; Forces user to dismiss the following dialog before using main window.
{
IfNotExist %EigeneDateien%\SucheDateien\Folder.txt
	{
	IfNotExist %EigeneDateien%\SucheDateien
		FileCreateDir, %EigeneDateien%\SucheDateien
	FileAppend , %DefaultFolder%, %EigeneDateien%\SucheDateien\Folder.txt
	}
FileRead, DefaultFolder, %EigeneDateien%\SucheDateien\Folder.txt
; DefaultFolder:=InnereVariablenExtrahieren(DefaultFolder)
; InputBox, DefaultFolderRueck,Ordner-VorAuswahl-Nummer eingeben (mehrere Ordner Leerzeichen-getrennt),%DefaultFolder%,,800,800,,,,,%LastDefaultFolder%
DefaultFolderRueck:=LoadFolderOrFilesMitVorschlaegen()
; MsgBox DefaultFolderRueck = %DefaultFolderRueck%
DuplikateSuchen=nein
}
EinstiegLoadFolderDoppelte:
{
If(DefaultFolderRueck="")
	Return
LastDefaultFolder:=DefaultFolderRueck
StringLeft,DefaultFolderRueckL1, DefaultFolderRueck, 1
If(DefaultFolderRueckL1=":")
        {
        StringTrimLeft,DefaultFolderRueck, DefaultFolderRueck, 1
        DuplikateSuchen=Ja
        }
IfExist %DefaultFolderRueck%
        {
        ; MsgBox 1
        Folder=%DefaultFolderRueck%
        If (DuplikateSuchen="Ja")
                {
	        SelectedFileExtension=lst
                SelectedFile = NichtLeer
                ; MsgBox eins
		FileAppend,%Folder%`r`n,%A_temp%\FolderAddList.lst
		; Msgbox %A_temp%\FolderAddList.lst Eintrag geschrieben
		AktObjekt:=DuplikateSuchen(DefaultFolderRueck)
		; Goto ButtonOpenNachFileSelect
                ; MsgBox EINS
		GoSub DuplikateAnzeigen
                return
		}
        Else
                Goto EinstiegUebergebenerOrdner
        }
DoppeltenFensterOeffnen=Nein
StringSplit, OutputArrayDefaultFolderRueck, DefaultFolderRueck ,`n,`r
; Msgbox % OutputArrayDefaultFolderRueck0 "	" OutputArrayDefaultFolderRueck1
If(OutputArrayDefaultFolderRueck0>1 AND DuplikateSuchen="Ja")
	{
	MsgBox, 4, , Ist dies eine neue ordnerübergreifende Suche? (Press YES or NO)
	IfMsgBox YES
		{
    		Gosub BeginnDoppelteOrdneruebergreifend
		DoppeltenFensterOeffnen=Ja			; Noch einbauen ###################################
		}
	}
Loop %OutputArrayDefaultFolderRueck0%
	{
	ThisDefaultFolderRueck:=OutputArrayDefaultFolderRueck%A_Index%
        If (ThisDefaultFolderRueck = "")
		{
		Return
		}

	StringLeft,ThisDefaultFolderRueckL1, ThisDefaultFolderRueck, 1
	If(ThisDefaultFolderRueckL1=":")
 	       {
 	       StringTrimLeft,ThisDefaultFolderRueck, ThisDefaultFolderRueck, 1
 	       DuplikateSuchen=Ja
 	       }



	; FileReadLine, NumberAndFolder, %EigeneDateien%\SucheDateien\Folder.txt, %ThisDefaultFolderRueck%
	; TabPos:=InStr(NumberAndFolder, A_Tab)
	; StringTrimLeft, FolderVorschlag, NumberAndFolder, %TabPos%
	; FolderVorschlag:=InnereVariablenExtrahieren(FolderVorschlag)
	; MsgBox % FolderVorschlag
	IfExist %ThisDefaultFolderRueck%
		{
	        Folder=%ThisDefaultFolderRueck%
                If (A_Index < OutputArrayDefaultFolderRueck0)
                	{
                	; MsgBox 2
                	If (DuplikateSuchen="Ja")
                        	{
				SelectedFileExtension=lst
                        	SelectedFile = NichtLeer
                        	; MsgBox zwei
				AktObjekt:=DuplikateSuchen(Folder)
                        	If (Aktobjekt<>"")
                            		{
					GoSub DuplikateAnzeigen
                            		; MsgBox ZWEI
                            		; Continue
                            		}
		        	}
                    	Else
                        	{
                        	; MsgBox ZwEi
                        	Gosub EinstiegUebergebenerOrdner
                        	}
                    	}
                Else if (OutputArrayDefaultFolderRueck0 > 1)	; wenn Vorauswahl mehrere oder Blank -> kein Fileselect
                    	{
                    	; MsgBox 3
                    	If (DuplikateSuchen="Ja")
                        	{
				SelectedFileExtension=lst
                        	SelectedFile = NichtLeer
                        	; MsgBox drei
				AktObjekt:=DuplikateSuchen(Folder)
                        	If (Aktobjekt<>"")
                            		{
					Goto DuplikateAnzeigen
                            		; MsgBox DREI
                            		}
                        	Else
                            		Return
		        	}
                    	Else
                        	{
                        	; MsgBox DrEi
		        	Goto EinstiegUebergebenerOrdner
                        	}
                    	}
            	}
    	}
}
; FileSelectFolder, Folder,*%Folder%, 3, Select a folder to read:
; MsgBox 4
If (DuplikateSuchen="Ja")
    {
    SelectedFileExtension=lst
    SelectedFile = NichtLeer
    ; MsgBox vier
    FileAppend,%Folder%`r`n,%A_temp%\FolderAddList.lst
    ; Msgbox %A_temp%\FolderAddList.lst Eintrag geschrieben
    AktObjekt:=DuplikateSuchen(Folder)
    Goto DuplikateAnzeigen
    }
MsgBox Folder = "%Folder%"
; DoMitschrieb=%DoMitschrieb%`r`n%Folder%
EinstiegUebergebenerOrdner:
if not Folder  ; The user canceled the dialog.
    return
Gui, Submit,NoHide
If(CheckboxTypen+CheckboxF=2)
	TrayTip,SucheDateien,Checkbox "+" hat Vorrang vor Checkbox "Typen"!,5
If CheckboxR
	DoMitschrieb=%DoMitschrieb%`r`nCheckbox0=%Checkbox0%`r`nCheckboxTypen=%CheckboxTypen%`r`n%Folder%
EinstiegUebergebenerOrdnerNachSubmit:
; If (DuplikateSuchen="Ja")		; ################## prüfen #############
    ; FileAppend,%Folder%`r`n,%A_temp%\FolderAddList.lst
{
    ToolTip,beschäftigt,4,4
    ; Check if the last character of the folder name is a backslash, which happens for root 
	; directories such as C:\. If it is, remove it to prevent a double-backslash later on.
	StringRight, LastChar, Folder, 1
	if LastChar = \
	    StringTrimRight, Folder, Folder, 1  ; Remove the trailing backslash.
	
	; Ensure the variable has enough capacity to hold the longest file path. This is done
	; because ExtractAssociatedIconA() needs to be able to store a new filename in it.
	VarSetCapacity(Filename, 260)
	sfi_size = 352
	VarSetCapacity(sfi, sfi_size)
	
	; Gather a list of file names from the selected folder and append them to the ListView:
	GuiControl, -Redraw, MyListView  ; Improve performance by disabling redrawing during load.
	ToolTip, beschäftigt,4,4
	If CheckboxOhneIcon
	{
	    Loop %Folder%\*.*,%CheckboxF%,%Checkbox0%
	    {
		Gosub ThreadsBeenden

	        FileName := A_LoopFileFullPath  ; Must save it to a writable variable for use below.
	
	        ; Build a unique extension ID to avoid characters that are illegal in variable names,
	        ; such as dashes.  This unique ID method also performs better because finding an item
	        ; in the array does not require search-loop.
	        SplitPath, FileName,,, FileExt  ; Get the file's extension.
	        If CheckboxTypen
	            if FileExt Not in %SomeFilterTextTyp%
	            {
	                ; MsgBox % FileName
			If(CheckboxF="1")
			    {
			    if not InStr(FileExist(FileName),"D")			    
	                	Continue
			    }
			Else
			    Continue
	            }
	            FileGetTime, FileTime,%A_LoopFileFullPath%
                    LoopFileSize:=A_LoopFileSize
	            LV_Add("Icon" . "9999999", A_LoopFileName, A_LoopFileDir, LoopFileSize, FileExt,FileTime)
	    }
	   
	}
	Else
	{
            ; NextIconNumber:=1
	    Loop %Folder%\*.*,,%Checkbox0%
	    {
		Gosub ThreadsBeenden
	        FileName := A_LoopFileFullPath  ; Must save it to a writable variable for use below.
	
	        ; Build a unique extension ID to avoid characters that are illegal in variable names,
	        ; such as dashes.  This unique ID method also performs better because finding an item
	        ; in the array does not require search-loop.
	        SplitPath, FileName,,, FileExt  ; Get the file's extension.
	        If CheckboxTypen
	            if FileExt Not in %SomeFilterTextTyp%
	            {
	                ; MsgBox % FileName
	                Continue
	            }
	        if FileExt in EXE,ICO,ANI,CUR,LNK
	        {
	            ExtID := FileExt  ; Special ID as a placeholder.
	            IconNumber = 0  ; Flag it as not found so that these types can each have a unique icon.
	        }
                Else if FileExt in JPG,GIF,BMP,PNG,TIF,WMF,EMF
                {
                    ; MsgBox JPG oder GIF
                    IconNumber2:=0xFFFFFF
                    IconNumber:=NextIconNumber
                    Temp1:=IL_Add(ImageListID1, FileName,IconNumber,IconNumber2)
                    Temp2:=IL_Add(ImageListID2, FileName,IconNumber,IconNumber2)
		    If Not (Temp1 AND Temp2)
			{
			; MsgBox % FileName
	                ExtID = 0  ; Initialize to handle extensions that are shorter than others.
	                Loop 7     ; Limit the extension to 7 characters so that it fits in a 64-bit value.
	                {
	                    StringMid, ExtChar, FileExt, A_Index, 1
	                    if not ExtChar  ; No more characters.
	                        break
	                    ; Derive a Unique ID by assigning a different bit position to each character:
	                    ExtID := ExtID | (Asc(ExtChar) << (8 * (A_Index - 1)))
	                }
	                ; Check if this file extension already has an icon in the ImageLists. If it does,
	                ; several calls can be avoided and loading performance is greatly improved,
	                ; especially for a folder containing hundreds of files:
	                IconNumber := IconArray%ExtID%
			}
		    Else
                        Goto Bild
                    ; IconNumber:=IconNumber+1
                    ; MsgBox % IconNumber
                }
	        else  ; Some other extension/file-type, so calculate its unique ID.
	        {
	            ExtID = 0  ; Initialize to handle extensions that are shorter than others.
	            Loop 7     ; Limit the extension to 7 characters so that it fits in a 64-bit value.
	            {
	                StringMid, ExtChar, FileExt, A_Index, 1
	                if not ExtChar  ; No more characters.
	                    break
	                ; Derive a Unique ID by assigning a different bit position to each character:
	                ExtID := ExtID | (Asc(ExtChar) << (8 * (A_Index - 1)))
	            }
	            ; Check if this file extension already has an icon in the ImageLists. If it does,
	            ; several calls can be avoided and loading performance is greatly improved,
	            ; especially for a folder containing hundreds of files:
	            IconNumber := IconArray%ExtID%
	        }
	        if not IconNumber  ; There is not yet any icon for this extension, so load it.
	        {
	            ; Get the high-quality small-icon associated with this file extension:
	            if not DllCall("Shell32\SHGetFileInfoA", "str", FileName, "uint", 0, "str", sfi, "uint", sfi_size, "uint", 0x101)  ; 0x101 is SHGFI_ICON+SHGFI_SMALLICON
	                IconNumber = 9999999  ; Set it out of bounds to display a blank icon.
	            else ; Icon successfully loaded.
	            {
	                ; Extract the hIcon member from the structure:
	                hIcon = 0
	                Loop 4
	                    hIcon += *(&sfi + A_Index-1) << 8*(A_Index-1)
	                ; Add the HICON directly to the small-icon and large-icon lists.
	                ; Below uses +1 to convert the returned index from zero-based to one-based:
	                IconNumber := DllCall("ImageList_ReplaceIcon", "uint", ImageListID1, "int", -1, "uint", hIcon) + 1
	                DllCall("ImageList_ReplaceIcon", "uint", ImageListID2, "int", -1, "uint", hIcon)
	                ; Now that it's been copied into the ImageLists, the original should be destroyed:
	                DllCall("DestroyIcon", "uint", hIcon)
	                ; Cache the icon to save memory and improve loading performance:
	                IconArray%ExtID% := IconNumber
	            }
	        }
Bild:	
	        ; Create the new row in the ListView and assign it the icon number determined above:
		; Gosub ButtonOpti
                ; sleep MaxIconNumber
	        FileGetTime, FileTime,%A_LoopFileFullPath%
                If (IconNumber + 1  >=  MaxIconNumber)
			{
                	NextIconNumber:=IconNumber + 1
			MaxIconNumber:=IconNumber
			}
		Else
			{
			NextIconNumber:=MaxIconNumber + 1
			}
                ; MsgBox % IconNumber "	" NextIconNumber "	" MaxIconNumber
                LoopFileSize:=A_LoopFileSize
			
	        LV_Add("Icon" . IconNumber, A_LoopFileName, A_LoopFileDir, LoopFileSize, FileExt,FileTime)
	    }
	}
	Gosub ButtonOpti
	ToolTip,
	return
}
;
NurFileName:    ; einzelne Datei der Liste hinzufügen
Gui, Submit,NoHide
NurFileNameNachSubmit:
{
    SplitPath, FileName,ShortFileName,FileDir, FileExt  ; Get the file's extension.
	; MsgBox Filename = %Filename%
	If CheckboxTypen
	    if FileExt Not in %SomeFilterTextTyp%
	    {
	        ; MsgBox % FileName
	        Return
	    }
	FileGetTime, FileTime,%FileName%
	FileGetSize, FileSizeKB, %FileName%
	LV_Add("Icon" . 99999, ShortFileName, FileDir, FileSizeKB, FileExt,FileTime)
	return
}

ButtonSave: ; LinksKlick auf Button Save
{
	; FileSelectFile, SelectedFile, S32,*%SelectedFile%, speichert eine Trefferliste eine Befehlsdatei bzw. einen Filter ..., (*.lst) (*.do) (*.typ) (*.spez) (*.filter) (*.txt) (*.m3u)
	FileSelectFile, SelectedFile, S32,*%SelectedFile%, speichert eine Trefferliste eine Befehlsdatei bzw. einen Filter ..., (*.lst; *.do; *.typ; *.spez; *.filter; *.txt; *.m3u)
	if SelectedFile =
	    return
	SplitPath, SelectedFile , , , SelectedFileExtension
	if SelectedFileExtension =
	{
	    SelectedFile=%SelectedFile%.lst
	    SelectedFileExtension=lst
	}
	if (SelectedFileExtension = "do")
	{
		FileSelectFileUeberspringen=True
		Goto DoDateiSpeichern
	}
	if (SelectedFileExtension = "filter")
	{
	    FileDelete, %SelectedFile%
	    FileAppend , %SomeFilterText%,%SelectedFile%
	    return
	}
	else if (SelectedFileExtension = "spez")
	{
	    FileDelete, %SelectedFile%
	    FileAppend , %SomeFilterTextSpez%,%SelectedFile%
	    return
	}
	else if (SelectedFileExtension = "typ")
	{
	    FileDelete, %SelectedFile%
	    FileAppend , %SomeFilterTextTyp%,%SelectedFile%
	    return
	}
	else if (SelectedFileExtension = "m3u")
	{
	    ToolTip, beschäftigt,4,4
	    Spalte=
	    Loop % LV_GetCount()
	    {
	        LV_GetText(Spalte1, A_Index, 1) 
	        LV_GetText(Spalte2, A_Index, 2) 
	        Zeile=%Spalte2%\%Spalte1%
	        Spalte=%Spalte%%Zeile%`r`n
	        ; MsgBox %Spalte%
	    }
	    StringTrimRight, GesamtListe, Spalte,2
	    ToolTip,
	}
	else if (SelectedFileExtension = "lst")
	{
	    ControlGet, GesamtListe, List, , SysListView321,%A_ScriptName%
	}
	Else
	{
	    ; Ausgabe=`%S2`%`\`%S1`%`%A_Tab`%`%S3`%`%A_Tab`%`%S4`%`%A_Tab`%`%S5`%`r`n
	    InputBox, Ausgabe , Format, der Ausgabe`n`n(momentan ist `%CR`% am Ende notwendig),,800,,,,,, %Ausgabe%
	    if ErrorLevel
	        return
	    ToolTip, beschäftigt,4,4
	    Spalte=
	    Loop % LV_GetCount()
	    {
	        LV_GetText(S1, A_Index, 1) 
	        LV_GetText(S2, A_Index, 2) 
	        LV_GetText(S3, A_Index, 3) 
	        LV_GetText(S4, A_Index, 4) 
	        LV_GetText(S5, A_Index, 5) 
	        ; Ausgabe=%S2%\%S1%%A_Tab%%S3%%A_Tab%%S4%%A_Tab%%S5%`r`n
	        Zeile:=InnereVariablenExtrahieren(Ausgabe)
	        Spalte=%Spalte%%Zeile%
	        ; MsgBox %Spalte%
	    }
	    If (SubStr(Spalte, 0, 1) ="`n")
	        StringTrimRight, GesamtListe, Spalte,1
	    If (SubStr(Spalte, 0, 1) ="`r")
	        StringTrimRight, GesamtListe, Spalte,1
	    ToolTip,    
	        
	}
	ToolTip, beschäftigt,4,4
	FileDelete, %SelectedFile%
	FileAppend , %GesamtListe%,%SelectedFile%
	ToolTip,
	If SelectedFileExtension Not in %NotRunTypList%
	{
	    MsgBox,4,Starten,soll die Standardanwendung gestartet werden,10
	    IfMsgBox, No
	        Return  ; User pressed the "No" button.
	    IfMsgBox, Timeout
	        Return ; i.e. Assume "No" if it timed out.
	    Run,%SelectedFile%
	}
	return
}

ButtonOpen: ; LinksKlick auf Button Open

FileSelectFile, SelectedFile, 35,*%SelectedFile%, öffnet eine Trefferliste eine Befehlsdatei bzw. einen Filter,unterstuetzt (*.lst; *.do; *.typ; *.spez; *.filter)
ButtonOpenNachFileSelect:
	SplitPath, SelectedFile , , , SelectedFileExtension
DuplikateAnzeigen:
{
	if SelectedFile =
	    return
	else if (SelectedFileExtension = "do")
	{
	    Ue1=%SelectedFile%
	    Gosub BefehlsDateiVerarbeiten
	}
	else if (SelectedFileExtension = "typ")
	{
	    FileRead,SomeFilterTextTyp,%SelectedFile%
	    Gosub ButtonTyp
	}
	else if (SelectedFileExtension = "spez")
	{
	    FileRead,SomeFilterTextSpez,%SelectedFile%
	    Gosub ButtonSpez
	}
	else if (SelectedFileExtension = "filter")
	{
	    FileRead,SomeFilterText,%SelectedFile%
	    Gosub ButtonFilter
	}
	Else
	{
            If (DuplikateSuchen<>"Ja")
                {
                ; MsgBox EndAusListPath="%EndAusListPath%"
	        IfExist,%SelectedFile%				; IfExist,%EndAusListPath% stand vorher drin
	            FileRead, Aktobjekt,%SelectedFile%
	        Else
	            Return
	        ToolTip,beschäftigt,4,4
                loop 2
                    {
                    StringRight,AktobjektR1, Aktobjekt, 1
                    If(AktobjektR1="`r" OR AktobjektR1="`n")
                        StringTrimRight,Aktobjekt, Aktobjekt, 1
                    }
                }
            ; Else
		; DuplikateSuchen=nein
; DuplikateAnzeigen:
	    Loop, parse, Aktobjekt, `n, `r  ; Specifying `n prior to `r allows both Windows and Unix files to be parsed.
	    {
	        ; MsgBox, 4, , Line number %A_Index% is %A_LoopField%.`n`nContinue?
	        ; IfMsgBox, No, break
	        Loop, parse, A_LoopField, %A_Tab%
	        {
	            Spalte%A_Index%:=A_LoopField
	        }
	        LV_Add("",Spalte1,Spalte2,Spalte3,Spalte4,Spalte5)
	    }
	    Gosub ButtonOpti
	    ToolTip,
	}
	If(DoppeltenFensterOeffnen="Ja")
		{
		IfWinNotExist Doppelte
			{
			DoppeltenFensterOeffnen=Nein
			; SetTimer,DoppelteBearbeiten,-100 
			}
		Else
			WinActivate, Doppelte
		}
	return
}

ButtonClear: ; LinksKlick auf Button Clear
Gui, Submit,NoHide
ButtonClearNachSubmit:
{
	If CheckboxR
		DoMitschrieb=%DoMitschrieb%`r`nButtonClearNachSubmit
	LV_Delete()  ; Clear the ListView, but keep icon cache intact for simplicity.
	; NextIconNumber:=1 ; ist falsch
	Gosub ButtonOpti
	return
}

ButtonSwitch: ; LinksKlick auf Button Switch View
{
	if not IconView
	    GuiControl, +Icon, MyListView    ; Switch to icon view.
	else
	    GuiControl, +Report, MyListView  ; Switch back to details view.
	IconView := not IconView             ; Invert in preparation for next time.
	return
}

ButtonOpti: ; LinksKlick auf Button Opti
{
	GuiControl, +Redraw, MyListView  ; Re-enable redrawing (it was disabled above).
	LV_ModifyCol()  ; Auto-size each column to fit its contents.
	LV_ModifyCol(3, 55) ; Make the Size column at little wider to reveal its header.
	DateiAnzahl:=LV_GetCount()
	GuiControl,, ZeigeDateiAnzahl, %DateiAnzahl%
	Return
}
OptiRechts:
{
    GuiControl, +Redraw, MyListView  ; Re-enable redrawing (it was disabled above).
    WinGetPos ,,,AktWidth,,ahk_class AutoHotkeyGUI
    Sp1:=(AktWidth-110)/3.6
    Sp2:=(AktWidth-110)/1.8
    ; LV_ModifyCol()  ; Auto-size each column to fit its contents.
    LV_ModifyCol(1, Sp1) ; 
    LV_ModifyCol(2,Sp2) ; 
    LV_ModifyCol(3, 45) ; 
    LV_ModifyCol(4) ; Auto-size each column 4
    LV_ModifyCol(5) ; Auto-size each column 5
    DateiAnzahl:=LV_GetCount()
    GuiControl,, ZeigeDateiAnzahl, %DateiAnzahl%
    return
}

ZeigeDateiAnzahl:
{
	; GuiControl, +Redraw, MyListView  ; Re-enable redrawing (it was disabled above).
	DateiAnzahl:=LV_GetCount()
	GuiControl,, ZeigeDateiAnzahl, %DateiAnzahl%
        ; traytip,jetzt,  ZeigeDateiAnzahl = %DateiAnzahl%,1
	Return
}
;
ButtonFilter: ; LinksKlick auf Button Filter
Gui, Submit,NoHide
If((Checkbox1+Checkbox2+CheckboxTxt)<>"0")
    InputBox, SomeFilterText , Filter, soll enthalten,,,,,,,, %SomeFilterText%
if ErrorLevel
{
    If CheckboxR
	{
		DoMitschrieb=%DoMitschrieb%`r`nCheckbox1=%Checkbox1%`r`nCheckbox2=%Checkbox2%`r`nCheckboxTxt=%CheckboxTxt%`r`nCheckboxOhneIcon=%CheckboxOhneIcon%`r`nSomeFilterText=%SomeFilterText%
	}
    return
}
ButtonFilterOhneInput:
{
; SuchFallFilter:                  Haken
;                D?P?T?S?I?        egal
;                 0 0 0 0 0        nicht gehakt
;                 1 1 1 1 1        gehakt
;                      -1          gegraut
;                Datei
;                  Pfad
;                    Text
;                      Icon
;                        Selektierte
    If CheckboxR
	{
		DoMitschrieb=%DoMitschrieb%`r`nCheckbox1=%Checkbox1%`r`nCheckbox2=%Checkbox2%`r`nCheckboxTxt=%CheckboxTxt%`r`nCheckboxOhneIcon=%CheckboxOhneIcon%`r`nCheckboxSel=%CheckboxSel%`r`nSomeFilterText=%SomeFilterText%`r`nButtonFilterOhneInput
	}
	ToolTip, beschäftigt,4,4
        If(CheckboxSel=-1)
            Gosub SelektierteSichern
	Else
            Gosub Sichern
	Z_Index:=LV_GetCount()
        RowNumber := 0
; ##############################################################
	ThisSomeFilterText:=SomeFilterText
	SucheInVarFunc=InStr
	SucheInFileFunc=InFile
        Gosub SuchFallFilterD%Checkbox1%P%Checkbox2%T%CheckboxTxt%S%CheckboxSel%I%CheckboxOhneIcon%
; ##############################################################
        If (CheckboxOhneIcon=1)
            Gosub SelectUp
	Gosub ButtonOpti
	ToolTip,
	return
}
ButtonSpez: ; LinksKlick auf Button Spez
Gui, Submit,NoHide
InputBox, SomeFilterTextSpez , Filter, RegExMatch,,,,,,,, %SomeFilterTextSpez%
if ErrorLevel
{
    If CheckboxR
	{
		DoMitschrieb=%DoMitschrieb%`r`nCheckbox1=%Checkbox1%`r`nCheckbox2=%Checkbox2%`r`nCheckboxTxt=%CheckboxTxt%`r`nCheckboxOhneIcon=%CheckboxOhneIcon%`r`nSomeFilterTextSpez=%SomeFilterTextSpez%
	}
    return
}
ButtonSpezOhneInput:
{
    If CheckboxR
	{
		DoMitschrieb=%DoMitschrieb%`r`nCheckbox1=%Checkbox1%`r`nCheckbox2=%Checkbox2%`r`nCheckboxTxt=%CheckboxTxt%`r`nCheckboxOhneIcon=%CheckboxOhneIcon%`r`nSomeFilterText=%SomeFilterText%`r`nButtonFilterOhneInput
	}
	ToolTip, beschäftigt,4,4
        If(CheckboxSel=-1)
            Gosub SelektierteSichern
	Else
            Gosub Sichern
	Z_Index:=LV_GetCount()
        RowNumber := 0
; ##############################################################
	ThisSomeFilterText:=SomeFilterTextSpez
	SucheInVarFunc=RegExMatch
	SucheInFileFunc=RegExMatchFile
        Gosub SuchFallFilterD%Checkbox1%P%Checkbox2%T%CheckboxTxt%S%CheckboxSel%I%CheckboxOhneIcon%
; ##############################################################
        If (CheckboxOhneIcon=1)
            Gosub SelectUp
	Gosub ButtonOpti
	ToolTip,
	return
}

SuchFallFilterD0P0T0S0I0:
SuchFallFilterD0P0T0S0I1:
SuchFallFilterD0P0T0S1I0:
SuchFallFilterD0P0T0S1I1:
SuchFallFilterD0P0T0S-1I0:
SuchFallFilterD0P0T0S-1I1:
{
; MsgBox Es wurde nichts ausgewählt worin gesuchgt werden soll.`n(1, 2 oder txt abhaken)
; ##############################################################################################
If(Suchmuster="")
    {
    IfExist %EigeneDateien%\SucheDateien\SuchmusterVorlage.txt
        {
        FileRead, SuchmusterVorlage, %EigeneDateien%\SucheDateien\SuchmusterVorlage.txt
        SuchmusterVorlage:=InnereVariablenExtrahieren(SuchmusterVorlage)
        }
    InputBox, SuchmusterVorlage, Suchmuster-Eingabe, Dateigröße von bis	letzte Änderung von bis  (Format: YYYY[MMDDHHMMSS] ),,800,200,,,,,%SuchmusterVorlage%
    if ErrorLevel
	Return
    }
Else
    {
    SuchmusterVorlage:=Suchmuster
    Suchmuster=
    }
; if Not ErrorLevel
    {
    StringReplace,SuchmusterVorlage,SuchmusterVorlage,~,=, All		; Für Scripte kann ~ statt = verwendet werden
    StringSplit, OutputArraySuchmusterVorlage, SuchmusterVorlage ,%A_Space%
    ; IndexSuch:=1
    Loop % OutputArraySuchmusterVorlage0
    {
	    StringSplit, OutputArrayVariablenZuweisung,OutputArraySuchmusterVorlage%A_Index%,=
            %OutputArrayVariablenZuweisung1%=%OutputArrayVariablenZuweisung2%
            ; MsgBox %OutputArrayVariablenZuweisung1%=%OutputArrayVariablenZuweisung2%
    }
    Loop % 14 - StrLen(VonGeaendert)
        VonGeaendert=%VonGeaendert%0
    Loop % 14 - StrLen(BisGeaendert)
        BisGeaendert=%BisGeaendert%0
    ; MsgBox % BisGeaendert 
            If (CheckboxSel="-1")
                {
	        Loop
	            {
		    Gosub ThreadsBeenden
	            RowNumber := LV_GetNext(RowNumber)
	            if not RowNumber  ; The above returned zero, so there are no more selected rows.
	                break
		    LV_GetText(FileName, RowNumber, 1)
		    LV_GetText(FileDir, RowNumber, 2)
		    LV_GetText(SizeKB, RowNumber, 3)
		    LV_GetText(FileModify, RowNumber, 5)
		    ThisFileName:= FileDir "\" FileName
		    ; MsgBox %  ThisFileName
                    ; FileGetTime, FileModify , %ThisFileName%, M
	            If Not (VonGeaendert <= FileModify AND FileModify <= BisGeaendert AND VonB <= SizeKB AND SizeKB <= BisB)
                        {
                            LV_Modify(RowNumber, "-Select")  ; deselect
	                }
	            }
                }
            Else
                {
	        Loop % SListeMerkenAnzahl
	            {
		        Gosub ThreadsBeenden
			LV_GetText(FileName, Z_Index, 1)
			LV_GetText(FileDir, Z_Index, 2)
			LV_GetText(SizeKB, Z_Index, 3)
			LV_GetText(FileModify, Z_Index, 5)
			ThisFileName:= FileDir "\" FileName
 			; MsgBox %  ThisFileName
                        ; FileGetTime, FileModify , %ThisFileName%, M
	                {
	                ; MsgBox Zeile %Z_Index%
                        If (CheckboxSel="0")
                            {
        	            If Not (VonGeaendert <= FileModify AND FileModify <= BisGeaendert AND VonB <= SizeKB AND SizeKB <= BisB)
	                        LV_Delete(Z_Index)
                            }
                        Else
        	            {
                            If (VonGeaendert <= FileModify AND FileModify <= BisGeaendert AND VonB <= SizeKB AND SizeKB <= BisB)
                                LV_Modify(Z_Index, "Select")
                            }
	                }
	            --Z_Index
	            }
                }
    }
Return
}


SuchFallFilterD0P0T1S0I0:
	        {
	        Loop % SListeMerkenAnzahl
	            {
		    Gosub ThreadsBeenden
	                ; MsgBox Zeile %Z_Index%
                            If (TextTypList="*")
			        Typ=*
		            Else
				LV_GetText(Typ, Z_Index, 4)
	                    If Typ in %TextTypList%
	                        {
				LV_GetText(FileName, Z_Index, 1)
				LV_GetText(FileDir, Z_Index, 2)
				ThisFileName:= FileDir "\" FileName
				; MsgBox %  ThisFileName
				if Not %SucheInFileFunc%(ThisFileName, ThisSomeFilterText)
			                LV_Delete(Z_Index)
				; MsgBox % FileName "	" ZeileBleibt%Z_Index%
	                        }
			Else
	            LV_Delete(Z_Index)
	        --Z_Index
	            }
                }
Return
SuchFallFilterD1P0T1S0I0:
	        {
	    ; MsgBox 1+2 Checked
	    Loop % SListeMerkenAnzahl
	    {
		Gosub ThreadsBeenden
	        if Not %SucheInVarFunc%(Zeile%Z_Index%Spalte1, ThisSomeFilterText)
	            ; if Not %SucheInVarFunc%(Zeile%Z_Index%Spalte2, ThisSomeFilterText)
	                ; {
	                ; MsgBox Zeile %Z_Index%
                            If (TextTypList="*")
			        Typ=*
		            Else
				LV_GetText(Typ, Z_Index, 4)
	        If Typ in %TextTypList%
	        {
				LV_GetText(FileName, Z_Index, 1)
				LV_GetText(FileDir, Z_Index, 2)
				ThisFileName:= FileDir "\" FileName
				; MsgBox %  ThisFileName
				if Not %SucheInFileFunc%(ThisFileName, ThisSomeFilterText)
			                LV_Delete(Z_Index)
				; MsgBox % FileName "	" ZeileBleibt%Z_Index%
	        }
			Else
	            LV_Delete(Z_Index)
	        --Z_Index
	    }
                }
Return
SuchFallFilterD1P0T0S0I0:
	        {
	        ; MsgBox 1 Checked
	        Loop % SListeMerkenAnzahl
	            {
		    Gosub ThreadsBeenden
	            If Not %SucheInVarFunc%(Zeile%Z_Index%Spalte1, ThisSomeFilterText)
	                {
	                ; MsgBox Zeile %Z_Index%
	                LV_Delete(Z_Index)
	                }
	            --Z_Index
	            }

	        }
Return
SuchFallFilterD0P1T1S0I0:
	{
	    ; MsgBox 1+2 Checked
	    Loop % SListeMerkenAnzahl
	    {
		Gosub ThreadsBeenden
	        ; if Not %SucheInVarFunc%(Zeile%Z_Index%Spalte1, ThisSomeFilterText)
	            if Not %SucheInVarFunc%(Zeile%Z_Index%Spalte2, ThisSomeFilterText)
	            {
	                ; MsgBox Zeile %Z_Index%
                            If (TextTypList="*")
			        Typ=*
		            Else
		                LV_GetText(Typ, Z_Index, 4)
	                If Typ in %TextTypList%
	                {
	                    LV_GetText(FileName, Z_Index, 1)
	                    LV_GetText(FileDir, Z_Index, 2)
	                    ThisFileName:= FileDir "\" FileName
	                    ; MsgBox %  ThisFileName
	                    if Not %SucheInFileFunc%(ThisFileName, ThisSomeFilterText)
			                LV_Delete(Z_Index)
	                    ; MsgBox % FileName "	" ZeileBleibt%Z_Index%
	                }
	                Else
		                LV_Delete(Z_Index)
	            }
	            --Z_Index
	    }
        }
Return
SuchFallFilterD0P1T0S0I0:
	{
	    ; MsgBox 2 Checked
	    Loop % SListeMerkenAnzahl
	    {
		Gosub ThreadsBeenden
	        If Not %SucheInVarFunc%(Zeile%Z_Index%Spalte2, ThisSomeFilterText)
	        {
	            ; MsgBox Zeile %Z_Index%
	            LV_Delete(Z_Index)
	        }
	        --Z_Index
	    }
        }
Return
SuchFallFilterD1P1T1S0I0:
	        {
	        ; MsgBox 1+2 Checked
	        Loop % SListeMerkenAnzahl
	            {
		    Gosub ThreadsBeenden
	            if Not %SucheInVarFunc%(Zeile%Z_Index%Spalte1, ThisSomeFilterText)
	                if Not %SucheInVarFunc%(Zeile%Z_Index%Spalte2, ThisSomeFilterText)
	                    {
	                    ; MsgBox Zeile %Z_Index%
                            If (TextTypList="*")
			        Typ=*
		            Else
		                LV_GetText(Typ, Z_Index, 4)
	                    If Typ in %TextTypList%
	                        {
	                        LV_GetText(FileName, Z_Index, 1)
	                        LV_GetText(FileDir, Z_Index, 2)
	                        ThisFileName:= FileDir "\" FileName
	                        ; MsgBox %  ThisFileName
	                        if Not %SucheInFileFunc%(ThisFileName, ThisSomeFilterText)
			                LV_Delete(Z_Index)
	                        ; MsgBox % FileName "	" ZeileBleibt%Z_Index%
	                    }
	                    Else
	                        LV_Delete(Z_Index)
	                    }
	            --Z_Index
	            }
                }
Return
SuchFallFilterD1P1T0S0I0:
	        {
	    ; MsgBox 1+2 Checked
	
	    Loop % SListeMerkenAnzahl
	    {
		Gosub ThreadsBeenden
	        if Not %SucheInVarFunc%(Zeile%Z_Index%Spalte1, ThisSomeFilterText)
	            if Not %SucheInVarFunc%(Zeile%Z_Index%Spalte2, ThisSomeFilterText)
	            {
	                ; MsgBox Zeile %Z_Index%
	                LV_Delete(Z_Index)
	            }
	        --Z_Index
	    }
                }
Return
SuchFallFilterD1P0T1S0I1:
	        {
	    ; MsgBox 1+2 Checked
	    Loop % SListeMerkenAnzahl
	    {
	        Gosub ThreadsBeenden
	        ZeileBleibt%Z_Index%:=1
	        if Not %SucheInVarFunc%(Zeile%Z_Index%Spalte1, ThisSomeFilterText)
	        {
	            ; if Not %SucheInVarFunc%(Zeile%Z_Index%Spalte2, ThisSomeFilterText)
	                ; {
	                ; MsgBox Zeile %Z_Index%
                            If (TextTypList="*")
			        Typ=*
		            Else
		                LV_GetText(Typ, Z_Index, 4)
	            If Typ in %TextTypList%
				{
	                LV_GetText(FileName, Z_Index, 1)
	                LV_GetText(FileDir, Z_Index, 2)
	                ThisFileName:= FileDir "\" FileName
	                ; MsgBox %  ThisFileName
	                if Not %SucheInFileFunc%(ThisFileName, ThisSomeFilterText)
	                    ZeileBleibt%Z_Index%:=0
	                ; MsgBox % FileName "	" ZeileBleibt%Z_Index%
				}
			Else
				ZeileBleibt%Z_Index%:=0
	                ; }                
	        }
	        --Z_Index
	    }
	    LV_Delete()
	    Loop % SListeMerkenAnzahl
	    {
	        If (ZeileBleibt%A_Index%)
	        {
	            LV_Add("Icon" . "9999999", Zeile%A_Index%Spalte1,Zeile%A_Index%Spalte2,Zeile%A_Index%Spalte3,Zeile%A_Index%Spalte4,Zeile%A_Index%Spalte5)
	            ; MsgBox % A_Index
	        }
	    }
                }
Return
SuchFallFilterD1P0T0S0I1:
	    {
	    ; MsgBox 1 Checked
	    Loop % SListeMerkenAnzahl
	        {
		Gosub ThreadsBeenden
	        If %SucheInVarFunc%(Zeile%Z_Index%Spalte1, ThisSomeFilterText)
	        {
	            ; MsgBox Zeile %Z_Index%
	            ZeileBleibt%Z_Index%:=1
	        }
	        Else
	            ZeileBleibt%Z_Index%:=0
	        --Z_Index
	        }
	    LV_Delete()
	    Loop % SListeMerkenAnzahl
	        {
	        If (ZeileBleibt%A_Index%)
	            LV_Add("Icon" . "9999999", Zeile%A_Index%Spalte1,Zeile%A_Index%Spalte2,Zeile%A_Index%Spalte3,Zeile%A_Index%Spalte4,Zeile%A_Index%Spalte5)
	        }
	    }
Return
SuchFallFilterD0P0T1S0I1:
	        {
	    ; MsgBox 1+2 Checked
	    Loop % SListeMerkenAnzahl
	    {
		Gosub ThreadsBeenden
	        ZeileBleibt%Z_Index%:=1
	        ; if Not %SucheInVarFunc%(Zeile%Z_Index%Spalte1, ThisSomeFilterText)
	            ; {
	            ; if Not %SucheInVarFunc%(Zeile%Z_Index%Spalte2, ThisSomeFilterText)
	                ; {
	                ; MsgBox Zeile %Z_Index%
                            If (TextTypList="*")
			        Typ=*
		            Else
				LV_GetText(Typ, Z_Index, 4)
	        If Typ in %TextTypList%
	        {
				LV_GetText(FileName, Z_Index, 1)
				LV_GetText(FileDir, Z_Index, 2)
				ThisFileName:= FileDir "\" FileName
				; MsgBox %  ThisFileName
				if Not %SucheInFileFunc%(ThisFileName, ThisSomeFilterText)
		                	ZeileBleibt%Z_Index%:=0
				; MsgBox % FileName "	" ZeileBleibt%Z_Index%
	        }
			Else
				ZeileBleibt%Z_Index%:=0
	                ; }                
	            ; }
	        --Z_Index
	    }
	    LV_Delete()
	    Loop % SListeMerkenAnzahl
	    {
	        If (ZeileBleibt%A_Index%)
	        {
	            LV_Add("Icon" . "9999999", Zeile%A_Index%Spalte1,Zeile%A_Index%Spalte2,Zeile%A_Index%Spalte3,Zeile%A_Index%Spalte4,Zeile%A_Index%Spalte5)
	            ; MsgBox % A_Index
	        }
	    }
                }
Return
SuchFallFilterD0P1T1S0I1:
	        {
	    ; MsgBox 1+2 Checked
	    Loop % SListeMerkenAnzahl
	    {
		Gosub ThreadsBeenden
	        ZeileBleibt%Z_Index%:=1
	        ; if Not %SucheInVarFunc%(Zeile%Z_Index%Spalte1, ThisSomeFilterText)
	            ; {
	            if Not %SucheInVarFunc%(Zeile%Z_Index%Spalte2, ThisSomeFilterText)
	            {
	                ; MsgBox Zeile %Z_Index%
                            If (TextTypList="*")
			        Typ=*
		            Else
		                LV_GetText(Typ, Z_Index, 4)
	                If Typ in %TextTypList%
	                {
	                    LV_GetText(FileName, Z_Index, 1)
	                    LV_GetText(FileDir, Z_Index, 2)
	                    ThisFileName:= FileDir "\" FileName
	                    ; MsgBox %  ThisFileName
	                    if Not %SucheInFileFunc%(ThisFileName, ThisSomeFilterText)
		                	ZeileBleibt%Z_Index%:=0
	                    ; MsgBox % FileName "	" ZeileBleibt%Z_Index%
	                }
			Else
				ZeileBleibt%Z_Index%:=0
	            }                
	            ; }
	        --Z_Index
	    }
	    LV_Delete()
	    Loop % SListeMerkenAnzahl
	    {
	        If (ZeileBleibt%A_Index%)
	        {
	            LV_Add("Icon" . "9999999", Zeile%A_Index%Spalte1,Zeile%A_Index%Spalte2,Zeile%A_Index%Spalte3,Zeile%A_Index%Spalte4,Zeile%A_Index%Spalte5)
		    ; MsgBox % A_Index
	        }
	    }
                }
Return
SuchFallFilterD0P1T0S0I1:
	        {
	    ; MsgBox 1 Checked
	    Loop % SListeMerkenAnzahl
	    {
		Gosub ThreadsBeenden
	        If %SucheInVarFunc%(Zeile%Z_Index%Spalte2, ThisSomeFilterText)
	        {
	            ; MsgBox Zeile %Z_Index%
	            ZeileBleibt%Z_Index%:=1
	        }
	        Else
	            ZeileBleibt%Z_Index%:=0
	        --Z_Index
	    }
	    LV_Delete()
	    Loop % SListeMerkenAnzahl
	    {
	        If (ZeileBleibt%A_Index%)
	            LV_Add("Icon" . "9999999", Zeile%A_Index%Spalte1,Zeile%A_Index%Spalte2,Zeile%A_Index%Spalte3,Zeile%A_Index%Spalte4,Zeile%A_Index%Spalte5)
	    }
                }
Return
SuchFallFilterD1P1T1S0I1:
	        {
	    ; MsgBox 1+2 Checked
	    Loop % SListeMerkenAnzahl
	    {
		Gosub ThreadsBeenden
	        ZeileBleibt%Z_Index%:=1
	        if Not %SucheInVarFunc%(Zeile%Z_Index%Spalte1, ThisSomeFilterText)
	        {
	            if Not %SucheInVarFunc%(Zeile%Z_Index%Spalte2, ThisSomeFilterText)
	            {
	                ; MsgBox Zeile %Z_Index%
                            If (TextTypList="*")
			        Typ=*
		            Else
		                LV_GetText(Typ, Z_Index, 4)
	                If Typ in %TextTypList%
	                {
	                    LV_GetText(FileName, Z_Index, 1)
	                    LV_GetText(FileDir, Z_Index, 2)
	                    ThisFileName:= FileDir "\" FileName
	                    ; MsgBox %  ThisFileName
	                    if Not %SucheInFileFunc%(ThisFileName, ThisSomeFilterText)
		                	ZeileBleibt%Z_Index%:=0
	                    ; MsgBox % FileName "	" ZeileBleibt%Z_Index%
	                }
	                Else
	                    ZeileBleibt%Z_Index%:=0
	            }                
	        }
	        --Z_Index
	    }
	    LV_Delete()
	    Loop % SListeMerkenAnzahl
	    {
	        If (ZeileBleibt%A_Index%)
	        {
	            LV_Add("Icon" . "9999999", Zeile%A_Index%Spalte1,Zeile%A_Index%Spalte2,Zeile%A_Index%Spalte3,Zeile%A_Index%Spalte4,Zeile%A_Index%Spalte5)
	            ; MsgBox % A_Index
	        }
	    }
                }
Return
SuchFallFilterD1P1T0S0I1:
	        {
	    ; MsgBox 1+2 Checked
	    Loop % SListeMerkenAnzahl
	    {
		Gosub ThreadsBeenden
	        ZeileBleibt%Z_Index%:=1
	        if Not %SucheInVarFunc%(Zeile%Z_Index%Spalte1, ThisSomeFilterText)
	        {
	            if Not %SucheInVarFunc%(Zeile%Z_Index%Spalte2, ThisSomeFilterText)
	            {
	                ; MsgBox Zeile %Z_Index%
	                ZeileBleibt%Z_Index%:=0
	            }                
	        }
	        --Z_Index
	    }
	    LV_Delete()
	    Loop % SListeMerkenAnzahl
	    {
	        If (ZeileBleibt%A_Index%)
	            LV_Add("Icon" . "9999999", Zeile%A_Index%Spalte1,Zeile%A_Index%Spalte2,Zeile%A_Index%Spalte3,Zeile%A_Index%Spalte4,Zeile%A_Index%Spalte5)
	    }
                }
Return

SuchFallFilterD0P0T1S-1I0:
SuchFallFilterD0P0T1S-1I1:
	        Loop
	            {
		    Gosub ThreadsBeenden
	            RowNumber := LV_GetNext(RowNumber)
	            if not RowNumber  ; The above returned zero, so there are no more selected rows.
	                break
	            LV_GetText(FileName, RowNumber, 1)
    	                LV_GetText(FileDir, RowNumber, 2)
                            If (TextTypList="*")
			        Typ=*
		            Else
	                        LV_GetText(Typ, RowNumber, 4)
	                    If Typ in %TextTypList%
	                        {
	                        ThisFileName:= FileDir "\" FileName
	                        ; MsgBox %  ThisFileName
	                        if Not %SucheInFileFunc%(ThisFileName, ThisSomeFilterText)
			                LV_Modify(RowNumber, "-Select")  ; deselect
	                        ; MsgBox % FileName "	" ZeileBleibt%Z_Index%
                                }
                            Else
                                LV_Modify(RowNumber, "-Select")  ; deselect
	            }
return
SuchFallFilterD0P0T1S1I0:
SuchFallFilterD0P0T1S1I1:
	        Loop % SListeMerkenAnzahl
	            {
		    Gosub ThreadsBeenden
                    If (TextTypList="*")
			Typ=*
		    Else
	                LV_GetText(Typ, Z_Index, 4)
	            If Typ in %TextTypList%
	                {
	                LV_GetText(FileName, Z_Index, 1)
	                LV_GetText(FileDir, Z_Index, 2)
	                ThisFileName:= FileDir "\" FileName
	                ; MsgBox %  ThisFileName
	                if %SucheInFileFunc%(ThisFileName, ThisSomeFilterText)
			    LV_Modify(Z_Index, "Select")  ; select
	                ; MsgBox % FileName "	" ZeileBleibt%Z_Index%
                        }
	            --Z_Index
	            }
return

SuchFallFilterD0P1T0S-1I0:
SuchFallFilterD0P1T0S-1I1:
	        Loop
	            {
		    Gosub ThreadsBeenden
	            RowNumber := LV_GetNext(RowNumber)
	            if not RowNumber  ; The above returned zero, so there are no more selected rows.
	                break
	            LV_GetText(FileName, RowNumber, 1)
    	                LV_GetText(FileDir, RowNumber, 2)
	                if Not %SucheInVarFunc%(FileDir, ThisSomeFilterText)
                            {
                                LV_Modify(RowNumber, "-Select")  ; deselect
	                    }
	            }
return
SuchFallFilterD0P1T0S1I0:
SuchFallFilterD0P1T0S1I1:
	        Loop % SListeMerkenAnzahl
	            {
		    Gosub ThreadsBeenden
	            if %SucheInVarFunc%(Zeile%Z_Index%Spalte2, ThisSomeFilterText)
                        {
                        LV_Modify(Z_Index, "Select")  ; select
	                    
	                ; MsgBox Zeile %Z_Index%
                        }
	            --Z_Index
	            }
return

SuchFallFilterD0P1T1S-1I0:
SuchFallFilterD0P1T1S-1I1:
	        Loop
	            {
		    Gosub ThreadsBeenden
	            RowNumber := LV_GetNext(RowNumber)
	            if not RowNumber  ; The above returned zero, so there are no more selected rows.
	                break
	            LV_GetText(FileName, RowNumber, 1)
    	                LV_GetText(FileDir, RowNumber, 2)
	                if Not %SucheInVarFunc%(FileDir, ThisSomeFilterText)
                            {
                            If (TextTypList="*")
			        Typ=*
		            Else
	                        LV_GetText(Typ, RowNumber, 4)
	                    If Typ in %TextTypList%
	                        {
	                        ThisFileName:= FileDir "\" FileName
	                        ; MsgBox %  ThisFileName
	                        if Not %SucheInFileFunc%(ThisFileName, ThisSomeFilterText)
			                LV_Modify(RowNumber, "-Select")  ; deselect
	                        ; MsgBox % FileName "	" ZeileBleibt%Z_Index%
                                }
                            Else
                                LV_Modify(RowNumber, "-Select")  ; deselect
	                    }
	            }
return
SuchFallFilterD0P1T1S1I0:
SuchFallFilterD0P1T1S1I1:
	        Loop % SListeMerkenAnzahl
	            {
		    Gosub ThreadsBeenden
                    If (TextTypList="*")
			Typ=*
		    Else
		        LV_GetText(Typ, Z_Index, 4)
	            if %SucheInVarFunc%(Zeile%Z_Index%Spalte2, ThisSomeFilterText)
                        {
                        LV_Modify(Z_Index, "Select")  ; select
                        }
	            Else If Typ in %TextTypList%
	                {
	                LV_GetText(FileName, Z_Index, 1)
	                LV_GetText(FileDir, Z_Index, 2)
	                ThisFileName:= FileDir "\" FileName
	                ; MsgBox %  ThisFileName
	                if %SucheInFileFunc%(ThisFileName, ThisSomeFilterText)
			    LV_Modify(Z_Index, "Select")  ; select
	                ; MsgBox % FileName "	" ZeileBleibt%Z_Index%
                        }
	            --Z_Index
	            }
return

SuchFallFilterD1P0T0S-1I0:
SuchFallFilterD1P0T0S-1I1:
	        ; RowNumber = 0  ; This causes the first iteration to start the search at the top.
	        Loop
	            {
		    Gosub ThreadsBeenden
	            RowNumber := LV_GetNext(RowNumber)
	            if not RowNumber  ; The above returned zero, so there are no more selected rows.
	                break
	            If Not %SucheInVarFunc%(Zeile%RowNumber%Spalte1, ThisSomeFilterText)
	                {
		        LV_Modify(RowNumber, "-Select")  ; deselect
                        ; MsgBox % Z_Index
	                }
	            }
return
SuchFallFilterD1P0T0S1I0:
SuchFallFilterD1P0T0S1I1:
	        Loop % SListeMerkenAnzahl
	            {
		    Gosub ThreadsBeenden
	            If %SucheInVarFunc%(Zeile%Z_Index%Spalte1, ThisSomeFilterText)
	                {
		        LV_Modify(Z_Index, "Select")  ; select
	                }
	            --Z_Index
	            }
return

SuchFallFilterD1P0T1S-1I0:
SuchFallFilterD1P0T1S-1I1:
	        Loop
	            {
		    Gosub ThreadsBeenden
	            RowNumber := LV_GetNext(RowNumber)
	            if not RowNumber  ; The above returned zero, so there are no more selected rows.
	                break
	            LV_GetText(FileName, RowNumber, 1)
	            if Not %SucheInVarFunc%(FileName, ThisSomeFilterText)
                        {
    	                LV_GetText(FileDir, RowNumber, 2)
                            If (TextTypList="*")
			        Typ=*
		            Else
	                        LV_GetText(Typ, RowNumber, 4)
	                    If Typ in %TextTypList%
	                        {
	                        ThisFileName:= FileDir "\" FileName
	                        ; MsgBox %  ThisFileName
	                        if Not %SucheInFileFunc%(ThisFileName, ThisSomeFilterText)
			                LV_Modify(RowNumber, "-Select")  ; deselect
	                        ; MsgBox % FileName "	" ZeileBleibt%Z_Index%
                                }
                            Else
                                LV_Modify(RowNumber, "-Select")  ; deselect
                        }
	            }
return
SuchFallFilterD1P0T1S1I0:
SuchFallFilterD1P0T1S1I1:
; MsgBox Nur selektieren wird in dieser Konstellation noch nicht unterstützt.
	        Loop % SListeMerkenAnzahl
	            {
		    Gosub ThreadsBeenden
                    If (TextTypList="*")
			Typ=*
		    Else
		        LV_GetText(Typ, Z_Index, 4)
	            if %SucheInVarFunc%(Zeile%Z_Index%Spalte1, ThisSomeFilterText)
                        LV_Modify(Z_Index, "Select")  ; select
	            Else If Typ in %TextTypList%
	                {
	                LV_GetText(FileName, Z_Index, 1)
	                LV_GetText(FileDir, Z_Index, 2)
	                ThisFileName:= FileDir "\" FileName
	                ; MsgBox %  ThisFileName
	                if %SucheInFileFunc%(ThisFileName, ThisSomeFilterText)
			    LV_Modify(Z_Index, "Select")  ; select
	                ; MsgBox % FileName "	" ZeileBleibt%Z_Index%
                        }
	            --Z_Index
	            }
return

SuchFallFilterD1P1T0S-1I0:
SuchFallFilterD1P1T0S-1I1:
; MsgBox Nur aus Selektierten wird in dieser Konstellation noch nicht unterstützt.
RowNumber := 0
	        Loop
	            {
		    Gosub ThreadsBeenden
	            RowNumber := LV_GetNext(RowNumber)
	            if not RowNumber  ; The above returned zero, so there are no more selected rows.
	                break
	            LV_GetText(FileName, RowNumber, 1)
	            if Not %SucheInVarFunc%(FileName, ThisSomeFilterText)
                        {
    	                LV_GetText(FileDir, RowNumber, 2)
	                if Not %SucheInVarFunc%(FileDir, ThisSomeFilterText)
                            {
                            LV_Modify(RowNumber, "-Select")  ; deselect
	                    }
                        }
	            }
return
SuchFallFilterD1P1T0S1I0:
SuchFallFilterD1P1T0S1I1:
	        Loop % SListeMerkenAnzahl
	            {
		    Gosub ThreadsBeenden
	            LV_GetText(Typ, Z_Index, 4)
	            if %SucheInVarFunc%(Zeile%Z_Index%Spalte1, ThisSomeFilterText)
                        LV_Modify(Z_Index, "Select")  ; select
	            Else if %SucheInVarFunc%(Zeile%Z_Index%Spalte2, ThisSomeFilterText)
                        {
                        LV_Modify(Z_Index, "Select")  ; select
	                    
	                ; MsgBox Zeile %Z_Index%
                        }
	            --Z_Index
	            }
return

SuchFallFilterD1P1T1S-1I0:
SuchFallFilterD1P1T1S-1I1:
	        Loop
	            {
		    Gosub ThreadsBeenden
	            RowNumber := LV_GetNext(RowNumber)
	            if not RowNumber  ; The above returned zero, so there are no more selected rows.
	                break
	            LV_GetText(FileName, RowNumber, 1)
	            if Not %SucheInVarFunc%(FileName, ThisSomeFilterText)
                        {
    	                LV_GetText(FileDir, RowNumber, 2)
	                if Not %SucheInVarFunc%(FileDir, ThisSomeFilterText)
                            {
                            If (TextTypList="*")
			        Typ=*
		            Else
	                        LV_GetText(Typ, RowNumber, 4)
	                    If Typ in %TextTypList%
	                        {
	                        ThisFileName:= FileDir "\" FileName
	                        ; MsgBox %  ThisFileName
	                        if Not %SucheInFileFunc%(ThisFileName, ThisSomeFilterText)
			                LV_Modify(RowNumber, "-Select")  ; deselect
	                        ; MsgBox % FileName "	" ZeileBleibt%Z_Index%
                                }
                            Else
                                LV_Modify(RowNumber, "-Select")  ; deselect
	                    }
                        }
	            }
return
SuchFallFilterD1P1T1S1I0:
SuchFallFilterD1P1T1S1I1:
	        Loop % SListeMerkenAnzahl
	            {
		    Gosub ThreadsBeenden
                    If (TextTypList="*")
			Typ=*
		    Else
		        LV_GetText(Typ, Z_Index, 4)
	            if %SucheInVarFunc%(Zeile%Z_Index%Spalte1, ThisSomeFilterText)
                        LV_Modify(Z_Index, "Select")  ; select
	            Else if %SucheInVarFunc%(Zeile%Z_Index%Spalte2, ThisSomeFilterText)
                        {
                        LV_Modify(Z_Index, "Select")  ; select
	                    
	                ; MsgBox Zeile %Z_Index%
                        }
	            Else If Typ in %TextTypList%
	                {
	                LV_GetText(FileName, Z_Index, 1)
	                LV_GetText(FileDir, Z_Index, 2)
	                ThisFileName:= FileDir "\" FileName
	                ; MsgBox %  ThisFileName
	                if %SucheInFileFunc%(ThisFileName, ThisSomeFilterText)
			    LV_Modify(Z_Index, "Select")  ; select
	                ; MsgBox % FileName "	" ZeileBleibt%Z_Index%
                        }
	            --Z_Index
	            }

return




ButtonTyp: ; LinksKlick auf Button Typ
Gui, Submit,NoHide
InputBox, SomeFilterTextTyp , Filter, Datei-Typ,,1000,,,,,, %SomeFilterTextTyp%
if ErrorLevel
{
    If CheckboxR
	{
		DoMitschrieb=%DoMitschrieb%`r`nCheckbox1=%Checkbox1%`r`nCheckbox2=%Checkbox2%`r`nCheckboxTxt=%CheckboxTxt%`r`nCheckboxOhneIcon=%CheckboxOhneIcon%`r`nSomeFilterTextTyp=%SomeFilterTextTyp%
	}
    return
}
ButtonTypOhneInput:
{
    If CheckboxR
	{
		DoMitschrieb=%DoMitschrieb%`r`nCheckbox1=%Checkbox1%`r`nCheckbox2=%Checkbox2%`r`nCheckboxTxt=%CheckboxTxt%`r`nCheckboxOhneIcon=%CheckboxOhneIcon%`r`nSomeFilterTextTyp=%SomeFilterTextTyp%`r`nButtonTypOhneInput
	}
	ToolTip, beschäftigt,4,4
	Gosub Sichern
	Z_Index:=SListeMerkenAnzahl
	If(NOT CheckboxOhneIcon OR CheckboxSel<>0)
	{
            If (CheckboxSel=1)							
	        {
                ; MsgBox Nur selektieren wird in dieser Konstellation noch nicht unterstützt.
	        Loop % SListeMerkenAnzahl
	            {
		    Gosub ThreadsBeenden
	            ; If Not InStr(Zeile%Z_Index%Spalte4, SomeFilterTextTyp)
	            if Zeile%Z_Index%Spalte4 in %SomeFilterTextTyp%
	                {
	                ; MsgBox Zeile %Z_Index%
		        LV_Modify(Z_Index, "Select")  ; select
	                ; LV_Delete(Z_Index)
	                }
	            --Z_Index
	            }
                If(CheckboxOhneIcon)
                    GoSub SelectUp
	        }
            Else If (CheckboxSel=-1)						
                {
	        RowNumber = 0  ; This causes the first iteration to start the search at the top.
	        Loop
	            {
		    Gosub ThreadsBeenden
	            RowNumber := LV_GetNext(RowNumber)
	            if not RowNumber  ; The above returned zero, so there are no more selected rows.
	                break
	            If Not InStr(Zeile%RowNumber%Spalte4, SomeFilterTextTyp)
	                {
		        LV_Modify(RowNumber, "-Select")  ; deselect
                        ; MsgBox % Z_Index
	                }
	            ; --Z_Index
	            }
                If(CheckboxOhneIcon)
                    Gosub SelectUp
                }
	    Else								
	        {
                ; MsgBox 1 Checked
	        Loop % SListeMerkenAnzahl
	            {
		    Gosub ThreadsBeenden
	            ; If Not InStr(Zeile%Z_Index%Spalte4, SomeFilterTextTyp)
	            if Zeile%Z_Index%Spalte4 not in %SomeFilterTextTyp%
	                {
	                ; MsgBox Zeile %Z_Index%
	                LV_Delete(Z_Index)
	                }
	            --Z_Index
	            }
                }
	    ControlFocus , SysListView321, ahk_class AutoHotkeyGUI
	}
	Else If(CheckboxOhneIcon)
	{
            If (CheckboxSel=1)							
	        {
                MsgBox Nur selektieren wird in dieser Konstellation noch nicht unterstützt.
	        }
            Else If (CheckboxSel=-1)						
                {
                MsgBox Nur aus Selektierten wird in dieser Konstellation noch nicht unterstützt.
                }
	    Else								
	        {
	    ; MsgBox 1 Checked
	    Loop % SListeMerkenAnzahl
	    {
		Gosub ThreadsBeenden
	        ; If InStr(Zeile%Z_Index%Spalte4, SomeFilterTextTyp)
	        if Zeile%Z_Index%Spalte4 in %SomeFilterTextTyp%
	        {
	            ; MsgBox Zeile %Z_Index%
	            ZeileBleibt%Z_Index%:=1
	        }
	        Else
	            ZeileBleibt%Z_Index%:=0
	        --Z_Index
	    }
	    LV_Delete()
	    Loop % SListeMerkenAnzahl
	    {
		Gosub ThreadsBeenden
	        If (ZeileBleibt%A_Index%)
	            LV_Add("Icon" . "9999999", Zeile%A_Index%Spalte1,Zeile%A_Index%Spalte2,Zeile%A_Index%Spalte3,Zeile%A_Index%Spalte4,Zeile%A_Index%Spalte5)
	    }
                }	
	}
	Gosub ButtonOpti
	ToolTip,
	return
}

ButtonSichern: ; LinksKlick auf Button Sichern
{
	ToolTip, beschäftigt,4,4
	ListeMerkenAnzahl:=LV_GetCount()
	Loop % ListeMerkenAnzahl
	{
		LV_GetText(FileName, A_Index, 1) ; Get the text of the first field.
		LV_GetText(FileDir, A_Index, 2)  ; Get the text of the second field.
		LV_GetText(FileSize, A_Index, 3)
		LV_GetText(FileType, A_Index, 4)
		LV_GetText(FileTime, A_Index, 5)
		ListeMerkenDir%A_Index%:=FileDir
		ListeMerkenFile%A_Index%:=FileName
		ListeMerkenSize%A_Index%:=FileSize
		ListeMerkenType%A_Index%:=FileType
		ListeMerkenTime%A_Index%:=FileTime
	}
	ToolTip, 
	return
}
TimeToHash: ; 
{
	ToolTip, beschäftigt,4,4
	ListeMerkenAnzahl:=LV_GetCount()
	Loop % ListeMerkenAnzahl
	{
		Gosub ThreadsBeenden
		LV_GetText(FileName, A_Index, 1) ; Get the text of the first field.
		LV_GetText(FileDir, A_Index, 2)  ; Get the text of the second field.
		ThisFileDirFileName:=FileDir "\" FileName
		; LV_GetText(FileSize, A_Index, 3)
		; LV_GetText(FileType, A_Index, 4)
		LV_GetText(FileTime, A_Index, 5)
		LV_Modify(A_Index,"COL5",HashMd5(ThisFileDirFileName))
		; ListeMerkenDir%A_Index%:=FileDir
		; ListeMerkenFile%A_Index%:=FileName
		; ListeMerkenSize%A_Index%:=FileSize
		; ListeMerkenType%A_Index%:=FileType
		; ListeMerkenTime%A_Index%:=FileTime
	}
	ToolTip, 
	return
}
ButtonWiederherstellen: ; LinksKlick auf Button Wiederherstellen
{
	ToolTip, beschäftigt,4,4
	LV_Delete()
	Loop % ListeMerkenAnzahl
	{
		LV_Add("Icon" . "9999999", ListeMerkenFile%A_Index%,ListeMerkenDir%A_Index%, ListeMerkenSize%A_Index%,ListeMerkenType%A_Index%,ListeMerkenTime%A_Index%)
	}
	Gosub ButtonOpti
	ToolTip,
	return
}

ButtonHilfe: ; LinksKlick auf Button Hilfe
{
	loop, 256
		HtmlTastAll:=HtmlTastAll . HtmlTast%A_index%
	HtmlHilfe=%HtmlHilfe1%%HtmlHilfe2%%HtmlTastAll%%HtmlHilfe3%

	ShowHtmVar(HtmlHilfe)
	return
}
;
; Kontext Menüs ############################################
;
WinSetTitle:
If(ThisWinTitleMerker="")
	WinGetTitle, ThisWinTitleMerker , A
WinSetTitle, %ThisWinTitleMerker%, ,%ThisWinTitleMerker% -> %ThisWinTitle%
ThisWinTitleMerker:=ThisWinTitle
Return

GuiContextMenu: ; Rechts Klick  ; Launched in response to a right-click or press of the Apps key.
{
	if A_GuiControl <> MyListView ; Rechts Klick  außerhalb der Liste  ; Display the menu only for clicks inside the ListView.
	{
	    ; MsgBox % "RechtsKlick Event = " A_GuiControl
            if (A_GuiControl = "") ; Rechtsklick auf ein nicht definiertes Feld -> Merker im Fenstertitel setzen!
                {
                WinGetTitle, ThisWinTitle , A
                ThisWinTitleMerker:=ThisWinTitle
                InputBox, ThisWinTitle , Merker, Fenstertitel als Merker neu setzen, , , , , , , , %ThisWinTitle%
		If (ThisWinTitle <> "")
                    {
                    WinSetTitle, %ThisWinTitleMerker%, , %ThisWinTitle%
                    ; MsgBox % ThisWinTitleMerker  ThisWinTitle
                    }
                }

	    if (A_GuiControl = "CheckboxTxt") ; Rechts Klick auf Haken txt
	    {
	        InputBox, TextTypList , TextDateien, Typen`, die mit der Textsuche durchsucht werden,,,,,,,, %TextTypList%
	        if ErrorLevel
	            return
	    }
            if (A_GuiControl = "ButtonOpti") ; Rechts Klick auf Button Opti
	    {
                Gosub OptiRechts
	        Return
	    }
	    ; if (A_GuiControl = "sa&ve") ; Rechts Klick auf Button save
	    if (A_GuiControl = "save") ; Rechts Klick auf Button save
	    {
	        InputBox, Ausgabe , Format, der Ausgabe,,800,,,,,, %Ausgabe%
	        if ErrorLevel
	            return
		}
	    if (A_GuiControl = "&Hilfe") ; Rechts Klick auf Button Hilfe
	    {
	        MsgBox DateiSuche Version 0,8`n 2009`nAuthor: Gerdi 
			Return
		}
	    if (A_GuiControl = "ButtonLoadFolder") ; Rechts Klick auf Button Load folder
	    {
	        InputBox, Abfrage, Google, Abfrage,,800,,,,,, %Abfrage%
	        if ErrorLevel
	            return
	        ToolTip,beschäftigt,4,4
	        Folder:=LoadGoogleFind(Abfrage)
	        Gosub EinstiegUebergebenerOrdner
	        WinActivate,ahk_class AutoHotkeyGUI
	        ToolTip
	        return
		}
	    if (A_GuiControl = "CheckboxR") ; Rechts Klick auf Haken r
	    {
			FileSelectFileUeberspringen=False
			Goto DoDateiSpeichern
		}
	    ; msgbox drin2 %A_GuiControl%
	    return
	}
	Else ; Rechts Klick in die Liste
	{
	    ; Show the menu at the provided coordinates, A_GuiX and A_GuiY.  These should be used
	    ; because they provide correct coordinates even if the user pressed the Apps key:
	    Menu, MyContextMenu, Show, %A_GuiX%, %A_GuiY%
	    return
	}
}
ContextOpenFile:    ; Kontext-Menü Open  ; The user selected "Open" in the context menu.
RowNumber = 0  ; This causes the first iteration to start the search at the top.
SelectCounter:=0
XVersatzEintrag=X0
Loop
	{
	AnzeigeFileName=
	Gosub GetMonitorWorkArea
	BildschirmPixelX:=Mon%WunschMonitorNr%Width 
	BildschirmPixelY:=Mon%WunschMonitorNr%Height 
	; Since deleting a row reduces the RowNumber of all other rows beneath it,
	; subtract 1 so that the search includes the same row number that was previously
	; found (in case adjacent rows are selected):
	RowNumber := LV_GetNext(RowNumber)
	if not RowNumber  ; The above returned zero, so there are no more selected rows.
		break
	SelectCounter:=SelectCounter+1
	If (SelectCounter=5 AND NZeilen<5)
	        {
		MsgBox, 4100, , soll der Vorgang für alle selektierten Listenelemente fortgeführt werden?, 10
		IfMsgBox No
		    break
	        }
		LV_GetText(FileName, RowNumber, 1) ; Get the text of the first field.
		LV_GetText(FileDir, RowNumber, 2)  ; Get the text of the second field.
		; MsgBox % RowNumber FileDir FileName
		ThisIsFolder=nein
		If(FileDir<>"")
		    ThisFileDirFileName=%FileDir%\%FileName%
		Else
		    ThisFileDirFileName=%FileName%
		IfExist %ThisFileDirFileName%
			{
			LV_GetText(FileTyp, RowNumber, 4)
			if InStr(FileExist(ThisFileDirFileName),"D")
			    {
			    ThisIsFolder=ja
			    OrgThisFileDirFileName:=ThisFileDirFileName
			    If (MultimediaVonOrdnerZeigen="Ja")
				{
				; MsgBox Spezialbehandlung von Folder %ThisFileDirFileName%
				Loop, %ThisFileDirFileName%\*.*, , 1  ; Recurse into subfolders.
				    {
				    SplitPath, A_LoopFileFullPath,,,ThisExt
				    If ThisExt in %BildEigenList%
					{
					ThisFileDirFileName:=A_LoopFileFullPath
					FileTyp:=ThisExt
				        break
					}
				    }
				Loop, %ThisFileDirFileName%\*.*, , 1  ; Recurse into subfolders.
				    {
				    SplitPath, A_LoopFileFullPath,,,ThisExt
				    If ThisExt in %VlCWaitList%
					{
					ThisFileDirFileName:=A_LoopFileFullPath
					FileTyp:=ThisExt
				        break
					}
				    }
			        If(OrgThisFileDirFileName=ThisFileDirFileName)
				    {
			    	    ThisFileDirFileName=%A_ScriptDir%\SucheDateien\Hintergrund.bmp
				    FileTyp=bmp
				    }
				}
			    } 
			If(FileTyp="lnk" AND ZielVonLinkOeffnen="ja")
			    {
			    FileDirFileNameLnk=%ThisFileDirFileName%
			    FileDirFileName:=RelLink2AbsPath(FileDirFileNameLnk,"ja")
			    IfExist %FileDirFileName%
				SplitPath, FileDirFileName , FileName, FileDir, FileTyp
			    Else
				StringTrimRight,FileDirFileName,FileDirFileNameLnk,4
			    IfNotExist %FileDirFileName%
			    	Continue
			    }
			If(ImageNrB=BildSpalten)
                            {
			    If(ImageNrA=BildZeilen)
				ImageNrA:=0
			    ImageNrB:=1
			    If(ImageNrA<BildZeilen)
				++ImageNrA
                            Else
                                ImageNrA:=1
                            }
			Else If(ImageNrB<BildSpalten)
			    ++ImageNrB
                        Else
                            ImageNrB:=1
			Gosub GetMonitorWorkArea
			FensterNr:=BildSpalten*ImageNrA -BildSpalten + ImageNrB 
			; TrayTip,FensterNr,%FensterNr%	%ImageNrA%	%ImageNrB%
			If(ThisIsFolder="ja" AND MultimediaVonOrdnerZeigen="Ja")
			    AnzeigeFileName=%FensterNr% ->	%FileName%
                        BildPixelX:=BildschirmPixelX/BildSpalten
                        BildPixelY:=BildschirmPixelY/BildZeilen
			XVersatz:=(ImageNrB-1)*BildPixelX
			XVersatz:=XVersatz+Mon%WunschMonitorNr%Left
			YVersatz:=(ImageNrA-1)*BildPixelY
			YVersatz:=YVersatz+Mon%WunschMonitorNr%Top
			    XVersatz:=Round(XVersatz)
			    YVersatz:=Round(YVersatz)
			; MsgBox % XVersatz "	" YVersatz
                        FensterNrZuordnung%FensterNr%:=RowNumber
			BildPixelXZuordnung%FensterNr%:=BildPixelX
			BildPixelYZuordnung%FensterNr%:=BildPixelY
			XVersatzZuordnung%FensterNr%:=XVersatz
			YVersatzZuordnung%FensterNr%:=YVersatz
			IF(BildSpalten=1 AND BildZeilen=1 AND WunschMonitorNr=1)
			    {
			    XVersatzEintrag=X0
			    YVersatzEintrag=Y0
			    }
			Else
			    {
                            XVersatzEintrag=X%XVersatz%
                            YVersatzEintrag=Y%YVersatz%
			    }
                        If FileTyp NOT in %BildEigenList%
			    {
                            FensterNrZuordnung%FensterNr%:=RowNumber
			    SplashImage,%FensterNr%:Off
			    ; MsgBox Fenster %FensterNr% aus
			    }
			If(VlcPid%FensterNr%>1)
				{
				ThisPID:=VlcPid%FensterNr%
				WinClose , ahk_pid %ThisPID%
				WinWaitClose , ahk_pid %ThisPID%,,9
				; Process, Close, %ThisPID%
				; MsgBox % VlcPid%FensterNr%
				VlcPid%FensterNr%:=
				}
                        If(VlCVerwenden<>"nein")
                            If FileTyp in %VlCWaitList%
                                IfNotExist %VlcPfad%
                                    Gosub VlcPfadAbfragen
                        If FileTyp in %VlCWaitList%
                            InVlcListe=ja
                        Else
			    {
                            InVlcListe=nein
			    WinSet, Bottom,,VLC media player
			    }
                        If(InVlcListe="ja" AND VlCVerwenden<>"nein")
                            {
                            IfExist %VlcPfad%
				{
				; ToolTip % FensterNr "	" VlcPid%FensterNr% 
			        ThisObjekt=%ThisFileDirFileName%
			        IfExist %ThisObjekt%.com
			            {
				    FileRead, CommandLine, %ThisObjekt%.com
				    CommandLine:=InnereVariablenExtrahieren(CommandLine)
				    ; MsgBox % CommandLine
				    }
			        Else
				    {
				    ; CommandLine=%A_Space% --embedded-video --fullscreen --video-on-top --directx-device=\\.\DISPLAY%WunschMonitorNr%
				    ; CommandLine=%A_Space% --no-embedded-video --fullscreen --video-on-top --directx-device=\\.\DISPLAY%WunschMonitorNr%
				    ThisMonLeft:=Mon%WunschMonitorNr%Left
				    ThisMonTop:=Mon%WunschMonitorNr%Top
				    CommandLine=%A_Space% --video-x=%ThisMonLeft% --video-y=%ThisMonTop% ; --no-embedded-video
				    ; CommandLine=%A_Space% :video-x=%ThisMonLeft% :video-y=%ThisMonTop% ; --no-embedded-video
				    ; CommandLine=%A_Space% --no-embedded-video --video-on-top-screennumber=%WunschMonitorNr%
				    ; CommandLine=%A_Space%--fullscreen --qt-fullscreen-screennumber=%WunschMonitorNr%
				    ; CommandLine=%A_Space%--qt-screennumber=%WunschMonitorNr%
				    ; CommandLine=
				    }
	                        Run "%VlcPfad%" "%ThisFileDirFileName% " %CommandLine%,, UseErrorLevel,vlcPID
				VlcPid%FensterNr%:=vlcPID
			        ; WinSet, Bottom,,SucheDateien
				}
                            Else
                                {
                                VlCWaitList=
                                return
                                }
			    ; MsgBox % FileTyp
                            sleep 700
			    IfWinActive,ahk_class QWidget
				{
				Send r
				}
                            WinActivate, %FileName%
			    ; SplashImage, Off
			    ; WinWait,%VlcWaitClose%,,5
			    ; WinWaitActive ,%VlcWaitClose%,,20
                            WinSet, Bottom,, ahk_class ShImgVw:CPreviewWnd
			    sleep 500
                            ; If(XVersatzEintrag<>"")
                                {
									sleep 1000
									If(BildSpalten>1)
									{
										send ^h
									}
									sleep 1000

                                ; msgbox %XVersatzEintrag% , %YVersatzEintrag%
                                WinMove, %FileName%, , %XVersatz%, %YVersatz% , %BildPixelX%, %BildPixelY%
				; Warte:=5
				WinSet, Bottom,,VLC media player
				sleep 20
			        WinSet, Bottom,,VLC media player
				WinClose,VLC media player
                                }
			    sleep 2500
                            ; ###############

                            WinActivate, %FileName%
                            sleep 300
			    FileGetSize, FileSize , %ThisFileDirFileName%
			    Warte:=FileSize/100000+50000
				; TrayTip,Warte,%Warte%,5
				; sleep 1000
                            ; If(XVersatzEintrag<>"X0")
                                {
                                ; msgbox %XVersatzEintrag% , %YVersatzEintrag%
                                WinMove, %FileName%, , %XVersatz%, %YVersatz% , %BildPixelX%, %BildPixelY%
				; Warte:=5
				WinSet, Bottom,,VLC media player
				sleep 20
			        WinSet, Bottom,,VLC media player
				WinClose,VLC media player
                                }
			    If(WarteAufFilmEnde="Nein")
				{
				sleep 3000
				}
			    Else
				{
		       	    	WinWait ,%VlcStopKenner%	,,%Warte%
				; TrayTip,Warte,Ende,5
				; sleep 1000
				}
			    ; ListLines
			    WarteWindowsY=0
                            ; WinSet, AlwaysOnTop, On, ahk_class ShImgVw:CPreviewWnd
                            If(XVersatzEintrag="X0")
                                {
				sleep 40
			        WinSet, Bottom,,%VlcStopKenner%
				sleep 40
			        WinClose,%VlcStopKenner%
				}
			    sleep 20
			    WinMinimize,%VlcStopKenner%
                            }
                        else If FileTyp in %BildEigenList%
                            {
			    ; MsgBox %BildZeilen%	%BildSpalten%
			    StringReplace, FileNameDotNoExt, FileName, %FileTyp%
			    BildPixelY:=Round(BildPixelY)
			    ; MsgBox % ImageNrA "	" ImageNrB "	" FensterNr "	" BildPixelY "	" XVersatz "	" YVersatz

			    If(BildZeilen="1" AND BildSpalten="1")
				{
				If(ThisFensterNr="2")
				    {
				    ThisFensterNr:=1
				    ThisFensterNrWeg:=2
				    }
				Else
				    {
				    ThisFensterNr:=2
				    ThisFensterNrWeg:=1
				    }
				; MsgBox % ThisFensterNr
				}
			    Else
				{
			        ThisFensterNr:=FensterNr
				ThisFensterNrWeg=
				}
			    DetectHiddenWindows, On
                            SplashImage,%ThisFensterNr%:%ThisFileDirFileName%, A B %SplashImageRand% ZH%BildPixelY% ZW-1 %XVersatzEintrag% %YVersatzEintrag% Hide,,%AnzeigeFileName%,ThisBild%FensterNr%			; Fällt manchmal auf schnauze ####################
			    If(ThisFensterNrWeg<>"")
				{
				WinGetPos,,,ThisSplashImageWidth,ThisSplashImageHeight, ThisBild%FensterNr%
				; MsgBox ThisSplashImageWidth = "%ThisSplashImageWidth%"
				If(ThisSplashImageWidth>=Mon%WunschMonitorNr%Width)	; Bild zu breit
				    {
				    SplashImage,%ThisFensterNr%:%ThisFileDirFileName%, A B %SplashImageRand% ZH-1 ZW%ThisSplashImageWidth% %XVersatzEintrag% %YVersatzEintrag% Hide,,%AnzeigeFileName%,ThisBild%FensterNr%			; Fällt manchmal auf schnauze ####################
				    
				    ; NewSplashImageHeight:=ThisSplashImageHeight*Mon%WunschMonitorNr%Width/ThisSplashImageWidth
				    ; WinMove, ThisBild%FensterNr%, , , ,%ThisSplashImageWidth%,%NewSplashImageHeight%
				    }
				If(ThisSplashImageWidth<Mon%WunschMonitorNr%Width/2 AND LastSplashImageWidth<Mon%WunschMonitorNr%Width/2 AND LastSplashImagePos="Left") ; es passen 2 Bilder auf eine Seite
				    {
				    ThisXVersatz:=XVersatz+Mon%WunschMonitorNr%Width/2
				    WinMove, ThisBild%FensterNr%, , %ThisXVersatz%
				    LastSplashImagePos=Right
				    }
				Else
				    {
				    ; If (LastSplashImagePos="Right" AND ThisSplashImageWidth>Mon%WunschMonitorNr%Width/2)
				    If (LastSplashImageWidth>Mon%WunschMonitorNr%Width/2 OR ThisSplashImageWidth>Mon%WunschMonitorNr%Width/2)
				        SplashImage, %ThisFensterNrWeg%:Off
				    LastSplashImagePos=Left
				    LastSplashImageWidth:=ThisSplashImageWidth
				    }
				ThisFensterNrWeg=
				}
			    ; MsgBox SplashImage`,%FensterNr%:%FileDir%\%FileName%`, A B ZH%BildPixelY% ZW-1 %XVersatzEintrag% %YVersatzEintrag%
			    ; WinMove, Bild%FensterNr%, , %XVersatz%, %YVersatz% , %BildPixelX%,  %BildPixelY%
			    WinMove, Bild%FensterNr%, , %XVersatz%, %YVersatz% , ,  %BildPixelY%
			    SplashImage,%ThisFensterNr%:Show
			    DetectHiddenWindows, Off
			    If (TonZuBild="ja")
				{
					
					StringSplit, TonTypListZuBildArray, TonTypListZuBild ,`,
					Loop % TonTypListZuBildArray0
					{
						ThisTonTypListZuBild:=TonTypListZuBildArray%A_Index%
						If(FileDir<>"")
							ThisSound=%FileDir%\%FileNameDotNoExt%%ThisTonTypListZuBild%
						Else
							ThisSound=%FileNameDotNoExt%%ThisTonTypListZuBild%
						IfExist %ThisSound%
						{
							SoundPlay, %ThisSound% ,%FolgebildWartetTonEnde%
							WarteWindowsY=0
						}
						else
							{
							
							; MsgBox %j% sleep %WarteBildEigen%
							sleep %WarteBildEigen%
							}
					}
				
				}
			    Else If (BildZeilen = 1 AND BildSpalten = 1)
				{
				
				; MsgBox %j% sleep %WarteBildEigen%
				sleep %WarteBildEigen%
				}
                            BildFenster=offen
			    ErrorLevel:=0
			    }
                        else If FileTyp in %MusikEigenList%
                            {
			    ; i:=0
			    SetTimer, Musiksteuerung , 1001
			    SoundAktiv=ja
			    AktuellGeoeffnetNr:=RowNumber
			    SoundPlay, %FileDir%\%FileName% , wait
			    SetTimer, Musiksteuerung , Off
			    SoundAktiv=nein
			    }
			else
                            {
                            ; SplashImage, Off
	                    Run %ThisFileDirFileName%,, UseErrorLevel
                            ; sleep 5000
                            } 
                        }
; listlines
; pause
	}
return

Musiksteuerung:
; WarteTaste=T1
; Musiksteuerung2:
IfWinActive , ahk_class AutoHotkeyGUI
	{
	; ++i
	; TrayTip,i,%i%
	Input, Key, L1 T1,{Space}{Backspace}{Esc}{Left}{Right}{Up}{Down}{Home}{End}{PgUp}{PgDn}{Del}{Ins}{BS}{Pause}{F1}{F2}{F3}{F4}{F5}{F6}{F7}{F8}{F9}{F10}{F11}{F12}
	RueckWert:=ErrorLevel
	; TrayTip,Rueckwert,%Rueckwert%
	If (RueckWert = "EndKey:Backspace")
		Key=Backspace
	If (RueckWert = "EndKey:Escape")
		Key=Esc
	If (RueckWert = "EndKey:Delete")
		Key=Delete
	If (RueckWert = "EndKey:Home")
		Key=Home
	If (RueckWert = "EndKey:End")
		Key=End
	If (RueckWert = "EndKey:Pause")
		Key=Pause
	If (RueckWert = "EndKey:Left")
		Key=Left
	If (RueckWert = "EndKey:Right")
		Key=Right
	If (RueckWert = "EndKey:Up")
		Key=Up
	If (RueckWert = "EndKey:Down")
		Key=Down
	If (RueckWert = "EndKey:PgUp")
		Key=PgUp
	If (RueckWert = "EndKey:PgDn")
		Key=PgDn
	If (RueckWert = "EndKey:Del")
		Key=Del
	If (RueckWert = "EndKey:Ins")
		Key=Ins
	If (RueckWert = "EndKey:Space")
		Key=Space
	If (RueckWert = "EndKey:BS")
		Key=BS
	Loop,12
		{
		Vergleich=EndKey:F%A_Index%
		If(RueckWert = Vergleich)
			{
			Key=F%A_Index%
			break
			}
		}
	If (Key=A_Tab)
		Key=Tab
	If (Key=".")
		Key=Dot
	If (Key="-")
		Key=ohne
	If (Key="+")
		Key=mit
	If (Key=";")
		Key=Strichpunkt
	If (Key=",")
		Key=Komma
	If (Key=":")
		Key=Doppelpunkt
	If (Key="<")
		Key=kleiner
	If (Key=">")
		Key=groesser
	If (Key="~")
		Key=Tilde
	If (Key="*")
		Key=Stern
	If (Key="/")
		Key=Slash
	If (Key="=")
		Key=gleich
	If (Key="`(")
		Key=KlammerAuf
	If (Key="`)")
		Key=KlammerZu
	If (Key="&")
		Key=Und
	If (Key="!")
		Key=Ausrufezeichen
	If (Key="%")
		Key=Prozent
	If (Key="""")
		Key=Hochkommas
	If (Key="'")
		Key=Hochkomma
	If (Key="°")
		Key=Grad
	If (Key="|")
		Key=Pipe
	If (Key="\")
		Key=Backslash

	WarteWindowsY:=0
	If (Key="s")
		{
		SoundPlay,GibtsNicht.mp3
		DauerwiederholungWindowsY=nein
		TrayTip,SucheDateien,Musik stop
		}
	If (Key="Right")
		{
		SoundPlay,GibtsNicht.mp3
		; DauerwiederholungWindowsY=nein
		TrayTip,SucheDateien,Musik nächster Titel
		}
	If (Key="Left")
		{
		SoundPlay,GibtsNicht.mp3
		LV_Modify(AktuellGeoeffnetNr-1, "Focus")
		TrayTip,SucheDateien,Musik voriger Titel
		}
	If (Key="Space")
		{
		SoundPlay,GibtsNicht.mp3
		DauerwiederholungWindowsY=nein
		LV_Modify(AktuellGeoeffnetNr, "Focus")
		; Pause ,Toggle,1			; ############ es wird zwar der richtige Thread pausiert, aber SoundPlay nicht.
		TrayTip,SucheDateien,Musik Pause
		; WarteTaste=
		; Goto Musiksteuerung2
		}
	}
return

ContextOpenFileSpez:    ; Kontext-Menü Open  ; The user selected "Open" in the context menu.
RowNumber = 0  ; This causes the first iteration to start the search at the top.
SelectCounter:=0
FileSelectFile, OpenWith, 32, %OpenWith%, öffnen mit, *.exe
IfNotExist, %OpenWith%
	{
	SplitPath, OpenWith , OpenWith
	}
InputBox, AdminUser , Öffenen als anderer User,,,,,,,,, %AdminUser%
if Not ErrorLevel
	{
        InputBox, AdminPassword , Password,,HIDE,,,,,,, %AdminPassword%
        InputBox, AdminDomain , Domain,für Localhost leerlassen,,,,,,,, %AdminDomain%
        RunAs , %AdminUser%, %AdminPassword%, %AdminDomain%
	}
Loop
	{
	; Since deleting a row reduces the RowNumber of all other rows beneath it,
	; subtract 1 so that the search includes the same row number that was previously
	; found (in case adjacent rows are selected):
	RowNumber := LV_GetNext(RowNumber)
	if not RowNumber  ; The above returned zero, so there are no more selected rows.
		break
	SelectCounter:=SelectCounter+1
	If (SelectCounter=5 AND NZeilen<5)
	        {
		MsgBox, 4100, , soll der Vorgang für alle selektierten Listenelemente fortgeführt werden?, 10
		IfMsgBox No
		    break
	        }
	LV_GetText(FileName, RowNumber, 1) ; Get the text of the first field.
	LV_GetText(FileDir, RowNumber, 2)  ; Get the text of the second field.
	IfExist %FileDir%\%FileName%
	       	{
	        Run %OpenWith% %FileDir%\%FileName%,, UseErrorLevel
	        }
	}
RunAs
return


ContextProperties:    ; Kontext-Menü Properties  ; The user selected "Properties" in the context menu.
RowNumber = 0  ; This causes the first iteration to start the search at the top.
SelectCounter:=0
Loop
	{
	; Since deleting a row reduces the RowNumber of all other rows beneath it,
	; subtract 1 so that the search includes the same row number that was previously
	; found (in case adjacent rows are selected):
	RowNumber := LV_GetNext(RowNumber)
	if not RowNumber  ; The above returned zero, so there are no more selected rows.
		break
	SelectCounter:=SelectCounter+1
	If (SelectCounter=5 AND NZeilen<5)
	        {
		MsgBox, 4100, , soll der Vorgang für alle selektierten Listenelemente fortgeführt werden?, 10
		IfMsgBox No
		    break
	        }

		LV_GetText(FileName, RowNumber, 1) ; Get the text of the first field.
		LV_GetText(FileDir, RowNumber, 2)  ; Get the text of the second field.
		IfExist %FileDir%\%FileName%
	        	{
	                Run Properties "%FileDir%\%FileName%",, UseErrorLevel
			if ErrorLevel
	                    MsgBox Could not perform requested action on "%FileDir%\%FileName%".
			}
	}
return



ContextEdit:    ; Kontext-Menü Edit  ; The user selected "Edit" in the context menu.
RowNumber = 0  ; This causes the first iteration to start the search at the top.
SelectCounter:=0
Loop
	{
	; Since deleting a row reduces the RowNumber of all other rows beneath it,
	; subtract 1 so that the search includes the same row number that was previously
	; found (in case adjacent rows are selected):
	RowNumber := LV_GetNext(RowNumber)
	if not RowNumber  ; The above returned zero, so there are no more selected rows.
		break
	SelectCounter:=SelectCounter+1
	If (SelectCounter=5 AND NZeilen<5)
	        {
		MsgBox, 4100, , soll der Vorgang für alle selektierten Listenelemente fortgeführt werden?, 10
		IfMsgBox No
		    break
	        }

		LV_GetText(FileName, RowNumber, 1) ; Get the text of the first field.
		LV_GetText(FileDir, RowNumber, 2)  ; Get the text of the second field.
		IfExist %FileDir%\%FileName%
	                 {
	                 Run %NPP% %FileDir%\%FileName%,, UseErrorLevel
                     if ErrorLevel
                             {
	                         Run edit %FileDir%\%FileName%,, UseErrorLevel
	                         if ErrorLevel
	                              Run notepad.exe %FileDir%\%FileName%,, UseErrorLevel
                             }
					 Else
					     WinWait , ahk_class Notepad++
	                 }
	}
If (SelectCounter=2)
	{
	sleep 1000
	IfWinExist , ahk_class Notepad++
		{
		MsgBox, 4100, , Soll ein Textvergleich durchgeführt werden?,10
		IfMsgBox Yes
			{
			WinActivate,ahk_class Notepad++
			WinWaitActive,ahk_class Notepad++
			Send !d
			}
		}
	}
return




ContextOpenExplorer:    ; Kontext-Menü OpenExplorer
RowNumber = 0  ; This causes the first iteration to start the search at the top.
SelectCounter:=0
Loop
	{
	; Since deleting a row reduces the RowNumber of all other rows beneath it,
	; subtract 1 so that the search includes the same row number that was previously
	; found (in case adjacent rows are selected):
	RowNumber := LV_GetNext(RowNumber)
	if not RowNumber  ; The above returned zero, so there are no more selected rows.
		break
	SelectCounter:=SelectCounter+1
	If (SelectCounter=5 AND NZeilen<5)
	        {
		MsgBox, 4100, , soll der Vorgang für alle selektierten Listenelemente fortgeführt werden?, 10
		IfMsgBox No
		    break
	        }
		LV_GetText(FileName, RowNumber, 1) ; Get the text of the first field.
		LV_GetText(FileDir, RowNumber, 2)  ; Get the text of the second field.
		IfExist %FileDir%\%FileName%
	                {
		        Run, explorer `/n`,`/select `, %FileDir%\%FileName%
	                }
	}
return


KurzfristigNochDrinnHalten:		; liegt braach, jedoch fehlt #############
{
	RowNumber = 0  ; This causes the first iteration to start the search at the top.
	SelectCounter:=0
	If (A_ThisMenuItem="Open Spez")
            {
	    FileSelectFile, OpenWith, 32, %OpenWith%, öffnen mit, *.exe
	    IfNotExist, %OpenWith%
		{
		SplitPath, OpenWith , OpenWith
		}
	    InputBox, AdminUser , Öffenen als anderer User,,,,,,,,, %AdminUser%
	    if Not ErrorLevel
		{
	        InputBox, AdminPassword , Password,,HIDE,,,,,,, %AdminPassword%
	        InputBox, AdminDomain , Domain,für Localhost leerlassen,,,,,,,, %AdminDomain%
	        RunAs , %AdminUser%, %AdminPassword%, %AdminDomain%
		}
            }
	Loop
	{
	    ; Since deleting a row reduces the RowNumber of all other rows beneath it,
	    ; subtract 1 so that the search includes the same row number that was previously
	    ; found (in case adjacent rows are selected):
	    RowNumber := LV_GetNext(RowNumber)
	    if not RowNumber  ; The above returned zero, so there are no more selected rows.
		break
	    SelectCounter:=SelectCounter+1
	    If (SelectCounter=5 AND NZeilen<5)
	        {
		MsgBox, 4100, , soll der Vorgang für alle selektierten Listenelemente fortgeführt werden?, 10
		IfMsgBox No
		    break
	        }

	    LV_GetText(FileName, RowNumber, 1) ; Get the text of the first field.
	    LV_GetText(FileDir, RowNumber, 2)  ; Get the text of the second field.
	    IfExist %FileDir%\%FileName%
	            {
	            If (A_ThisMenuItem="Explorer")  ; User selected "Explorer" from the context menu.
		        Run, explorer `/n`,`/select `, %FileDir%\%FileName%
	            Else If (A_ThisMenuItem="Open" Or Oeffnen="ja")  ; User selected "Open" from the context menu.
                        {
			LV_GetText(FileTyp, RowNumber, 4)
                        If FileTyp in %VlCWaitList%
                            IfNotExist %VlcPfad%
                                Gosub VlcPfadAbfragen
                        If FileTyp in %VlCWaitList%
                            {
                            IfExist %VlcPfad%
	                        Run "%VlcPfad%" "%FileDir%\%FileName%",, UseErrorLevel
                            Else
                                VlCWaitList=
			    ; MsgBox % FileTyp
                            sleep 700
				SplashImage, Off
			    ; WinWait,%VlcWaitClose%,,5
			    ; WinWaitActive ,%VlcWaitClose%,,20
                            WinSet, Bottom,, ahk_class ShImgVw:CPreviewWnd
			    sleep 5000
		       	    WinWait ,%VlcStopKenner%	;,,60+60*Warte*3
			    
			    WarteWindowsY=0
                            ; WinSet, AlwaysOnTop, On, ahk_class ShImgVw:CPreviewWnd
			    ; WinClose,%VlcStopKenner%
                            }
                        else If FileTyp in %BildEigenList%
                            {
; BildZeilen:=3
; BildSpalten:=3
			    If(ImageNrB=BildSpalten)
                                {
				If(ImageNrA=BildZeilen)
				    ImageNrA:=0
				ImageNrB:=1
				++ImageNrA
                                }
			    Else
				++ImageNrB
                            BildPixelX:=BildschirmPixelX/BildSpalten
                            BildPixelY:=BildschirmPixelY/BildZeilen
			    XVersatz:=(ImageNrB-1)*BildPixelX
			    YVersatz:=(ImageNrA-1)*BildPixelY
			    FensterNr:=BildSpalten*ImageNrA -BildSpalten + ImageNrB 
                            FensterNrZuordnung%FensterNr%:=RowNumber
			    BildPixelXZuordnung%FensterNr%:=BildPixelX
			    BildPixelYZuordnung%FensterNr%:=BildPixelY
			    XVersatzZuordnung%FensterNr%:=XVersatz
			    YVersatzZuordnung%FensterNr%:=YVersatz
			    ; MsgBox % ImageNrA "	" ImageNrB "	" FensterNr "	" XVersatz "	" YVersatz
                            SplashImage,%FensterNr%:%FileDir%\%FileName%, A b ZH%BildPixelY% ZW-1 X%XVersatz% Y%YVersatz%
                            BildFenster=offen
			    ErrorLevel:=0
			    }
			else
                            {
                            ; SplashImage, Off
	                    Run %FileDir%\%FileName%,, UseErrorLevel
                            ; sleep 5000
                            }
                        }
 	        Else If (A_ThisMenuItem="Open Spez")  ; User selected "Open Spez" from the context menu.
	                {
	                Run %OpenWith% %FileDir%\%FileName%,, UseErrorLevel	                 
	                }
	        else IfInString A_ThisMenuItem, edit  ; User selected "Open" from the context menu.
	                {
	                Run edit %FileDir%\%FileName%,, UseErrorLevel
	                if ErrorLevel
	                      Run notepad.exe %FileDir%\%FileName%,, UseErrorLevel
	                }
	        else if FocusedControl = MyListView		; was fehlt? ##########################################################
	        	      Run %FileDir%\%FileName%,, UseErrorLevel	; was fehlt? ##########################################################
	        else  ; User selected "Properties" from the context menu.
	                Run Properties "%FileDir%\%FileName%",, UseErrorLevel
	        if ErrorLevel
	                MsgBox Could not perform requested action on "%FileDir%\%FileName%".

	        }
	}
	RunAs
        return
}

Bild2Bis9Weg:
Loop,9
{
	If (A_Index>1)
		SplashImage, %A_index%:Off
}
Return
ContextOpenFokusedFile:    ; Kontext-Menü Open  ; The user selected "Open" in the context menu.
ContextOpenFokusedFileSpez:    ; Kontext-Menü Open  ; The user selected "Open" in the context menu.
ContextFokusedProperties:    ; Kontext-Menü Properties  ; The user selected "Properties" in the context menu.
ContextFokusedEdit:    ; Kontext-Menü Edit  ; The user selected "Edit" in the context menu.
{
	; For simplicitly, operate upon only the focused row rather than all selected rows:
	FocusedRowNumber := LV_GetNext(0, "F")  ; Find the focused row.
	if not FocusedRowNumber  ; No row is focused.
	    return
	LV_GetText(FileName, FocusedRowNumber, 1) ; Get the text of the first field.
	LV_GetText(FileDir, FocusedRowNumber, 2)  ; Get the text of the second field.
	If(FileDir<>"")
	    ThisFileDirFileName=%FileDir%\%FileName%
	Else
	    ThisFileDirFileName=%FileName%
	; MsgBox % A_ThisMenuItem
	If (A_ThisMenuItem="Open")  ; User selected "Open" from the context menu.
	    Run %ThisFileDirFileName%,, UseErrorLevel
	Else If (A_ThisMenuItem="Open Spez")  ; User selected "Open Spez" from the context menu.
	    {
	    FileSelectFile, OpenWith, 32, %OpenWith%, öffnen mit, *.exe
	    IfNotExist, %OpenWith%
		{
		SplitPath, OpenWith , OpenWith
		}
	    InputBox, AdminUser , Öffenen als anderer User,,,,,,,,, %AdminUser%
	    if Not ErrorLevel
		{
	        InputBox, AdminPassword , Password,,HIDE,,,,,,, %AdminPassword%
	        InputBox, AdminDomain , Domain,für Localhost leerlassen,,,,,,,, %AdminDomain%
	        RunAs , %AdminUser%, %AdminPassword%, %AdminDomain%
		}
	    If (OpenWith<>"")
	        Run %OpenWith% %ThisFileDirFileName%,, UseErrorLevel
	    Else
		{
	        Run %ThisFileDirFileName%,, UseErrorLevel
		}
	    RunAs
	    }
	else IfInString A_ThisMenuItem, edit  ; User selected "Open" from the context menu.
	{
	    Run edit %ThisFileDirFileName%,, UseErrorLevel
	    if ErrorLevel
	        Run notepad.exe %ThisFileDirFileName%,, UseErrorLevel
	}
	else if FocusedControl = MyListView
	    Run %ThisFileDirFileName%,, UseErrorLevel
	else  ; User selected "Properties" from the context menu.
	    Run Properties "%ThisFileDirFileName%",, UseErrorLevel
	if ErrorLevel
	    MsgBox Could not perform requested action on "%FileDir%\%FileName%".
	return
}

ContextClearRows:    ; Kontext-Menü Clear from Listview  ; The user selected "Clear" in the context menu.
{
	If CheckboxR
		DoMitschrieb=%DoMitschrieb%`r`nContextClearRows

	RowNumber = 0  ; This causes the first iteration to start the search at the top.
	ToolTip, beschäftigt,4,4
	Loop
	{
	    ; Since deleting a row reduces the RowNumber of all other rows beneath it,
	    ; subtract 1 so that the search includes the same row number that was previously
	    ; found (in case adjacent rows are selected):
	    RowNumber := LV_GetNext(RowNumber - 1)
	    if not RowNumber  ; The above returned zero, so there are no more selected rows.
	        break
	    LV_Delete(RowNumber)  ; Clear the row from the ListView.
	}
	Gosub ButtonOpti
	ToolTip,
	return
}

ContextDelNearLinkFiles:
{
	; MsgBox, 4, ,Achtung:`nsollen wirklich die zugehörigen Originale bei den selektierten Dateien gelöscht werden?`n`nContinue?
	; IfMsgBox, No, return        
	
	RowNumber = 0  ; This causes the first iteration to start the search at the top.
	GeloeschteOriginaleAnz:=0
	ToolTip, beschäftigt,4,4
	Loop
	{
	
	    ; Since deleting a row reduces the RowNumber of all other rows beneath it,
	    ; subtract 1 so that the search includes the same row number that was previously
	    ; found (in case adjacent rows are selected):
	    RowNumber := LV_GetNext(RowNumber - 1)
	    if not RowNumber  ; The above returned zero, so there are no more selected rows.
	        break
	    LV_GetText(FileName, RowNumber, 1) ; Get the text of the first field.
	    LV_GetText(FileDir, RowNumber, 2)  ; Get the text of the second field.
	    ThisLink=%FileDir%\%FileName%
	    SplitPath, ThisLink, ThisLinkFileName, ThisLinkDir, ThisLinkExtension, ThisLinkNameNoExt, ThisLinkDrive
	    If(ThisLinkExtension="lnk")
		{
		ThisLinkZiel:=RelLink2AbsPath(ThisLink,"ja")
		SplitPath, ThisLinkZiel, ThisLinkZielFileName, ThisLinkZielDir, ThisLinkZielExtension, ThisLinkZielNameNoExt, ThisLinkZielDrive
		If(ThisLinkDrive=ThisLinkZielDrive)	; nur wenn beizubehaltendes Original auf der selben Festplatte
		    {
		    IfExist %ThisLinkZiel%
			{
			ThisOrg=%ThisLinkDir%\%ThisLinkNameNoExt%
			IfExist %ThisOrg%	; nur wenn zu löschendes Original vorhanden
			    {
			    FileGetSize, ThisOrgSize, %ThisOrg%
			    FileGetSize, ThisLinkZielSize, %ThisLinkZiel%
			    If(ThisLinkZielSize=ThisOrgSize)	; nur wenn nicht beizubehaltendes = zu löschendes Original ist. ############# es sollte noch ein Dateivergeleich programmiert werden.
				{
				If(ThisLinkZiel<>ThisOrg)	; nur wenn nicht beizubehaltendes = zu löschendes Original ist
				    {
				    MsgBox,4, Achtung,Das Original `n	%ThisOrg% `nwird gelöscht, da im selben Ordner der Link `n	%ThisLink% `nauf das Fern-Original `n	%ThisLinkZiel% `nzeigt!
				    IfMsgBox, No
					{
					RowNumber:=RowNumber+1
					Continue
					}
				    FileDelete,%ThisOrg%
				    if Not ErrorLevel  
					GeloeschteOriginaleAnz:=GeloeschteOriginaleAnz+1
				    Else
					MsgBox Datei %ThisOrg% konnte nicht gelöscht werden!
				    }
				}
			    }
		        }
		    }
		}
	    ; Listlines
	    ; Pause
	    RowNumber:=RowNumber+1
	}
	Gosub ButtonOpti
	ToolTip,
	MsgBox Es wurden %GeloeschteOriginaleAnz% Originale gelöscht.
	return
}

ContextDelFiles:       ; Kontext-Menü Delete from FileSystem 
{
	MsgBox, 4, ,Achtung:`nsollen wirklich die selektierten Dateien gelöscht werden?`n`nContinue?
	    IfMsgBox, No, return        
	
	RowNumber = 0  ; This causes the first iteration to start the search at the top.
	ToolTip, beschäftigt,4,4
	Loop
	{
	
	    ; Since deleting a row reduces the RowNumber of all other rows beneath it,
	    ; subtract 1 so that the search includes the same row number that was previously
	    ; found (in case adjacent rows are selected):
	    RowNumber := LV_GetNext(RowNumber - 1)
	    if not RowNumber  ; The above returned zero, so there are no more selected rows.
	        break
	    LV_GetText(FileName, RowNumber, 1) ; Get the text of the first field.
	    LV_GetText(FileDir, RowNumber, 2)  ; Get the text of the second field.
	    FileDelete,%FileDir%\%FileName%
	    if Not ErrorLevel  
	        LV_Delete(RowNumber)  ; Clear the row from the ListView.
	    Else
		RowNumber:=RowNumber+1
	}
	Gosub ButtonOpti
	ToolTip,
	return
}

ContextReplaceText:   ; Kontext-Menü replace Text in Files
{
	Prompt=	was soll ersetzt werden?`n`n`nDie Zeitstempel`n	`%Createt_??`%  /  `%LastChange_??`%`n(der jeweiligen Datei) siehe Kontext-Menü`n	Rename at Filesystem`nkönnen [Reg]Ersetzen zugewiesen werden.`n`n(Spezialfunktion: der Zeitstempel kann mit `nTime[M|C|A]=YYYYMMDDHHMISS`ngesetzt werden.`nM = Modification time`nC = Creation time`nA = Last access time`nz.B.:`nSuchen=|Ersetzen=|RegSuchen=|RegErsetzen=|TimeM=20100417`n)
	InputBox, RePlace , Ersetzen, %Prompt%, , 800,400 ,, , , , %RePlace%
	If (ErrorLevel <> 0)
	    return
	
        Loop, parse, RePlace, |, 
        {
            if InStr(A_LoopField,"=")
            {
		
                Loop, parse, A_LoopField,=,%A_Space%
                {
                    Variable%A_Index%=%A_LoopField%
		    ; MsgBox %Variable1%=%Variable2%
		    If (A_Index=2)
			{
                        if Variable1 not contains`>,`<,`|,`;,,,, ,	,`#
                            {
                            %Variable1%=%Variable2%
                            ; MsgBox  %Variable1% = %Variable2%
                            }
			}

                 }
	     }
	}
	If (RegSuchen<>"" OR Suchen<>"")
	    MsgBox, 4, ,Achtung:`nsoll wirklich der Text in den selektierten Dateien ersetzt werden?`n`nContinue?
	        IfMsgBox, No, return
	If (Time<>"")
            {
	    If (TimeC="")
                TimeC:=Time
	    If (TimeM="")
                TimeM:=Time
	    If (TimeA="")
                TimeA:=Time
            }
	OhneNachfrage=Nein
	RowNumber = 0  ; This causes the first iteration to start the search at the top.
	ToolTip, beschäftigt,4,4
	Index:=1
	Loop
	{
	
	    ; Since deleting a row reduces the RowNumber of all other rows beneath it,
	    ; subtract 1 so that the search includes the same row number that was previously
	    ; found (in case adjacent rows are selected):
	    RowNumber := LV_GetNext(RowNumber - 1)
	    if not RowNumber  ; The above returned zero, so there are no more selected rows.
	        break
	    LV_GetText(FileName, RowNumber, 1) ; Get the text of the first field.
	    LV_GetText(FileDir, RowNumber, 2)  ; Get the text of the second field.
	    LV_GetText(FileTyp, RowNumber, 4)  ; Get the typ of the 4. field.
            ThisFile=%FileDir%\%FileName%
	    ThisFileTyp:=FileTyp
	    ; If (Time<>"")
                {
	        FileGetTime, LastChange , %ThisFile%, M
	        LastChange_YYYY:=SubStr(LastChange,1,4)
                LastChange_YY:=SubStr(LastChange,3,2)
                LastChange_MM:=SubStr(LastChange,5,2)
                LastChange_DD:=SubStr(LastChange,7,2)
                LastChange_HH:=SubStr(LastChange,9,2)
                LastChange_Mi:=SubStr(LastChange,11,2)
                LastChange_SS:=SubStr(LastChange,13,2)
	        FileGetTime, Createt , %ThisFile%, C
	        Createt_YYYY:=SubStr(Createt,1,4)
                Createt_YY:=SubStr(Createt,3,2)
                Createt_MM:=SubStr(Createt,5,2)
                Createt_DD:=SubStr(Createt,7,2)
                Createt_HH:=SubStr(Createt,9,2)
                Createt_Mi:=SubStr(Createt,11,2)
                Createt_SS:=SubStr(Createt,13,2)
                }

            IfExist, %ThisFile%
            	{
            	FileGetSize, ThisFileSize, %ThisFile%
		If(ThisFileTyp<>"lnk")
		    {
                    FileRead, ThisFileContent, %ThisFile%
		    }
		Else
		    {
		    FileGetShortcut, %ThisFile% , ThisLink1, ThisLink2, ThisLink3, ThisLink4, ThisLink5, ThisLink6, ThisLink7
		    ThisFileContent=%ThisLink1%%A_Tab%%ThisLink2%%A_Tab%%ThisLink3%%A_Tab%%ThisLink4%%A_Tab%%ThisLink5%%A_Tab%%ThisLink6%%A_Tab%%ThisLink7%
		    }
                If (ThisFileSize = StrLen(ThisFileContent) OR ThisFileTyp="lnk")
                    {
                    HabeErsetzt=Nein
	    	    If (Suchen<>"")
                        {
                        Ersetzen:=InnereVariablenExtrahieren(Ersetzen)
	    	        StringReplace, ThisFileContent, ThisFileContent, %Suchen%, %Ersetzen%, All 
                        HabeErsetzt=Ja
                        }
	    	    If (RegSuchen<>"")
                        {
                        RegErsetzen:=InnereVariablenExtrahieren(RegErsetzen)
	    		ThisFileContent:= RegExReplace(ThisFileContent, RegSuchen , RegErsetzen)
                        HabeErsetzt=Ja
                        }
                    If (HabeErsetzt="Ja")
                        {
			If(ThisFileTyp<>"lnk")
			    {
            	            FileMove, %ThisFile%, %ThisFile%.bak,1
            	            FileAppend , %ThisFileContent%, %ThisFile%
			    }
			Else
			    {
			    StringSplit, ThisNewLink, ThisFileContent, %A_Tab%
			    Loop % ThisNewLink0
				{
				If(ThisLink%A_Index%<>ThisNewLink%A_Index%)
				    {
				    ThisLinkChanged=Ja
				    Break
				    }
				Else
				    ThisLinkChanged=Nein
				}
			    If(ThisLinkChanged="Ja")
				{
            	                FileMove, %ThisFile%, %ThisFile%.bak,1
			        FileCreateShortcut,%ThisNewLink1%,%ThisFile%,%ThisNewLink2%,%ThisNewLink3%,%ThisNewLink4%,%ThisNewLink5%,%ThisNewLink6%,,%ThisNewLink7%
; FileGetShortcut, LinkFile [, OutTarget, OutDir    , OutArgs, OutDescription, OutIcon,  OutIconNum,  OutRunState
; FileCreateShortcut, Target, LinkFile [, WorkingDir, Args,    Description,    IconFile, ShortcutKey, IconNumber, RunState

				}
			    }
                        }
            	    ; Listvars
            	    ; Pause
                    }
                Else
                    {
	            If(OhneNachfrage="Nein" AND HabeErsetzt="Ja")
		        {

                        MsgBox ,2,,%ThisFile% ist keine reine Textdatei`nersetzen ist hier nicht möglich!`n`n(ersetzen) Abbrechen / (Warnungen) Wiederholen / Ignorieren (der Meldungen, weiterhin ersetzen bei Text-Dateien)
	                IfMsgBox Abort
		            break
	                IfMsgBox Ignore
	      	            OhneNachfrage=Ja

                        ; MsgBox % ThisFileSize "=" StrLen(ThisFileContent)
                         }
                    }

	    	If (TimeC<>"")
                    {
	    	    FileSetTime , %TimeC%, %ThisFile%, C
                    }
	    	If (TimeM<>"")
                    {
	    	    FileSetTime , %TimeM%, %ThisFile%, M
                    }
	    	If (TimeA<>"")
                    {
	    	    FileSetTime , %TimeA%, %ThisFile%, A
                    }
            	}
	    RowNumber:=RowNumber+1
	    Index:=Index+1
            ; Listlines
	}
        Suchen=
        RegSuchen=
	Time=
	TimeC=
	TimeM=
	TimeA=

	Gosub ButtonOpti
	ToolTip,
	return
}
ReplaceRelToAbs:   ; Kontext-Menü replace relative Path with absolut path in Files ########### noch nicht verwendbar
{
	; z.B.
	ThisAbsFolder=href:"//c:/Dok"	; Ordner in dem die jeweilige Datei steht, deren Pfade im Inhalt ersetzt werden soll.
	ThisAbsPath=href:"//C:/temp/test.htm"	; Beispiel für eine zu ersetzenden absoluten Pfad im Datei-Inhalt
	ThisRelPath=href:"../test.htm"	; Beispiel für einen ersetzten Pfad im Datei-Inhalt

	Prompt=	was soll ersetzt werden?`nverwendbare Variablen:`n`%ThisAbsPath`%`n`%ThisRelPath`%`n`n(Spezialfunktion: der Zeitstempel kann mit `nTime[M|C|A]=YYYYMMDDHHMISS`nverändert werden.`nM = Modification time`nC = Creation time`nA = Last access time)
	InputBox, RePlace , Umbenennen, %Prompt%, , 800,400 ,, , , , %RePlace%
	If (ErrorLevel <> 0)
	    return
        Loop, parse, RePlace, |, 
        {
            if InStr(A_LoopField,"=")
            {
		
                Loop, parse, A_LoopField,=,%A_Space%
                {
                    Variable%A_Index%=%A_LoopField%
		    ; MsgBox %Variable1%=%Variable2%
		    If (A_Index=2)
			{
                        if Variable1 not contains`>,`<,`|,`;,,,, ,	,`#
                            {
                            %Variable1%=%Variable2%
                            MsgBox  %Variable1% = %Variable2%
                            }
			}

                 }
	     }
	}
	If (RegSuchen<>"" OR Suchen<>"")
	    MsgBox, 4, ,Achtung:`nsoll wirklich der Text in den selektierten Dateien ersetzt werden?`n`nContinue?
	        IfMsgBox, No, return
	If (Time<>"")
            {
	    If (TimeC="")
                TimeC:=Time
	    If (TimeM="")
                TimeM:=Time
	    If (TimeA="")
                TimeA:=Time
            }
	OhneNachfrage=Nein
	RowNumber = 0  ; This causes the first iteration to start the search at the top.
	ToolTip, beschäftigt,4,4
	Index:=1
	Loop
	{
	
	    ; Since deleting a row reduces the RowNumber of all other rows beneath it,
	    ; subtract 1 so that the search includes the same row number that was previously
	    ; found (in case adjacent rows are selected):
	    RowNumber := LV_GetNext(RowNumber - 1)
	    if not RowNumber  ; The above returned zero, so there are no more selected rows.
	        break
	    LV_GetText(FileName, RowNumber, 1) ; Get the text of the first field.
	    LV_GetText(FileDir, RowNumber, 2)  ; Get the text of the second field.
            ThisFile=%FileDir%\%FileName%
            IfExist, %ThisFile%
            	{
            	FileGetSize, ThisFileSize, %ThisFile%
                FileRead, ThisFileContent, %ThisFile%
                If (ThisFileSize = StrLen(ThisFileContent))
                    {
                    HabeErsetzt=Nein
	    	    If (Suchen<>"")
                        {
	    	        StringReplace, ThisFileContent, ThisFileContent, %Suchen%, %Ersetzen%, All 
                        HabeErsetzt=Ja
                        }
	    	    If (RegSuchen<>"")
                        {
	    		ThisFileContent:= RegExReplace(ThisFileContent, RegSuchen , RegErsetzen)
                        HabeErsetzt=Ja
                        }
                    If (HabeErsetzt="Ja")
                        {
            	        FileMove, %ThisFile%, %ThisFile%.bak,1
            	        FileAppend , %ThisFileContent%, %ThisFile%
                        }
            	    ; Listvars
            	    ; Pause
                    }
                Else
                    {
	            If(OhneNachfrage="Nein" AND HabeErsetzt="Ja")
		        {

                        MsgBox ,2,,%ThisFile% ist keine reine Textdatei`nersetzen ist hier nicht möglich!`n`n(ersetzen) Abbrechen / (Warnungen) Wiederholen / Ignorieren (der Meldungen, weiterhin ersetzen bei Text-Dateien)
	                IfMsgBox Abort
		            break
	                IfMsgBox Ignore
	      	            OhneNachfrage=Ja

                        ; MsgBox % ThisFileSize "=" StrLen(ThisFileContent)
                         }
                    }

	    	If (TimeC<>"")
                    {
	    	    FileSetTime , %TimeC%, %ThisFile%, C
                    }
	    	If (TimeM<>"")
                    {
	    	    FileSetTime , %TimeM%, %ThisFile%, M
                    }
	    	If (TimeA<>"")
                    {
	    	    FileSetTime , %TimeA%, %ThisFile%, A
                    }
            	}
	    RowNumber:=RowNumber+1
	    Index:=Index+1
            ; Listlines
	}
        Suchen=
        RegSuchen=
	Time=
	TimeC=
	TimeM=
	TimeA=

	Gosub ButtonOpti
	ToolTip,
	return
}

ContextReNameFiles:   ; Kontext-Menü Rename at FileSystem 
{
	
	; MsgBox, 4, ,Achtung:`nsollen wirklich die selektierten Dateien umbenannt werden?`n`nContinue?
	;   IfMsgBox, No, return
	Prompt=
	(
_______________________________________________________________________________________________

	
In der ersten editierbaren Zeile wird geregelt, wie umbenannt wird.
Die restlichen Zeilen dienen zur Info und zum kopieren von Variablen, bzw. von Beispielen.

	benutzbare Variablen:
	`%Index`%	Zähler
	`%LastChange`%	Zeitstempel der letzten Änderung
	`%LastChange_YYYY`% `%LastChange_YY`% `%LastChange_MM`% `%LastChange_DD`% `%LastChange_HH`% `%LastChange_Mi`% `%LastChange_SS`%
	`%Createt`%	Zeitstempel der Erstellung der Datei
	`%Createt_YYYY`% `%Createt_YY`% `%Createt_MM`% `%Createt_DD`% `%Createt_HH`% `%Createt_Mi`% `%Createt_SS`%
	`%Size`%	Größe der Datei [Byte]
	`%A_space`%	Leerzeichen
	`%A_Now`%	Jetzt YYYYMMDDHH24MISS
	`%A_YYYY`%	Jetzt YYYY
	`%A_MM`%	Jetzt MM
	`%A_DD`%	Jetzt DD
	`%A_Hour`%	Jetzt HH
	`%A_Min`%	Jetzt Mi
	`%A_Sec`%	Jetzt SS
	`%Pipe`%   	|
	+ weitere 	wie immer auf eigene Gefahr!
	
	Beispiele
	- Multimedia-Dateien so umbenennen, dass sie bei alphabetischer Sortierung in Chronologischer Reihenfolge gelistet werden:
	NewName=`%Createt_YYYY`%_`%Createt_MM`%_`%Createt_DD`%-`%Createt_HH`%_`%Createt_Mi`%_`%Createt_SS`%-`%OldName`%|NewExt=`%OldExt`%|Suchen=|Ersetzen=|RegSuchen=|RegErsetzen=
	- Ändern des Datei-Typs (hier z.B. als Vorbereitung für Diashows, Typ jpg anzeigen, Typ jpeg weglassen):
	NewName=`%OldName`%|NewExt=jpeg|Suchen=|Ersetzen=|RegSuchen=|RegErsetzen=
	- Ersetzen von Umlauten (hier ä -> ae):
	NewName=`%OldName`%|NewExt=`%OldExt`%|Suchen=ä|Ersetzen=ae|RegSuchen=|RegErsetzen=
	- Suche am DateiNameBeginn und ersetze (hier Jahreszahl 09 durch 2009)
	NewName=%OldName%|NewExt=%OldExt%|Suchen=|Ersetzen=|RegSuchen=^09|RegErsetzen=2009
	- Suche mehrere Schreibweisen des 3. Monats Groß/Klein-Schreibung egal, ersetze durch 03
	NewName=%OldName%|NewExt=%OldExt%|Suchen=|Ersetzen=|RegSuchen=i)(März`%Pipe`%Maerz`%Pipe`%March)|RegErsetzen=03
	- Zeitstempel nach vorne bringen (z.B.: Dateiname[100406].typ -> 100406-Dateiname.typ)
	NewName=%OldName%|NewExt=%OldExt%|Suchen=|Ersetzen=|RegSuchen=^(.*)\[(.*)\]|RegErsetzen=$2-$1
	)
	; InputBox, Rename , Umbenennen, %Prompt%, , 800,400 ,, , , , %ReName%
	; If (ErrorLevel <> 0)
	    ; return
	RenameAbfragen:
	RenameCrPrompt=%ReName%`n%Prompt%
	umbenennen_TT=benennt die selektierten Dateien  wie in Zeile 1 beschrieben  um.`nEs wird einzeln nachgefragt ob die Umbenennung so gemeint war.
	ohneRueckfrageumbennen_TT=benennt die selektierten Dateien  wie in Zeile 1 beschrieben  ohne Rückfrage  um.
	Eingabezuruecksetzen_TT=Setzt die Eingabe zurück.
	abbrechen_TT=Bricht umbenennen ab,`nauch die Änderungen in Zeile 1 gehen verloren.
	; Edit1_TT=Bitte Regelwerk für die Umbenennungen in Zeile 1 eingeben.
	Frage4711_TT=Bitte Regelwerk für die Umbenennungen in Zeile 1 eingeben.
	RenameCrPrompt:=AbfrageFenster("Rename Files",RenameCrPrompt,"     umbenennen     ",">>>>>>ohne Rueckfrage umbennen",">>>>>>>>>>>>>>Eingabe zuruecksetzen",">>>>>>>>>>>>>>     abbrechen     ")
	WinActivate SucheDateien
	If(SubStr(RenameCrPrompt, 1 , 1) =2)
		OhneNachfrage=Ja
	Else If(SubStr(RenameCrPrompt, 1 , 1) =4 OR SubStr(RenameCrPrompt, 1 , 1) =0)
		Return
	Else If(SubStr(RenameCrPrompt, 1 , 1) =3)
		{
		Rename:=RenameOrg
		Goto RenameAbfragen
		}
	Else If(SubStr(RenameCrPrompt, 1 , 1) =1)
		OhneNachfrage=Nein
	
	StringTrimLeft, RenameCrPrompt, RenameCrPrompt, 1
	Loop, parse, RenameCrPrompt,`n,`r
        {
		Rename:=A_LoopField
		break
		}
	
        Loop, parse, Rename, |, 
        {
            if InStr(A_LoopField,"=")
            {
		
                Loop, parse, A_LoopField,=,%A_Space%
                {
                    Variable%A_Index%=%A_LoopField%
		    ; MsgBox %Variable1%=%Variable2%
                    if Variable1 not contains`>,`<,`|,`;,,,, ,	,`#
                        {
                        %Variable1%=%Variable2%
                        ; MsgBox drin
                        }

                }
	    }
	}
	
	RowNumber = 0  ; This causes the first iteration to start the search at the top.
	ToolTip, beschäftigt,4,4
	Index:=1
	Loop
	{
	
	    ; Since deleting a row reduces the RowNumber of all other rows beneath it,
	    ; subtract 1 so that the search includes the same row number that was previously
	    ; found (in case adjacent rows are selected):
	    RowNumber := LV_GetNext(RowNumber - 1)
	    if not RowNumber  ; The above returned zero, so there are no more selected rows.
	        break
	    LV_GetText(FileName, RowNumber, 1) ; Get the text of the first field.
	    LV_GetText(FileDir, RowNumber, 2)  ; Get the text of the second field.
            ThisFile=%FileDir%\%FileName%
	    FileGetTime, LastChange , %ThisFile%, M
	    LastChange_YYYY:=SubStr(LastChange,1,4)
            LastChange_YY:=SubStr(LastChange,3,2)
            LastChange_MM:=SubStr(LastChange,5,2)
            LastChange_DD:=SubStr(LastChange,7,2)
            LastChange_HH:=SubStr(LastChange,9,2)
            LastChange_Mi:=SubStr(LastChange,11,2)
            LastChange_SS:=SubStr(LastChange,13,2)
	    FileGetTime, Createt , %ThisFile%, C
	    Createt_YYYY:=SubStr(Createt,1,4)
            Createt_YY:=SubStr(Createt,3,2)
            Createt_MM:=SubStr(Createt,5,2)
            Createt_DD:=SubStr(Createt,7,2)
            Createt_HH:=SubStr(Createt,9,2)
            Createt_Mi:=SubStr(Createt,11,2)
            Createt_SS:=SubStr(Createt,13,2)

            FileGetSize, Size, %ThisFile%
	    SplitPath, ThisFile , OutThisFileName, OutThisDir, OldExt, OldName
	    ThisNewName:=InnereVariablenExtrahieren(NewName)
	    ThisNewExt:=InnereVariablenExtrahieren(NewExt)
            IF ((VorExt . ThisNewExt . NachExt) ="")
            	NewFileName:=VorName ThisNewName NachName
            Else
            	NewFileName:=VorName ThisNewName NachName "." VorExt ThisNewExt NachExt
            ; ThisSuchen:=InnereVariablenExtrahieren(Suchen)
            ; ThisErsetzen:=InnereVariablenExtrahieren(Ersetzen)
            ; MsgBox Suchen="%Suchen%"
	    If (Suchen<>"")
                {
                ThisSuchen:=InnereVariablenExtrahieren(Suchen)
                ThisErsetzen:=InnereVariablenExtrahieren(Ersetzen)
                ; MsgBox % Index " vor"
	    	StringReplace, NewFileName, NewFileName, %ThisSuchen%, %ThisErsetzen%, All 
                }
	    If (RegSuchen<>"")
                {
                ThisRegSuchen:=InnereVariablenExtrahieren(RegSuchen)
                ThisRegErsetzen:=InnereVariablenExtrahieren(RegErsetzen)
	    	NewFileName:= RegExReplace(FileName, ThisRegSuchen , ThisRegErsetzen)
                }
	    If (FileName<>NewFileName)
		{
	        ; MsgBox % FileName "`n" NewFileName
	        If(OhneNachfrage="Nein")
		    {
	            MsgBox, 6, , %FileName%		wird zu`n%NewFileName%`nDo you want to continue without this Question? (Press Continue, Try Again or Cancel to aboard)
	            IfMsgBox Cancel
		        break
	            IfMsgBox Continue
		        OhneNachfrage=Ja
		}
                FileMove, %FileDir%\%FileName%, %FileDir%\%NewFileName%,0 
	        if Not ErrorLevel  
	            LV_Delete(RowNumber)  ; Clear the row from the ListView.
	        Else
		    RowNumber:=RowNumber+1
		}
	    Else
		RowNumber:=RowNumber+1
	    Index:=Index+1
            ; MsgBox % Index
	}
        Suchen=
        RegSuchen=
	Gosub ButtonOpti
	ToolTip,
	return
}

ContextCopy:    ; Kontext-Menü Copy
{
	RowNumber = 0  ; This causes the first iteration to start the search at the top.
	ToolTip, beschäftigt,4,4
	Spalte=
	Loop
	{
	    RowNumber := LV_GetNext(RowNumber)
	    if not RowNumber  ; The above returned zero, so there are no more selected rows.
	        break
	    Zeile=
	    loop,5
	    {
	        LV_GetText(Spalte%A_Index%, RowNumber, A_Index) 
	        Zeile:=Zeile Spalte%A_Index% A_Tab
	    }
	    StringTrimRight, Zeile, Zeile,1
	    Spalte:=Spalte Zeile "`r`n"
	}
	StringTrimRight, Spalte, Spalte,2
	Clipboard:=Spalte
	ToolTip,
return
}

ContextFullPath:    ; Kontext-Menü FullPath
{
	RowNumber = 0  ; This causes the first iteration to start the search at the top.
	ToolTip, beschäftigt,4,4
	Spalte=
	Loop
	{
	    RowNumber := LV_GetNext(RowNumber)
	    if not RowNumber  ; The above returned zero, so there are no more selected rows.
	        break
	    LV_GetText(Spalte1, RowNumber, 1) 
	    LV_GetText(Spalte2, RowNumber, 2) 
	    If(Spalte2<>"")
	        Zeile=%Spalte2%\%Spalte1%
	    Else
		Zeile=%Spalte1%
	    Spalte=%Spalte%%Zeile%`r`n
	}
	StringTrimRight, Spalte, Spalte,2
	Clipboard:=Spalte
	ToolTip,
	return
}

ContextPaste:    ; Kontext-Menü Paste
{
    ToolTip,beschäftigt,4,4
    Loop, parse, Clipboard, `n, `r  ; Specifying `n prior to `r allows both Windows and Unix files to be parsed.
    {
        ; MsgBox, 4, , Line number %A_Index% is %A_LoopField%.`n`nContinue?
        ; IfMsgBox, No, break
        Loop, parse, A_LoopField, %A_Tab%
        {
            Spalte%A_Index%:=A_LoopField
            IndexEnde:=A_Index
        }
        loop % 5-IndexEnde
        {
            TempIndex:=IndexEnde+A_Index
            Spalte%TempIndex%=
        }
        LV_Add("",Spalte1,Spalte2,Spalte3,Spalte4,Spalte5)
    }
    Gosub ButtonOpti
    ToolTip,
return
}

ContextSelectAll:    ; Kontext-Menü SelectAll
{
    If CheckboxR
	{
		DoMitschrieb=%DoMitschrieb%`r`nContextSelectAll
	}
	RowNumber = 0  ; This causes the first iteration to start the search at the top.
	ToolTip, beschäftigt,4,4
	LV_Modify(0, "Select")
	ToolTip,
	Return
}

ContextDeSelectAll:    ; Kontext-Menü DeSelectAll
{
    If CheckboxR
	{
		DoMitschrieb=%DoMitschrieb%`r`nContextDeSelectAll
	}
	RowNumber = 0  ; This causes the first iteration to start the search at the top.
	ToolTip, beschäftigt,4,4
	LV_Modify(0, "-Select")
	ToolTip,
	Return
}

ContextInvertSelect:
{
	ToolTip,beschäftigt,4,4
	RowNumberSelect := LV_GetNext(0)
	Loop % LV_GetCount()
	{
	    RowNumber := A_Index ; - 1
	    If (RowNumberSelect = RowNumber)
		{
		LV_Modify(RowNumber, "-Select")  ; De-select
		RowNumberSelect := LV_GetNext(RowNumber)
		
		}
	    Else
		LV_Modify(RowNumber, "Select")  ; select
	}
	ToolTip,
	Return
}
ContextSelectUp:
Gosub SelectUp
Return

ContextErzeugeLink:    ; Kontext-Menü ErzeugeLink
FileSelectFolder, LinkInFolder,*%LinkInFolder%, 1, get a folder to copy a Link of selectet files:
EinstiegLinkUebergebenerOrdner:
{
	if not LinkInFolder  ; The user canceled the dialog.
	    return
	If CheckboxR
	{
		DoMitschrieb=%DoMitschrieb%`r`nLinkInFolder=%LinkInFolder%`r`nEinstiegLinkUebergebenerOrdner
	}
	RowNumber = 0  ; This causes the first iteration to start the search at the top.
	SelectCounter:=0
	Loop
	{
		; Since deleting a row reduces the RowNumber of all other rows beneath it,
		; subtract 1 so that the search includes the same row number that was previously
		; found (in case adjacent rows are selected):
		RowNumber := LV_GetNext(RowNumber)
		if not RowNumber  ; The above returned zero, so there are no more selected rows.
			break
		SelectCounter:=SelectCounter+1
		; If (SelectCounter=15)
	    ; {
		;	MsgBox, 4100, , sollen weitere Links Erzeugt werden?, 10
		;	IfMsgBox No
		;		break
	    ; }
		LV_GetText(FileName, RowNumber, 1) ; Get the text of the first field.
		LV_GetText(FileDir, RowNumber, 2)  ; Get the text of the second field.
                FileDirFileName=%FileDir%\%FileName%
		IfExist %FileDirFileName%
	    {
			; Run, explorer `/n`,`/select `, %FileDir%\%FileName%
                        LinkInFolderFileName=%LinkInFolder%\%FileName%
                        RelLink:= PfadAbs2Rel(LinkInFolderFileName,FileDirFileName)
                        RelLinkComent=href="%RelLink%"
			FileCreateShortcut, %FileDirFileName%,%LinkInFolder%\%FileName%.lnk,%FileDir%,,%RelLinkComent%
			FileGetTime, ThisModificatonTime , %FileDirFilename%, M
			FileGetTime, ThisCreationTime , %FileDirFilename%, C
			FileSetTime , %ThisModificatonTime%, %LinkInFolder%\%FileName%.lnk, M
			FileSetTime , %ThisCreationTime%, %LinkInFolder%\%FileName%.lnk, C
	    }
	}
	return
}

ContextAutoSelectNextMehrfachLink:
{
; ####################################################################################
RowNumber:=0
MinFilePathLength:=0
FocusedRowNumber:=LV_GetNext(RowNumber, "Focused") 
MinFilePathLengthRowNumber:=FocusedRowNumber
RowNumber:=FocusedRowNumber-1
LV_Modify(0, "-Select")
LV_GetText(FileName%FocusedRowNumber%, FocusedRowNumber, 1)
LV_GetText(FileDir%FocusedRowNumber%, FocusedRowNumber, 2)
FilePathLength%FocusedRowNumber%:=StrLen(FileName%FocusedRowNumber%)+1+StrLen(FileDir%FocusedRowNumber%)
MinFilePathLength:=FilePathLength%FocusedRowNumber%

LV_GetText(FocusedHash, FocusedRowNumber, 5)  ; Get the text of the 5 field.
; ListVars
If(StrLen(FocusedHash)<>32)
    return
Loop
    {
    ++RowNumber
    LV_GetText(ThisHash, RowNumber, 5)
    If (ThisHash=FocusedHash)
         {
          ; FileGetSize, FileSize%RowNumber%, %ThisFile%
          LV_Modify(RowNumber, "Select")
          LV_GetText(FileName%RowNumber%, RowNumber, 1)
          LV_GetText(FileDir%RowNumber%, RowNumber, 2)
          FilePathLength%RowNumber%:=StrLen(FileName%RowNumber%)+1+StrLen(FileDir%RowNumber%)
          IF (FilePathLength%RowNumber% < MinFilePathLength)
             {
             MinFilePathLength:=FilePathLength%RowNumber%
             MinFilePathLengthRowNumber:=RowNumber
             ; msgbox % MinFilePathLengthRowNumber " " RowNumber
             }
         
         }
    Else
         {
         NextRowNumber:=RowNumber
         Break
         }
    }
LV_Modify(MinFilePathLengthRowNumber, "Focus")
return
}
OrdnerEntfernen:
ToolTip,beschäftigt,4,4
SListeMerkenAnzahl:=LV_GetCount()
Z_Index:=SListeMerkenAnzahl
Loop % SListeMerkenAnzahl
    {
    LV_GetText(ThisFileSize, Z_Index, 3)
    ; MsgBox ThisFileSize="%ThisFileSize%"
    If(ThisFileSize=0 OR ThisFileSize="")
        {
	LV_GetText(ThisFileName, Z_Index, 1)
        LV_GetText(ThisFileDir, Z_Index, 2)
        ThisFileDirFileName=%ThisFileDir%\%ThisFileName%
        ; MsgBox % ThisFileDirFileName
	if InStr(FileExist(ThisFileDirFileName), "D")
	     {
	     ; MsgBox Zeile %Z_Index%
	     LV_Delete(Z_Index)
             }
        }
	--Z_Index
    }
ToolTip,
Return
AutoSelectDoppelte:
{
Gosub OrdnerEntfernen
ToolTip,beschäftigt,4,4
ControlFocus , SysListView321, ahk_class AutoHotkeyGUI
LV_ModifyCol(5, "Sort")
sleep 1000
LV_ModifyCol(3, "SortDesc")
sleep 1000
LV_Modify(1, "Select")
RowNumber:=0
FocusedRowNumber:=1
MinFilePathLength:=0
; FocusedRowNumber:=LV_GetNext(RowNumber, "Focused") 
MinFilePathLengthRowNumber:=FocusedRowNumber
RowNumber:=FocusedRowNumber-1
LV_Modify(0, "-Select")
Loop
{
; FocusedRowNumber:=RowNumber+1
; MsgBox % FocusedRowNumber "	" RowNumber
If (FocusedRowNumber>=LV_GetCount())
	Break
LV_GetText(FileName%FocusedRowNumber%, FocusedRowNumber, 1)
LV_GetText(FileDir%FocusedRowNumber%, FocusedRowNumber, 2)
FilePathLength%FocusedRowNumber%:=StrLen(FileName%FocusedRowNumber%)+1+StrLen(FileDir%FocusedRowNumber%)
MinFilePathLength:=FilePathLength%FocusedRowNumber%

LV_GetText(FocusedHash, FocusedRowNumber, 5)  ; Get the text of the 5 field.
; ListVars
If(StrLen(FocusedHash)<>32)
    {
    ToolTip,
    return
    }
Loop
    {
    ++RowNumber
    LV_GetText(ThisHash, RowNumber, 5)
    If (ThisHash=FocusedHash)
         {
          LV_GetText(ThisFileName, RowNumber, 1)
          LV_GetText(ThisFileDir, RowNumber, 2)
          LV_GetText(ThisFileSize, RowNumber, 3)
          ThisFileDirFileName=%ThisFileDir%\%ThisFileName%
          IfExist %ThisFileDirFileName%
              {
              LV_Modify(RowNumber, "Select")
              }
          Else
              {
              LV_Delete(RowNumber)
              --RowNumber
              }
         }
    Else
         {
		 LV_Modify(RowNumber, "Focus")
		 
         ; NextRowNumber:=RowNumber
		 If(A_Index=2)
		 {
			LV_Delete(FocusedRowNumber)  ; Clear the row from the ListView.
			RowNumber:=FocusedRowNumber-1
		 }
		 Else
			--RowNumber
		 FocusedRowNumber:=RowNumber+1
         Break
         }
    }
}
ToolTip,
LV_Modify(1, "Focus")
return
}

DoppelteDurchLinksErsetzen:
NextRowNumber:=0
Gosub ContextDeSelectAll
FocusedRowNumber:=LV_GetNext(0, "Focused") 
If (FocusedRowNumber=0)
    LV_Modify(1, "Focus")
Loop
    {
    Gosub ContextAutoSelectNextMehrfachLink
    ; MsgBox OK
    Gosub ContextErzeugeMehrfachLink
    LV_Modify(NextRowNumber, "Focus")
    If(NextRowNumber>=DateiAnzahl)
        Break
    }
return

ContextErzeugeMehrfachLink:    ; Kontext-Menü ErzeugeMehrfachLink
	ToolTip,beschäftigt,4,4
	RowNumber := 0
        LinkErzeugt = nein
	FocusedRowNumber:=LV_GetNext(RowNumber, "Focused") 
	LV_GetText(FocusedFileName, FocusedRowNumber, 1) ; Get the text of the first field.
	LV_GetText(FocusedFileDir, FocusedRowNumber, 2)  ; Get the text of the second field.
	LV_GetText(FocusedSize, FocusedRowNumber, 3)  ; Get the text of the 3. field.
        LV_GetText(FocusedTyp, FocusedRowNumber, 4)
        If(FocusedSize<=MindestOriginalSize)
            {
            ToolTip,
	    MsgBox, 4, , Die Mindest-Dateigröße ist unterschritten.`nDo you want to continue? (Press YES or NO)
	    IfMsgBox No
		exit
            }
	LV_GetText(FocusedHash, FocusedRowNumber, 5)  ; Get the text of the 5 field.
	FocusedFileName=%FocusedFileDir%\%FocusedFileName%
        If(StrLen(FocusedFileName) > 200)
            {
            Msgbox ,4096,Hinweis,% "Die fokusierte Datei hat ein Gesamt-Pfad-Länge von " StrLen(FocusedFileName) ". `nsie wird von diesem Skript nicht unterstützt.",2
            ToolTip,
            return
            }
        Else IfNotExist %FocusedFileName%
            {
            Msgbox Die fokusierte Datei existiert (momentan) nicht (mehr)!`n`nAbbruch
            ToolTip,
            return
            }

        SplitPath, FocusedFileName , FocusedFileNameNoDir, FocusedDir, FocusedFileExt,FocusedFileNameNoExt
        If (HaschEinfuegen="ja")
            HashZusatz=%FocusedHash%.
        NewFocusedFileNameNoDir=%FocusedFileNameNoExt%.%HashZusatz%%FocusedFileExt%
	HashAnz:= StrLen(FocusedFileNameNoExt) - InStr(FocusedFileNameNoExt,".")
	If (HashAnz=32 AND StrLen(FocusedFileNameNoExt)>32)
	    {
	    NewFocusedFileName=%FocusedFileName%
	    NewFocusedFileNameNoDir=%FocusedFileNameNoDir%
	    }
	Else
            NewFocusedFileName=%FocusedDir%\%NewFocusedFileNameNoDir%
	Loop 

	{
	    RowNumber := LV_GetNext(RowNumber)
            if not RowNumber  ; The above returned zero, so there are no more selected rows.
	        break

	    If (FocusedRowNumber <> RowNumber)
		{
                LV_GetText(FileTyp, RowNumber, 4)
                If(FileType="lnk")
                    Continue
		LV_GetText(FileName, RowNumber, 1) ; Get the text of the first field.
		LV_GetText(FileDir, RowNumber, 2)  ; Get the text of the second field.
                LV_GetText(FileTyp, RowNumber, 4)
		LV_GetText(FileHash, RowNumber, 5)  ; Get the text of the 5. field.
                If(FileHash<>FocusedHash)
                    {
                    MsgBox, 4, , Der Hash vor der Wandlung in einen Link von`n%FileName%`nstimmt nicht mit dem Hash der fokusierten Datei überein!`nAbbrechen?
                    IfMsgBox Yes
                        break
                    }
                If(FileTyp<>FocusedTyp)
                    {
                    TrayTip , Achtung, Der Datei-Typ vor der Wandlung in einen Link von`n%FileName%`nstimmt nicht mit dem Datei-Typ der fokusierten Datei überein!`nAbbrechen?,
                    MsgBox, 4, , Der Datei-Typ vor der Wandlung in einen Link von`n%FileName%`nstimmt nicht mit dem Datei-Typ der fokusierten Datei überein!`nAbbrechen?
                    IfMsgBox Yes
                        break
                    }
		IfExist %FileDir%\%FileName%
	            {
		    IfNotExist %FocusedFileName%
			{
			MsgBox Die ZielDatei existiert (momentan) nicht (mehr)!
			Exit
			}
                    ; MsgBox erzeuge Link auf %NewFocusedFileName% mit dem Name`n%FileDir%\%FileName%.lnk und lösche`n%FileDir%\%FileName%
			; auch relativen Pad im [InternetShortcut] mitschleppen:
			; [InternetShortcut]
			; URL=file://Sstr102f/estr_shr002/ESTR_G00113/10_Work/40_MARS/9S_ARCHIV/MARS_PROJECT_ALT/Protokolle/Presentation/GFT_for_DCAG_0903005_Classic.ppt
			; URL=file://Sstr102f/estr_shr002/ESTR_G00113/10_Work/40_MARS/9S_ARCHIV/MARS_PROJECT_ALT/MARS_ProjektinhaltuErgebnisse/Mars Project/Protokolle/Presentation/./../../../../Protokolle/Presentation/GFT_for_DCAG_0903005_Classic.ppt
		    ; IniWrite, %NewFocusedFileName%, %FileDir%\%FileName%.htm.url, InternetShortcut, URL
                    AbsStandortPfad=%FileDir%\%FileName%
                    RelLink:= PfadAbs2Rel(AbsStandortPfad,NewFocusedFileName)
                    If(RelLink=NewFocusedFileName)
                        RelLinkComent=					; Relativer Pfad wurde nicht gefunden
                    Else
                        RelLinkComent=href="%RelLink%"			; Relativer Pfad wurde gefunden
                    LV_GetText(OldFileExt, RowNumber, 4)
                    If(OldFileExt="lnk")
                        DotNewFileExt=
                    Else
                        DotNewFileExt=.lnk
                    If (HaschEinfuegen="ja")
                        HashKomentar=			; leer da Hash schon im rel-Link 
                    Else
                        HashKomentar=%A_Space%| hash="%FocusedHash%"
                    FileCreateShortcut, %NewFocusedFileName%, %FileDir%\%FileName%%DotNewFileExt%,%FocusedFileDir%,,%RelLinkComent%%HashKomentar%
                    If (ErrorLevel="0")
                        {
			FileGetTime, ThisModificatonTime , %NewFocusedFileName%, M
			FileGetTime, ThisCreationTime , %NewFocusedFileName%, C
			FileSetTime , %ThisModificatonTime%, %FileDir%\%FileName%%DotNewFileExt%, M
			FileSetTime , %ThisCreationTime%, %FileDir%\%FileName%%DotNewFileExt%, C

                        ; MsgBox % ErrorLevel
                        LinkErzeugt = ja
                        FileDelete, %FileDir%\%FileName%
                        If (ErrorLevel<>"0")
                            {
			    Run Properties "%FileDir%\%FileName%"
                            MsgBox "%FileDir%\%FileName%"`nkonnte nicht gelöscht werden.`nBerechtigungen prüfen!
			    }
			Else
			    {
			    LinkName=%FileName%%DotNewFileExt%
			    FileGetSize, LinkSize,%FileDir%\%LinkName%
                            ThisFileName=%FileDir%\%LinkName%
			    SplitPath, ThisFileName , , , ThisFileTyp
			    LV_Modify(RowNumber, "Select", LinkName, FileDir,LinkSize,ThisFileTyp)
			    }
                        }
		    Else
			{
			MsgBox der Link `n"%FileDir%\%FileName%%DotNewFileExt%"`nauf `n"%NewFocusedFileName%"`nkonnte nicht erstellt werden.
			}
		    }		
		}
	}
        If (LinkErzeugt = "ja")
            {
            If (HaschEinfuegen="ja")
                {
                FileMove, %FocusedFileName%, %NewFocusedFileName% , 0
                If (ErrorLevel = "0")
                    LV_Modify(FocusedRowNumber, "Select", NewFocusedFileNameNoDir)
                }
            }
	ToolTip,
return

ContextLink2Org:    ; Kontext-Menü Link2Org
FileSelectFolder, OrgOfLinkInFolder,*%OrgOfLinkInFolder%, 1, Wähle den Ordner in den die Originale der Links kopiert werden:`nMit Cancel werden die Originale neben die Links gestellt.
EinstiegLink2OrgUebergebenerOrdner:
{
	if not OrgOfLinkInFolder  ; The user canceled the dialog.
	    Link2OrgQuellGleichZiel=Ja
	Else
	    Link2OrgQuellGleichZiel=Nein
	If CheckboxR
	{
		DoMitschrieb=%DoMitschrieb%`r`nOrgOfLinkInFolder=%OrgOfLinkInFolder%`r`nEinstiegLink2OrgUebergebenerOrdner
	}
	RowNumber = 0  ; This causes the first iteration to start the search at the top.
	SelectCounter:=0
	Loop
	{
		; Since deleting a row reduces the RowNumber of all other rows beneath it,
		; subtract 1 so that the search includes the same row number that was previously
		; found (in case adjacent rows are selected):
		RowNumber := LV_GetNext(RowNumber)
		if not RowNumber  ; The above returned zero, so there are no more selected rows.
			break
		SelectCounter:=SelectCounter+1
		LV_GetText(FileName, RowNumber, 1) ; Get the text of the first field.
		LV_GetText(FileDir, RowNumber, 2)  ; Get the text of the second field.
                FileDirFileName=%FileDir%\%FileName%
                FileDirFileNameTemp=%FileDirFileName%
                SplitPath, FileDirFileName,,,, FileNameNoExt
		IfExist %FileDirFileName%
	        {
			OrgFileOutTarget:=RelLink2AbsPath(FileDirFileName)
			; MsgBox OrgFileOutTarget = %OrgFileOutTarget%
			IfNotExist %OrgFileOutTarget%
				FileGetShortcut, %FileDirFileName% , OrgFileOutTarget
			If (Link2OrgQuellGleichZiel = "Nein")
			{
				FileCopy, %OrgFileOutTarget%, %OrgOfLinkInFolder%\%FileNameNoExt% 
			}
			If (Link2OrgQuellGleichZiel = "Ja")
			{
				FileCopy, %OrgFileOutTarget%, %FileDir%\%FileNameNoExt%
                                IfExist %FileDir%\%FileNameNoExt%
					{
				        FileDelete,%FileDirFileNameTemp%
					FileGetSize, FileSize , %FileDir%\%FileNameNoExt%
					ThisFile=%FileDir%\%FileNameNoExt%
                                        SplitPath, ThisFile,,,FileTyp
					LV_Modify(RowNumber, "Select", FileNameNoExt, FileDir,FileSize,Filetyp)
					}
			}
	        }
	}
	return
}

ContextFileCopy:    ; Kontext-Menü FileCopy
	ToolTip, beschäftigt,4,4
	Basisordner=Nein
	Gosub GetFolderAddList
	FocusedRowNumber := 0
	FocusedRowNumber := LV_GetNext(FocusedRowNumber,"Focused")
	LV_GetText(FileDir, FocusedRowNumber, 2)
	if FileDir contains %FolderAddList1%
		{
		FileCopyQuelle=%FolderAddList1%
		FileCopyZiel=%FolderAddList2%
		}
	Else if FileDir contains %FolderAddList2%
		{
		FileCopyQuelle=%FolderAddList2%
		FileCopyZiel=%FolderAddList1%		
		}
	Else if FileDir contains %FolderAddList3%
		{
		FileCopyQuelle=%FolderAddList3%
		FileCopyZiel=%FolderAddList1%		
		}
	Else
		FolderAddList0=-1
	If (FolderAddList0>=2)
		{
		InputBox, FileCopyQuelle, FileCopy, Basis-QuellOrdner (für Multi-Copy)`n`nCancel: weitere Optionen,,800,,,,,, %FileCopyQuelle%
		if ErrorLevel
			{
			FolderAddListPfad = %A_temp%\FolderAddList.lst
			ThisQuelleUndziel:=LoadFolderOrFilesMitVorschlaegen("","19",FolderAddListPfad,"Gib (den Basis-Quellordner und leerzeichengetrennt) den (Basis-)Zielordner ein. (-... Ordner drüber`, +... händisch weiter)")
			If (ThisQuelleUndziel="")
				{
				ToolTip,
				Return
				}
			Loop, parse, ThisQuelleUndziel, `n, `r
				{
				If(A_Index="1")
					{
					FileCopyQuelle=%A_LoopField%
					Basisordner=Nein
					}
				If(A_Index="2")
					{
					FileCopyZiel=%A_LoopField%
					Basisordner=Ja
					}

				Else If Not (Instr(ThisQuelleUndziel,"`n"))
					{
					CopyInFolder:=FileCopyQuelle
					FileSelectFolder, CopyInFolder,*%CopyInFolder%, 3, get a folder to copy selectet files:
					If (CopyInFolder="")
						{
						ToolTip,
						Return
						}
					}
				}
			; FileSelectFolder, CopyInFolder,*%CopyInFolder%, 1, get a folder to copy selectet files:
			}
		Else
			{
			InputBox, FileCopyZiel, FileCopy, Basis-ZielOrdner,,800,,,,,, %FileCopyZiel%
			if ErrorLevel
				{
				ToolTip,
				Return
				}
			Else
				Basisordner=Ja
			}
		}
	Else
		{
		FolderAddListPfad = %A_temp%\FolderAddList.lst
		ThisQuelleUndziel:=LoadFolderOrFilesMitVorschlaegen("","19",FolderAddListPfad,"Gib (den Basis-Quellordner und leerzeichengetrennt) den (Basis-)Zielordner ein. (-... Ordner drüber`, +... händisch weiter)")
		If (ThisQuelleUndziel="")
			{
			ToolTip,
			Return
			}
		Loop, parse, ThisQuelleUndziel, `n, `r
			{
			If(A_Index="1")
				{
				FileCopyQuelle=%A_LoopField%
				Basisordner=Nein
				}
			If(A_Index="2")
				{
				FileCopyZiel=%A_LoopField%
				Basisordner=Ja
				}
			Else If Not (Instr(ThisQuelleUndziel,"`n"))
				{
				CopyInFolder:=FileCopyQuelle
				FileSelectFolder, CopyInFolder,*%CopyInFolder%, 3, get a folder to copy selectet files:
				If (CopyInFolder="")
					{
					ToolTip,
					Return
					}

				
				}
			}


		}
MsgBox FileCopy,%FileCopyQuelle%,%FileCopyZiel%
; Return			; muss wieder raus
FileCopy:
{
	if not CopyInFolder	; The user canceled the dialog.
		If (Basisordner<>"Ja")
			{
			ToolTip,
			return
			}
	ToolTip, beschäftigt,4,4
	If CheckboxR
	{
		DoMitschrieb=%DoMitschrieb%`r`nCopyInFolder=%CopyInFolder%`r`nFileCopy
	}
	RowNumber = 0  ; This causes the first iteration to start the search at the top.
	SelectCounter:=0
	If (Basisordner<>"Ja")
	{
	Loop
	{		; Filecopy in einen Fix-Ordner
		; Since deleting a row reduces the RowNumber of all other rows beneath it,
		; subtract 1 so that the search includes the same row number that was previously
		; found (in case adjacent rows are selected):
		RowNumber := LV_GetNext(RowNumber)
		if not RowNumber  ; The above returned zero, so there are no more selected rows.
			break
		SelectCounter:=SelectCounter+1
		LV_GetText(FileName, RowNumber, 1) ; Get the text of the first field.
		LV_GetText(FileDir, RowNumber, 2)  ; Get the text of the second field.
		IfExist %FileDir%\%FileName%
	    {
			IfExist %CopyInFolder%\%FileName%
	        {
				NewFileName=[%A_now%]%FileName%
				FileCopy, %FileDir%\%FileName%, %CopyInFolder%\%NewFileName% ,0
	        }
			Else
				FileCopy, %FileDir%\%FileName%, %CopyInFolder%\%FileName% ,0
	    }
	}
	}
	Else
	{
	Loop
		{		; Filecopy relativ zum Basis-Ordner
		; Since deleting a row reduces the RowNumber of all other rows beneath it,
		; subtract 1 so that the search includes the same row number that was previously
		; found (in case adjacent rows are selected):
		RowNumber := LV_GetNext(RowNumber)
		if not RowNumber  ; The above returned zero, so there are no more selected rows.
			break
		SelectCounter:=SelectCounter+1
		LV_GetText(FileName, RowNumber, 1) ; Get the text of the first field.
		LV_GetText(FileDir, RowNumber, 2)  ; Get the text of the second field.
		ThisFileDirFileNameQuelle=%FileDir%\%FileName%
		StringReplace, ThisFileDirFileNameZiel, ThisFileDirFileNameQuelle,%FileCopyQuelle%,%FileCopyZiel%,UseErrorLevel
		If(ErrorLevel="0")
			{
			MsgBox Die Datei `n	%ThisFileDirFileNameQuelle%`nwurde nicht kopiert, da sie nicht nicht im Basis-Ordner`n	%FileCopyQuelle%`nbefindet!
			Continue
			}
		IfExist %ThisFileDirFileNameQuelle%
			{
			SplitPath, ThisFileDirFileNameZiel,, ThisFileDirFileNameZielDir
			IfNotExist %ThisFileDirFileNameZielDir%
				FileCreateDir, %ThisFileDirFileNameZielDir% 
			IfExist %ThisFileDirFileNameZiel%
				{
				FileGetTime, ThisFileDirFileNameQuelleTimestamp,%ThisFileDirFileNameQuelle%
				FileGetTime, ThisFileDirFileNameZielTimestamp,%ThisFileDirFileNameZiel%
				If (MitNeuerenDateienOhneRueckfrageUeberschreiben<>"Ja" AND ThisFileDirFileNameQuelleTimestamp<ThisFileDirFileNameZielTimestamp)
					{
					MsgBox, 4102,Überschreiben?, soll die neure Datei`n	%ThisFileDirFileNameZiel%`ndurch die ältere Datei`n	%ThisFileDirFileNameQuelle%`nüberschrieben werden?`n`nContinue = Alle überschreiben`nCancel = nur mit neueren überschreiben`nTry Again = einzel Nachfage 
					IfMsgBox Cancel
		    				break
					IfMsgBox Continue
						{
		    				MitNeuerenDateienOhneRueckfrageUeberschreiben=Ja
						FileCopy, %ThisFileDirFileNameQuelle%, %ThisFileDirFileNameZiel% ,1
						If Errorlevel
							MsgBox Die Datei `n	%ThisFileDirFileNameQuelle%`nwurde nicht kopiert, FileCopy schlug fehl.
						}
					IfMsgBox TryAgain
						{
		    				MitNeuerenDateienOhneRueckfrageUeberschreiben=Nachfragen
						MsgBox, 4100,Überschreiben?, soll die neure Datei`n	%ThisFileDirFileNameZiel%`ndurch die ältere Datei`n	%ThisFileDirFileNameQuelle%`nüberschrieben werden?
						IfMsgBox Yes
							{
							FileCopy, %ThisFileDirFileNameQuelle%, %ThisFileDirFileNameZiel% ,1
							If Errorlevel
								MsgBox Die Datei `n	%ThisFileDirFileNameQuelle%`nwurde nicht kopiert, FileCopy schlug fehl.
							}
						}
					}
				Else
					{
					FileCopy, %ThisFileDirFileNameQuelle%, %ThisFileDirFileNameZiel% ,1
					If Errorlevel
						MsgBox Die Datei `n	%ThisFileDirFileNameQuelle%`nwurde nicht kopiert, FileCopy schlug fehl.
					}
				}
			Else
				{
				FileCopy, %ThisFileDirFileNameQuelle%, %ThisFileDirFileNameZiel% ,1
				If Errorlevel
					MsgBox Die Datei `n	%ThisFileDirFileNameQuelle%`nwurde nicht kopiert, FileCopy schlug fehl.
				}
			}
		}
	}
	MitNeuerenDateienOhneRueckfrageUeberschreiben=Nein
	ToolTip,
	return
}
ContextLinksAktualisieren:    ; Kontext-Menü Links Aktualisieren
{
	ToolTip, beschäftigt,4,4
	If CheckboxR
	{
		DoMitschrieb=%DoMitschrieb%`r`nContextLinksAktualisieren
	}
	RowNumber = 0  ; This causes the first iteration to start the search at the top.
	SelectCounter:=0
	Loop
	{
		; Since deleting a row reduces the RowNumber of all other rows beneath it,
		; subtract 1 so that the search includes the same row number that was previously
		; found (in case adjacent rows are selected):
		RowNumber := LV_GetNext(RowNumber)
		if not RowNumber  ; The above returned zero, so there are no more selected rows.
			break
		++SelectCounter
		LV_GetText(FileName, RowNumber, 1) ; Get the text of the first field.
		LV_GetText(FileDir, RowNumber, 2)  ; Get the text of the second field.
		FileDirFileName=%FileDir%\%FileName%
		IfExist %FileDirFileName%
	    	    {
		    SplitPath, FileDirFileName,,,FileTyp
		    If (FileTyp="lnk")
			{
			FileGetShortcut, %FileDirFileName% , OutTarget, OutDir, OutArgs, OutDescription, OutIcon, OutIconNum, OutRunState ; Abs Link besorgen
			; MsgBox FileGetShortcut`, %FileDirFileName% `, %OutTarget%`, %OutDir%`, %OutArgs%`, %OutDescription%`, %OutIcon%`, %OutIconNum%`, %OutRunState%
			IfExist %OutTarget% ; Existiert die Datei des Abs Link?
			    { ; Ja
			    HrefPos:=InStr(OutDescription, "href")
			    If (HrefPos) ; Ist Rel Link vorhanden?
				{
			    	ThisAbsPath:=RelLink2AbsPath(FileDirFileName) ; hole Rel Link 
				
				IfExist %ThisAbsPath%  ; Existiert die Datei des Rel Link?
				    {
				    ; MsgBox % ThisAbsPath "<>" OutTarget
				    If (ThisAbsPath<>OutTarget)
					{
					FileGetTime, ThisAbsPathCreationTime , %ThisAbsPath%, C
					FileGetTime, OutTargetCreationTime , %OutTarget%, C
					; MsgBox % ThisAbsPathCreationTime "`n" OutTargetCreationTime 
					If (OutTargetCreationTime = ThisAbsPathCreationTime)
						{
						FileGetTime, ThisAbsPathModificationTime , %ThisAbsPath%, M
						FileGetTime, OutTargetModificationTime , %OutTarget%, M
						If (ThisAbsPathModificationTime = OutTargetModificationTime)
							{
							FileGetSize, ThisAbsPathSize , %ThisAbsPath%
							FileGetSize, OutTargetSize , %OutTarget%
							If (ThisAbsPathSize=OutTargetSize)
								GleicheDateiUnterschiedlicherPfad=ja	; Mit hoher Wahrscheinlichkeit die selbe Datei, nur auf verschienem Wege erreicht.
							}
						}
					If(GleicheDateiUnterschiedlicherPfad<>"ja")
						{
						MsgBox , , Hinweis,  der existierende absolute Link 	%OutTarget%`nund der existierende relative Link 	%ThisAbsPath%`nzeigt auf unterschiedliche Dateien.`nhändisch berichtigen!,5
						Run Properties "%FileDirFileName%"
						; Listlines
						; pause
						continue
						}
					Else
						GleicheDateiUnterschiedlicherPfad=
					}
				    }
             		        RelLink:= PfadAbs2Rel(FileDirFileName,OutTarget)
             		        RelLinkThisAbsPath:= PfadAbs2Rel(FileDirFileName,ThisAbsPath)
				; MsgBox RelLink = %RelLink%	RelLinkThisAbsPath = %RelLinkThisAbsPath%
				RelLinkThisAbsPathLinks21:=SubStr(RelLinkThisAbsPath, 2,1)
				RelLinkThisAbsPathLinks12:=SubStr(RelLinkThisAbsPath, 1,2)
				If NOT (RelLinThisAbsPathkLinks21=":" OR RelLinkThisAbsPathLinks12="\\")
					RelLink:=RelLinkThisAbsPath
				RelLinkPos:=InStr(OutDescription, RelLink)
				; If(RelLinkPos-HrefPos < 7)
             		        ; RelLinkExist:= PfadAbs2Rel(FileDirFileName,OutTarget)		
				; If (RelLink=ThisAbsPath OR  NOT (InStr(RelLink, ".." ) OR (StrLen(RelLink)<StrLen(ThisAbsPath)))) ; ist es ein Relativer Link?
					; Continue
				RelLinkLinks21:=SubStr(RelLink, 2,1)
				RelLinkLinks12:=SubStr(RelLink, 1,2)
				;					0 +	1-7 -	8... +
				If NOT (RelLinkLinks21=":" OR RelLinkLinks12="\\" OR RelLink=ThisAbsPath OR ((RelLinkPos-HrefPos > 3)  AND (RelLinkPos-HrefPos < 8)))
				    { ; schreibe Rel Link neu
           		            RelLinkComent=href="%RelLink%" %OutDescription%
				    FileCreateShortcut, %OutTarget%,%FileDirFileName%,%OutDir%,%OutArgs%,%RelLinkComent%, %OutIcon%, %OutIconNum%, %OutRunState%
				    If(ErrorLevel=0)
				    	{ ; Link-File konnte erzeugt werden
				    	FileGetTime, ThisModificatonTime , %OutTarget%, M
				    	FileGetTime, ThisCreationTime , %OutTarget%, C
				    	FileSetTime , %ThisModificatonTime%, %FileDirFileName%, M
				    	FileSetTime , %ThisCreationTime%, %FileDirFileName%, C
				    	LV_Modify(RowNumber, "-Select")
				    	}
				    }
				}
			    Else
				{ ; schreibe Rel Link
             		        RelLink:= PfadAbs2Rel(FileDirFileName,OutTarget)
            		        RelLinkComent=href="%RelLink%" %OutDescription%
				FileCreateShortcut, %OutTarget%,%FileDirFileName%,%OutDir%,%OutArgs%,%RelLinkComent%, %OutIcon%, %OutIconNum%, %OutRunState%
				If(ErrorLevel=0)
				    { ; Link-File konnte erzeugt werden
				    FileGetTime, ThisModificatonTime , %OutTarget%, M
				    FileGetTime, ThisCreationTime , %OutTarget%, C
				    FileSetTime , %ThisModificatonTime%, %FileDirFileName%, M
				    FileSetTime , %ThisCreationTime%, %FileDirFileName%, C
				    LV_Modify(RowNumber, "-Select")
				    }
				}

			    }
                        Else ; sonst
			    { ; Nein
			    ThisAbsPath:=RelLink2AbsPath(FileDirFileName,"ja") ; hole Abs Link (nur gültigen)
			    IfExist %ThisAbsPath%
				{
				FileCreateShortcut, %ThisAbsPath% , %FileDirFileName%, %OutDir%, %OutArgs%, %OutDescription%, %OutIcon%, %OutIconNum%, %OutRunState% ; schreibe Abs Link neu
				If(ErrorLevel=0)
				    { ; Link-File konnte erzeugt werden
				    FileGetTime, ThisModificatonTime , %OutTarget%, M
				    FileGetTime, ThisCreationTime , %OutTarget%, C
				    FileSetTime , %ThisModificatonTime%, %FileDirFileName%, M
				    FileSetTime , %ThisCreationTime%, %FileDirFileName%, C
				    LV_Modify(RowNumber, "-Select")
				    }
				}
			    Else
				FileAppend , %FileDirFileName%	%OutTarget%	%ThisAbsPath% `r`n, %EigeneDateien%\SucheDateien\ToteLinks.log ; Toter Link
			    }
			}
	    	    }
	}
	
	ToolTip,
	return
}
ContextSucheToteLinksInVerknuepfungen:    ; SucheToteLinksInVerknuepfungen
{
	ToolTip, beschäftigt,4,4
	If CheckboxR
	{
		DoMitschrieb=%DoMitschrieb%`r`nContextSucheToteLinksInVerknuepfungen
	}
	RowNumber = 0  ; This causes the first iteration to start the search at the top.
	SelectCounter:=0
	Loop
	{
		; Since deleting a row reduces the RowNumber of all other rows beneath it,
		; subtract 1 so that the search includes the same row number that was previously
		; found (in case adjacent rows are selected):
		RowNumber := LV_GetNext(RowNumber)
		if not RowNumber  ; The above returned zero, so there are no more selected rows.
			break
		++SelectCounter
		LV_GetText(FileName, RowNumber, 1) ; Get the text of the first field.
		LV_GetText(FileDir, RowNumber, 2)  ; Get the text of the second field.
		FileDirFileName=%FileDir%\%FileName%
		IfExist %FileDirFileName%
	    	    {
		    SplitPath, FileDirFileName,,,FileTyp
		    If (FileTyp="lnk")
			{
			FileGetShortcut, %FileDirFileName% , OutTarget, OutDir, OutArgs, OutDescription, OutIcon, OutIconNum, OutRunState ; Abs Link besorgen
			ThisAbsPath:=RelLink2AbsPath(FileDirFileName) ; hole Rel Link
			; MsgBox ThisAbsPath=%ThisAbsPath%
			IfExist %OutTarget% ; Existiert die Datei des Abs Link?
				LV_Modify(RowNumber, "-Select")
			IfExist %ThisAbsPath%
				LV_Modify(RowNumber, "-Select")
			; Else
				; LV_Modify(RowNumber, "Select")
			; FileAppend , %FileDirFileName%	%OutTarget%	%ThisAbsPath% `r`n, %EigeneDateien%\SucheDateien\ToteLinks.log ; Toter Link
			}
		    Else
			LV_Modify(RowNumber, "Select")
	    	    }
		Else
		    LV_Modify(RowNumber, "Select")
	}
	ToolTip,
	return
}

; Andere ############################################
Aufnahme:
Gui, Submit,NoHide
If checkboxR
{
	; TrayTip,Makro,Aufnahme,9999999
	; To have a TrayTip permanently displayed, use a timer to refresh it periodically:
	SetTimer, RefreshTrayTip, 2500
	Gosub, RefreshTrayTip  ; Call it once to get it started right away.
	return
}
Else
{
	SetTimer, RefreshTrayTip, Off
	TrayTip,Makro,speichern -> mit Rechtsklick auf Haken r
}
Return
RefreshTrayTip:
TrayTip, Makro,Aufnahme, , 30
return
;
GuiSize:    ; die Fenstergröße wurde verändert  ; Expand or shrink the ListView in response to the user's resizing of the window.
{
	if A_EventInfo = 1  ; The window has been minimized.  No action needed.
	    return
	; Otherwise, the window has been resized or maximized. Resize the ListView to match.
	GuiControl, Move, MyListView, % "W" . (A_GuiWidth - 20) . " H" . (A_GuiHeight - 40)
	return
}

MyListView: ; DoppelKlick
{
	if A_GuiEvent = DoubleClick  ; There are many other possible values the script can check.
	{
	    LV_GetText(FileName, A_EventInfo, 1) ; Get the text of the first field.
	    LV_GetText(FileDir, A_EventInfo, 2)  ; Get the text of the second field.
	    If(Spalte2<>"")
		{
	        Run %FileDir%\%FileName%,, UseErrorLevel
	        if ErrorLevel
	            MsgBox Could not open "%FileDir%\%FileName%".
		}
	    Else
		{
	        Run %FileName%,, UseErrorLevel
	        if ErrorLevel
	            MsgBox Could not open "%FileName%".
		}
	}
	return
}

GuiDropFiles:   ; eingehendes Drag and Drop
{
	; MsgBox % A_GuiControl
	WinActivate,ahk_class AutoHotkeyGUI
	If (A_GuiControl="&Open")   ; eingehendes Drag and Drop auf Button Open
	{
	    Ue1=%A_GuiEvent%
	    Gosub BefehlsDateiVerarbeiten
	    Return
	}
	else If (A_GuiControl="&Typ")   ; eingehendes Drag and Drop auf Button Typ
	{
	    FileRead,SomeFilterTextTyp,%A_GuiEvent%
	    Gosub ButtonTyp
	    Return
	}
	else If (A_GuiControl="&Spez")   ; eingehendes Drag and Drop auf Button Spez
	{
	    FileRead,SomeFilterTextSpez,%Event%
	    Gosub ButtonSpez
	    Return
	}
	else If (A_GuiControl="CheckboxF")   ; eingehendes Drag and Drop auf Checkbox +
	{
		Loop, parse, A_GuiEvent, `n
	    {
	        if InStr(FileExist(A_LoopField), "D") 	; nur Folder zugelassen
			{
				; MsgBox Folder kommt an
				FileName=%A_LoopField%
				; Gosub NurFileName        
				SplitPath, FileName,ShortFileName,FileDir  ; Get the file's extension.
				FileExt=
				MsgBox Filename = %Filename%	
				FileGetTime, FileTime,%FileName%
				FileGetSize, FileSizeKB, %FileName%
				LV_Add("Icon" . 99999, ShortFileName, FileDir, FileSizeKB, FileExt,FileTime)
			}
		}
		Gosub ButtonOpti
	}
	else If (A_GuiControl="&Filter")   ; eingehendes Drag and Drop auf Button Filter
	{
	    FileRead,SomeFilterText,%A_GuiEvent%
	    Gosub ButtonFilter
	    Return
	}
	else If (A_GuiControl="MyListView")   ; eingehendes Drag and Drop in die Liste
	{
	    GuiControl, -Redraw, MyListView  ; Improve performance by disabling redrawing during load.
	    Gui, Submit,NoHide
	    ToolTip, beschäftigt,4,4
	
	    Loop, parse, A_GuiEvent, `n
	    {
	        if InStr(FileExist(A_LoopField), "D") 
	        {
	            ; MsgBox Ordner: %A_LoopField%
	            Folder=%A_LoopField%
	            Gosub EinstiegUebergebenerOrdner
	        }
	    else
	        {
	        ; MsgBox Datei: %A_LoopField%
	        FileName=%A_LoopField%
	        Gosub NurFileName        
	        }
	    }
	    Gosub ButtonOpti
	    ToolTip,
	}
	return
}

Sichern:
{
	ToolTip, beschäftigt,4,4
	SListeMerkenAnzahl:=LV_GetCount()
	Loop %SListeMerkenAnzahl%
	{
	    Z_Index:=A_Index
	    ; MsgBox % Z_Index
	    loop,5
	    {
	        LV_GetText(Zeile%Z_Index%Spalte%A_Index%, Z_Index, A_Index) 
	    }
	}
	; ListVars
	return
}
SelektierteSichern:
{
	ToolTip, beschäftigt,4,4
	RowNumber:=0
	Loop 
	    {
	    RowNumber := LV_GetNext(RowNumber)
	    if not RowNumber  ; The above returned zero, so there are no more selected rows.
	        break
	    ; MsgBox % RowNumber
	    loop,5
	    {
	        LV_GetText(Zeile%RowNumber%Spalte%A_Index%, RowNumber, A_Index) 
	    }
	}
	return
}

DoDateiSpeichern:
{
	Gui, Submit,NoHide
	If (FileSelectFileUeberspringen="False")
		FileSelectFile, SelectedDoFile, s32,*%SelectedDoFile%, speichert eine Befehlsdatei, (*.do)
	Else
	{
		SelectedDoFile=%SelectedFile%
		FileSelectFileUeberspringen=False
	}
	SplitPath, SelectedDoFile , , SelectedDoFileDir, SelectedDoFileExtension,SelectedDoFileNameNoExt
	if SelectedDoFileNameNoExt =
	{
		MsgBox,4,Aufzeichnung verwerfen,%DoMitschrieb%`r`n`r`nlöschen?
		IfMsgBox Yes
			DoMitschrieb=
		return
	}
	if Not SelectedDoFileExtension
		SelectedDoFile=%SelectedDoFile%.do
	IfExist %SelectedDoFile%
		MsgBox,4,Datei,%SelectedDoFile% überschreiben?
		IfMsgBox No
		{
			SelectedDoFile=%SelectedDoFileDir%\%SelectedDoFileNameNoExt%%A_Now%.do
			Run, explorer `/n`,`/select `, %SelectedDoFile%
		}
		IfMsgBox,cancel
			Return
	FileDelete,%SelectedDoFile%
	If (SubStr(DoMitschrieb,1,2)="`r`n")
		StringTrimLeft, DoMitschrieb, DoMitschrieb, 2
	FileAppend,%DoMitschrieb%,%SelectedDoFile%
	if not errorcode
		If not CheckboxR
			DoMitschrieb=
	; MsgBox %DoMitschrieb%
	Return
}

GuiClose:  ; When the window is closed, exit the script automatically:
{
	ControlGet, GesamtListe, List, , SysListView321,%A_ScriptName%
	FileDelete, %EndAusListPath%
	FileAppend , %GesamtListe%,%EndAusListPath%
	
	RowNumber = 0  ; This causes the first iteration to start the search at the top.
	SelectCounter:=0
	SelectetFiles=
	Loop
	{
		RowNumber := LV_GetNext(RowNumber)
		if not RowNumber  ; The above returned zero, so there are no more selected rows.
			break
		SelectCounter:=SelectCounter+1
		LV_GetText(FileName, RowNumber, 1) ; Get the text of the first field.
		LV_GetText(FileDir, RowNumber, 2)  ; Get the text of the second field.
		IfExist %FileDir%\%FileName%
	    {
			; Run, explorer `/n`,`/select `, %FileDir%\%FileName%
			SelectetFiles=%SelectetFiles%%RowNumber%	%FileDir%\%FileName%`r`n
	    }
	}
	StringTrimRight, SelectetFiles, SelectetFiles,2
	FileDelete, %EndAusListSelektPath%
	FileAppend , %SelectetFiles%,%EndAusListSelektPath%
	; run %EndAusListSelektPath%
	
	FocusedRowNumber := LV_GetNext(0, "F")  ; Find the focused row.
	LV_GetText(FileName, FocusedRowNumber, 1) ; Get the text of the first field.
	LV_GetText(FileDir, FocusedRowNumber, 2)  ; Get the text of the second field.
	IfExist %FileDir%\%FileName%
	{
		; Run, explorer `/n`,`/select `, %FileDir%\%FileName%
		FocusedFile=%FocusedRowNumber%	%FileDir%\%FileName%
	}
	FileDelete, %EndAusListFokusPath%
	FileAppend , %FocusedFile%,%EndAusListFokusPath%
	; run %EndAusListFokusPath%
	ExitApp
}

; Funktionsdefinitionen ############################################
;
Rel2AbsPath(Url)
{
    If (substr(Url,1,1)="\" OR substr(Url,2,1)=":")
        Return Url
    UrlAlt=%Url%
    URL = %A_scriptdir%\%Url%
    IfExist %Url%
    {
        Loop
        {
            If Not instr(Url,"..")
                break
            StringSplit, Url, Url ,\
            Loop % Url0
            {
                If(Url%A_Index%="..")
                {
                    IndexWeg:=A_index-1
                    Weg:="\" Url%IndexWeg% "\" Url%A_Index%
                    StringReplace, Url, Url, %Weg%,
                    ; msgbox % url
                    Break
                }
            }
        }
    }
    IfNotExist %Url%
    {
        ; msgbox % "zurück: " urlalt
        return UrlAlt
    }
    ; msgbox % "zurück: " url
    return Url
}

InFile(HaystackFileName,Needle,CaseSensitive = false, StartingPos = 1)	; Kurz: Liefert die Position des ersten Auftretens der Needle Zeichenkette (string) innerhalb der Haystack-Datei. Ähnlich InStr()	Eingang: Dateiname der zu durchsuchenden Datei, Suchzeichenkette	Ausgang: Position der Fundstelle	Beispiel: Steuer-Zeile:<br><code>Auto§Zeige die Position von InFile in AdHoc.ahk §Pos:=<b>InFile("AdHoc.ahk","InFile")</b>|MsgBoxNurText(Pos)|Exit</code><br>
{
    IfExist %HaystackFileName%
    {
	FileGetSize, ThisFileSize, %HaystackFileName%
        FileRead,Haystack,%HaystackFileName%
	If (ThisFileSize = StrLen(Haystack))
	    {
            ; MsgBox % Haystack
            Pos:=InStr(Haystack, Needle, CaseSensitive, StartingPos) 
            ; MsgBox %HaystackFileName% %Pos%
            Return Pos
            }
        Else
	    return 0
	}
    Else
        return 0
}

RegExMatchFile(HaystackFileName,Needle,UnquotedOutputVar = "", StartingPos = 1)	; Kurz: Liefert die Position des ersten Auftretens der Needle Zeichenkette (string) innerhalb der Haystack-Datei. Ähnlich RegExMatch()	Eingang: Dateiname der zu durchsuchenden Datei, Suchzeichenkette	Ausgang: Position der Fundstelle	Beispiel: Steuer-Zeile:<br><code>Auto§Zeige die Position von RegEx*File in AdHoc.ahk §Pos:=<b>RegExMatchFile("AdHoc.ahk","RegEx.*File")</b>|MsgBoxNurText(Pos)|Exit</code><br>
{
    IfExist %HaystackFileName%
	{
        FileRead,Haystack,%HaystackFileName%
        ; MsgBox % Haystack
        Pos:=RegExMatch(Haystack, Needle, UnquotedOutputVar, StartingPos) 
        ; MsgBox %HaystackFileName% %Pos%
        Return Pos
	}
    Else
        return 0
}

ShowHtmVar(HtmVar)	; Kurz: zeigt den Inhalt der übergebenen Variablen im Browser.	Eingang: Variable in HTML-Notation	Ausgang: -	Beispiel: Steuer-Zeile:<br><code>Auto§Hallo Welt§Anzeige=Hallo Welt|<b>ShowHtmVar(Anzeige)</b>|Exit</code><br>
{
    HtmVarPath=%A_Temp%\ShowHtmVar.htm
    FileDelete,%HtmVarPath%
    FileAppend , %HtmVar%, %HtmVarPath%
    Run,%HtmVarPath%
    return
}

InnereVariablenExtrahieren(Text,SerienbriefIndex="")	; Kurz: expandiert die inneren Variablen von Text.	Eingang: Text der Variablen enthält	Ausgang: Text mit expandierten Variablen	Beispiel: - 
{
    StringSplit, GefundeneVariablen, Text , `%
    Loop 			; über alle gefundenen Variablen
	{
        i:=2*a_index
        If (GefundeneVariablen%i%="")
            break
        StringLeft, Links3GefundeneVariablen%i%, GefundeneVariablen%i%, 3
        If (Links3GefundeneVariablen%i%="Sbr")
		{
            AktSerienbriefIndex:=SerienbriefIndex
		}
        else
            AktSerienbriefIndex=
        AktVar:=GefundeneVariablen%i%
        TempAktVar=%AktVar%
        AktVar=%AktVar%%AktSerienbriefIndex%
        AktVarInhalt:=%AktVar%
        ; MsgBox %TempAktVar% = %AktVarInhalt%
        StringReplace, Text, Text, `%%TempAktVar%`% , %AktVarInhalt%, All
	}
    ; MsgBox Text = "%Text%"
    return Text
}

LoadGoogleFind(Search="",FolderPath="",MaxFind="")
{
	Abfrage=Suchbegriff1+...
    If(Search="")
    {
        InputBox, Abfrage, Google, Abfrage,,800,,,,,, %Abfrage%
        if ErrorLevel
	    return
    }
    else
        Abfrage=%Search%
    If(FolderPath="")
        FolderPath=%A_Temp%\GoogleTemp
    If(MaxFind="")
        MaxFindAbfrage=1		 ; zeigt google suche im browser und frägt MaxFind ab
	Else
		MaxFindAbfrage=0
    Num=num=100
    Filetyp=filetype`%3Ahtm
    GrundUrl=http://www.google.de/search?
    GoogelTrenner=<h3 class=r><a href="
    Hochkomma="
    Gefunden:=0

    FileRemoveDir, %A_Temp%\GoogleTemp ,1
    FileCreateDir,%A_Temp%\GoogleTemp
    run %A_Temp%\GoogleTemp

    loop, 10
    {
        Index:=A_Index
        AnzeigeAb:=(A_Index -1) * 100
        Start=start=%AnzeigeAb%
        Url=%GrundUrl%%Num%&q=%Abfrage%+%Filetyp%&%Start%
        ; MsgBox % Url
        UrlDownloadToFile, %URL%, %A_Temp%\GoogleTemp\FHundert%A_Index%.htm 
        ; MsgBox %Errorlevel%
        If MaxFindAbfrage
        {
			MaxFindAbfrage=0
            run %A_Temp%\GoogleTemp\FHundert%A_Index%.htm, , , NewPID
            WinGet, OldPid , PID, A
            WinWaitNotActive,ahk_id %OldPID%
            WinWaitActive,ahk_id %NewPID%,,2
            InputBox, MaxFind, Google, wie viele Funstellen sollen berücksichtigt werden?,,,,,,,, 20
			if ErrorLevel
				Return
			if (MaxFind=0)
				Return
        }
        FileRead, GooglErg, %A_Temp%\GoogleTemp\FHundert%A_Index%.htm
        FileDelete,%A_Temp%\GoogleTemp\FHundert%A_Index%.htm
        StringReplace, GooglErg, GooglErg, %GoogelTrenner% , §, 1
		If not InStr(GooglErg,"§")
			Return FolderPath
        Loop, Parse, GooglErg , §
        {
            if (A_Index > 1)
            {
                ; MsgBox % A_LoopField
                TeilUrl:=SubStr(A_LoopField, 1, InStr(A_LoopField,Hochkomma)-1)
                ; MsgBox % TeilUrl
                UrlDownloadToFile, %TeilURL%, %A_Temp%\GoogleTemp\F%Index%I%A_Index%.htm
                    If Not Errorlevel
                        Gefunden:=Gefunden+1
                    If (Gefunden>=Maxfind)
                    {
                        ; listvars
                        ; MsgBox halt
                        Return FolderPath
                    }
			; MsgBox %A_Temp%\GoogleTemp\F%Index%I%A_Index%.htm
			; run %A_Temp%\GoogleTemp\F%Index%I%A_Index%.htm
            }
        }
    }
    run SucheDateien.ahk %A_Temp%\GoogleTemp
    return
}
; /*
WM_MOUSEMOVE()
{
    Global Fehlersuchmodus,ThisWinTitleMerker
    ; trayTip,,%a_now%
    If (Fehlersuchmodus="ja")
        {
        sleep 3000
        WinWaitClose,%ThisWinTitleMerker%-NoMouseOver,,6
        ; WinwaitClose,MouseOver-Hilfe
        }
    static CurrControl, PrevControl, _TT, CurrControlLaenge  ; _TT is kept blank for use by the ToolTip command below.
    CurrControl := A_GuiControl
    StringReplace, CurrControl, CurrControl,&,,All
    StringReplace, CurrControl, CurrControl,%A_Space%,,All
    StringReplace, CurrControl, CurrControl,-,,All
    StringReplace, CurrControl, CurrControl,(,,All
    StringReplace, CurrControl, CurrControl,),,All
    StringReplace, CurrControl, CurrControl,`n`r,,All
    StringReplace, CurrControl, CurrControl,`n,,All
    CurrControlLaenge:=StrLen(%CurrControl%_TT)
    ; traytip,CurrControl,%CurrControl%	%CurrControlLaenge%,2
    If (CurrControl <> PrevControl and not InStr(CurrControl, " "))
    {
        ; ToolTip  ; Turn off any previous tooltip.
        SetTimer, DisplayToolTip, 1000
        PrevControl := CurrControl
    }
    return

    DisplayToolTip:
    SetTimer, DisplayToolTip, Off
    TempCurrControl:=%CurrControl%_TT
    If InStr(%CurrControl%_TT, "|")
    {
    Label:= SubStr(%CurrControl%_TT, 1 , InStr(%CurrControl%_TT, "|"))
    ; msgbox % Label "	" InStr(%CurrControl%_TT, "|")
    StringTrimRight, Label, Label, 1
    ; traytip,Label,"%Label%",2
        If IsLabel(Label)	; eingeführt zur Aktualisierung der Anzahl der Dateien
        {
            GoSub %Label%
            StringReplace, %CurrControl%_TT, %CurrControl%_TT,%Label%|,
            PrevControl=
        }
    }
    ToolTip, % %CurrControl%_TT ,,,2 ; The leading percent sign tell it to use an expression.
    If (CurrControlLaenge<40)
        SetTimer, RemoveToolTip, 2000
    Else If (CurrControlLaenge<80)
        SetTimer, RemoveToolTip, 4000
    Else If (CurrControlLaenge<120)
        SetTimer, RemoveToolTip, 6000
    Else
        SetTimer, RemoveToolTip, 10000
    %CurrControl%_TT:=TempCurrControl
    return

    RemoveToolTip:
    SetTimer, RemoveToolTip, Off
    ToolTip,,,,2
    return
}
; */
FileAddListLoeschen()
{
	FileDelete,%A_temp%\FileAddList.lst
	Return errorlevel
}

DuplikateSuchen(Suchordner)
{
ToolTip,beschäftigt,4,4
Global LogParserPfad
LogParserAufrufPfad = %A_temp%\LogParserAufruf.bat
SqlStatementPfad = %A_temp%\SqlStatement.sql
CsvErgPfad = %A_temp%\Erg.csv
CsvErgAddPfad = %A_temp%\ErgAdd.csv
FileListPfad = %A_temp%\FileList.lst
FileAddListPfad = %A_temp%\FileAddList.lst
DoppeltePfad = %A_temp%\Doppelte.csv
FileDelete, %SqlStatementPfad% 
FileDelete, %LogParserAufrufPfad%
FileDelete, %CsvErgPfad%
FileDelete, %FileListPfad%
FileDelete, %DoppeltePfad%

Einleitung =
(
Die Eingabe des Ordners in dem Duplikate gesucht werden ist gerade geschehen,
anschließend geht eine DOS-Box auf 		schwarzes Fenster 
und erstellt von jeder enthaltenen Datei einen Hash-Code.
Dies kann lange dauern.
Nach dem Schließen der DOS-Box mit einer beliebigen Taste
werden die größensortierten Duplikate der Liste angefügt.
)
MsgBox ,,Einleitung,%Einleitung%,20
; MsgBox Suchordner=%Suchordner%
IfNotExist, %Suchordner%
	FileSelectFolder,Suchordner,*\\Sstr102f\estr_shr002\ESTR_G00113\10_Work,,Gib der Ordner ein in dem Duplikate vermutet werden.
if Suchordner =
	return 0

LogParserPfad = \\Sstr102f\estr_shr002\ESTR_G00113\80_Programme\10_NetzProgramme\LogParser2.2\LogParser.exe
IfNotExist, %LogParserPfad%
	{
	LogParserPfad = %A_AhkPath%\.\LogParser2.2\LogParser.exe
	IfNotExist, %LogParserPfad%
		{
			LogParserPfad = %A_ScriptDir%\SucheDateien\LogParser\LogParser.exe
			IfNotExist, %LogParserPfad%
				FileSelectFile, LogParserPfad , 1, %A_Programfiles%, Gesucht ist der LogParser, LogParser.exe (*.exe)]
		}
	}

LogParserAufruf=
(
"%LogParserPfad%" file:"%SqlStatementPfad%" -i:FS -recurse:-1 -o:tSV -fileMode:1 -oSeparator:"|"
)
; MsgBox %LogParserAufruf%
FileAppend ,%LogParserAufruf%,%LogParserAufrufPfad%

SqlStatement=
(
SELECT Name
 , Size
 , HASHMD5_FILE(Path) AS Hash
 , LastWriteTime
 , CreationTime
 , Path
INTO '%A_temp%\Erg.csv'
FROM '%Suchordner%\*.*'
ORDER BY Size, Hash, LastWriteTime DESC
)
; MsgBox %SqlStatement%

FileAppend , %SqlStatement%, %SqlStatementPfad%

RunWait, %LogParserAufrufPfad%
sleep, 500

FileList=

FileRead, CsvErg, %CsvErgPfad%
Loop, parse, CsvErg, `n, `r
	{
	if (A_Index=1)
		{
		Doppelte=%Doppelte%%A_LoopField%`n
		}
	MerkerletztDoppelt=nein
	LetzteZeile=%tempA%
	tempA=%A_LoopField%
	Loop, Parse, A_LoopField ,|
		{
		Last_A_LoopField%A_index%:=This_A_LoopField%A_index%
                This_A_LoopField%A_index%:=A_LoopField
		; MsgBox %A_LoopField%
		if (A_Index=3)
			{
			MerkerletztDoppelt=nein
			Letzt=%temp%
			temp=%A_LoopField%
			if (Letzt=A_LoopField)
				{
				
				if (Letzt<>"")
					{
					Doppelte=%Doppelte%%LetzteZeile%`n
					; MsgBox %Letzt% = %A_LoopField%
					MerkerletztDoppelt=ja
					}
				letztDoppelt=ja
				}
			else if (letztDoppelt="ja")
				{
				if (Letzt<>"")
					{
					Doppelte=%Doppelte%%LetzteZeile%`n
					letztDoppeltMerker=ja
					; MsgBox %Letzt% = %A_LoopField%
					MerkerletztDoppelt=ja
					}
				letztDoppelt=nein
				}
			else
				{
				letztDoppelt=nein
				MerkerletztDoppelt=nein
				}
			}
                ; This_A_LoopField%A_index%:=A_LoopField
		}
	SplitPath, Last_A_LoopField6 , LastFileName, LastDir, LastExtension
	ZeileFileList=%LastFileName%	%LastDir%	%LastSize%	%LastExtension%	%Last_A_LoopField2%
	ZeileFileList=%LastFileName%	%LastDir%	%Last_A_LoopField2%	%LastExtension%	%Last_A_LoopField3%
	; MsgBox % ZeileFileList	
	If(MerkerletztDoppelt="ja")
		{
		FileList=%FileList%%ZeileFileList%`n
	}
	FileAddList=%FileAddList%%ZeileFileList%`n

	}
StringLeft,FileAddListL1, FileAddList, 1
If(FileAddListL1="`r" OR FileAddListL1="`n")
	StringTrimLeft,FileAddList, FileAddList, 1
StringLeft,FileAddListL1, FileAddList, 1
If(FileAddListL1="`r" OR FileAddListL1="`n")
	StringTrimLeft,FileAddList, FileAddList, 1
StringReplace, FileAddList, FileAddList,Path		Size		Hash`n,,All
StringReplace, FileAddList, FileAddList,Path		Size		Hash,,All
StringReplace, FileAddList, FileAddList,`n`n,`n,All
StringReplace, FileAddList, FileAddList,`r`n`r`n,`r`n,All
StringReplace, FileAddList, FileAddList,`r`r,`r,All
StringRight,FileListR1, FileList, 1
If(FileListR1="`r" OR FileListR1="`n")
	StringTrimRight,FileList, FileList, 1
FileAppend , %FileList%, %FileListPfad%
FileAppend , %FileAddList%, %FileAddListPfad%
FileAppend , %Doppelte%, %DoppeltePfad%

; Run, %CsvErgPfad%

; Run, %DoppeltePfad%


; Run,%FileListPfad%
ToolTip
Return FileList


}

RelLink2AbsPath(RelLinkFilePath,LinkMustExist="")	; Kurz:	Eingang:	Ausgang: -	Beispiel: Steuer-Zeile:<br><code><b></b></code><br>
{
SplitPath, RelLinkFilePath, , RelLinkFileDir
; MsgBox RelLinkFilePath = %RelLinkFilePath%
FileGetShortcut, %RelLinkFilePath% , OutTarget, OutDir, OutArgs, OutDescription, OutIcon, OutIconNum, OutRunState
; MsgBox OutTarget = "%OutTarget%"
; MsgBox OutDescription = %OutDescription%
If (OutTarget="" AND OutDescription="")
	return 0
Hochkomma="
HrefPos:=InStr(OutDescription, "href=") 
; MsgBox HrefPos = %HrefPos%
If (HrefPos>0)
	{
	RelLinkPos:=HrefPos+6
	RelLinkPosEnd:=InStr(OutDescription, Hochkomma,"false",RelLinkPos)
	RelLinkPath:=SubStr(OutDescription, RelLinkPos , RelLinkPosEnd-RelLinkPos)
	RelLinkLinks21:=SubStr(RelLinkPath, 2,1)
	RelLinkLinks12:=SubStr(RelLinkPath, 1,2)
	If (RelLinkLinks21=":" OR RelLinkLinks12="\\")
		{				; This Path Is Abs.
		If (LinkMustExist="ja")
			{
			IfExist %RelLinkPath%
				return RelLinkPath
			Else
				return 0
			}
		Else
				return RelLinkPath
		}
	}
Else
	{
	If (LinkMustExist="ja")
		{
		IfExist %OutTarget%
			return OutTarget
		Else
			return 0
		}
	}
; MsgBox RelLinkPath = %RelLinkPath%

RelLinkFilePathBeginn=
Loop
	{
	If (InStr(RelLinkFileDir,"\","false", 1) = 1)
		{
		StringTrimLeft, RelLinkFileDir,RelLinkFileDir,1
		RelLinkFilePathBeginn=%RelLinkFilePathBeginn%\
		}
	Else
		break
	}

StringSplit, RelLinkFileDirArray, RelLinkFileDir, \

; SplitPath, RelLinkPath, , RelLinkDir
StringSplit, RelLinkDirArray, RelLinkPath, \

RelLinkDirArrayStart:=1
Loop
	{
	If (RelLinkDirArray%A_Index%="..")
		{
		--RelLinkFileDirArray0
		++RelLinkDirArrayStart
		}
	Else
		break
	}
Rueck=%RelLinkFilePathBeginn%
Loop % RelLinkFileDirArray0
	{						; Pfad links setzen
	Rueck:=Rueck RelLinkFileDirArray%A_Index% "\"
	}
Loop
	{						; Pfad rechts setzen
	Rueck:=Rueck RelLinkDirArray%RelLinkDirArrayStart% "\"
	++RelLinkDirArrayStart
	If(RelLinkDirArray0 < RelLinkDirArrayStart)
		break
	}
StringRight, RueckR1, Rueck, 1
If (RueckR1="\")
	StringTrimRight, Rueck, Rueck, 1
If (LinkMustExist="ja")
	{
	IfNotExist %rueck%
		{
		IfExist %OutTarget%
			return OutTarget
		Else
			return 0
		}
	Else
		return rueck
	}
; MsgBox % Rueck
return rueck
}



PfadAbs2Rel(AbsStandortPfad,AbsZielPfad,AbsStandortPfadIstDatei="true")	; Kurz:	Eingang: Absoluter-Pfad	Ausgang: Relativer-Pfad	Beispiel: Steuer-Zeile:<br><code><b></b></code><br>
{	;   Ordner          Datei oder Ordner
; MsgBox %AbsStandortPfad%	%AbsZielPfad%
AbsStandortPfadL=
Loop
    {
    StringLeft, AbsStandortPfadL1, AbsStandortPfad, 1
    If (AbsStandortPfadL1="\")
        {
        AbsStandortPfadL=%AbsStandortPfadL%\
        StringTrimLeft, AbsStandortPfad, AbsStandortPfad, 1
        }
    Else
        break	; Schleife verlassen
    }
AbsZielPfadL=
Loop
    {
    StringLeft, AbsZielPfadL1, AbsZielPfad, 1
    If (AbsZielPfadL1="\")
        {
        AbsZielPfadL=%AbsZielPfadL%\
        StringTrimLeft, AbsZielPfad, AbsZielPfad, 1
        }
    Else
        break	; Schleife verlassen
    }
StringReplace, AbsStandortPfad, AbsStandortPfad,\\,\,All
StringReplace, AbsStandortPfad, AbsStandortPfad,\.\,\,All
StringReplace, AbsZielPfad, AbsZielPfad,\\,\,All
StringReplace, AbsZielPfad, AbsZielPfad,\.\,\,All
; MsgBox %AbsStandortPfad%	%AbsZielPfad%
StringSplit, AbsStandortPfadArray, AbsStandortPfad,\
If (AbsStandortPfadIstDatei="True")
    --AbsStandortPfadArray0
StringSplit, AbsZielPfadArray, AbsZielPfad,\

Loop % AbsStandortPfadArray0
    {				; . und .. entfernen
    If (AbsStandortPfadArray%A_Index%="..")	; \\serverA\1\2\a\..\c
        {					;      1    2 3 4 5  6
        Out1A_IndexMinus1:=A_Index-1
        AbsStandortPfadArray%Out1A_IndexMinus1%=.
        AbsStandortPfadArray%A_Index%=.
        }
    }
Loop % AbsStandortPfadArray0
    {				; . und .. entfernen
    ; MsgBox % ".. weg 	" AbsStandortPfadArray%A_Index%
    If (AbsStandortPfadArray%A_Index%=".")	; \\serverA\1\2\a\.\c
        {					;      1    2 3 4 5 6
        Out1A_Index:=A_Index
        Index:=A_Index
        ; MsgBox Out1A_Index="%Out1A_Index%"
        Loop
            {
            ++Index
            If (Index > AbsStandortPfadArray0)
                break
            If (AbsStandortPfadArray%Index%<>".")
                {
                AbsStandortPfadArray%Out1A_Index%:=AbsStandortPfadArray%Index%
                AbsStandortPfadArray%Index%=.
                ; listvars
                ; MsgBox % "AbsStandortPfadArray" Index " = " AbsStandortPfadArray%Index%
                If(Index=AbsStandortPfadArray0)
                    --AbsStandortPfadArray0
                break
                }
            Else
                {
                ; --AbsStandortPfadArray0
                sleep 1
                ; break
                }
            }
        }
    If (A_Index>AbsStandortPfadArray0)
        break
    }
Zindex:=AbsStandortPfadArray0
Loop % AbsStandortPfadArray0
    {
    IF (AbsStandortPfadArray%Zindex%=".")
        --AbsStandortPfadArray0
    Else
        break
    ; MsgBox % AbsStandortPfadArray%ZIndex%

    --Zindex
    }
Loop % AbsZielPfadArray0
    {				; . und .. entfernen
    If (AbsZielPfadArray%A_Index%="..")	; \\serverA\1\2\a\..\c
        {					;      1    2 3 4 5  6
        Out1A_IndexMinus1:=A_Index-1
        AbsZielPfadArray%Out1A_IndexMinus1%=.
        AbsZielPfadArray%A_Index%=.
        }
    }
Loop % AbsZielPfadArray0
    {				; . und .. entfernen
    ; MsgBox % ".. weg 	" AbsZielPfadArray%A_Index%
    If (AbsZielPfadArray%A_Index%=".")	; \\serverA\1\2\a\.\c
        {					;      1    2 3 4 5 6
        Out1A_Index:=A_Index
        Index:=A_Index
        ; MsgBox Out1A_Index="%Out1A_Index%"
        Loop
            {
            ++Index
            If (Index > AbsZielPfadArray0)
                break
            If (AbsZielPfadArray%Index%<>".")
                {
                AbsZielPfadArray%Out1A_Index%:=AbsZielPfadArray%Index%
                AbsZielPfadArray%Index%=.
                ; listvars
                ; MsgBox % "AbsZielPfadArray" Index " = " AbsZielPfadArray%Index%
                If(Index=AbsZielPfadArray0)
                    --AbsZielPfadArray0
                break
                }
            Else
                {
                ; --AbsZielPfadArray0
                sleep 1
                ; break
                }
            }
        }
    If (A_Index>AbsZielPfadArray0)
        break
    }
Zindex:=AbsZielPfadArray0
Loop % AbsZielPfadArray0
    {
    IF (AbsZielPfadArray%Zindex%=".")
        --AbsZielPfadArray0
    Else
        break
    ; MsgBox % AbsZielPfadArray%ZIndex%

    --Zindex
    }

If (AbsStandortPfadArray0 < AbsZielPfadArray0)
    Anz:=AbsStandortPfadArray0
Else
    Anz:=AbsZielPfadArray0
Loop % Anz
    {
    LastSame:=Anz
    If (AbsStandortPfadArray%A_Index% <> AbsZielPfadArray%A_Index%)
        {
        If (A_Index=1)
            Return AbsZielPfadL . AbsZielPfad	; keine gemeinsame Wurzel, Rueck -> AbsPfad
        Else
            {
            LastSame:=A_Index-1
            break		; Schleife verlassen
            }
        }
    }

; MsgBox LastSame = %LastSame%
Hoch=
Loop % AbsStandortPfadArray0 - LastSame
    {
    Hoch=%Hoch%\..
    }
Rein=
Index:=AbsZielPfadArray0
; MsgBox AbsZielPfadArray0 - LastSame	%AbsZielPfadArray0% - %LastSame%
Loop % AbsZielPfadArray0 - LastSame
    {
    Rein:= "\" AbsZielPfadArray%Index% Rein
    --Index
    }
RelPfad=%Hoch%%Rein%
StringLeft, RelPfadL1, RelPfad, 1
If (RelPfadL1="\")
    StringTrimLeft,RelPfad, RelPfad, 1
Else If (RelPfad="")
    RelPfad=.
Return RelPfad
}

; MsgBox % AbfrageFenster("Alter?","",">>>>>>>>>>          1-          "," 2- ","3-","4-","5-","6-","7-","8-",">>>>>>>>>>>>>>>>>>`n      OK      `n ")
; MsgBox % AbfrageFenster("Pause","",">>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>OK")
; MsgBox % AbfrageFenster("Hinweis","ReadOnly|Das Skript geht weiter`nzweite Hinweiszeile`nzweite Hinweiszeile 1233444 566666  7777 888888 89999 9999 gjhgkjgk gjk jkgkj gkjgj kjg kjhkj kjkjgkg k kgk ",">>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>          OK          ")
; MsgBox % AbfrageFenster("Alter?","","1-","2-","3-","4-","5-","6-","7-","8-","9 Jahre Alt")
; MsgBox % AbfrageFenster("Name Alter?","mit dem Vorname`nName überschreiben","1-","2-","3-","4-","5-","6-","7-","8-","9 Jahre Alt")
; MsgBox % AbfrageFenster("Adresse?","mit der Adresse überschreiben`n`n`n`n`n`n","OK")
; MsgBox % AbfrageFenster("Adresse?","mit der Adresse überschreiben`n`n`n`n`n`n`r","OK")
; ExitApp

AbfrageFenster(FensterTitel,Frage,ButtonText1="",ButtonText2="",ButtonText3="",ButtonText4="",ButtonText5="",ButtonText6="",ButtonText7="",ButtonText8="",ButtonText9="")
{
static 					; alle
Frage4711:=Frage
; MsgBox AbfrageFenster: Frage4711 = "%Frage4711%"
AbfrageFensterErg:=0
ReadOnly=
If(SubStr(Frage4711, 1, 9) ="ReadOnly|")
	{
	ReadOnly=ReadOnly
	StringTrimLeft, Frage4711, Frage4711, 9
	}
StringSplit, Frage4711Array, Frage4711, `n, `r
Loop
{
	IF(SubStr(Frage4711, 0,1)="`n")
		StringTrimRight, Frage4711, Frage4711, 1
	Else
		Break
}
If(FensterTitel="")
	FensterTitel="Untitled"
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
		IF(ButtonText4711%A_Index%="OK")
			Default=Default
		Else
			Default=
		}
	Else
	{
		ButtonText47110:=A_Index - 1
		Break
	}
	}
; Gui, 4:+owner1  ; Make the main window (Gui #1) the owner of the "about box" (Gui #2).
; Gui +Disabled  ; Disable main window.
Gui, 4:+Resize  ; Make the window resizable.
loop % ButtonText47110
{
	ThisButtonText:=ButtonText4711%A_Index%
	ThisNeachRechts:=NeachRechts%A_Index%*4
	; ThisButtonGoto:=gButton%A_Index%
	If(A_Index=1 And NeachRechts%A_Index%>1)
		Gui, 4:Add, Button, x%ThisNeachRechts%  gButton%A_Index% %Default%, %ThisButtonText%	
	Else If(A_Index=1)
		Gui, 4:Add, Button,   gButton%A_Index% %Default%, %ThisButtonText%
	Else
		Gui, 4:Add, Button, x+%ThisNeachRechts%  gButton%A_Index% %Default%, %ThisButtonText%
		
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
	Gui, 4:Add, Edit, vFrage4711 %ReadOnly% X1 W%EditBreite%  R%Frage4711Array0%	; "WantTab" hätte Tabulatoren im Text zugelassen.
	}
Gui, 4:Show,, %FensterTitel%
If(Frage4711<>"")
	GuiControl,4:, Frage4711, %Frage4711%  ; Put the text into the control.
; sleep 10000	; Zeit für die Eingabe
Goto NachRet


4GuiSize:
if ErrorLevel = 1  ; The window has been minimized.  No action needed.
    return
; Otherwise, the window has been resized or maximized. Resize the Edit control to match.
NewWidth := A_GuiWidth - 2
ControlGetPos , Edit1X, Edit1Y, Edit1Width, Edit1Height, Edit1, %FensterTitel%
SysGet, TitleBarHeight, 31, SM_CYSIZE
; msgbox % TitleBarHeight
NewHeight := A_GuiHeight - Edit1Y + TitleBarHeight +4
; TrayTip,FensterGröße, % NewWidth "	" NewHeight,5
GuiControl, Move, Edit1, W%NewWidth%  H%NewHeight%
; GuiControl, Focus, Edit1  
return


Button9:
++AbfrageFensterErg
Button8:
++AbfrageFensterErg
Button7:
++AbfrageFensterErg
Button6:
++AbfrageFensterErg
Button5:
++AbfrageFensterErg
Button4:
++AbfrageFensterErg
Button3:
++AbfrageFensterErg
Button2:
++AbfrageFensterErg
Button1:
++AbfrageFensterErg
Gui, Submit
; MsgBox %Frage4711%
AbfrageFensterErg=%AbfrageFensterErg%%Frage4711%
4GuiClose:  ; User closed the window.
Gui, Destroy
; ExitApp
Gui -Disabled  ; Enable main window.
return AbfrageFensterErg
NachRet:
WinWaitClose, %FensterTitel%
; AbfrageFensterErg=%AbfrageFensterErg%%Frage4711%
Gui -Disabled  ; Enable main window.
return AbfrageFensterErg

}
VlcPfadAbfragen:
VlcPfad = %A_ProgramFiles%\VideoLAN\VLC\vlc.exe	; Für vlc.exe auf standart Installationspfad.
IfNotExist, %VlcPfad%
	{
	VlcPfad = D:\10_NetzProgramme\VLCPortable\VLCPortable.exe
	IfNotExist, %VlcPfad%
		{
		VlcPfad = \\Sstr102f\estr_shr002\ESTR_G00113\80_Programme\10_NetzProgramme\VLC\vlc.exe	; Beispiel für vlc.exe auf Netzlaufwerk.
		IfNotExist,  %VlcPfad%
			FileSelectFile, VlcPfad, 1, %A_ProgramFiles%, FilmProgramm (z.B. vlc.exe),*.exe	; vlc.exe von Hand suchen lassen.
		}
	}
IfNotExist, %VlcPfad%
	VlCVerwenden=nein
Return

ButtonBefehle:
ThisBefehl:=AbfrageFenster("Befehl","Welcher Befehl soll ausgefuehrt werden","Multimedia`nshow","Multimedia`nÜbersicht","Doppelte","Key-Reset",">>>>>>>>>>>>>>>>>>>>MouseOver-Hilfe`nein aus","Compiliere`ndieses Skript","Starte neuste Version`ndieses Skriptes","Reload`nSkript","hart`nbeenden")
ThisBefehl:=SubStr(ThisBefehl, 1,1) 
ThisBefehl1=WindowsYnachKey
ThisBefehl2=WindowsYnachKey
ThisBefehl3=DoppelteBearbeiten
ThisBefehl4=KeyReset
ThisBefehl5=FehlersuchmodusEinAus
ThisBefehl6=CompileSucheDateien
ThisBefehl7=StartNewestVersion
ThisBefehl8=Reload
ThisBefehl9=ExitApp
RueckWert=
If (ThisBefehl=1)
	key=m
If (ThisBefehl=2)
	key=ü

If (IsLabel(ThisBefehl%ThisBefehl%))
	Gosub % ThisBefehl%ThisBefehl%
Return

KeyReset:
DelKey1=%EigeneDateien%\SucheDateien\Key-*
DelKey2=%A_ScriptDir%\SucheDateien\Key-*
FileDelete,%DelKey1%
FileDelete,%DelKey2%
Return

DoppeltenHilfe:
ShowHtmVar(HtmlHilfe3)
return

DoppelteBearbeiten:
ExitDoppelte=nein
Loop
{
ThisBefehl:=AbfrageFenster("Doppelte","Welcher Befehl soll ausgefuehrt werden?          (Buttons von links nach rechts benutzen!)","DoppeltenHilfe","Beginn Doppelte ordnerübergreifend","Load a Folder","Hash Refresh","End Doppelte ordnerübergreifend","EinzelDateien aus`nHash-Liste entfernen","Doppelte (hash)`ndurch Links ersetzen","zeige Unterschiede","Exit Doppelte")
ThisBefehl:=SubStr(ThisBefehl, 1,1) 
ThisBefehl1=DoppeltenHilfe
ThisBefehl2=BeginnDoppelteOrdneruebergreifend
ThisBefehl3=ButtonLoadFolder
If (ThisBefehl=3)
    {
    LastDefaultFolder:=":"		; Sicherer machen
    }
ThisBefehl4=TimeToHash
ThisBefehl5=EndDoppelteOrdneruebergreifend
ThisBefehl6=AutoSelectDoppelte
ThisBefehl7=DoppelteDurchLinksErsetzen
ThisBefehl8=ZeigeUnterschiede
ThisBefehl9=ExitDoppelte
RueckWert=
If (IsLabel(ThisBefehl%ThisBefehl%))
	Gosub % ThisBefehl%ThisBefehl%
DuplikateSuchen=nein
If(ExitDoppelte="ja")
	break
}
Return
ExitDoppelte:
ExitDoppelte=ja
return


Reload:
Reload
Goto GuiClose
return

BeginnDoppelteOrdneruebergreifend:
IfNotExist FileAddListPfad
	FileAddListPfad = %A_temp%\FileAddList.lst
FileDelete,%FileAddListPfad%
IfNotExist FolderAddListPfad
	FolderAddListPfad = %A_temp%\FolderAddList.lst
FileDelete,%FolderAddListPfad%
MsgBox %FileAddListPfad%`n%FolderAddListPfad%`n wurden zurückgesetzt!
return

EndDoppelteOrdneruebergreifend:
Gosub ButtonClearNachSubmit
sleep 5000
Ue1=%FileAddListPfad%
DuplikateSuchen=nein		; hier soll ja nur eine normale Liste geladen werden
Gosub BefehlsDateiVerarbeiten
return

ZeigeUnterschiede:		; mehrerer Ordner
ToolTip,beschäftigt,4,4
Gosub GetFolderAddList
Gosub ButtonClearNachSubmit
SelectedFile=%A_temp%\FileAddList.lst
DuplikateSuchen=Nein
Gosub ButtonOpenNachFileSelect
LV_ModifyCol(1, "SortDesc")
LV_ModifyCol(5, "SortDesc")
LV_ModifyCol(3, "SortDesc")
AnzListenZeilen:=LV_GetCount()
Loop % AnzListenZeilen
	{
	RowNumber:=A_Index
	Loop 5			; über alle Spalten
		{
		LV_GetText(Spalte%RowNumber%%A_Index%, RowNumber, A_Index) ; Get the text of the field.
		If(A_Index=2)
			{
			ThisFolder:=Spalte%RowNumber%2
			Loop % FolderAddList0
				{
				ThisLoadFolder:=FolderAddList%A_Index%
				StringReplace, ThisFolder, ThisFolder, %ThisLoadFolder%	
				}
			Spalte%RowNumber%2:=ThisFolder
			}
		}
	}
Loop % AnzListenZeilen
	{
	GleichZaehler:=0
	RowNumber := AnzListenZeilen-A_Index+1
	Loop % AnzListenZeilen-A_Index+1				; über gleiche Dateilängen
		{
		RowNumberBezug := RowNumber-A_Index +1
		
		; MsgBox  RowNumber = %RowNumber%	RowNumberBezug = %RowNumberBezug%

		; Msgbox RowNumberBezug = %RowNumberBezug%
		If(RowNumberBezug<>RowNumber)	
			{
			If(Spalte%RowNumberBezug%1=Spalte%RowNumber%1)
				{
				If(Spalte%RowNumberBezug%3=Spalte%RowNumber%3)
					{
					If(Spalte%RowNumberBezug%4=Spalte%RowNumber%4)
						{
						If(Spalte%RowNumberBezug%5=Spalte%RowNumber%5)
							{
							If(Spalte%RowNumberBezug%2=Spalte%RowNumber%2)
								{
								If(GleichZaehler="0")
									{
									; LV_Modify(RowNumber, "Select")  ; select
									SelectRowNumber1:=RowNumber
									; LV_Modify(RowNumberBezug, "Select")  ; select
									SelectRowNumber2:=RowNumberBezug
									GleichZaehler:=2
									; Pause
									}
								Else
									{
									++GleichZaehler
									SelectRowNumber%GleichZaehler%:=RowNumberBezug

									}
								If(GleichZaehler>=FolderAddList0)
									{
									Loop % FolderAddList0
										{
										LV_Modify(SelectRowNumber%A_Index%, "Select")  ; select
										}
										GleicheGefunden=Ja

									}
								}
							}
						}
					}
				}
			}

		; MsgBox % Spalte%RowNumberBezug%3 " <> " Spalte%RowNumber%3
		If(Spalte%RowNumberBezug%3<>Spalte%RowNumber%3 OR GleicheGefunden="Ja")
			{
			; MsgBox %FolderAddList0% Gleiche gefunden = %GleicheGefunden%
			GleicheGefunden=Nein
			Break
			}
		}
	}
ToolTip,
; Listlines
; Pause
Gosub ContextClearRows
Return

GetFolderAddList:
FolderAddList0=0
FileRead, FolderAddList, %A_temp%\FolderAddList.lst
Loop, parse, FolderAddList, `n, `r  ; Specifying `n prior to `r allows both Windows and Unix files to be parsed.
	{
    	FolderAddList%A_Index%=%A_LoopField%
    	++FolderAddList0
	}
	--FolderAddList0
Return

FehlersuchmodusEinAus:
If (Fehlersuchmodus<>"ja")
    {
    sleep 2000
    Fehlersuchmodus=ja
    WinGetTitle, ThisWinTitle , A
    ThisWinTitleMerker:=ThisWinTitle
    WinSetTitle, %ThisWinTitle%, , %ThisWinTitle%-NoMouseOver
    ; MsgBox % ThisWinTitleMerker  ThisWinTitle
    }
Else
    {
    Fehlersuchmodus=nein
    WinSetTitle, %ThisWinTitleMerker%, , %ThisWinTitle%
    }
TrayTip,SucheDateien,Fehlersuchmodus=%Fehlersuchmodus%
return

CompileSucheDateien:
If (A_IsCompiled)
{
    MsgBox Diese Funktion wird nur Unterstützt, `nwenn SucheDateien als "ahk" gestartet wurde.
    return
}
ImmerAktuellesScript=%A_ScriptDir%\SucheDateien.ahk
NetzProgramme=%A_ScriptDir%\..\..
CompilatDir=%NetzProgramme%\010_NetzDesk\Speicher
IfExist %CompilatDir%
    CompilatPfad=%CompilatDir%\SucheDateien.exe
Else
    CompilatPfad=%A_ScriptDir%\SucheDateien.exe
IfExist %A_AhkPath%
    {
    SplitPath, A_AhkPath,,AhkDir
    CompilerPfad=%AhkDir%\Compiler\Ahk2Exe.exe
    ; MsgBox % CompilerPfad
    IconPfad=%A_ScriptDir%\ExploreWClass.ico
    IfExist %CompilerPfad%
        CompilerAufruf=%CompilerPfad% /in %ImmerAktuellesScript% /out %CompilatPfad% /icon %IconPfad%
    Else
        {
        MsgBox Kann Compiler nicht unter "%CompilerPfad%" finden.
        return
        }
    }
; MsgBox % CompilerAufruf
IfExist %CompilerPfad%
    RunWait %CompilerAufruf% 
IfExist %CompilatPfad%
    {
    sleep 3000	; Zeit lassen zum Komprimieren!
    MsgBox, 4, ,starte Compilat `nund beende ahk?
    IfMsgBox Yes
        {
        Run %CompilatPfad%
        Goto GuiClose
        }
    }
return


Warte:
WarteVomScriptSec:=WarteVomScript/1000
Input, UserInput,T%WarteVomScriptSec% L1, {Esc}{LControl}{RControl}{LAlt}{RAlt}{LWin}{RWin}{AppsKey}{F1}{F2}{F3}{F4}{F5}{F6}{F7}{F8}{F9}{F10}{F11}{F12}{Left}{Right}{Up}{Down}{Home}{End}{PgUp}{PgDn}{Del}{Ins}{BS}{Capslock}{Numlock}{PrintScreen}{Pause} 
RueckWert2:=ErrorLevel
; ToolTip,"%Rueckwert2%"	"%UserInput%"
if Rueckwert2 = Max
	{
	If (UserInput=" ")
		Input, UserInput, L1
	}
Else if (Rueckwert2 = "EndKey:Escape")
	Exit
Else if Rueckwert2 = Timeout
	Return
Return

GetMonitorWorkArea:
SysGet, MonitorCount, MonitorCount
; MsgBox %MonitorCount% angeschlossene Monitore erkannt.
Loop, %MonitorCount%
	{
	SysGet, Mon%A_Index%, MonitorWorkArea, %A_Index%
	Mon%A_Index%Width:=Abs(Mon%A_Index%Right-Mon%A_Index%Left)
	Mon%A_Index%Height:=Abs(Mon%A_Index%Top-Mon%A_Index%Bottom)
	; MsgBox % "Monitor(" A_Index "):`n" Mon%A_Index%Left " , " Mon%A_Index%Top "	" Mon%A_Index%Right   " , " Mon%A_Index%Bottom "`n" Mon%A_Index%Width "	" Mon%A_Index%Height
	}
Return

StartNewestVersion:
MaxModificationTime:=0
If (A_IsCompiled)
    ThisTyp=exe
Else
    ThisTyp=ahk
Loop, %A_ScriptDir%\SucheDateien*.%ThisTyp%,0, 0 
{
    FileGetTime, ThisModificationTime , %A_LoopFileFullPath%, M
    If (MaxModificationTime < ThisModificationTime)
        {
        NewestVersion = %A_LoopFileFullPath%
        MaxModificationTime:=ThisModificationTime
        }
    ; msgbox % A_LoopFileFullPath "	" MaxModificationTime "	" ThisModificationTime
}
Run %NewestVersion%
Goto GuiClose
ExitApp:
ExitApp

FunktionsaufrufErzeugenUndAufrufen:
HK="
; MsgBox AktLabel = "%AktLabel%"
AktLabel:=FunktionsAufrufTextfreiMachen(AktLabel)
; MsgBox AktLabel = "%AktLabel%"

PosZuweisungsOperator:=InStr(AktLabel,":=")
; MsgBox PosZuweisungsOperator = "%PosZuweisungsOperator%"
PosLetztesZeichenFuncZuweisungsVarName:=PosZuweisungsOperator-1
IF PosZuweisungsOperator
	{
	StringLeft, FuncZuweisungsVarName, AktLabel, %PosLetztesZeichenFuncZuweisungsVarName%
	PosErstesZeichenFuncName:=PosZuweisungsOperator + 2
	; MsgBox FuncZuweisungsVarName = "%FuncZuweisungsVarName%"
	}
Else
	PosErstesZeichenFuncName:=1
FuncNameLaenge:=InStr(AktLabel,"(") - PosErstesZeichenFuncName
FuncName := SubStr(AktLabel, PosErstesZeichenFuncName, FuncNameLaenge) 
; MsgBox FuncName = "%FuncName%"


PosErstesZeichenFuncKlammerInhalt:=InStr(AktLabel,"(")+1
PosLetstesZeichenFuncKlammerInhalt:=InStr(AktLabel,")")
FuncKlammerInhaltLaenge:=PosLetstesZeichenFuncKlammerInhalt - PosErstesZeichenFuncKlammerInhalt
FuncKlammerInhalt := SubStr(AktLabel, PosErstesZeichenFuncKlammerInhalt, FuncKlammerInhaltLaenge)
; MsgBox FuncKlammerInhalt = "%FuncKlammerInhalt%"

StringSplit, FuncUebergabeVarName, FuncKlammerInhalt,`,

loop,%FuncUebergabeVarName0%
	{
	; MsgBox % FuncUebergabeVarName%A_Index%
	If(InStr(FuncUebergabeVarName%A_Index%,HK) = 1)
		{
		MsgBox % "Die Funktionsübergabe " FuncUebergabeVarName%A_Index% "ist nicht erlaubt.`nTextÜbergabe wird nicht Unterstützt."
		Goto EndeFunktionsaufrufErzeugenUndAufrufen
		; TempString:=FuncUebergabeVarName%A_Index%
		; StringTrimLeft, TempString, %TempString%, 1
		; StringTrimRight, TempString, %TempString%, 1
		; FuncUebergabeVarName%A_Index%:=TempString		; wenn nur Text übergeben wird
		; HochKomma%A_Index%="
		; FuncUebergabeText%A_Index%=Ja
		}
	; Else
		; {
		; HochKomma%A_Index%=
		; FuncUebergabeText%A_Index%=Nein
		; }
	}

If (FuncUebergabeVarName0=0)
	{
	IF PosZuweisungsOperator
		{
		if IsFunc(FuncName)
			%FuncZuweisungsVarName%:=%FuncName%()
		Else
			%FuncZuweisungsVarName%:=AktobjektUnveraedertUnterprogAufruf(FuncName)
		}
	Else
		{
		if IsFunc(FuncName)
			%FuncName%()
		Else
			AktobjektUnveraedertUnterprogAufruf(FuncName)
		}
	}

If (FuncUebergabeVarName0=1)
	{
	IF PosZuweisungsOperator
		{
		if IsFunc(FuncName)
			%FuncZuweisungsVarName%:=%FuncName%(%FuncUebergabeVarName1%)
		Else
			MsgBox % "Die Funktion " FuncName "(" FuncUebergabeVarName1 ") existiert nicht"
		}
	Else
		{
		if IsFunc(FuncName)
			%FuncName%(%FuncUebergabeVarName1%)
		Else
			MsgBox % "Die Funktion " FuncName "(" FuncUebergabeVarName1 ") existiert nicht"
		}
	}

If (FuncUebergabeVarName0=2)
	{
	IF PosZuweisungsOperator
		{
		if IsFunc(FuncName)
			%FuncZuweisungsVarName%:=%FuncName%(%FuncUebergabeVarName1% , %FuncUebergabeVarName2%)
		Else
			MsgBox % "Die Funktion " FuncName "(" FuncUebergabeVarName1 "," FuncUebergabeVarName2 ") existiert nicht"
		}
	Else
		{
		if IsFunc(FuncName)
			%FuncName%(%FuncUebergabeVarName1% , %FuncUebergabeVarName2%)
		Else
			MsgBox % "Die Funktion " FuncName "(" FuncUebergabeVarName1 "," FuncUebergabeVarName2 ") existiert nicht"
		}
	}

If (FuncUebergabeVarName0=3)
	{
	IF PosZuweisungsOperator
		{
		if IsFunc(FuncName)
			%FuncZuweisungsVarName%:=%FuncName%(%FuncUebergabeVarName1% , %FuncUebergabeVarName2% , %FuncUebergabeVarName3%)
		Else
			MsgBox % "Die Funktion " FuncName "(" FuncUebergabeVarName1 "," FuncUebergabeVarName2 "," FuncUebergabeVarName3 ") existiert nicht"
		}
	Else
		{
		if IsFunc(FuncName)
			%FuncName%(%FuncUebergabeVarName1% , %FuncUebergabeVarName2% , %FuncUebergabeVarName3%)
		Else
			MsgBox % "Die Funktion " FuncName "(" FuncUebergabeVarName1 "," FuncUebergabeVarName2 "," FuncUebergabeVarName3 ") existiert nicht"
		}
	}

If (FuncUebergabeVarName0=4)
	{
	IF PosZuweisungsOperator
		{
		if IsFunc(FuncName)
			%FuncZuweisungsVarName%:=%FuncName%(%FuncUebergabeVarName1% , %FuncUebergabeVarName2% , %FuncUebergabeVarName3% , %FuncUebergabeVarName4%)
		Else
			MsgBox % "Die Funktion " FuncName "(" FuncUebergabeVarName1 "," FuncUebergabeVarName2 "," FuncUebergabeVarName3 "," FuncUebergabeVarName4 ") existiert nicht"
		}
	Else
		{
		if IsFunc(FuncName)
			%FuncName%(%FuncUebergabeVarName1% , %FuncUebergabeVarName2% , %FuncUebergabeVarName3% , %FuncUebergabeVarName4%)
		Else
			MsgBox % "Die Funktion " FuncName "(" FuncUebergabeVarName1 "," FuncUebergabeVarName2 "," FuncUebergabeVarName3 "," FuncUebergabeVarName4 ") existiert nicht"
		}
	}
If (FuncUebergabeVarName0=5)
	{
	IF PosZuweisungsOperator
		{
		if IsFunc(FuncName)
			%FuncZuweisungsVarName%:=%FuncName%(%FuncUebergabeVarName1% , %FuncUebergabeVarName2% , %FuncUebergabeVarName3% , %FuncUebergabeVarName4%, %FuncUebergabeVarName5%)
		Else
			MsgBox % "Die Funktion " FuncName "(" FuncUebergabeVarName1 "," FuncUebergabeVarName2 "," FuncUebergabeVarName3 "," FuncUebergabeVarName4 "," FuncUebergabeVarName5 ") existiert nicht"
		}
	Else
		{
		if IsFunc(FuncName)
			%FuncName%(%FuncUebergabeVarName1% , %FuncUebergabeVarName2% , %FuncUebergabeVarName3% , %FuncUebergabeVarName4%, %FuncUebergabeVarName5%)
		Else
			MsgBox % "Die Funktion " FuncName "(" FuncUebergabeVarName1 "," FuncUebergabeVarName2 "," FuncUebergabeVarName3 "," FuncUebergabeVarName4 "," FuncUebergabeVarName5 ") existiert nicht"
		}
	}

If (FuncUebergabeVarName0=6)
	{
	IF PosZuweisungsOperator
		{
		if IsFunc(FuncName)
			%FuncZuweisungsVarName%:=%FuncName%(%FuncUebergabeVarName1% , %FuncUebergabeVarName2% , %FuncUebergabeVarName3% , %FuncUebergabeVarName4%, %FuncUebergabeVarName5%, %FuncUebergabeVarName6%)
		Else
			MsgBox % "Die Funktion " FuncName "(" FuncUebergabeVarName1 "," FuncUebergabeVarName2 "," FuncUebergabeVarName3 "," FuncUebergabeVarName4 "," FuncUebergabeVarName5 "," FuncUebergabeVarName6 ") existiert nicht"
		}
	Else
		{
		if IsFunc(FuncName)
			%FuncName%(%FuncUebergabeVarName1% , %FuncUebergabeVarName2% , %FuncUebergabeVarName3% , %FuncUebergabeVarName4%, %FuncUebergabeVarName5%, %FuncUebergabeVarName6%)
		Else
			MsgBox % "Die Funktion " FuncName "(" FuncUebergabeVarName1 "," FuncUebergabeVarName2 "," FuncUebergabeVarName3 "," FuncUebergabeVarName4 "," FuncUebergabeVarName5 "," FuncUebergabeVarName6 ") existiert nicht"
		}
	}

If (FuncUebergabeVarName0>6)
	MsgBox so viele (%FuncUebergabeVarName0%) Funktionsübergabe-Variablen werden momentan nicht unterstützt.`nDie Unterstützung lässt sich leicht in Unterprogramm FunktionsaufrufErzeugenUndAufrufen nachrüsten.





EndeFunktionsaufrufErzeugenUndAufrufen:
return

; MsgBox % HashMd5("\\192.168.178.4\z\10_NetzProgramme\AdHoc\AdHoc.ahk")
; MsgBox % HashMd5("\\192.168.178.4\z\10_NetzProgramme\AdHoc\A*.ahk","Nein")
; MsgBox % HashMd5("\\192.168.178.4\z\10_NetzProgramme\AdHoc\*re.ahk","-r","Nein")
; MsgBox % HashMd5("\\192.168.178.4\z\10_NetzProgramme\AdHoc\*.*","-r","Nein")
HashMd5(Datei,Option="",Only1Hash="")
{
Global HashMd5Path
RunWait, %comspec% /c ""%HashMd5Path%" %Option% "%Datei%" >"%A_Temp%ThisHash.txt"",,Hide
; RunWait %comspec% /c dir > C:\My Temp File.txt
FileRead, ThisHash, %A_Temp%ThisHash.txt
FileDelete, %A_Temp%ThisHash.txt
BisWeg:=InStr(ThisHash, "Withopf") + 10
StringTrimLeft, ThisHash, ThisHash, %BisWeg%
If(Only1Hash="")
	{
	BisWeg:=InStr(ThisHash, " = ") + 2
	StringTrimLeft, ThisHash, ThisHash, %BisWeg%
	AbWeg:=InStr(ThisHash,"`r`n") -1
	; StringTrimRight, ThisHash, ThisHash, %AbWeg%
	ThisHash:=SubStr(ThisHash,"1",AbWeg) 
	If(abweg<>32)
		Return
	}
Else
	{
	StringTrimRight, ThisHash, ThisHash,2
	AbWeg:=InStr(ThisHash,"`r`n","false",0)  -1
	; l:=strlen(ThisHash)
	ThisHash:=SubStr(ThisHash,"1",AbWeg) 
	}
Return ThisHash
}

; Text=funktion("Gerdi",MittelInitiale,"Nachname")
; ListVars
; MsgBox % FunktionsAufrufTextfreiMachen(Text)

FunktionsAufrufTextfreiMachen(Text)
{
global FunktionsUebergabeVarName1, FunktionsUebergabeVarName2, FunktionsUebergabeVarName3, FunktionsUebergabeVarName4, FunktionsUebergabeVarName5, FunktionsUebergabeVarName6, FunktionsUebergabeVarName7, FunktionsUebergabeVarName8, FunktionsUebergabeVarName9, FunktionsUebergabeVarName10, FunktionsUebergabeVarName11, FunktionsUebergabeVarName12

Pos0=0
loop
	{
	IndexVor:=A_Index-1
	Pos%A_Index% := RegExMatch(Text, """(.*?)""" , Anker%A_Index%,Pos%IndexVor%+1)
	FunktionsUebergabeVarInhalt:=Anker%A_Index%			; Variable mit Hochkomma
	FunktionsUebergabeVarName=FunktionsUebergabeVarName%A_Index%
	%FunktionsUebergabeVarName%:=Anker%A_Index%1			; Variable ohne Hochkomma setzen
	; MsgBox % Pos%A_Index%
	If (Pos%A_Index%=0)
		break
	StringReplace, Text, Text, %FunktionsUebergabeVarInhalt%, %FunktionsUebergabeVarName%
	; MsgBox % Text
	}

return Text
}


; Ruft übergebenes Unterprogramm auf
; verändert dabei Aktobjekt nicht!
;
; Aufrufbeispiel:
; 	Aktobjekt=DatumTTMMJJJJ
; 	MsgBox % AktobjektUnveraedertUnterprogAufruf("DatumTTMMJJ")
; 	MsgBox % AktobjektUnveraedertUnterprogAufruf(Aktobjekt)
; 	MsgBox %Aktobjekt%
; gibt folgende MsgBoxen aus
; 21.07.09
; 21.07.2009
; DatumTTMMJJJJ

AktobjektUnveraedertUnterprogAufruf(UnterprogName)
{
AktobjektTemp:=GetGlobalVar("Aktobjekt")

if IsLabel(UnterprogName)
	Gosub %UnterprogName%
Else
	MsgBox Das Label "%UnterprogName%" existiert nicht!

AktobjektTemp2:=GetGlobalVar("Aktobjekt")
SetGlobalVar("Aktobjekt",AktobjektTemp)
return AktobjektTemp2
}

; Funktion zum Holen von Kopien Globaler Variablen,
; Die Funtion ist gedacht zum aufgerufen aus Funtionen 
; Aufruf Beispiel:
; MsgBox % GetGlobalVar("DreamweaverDefault")
; Eine Kopie der globalen Variablen wird zurückgegeben.

GetGlobalVar(GlobalVarName)
	{
	Global GlobalVarNameTemp
	GlobalVarNameTemp:=GlobalVarName
	Gosub GetGlobalVar
	return GlobalVarNameTemp
	}

Goto NachGetGlobalVar		; Falls dieses Unterprogrammm im Hauptprogrammteil steht, wird übersprungen.
GetGlobalVar:
GlobalVarNameTemp:=%GlobalVarNameTemp%
return
NachGetGlobalVar:
Sleep 0


; Funktion zum Setzen Globaler Variablen,
; Die Funtion ist gedacht zum aufgerufen aus Funtionen 
; Aufruf Beispiel:
; [MsgBox % ]SetGlobalVar("DreamweaverDefault","c:\temp\test.htm")
; Eine Kopie der globalen Variablen wird zurückgegeben.

SetGlobalVar(GlobalVarName,GlobalVarInhalt)
	{
	; MsgBox GlobalVarName = %GlobalVarName%
	Global GlobalVarNameTemp,GlobalVarInhaltTemp
	GlobalVarInhaltTemp:=GlobalVarInhalt
	GlobalVarNameTemp:=GlobalVarName
	Gosub SetGlobalVar
	return GlobalVarInhaltTemp
	}

Goto NachSetGlobalVar		; Falls dieses Unterprogrammm im Hauptprogrammteil steht, wird übersprungen.
SetGlobalVar:
%GlobalVarNameTemp%:=GlobalVarInhaltTemp
; MsgBox % %GlobalVarNameTemp% " := " GlobalVarInhaltTemp
return
NachSetGlobalVar:
Sleep 0

MsgBoxNurText(Text="")	; Kurz: gibt Bildschirmmeldung aus.	Eingang: Variable die den Text enthält / Text in Hochkomma	Ausgang: TextBox mit der Meldung	Beispiel: Steuer-Zeile:<br><code>Auto§Hallo Welt	§<b>MsgBoxNurText("Hallo Welt")</b>|Exit</code><br>gibt die Meldung "Hallo Welt" aus 
{
MsgBox,%Text%
Return 
}

Key-1:					; Übersichts-Bild-1 --> Vollanzeige 
TonZuBild=ja
FensterNr=1
Gosub BildAufVolleGroesseFensternummer
Return

Key-2:					; Übersichts-Bild-2 --> Vollanzeige 
TonZuBild=ja
FensterNr=2
Gosub BildAufVolleGroesseFensternummer
Return

Key-3:					; Übersichts-Bild-3 --> Vollanzeige 
TonZuBild=ja
FensterNr=3
Gosub BildAufVolleGroesseFensternummer
Return

Key-4:					; Übersichts-Bild-4 --> Vollanzeige 
TonZuBild=ja
FensterNr=4
Gosub BildAufVolleGroesseFensternummer
Return

Key-5:					; Übersichts-Bild-5 --> Vollanzeige 
TonZuBild=ja
FensterNr=5
Gosub BildAufVolleGroesseFensternummer
Return

Key-6:					; Übersichts-Bild-6 --> Vollanzeige 
TonZuBild=ja
FensterNr=6
Gosub BildAufVolleGroesseFensternummer
Return

Key-7:					; Übersichts-Bild-7 --> Vollanzeige 
TonZuBild=ja
FensterNr=7
Gosub BildAufVolleGroesseFensternummer
Return

Key-8:					; Übersichts-Bild-8 --> Vollanzeige 
TonZuBild=ja
FensterNr=8
Gosub BildAufVolleGroesseFensternummer
Return

Key-9:					; Übersichts-Bild-9 --> Vollanzeige 
TonZuBild=ja
FensterNr=9
Gosub BildAufVolleGroesseFensternummer
Return

Key-ü:					; Diaschow Übersicht
ImageNrA=1
ImageNrB=0
DauerwiederholungWindowsY=WindowsYNachTaste
WarteWindowsY=6000
WarteBildEigen=0
TonZuBild=nein
BildZeilen=3
BildSpalten=3
ToolTipZeigen=nein
Gosub MarkiereNZeilenAbFokusierter
BildEigenList=%BildEigenListVorlage%
VlCWaitList=%VlCWaitListVorlage%
Oeffnen=ja
Gosub ContextOpenFile
Oeffnen=nein
Return

Key-h:
DauerwiederholungWindowsY=WindowsY
Gosub HintergrundBild
Return

Key-m:					; Multimediaschow
ImageNrA=1
ImageNrB=0
DauerwiederholungWindowsY=WindowsYNachTaste
WarteWindowsY=0
WarteBildEigen=%DefaultWarteBildEigen%
TonZuBild=ja
BildZeilen=1
BildSpalten=1
ToolTipZeigen=nein
Gosub MarkiereNZeilenAbFokusierter
BildEigenList=%BildEigenListVorlage%
VlCWaitList=%VlCWaitListVorlage%
Oeffnen=ja
Gosub ContextOpenFile
Oeffnen=nein
Return

Key-k:					; Erzeuge Link auf BildVolleGroesse Datei im zuvor gewählten Ordner

DauerwiederholungWindowsY=WindowsY
Gosub LinkBildVolleGroesseFensternummer
Return

Key-l:					; Erzeuge Link auf Markierte Datei(en) im zuvor gewählten Ordner
DauerwiederholungWindowsY=WindowsY
Gosub EinstiegLinkUebergebenerOrdner
Return

Key-mit:					; + Bild auf volle Größe
DauerwiederholungWindowsY=nein
TonZuBild=ja
Gosub BildAufVolleGroesse
DauerwiederholungWindowsY=WindowsY
Return

Key-ohne:				; - volle Größe Bild --> ursprüngliche Größe
TonZuBild=nein
Gosub BildAufUrsprungsGroesse
Return

Key-Esc:					; Abbrechen
DauerwiederholungWindowsY=nein
Gosub SplashImageOff
Return

Key-q:					; Abbrechen
DauerwiederholungWindowsY=nein
Gosub SplashImageOff
WarteBildEigen=%DefaultWarteBildEigen%
Return

Key-r:					; wie Rechtskick auf markierte(s) Bild / Listenelement(e)
Gosub MarkiereVolleGroesseBild
Return

Key-w:					; weiter
Gosub RestlicheBefehleAbarbeiten
Return

Key-z:					; Zeilesortierung zufällig
Gosub SortRandomAll
Return

Key-Down:				; 9-Bilder weiterblättern
ImageNrA=1
ImageNrB=0
DauerwiederholungWindowsY=WindowsY
TonZuBild=nein
BildZeilen=3
BildSpalten=3
ToolTipZeigen=nein
Gosub MarkiereNZeilenAbFokusierter
BildEigenList=%BildEigenListVorlage%
VlCWaitList=%VlCWaitListVorlage%
Oeffnen=ja
Gosub ContextOpenFile
Oeffnen=nein
Return

Key-Dot:				; 4-Bilder weiterblättern
ImageNrA=1
ImageNrB=0
DauerwiederholungWindowsY=WindowsY
TonZuBild=nein
BildZeilen=2
BildSpalten=2
ToolTipZeigen=nein
Gosub MarkiereNZeilenAbFokusierter
BildEigenList=%BildEigenListVorlage%
VlCWaitList=%VlCWaitListVorlage%
Oeffnen=ja
Gosub ContextOpenFile
Oeffnen=nein
Return

Key-Doppelpunkt:				; 2-Bilder weiterblättern
ImageNrA=1
ImageNrB=0
DauerwiederholungWindowsY=WindowsY
TonZuBild=nein
BildZeilen=1
BildSpalten=2
ToolTipZeigen=nein
Gosub MarkiereNZeilenAbFokusierter
BildEigenList=%BildEigenListVorlage%
VlCWaitList=%VlCWaitListVorlage%
Oeffnen=ja
Gosub ContextOpenFile
Oeffnen=nein
Return

Key-Strichpunkt:				; 3-Bilder weiterblättern
ImageNrA=1
ImageNrB=0
DauerwiederholungWindowsY=WindowsY
TonZuBild=nein
BildZeilen=1
BildSpalten=3
ToolTipZeigen=nein
Gosub MarkiereNZeilenAbFokusierter
BildEigenList=%BildEigenListVorlage%
VlCWaitList=%VlCWaitListVorlage%
Oeffnen=ja
Gosub ContextOpenFile
Oeffnen=nein
Return

Key-Right:				; 1-Bild weiterblättern
ImageNrA=1
ImageNrB=0
DauerwiederholungWindowsY=WindowsY
TonZuBild=ja
FolgebildWartetTonEnde=
BildZeilen=1
BildSpalten=1
WarteBildEigen=0
ToolTipZeigen=nein
Gosub MarkiereNZeilenAbFokusierter
BildEigenList=%BildEigenListVorlage%
VlCWaitList=%VlCWaitListVorlage%
Oeffnen=ja
Gosub ContextOpenFile
Oeffnen=nein
FolgebildWartetTonEnde=Wait
Return

Key-Up:					; 9-Bilder zurückblättern
ImageNrA=1
ImageNrB=0
TonZuBild=nein
BildZeilen=3
BildSpalten=3
ToolTipZeigen=nein
Gosub MarkiereNZeilenVorFokusierter
BildEigenList=%BildEigenListVorlage%
VlCWaitList=%VlCWaitListVorlage%
DauerwiederholungWindowsY=WindowsY
Oeffnen=ja
Gosub ContextOpenFile
Oeffnen=nein
Return

Key-Komma:					; 4-Bilder zurückblättern
ImageNrA=1
ImageNrB=0
TonZuBild=nein
BildZeilen=2
BildSpalten=2
ToolTipZeigen=nein
Gosub MarkiereNZeilenVorFokusierter
BildEigenList=%BildEigenListVorlage%
VlCWaitList=%VlCWaitListVorlage%
DauerwiederholungWindowsY=WindowsY
Oeffnen=ja
Gosub ContextOpenFile
Oeffnen=nein
Return

Key-Left:					; 1-Bilder zurückblättern
ImageNrA=1
ImageNrB=0
FolgebildWartetTonEnde=
TonZuBild=ja
BildZeilen=1
BildSpalten=1
ToolTipZeigen=nein
Gosub MarkiereNZeilenVorFokusierter
BildEigenList=%BildEigenListVorlage%
VlCWaitList=%VlCWaitListVorlage%
DauerwiederholungWindowsY=WindowsY
Oeffnen=ja
Gosub ContextOpenFile
Oeffnen=nein
FolgebildWartetTonEnde=Wait
Return

UeberwacheVariablenAenderung:
UeberwachteVariable=BildEigenList
If(Old%UeberwachteVariable%<>%UeberwachteVariable%)
	{
	listlines
	MsgBox % UeberwachteVariable " = " %UeberwachteVariable%
	}
Old%UeberwachteVariable%:=%UeberwachteVariable%
Return

ListLines:
Listlines
return
ListVars:
ListVars
return

#IfWinActive, ahk_class AutoHotkeyGUI,in
F5::
MultimediaVonOrdnerZeigen=ja
DauerwiederholungWindowsY=nein
WarteWindowsY=0
WindowsY:
If(ThreadsBeenden="ja")
	{
	ThreadsBeenden=
	DauerwiederholungWindowsY=
	; DauerwiederholungWindowsY=nein
	MultimediaVonOrdnerZeigen=
	Exit
	return
	}
If(ToolTipZeigen><"nein")
    ToolTip,Macro Aufruf`n`nhinterlegte Taste drücken,4,4
BeteiligteFenster:=0
IfWinActive , ahk_class AutoHotkeyGUI
	++BeteiligteFenster
IfWinActive , ahk_class QWidget
	++BeteiligteFenster
If(WinExist("A")="0x0")
	++BeteiligteFenster

If (BeteiligteFenster>0)
	{
	Input, Key, L1,{Backspace}{Esc}{Left}{Right}{Up}{Down}{Home}{End}{PgUp}{PgDn}{Del}{Ins}{BS}{Pause}{F1}{F2}{F3}{F4}{F5}{F6}{F7}{F8}{F9}{F10}{F11}{F12}
	RueckWert:=ErrorLevel
	}
WindowsYnachKey:
BeteiligteFenster:=0
IfWinActive , ahk_class AutoHotkeyGUI
	++BeteiligteFenster
IfWinActive , ahk_class QWidget
	++BeteiligteFenster
If(WinExist("A")="0x0")
; IfWinActive , ahk_class 
	++BeteiligteFenster

If (BeteiligteFenster>0)
	{
	If(ThreadsBeenden="ja")
		{
		ThreadsBeenden=
		DauerwiederholungWindowsY=
		; DauerwiederholungWindowsY=nein
		MultimediaVonOrdnerZeigen=
		Exit
		return
		}
	If (RueckWert = "EndKey:Backspace")
		Key=Backspace
	If (RueckWert = "EndKey:Escape")
		Key=Esc
	If (RueckWert = "EndKey:Delete")
		Key=Delete
	If (RueckWert = "EndKey:Home")
		Key=Home
	If (RueckWert = "EndKey:End")
		Key=End
	If (RueckWert = "EndKey:Pause")
		{
		Key=Pause
		Send {Pause}
		sleep 40
		}
	If (RueckWert = "EndKey:Left")
		Key=Left
	If (RueckWert = "EndKey:Right")
		Key=Right
	If (RueckWert = "EndKey:Up")
		Key=Up
	If (RueckWert = "EndKey:Down")
		Key=Down
	If (RueckWert = "EndKey:PgUp")
		Key=PgUp
	If (RueckWert = "EndKey:PgDn")
		Key=PgDn
	If (RueckWert = "EndKey:Del")
		Key=Del
	If (RueckWert = "EndKey:Ins")
		Key=Ins
	If (RueckWert = "EndKey:BS")
		Key=BS
	Loop,12
		{
		Vergleich=EndKey:F%A_Index%
		If(RueckWert = Vergleich)
			{
			Key=F%A_Index%
			break
			}
		}
	If (Key=A_Tab)
		Key=Tab
	If (Key=".")
		Key=Dot
	If (Key="-")
		Key=ohne
	If (Key="+")
		Key=mit
	If (Key=";")
		Key=Strichpunkt
	If (Key=",")
		Key=Komma
	If (Key=":")
		Key=Doppelpunkt
	If (Key="<")
		Key=kleiner
	If (Key=">")
		Key=groesser
	If (Key="~")
		Key=Tilde
	If (Key="*")
		Key=Stern
	If (Key="/")
		Key=Slash
	If (Key="=")
		Key=gleich
	If (Key="`(")
		Key=KlammerAuf
	If (Key="`)")
		Key=KlammerZu
	If (Key="&")
		Key=Und
	If (Key="!")
		Key=Ausrufezeichen
	If (Key="%")
		Key=Prozent
	If (Key="""")
		Key=Hochkommas
	If (Key="'")
		Key=Hochkomma
	If (Key="°")
		Key=Grad
	If (Key="|")
		Key=Pipe
	If (Key="\")
		Key=Backslash

	If (Key="Escape")
		{
		DauerwiederholungWindowsY=nein
		ToolTip,
		return
		}
	If (Key="Pause")
		{
		return
		}
	Else
		{
		DoMitschrieb=%DoMitschrieb%`r`nKey-%Key%`r`n^WarteVomScript=%WarteVomScriptDefault%`r`nWarte
		Ue1=%EigeneDateien%\SucheDateien\Key-%Key%.do.lnk
		}
	IfNotExist %Ue1%
		{
		Ue1=%EigeneDateien%\SucheDateien\Key-%Key%.do
		IfNotExist %Ue1%
			{
			Ue1=%A_ScriptDir%\SucheDateien\Key-%Key%.do.lnk

			IfNotExist %Ue1%
				{
				Ue1=%A_ScriptDir%\SucheDateien\Key-%Key%.do.lnk

				IfNotExist %Ue1%
					{
					Ue1=%A_ScriptDir%\SucheDateien\Key-%Key%.do
					IfNotExist %Ue1%
						{
						KeyVar=Key%Key%
						KeyPfad:=%KeyVar%
						If (KeyPfad = "")
							{
							ToolTip,
							MsgBox kann die Befehls-Datei`n%EigeneDateien%\SucheDateien\Key-%Key%.do`nnicht finden!
							return
							}
						Else
							{
							IfNotExist %EigeneDateien%\SucheDateien
								FileCreateDir, %EigeneDateien%\SucheDateien
							FileAppend , %KeyPfad%, %EigeneDateien%\SucheDateien\Key-%Key%.do
							Ue1=%EigeneDateien%\SucheDateien\Key-%Key%.do
							}
						}
					}
				}
			Else
				Ue1:=RelLink2AbsPath(Ue1)
			}
		}
	Else
		Ue1:=RelLink2AbsPath(Ue1)
WindowsYNachTaste:
	If(ToolTipZeigen><"nein")
		ToolTip,Macro`n%Ue1%`nwird ausgeführt.,4,4
	; MsgBox % Ue1 "	" DauerwiederholungWindowsY
	Gosub BefehlsDateiVerarbeiten
	; MsgBox % Ue1 "	" DauerwiederholungWindowsY
	If(WarteWindowsY > 0)
		{
		; MsgBox % WarteWindowsY
		sleep, WarteWindowsY
		}
	ToolTip,
	; MsgBox OK
Verzoegern:
	GetKeyState, state, Space				; Taste Escape überwachen (für händisches weiterschalten)
	; MsgBox % State
	if state = D					; bei gedrückter Taste Autoweiterschalten aus
		{
		Sleep 700
		Goto Verzoegern
		}
	GetKeyState, state, q				; Taste Escape überwachen (für händisches weiterschalten)
	; MsgBox % State
	if state = D					; bei gedrückter Taste Autoweiterschalten aus
		{
		return
		}
	If(DauerwiederholungWindowsY<>"nein")
		Goto %DauerwiederholungWindowsY%
	If(BildFenster="offen")
		{
		If(BeendenBeiListEnde<>"")
			{
			TrayTip,Programmende,letztes Bild / letzter Film`nzurück zur Übersicht.
			sleep %BeendenBeiListEnde%
			ExitApp
			}
		Else
			{
			MsgBox,4100,, Bilder nicht mehr anzeigen?`nBildFenster=%BildFenster%
			IfMsgBox Yes
				{
				Loop % NZeilen
					SplashImage, %A_index%:Off
				SplashImage, 10:Off
				BildFenster=zu
				}
			}
		}
	}
Else
	{
	ThisActiveWinID:=WinExist("A") 
	WinWaitNotActive,ahk_id %ThisActiveWinID%
	Goto WindowsY ; ############################ Achtung geht immer tiefer rein!! besser Loop verwenden
	}
return

#Right::
MarkiertenRelLinkStarten:
TempClipboard=%Clipboard%
clipboard =			; Empty the clipboard
Send, ^c
ClipWait, 3
if ErrorLevel
	{
	ToolTip,es kam innerhalb 3sec kein Inhalt im Clipboard an
	ClipWait, 3
	if ErrorLevel
		{
		ToolTip
		; ggf. Fehlerbehandlung einfügen
		}
	}
ThisLinkFile:=Clipboard
; MsgBox % ThisLinkFile
If (SubStr(ThisLinkFile, -3 , 4)=".lnk")
	{
	IfExist %ThisLinkFile%
		{
		Thisfile:=RelLink2AbsPath(ThisLinkFile,"ja")
		IfExist %Thisfile%
			Run %Thisfile%
		}
	}
Else If Exist ThisLinkFile
	Run %ThisLinkFile%
Clipboard=%TempClipboard%
Return

#Left::
MarkiertenRelLink2Clipboard:
TempClipboard=%Clipboard%
clipboard =			; Empty the clipboard
Send, ^c
ClipWait, 3
if ErrorLevel
	{
	ToolTip,es kam innerhalb 3sec kein Inhalt im Clipboard an
	ClipWait, 3
	if ErrorLevel
		{
		ToolTip
		; ggf. Fehlerbehandlung einfügen
		}
	}
ThisLinkFile:=Clipboard
; MsgBox % ThisLinkFile
If (SubStr(ThisLinkFile, -3 , 4)=".lnk")
	{
	IfExist %ThisLinkFile%
		{
		Thisfile:=RelLink2AbsPath(ThisLinkFile,"ja")
		IfExist %Thisfile%
			{
			Clipboard:=Thisfile
			Return
			}
		}
	}
Else If Exist ThisLinkFile
	{
	Clipboard:=ThisLinkFile
	return
	}
Clipboard=%TempClipboard%
Return
F10::
IF(SplashImageRand="")
	{
	SplashImageRand=M1
	TrayTip,SplashImage,mit Rand
	}
Else
	{
	SplashImageRand=
	TrayTip,SplashImage,ohne Rand
	}
Return

F1::
AusgabeMonitor1:
WunschMonitorNr:=1
TrayTip,Ausgabe,Monitor 1
Return

F2::
AusgabeMonitor2:
Gosub GetMonitorWorkArea
If (2<=MonitorCount)
	{
	WunschMonitorNr:=2
	TrayTip,Ausgabe,Monitor %WunschMonitorNr%,4
	}
Else
	TrayTip,Ausgabe,Monitor 2 nicht vorhanden.`nMonitor %WunschMonitorNr% wird weiterhin verwendet!
Return

F3::
AusgabeMonitor3:
Gosub GetMonitorWorkArea
If (3<=MonitorCount)
	{
	WunschMonitorNr:=3
	TrayTip,Ausgabe,Monitor %WunschMonitorNr%,4
	}
Else
	TrayTip,Ausgabe,Monitor 3 nicht vorhanden.`nMonitor %WunschMonitorNr% wird weiterhin verwendet!,9
Return


LShift & RShift::
FensterWegHer:
WinGetPos , SucheDateienXpos, , , ,SucheDateien
If (SucheDateienXpos=10000)
	WinMove, SucheDateien, , SucheDateienXposAlt, SucheDateienYposAlt
Else
	{
	WinGetPos , SucheDateienXposAlt, SucheDateienYposAlt, , ,SucheDateien
	WinMove, SucheDateien, , 10000, 0
	}
Return

ThreadsBeenden:
If(ThreadsBeenden="ja")
	{
	; Msgbox drin
	ToolTip
	ThreadsBeenden=
	Gosub ButtonOpti
	TrayTip,Aktion,abgewürgt`nweiter auf eigene Gefahr!,5
	Exit
	}
Return

Abbruch:
Esc::
Hotkey, Esc, Off  
Gosub SplashImageOff
Oeffnen=nein
ThreadsBeenden=ja
BefehlsDateiVerarbeitenBeenden=ja
DauerwiederholungWindowsY=nein
send q
Input, Key, L1 T1,{Enter}.{Esc}
ThisKey:=ErrorLevel
If (ThisKey = "EndKey:Escape")
	Exitapp
Hotkey, Esc, On  
Exit
return
+Esc::
Exitapp
return

