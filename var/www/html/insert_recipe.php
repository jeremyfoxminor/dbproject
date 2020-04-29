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
$desc=$_POST["desc"];
$ingredients=$_POST["form"];

$sql = "INSERT INTO RECIPES (name, rdesc) VALUES('$name','$desc')";

$result = $conn->query($sql);
if($result === TRUE) {
        echo $name . " Recipe Added!";
}
else{
echo "Error: " .$sql . "<br>" . $conn->error;
}

$sql = "SELECT r_id FROM RECIPES WHERE name='$name'";
$result = $conn->query($sql);
$recipe = mysqli_fetch_row($result);

echo $recipe[0];

for($i=0;$i<sizeof($ingredients);$i++)
{
        $sql = "INSERT INTO R_USES VALUES('$recipe[0]','$ingredients[$i]')";
        $result = $conn->query($sql);
        if($result === TRUE){
                echo $ingredients[$i] . ' ingredient added!';
        }
        else{
        echo "Error: " .$sql . "<br>" . $conn->error;
        }

}


$conn->close();

?>
