<?php
//Uploader stub

$order = isset($_POST["order"]) ? $_POST["order"] : "";
$format = isset($_POST["format"]) ? $_POST["format"] : "";
$fileName = isset($_POST["originalFilename"]) ? $_POST["originalFilename"] : "";
$orientation = isset($_POST["orientation"]) ? $_POST["orientation"] : "";
$exifDate = isset($_POST["exifDate"]) ? $_POST["exifDate"] : "";

$foldername = dirname($_SERVER['SCRIPT_FILENAME'])."/images/";

if (!isset($_FILES['Filedata'])) {
	result("Error", "No file transfered");
	exit();
}

if (move_uploaded_file($_FILES['Filedata']['tmp_name'], $foldername.$_FILES['Filedata']['name'])) {
	result("Ok", "Uploaded. Order: $order, format: $format, filename: $fileName, orientation: $orientation, date: $exifDate");
} else {
	result("Error", "Upload error");
}

function result($status, $message) {
	header ("Content-type: text/xml; charset=utf-8");
	print ("<?xml version=\"1.0\" encoding=\"UTF-8\"?>\n");
	print ("<result>\n");
	print ("\t<status>$status</status>\n");
	print ("\t<message><![CDATA[$message]]></message>\n");
	print ("</result>");
}
?>