-- set foreign_key_checks=0;

drop database if exists mtrombly;
create database if not exists mtrombly;
use mtrombly;

DROP TABLE IF EXISTS company;
CREATE TABLE IF NOT EXISTS company
(
  cmp_id INT UNSIGNED NOT NULL AUTO_INCREMENT,
  cmp_type ENUM('C-Corp','S-Corp','Non-Profit-Corp','LLC','Partnership'),
  cmp_street VARCHAR(30) NOT NULL,
  cmp_city VARCHAR(30) NOT NULL,
  cmp_state CHAR(2) NOT NULL,
  cmp_zip CHAR(9) NOT NULL COMMENT 'no dashes',
  cmp_phone BIGINT UNSIGNED NOT NULL COMMENT 'ssn and zip codes can be zero-filled, but not US area codes',
  cmp_ytd_sales DECIMAL(10,2) NOT NULL COMMENT '12,345,678.90',
  cmp_email VARCHAR(100) NULL,
  cmp_url VARCHAR(100) NULL,
  cmp_notes VARCHAR(255) NULL,
  PRIMARY KEY (cmp_id)
)
ENGINE = InnoDB CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci;

SHOW WARNINGS;

INSERT INTO company
VALUES
(null,'C-Corp','507 - 20th Ave. E. Apt. 2A','Seattle','WA','081226749','2065559857','12345678.00',null,'http://www.http://technologies.ci.fsu.edu/node/72','company notes1'),
(null,'S-Corp','908 W Capital Way','Tacoma','WA','004011298','2065559482','9945678.00',null,'http://www.qcitr.com','company notes2'),
(null,'Non-Profit-Corp','722 Moss Bay Blvd.','Kirkland','WA','000337845','2065553412','1345678.00',null,'http://www.markjowett.com','company notes3'),
(null,'LLC','4110 Old Redmond Rd.','Redmond','WA','000029021','2065558122','678345.00',null,'http://www.thejowetts.com','company notes4'),
(null,'Partnership','4726 - 11th Ave. N.E.','Seattle','WA','001051082','2065551189','345678.00',null,'http://www.qualityinstruction.com','company notes5');

SHOW WARNINGS;

DROP TABLE IF EXISTS customer;
CREATE TABLE IF NOT EXISTS customer
(
  cus_id INT UNSIGNED NOT NULL AUTO_INCREMENT,
  cmp_id INT UNSIGNED NOT NULL,
  cus_ssn BINARY(64) NOT NULL,
  cus_salt BINARY(64) NOT NULL COMMENT '*only* demo purposes - do *NOT* use *salt* in the name!',
  cus_type ENUM('Loyal','Discount','Impulse','Need-Based','Wandering'),
  cus_first VARCHAR(15) NOT NULL,
  cus_last VARCHAR(30) NOT NULL,
  cus_street VARCHAR(30) NULL,
  cus_city VARCHAR(30) NULL,
  cus_state CHAR(2) NULL,
  cus_zip CHAR(9) NULL,
  cus_phone BIGINT UNSIGNED NOT NULL COMMENT 'ssn and zip codes can be qero-filled, but not US area codes',
  cus_email VARCHAR(100) NULL,
  cus_balance DECIMAL(7,2) NULL COMMENT '12,345.67',
  cus_tot_sales DECIMAL(7,2) NULL,
  cus_notes VARCHAR(255) NULL,
  PRIMARY KEY (cus_id),

  UNIQUE INDEX ux_cus_ssn (cus_ssn ASC),
  INDEX idx_cmp_id(cmp_id ASC),

CONSTRAINT fk_customer_company
  FOREIGN KEY(cmp_id)
  REFERENCES company(cmp_id)
  ON DELETE NO ACTION
  ON UPDATE CASCADE
)
ENGINE = InnoDB CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci;

SHOW WARNINGS;

set @salt=RANDOM_BYTES(64);

INSERT INTO customer
VALUES
(null,2,unhex(SHA2(CONCAT(@salt, 000456789),512)),@salt,'Discount','Wilbur','Denaway','23 Billings Gate','El Paso','TX','085703412','2145559857','test1@mymail.com','8391.87','37642.00','customer notes1'),
(null,4,unhex(SHA2(CONCAT(@salt, 001456789),512)),@salt,'Loyal','Bradford','Casis','891 Drift Dr.','Stanton','TX','005819045','2145559482','test2@mymail.com','675.57','87341.00','customer notes2'),
(null,3,unhex(SHA2(CONCAT(@salt, 002456789),512)),@salt,'Impulse','Valerie','Lieblong','421 Calamari Vista','Odessa','TX','000621134','2145553412','test3@mymail.com','8730.23','92678.00','customer notes3'),
(null,5,unhex(SHA2(CONCAT(@salt, 003456789),512)),@salt,'Need-Based','Kathy','Jeffries','915 Drive Past','Penwell','TX','009135674','2145558122','test4@mymail.com','2651.19','78345.00','customer notes4'),
(null,1,unhex(SHA2(CONCAT(@salt, 004456789),512)),@salt,'Wandering','Steve','Rogers','329 Volume Ave.','Tarzan','TX','000054426','2145551189','test5@mymail.com','782.73','23471.00','customer notes5');

SHOW WARNINGS;

select * from company;
select * from customer;