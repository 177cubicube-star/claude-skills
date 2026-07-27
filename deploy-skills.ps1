<#
.SYNOPSIS
  Déploie les skills de la maison vers la cible qui les exécute réellement.

.DESCRIPTION
  Source  : <ce dépôt>\.claude\skills\
  Cible   : $HOME\.claude\SKILLS\

  Pourquoi cette cible et pas --add-dir : mesuré le 2026-07-26 (Windows) et
  répliqué le 2026-07-27 (Linux), CLI 2.1.220 — un skill personnel l'emporte
  sur son homonyme atteint par --add-dir ET sur celui du projet courant, et il
  l'EFFACE de la liste. La copie est donc ce qui tourne. Ce script n'est pas un
  confort : c'est le seul chemin par lequel une modification de la maison
  atteint une session.

  Par défaut le script ne fait qu'AFFICHER ce qu'il changerait. Il faut -Apply
  pour écrire. Rien n'est jamais supprimé côté cible.

.PARAMETER Apply
  Écrit réellement. Sans ce drapeau, simple rapport.

.PARAMETER Backup
  Avant d'écrire, copie la cible entière dans
  Documents\Claude\sauvegardes\skills-sauvegarde-AAAAMMJJ\.

.EXAMPLE
  .\deploy-skills.ps1                 # que changerait un déploiement ?
  .\deploy-skills.ps1 -Apply -Backup  # déploie, après sauvegarde datée
#>

[CmdletBinding()]
param(
    [switch]$Apply,
    [switch]$Backup
)

$ErrorActionPreference = 'Stop'

$source = Join-Path $PSScriptRoot '.claude\skills'
$cible  = Join-Path $HOME '.claude\SKILLS'

if (-not (Test-Path -LiteralPath $source)) { throw "Source introuvable : $source" }
if (-not (Test-Path -LiteralPath $cible))  { throw "Cible introuvable : $cible" }

Write-Host "source : $source"
Write-Host "cible  : $cible"
Write-Host ""

# Comparaison de contenu, insensible aux fins de ligne : git réécrit la source
# en CRLF au checkout (.gitattributes text=auto) alors que la cible reste en LF.
# Comparer les octets ferait voir une divergence sur chaque fichier.
function Get-Empreinte {
    param([string]$Chemin)
    $t = (Get-Content -LiteralPath $Chemin -Raw -Encoding UTF8) -replace "`r`n", "`n"
    $md5 = [System.Security.Cryptography.MD5]::Create()
    $h = $md5.ComputeHash([System.Text.Encoding]::UTF8.GetBytes($t))
    return [System.BitConverter]::ToString($h)
}

$aEcrire = @()
$identiques = 0

foreach ($skill in Get-ChildItem -LiteralPath $source -Directory) {
    foreach ($f in Get-ChildItem -LiteralPath $skill.FullName -Recurse -File) {
        $relatif = $f.FullName.Substring($source.Length).TrimStart('\')
        $dst = Join-Path $cible $relatif
        if (-not (Test-Path -LiteralPath $dst)) {
            $aEcrire += [pscustomobject]@{ Etat = 'NOUVEAU'; Fichier = $relatif; Src = $f.FullName; Dst = $dst }
        }
        elseif ((Get-Empreinte $f.FullName) -ne (Get-Empreinte $dst)) {
            $aEcrire += [pscustomobject]@{ Etat = 'MODIFIE'; Fichier = $relatif; Src = $f.FullName; Dst = $dst }
        }
        else { $identiques++ }
    }
}

# Ce qui existe à la cible sans exister à la source : signalé, JAMAIS supprimé.
$orphelins = @()
foreach ($f in Get-ChildItem -LiteralPath $cible -Recurse -File) {
    $relatif = $f.FullName.Substring($cible.Length).TrimStart('\')
    if (-not (Test-Path -LiteralPath (Join-Path $source $relatif))) { $orphelins += $relatif }
}

if ($aEcrire.Count -eq 0) {
    Write-Host "A JOUR — $identiques fichier(s) identique(s), rien a deployer." -ForegroundColor Green
} else {
    Write-Host "$($aEcrire.Count) fichier(s) a deployer ($identiques deja identiques) :"
    $aEcrire | ForEach-Object { Write-Host ("  {0,-8} {1}" -f $_.Etat, $_.Fichier) }
}

if ($orphelins.Count -gt 0) {
    Write-Host ""
    Write-Host "$($orphelins.Count) fichier(s) presents a la cible mais absents de la maison :" -ForegroundColor Yellow
    $orphelins | ForEach-Object { Write-Host "  ORPHELIN $_" }
    Write-Host "  -> jamais supprimes par ce script. A traiter a la main si voulu." -ForegroundColor Yellow
}

if (-not $Apply) {
    Write-Host ""
    Write-Host "Rapport seulement. Relancer avec -Apply pour ecrire." -ForegroundColor Cyan
    return
}

if ($aEcrire.Count -eq 0) { return }

if ($Backup) {
    $dossier = Join-Path $HOME ("Documents\Claude\sauvegardes\skills-sauvegarde-" + (Get-Date -Format 'yyyyMMdd'))
    if (-not (Test-Path -LiteralPath $dossier)) { New-Item -ItemType Directory -Force -Path $dossier | Out-Null }
    robocopy $cible $dossier /E /COPY:DAT /R:1 /W:1 /NFL /NDL /NP | Out-Null
    if ($LASTEXITCODE -ge 8) { throw "Sauvegarde echouee (robocopy $LASTEXITCODE). Rien ecrit." }
    Write-Host "Sauvegarde : $dossier" -ForegroundColor Green
}

foreach ($e in $aEcrire) {
    $parent = Split-Path -Parent $e.Dst
    if (-not (Test-Path -LiteralPath $parent)) { New-Item -ItemType Directory -Force -Path $parent | Out-Null }
    Copy-Item -LiteralPath $e.Src -Destination $e.Dst -Force
    Write-Host ("  ecrit   {0}" -f $e.Fichier)
}

# Verification apres ecriture : mesurer l'effet, pas se fier au rapport.
$restant = @($aEcrire | Where-Object { (Get-Empreinte $_.Src) -ne (Get-Empreinte $_.Dst) })
if ($restant.Count -eq 0) {
    Write-Host ""
    Write-Host "DEPLOYE — $($aEcrire.Count) fichier(s), tous verifies identiques apres ecriture." -ForegroundColor Green
    Write-Host "Les sessions deja ouvertes ne voient pas le changement : relancer." -ForegroundColor Cyan
} else {
    Write-Host ""
    Write-Host "ECHEC — $($restant.Count) fichier(s) divergent(s) APRES ecriture :" -ForegroundColor Red
    $restant | ForEach-Object { Write-Host "  $($_.Fichier)" }
    exit 1
}
