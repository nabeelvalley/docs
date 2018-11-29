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
