/*THESE TRIGGERS UPDATE, DELETE FROM AND INERT INTO INVENTROY
	BASED ON WHATS CHANGING WITH THE FOOD TABLE*/

DELIMITER //

CREATE TRIGGER invInsert AFTER INSERT ON FOOD
	FOR EACH ROW BEGIN
		INSERT INTO MV_INVENTORY
			SELECT DISTINCT NEW.foodid, NEW.name, NEW.ftype, NEW.shelf_life, NEW.fdate, NEW.qty
			FROM FOOD WHERE NEW.qty > 0;
	END; 

CREATE TRIGGER invDelete AFTER DELETE ON FOOD
	FOR EACH ROW BEGIN
		DELETE FROM MV_INVENTORY AS i 
		WHERE i.foodid = OLD.foodid;
	END;

CREATE TRIGGER invUpdate AFTER UPDATE ON FOOD
	FOR EACH ROW BEGIN
		IF NEW.qty < 0
		THEN signal sqlstate '45000' 
			SET MESSAGE_TEXT='Invalid quantity!';
		END IF;
		
		IF NEW.qty = 0
		THEN
			DELETE FROM MV_INVENTORY
			WHERE foodid = NEW.foodid;
		END IF;
		
		IF NEW.qty > 0
		THEN
			UPDATE MV_INVENTORY SET
				foodid = NEW.foodid,
				name = NEW.name,
				ftype = NEW.ftype,
				shelf_life = NEW.shelf_life,
				fdate = NEW.fdate,
				qty = NEW.qty
			WHERE foodid = NEW.foodid;
		END IF;
	END;
//

/* Triggers for recipe */

DELIMITER //

CREATE TRIGGER recipeInsert AFTER INSERT ON RECIPES
	FOR EACH ROW BEGIN
		INSERT INTO MV_RECIPES
			SELECT * 
			FROM RECIPES
			WHERE NEW.ravail IS TRUE;
	END;
	
CREATE TRIGGER recipeDelete AFTER DELETE ON RECIPES
	FOR EACH ROW BEGIN
		DELETE FROM MV_RECIPES
		WHERE recipeid = OLD.r_id;
	END;
	
CREATE TRIGGER recipeUpdate AFTER UPDATE ON RECIPES
	FOR EACH ROW BEGIN
		IF NEW.ravail IS TRUE
		THEN
			UPDATE MV_RECIPES SET
				name = NEW.name,
				rtype = NEW.rtype,
				ravail = NEW.ravail,
				rdesc = NEW.rdesc
			WHERE r_id = NEW.r_id;
		END IF;
		
		IF NEW.ravail IS FALSE
		THEN
			DELETE FROM MV_RECIPES
			WHERE r_id = NEW.r_id;
		END IF;
	END; 
	
//
delimiter $$
CREATE TRIGGER setDietType
	AFTER INSERT
	ON R_USES FOR EACH ROW
    BEGIN
		DECLARE ingredient varchar(45);
		SELECT ftype INTO @ingredient FROM FOOD WHERE FOOD.foodid=NEW.foodid;
        
        If @ingredient = 'carb'
        THEN
			UPDATE RECIPES
            SET isPaleo = false, isKeto = false
			WHERE RECIPES.r_id = NEW.recipeid;
		END IF;
        
        IF @ingredient = 'meat'
        THEN
			UPDATE RECIPES
            SET isVegan = false
			WHERE RECIPES.r_id = NEW.recipeid;
		END IF;
        
        IF @ingredient = 'dairy'
		THEN
			UPDATE RECIPES
            SET isVegan = false, isDairyFree = false
			WHERE RECIPES.r_id = NEW.recipeid;
		END IF;
        
        IF @ingredient = 'animal product'
		THEN
			UPDATE RECIPES
            SET isVegan = false
			WHERE RECIPES.r_id = NEW.recipeid;
		END IF;
	END;
$$ delimiter ;
