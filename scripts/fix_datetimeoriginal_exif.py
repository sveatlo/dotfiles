#!/usr/bin/env python

import os
import re
import piexif
from PIL import Image

## standard format
standard_date_regex = re.compile("(?P<year>\d{4})\/(?P<month>\d{2})\/(?P<day>\d{2})")

## multi-day format
multi_day_date_regex = re.compile(
    "(?P<year>\d{4})\/(?P<month>\d{2})\/[a-zA-Z0-9 -]+\/(?P<day>\d{2})"
)

## sometime
sometime_date_regex = re.compile(
    "(?P<year>\d{4})\/(?P<month>\d{2})\/(sometime|mix|niekedy|MIX)"
)

camera_folder = "/home/sveatlo/Pictures/camera"

idx_dict = {}

for root, dirs, files in os.walk(camera_folder):
    for file in files:
        file_path = os.path.join(root, file)

        # filter out digital
        if "DSC" in file:
            continue
        # filter out non-exported files
        if "darktable_exported" not in file_path:
            continue
        # filter out specific dirs
        if "2018/08/18" in file_path or "2016/01-05" in file_path:
            continue

        # extract year,month,day by trying standard, multi-day and sometime regexes in order and choosing the first that matches
        standard_match = standard_date_regex.search(file_path)
        multi_day_match = multi_day_date_regex.search(file_path)
        sometime_match = sometime_date_regex.search(file_path)
        if multi_day_match is not None:
            date_data = multi_day_match.groupdict()
            year = date_data["year"]
            month = date_data["month"]
            day = date_data["day"]
        elif standard_match is not None:
            date_data = standard_match.groupdict()
            year = date_data["year"]
            month = date_data["month"]
            day = date_data["day"]
        elif sometime_match is not None:
            date_data = sometime_match.groupdict()
            year = date_data["year"]
            month = date_data["month"]
            day = "01"
        else:
            print(f"Failed to extract date from {file_path}")
            continue

        if root not in idx_dict:
            idx_dict[root] = 0
        idx_dict[root] += 1

        try:
            image = Image.open(file_path)

            exif_data = image.getexif()

            minute = idx_dict[root] // 60
            second = idx_dict[root] % 60

            new_datetime = f"{year}:{month}:{day} 08:{minute:02d}:{second:02d}"
            exif_data[piexif.ExifIFD().DateTimeOriginal] = new_datetime

            image.save(file_path, exif=exif_data.tobytes())
            print(f"Updated EXIF data for {file_path}")
        except Exception as e:
            print(f"Failed to update EXIF data for {file_path}: {str(e)}")
