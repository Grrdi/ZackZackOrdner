Ue0=%0%
Ue1=%1%
Ue2=%2%
Ue3=%3%
Ue4=%4%
Ue5=%5%
Ue6=%6%
; MsgBox Hallo %Ue1% at gesucht wude %Ue2%	X=%Ue3%	Y=%Ue4%
; SplashImage,%Ue1%,B M   X%Ue3% Y%Ue4% W350 H350 ; ZW-1 ; ZH-1
; SplashImage,%Ue1%,A b X%Ue3% Y%Ue4% ZH%ScreenHeight% ZW%ScreenWidth%
SplashImage,%Ue1%,A b X%Ue3% Y%Ue4% H450 W-1 
UE4:=UE4+80
SplashImage,%Ue1%,A b X%Ue3% Y%Ue4% ZH-1 ZW%Ue5% ; ZW400
Sleep 500
UE4:=UE4+305
SplashImage,%Ue1%,A b X%Ue3% Y%Ue4% ZH-1 ZW145 ; ZW400
Sleep 5000