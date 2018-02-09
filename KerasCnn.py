# coding=utf-8
import numpy as np
import keras
from keras.models import Sequential
from keras.layers import Dense
from keras.datasets import mnist
#model = Sequential()

#model.add(Dense(units=64, input_dim=100))

print(keras.__version__);
#(x_train, y_train), (x_test,y_test) =mnist.load_data();

x=np.array([[0,1,0],[0,0,1],[1,3,2],[3,2,1]])

y=np.array([0,0,1,1]);

simple_model=Sequential()

simple_model.add(Dense(5,input_shape=(x.shape[1],),activation='relu',name='layer1'))

simple_model.add(Dense(4,activation='relu',name='layer2'))

simple_model.add(Dense(1,activation='sigmoid',name='layer3'))

simple_model.compile(optimizer='sgd',loss='mean_squared_error')

simple_model.fit(x,y,epochs=200)

print(x[0:2])

print(simple_model.predict(x[0:2]))