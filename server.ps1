param(
    [int]$Port = 8080
)

$ErrorActionPreference = "Stop"
Add-Type -AssemblyName System.Web

$root = Split-Path -Parent $MyInvocation.MyCommand.Path
$listener = New-Object System.Net.HttpListener
$prefix = "http://localhost:$Port/"
$listener.Prefixes.Add($prefix)
$listener.Start()

Start-Process "http://localhost:$Port/%C4%91ang%20ch%E1%BB%89nh.html"

Write-Host "Photobooth server đang chạy tại $prefix"
Write-Host "Mở file: http://localhost:$Port/%C4%91ang%20ch%E1%BB%89nh.html"
Write-Host "Nhấn Ctrl+C để dừng."

function Get-ContentType([string]$path) {
    switch ([System.IO.Path]::GetExtension($path).ToLowerInvariant()) {
        ".html" { "text/html; charset=utf-8" }
        ".htm"  { "text/html; charset=utf-8" }
        ".js"   { "application/javascript; charset=utf-8" }
        ".css"  { "text/css; charset=utf-8" }
        ".json" { "application/json; charset=utf-8" }
        ".png"  { "image/png" }
        ".jpg"  { "image/jpeg" }
        ".jpeg" { "image/jpeg" }
        ".webp" { "image/webp" }
        ".gif"  { "image/gif" }
        ".svg"  { "image/svg+xml" }
        ".ico"  { "image/x-icon" }
        ".ttf"  { "font/ttf" }
        ".otf"  { "font/otf" }
        ".woff" { "font/woff" }
        ".woff2"{ "font/woff2" }
        ".mp4"  { "video/mp4" }
        ".webm" { "video/webm" }
        default { "application/octet-stream" }
    }
}

try {
    while ($listener.IsListening) {
        $context = $listener.GetContext()
        try {
            $req = $context.Request
            $res = $context.Response

            $relative = [System.Web.HttpUtility]::UrlDecode($req.Url.AbsolutePath.TrimStart('/'))
            if ([string]::IsNullOrWhiteSpace($relative)) { $relative = "đang chỉnh.html" }

            $filePath = Join-Path $root $relative
            $fullRoot = [System.IO.Path]::GetFullPath($root)
            $fullPath = [System.IO.Path]::GetFullPath($filePath)

            if (-not $fullPath.StartsWith($fullRoot)) {
                $res.StatusCode = 403
                $bytes = [System.Text.Encoding]::UTF8.GetBytes("403 Forbidden")
                $res.OutputStream.Write($bytes, 0, $bytes.Length)
                $res.Close()
                continue
            }

            if (-not (Test-Path $fullPath -PathType Leaf)) {
                $res.StatusCode = 404
                $bytes = [System.Text.Encoding]::UTF8.GetBytes("404 Not Found")
                $res.OutputStream.Write($bytes, 0, $bytes.Length)
                $res.Close()
                continue
            }

            $bytes = [System.IO.File]::ReadAllBytes($fullPath)
            $res.ContentType = Get-ContentType $fullPath
            $res.ContentLength64 = $bytes.Length
            $res.AddHeader("Cache-Control", "no-store")
            $res.OutputStream.Write($bytes, 0, $bytes.Length)
            $res.Close()
        } catch {
            try {
                $context.Response.StatusCode = 500
                $bytes = [System.Text.Encoding]::UTF8.GetBytes("500 Server Error")
                $context.Response.OutputStream.Write($bytes, 0, $bytes.Length)
                $context.Response.Close()
            } catch {}
        }
    }
}
finally {
    if ($listener) { $listener.Stop(); $listener.Close() }
}
