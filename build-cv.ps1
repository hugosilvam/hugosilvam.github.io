<#
.SYNOPSIS
  Compiles the CV from its bilingual Overleaf source into pdf/cv.pdf and pdf/cv-es.pdf.

.DESCRIPTION
  The CV lives in the Overleaf-synced Dropbox folder, not in this repo, so it stays
  editable in the browser. One file, main.tex, holds both languages: every translatable
  string is wrapped in \tr{english}{spanish}. This script compiles it twice and is the
  only thing that writes the PDFs.

  Workflow: edit main.tex on Overleaf, let Dropbox sync, run this, commit the PDFs.

  LaTeX runs in a scratch directory so no .aux/.log/.out files land in the Overleaf
  folder, which would otherwise sync back to the project.

.EXAMPLE
  .\build-cv.ps1

.EXAMPLE
  .\build-cv.ps1 -Language es

.EXAMPLE
  .\build-cv.ps1 -Source "D:\other\cv.tex"
#>
[CmdletBinding()]
param(
  [string]$Source = "$HOME\Dropbox\Apps\Overleaf\CV - Curriculum\main.tex",
  [string]$OutputDir = "$PSScriptRoot\pdf",
  [ValidateSet('both', 'en', 'es')]
  [string]$Language = 'both'
)

$ErrorActionPreference = 'Stop'

if (-not (Test-Path -LiteralPath $Source)) {
  throw "CV source not found: $Source`nIf the Overleaf project moved, pass -Source <path to .tex>."
}

# pdflatex directly rather than latexmk: latexmk is a Perl script and MiKTeX here has no
# Perl. main.tex has no \input of local files, no graphics and no bibliography, so a fixed
# two-pass run is equivalent. If the CV ever gains \ref or \cite, add a third pass.
$pdflatex = Get-Command pdflatex -ErrorAction SilentlyContinue
if (-not $pdflatex) { throw "pdflatex not found on PATH. Install MiKTeX or add it to PATH." }

$src = (Resolve-Path -LiteralPath $Source).Path
# TeX accepts forward slashes on Windows, and \input{} braces tolerate the spaces in
# "CV - Curriculum". Backslashes would be read as escape sequences.
$texPath = $src -replace '\\', '/'

$work = Join-Path $env:TEMP 'cv-build'
if (-not (Test-Path -LiteralPath $work)) { New-Item -ItemType Directory -Path $work | Out-Null }
if (-not (Test-Path -LiteralPath $OutputDir)) { New-Item -ItemType Directory -Path $OutputDir | Out-Null }

$targets = @(
  @{ Lang = 'en'; Job = 'cv';    Label = 'English' },
  @{ Lang = 'es'; Job = 'cv-es'; Label = 'Spanish' }
) | Where-Object { $Language -eq 'both' -or $_.Lang -eq $Language }

Write-Host "Source : $src"
Write-Host "Build  : $work"
Write-Host ""

$results = @()

foreach ($t in $targets) {
  $job = $t.Job

  # --enable-installer lets MiKTeX fetch a missing package without an interactive prompt,
  # which would otherwise hang the script.
  # Do not merge stderr into the pipeline: Windows PowerShell 5.1 turns every stderr line
  # from a native exe into a NativeCommandError. pdflatex writes a .log anyway.
  $code = 0
  foreach ($pass in 1, 2) {
    Write-Host "$($t.Label): pdflatex pass $pass ..."
    & $pdflatex.Source -interaction=nonstopmode -halt-on-error --enable-installer `
        -jobname="$job" -output-directory="$work" `
        "\def\cvlang{$($t.Lang)}\input{$texPath}" | Out-Null
    $code = $LASTEXITCODE
    if ($code -ne 0) { break }
  }

  $built   = Join-Path $work "$job.pdf"
  $logFile = Join-Path $work "$job.log"

  if ($code -ne 0 -or -not (Test-Path -LiteralPath $built)) {
    if (Test-Path -LiteralPath $logFile) {
      Write-Host "`nErrors from $logFile :" -ForegroundColor Yellow
      Select-String -LiteralPath $logFile -Pattern '^(!|l\.\d)' |
        Select-Object -First 20 -ExpandProperty Line
    }
    throw "LaTeX build failed for $($t.Label) (exit $code). Full log: $logFile"
  }

  $dest = Join-Path $OutputDir "$job.pdf"
  Copy-Item -LiteralPath $built -Destination $dest -Force

  $results += [pscustomobject]@{
    Language = $t.Label
    File     = $dest
    KB       = [math]::Round((Get-Item -LiteralPath $dest).Length / 1KB, 1)
    Pages    = (Select-String -LiteralPath $logFile -Pattern 'Output written .*\((\d+) pages?' |
                Select-Object -First 1).Matches.Groups[1].Value
  }
}

# The CV prints its own date under the name; surface it so a stale build is obvious.
$dateLine = (Select-String -LiteralPath $src -Pattern '\\tr\{(\w+)\}\{(\w+)\},\s*(\d{4})' |
             Select-Object -First 1).Matches
if ($dateLine) { $stamp = "$($dateLine.Groups[1].Value) / $($dateLine.Groups[2].Value) $($dateLine.Groups[3].Value)" }

Write-Host ""
$results | Format-Table Language, KB, Pages, File -AutoSize | Out-String -Width 200 | Write-Host
if ($stamp) { Write-Host "CV date line: $stamp" }

# Spanish strings drafted but not yet approved by Hugo are tagged in the source.
$todo = @(Select-String -LiteralPath $src -Pattern '%\s*\[REVISAR\]').Count
if ($todo -gt 0) {
  Write-Host "$todo lines still marked % [REVISAR] in main.tex (Spanish pending your review)." -ForegroundColor Yellow
}

Write-Host ""
Write-Host "Next: git add pdf/cv.pdf pdf/cv-es.pdf; git commit -m 'CV update'; git push"
