#SingleInstance off
Ue0=%0%
if not Ue0
	ExitApp
Ue1=%1%
if (Ue1="")
	ExitApp
Ue2=%2%
Ue3=%3%
Kord=%4%
CoordMode, ToolTip,%Kord%
Dauer=%5%
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
	ToolTip,%Ue1%,x,y
	Last_TickCount:=A_TickCount
loop, 1000
{
	if((A_TickCount - Last_TickCount) > Dauer)
		break
	if FolgtMaus
		ToolTip,%Ue1%,x,y
	Sleep 9
	if(GetKeyState("ESc"))
		break
}
ExitApp