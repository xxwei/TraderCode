#coding=utf-8

from pymongo import MongoClient
from funddata import eastmoney
from datetime import datetime

#保存原始基金列表
def updateraw_fundlist():
    client = MongoClient("localhost", 27017);
    # 基金
    fddb = client.fddb;
    # 基金列表
    fundlist  = eastmoney.getlist();
    fddb.rawfundlist.remove({});
    # 下载基金列表
    if fddb.rawfundlist.count() < 1:
        for item in fundlist:
            if (item[3] == "股票型" or item[3]== "股票指数" or item[3] == "混合型"):
                itemtext = {"code": item[0],
                            "name": item[2],
                            "type": item[3]};
                fddb.rawfundlist.insert(itemtext);


#保存累计净值信息

def updateraw_fundvalue():
    client = MongoClient("localhost", 27017)
    # 基金
    fddb = client.fddb;
    #fddb.fundworth.remove({})
    last_update = datetime(1970, 1, 1, 0, 0);
    if fddb.fundworth.count() > 1:
        value = fddb.fundworth.find({"code":"000011"});
        last_update = list(value)[-1]['time'];

    print("上次更新时间",last_update);

    flist = fddb.rawfundlist.find();
    for item in flist:
        if (item["type"] == "股票型" or item["type"] == "股票指数" or item["type"] == "混合型"):
            try:
                print("update  " + item["name"] + " code " + item["code"]);
                itemvalues,manger= eastmoney.getitem(item["code"], "Data_ACWorthTrend","Data_currentFundManager");
                firstvalue = itemvalues[0][1];
            except Exception as err:
                print(err);
            else:
                for itemvar in itemvalues[::-1]:
                    currentdate = datetime.fromtimestamp(float(itemvar[0] / 1000));
                    delta = (currentdate-last_update).days;
                    if delta>0:
                        itemtext = {"time": currentdate,
                                    "value": itemvar[1] / firstvalue,
                                    "code": item["code"]};
                        fddb.fundworth.insert(itemtext);
                try:
                    fddb.rawfundlist.update({'code': item["code"]}, {'$set': {'mangerid': manger[0]["id"]}});
                except Exception as err2:
                    print(err2);


#保存基金经理信息
def updateraw_mangerdata():
    client = MongoClient("localhost", 27017)
    # 基金
    fddb = client.fddb;
    fddb.fundmanger.remove({})
    flist = fddb.rawfundlist.find()
    for item in flist:
        if (item["type"] == "股票型" or item["type"] == "股票指数" or item["type"] == "混合型"):
            try:
                print("update  " + item["name"] + " code " + item["code"]);
                manger= eastmoney.getitem(item["code"],"Data_currentFundManager");
                manger = manger[0][0];
                itemtext = {"id": manger['id'],
                            "name": manger['name'],
                            "star": manger['star'],
                            "worktime": manger['workTime'],
                            "fundsize": manger['fundSize'],
                            "powerdisc": manger["power"]["categories"],
                            "powerdata": manger["power"]["data"],
                            "avr": manger["power"]["avr"]};
                fddb.fundmanger.insert(itemtext);
            except Exception as err:
                print(err)



#过滤基金 ,后端基金没数据，不能购买的
def fundfilter():
    client = MongoClient("localhost", 27017)
    # 基金库
    fddb = client.fddb;
    #原始基金列表
    flist = fddb.rawfundlist.find();








