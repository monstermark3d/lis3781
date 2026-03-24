-- Mark Trombly
-- Assignment #4
--
-- MSSQL
--
select * from [mtrombly].INFORMATION_SCHEMA.tables;
GO

select * from [mtrombly].INFORMATION_SCHEMA.columns;
GO

sp_help 'dbo.srp_hist';
GO

USE mtrombly;
GO

--
-- -------------------------------------------
-- Question #1
-- -------------------------------------------
PRINT '#1 Solution: create view (sum of each customer''s *paid* invoices, in desc order):';

IF OBJECT_ID(N'dbo.v_paid_invoice_total',N'V') IS NOT NULL
  DROP VIEW dbo.v_paid_invoice_total;
GO

CREATE VIEW dbo.v_paid_invoice_total AS
  SELECT p.per_id, per_fname, per_lname, sum(inv_total) as sum_total, FORMAT(sum(inv_total),'C', 'en-us') as v_paid_invoice_total
  FROM dbo.person p
    JOIN dbo.customer c ON p.per_id = c.per_id
    JOIN dbo.contact ct on c.per_id = ct.per_cid
    JOIN dbo.[order] o ON ct.cnt_id = o.cnt_id
    JOIN dbo.invoice i ON o.ord_id = i.ord_id
  WHERE inv_paid != 0

  GROUP BY p.per_id, per_fname, per_lname
GO

SELECT per_id, per_fname, per_lname, v_paid_invoice_total from dbo.v_paid_invoice_total order by sum_total desc;
GO
--
-- -------------------------------------------
-- Question #2
-- -------------------------------------------
IF OBJECT_ID(N'dbo.sp_all_customers_outstanding_balances',N'P') IS NOT NULL
  DROP PROC dbo.sp_all_customers_outstanding_balances
GO

CREATE PROC dbo.sp_all_customers_outstanding_balances AS
BEGIN
  SELECT p.per_id, per_fname, per_lname,
  SUM(pay_amt) as total_paid, (inv_total - sum(pay_amt)) invoice_diff
    FROM person p
      JOIN dbo.customer c on p.per_id = c.per_id
      JOIN dbo.contact ct ON c.per_id = ct.per_cid
      JOIN dbo.[order] o ON ct.cnt_id = o.cnt_id
      JOIN dbo.invoice i ON o.ord_id = i.ord_id
      JOIN dbo.payment pt ON i.inv_id = pt.inv_id
  GROUP BY p.per_id, per_fname, per_lname, inv_total
  ORDER BY invoice_diff DESC;
END
GO

EXEC dbo.sp_all_customers_outstanding_balances;
--
-- -------------------------------------------
-- Question #3
-- -------------------------------------------
IF OBJECT_ID(N'dbo.sp_populate_srp_hist_table',N'P') IS NOT NULL
  DROP PROC dbo.sp_populate_srp_hist_table
GO

CREATE PROC dbo.sp_populate_srp_hist_table AS
BEGIN
  INSERT INTO dbo.srp_hist
  (per_id, sht_type, sht_modified, sht_modifier, sht_date, sht_yr_sales_goal, sht_yr_total_sales, sht_yr_total_comm, sht_notes)

  SELECT per_id, 'i', GETDATE(), SYSTEM_USER, GETDATE(), srp_yr_sales_goal, srp_ytd_sales, srp_ytd_comm, srp_notes
    FROM dbo.slsrep;
END
GO
--
-- -------------------------------------------
-- Question #4
-- -------------------------------------------
IF OBJECT_ID(N'dbo.trg_sales_history_insert',N'TR') IS NOT NULL
  DROP TRIGGER dbo.trg_sales_history_insert
GO

CREATE TRIGGER dbo.trg_sales_history_insert
ON dbo.slsrep 
AFTER INSERT AS
BEGIN
  DECLARE
  @per_id_v SMALLINT,
  @sht_type_v CHAR(1),
  @sht_modified_v DATE,
  @sht_modifier_v VARCHAR(45),
  @sht_date_v DATE,
  @sht_yr_sales_goal_v DECIMAL(8,2),
  @sht_yr_total_sales_v DECIMAL(8,2),
  @sht_yr_total_comm_v DECIMAL(7,2),
  @sht_notes_v VARCHAR(255);

  SELECT
  @per_id_v = per_id,
  @sht_type_v = 'i',
  @sht_modified_v = GETDATE(),
  @sht_modifier_v = SYSTEM_USER,
  @sht_date_v = GETDATE(),
  @sht_yr_sales_goal_v = srp_yr_sales_goal,
  @sht_yr_total_sales_v = srp_ytd_sales,
  @sht_yr_total_comm_v = srp_ytd_comm,
  @sht_notes_v = srp_notes
  FROM INSERTED;

  INSERT INTO dbo.srp_hist
  (per_id, sht_type, sht_modified, sht_modifier, sht_date, sht_yr_sales_goal, sht_yr_total_sales, sht_yr_total_comm, sht_notes)
  VALUES
  (@per_id_v, @sht_type_v, @sht_modified_v, @sht_modifier_v, sht_date_v, @sht_yr_sales_goal_v, @sht_yr_total_sales_v, @sht_yr_total_comm_v, @sht_notes_v);
END
GO
--
-- Test trigger
/*
SELECT * FROM slsrep;
SELECT * FROM srp_hist;

INSERT INTO dbo.slsrep
(per_id, srp_yr_sales_goal, srp_ytd_sales, srp_ytd_comm, srp_notes)
VALUES
(6, 98000, 43000, 8750, 'per_id values 1-5 already used');

SELECT * FROM slsrep;
SELECT * FROM srp_hist;
*/
--
-- -------------------------------------------
-- Question #5
-- -------------------------------------------
IF OBJECT_ID(N'dbo.trg_product_history_insert',N'TR') IS NOT NULL
  DROP TRIGGER dbo.trg_product_history_insert
GO

CREATE TRIGGER dbo.trg_product_history_insert
ON dbo.product 
AFTER INSERT AS
BEGIN
  DECLARE
    @pro_id_v SMALLINT,
    @pht_modified_v DATE,
    @pht_cost_v DATE,
    @pht_cost_v DECIMAL(7,2),
    @pht_price_v DECIMAL(7,2),
    @pht_discount_v DECIMAL(3,0),
    @pht_notes_v VARCHAR(255);

    SELECT
    @pro_id_v = pro_id,
    @pht_modified_v = GETDATE(),
    @pht_cost_v = pro_cost,
    @pht_price_v = pro_price,
    @pht_discount_v = pro_discount,
    @pht_notes_v = pro_notes
    FROM INSERTED;

    INSERT INTO dbo.product_hist
    (pro_id, pht_date, pht_cost, pht_price, pht_discount, pht_notes)
    VALUES
    (@pro_id_v, @pht_modified_v, @pht_cost_v, @pht_price_v, @pht_discount_v, @pht_notes_v);
END
GO
--
-- Test trigger
/*
SELECT * FROM product;
SELECT * FROM product_hist;

INSERT INTO dbo.product
(ven_id, pro_name, pro_descript, pro_weight, pro_qoh, pro_cost, pro_price, pro_discount, pro_notes)
VALUES
(3, 'desk lamp', 'small desk lamp with led lights', 3.6, 14, 5.98, 11.99, 15, 'No discounts after sale.');

SELECT * FROM product;
SELECT * FROM product_hist;
*/
--
-- -------------------------------------------
-- Question #6
-- -------------------------------------------
IF OBJECT_ID(N'dbo.sp_annual_salesrep_sales_goal',N'P') IS NOT NULL
  DROP PROC dbo.sp_annual_salesrep_sales_goal
GO

CREATE PROC dbo.sp_annual_salesrep_sales_goal AS
BEGIN
  UPDATE slsrep 
  SET srp_yr_sales_goal = sht_yr_total_sales * 1.08
  FROM slsrep AS sr
    JOIN srp_hist as sh
    ON sr.per_id = sh.per_id
  WHERE sht_date = (SELECT MAX(sht_date) FROM srp_hist);
END
GO
--
-- Test trigger
/*
SELECT * FROM dbo.slsrep;
SELECT * FROM dbo.srp_hist;

EXEC dbo.sp_annual_salesrep_sales_goal;

SELECT * FROM dbo.slsrep;
*/