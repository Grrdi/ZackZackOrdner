; Danke nnnik	https://autohotkey.com/boards/viewtopic.php?f=7&t=41332 ;{
; Danke	Beteiligte	https://autohotkey.com/board/topic/64563-basic-ahk-v11-com-tutorial-for-webpages/
; Danke	Glines	http://the-automator.com/tag/web-scraping-intro-with-autohotkey/
; Danke justme	ohne den ich nicht so weit gekommen waere
; https://msdn.microsoft.com/en-us/library/aa752084(v=vs.85).aspx
; HTML Befehlsuebersicht	http://www.webhinweis.de/html/html_tabelle.html	
; Danke IsNull	OOP Einfuehrung in deutsch	http://ahkscript.org/germans/forums/viewtopic.php?t=7884
; https://ahkde.github.io/docs/commands/ComObjQuery.htm
; Mein erster ernsthafter Versuch, der Erstellung einer eigenen Class
;}	
; Man definiert mit Klassen, wie Objekte (Instanzen von Klassen) ausschauen, welche Daten sie enthalten und welche Methoden (Funktionalität) sie anbieten.
; z.B.:             wBr                   S1                                        S1.WinHwnd                               S1.getUrl()
; "this". This beinhalted immer eine Referenz zur aktuellen Objekt-Instanz. 
; __New([params]). ist der Klassen Konstruktor 
; static Variablen sind in allen Instanzen gleich
class wBr {
	static instances := 0		; die nackte Var "instances" ist ohne fuehrende "Obj-Var." nicht sichtbar in der __New() Funktion.
	ErstellZeit:=A_Now		; die nackte Var "ErstellZeit" ist ohne fuehrende "Obj-Var." nicht sichtbar in der __New() Funktion.
	__New( WbName ) {
		this.name := WbName
		if(WbName="IE_"){	; Wenn der New wb(Uebergabe-Parameter) exakt "IE_" enthaelt, dann wird das zuletzt benutzte IE_Reiter-Fenster uebernommen.
			this.Com := this.WBGet()
			this.WinHwnd:=this.Com.HWND
			wBr.instances++
			this.instanceNr:=wBr.instances
			this.erstellZeit:=this.ErstellZeit
		}
		else if (SubStr(WbName,1,3)="IE_")	; Wenn der New wb(Uebergabe-Parameter) mit "IE_" beginnt, dann wird ein neues IE_Reiter-Fenster erstellt.
		{
			this.Com := ComObjCreate("InternetExplorer.Application")
			Sleep 300
			this.WinHwnd:=this.Com.HWND
			wBr.instances++
			this.instanceNr:=this.base.instances
			this.instanceNr:=wBr.instances		; this.instanceNr:=this.instances  oder  this.instanceNr:=this.base.instances  haetten zum selben Ergebnis gefuehrt.	instances alleine wird wie nicht existent behandelt.
			this.erstellZeit:=this.ErstellZeit
		}
		else		;  Wenn der New wb(Uebergabe-Parameter) nicht mit "IE_" beginnt, dann ... --> Reserviert fuer andere Browser
		{
			Ae1Browser_Ae2RestName:=StrSplit(WbName,"_")
			if ((Ae1Browser_Ae2RestName.MaxIndex() < 2) OR (Ae1Browser_Ae2RestName[1] <> "IE"))
				MsgBox,0,% A_LineFile "[" A_LineNumber "]",%  "Uebergabe-Parameter >" WbName "< nicht unterstuetzt. `n`nIE_`nIE_...`nerwartet. `n`nBrowser  >" Ae1Browser_Ae2RestName[1] "<   noch nicht unterstuetzt!",10
			return false
		}
		this.OnError:={Exit: False}
	}
	__Delete() {
		ExitThreadOnClose:=false
		if this.OnError.Exit
			ExitThreadOnClose:=true
		if IsObject(this.Com)
		{
			try
				this.Com.Quit()    ; bringt keine Fehlermeldung, ich sehe aber die Wirkung im TaskManager. Danke nnnik
		}
		if ExitThreadOnClose
			Exit
    }
	getUrl() {
		try
			return this.com.LocationURL ;grab current url
		catch
			this.ifOnErrorDoExit(this.OnError.Exit)
	}
	getUrlAfterQuestionMark() {
		try
			return this.com.document.location.Search ; gets substring of URL following question mark
		catch
			this.ifOnErrorDoExit(this.OnError.Exit)
	}
	getUrlPort() {
		try
			return this.com.document.location.port
		catch
			this.ifOnErrorDoExit(this.OnError.Exit)
	}
	getUrlPathname() {		
		try
			return this.com.document.location.pathname ; returns pathname
		catch
			this.ifOnErrorDoExit(this.OnError.Exit)
	}
	getLocationName() {
		try
			return this.com.LocationName ; grab page Titlerite
		catch
			this.ifOnErrorDoExit(this.OnError.Exit)
	}
	getUrlHostName() {
		try
			return this.com.document.location.hostname ; returns host
		catch
			this.ifOnErrorDoExit(this.OnError.Exit)
	}
	getUrlAfterHash() {
		try
			return this.com.document.location.hash ; retreives everyting from the # on
		catch
			this.ifOnErrorDoExit(this.OnError.Exit)
	}
	getUserAgent() {
		try
			return this.com.document.parentWindow.navigator.userAgent ; Get User Agent
		catch
			this.ifOnErrorDoExit(this.OnError.Exit)
	}
	getSourceCode(){
		try{
			SourceCode := this.com.document.documentElement.innerHtml
			this.NotBusy()
			return SourceCode
		}
		catch
			this.ifOnErrorDoExit(this.OnError.Exit)
	}
	getAllText(){
		try{
			AllText:=this.com.document.documentElement.innerText ; Get All text on page
			this.NotBusy()
			return AllText
		}
		catch
			this.ifOnErrorDoExit(this.OnError.Exit)
	}
	getUrlProtocol(){
		try
			return this.com.document.location.protocol ; retreives the protocol (http, https, etc)
		catch
			this.ifOnErrorDoExit(this.OnError.Exit)
	}
	getWinHwnd() {
		return this.WinHwnd
	}
	getIeControlHwnd() {
		MsgBox Implementierung gesucht
	}
	DuplicateTab() { ; -> ^k
		Sleep 1000
		this.NotBusy()
		WinHwnd := this.WinHwnd
		if (WinHwnd="" OR WinHwnd=0)
			SoundBeep 500
		WinActivate,ahk_id %WinHwnd%
		WinWaitActive,ahk_id %WinHwnd%,,1
		sleep 300
		ControlFocus,,ahk_id %WinHwnd%
		sleep 300
		ControlSend,,^k,ahk_id %WinHwnd%
		Sleep 1000
		this.NotBusy()
		Sleep 1000
	}
	refresh() {
		try{
			this.com.refresh ;Reload page
			this.NotBusy()
			return
		}
		catch
			this.ifOnErrorDoExit(this.OnError.Exit)
	}
	getAllLinks(){
		try{
			Links := this.Com.Document.Links ; collection of hyperlinks on the page
			Loop % Links.Length ; Loop through links
				If ((Link := Links[A_Index-1].InnerText) != "") { ; if the link is not blank
					(OuterHTML := Links[A_Index-1].OuterHTML)  ; Grab outerHTML for each link
					Link:=StrReplace(Link,"`n")
					Link:=StrReplace(Link,"`r")
					Link:=StrReplace(Link,"`t")
					OuterHTML:=StrReplace(OuterHTML,"`n")
					OuterHTML:=StrReplace(OuterHTML,"`r")
					OuterHTML:=StrReplace(OuterHTML,"`t")
					Msg .= A_Index-1 A_Space A_Space A_Space Link A_Tab OuterHTML "`r`n" ; add items to the msg list
				}
			this.NotBusy()
			return Msg
		}
		catch
			this.ifOnErrorDoExit(this.OnError.Exit)
	}
	getParent(Obj,Tiefe="6") {
									; this.Com.document.getElementsByTagName(TagP)[0].getElementsByTagName(Tag)[0]...  ergibt auch eine Vater-Beziehung 
		; ParentKnoten:={}
		ParentKnoten:=Obj
		Loop, % Tiefe {
			; MsgBox % ParentKnoten.OuterHTML
			; Probe:=ParentKnoten.innerHtml
			; MsgBox % Probe
			if(SubStr(Probe,1,5)="<head" OR SubStr(ParentKnoten.OuterHTML,1,5)="<body")
			{
				return ParentKnoten
			}
			ParentKnoten:=ParentKnoten.ParentNode
		}
		return ParentKnoten
	}
	getParents(Obj,Tiefe="30",quick="1") {
		Parents:={}
		ParentKnoten:=Obj
		ParentTagName:=ParentKnoten.TagName
		if(ParentTagName="html" OR ParentTagName="")
			return
		ParentAnz:=0
		Loop, % Tiefe {
			; MsgBox % ParentKnoten.OuterHTML
			ParentKnoten:=ParentKnoten.ParentNode
			ParentTagName:=ParentKnoten.TagName
			ParentPath:=ParentTagName "/" ParentPath
			++ParentAnz
			ParentVersatzt.= "."
			if(ParentTagName="html")
			{
				break
			}
		}
		if quick
			return ParentPath
		else
		{
			Parents.ParentPath:=ParentPath
			Parents.ParentVersatzt:=ParentVersatzt
			Parents.ParentAnz:=ParentAnz
			return Parents
		}
	}
	ElementFilter(Obj,FilterName="",Filter="",INr="0") {
									; this.Com.document.getElementsByTagName(TagP)[0].getElementsByTagName(Tag)[0]...  ergibt auch eine Vater-Beziehung 
		Knoten:=Obj
		if (FilterName="Tag")
		{
			if(INr="free")
				Knoten:=Knoten.getElementsByTagName(Filter)
			else
				Knoten:=Knoten.getElementsByTagName(Filter)[INr]
		}
		else if (FilterName="ID")
			Knoten:=Knoten.getElementByID(Filter)
		else if (FilterName="") {
		}
		else
		{
			MsgBox,0,% A_LineFile "[" A_LineNumber "]",Der Element-Filter %FilterName% wird noch nicht unterstuetzt.`nUnterstuetzte Filter:`nID,20
			return false
		}
		return Knoten
	}
	GetElementsHtmlByTagName(Tag="",ParentTiefe="",quick="1",MaxFundZeien="50000"){
		short:=false					; IeEx://divin_Row? ¬<html`n¬<head`n¬<body
		long:=false
		TagChar1 := SubStr(Tag,1,1)
		if(TagChar1="-")
		{
			short:=true
			StringTrimLeft,Tag,Tag,1
		}
		else if(TagChar1="+")
		{
			long:=true
			StringTrimLeft,Tag,Tag,1
		}
		if (Tag="")
			Tag:= "*"
		this.Element:={}
		F := 0
		FEnd := false
		FBreak := false
		Alle := this.Com.document.getElementsByTagName(Tag)
		Anz:=Alle.Length
		Loop % Anz
		{
			TagIndex:=A_Index - 1
try
				Parents := this.getParents(Alle[TagIndex])
catch
{
	; moegliche Ursache: Zugriff verweigert
	continue
}

			if quick
			{
				if(F > MaxFundZeien)
				{
					FBreak := true
					break
				}

				if short
				{
					ParentPathElementsText .= TagIndex A_Space Parents . "   " . "<" Alle[TagIndex].TagName . ">`r`n"
					++F
				}
				else if long
				{
					; TagA:=Alle[TagIndex].OuterHTML
					ParentPathElementsText .= TagIndex A_Space Parents . "   " . StrReplace(StrReplace(Alle[TagIndex].OuterHTML,"`n",A_Space,All),"`t",A_Space,All) . "`r`n"
					++F
				}
				else
				{
					ParentPathElementsText .= TagIndex A_Space Parents . A_Tab . "<" Alle[TagIndex].TagName . ">" . A_Tab . StrReplace(StrReplace(Alle[TagIndex].outerText,"`n",A_Space,All),"`t",A_Space,All)  . "`r`n"
					++F
				}
			}
			else
			{
				this.Element[TagIndex]:={}
				if long
				{
					this.Element[TagIndex].outerHtml := {}
					this.Element[TagIndex].outerHtml := Alle[TagIndex].OuterHTML
				}
				else if short
				{
					this.Element[TagIndex].TagName := {}
					this.Element[TagIndex].TagName := "<" Alle[TagIndex].TagName . ">"
				}
				else
				{
					this.Element[TagIndex].innerText := {}
					this.Element[TagIndex].innerText := Alle[TagIndex].innerText
				}
				this.Element[TagIndex].ParentPath := {}
				this.Element[TagIndex].ParentPath := Parents
			}
		}
		if quick
		{
			if NOT FBreak			; wenn letzte Zeile leer, dann wurde abgebrochen!
				StringTrimRight,ParentPathElementsText,ParentPathElementsText,2
			return ParentPathElementsText
		}
;		this.ParentPathElementsText := ParentPathElementsText
		return  this.Element
	}
	GetSetOneOfAllTags(getElementsBy="",Suchliste="",NachDot="",InKlammenValue="KlammerLos",setValue="",TagIndexVorrang=""){			; Universal-Methode
; 		try	; Parameter 1 = Tag-Filer	2 = QuellTextSuchWoerter-Pipe|getrennt	3 = Aktion mit gefundenem Element	4 = KlammerInhalt	5 = Leer fuer get's	5 = Value fuer set's
		{	;	z.B.	"input"			"Anmelden|Button"						"click"								""					""
			; 			"a"				"Das sind Ihre Vorteile"				"click"								""
			;					 		"LoginLink|Anmelden|Anmelden|Button"	"outerHtml"
			;																	"innerText"
			; wenn tags und Tag-Inhalte gleich sind, kann man versuchen einen Suchbegriff des zugehoerigen Elternknoten in die Suchliste hinzu zu fuegen.
			; dieeser wird jedoch nur wirksam wenn es einen Suchbegriff links angrenzend davon gibt der im Tag Inhalt zu finden ist. Beispiel:
			; 			"+cite",		"nnnik|OOP",							"outerHtml"
			; das + vor cite ist bei der Einrichtung hilfreich. Es werden Tags + Eltern zum Blaettern angezeigt, und die betreffende Stelle in den sichtbaren Bereich gebracht.
			; 			"cite",			"nnnik|OOP",							"scrollIntoView",					""
			; 
			; das Not Zeichen ¬ erreichbar via Alt-Down 0172 Alt-Up, sorgt fuer eine Sortierung nach unten. Ein alleinstehender Begriff mit fuerendem ¬ wird nicht unterstuetzt. Beispiel: 
			;							AnkerKette|Kette|Edelstahl|¬Schmuck|¬Halskette
			; fuer technische Ketten.
			; return	this.Com.document.getElementsByTagName("h3")[0].outerHtml  "`n" this.Com.document.getElementByID("p193153").getElementsByTagName("h3")[0].outerHtml "`n"
			; return	 this.Com.document.getElementByID("p188368").getElementsByTagName("cite")[0].outerHtml "`n"this.Com.document.getElementsByTagName("cite")[0].outerHtml "`n"
			if (SubStr(getElementsBy,1,1)="+") {								;	"" -> getEl2[1]		ID -> getEl2[2]		"Tag" -> getEl1[1]	Tag -> getEl1[2]
				Info:=true 
				getElementsBy:=SubStr(getElementsBy,2)
			}
			B:={}
			if (InStr(getElementsBy,"/"))
			{											; +ID=a4711/Tag=div
				getElZu := StrSplit(getElementsBy,"/")
				Loop % getElZu.MaxIndex()
				{
					getEl%A_Index% := StrSplit(getElZu[A_Index],"=")
					
				}
			}
			else
			{
				if (getElementsBy="")
					getElementsBy:= "*"
				if (InStr(getElementsBy,"="))
				{											; +ID=a4711/Tag=div
					getEl := StrSplit(getElementsBy,"=")
					getE2[1] := 	, getE2[2] :=
				}
				else
				{
					getEl1:={}			, getEl2:={}
					getEl1[1] :=  		, getEl1[2] := 
					getEl2[1] := "Tag"	, getEl2[2] := getElementsBy
				}
			}
			if (INr="")
				INr:="free"
			Loop 2
			{
				if (getE%A_Index%[1]="ID")
					INr:="free"
				else if (getE%A_Index%[1]="Tag"){
					if (TagIndexVorrang="")
						INr:="free"
					else
						INr:=TagIndexVorrang
				}
			}
			Alle := this.Com.document
			Loop 2
				ElementFilter(Alle,getEl%A_Index%[1],getEl%A_Index%[2],INr)
			try
				Anz:=Alle.Length

			gesAnz:=0
			indexFuerGes:=-1
			if (Suchliste="")
				AddKor:=0.01
			else
				AddKor:=0
			Loop % Anz { ; Loop through Tags
				TagIndex:=A_Index - 1
			try
				All := Alle[TagIndex].OuterHTML
				If ((All) != "") { ; if the Tag is not blank
					Funde:=0
					PlusMinus1:=1
					SuchStr:=StrSplit(Suchliste,"|")
					SuchWortAnz:=SuchStr.MaxIndex()
					if (SuchWortAnz="")
						SuchWortAnz=0
					ParentMulti:=1
					loop % SuchWortAnz {
						PlusMinus1:=1
						if(SubStr(SuchStr[A_Index],1,1)="¬") {
							SuchStr[A_Index]:=SubStr(SuchStr[A_Index],2)
							PlusMinus1:=-10
						}
						Funstellen:=StrSplit(All,SuchStr[A_Index])
						Funde+=(Funstellen.MaxIndex() -1) ; * PlusMinus1
					}
					if (Strlen(All)<15000 AND (Funde OR Suchliste="")) {
						ges .= ((PlusMinus1 * Funde * Funde + AddKor)*(ParentMulti)/Strlen(All))  / (SuchWortAnz ) . A_Tab . TagIndex . A_Tab . StrLen(All) "`n" ; Falls die Bewertungen hier nicht direkt zum gewuenschten Element fuerhren, kann auch mit mehrfach-Nennung eines Suchbegriffes, zu dessen Gunsten beeinflusst werden.
						B[TagIndex] :=all
						++gesAnz
					}
				}
			}
			this.Elements := B
			StringTrimRight,ges,ges,1
			sort,ges, N  R			; nach Bewertung sortieren
			Loop,Parse,ges,`n
			{
				FuerTagIndex:=StrSplit(A_LoopField,A_Tab)		; best bewerteten Index holen
				break
			}
			DieserTagIndex:=FuerTagIndex[2] ; -1			; Index auf basis 0 korrigieren
			IndexOfBest:=DieserTagIndex
			; MsgBox %DieserTagIndex%`n%ges%
			if Info
			{									;	"" -> getEl2[1]		ID -> getEl2[2]		"Tag" -> getEl1[1]	Tag -> getEl1[2]
				IfExist,%A_Temp%\wb_ges.txt				
					FileDelete,%A_Temp%\wb_ges.txt
				FileAppend,%ges%,%A_Temp%\wb_ges.txt
				BlaetternRunter:=true
				Loop{
					if (i="")
						i:=1
					FileReadLine,ges_Line,%A_Temp%\wb_ges.txt,i
					FuerTagIndex:=StrSplit(ges_Line,A_Tab)	
					DieserAnsichtTagIndex:=FuerTagIndex[2] ; -1			; Index auf basis 0 korrigieren
					; this.Com.document.getElementsByTagName(Tag)[DieserAnsichtTagIndex].scrollIntoView()		; in den sichtbaren Bereich damit
					; this.Com.document.getElementsByTagName(Tag)[DieserAnsichtTagIndex].selectext()		; this.Com.ExecWB(selectAll:=17) this.Com.ExecWB(17,0) wuerde alles Selektieren, 18 entfernt die Selection		http://www.programering.com/a/MzM3UDNwATc.html)
					temp := this.Com.document
						ElementFilter(temp,getEl1[1],getEl1[2])
						tempZwischen := temp
						ElementFilter(temp,getEl2[1],getEl2[2],DieserAnsichtTagIndex)
						tempEnde:=temp
					if info
					{
						tempEnde.parentNode.scrollIntoView()		; in den sichtbaren Bereich damit
						; ControlGetFocus, Steuerelement, A
						WinActivate,% "ahk_id " this.WinHwnd
						WinWaitActive,% "ahk_id " this.WinHwnd,,1
						; Eine Zeile nach unten scrollen:
						ControlGetFocus, Steuerelement, A
						SendMessage, 0x115, 0, 0, %Steuerelement%, A
						SendMessage, 0x115, 0, 0, %Steuerelement%, A

						Loop 7
						SendMessage, 0x115, 0, 0, , % "ahk_id " this.WinHwnd
						Wert:=tempEnde.outerHtml 
						tempEnde.outerHtml := "<mark>" Wert "</mark>"
					}
					TagAnzeige := temp.outerHtml
					try
						All := tempZwischen.OuterHTML
					All_Anzeige := A_Tab SubStr(StrReplace(StrReplace(All,"`n",A_Space,All),"`t",A_Space,All),1,1500)
					gesAnzeige:=StrReplace(ges,A_Tab DieserAnsichtTagIndex A_Tab,A_Tab "#" DieserAnsichtTagIndex "#" A_Tab,markiert)
					if (NOT markiert)
						break		; wenn index nicht vorhanden, d.h. oberes oder uteres Ende erreicht.
					Anzeige= % i	A_Tab	All_Anzeige "`n`nTag	Suchliste`n" getEl1[2] A_Tab	Suchliste "`n`n" TagAnzeige "`n`nBew.	index	Len`n`n" gesAnzeige
					; Anzeige= %i%	%All_Anzeige% `n`nTag	Suchliste`n%Tag%	%Suchliste%`n`n%TagAnzeige% `n`nBew.	index	Len`n`n%gesAnzeige%
					if BlaetternRunter
						MsgBox,8195 , Blättern, % "Element tiefer ansehen	Ja	höher	Nein`n`n" Anzeige "`n`n"	;	GetObjectDetails(B,"B")
					else
						MsgBox,8451 , Blättern, % "Element tiefer ansehen	Ja	höher	Nein`n`n" Anzeige "`n`n"	; 	GetObjectDetails(B,"B")

					IfMsgBox,Yes
					{
						++i
						if (i>gesAnz)
							break
						BlaetternRunter:=true
					}
					else IfMsgBox,No
					{
						--i
						if (i<1)
							break
						BlaetternRunter:=false
					}
					else
						break
				}
			}
			if(TagIndexVorrang<>"")
				DieserTagIndex := TagIndexVorrang
			else
			DieserTagIndex := IndexOfBest
			if (InKlammenValue="KlammerLos")
			{
				; InKlammenValue:=
				if (setValue="")
				{
					temp2 := this.Com.document
						ElementFilter(temp2,getEl1[1],getEl1[2],DieserTagIndex)
						ElementFilter(temp2,getEl2[1],getEl2[2],DieserTagIndex,NachDot)
				}
				else
				{
					temp2 := this.Com.document
						ElementFilter(temp2,getEl1[1],getEl1[2],DieserTagIndex)
						ElementFilter(temp2,getEl2[1],getEl2[2],DieserTagIndex,NachDot,,setValue) ; := setValue
				}
			}
			else
			{
				if (setValue="")
				{
					temp2 := this.Com.document
						ElementFilter(temp2,getEl1[1],getEl1[2],DieserTagIndex)
						ElementFilter(temp2,getEl2[1],getEl2[2],DieserTagIndex,NachDot,InKlammenValue)
				}
				else
				{
					temp2 := this.Com.document
						ElementFilter(temp2,getEl1[1],getEl1[2],DieserTagIndex)
						ElementFilter(temp2,getEl2[1],getEl2[2],DieserTagIndex,NachDot,InKlammenValue,setValue) ; := setValue				
				}			; ElementFilter(ByRef Knoten,FilterName="",Filter="",INr="",TagIndex="",NachDot="",InKlammenValue="") 
			}
		}
		return temp2
	}
	FocusClick(ID:="",Name:="",ClassName:="",TagName:=""){
		try{
			Dashes:=false
			if ID contains -,_,¯
				Dashes:=true
			if (ID<>"")
			{
				if Dashes
					this.Com.document.getElementByID(ID).focus() ; Acts like clicking the link
				else
					this.Com.document.all[ID].focus()
				this.NotBusy()
				if Dashes
					this.Com.document.getElementByID(ID).click() ; Acts like clicking the link
				else
					this.Com.document.all[ID].click()
				this.NotBusy()
			}
			if (Name<>"")
			{
				this.Com.document.GetElementsByName(Name)[0].focus()
				this.NotBusy()
				this.Com.document.GetElementsByName(Name)[0].click()
				this.NotBusy()
			}
			if (ClassName<>"")
			{
				try
					this.Com.document.GetElementsByName(ClassName)[0].focus()
				this.NotBusy()
				try
					this.Com.document.GetElementsByName(ClassName)[0].click()
				this.NotBusy()
			}
			if (TagName<>"")
			{
				this.Com.document.GetElementsByName(TagName)[0].focus()
				this.NotBusy()
				this.Com.document.GetElementsByName(TagName)[0].click()
				this.NotBusy()
			}
			; this.NotBusy()
		}
		catch
			this.ifOnErrorDoExit(this.OnError.Exit)
	}
	FeldEintrag(SuchString,ID:="",Name:="",ClassName:="",TagName:="")	{
		try
		{
			SuchStringProbe:=this.Com.document.getElementByID(ID).Value ;Unique ID-with dashes	; Existiert die ID
			this.Com.document.getElementByID(ID).Value :=SuchString ;Unique ID-with dashes		; Wert eintragen
			this.NotBusy()
			SuchStringProbe:=this.Com.document.getElementByID(ID).Value ;Unique ID-with dashes	; eingetragenen Wet fuer Probe auslesen
		}
		if (SuchStringProbe=SuchString)
			Erfolreich.="ID = " ID
		else
		{
			Loop 100 {
				NullIndex:=A_Index-1
				try{
					; MsgBox %ID% nicht gefunden
					SuchStringProbe:=this.Com.document.GetElementsByName(Name)[NullIndex].Value ;Object Name- Get array value
					this.Com.document.GetElementsByName(Name)[NullIndex].Value := SuchString
					this.NotBusy()
					SuchStringProbe:=this.Com.document.GetElementsByName(Name)[NullIndex].Value ;Object Name- Get array value
					; MsgBox %SuchStringProbe%
					if (SuchStringProbe=SuchString)
					{
						; MsgBox % NullIndex "	" SuchStringProbe
						break
					}
				}
			}
			if (SuchStringProbe=SuchString)
				Erfolreich.="Name[" NullIndex "] = " Name
			else
			{
				Loop 100 {
					NullIndex:=A_Index-1
					try{
						SuchStringProbe:=this.Com.document.getElementsByClassName(ClassName)[NullIndex].Value ;Get classname and Array value
						this.Com.document.getElementsByClassName(ClassName)[NullIndex].Value := SuchString
						this.NotBusy()
						SuchStringProbe:=this.Com.document.getElementsByClassName(ClassName)[NullIndex].Value ;Get classname and Array value
						if (SuchStringProbe=SuchString)
						{
							break
						}
					}
				}
				if (SuchStringProbe=SuchString)
					Erfolreich.="ClassName[" NullIndex "] = " ClassName
				else
				{
					Loop 100 {
						NullIndex:=A_Index-1
						try{
							SuchStringProbe:=this.Com.document.GetElementsByTagName(TagName)[NullIndex].Value ;Get Tagname and Array value
							this.Com.document.GetElementsByTagName(TagName)[NullIndex].Value := SuchString
							this.NotBusy()
							SuchStringProbe:=this.Com.document.GetElementsByTagName(TagName)[NullIndex].Value ;Get Tagname and Array value
							if (SuchStringProbe=SuchString)
								break
						}
					}
					if (SuchStringProbe=SuchString)
						Erfolreich.="TagName[" NullIndex "] = " TagName
					else
					{
						; MsgBox Der Text konnte nicht ins Feld eingetragen werden.
						Erfolreich:=false
					}
				}
			}
		}
		this.NotBusy()
		if Erfolreich
			return Erfolreich
		else
			this.ifOnErrorDoExit(this.OnError.Exit)			
	}
	Visible(flag:=true){
		try
			this.Com.Visible := flag	
			; this.NotBusy() ; Achtung, darf nicht rein. Ohne visible kein busy-Ende !!!!!!!!!!!!!!!!!!
		catch
			this.ifOnErrorDoExit(this.OnError.Exit)
	}
	Navigate(Url){
		try{
			this.Com.Navigate(Url)
			this.NotBusy()
		}
		catch
			this.ifOnErrorDoExit(this.OnError.Exit)
	}
	setOnErrorExit(Flag=0){
		this.OnError.Exit := Flag
		if Flag
			Critical,Off
	}
	History(Number){
		try{
			this.Com.document.parentWindow.history.go(Number) ; if Number is negativ Go Backward one page
			this.NotBusy()
		}
		catch
			this.ifOnErrorDoExit(this.OnError.Exit)
	}
	HistoryLen(){
		try
			return this.Com.document.parentWindow.history.length	
		catch
			this.ifOnErrorDoExit(this.OnError.Exit)
	}
	Help(Methode){
		if(Methode="")
			return "geplant:	wb-Class-Hilfe + Liste aller Methoden + Beschreibungen"
		else
			return "geplant:	Liste aller Methoden + Beschreibungen, gefiltert nach >" Methode "<"
	}
	NotBusy(){
		try{
			while this.Com.busy or this.Com.ReadyState != 4	
				Sleep 10	
		}
		catch
			this.ifOnErrorDoExit(this.OnError.Exit)
	}
 	CloseTab(force=1) {		; wirkung wie WebBroserObjekt := "" 	bei 1 ohne Rueckfrage
		if force
		{		; Rueckfrage wird 8 Zeilen weiter unten mit ja beantwortet.
			SchliessenBestaetigenAhk=
(
WinWaitActive,Windows Internet Explorer ahk_class #32770,,1
ControlClick,Button1,Windows Internet Explorer ahk_class #32770
)
			FileDelete,%A_Temp%\SB.ahk
			FileAppend,%SchliessenBestaetigenAhk%,%A_Temp%\SB.ahk
			Run %A_Temp%\SB.ahk
		}
		sleep 20
		try{
			this.Com.document.parentWindow.window.Close()		; Reiter Schliessen mit Rueckfrage
		}
		catch
			this.ifOnErrorDoExit(this.OnError.Exit)
	}
	ifOnErrorDoExit(Flag){	; Diese Funktion hier ist nur fuer den Class-internen Aufruf vorgesehen.
		if this.OnError.Exit{
			if IsObject(this.Com){
				try
					this.Com.Quit()		; auch IE.exe beenden
			}
			Exit					; aktuellen Thread beenden
		}
	}
	; Folgende Funktion (danke Glines) ist hier fuer den Class-internen Aufruf vorgesehen.
		;************Pointer to Open IE Window******************
	WBGet(WinTitle="ahk_class IEFrame", Svr#=1) {               ;// based on ComObjQuery docs
	   static msg := DllCall("RegisterWindowMessage", "str", "WM_HTML_GETOBJECT")
			, IID := "{0002DF05-0000-0000-C000-000000000046}"   ;// IID_IWebBrowserApp
	;//     , IID := "{332C4427-26CB-11D0-B483-00C04FD90119}"   ;// IID_IHTMLWindow2
	   SendMessage msg, 0, 0, Internet Explorer_Server%Svr#%, %WinTitle%

	   if (ErrorLevel != "FAIL") {
		  lResult:=ErrorLevel, VarSetCapacity(GUID,16,0)
		  if DllCall("ole32\CLSIDFromString", "wstr","{332C4425-26CB-11D0-B483-00C04FD90119}", "ptr",&GUID) >= 0 {
			 DllCall("oleacc\ObjectFromLresult", "ptr",lResult, "ptr",&GUID, "ptr",0, "ptr*",pdoc)
			 return ComObj(9,ComObjQuery(pdoc,IID,IID),1), ObjRelease(pdoc)
		  }
	   }
	}	; written by Glines
}
; 
; ################# Class Tests: ################### ;{
; S1 := new wb("Edge")	; Test nicht unterstuetzter Browser
; S1 := new wb("Edge_S1")	; Test nicht unterstuetzter Browser
WinActivate,ahk_exe iexplore.exe
WinWaitActive,ahk_exe iexplore.exe,,2
Sleep 100
IfWinActive,ahk_exe iexplore.exe
{
	S1 := new wbr("IE_")
	MsgBox,0,% A_LineFile "[" A_LineNumber "]",  % S1.getUrl(),4
	NewTab:=false
}
else
{
	S1 := new wbr("IE_S1")
	S1.Visible(1)
	NewTab:=true
}
; S1.GetSetOneOfAllTags("+ID=a4711/Tag=div","¬body|General|strong","outerHtml"),200
; S1.setOnErrorExit(true)	; bei Fehler Thread beenden
; S2 := new wb("IE_S2")		; paralele 2. Browser Sitzung
; S2.Visible(1)
S1.Navigate("http://autohotkey.com")

MsgBox,0,% A_LineFile "[" A_LineNumber "]", % S1.GetElementsHtmlByTagName("a",,"outerHtml",0),6
MsgBox,0,% A_LineFile "[" A_LineNumber "]",  % S1.getUrl() "	" S1.getLocationName() "	alle Links:`r`n" S1.getAllLinks(),5
MsgBox,0,% A_LineFile "[" A_LineNumber "]",  % S1.getUrl() "	" S1.getLocationName() "	GesammtText:`r`n" S1.getAllText(),5
MsgBox,0,% A_LineFile "[" A_LineNumber "]",  % S1.getUrl() "	" S1.getLocationName() "	QuellText:`r`n" S1.getSourceCode(),5
MsgBox,0,% A_LineFile "[" A_LineNumber "]",  % S1.getUrlAfterHash()	,2
S1.refresh()
S1.Navigate("Google.de")
MsgBox,0,% A_LineFile "[" A_LineNumber "]", % S1.FeldEintrag("Hugo","lst-ib","q","gsfi","input"),2
S1.FocusClick("gsr") 
S1.FocusClick("","btnK")
MsgBox,0,% A_LineFile "[" A_LineNumber "]",  % S1.getUrlAfterQuestionMark(),3
MsgBox,0,% A_LineFile "[" A_LineNumber "]",  % S1.getUrlPathname(),2
MsgBox,0,% A_LineFile "[" A_LineNumber "]",  % S1.getUrlHostname(),2
MsgBox,0,% A_LineFile "[" A_LineNumber "]",  % S1.getLocationName(),2
MsgBox,0,% A_LineFile "[" A_LineNumber "]",  % "Die Seitenhistorie hat " S1.HistoryLen() " Eintraege",2
S1.History(-1)
MsgBox,0,% A_LineFile "[" A_LineNumber "]",  % S1.getUserAgent(),4
S1.History(1)
Sleep 1000
S1.Navigate("https://autohotkey.com/boards/viewtopic.php?f=7&t=41332")






S2 := new wbr("IE_S2")
; 
; S1.GetSetOneOfAllTags("+ID=a4711/Tag=div","¬body|General|strong","outerHtml"),200
; S1.setOnErrorExit(true)	; bei Fehler Thread beenden
; S2 := new wb("IE_S2")		; paralele 2. Browser Sitzung
; S2.Visible(1)
; S1.Navigate("http://autohotkey.com")
S2.Navigate("https://www.uhrzeit.org/atomuhr.php")


AtomZeit:=S2.GetSetOneOfAllTags("/ID=anzeige_zeit",,"innerText","Klammerlos")
MsgBox,0,% A_LineFile "[" A_LineNumber "]" ,%AtomZeit% " von https://www.uhrzeit.org/atomuhr.php", 5
MsgBox,0,% A_LineFile "[" A_LineNumber "]", % S1.GetSetOneOfAllTags("strong","General","innerhtml",,"<marquee><mark>temporaere Aenderungs-Zeit " AtomZeit " G e n e r a <i>l</i> :   G e n e r a <i>l</i> :   G e n e r a <i>l</i></mark></marquee>"),12
AtomZeit:=S2.GetSetOneOfAllTags("/ID=anzeige_zeit",,"innerText","Klammerlos")
MsgBox,0,% A_LineFile "[" A_LineNumber "]" ,%AtomZeit% " von https://www.uhrzeit.org/atomuhr.php", 5
MsgBox,0,% A_LineFile "[" A_LineNumber "]", % S1.GetSetOneOfAllTags("+strong","G e n e r a","innerhtml",,"<marquee><mark>2. temporaere Aenderungs-Zeit " AtomZeit " G e n e r a <i>l</i> :  : <i>l</i> a r e n e G   G e n e r a <i>l</i></mark></marquee>"),10
S2.Visible(1)
AtomZeit:=S2.GetSetOneOfAllTags("+ID=anzeige_zeit/Tag=span",,"innerText","Klammerlos")	; das + vorne am ersten Parameter kann beim Einrichten helfen. Die Markierungen sind schlussendlich bei weggelassenem + nicht zu sehen weil nicht vorhanden.



; MsgBox,0,% A_LineFile "[" A_LineNumber "]", % S1.GetSetOneOfAllTags(/"Tag=html")
; MsgBox,0,% A_LineFile "[" A_LineNumber "]", % S1.GetSetOneOfAllTags("strong","General","innerhtml",,"<marquee><mark>G e n e r a <i>l</i> :   G e n e r a <i>l</i> :   G e n e r a <i>l</i></mark></marquee>"),10
; MsgBox % S1.GetSetOneOfAllTags("+ID=profile188328/Tag=a","nnnik","click","InKlammern")
; MsgBox,0,% A_LineFile "[" A_LineNumber "]", % S1.GetSetOneOfAllTags("+strong","General","OuterHtml",,"General",0),10
; MsgBox,0,% A_LineFile "[" A_LineNumber "]", % S1.GetSetOneOfAllTags("strong","General","innerhtml.selectedText",,"General",0),10
; MsgBox % S1.GetSetOneOfAllTags("+ID=profile188328/Tag=a",,"outerHtml")
; WinHwnd := S1.getWinHwnd()
; MsgBox % S1.document.getElementByID("p188368").outerHtml
; MsgBox % S1.document.getElementByID("p188368").getElementsByTagName("cite")[0].outerHtml
; <strong>General:</strong>
; MsgBox % GetDom(S1.Com,"cite","")
; MsgBox,0,% A_LineFile "[" A_LineNumber "]", % S1.GetSetOneOfAllTags("+div","¬body|General|strong","outerHtml"),200
Sleep 1000
; MsgBox,0,% A_LineFile "[" A_LineNumber "]", % S1.GetSetOneOfAllTags("+","General","outerHtml"),2
; MsgBox % S1.getParent(S1.GetSetOneOfAllTags("+cite","nnnik"),5).outerHtml
; S1.GetSetOneOfAllTags("cite",			"nnnik wrote|prototype based languages",							"scrollIntoView",					"")	; zielt auf 13.12.2017  14:59
; Sleep 2000
; S1.GetSetOneOfAllTags("cite",			"nnnik wrote|prototype based languages",							"scrollIntoView"					)	; zielt auf 13.12.2017  14:59
; Sleep 2000
; S1.GetSetOneOfAllTags("+cite",			"nnnik wrote|prototype based languages",							"scrollIntoView",					"")	; zielt auf 13.12.2017  14:59
; Sleep 8000
; S1.GetSetOneOfAllTags("cite",			"nnnik wrote|prototype based languages",							"scrollIntoView"					)	; zielt auf 13.12.2017  14:59
; ExitApp
; S1.GetSetOneOfAllTags("+cite",			"nnnik wrote|prototype based languages",							"scrollIntoView",					"")




if Not NewTab
	S1.DuplicateTab()
sleep 2000
S1:=""
; MsgBox Skript Ende
;}	

ElementFilter(ByRef Knoten,FilterName="",Filter="",INr="",NachDot="",InKlammenValue="",setValue="") {
;	if (INr="")
;		INr:="free"
	if (FilterName="Tag")
	{
		if (INr="free"  AND NachDot="" AND InKlammenValue="")
			Knoten:=Knoten.getElementsByTagName(Filter)
		else if(INr<>"free")
		{
			if (NachDot="" AND InKlammenValue="")
				Knoten:=Knoten.getElementsByTagName(Filter)[INr]
			else if(NachDot<>"")
			{
				if (InKlammenValue="KlammerLos" OR InKlammenValue="")
				{
					InKlammenValue:=""
					if(setValue="")
; {
						Knoten:=Knoten.getElementsByTagName(Filter)[INr][NachDot]
	; MsgBox %   A_LineFile "	" A_LineNumber "	"       Filter   "`n`n`n" INr "`n`n`n" NachDot
; }
					else
						Knoten:=Knoten.getElementsByTagName(Filter)[INr][NachDot]	:= setValue
				}
				else ; if (InKlammenValue="InKlammern" OR InKlammenValue<>"" and InKlammenValue<>"InKlammern")			
				{
					if(InKlammenValue="InKlammern")
						InKlammenValue:=""
					if(setValue="")
; {
						Knoten:=Knoten.getElementsByTagName(Filter)[INr][NachDot]([InKlammenValue])
	; MsgBox %   A_LineFile "	" A_LineNumber "	"       Filter   "`n`n`n" INr "`n`n`n" NachDot "`n`n`n" InKlammenValue
; }
					else
						Knoten:=Knoten.getElementsByTagName(Filter)[INr][NachDot]([InKlammenValue])	:= setValue
				}
			}
			else
				Fehlermeldung:=true
		}
		else
			Fehlermeldung:=true
	}
	else if (FilterName="ID")
	{
		if(INr="")
		{
			if(NachDot="" AND InKlammenValue="")
				Knoten:=Knoten.getElementByID(Filter)
			else if (NachDot<>"")
			{
				if (InKlammenValue="KlammerLos" OR InKlammenValue="")
				{
					InKlammenValue:=""
					if(setValue="")
						Knoten:=Knoten.getElementByID(Filter)[NachDot]
					else
						Knoten:=Knoten.getElementByID(Filter)[NachDot]	:= setValue
				}
				else
				{
					InKlammenValue:=""
					if(setValue="")
						Knoten:=Knoten.getElementByID(Filter)[NachDot]([InKlammenValue])
					else
						Knoten:=Knoten.getElementByID(Filter)[NachDot]([InKlammenValue])	:= setValue
				}
			}
			else
				Fehlermeldung:=true
		}
		else
		{
			if(NachDot="" AND InKlammenValue="")
				Knoten:=Knoten.getElementByID(Filter)
			else if (NachDot<>"")
			{
				if (InKlammenValue="" OR InKlammenValue="KlammerLos")
				{
					InKlammenValue:=""
					Knoten:=Knoten.getElementByID(Filter)[NachDot]
				}
				else
					Knoten:=Knoten.getElementByID(Filter)[NachDot]([InKlammenValue])
			}
			else
				Fehlermeldung:=true
		}
	}
	else if(FilterName="")
	{
	}
	else
	{
		Fehlermeldung:=true
		; MsgBox,0,% A_LineFile "[" A_LineNumber "]",Der Element-Filter %FilterName% wird noch nicht unterstuetzt.`nUnterstuetzte Filter:`nID,20
	}
	if Fehlermeldung
	{
		MsgBox,0,% A_LineFile "[" A_LineNumber "]",Der Element-Filter %FilterName% %Filter% %INr% %NachDot% %InKlammenValue% wird noch nicht unterstuetzt.`nUnterstuetzte Filter:`nID,20
		return false
	}
}


/*
; ab hier weglassen ###################################################################################

GetDom(ComObj,Tag,attribute){
 ;       global oDriverCh,Rueckgabe,JavaScriptGetDom
    JavaScriptGetDom =
(
matches = document.querySelectorAll('%Tag%.%attribute%');
match = matches[0];
// alert(matches + ' Matches Text ' + matches[0].textContent +'    ' + match + ' Match Text ' + match.textContent);
var JavaRueck = getElementPath(match);
return JavaRueck
function getElementPath(element){
 //   alert('Element ' + element + match.textContent);
  return '//' + $(element).parents().andSelf().map(function() {
        var $this = $(this);
        var tagName = this.nodeName;
        if ($this.siblings(tagName).length > 0) {
            tagName += '[' + $this.prevAll(tagName).length + ']';
        }
        return tagName;
    }).get().join('/').toUpperCase();
}
)
    ; MsgBox % JavaScriptGetDom
    try
        Rueckgabe := ComObj.executeScript(JavaScriptGetDom)			; funced so mit dem IE nicht
    Catch E
        DoChatch(E)
    ; MsgBox %Rueckgabe%
    return Rueckgabe
}


DoChatch(Exeption,AddAnzahlFehler:=true){	; wird noch bei den Try ... Catch Befehlen eingerichtet
    global AnzahlFehler,GesLogPath
    ; MsgBox %         A_now A_Tab Gelb A_Tab Abbruch vermutlich via [Esc] Taste A_Tab Exeption.Message A_Tab "|" A_Tab Exeption.What A_Tab Exeption.Extra A_Tab Exeption.File A_Tab Exeption.Line A_Tab "`r`n" 

    if AddAnzahlFehler
        ++AnzahlFehler
    if(InStr(Exeption.Message,"Code execution has been interrupted"))
    {
        GesLog.=A_now A_Tab Gelb A_Tab Abbruch vermutlich via [Esc] Taste A_Tab Exeption.Message A_Tab Exeption.What A_Tab Exeption.Extra A_Tab Exeption.File A_Tab Exeption.Line A_Tab "`r`n" 
        FileAppend,%GesLog%,%GesLogPath%
        odriverCh.quit()
        ExitApp
    }
    else
    {
        GesLog.=A_now A_Tab Exeption.Message A_Tab Exeption.What A_Tab Exeption.Extra A_Tab Exeption.File A_Tab Exeption.Line A_Tab "`r`n" 
        FileAppend,%GesLog%,%GesLogPath%
    }
}

; Hier folgen Links die ich gefunden habe, die interressant  wichtig oder dergleichen sind oder sein koennten,
; fuer die aber noch nicht genuegend Sichtungszeit oder Test-Zeit vorhanden war:
; https://stackoverflow.com/questions/35586127/get-the-first-child-node-using-the-internet-explorer-com-object	
;	wb.Document.getElementByID("past").childnodes.item[0].innerText	KinderKnoten
;	querySelector	AHK-Beispiele
; https://stackoverflow.com/questions/38634989/autohotkey-set-focus-on-a-button-webpage-and-send-click
; 	ComObjConnect(WB, WB_events)  ; Connect WB's events to the WB_events class object.	Button-Klick ueberwachen
;		AHK-Gui Beispiel zu WebBrowser Events
; https://github.com/cocobelgica/AutoHotkey-CWebView/blob/master/CWebView.ahk
; 		AHK-Beispiel einer WebBrowser Class
; https://gist.github.com/Pulover
;	https://gist.github.com/Pulover/6824965	TreeViewBrowser.ahk
; http://the-automator.com/web-scraping-with-autohotkey-108-queryselctorall/	duerfte zum Link oben hinter Danke Glines gehoeren
; https://q-a-assistant.com/computer-internet-technology/1780433_javascript-login-on-website-using-autohotkey.html
; https://autohotkey.com/boards/viewtopic.php?f=5&t=28053	
; 	erzeugt Listen: vNeedle1 = href="#	vNeedle2 = id="	vNeedle3 = name="
; https://getawesomeness.herokuapp.com/get/autohotkey	Linksammelung "genialer" AutoHotKey Libraries