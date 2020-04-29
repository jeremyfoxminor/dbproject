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

$sql = "INSERT INTO FOOD (name, ftype) VALUES ('$name','$type')";

if($conn->query($sql) === TRUE) {
        selectFood();
}
else{
echo "Error: " .$sql . "<br>" . $conn->error;
}

$conn->close();

?>
