import argparse
import subprocess
import csv
from io import StringIO

def device():
    try:
        result = subprocess.run(
            'rocm-smi -i --csv',
            capture_output=True,
            text=True,
            shell=True,
        )
    except subprocess.CalledProcessError as e:
        print('')

    reader = csv.DictReader(StringIO(result.stdout))
    rows = list(reader)
    indexes = [row['Device ID'] for row in rows]
    print(','.join(indexes))

def monitor(index):
    result = subprocess.run(
        'rocm-smi -i --showuse --showclocks --showpower --showtemp --showmeminfo vram --csv',
        capture_output=True,
        text=True,
        shell=True,
    )
    
    reader = csv.DictReader(StringIO(result.stdout))
    rows = list(reader)
    
    for row in rows:
        if row['Device ID'] == index:
            temp = row['Temperature (Sensor edge) (C)']
            freq = row['sclk clock level:']
            power = row['Current Socket Graphics Package Power (W)']
            usage = row['GPU use (%)']
            used_mem = row['VRAM Total Used Memory (B)']
            total_mem = row['VRAM Total Memory (B)']
            
            freq = freq[1:-4]
            power = float(power)
            temp = int(float(temp))
            used_mem = int(int(used_mem) / 10**6)
            total_mem = int(int(total_mem) / 10**6)
            
            print(f'{usage}% {freq}MHz {power:.2f}W {temp}°C {used_mem}/{total_mem}MiB')
            break

parser = argparse.ArgumentParser(description='AMD GPU info')
parser.add_argument('-d', '--device', action='store_true', help='fetch all AMD GPUs')
parser.add_argument('-m', '--monitor', type=str, help='AMD GPU device to be monitored')

args = parser.parse_args()
if args.device is True:
    device()
elif args.monitor:
    monitor(args.monitor)
