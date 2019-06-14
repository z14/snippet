<?php
/**
 * @author Dotcra <dotcra@gmail.com>
 * @version
 * @todo
 */

class xml{
	static function make(){
		$doc = new DOMDocument();
		$root = $doc->createElement( "speak" );
		$root->setAttribute( "version" , "1.0" );
		$root->setAttribute( "xml:lang" , "en-us" );
		$voice = $doc->createElement( "voice" );
		$voice->setAttribute( "xml:lang" , "en-us" );
		$voice->setAttribute( "xml:gender" , "Female" );
		$voice->setAttribute( "name" , "Microsoft Server Speech Text to Speech Voice (en-US, ZiraRUS)" );
		$text = $doc->createTextNode( "This is a demo to call microsoft text to speech service in php." );
		$voice->appendChild( $text );
		$root->appendChild( $voice );
		$doc->appendChild( $root );
		$data = $doc->saveXML();

		return $data;
	}
}

echo xml::make();
