# Connect to the Defender SecurityAPI using certificate authentication

# pre-requisites:
<#
 - app registration (clientID) must have API permissions for defender.
     example reading machine information will need machine.read.all
     permissions added in entra > applications > app registrations > "app name" 
       > API permissions > Add a permission > search "WindowsDefenderATP" > Add machine.read.all or machine.readwrite.all
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

# Retrieve Token
$tenantId = "xxx"
$clientId = "xxx"
$clientSecret = "xxx"
$tokenUrl = "https://login.microsoftonline.com/$tenantId/oauth2/v2.0/token"
# Create request body
$body = @{
    client_id     = $clientId
    client_secret = $clientSecret
    scope         = "https://api.securitycenter.microsoft.com/.default"
    grant_type    = "client_credentials"
}
$response = Invoke-RestMethod -Uri $tokenUrl -Method Post -Body $body -ContentType "application/x-www-form-urlencoded"
$accessToken = $response.access_token

$headers = @{
    Authorization = "Bearer $accessToken"
    "Content-Type" = "application/json"
}
"API Connected."

# get devices
$devices = Invoke-RestMethod -Uri "https://api.security.microsoft.com/api/machines" -Headers $headers
"devices collected: "
$devices.value | measure

$devices.value
