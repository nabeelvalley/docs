# Powershell

## [Modify function prompt](https://superuser.com/questions/446827/configure-the-windows-powershell-to-display-only-the-current-folder-name-in-the)

Open **Powershell** and type

```bash
notepad $profile
```

If the file does not exist you will be asked to create it, then paste the following

```powershell
function prompt {
  $p = Split-Path -leaf -path (Get-Location)
  "$p > "
}
```

You can replace the `$p >` part with anything you'd like to be displayed in your shell

Alternatively, if you would like to see the full path, and the command on the next line you can use

```powershell
function prompt {
  $p = Get-Location
  "$p
>"
}
```

## [Adding Aliases](https://docs.microsoft.com/en-us/powershell/module/microsoft.powershell.utility/set-alias?view=powershell-6)

We can add persistent aliases in our **profile** by defining functions for them, we can open our Powershell Profile

```powershell
notepad $profile
```

Then we can define a function to navigate to our Repo directory by adding the following to the profile

```powershell
function repo {
  set-location c:\Users\NabeelValley\Documents\DevEx\Repos
}
```

## Git Status for Sub-Directories

Check which folders have modified files (only goes one level deep)

```powershell
$notGit = "`nNot Git Repositories"
Get-ChildItem -Directory | ForEach-Object {
	Set-Location $($_.Name);
	$status = (git status) 2>&1
	if ($status -like "*fatal*") {
		$notGit += "`n-$($_.Name)"
	}
 	else {
		Write-Host "$($_.Name)" -ForegroundColor yellow;
	}
	if ($status -like "*nothing to commit*") {
		Write-Host "  All Good" -ForegroundColor green;
	}
	if ($status -like "*Changes to be committed*") {
		Write-Host "  Uncomitted Files" -ForegroundColor DarkRed;
	}
	if ($status -like "*modified*") {
		Write-Host "  Modified Files" -ForegroundColor DarkMagenta;
	}
	if ($status -like "*Untracked*") {
		Write-Host "  Untracked Files" -ForegroundColor Red;
	}
	if ($status -like "*pull*") {
		Write-Host "  Behind Origin" -ForegroundColor DarkGreen;
	}
	Set-Location ..
}

Write-Host $notGit;
```

# Zip and Unzip a File

```ps1
Compress-Archive .\DirectoryToZip .\NewFileName.zip
Expand-Archive .\FileToUnzip.zip .\DestinationDirectoryName
```

# Copy and Paste Files

Copy the current directory with:

```ps1
Get-ChildItem * | Set-Clipboard
```

Copy a single file with:

```ps1
Get-Item '.\FileToCopy.png' | Set-Clipboard
```

Paste Item with:

```ps1
Get-Clipboard -Format FileDropList | Copy-Item
```

# Send an Email

From [this StackOverflow Answer](https://stackoverflow.com/questions/12460950/how-to-pass-credentials-to-the-send-mailmessage-command-for-sending-emails)

```ps1
Function Send-EMail {
    Param (
        [Parameter(`
            Mandatory=$true)]
        [String]$EmailTo,
        [Parameter(`
            Mandatory=$true)]
        [String]$Subject,
        [Parameter(`
            Mandatory=$true)]
        [String]$Body,
        [Parameter(`
            Mandatory=$true)]
        [String]$EmailFrom="myself@gmail.com",  #This gives a default value to the $EmailFrom command
        [Parameter(`
            mandatory=$false)]
        [String]$attachment,
        [Parameter(`
            mandatory=$true)]
        [String]$Password
    )

        $SMTPServer = "smtp.gmail.com" 
        $SMTPMessage = New-Object System.Net.Mail.MailMessage($EmailFrom,$EmailTo,$Subject,$Body)
        if ($attachment -ne $null) {
            $SMTPattachment = New-Object System.Net.Mail.Attachment($attachment)
            $SMTPMessage.Attachments.Add($SMTPattachment)
        }
        $SMTPClient = New-Object Net.Mail.SmtpClient($SmtpServer, 587) 
        $SMTPClient.EnableSsl = $true 
        $SMTPClient.Credentials = New-Object System.Net.NetworkCredential($EmailFrom.Split("@")[0], $Password); 
        $SMTPClient.Send($SMTPMessage)
        Remove-Variable -Name SMTPClient
        Remove-Variable -Name Password

} 
```
