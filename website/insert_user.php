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

$conn->close();
?>
