#!/bin/bash
#

############### Variables ###############
auth='xxx@xxx.xxx:xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx'
auth='dotcra@gmail.com:b296c2391b2aaee418072a1a323a99ae27cdf'
email=${auth%:*}
key=${auth#*:}
url="https://api.cloudflare.com/client/v4/"
suffix="zones?per_page=30"
contype="application/json"
method=get
method=`echo $method | tr 'a-z' 'A-Z'`

############# Get all zones
all=$(curl -s -X $method "${url}${suffix}" -H "X-Auth-Email: $email" -H "X-Auth-Key: $key" -H "Content-Type: $contype")
a=$(echo $all | jq -r '.result[] | "\(.id):\(.name)"')

#############
for i in $a
do
	### get record id
	method=GET
	id=${i%:*}
	name=${i#*:}
	suffix="zones/$id/dns_records?type=TXT&name=$name"
	records=$(curl -s -X $method "${url}${suffix}" -H "X-Auth-Email: $email" -H "X-Auth-Key: $key" -H "Content-Type: $contype")
	rid=$(echo $records | jq -r '.result[0].id')
	echo $rid

	### delete record id
	method=DELETE
	suffix="zones/$id/dns_records/$rid"
	curl -s -X $method "${url}${suffix}" -H "X-Auth-Email: $email" -H "X-Auth-Key: $key" -H "Content-Type: $contype"
	echo

	### create record
	# query="-d {\"type\":\"TXT\",\"name\":\"$name\",\"content\":\"20a67af02088104e2e937337321da43939681ed6\",\"ttl\":3600}"
done
