function FixOutlook
{
    try
    {
                
        get-process 'outlook' | Stop-Process -Force | Out-String
		Start-Sleep -Seconds 2
		Remove-Item "HKCU:\Software\Microsoft\Office\16.0\Outlook\Profiles\Outlook" -Recurse -Confirm:$false -Force | Out-String
		Start-Sleep -Seconds 2
        try
        {
            Start-Process -FilePath "C:\Program Files (x86)\Microsoft Office\root\Office16\OUTLOOK.EXE"
            $output = "Microsoft Outlook repair completed"
        }
        catch
        {
            $output = "Error: $($PSItem.Exception.Message)"
        }
                
    }
    catch
    {
        $output = "Error: $($PSItem.Exception.Message)"
                
    }
return $output
}

FixOutlook