[CmdletBinding()]
param(
    [Parameter(Mandatory = $true)]
    [ValidatePattern('^[A-Z][A-Za-z0-9]{0,61}$')]
    [string] $Name,

    [Parameter(Mandatory = $true)]
    [ValidatePattern('^[A-Za-z0-9](?:[A-Za-z0-9-]{0,38})$')]
    [string] $User
)

$ErrorActionPreference = "Stop"
$templateName = "RhinoFSharpTemplate"
$templateUser = "TemplateUser"
$repoRoot = [IO.Path]::GetFullPath((Split-Path -Parent (Split-Path -Parent $PSScriptRoot)))
$rootPrefix = $repoRoot.TrimEnd('\', '/') + [IO.Path]::DirectorySeparatorChar
$templateProject = Join-Path $repoRoot "$templateName.fsproj"
$scriptPath = [IO.Path]::GetFullPath($PSCommandPath)
$utf8WithoutBom = [Text.UTF8Encoding]::new($false)

if (-not (Test-Path -LiteralPath $templateProject -PathType Leaf)) {
    throw "This repository is already initialized or is missing '$templateName.fsproj'."
}

if ([string]::Equals($Name, $templateName, [StringComparison]::OrdinalIgnoreCase)) {
    throw "Choose a project name other than '$templateName'."
}

$renames = @(
    [PSCustomObject]@{
        Source = $templateProject
        Destination = Join-Path $repoRoot "$Name.fsproj"
    }
    [PSCustomObject]@{
        Source = Join-Path $repoRoot "src\Commands\${templateName}A.fs"
        Destination = Join-Path $repoRoot "src\Commands\${Name}A.fs"
    }
    [PSCustomObject]@{
        Source = Join-Path $repoRoot "src\Commands\${templateName}B.fs"
        Destination = Join-Path $repoRoot "src\Commands\${Name}B.fs"
    }
)

foreach ($rename in $renames) {
    if (Test-Path -LiteralPath $rename.Destination) {
        throw "Refusing to overwrite '$($rename.Destination)'."
    }
}

$environmentPrefix =
    [regex]::Replace($Name, '(?<=[a-z0-9])(?=[A-Z])', '_').ToUpperInvariant()

$pluginGuid = [guid]::NewGuid().ToString().ToUpperInvariant()
$commandAGuid = [guid]::NewGuid().ToString().ToUpperInvariant()
$commandBGuid = [guid]::NewGuid().ToString().ToUpperInvariant()

$replacements = @(
    [PSCustomObject]@{ Old = "11111111-1111-4111-8111-111111111111"; New = $pluginGuid }
    [PSCustomObject]@{ Old = "22222222-2222-4222-8222-222222222222"; New = $commandAGuid }
    [PSCustomObject]@{ Old = "33333333-3333-4333-8333-333333333333"; New = $commandBGuid }
    [PSCustomObject]@{ Old = "RHINO_FSHARP_TEMPLATE"; New = $environmentPrefix }
    [PSCustomObject]@{ Old = "rhino-fsharp-template"; New = $Name.ToLowerInvariant() }
    [PSCustomObject]@{ Old = "rhinofsharptemplate"; New = $Name.ToLowerInvariant() }
    [PSCustomObject]@{ Old = $templateName; New = $Name }
    [PSCustomObject]@{ Old = $templateUser; New = $User }
)

$ignoredDirectories = @(".git", "bin", "obj", "dist")
$textExtensions = @(".fs", ".fsproj", ".props", ".ps1", ".md", ".yml", ".yaml", ".json", ".txt")
$textNames = @(".editorconfig", ".gitattributes", ".gitignore", "LICENSE")

$textFiles = @(
    Get-ChildItem -LiteralPath $repoRoot -File -Recurse -Force |
        Where-Object {
            $relativePath = $_.FullName.Substring($rootPrefix.Length)
            $pathParts = $relativePath.Split([IO.Path]::DirectorySeparatorChar)
            $isIgnored = @($pathParts | Where-Object { $_ -in $ignoredDirectories }).Count -gt 0
            $isText = $_.Extension -in $textExtensions -or $_.Name -in $textNames

            -not $isIgnored -and $isText -and $_.FullName -ne $scriptPath
        }
)

foreach ($file in $textFiles) {
    $content = [IO.File]::ReadAllText($file.FullName)
    $updated = $content

    foreach ($replacement in $replacements) {
        $updated = $updated.Replace($replacement.Old, $replacement.New)
    }

    if ($updated -ne $content) {
        [IO.File]::WriteAllText($file.FullName, $updated, $utf8WithoutBom)
    }
}

$readme = Join-Path $repoRoot "README.md"
$readmeContent = [IO.File]::ReadAllText($readme)
$templateOnlyPattern = '(?s)<!-- TEMPLATE_ONLY_START -->.*?<!-- TEMPLATE_ONLY_END -->\r?\n?'
$readmeContent = [regex]::Replace($readmeContent, $templateOnlyPattern, "")
[IO.File]::WriteAllText($readme, $readmeContent, $utf8WithoutBom)

foreach ($rename in $renames) {
    Move-Item -LiteralPath $rename.Source -Destination $rename.Destination
}

Write-Host "Initialized $Name for $User at version 0.0.1."
Write-Host "Plug-in GUID: $pluginGuid"
Write-Host "Commands: ${Name}A and ${Name}B"
Write-Host "Next: .\build-and-install.ps1"

Remove-Item -LiteralPath $scriptPath -Force
Write-Host "Removed the one-time initializer."
