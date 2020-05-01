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


?>


<html>
<head>
<script src="https://ajax.googleapis.com/ajax/libs/jquery/3.1.1/jquery.min.js"></script>
</head>
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
			<form>
				<label for="rName">Recipe Name:</label><br>
				<input type="text" id="rName" name="rName"><br>
				<label for="rDesc">Description:</label><br>
				<textarea id="rDesc" name="rDesc" rows="4" cols="50" placeholder="Enter your Recipe description Here!!"></textarea><br>
				<label for="rIngredients">Ingredients</label><br>
				<div id="entryPoint">
				<?php selectFood(); ?>
				</div>
				<br><input type="button" value="Add Recipe" id="recipeButton">
				<span id="recipeEntryPoint"></span>
			</form>
		</div>


		<div>
			<h2>Don't see the ingredients you need?? Add some to the list</h2>
			<form>
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

                                <input type="radio" id="other" name="type" value="other">
                                <label for="other">Other</label>
				<br>

				<label for="shelfLife">Shelf Life:</label>
				<input type="number" id="shelfLife" name="shelfLife">

				<br><br><input type="button" value="Add Ingredient" id="ingredientButton">
			</form>
		</div>

		<div id="div1">

		</div>
<script>
	$(document).ready(function(){
		$("#ingredientButton").click(function(){
			var type = document.querySelector('input[name="type"]:checked').value;
			var name = $("#name").val();
			var shelf = $("#shelfLife").val();
			console.log(name);
			console.log(type);
			console.log(shelf);
			$.ajax({
				url: "insert_ingredient.php",
				method:"post",
				data: {name:name, type:type, shelf:shelf},
				success: function(result){$("#entryPoint").html(result);}
			});
		});

		$("#recipeButton").click(function(){
			var name = $("#rName").val();
			var desc = $("#rDesc").val();

			var listOfIngredients = [];
			var ingredients = {};
			$('#entryPoint').children().each( (index, element) => {
				if(element.getElementsByClassName("boxes")[0].checked) {
				var id = element.getElementsByClassName("boxes")[0].value;
				var meas = element.getElementsByClassName("measurement")[0].value;
				var qty = element.getElementsByClassName("quantity")[0].value;
				ingredients = {id:id, meas:meas,qty:qty};
				listOfIngredients.push(ingredients);
				}
			});
			var ingArray = {data: listOfIngredients};
			console.log(name);
			console.log(desc);
			console.log(listOfIngredients);
			console.log($.param(ingArray));
			$.ajax({
				url: "insert_recipe.php",
				method: "post",
				data: {name:name, desc:desc, ingredients:listOfIngredients},
				success: function(result){$("#recipeEntryPoint").html(result);}
			});
		});
	});


</script>

	</body>
</html>

<?php

$conn->close();

?>
