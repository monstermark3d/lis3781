SET DEFINE OFF

DROP SEQUENCE seq_cus_id;
CREATE SEQUENCE seq_cus_id
START WITH 1
INCREMENT BY 1
MINVALUE 1
MAXVALUE 10000;

DROP TABLE customer CASCADE CONSTRAINTS PURGE;
CREATE TABLE customer
(
cus_id      number(3,0) NOT NULL,
cus_fname   varchar2(15) NOT NULL,
cus_lname   varchar2(30) NOT NULL,
cus_street  varchar2(30) NOT NULL,
cus_city    varchar2(30) NOT NULL,
cus_state   char(2) NOT NULL,
cus_zip     number(9) NOT NULL,
cus_phone   number(10) NOT NULL,
cus_email   varchar2(100),
cus_balance number(7,2),
cus_notes   varchar2(255),

CONSTRAINT pk_customer PRIMARY KEY(cus_id)
);

DROP SEQUENCE seq_com_id;
CREATE SEQUENCE seq_com_id
START WITH 1
INCREMENT BY 1
MINVALUE 1
MAXVALUE 10000;

DROP TABLE commodity CASCADE CONSTRAINTS PURGE;
CREATE TABLE commodity
(
com_id     number NOT NULL,
com_name   varchar2(20),
com_price  number(8,2) NOT NULL,
cus_notes  varchar2(255),

CONSTRAINT pk_commodity PRIMARY KEY(com_id),
CONSTRAINT uq_com_name UNIQUE(com_name)
);

DROP SEQUENCE seq_ord_id;
CREATE SEQUENCE seq_ord_id
START WITH 1
INCREMENT BY 1
MINVALUE 1
MAXVALUE 10000;

DROP TABLE "order" CASCADE CONSTRAINTS PURGE;
CREATE TABLE "order"
(
ord_id         number(4,0) NOT NULL,
cus_id         number,
com_id         number,
ord_num_units  number(5,0) NOT NULL,
ord_total_cost number(8,2) NOT NULL,
ord_notes      varchar2(255),

CONSTRAINT pk_order PRIMARY KEY(ord_id),
CONSTRAINT fk_order_customer
FOREIGN KEY (cus_id)
REFERENCES customer(cus_id),
CONSTRAINT fk_order_commodity
FOREIGN KEY (com_id)
REFERENCES commodity(com_id),
CONSTRAINT check_unit CHECK(ord_num_units > 0),
CONSTRAINT check_total CHECK(ord_total_cost > 0)
);

INSERT INTO customer VALUES(seq_cus_id.nextval,'Beverly','Davis','123 Main St.','Detroit','MI',48252,3135551212,'bdavis@aol.com',11500.99,'recently moved');
INSERT INTO customer VALUES(seq_cus_id.nextval,'Stephen','Taylor','456 Elm St.','St. Louis', 'MO',57252,4185551212,'staylor@comcast.net',25.01,NULL);
INSERT INTO customer VALUES(seq_cus_id.nextval,'Donna','Carter','789 Peach Ave.','Los Angeles','CA',48252,3135551212,'dcarter@wow.com',300.99,'returning customer');
INSERT INTO customer VALUES(seq_cus_id.nextval,'Robert','Silverman','857 Wilbur Rd.','Phoenix','AZ',25278,4805551212,'rsilverman@aol.com',NULL,NULL);
INSERT INTO customer VALUES(seq_cus_id.nextval,'Sally','Victors','534 Holler Way','Charleston','WV',78345,9045551212,'svictors@wow.com',500.76,'new customer');
COMMIT;

INSERT INTO commodity VALUES(seq_com_id.nextval,'DVD & Player',109.00,NULL);
INSERT INTO commodity VALUES(seq_com_id.nextval,'Cereal',3.00,'sugar free');
INSERT INTO commodity VALUES(seq_com_id.nextval,'Scrabble',29.00,'original');
INSERT INTO commodity VALUES(seq_com_id.nextval,'Licorice',1.89,NULL);
INSERT INTO commodity VALUES(seq_com_id.nextval,'Tums',2.45,'antacid');
COMMIT;

INSERT INTO "order" VALUES(seq_ord_id.nextval, 1, 2, 50, 200, NULL);
INSERT INTO "order" VALUES(seq_ord_id.nextval, 2, 3, 30, 100, NULL);
INSERT INTO "order" VALUES(seq_ord_id.nextval, 3, 1, 6, 654, NULL);
INSERT INTO "order" VALUES(seq_ord_id.nextval, 5, 4, 24, 972, NULL);
INSERT INTO "order" VALUES(seq_ord_id.nextval, 3, 5, 7, 300, NULL);
INSERT INTO "order" VALUES(seq_ord_id.nextval, 1, 2, 5, 15, NULL);
INSERT INTO "order" VALUES(seq_ord_id.nextval, 2, 3, 40, 57, NULL);
INSERT INTO "order" VALUES(seq_ord_id.nextval, 3, 1, 4, 300, NULL);
INSERT INTO "order" VALUES(seq_ord_id.nextval, 5, 4, 14, 770, NULL);
INSERT INTO "order" VALUES(seq_ord_id.nextval, 3, 5, 15, 883, NULL);
COMMIT;

SELECT * FROM customer;
SELECT * FROM commodity;
SELECT * from "order";