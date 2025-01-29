/*
=========================================================
Stored Procedure : Load Bronze Layer (Source -> Bronze)
=========================================================
Script Purpose:
  This stored procedures loads data into the bronze schema from external csv files.
  It performs the following actions:
    - Truncate the bronze table beofre loading data.
    - Uses the BULK INSERT' command to load data from csv file to bronze table


Parameter: 
  None. 
  This stored procedure does not accept any parmater or returns values.

Usage Example:
  EXCE bronze.load_bronze
*/



CREATE OR ALTER PROCEDURE bronze.load_bronze AS
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

