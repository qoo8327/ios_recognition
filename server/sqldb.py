import MySQLdb
conn=MySQLdb.connect(host="127.0.0.1",user="root", passwd="", db="recognize_img", charset="utf8")

cursor=conn.cursor()
cursor.execute("SELECT VERSION()")
print("Database version : %s " % cursor.fetchone())

SQL="CREATE DATABASE IF NOT EXISTS recognize_img DEFAULT CHARSET=utf8 DEFAULT COLLATE=utf8_unicode_ci"
cursor.execute(SQL) 
conn.commit()

SQL="CREATE TABLE IF NOT EXISTS img(classes INT(5), img_name VARCHAR(80))"
cursor.execute(SQL)
conn.commit()
def inserst(label,name):
	SQL=("INSERT INTO img(classes, img_name) VALUES('%s', '%s')"%(int(label), name))
	cursor.execute(SQL)
	conn.commit()


'''
conn=MySQLdb.connect(host="127.0.0.1",user="root", passwd="", charset="utf8")

cursor=conn.cursor()
#cursor.execute("SELECT VERSION()")
#print("Database version : %s " % cursor.fetchone())

SQL="CREATE DATABASE IF NOT EXISTS upload_data DEFAULT CHARSET=utf8 DEFAULT COLLATE=utf8_unicode_ci"
cursor.execute(SQL) 
conn.commit()

conn=MySQLdb.connect(host="127.0.0.1",user="root", passwd="", db="upload_data", charset="utf8")

cursor=conn.cursor()
SQL="CREATE TABLE IF NOT EXISTS user_upload(dis_name VARCHAR(80), img_name VARCHAR(80), test VARCHAR(80))"
cursor.execute(SQL)
conn.commit()'''