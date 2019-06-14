<?php
class logtofile{
	function __construct($content, $tarfile="log.xml", $hint=""){
		$fp = fopen($tarfile,"a+");
		fwrite($fp,$hint);
		fwrite($fp,"\n");
		fwrite($fp,$content);
		//fwrite($fp,"<br />");
		fclose($fp);
	}

	function __destruct(){
	}

	function f(){

	}
}

