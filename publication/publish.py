import argparse
import os
import boto3
from progressbar import ProgressBar

BUCKET_NAME = "protouch-updates"

class Progress:
    def __init__(self):
        self.__up_progress = ProgressBar()

    def set_max(self, max):
        self.__up_progress.maxval = max

    def start(self):
        self.__up_progress.start()

    def finish(self):
        self.__up_progress.finish()

    def update_progress(self, chunk):
        self.__up_progress.update(self.__up_progress.currval + chunk)

parser = argparse.ArgumentParser()
parser.add_argument("filePath", type=str, help="Path to Simulator package file", nargs=1)

progress = Progress()
filePath = parser.parse_args().filePath[0]

if not os.path.isfile(filePath):
    print("Simulator package file doesn't exist")
    exit(1)

target_dir = "production/"
fileName = os.path.basename(filePath)

s3 = boto3.resource("s3")
bucket = s3.Bucket(BUCKET_NAME)

print("Uploading Simulator package...")
progress.set_max(os.stat(filePath).st_size)
progress.start()
bucket.upload_file(filePath, target_dir + fileName, Callback=progress.update_progress,
                   ExtraArgs={"ContentDisposition": 'attachment; filename="{}"'.format(fileName)})
progress.finish()

print("Published successfully")
