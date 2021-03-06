from tensorflow.contrib import keras
import tensorflow as tf
from tensorflow.contrib.keras.api.keras.models import Sequential
from tensorflow.contrib.keras.api.keras.layers import Dense
from tensorflow.contrib.keras.api.keras.layers import LSTM
from tensorflow.contrib.keras.api.keras.layers import Dropout
from tensorflow.contrib.keras.api.keras.layers import Activation
import tushare as ts
import numpy as np
import time
import matplotlib.pyplot as plt


def plot_results(predicted_data, true_data):
    fig = plt.figure(facecolor='white')
    ax = fig.add_subplot(111)
    ax.plot(true_data, label='True Data')
    plt.plot(predicted_data, label='Prediction')
    plt.legend()
    plt.show()

model = Sequential()
#if tf.gfile.Exists('./logs'):
#    tf.gfile.Remove('./logs')
tbCallBack  = keras.callbacks.TensorBoard(log_dir='./logs', histogram_freq=0,write_graph=True, write_images=True)
basetick = 30
pretick = 5
sh001 = ts.get_k_data("000001",index=True)
#print(sh001.head())
#train_x = sh001.iloc[:sh001.index.size-pretick-basetick,1:6]
#print(train_x.head())
train_x = []
train_y = []
for index in range(sh001.index.size-pretick-basetick):
    #ty = sh001.iloc[index+basetick+pretick,3]-sh001.iloc[index+basetick,1]
    ty = sh001.iloc[index+basetick+pretick,3]
    #tx = sh001.iloc[index:index+basetick,1:6]
    tx = sh001.iloc[index:index + basetick, 3]
    train_y.append(ty)
    train_x.append(tx.as_matrix())
#train_y = sh001
train_x = np.array(train_x)
train_y = np.array(train_y)
train_x = np.reshape(train_x, (train_x.shape[0],train_x.shape[1],1))
test_x = train_x[train_x.shape[0]-100:]
test_y = train_y[train_y.shape[0]-100:]
train_x = train_x[:train_x.shape[0]-100]
train_y = train_y[:train_y.shape[0]-100]
print(train_x.shape)
print(train_y.shape)
print(test_x.shape)
print(test_y.shape)
#通过 input_shape 指定，不需要样本大小，见例子
#通过 batch_input_shape 指定，需要指定样本大小
#2D Layer 通过input_dim指定各维大小，3D Layer通过input_dim 和 input_length 两个参数指定
#Keras LSTM层的工作方式是通过接收3维（N，W，F）的数字阵列，其中N是训练序列的数目，W是序列长度，F是每个序列的特征数目。
TIME_STEPS = 30
INPUT_SIZE = 1
#model.add(LSTM(1,batch_input_shape=(None, TIME_STEPS, INPUT_SIZE)))
model.add(LSTM(1,input_shape=(TIME_STEPS,INPUT_SIZE)))
model.add(Dropout(0.2))
model.add(Dense(1))
model.add(Activation("linear"))
start = time.time()
model.compile(loss="mse", optimizer="rmsprop")
print("Compilation Time : ", time.time() - start)
tbCallBack.set_model(model)
model.fit(train_x,train_y,batch_size=32,epochs=5)
score = model.evaluate(train_x, train_y, batch_size=32)
#model.save_weights('w1.hdf5')
predicted = model.predict(test_x,batch_size=32,verbose=2)
predicted = np.reshape(predicted, (predicted.size,))

print(predicted)
print(score)
plot_results(predicted,test_y)


'''
model.add(Dense(128,activation='relu',input_shape=[None,5],input_dim=2))
model.add(Dense(3,activation='softmax'))

model.compile(loss='categorical_crossentropy',
              optimizer='rmsprop',
              metrics=['accuracy'])
tbCallBack.set_model(model)

model.fit(train_x,train_y, batch_size=basetick, epochs=5, shuffle=False)
'''

