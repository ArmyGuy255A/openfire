
# Download Plugins
./Download-Files.ps1 -FileName Plugins.txt

# Download Windows Files
./Download-Files.ps1 -FileName Windows.txt

# Read the openfire version
$openfireVersion = Get-Content openfire_version.txt

# Check if we're on the correct openfire branch
$currentBranch = git branch --show-current

# Check if the branch already exists
$branchExists = $(git branch --list "$openfireVersion").trim()

if ($branchExists) {
    Write-Host "Branch $openfireVersion already exists." -ForegroundColor Green
} else {
    Write-Host "Branch $openfireVersion does not exist. Preparing a new branch for this version..." -ForegroundColor Yellow
    git branch "$openfireVersion"

    # Reset buildver.txt
    Set-Content -Path buildver.txt -Value "0"
}

# Switch to the branch if we're not already on it
if ($currentBranch -ne $openfireVersion) {
    Write-Host "Switching to branch $openfireVersion..." -ForegroundColor Yellow
    git checkout "$openfireVersion"
} else {
    Write-Host "Already on branch $openfireVersion." -ForegroundColor Green
}

# Check if the tag already exists on this branch
$tagExists = git tag -l "$openfireVersion"

if ($tagExists) {
    Write-Host "Tag $openfireVersion already exists on the current branch." -ForegroundColor Green
} else {
    Write-Host "Tag $openfireVersion does not exist. Tagging this version..." -ForegroundColor Yellow

    # Tag the branch with the openfire version
    git tag -a "$openfireVersion" -m "Running Openfire Version: $openfireVersion"
}

# Increment the build version
$buildVersion = Get-Content buildver.txt
$newBuildVersion = $buildVersion + 1
Set-Content -Path buildver.txt -Value $newBuildVersion


# Add all modified files and commit
git add .
git commit -m ("{0}:v{1}" -f $openfireVersion, $newBuildVersion )

$remoteRepo = git remote -v | Select-String -Pattern "origin\s+" | ForEach-Object {
    ($_ -split '\s+')[1]  # Extract the URL part
}

$matches = $remoteRepo -match "^https://(.+?)/"

if ($matches.Length -gt 0) {
    $remoteRepo = $matches[0]
    Write-Host "Remote repository found: $remoteRepo" -ForegroundColor Green
} else {
    Write-Host "No remote found. Skipping attempt to push to remote repository." -ForegroundColor Yellow
}



# Push the branch and tag to the remote repository if we're online
$result = Invoke-WebRequest $remoteRepo -UseBasicParsing -TimeoutSec 2 -ErrorAction SilentlyContinue

if ($result.StatusCode -eq 200) {
    Write-Host "Pushing branch $openfireVersion and tag $openfireVersion to the remote repository..." -ForegroundColor Yellow
    git push origin "$openfireVersion"
} else {
    Write-Host "Not connected to the internet. Skipping push to remote repository." -ForegroundColor Yellow
}

# Build and tag the Docker image
docker build `
    -t "armyguy255a/openfire:latest" `
    -t "armyguy255a/openfire:$openfireVersion" `
    -t "armyguy255a/openfire:v$newBuildVersion" .
