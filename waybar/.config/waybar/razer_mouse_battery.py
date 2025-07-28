import logging
from openrazer.client import DeviceManager
from openrazer.client import DaemonNotFound
from openrazer.client.devices import RazerDevice
from json import dumps
from time import sleep
from sys import stdout

logger = logging.getLogger("MouseBattery")
handler = logging.StreamHandler()
formatter = logging.Formatter("{asctime} - {name} - {levelname} - {message}", style='{', datefmt="%Y-%m-%d %H:%M:%S")
handler.setFormatter(formatter)
logger.addHandler(handler)

def mouse_info() -> dict:
    try:
        device_manager = DeviceManager()
        devices = list(filter(lambda d: d.type == 'mouse', device_manager.devices))

        if not devices:
            return {"percentage": 0}

        device: RazerDevice = devices[0]
        battery = device.battery_level

        res = {"percentage": battery}

        if device.is_charging:
            res["class"] = "charging"
            res["alt"] = "charging"
        elif battery < 15:
            res["class"] = "low"

        return res
    except DaemonNotFound:
        logger.error("OpenRazer Daemon not found.")
        return {"percentage": 0}


def main():
    while True:
        info = mouse_info()
        print(dumps(info))
        stdout.flush()
        sleep(10)

if __name__ == "__main__":
    main()
