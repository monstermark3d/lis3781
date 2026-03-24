-- Mark Trombly
-- Assignment #4
--
-- MSSQL
--
-- -------------------------------------------
-- Populate tables
-- -------------------------------------------
--
USE mtrombly;
GO
-- -------------------------------------------
-- Data - person
-- -------------------------------------------
INSERT INTO dbo.person 
(per_ssn, per_salt, per_fname, per_lname, per_gender, per_dob, per_street, per_city, per_state, per_zip, per_email, per_type, per_notes)
VALUES
(1, NULL, 'Steve', 'Rogers', 'm', '1923-10-03', '437 Southern Drive', 'Rochester', 'NY', 324402222, 'srogers@comcast.net', 's', NULL),
(2, NULL, 'Bruce', 'Wayne', 'm', '1968-03-20', '1007 Mountain Drive', 'Gotham', 'NY', 983208440, 'bwayne@knology.net', 's', NULL),
(3, NULL, 'Peter', 'Parker', 'm', '1988-09-12', '20 Ingram Street', 'New York', 'NY', 102862341, 'pparker@msn.com', 's', NULL),
(4, NULL, 'Jayne', 'Thompson', 'f', '1978-05-08', '13563 Ocean View Drive', 'Seattle', 'WA', 132084409, 'jthompson@gmail.com', 's', NULL),
(5, NULL, 'Debra', 'Steele', 'f', '1994-07-19', '543 Oak Lane', 'Milwaukee', 'WI', 286234178, 'dsteele@verizon.net', 's', NULL),
(6, NULL, 'Tony', 'Smith', 'm', '1972-05-04', '332 Palm Avenue', 'Malibu', 'CA', 902638332, 'tstark@yahoo.com', 'c', NULL),
(7, NULL, 'Hank', 'Pymi', 'm', '1980-08-28', '2355 Brown Street', 'Cleveland', 'OH', 822348890, 'hpym@aol.com', 'c', NULL),
(8, NULL, 'Bob', 'Best', 'm', '1992-02-10', '4902 Avendale Avenue', 'Scottsdate', 'AZ', 872638332, 'bbest@yahoo.com', 'c', NULL),
(9, NULL, 'Sandra', 'Smith', 'f', '1990-01-26', '87912 Lawrence Avenue', 'Atlanta', 'GA', 672348890, 'sdole@gmail.com', 'c', NULL),
(10, NULL, 'Ben', 'Avery', 'm', '1983-12-24', '6432 Thunderbird Lane', 'Sioux Falls', 'SD', 562638332, 'bavery@hotmail.com', 'c', NULL),
(11, NULL, 'Arthur', 'Curry', 'm', '1975-12-15', '3304 Euclid Avenue', 'Miami', 'FL', 342219932, 'acurry@gmail.com', 'c', NULL),
(12, NULL, 'Diana', 'Prince', 'f', '1980-08-22', '944 Green Street', 'Las Vegas', 'NV', 322048823, 'dprice@symaptico.com', 'c', NULL),
(13, NULL, 'Adam', 'Smith', 'm', '1995-01-31', '98435 Valencia Drive', 'Gulf Shores', 'AL', 870219932, 'ajurris@gmx.com', 'c', NULL),
(14, NULL, 'Judy', 'Sleen', 'f', '1970-03-22', '56343 Rover Court', 'Billings', 'MT', 672048823, 'jsleen@sumaptico.com', 'c', NULL),
(15, NULL, 'Bill', 'Neiderheim', 'm','1982-06-13', '43567 Netherland Boulevard', 'South Bend', 'IN', 320319932, 'bneiderheim@comcast.net', 'c', NULL);
GO
--
-- -------------------------------------------
-- Data - person -- create SSN stored proc
-- -------------------------------------------
CREATE PROC dbo.CreatePersonSSN
AS
BEGIN

  DECLARE @salt BINARY(64);
  DECLARE @ran_num INT;
  DECLARE @ssn BINARY(64);
  DECLARE @x INT, @y INT;
  SET @x = 1;

  SET @y = (SELECT COUNT(*) FROM dbo.person);

  WHILE (@x <= @y)
  BEGIN
    SET @salt=CRYPT_GEN_RANDOM(64);
    SET @ran_num=FLOOR(RAND()*(999999999-111111111+1))+111111111;
    SET @ssn=HASHBYTES('SHA2_512', CONCAT(@salt, @ran_num));

    UPDATE dbo.person 
    SET per_ssn=@ssn, per_salt=@salt
    WHERE per_id=@x;

    SET @x = @x + 1;

  END;
END;
GO

EXEC dbo.CreatePersonSSN

SELECT * from person;
--
-- -------------------------------------------
-- Data - slsrep
-- -------------------------------------------
INSERT INTO dbo.slsrep
(per_id, srp_yr_sales_goal, srp_ytd_sales, srp_ytd_comm, srp_notes)
VALUES
(1, 100000, 60000, 1800, NULL),
(2, 80000, 35000, 3500, NULL),
(3, 150000, 84000, 9650, 'Great salesperson!'),
(4, 125000, 87000, 15300, NULL),
(5, 98000, 43000, 8750, NULL);

SELECT * FROM dbo.slsrep;
--
-- -------------------------------------------
-- Data - customer
-- -------------------------------------------
INSERT INTO dbo.customer 
(per_id, cus_balance, cus_total_sales, cus_notes)
VALUES
(6, 120, 14789, NULL),
(7, 98.46, 234.92, NULL),
(8, 0, 4578, 'Customer always pays on time.'),
(9, 981.73, 1672.38, 'High balance.'),
(10, 541.23, 782.57, NULL),
(11, 251.02, 13782.96, 'Good customer.'),
(12, 582.67, 963.12, 'Previously paid in full.'),
(13, 121.67, 1057.45, 'Recent customer.'),
(14, 765.43, 6789.42, 'Buys bulk quantities.'),
(15, 304.39, 456.81, 'Has not purchased recently.');

SELECT * FROM dbo.customer;
--
-- -------------------------------------------
-- Data - contact
-- -------------------------------------------
INSERT INTO dbo.contact
(per_sid, per_cid, cnt_date, cnt_notes)
VALUES
(1, 6, '1999-01-01', NULL),
(2, 6, '2001-09-29', NULL),
(3, 7, '2002-08-15', NULL),
(2, 7, '2002-09-01', NULL),
(4, 7, '2004-01-05', NULL),
(5, 8, '2004-02-28', NULL),
(4, 8, '2004-03-03', NULL),
(1, 9, '2004-04-07', NULL),
(5, 9, '2004-07-29', NULL),
(3, 11, '2005-05-02', NULL),
(4, 13, '2005-06-14', NULL),
(2, 15, '2005-07-02', NULL);

SELECT * FROM dbo.contact;
--
-- -------------------------------------------
-- Data - order
-- -------------------------------------------
INSERT INTO dbo.[order]
(cnt_id, ord_placed_date, ord_filled_date, ord_notes)
VALUES
(1, '2010-11-23', '2010-12-24', NULL),
(2, '2005-03-19', '2005-07-28', NULL),
(3, '2011-07-01', '2011-07-06', NULL),
(4, '2009-12-24', '2010-01-05', NULL),
(5, '2008-09-21', '2008-11-26', NULL),
(6, '2009-05-31', '2009-04-30', NULL),
(7, '2010-05-31', '2010-06-07', NULL),
(8, '2007-09-02', '2007-12-23', NULL),
(9, '2011-12-08', '2011-12-23', NULL),
(10, '2012-02-29', '2012-05-02', NULL);

SELECT * FROM dbo.[order];
--
-- -------------------------------------------
-- Data - store
-- -------------------------------------------
INSERT INTO dbo.store
(str_name, str_street, str_city, str_state, str_zip, str_phone, str_email, str_url, str_notes)
VALUES
('Walgreens', '14567 Walnut Lane', 'Aspen', 'IL', '475315690', '3127658127', 'info@walgreens.com', 'http://www.walgreens.com', NULL),
('CVS', '572 Casper Road', 'Chicago', 'IL', '505231519', '3128926534', 'help@cvs.com', 'http://www.cvs.com', 'Rumor of merger.'),
('Lowes', '81309 Catapult Avenue', 'Clover', 'WA', '802345671', '9017653421', 'sales@lowes.com', 'http://www.lowes.com', NULL),
('Walmart', '14567 Walnut Lane', 'St Louis', 'FL', '387563628', '8722718927', 'info@walmart.com', 'http://www.walmart.com', NULL),
('Dollar General', '47583 Davison Road', 'Detroit', 'MI', '482983456', '3137583482', 'ask@dollargeneral.com', 'http://www.dollargeneral.com', 'recently sold property.');

SELECT * FROM dbo.store;
--
-- -------------------------------------------
-- Data - invoice
-- -------------------------------------------
INSERT INTO dbo.invoice
(ord_id, str_id, inv_date, inv_total, inv_paid, inv_notes)
VALUES
(5, 1, '2001-05-03', 58.32, 0, NULL),
(4, 1, '2006-11-11', 100.59, 0, NULL),
(1, 1, '2010-09-16', 57.34, 0, NULL),
(3, 2, '2011-01-10', 99.32, 1, NULL),
(2, 3, '2008-06-24', 1109.67, 1, NULL),
(6, 4, '2009-04-20', 239.83, 0, NULL),
(7, 5, '2010-09-09', 537.29, 0, NULL),
(8, 2, '2007-09-09', 644.21, 1, NULL),
(9, 3, '2011-12-17', 934.12, 1, NULL),
(10, 4, '2012-03-18', 27.45, 0, NULL);

SELECT * FROM dbo.invoice;
--
-- -------------------------------------------
-- Data - vendor
-- -------------------------------------------
INSERT INTO dbo.vendor
(ven_name, ven_street, ven_city, ven_state, ven_zip, ven_phone, ven_email, ven_url, ven_notes)
VALUES
('Sysco', '531 Dolphin Run', 'Orlando', 'FL', '344761234', '7641238543', 'sales@sysco.com', 'http://www.sysco.com', NULL),
('General Electric', '100 Happy Trails Drive', 'Boston', 'MA', '123458743', '2134569641', 'support@ge.com', 'http://www.ge.com', 'Very good turnaround!'),
('Cisco', '300 Cisco Drive', 'Stanford', 'OR', '872315492', '7823456723', 'cisco@cisco.com', 'http://www.cisco.com', NULL),
('Goodyear', '100 Goodyear Drive', 'Gary', 'IN', '485321956', '5784218427', 'sales@goodyear.com', 'http://www.goodyear.com', 'Competing well with Firestone.'),
('Snap-On', '42185 Mangenta Avenue', 'Lake Falls', 'ND', '387513649', '9197345632', 'support@snapon.com', 'http://www.snap-on.com', 'Good quality tools!');

SELECT * FROM dbo.vendor;
--
-- -------------------------------------------
-- Data - product
-- -------------------------------------------
INSERT INTO dbo.product
(ven_id, pro_name, pro_descript, pro_weight, pro_qoh, pro_cost, pro_price, pro_discount, pro_notes)
VALUES
(1, 'hammer', '', 2.5, 45, 4.99, 7.99, 30, 'Discounted only when purchased with screwdriver set.'),
(2, 'screwdriver', '', 1.8, 120, 1.99, 3.49, NULL, NULL),
(4, 'pail', '16 Gallon', 2.8, 48, 3.89, 7.99, 40, NULL),
(5, 'cooking oil', 'Peanut oil', 15, 19, 19.99, 28.99, NULL, 'gallons'),
(3, 'frying pan', '', 3.5, 178, 8.45, 13.99, 50, 'Currently 1/2 price sale.');

SELECT * FROM dbo.product;
--
-- -------------------------------------------
-- Data - order_line
-- -------------------------------------------
INSERT INTO dbo.order_line
(ord_id, pro_id, oln_qty, oln_price, oln_notes)
VALUES
(1, 2, 10, 8.0, NULL),
(2, 3, 7, 9.88, NULL),
(3, 4, 3, 6.99, NULL),
(5, 1, 2, 12.76, NULL),
(4, 5, 13, 58.99, NULL);

SELECT * FROM dbo.order_line;
--
-- -------------------------------------------
-- Data - payment
-- -------------------------------------------
INSERT INTO dbo.payment
(inv_id, pay_date, pay_amt, pay_notes)
VALUES
(5, '2008-07-01', 5.99, NULL),
(4, '2010-09-28', 4.99, NULL),
(1, '2008-07-23', 8.75, NULL),
(3, '2010-10-31', 19.55, NULL),
(2, '2011-03-29', 32.50, NULL),
(6, '2010-10-03', 20.00, NULL),
(8, '2008-08-09', 1000.00, NULL),
(9, '2009-01-10', 103.68, NULL),
(7, '2007-03-15', 25.00, NULL),
(10, '2007-05-12', 40.00, NULL),
(4, '2007-05-22', 9.33, NULL);

SELECT * FROM dbo.payment;
--
-- -------------------------------------------
-- Data - product_hist
-- -------------------------------------------
INSERT INTO dbo.product_hist
(pro_id, pht_date, pht_cost, pht_price, pht_discount, pht_notes)
VALUES
(1, '2005-01-02 11:53:34', 4.99, 7.99, 30, 'Discounted only when purchased with screwdriver set.'),
(2, '2005-02-03 09:13:56', 1.99, 3.49, NULL, NULL),
(3, '2005-03-04 23:21:49', 3.89, 7.99, 40, NULL),
(4, '2006-05-06 18:09:04', 19.99, 28.99, NULL, 'gallons'),
(5, '2006-05-07 15:07:29', 8.45, 13.99, 50, 'Currently 1/2 price sale.');

SELECT * FROM dbo.product_hist;
--
-- -------------------------------------------
-- Data - srp_hist
-- -------------------------------------------
INSERT INTO dbo.srp_hist
(per_id, sht_type, sht_modified, sht_modifier, sht_date, sht_yr_sales_goal, sht_yr_total_sales, sht_yr_total_comm, sht_notes)
VALUES
(1, 'i', GETDATE(), SYSTEM_USER, GETDATE(), 100000, 110000, 11000, NULL),
(4, 'i', GETDATE(), SYSTEM_USER, GETDATE(), 150000, 175000, 17500, NULL),
(3, 'u', GETDATE(), SYSTEM_USER, GETDATE(), 200000, 185000, 18500, NULL),
(2, 'u', GETDATE(), ORIGINAL_LOGIN(), GETDATE(), 210000, 220000, 22000, NULL),
(5, 'i', GETDATE(), ORIGINAL_LOGIN(), GETDATE(), 225000, 230000, 2300, NULL);

SELECT * FROM dbo.srp_hist;
--
-- -------------------------------------------
-- Data - phone
-- -------------------------------------------
-- -------------------------------------------
INSERT INTO dbo.phone
(per_id, phn_num, phn_type, phn_notes)
VALUES
(1, 2135551234, 'c', NULL),
(2, 8502225678, 'w', NULL),
(3, 3294358212, 'w', NULL),
(4, 4278881276, 'f', NULL),
(5, 8885001234, 'w', '800 number for the office.');

SELECT * FROM dbo.phone;