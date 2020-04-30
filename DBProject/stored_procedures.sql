DELIMITER //

CREATE PROCEDURE check_if_food_expired()
BEGIN 
	
	UPDATE FOOD SET
		qty = 0
	WHERE DATEDIFF(CURDATE(), fdate) > shelf_life;
	
END //

DELIMITER ;

CREATE EVENT checkExpiration
	ON SCHEDULE EVERY 1 DAY
	DO
		CALL check_if_food_expired();