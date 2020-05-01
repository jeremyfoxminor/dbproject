/*THESE TRIGGERS UPDATE, DELETE FROM AND INERT INTO INVENTROY
	BASED ON WHATS CHANGING WITH THE FOOD TABLE*/

DELIMITER //

/* insert new row in food table into inventory if qty is greater than 0 */
CREATE TRIGGER IF NOT EXISTS invInsert AFTER INSERT ON FOOD
	FOR EACH ROW BEGIN
		INSERT INTO MV_INVENTORY
			SELECT DISTINCT NEW.foodid, NEW.name, NEW.qty, NEW.measurement, NEW.shelf_life, NEW.fdate
			FROM FOOD WHERE NEW.qty > 0;
	END; 

/* delete food from inventory if deleted in food table */
CREATE TRIGGER IF NOT EXISTS invDelete AFTER DELETE ON FOOD
	FOR EACH ROW BEGIN
		DELETE FROM MV_INVENTORY
		WHERE id = OLD.foodid;
	END;

/* handles updates, qty can't be less then 0, remove food from inventory if qty is 0, 
	re-add or update food in inventory if qty is greater then 0
	check if recipe is still available after updating qty */
CREATE TRIGGER IF NOT EXISTS invUpdate AFTER UPDATE ON FOOD
	FOR EACH ROW BEGIN
		IF NEW.qty < 0
		THEN signal sqlstate '45000' 
			SET MESSAGE_TEXT='Invalid quantity!';
		END IF;
		
		IF NEW.qty = 0
		THEN
			DELETE FROM MV_INVENTORY
			WHERE id = NEW.foodid;
			
		END IF;
		
		IF NEW.qty > 0
		THEN
			IF OLD.qty = 0
			THEN 
				INSERT INTO MV_INVENTORY VALUES
					(NEW.foodid, NEW.name, NEW.qty, NEW.measurement, NEW.shelf_life, NEW.fdate);
			END IF;
			
			IF OLD.qty > 0
			THEN
				UPDATE MV_INVENTORY SET
					id = NEW.foodid,
					name = NEW.name,
					qty = NEW.qty,
					measurement = NEW.measurement
				WHERE id = NEW.foodid;
			end if;
		END IF;
		
		CALL check_if_recipe_available(NEW.foodid, NEW.qty);
		
	END;
//

/* Triggers for recipe */

CREATE TRIGGER IF NOT EXISTS recipeInsert AFTER INSERT ON RECIPES
	FOR EACH ROW BEGIN
		INSERT INTO MV_RECIPES
			SELECT DISTINCT NEW.r_id, NEW.name, NEW.rtype, NEW.rdesc
			FROM RECIPES
			WHERE NEW.ravail IS TRUE;
	END;
	
CREATE TRIGGER IF NOT EXISTS recipeDelete AFTER DELETE ON RECIPES
	FOR EACH ROW BEGIN
		DELETE FROM MV_RECIPES
		WHERE r_id = OLD.r_id;
	END;
	
CREATE TRIGGER IF NOT EXISTS recipeUpdate AFTER UPDATE ON RECIPES
	FOR EACH ROW BEGIN
		IF NEW.ravail IS TRUE
		THEN
			INSERT INTO MV_RECIPES VALUES
				(NEW.r_id, NEW.name, NEW.rtype, NEW.rdesc);
		END IF;
		
		IF NEW.ravail IS FALSE
		THEN
			DELETE FROM MV_RECIPES
			WHERE r_id = NEW.r_id;
		END IF;
	END; 
	
//

/* Triggers for u_recieves */

/* update qty in food table when user recieves food */
CREATE TRIGGER IF NOT EXISTS recievesInsert BEFORE INSERT ON U_RECIEVES
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
	
/* since the only reason you would need to update this table is if you entered the wrong data ,
	this trigger corrects the qty of food in the food table */
CREATE TRIGGER IF NOT EXISTS recievesUpdate BEFORE UPDATE ON U_RECIEVES
	FOR EACH ROW BEGIN
		
		IF OLD.qty > NEW.qty
			THEN 
				UPDATE FOOD SET
					qty = qty + (OLD.qty - NEW.qty)
				WHERE foodid = NEW.foodid;
		END IF;
		
		IF OLD.qty < NEW.qty
			THEN 
				UPDATE FOOD SET
					qty = qty - (NEW.qty - OLD.qty)
				WHERE foodid = NEW.foodid;
		END IF;
	END;
	
/* Don't need a trigger for delete */
	
//

/* Triggers for user and business view */

CREATE TRIGGER userInsert BEFORE INSERT ON USER
	FOR EACH ROW BEGIN
	DECLARE autoUpUserId int;
		/* makes sure mgr/btype are null is not a business */
		IF NEW.isBusiness IS FALSE
		THEN
			IF NEW.mgr IS NOT NULL
			THEN signal sqlstate '45000'
				SET MESSAGE_TEXT='Only businesses can have managers';
			END IF;
			
			IF NEW.btype IS NOT NULL
			THEN signal sqlstate '45000'
				SET MESSAGE_TEXT='Only businesses can have a type';
			END IF;
			
		END IF;

		/* add user to business view if there a business */
		IF NEW.isBusiness IS TRUE
		THEN 
		
			IF NEW.userid = 0
            THEN
			
            SELECT auto_increment into autoUpUserId
			FROM information_schema.tables
			WHERE table_name = 'USER' AND table_schema = database();
			INSERT INTO businessView VALUES
				(autoUpUserId, NEW.btype, NEW.mgr, NEW.name, NEW.street, NEW.city, NEW.state, NEW.zip);
			
            ELSE
			
			INSERT INTO businessView VALUES
				(NEW.userid, NEW.btype, NEW.mgr, NEW.name, NEW.street, NEW.city, NEW.state, NEW.zip);
		
			END IF;
            
		END IF;
	
	END;
	
//

CREATE TRIGGER IF NOT EXISTS userDelete AFTER DELETE ON USER
	FOR EACH ROW BEGIN
		IF OLD.isBusiness is true
		then
			DELETE FROM businessView where userid = OLD.userid;
		END IF;
	END;
	
//

CREATE TRIGGER IF NOT EXISTS userUpdate AFTER UPDATE ON USER
	FOR EACH ROW BEGIN
		IF NEW.isBusiness is true
		then 
			UPDATE businessView set
				btype = NEW.btype,
				mgr = NEW.mgr,
				name = NEW.name,
				street = NEW.street,
				city = NEW.city,
				state = NEW.state,
				zip = NEW.zip
			WHERE userid = NEW.userid;
		END IF;
	END;
	
//

DELIMITER ;

