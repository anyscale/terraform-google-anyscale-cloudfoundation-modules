import socket
import time


def hit_ports(host, ports):
    while True:
        for port in ports:
            try:
                with socket.socket(socket.AF_INET, socket.SOCK_STREAM) as sock:
                    sock.settimeout(2)  # Timeout after 2 seconds
                    sock.connect((host, port))
                    print(f"Successfully connected to {host}:{port}")
            except Exception as e:
                print(f"Failed to connect to {host}:{port} - {e}")
        time.sleep(1)  # Pause before the next round


if __name__ == "__main__":
    host = input("Enter the URL or IP address: ")
    ports = [10001, 6379, 8265]
    hit_ports(host, ports)
