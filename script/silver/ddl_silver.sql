
/*
===============================================================================

DDL Script: Create silver Tables

===============================================================================
Script Purpose:
	This script creates tables in the 'silver' schema, dropping existing tables
	if they already exist.
	Run this script to re-define the DDL structure of 'bronxe' Tables
===============================================================================

=========================================================
Stored Procedure : Load silver Layer (Source -> silver)
=========================================================
Script Purpose:
  This stored procedures loads data into the silver schema from external csv files.
  It performs the following actions:
    - Truncate the silver table beofre loading data.
    - Uses the BULK INSERT' command to load data from csv file to silver table


Parameter: 
  None. 
  This stored procedure does not accept any parmater or returns values.

Usage Example:
  EXCE silver.load_silver

*/


-- CREATING TABLE silver.crm_cust_info 
IF OBJECT_ID('silver.crm_cust_info', 'U') IS NOT NULL
	DROP TABLE silver.crm_cust_info;
CREATE TABLE silver.crm_cust_info(
	Cust_id INT,
	cst_key VARCHAR(50),
	cst_firstname VARCHAR(30),
	cst_lastname VARCHAR(30),
	cst_marital_status VARCHAR(10),
	cst_gndr VARCHAR(10),
	cst_create_date DATE,
	dwhe_create_date DATETIME2 DEFAULT GETDATE()
);

-- Creating Table silver.crm_prd_info
IF OBJECT_ID('silver.crm_prd_info', 'U') IS NOT NULL
	DROP TABLE silver.crm_prd_info;
CREATE TABLE silver.crm_prd_info(
	prd_id INT,
	cat_id VARCHAR(50),
	prd_key VARCHAR(50),
	prd_nm VARCHAR(50),
	prd_cost INT,
	prd_line VARCHAR(50),
	prd_start_dt DATE,
	prd_end_dt DATE,
	dwhe_create_date DATETIME2 DEFAULT GETDATE()
);


-- Creating Table silver.crm_sales_details
IF OBJECT_ID('silver.crm_sales_details', 'U') IS NOT NULL
	DROP TABLE silver.crm_sales_details;
CREATE TABLE silver.crm_sales_details(
	sls_ord_num VARCHAR(20),
	sls_prd_key VARCHAR(20),
	sls_cust_id INT,
	sls_ord_dt DATE,
	sls_ship_dt DATE,
	sls_due_dt DATE,
	sls_sales INT,
	sls_quantity INT,
	sls_price INT,
	dwhe_create_date DATETIME2 DEFAULT GETDATE()
);

-- Creating Table silver.erp_cust_az12
IF OBJECT_ID('silver.erp_cust_az12', 'U') IS NOT NULL
	DROP TABLE silver.erp_cust_az12;
CREATE TABLE silver.erp_cust_az12(
	cid VARCHAR(50),
	Bdate DATE,
	Gen VARCHAR(10),
	dwhe_create_date DATETIME2 DEFAULT GETDATE()
);

-- Creating Table silver.erp_loc_a101 Table
IF OBJECT_ID('silver.erp_loc_a101', 'U') IS NOT NULL
	DROP TABLE silver.erp_loc_a101;
CREATE TABLE silver.erp_loc_a101(
	cid VARCHAR(30),
	cntry VARCHAR(30),
	dwhe_create_date DATETIME2 DEFAULT GETDATE()
);

-- Creating silver.erp_px_cat_g1v12 Table
IF OBJECT_ID('silver.erp_px_cat_g1v12', 'U') IS NOT NULL
	DROP TABLE silver.erp_px_cat_g1v12;
CREATE TABLE silver.erp_px_cat_g1v12(
	id VARCHAR(50),
	cat VARCHAR(30),
	subcat VARCHAR(50),
	maintenance VARCHAR(20),
	dwhe_create_date DATETIME2 DEFAULT GETDATE()
);

x
