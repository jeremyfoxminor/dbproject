CREATE TABLE USER (
	userid int auto_increment NOT NULL,
	name varchar(45),
	street varchar(25),
	city varchar(25),
	state char(2),
	zip char(5),
	mgr varchar(20),
	btype varchar(15),
	isBusiness boolean NOT NULL,
	PRIMARY KEY(userid));
	
CREATE TABLE RECIPES (
	r_id smallint auto_increment NOT NULL,
	name varchar(45),
	rdesc text,
	rtype varchar(15),
	keto boolean default true,
	paleo boolean default true,
	vegan boolean default true,
	dairy_free boolean default true,
	PRIMARY KEY(r_id));
	
CREATE TABLE FOOD (
	foodid int auto_increment NOT NULL,
	name varchar(45),
	ftype varchar(15),
	shelf_life int,
	fdate DATE,
	qty int,
	measurement char(15),
	PRIMARY KEY(foodid));
	
CREATE TABLE R_USES (
	recipeid smallint NOT NULL,
	foodid int NOT NULL,
	quantity int NOT NULL,
    	measurement enum('Count','Cup', 'Ounce', 'Pound', 'Teaspoon', 'Tablespoon') NOT NULL,
	PRIMARY KEY(recipeid, foodid),
	FOREIGN KEY(recipeid) REFERENCES RECIPES(r_id) ON DELETE CASCADE,
	FOREIGN KEY(foodid) REFERENCES FOOD(foodid));

CREATE TABLE PHONE (
	userid int auto_increment NOT NULL,
	phone char(10) NOT NULL,
	PRIMARY KEY(userid, phone),
	FOREIGN KEY(userid) REFERENCES USER(userid));
	
CREATE TABLE U_COOKS (
	userid int NOT NULL,
	recipeid int NOT NULL,
	PRIMARY KEY(userid, recipeid),
	FOREIGN KEY(userid) REFERENCES USER(userid),
	FOREIGN KEY(recipeid) REFERENCES RECIPES(r_id));
	
CREATE TABLE U_RECIEVES (
	userid int NOT NULL,
	foodid int NOT NULL,
	date_recieved DATE,
	qty int,
	measurement char(15),
	PRIMARY KEY(userid, foodid),
	FOREIGN KEY(userid) REFERENCES USER(userid),
	FOREIGN KEY(foodid) REFERENCES FOOD(foodid));

/* Materialized Views */

CREATE TABLE MV_INVENTORY AS SELECT foodid as id, name, qty, measurement, shelf_life, fdate FROM FOOD WHERE qty <> 0;

/* CREATE TABLE MV_RECIPES AS SELECT r_id, name, rtype, rdesc FROM RECIPES WHERE ravail IS TRUE; */

CREATE TABLE businessView AS SELECT userid, btype, mgr, name, street, city, state, zip FROM USER WHERE isBusiness is true;

CREATE VIEW ketoView AS SELECT r_id, name, rtype, rdesc FROM RECIPES WHERE keto IS TRUE;

CREATE VIEW paleoView AS SELECT r_id, name, rtype, rdesc FROM RECIPES WHERE paleo IS TRUE;

CREATE VIEW veganView AS SELECT r_id, name, rtype, rdesc FROM RECIPES WHERE vegan IS TRUE;

CREATE VIEW dfreeView AS SELECT r_id, name, rtype, rdesc FROM RECIPES WHERE dairy_free IS TRUE;
		
CREATE VIEW R_INGREDIENTS AS 
	SELECT r.name as Recipe, u.quantity as Quantity, u.measurement as Measurement, f.name as Ingredient 
	FROM RECIPES as r JOIN R_USES as u ON r.r_id = u.recipeid 
		JOIN FOOD as f ON u.foodid = f.foodid;
	

	
