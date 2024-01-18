#PS1 - Powershell Logging of System Resources for Windows Machines

$datey = Get-Date -Format "MM-dd-yyyy_HH-mm"
$filey = "~\hardware_logs\"+ $datey + "_resource_logging.txt"

New-Item $filey -Force

git pull origin >> $filey


"$(Get-Date -Format "MM-dd-yyyy_HH-mm"): STARTING LOGGING SCRIPT - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - `n`n`n" >> $filey



$totalRam = (Get-CimInstance Win32_PhysicalMemory | Measure-Object -Property capacity -Sum).Sum

while ($true){ 

	"$(Get-Date -Format "yyyy-MM-dd HH:mm:ss"): LOGGING STATISTICS + + + + + + + + + + + + + + + + + + + + + + + + + + + + + + + + + " >> $filey
	"Total Number of Processes Running: $((Get-Process).Count)" >> $filey
	"Total Number of Threads: $((Get-Process | Select-Object -ExpandProperty Threads).Count)`n" >> $filey
	 
	"Chrome Processes: $((Get-Process chrome).Count)" >> $filey

	#SCRIPT FROM: https://stackoverflow.com/questions/6298941/how-do-i-find-the-cpu-and-ram-usage-using-powershell
	
    $cpuTime = (Get-Counter '\Processor(_Total)\% Processor Time').CounterSamples.CookedValue
    $availMem = (Get-Counter '\Memory\Available MBytes').CounterSamples.CookedValue
    'CPU: ' + $cpuTime.ToString("#,0.000") + '%, Avail. Mem.: ' + $availMem.ToString("N0") + 'MB (' + (104857600 * $availMem / $totalRam).ToString("#,0.0") + '%)' >> $filey


    Get-Counter '\Process(*)\% Processor Time' | Select-Object -ExpandProperty countersamples | Select-Object -Property  instancename, cookedvalue| Sort-Object -Property cookedvalue -Descending| Select-Object -First 20| ft  InstanceName,@{L='CPU';E={($_.Cookedvalue/100).toString('P')}} -AutoSize >> $filey


    #script from here: https://stackoverflow.com/questions/26552223/get-process-with-total-memory-usage
    get-process | Group-Object -Property ProcessName | 
		% {
    		[PSCustomObject]@{
        	ProcessName = $_.Name
        	Mem_MB = [math]::Round(($_.Group|Measure-Object WorkingSet64 -Sum).Sum / 1MB, 0)
        	ProcessCount = $_.Count
    	}
	} | sort -desc Mem_MB | Select-Object -First 25 >> $filey

	"DISK USEAGE:" >> $filey
	Get-Volume >> $filey

	Start-Sleep -s 900
}
