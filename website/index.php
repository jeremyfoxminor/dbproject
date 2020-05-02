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
			<h1>Add a user</h1>
			<form>
			<label for="uName">User Name: </label><input type="text" id="uName"><br>
			<label for="uStreet">Street: </label><input type="text" id="uStreet">
			<label for="uCity">City: </label><input type="text" id="uCity">
			<label for="uState">State: </label><input type="text" id="uState">
			<label for="uZip">Zip: </label><input type="text" id="uZip"><br>
			<label for="uPhone1">Home Phone: </label>
			<input type="tel" id="uPhone1" name="uPhone1" placeholder="123-456-7890" pattern="[0-9]{3}-[0-9]{3}-[0-9]{4}">
			<label for="uPhone2">Cell Phone: </label>
			<input type="tel" id="uPhone2" name="uPhone2" placeholder="123-456-7890" pattern="[0-9]{3}-[0-9]{3}-[0-9]{4}">
			<br><span>Is this a busines?</span>
			<label for="yesBus">Yes</lable><input type="radio" name="isBus" id="yesBus" value="true">
			<lable for="noBus">No</label><input type="radio" name="isBus" id="noBus" value="false" checked><br>
			<label for="uManager">Manager Name: </label><input type="text" id="uManager">
			<lable for="uType">Business Type: </label><input type="text" id="uType">
			<br><input type="button" value="Add New User" id="userButton"><span id="userEntryPoint"></span>
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

		<div>
			<h1>Add Inventory to a User</h1>
			<select id="iName">
<?php
$sql = "SELECT * FROM USER";

$result = $conn->query($sql);

while($row = mysqli_fetch_row($result)) {
	echo "<option value=".$row[0].">".$row[1]."</option>";
}

?>
			</select>

			<select id="iIngredient">
<?php
$sql = "SELECT * FROM FOOD";

$result = $conn->query($sql);

while($row = mysqli_fetch_row($result)) {
	echo "<option value=".$row[0].">".$row[1]."</option>";
}

?>
			</select>
			<input type="date" id="iDate">
			<select id="iMeas">
		  	       <option value="Count">Count</option>";
			       <option value="Cup">Cup</option>";
 				<option value="Ounce">Ounce</option>";
       			 	<option value="Pound">Pound</option>";
        			<option value="Teaspoon">Teaspoon</option>";
        			<option value="Tablespoon">Tablespoon</option>";
			</select>
			<input type="number" id="iQty"  min=0>

			<input type="button" value="Add Inventory" id="inventoryButton">
			<p id="inventoryEntryPoint"></p>
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
		$("#userButton").click(function(){
			var name = $("#uName").val();
			var street = $("#uStreet").val();
			var city = $("#uCity").val();
			var state = $("#uState").val();
			var zip = $("#uZip").val();
			var isBus = $("input[name='isBus']:checked").val();
			var mgr = $("#uManager").val();
			var type = $("#uType").val();
			var phone1 = $("#uPhone1").val();
			var phone2 = $("#uPhone2").val();
			console.log(isBus);
			console.log(phone1);
			console.log(phone2);
			$.ajax({
				url: "insert_user.php",
				method: "post",
				data: {name:name, street:street, city:city, state:state, zip:zip, isBus:isBus, mgr:mgr, type:type, phone1:phone1, phone2:phone2},
				success: function(result){$("#userEntryPoint").html(result);}
			});
		});
		$("#inventoryButton").click(function(){
			var name = $("#iName").val();
			console.log(name);
			var ing = $("#iIngredient").val();
			console.log(ing);
			var date = $("#iDate").val();
			console.log(date);
			var meas = $("#iMeas").val();
			console.log(meas);
			var qty = $("#iQty").val();
			console.log(qty);

			$.ajax({
				url:"insert_inventory.php",
				method:"post",
				data: {name:name, ing:ing, date:date, meas:meas, qty:qty},
				success: function(result){$("#inventoryEntryPoint").html(result);}
			});
		});
	});


</script>

	</body>
</html>

<?php

$conn->close();

?>
