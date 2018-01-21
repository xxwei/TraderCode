import json
import pandas as pd
import pymongo
import time
from ggplot import *
import tushare as ts

cons = ts.get_apis()
hs300 = ts.bar('000300', conn=cons, asset='INDEX', start_date='', end_date='')
hs300 = hs300.reset_index();
#print(hs300.head(5));
firstopen = hs300.iloc[-1].values[2];
#print(firstopen);
hs300['value'] = hs300['open']/firstopen;
hs300['time'] = hs300['datetime'];
del hs300['datetime'];
del hs300['open'];
del hs300['close'];
del hs300['high'];
del hs300['low'];
del hs300['vol'];
del hs300['amount'];
#print(hs300.head(5));



client = pymongo.MongoClient('localhost', 27017)

#基金
fddb = client.fddb;


#flist = fddb.fundlist.find().sort([("avg",pymongo.DESCENDING),("stddev",pymongo.ASCENDING)]).limit(100)
flist = list(fddb.fundlist.find({"timestamp":{"$gt":200}}).sort("agr",pymongo.DESCENDING).limit(100));
df = pd.DataFrame(flist);

del df['_id'];
#del df['name'];
#print(df);

'''
df.to_csv(r'1.csv',encoding = "utf-8")
df = df.sort_values(by='stddev',axis = 0,ascending = True);
print(df);
df.to_csv(r'2.csv',encoding = "utf-8")
'''
arr = [];

for indexs in df.index:
    arr.append({"code": df.loc[indexs].values[2]});
    if len(arr) % 5 == 0:
        ticks = time.time();
        print("获取时间戳为:", ticks)
        print(arr);
        value = fddb.fundworth.find({"$or": arr});
        if value.count() > 0:
            ticks = time.time()
            print("构造时间戳为:", ticks)
            showlist = pd.DataFrame(list(value));
            del showlist['_id'];
            showlist = pd.concat([showlist, hs300]);
            ticks = time.time()
            print("显示时间戳为:", ticks)
            p = ggplot(aes(x='time', y='value', colour='code'), data=showlist) + geom_line() + ggtitle(u'走势');
            print(p)
        arr.clear();

'''
for item in flist:
    if (item["type"] == "股票型" or item["type"] == "股票指数" or item["type"] == "混合型"):
        arr.append({"code":item["code"]});
        if len(arr)%20==0:
            ticks = time.time()
            print("获取时间戳为:",ticks)
            print(arr);
            value = fddb.fundworth.find({"$or": arr});
            if value.count()>0:
                ticks = time.time()
                print("构造时间戳为:", ticks)
                showlist = pd.DataFrame(list(value));
                ticks = time.time()
                print("显示时间戳为:", ticks)
                p = ggplot(aes(x='time', y='value', colour='code'), data=showlist) + geom_line() + ggtitle(u'走势');
                print(p)
            arr.clear();

#print(showlist);
'''
