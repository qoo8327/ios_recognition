import socket
import time
import json
import threading
import sys
SIZE = 1024*1024


def re():
	classes = socket02.recv(SIZE)
	print(classes)

hostname = socket.gethostname()#本地hsotname
ip = socket.gethostbyname(hostname)#本地ip
port = 666
address = (ip, port)

socket02 = socket.socket(socket.AF_INET, socket.SOCK_STREAM)
# AF_INET:默認IPv4, SOCK_STREAM:TCP

socket02.connect(address)  # 用來請求連接遠程服務器
print(socket02.recv(SIZE))
##################################
# 開始傳輸
im = sys.argv[1]
with open(im, "rb") as f:
	for imgData in f:
		socket02.send(imgData)
socket02.shutdown(socket.SHUT_WR)
#print('transmit end')

re()
##################################

socket02.close()  # 關閉
#print('client close')