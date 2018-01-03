#coding=utf-8
import json
from pymongo import MongoClient
from funddata import eastmoney
import datetime
import pandas as pd
import tushare as ts




client = MongoClient('localhost', 27017)

#基金
fddb = client.fddb;

#fddb.fundlist.remove({})

#下载基金列表
if fddb.fundlist.count()<1:
    #基金列表
    fundlist = eastmoney.getlist();

    for item in fundlist:
        itemtext = {"code":item[0],
                    "name":item[2],
                    "type":item[3]};
        fddb.fundlist.insert(itemtext);

#数据库中加载基金列表
flist = fddb.fundlist.find()

#flist = pd.DataFrame(list(fddb.fundlist.find()))
# 删除mongodb中的_id字段
#del flist['_id'];
#for indexs in flist.index:
if fddb.fundworth.count()<1:
    fddb.fundworth.remove({})
    for item in flist:
        if (item["type"] == "股票型" or item["type"] == "股票指数" or item["type"] == "混合型"):
            try:
                print("loading " + item["name"] + " code " + item["code"]);
                itemvalues = eastmoney.getitem(item["code"], "Data_ACWorthTrend");
                firstvalue = itemvalues[0][1];
                for itemvar in itemvalues:
                    itemtext = {"time": datetime.datetime.fromtimestamp(float(itemvar[0]/1000)),
                                "value": itemvar[1]/firstvalue,
                                "code": item["code"]};
                    fddb.fundworth.insert(itemtext);
            except Exception as err:
                print(err)



