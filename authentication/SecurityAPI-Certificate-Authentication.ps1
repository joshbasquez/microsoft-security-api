# Connect to the Defender SecurityAPI using certificate authentication

# pre-requisites:
<#
 - install the module MSAL.PS
 - request a certificate from company CA or generate self-signed private key
 - upload private key to the app registration in azure
 - load private key to the local key store of client connecting to securityAPI
 - app registration (clientID) must have API permissions for defender.
     example reading machine information will need machine.read.all
     permissions added in entra > applications > app registrations > "app name" 
       > API permissions > Add a permission > search "WindowsDefenderATP" > Add machine.read.all or machine.readwrite.all
--
 Cert path info:
 - example cert is loaded into CurrentUser\Personal
 - get cert thumbprint using:
    Get-ChildItem -path 'cert:\currentuser\my' | fl friendlyname, subject, thumbprint
 - powershell path to currentuser\personal is 
    get-item -Path 'Cert:\CurrentUser\my\xxthumbprintxxx'
#>

<# 
API endpoints URLs - https://learn.microsoft.com/en-us/defender-endpoint/gov
sign-in
 Commercial / GCC    - https://login.microsoftonline.com
 GCCH / DoD          - https://login.microsoftonline.us
defender for endpoint api
 GCC             - https://api-gcc.securitycenter.microsoft.us
 GCCH/DoD        - https://api-gov.securitycenter.microsoft.us 
#>


Import-Module MSAL.PS

$connectionDetails = @{
    'TenantId'          = '4b11xx-xxx-xxx'
    'ClientId'          = '1ddxxx-xxx-xxx'
    'ClientCertificate' = Get-Item -Path 'Cert:\CurrentUser\my\xxthumbprintxx' 
}

# Acquire a token
$token = (Get-MsalToken @connectionDetails -Scopes 'https://api.securitycenter.microsoft.com/.default').accessToken

$headers = @{
    "Authorization" = "Bearer $Token"
}

# test query of machines
$devices = Invoke-RestMethod -Uri "https://api.security.microsoft.com/api/machines" -Headers $headers
$devices.value
