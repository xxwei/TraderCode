import json
import pandas as pd
import pymongo
import time
from ggplot import *
client = pymongo.MongoClient('localhost', 27017)

#基金
fddb = client.fddb;


#flist = fddb.fundlist.find().sort([("avg",pymongo.DESCENDING),("stddev",pymongo.ASCENDING)]).limit(100)
flist = list(fddb.fundlist.find({"timestamp":{"$gt":365}}).sort("agr",pymongo.DESCENDING).limit(100));
df = pd.DataFrame(flist);
df = df.sort_values(by='stddev',axis = 0,ascending = True);
del df['_id'];
print(df);
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
