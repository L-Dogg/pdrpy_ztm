import time
import helpers
from Lines import VehicleType
import datetime
import signal
import sys

TIMEOUT = 10.0  # Sixty seconds


def saveJsonToFile(tramfile, busfile):
    starttime = time.time()
    tramfile.write("{\n\"results\": [")
    busfile.write("{\n\"results\": [")

    while True:
        try:
            result = helpers.get_active_vehicles(VehicleType.Bus).strip().strip('[').strip(']')
            busfile.write("{},\n".format(result))

            result = helpers.get_active_vehicles(VehicleType.Tram).strip().strip('[').strip(']')
            tramfile.write("{},\n".format(result))

            print("Saved another chunk to file")
            time.sleep(TIMEOUT - ((time.time() - starttime) % TIMEOUT))
        except KeyboardInterrupt:
            # TODO: there's one extra comma at the end of file
            tramfile.write("\n ]}")
            busfile.write("\n ]}")


if __name__ == "__main__":
    print("Starting bot.")
    today_string = datetime.datetime.now().strftime('%x')
    with open("trams.json", "w") as tram_output, open("buses.json", "w") as bus_output:
        saveJsonToFile(tram_output, bus_output)
