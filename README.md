# Compress-PDF

## Requirements

- This script requires the application GhostScript to be installed in its default path (<https://ghostscript.com/>).

## Instructions

- Download the code as a zip file.
- Unzip the contents to a location of your choosing.
- Open a PowerShell window and browse to the location of the Compress-PDF.ps1 script. Alternatively you can execute the script by specifying the full path.
- Execute the script by following the usage examples below. If you recieve the error "not digitally signed" you will first need to execute the command Unblock-File -Path .\Compress-PDF.ps1

## Parameters

- `SourceDirectory`

  Directory with the PDF files to compress.

- `DestinationDirectory`

  Directory where the compressed PDF files will be saved.

- `CompressionLevel`

  The level of compression to apply to the PDF.  Choices are **screen**, **ebook**, **printer**, **prepress** (most compression -> least compression).
  If the parameter is not included the GhostScript **default** compression level will be used.

## Usage Examples

**Example 1:**

Compress all PDF files in the source directory to the ebook compression level, and the results are saved to the destination directory.

```PowerShell
.\Compress-PDF.ps1 -SourceDirectory "C:\Temp\PdfSource" -DestinationDirectory "C:\Temp\PdfDestination" -CompressionLevel ebook
```

**Example 2:**

Compress all PDF files in the source directory to the default compression level, and the results are saved to the destination directory.

```PowerShell
.\Compress-PDF.ps1 -SourceDirectory "C:\Temp\PdfSource" -DestinationDirectory "C:\Temp\PdfDestination"
```
