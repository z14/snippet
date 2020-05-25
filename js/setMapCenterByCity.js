let div = {
	'北京' : ['北京'],
	'上海' : ['上海'],
	'重庆' : ['重庆'],
	'天津' : ['天津'],
	'广东' : ['广州','深圳','韶关','珠海','汕头','佛山','江门','湛江','茂名','肇庆','惠州','梅州','汕尾','河源','阳江','清远','东莞','中山','潮州','揭阳','云浮'],
	'河北' : ['石家庄','唐山','秦皇岛','邯郸','邢台','保定','张家口','承德','沧州','廊坊','衡水'],
	'山西': ['太原','大同','阳泉','长治','晋城','朔州','晋中','运城','忻州','临汾','吕梁', '永济'],
	'内蒙古': ['呼和浩特','包头','乌海','赤峰','通辽','鄂尔多斯','呼伦贝尔','巴彦淖尔','乌兰察布','兴安','锡林郭勒','阿拉善','临河','东胜','集宁','锡林浩特','海拉尔','乌兰浩特'],
	'辽宁' : ['沈阳','大连','鞍山','抚顺','本溪','丹东','锦州','营口','阜新','辽阳','盘锦','铁岭','朝阳','葫芦岛'],
	'吉林' : ['长春','吉林','四平','辽源','通化','白山','松原','白城','延边'],
	'黑龙江' : ['哈尔滨','齐齐哈尔','鸡西','鹤岗','双鸭山','大庆','伊春','佳木斯','七台河','牡丹江','黑河','绥化','大兴安岭'],
	'江苏' : ['南京','无锡','徐州','常州','苏州','南通','连云港','淮安','盐城','扬州','镇江','泰州','宿迁','淮阴','张家港'],
	'浙江' : ['杭州','宁波','温州','嘉兴','湖州','绍兴','金华','衢州','舟山','台州','丽水','温岭'],
	'安徽' : ['合肥','芜湖','蚌埠','淮南','马鞍山','淮北','铜陵','安庆','黄山','滁州','阜阳','宿州','巢湖','六安','亳州','池州','宣城'],
	'福建' : ['福州','厦门','莆田','三明','泉州','漳州','南平','龙岩','宁德'],
	'江西' : ['南昌','景德镇','萍乡','九江','新余','鹰潭','赣州','吉安','宜春','抚州','上饶'],
	'山东' : ['济南','青岛','淄博','枣庄','东营','烟台','潍坊','济宁','泰安','威海','日照','莱芜','临沂','德州','聊城','滨州','菏泽'],
	'河南' : ['郑州','开封','洛阳','平顶山','安阳','鹤壁','新乡','焦作','濮阳','许昌','漯河','三门峡','南阳','商丘','信阳','周口','驻马店','济源'],
	'湖北' : ['武汉','黄石','十堰','宜昌','襄樊','鄂州','荆门','孝感','荆州','黄冈','咸宁','随州','恩施','仙桃','潜江','天门','神农架'],
	'湖南' : ['长沙','株洲','湘潭','衡阳','邵阳','岳阳','常德','张家界','益阳','郴州','永州','怀化','娄底','湘西'],
	'广西' : ['南宁','柳州','桂林','梧州','北海','防城港','钦州','贵港','玉林','百色','贺州','河池','来宾','崇左','桂平'],
	'海南' : ['海口','三亚','五指山','琼海','儋州','文昌','万宁','东方','琼山','临高','陵水','澄迈','定安','屯昌','昌江','白沙','琼中','乐东','保亭','陵水'],
	'四川' : ['成都','自贡','攀枝花','泸州','德阳','绵阳','广元','遂宁','内江','乐山','南充','眉山','宜宾','广安','达州','雅安','巴中','资阳','阿坝','甘孜','凉山','达川','阆中'],
	'贵州' : ['贵阳','六盘水','遵义','安顺','铜仁','黔西南','毕节','黔东南','黔南'],
	'云南' : ['昆明','曲靖','玉溪','保山','昭通','丽江','思茅','临沧','楚雄','红河州','文山','西双版纳','大理','德宏','怒江傈','迪庆','东川','怒江'],
	'西藏' : ['拉萨','昌都','山南','日喀则','那曲','阿里','林芝'],
	'陕西' : ['西安','铜川','宝鸡','咸阳','渭南','延安','汉中','榆林','安康','商洛'],
	'甘肃' : ['兰州','嘉峪关','金昌','白银','天水','武威','张掖','平凉','酒泉','庆阳','定西','陇南','临夏','甘南'],
	'青海' : ['西宁','海东','海北','黄南','海南','果洛','玉树','海西'],
	'宁夏' : ['银川','石嘴山','吴忠','固原','中卫','银南'],
	'新疆' : ['乌鲁木齐','克拉玛依','吐鲁番','哈密','昌吉','博尔塔拉','巴音郭楞','阿克苏','克孜勒苏','喀什','和田','伊犁','塔城','阿勒泰','石河子','阿拉尔','图木舒克','五家渠']
};

let distros = {
	'十堰': [
		{
			coord: [110.783675, 32.653377],
			title: '麦当劳(十堰公园路店)',
			addr: 'addr1',
			tel: 'tel1'
		},
		{
			coord: [110.788138, 32.653377],
			title: '麦当劳甜品站(人民北路店)',
			addr: 'addr2',
			tel: 'tel2'
		},
	],
	'武汉': [
		{
			coord: [111, 111],
			title: 'title1',
			addr: 'addr1',
			tel: 'tel1'
		},
		{
			coord: [111, 111],
			title: 'title2',
			addr: 'addr2',
			tel: 'tel3'
		},
	]
};

// create option tag
let optionTag = document.createElement('option');

// create li tag
let ulTag = document.getElementById('distributor_list');
let liTag = ulTag.firstElementChild;

// get all provinces
let provinces = Object.keys(div);
let selectTagProv = document.getElementById('province');
selectTagProv.addEventListener('change', appendCities);
let selectTagCity = document.getElementById('city');
selectTagCity.addEventListener('change', appendDistros);

let default_prov = '湖北';
let default_city = '十堰';

// append options to select#province
for (let i = 0; i < provinces.length; i++) {
	let o = document.importNode(optionTag);
	o.append(provinces[i]);
	if (provinces[i] == default_prov) {
		o.setAttribute('selected', '');
	}
	selectTagProv.appendChild(o);
}

// append options to select#city
function appendCities() {
	// get selected province
	//let selectedProv = this.options[this.selectedIndex].value;
	let selectedProv = selectTagProv.value;
	// get cities of selected province
	let cities = div[selectedProv];
	// clear cities
	selectTagCity.innerHTML = "";
	// append cities
	for (let i = 0; i < cities.length; i++) {
		let o = document.importNode(optionTag);
		o.append(cities[i]);
		if (cities[i] == default_city) {
			o.setAttribute('selected', '');
		}
		selectTagCity.appendChild(o);
	}

	appendDistros();
}


function appendDistros() {
	//let selectedCity = this.options[this.selectedIndex].value;
	let selectedCity = selectTagCity.value;
	let distrosOfCity = distros[selectedCity];
	// clear cities
	ulTag.innerHTML = "";
	// clear all overlay
	map.clearMap();
	// append distros
	for (let i = 0; i < distrosOfCity.length; i++) {
		let li = liTag.cloneNode(true);
		li.dataset.lat = distrosOfCity[i].coord[0];
		li.dataset.lng = distrosOfCity[i].coord[1];
		li.dataset.title = distrosOfCity[i].title;
		li.dataset.address = distrosOfCity[i].addr;
		li.dataset.tel = distrosOfCity[i].tel;
		li.firstElementChild.append(distrosOfCity[i].title);
		li.firstElementChild.nextElementSibling.firstElementChild.append(distrosOfCity[i].addr);
		li.firstElementChild.nextElementSibling.firstElementChild.nextElementSibling.append(distrosOfCity[i].tel);
		li.addEventListener('click', showInfoWindow);
		ulTag.appendChild(li);
		addMarker(distrosOfCity[i].coord);
	}

	// initially set map center to first distro of this city
	setMapCenter(distrosOfCity[0].coord);
}

// cities of initical province
appendCities();

function setMapCenter(coord) {
	map.setZoomAndCenter(15, coord);
}

function addMarker(coord) {
	let marker = new AMap.Marker({
		//position: new AMap.LngLat(coord[0], coord[1]),
	});
	marker.setPosition(coord);
	map.add(marker);
}

function showInfoWindow() {
    let infoWindow = new AMap.InfoWindow({
        anchor: 'top-left',
        content: this.dataset.title,
    });
    infoWindow.open(map, [this.dataset.lat, this.dataset.lng]);
}
