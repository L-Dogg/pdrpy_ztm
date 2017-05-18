import time
import helpers
from Lines import VehicleType
import datetime
import os

#There's a problem with that script, so we have to remove last comma manually and add ]} at the end

TIMEOUT = 10.0  # Sixty seconds

MEGABYTE = 1024 * 1024
MAX_FILE_SIZE = 2 * 4096 * MEGABYTE #8GB

bus_file_name = "buses3.json"
tram_file_name = "trams3.json"

def saveJsonToFile(tramfile, busfile):
    starttime = time.time()
    tramfile.write("{\n\"results\": [")
    busfile.write("{\n\"results\": [")

    bus_file_size = 0
    tram_file_size = 0

    while bus_file_size < MAX_FILE_SIZE and tram_file_size < MAX_FILE_SIZE:
        try:
            result = helpers.get_active_vehicles(VehicleType.Bus).strip().strip('[').strip(']')
            busfile.write("{},\n".format(result))

            result = helpers.get_active_vehicles(VehicleType.Tram).strip().strip('[').strip(']')
            tramfile.write("{},\n".format(result))

            print("Saved another chunk to file")
            time.sleep(TIMEOUT - ((time.time() - starttime) % TIMEOUT))

            bus_file_size = os.stat(bus_file_name).st_size
            tram_file_size = os.stat(tram_file_name).st_size
        except KeyboardInterrupt:
            # TODO: there's one extra comma at the end of file
            tramfile.write("\n ]}")
            busfile.write("\n ]}")
            return


if __name__ == "__main__":
    print("Starting bot.")
    today_string = datetime.datetime.now().strftime('%x')
    with open(tram_file_name, "w") as tram_output, open(bus_file_name, "w") as bus_output:
        saveJsonToFile(tram_output, bus_output)
