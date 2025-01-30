from tabnanny import check
import oci
import json
import base64
import os
from pymongo import MongoClient
from urllib.parse import quote_plus
import logging
import sys

logging.basicConfig(
    level=logging.INFO,
    format="%(asctime)s - %(levelname)s - %(message)s",
    handlers=[logging.StreamHandler(sys.stdout)]
)

service_endpoint = os.environ['SERVICE_ENDPOINT']
queue_id = os.environ['QUEUE_ID']
secret_id = os.environ['SECRET_ID']
autonomous = os.environ['AUTONOMOUS']
user = os.environ['USER']

try:
    if 'OCI_RESOURCE_PRINCIPAL_VERSION' in os.environ:
        signer = oci.auth.signers.get_resource_principals_signer()
    else:
        signer = oci.auth.signers.InstancePrincipalsSecurityTokenSigner()

    queue_client = oci.queue.QueueClient(config={}, signer=signer, service_endpoint=service_endpoint)
except Exception as ex:
    logging.error(ex)

def get_text_secret(secret_ocid):
    try:
        client = oci.secrets.SecretsClient(config={}, signer=signer)
        secret_content = client.get_secret_bundle(secret_ocid).data.secret_bundle_content.content.encode('utf-8')
        decrypted_secret_content = base64.b64decode(secret_content).decode("utf-8")
    except Exception as ex:
        logging.error("ERROR: failed to retrieve the secret content", ex, flush=True)
        raise
    return decrypted_secret_content

def mongo_client(user, password, db):
    mongoString = f"mongodb://{user}:{password}@{db}-JSON.adb.sa-santiago-1.oraclecloudapps.com:27017/{user}?authMechanism=PLAIN&authSource=$external&ssl=true&retryWrites=false&loadBalanced=true"
    client = MongoClient(mongoString, maxPoolSize=50)
    return client

def mongo_connection(client, db_name):
    return client[db_name]

def ensure_collection_exists(db, collection_name):
    """Check if a MongoDB collection exists and create it if it doesn't."""

    if collection_name in db.list_collection_names():
        logging.info(f"Collection '{collection_name}' already exists.")
    else:
        db.create_collection(collection_name)
        logging.info(f"Collection '{collection_name}' has been created.")

def get_message(queue_id):
    
    get_messages_response = queue_client.get_messages(
        queue_id=queue_id,
        visibility_in_seconds=10,
        timeout_in_seconds=10,
        limit=10)
    return get_messages_response.data.messages

def delete_message(queue_id, messages):
    
    delete_message_response = queue_client.delete_message(
    queue_id=queue_id,
    message_receipt=messages.receipt)
    return delete_message_response.headers

def insert_data(db ,data):
    db.devopsft.insert_one(json.loads(data))
    logging.info("Dados Inseridos")

def check_message_is_json(messages):
    try:
        json.loads(messages.content)
        return True
    except json.JSONDecodeError as ex:
        logging.error(f"Menssagem não é Json: {ex}")
        return False
   
def process_data(mydb, messages, queue_id):
    insert_data(mydb, messages.content)
    delete_message(queue_id, messages)
   
if __name__ == "__main__":

    passwd = get_text_secret(secret_id)
    encoded_username = quote_plus(user)
    encoded_password = quote_plus(passwd)
    client = mongo_client(encoded_username, encoded_password, autonomous)
    db = mongo_connection (client, user)
    ensure_collection_exists(db, 'devopsft')
    while True:
        messages = get_message(queue_id)
        if len(messages) > 0:
            for msg in messages:
                if check_message_is_json(msg):
                    process_data(db, msg, queue_id)