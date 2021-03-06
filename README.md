# ZackZackOrdner

Ordner schnell Auswahl. / Get Folders On The Quick.

Das Hauptziel  des Skripts ist, eine flotte Verwendung von Ordnern. / The main goal of the script is, a zippy use of folders.

https://github.com/Grrdi/ZackZackOrdner/archive/master.zip entpacken<br>
und SchnellOrdner.ahk mit AutoHotkey Version 1. Hoechste starten<br>
Näheres siehe Hilfe-Datei:<br>
SchnellOrdner.ahk.htm<br>
und <br>
https://autohotkey.com/boards/viewtopic.php?f=10&t=15248<br>
https://youtu.be/tN214pjN6aA

Installations-Alternative: AktualisiereZackZackOrdner.ahk starten (Proxy-Umgebungen werden seit 12.2018 unterstützt).

Install: run AktualisiereZackZackOrdner.ahk (This will: Download; Install; First-Run of Program)

<h2>Was ist, was kann ZackZackOrdner</h2>
<p>Würde ich dem Programm heute (Ende 2018) einen Namen geben, würde es eher <b>Power-Suche</b> oder <b>Filter-Anzeige</b> lauten.</p>
<p>ZackZackOrdner ist inzwischen wesentlich mehr als ein sehr <b>schnelles Ordner-Such-Programm</b>. 
  Fast genau so schnell <b>findet</b> man damit <b>Dateien</b>. Eine integrierte 
  <b>Favoriten-Datenbank</b> / Favoriten-Verwaltung unterst&uuml;tzt auch gro&szlig;e 
  Favoriten-Sammlungen in gewohnter Suchumgebung und finde-Geschwindigkeit. Da 
  Programme letztendlich auch nur Dateien sind wurde ein Container dem Thema <b>Programmstart</b> 
  gewidmet. Durch einen effizienten Cache ist das bisher genannte so schnell, 
  dass es w&auml;hrend der Eingabe schon passende Suchergebnisse anzeigt und das 
  auch bei der Suche ueber mehrere Laufwerke, was bei der Suche mit Bord-Mitteln 
  eine Kaffe-Pause bis hin zur &Uuml;ber-Nacht-Suche erforderlich machen kann. 
  Bord-Mittel wie <b>Explorer</b> bzw. <b>Speichern</b> ... <b>Dialoge</b> werden 
  <b>unterst&uuml;tzt</b>, nicht ersetzt.</p>
<p>Wesentlich vielf&auml;ltiger ist jedoch die <a href="LiveSuche.md">Live-Suche</a>, 
  sie arbeitet ohne Cache (gespeicherte Suchbeschleuniger). Auch mit der Live-Suche 
  kann oben erw&auml;hntes gefunden / gehandelt werden. Dar&uuml;ber hinaus gibt 
  es <b>selektive Dateibetrachter</b>, d.h. von einer Datei werden nur die Inhaltszeilen 
  gezeigt, die der Suchaufforderung entsprechen. Dies ist sehr n&uuml;tzlich 
  bei <b>Quelltexten</b>, <b>Logfiles</b> oder allgemein bei Text-Dateien/-Inhalten. 
  Die Live-Suche kann aber auch mit einer Sammlung von Dateien umgehen. Z.B. mit 
  den Dateien eines Ordners mit oder ohne Unterverzeichnisse. Hier kann sowohl 
  in den <b>Datei-Pfaden</b> als auch in den <b>Datei-Inhalten</b> gesucht (/gefiltert) werden. 
  Siehe auch Hilfe-Dateien unten.
</p>
<p>Nicht nur Text-Dateien enthalten Text, auch das <b>Clipboard</b>, <b>editierbare-Fenster-Elemente</b> 
  von <b>Fremd-Fenstern</b>, <b>Web-Inhalte</b>. Einige Text anzeigende Fenster 
  Elemente lassen sich von ZZO direkt durchsuchen bzw. selektiv betrachten.</p>
<p><b>Dateigr&ouml;&szlig;en</b> bei denen z.B. Notepad schon lange aussteigt lassen 
  sich mit geringer Verz&ouml;gerung durchsuchen.</p>
<p>Stichwortartige Nennung weiterer Funktionalit&auml;ten: <b>Clipboard Tool</b>, 
  ClipBoard-Anzeige, Clipboard Eitor, &ouml;ffnen mit, 
  Fundstellen sortieren, Anlegen von Ordner-/Datei-Strukturen nach Muster, SuperFavoriten, DLL-Infos,
  (Direktaufruf von Favoriten und Macros), Fundstellen-genauer-Scite-Editor-Direktaufruf 
  vom selectiven Dateibetrachter. Datei-/Ordner-Zeitstempel ver&auml;ndern, GuiDropFile, 
  Benutzer-Speziefischer Button, Machs Beste draus --&gt; Versuch f&uuml;r das 
  fokusierte Control (+ weitere Infos) das hier sinvolle (und stets harmlose), 
  durch zu f&uuml;hren.</p>
<p>Bei den oben genannten Suchen lassen sich meist via Vorfilter die anzufassenden 
  Elemente einschr&auml;nken (sehr schnell aber nur ein Suchbegriff m&ouml;glich), 
  mit einem Nachfilter k&ouml;nnen die schon eingeschr&auml;nkten Vor-Ergebnisse 
  auf den exakten Bedarfsfall beschr&auml;nkt werden, hierbei sind <b>UND</b> 
  oder <b>ODER</b> (z.B. Maier,Mayer,Meier,Meyer) <b>verkn&uuml;pfte</b> Suchworlisten 
  und daraus gebildete kombinationen erlaubt . </p>
<p><b>M&auml;chtige Macro-Umgebung</b> mit optionaler <b>Einmal</b>- oder <b>Intervall</b>-<b>Startm&ouml;glichkeit</b>. 
  Damit lassen sich <b>automatisiert</b> Logdateien, Fehlermeldunngen, freier 
  SpeicherPlatz etc <b>&uuml;berwachen</b> und bei Bedarf kann auch <b>alarmiert</b> 
  (z.B. E-Mail) werden. Automatische Verteiler (um-kopieren) von Dateien nach Datei-Inhalten 
  oder Namen oder nach Zufall lassen sich auch durch Macros realisieren.</p>
<p>F&uuml;r fast alle oben genannten Funktionalit&auml;ten lassen sich <b>Start-Macro</b>s 
  erzeugen (Macro in den Uebergabe-Parametern von Standart-LNK-Verknuepfungen) und anschlie&szlig;end auch direkt aufrufen. So laesst sich ZZO bspw. direkt als selbst aktualisierende ClipBoard-Anzeige (auf Wunsch gefiltert) starten. Die Start-LNK-Datei benötigt nur folgende Schritte: <br>1. kopieren von <pre>clip://&#09;In_Row? 
Ab Version [0.597]  
OnEvent? OnClipboardChange`tGosub F5`vclip://`vIn_Row? </pre> ins Standart-Suchfeld (das Zeichen rechts von // ist ein Tabulator). <br>2. Hauptmenü | Filter | Aktuelle Live-Suche 2 LinkMacro<br>Ein sinnvoller Filter waere z.B. <pre>clip://&#09;In_Row? Stengel,rauh</pre>Stengel,rauh,... ist eine Liste von potentiellen Rechtschreibfehlern. Anzeige nur bei vorkommen von Falschwoertern (optionaler Warnton mit Anzeige minimiert oder im Hintergrund moeglich).</p>
<p> Hilfe Dateien:<br>
Nach entpacken einer .hlp Datei (z.B. mit 7-Zip) in einen Container-Ordner (hier am Beispiel der AHK-Hilfe)
können die Inhalte aller Hilfedateien nach Suchbegriffen gefiltert werden (alle Hilfedateien gleichzeitig).
<pre>FilP://C:\ProgramData\Zack\WuCont\AhkHelp\*.htm*,DFR In_Inh? SUCHBEGRIFF(E)</pre>
Suchbegriffs-Beispiele:<br>
Objekt`nCOM`nfunc (`n verbindet Suchbegriffe mit UND)<br>
-= (auch in der Standart-Hilfe nicht unterstützte Suchen können funktionieren, solange nichts als spezielles Live-Suche-Zeichen [wie z.B. bei: , `n `v `t] interprätiert wird).<br>
Kontakte (VCF-Dateien) können wie zuvor behandelt werden, so lassen sich z.B. leicht alle Kontakte mit einer bestimmten Ortsvorwahl filtern.</p>
<p><pre>OnEvent? OnClipboardChange`tGosub F5`vCoTe://WConDef? Scintilla1,ahk_class SciTEWindow`vNr_Row? %Clipboard%
OnEvent? OnClipboardChange`tGosub F5`vCoTe://WConDef? Edit1,ahk_class Notepad`vNr_Row? %Clipboard%</pre> zeigt alle Zeilen des momentanen Scintilla-Editors (Notepad-Editors Zeile 2) gefiltert nach dem Clippboard. Eine Variable ins Clipboard genommen, zeigt alle Zeilen welche die Variable enthalten, auch wenn noch nicht gespeichert wurde.<br>
Hinweis: Das Clipboard unterstützt die Zeilenschaltung via `n nicht für eine UND Verknüpfung der Suchbegriffe, aber echte Zeilenschaltungen funktionieren.</p>
