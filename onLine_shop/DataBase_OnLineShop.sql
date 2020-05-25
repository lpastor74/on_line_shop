CREATE DATABASE `on_line_store` /*!40100 DEFAULT CHARACTER SET latin1 */;
use on_line_store;
CREATE TABLE `customer` (
  `id` int(11) NOT NULL,
  `name` varchar(15) NOT NULL,
  `store_location` varchar(2) NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
CREATE TABLE `product` (
  `category` int(11) NOT NULL,
  `id` int(11) NOT NULL,
  `price` decimal(10,2) NOT NULL,
  `name` varchar(45) NOT NULL,
  PRIMARY KEY (`category`,`id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
CREATE TABLE `OrderHeader` (
  `idOrderHeader` int(11) NOT NULL AUTO_INCREMENT,
  `date` datetime DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`idOrderHeader`),
  UNIQUE KEY `idOrderHeader_UNIQUE` (`idOrderHeader`)
) ENGINE=InnoDB AUTO_INCREMENT=9 DEFAULT CHARSET=latin1;
CREATE TABLE `OrderDetail` (
  `no` int(11) NOT NULL AUTO_INCREMENT,
  `orderHeader_id` int(11) NOT NULL,
  `customer_id` int(11) NOT NULL,
  `ship_to` varchar(2) NOT NULL,
  `date` datetime DEFAULT CURRENT_TIMESTAMP,
  `processed` int(11) DEFAULT '0',
  PRIMARY KEY (`no`),
  KEY `customer_id` (`customer_id`),
  KEY `parent_ind` (`orderHeader_id`),
  CONSTRAINT `OrderDetail_ibfk_1` FOREIGN KEY (`orderHeader_id`) REFERENCES `OrderHeader` (`idOrderHeader`) ON DELETE CASCADE,
  CONSTRAINT `OrderDetail_ibfk_3` FOREIGN KEY (`customer_id`) REFERENCES `customer` (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=80 DEFAULT CHARSET=latin1;
CREATE TABLE `OrderDetailLine` (
  `no` int(11) NOT NULL AUTO_INCREMENT,
  `orderDetail_id` int(11) NOT NULL,
  `product_id` int(11) NOT NULL,
  `qty` decimal(10,2) NOT NULL,
  `processed` int(11) DEFAULT '0',
  PRIMARY KEY (`no`),
  KEY `parent_ind2` (`orderDetail_id`),
  KEY `product_category` (`product_id`),
  CONSTRAINT `OrderDetailLine_ibfk_1` FOREIGN KEY (`orderDetail_id`) REFERENCES `OrderDetail` (`no`) ON DELETE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=125 DEFAULT CHARSET=latin1;

DELIMITER $$
CREATE DEFINER=`wso2`@`%` PROCEDURE `insertOrder`(
IN customer INT,
IN shipTo VARCHAR(2),
OUT LID int(11)
)
BEGIN
SET @lastOrderDate = (select  date(date) from  OrderHeader order by date DESC LIMIT 1);
SET @lastOrderId      = (select  idOrderHeader from  OrderHeader order by date DESC LIMIT 1);

if @lastOrderDate = date(current_timestamp())
THEN
 INSERT INTO `OrderDetail` (`orderHeader_id` ,`customer_id`,`ship_to`) VALUES ( @lastOrderId , customer, shipTo) ;
ELSE

 -- inster new row into OrderHeader
 INSERT INTO  `OrderHeader` (`date`) VALUES (CURRENT_TIMESTAMP);
 -- get last ID 
 set @lastOrderId = (SELECT LAST_INSERT_ID());
 -- insert into OrderDetai
 INSERT INTO `OrderDetail` (`orderHeader_id` ,`customer_id`,`ship_to`) VALUES ( @lastOrderId , customer, shipTo) ;
END IF;

SET LID = LAST_INSERT_ID();
SELECT LID;
END$$
DELIMITER ;
DELIMITER $$
CREATE DEFINER=`wso2`@`%` PROCEDURE `processOrder`(
IN orderNo INT
)
BEGIN
UPDATE OrderDetail
SET
processed = 1
WHERE no = orderNo;
END$$
DELIMITER ;
DELIMITER $$
CREATE DEFINER=`wso2`@`%` PROCEDURE `processOrderLine`(
IN orderLineNo INT
)
BEGIN
UPDATE OrderDetailLine
SET
processed = 1
WHERE no = orderLineNo;
END$$
DELIMITER ;

CREATE DATABASE `persist_db2` /*!40100 DEFAULT CHARACTER SET latin1 */;
use persist_db2;
CREATE TABLE `archive` (
  `idArchive` int(11) NOT NULL AUTO_INCREMENT,
  `customer_id` int(11) DEFAULT NULL,
  `customer_Name` varchar(45) DEFAULT NULL,
  `product_id` int(11) DEFAULT NULL,
  `product_name` varchar(45) DEFAULT NULL,
  `qty` decimal(10,2) DEFAULT NULL,
  PRIMARY KEY (`idArchive`),
  UNIQUE KEY `idArchive_UNIQUE` (`idArchive`)
) ENGINE=InnoDB AUTO_INCREMENT=88 DEFAULT CHARSET=latin1;





