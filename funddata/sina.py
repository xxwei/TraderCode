import requests
import execjs



#http://vip.stock.finance.sina.com.cn/fund_center/data/jsonp.php/CallbackList/NetValueReturn_Service.NetValueReturnOpen?page=1&num=20&sort=form_year&asc=0

def getvar(htmltext):
    data = htmltext[70:-2];
    data = "var r="+data+"; function get(){return r;}";
    context = execjs.compile(data);
    data = context.call("get");
    return data;

#基金列表
def getlist():
    html = requests.get("http://vip.stock.finance.sina.com.cn/fund_center/data/jsonp.php/CallbackList/NetValueReturn_Service.NetValueReturnOpen?page=1&num=2000&sort=symbol&asc=1");
    itemtw = getvar(html.text);
    data = itemtw["data"];
    num = itemtw["total_num"];
    page = num//2000+1;
    i = 2;
    while i < page:
        i += 1
        html = requests.get("http://vip.stock.finance.sina.com.cn/fund_center/data/jsonp.php/CallbackList/NetValueReturn_Service.NetValueReturnOpen?page="+str(i)+"&num=2000&sort=symbol&asc=1");
        itemtw = getvar(html.text);
        data.extend(itemtw["data"]);

    return data;