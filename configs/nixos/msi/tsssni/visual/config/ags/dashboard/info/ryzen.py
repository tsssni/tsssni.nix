import time
import psutil
import concurrent.futures

def get_usage():
	return int(psutil.cpu_percent(0.05))

def get_frequency():
	try:
		freq = psutil.cpu_freq()
		return int(freq.current)
	except Exception as e:
		print(f"Error fetching CPU frequency: {e}")
	return None

def get_power():
	prev_energy = 0
	total_watt = 0
	for i in range(6):
		if (i > 0):
			time.sleep(0.01)
		with open('/sys/class/powercap/intel-rapl/intel-rapl:0/energy_uj', 'r') as file:
			energy = int(file.readline().strip())
			if (i > 0):
				total_watt += (energy - prev_energy) * 10**-4 
			prev_energy = energy
	return total_watt / 5

def get_temperature():
	try:
		temps = psutil.sensors_temperatures()
		if 'coretemp' in temps:
			for entry in temps['coretemp']:
				if 'Package id 0' in entry.label:
					return int(entry.current)
		elif 'k10temp' in temps:
			for entry in temps['k10temp']:
				if 'Tctl' in entry.label:
					return int(entry.current)
	except Exception as e:
		print(f"Error fetching CPU temperature: {e}")
	return None

def get_memory_usage():
	try:
		mem = psutil.virtual_memory()
		used_mem = int(mem.used / (1024 ** 2))
		total_mem = int(mem.total / (1024 ** 2))
		return used_mem, total_mem
	except Exception as e:
		print(f"Error fetching memory usage: {e}")
	return None, None

def main():
	with concurrent.futures.ThreadPoolExecutor() as executor:
		usage_future = executor.submit(get_usage)
		power_future = executor.submit(get_power)

		freq = get_frequency()
		temp = get_temperature()
		used_mem, total_mem = get_memory_usage()
		usage = usage_future.result()
		power = power_future.result()

		print(f'{usage}% {freq}MHz {power:.2f}W {temp}°C {used_mem}/{total_mem}MiB')

if __name__ == "__main__":
	main()
