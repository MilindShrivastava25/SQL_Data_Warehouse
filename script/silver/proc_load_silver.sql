CREATE OR ALTER PROCEDURE silver.load_silver AS 
BEGIN
	DECLARE @Start_Time DATE
	DECLARE @End_Time DATE
		BEGIN TRY
			PRINT '============================================================';
			PRINT 'Loading Silver Layer';
			PRINT '============================================================';

			PRINT '------------------------------------------------------------';
			PRINT 'Loading CRM Source';
			PRINT '------------------------------------------------------------';

			SET @Start_Time	= GETDATE();
			-- Customer_Info
			TRUNCATE TABLE silver.crm_cust_info;
			INSERT INTO silver.crm_cust_info
			(	
				Cust_id,
				cst_key,
				cst_firstname,
				cst_lastname,
				cst_marital_status,
				cst_gndr,
				cst_create_date
			)
			SELECT  
				Cust_id,
				cst_key,
				TRIM(cst_firstname) AS cst_firstname,
				TRIM(cst_lastname) AS cst_lastname,
				CASE 
					WHEN cst_marital_status = 'M' THEN 'Married'
					WHEN cst_marital_status = 'S' THEN 'Single'
					ELSE 'n/a'
				END cst_marital_status,
				CASE 
					WHEN UPPER(TRIM(cst_gndr)) = 'F' THEN 'Female'
					WHEN UPPER(TRIM(cst_gndr)) = 'M' THEN 'Male'
					ELSE 'n/a'
				END AS cst_gndr,
				cst_create_date
			FROM
			(SELECT *, ROW_NUMBER() OVER(PARTITION BY Cust_Id ORDER BY cst_create_date) AS Flag
			FROM bronze.crm_cust_info)t WHERE Flag = 1;
			SET @End_Time	= GETDATE();
			PRINT 'Loading Duration : ' + CAST(DATEDIFF(Second, @start_Time, @end_time) AS NVARCHAR)
			PRINT '-------------------------'


			-- Product_Info
			SET @Start_Time	= GETDATE();
			TRUNCATE TABLE silver.crm_prd_info;
			INSERT INTO silver.crm_prd_info(
				prd_id,
				cat_id,
				prd_key,
				prd_nm,
				prd_cost,
				prd_line,
				prd_start_dt,
				prd_end_dt
			)
			SELECT 
				prd_id,
				REPLACE(SUBSTRING(prd_key, 1, 5), '-','_') AS cat_id,
				SUBSTRING(prd_key, 7, LEN(prd_key)) AS prd_key,
				prd_nm,
				ISNULL(prd_cost, 0) prd_cost,
				CASE prd_line
					WHEN 'M' THEN 'Mountain'
					WHEN 'R' THEN 'Road'
					WHEN 'S' THEN 'Other Sales'
					WHEN 'T' THEN 'Tourring'
					ELSE 'n/a'
				END AS prd_line,
				prd_start_dt,
				LEAD(prd_start_dt) OVER(PARTITION BY prd_key ORDER BY prd_start_dt) AS prd_end_dt8
			FROM bronze.crm_prd_info;
			SET @End_Time	= GETDATE();
			PRINT 'Loading Duration : ' + CAST(DATEDIFF(Second, @start_Time, @end_time) AS NVARCHAR)
			PRINT '-------------------------'



			-- Sales_Details
			SET @Start_Time	= GETDATE();
			TRUNCATE TABLE silver.crm_sales_details;
			INSERT INTO silver.crm_sales_details(
				sls_ord_num,
				sls_prd_key,
				sls_cust_id,
				sls_ord_dt,
				sls_ship_dt,
				sls_due_dt,
				sls_sales,
				sls_quantity,
				sls_price)
			SELECT 
				sls_ord_num,
				sls_prd_key,
				sls_cust_id,
				CASE 
					WHEN sls_ord_dt <=  0 OR LEN(sls_ord_dt) != 8 THEN NULL
					ELSE CAST(CAST(sls_ord_dt AS VARCHAR) AS DATE)
				END  sls_ord_dt,
				CASE 
					WHEN sls_ship_dt <=  0 OR LEN(sls_ship_dt) != 8 THEN NULL
					ELSE CAST(CAST(sls_ship_dt AS VARCHAR) AS DATE)
				END  sls_ship_dt,
				CASE 
					WHEN sls_due_dt <=  0 OR LEN(sls_due_dt) != 8 THEN NULL
					ELSE CAST(CAST(sls_due_dt AS VARCHAR) AS DATE)
				END  sls_due_dt,
				CASE 
					WHEN sls_sales IS NULL OR sls_sales <= 0 OR sls_sales != sls_quantity * ABS(sls_price) THEN sls_quantity * ABS(sls_price)
					ELSE sls_sales
				END sls_sales,
				sls_quantity,
				CASE 
					WHEN sls_price IS NULL OR sls_price <= 0 THEN sls_sales / NULLIF(sls_quantity, 0)
					ELSE sls_price
				END sls_price	
			FROM bronze.crm_sales_details;
			SET @End_Time	= GETDATE();
			PRINT 'Loading Duration : ' + CAST(DATEDIFF(Second, @start_Time, @end_time) AS NVARCHAR)
			PRINT '-------------------------'

			PRINT '-----------------------------'
			PRINT 'ERP SOURCE';
			PRINT '-----------------------------'

			-- cust_az12
			SET @Start_Time	= GETDATE();
			TRUNCATE TABLE silver.erp_cust_az12;
			INSERT INTO silver.erp_cust_az12(
				cid,
				bdate,
				Gen)
			SELECT 
				CASE
					WHEN cid LIKE 'NAS%' THEN SUBSTRING(cid, 4, LEN(cid))
					ELSE cid
				END cid,
				CASE 
					WHEN Bdate > GETDATE() THEN NULL
					ELSE Bdate
				END bdate,
				CASE 
					WHEN UPPER(TRIM(Gen)) IN ('F', 'Female') THEN 'Female'
					WHEN UPPER(TRIM(Gen)) IN ('M', 'Male') THEN 'Male'
					ELSE 'n/a'
				END Gen
			FROM bronze.erp_cust_az12;
			SET @End_Time	= GETDATE();
			PRINT 'Loading Duration : ' + CAST(DATEDIFF(Second, @start_Time, @end_time) AS NVARCHAR)
			PRINT '-------------------------'

			-- Location
			SET @Start_Time	= GETDATE();
			TRUNCATE TABLE silver.erp_loc_a101;
			INSERT INTO silver.erp_loc_a101( cid, cntry)
			SELECT 
				REPLACE(cid, '-','') cid,
				CASE 
					WHEN TRIM(cntry) IS NULL OR TRIM(cntry) = '' THEN 'n/a'
					WHEN TRIM(cntry) IN ('US', 'USA') THEN 'United States'
					WHEN TRIM(cntry) = 'DE' THEN 'Germany'
					ELSE TRIM(cntry)
				END cntry
			FROM bronze.erp_loc_a101;
			SET @End_Time	= GETDATE();
			PRINT 'Loading Duration : ' + CAST(DATEDIFF(Second, @start_Time, @end_time) AS NVARCHAR)
			PRINT '-------------------------'

			-- Category
			SET @Start_Time	= GETDATE();
			TRUNCATE TABLE silver.erp_px_cat_g1v12;
			INSERT INTO silver.erp_px_cat_g1v12(
				id,
				cat,
				subcat,
				maintenance
				)
			SELECT 
				id,
				cat,
				subcat,
				maintenance
				FROM bronze.erp_px_cat_g1v12;
				SET @End_Time	= GETDATE();
				PRINT 'Loading Duration : ' + CAST(DATEDIFF(Second, @start_Time, @end_time) AS NVARCHAR)
				PRINT '-------------------------'
		END TRY
		BEGIN CATCH
			PRINT '=================================='
			PRINT 'Error Occured During Loading Silver'
			PRINT 'Error Message: ' + ERROR_MESSAGE();
			PRINT 'Error Message: ' + CAST(ERROR_NUMBER() AS NVARCHAR);
			PRINT '=================================='
		END CATCH
END

EXEC silver.load_silver;
