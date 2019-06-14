;(function (){
	var a = setInterval(reload, 1000);
	//console.log(a);
	// create dom
	var div = document.createElement('div');
	div.setAttribute('class', 'fixed-bottom m-3');
	//div.setAttribute('id', 'stop');
	
	var btn = document.createElement('button');
	btn.setAttribute('class', 'btn btn-danger');
	btn.innerHTML = '<i class="fas fa-stop"></i>';
	
	div.append(btn);
	
	document.getElementsByTagName('body')[0].append(div);
	
	// event listener
	div.addEventListener('click', sstop)
	
	function stop(){
	console.log(a);
			clearInterval(a);
	}
	
	function sstop(){
	console.log(a);
		var i = btn.firstElementChild;
		if (i.classList.contains('fa-stop')) {
			clearInterval(a);
		}
		else {
			var a = setInterval(reload, 1000);
		}
		i.classList.toggle('fa-stop');
		i.classList.toggle('fa-play');
	}
	
	function reload(){
		location.reload();
		console.log(a);
	}
})();
