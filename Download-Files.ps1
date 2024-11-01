param (
    [string]$FileName = "plugins.txt"
)

# Define the path to the plugins.txt file and the Plugins folder
$pluginsFilePath = $FileName
$pluginsFolderPath = $FileName.Replace(".txt", "")

# Create the Plugins folder if it doesn't exist
if (-not (Test-Path -Path $pluginsFolderPath)) {
    New-Item -ItemType Directory -Path $pluginsFolderPath
}

# Read the URLs from the plugins.txt file
$pluginUrls = Get-Content -Path $pluginsFilePath

# Download each plugin to the Plugins folder
foreach ($url in $pluginUrls) {
    $fileName = [System.IO.Path]::GetFileName($url)
    if (test-path "$pluginsFolderPath\$fileName") {
        Write-Host "$fileName already exists in $pluginsFolderPath" -ForegroundColor Green
        continue
    }

    Write-Host "Downloading $fileName to $pluginsFolderPath" -ForegroundColor Magenta
    # Extract the file name from the URL
    $fileName = [System.IO.Path]::GetFileName($url)
    # Define the destination path for the downloaded file
    $destinationPath = Join-Path -Path $pluginsFolderPath -ChildPath $fileName
    # Download the file
    Invoke-WebRequest -Uri $url -OutFile $destinationPath
}