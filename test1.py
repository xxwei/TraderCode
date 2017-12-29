# coding:utf-8
import numpy as np
import pandas as pd
from pyecharts import Geo

value = [20, 30, 40, 60, 70, 80, 90, 100, 10]
attr = ['荆州', '长沙', '渭南', '临汾', '十堰', '唐山', '郴州', '铜陵', '呼和浩特']
geo = Geo("全国各地销售量图", width=1200, height=600)
geo.add("各网点销售量", attr, value, type="effectScatter", border_color="#ffffff", symbol_size=20, \
        is_label_show=True, label_text_color="#00FF00", label_pos="inside", symbol="circle", \
        symbol_color="FF0000", geo_normal_color="#006edd", geo_emphasis_color="#0000ff")
geo.show_config()
geo.render("geo.html")