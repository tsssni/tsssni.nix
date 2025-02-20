import time
import subprocess

def main():
	info = subprocess.run(
		'rocm-smi --showuse --showclocks --showpower --showtemp --showmeminfo vram --csv',
		capture_output = True,
		text = True,
		shell = True,
	).stdout.splitlines()[1]

	[_,temp,_,_,freq,_,_,_,power,usage,total_mem,used_mem] = info.split(',')
	freq=freq[1:-4]
	power=float(power)
	temp=int(float(temp))
	used_mem=int(int(used_mem)/10**6)
	total_mem=int(int(total_mem)/10**6)
	print(f'{usage}% {freq}MHz {power:.2f}W {temp}°C {used_mem}/{total_mem}MiB')
	

if __name__ == "__main__":
	main()
