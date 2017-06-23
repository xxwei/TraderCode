#coding=utf-8
from pymongo import MongoClient
import tushare as ts
import json
import datetime
from sklearn.svm import SVR
import matplotlib.pyplot as plt


client = MongoClient('172.16.12.3', 27017)
db_name = 'Stock'
db = client[db_name]
collection_sh = db['SH']


print(ts.__version__)
#print(ts.get_stock_basics())
#print(ts.get_latest_news(top=5,show_content=True).title[0])
#print(ts.get_notices())
#print(ts.guba_sina())

#df = ts.shibor_quote_data() #取当前年份的数据
#df = ts.shibor_data(2014) #取2014年的数据
#print(ts.get_money_supply())

#print(ts.get_loan_rate())

#print(ts.get_today_all())

sh000001 = ts.get_k_data("000001",index=True)

print(sh000001.head().as_matrix())
print(sh000001[:20])
print (sh000001.index.size)
soho = sh000001.iloc[:4,1:6]
print(soho)
print(soho.as_matrix())

df = ts.shibor_data() #取当前年份的数据
#df = ts.shibor_data(2014) #取2014年的数据
#df.sort('date', ascending=False).head(10)
print(df[:10])
#df = ts.profit_data(top='all')
#df.sort('shares',ascending=False)
#print(df[:10])
#all = ts.get_today_all();
#print(all[:20])
#print(sh000001.index.size)
#print(sh000001.columns.size)
df = ts.get_tick_data('600848',date='2014-12-22',src='sn')
print(df.head())
#collection_sh.insert(json.loads(df.to_json(orient='records')))
'''
date = sh000001["date"]
openv = sh000001["open"]
closev = sh000001["close"]
high=sh000001["high"]

train_size = sh000001.index.size-100

date_train_data = date[:train_size]
date_test_data = date[train_size:sh000001.index.size]
#print(date_train_data)
openv_train_data =openv[:train_size]
openv_test_data =openv[train_size:sh000001.index.size]

closev_train_data =closev[:train_size]
closev_test_data =closev[train_size:sh000001.index.size]
#print(openv_train_data)


#print(x_test.as_matrix())
#print(sh000001.as_matrix())

#for itemtype in sh000001:
#    print(itemtype)
#    for item in sh000001[itemtype]:
#        print(item)
#print(sh000001)

#拟合回归模型，不同的核函数
svr_rbf = SVR(kernel='rbf',C=1e3,gamma=0.1)
svr_lin = SVR(kernel='linear',C=1e3)
svr_poly = SVR(kernel='poly',C=1e3,degree=2)

#index = date_train_data.index.reshape(train_size,1)
f = openv_train_data.values.reshape(train_size,1)
l = closev_train_data.values.reshape(train_size,1)

print(date_train_data.index.shape)
print(l.shape)
y_rbf = svr_rbf.fit(f,l).predict(f)
#y_lin = svr_lin.fit(date_train_data.index,openv_train_data).predict(date_train_data.index)
#y_poly = svr_poly.fit(date_train_data.index,openv_train_data).predict(date_train_data.index)

#plt.scatter(date_train_data.index,openv_train_data,c="k",label="data")
plt.plot(l,y_rbf,c='g',label="RBF model")
#plt.plot(date_train_data.index,y_lin,c='r',label="RBF model")
#plt.plot(date_train_data.index,y_poly,c='b',label="RBF model")
plt.xlabel("time")
plt.ylabel("value")
plt.title("SVR")
plt.legend()
plt.show()

'''