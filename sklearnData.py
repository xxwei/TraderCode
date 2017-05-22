# coding=utf-8

from sklearn import datasets
import numpy as np
import matplotlib.pyplot as plt

d1 = datasets.load_iris() #
d2 = datasets.load_breast_cancer() #乳腺癌数据
d3 = datasets.load_digits() #手写数字
d4 = datasets.load_boston() #波士顿房价
d5 = datasets.load_linnerud() #体能数据集


print(d3.keys())
samples,features = d3.data.shape
print(samples,features)
print(d3.images.shape)

#print(d1.data)
#print(d1.target)
print(d3.target_names)

print(np.bincount(d1.target))

x_index = 3
colors = ['blue','red','green']

'''
for label,color in zip(range(len(d1.target_names)),colors):
    plt.hist(d1.data[d1.target==label,x_index],label=d1.target_names[label],color=color) #直方图

plt.xlabel(d1.feature_names[x_index])
plt.legend(loc='upper right')
plt.show()
'''
x_index = 0
y_index = 3
'''
for label,color in zip(range(len(d1.target_names)),colors):
    plt.scatter(d1.data[d1.target==label,x_index],d1.data[d1.target == label, y_index],label=d1.target_names[label],color=color) #散点图

plt.xlabel(d1.feature_names[x_index])
plt.xlabel(d1.feature_names[y_index])
plt.legend(loc='upper left')
plt.show()

'''

'''
fig = plt.figure(figsize=(6,6))
fig.subplotpars(left=0,right=1,bottom=0,top=1,hspace=0.05,wspace=0.05)

for i in range(64):
    ax = fig.add_subplot(8,8,i+1,xticks=[],yticks=[])
    ax.imshow(d3.images[i],cmap=plt.cm.binary,interpolation="nearest")
    ax.text(0,7,str(d3.target[i]))
plt.show()
'''

#china = datasets.load_sample_image('china.jpg')

print(datasets.get_data_home())
