from keras.models import load_model
from vis.utils import utils
import os
import numpy as np
import json
import tensorflow as tf
import time
import socket
import threading
import uuid
from sqldb import inserst



config = tf.ConfigProto()
config.gpu_options.per_process_gpu_memory_fraction = 0.2
session = tf.Session(config=config)




model = load_model("all_group_299v4.h5")
with open("all_group_299v4.json", 'r') as load_f:
	load_dict = json.load(load_f)
testimg = np.zeros((1,299,299,3)).astype('float32')/255
model.predict(testimg)
print("model is ok")

SIZE = 1024*1024
hostname = socket.gethostname()#本地hsotname
ip = socket.gethostbyname(hostname)#本地ip
port = 666

address = (ip, port)

socket01 = socket.socket(socket.AF_INET, socket.SOCK_STREAM)
# AF_INET:默認IPv4, SOCK_STREAM:TCP

socket01.bind(address)  # 讓這個socket要綁到位址(ip/port)
socket01.listen(2)  # listen(backlog)
print('Socket Startup')

def recognition(img,conn,x):
	Stime = time.time()
	img = 'upload/'+x+".jpg"
	print(img)
	img1 = utils.load_img(img, target_size=(299, 299))
	im_normal2 = img1.reshape(1, img1.shape[0], img1.shape[1], img1.shape[2]).astype('float32')/255

	probabilities = model.predict(im_normal2)
	predict = np.argmax(probabilities, axis=1)

	i = predict
	'''print("class: %s, acc: %.2f" % (list(load_dict.keys())[list(load_dict.values()).index(i)],
									 (probabilities[0][i])))'''

	data_to_client = {'class': list(load_dict.keys())[list(load_dict.values()).index(i)], 'acc': (probabilities[0][i])}
	
	conn.send(bytes(data_to_client['class'], encoding="utf8"))
	print(data_to_client['class'],data_to_client['acc'])
	#寫入資料庫
	inserst(i, img)
	Etime = time.time()
	print("spend: %f" % (Etime - Stime) + 's')
	return

# 刪除相同名稱檔案
def checkFile():
	list = os.listdir('.')
	for iterm in list:
		if iterm == 'upload/image.jpg':
			os.remove(iterm)
			#print ("remove")
		else:
			pass

def recvImage(conn,x):
	while True:
		imgData = conn.recv(SIZE)
		if not imgData:
			break
		else:
			with open('upload/'+x+'.jpg', 'ab') as f:
				f.write(imgData)
	return x
#新增線程
def saveImage(conn,x):
	checkFile()
	t = threading.Thread(target = recvImage, args = (conn,x))
	t.setDaemon(True)
	t.start()
	t.join()

def tcplink(conn, addr):
	conn.send(b"1:")
	print('begin write image file')
	x = str(uuid.uuid1())
	saveImage(conn,x)
	img = "test"
	recognition(img,conn,x)
	conn.close()


while True:
	conn, addr = socket01.accept()
	t = threading.Thread(target = tcplink, args = (conn, addr))
	t.start()
	#print('Connected by', addr)