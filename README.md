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

```bash
1. Build a mysql transactional database in AWS RDS:
1.1 Create tables in the mysql database
1.1_create_tables_raw.sql
1.2 Load raw data into the mysql database
1.2_load_raw_data.sql
2. Build a data warehouse in Redshift Cluster:
	2.1 Create tables in the data warehouse
		2.1_create_tables_dwh.sql		
3. Create data pipeline to copy RDS mysql data to S3:
	3.1 Copy RDS mysql data to S3 for both historical and incremental data
		3.1_data_pipeline.sql
	3.2 make sure historical data only load once, and schedule incremental loading on  regular basis.
```