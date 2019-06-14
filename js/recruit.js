// itove.com 招募令 version 1.0.5

(function (){
	var all = peopleIn('十堰');
	for (var i in all){
		var him = all[i];
		if (him.plan === '创业' && him.profession === '前端工程师'){
			invite(him);
			break;
		}
	}
}());

function peopleIn(city){
	// blah, blah, blah
	return {a:{plan: '看电视', profession: '前端工程师'}, b:{plan: '创业', profession: '大游戏', phoneNum: '250'}, c:{plan: '创业', profession: '前端工程师', phoneNum: '13800000000'}, d:{plan: '吃饭', profession: '玩'}};
}

function invite(whoIWant){
	//print(whoIWant.plan);
	//print(whoIWant.profession);
	//print(whoIWant.phoneNum);
	// blah, blah, blah
	var myNum='13000000000';
	call(myNum, whoIWant.phoneNum);
	// blah, blah, blah
}

function call(from, to){
	print(from);
	print(to);
	// blah, blah, blah
}

