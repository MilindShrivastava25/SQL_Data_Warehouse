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


CREATE OR ALTER PROCEDURE bronze_load_bronze AS
BEGIN
	DECLARE @Start_Time DATE
	DECLARE @End_Time DATE
	BEGIN TRY
		PRINT '============================================================';
		PRINT 'Loading Bronze Layer';
		PRINT '============================================================';

		PRINT '------------------------------------------------------------';
		PRINT 'Loading CRM Source';
		PRINT '------------------------------------------------------------';

		SET @Start_Time	= GETDATE()
		-- Deleting Every Data From bronze.crm_cust_info Table
		TRUNCATE TABLE bronze.crm_cust_info;

		-- Bulk Inserting Data Into bronze.crm_cust_info Table
		BULK INSERT bronze.crm_cust_info 
		FROM 'C:\Program Files\Microsoft SQL Server\MSSQL16.SQLEXPRESS\MSSQL\DATA\sql-data-warehouse-project\sql-data-warehouse-project\datasets\source_crm\cust_info.csv'
		WITH (
			FIRSTROW = 2,
			FIELDTERMINATOR = ',',
			TABLOCK
		);
		SET @End_Time	= GETDATE();
		PRINT 'Loading Duration : ' + CAST(DATEDIFF(Second, @start_Time, @end_time) AS NVARCHAR)
		PRINT '-------------------------'


		SET @Start_Time = GETDATE()
		-- Deleting Every Data From bronze.crm_prd_info Table
		TRUNCATE TABLE bronze.crm_prd_info;

		-- Bulk Inserting Data Into bronze.crm_prd_info
		BULK INSERT bronze.crm_prd_info
		FROM 'C:\Program Files\Microsoft SQL Server\MSSQL16.SQLEXPRESS\MSSQL\DATA\sql-data-warehouse-project\sql-data-warehouse-project\datasets\source_crm\prd_info.csv'
		WITH (
			FIRSTROW = 2,
			FIELDTERMINATOR = ',',
			TABLOCK
		);
		SET @End_Time	= GETDATE();
		PRINT 'Loading Duration : ' + CAST(DATEDIFF(Second, @start_Time, @end_time) AS NVARCHAR)
		PRINT '-------------------------'


		SET @Start_Time = GETDATE()
		-- Deleting Every Data From bronze.crm_sales_details Table
		TRUNCATE TABLE bronze.crm_sales_details;

		-- Bulk Inserting Data into bronze.crm_sales_details Table
		BULK INSERT bronze.crm_sales_details
		FROM 'C:\Program Files\Microsoft SQL Server\MSSQL16.SQLEXPRESS\MSSQL\DATA\sql-data-warehouse-project\sql-data-warehouse-project\datasets\source_crm\sales_details.csv'
		WITH(
			FIRSTROW = 2,
			FIELDTERMINATOR = ',',
			TABLOCK
		);
		SET @End_Time	= GETDATE();
		PRINT 'Loading Duration : ' + CAST(DATEDIFF(Second, @start_Time, @end_time) AS NVARCHAR)
		PRINT '-------------------------'

		PRINT '------------------------------------------------------------'
		PRINT 'Loaing ERP Tables'
		PRINT '------------------------------------------------------------'

		SET @Start_Time = GETDATE()
		-- Deleting Every Data From bronze.erp_cust_az12 Table
		TRUNCATE TABLE bronze.erp_cust_az12;

		-- Bulk Inserting Data Into bronze.erp_cust_az12 Table
		BULK INSERT bronze.erp_cust_az12
		FROM 'C:\Program Files\Microsoft SQL Server\MSSQL16.SQLEXPRESS\MSSQL\DATA\sql-data-warehouse-project\sql-data-warehouse-project\datasets\source_erp\CUST_AZ12.csv'
		WITH(
			FIRSTROW = 2,
			FIELDTERMINATOR = ',',
			TABLOCK
		);
		SET @End_Time	= GETDATE();
		PRINT 'Loading Duration : ' + CAST(DATEDIFF(Second, @start_Time, @end_time) AS NVARCHAR)
		PRINT '-------------------------'

		SET @Start_Time = GETDATE()
		-- Deleting Every Data From bronze.erp_loc_a101 Table
		TRUNCATE TABLE bronze.erp_loc_a101;

		-- Bulk Inserting Data Into bronze.erp_loc_a101 Table
		BULK INSERT bronze.erp_loc_a101
		FROM 'C:\Program Files\Microsoft SQL Server\MSSQL16.SQLEXPRESS\MSSQL\DATA\sql-data-warehouse-project\sql-data-warehouse-project\datasets\source_erp\LOC_A101.csv'
		WITH(
			FIRSTROW = 2,
			FIELDTERMINATOR = ',',
			TABLOCK
		);
		SET @End_Time	= GETDATE();
		PRINT 'Loading Duration : ' + CAST(DATEDIFF(Second, @start_Time, @end_time) AS NVARCHAR)
		PRINT '-------------------------'

		SET @Start_Time = GETDATE()
		-- Deleting Every Data From bronze.erp_px_cat_g1v12 Table
		TRUNCATE TABLE bronze.erp_px_cat_g1v12;

		-- Bulk Inserting Data Into bronze.erp_px_cat_g1v12 Table
		BULK INSERT bronze.erp_px_cat_g1v12
		FROM 'C:\Program Files\Microsoft SQL Server\MSSQL16.SQLEXPRESS\MSSQL\DATA\sql-data-warehouse-project\sql-data-warehouse-project\datasets\source_erp\PX_CAT_G1V2.csv'
		WITH(
			FIRSTROW = 2,
			FIELDTERMINATOR = ',',
			TABLOCK
		);
		SET @End_Time	= GETDATE();
		PRINT 'Loading Duration : ' + CAST(DATEDIFF(Second, @start_Time, @end_time) AS NVARCHAR)
		PRINT '-------------------------'

	END TRY
	BEGIN CATCH
		PRINT 'Error Occured During Loading Bronze Layer';
		PRINT 'Error Message: ' + ERROR_MESSAGE();
		PRINT 'Error Message: ' + CAST(ERROR_NUMBER() AS NVARCHAR);
	END CATCH

END

EXEC bronze_load_bronze
