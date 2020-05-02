-- MySQL dump 10.13  Distrib 5.7.29, for Linux (x86_64)
--
-- Host: localhost    Database: dbproject
-- ------------------------------------------------------
-- Server version	5.7.29-0ubuntu0.18.04.1

/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8 */;
/*!40103 SET @OLD_TIME_ZONE=@@TIME_ZONE */;
/*!40103 SET TIME_ZONE='+00:00' */;
/*!40014 SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0 */;
/*!40014 SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0 */;
/*!40101 SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_AUTO_VALUE_ON_ZERO' */;
/*!40111 SET @OLD_SQL_NOTES=@@SQL_NOTES, SQL_NOTES=0 */;

--
-- Table structure for table `FOOD`
--

DROP TABLE IF EXISTS `FOOD`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `FOOD` (
  `foodid` int(11) NOT NULL AUTO_INCREMENT,
  `name` varchar(45) DEFAULT NULL,
  `ftype` varchar(15) DEFAULT NULL,
  `shelf_life` int(11) DEFAULT NULL,
  `fdate` date DEFAULT NULL,
  `qty` int(11) DEFAULT NULL,
  `measurement` char(15) DEFAULT NULL,
  PRIMARY KEY (`foodid`)
) ENGINE=InnoDB AUTO_INCREMENT=14 DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `FOOD`
--

LOCK TABLES `FOOD` WRITE;
/*!40000 ALTER TABLE `FOOD` DISABLE KEYS */;
INSERT INTO `FOOD` VALUES (1,'Macaroni ','carb',365,NULL,NULL,NULL),(2,'Cheese','dairy',45,NULL,NULL,NULL),(3,'Milk','dairy',14,NULL,NULL,NULL),(4,'Butter','dairy',60,NULL,NULL,NULL),(5,'Oatmeal','carb',365,NULL,NULL,NULL),(6,'Chocolate Chips','carb',365,NULL,NULL,NULL),(7,'sugar','carb',365,NULL,NULL,NULL),(8,'Egg','animal product',14,NULL,NULL,NULL),(9,'Black Beans','vegetable',1000,NULL,NULL,NULL),(10,'Ground Beef','meat',5,NULL,NULL,NULL),(11,'Bell Pepper','vegetable',10,NULL,NULL,NULL),(12,'Kidney Bean','vegetable',1000,NULL,NULL,NULL),(13,'Canned Tomatoes','vegetable',1000,NULL,NULL,NULL);
/*!40000 ALTER TABLE `FOOD` ENABLE KEYS */;
UNLOCK TABLES;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8 */ ;
/*!50003 SET character_set_results = utf8 */ ;
/*!50003 SET collation_connection  = utf8_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
/*!50003 CREATE*/ /*!50017 DEFINER=`root`@`localhost`*/ /*!50003 TRIGGER invInsert AFTER INSERT ON FOOD
FOR EACH ROW BEGIN
INSERT INTO MV_INVENTORY
SELECT DISTINCT NEW.foodid, NEW.name, NEW.qty, NEW.measurement, NEW.shelf_life, NEW.fdate
FROM FOOD WHERE NEW.qty > 0;
END */;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8 */ ;
/*!50003 SET character_set_results = utf8 */ ;
/*!50003 SET collation_connection  = utf8_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
/*!50003 CREATE*/ /*!50017 DEFINER=`root`@`localhost`*/ /*!50003 TRIGGER invUpdate AFTER UPDATE ON FOOD
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

END */;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8 */ ;
/*!50003 SET character_set_results = utf8 */ ;
/*!50003 SET collation_connection  = utf8_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
/*!50003 CREATE*/ /*!50017 DEFINER=`root`@`localhost`*/ /*!50003 TRIGGER invDelete AFTER DELETE ON FOOD
FOR EACH ROW BEGIN
DELETE FROM MV_INVENTORY
WHERE id = OLD.foodid;
END */;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;

--
-- Table structure for table `RECIPES`
--

DROP TABLE IF EXISTS `RECIPES`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `RECIPES` (
  `r_id` smallint(6) NOT NULL AUTO_INCREMENT,
  `name` varchar(45) DEFAULT NULL,
  `rdesc` text,
  `keto` tinyint(1) DEFAULT '1',
  `paleo` tinyint(1) DEFAULT '1',
  `vegan` tinyint(1) DEFAULT '1',
  `dairy_free` tinyint(1) DEFAULT '1',
  `rtype` varchar(15) DEFAULT NULL,
  PRIMARY KEY (`r_id`)
) ENGINE=InnoDB AUTO_INCREMENT=11 DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `RECIPES`
--

LOCK TABLES `RECIPES` WRITE;
/*!40000 ALTER TABLE `RECIPES` DISABLE KEYS */;
INSERT INTO `RECIPES` VALUES (9,'Mac and Cheese','',0,0,0,0,NULL),(10,'Scrambled Egg','Just 1 Egg LOL',1,1,0,1,NULL);
/*!40000 ALTER TABLE `RECIPES` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `R_USES`
--

DROP TABLE IF EXISTS `R_USES`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `R_USES` (
  `recipeid` smallint(6) NOT NULL,
  `foodid` int(11) NOT NULL,
  `quantity` int(11) NOT NULL,
  `measurement` enum('Count','Cup','Ounce','Pound','Teaspoon','Tablespoon') NOT NULL,
  PRIMARY KEY (`recipeid`,`foodid`),
  KEY `foodid` (`foodid`),
  CONSTRAINT `R_USES_ibfk_1` FOREIGN KEY (`recipeid`) REFERENCES `RECIPES` (`r_id`) ON DELETE CASCADE,
  CONSTRAINT `R_USES_ibfk_2` FOREIGN KEY (`foodid`) REFERENCES `FOOD` (`foodid`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `R_USES`
--

LOCK TABLES `R_USES` WRITE;
/*!40000 ALTER TABLE `R_USES` DISABLE KEYS */;
INSERT INTO `R_USES` VALUES (9,1,1,'Cup'),(9,2,3,'Ounce'),(9,3,2,'Ounce'),(10,8,1,'Count');
/*!40000 ALTER TABLE `R_USES` ENABLE KEYS */;
UNLOCK TABLES;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8 */ ;
/*!50003 SET character_set_results = utf8 */ ;
/*!50003 SET collation_connection  = utf8_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
/*!50003 CREATE*/ /*!50017 DEFINER=`root`@`localhost`*/ /*!50003 TRIGGER setDietType
AFTER INSERT
ON R_USES FOR EACH ROW
    BEGIN
DECLARE ingredient varchar(45);
SELECT ftype INTO @ingredient FROM FOOD WHERE FOOD.foodid=NEW.foodid;
        
        If @ingredient = 'carb'
        THEN
UPDATE RECIPES
            SET paleo = false, keto = false
WHERE RECIPES.r_id = NEW.recipeid;
END IF;
        
        IF @ingredient = 'meat'
        THEN
UPDATE RECIPES
            SET vegan = false
WHERE RECIPES.r_id = NEW.recipeid;
END IF;
        
        IF @ingredient = 'dairy'
THEN
UPDATE RECIPES
            SET vegan = false, dairy_free = false
WHERE RECIPES.r_id = NEW.recipeid;
END IF;
        
        IF @ingredient = 'animal product'
THEN
UPDATE RECIPES
            SET vegan = false
WHERE RECIPES.r_id = NEW.recipeid;
END IF;
END */;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;

--
-- Table structure for table `USER`
--

DROP TABLE IF EXISTS `USER`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `USER` (
  `userid` int(11) NOT NULL AUTO_INCREMENT,
  `name` varchar(45) DEFAULT NULL,
  `street` varchar(25) DEFAULT NULL,
  `city` varchar(25) DEFAULT NULL,
  `state` char(2) DEFAULT NULL,
  `zip` char(5) DEFAULT NULL,
  `mgr` varchar(20) DEFAULT NULL,
  `btype` varchar(15) DEFAULT NULL,
  `isBusiness` tinyint(1) NOT NULL,
  PRIMARY KEY (`userid`)
) ENGINE=InnoDB AUTO_INCREMENT=147 DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `USER`
--

LOCK TABLES `USER` WRITE;
/*!40000 ALTER TABLE `USER` DISABLE KEYS */;
INSERT INTO `USER` VALUES (1,'Jeremy','123 Vista','Citrus Heights','CA','95610',NULL,NULL,0),(2,'Henry','685 Sandy','Los Angeles','CA','68123',NULL,NULL,0),(3,'Walmart','6969 Dusty Way','Sacramento','CA','95662',NULL,NULL,1),(146,'Big Diesel','9000 Lexington Steel Way','New York City ','NY','12423','Fat Joe','Retail',1);
/*!40000 ALTER TABLE `USER` ENABLE KEYS */;
UNLOCK TABLES;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8 */ ;
/*!50003 SET character_set_results = utf8 */ ;
/*!50003 SET collation_connection  = utf8_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
/*!50003 CREATE*/ /*!50017 DEFINER=`root`@`localhost`*/ /*!50003 TRIGGER userInsert BEFORE INSERT ON USER
FOR EACH ROW BEGIN
DECLARE autoUpUserId int;

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

END */;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8 */ ;
/*!50003 SET character_set_results = utf8 */ ;
/*!50003 SET collation_connection  = utf8_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
/*!50003 CREATE*/ /*!50017 DEFINER=`root`@`localhost`*/ /*!50003 TRIGGER userUpdate AFTER UPDATE ON USER
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
END */;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8 */ ;
/*!50003 SET character_set_results = utf8 */ ;
/*!50003 SET collation_connection  = utf8_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
/*!50003 CREATE*/ /*!50017 DEFINER=`root`@`localhost`*/ /*!50003 TRIGGER userDelete AFTER DELETE ON USER
FOR EACH ROW BEGIN
IF OLD.isBusiness is true
then
DELETE FROM businessView where userid = OLD.userid;
END IF;
END */;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;

--
-- Table structure for table `U_INVENTORY`
--

DROP TABLE IF EXISTS `U_INVENTORY`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `U_INVENTORY` (
  `userid` int(11) NOT NULL,
  `foodid` int(11) NOT NULL,
  `date_recieved` date NOT NULL,
  `qty` int(11) DEFAULT NULL,
  `measurement` char(15) DEFAULT NULL,
  PRIMARY KEY (`userid`,`foodid`,`date_recieved`),
  KEY `foodid` (`foodid`),
  CONSTRAINT `U_INVENTORY_ibfk_1` FOREIGN KEY (`userid`) REFERENCES `USER` (`userid`),
  CONSTRAINT `U_INVENTORY_ibfk_2` FOREIGN KEY (`foodid`) REFERENCES `FOOD` (`foodid`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `U_INVENTORY`
--

LOCK TABLES `U_INVENTORY` WRITE;
/*!40000 ALTER TABLE `U_INVENTORY` DISABLE KEYS */;
INSERT INTO `U_INVENTORY` VALUES (2,9,'2017-02-04',19,'Pound'),(2,9,'2017-03-04',19,'Pound');
/*!40000 ALTER TABLE `U_INVENTORY` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `U_PHONE`
--

DROP TABLE IF EXISTS `U_PHONE`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `U_PHONE` (
  `userid` int(11) NOT NULL AUTO_INCREMENT,
  `phone` char(12) NOT NULL,
  PRIMARY KEY (`userid`,`phone`),
  CONSTRAINT `U_PHONE_ibfk_1` FOREIGN KEY (`userid`) REFERENCES `USER` (`userid`) ON DELETE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=148 DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `U_PHONE`
--

LOCK TABLES `U_PHONE` WRITE;
/*!40000 ALTER TABLE `U_PHONE` DISABLE KEYS */;
INSERT INTO `U_PHONE` VALUES (146,'123-456-7890'),(146,'234-567-8901');
/*!40000 ALTER TABLE `U_PHONE` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `businessView`
--

DROP TABLE IF EXISTS `businessView`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `businessView` (
  `userid` int(11) DEFAULT NULL,
  `btype` varchar(15) DEFAULT NULL,
  `mgr` varchar(20) DEFAULT NULL,
  `name` varchar(45) DEFAULT NULL,
  `street` varchar(25) DEFAULT NULL,
  `city` varchar(25) DEFAULT NULL,
  `state` char(2) DEFAULT NULL,
  `zip` char(5) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `businessView`
--

LOCK TABLES `businessView` WRITE;
/*!40000 ALTER TABLE `businessView` DISABLE KEYS */;
INSERT INTO `businessView` VALUES (3,NULL,NULL,'Walmart','6969 Dusty Way','Sacramento','CA','95662'),(146,'Retail','Fat Joe','Big Diesel','9000 Lexington Steel Way','New York City ','NY','12423');
/*!40000 ALTER TABLE `businessView` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Temporary table structure for view `dfreeView`
--

DROP TABLE IF EXISTS `dfreeView`;
/*!50001 DROP VIEW IF EXISTS `dfreeView`*/;
SET @saved_cs_client     = @@character_set_client;
SET character_set_client = utf8;
/*!50001 CREATE VIEW `dfreeView` AS SELECT 
 1 AS `r_id`,
 1 AS `name`,
 1 AS `rtype`,
 1 AS `rdesc`*/;
SET character_set_client = @saved_cs_client;

--
-- Temporary table structure for view `ketoView`
--

DROP TABLE IF EXISTS `ketoView`;
/*!50001 DROP VIEW IF EXISTS `ketoView`*/;
SET @saved_cs_client     = @@character_set_client;
SET character_set_client = utf8;
/*!50001 CREATE VIEW `ketoView` AS SELECT 
 1 AS `r_id`,
 1 AS `name`,
 1 AS `rtype`,
 1 AS `rdesc`*/;
SET character_set_client = @saved_cs_client;

--
-- Temporary table structure for view `paleoView`
--

DROP TABLE IF EXISTS `paleoView`;
/*!50001 DROP VIEW IF EXISTS `paleoView`*/;
SET @saved_cs_client     = @@character_set_client;
SET character_set_client = utf8;
/*!50001 CREATE VIEW `paleoView` AS SELECT 
 1 AS `r_id`,
 1 AS `name`,
 1 AS `rtype`,
 1 AS `rdesc`*/;
SET character_set_client = @saved_cs_client;

--
-- Temporary table structure for view `recipe_ingredient_view`
--

DROP TABLE IF EXISTS `recipe_ingredient_view`;
/*!50001 DROP VIEW IF EXISTS `recipe_ingredient_view`*/;
SET @saved_cs_client     = @@character_set_client;
SET character_set_client = utf8;
/*!50001 CREATE VIEW `recipe_ingredient_view` AS SELECT 
 1 AS `Recipe`,
 1 AS `Quantity`,
 1 AS `Measurement`,
 1 AS `Ingredient`*/;
SET character_set_client = @saved_cs_client;

--
-- Temporary table structure for view `veganView`
--

DROP TABLE IF EXISTS `veganView`;
/*!50001 DROP VIEW IF EXISTS `veganView`*/;
SET @saved_cs_client     = @@character_set_client;
SET character_set_client = utf8;
/*!50001 CREATE VIEW `veganView` AS SELECT 
 1 AS `r_id`,
 1 AS `name`,
 1 AS `rtype`,
 1 AS `rdesc`*/;
SET character_set_client = @saved_cs_client;

--
-- Final view structure for view `dfreeView`
--

/*!50001 DROP VIEW IF EXISTS `dfreeView`*/;
/*!50001 SET @saved_cs_client          = @@character_set_client */;
/*!50001 SET @saved_cs_results         = @@character_set_results */;
/*!50001 SET @saved_col_connection     = @@collation_connection */;
/*!50001 SET character_set_client      = utf8 */;
/*!50001 SET character_set_results     = utf8 */;
/*!50001 SET collation_connection      = utf8_general_ci */;
/*!50001 CREATE ALGORITHM=UNDEFINED */
/*!50013 DEFINER=`root`@`localhost` SQL SECURITY DEFINER */
/*!50001 VIEW `dfreeView` AS select `RECIPES`.`r_id` AS `r_id`,`RECIPES`.`name` AS `name`,`RECIPES`.`rtype` AS `rtype`,`RECIPES`.`rdesc` AS `rdesc` from `RECIPES` where (`RECIPES`.`dairy_free` is true) */;
/*!50001 SET character_set_client      = @saved_cs_client */;
/*!50001 SET character_set_results     = @saved_cs_results */;
/*!50001 SET collation_connection      = @saved_col_connection */;

--
-- Final view structure for view `ketoView`
--

/*!50001 DROP VIEW IF EXISTS `ketoView`*/;
/*!50001 SET @saved_cs_client          = @@character_set_client */;
/*!50001 SET @saved_cs_results         = @@character_set_results */;
/*!50001 SET @saved_col_connection     = @@collation_connection */;
/*!50001 SET character_set_client      = utf8 */;
/*!50001 SET character_set_results     = utf8 */;
/*!50001 SET collation_connection      = utf8_general_ci */;
/*!50001 CREATE ALGORITHM=UNDEFINED */
/*!50013 DEFINER=`root`@`localhost` SQL SECURITY DEFINER */
/*!50001 VIEW `ketoView` AS select `RECIPES`.`r_id` AS `r_id`,`RECIPES`.`name` AS `name`,`RECIPES`.`rtype` AS `rtype`,`RECIPES`.`rdesc` AS `rdesc` from `RECIPES` where (`RECIPES`.`keto` is true) */;
/*!50001 SET character_set_client      = @saved_cs_client */;
/*!50001 SET character_set_results     = @saved_cs_results */;
/*!50001 SET collation_connection      = @saved_col_connection */;

--
-- Final view structure for view `paleoView`
--

/*!50001 DROP VIEW IF EXISTS `paleoView`*/;
/*!50001 SET @saved_cs_client          = @@character_set_client */;
/*!50001 SET @saved_cs_results         = @@character_set_results */;
/*!50001 SET @saved_col_connection     = @@collation_connection */;
/*!50001 SET character_set_client      = utf8 */;
/*!50001 SET character_set_results     = utf8 */;
/*!50001 SET collation_connection      = utf8_general_ci */;
/*!50001 CREATE ALGORITHM=UNDEFINED */
/*!50013 DEFINER=`root`@`localhost` SQL SECURITY DEFINER */
/*!50001 VIEW `paleoView` AS select `RECIPES`.`r_id` AS `r_id`,`RECIPES`.`name` AS `name`,`RECIPES`.`rtype` AS `rtype`,`RECIPES`.`rdesc` AS `rdesc` from `RECIPES` where (`RECIPES`.`paleo` is true) */;
/*!50001 SET character_set_client      = @saved_cs_client */;
/*!50001 SET character_set_results     = @saved_cs_results */;
/*!50001 SET collation_connection      = @saved_col_connection */;

--
-- Final view structure for view `recipe_ingredient_view`
--

/*!50001 DROP VIEW IF EXISTS `recipe_ingredient_view`*/;
/*!50001 SET @saved_cs_client          = @@character_set_client */;
/*!50001 SET @saved_cs_results         = @@character_set_results */;
/*!50001 SET @saved_col_connection     = @@collation_connection */;
/*!50001 SET character_set_client      = utf8 */;
/*!50001 SET character_set_results     = utf8 */;
/*!50001 SET collation_connection      = utf8_general_ci */;
/*!50001 CREATE ALGORITHM=UNDEFINED */
/*!50013 DEFINER=`root`@`localhost` SQL SECURITY DEFINER */
/*!50001 VIEW `recipe_ingredient_view` AS select `r`.`name` AS `Recipe`,`u`.`quantity` AS `Quantity`,`u`.`measurement` AS `Measurement`,`f`.`name` AS `Ingredient` from ((`RECIPES` `r` join `R_USES` `u` on((`r`.`r_id` = `u`.`recipeid`))) join `FOOD` `f` on((`u`.`foodid` = `f`.`foodid`))) */;
/*!50001 SET character_set_client      = @saved_cs_client */;
/*!50001 SET character_set_results     = @saved_cs_results */;
/*!50001 SET collation_connection      = @saved_col_connection */;

--
-- Final view structure for view `veganView`
--

/*!50001 DROP VIEW IF EXISTS `veganView`*/;
/*!50001 SET @saved_cs_client          = @@character_set_client */;
/*!50001 SET @saved_cs_results         = @@character_set_results */;
/*!50001 SET @saved_col_connection     = @@collation_connection */;
/*!50001 SET character_set_client      = utf8 */;
/*!50001 SET character_set_results     = utf8 */;
/*!50001 SET collation_connection      = utf8_general_ci */;
/*!50001 CREATE ALGORITHM=UNDEFINED */
/*!50013 DEFINER=`root`@`localhost` SQL SECURITY DEFINER */
/*!50001 VIEW `veganView` AS select `RECIPES`.`r_id` AS `r_id`,`RECIPES`.`name` AS `name`,`RECIPES`.`rtype` AS `rtype`,`RECIPES`.`rdesc` AS `rdesc` from `RECIPES` where (`RECIPES`.`vegan` is true) */;
/*!50001 SET character_set_client      = @saved_cs_client */;
/*!50001 SET character_set_results     = @saved_cs_results */;
/*!50001 SET collation_connection      = @saved_col_connection */;
/*!40103 SET TIME_ZONE=@OLD_TIME_ZONE */;

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;

-- Dump completed on 2020-05-02  5:41:07
