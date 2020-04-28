DELIMITER //

CREATE TRIGGER invInsert AFTER INSERT ON FOOD
	FOR EACH ROW BEGIN
		INSERT INTO MV_INVENTORY
			SELECT DISTINCT NEW.foodid, NEW.name, NEW.ftype, NEW.shelf_life, NEW.fdate, NEW.qty
			FROM FOOD WHERE NEW.qty > 0;
	END; 

CREATE TRIGGER invDelete AFTER DELETE ON FOOD
	FOR EACH ROW BEGIN
		DELETE FROM MV_INVENTORY 
		WHERE foodid = OLD.foodid;
	END;

CREATE TRIGGER invUpdate BEFORE UPDATE ON FOOD
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
