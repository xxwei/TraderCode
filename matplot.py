import matplotlib.pyplot as plt
import numpy as np


plt.style.use("ggplot")

X = np.linspace(-np.pi,np.pi,256,endpoint=True)
(C,S)=np.cos(X),np.sin(X)
Tx = np.arange(0.,5.,0.2)
Ty = np.arange(0.,10.,0.4)

plt.figure(1)#创建图表1
ax3 = plt.subplot(211) #创建子图表1
ax4 = plt.subplot(212) #创建子图表2
plt.figure(2) # 创建图表2
ax1  = plt.subplot(211) #创建子图表1  //三个数分别表示行列数编号
ax2 = plt.subplot(212) #创建子图表2
plt.sca(ax2)   #❶ # 选择图表1
plt.plot(X,C)
plt.sca(ax4)   #❷ # 选择图表2的子图1
plt.plot(X,S)
plt.sca(ax1)


#Line and scatter plots(使用plot()命令), histogram(使用hist()命令)
#线状
plt.plot(Tx,Ty, color="green", linewidth=1.0, linestyle="-")

#点状
plt.scatter(Tx,Ty)

plt.sca(ax3)
data = np.random.normal(5.0, 3.0, 1000)
bins = np.arange(-5., 16., 1.) 
plt.hist(data,bins,histtype="stepfilled")
plt.xlabel("data")
plt.show()

