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
Run, %InPath%
ExitApp
return

FuehrendeSterneEntfernen(Pfad,Max=20)
{
 	global AnzahlEntfernterSterne
	Stern=*
	AnzahlEntfernterSterne:=0
	StringReplace,Pfad,Pfad,%A_Tab%,`\
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
