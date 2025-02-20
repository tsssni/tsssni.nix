import time
import subprocess

def main():
	info = subprocess.run(
		'nvidia-smi --query-gpu=utilization.gpu,clocks.gr,power.draw,temperature.gpu,memory.used,memory.total --format=csv,noheader,nounits',
		capture_output = True,
		text = True,
		shell = True,
	).stdout.strip()

	[usage, freq, power, temp, used_mem, total_mem] = info.split(', ')
	print(f'{usage}% {freq}MHz {power}W {temp}°C {used_mem}/{total_mem}MiB')


if __name__ == "__main__":
main()
