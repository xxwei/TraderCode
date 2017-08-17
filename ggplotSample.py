# -*- coding:utf-8 -*-
# 准备数据
import ggplot as gp # 不太喜欢import *
import pandas as pd
meat = gp.meat


p=gp.ggplot(gp.aes(x='date',y='beef'),data=meat)+gp.geom_point(color='red')+gp.ggtitle(u'散点图')
print (p)
p=gp.ggplot(gp.aes(x='date',y='beef'),data=meat)+gp.geom_line(color='blue')+gp.ggtitle(u'折线图')
print (p)
p=gp.ggplot(gp.aes(x='date',y='beef'),data=meat)+gp.geom_point(color='red')+gp.geom_line(color='blue')+gp.ggtitle(u'散点图+折线图')
print (p)

# 将想要表达的变量组成一列
meat_lng = pd.melt(meat[['date','beef','pork','broilers']],id_vars='date')
# meat_lng包含了date,value（变量的值组成的列）,variable（变量的名称组成的列）
p = gp.ggplot(gp.aes(x='date',y='value',colour='variable'),data=meat_lng)+\
    gp.geom_point()+gp.geom_line()
print (p)




meat_lng = pd.melt(meat[['date','beef','pork','broilers']],id_vars='date')
p = gp.ggplot(gp.aes(x='date',y='value',colour='variable'),data=meat_lng)+gp.geom_point()+gp.facet_wrap('variable')
print (p)

p = gp.ggplot(gp.aes(x='beef'),data=meat)+gp.geom_histogram()
print (p)

meat_lng = pd.melt(meat[['date','beef','pork']],id_vars='date')
p = gp.ggplot(gp.aes(x='value'),data=meat_lng)+gp.facet_wrap('variable')+gp.geom_histogram()
print (p)