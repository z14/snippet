<?php
/**
 * @author Dotcra <dotcra@gmail.com>
 * @version
 * @todo
 */
// require_once 'autoload.php';

class key{
	static function ass($vendor){
		$keyd = __DIR__.'/sec';
		$arr = json_decode(file_get_contents("$keyd/key.json"), 1);
		$vend = substr($vendor, 0, 2); // so that 'wx' and 'wxbeta' can share case 'wx':

		switch($vend){
		case "ms":
			$url = "https://api.cognitive.microsoft.com/sts/v1.0/issueToken";
			$opts = array(
				"url" => $url,
				"post" => 1,
				"httpheader" => array(
					"Ocp-Apim-Subscription-Key: ${arr[$vendor]}",
					'Content-length: 0',
				),
			);
			// if older than 600 sec, renew it
			$keyf = $keyd.'/cog_ass';
			if (time() - @filectime($keyf) > 590) file_put_contents($keyf, curl::go($opts));
			return file_get_contents($keyf);
		case 'wx':
			$appid = $arr[$vendor]['id'];
			$appsecret = $arr[$vendor]['key'];
			$url = "https://api.weixin.qq.com/cgi-bin/token?grant_type=client_credential&appid=$appid&secret=$appsecret";
			// if older than 7200 sec, renew it
			$keyf = $keyd.'/'.$vendor.'_ass';
			if (time() - @filectime($keyf) > 7180){
				$a = array(
					"url" => $url,
				);
				$ass = json_decode(curl::go($a), 1);
				$ass = $ass["access_token"];
				file_put_contents($keyf, $ass);
				return $ass;
			}
			return file_get_contents($keyf);
		default:
			return $arr[$vendor];
		}
	}
}

// key::ass('wxbeta');

$a = array(
	'ms' => '',
	'tuling123' => '',
	'miaodiyun' => array(
		'key' => '',
		'id' => ''
	),
	'wx' => array(
		'key' => '',
		'id' => '',
		'token' => '',
	),
	'wxbeta' => array(
		'key' => '',
		'id' => '',
		'token' => '',
	),

	
);

// echo json_encode($a);
