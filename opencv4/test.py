import datetime
import json
import os
import time

import cv2
import pkg_resources
from os import listdir
from ntpath import isfile


def __compress_to_mp4(video_file: str, image_urls: list):
    writer = cv2.VideoWriter_fourcc(*'mp4v')  # Be sure to use lower case
    frame = cv2.imread(image_urls[0])
    image_height = frame.shape[0]
    image_width = frame.shape[1]
    out = cv2.VideoWriter(video_file, writer, 1.0, (image_width, image_height))
    for image_url in image_urls:
        frame = cv2.imread(image_url)
        out.write(frame)
    out.release()


def __extract_images(output_folder: str, video_file: str):
    current_frame = 0
    extract_flow = cv2.VideoCapture(video_file)
    while True:

        # reading from frame
        ret, frame = extract_flow.read()

        if ret:
            # if video is still left continue creating images
            name = os.path.join(output_folder, f'frame{current_frame}.jpg')

            # writing the extracted images
            cv2.imwrite(name, frame)

            # increasing counter so that it will
            # show how many frames are created
            current_frame += 1
        else:
            break
    # Release all space and windows once done
    extract_flow.release()


if __name__ == "__main__":
    video_file = os.path.join('output', 'video.mp4')
    __compress_to_mp4(video_file, [os.path.join('input', f) for f in listdir('input') if isfile(os.path.join('input', f))])
    __extract_images('output', video_file)
