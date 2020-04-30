INSERT INTO USER VALUES
	(1, "Jeremy", "123 Vista", "Citrus Heights", "CA", "95610", null, null, false),
	(2, "Henry", "685 Sandy", "Los Angeles", "CA", "68123", null, null, false),
	(3, "Walmart", "6969 Dusty Way", "Sacramento", "CA", "95662", null, null, true);

/* THESE TWO SHOULD RETURN ERRORS */
INSERT INTO USER VALUES
	(4, "Test", "123 test dr.", "testcity", "CA", "12345", "hi", null, false);
	
INSERT INTO USER VALUES
	(5, "Test2","123 test dr", "testme", "CA", "12345", null, "hey", false);
/**/

INSERT INTO RECIPES VALUES
	(1, "Sick Nachos", "Mexicano", TRUE, "Put some cheese on some chips", false, false, false, false),
	(2, "Hamburger", "Americana", TRUE, "Just go to McDonalds", false, false, false, true);
	
INSERT INTO FOOD VALUES
	(1, "Tortilla Chips", "Chips", 10, "2020-04-20", 35),
	(2, "Chedda", "Cheese", 60, "2020-04-20", 35),
	(3, "Bun", "Bread", 10, "2020-04-20", 35),
	(4, "Beef", "Meat", 5, "2020-04-20", 35);

/* NO ERROR, reduces qty in foods table */
INSERT INTO U_RECIEVES VALUES
	(1, 1, "2020-04-30", 5);
	
/* NO ERROR sets qty to 0 in foods table */
INSERT INTO U_RECIEVES VALUES
	(1, 4, "2020-04-21", 35);

/* FOOD EXPIRED ERROR */
INSERT INTO U_RECIEVES VALUES
	(1, 2, "2020-10-31", 7);
	
/* NOT ENOUGH INVENTORY */
INSERT INTO U_RECIEVES VALUES
	(1, 4, "2020-04-21", 40);
	

	

	
