# initial commit
function get-data-from-pryiom($timemin,$timemax) {
#connect to priyom and get a json file based on the time interval
    $url = "http://calendar.priyom.org/events?timeMin=$timemin&timeMax=$timemax";
    $request_headers = @{'Host' = 'calendar.priyom.org'; 'Origin' = 'http://priyom.org'; 'Referer' = 'http://priyom.org/' };
    $response = Invoke-WebRequest -Uri $url -Headers $request_headers -UseBasicParsing | ConvertFrom-JSON;
    return $response;
}
$timemin='2020-04-22T10:00:00.000Z';
$timemax='2020-04-22T10:30:00.000Z';

$response = get-data-from-pryiom $timemin $timemax;

foreach ($station in $response.items) {
    $station.summary + ' -> ' + $station.start.dateTime;
}


