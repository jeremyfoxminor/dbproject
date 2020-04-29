CREATE TABLE USER (
	userid int auto_increment NOT NULL,
	name varchar(45),
	street varchar(25),
	city varchar(25),
	state char(2),
	zip char(5),
	PRIMARY KEY(userid));
	
CREATE TABLE RECIPES (
	r_id int auto_increment NOT NULL,
	name varchar(45),
	rtype varchar(15),
	ravail boolean NOT NULL,
	rdesc text,
	PRIMARY KEY(r_id));
	
CREATE TABLE FOOD (
	foodid int auto_increment NOT NULL,
	name varchar(45),
	ftype varchar(15),
	shelf_life int,
	fdate DATE,
	qty int,
	PRIMARY KEY(foodid));
	
CREATE TABLE R_USES (
	recipeid int NOT NULL,
	foodid int NOT NULL,
	PRIMARY KEY(recipeid, foodid),
	FOREIGN KEY(recipeid) REFERENCES RECIPES(r_id),
	FOREIGN KEY(foodid) REFERENCES FOOD(foodid));
	
	
CREATE TABLE DONATIONS (
	userid int auto_increment NOT NULL,
	ddate DATE NOT NULL,
	amount DECIMAL(10,2),
	PRIMARY KEY(userid, ddate),
	FOREIGN KEY(userid) REFERENCES USER(userid));
	
CREATE TABLE BUSINESS (
	id int auto_increment NOT NULL,
	bname varchar(45),
	baddress varchar(25),
	PRIMARY KEY(id),
	FOREIGN KEY(id) REFERENCES USER(userid));

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
	PRIMARY KEY(userid, foodid),
	FOREIGN KEY(userid) REFERENCES USER(userid),
	FOREIGN KEY(foodid) REFERENCES FOOD(foodid));
	
CREATE TABLE MV_INVENTORY AS SELECT * FROM FOOD WHERE qty <> 0;

CREATE TABLE MV_RECIPES AS SELECT * FROM RECIPES WHERE ravail IS TRUE;

	
