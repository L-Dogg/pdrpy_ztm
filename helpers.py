import json
import requests
from datetime import datetime
from Lines import VehicleType
from typing import Set

# Low Floor endpoint is updated every 30s
# One Line endpoint is updated ever 10s
# Available Line endpoint is updated ever 10s

API_KEY = 'b2404019-9b1d-4ff5-9969-af137b28c7da'

ONE_LINE_ENDPOINT_URL = 'https://api.um.warszawa.pl/api/action/busestrams_get/' \
                        '?resource_id=f2e5503e-927d-4ad3-9500-4ab9e55deb59&apikey={}&type={}&line={}'

AVAILABLE_LINES_ENDPOINT_URL = 'https://api.um.warszawa.pl/api/action/busestrams_get/' \
                               '?resource_id=f2e5503e-927d-4ad3-9500-4ab9e55deb59&apikey={}&type={}'

LOW_FLOOR_LINES_ENDPOINT_URL = 'https://api.um.warszawa.pl/api/action/wsstore_get/' \
                              '?id=c7238cfe-8b1f-4c38-bb4a-de386db7e776&apikey={}'

JSON_ROOT = "result"


def datetime_handler(x):
    if isinstance(x, datetime.datetime):
        return x.isoformat()
    raise TypeError("Unknown type")


def get_one_line(vehicle_type: VehicleType, line: int) -> str:
    data = {}
    response = requests.post(ONE_LINE_ENDPOINT_URL.format(API_KEY, vehicle_type.value, line)).json()[JSON_ROOT]
    data[str(datetime.now())] = response
    return json.dumps(data)


def get_active_lines(vehicle_type: VehicleType) -> Set[str]:
    active_lines = set()
    response = requests.post(AVAILABLE_LINES_ENDPOINT_URL.format(API_KEY, vehicle_type.value)).json()[JSON_ROOT]
    for vehicle in response:
        active_lines.add(vehicle["Lines"])

    return active_lines


def get_active_vehicles(vehicle_type: VehicleType) -> str:
    response = requests.post(AVAILABLE_LINES_ENDPOINT_URL.format(API_KEY, vehicle_type.value)).json()[JSON_ROOT]
    return json.dumps(response)


def low_floor_tram_data() -> str:
    data = {}
    response = requests.post(LOW_FLOOR_LINES_ENDPOINT_URL.format(API_KEY)).json()[JSON_ROOT]
    data[str(datetime.now())] = response
    return json.dumps(data)
