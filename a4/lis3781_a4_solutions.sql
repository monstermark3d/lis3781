-- Mark Trombly
-- Assignment #4
--
-- MSSQL
--
SET ANSI_WARNINGS ON;
GO
-- avoids error that user kept db connection open
use master;
GO
-- *IF* vs code error (with sql server express): "Cannot drop database because it is currently in use"
ALTER DATABASE [mtrombly]
SET SINGLE_USER WITH ROLLBACK IMMEDIATE;
GO
-- drop existing database if it exists (use *your* username)
IF EXISTS (SELECT name FROM master.dbo.sysdatabases WHERE name = N'mtrombly')
DROP DATABASE mtrombly;
GO
-- create database if not exists (use *your* username)
IF NOT EXISTS (SELECT name FROM master.dbo.sysdatabases WHERE name = N'mtrombly')
CREATE DATABASE mtrombly;
GO
--
use mtrombly;
GO
-- -------------------------------------------
-- Table person
-- -------------------------------------------
IF OBJECT_ID(N'dbo.person',N'U') IS NOT NULL
DROP TABLE dbo.person;
GO

CREATE TABLE dbo.person
(
  per_id SMALLINT NOT NULL IDENTITY(1,1),
  per_ssn BINARY(64) NULL,
  per_salt BINARY(64) NULL,
  per_fname VARCHAR(15) NOT NULL,
  per_lname VARCHAR(30) NOT NULL,
  per_gender CHAR(1) NOT NULL CHECK(per_gender IN('m','f')),
  per_dob DATE NOT NULL,
  per_street VARCHAR(30) NOT NULL,
  per_city VARCHAR(30) NOT NULL,
  per_state CHAR(2) NOT NULL DEFAULT 'FL',
  per_zip INT NOT NULL CHECK (per_zip like '[0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9]'),
  per_email VARCHAR(100) NULL,
  per_type CHAR(1) NOT NULL CHECK(per_type IN('c','s')),
  per_notes VARCHAR(45) NULL,
  PRIMARY KEY(per_id),

  CONSTRAINT ux_per_ssn UNIQUE NONCLUSTERED(per_ssn ASC)
);
--
-- -------------------------------------------
-- Table phone
-- -------------------------------------------
IF OBJECT_ID(N'dbo.phone',N'U') IS NOT NULL
DROP TABLE dbo.phone;
GO

CREATE TABLE dbo.phone
(
  phn_id SMALLINT NOT NULL IDENTITY(1,1),
  per_id SMALLINT NOT NULL,
  phn_num BIGINT NOT NULL CHECK(phn_num like'[0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9]'),
  phn_type CHAR(1) NOT NULL CHECK(phn_type IN('h','c','w','f')),
  phn_notes VARCHAR(255) NULL,
  PRIMARY KEY(phn_id),

  CONSTRAINT fk_phone_person
    FOREIGN KEY(per_id)
    REFERENCES dbo.person(per_id)
    ON DELETE CASCADE
    ON UPDATE CASCADE
);
--
-- -------------------------------------------
-- Table customer
-- -------------------------------------------
IF OBJECT_ID(N'dbo.customer',N'U') IS NOT NULL
DROP TABLE dbo.customer;
GO

CREATE TABLE dbo.customer
(
  per_id SMALLINT NOT NULL,
  cus_balance DECIMAL(7,2) NOT NULL CHECK(cus_balance >= 0),
  cus_total_sales DECIMAL(7,2) NOT NULL CHECK(cus_total_sales >= 0),
  cus_notes VARCHAR(45) NULL,
  PRIMARY KEY(per_id),

  CONSTRAINT fk_customer_person
    FOREIGN KEY(per_id)
    REFERENCES dbo.person(per_id)
    ON DELETE CASCADE
    ON UPDATE CASCADE
);
--
-- -------------------------------------------
-- Table slsrep
-- -------------------------------------------
IF OBJECT_ID(N'dbo.slsrep',N'U') IS NOT NULL
DROP TABLE dbo.slsrep;
GO

CREATE TABLE dbo.slsrep
(
    per_id SMALLINT NOT NULL,
    srp_yr_sales_goal DECIMAL(8,2) NOT NULL CHECK(srp_yr_sales_goal >= 0),
    srp_ytd_sales DECIMAL(8,2) NOT NULL CHECK(srp_ytd_sales >= 0),
    srp_ytd_comm DECIMAL(7,2) NOT NULL CHECK(srp_ytd_comm >= 0),
    srp_notes VARCHAR(45) NULL,
    PRIMARY KEY(per_id),

    CONSTRAINT fk_slsrep_person
      FOREIGN KEY(per_id)
      REFERENCES dbo.person(per_id)
      ON DELETE CASCADE
      ON UPDATE CASCADE
);
--
-- -------------------------------------------
-- Table srp_hist
-- -------------------------------------------
IF OBJECT_ID(N'dbo.srp_hist',N'U') IS NOT NULL
DROP TABLE dbo.srp_hist;
GO

CREATE TABLE dbo.srp_hist
(
    sht_id SMALLINT NOT NULL IDENTITY(1,1),
    per_id SMALLINT NOT NULL,
    sht_type CHAR(1) NOT NULL CHECK(sht_type IN('i','u','d')),
    sht_modified DATETIME NOT NULL,
    sht_modifier VARCHAR(45) NOT NULL DEFAULT system_user,
    sht_date DATE NOT NULL DEFAULT getDate(),
    sht_yr_sales_goal DECIMAL(8,2) NOT NULL CHECK(sht_yr_sales_goal >= 0),
    sht_yr_total_sales DECIMAL(8,2) NOT NULL CHECK(sht_yr_total_sales >= 0),
    sht_yr_total_comm DECIMAL(7,2) NOT NULL CHECK(sht_yr_total_comm >= 0),
    sht_notes VARCHAR(45) NULL,
    PRIMARY KEY(sht_id),

    CONSTRAINT fk_srp_hist_slsrep
      FOREIGN KEY(per_id)
      REFERENCES dbo.slsrep(per_id)
      ON DELETE CASCADE
      ON UPDATE CASCADE
);
--
-- -------------------------------------------
-- Table contact
-- -------------------------------------------
IF OBJECT_ID(N'dbo.contact',N'U') IS NOT NULL
DROP TABLE dbo.contact;
GO

CREATE TABLE dbo.contact
(
    cnt_id INT NOT NULL IDENTITY(1,1),
    per_cid SMALLINT NOT NULL,
    per_sid SMALLINT NOT NULL,
    cnt_date DATETIME NOT NULL,
    cnt_notes VARCHAR(255) NULL,
    PRIMARY KEY(cnt_id),

    CONSTRAINT fk_contact_customer
      FOREIGN KEY(per_cid)
      REFERENCES dbo.customer(per_id)
      ON DELETE CASCADE
      ON UPDATE CASCADE,
    
    CONSTRAINT fk_contact_slsrep
      FOREIGN KEY(per_sid)
      REFERENCES dbo.slsrep(per_id)
      ON DELETE NO ACTION
      ON UPDATE NO ACTION
);
--
-- -------------------------------------------
-- Table [order]
-- -------------------------------------------
IF OBJECT_ID(N'dbo.[order]',N'U') IS NOT NULL
DROP TABLE dbo.[order];
GO

CREATE TABLE dbo.[order]
(
  ord_id INT NOT NULL IDENTITY(1,1),
  cnt_id INT NOT NULL,
  ord_placed_date DATETIME NOT NULL,
  ord_filled_date DATETIME NULL,
  ord_notes VARCHAR(255) NULL,
  PRIMARY KEY(ord_id),

  CONSTRAINT fk_order_contact
    FOREIGN KEY(cnt_id)
    REFERENCES dbo.contact(cnt_id)
    ON DELETE CASCADE
    ON UPDATE CASCADE
);
--
-- -------------------------------------------
-- Table store
-- -------------------------------------------
IF OBJECT_ID(N'dbo.store',N'U') IS NOT NULL
DROP TABLE dbo.store;
GO

CREATE TABLE dbo.store
(
  str_id SMALLINT NOT NULL IDENTITY(1,1),
  str_name VARCHAR(45) NOT NULL,
  str_street VARCHAR(30) NOT NULL,
  str_city VARCHAR(30) NOT NULL,
  str_state CHAR(2) NOT NULL DEFAULT 'FL',
  str_zip INT NOT NULL CHECK (str_zip like '[0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9]'),
  str_phone BIGINT NOT NULL CHECK (str_phone like '[0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9]'),
  str_email VARCHAR(100) NOT NULL,
  str_url VARCHAR(100) NOT NULL,
  str_notes VARCHAR(255) NULL,
  PRIMARY KEY(str_id)
);
--
-- -------------------------------------------
-- Table invoice
-- -------------------------------------------
IF OBJECT_ID(N'dbo.invoice',N'U') IS NOT NULL
DROP TABLE dbo.invoice;
GO

CREATE TABLE dbo.invoice
(
  inv_id INT NOT NULL IDENTITY(1,1),
  ord_id INT NOT NULL,
  str_id SMALLINT NOT NULL,
  inv_date DATETIME NOT NULL,
  inv_total DECIMAL(8,2) NOT NULL CHECK(inv_total >= 0),
  inv_paid BIT NOT NULL,
  inv_notes VARCHAR(255) NULL,
  PRIMARY KEY(inv_id),

  CONSTRAINT ux_ord_id UNIQUE NONCLUSTERED(ord_id ASC),

  CONSTRAINT fk_invoice_order
    FOREIGN KEY(ord_id)
    REFERENCES dbo.[order](ord_id)
    ON DELETE CASCADE
    ON UPDATE CASCADE,

  CONSTRAINT fk_invoice_store
    FOREIGN KEY(str_id)
    REFERENCES dbo.store(str_id)
    ON DELETE CASCADE
    ON UPDATE CASCADE
);
--
-- -------------------------------------------
-- Table payment
-- -------------------------------------------
IF OBJECT_ID(N'dbo.payment',N'U') IS NOT NULL
DROP TABLE dbo.payment;
GO

CREATE TABLE dbo.payment
(
  pay_id INT NOT NULL IDENTITY(1,1),
  inv_id INT NOT NULL,
  pay_date DATETIME NOT NULL,
  pay_amt DECIMAL(7,2) NOT NULL CHECK(pay_amt >= 0),
  pay_notes VARCHAR(255) NULL,
  PRIMARY KEY(pay_id),

  CONSTRAINT fk_payment_invoice
    FOREIGN KEY(inv_id)
    REFERENCES dbo.invoice(inv_id)
    ON DELETE CASCADE
    ON UPDATE CASCADE
);
--
-- -------------------------------------------
-- Table vendor
-- -------------------------------------------
IF OBJECT_ID(N'dbo.vendor',N'U') IS NOT NULL
DROP TABLE dbo.vendor;
GO

CREATE TABLE dbo.vendor
(
  ven_id SMALLINT NOT NULL IDENTITY(1,1),
  ven_name VARCHAR(45) NOT NULL,
  ven_street VARCHAR(30) NOT NULL,
  ven_city VARCHAR(30) NOT NULL,
  ven_state CHAR(2) NOT NULL DEFAULT 'FL',
  ven_zip INT NOT NULL CHECK (ven_zip like '[0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9]'),
  ven_phone BIGINT NOT NULL CHECK (ven_phone like '[0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9]'),
  ven_email VARCHAR(100) NULL,
  ven_url VARCHAR(100) NULL,
  ven_notes VARCHAR(255) NULL,
  PRIMARY KEY(ven_id)
);
--
-- -------------------------------------------
-- Table product
-- -------------------------------------------
IF OBJECT_ID(N'dbo.product',N'U') IS NOT NULL
DROP TABLE dbo.product;
GO

CREATE TABLE dbo.product
(
  pro_id SMALLINT NOT NULL IDENTITY(1,1),
  ven_id SMALLINT NOT NULL,
  pro_name VARCHAR(30) NOT NULL,
  pro_descript VARCHAR(45) NULL,
  pro_weight FLOAT NOT NULL CHECK(pro_weight >= 0),
  pro_qoh SMALLINT NOT NULL CHECK (pro_qoh >= 0),
  pro_cost DECIMAL(7,2) NOT NULL CHECK(pro_cost >= 0),
  pro_price DECIMAL(7,2) NOT NULL CHECK(pro_price >= 0),
  pro_discount DECIMAL(3,0) NULL,
  pro_notes VARCHAR(255) NULL,
  PRIMARY KEY(pro_id),

  CONSTRAINT fk_product_vendor
    FOREIGN KEY(ven_id)
    REFERENCES dbo.vendor(ven_id)
    ON DELETE CASCADE
    ON UPDATE CASCADE
);
--
-- -------------------------------------------
-- Table product_hist
-- -------------------------------------------
IF OBJECT_ID(N'dbo.product_hist',N'U') IS NOT NULL
DROP TABLE dbo.product_hist;
GO

CREATE TABLE dbo.product_hist
(
  pht_id INT NOT NULL IDENTITY(1,1),
  pro_id SMALLINT NOT NULL,
  pht_date DATETIME NOT NULL,
  pht_cost DECIMAL(7,2) NOT NULL CHECK(pht_cost >= 0),
  pht_price DECIMAL(7,2) NOT NULL CHECK(pht_price >= 0),
  pht_discount DECIMAL(3,0) NULL,
  pht_notes VARCHAR(255) NULL,
  PRIMARY KEY(pht_id),

  CONSTRAINT fk_product_hist_product
    FOREIGN KEY(pro_id)
    REFERENCES dbo.product(pro_id)
    ON DELETE CASCADE
    ON UPDATE CASCADE
);
--
-- -------------------------------------------
-- Table order_line
-- -------------------------------------------
IF OBJECT_ID(N'dbo.order_line',N'U') IS NOT NULL
DROP TABLE dbo.order_line;
GO

CREATE TABLE dbo.order_line
(
  oln_id INT NOT NULL IDENTITY(1,1),
  ord_id INT NOT NULL,
  pro_id SMALLINT NOT NULL,
  oln_qty SMALLINT NOT NULL CHECK(oln_qty >= 0),
  oln_price DECIMAL(7,2) NOT NULL CHECK(oln_price >= 0),
  oln_notes VARCHAR(255) NULL,
  PRIMARY KEY(oln_id),

  CONSTRAINT fk_order_line_order
    FOREIGN KEY(ord_id)
    REFERENCES dbo.[order](ord_id)
    ON DELETE CASCADE
    ON UPDATE CASCADE,

  CONSTRAINT fk_order_line_product
    FOREIGN KEY(pro_id)
    REFERENCES dbo.product(pro_id)
    ON DELETE CASCADE
    ON UPDATE CASCADE
);

SELECT * FROM INFORMATION_SCHEMA.tables;

