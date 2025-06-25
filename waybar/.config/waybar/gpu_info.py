import subprocess
import json

def gpu_busy_percent() -> str:
    """
    Executes 'cat /sys/class/hwmon/hwmon3/device/gpu_busy_percent'
    and returns its plain text output.
    """
    result = subprocess.run(
        ["cat", "/sys/class/hwmon/hwmon3/device/gpu_busy_percent"],
        capture_output=True,
        text=True,
        check=True  # Raise an exception if the command returns a non-zero exit code
    )
    return result.stdout.strip()

def amdgpu_top_activity() -> dict:
    """
    Executes 'amdgpu_top -d -J' and returns its JSON output as a Python dictionary.
    """
    result = subprocess.run(
        ["amdgpu_top", "-d", "-J"],
        capture_output=True,
        text=True,
        check=True  # Raise an exception if the command returns a non-zero exit code
    )
    return json.loads(result.stdout)[0]["gpu_activity"]

def main():
    """
    Main function to get and print GPU information.
    """
    gpu_busy = gpu_busy_percent()
    gpu_activity = amdgpu_top_activity()

    activities = []
    for k, v in gpu_activity.items():
        activities.append(f"{k}: {v["value"]}{v["unit"]}")

    result = {"text": gpu_busy, "tooltip": ", ".join(activities)}
    print(json.dumps(result))

if __name__ == "__main__":
    main()

