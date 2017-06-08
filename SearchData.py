from sklearn import datasets
import tensorflow as tf


class loaddata:
    boston = ''
    def __init__(self):
        print("load data")
    def load(self):
        print("load.....")
        self.boston = datasets.load_boston()
    def printdata(self):
        print(self.boston)



if __name__ == '__main__':
    ld  = loaddata()
    ld.load()
    ld.printdata();
    print(tf.__version__)
