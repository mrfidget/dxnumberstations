
param (
    [datetime]$timemin=(Get-Date),
    [datetime]$timemax=((Get-Date).AddMinutes(30))
)


function get-data-from-pryiom($timemin,$timemax) {
#connect to priyom and get a json file based on the time interval, by default read within 30 minutes of now
    $time_min=$timemin.ToString('yyyy-MM-ddTHH:mm:00.000Z');
    $time_max=$timemax.ToString('yyyy-MM-ddTHH:mm:00.000Z');
    $url = "http://calendar.priyom.org/events?timeMin=$time_min&timeMax=$time_max";
    $request_headers = @{'Host' = 'calendar.priyom.org'; 'Origin' = 'http://priyom.org'; 'Referer' = 'http://priyom.org/' };
    $response = Invoke-WebRequest -Uri $url -Headers $request_headers -UseBasicParsing | ConvertFrom-JSON;
    return $response;
}

$response = get-data-from-pryiom $timemin $timemax;

foreach ($station in $response.items) {
    $station.summary + ' -> ' + $station.start.dateTime;
}
