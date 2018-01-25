# encoding: utf-8
import pandas as pd
import pymongo
import time
from ggplot import *
import tushare as ts
import plotly.plotly
import plotly.graph_objs as go
from pymongo import MongoClient



def top100avg():
    client = MongoClient("localhost", 27017);
    # 基金
    fddb = client.fddb;
    # 基金列表
    flist = list(fddb.rawfundlist.find({"timedeta":{"$gt":200},"mangeravr":{"$ne":"暂无数据"},"code":{"$ne":"000011"}}).sort("avg",pymongo.DESCENDING).limit(100));
    df = pd.DataFrame(flist);
    del df['_id'];
    print(df);

    p = ggplot(df, aes(x='avg', y='stddev', size='mangeravr', color='code')) + \
        geom_point(shape='o', position='jitter') + scale_color_gradient(low='white', high='red')
    print(p)


def top100avghtml(htmlname):
    client = MongoClient("localhost", 27017);
    # 基金
    fddb = client.fddb;
    # 基金列表
    flist = list(fddb.rawfundlist.find({"timedeta":{"$gt":200},"mangeravr":{"$ne":"暂无数据"},"code":{"$ne":"000011"}}).sort("avg",pymongo.DESCENDING).limit(500));
    df = pd.DataFrame(flist);
    del df['_id'];
    print(df);
    # Create a trace
    trace = go.Scatter(
        x=df["avg"],
        y=df["stddev"],
        mode='markers',
        marker=dict(
            size=df["mangeravr"],
            color=df["mangerstar"],  # set color equal to a variable
            colorscale='Viridis',
            showscale=True
        )
    )

    data = [trace]

    # Plot and embed in ipython notebook!
    # py.iplot(data, filename='basic-scatter')
    plotly.offline.plot(data, filename=htmlname)