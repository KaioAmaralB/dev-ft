import io
from oci import queue
from oci import auth

from fdk import response

def put_message (message, service_endpoint, queue_id):

    signer = auth.signers.get_resource_principals_signer()
    queue_client = queue.QueueClient(config={}, signer=signer, service_endpoint=service_endpoint)
    
    return queue_client.put_messages(
        queue_id= queue_id,
        put_messages_details=queue.models.PutMessagesDetails(
            messages=[
                queue.models.PutMessagesDetailsEntry(
                    content=message)])).data
    
def handler(ctx, data: io.BytesIO = None):

    body = data.getvalue().decode("utf-8")
    cfg = ctx.Config()
    service_endpoint = cfg["service_endpoint"]
    queue_id = cfg["queue_id"]
    resposta = put_message(body, service_endpoint, queue_id)

    return response.Response(
        ctx, response_data="{id =" + str(resposta) + "}",
        headers={"Content-Type": "application/json"}
    )