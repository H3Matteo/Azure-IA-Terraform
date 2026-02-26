import logging
import azure.functions as func
from azure.identity import DefaultAzureCredential
from azure.ai.vision.imageanalysis import ImageAnalysisClient
from azure.storage.blob import BlobServiceClient
import os
import json

def main(myblob: func.InputStream):

    logging.info(f"Blob trigger processed: {myblob.name}")

    credential = DefaultAzureCredential()

    vision_endpoint = os.environ["VISION_ENDPOINT"]
    storage_url = os.environ["STORAGE_ACCOUNT_URL"]

    vision_client = ImageAnalysisClient(
        endpoint=vision_endpoint,
        credential=credential
    )

    image_data = myblob.read()

    result = vision_client.analyze(
        image_data=image_data,
        visual_features=["Read"]
    )

    extracted_text = ""

    if result.read:
        for block in result.read.blocks:
            for line in block.lines:
                extracted_text += line.text + "\n"

    blob_service_client = BlobServiceClient(
        account_url=storage_url,
        credential=credential
    )

    output_blob = blob_service_client.get_blob_client(
        container="results",
        blob=myblob.name + ".json"
    )

    output_blob.upload_blob(
        json.dumps({"text": extracted_text}),
        overwrite=True
    )

    logging.info("OCR result saved successfully.")