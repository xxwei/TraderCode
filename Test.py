#coding=utf-8
import requests
import pandas as pd
import execjs
import datetime
from ggplot import *
import tushare as ts

#中证500
#dt = ts.get_zz500s()
#print(dt);

#上证50
#print(ts.get_sz50s());

#沪深300
#print(ts.get_hs300s());


#获取连接备用

cons = ts.get_apis()
df = ts.bar('000300', conn=cons, asset='INDEX', start_date='', end_date='')
df = df.reset_index();
df['value'] = df['open']/2000;
print(df.head(5));
print(df.dtypes);

df1 = ts.bar('000016', conn=cons, asset='INDEX', start_date='', end_date='')
df1 = df1.reset_index();
df1['value'] = df1['open']/2000;
df1['odc'] = df1['open']>df1['close'];

df = pd.concat([df,df1]);
'''
df1 = ts.bar('000905', conn=cons, asset='INDEX', start_date='2016-01-01', end_date='')
df1 = df1.reset_index();
df1['odc'] = df1['open']>df1['close'];
df1['open'] = df1['open'];
df = pd.concat([df,df1]);

p = ggplot(aes(x='datetime',y='open',shape='odc',color='code'),data=df) + geom_point()+ggtitle(u'hs300');
print(p)
'''

def getvar(htmltext,varname):
    context = execjs.compile(htmltext + "function get(){return " + varname + ";};");
    data = context.call("get");
    return data;

#基金列表
def getlist():
    html = requests.get("http://fund.eastmoney.com/js/fundcode_search.js");
    list = getvar(html.text, "r");
    return list;

#基金详细信息
def getitem(itemcode,itemvar):
    itemurl = "http://fund.eastmoney.com/pingzhongdata/" + itemcode+ ".js"
    html = requests.get(itemurl);
    itemvar = getvar(html.text, itemvar);
    return itemvar;

#基金列表
list  = getlist();


#基金详细信息

#成分股号码
itemvar = getitem(list[0][0],"stockCodes");
print(itemvar[0][:6]); #股票号码最后多了1位

#print(ts.get_hist_data(itemvar[0][:6]));

#基金名称
fs_name = getitem(list[0][0],"fS_name");
print(fs_name);


#基金净值
itemvar = getitem(list[0][0],"Data_ACWorthTrend");


#print(itemvar);
#for itemvvar in itemvar:
#    itemvvar[0] = datetime.datetime.fromtimestamp(float(itemvvar[0]/1000));
#iv = pd.DataFrame(itemvar,columns=["date","value"]);
#iv['code'] = list[0][0];
df = df[['datetime','value','code']]
df.rename(columns={'datetime':'date'}, inplace = True)


itemcode = list[0];
itemvar = getitem(itemcode[0],"Data_ACWorthTrend");
for itemvvar in itemvar:
    itemvvar[0] = datetime.datetime.fromtimestamp(float(itemvvar[0]/1000));
iv = pd.DataFrame(itemvar,columns=["date","value"]);
iv['code'] = itemcode[0];


iv = pd.concat([iv,df]);

showrange = iv;
#print(list);
#print(showrange);
i = 0;
for item in list:
    if(item[3]=="股票型" or item[3]=="股票指数" or item[3]=="混合型"):
        try:
            itemvar = getitem(item[0],"Data_ACWorthTrend");
            for itemvvar in itemvar:
                itemvvar[0] = datetime.datetime.fromtimestamp(float(itemvvar[0]/1000));
            tp = pd.DataFrame(itemvar,columns=["date","value"]);
            tp['code'] = item[0];
            showrange = pd.concat([showrange,tp]);
            print("loading "+item[2]+" code "+item[0]);
        except Exception as err:
            print(err)
    i=i+1;
    if(i%10==0):
        p = ggplot(aes(x='date', y='value', colour='code'), data=showrange) + geom_line() + ggtitle(u'走势');
        print(p)
        showrange = iv;


#p=ggplot(aes(x='date',y='value',colour='code'),data=iv)+geom_line()+ggtitle(u'走势');
#print(p)


#itemurl = "http://fund.eastmoney.com/pingzhongdata/"+list[0][0]+".js"
#html = requests.get(itemurl);
#print(html.text);










