param(
    [string]$WorktreeRoot = ".worktrees"
)

$ErrorActionPreference = "Stop"
$repoRoot = (Resolve-Path (Join-Path $PSScriptRoot "..")).Path
Set-Location $repoRoot

git rev-parse --verify HEAD *> $null
if ($LASTEXITCODE -ne 0) {
    throw "This starter needs an initial Git commit. See the first setup steps in README.md."
}

$rootPath = [System.IO.Path]::GetFullPath((Join-Path $repoRoot $WorktreeRoot))
New-Item -ItemType Directory -Force -Path $rootPath | Out-Null

foreach ($name in @("frontend", "backend")) {
    $branch = "work/$name"
    $path = Join-Path $rootPath $name
    if (Test-Path -LiteralPath $path) {
        Write-Host "Already exists: $path"
        continue
    }

    git worktree add -b $branch $path HEAD
    if ($LASTEXITCODE -ne 0) {
        throw "Could not create $name worktree. Check whether branch '$branch' already exists."
    }
}

Write-Host "Frontend and Backend worktrees are ready under $rootPath"
