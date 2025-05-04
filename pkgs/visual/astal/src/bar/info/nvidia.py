import argparse
import subprocess
import sys
import csv
from io import StringIO

def device():
    try:
        result = subprocess.run(
            'nvidia-smi --query-gpu=index --format=csv',
            capture_output=True,
            text=True,
            shell=True,
        )
    except subprocess.CalledProcessError as e:
        print('')

    reader = csv.DictReader(StringIO(result.stdout), skipinitialspace=True)
    rows = list(reader)
    indexes = [row['index'] for row in rows]
    print(','.join(indexes))


def monitor(index):
    result = subprocess.run(
        'nvidia-smi --query-gpu=index,utilization.gpu,clocks.gr,power.draw,temperature.gpu,memory.used,memory.total --format=csv,nounits',
        capture_output=True,
        text=True,
        shell=True,
        check=True
    )
    
    reader = csv.DictReader(StringIO(result.stdout), skipinitialspace=True)
    rows = list(reader)
    
    for row in rows:
        if row['index'] == index:
            usage = row['utilization.gpu [%]']
            freq = row['clocks.current.graphics [MHz]']
            power = row['power.draw [W]']
            temp = row['temperature.gpu']
            used_mem = row['memory.used [MiB]']
            total_mem = row['memory.total [MiB]']
            print(f'{usage}% {freq}MHz {power}W {temp}°C {used_mem}/{total_mem}MiB')
            break

parser = argparse.ArgumentParser(description='NVIDIA GPU info')
parser.add_argument('-d', '--device', action='store_true', help='fetch all NVIDIA GPUs')
parser.add_argument('-m', '--monitor', type=str, metavar='GPU_INDEX', help='NVIDIA GPU device to be monitored')

args = parser.parse_args()
if args.device is True:
    device()
elif args.monitor:
    monitor(args.monitor)
