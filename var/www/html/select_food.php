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
        $count++;
        echo "<input type=".'checkbox'. " id=".$row[1]. " class=".'boxes'. " value=" . $row[0].">";
        echo '<label for='.$row[1].'>'.$row[1].'</label>';
        if($count % 8 ==0) echo '<br>';
}
}
?>
