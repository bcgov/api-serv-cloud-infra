from services.secretsmanager import SecretsManagerService
import os
import logging
import json
import traceback

# using root logger
logging.basicConfig(level=os.getenv('LOG_LEVEL', default=logging.DEBUG),
                    format='%(asctime)s-%(levelname)s-%(message)s', datefmt='%d-%b-%y %H:%M:%S')

logger = logging.getLogger(__name__)

def write_to_file(content, file_dir, file_name):
    try:
        if not os.path.exists(file_dir):
            os.makedirs(file_dir)

        with open("%s/%s" % (file_dir, file_name), "w+") as f:
            f.write(content)
    except Exception as ex:
        traceback.print_exc()
        logger.error("Failed to write secrets. %s" % ex)

def main():

    try:
        list_of_secrets_json = os.getenv('AWS_SECRETS', """{}""")
        logger.debug("list_of_secrets_json - %s" % list_of_secrets_json)
        path = os.getenv("FILE_PATH", "/tmp")
        logger.debug("path - %s" % path)
        secrets_dict = json.loads(list_of_secrets_json)
        logger.debug("secrets_dict - %s" % str(secrets_dict))
        sm_svc = SecretsManagerService()

        if not secrets_dict == None and not bool(secrets_dict) == False:
            for key, val in secrets_dict.items():
                write_to_file(sm_svc.get_secret(key), path, val)

    except Exception as ex:
        traceback.print_exc()
        logger.error("Failed to mount secrets. %s" % ex)


if __name__ == "__main__":
    main()