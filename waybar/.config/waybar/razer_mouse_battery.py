from openrazer.client import DeviceManager
from openrazer.client.devices import RazerDevice
from json import dumps
from time import sleep
from sys import stdout

def mouse_info() -> dict:
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


def main():
    while True:
        info = mouse_info()
        print(dumps(info))
        stdout.flush()
        sleep(10)

if __name__ == "__main__":
    main()
