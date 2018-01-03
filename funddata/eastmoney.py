#coding=utf-8
import requests
import execjs


#获取页面变量值
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


