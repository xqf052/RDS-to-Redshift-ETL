# ETL for syncing data from AWS RDS to Redshift
### Project Description

```bash
The project is to create an ETL process to sync the data from a Mysql transactional database into
a Redshift data warehouse. The data comes from an Brazilian E-commerce company called Olist.
The Aws components involved in this project are RDS, Redshift, Glue, Lambda, Data Pipeline, Quicksight,
etc. I use Star schema for dimensional modeling of the data warehouse. I use Dbeaver to connect both
the RDS instance and the Redshift cluster.

The first step of the mechanism is to use Data Pipeline to establish connection with RDS Mysql database 
and pull the transactional data as csv file formats, which will be saved in S3. Then I implement both 
initial ETL and incremental ETL to load the data from S3 into Redshift data warehouse. For the historical
data, I write SQL queries to load them directly into the data warehouse. For the incremental data, I use 
lambda function, event trigger and glue job with python shell script to automatically perfrom ETL and
load data on a regular basis.
```

### Data Warehouse Schema

![star schema drawio](https://user-images.githubusercontent.com/31687491/159823998-dae194f1-ed3f-425f-bace-d1a6b4838cd8.png)

### Process Design

```bash
1. Build a mysql transactional database using AWS RDS:
    - Create tables for the transactional database:
        1.1_create_tables_mysql.sql
    - Load data into the transactional database:
        1.2_load_raw_data.sql
2. Build a data warehouse using AWS Redshift:
	- Create schemas and tables in the data warehouse
		2.1_create_tables_dwh.sql		
3. Use AWS data pipeline to copy data from the transactional database into S3:
	- Copy both historical and incremental data into S3
		3.1_data_pipeline.sql
	- For the incremental ETL, we can use data pipeline to schedule the process on a regular basis, 
      such as once per month.
4. Sync historical data in S3 with the Redshift data warehouse
	- Populate delta tables in the data warehouse
		4.1_populate_delta.sql
	- Populate dimension and fact tables in the data warehouse
		4.2_populate_dim_fact.sql
5. Sync incremental data in S3 with the Redshift Data warehouse
	- Use AWS Glue Job with python shell script to sync incremental data.
		5.1_load_incremental_data.py
	- Use a lambda function with an S3 event trigger to automatically run the glue job, so that the 
      incremental ETL can be triggered on a regular basis.
	    5.2_trigger_gluejob.py
6. Connect the data warehouse with AWS Quicksight for data analytics and BI reporting.
```

### Project Architecture

![redshift_dwh drawio](https://user-images.githubusercontent.com/31687491/159819100-798d12ae-b4a5-4730-8713-40ee6762d89e.png)