# Create a vector.
apple<-c('red','green','yellow')
print(class(apple))
# Create a matrix.
M = matrix( c('a','a','b','c','b','a'), nrow = 2, ncol = 3, byrow = TRUE)
print(M)
# Create an array.
a <- array(c('green','yellow'),dim = c(3,3,2))
print(a)
# Create a list.
list1 <- list(c(2,5,3),21.3,sin)
print(list1)

# Create a vector.
apple_colors <- c('green','green','yellow','red','red','red','green')

# Create a factor object.
factor_apple <- factor(apple_colors)

# Print the factor.
print(factor_apple)
print(nlevels(factor_apple))

# Create the data frame.
BMI <- 	data.frame(
  gender = c("Male", "Male","Female"), 
  height = c(152, 171.5, 165), 
  weight = c(81,93, 78),
  Age = c(42,38,26)
)
print(BMI)


require(ggplot2)

ggplot(BMI,aes(x="height",y="weight",color="Age"))+geom_point()


library(tensorflow)
sess = tf$Session()
hello <- tf$constant('Hello, TensorFlow!')
sess$run(hello)