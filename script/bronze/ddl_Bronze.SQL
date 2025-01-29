/*
===============================================================================

DDL Script: Create Bronze Tables

===============================================================================
Script Purpose:
	This script creates tables in the 'bronze' schema, dropping existing tables
	if they already exist.
	Run this script to re-define the DDL structure of 'bronxe' Tables
===============================================================================

*/

-- CREATING TABLE bronze.crm_cust_info 
IF OBJECT_ID('bronze.crm_cust_info', 'U') IS NOT NULL
	DROP TABLE bronze.crm_cust_info;
CREATE TABLE bronze.crm_cust_info(
	Cust_id INT,
	cst_key VARCHAR(50),
	cst_firstname VARCHAR(30),
	cst_lastname VARCHAR(30),
	cst_marital_status VARCHAR(10),
	cst_gndr VARCHAR(10),
	cst_create_date DATE
);

-- Creating Table bronze.crm_prd_info
IF OBJECT_ID('bronze.crm_prd_info', 'U') IS NOT NULL
	DROP TABLE bronze.crm_prd_info;
CREATE TABLE bronze.crm_prd_info(
	prd_id INT,
	prd_key VARCHAR(50),
	prd_nm VARCHAR(50),
	prd_cost INT,
	prd_line VARCHAR(50),
	prd_start_dt DATE,
	prd_end_dr DATE
);

-- Creating Table bronze.crm_sales_details
IF OBJECT_ID('bronze.crm_sales_details', 'U') IS NOT NULL
	DROP TABLE bronze.crm_sales_details;
CREATE TABLE bronze.crm_sales_details(
	sls_ord_num VARCHAR(20),
	sls_prd_key VARCHAR(20),
	sls_cust_id INT,
	sls_ord_dt INT,
	sls_ship_dt INT,
	sls_due_dt INT,
	sls_sales INT,
	sls_quantity INT,
	sls_price INT
);

-- Creating Table bronze.erp_cust_az12
IF OBJECT_ID('bronze.erp_cust_az12', 'U') IS NOT NULL
	DROP TABLE bronze.erp_cust_az12;
CREATE TABLE bronze.erp_cust_az12(
	cid VARCHAR(50),
	Bdate DATE,
	Gen VARCHAR(10)
);

-- Creating Table bronze.erp_loc_a101 Table
IF OBJECT_ID('bronze.erp_loc_a101', 'U') IS NOT NULL
	DROP TABLE bronze.erp_loc_a101;
CREATE TABLE bronze.erp_loc_a101(
	cid VARCHAR(30),
	cntry VARCHAR(30)
);

-- Creating bronze.erp_px_cat_g1v12 Table
IF OBJECT_ID('bronze.erp_px_cat_g1v12', 'U') IS NOT NULL
	DROP TABLE bronze.erp_px_cat_g1v12;
CREATE TABLE bronze.erp_px_cat_g1v12(
	id VARCHAR(50),
	cat VARCHAR(30),
	subcat VARCHAR(50),
	maintenance VARCHAR(20)
);
