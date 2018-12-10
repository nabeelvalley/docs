$readme_title = "Nabeel's Docs"
$asset_folder = ".gitbook"

$summary = "# Table of Contents`n`n* [$readme_title](README.md)`n`n"

Get-ChildItem -Directory | ForEach-Object {
	$directory = $_.Name
	if ($directory-ne $asset_folder) {
		$print_dir = ""
		$dir_words = $directory.split("-")
		foreach ($word in $dir_words) {
			$print_dir += $word.substring(0, 1).toupper() + $word.substring(1) + " "
		}
		$summary += "## $print_dir`n`n"
		Set-Location $directory;
		Get-ChildItem -File | ForEach-Object {
			$file = $_.Name
			$line = (Get-Content $file -First 1).Replace("# ", "")
			$summary += "* [$line]($directory/$file)`n"
		}
		$summary += "`n"
		Set-Location ..
	}
}

$summary | Out-File "README.md"