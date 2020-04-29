<?php
$servername = "localhost";
$username = "visiter";
$password = "csc174";
$dbname = "dbproject";

$conn = new mysqli($servername, $username, $password, $dbname);

if($conn->connect_error) {
        die("Connection failed: " . $conn->connect_error);
}

$sql = "SELECT * FROM {$_POST["table"]}";

$result = $conn->query($sql);

   if ($result->num_rows > 0)
   {
      echo "<table><tr>";

$field = $result->fetch_fields();

foreach($field as $col) {
        echo "<th>".$col->name."</th>";
}
echo "</tr>";

while($row = $result->fetch_row())
     {
        echo "<tr>";

        for ($i=0;$i<$result->field_count;$i++)
        {
           echo "<td>".$row[$i]."</td>";
        }

        echo "</tr>";
      }
     echo "</table>";

   }

else
{
 echo "No data found";
}

$conn->close();

?>

<html>
<head>
        <title>CSC 174 Project</title>
        <style>
                table, td, th {
                  border: 1px solid black;
                }
                th {
                  height: 50px;
                }
        </style>
</head>


<body>
<p>Ran the Query:
<?php echo $sql; ?>
</p>

</body>

</html>
