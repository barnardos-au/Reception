$pfxname = 'devHttps.pfx'
$password = 'password'

$scriptPath = Split-Path $MyInvocation.MyCommand.Path -Parent
$pfxpath = Join-Path $scriptPath $pfxname

Add-Type -AssemblyName System.Security
$cert = New-Object System.Security.Cryptography.X509Certificates.X509Certificate2
$cert.Import($pfxpath, $password, [System.Security.Cryptography.X509Certificates.X509KeyStorageFlags]"PersistKeySet")
$store = new-object system.security.cryptography.X509Certificates.X509Store -argumentlist "MY", CurrentUser
$store.Open([System.Security.Cryptography.X509Certificates.OpenFlags]"ReadWrite")
$store.Add($cert)
$store.Close()