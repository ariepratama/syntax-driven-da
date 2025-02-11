import io
import os
from pathlib import Path

import torch
from google.cloud import storage

storage_client = None


def save_to_local(state_dict, output_dir: str, file_name: str):
    torch.save(state_dict, os.path.join(output_dir, file_name))


def load_from_local(output_dir: str, file_name: str):
    return torch.load(os.path.join(output_dir, file_name))


def save_to_gcs(state_dict, output_dir: str, file_name: str):
    global storage_client

    if not storage_client:
        storage_client = storage.Client()

    output_bucket = storage_client.get_bucket("pandl_1")
    dir = output_dir.split("/")[-1]

    local_dir = f"/tmp/{dir}"
    Path(local_dir).mkdir(parents=True, exist_ok=True)

    src_file_path = os.path.join(local_dir, file_name)
    torch.save(state_dict, src_file_path)

    blob = output_bucket.blob(f"out/{dir}/{file_name}")
    blob.upload_from_filename(src_file_path)


def load_from_gcs(output_dir: str, file_name: str):
    global storage_client

    if not storage_client:
        storage_client = storage.Client()
    output_bucket = storage_client.get_bucket("pandl_1")
    dir = output_dir.split("/")[-1]
    model_blob = output_bucket.get_blob(f"out/{dir}/{file_name}")
    model_blob = model_blob.download_as_string()
    model_buffer = io.BytesIO(model_blob)
    return torch.load(model_buffer)


def save_log_to_gcs(log_path: str):
    global storage_client

    if not storage_client:
        storage_client = storage.Client()

    output_bucket = storage_client.get_bucket("pandl_1")
    file_path_splits = log_path.split("/")
    file_name = file_path_splits[-1]
    dir = file_path_splits[-2]

    blob = output_bucket.blob(f"logs/{dir}/{file_name}")
    blob.upload_from_filename(log_path)
