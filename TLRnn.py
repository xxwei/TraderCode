# coding=utf-8
import numpy as np
import tensorlayer as tl
import tensorflow as tf
import tushare as ts

class LearnStock:
    def __init__(self):
        self.m_code='000001'
        self.m_codeEx = "SH0000001"
        self.m_stock=''
        print('Init LearnStock')
    def tan(self,x):
        return tf.tan(x)
    def loadData(self):
        m_stock = ts.get_k_data(self.m_code,index=True)
    def loadGraphlayer(self):
        x = tf.placeholder(tf.float32, [30, 5])
        lstm_input = tl.layers.InputLayer(x,name='input')
        l1 = tl.layers.DenseLayer(lstm_input)
        l2 = tl.layers.DenseLayer(l1)




if __name__ == '__main__':
    ls  = LearnStock()


