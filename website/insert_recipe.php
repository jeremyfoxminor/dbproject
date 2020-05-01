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
$ingredients=$_POST["ingredients"];

//echo var_dump(count($ingredients));
//echo "<br>";
//echo var_dump($ingredients);

//$i = 0;
//$ing = $ingredients[$i]['id'];
//echo $ing;
//echo "INSERT INTO R_USES VALUES('$recipe[0]','$ing','$ingredients[$i]['qty']','$ingredients[$i]['meas']')";
//echo sizeof($ingredients);

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
	$ingId = $ingredients[$i]['id'];
	$ingQty = $ingredients[$i]['qty'];
	$ingMeas = $ingredients[$i]['meas'];
	$sql = "INSERT INTO R_USES VALUES('$recipe[0]','$ingId','$ingQty','$ingMeas')";
	$result = $conn->query($sql);
	if($result === TRUE){
		echo $ingredients[id] . ' ingredient added!';
	}
	else{
	echo "Error: " .$sql . "<br>" . $conn->error;
	}

}

$conn->close();

?>
