; dieses Script installiert oder aktualisiert ZZO in das hier verwendete Verzeichnis und startet es.
url=https://github.com/Grrdi/ZackZackOrdner/archive/master.zip
DownLoadPfad=%A_ScriptDir%\ZackZackOrdner-master.zip
DownLoadOrdner=%A_ScriptDir%\ZackZackOrdner-master
IfExist %DownLoadPfad%
	FileDelete,%DownLoadPfad%
IfExist %DownLoadOrdner%
	FileRemoveDir, %DownLoadOrdner%,1 
UrlDownloadToFile, %URL%, %DownLoadPfad%
if ErrorLevel
{
	Clipboard:=DownLoadPfad
	FileCreateDir,%DownLoadOrdner%
	Run %url%
	MsgBox, 262196, Fehler beim Automatischen Download., Der Download wurde fuer die manuelle Weiterverabeitung gestartet. Dieser ist unter %DownLoadPfad% zu speichern.`n`nErst wenn erledigt Ja klicken!`n`nHinweis: Der DownLoadPfad befindet sich  im Clipboard.
	IfMsgBox,No
		ExitApp
	IfNotExist %DownLoadPfad%
	{
		MsgBox, 262160, Fehler beim Download, Beim Herunterladen ist ein Fehler aufgetreten.`nUrsache koennte sein`, dass Kein Netwerk vorhanden oder dieses Skript nicht mit Ihrer Proxy-Umgebung zurecht kommt.`n`nAbbruch
		ExitApp
	}
}
IfExist %DownLoadPfad%
{
	ScriptDir:=A_ScriptDir
	Unz(DownLoadPfad,ScriptDir)
	IfExist %A_ScriptDir%\ZackZackOrdner-master\SchnellOrdner.ahk
		; FileCopy,%A_ScriptDir%\ZackZackOrdner-master\*.*,%A_ScriptDir%
		RunWait, %ComSpec% /c ""XCopy" "%A_ScriptDir%\ZackZackOrdner-master\*.*" "%A_ScriptDir%"" /D /Y /S
	IfExist %A_ScriptDir%\ZackZackOrdner-master\SchnellOrdnerNeuesteBeta.ahk
	{
		MsgBox, 262404, ZZO Beta, Beta-Version entdeckt`,`nsoll diese installiert werden?
		IfMsgBox,Yes
		{
			FileDelete,%A_ScriptDir%\SchnellOrdner.ahk
			; FileMove,%A_ScriptDir%\SchnellOrdner.ahk,%A_ScriptDir%\SchnellOrdnerOrg.ahk
			FileMove,%A_ScriptDir%\ZackZackOrdner-master\SchnellOrdnerNeuesteBeta.ahk,%A_ScriptDir%\SchnellOrdner.ahk
			IfExist %A_ScriptDir%\ZackZackOrdner-master\*[ZuSchnellOrdnerNeuesteBeta].*
				MsgBox, 262208, Hinweis, Datei mit dem Muster`n	*[ZuSchnellOrdnerNeuesteBeta].*`nentdeckt.`nEventuell ist manuelle Nacharbeit erforderlich!
		}
		else
		{
			FileDelete,%A_ScriptDir%\SchnellOrdner.ahk
			FileMove,%A_ScriptDir%\ZackZackOrdner-master\SchnellOrdner.ahk,%A_ScriptDir%\SchnellOrdner.ahk
		}
	}
	IfExist %A_ScriptDir%\SchnellOrdner.exe
	{
		run %A_ScriptDir%\SchnellOrdner.exe		; auskommentieren, wenn nicht gleich gestartet werden soll 
		ExitApp
	}
	IfExist %A_ScriptDir%\SchnellOrdner.ahk
		run %A_ScriptDir%\SchnellOrdner.ahk		; auskommentieren, wenn nicht gleich gestartet werden soll 
	Dummy=
}

Unz(sZip, sUnz){ ; http://www.autohotkey.com/board/topic/60706-native-zip-and-unzip-xpvista7-ahk-l/
    fso := ComObjCreate("Scripting.FileSystemObject")
    If Not fso.FolderExists(sUnz)  ;http://www.autohotkey.com/forum/viewtopic.php?p=402574
       fso.CreateFolder(sUnz)
    psh  := ComObjCreate("Shell.Application")
    zippedItems := psh.Namespace( sZip ).items().count
    psh.Namespace( sUnz ).CopyHere( psh.Namespace( sZip ).items, 4|16 )
    Loop 1
	{
        sleep 50
        unzippedItems := psh.Namespace( sUnz ).items().count
        IfEqual,zippedItems,%unzippedItems%
            break
    }
}
