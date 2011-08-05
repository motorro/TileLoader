<?php
/********************************************************** 
 *                Authorization stub                      *
 * Checks for valid authorization ticket passed.          *
 * If ticket is valid, returns OK and album title         *
 *********************************************************/ 

define ('STATUS_OK', 0);
define ('STATUS_ERROR', 1000);
define ('STATUS_ERROR_EMPTY_TOKEN', STATUS_ERROR + 110); 
define ('STATUS_ERROR_INVALID_TOKEN', STATUS_ERROR + 120); 
 
$token = isset($_POST["token"]) ? $_POST["token"] : "";
if ("" == $token) {
	result("Error", STATUS_ERROR_EMPTY_TOKEN, "Empty token.");
	exit();
} 

//Authorization error test
if ("BadOne" == $token) {
	result("Error", STATUS_ERROR_INVALID_TOKEN, "Invalid token");
	exit();
}

result("Ok", STATUS_OK, "Authorized", "<order><token>$token</token><name>Альбом $token</name></order>");

function result($status, $code, $message, $xmlData = null) {
	header ("Content-type: text/xml; charset=utf-8");
	print ("<?xml version=\"1.0\" encoding=\"UTF-8\"?>\n");
	print ("<result>\n");
	print ("\t<status>$status</status>\n");
	print ("\t<code>$code</code>\n");
	print ("\t<message><![CDATA[$message]]></message>\n");
	if ($xmlData) {
		print ($xmlData);
	}
	print ("</result>");
}
?>