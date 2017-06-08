import numpy as np
import tensorflow as tf

import os
os.environ['TF_CPP_MIN_LOG_LEVEL']='2'
print("Hello tensorflow",tf.__version__)
print(np.random.random(size=10))

AP = np.array([1.2, 11, 23, 0])
print(AP)
print(AP.dtype)
#d = AP.reshape((2, 2))
#print(d)
print("The Num is %-8d %-8.2f"%(25, 1.8888))


hello = tf.constant('Hello, TensorFlow!')
bExist = tf.gfile.Exists("First.py")
sess = tf.Session()
print(sess.run(hello))
print(bExist)

# Create 100 phony x, y data points in NumPy, y = x * 0.1 + 0.3
x_data = np.random.rand(100).astype(np.float32)
y_data = x_data * 0.1 + 0.3

# Try to find values for W and b that compute y_data = W * x_data + b
# (We know that W should be 0.1 and b 0.3, but TensorFlow will
# figure that out for us.)
W = tf.Variable(tf.random_uniform([1], -1.0, 1.0))
b = tf.Variable(tf.zeros([1]))
y = W * x_data + b
# Minimize the mean squared errors.
loss = tf.reduce_mean(tf.square(y - y_data))
optimizer = tf.train.GradientDescentOptimizer(0.5)
train = optimizer.minimize(loss)

# Before starting, initialize the variables.  We will 'run' this first.
init = tf.global_variables_initializer()

# Launch the graph.
sess = tf.Session()
sess.run(init)

# Fit the line.
for step in range(201):
    sess.run(train)
    if step % 20 == 0:
        print(step, sess.run(W), sess.run(b))


writer = tf.summary.FileWriter(logdir="logs",graph=tf.get_default_graph())
writer.flush()
