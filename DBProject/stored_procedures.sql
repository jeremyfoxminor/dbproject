DELIMITER //

CREATE PROCEDURE IF NOT EXISTS check_if_food_expired()
BEGIN 
	
	UPDATE DBFINALPROJ.FOOD SET
		qty = 0
	WHERE DATEDIFF(CURDATE(), fdate) > shelf_life;
	
END //

CREATE PROCEDURE IF NOT EXISTS check_if_recipe_available(IN foodid INT, IN qty int)
BEGIN
	DECLARE requiredQty INT;
	DECLARE recipe INT;
	
	SELECT u.qty into requiredQty FROM R_USES as u where foodid = u.foodid;
	SELECT u.recipeid into recipe FROM R_USES as u where foodid = u.foodid;
	
	IF qty < requiredQty
	THEN 
		UPDATE DBFINALPROJ.RECIPES SET
			ravail = false
		WHERE r_id = recipe;
	END IF;
	
	IF qty >= requiredQty
	THEN 
		UPDATE DBFINALPROJ.RECIPES SET
			ravail = true
		WHERE r_id = recipe;
	END IF;
	
END //

DELIMITER ;

CREATE EVENT IF NOT EXISTS checkExpiration
	ON SCHEDULE EVERY 1 DAY
	DO
		CALL check_if_food_expired();