function Fix-Office {
    $paths = @(
        "C:\Program Files\Microsoft Office 15\ClientX64\OfficeClickToRun.exe",
        "C:\Program Files\Microsoft Office 15\ClientX86\OfficeClickToRun.exe"
    )

    $wordPath = "C:\Program Files (x86)\Microsoft Office\root\Office16\WINWORD.EXE"

    foreach ($officePath in $paths) {
        if (Test-Path $officePath) {
            try {
                Start-Process -FilePath $officePath -ArgumentList "scenario=Repair RepairType=FullRepair forceappshutdown=True DisplayLevel=False" -Wait -ErrorAction Stop
                if (Test-Path $wordPath) {
                    Start-Process -FilePath $wordPath
                }
                return "Microsoft Office repair completed."
            } catch {
                return "Error during repair: $($_.Exception.Message)"
            }
        }
    }

    return "Microsoft Office NOT Installed."
}

Fix-Office
