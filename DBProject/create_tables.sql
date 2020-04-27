CREATE TABLE USER (
	userid char(4) NOT NULL,
	name varchar(45),
	street varchar(25),
	city varchar(25),
	state char(2),
	zip char(5),
	PRIMARY KEY(userid));
	
CREATE TABLE RECIPES (
	r_id char(4) NOT NULL,
	name varchar(45),
	rtype varchar(15),
	ravail boolean,
	rdesc text,
	PRIMARY KEY(r_id));
	
CREATE TABLE FOOD (
	foodid char(6) NOT NULL,
	name varchar(45),
	ftype varchar(15),
	shelf_life int,
	PRIMARY KEY(foodid));
	
CREATE TABLE R_USES (
	recipeid char(4) NOT NULL,
	foodid char(6) NOT NULL,
	PRIMARY KEY(recipeid, foodid),
	FOREIGN KEY(recipeid) REFERENCES RECIPES(r_id),
	FOREIGN KEY(foodid) REFERENCES FOOD(foodid));
	
	
CREATE TABLE DONATIONS (
	userid char(4) NOT NULL,
	ddate DATE NOT NULL,
	amount DECIMAL(10,2),
	PRIMARY KEY(userid, ddate),
	FOREIGN KEY(userid) REFERENCES USER(userid));
	
CREATE TABLE BUSINESS (
	id char(4) NOT NULL,
	bname varchar(45),
	baddress varchar(25),
	PRIMARY KEY(id),
	FOREIGN KEY(id) REFERENCES USER(userid));

CREATE TABLE PHONE (
	userid char(4) NOT NULL,
	phone char(10) NOT NULL,
	PRIMARY KEY(userid, phone),
	FOREIGN KEY(userid) REFERENCES USER(userid));
	
CREATE TABLE U_COOKS (
	userid char(4) NOT NULL,
	recipeid char(4) NOT NULL,
	PRIMARY KEY(userid, recipeid),
	FOREIGN KEY(userid) REFERENCES USER(userid),
	FOREIGN KEY(recipeid) REFERENCES RECIPES(r_id));
	
