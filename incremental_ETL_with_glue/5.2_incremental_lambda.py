import json
import boto3 

def lambda_handler(event, context):
    client = boto3.client("glue")

    client.start_job_run(
        JobName = 'incremental_ETL',
        Arguments = {}
    )
    return {
        'statusCode': 200,
        'body': json.dumps('incremental_ETL triggered')
    }
