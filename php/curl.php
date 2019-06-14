<?php
/**
 * @author Dotcra <dotcra@gmail.com>
 * @version 1.0
 */
class curl{
	/**
	 * @param array $opts contain curl options and values, do NOT prefix "CURLOPT_". case insensitive.
	 *
	 * $opts = array(
	 * "url" => "https://api.url",
	 * "returntransfer" => 0,
	 * "header" => 1,
	 * "post" => 1, // TRUE to do a regular HTTP POST. This POST is the normal application/x-www-form-urlencoded kind, most commonly used by HTML forms.
	 * "postfields" => "key=816ddc83c3406960573&info=hi", // Passing an array to CURLOPT_POSTFIELDS will encode the data as multipart/form-data, while passing a URL-encoded string will encode the data as application/x-www-form-urlencoded.
	 * );
	 *
	 * @return request result on success or FALSE on failure. However, if $opts["RETURNRANSFER"] set to 0, return TRUE on success or FALSE on failure.
	 */
	static function go(array $opts){
		$opts = array_change_key_case($opts, CASE_UPPER);

		$ch = curl_init();

		# return the transfer as a string by default
		curl_setopt($ch, CURLOPT_RETURNTRANSFER, 1);

		foreach($opts as $k => $v){
			//if($k == "POSTFIELDS" && is_array($v)){
			//	foreach($v as $kk => $vv){
			//		$cfile = new CURLFile($vv);
			//	}
			//}
			//print_r($opts[$k]);
			curl_setopt($ch, constant("CURLOPT_$k"), $v);
		}

		$data = curl_exec($ch);

		curl_close($ch);

		return $data;
	}
}
