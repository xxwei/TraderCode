from tensorflow.contrib import keras
import tensorflow as tf
from tensorflow.contrib.keras.python.keras.models import Sequential
from tensorflow.contrib.keras.python.keras.layers import Dense
import tushare as ts
import numpy as np
model = Sequential()
#if tf.gfile.Exists('./logs'):
#    tf.gfile.Remove('./logs')
tbCallBack  = keras.callbacks.TensorBoard(log_dir='./logs', histogram_freq=0,write_graph=True, write_images=True)
model.add(Dense(128,activation='relu',input_shape=[30,5]))
model.add(Dense(3,activation='softmax'))

model.compile(loss='categorical_crossentropy',
              optimizer='rmsprop',
              metrics=['accuracy'])
tbCallBack.set_model(model)
basetick = 30
pretick = 5
sh001 = ts.get_k_data("000001",index=True)
#print(sh001.head())
train_x = sh001.iloc[:sh001.index.size-pretick-basetick,1:6]
#print(train_x.head())
train_y = []
for index in range(sh001.index.size-pretick-basetick):
    #print(index+basetick+pretick,sh001.iloc[index+basetick+pretick,3])
    ty = sh001.iloc[index+basetick+pretick,3]-sh001.iloc[index+basetick,1]
    train_y.append(ty)
#print(train_y)
#train_y = sh001
model.fit(train_x,train_y, batch_size=basetick, epochs=5, shuffle=False)

