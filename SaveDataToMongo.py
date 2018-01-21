#coding=utf-8
import json
from pymongo import MongoClient
from funddata import eastmoney
from choosefund import savemongo
import datetime
import pandas as pd
import tushare as ts



savemongo.updateraw_fundlist();
savemongo.updateraw_fundvalue();
#savemongo.updateraw_mangerdata();


