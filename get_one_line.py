import json
import requests
from datetime import datetime
from Helpers import VehicleType

def datetime_handler(x):
    if isinstance(x, datetime.datetime):
        return x.isoformat()
    raise TypeError("Unknown type")

APIKEY = 'b2404019-9b1d-4ff5-9969-af137b28c7da'
ENDPOINT_URL = 'https://api.um.warszawa.pl/api/action/busestrams_get/?resource_id=f2e5503e-927d-4ad3-9500-4ab9e55deb59&' \
               'apikey={}&type={}&line={}'

def get_one_line(vehicleType, line):
    data = {}
    response = requests.post(ENDPOINT_URL.format(APIKEY, vehicleType.value, line)).json()["result"]
    data[str(datetime.now())] = response

    with open("{} - {} - {}.json".format(vehicleType, line, datetime.now().date()), "w") as output:
        output.write(json.dumps(data))

get_one_line(VehicleType.Bus, "208")
