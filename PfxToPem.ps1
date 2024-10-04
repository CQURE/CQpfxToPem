param(
    [string]$pfxFilePath,
    [string]$outputPemFilePath
)

# Prompt for pfxFilePath if not provided
if (-not $pfxFilePath) {
    $pfxFilePath = Read-Host "Enter the path to the PFX file"
}

# Prompt for outputPemFilePath if not provided
if (-not $outputPemFilePath) {
    $outputPemFilePath = Read-Host "Enter the output path for the PEM file"
}

# Load the BouncyCastle library from the libs directory
$bcLibPath = Join-Path -Path $PSScriptRoot -ChildPath "libs\BouncyCastle.Cryptography.dll"
if (Test-Path $bcLibPath) {
    [System.Reflection.Assembly]::LoadFrom($bcLibPath) | Out-Null
    Write-Host "BouncyCastle library loaded successfully."
} else {
    Write-Host "BouncyCastle library not found at: $bcLibPath"
    exit 1
}

# Prompt for password if not provided
$passwordSecureString = Read-Host "Enter password for PFX (input will be hidden)" -AsSecureString
$password = [Runtime.InteropServices.Marshal]::PtrToStringAuto([Runtime.InteropServices.Marshal]::SecureStringToBSTR($passwordSecureString))

# Load the PFX certificate
$pfx = New-Object System.Security.Cryptography.X509Certificates.X509Certificate2
$pfx.Import($pfxFilePath, $password, [System.Security.Cryptography.X509Certificates.X509KeyStorageFlags]::Exportable)

# Function to export the private key as PEM format
function Export-PrivateKey {
    param($certificate)

    # Check if the certificate has a private key
    if (-not $certificate.HasPrivateKey) {
        Write-Host "No private key found in the certificate"
        return $null
    }

    # Extract the private key using older methods for .NET versions without GetRSAPrivateKey()
    $privateKey = $certificate.PrivateKey

    if ($privateKey -is [System.Security.Cryptography.RSACryptoServiceProvider]) {
        # Prepare PEM encoding
        $sw = New-Object System.IO.StringWriter
        $pemWriter = New-Object Org.BouncyCastle.OpenSsl.PemWriter($sw)
        $rsa = [Org.BouncyCastle.Security.DotNetUtilities]::GetRsaKeyPair($privateKey).Private
        $pemWriter.WriteObject($rsa)
        $pemWriter.Writer.Flush()

        # Return the private key in PEM format
        return $sw.ToString()
    }
}

# Function to export the certificate as PEM format
function Export-Certificate {
    param($certificate)

    $certBytes = $certificate.Export([System.Security.Cryptography.X509Certificates.X509ContentType]::Cert)

    # Prepare PEM encoding
    $pem = "-----BEGIN CERTIFICATE-----`n"
    $pem += [Convert]::ToBase64String($certBytes, 'InsertLineBreaks')
    $pem += "`n-----END CERTIFICATE-----"

    return $pem
}

# Export the private key to PEM
$privateKeyPem = Export-PrivateKey -certificate $pfx

if ($privateKeyPem -ne $null) {
    # Export the certificate to PEM
    $certificatePem = Export-Certificate -certificate $pfx

    # Save the private key to a .key file
    $keyFilePath = "$outputPemFilePath.key"
    Set-Content -Path $keyFilePath -Value $privateKeyPem

    # Save the certificate to a .pem file
    Set-Content -Path $outputPemFilePath -Value $certificatePem

    Write-Host "Conversion successful. PEM and KEY files have been saved:"
    Write-Host "Private key saved to: $keyFilePath"
    Write-Host "Certificate saved to: $outputPemFilePath"
} else {
    Write-Host "No private key was exported."
}
