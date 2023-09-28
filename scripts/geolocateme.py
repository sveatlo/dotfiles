#!/usr/bin/env python3

import os
import typing
import jsons
import requests
import gi

gi.require_version("NM", "1.0")
from gi.repository import NM

GOOGLE_API_KEY = os.environ["GOOGLE_API_KEY"]


class Location(object):
    def __init__(self, latitude, longitude, accuracy=-1):
        self.latitude = latitude
        self.longitude = longitude
        self.accuracy = accuracy

    def __str__(self) -> str:
        return f"{self.latitude};{self.longitude};{self.accuracy}"


class WifiAP(object):
    def __init__(self, nm_ap):
        ssid = nm_ap.get_ssid()
        ssid = "" if not ssid else NM.utils_ssid_to_utf8(nm_ap.get_ssid().get_data())

        self.ssid = ssid
        self.channel = NM.utils_wifi_freq_to_channel(nm_ap.get_frequency())
        self.macAddress = nm_ap.get_bssid()
        self.signalStrength = -1 * nm_ap.get_strength()


class Geolocator(object):
    def __init(self, google_api_key: str):
        self.google_api_key = google_api_key
        pass

    def get_location(self) -> Location:
        location = self._query_geolocation()

        return location

    def _query_geolocation(self) -> Location:
        wifi_aps = self._get_wifi_aps()

        payload = {
            "considerIp": "true",
            "wifiAccessPoints": wifi_aps,
        }

        params = {"key": GOOGLE_API_KEY}

        headers = {"Content-Type": "application/json"}

        r = requests.post(
            "https://www.googleapis.com/geolocation/v1/geolocate",
            params=params,
            data=jsons.dumps(payload),
            headers=headers,
        )
        if r.status_code != 200:
            raise Exception("error querying geolocation API", r.json())

        d = r.json()
        l = d["location"]

        return Location(l["lat"], l["lng"], d["accuracy"])

    def _get_wifi_aps(self) -> typing.List[WifiAP]:
        aps = []

        nmc = NM.Client.new(None)
        devs = nmc.get_devices()

        for dev in devs:
            if dev.get_device_type() != NM.DeviceType.WIFI:
                continue

            # TODO: replace with sync scanning
            try:
                dev.request_scan_async()
            except gi.repository.GLib.Error as err:
                # Too frequent rescan error
                if not err.code == 6:  # pylint: disable=no-member
                    raise err

        for dev in devs:
            if dev.get_device_type() != NM.DeviceType.WIFI:
                continue

            for ap in dev.get_access_points():
                aps.append(WifiAP(ap))

        return aps


if __name__ == "__main__":
    g = Geolocator()
    print(g.get_location())
