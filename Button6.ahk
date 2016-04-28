Ue0=%0%
Ue1=%1%
Ue2=%2%
Ue3=%3%
Ue4=%4%
Ue5=%5%
Ue6=%6%
Ue7=%7%
Ue8=%8%
Ue9=%9%
Ue10=%10%

InPath:=Ue1
ZusatzText:=Ue2
InPath:=FuehrendeSterneEntfernen(InPath)
FileGetAttrib, Attribute, %InPath%
; MsgBox % Attribute

IfInString, Attribute, D
{
}
else
{
	Edit8Sternlos:=InPath
	SplitPath,Edit8Sternlos, Edit8SternlosFileName, Edit8SternlosDir ; , Edit8SternlosExt, Edit8SternlosNameNoExt
	InPath:=Edit8SternlosDir		; Enthaltendes Verzeichnis statt Datei
}
IfNotExist %InPath%
{
	MsgBox, 262160, Fehler, %SpeicherPfad%.txt`n`nwurde nicht uebrgeben!
	ExitApp
}

StringSplit,ZusatzTextDetail,ZusatzText,|,%A_Space%
if(ZusatzTextDetail1="Zusatz"  or ZusatzTextDetail1="" or SubStr(ZusatzTextDetail1,1,12)="Start-Pfade:" or SubStr(ZusatzTextDetail1,1,10)="Bitte hier")
{
	ControlSetText,Edit4,Edit10=Bitte hier Gegenstand eingeben|optional Kategorie.,ZackZackOrdner
	MsgBox, 262160, Fehlender Parameter, Bitte die Bezeichnung des Gegenstandes unten eingeben.`n`nAbbruch!
	ExitApp
}
else
{
	Zeile1:=ZusatzTextDetail1
	Zeile2:=ZusatzTextDetail2
	Zeile3:=FuehrendeSterneEntfernen(InPath)
	SpeicherPfad=%Zeile3%\%ZusatzTextDetail1%
	Dateinhalt=%Zeile1%`r`n%Zeile2%`r`n%Zeile3%

	loop, % ZusatzTextDetail0-1
	{
		Index := 3 + A_Index
		Index2 := Index - 1
		Zeile%Index%:=ZusatzTextDetail%Index2%					; Falls einzeln benoetigt
		Dateinhalt:=Dateinhalt "`r`n" Zeile%Index%
	}
	IfExist %SpeicherPfad%.txt
	{
		; MsgBox, 262176, Dateinamenskonflikt, %SpeicherPfad%`n`nvorhandene Datei ueberschreiben	Ja`nNeue Datei umbenennen 	bei	Nein`nnichts unternehemen	bei	Cancel
		MsgBox, 262435, Dateinamenskonflikt, %SpeicherPfad%`n`nvorhandene  Datei ueberschreiben	Ja`nNeue Datei umbenennen 	bei	Nein`nnichts unternehemen	bei	Abrechen
		IfMsgBox,Yes
		{
			FileDelete,%SpeicherPfad%.txt
			FileAppend,%Dateinhalt%,%SpeicherPfad%.txt
			if ErrorLevel
			{
				goto KeineNeueDatei
				ExitApp
			}
			TrayTip,Datei erstellt,% SpeicherPfad ".txt"
			sleep 2000
			ExitApp
		}
		IfMsgBox,No
		{
			FileAppend,%Dateinhalt%,%SpeicherPfad%[%A_Now%].txt
			if ErrorLevel
			{
				MsgBox, 262160, Fehler, %SpeicherPfad%[%A_Now%]`n`nkonnte nicht erstellt werden!
				ExitApp
			}
			TrayTip,Datei erstellt,% SpeicherPfad "[" A_Now "].txt"
			sleep 2000
		}
		ExitApp
	}
	else
	{
		FileAppend,%Dateinhalt%,%SpeicherPfad%.txt
		if ErrorLevel
		{
			goto KeineNeueDatei
			ExitApp
		}
		; < Sternlosen Favoriten von und in ZackZackOrdner anlegen lassen.>
		sleep 200
		ControlSetText,Edit4,Edit8Vorher:=Edit8.,ZackZackOrdner
		; MsgBox 1
		sleep 200
		ControlSetText,Edit4,Edit8=%SpeicherPfad%.txt.,ZackZackOrdner
		; MsgBox 2
		sleep 200
		ControlSetText,Edit4,SetAutoFavorit.,ZackZackOrdner
		; MsgBox 3
		sleep 1000
		ControlSetText,Edit4,Edit8:=Edit8Vorher.,ZackZackOrdner
		; </ Sternlosen Favoriten von und in ZackZackOrdner anlegen lassen.>
		
		TrayTip,Datei erstellt,% SpeicherPfad ".txt"
			sleep 2000
		ExitApp
	}
}
KeineNeueDatei:
MsgBox, 262160, Fehler, %SpeicherPfad%.txt`n`nkonnte nicht erstellt werden!

ExitApp

FuehrendeSterneEntfernen(Pfad,Max=20)
{
	; MsgBox EingangPfad %Pfad%
	Loop,
	{
		if not Max
			return Pfad
		if(SubStr(Pfad,1,1)="*")
			StringTrimLeft,Pfad,Pfad,1
		else
		{
			; MsgBox AusgangPfad %Pfad%
			return Pfad
		}
		--Max
	}
}
