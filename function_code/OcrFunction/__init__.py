import azure.functions as func
import logging
import os
import requests
from azure.storage.blob import BlobServiceClient

def main(myblob: func.InputStream):

    logging.info(f"Processing blob: {myblob.name}, size: {myblob.length} bytes")

    # Récupération des variables d’environnement
    vision_endpoint = os.environ.get("VISION_ENDPOINT")
    vision_key = os.environ.get("VISION_KEY")
    storage_url = os.environ.get("STORAGE_ACCOUNT_URL")
    storage_key = os.environ.get("STORAGE_KEY")

    if not all([vision_endpoint, vision_key, storage_url, storage_key]):
        logging.error("One or more environment variables are missing!")
        return

    headers = {
        "Ocp-Apim-Subscription-Key": vision_key,
        "Content-Type": "application/octet-stream"
    }

    try:
        response = requests.post(
            f"{vision_endpoint}/vision/v3.2/ocr",
            headers=headers,
            data=myblob.read()
        )
        response.raise_for_status()
    except Exception as e:
        logging.error(f"Error calling Vision API: {e}")
        return

    result = response.json()
    extracted_text = ""

    for region in result.get("regions", []):
        for line in region.get("lines", []):
            for word in line.get("words", []):
                extracted_text += word["text"] + " "

    try:
        blob_service_client = BlobServiceClient(account_url=storage_url, credential=storage_key)
        blob_client = blob_service_client.get_blob_client(
            container="results",
            blob=f"{myblob.name}.txt"
        )
        blob_client.upload_blob(extracted_text, overwrite=True)
        logging.info("OCR processing completed and uploaded to 'results'")
    except Exception as e:
        logging.error(f"Error uploading result blob: {e}")