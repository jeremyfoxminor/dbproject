<?php

$servername = "localhost";
$username = "visiter";
$password = "csc174";
$dbname = "dbproject";

$conn = new mysqli($servername, $username, $password, $dbname);

if($conn->connect_error) {
        die("Connection failed: " . $conn->connect_error);
}

$sql = $conn->prepare("INSERT INTO USER (name, street, city, state ,zip, mgr, btype, isBusiness) VALUES (?,?,?,?,?,?,?,?)");

$bValue = 0;
$mgr = null;
$type = null;
if($_POST['isBus']=== "true"){
$bValue = 1;
}

if($_POST['mgr'] != ''){
$mgr = $_POST['mgr'];
}

if($_POST['type'] != ''){
$type = $_POST['type'];
}


$sql->bind_param("sssssssi", $_POST['name'], $_POST['street'], $_POST['city'], $_POST['state'], $_POST['zip'], $mgr, $type, $bValue);

if($sql->execute()) {
echo "user successfully added";
}
else {
echo $sql->error;
}

$phone1 = $_POST['phone1'];
$phone2 = $_POST['phone2'];

function insertPhone($phone) {
	global $sql;
	global $id;

}

if($phone1 != '' || $phone2 != '') {

	$name2 = $_POST['name'];
	$newQuery = "SELECT userid FROM USER WHERE name='$name2'";
	$result = $conn->query($newQuery);
	$id = mysqli_fetch_row($result);
	$sql = $conn->prepare("INSERT INTO U_PHONE (userid, phone) VALUES (?,?)");

	if($phone1 != '') {
		$sql->bind_param("is", $id[0], $phone1);
		if($sql->execute()) {
			echo ", phone added too";
		} else {
			echo $sql->error;
		}
	}
	if($phone2 != '') {
		$sql->bind_param("is", $id[0], $phone2);
		if($sql->execute()) {
			echo ", phone added too";
		} else {
			echo $sql->error;
		}
	}

}

$conn->close();
?>
