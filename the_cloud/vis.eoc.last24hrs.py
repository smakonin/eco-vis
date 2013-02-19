print "Content-type: text/plain"
print

import sys, os, cgi, pg

con = pg.connect(dbname='smarthome', host='localhost', user='restful', passwd='?????')

for i in range(7):

	home = "MAK"
	device = ""
	descr = ""
	data = ""
	total = 0.0
	count = 0

	if i == 0:
		device = "MHE"
		descr = "House"
	elif i == 1:
		device = "HPE"
		descr = "HVAC"
	elif i == 2:
		device = "FRE"
		descr = "Fridge"
		data = ",0.1,0.1,0.1,0.1,0.1,0.1,0.1,0.1,0.1,0.1,0.1,0.1,0.1,0.1,0.1,0.1,0.1,0.1,0.1,0.1,0.1,0.1,0.1,0.1"
	elif i == 3:
		device = "FZE"
		descr = "Freezer"
		data = ",0.1,0.1,0.1,0.1,0.1,0.1,0.1,0.1,0.1,0.1,0.1,0.1,0.1,0.1,0.1,0.1,0.1,0.1,0.1,0.1,0.1,0.1,0.1,0.1"
	elif i == 4:
		device = "OVE" 
		descr = "Oven"
		data = ",0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,1.2,0.0,0.1,0.0,0.0,3.4,0.0,0.0,0.0,0.0,0.0,0.0,0.1"
	elif i == 5:
		device = "TVE"
		descr = "TV/PVR"
		data = ",0.1,0.1,0.1,0.1,0.1,0.1,0.1,0.1,0.1,0.1,0.1,0.1,0.1,0.1,0.1,0.1,0.1,0.3,0.3,0.3,0.3,0.3,0.3,0.1"
	elif i == 6:
		device = "RHE"
		descr = "Other"
		data = ",0.4,0.5,0.4,0.6,0.6,0.5,0.8,1.1,0.9,0.8,0.8,1.2,0.5,0.4,0.5,0.6,1.2,1.0,0.9,0.6,0.4,0.5,0.4,0.5"


	sql = "select date(gmt_ts) as dt, extract(hour from gmt_ts) as hr, sum(abs(period_rate)) as reading from rawdata where home_id = '%s' and device_id = '%s' and gmt_ts >= ((now() at time zone 'UTC') - interval '25 hours') group by dt, hr order by dt desc, hr desc limit 24" % (home, device)

	if data == "":
		for res in con.query(sql).dictresult():
			data = "%s,%0.1f" % (data, float(res['reading']))
			total += float(res['reading'])
			count += 1

	print "%s,%s%s" % (device, descr, data)

con.close

