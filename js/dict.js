var http=require('https');
var word='swan';
var j=0;	// if regions=us, pronunciations[1] should be used
var opt={
	host:'od-api.oxforddictionaries.com',
	path:"/api/v1/entries/en/" + word + "/regions=us",
	//path:'/api/v1/entries/en/levitation',
	port: 443,
	headers:{app_id: 'XXXX', app_key: 'XXXXXX'}
};

http.get(opt,(res)=>{
	res.on('data',(chunk)=>{
		//console.log(chunk.toString());
		var a=JSON.parse(chunk.toString());
		o=a;
		console.log(word);
		console.log(o.results[0].lexicalEntries[0].entries[0].senses[0].definitions);
		console.log(o.results[0].lexicalEntries[0].pronunciations[0].phoneticSpelling);
		console.log(o.results[0].lexicalEntries[0].pronunciations[j].audioFile);
		// download audioFile to word_us_1.mp3
	});
	//console.log(res);
});
