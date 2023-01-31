/*
Pause the current thread if viewing pluralsight videos
This is to avoid the mysterious extended sleep interval in weip-ahk
*/
Global Config

#If MouseIsOver("Pluralsight - Google Chrome")
;#If WinActive("ahk_exe chrome.exe") and MouseIsOver("Pluralsight - Google Chrome")
{

	msgbox, chrome is active
	>+F12::
	{
		msgbox, F12 pressed
		isPause := Config["weip"]["isPause"]
	    ConfigReader.updateConfig("settings.ini", "weip", "isPause", !isPause)

	    PauseInstance(isPause)

		Return
	}


	Return
}
;#If


MouseIsOver(WinTitle) {
    ; Check the pid with the expected title
    MouseGetPos,,, Win
    handlerId := WinExist(WinTitle . " ahk_id " . Win)

    return handlerId != 0x0
}


PauseInstance(isPause) {
    ; check isPause flag in settings.ini
    if (isPause) {
        MsgBox, This is pause&suspend
        Pause On
        Suspend On
    } else {
        MsgBox, This is reload
        Reload
    }
	Return
}

PauseInstance(Config["weip"]["isPause"])
