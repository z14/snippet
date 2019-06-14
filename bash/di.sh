#!/bin/bash
#
# vim:ft=sh

############### Variables ###############

############### Functions ###############

############### Main Part ###############
dir=~/.di/
id=de56b4d3
key=02c2d3fefcf189c03403b9c769e9fa63
word=figure
region=us #gb
URL='https://od-api.oxforddictionaries.com/api/v1/'
suf="entries/en/$word/regions=$region"

[ -d "$dir" ] || mkdir $dir

# if $dir$word, cat 
if [ -f "$dir$word" ]; then
	di_res=$(cat $dir$word)
# else curl
else
	di_res=$(curl -s -X GET --header 'Accept: application/json' --header "app_id: $id" --header "app_key: $key" "$URL$suf" > $dir$word | tee $dir$word)
fi


echo $di_res | jq '.results[].lexicalEntries[].pronunciations[].audioFile'

# cvlc --quiet --play-and-exit $dir$word.mp3
