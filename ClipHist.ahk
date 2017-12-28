; ClipHist.ahk
#Persistent

IfNotExist %A_Temp%\Clip
	FileCreateDir %A_Temp%\Clip
SplitPath,A_Temp,,,,,TempDrive
OnClipboardChange("ClipChange")
return
ClipChange(Typ)
{
	if (Typ=1)
		FileAppend, %Clipboard%,%A_Temp%\Clip\%A_Now%.txt
	else if(Typ=2)
		FileAppend, %ClipboardAll%,%A_Temp%\Clip\%A_Now%.clip
	DriveSpaceFree,FreiMB,%TempDrive%\
	
	AeltesteDateiLoeschen(A_Temp "\Clip",FreiMB/500)
}







AeltesteDateiLoeschen(Dir,MaxFiles)
{
	i:=0
	Loop,Files,%Dir%\*,F
	{
		++i
		if(A_Index=1)
			LastLoopFileTimeModified:=A_LoopFileTimeModified
		if (A_LoopFileTimeModified<=LastLoopFileTimeModified)
		{
			Aelteste:=A_LoopFileLongPath
			ia:=i
			LastLoopFileTimeModified:=A_LoopFileTimeModified
		}
	}
	; MsgBox %i%	%MaxFiles%	%ia%	%Aelteste%
	if (i>MaxFiles)
		FileDelete,%Aelteste%
}