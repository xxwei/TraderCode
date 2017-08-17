# -*- coding:utf-8 -*-
from ggplot import *

p = ggplot(mtcars,aes(x='wt',y='mpg')) + \
    geom_point() + \
    geom_abline(intercept=20)

print(p)

p =  ggplot(aes(x='date', y='beef', ymin='beef - 1000', ymax='beef + 1000'), data=meat) + \
    geom_area() + \
    geom_point(color='coral')

print(p)

p = ggplot(aes(x='carat', y='price', color='clarity'), data=diamonds) +\
    geom_point() +\
    scale_color_brewer(type='qual')

print(p)

p = ggplot(aes(x='x', y='y', color='z'), data=diamonds.head(1000)) +\
    geom_point() +\
    scale_color_gradient(low='red', high='white')

print(p)