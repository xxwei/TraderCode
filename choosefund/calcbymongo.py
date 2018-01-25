#coding=utf-8
import pymongo
from pymongo import MongoClient

#跳过波动异常的
def clac_agr_stddev():
    client = MongoClient("localhost", 27017);
    # 基金
    fddb = client.fddb;
    #基金列表
    flist = fddb.rawfundlist.find();

    for item in flist:
        itemhistory = list(fddb.fundworth.find({"code":item["code"]}).sort("time",pymongo.ASCENDING));
        print("clac ",item["code"],item["name"]);
        i = 0;
        avg = 0;
        stddev = 0;
        startindex = 0;
        listlen = len(itemhistory)
        try:
            if listlen > 0:
                for itemday in itemhistory:
                    avg = avg+itemday["value"];
                    i=i+1;
                    if i + 1 < listlen:
                        if itemhistory[i+1]["value"]/itemday["value"]>1.1:
                            avg = 0
                            startindex = i+1;
                avg = avg/(listlen-startindex);
                for itemindex in range(startindex,listlen):
                    stddev = stddev + (itemhistory[itemindex]['value'] - avg) ** 2
                stddev = stddev / (listlen - startindex);
                agr = (itemhistory[-1]["value"]-itemhistory[startindex]["value"])/(listlen-startindex);
                if item["mangerid"]:
                    manger = fddb.fundmanger.find_one({"id":item["mangerid"]})
                    if manger :
                        print(item["code"],item["name"],"avg:",agr," stddev:",stddev,"manger star",manger["star"],"manger avr",manger["avr"],"manger name",manger["name"]);
                        fddb.rawfundlist.update({'code': item["code"]}, {'$set': {'avg': agr, 'stddev': stddev, 'timedeta': listlen - startindex,"mangerstar":manger["star"],
                                                                           "mangeravr":manger["avr"],"mangerdata":manger["powerdata"]}});
        except Exception as err:
            print(err)