/*THESE TRIGGERS UPDATE, DELETE FROM AND INERT INTO INVENTROY
	BASED ON WHATS CHANGING WITH THE FOOD TABLE*/

DELIMITER //

CREATE TRIGGER invInsert AFTER INSERT ON FOOD
	FOR EACH ROW BEGIN
		INSERT INTO MV_INVENTORY
			SELECT DISTINCT NEW.foodid, NEW.name, NEW.qty
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
				qty = NEW.qty
			WHERE foodid = NEW.foodid;
		END IF;
	END;
//

/* Triggers for recipe */

CREATE TRIGGER recipeInsert AFTER INSERT ON RECIPES
	FOR EACH ROW BEGIN
		INSERT INTO MV_RECIPES
			SELECT DISTINCT NEW.r_id, NEW.name, NEW.rtype, NEW.rdesc
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

/* Triggers for u_recieves */

CREATE TRIGGER recievesInsert BEFORE INSERT ON U_RECIEVES
	FOR EACH ROW BEGIN
		
		IF DATEDIFF(NEW.date_recieved, (SELECT fdate FROM FOOD WHERE foodid = NEW.foodid)) > (SELECT shelf_life FROM FOOD WHERE foodid = NEW.foodid)
			THEN signal sqlstate '45000'
				SET MESSAGE_TEXT='Food has expired';
		END IF;
		
		IF NEW.qty > (SELECT qty FROM FOOD where foodid=NEW.foodid)
			THEN signal sqlstate '45000'
				SET MESSAGE_TEXT='Not enough inventory!';
		END IF;
		
		IF NEW.qty < (SELECT qty FROM FOOD where foodid=NEW.foodid)
			THEN 
				UPDATE FOOD SET 
					qty = qty - NEW.qty
				WHERE foodid = NEW.foodid;
		END IF;
		
		IF NEW.qty = (SELECT qty FROM FOOD where foodid=NEW.foodid)
			THEN
				UPDATE FOOD SET
					qty = 0
				WHERE foodid = NEW.foodid;
		END IF;
	END; 
	
//

DELIMITER ;

