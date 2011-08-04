<?php
/********************************************************** 
 *                   Uploader stub                        *
 * Checks for valid parameters and file.                  *
 * Returns passed parameters in reply.                    *
 *********************************************************/ 
define ('STATUS_OK', 0);
define ('STATUS_ERROR', 100);
define ('STATUS_ERROR_NO_FILE', STATUS_ERROR + 10); 
define ('STATUS_ERROR_UPLOAD_ERROR', STATUS_ERROR + 20); 

$order = isset($_POST["order"]) ? $_POST["order"] : "";
$format = isset($_POST["format"]) ? $_POST["format"] : "";
$fileName = isset($_POST["originalFilename"]) ? $_POST["originalFilename"] : "";
$orientation = isset($_POST["orientation"]) ? $_POST["orientation"] : "";
$exifDate = isset($_POST["exifDate"]) ? $_POST["exifDate"] : "";

$foldername = dirname($_SERVER['SCRIPT_FILENAME'])."/images/";

if (!isset($_FILES['Filedata'])) {
	result("Error", STATUS_ERROR_NO_FILE, "No file transfered");
	exit();
}

if (move_uploaded_file($_FILES['Filedata']['tmp_name'], $foldername.$_FILES['Filedata']['name'])) {
	result("Ok", STATUS_OK, "Uploaded. Order: $order, format: $format, filename: $fileName, orientation: $orientation, date: $exifDate");
} else {
	result("Error", STATUS_ERROR_UPLOAD_ERROR, "Upload error");
}

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