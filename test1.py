# coding:utf-8
import numpy as np
import pandas as pd
from pyecharts import Geo
import pyecharts
from  funddata import eastmoney as em
import json;

'''
value = [20, 30, 40, 60, 70, 80, 90, 100, 10]
attr = ['荆州', '长沙', '渭南', '临汾', '十堰', '唐山', '郴州', '铜陵', '呼和浩特']
geo = Geo("全国各地销售量图", width=1200, height=600)
geo.add("各网点销售量", attr, value, type="effectScatter", border_color="#ffffff", symbol_size=20, \
        is_label_show=True, label_text_color="#00FF00", label_pos="inside", symbol="circle", \
        symbol_color="FF0000", geo_normal_color="#006edd", geo_emphasis_color="#0000ff")
geo.show_config()
geo.render("geo.html")



attr =["衬衫", "羊毛衫", "雪纺衫", "裤子", "高跟鞋", "袜子"]
v1 =[5, 20, 36, 10, 10, 100]
v2 =[55, 60, 16, 20, 15, 80]
line =pyecharts.Line("折线图示例")
line.add("商家A", attr, v1, mark_point=["average"])
line.add("商家B", attr, v2, is_smooth=True, mark_line=["max", "average"])
line.show_config()
line.render("1.html")
line =pyecharts.Line("折线图-阶梯图示例");
line.add("商家A", attr, v1, is_step=True, is_label_show=True)
line.show_config()
line.render("12.html")



item = em.getitem("002803","Data_currentFundManager");
item = item[0][0];
print(item);
print(item["fundSize"]);
print(item["power"]["avr"]);
print(item["power"]["categories"]);
print(item["power"]["dsc"]);
print(item["power"]["data"]);
print(item["profit"]["series"][0]["data"][0]["y"]);
print(item["workTime"]);
print(item["profit"]["series"][0]["data"][1]["y"]);
print(item["profit"]["series"][0]["data"][2]["y"]);
'''


from choosefund import savemongo
from choosefund import calcbymongo
from funddata import sina



#savemongo.saveraw_fundlist();

#k1,k2,k3 = eastmoney.getitem("002803","Data_currentFundManager","Data_fluctuationScale","Data_holderStructure")


#savemongo.updateraw_fundvalue();

#calcbymongo.clac_agr_stddev();
flist = sina.getlist();
print(flist[0:1]);




