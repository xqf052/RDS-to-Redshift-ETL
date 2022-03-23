# ETL for syncing data from AWS RDS to Redshift
### Project Description

```bash
# 1. Install or update python to version 3.8
# 2. cd to the directory where requirements.txt is located
# 3. Optional: activate your virtualenv
# 4. Run the following command to install required python packages
pip3 inst
```

### Process Design

```
1. Build a mysql transactional database using AWS RDS:
    - Create tables for the transactional database:
        1.1_create_tables_mysql.sql
    - Load data into the transactional database:
        1.2_load_raw_data.sql
2. Build a data warehouse in Redshift Cluster:
	2.1 Create tables in the data warehouse
		2.1_create_tables_dwh.sql		
3. Create data pipeline to copy RDS mysql data to S3:
	3.1 Copy RDS mysql data to S3 for both historical and incremental data
		3.1_data_pipeline.sql
	3.2 make sure historical data only load once, and schedule incremental loading on  regular basis.
4. Sync historical data in S3 with redshift Data warehouse
	4.1 Populate delta tables(olist_delta, customers_delta, date_delta, orders_delta)
		4.1_populate_delta.sql
	4.2 Populate dimension and fact tables (date_dim, orders_dim, customers_dim, orders_status_fact)
		4.2_populate_dim_fact.sql

5. Sync incremental data in S3 with redshift Data warehouse
	5.1 Use glue job with python shell script to sync incremental data from S3.
		5.1_load_incremental_data.py
	5.2 Use lambda function to trigger the glue job to run on a regular basis.
	5.2_trigger_gluejob.py
```