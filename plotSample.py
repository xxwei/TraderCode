# -*- coding:utf-8 -*-
from ggplot import *



p = ggplot(mtcars, aes(x='wt', y='mpg',size='disp',color='qsec')) + \
    geom_point(shape='D',position = 'jitter')+scale_color_gradient(low='red', high='white')
print(p)

p = ggplot(aes(x='carat', y='price', color='clarity',size='table'), data=diamonds) +\
    geom_point() +\
    scale_color_brewer(type = 'qual', palette = 3)

print(p)



p = ggplot(mtcars,aes(x='wt',y='mpg')) + \
    geom_point() + \
    geom_abline(intercept=20)

print(p)

p =  ggplot(aes(x='date', y='beef', ymin='beef - 1000', ymax='beef + 1000'), data=meat) + \
    geom_area() + \
    geom_point(color='coral')

print(p)

p = ggplot(aes(x='x', y='y', color='z'), data=diamonds.head(1000)) +\
    geom_point() +\
    scale_color_gradient(low='red', high='white')

print(p)