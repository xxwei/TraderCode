# coding=utf-8

from sklearn import datasets
import numpy as np
import matplotlib.pyplot as plt

d1 = datasets.load_iris() #
d2 = datasets.load_breast_cancer() #乳腺癌数据
d3 = datasets.load_digits() #手写数字
d4 = datasets.load_boston() #波士顿房价
d5 = datasets.load_linnerud() #体能数据集


print(d1.keys())

samples,features = d1.data.shape
print(samples,features)

print(d1.data)
print(d1.target)
print(d1.target_names)

print(np.bincount(d1.target))

x_index = 0
colors = ['blue','red','green']

for label,color in zip(range(len(d1.target_names)),colors):
    plt.hist(d1.data[d1.target==label,x_index],label=d1.target_names[label],color=color)

plt.xlabel(d1.feature_names[x_index])
plt.legend(loc='upper right')
plt.show()
