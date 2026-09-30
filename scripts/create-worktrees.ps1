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

# A deleted directory leaves a Git worktree registration behind. Clear stale
# registrations before reusing its branch and path.
git worktree prune --expire now
if ($LASTEXITCODE -ne 0) {
    throw "Could not clean stale Git worktree registrations."
}

foreach ($name in @("frontend", "backend")) {
    $branch = "work/$name"
    $path = Join-Path $rootPath $name
    if (Test-Path -LiteralPath $path) {
        if (Test-Path -LiteralPath (Join-Path $path ".git")) {
            $currentBranch = git -C $path branch --show-current
            if ($LASTEXITCODE -ne 0 -or $currentBranch -ne $branch) {
                throw "Existing worktree at $path is not on $branch."
            }
            Write-Host "Already ready: $path"
            continue
        }

        if ((Get-ChildItem -LiteralPath $path -Force | Select-Object -First 1)) {
            throw "Directory exists but is not a worktree: $path. Move its contents before retrying."
        }
    }

    git show-ref --verify --quiet "refs/heads/$branch"
    if ($LASTEXITCODE -eq 0) {
        git worktree add $path $branch
    } else {
        git worktree add -b $branch $path HEAD
    }
    if ($LASTEXITCODE -ne 0) {
        throw "Could not create $name worktree. Check whether branch '$branch' is open elsewhere."
    }
}

Write-Host "Frontend and Backend worktrees are ready under $rootPath"
