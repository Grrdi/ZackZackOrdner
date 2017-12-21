<html>
<head>
<title>Live Suche</title>
<meta http-equiv="Content-Type" content="text/html; charset="iso-8859-1">
</head>

<body bgcolor="#FFFFFF" text="#000000">
<h2>Live Suche </h2>
<p>Bei der Cache-Suche wird nur im Cache gesucht bzw. die richtigen Cache-Elemente 
  zusammmengestellt. Bei der Live-Suche ist nichts zur Suchbeschlaeunigung vorbereitet. 
  In ZZO erkennt man die Live-Suche an den 4 Buchstaben gefolgt von :// links 
  in Edit2 und an der deutlich groesseren Laenge. Die Live-Suche wird nicht vom 
  Container, Startpfad oder Such-Filter oder dergleichen beeinflusst. </p>
<p>Wenn bei der Live Suche das Evaluieren w&auml;hrend der Eingabe st&ouml;rt, 
  kann der Haken links von []warte gesetzt werden. Dann wird nur bei Button1 oder 
  F5 die Suche aktualisiert.</p>
<p><b>Beispiel</b> -&gt; Suche in einer Datei:<br>
  <code>file://C:\Program Files (x86)\ZackZackOrdner\SchnellOrdner.ahk Nr_Row?<br>
  </code>in Edit2 eingegeben, gibt die ersten Zeilen von <samp>C:\Program Files 
  (x86)\ZackZackOrdner\SchnellOrdner.ahk</samp> aus. Bei<br>
  <code>file://C:\Program Files (x86)\ZackZackOrdner\SchnellOrdner.ahk Nr_Row? 
  <b>Doppelklick<br>
  </b></code>werden nur noch Zeilen, die den Text Doppelklick enthalten, ausgegeben. 
  Bei installiertem Scite-Eitor und bekanntem Scite-Pfad) kann im Pfad-Ausgabefeld 
  Edit5 eiene Zeile doppelgeklickt werden und sie springt markiert in Scite auf.</p>
<p>ZZO verh&auml;lt sich bei der Eingabesyntax meist kompromisslos. Bei Syntaxfehlern 
  ist die Ausgabe haufig leer. <br>
  Deshalb wurde obiges Beispiel farbig hinterlegt: (die Farben werden von Github bei MD-Dateien nicht unterstuetzt, bitte LiveSuche.htm herunterladen und oeffnen.) <br>
  <code><span style="background-color:#DDFFDD;">file://</span><span style="background-color:#FFDDDD;">C:\Program 
  Files (x86)\ZackZackOrdner\SchnellOrdner.ahk</span><span style="background-color:#FFFFDD;">&nbsp;</span><span style="background-color:#DDFFFF;">Nr_Row?</span><span style="background-color:#FFFFDD;">&nbsp;</span><span style="color:red;background-color:#CCCCFF;">Doppelklick</span></code><br>
<p>in den Tabellen unten sind die Zuordnungen ersichtlich. Ohne die <code><span style="background-color:#FFFFDD;">Leerzeichen</span></code> 
  gehts schief. 
<p>Eine Live Suche besteht aus einem <code><span style="background-color:#DDFFDD;">Suchort-Kenner</span></code>
<table border="1">
  <tr> 
    <td><b>Suchort-Kenner</b></td>
    <td><b>Suche in</b></td>
    <td><b>erwarteter Code</b></td>
  </tr>
  <tr> 
    <td><code><span style="background-color:#DDFFDD;">file://</span><span style="background-color:#FFDDDD;"></span></code></td>
    <td>Einzeldatei</td>
    <td>DateiPfad ohne Platzhalter</td>
  </tr>
  <tr> 
    <td><code><span style="background-color:#DDFFDD;">clip://</span><span style="background-color:#FFDDDD;"></span></code></td>
    <td>Clipboard</td>
    <td>nichts </td>
  </tr>
  <tr> 
    <td><code><span style="background-color:#DDFFDD;">filP://</span></code></td>
    <td>FilePattern (DateiPfad mit Platzhaltern)</td>
    <td>DateiPfad mit Platzhalter</td>
  </tr>
  <tr> 
    <td><code><span style="background-color:#DDFFDD;">CoTe://</span><span style="background-color:#FFDDDD;"></span></code></td>
    <td>Fenster-Element (Control)</td>
    <td>WinTitle Control siehe unten</td>
  </tr>
</table>
gefolgt von <code><span style="background-color:#DDFFFF;">Such- und Anzeige- Option(en)</span>.</code><br>
<table border="1">
  <tr> 
    <td><b>Such- und Anzeige- Optionen</b></td>
    <td><b>liefert</b></td>
    <td><b>Bemerkung</b></td>
  </tr>
  <tr> 
    <td><code><span style="background-color:#DDFFFF;">Nr_Row?</span><span style="background-color:#FFFFDD;"></span></code></td>
    <td>Nummerierte Anzeige; Suche in der Zeile</td>
    <td>&nbsp;</td>
  </tr>
  <tr> 
    <td><code><span style="background-color:#DDFFFF;">In_Row?</span></code></td>
    <td>1:1 Anzeige; Suche in der Pfad-Zeiele</td>
    <td>&nbsp;</td>
  </tr>
  <tr> 
    <td><code><span style="background-color:#DDFFFF;">In_Inh?</span></code></td>
    <td>1:1 Anzeige; Suche im Datei-Inhalt</td>
    <td>&nbsp;</td>
  </tr>
  <tr> 
    <td><code><span style="background-color:#DDFFFF;">Nr_Inh?</span></code></td>
    <td>Nummerierte Anzeige; Suche im Datei-Inhalt</td>
    <td>&nbsp;</td>
  </tr>
  <tr> 
    <td><code><span style="background-color:#DDFFFF;">NrRRex?</span></code></td>
    <td>Nummerierte Anzeige; RegExSuche f&uuml;r Profies</td>
    <td>&nbsp;</td>
  </tr>
  <tr> 
    <td><code><span style="background-color:#DDFFFF;">InNAme?</span></code></td>
    <td>1:1 Anzeige; Suche im Ordner- oder Pfad-Name</td>
    <td>&nbsp;</td>
  </tr>
  <tr> 
    <td><code><span style="background-color:#DDFFFF;">MacrDo?</span></code></td>
    <td>auszufuehrendes Macro</td>
    <td>&nbsp;</td>
  </tr>
  <tr> 
    <td><code><span style="background-color:#DDFFFF;">WTitle?</span></code></td>
    <td rowspan="2">Suche in eienem Fenster-Element</td>
    <td>&nbsp;</td>
  </tr>
  <tr> 
    <td><code><span style="background-color:#DDFFFF;">Contro?</span></code></td>
    <td>&nbsp;</td>
  </tr>
</table>
<p>Beispiele was geht:</p>
<table border="1">
  <tr> 
    <td height="20" width="28">Nr</td>
    <td height="20" width="361"><b>Code</b></td>
    <td height="-1" width="136"><b>Such-Ort</b></td>
    <td height="20" width="141"><b>Anzeige; Suchart</b></td>
    <td height="20" width="124"><b>Filter</b></td>
    <td height="20" width="124">Verwendungsbeispiele</td>
  </tr>
  <tr> 
    <td height="20" width="28">1.1</td>
    <td height="20" width="361"><code><span style="background-color:#DDFFDD;">file://</span><span style="background-color:#DDFFDD;"></span><span style="background-color:#FFDDDD;">SchnellOrdner.ahk</span><span style="background-color:#FFFFDD;">&nbsp;</span><span style="background-color:#DDFFFF;">Nr_Row?</span><span style="background-color:#FFFFDD;">&nbsp;</span><span style="color:red;background-color:#CCCCFF;">Doppelklick</span></code></td>
    <td height="41" rowspan="4" width="136">Einzeldatei</td>
    <td height="20" width="141">Nummerierte Anzeige;Suche in der Inhalts-Zeile</td>
    <td height="20" width="124">&nbsp;</td>
    <td height="20" width="124">Quelltext-Suche</td>
  </tr>
  <tr> 
    <td width="28">1.2</td>
    <td width="361"><code><span style="background-color:#DDFFDD;">file://</span><span style="background-color:#FFDDDD;">SchnellOrdner.ahk</span><span style="background-color:#FFFFDD;">&nbsp;</span><span style="background-color:#DDFFFF;">In_Row?</span><span style="background-color:#FFFFDD;">&nbsp;</span><span style="color:red;background-color:#CCCCFF;">Doppelklick</span></code></td>
    <td width="141">1:1 Anzeige; Suche in der Inhalts-Zeile</td>
    <td width="124">&nbsp;</td>
    <td width="124">Logfile-Suche</td>
  </tr>
  <tr> 
    <td height="29" width="28">1.3</td>
    <td height="29" width="361"><code><span style="background-color:#DDFFDD;">file://</span><span style="background-color:#FFDDDD;">SchnellOrdner.ahk</span><span style="background-color:#FFFFDD;">&nbsp;</span><span style="background-color:#DDFFFF;">NrRRex?</span><span style="background-color:#FFFFDD;">&nbsp;</span><span style="color:red;background-color:#CCCCFF;">Doppelklick</span></code></td>
    <td height="20" width="141">Nummerierte Anzeige;Regex-Suche in der Inhalts-Zeile</td>
    <td height="29" width="124">&nbsp;</td>
    <td height="29" width="124">Logfile-Suche</td>
  </tr>
  <tr> 
    <td width="28">1.4</td>
    <td width="361"><code><span style="background-color:#DDFFDD;">file://</span><span style="background-color:#FFDDDD;">SchnellOrdner.ahk</span><span style="background-color:#FFFFDD;">&nbsp;</span><span style="background-color:#DDFFFF;">InName?</span><span style="background-color:#FFFFDD;">&nbsp;</span><span style="color:red;background-color:#CCCCFF;">Doppelklick</span></code></td>
    <td width="141">1:1 Anzeige; Suche in der Inhalts-Zeile, wenn der als Pfad 
      interpretierbar, dann suche im Datei- oder Orner-Name</td>
    <td width="124">&nbsp;</td>
    <td width="124">Datei, die Pfade gespeichert hat, nach Datei- oder Orner-Name 
      durchsuchen. </td>
  </tr>
  <tr> 
    <td width="28">&nbsp;</td>
    <td width="361">&nbsp;</td>
    <td width="136">&nbsp;</td>
    <td width="141">&nbsp;</td>
    <td width="124">&nbsp;</td>
    <td width="124">&nbsp;</td>
  </tr>
  <tr> 
    <td width="28">2.1</td>
    <td width="361"><code><span style="background-color:#DDFFDD;">clip://</span><span style="background-color:#FFFFDD;">&nbsp;</span><span style="background-color:#DDFFFF;">Nr_Row?</span><span style="background-color:#FFFFDD;">&nbsp;</span><span style="background-color:#FFFFDD;"></span><span style="color:red;background-color:#DDDDEE;">Doppelklick</span></code></td>
    <td rowspan="4">Clipboard</td>
    <td width="141">Nummerierte Anzeige;Suche in der Inhalts-Zeile</td>
    <td width="124">&nbsp;</td>
    <td width="124">&nbsp;</td>
  </tr>
  <tr> 
    <td width="28">2.2</td>
    <td width="361"><code><span style="background-color:#DDFFDD;">clip://</span><span style="background-color:#FFFFDD;">&nbsp;</span><span style="background-color:#DDFFFF;">In_Row?</span><span style="background-color:#FFFFDD;">&nbsp;</span><span style="color:red;background-color:#CCCCFF;">Doppelklick</span></code></td>
    <td width="141">1:1 Anzeige; Suche in der Inhalts-Zeile</td>
    <td width="124">&nbsp;</td>
    <td width="124">&nbsp;</td>
  </tr>
  <tr> 
    <td width="28">2.3</td>
    <td width="361"><code><span style="background-color:#DDFFDD;">clip://</span><span style="background-color:#FFFFDD;">&nbsp;</span><span style="background-color:#DDFFFF;">InName?</span><span style="background-color:#FFFFDD;">&nbsp;</span><span style="color:red;background-color:#CCCCFF;">Doppelklick</span></code></td>
    <td width="141">1:1 Anzeige; Suche in der Inhalts-Zeile, wenn der als Pfad 
      interpretierbar, dann suche im Datei- oder Orner-Name</td>
    <td width="124">&nbsp;</td>
    <td width="124">&nbsp;</td>
  </tr>
  <tr> 
    <td width="28">2.4</td>
    <td width="361">2.1 bis 2.3 erstes Leerzeichen durch Tabulator ersetzt.<br>
      <code><span style="background-color:#DDFFDD;">clip://</span><span style="background-color:#FFFFDD;">&lt;Tab&gt;</span><span style="background-color:#DDFFFF;">In_Row?</span><span style="background-color:#FFFFDD;">&nbsp;</span></code> 
      <verbatim></verbatim></td>
    <td width="141">Dito aber selbst aktualisierend.</td>
    <td width="124">&nbsp;</td>
    <td width="124">als Clipboard-Text-Anzeige</td>
  </tr>
  <tr> 
    <td width="28">&nbsp;</td>
    <td width="361">&nbsp;</td>
    <td width="136">&nbsp;</td>
    <td width="141">&nbsp;</td>
    <td width="124">&nbsp;</td>
    <td width="124">&nbsp;</td>
  </tr>
  <tr> 
    <td width="28">3.1</td>
    <td width="361"><code><span style="background-color:#DDFFDD;">filP://</span><span style="background-color:#FFEEBB;">Hilfe\*</span><span style="color:red;background-color:#EEEEFF;">Live</span><span style="background-color:#FFEEBB;">*</span><span style="background-color:#BBFFDD;">,DFR</span><span style="background-color:#FFFFDD;">&nbsp;</span><span style="background-color:#DDFFFF;">Nr_Row?</span><span style="background-color:#FFFFDD;">&nbsp;</span><span style="color:red;background-color:#CCCCFF;">htm</span></code></td>
    <td rowspan="5" width="136">
      <p>Dateien / Ordner, welche dem Platzhalter-Muster <code><span style="background-color:#FFEEBB;">Pfad-Teil\*</span><span style="color:red;background-color:#EEEEFF;">Pfad-Suchbegriff</span><span style="background-color:#FFEEBB;">*</span></code> 
        entsprechen.</p>
      <p>&nbsp;</p>
      </td>
    <td width="141">Nummerierte Anzeige;<br>
      &deg; Zeige nur Pfade die zus&auml;tzlich <code><span style="color:red;background-color:#CCCCFF;">htm</span></code> 
      enthalten.</td>
    <td rowspan="5" width="124"><code><span style="color:red;background-color:#BBFFDD;">,DFR</span><span style="background-color:#FFEEBB;"></span></code> 
      beliebige Kombination der 3 Buchstaben<br>
      D=Directory (findet Ordner)<br>
      F=Files (findet Dateien)<br>
      R=Recursiv (inklusive Untrverzeichnisse)</td>
    <td rowspan="3">Suche in Multimedia Ordnern</td>
  </tr>
  <tr> 
    <td width="28">3.2</td>
    <td width="361"><code><span style="background-color:#DDFFDD;">filP://</span><span style="background-color:#FFEEBB;">Hilfe\*</span><span style="color:red;background-color:#EEEEFF;">Live</span><span style="background-color:#FFEEBB;">*</span><span style="background-color:#BBFFDD;">,DFR</span><span style="background-color:#FFFFDD;">&nbsp;</span><span style="background-color:#DDFFFF;">In_Row?</span><span style="background-color:#FFFFDD;">&nbsp;</span><span style="color:red;background-color:#CCCCFF;">htm</span></code></td>
    <td width="141">1:1 Anzeige; &deg;</td>
  </tr>
  <tr> 
    <td width="28">3.3</td>
    <td width="361"><code><span style="background-color:#DDFFDD;">filP://</span><span style="background-color:#FFEEBB;">Hilfe\*</span><span style="color:red;background-color:#EEEEFF;">Live</span><span style="background-color:#FFEEBB;">*</span><span style="background-color:#BBFFDD;">,DFR</span><span style="background-color:#FFFFDD;">&nbsp;</span><span style="background-color:#DDFFFF;">NrRRex?</span><span style="background-color:#FFFFDD;">&nbsp;</span><span style="color:red;background-color:#CCCCFF;">htm</span></code></td>
    <td width="141">1:1 Anzeige; &deg; jedoch RegEx-Suche im Pfad</td>
  </tr>
  <tr> 
    <td width="28">3.4</td>
    <td width="361"><code><span style="background-color:#DDFFDD;">filP://</span><span style="background-color:#FFEEBB;">Hilfe\*</span><span style="color:red;background-color:#EEEEFF;">Live</span><span style="background-color:#FFEEBB;">*</span><span style="background-color:#BBFFDD;">,F</span><span style="background-color:#FFFFDD;">&nbsp;</span><span style="background-color:#DDFFFF;">In_Inh?</span><span style="background-color:#FFFFDD;">&nbsp;</span><span style="color:red;background-color:#CCCCFF;">html</span></code></td>
    <td width="141">1:1 Anzeige; Zeige nur Inhalts-Zeilen die <code><span style="color:red;background-color:#CCCCFF;">html</span></code> 
      enthalten.</td>
    <td rowspan="2">Suche von Telefonnummern in Kontakt-Dateien; Suche nach schonmal 
      verwendeten Befehlen in alten Skript-Dateien.; <a href="#HilfeDateien">Hilfe-Dateien</a></td>
  </tr>
  <tr> 
    <td width="28">3.5</td>
    <td width="361"><code><span style="background-color:#DDFFDD;">filP://</span><span style="background-color:#FFEEBB;">Hilfe\*</span><span style="color:red;background-color:#EEEEFF;">Live</span><span style="background-color:#FFEEBB;">*</span><span style="background-color:#BBFFDD;">,F</span><span style="background-color:#FFFFDD;">&nbsp;</span><span style="background-color:#DDFFFF;">Nr_Inh?</span><span style="background-color:#FFFFDD;">&nbsp;</span><span style="color:red;background-color:#CCCCFF;">html</span></code></td>
    <td width="141">Nummerierte Anzeige; Zeige nur Inhalts-Zeilen die <code><span style="color:red;background-color:#CCCCFF;">html</span></code> 
      enthalten.</td>
  </tr>
  <tr> 
    <td width="28">&nbsp;</td>
    <td width="361">wegen Platzmangels wurden in 3.1 bis 3.5 relative Pfade in den Filepattern verwendet</td>
    <td width="136">&nbsp;</td>
    <td width="141">&nbsp;</td>
    <td width="124">&nbsp;</td>
    <td width="124">&nbsp;</td>
  </tr>
  <tr> 
    <td width="28">4.1</td>
    <td width="361"><code><span style="background-color:#DDFFDD;">CoTe://</span><span style="background-color:#DDFFFF;">WTitle?</span><span style="background-color:#FFFFDD;">&nbsp;</span><span style="background-color:#FFFFDD;"></span><span style="background-color:#FFDDDD;">ahk_class 
      SciTEWindow</span><span style="background-color:#FFFFDD;">&nbsp;</span><span style="background-color:#FFFFDD;"></span><span style="background-color:#DDFFFF;">Contro?</span><span style="background-color:#FFFFDD;">&nbsp;</span><span style="background-color:#FFDDDD;">Scintilla1</span><span style="background-color:#FFFFDD;"></span><span style="background-color:#FFFFDD;">&nbsp;</span><span style="background-color:#DDFFFF;">Nr_Row?</span><span style="background-color:#FFFFDD;">&nbsp;</span><span style="color:red;background-color:#CCCCFF;">html</span></code></td>
    <td rowspan="2" width="136">
      <p>Textfelder (anderer) Fenster.</p>
      <p>Hier Scite-Editor</p>
    </td>
    <td width="141">Nummerierte Anzeige; Suche im vom Control abrufbaren Text</td>
    <td width="124">&nbsp;</td>
    <td rowspan="2">Variablen + Inhalte von AHK gefiltert anzeigen (Siehe ZZO 
      | Hauptmenu | ? | Variablen anzeigen).<br>
      Dito durchlaufene Zeilennummern.</td>
  </tr>
  <tr> 
    <td width="28" height="126">4.2</td>
    <td width="361" height="126"><code><span style="background-color:#DDFFDD;">CoTe://</span><span style="background-color:#DDFFFF;">WTitle?</span><span style="background-color:#FFFFDD;">&nbsp;</span><span style="background-color:#FFDDDD;">ahk_class 
      SciTEWindow</span><span style="background-color:#FFFFDD;">&nbsp;</span><span style="background-color:#DDFFFF;">Contro?</span><span style="background-color:#FFFFDD;">&nbsp;</span><span style="background-color:#FFDDDD;">Scintilla1</span><span style="background-color:#FFFFDD;">&nbsp;</span><span style="background-color:#DDFFFF;">In_Row?</span><span style="background-color:#FFFFDD;">&nbsp;</span><span style="color:red;background-color:#CCCCFF;">html</span></code></td>
    <td width="141" height="126">1:1 Anzeige; Suche im vom Control abrufbaren 
      Text</td>
    <td width="124" height="126">&nbsp;</td>
  </tr>
</table>
<p><a name="HilfeDateien"></a>Um Hilfe-Dateien mit ZZO betrachten zu k&ouml;nnen 
  m&uuml;ssen sie vorher</p>
<ul>
  <li>umbenannt nach <samp>.zip</samp> </li>
  <li>und entpackt</li>
</ul>
<p>werden. Den entstehenden HTML-Ordner kann man dann mit 3.4 oder 3.5 durchsuchen. 
  Es lassen sich dann auch Zeichenketten wie z.B.<br>
  %1%&nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &lt;=&nbsp; &nbsp; &nbsp; 
  &nbsp; &nbsp; &nbsp; &nbsp; *&nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; 
  ?<br>
  suchen, die von der Hilfesuche nicht unterst&uuml;tzt weren.</p>
<h2>Alternativen</h2>
<p>1.2 entspricht etwa folgender Powershell-Suche, <font size="-1">dort ohne Direkt-Sprung-M&ouml;glichkeit 
  in den Editor-Scite (oder -Notepad) in die Fundzeile mit markiertem Suchbegriff 
  ( Hier <code><samp><code><span style="color:red;background-color:#CCCCFF;">Doppelklick</span></code></samp></code></font><code>).<br>
  </code> <samp>Select-String -Path &quot;C:\Program Files (x86)\ZackZackOrdner\<code><span style="background-color:#FFDDDD;">SchnellOrdner.ahk</span></code>&quot; 
  &quot;<code><span style="color:red;background-color:#CCCCFF;">Doppelklick</span></code>&quot; 
  -EA SilentlyContinue</samp> 
<p>3.4 entspricht etwa folgender Powershell-Suche<br>
  <samp>Select-String -Path &quot;C:\Program Files (x86)\ZackZackOrdner\<code><span style="background-color:#FFEEBB;">Hilfe\*</span><span style="color:red;background-color:#EEEEFF;">Live</span><span style="background-color:#FFEEBB;">*</span></code>&quot; 
  -Pattern &quot;<code><span style="color:red;background-color:#CCCCFF;">html</span></code>&quot; 
  -EA SilentlyContinue</samp> <br>
  Hinweis: Hier und bei 3.5 ist die Direkt-Sprung-M&ouml;glichkeit in den Editor-Scite 
  in ZZO noch nicht [Version0.522] implementiert.
</body>
</html>

