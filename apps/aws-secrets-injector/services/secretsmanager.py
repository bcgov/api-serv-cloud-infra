import base64
import boto3
import threading
import logging
import json
import time
import os
from botocore.exceptions import ClientError

logger = logging.getLogger(__name__)

class SecretsManagerService:

    region_name = os.getenv("AWS_REGION", default="ca-central-1")
    
    def __init__(self):
        self.sess = boto3.session.Session()
        self.client = self.sess.client(service_name="secretsmanager", region_name=self.region_name)

    def get_secret(self, secret_id):
        try:
            logger.debug("fetching - %s" % secret_id)
            get_secret_value_response = self.client.get_secret_value(SecretId=secret_id)
            logger.debug("get_secret_value_response - %s" % str(get_secret_value_response["CreatedDate"]))
        except ClientError as e:
            if e.response['Error']['Code'] == 'ResourceNotFoundException':
                print("The requested secret " + secret_id + " was not found")
            elif e.response['Error']['Code'] == 'InvalidRequestException':
                print("The request was invalid due to:", e)
            elif e.response['Error']['Code'] == 'InvalidParameterException':
                print("The request had invalid params:", e)
            elif e.response['Error']['Code'] == 'DecryptionFailure':
                print("The requested secret can't be decrypted using the provided KMS key:", e)
            elif e.response['Error']['Code'] == 'InternalServiceError':
                print("An error occurred on service side:", e)
        else:
            # Secrets Manager decrypts the secret value using the associated KMS CMK
            # Depending on whether the secret was a string or binary, only one of these fields will be populated
            if 'SecretString' in get_secret_value_response:
                return get_secret_value_response['SecretString']
            else:
                return base64.b64decode(get_secret_value_response['SecretBinary'])
