<?php

include 'select_food.php';

$servername = "localhost";
$username = "visiter";
$password = "csc174";
$dbname = "dbproject";

$conn = new mysqli($servername, $username, $password, $dbname);

if($conn->connect_error) {
        die("Connection failed: " . $conn->connect_error);
}

$name=$_POST["name"];
$type=$_POST["type"];
$shelf=$_POST["shelf"];

$sql = "INSERT INTO FOOD (name, ftype, shelf_life) VALUES ('$name','$type','$shelf')";

if($conn->query($sql) === TRUE) {
	selectFood();
}
else{
echo "Error: " .$sql . "<br>" . $conn->error;
}

$conn->close();

?>
