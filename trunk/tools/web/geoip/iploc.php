<?php

// This code demonstrates how to lookup the country, region, city,
// postal code, latitude, and longitude by IP Address.
// It is designed to work with GeoIP/GeoLite City

// Note that you must download the New Format of GeoIP City (GEO-133).
// The old format (GEO-132) will not work.

include("./geoipcity.inc");
include("./geoipregionvars.php");

$ipaddr   = $_REQUEST['ip'];

if($ipaddr == '')
   $ipaddr = $_SERVER['REMOTE_ADDR'];

$gi = geoip_open("./GeoLiteCity.dat",GEOIP_STANDARD);

$record = geoip_record_by_addr($gi,$ipaddr);

$city = $record->city;
if($city == '')
   $city = '-';

print $ipaddr . "\t" . $record->country_code . "\t" . utf8_encode($record->country_name) . "\t" . utf8_encode($city) . "\t" . $record->latitude . "\t" . $record->longitude . "\n";

geoip_close($gi);

?>
