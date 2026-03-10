import socket
import sys

ID_DEST = "192.168.55.22"

# create UDP socket
udp_socket = socket.socket(socket.AF_INET, socket.SOCK_DGRAM)

raw_data = sys.argv[1]
data_list = []
for i in range(0,len(raw_data),2):
  data_list += [int(raw_data[i:i+2],16)]
data = bytearray(data_list)

try:
  # Send frame to a specific IP address and port
  udp_socket.sendto(data, (ID_DEST, 2137))
  print("Sended data:",data)
except Exception as e:
  print(f"Error sending data: {e}")
finally:
  udp_socket.close()
