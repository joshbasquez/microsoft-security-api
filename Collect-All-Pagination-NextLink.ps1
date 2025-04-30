# how to collect all results from a query with over 10K results
#  aka pagination

$devices = Invoke-RestMethod -Uri "https://api.security.microsoft.com/api/machines" -Headers $headers
$devices.value | ft id, computerdnsname, osplatform

###############################
# Add Pagination/Collect All ##
###############################
$working = 1
$allResults=@()
$pageCount = 1
$queryURI = "https://api.security.microsoft.com/api/machines"
while($working){
    $result = Invoke-RestMethod -Uri $queryURI -Headers $headers
    if($result.'@odata.nextLink'){
    #"theres a link"
    $queryURI = $result.'@odata.nextLink'
    $pageCount++
    }
    else{
    #"no more nextLink"
        $working = 0
    }
    $allResults+=$result.value
}
"finished. pagecount: $pageCount . devicecount: $($allResults.count)."
#############################
