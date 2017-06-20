from sklearn import datasets
import tensorflow as tf
import matplotlib.pyplot as plt
import matplotlib
from mpl_toolkits.mplot3d import Axes3D,axes3d
import numpy as np


class loaddata:
    boston = ''
    def __init__(self):
        matplotlib.rcParams['font.family']='SimHei'
        print("load data")
    def load(self):
        print("load.....")
        self.boston = datasets.load_boston()
    def printdata(self):
        print(self.boston)
    def showdata(self):
        a = np.arange(10)
        plt.ylabel("纵轴",fontproperties='SimHei',fontsize=25,color='green')
        plt.plot(a,a*1.5,'b-.',a,a*2.5,'go-')
        plt.show()
    def showcycle(self):
        center = 1
        radius = 10
        #data
        u = np.linspace(0,2*np.pi,100)
        v= np.linspace(0,np.pi,100)
        x = radius*np.outer(np.cos(u),np.sin(v))+center
        y = radius*np.outer(np.sin(u),np.sin(v))+center
        z = radius*np.outer(np.ones(np.size(u)),np.cos(v))+center
        #plot
        fig = plt.figure()
        ax = fig.add_subplot(121,projection='3d')
        #surface plot
        ax.plot_surface(x,y,z,rstride=4,cstride=4,color='b')
        #wire frame
        ax = fig.add_subplot(122,projection='3d')
        ax.plot_wireframe(x,y,z,rstride=10,cstride=10)
        plt.show()





if __name__ == '__main__':
    ld  = loaddata()
    #ld.load()
    #ld.showdata()
    ld.showcycle()
    #ld.printdata();
    print(tf.__version__)
