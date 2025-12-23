---
published: true
title: Powershell
subtitle: Tips and Tricks
description: Powershell tips and tricks
---

## Modify Prompt

> Based on [this](https://superuser.com/questions/446827/configure-the-windows-powershell-to-display-only-the-current-folder-name-in-the)

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

## Adding Aliases

> Based on [this](https://docs.microsoft.com/en-us/powershell/module/microsoft.powershell.utility/set-alias?view=powershell-6)

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

## View File Tree

You can view the folder and file tree in powershell using the `tree` command.

To view the Folders only in the current directory:

```powershell
tree
```

Which will output something like:

```
C:.
└───main
```

Or from another directory you can use:

```powershell
tree ./path/to/dir
```

> To refer to the current directory you can use `tree` without any directory, or `tree .` to refer to the current directory. Both ways are almost identical in terms of the output. Note that including the directory in the command results in the full directory path being written in the command's output

And to view the tree with files included, you can use:

```powershell
tree /f
```

Which will output something like:

```
C:.
└───main
        data.txt
```

And for another directory:

```powershell
tree ./path/to/dir /f
```

## Symlinks

> Support for `mklink` only exists on newer versions of Windows, otherwise you may need to use `New-Item`

Creating symlinks can be done with the `mklink` command which is an alias for the `New-Item -ItemType SymbolicLink` command

Using the base `New-Item` version, a symlink can be created with the below command where `data.txt` is the linked file we want to create and `./main/data.txt/ is the path to the existing file:

```powershell
New-Item -ItemType SymbolicLink -Name data.txt -Target ./main/data.txt
```

Which creates a file called `data.txt` which is linked to `./main/data.txt`

The `mklink` version of this is:

```powershell
mklink data.txt ./main/data.txt
```

> For more info see [this page](https://superuser.com/questions/1307360/how-do-you-create-a-new-symlink-in-windows-10-using-powershell-not-mklink-exe_

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

## Zip and Unzip a File

```ps1
Compress-Archive .\DirectoryToZip .\NewFileName.zip
Expand-Archive .\FileToUnzip.zip .\DestinationDirectoryName
```

## Copy and Paste Files

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

## Send an Email

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

## Troubleshooting Path Commands

If a command is not running the application/version of the application you'd expect you can try the following steps:

1. Refresh your path and try the command again, it may just not be up-to-date. You can use the following function to do that:

```ps1
function refresh {
  $env:Path = [System.Environment]::GetEnvironmentVariable("Path","Machine") + ";" + [System.Environment]::GetEnvironmentVariable("Path","User")
}
```

2. If you command is just generally being weird in some way it may be because it is defined/part of another path than the one you expect

To see where a command is being run from, you can try the following:

```ps1
Get-Command <command>
```

e.g. for node:

```ps1
Get-Command node
```

> e.g my `node` command was being problematic because it was running the one in my Anaconda path entry (because apparently Anaconda comes with Node)

3. In order to ensure that the correct application/command takes precedence move it higher up your path

## Create Drive Aliases

On Windows you can alias specific folders as virtual drives (for easy reference or to get around file length restrictions)

To view your aliases/drives you can run:

```
> subst
R:\: => C:\repos
```

To create a new drive you can use:

```
> subst X: C:\path\to\folder
```

Where `X` is the drive you would like to map to. Be sure not to have the trailing `\` in your folder name

> The path to the folder can also be relative: `.\my\rel\path`

To remove a drive run the following command:

```
> subst R: /D
```

## What Process is Using a Port

To view what process is using a specific port you can run the following command:

```ps1
Get-Process -Id (Get-NetTCPConnection -LocalPort 5000).OwningProcess
```

You can also use the following command:

```ps1
netstat -ano | findstr : 8000
```

## Killing Process by ID

If you have the PID, for example using one of the above commands, you can kill us using `taskkill`, for example for killing PID 1234

```ps1
taskkill /PID 1234 /F
```

## Zipping Files

To zip all the files in a directory you can use the following:

```ps1
Compress-Archive -Path ./* -DestinationPath ./output_file.zip
```

To zip a directory, including the root directory in the Zip use the following:

```ps1
Compress-Archive -Path ./dir_to_zip -DestinationPath Compress-Archive -Path ./* -DestinationPath ./output_file.zip
```

## Search for Devices on Network

To view the IP's of the different devices that are currently connected to your network you can use the following command:

```ps1
arp -a
```

## Connect to RDP

To use an RDP file you can make use of the `mstsc` command with a path to the RDP file you want to connec with:

```ps1
mstsc ./my-cool-server.rdp
```

Which will then open the RDP file

## Switch to Home Directory

You can switch to your home directory on Powershell with `cd ~`, the `~` directory represents the user's home, same as in other OS's and shells

## My Current \$PROFILE

Yout Powershell is a script that runs whenever you open a new powershell instance, the functions available in it become part of your session so you can just call them from the terminal. The path to this file is stored in every Powershell instance as the `$PROFILE` variable

To open your `$PROFILE` in notepad you can run:

```ps1
notepad $PROFILE
```

My current profile which has some common commands is here:

```ps1
## POWERSHELL CONFIGURATION FUNCTIONS
## ==================================
## THESE ARE CALLED BY POWERSHELL ITSELF

## SETS CUSTOM PROMPT, THIS FUNCTION GETS CALLED ON PS SETUP
function prompt {
  $p = Get-Location
  "$p
!"
}

## ENVIRONMENT FUNCTIONS
## =====================
## CONFIGURE ENVIRONMENT

## REFRESH SESSION ENVIRONMENT VARIABLES
function _refresh {
  $env:Path = [System.Environment]::GetEnvironmentVariable("Path","Machine") + ";" + [System.Environment]::GetEnvironmentVariable("Path","User")
}

## GENERAL UTILITIES
## =================

## NAVIGATION
## ^^^^^^^^^^

## CD TO MY REPOSITORIES
function _repo {
  Set-Location c:\repos
}

## CD TO MY DOCS
function _docs {
  Set-Location C:\repos\PersonalSite\static\content\docs
}

## GIT
## ^^^

## MERGE GIT "DEVELOP" TO "MASTER"
function _quickmerge {
  git push
  git checkout master
  git merge develop
  git push
  git checkout develop
}

## COMMIT ALL SUBMODULE'S FILES AND RUN SAME COMMIT ON PARENT REPO
## FOR THE UPDATED SUBMODULE. RUN FROM SUBMODULE DIRECOTRY
function _updatesub  {
  param(
    [string]$commitMessage
  )

  $submoduleFolder = Split-Path (Get-Location) -Leaf

  git add .
  git commit -m $commitMessage
  git push
  cd ..
  git add $submoduleFolder
  git commit -m $commitMessage
  git push
  cd $submoduleFolder
}

## FILE MANIPULATION
## ^^^^^^^^^^^^^^^^^

## COPY SOMETHING TO YOUR CLIPBOARD
function _copy {
  param(
    [string]$fileToCopy
  )

  Get-Item $fileToCopy | Set-Clipboard
}

## PASTE WHAT'S ON YOUR CLIPBOARD
function _paste {
  Get-Clipboard -Format FileDropList | Copy-Item
}

## RENAME A FILE
function _rename {
  param(
    [string]$currentFile,
    [string]$newName
  )

  Rename-Item -Path $currentFile $newName
}

## COPY AND RENAME FILE
function _dupe {
   param(
    [string]$currentFile,
    [string]$newName
  )
  $tempDir = ".temp_nvdupe"

  nvcopy $currentFile
  mkdir $tempDir
  cd $tempDir
  nvpaste
  nvrename $currentFile $newName
  nvcopy $newName
  cd ..
  nvpaste
  rm -r $tempDir
}
```
