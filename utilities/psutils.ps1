$utility = ''
$PasswordLenght = 0

#region Login
Function Fn-GenerateStrongPassword{
    Add-Type -AssemblyName System.Web
    $PassComplexCheck = $false
    do {
        $newPassword=[System.Web.Security.Membership]::GeneratePassword($PasswordLenght,1)
        if(($newPassword -cmatch "[A-Z\p{Lu}\s]") -and ($newPassword -cmatch "[a-z\p{Ll}\s]") -and ($newPassword -match "[\d]") -and ($newPassword -match "[^\w]")){
            $PassComplexCheck=$True
        }
    } While ($PassComplexCheck -eq $false)
    return $newPassword
}
#endregion

#region Program
Function Fn-Menu {
    Write-Output "----------------------------"
    Write-Output "- Generate new GUID [0]"
    Write-Output "- Generate new Password [1]"
    Write-Output "- Generate hash as string [2]"
    Write-Output "- Generate document checksum [3]"
    Write-Output "- Check document checksum [4]"
    Write-Output "- Replace string in documents (recursive in entire folders) [5]"
    Write-Output "- Rename string in documents name (recursive in entire folders) [6]"
    Write-Output "- Encrypt entire folder [7]"
    Write-Output "- Decrypt entire folder [8]"
    Write-Output "- Create new encryption key [9]"
    Write-Output "- Open new Powershell windows [10]"
    Write-Output "- Open new Terminal windows [11]"
    Write-Output "- Run PowerUtils in new Powershell windows [12]"
    Write-Output "- Initialize new minimo project [13]"
    Write-Output "- Exit [e]"
    Write-Output "----------------------------"
}

Function Fn-Welcome {
    Write-Host '
    __________                           ____ ___   __  .__.__          
    \______   \______  _  __ ___________|    |   \_/  |_|__|  |   ______
    |     ___/  _ \ \/ \/ // __ \_  __ \    |   /\   __\  |  |  /  ___/
    |    |  (  <_> )     /\  ___/|  | \/    |  /  |  | |  |  |__\___ \ 
    |____|   \____/ \/\_/  \___  >__|  |______/   |__| |__|____/____  >
                            \/                                   \/ 
'
    Write-Output ""
    Write-Output ""
    Fn-Start
}

Function Fn-Start {
    Write-Output ""
    Write-Output "Select utilities"
    Fn-Menu
    $utility = Read-Host "Press selected utility number"
    Write-Output ""
    Fn-Decide-Utility
}

Function Fn-Restart {
    Write-Output ""
    Write-Output "Select another utilities or exit [e]"
    Fn-Menu
    $utility = Read-Host "Press selected utility number"
    Write-Output ""
    Fn-Decide-Utility
}

Function Fn-Decide-Utility {
    if($utility -eq ''){
        Fn-Restart
    }
    if($utility -eq 'e'){
        exit
        return
    }
    if($utility -eq '0'){
        $guid = [guid]::NewGuid()
        Write-Host "New guid is:"
        Write-Host $guid -ForegroundColor DarkGreen -BackgroundColor Green
        Write-Output ""
    }
    if($utility -eq '1'){
        $length = Read-Host "Insert length of new password"
        $PasswordLenght = [int]$length
        Write-Host "New password is:"
        Fn-GenerateStrongPassword
        Write-Output ""
        $PasswordLenght = 0
    }
    if($utility -eq '2'){
        $plainString = Read-Host "Insert plaintext string"
        Write-Host "String hashing is:"
        $stringStream = [IO.MemoryStream]::new([byte[]][char[]]$plainString)
        Get-FileHash -InputStream $stringStream -Algorithm SHA1 | format-list
        Get-FileHash -InputStream $stringStream -Algorithm SHA256 | format-list
        Get-FileHash -InputStream $stringStream -Algorithm SHA384 | format-list
        Get-FileHash -InputStream $stringStream -Algorithm SHA512 | format-list
        Get-FileHash -InputStream $stringStream -Algorithm MD5 | format-list
        Write-Output ""
    }
    if($utility -eq '3'){
        $path = Read-Host "Insert document path"
        Write-Host "Document checksum is:"
        Get-FileHash -Path $path -Algorithm SHA1 | format-list
        Get-FileHash -Path $path -Algorithm SHA256 | format-list
        Get-FileHash -Path $path -Algorithm SHA384 | format-list
        Get-FileHash -Path $path -Algorithm SHA512 | format-list
        Get-FileHash -Path $path -Algorithm MD5 | format-list
        Write-Output ""
    }
    if($utility -eq '4'){
        $path = Read-Host "Insert document path"
        $checksum = Read-Host "Insert checksum to validate"
        $algo = Read-Host "Insert checksum algorithm"
        Write-Output "Document checksum is:"
        $verifiedChecksum = ''
        if($algo -eq 'SHA1'){
            $verifiedChecksum = Get-FileHash -Path $path -Algorithm SHA1
        }
        if($algo -eq 'SHA256'){
            $verifiedChecksum = Get-FileHash -Path $path -Algorithm SHA256
        }
        if($algo -eq 'SHA384'){
            $verifiedChecksum = Get-FileHash -Path $path -Algorithm SHA384
        }
        if($algo -eq 'SHA512'){
            $verifiedChecksum = Get-FileHash -Path $path -Algorithm SHA512
        }
        if($algo -eq 'MD5'){
            $verifiedChecksum = Get-FileHash -Path $path -Algorithm MD5
        }
        if($verifiedChecksum.Hash.ToString() -eq $checksum){
            Write-Host "Document has not been modified!" -ForegroundColor DarkGreen -BackgroundColor Green
        } else {
            Write-Host "Document has been modified!" -ForegroundColor Black -BackgroundColor Red
        }
        Write-Output ""
    }
    if($utility -eq '5'){
        $path = Read-Host "Insert main folder path"
        $search = Read-Host "Insert search term"
        $replace = Read-Host "Insert new term"
        try { 
            $items = Get-ChildItem -Path $path -Recurse
            foreach ($file in $items) {
                $filetext = Get-Content $file.FullName -Raw
                $filetextNew = $filetext -replace $search, $replace
                Set-Content $file.FullName $filetextNew
            }
            Write-Host "Files strings replace operations has been finished with success" -ForegroundColor DarkGreen -BackgroundColor Green
        }
        catch { 
            Write-Host "An error has occurred during file strings replace operation" -ForegroundColor Black -BackgroundColor Red
        }
        Write-Output ""
    }
    if($utility -eq '6'){
        $path = Read-Host "Insert main folder path"
        $search = Read-Host "Insert search term"
        $replace = Read-Host "Insert new term"
        try { 
            $items = Get-ChildItem -Path $path -Recurse
            foreach ($file in $items) {
                Rename-Item -Path $file.FullName -NewName ($file.name -replace $search, $replace)
            }
            Write-Host "Files renamed operations has been finished with success" -ForegroundColor DarkGreen -BackgroundColor Green
        }
        catch { 
            Write-Host "An error has occurred during file renamed operation" -ForegroundColor Black -BackgroundColor Red
        }
        Write-Output ""
    }
    if($utility -eq '7'){
        $path = Read-Host "Insert main folder to encrypt path"
        (Get-ChildItem -path $path).Encrypt()
        Write-Host "Folder has been encrypted with success" -ForegroundColor DarkGreen -BackgroundColor Green
        Write-Output ""
    }
    if($utility -eq '8'){
        $path = Read-Host "Insert main folder to decrypt path"
        (Get-ChildItem -path $path).Decrypt()
        Write-Host "Folder has been decrypted with success" -ForegroundColor DarkGreen -BackgroundColor Green
        Write-Output ""
    }
    if($utility -eq '9'){
        $EncryptionKeyBytes = New-Object Byte[] 32
        $random = Get-Random
        [Security.Cryptography.RNGCryptoServiceProvider]::Create().GetBytes($EncryptionKeyBytes)
        $EncryptionKeyBytes | Out-File "$PSScriptRoot/encryption-$($random).key"
        Write-Host "Encryption key as been created with name: encryption-$($random).key in $PSScriptRoot\ folder" -ForegroundColor DarkGreen -BackgroundColor Green
        Write-Output ""
    }
    if($utility -eq '10'){
        Start-Process -FilePath "powershell"
        Write-Host "New Powershell window has been opened with success" -ForegroundColor DarkGreen -BackgroundColor Green
        Write-Output ""
    }
    if($utility -eq '11'){
        Start-Process -FilePath "cmd"
        Write-Host "New Terminal window has been opened with success" -ForegroundColor DarkGreen -BackgroundColor Green
        Write-Output ""
    }
    if($utility -eq '12'){
        try {
            Invoke-Item (start powershell "$($PSScriptRoot)\psutils.ps1")
        }
        catch {}
        Write-Host "New PowerUtils window has been opened with success" -ForegroundColor DarkGreen -BackgroundColor Green
        Write-Output ""
    }
    if($utility -eq '13'){
        $path = Read-Host "Insert main folder (contains solution) path"
        $search = Read-Host "Insert search term"
        $replace = Read-Host "Insert new term"
        try { 
            $items = Get-ChildItem -Path $path -Recurse
            foreach ($file in $items) {
                $newName = $file.FullName -replace $search, $replace
                Rename-Item -Path $file.FullName -NewName $newName
            }
            $items = Get-ChildItem -Path $path -Recurse
            foreach ($file in $items) {
                if($file.Extension -eq '.cs' -or $file.Extension -eq '.cshtml' -or $file.Extension -eq '.txt' -or $file.Extension -eq '.json' -or $file.Extension -eq '.csv' -or $file.Extension -eq '.css' -or $file.Extension -eq '.js' -or $file.Extension -eq '.sln' -or $file.Extension -eq '.csproj' -or $file.Extension -eq '.xml' -or $file.Extension -eq '.resx'){
                    $filetext = Get-Content $file.FullName -Raw
                    $filetextNew = $filetext -replace $search, $replace
                    Set-Content $file.FullName $filetextNew
                }
            }
            Write-Host "Files renamed operations has been finished with success" -ForegroundColor DarkGreen -BackgroundColor Green
        }
        catch { 
            Write-Host "An error has occurred during file renamed operation" -ForegroundColor Black -BackgroundColor Red
        }
        Write-Output ""
    }
    $utility = ''
    Fn-Restart
}
#endregion

Fn-Welcome