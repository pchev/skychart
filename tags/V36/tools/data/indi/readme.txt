Skychart will use this INDI drivers list in last resort if it is not found in:
/usr/share/indi/drivers.xml
/usr/local/share/indi/drivers.xml

You must replace this file by the one given with your INDI version.
You can also edit this file to add or remove a driver.

Only <devGroup group="Telescopes"> is read by Skychart.

Be sure <driver> include the name= attribute, otherwise it is ignored by Skychart.

