;Created By valleyman86
; needs to be #Persistent, otherwise events will kick few times and script exits.
#Persistent

ConsolePath := "C:\Program Files (x86)\Steam\steamapps\common\Counter-Strike Global Offensive\csgo\console.log"

AutoTrim, On

;Delete this section to remove auto recording
;-start-
SetTimer MonitorConsoleLog, 500
EraseConsoleLog(ConsolePath)
File := FileOpen(ConsolePath, "r")
File.Seek(0, 2)
Size0 := File.Length
gMapName := ""
;-end-
 
RecordDemo() {
    FormatTime, time, %A_Now%, yyyy-MM-dd_HH-mm
    SendInput, {f10}
    Sleep, 250
    SendInput record demos\%time%_%gMapName% {enter}
    Sleep, 100
    SendInput, {f10}
}

EraseConsoleLog(filePath) {
    FileToErase := FileOpen(filePath, "w")
    FileToErase.Write("")
    FileToErase.Close()
}

MonitorConsoleLog:
   global gMapName
   Size := File.Length
 
   If (Size0 >= Size) {
      Size0 := Size
      File.Seek(0, 2)
      Return
   }

   while (LastLine := File.ReadLine()) {
       if (RegExMatch(LastLine,"i)^Map: (.*/)?(.*)", MapName)) {
	       gMapName := MapName2
       }

       if (RegExMatch(LastLine,"i)ChangeGameUIState: CSGO_GAME_UI_STATE_LOADINGSCREEN -> CSGO_GAME_UI_STATE_INGAME")) {
           RecordDemo()
       }
 
      if (RegExMatch(LastLine,"i)Recording to")) {
          SoundBeep, 500, 100
          SoundBeep, 500, 100
          SoundBeep, 500, 100
      }
   }
 
   Size0 := Size
Return
