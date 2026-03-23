Set objShell = CreateObject("Wscript.Shell")
objShell.Run "powershell -NoProfile -ExecutionPolicy Bypass -File """ & Replace(WScript.ScriptFullName, "start_hidden.vbs", "server.ps1") & """", 0, False
