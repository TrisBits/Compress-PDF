<#
.SYNOPSIS
Compresses PDF files

.DESCRIPTION
The PDF files specified in the source directory are compressed and the results placed in the destination directory.

DEPENDENCY:  This script requires the application GhostScript to be installed in its default path (https://ghostscript.com/).

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
.\Compress-PDF.ps1 -SourceDirectory "C:\Temp\PdfSource" -DestinationDirectory "C:\Temp\PdfDestination" -CompressionLevel ebook

.EXAMPLE
.\Compress-PDF.ps1 -SourceDirectory "C:\Temp\PdfSource" -DestinationDirectory "C:\Temp\PdfDestination"

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


function Invoke-Process {
    [CmdletBinding(SupportsShouldProcess)]
    param(
        [Parameter(Mandatory)]
        [ValidateNotNullOrEmpty()]
        [string]$FilePath,

        [Parameter()]
        [ValidateNotNullOrEmpty()]
        [string]$ArgumentList
    )

    # VERSION 1.4
    # GUID b787dc5d-8d11-45e9-aeef-5cf3a1f690de
    # AUTHOR Adam Bertram
    # COMPANYNAME Adam the Automator, LLC
    # URL: https://www.powershellgallery.com/packages/Invoke-Process
    # DESCRIPTION
    #   Invoke-Process is a simple wrapper function that aims to "PowerShellyify" launching typical external processes. There
    #   are lots of ways to invoke processes in PowerShell with Start-Process, Invoke-Expression, & and others but none account
    #   well for the various streams and exit codes that an external process returns. Also, it's hard to write good tests
    #   when launching external proceses.
    #   This function ensures any errors are sent to the error stream, standard output is sent via the Output stream and any
    #   time the process returns an exit code other than 0, treat it as an error.

    $ErrorActionPreference = 'Stop'

    try {
        $stdOutTempFile = "$env:TEMP\$((New-Guid).Guid)"
        $stdErrTempFile = "$env:TEMP\$((New-Guid).Guid)"

        $startProcessParams = @{
            FilePath               = $FilePath
            ArgumentList           = $ArgumentList
            RedirectStandardError  = $stdErrTempFile
            RedirectStandardOutput = $stdOutTempFile
            Wait                   = $true;
            PassThru               = $true;
            NoNewWindow            = $true;
        }

        if ($PSCmdlet.ShouldProcess("Process [$($FilePath)]", "Run with args: [$($ArgumentList)]")) {
            $cmd = Start-Process @startProcessParams
            $cmdOutput = Get-Content -Path $stdOutTempFile -Raw
            $cmdError = Get-Content -Path $stdErrTempFile -Raw
            if ($cmd.ExitCode -ne 0) {
                if ($cmdError) {
                    throw $cmdError.Trim()
                }
                if ($cmdOutput) {
                    throw $cmdOutput.Trim()
                }
            }
            else {
                if ([string]::IsNullOrEmpty($cmdOutput) -eq $false) {
                    Write-Output -InputObject $cmdOutput
                }
            }
        }
    }
    catch {
        $PSCmdlet.ThrowTerminatingError($_)
    }
    finally {
        Remove-Item -Path $stdOutTempFile, $stdErrTempFile -Force -ErrorAction Ignore
    }
}



if (Test-Path -Path "C:\Program Files\gs") {
    $gs = (Get-ChildItem -Path "C:\Program Files\gs\*gswin64c.exe" -Recurse).FullName
}
elseif (Test-Path -Path "C:\Program Files (x86)\gs") {
    $gs = (Get-ChildItem -Path "C:\Program Files (x86)\gs\*gswin32c.exe" -Recurse).FullName
}
else {
    Write-Host "GhostScript not found in default install location." -ForegroundColor Red
}

$filesToCompress = Get-ChildItem -Path $SourceDirectory -Filter *.pdf

foreach ($pdfFile in $filesToCompress) {
    $compressedFile = Join-Path -Path $DestinationDirectory -ChildPath $pdfFile.Name

    $arguments = "-sDEVICE=pdfwrite -dCompatibilityLevel=1.4 -dPDFSETTINGS=/$($CompressionLevel) -dNOPAUSE -dQUIET -dBATCH -sOutputFile=`"$($compressedFile)`" `"$($pdfFile.FullName)`""
    Write-Host "Processing file $($pdfFile.Name)" -ForegroundColor Cyan
    Invoke-Process -FilePath $gs -ArgumentList $arguments
}
