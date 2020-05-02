<?php

$servername = "localhost";
$username = "visiter";
$password = "csc174";
$dbname = "dbproject";

$conn = new mysqli($servername, $username, $password, $dbname);

if($conn->connect_error) {
        die("Connection failed: " . $conn->connect_error);
}

$name=$_POST["name"];
$ing=$_POST["ing"];
$date=$_POST["date"];
$meas=$_POST["meas"];
$qty=$_POST["qty"];

$sql = "INSERT INTO U_INVENTORY VALUES ('$name','$ing','$date', '$qty', '$meas')";

if($conn->query($sql) === TRUE) {
        echo "Added Inventory To User";
}
else{
echo "Error: " .$sql . "<br>" . $conn->error;
}

$conn->close();

?>

