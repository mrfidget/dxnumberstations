param (
# if no param are given, default read within 30 minutes of now
    [datetime]$timemin=(Get-Date),
    [datetime]$timemax=((Get-Date).AddMinutes(30))
)
function convert-to-UTC($atime){
    return $atime.ToUniversalTime();
}

function convert-time-format($atime){
    $atime=$atime.ToString('yyyy-MM-ddTHH:mm:00.000Z');
    return $atime;
}

function build-headers(){
    return @{'Host' = 'calendar.priyom.org'; 'Origin' = 'http://priyom.org'; 'Referer' = 'http://priyom.org/' };
}
function get-data-from-pryiom($timemin,$timemax) {
#convert the time to UTC
#give them the appropriate format
#suppress progress bar with preferences
#connect to priyom and get a json file based on the time interval
#convert the response to a handy PSObject
    $timemin=convert-to-UTC($timemin);
    $timemax=convert-to-UTC($timemax);
    $time_min=convert-time-format($timemin);
    $time_max=convert-time-format($timemax);
    $url = "http://calendar.priyom.org/events?timeMin=$time_min&timeMax=$time_max";
    $progressPreference = 'silentlyContinue';
    $request_headers = build-headers;
    $response = Invoke-WebRequest -Uri $url -Headers $request_headers -UseBasicParsing -ErrorAction Stop | ConvertFrom-JSON;
    $progressPreference = 'Continue';
    return $response;
}

$response = get-data-from-pryiom $timemin $timemax;

foreach ($station in $response.items) {
    $station.summary + ' -> ' + $station.start.dateTime;
}
