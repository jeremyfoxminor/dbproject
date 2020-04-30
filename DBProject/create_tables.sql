CREATE TABLE IF NOT EXISTS USER (
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
	
CREATE TABLE IF NOT EXISTS RECIPES (
	r_id int auto_increment NOT NULL,
	name varchar(45),
	rtype varchar(15),
	ravail boolean NOT NULL,
	rdesc text,
	keto boolean,
	paleo boolean,
	vegan boolean,
	dairy_free boolean,
	PRIMARY KEY(r_id));
	
CREATE TABLE IF NOT EXISTS FOOD (
	foodid int auto_increment NOT NULL,
	name varchar(45),
	ftype varchar(15),
	shelf_life int,
	fdate DATE,
	qty int,
	measurement char(15),
	PRIMARY KEY(foodid));
	
CREATE TABLE IF NOT EXISTS R_USES (
	recipeid int NOT NULL,
	foodid int NOT NULL,
	qty int,
	measurement char(15),
	PRIMARY KEY(recipeid, foodid),
	FOREIGN KEY(recipeid) REFERENCES RECIPES(r_id),
	FOREIGN KEY(foodid) REFERENCES FOOD(foodid));

CREATE TABLE IF NOT EXISTS PHONE (
	userid int auto_increment NOT NULL,
	phone char(10) NOT NULL,
	PRIMARY KEY(userid, phone),
	FOREIGN KEY(userid) REFERENCES USER(userid));
	
CREATE TABLE IF NOT EXISTS U_COOKS (
	userid int NOT NULL,
	recipeid int NOT NULL,
	PRIMARY KEY(userid, recipeid),
	FOREIGN KEY(userid) REFERENCES USER(userid),
	FOREIGN KEY(recipeid) REFERENCES RECIPES(r_id));
	
CREATE TABLE IF NOT EXISTS U_RECIEVES (
	userid int NOT NULL,
	foodid int NOT NULL,
	date_recieved DATE,
	qty int,
	measurement char(15),
	PRIMARY KEY(userid, foodid),
	FOREIGN KEY(userid) REFERENCES USER(userid),
	FOREIGN KEY(foodid) REFERENCES FOOD(foodid));

/* Materialized Views */

CREATE TABLE IF NOT EXISTS MV_INVENTORY AS SELECT foodid as id, name, qty, measurement, shelf_life, fdate FROM FOOD WHERE qty <> 0;

CREATE TABLE IF NOT EXISTS MV_RECIPES AS SELECT r_id, name, rtype, rdesc FROM RECIPES WHERE ravail IS TRUE;

CREATE TABLE IF NOT EXISTS businessView AS SELECT userid, btype, mgr, name, street, city, state, zip FROM USER WHERE isBusiness is true;

CREATE VIEW IF NOT EXISTS ketoView AS SELECT r_id, name, rtype, ravail, rdesc FROM RECIPES WHERE keto IS TRUE;

CREATE VIEW IF NOT EXISTS paleoView AS SELECT r_id, name, rtype, ravail, rdesc FROM RECIPES WHERE paleo IS TRUE;

CREATE VIEW IF NOT EXISTS veganView AS SELECT r_id, name, rtype, ravail, rdesc FROM RECIPES WHERE vegan IS TRUE;

CREATE VIEW IF NOT EXISTS dfreeView AS SELECT r_id, name, rtype, ravail, rdesc FROM RECIPES WHERE dairy_free IS TRUE;

CREATE VIEW IF NOT EXISTS R_INGREDIENTS AS 
	SELECT r.name as Recipe, f.name as Ingredient, u.qty as Quantity
	FROM RECIPES as r JOIN R_USES as u ON r.r_id = u.recipeid
		JOIN FOOD as f ON u.foodid = f.foodid;
	

	
