#PS1 - Powershell Launch MITRE Caldera Human Plugin 

$datey = Get-Date -Format "MM-dd-yyyy_HH-mm"
$filey = "~\mchp_logs\"+ $datey + "_mtx_mchp.txt"

New-Item $filey -Force


Get-Date -Format "MM-dd-yyyy_HH-mm" >> $filey
"STARTING RECORDING SCRIPT - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - " >> $filey

while ($true){ 

	Get-Date -Format "MM-dd-yyyy_HH-mm" >> $filey
	"STARTING MCHP PLUGIN - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - " >> $filey
	python3 human.py >> $filey

	Stop-Process -Name "chrome" -Force >> $filey
	Stop-Process -Name "mspaint" -Force >> $filey
	Stop-Process -Name "soffice" -Force >> $filey
	
	Get-ChildItem C:\Users\win11\Downloads\* | Remove-Item -recurse -force

	Clear-RecycleBin -force
	
}
