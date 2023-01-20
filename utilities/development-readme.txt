Do edit utils:
- edit psutils.ps1 file

for recompile as exe:
- run powershell as administrator
- Install-Module ps2exe
- Invoke-ps2exe .\psutils.ps1 psutils.exe -iconFile .\icons.ico
- add file to antivirus exclusion