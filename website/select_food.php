<?php
function selectFood() {

$servername = "localhost";
$username = "visiter";
$password = "csc174";
$dbname = "dbproject";

$conn = new mysqli($servername, $username, $password, $dbname);

if($conn->connect_error) {
        die("Connection failed: " . $conn->connect_error);
}


$sql = "SELECT * FROM FOOD";

$result = $conn->query($sql);

$count = 0;

while($row = mysqli_fetch_row($result)) {
	echo "<div id=" . $row[1] . ">";
        echo "<input type=".'checkbox'. " class=".'boxes'. " value=" . $row[0].">";
        echo '<label for='.$row[1].'>'.$row[1].'</label>';
	echo "<select class=". 'measurement' . ">";
	echo "<option value=" . 'Count' . ">Count</option>";
	echo "<option value=" . 'Cup' . ">Cup</option>";
	echo "<option value=" . 'Ounce' . ">Ounce</option>";
	echo "<option value=" . 'Pound' . ">Pound</option>";
	echo "<option value=" . 'Teaspoon' . ">Teaspoon</option>";
	echo "<option value=" . 'Tablespoon' . ">Tablespoon</option>";
	echo "</select>";
	echo "<label for=" .'quantity'. ">" .'quantity'. "</label>";
        echo "<input type=".'number'. " class=" . 'quantity'. " id=" . 'quantity' . " name=" . 'quantity' . " min=" . '0' . "/>";
	echo "<br>";
	echo "</div>";
}
}
?>
