
# Download Plugins
./Download-Files.ps1 -FileName Plugins.txt

# Download Windows Files
./Download-Files.ps1 -FileName Windows.txt

# Read the openfire version
$openfireVersion = Get-Content openfire_version.txt

# Check if we're on the correct openfire branch
$currentBranch = git branch --show-current

# Store the expected branch name
$expectedBranch = "$openfireVersion"

# Check if the branch already exists
$branchExists = $(git branch --list "$expectedBranch")
if ($branchExists) {
    $branchExists = $branchExists.Trim()
}

if ($branchExists) {
    Write-Host "Branch $expectedBranch already exists." -ForegroundColor Green
} else {
    Write-Host "Branch $expectedBranch does not exist. Preparing a new branch for this version..." -ForegroundColor Yellow
    git branch "$expectedBranch"

    # Reset buildver.txt
    Set-Content -Path buildver.txt -Value "0"
}

# Switch to the branch if we're not already on it
if ($currentBranch -ne $expectedBranch) {
    Write-Host "Switching to branch $expectedBranch..." -ForegroundColor Yellow
    git checkout "$expectedBranch"
} else {
    Write-Host "Already on branch $expectedBranch." -ForegroundColor Green
}

# Check if the tag already exists on this branch
$tagName = "openfire-$openfireVersion"
$tagExists = git tag -l "$tagName"

if ($tagExists) {
    Write-Host "Tag $tagName already exists on the current branch." -ForegroundColor Green
    Write-Host "Removing the tag and re-tagging this version..." -ForegroundColor Yellow
    git tag -d "$tagName"
    git tag -a "$tagName" -m "Running Openfire Version: $openfireVersion"
} else {
    Write-Host "Tag $tagName does not exist. Tagging this version..." -ForegroundColor Yellow

    # Tag the branch with the openfire version
    git tag -a "$tagName" -m "Running Openfire Version: $openfireVersion"
}

# Increment the build version
[int]$buildVersion = Get-Content buildver.txt
$newBuildVersion = $buildVersion + 1
Set-Content -Path buildver.txt -Value $newBuildVersion


# Add all modified files and commit
git add .
git commit -m ("{0}:v{1}" -f $openfireVersion, $newBuildVersion )

$remoteRepo = $null
$remoteRepos = git remote -v | Select-String -Pattern "origin\s+" | ForEach-Object {
    ($_ -split '\s+')[1]  # Extract the URL part
}

$checkRemoteRepo = $false
if ($null -ne $remoteRepos -and $remoteRepos.Length -gt 0) {

    $remoteRepo = $remoteRepos[0]
    if (-not $remoteRepo.Contains("http")) {
        Write-Host "Remote repository is not an HTTP URL. Skipping an attempt to push."
    } else {
        Write-Host "Remote repository found: $remoteRepo" -ForegroundColor Green
        $checkRemoteRepo = $true
    }
    
} else {
    Write-Host "No remote repository found. Checking if we're online..." -ForegroundColor Yellow
}

# Push the branch and tag to the remote repository if we're online
if ($checkRemoteRepo) {
    Write-Host "Checking if we're online..." -ForegroundColor Yellow
    $result = Invoke-WebRequest $remoteRepo -UseBasicParsing -TimeoutSec 2 -ErrorAction SilentlyContinue

    if ($result.StatusCode -eq 200) {
        Write-Host "Pushing branch $expectedBranch and tag $expectedBranch to the remote repository..." -ForegroundColor Green
        git push --set-upstream origin $expectedBranch
    } else {
        Write-Host "Not connected to the internet. Skipping push to remote repository." -ForegroundColor Yellow
    }
}

# Build and tag the Docker image
$buildArgOpenfireVersion = $openfireVersion.Replace(".", "_")
docker build `
    --build-arg OPENFIRE_VERSION=$buildArgOpenfireVersion `
    -t "armyguy255a/openfire:latest" `
    -t ("armyguy255a/openfire:{0}" -f $openfireVersion) `
    -t ("armyguy255a/openfire:{0}v{1}" -f $openfireVersion, $newBuildVersion) .

    