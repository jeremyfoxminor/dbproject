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

                <div>
                        <h1>Add a Recipe to our database with the form below</h1>
                        <form action="add_recipe.php" mehtod="post">
                                <label for="rName">Recipe Name:</label><br>
                                <input type="text" id="rName" name="rName"><br>
                                <label for="rDesc">Description:</label><br>
                                <textarea id="rDesc" rows="4" cols="50">Enter your Recipe description Here!!</textar$
                                <label for="rIngredients">Ingredients</label><br>
<?php
$sql = "SELECT name FROM FOOD";

$result = $conn->query($sql);

$count = 0;

while($row = mysqli_fetch_row($result)) {
        $count++;
        echo "<input type=".'checkbox'. " id=".$row[0]. " name=". $row[0].">";
        echo '<label for='.$row[0].'>'.$row[0].'</label>';
        if($count % 8 ==0) echo '<br>';
}
?>
                                <br><input type="submit" value="Add Recipe">
                        </form>
                </div>


                <div>
                        <h2>Don't see the ingredients you need?? Add some to the list</h2>
                        <form action="add_ingredient.php" method="post">
                                <label for="name">Ingredient Name:</label>
                                <input type="text" id="name" name="name"><br>
                                <span>Ingredient Type: </span>
                                <input type="radio" id="carb" name="type" value="carb">
                                <label for="carb">Carb</label>

                                <input type="radio" id="meat" name="type" value="meat">
                                <label for="meat">Meat</label>
                                <input type="radio" id="dairy" name="type" value="dairy">
                                <label for="dairy">Dairy</label>

                                <input type="radio" id="animal product" name="type" value="animal product">
                                <label for="animal product">Animal Product</label>

                                <input type="radio" id="vegetable" name="type" value="vegetable">
                                <label for="vegetable">Vegetable</label>

                                <input type="radio" id="fruit" name="type" value="fruit">
                                <label for="fruit">Fruit</label>

                                <input type="radio" id="spice/herb" name="type" value="spice/herb">
                                <label for="spice/herb">Spice/Herb</label>

                                <br><input type="submit" value="Add Ingredient">
                        </form>
                </div>

        </body>
</html>

<?php

$conn->close();

?>
