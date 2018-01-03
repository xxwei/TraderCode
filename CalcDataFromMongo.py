#coding=utf-8

from pymongo import MongoClient
import pandas as pd
import math

client = MongoClient('localhost', 27017)

#基金
fddb = client.fddb;


flist = fddb.fundlist.find()


'''
for item in flist:
    if (item["type"] == "股票型" or item["type"] == "股票指数" or item["type"] == "混合型"):
        findval = list(fddb.fundworth.find({"code":item["code"]}));
        #showlist = pd.DataFrame(findval);
        avg = 0;
        stddev = 0;
        length = len(findval);
        if length>0:
            for it in findval:
                avg = avg+it['value'];
            avg = avg/length
            for it in findval:
                stddev = stddev +(it['value']-avg)**2
            stddev = stddev/length
            stdev = math.sqrt(stddev);
            fddb.fundlist.update({'code':item["code"]},{'$set':{'avg':avg,'stddev':stddev,'timestamp':length}});
            print(item['name']," ",item['code']," avg:",avg," stddev:",stddev);
'''
for item in flist:
    if (item["type"] == "股票型" or item["type"] == "股票指数" or item["type"] == "混合型"):
        agr = 0;
        findval = list(fddb.fundworth.find({"code":item["code"]}));
        #showlist = pd.DataFrame(findval);
        length = len(findval);
        if length>0:
            agr = (findval[-1]['value']-findval[0]['value'])/length;
            fddb.fundlist.update({'code': item["code"]}, {'$set': {'agr': agr}});
            print(item['name'], " ", item['code'], " agr:", agr);