param(
    [Parameter(Mandatory = $true)]
    [string]$OutputPath,
    [switch]$UseSystemScreenshot
)

$ErrorActionPreference = 'Stop'

if (-not $UseSystemScreenshot) {
    throw "This helper expects -UseSystemScreenshot."
}

Add-Type -AssemblyName System.Drawing
Add-Type -AssemblyName System.Windows.Forms

$bounds = [System.Windows.Forms.SystemInformation]::VirtualScreen
$bmp = New-Object System.Drawing.Bitmap $bounds.Width, $bounds.Height
$graphics = [System.Drawing.Graphics]::FromImage($bmp)

try {
    $graphics.CopyFromScreen($bounds.X, $bounds.Y, 0, 0, $bounds.Size)
    $parent = Split-Path -Parent $OutputPath
    if ($parent) {
        New-Item -ItemType Directory -Force -Path $parent | Out-Null
    }
    $bmp.Save($OutputPath, [System.Drawing.Imaging.ImageFormat]::Png)
    Write-Output $OutputPath
} finally {
    $graphics.Dispose()
    $bmp.Dispose()
}
