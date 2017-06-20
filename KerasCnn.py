# coding=utf-8
import numpy as np
from keras.models import Sequential
from keras.layers import Dense
model = Sequential()

model.add(Dense(units=64, input_dim=100))