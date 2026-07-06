/*
Should have added more descriptive print statements with time tracking. Ideally, track every single import. The more you track the better. 
Once the procedure is ran, it gets saved, and then you can execute as a single query command.
*/

CREATE OR ALTER PROCEDURE bronze.load_bronze AS
BEGIN
	DECLARE @start_time DATETIME, @end_time DATETIME;
	BEGIN TRY
		PRINT '------------'
		PRINT 'LOADING THE BRONZE LAYER'
		PRINT '------------'

		PRINT 'LOADING CRM TABLES'

		-- Start time for CRM tables.
		SET @start_time = GETDATE();

		TRUNCATE TABLE bronze.crm_cust_info;
		BULK INSERT bronze.crm_cust_info
		FROM 'C:\Users\masab\Courses\Udemy - Building a Modern Data Warehouse - Data Engineering Bootcamp 2025-3\01. Introduction\2. sql-data-warehouse-project\sql-data-warehouse-project\datasets\source_crm\cust_info.csv'
		WITH (
			FIRSTROW = 2,
			FIELDTERMINATOR = ',',
			TABLOCK
		);

		TRUNCATE TABLE bronze.crm_prd_info;
		BULK INSERT bronze.crm_prd_info
		FROM 'C:\Users\masab\Courses\Udemy - Building a Modern Data Warehouse - Data Engineering Bootcamp 2025-3\01. Introduction\2. sql-data-warehouse-project\sql-data-warehouse-project\datasets\source_crm\prd_info.csv'
		WITH (
			FIRSTROW = 2,
			FIELDTERMINATOR = ',',
			TABLOCK
		);

		TRUNCATE TABLE bronze.crm_sales_details;
		BULK INSERT bronze.crm_sales_details
		FROM 'C:\Users\masab\Courses\Udemy - Building a Modern Data Warehouse - Data Engineering Bootcamp 2025-3\01. Introduction\2. sql-data-warehouse-project\sql-data-warehouse-project\datasets\source_crm\sales_details.csv'
		WITH (
			FIRSTROW = 2,
			FIELDTERMINATOR = ',',
			TABLOCK
		);

		-- Setting end time of CRM Tables
		SET @end_time = GETDATE();

		PRINT 'Time taken to load CRM tables: ' + CAST (DATEDIFF(second, @end_time, @start_time) AS NVARCHAR) + ' seconds.'

		SET @start_time = GETDATE();
		PRINT 'LOAD ERP TABLES'
		TRUNCATE TABLE bronze.erp_cust_az12;
		BULK INSERT bronze.erp_cust_az12
		FROM 'C:\Users\masab\Courses\Udemy - Building a Modern Data Warehouse - Data Engineering Bootcamp 2025-3\01. Introduction\2. sql-data-warehouse-project\sql-data-warehouse-project\datasets\source_erp\CUST_AZ12.csv'
		WITH (
			FIRSTROW = 2,
			FIELDTERMINATOR = ',',
			TABLOCK
		);

		TRUNCATE TABLE bronze.erp_loc_a101;
		BULK INSERT bronze.erp_loc_a101
		FROM 'C:\Users\masab\Courses\Udemy - Building a Modern Data Warehouse - Data Engineering Bootcamp 2025-3\01. Introduction\2. sql-data-warehouse-project\sql-data-warehouse-project\datasets\source_erp\LOC_A101.csv'
		WITH (
			FIRSTROW = 2,
			FIELDTERMINATOR = ',',
			TABLOCK
		);

		TRUNCATE TABLE bronze.erp_px_cat_g1v2;
		BULK INSERT bronze.erp_px_cat_g1v2
		FROM 'C:\Users\masab\Courses\Udemy - Building a Modern Data Warehouse - Data Engineering Bootcamp 2025-3\01. Introduction\2. sql-data-warehouse-project\sql-data-warehouse-project\datasets\source_erp\PX_CAT_G1V2.csv'
		WITH (
			FIRSTROW = 2,
			FIELDTERMINATOR = ',',
			TABLOCK
		);

	SET @end_time = GETDATE();

	PRINT 'ERP tables loaded in ' + CAST(DATEDIFF(second, @end_time, @start_time) AS NVARCHAR) + ' seconds' 
	END TRY
	BEGIN CATCH
		PRINT '-------------------------'
		PRINT 'Error occured in Bronze layer'
		PRINT 'Error Message: ' + ERROR_MESSAGE();
		PRINT 'Error Number: ' + CAST (ERROR_NUMBER() AS NVARCHAR);
		PRINT 'Error State: ' + CAST (ERROR_STATE() AS NVARCHAR);
		PRINT '-------------------------'
	END CATCH
END
