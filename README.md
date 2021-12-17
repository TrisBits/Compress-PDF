# Compress-PDF

## Requirements

- This script requires the application GhostScript to be installed in its default path (<https://ghostscript.com/>).

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
