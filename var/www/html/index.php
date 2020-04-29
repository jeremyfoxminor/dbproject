<?php
$servername = "localhost";
$username = "visiter";
$password = "csc174";
$dbname = "dbproject";

$conn = new mysqli($servername, $username, $password, $dbname);

if($conn->connect_error) {
        die("Connection failed: " . $conn->connect_error);
}


?>


<html>
<head></head>
        <body>

                <div>
                        <h1>Select from the drop down to view a table</h1>
                        <form action="display_table.php" method="post">
                        <select name="table">

<?php
$sql = "SHOW TABLES FROM {$dbname}";

$result = $conn->query($sql);

while($row = mysqli_fetch_row($result)) {
        echo "<option value=".$row[0].">".$row[0]."</option>";
}

?>

                        </select>
                          <input type="submit" value="Submit">
                        </form>
                </div>

        </body>
</html>

<?php

$conn->close();

?>
