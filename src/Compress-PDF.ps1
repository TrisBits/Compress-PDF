<#
.SYNOPSIS
Compresses PDF files

.DESCRIPTION
The PDF files specified in the source directory are compressed and the results placed in the destination directory.

.PARAMETER SourceDirectory
Directory with the PDF files to compress.

.PARAMETER DestinationDirectory
Directory where the compressed PDF files will be saved.

.PARAMETER CompressionLevel
The level of compression to apply to the PDF.  Choices are screen, ebook, printer, prepress (most compression -> least compression).

.INPUTS
None. You cannot pipe objects to this script.

.OUTPUTS
None

.EXAMPLE
.\Compress-PDF.ps1 -

.EXAMPLE
.\Compress-PDF.ps1 -

#>


[Diagnostics.CodeAnalysis.SuppressMessageAttribute("PSUseApprovedVerbs", "")]
param(
    [Parameter(Mandatory = $true)]
    [string] $SourceDirectory,

    [Parameter(Mandatory = $true)]
    [string] $DestinationDirectory,

    [Parameter(Mandatory = $false)]
    [ValidateSet('screen', 'ebook', 'printer', 'prepress')]
    [string] $CompressionLevel = 'default'
)


if (Test-Path -Path "C:\Program Files\gs") {
    $gs = (Get-ChildItem -Path "C:\Program Files\gs\*gswin64c.exe" -Recurse).FullName
}
elseif (Test-Path -Path "C:\Program Files (x86)\gs"){
    $gs = (Get-ChildItem -Path "C:\Program Files (x86)\gs\*gswin32c.exe" -Recurse).FullName
}
else {
    Write-Output "GhostScript not found in default install location."
}

$filesToCompress = Get-ChildItem -Path $SourceDirectory -Filter *.pdf

foreach ($pdfFile in $filesToCompress) {
    $compressedFile = Join-Path -Path $DestinationDirectory -ChildPath $pdfFile.Name

    $arguments = "-sDEVICE=pdfwrite -dCompatibilityLevel=1.4 -dPDFSETTINGS=/$($CompressionLevel) -dNOPAUSE -dQUIET -dBATCH -sOutputFile=`"$($compressedFile)`" `"$($pdfFile.FullName)`""
    Start-Process $gs -ArgumentList $Arguments -Wait -WindowStyle Hidden -PassThru
}
