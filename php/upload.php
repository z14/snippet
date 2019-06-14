<?php
/**
 * @author Dotcra <dotcra@gmail.com>
 * @version
 * @todo
 */

class upload{
	function __construct($target="."){
		date_default_timezone_set('Asia/Shanghai');
		$most=5;
		$max=1000000;
		$type = array(
			"image/jpeg",
			"image/png",
			"image/gif",
		);

		// is there too many files?
		if(count($_FILES) > $most) exit("too many files");

			var_dump($_FILES);
		foreach($_FILES as $k => $v){
			// check name validation
			// turn space into _, trim specials
			var_dump($v);

			// is it a image?
			if(in_array($v["type"], $type)){
				// really a image? check here
			}
			else exit("wtf");

			// is it too big?
			if($v["size"] > $max) exit("too big!");

			// move it to target path
			if(is_uploaded_file($v["tmp_name"])){
				// rename, trim space, specials
				$v["name"] = str_replace(' ','_',$v["name"]);
				if(!move_uploaded_file($v["tmp_name"], $target."/".date("ymdHis")."-".$v["name"])) echo "move failed";
			}
			else echo "upload failed\n";
			
		}


	}

	function __destruct(){
	}

}

new upload();
