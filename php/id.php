<?php
/**
 * @author Dotcra <dotcra@gmail.com>
 * @version
 * @todo
 */

class pus{
	private $a;
	private $b;
	private $c;
	function __construct(){
	}

	function __destruct(){
	}

	function f(){
	}
}

#new pus();
#pus::f();

function id($id){
	$sum=0;
	//var_dump($id);
	$id=str_split(substr($id, 0, 17));
	//var_dump($id);

	$factor=[7, 9, 10, 5, 8, 4, 2, 1, 6, 3, 7, 9, 10, 5, 8, 4, 2];
	$last=[1, 0, "X", 9, 8, 7, 6, 5, 4, 3, 2];

	foreach($id as $k => $v){
		$sum+=$v * $factor[$k];
	}
	$m=$sum % 11;
	return $last[$m];
}
echo id(41112319851014252);
