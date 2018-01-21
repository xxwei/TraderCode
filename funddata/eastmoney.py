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
def getitem(itemcode,*itemvar):
    itemurl = "http://fund.eastmoney.com/pingzhongdata/" + itemcode+ ".js"
    html = requests.get(itemurl);
    valuelist=[]
    for key in itemvar:
        value = getvar(html.text, key);
        valuelist.append(value);
    return tuple(valuelist);


#基金列表
#http://fund.eastmoney.com/js/fundcode_search.js
#http://vip.stock.finance.sina.com.cn/fund_center/data/jsonp.php/CallbackList/NetValueReturn_Service.NetValueReturnOpen?page=1&num=20&sort=form_year&asc=0

#基金详细信息
#http://fund.eastmoney.com/pingzhongdata/000011.js

#基金经理
#http://fund.eastmoney.com/Data/FundDataPortfolio_Interface.aspx?dt=14&mc=returnjson&ft=all&pn=2000&pi=1&sc=penavgrowth&st=desc
#http://app.xincai.com/fund/api/jsonp.json/CallbackList/XinCaiOtherService.getManagerFundInfo?page=1&num=40&sort=NavRate&asc=0&type2=1


#http://fund.eastmoney.com/data/FundDataPortfolio_Interface.aspx?dt=17&mc=jjjl&pn=20&pi=1&jlid=30430383


#基金公司
#http://fund.eastmoney.com/Data/FundDataPortfolio_Interface.aspx?dt=16



#http://stock.finance.qq.com/fund/jzzx/kfs.js?0.2606529625058509

#http://app.xincai.com/fund/api/jsonp.json/CallbackList/XinCaiOtherService.getManagerFundInfo?page=1&num=40&sort=NavRate&asc=0&ccode=&date=&type2=1&%5Bobject%20HTMLDivElement%5D=k7i89

#http://vip.stock.finance.sina.com.cn/fund_center/data/jsonp.php/CallbackList/NetValueReturn_Service.NetValueReturnOpen?page=1&num=200&sort=form_year&asc=0&ccode=&type2=0&type3=
#基金重仓股
#http://vip.stock.finance.sina.com.cn/fund_center/data/jsonp.php/CallbackList/FundStock_Service.getFundBigholdList?page=1&num=40&sort=fHolderNum&asc=0&companyCode=&year=&quarter=&type2=&type3=&symbol=