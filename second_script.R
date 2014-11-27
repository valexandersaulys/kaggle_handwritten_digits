#
# Attempt at something new
# Usng svm() function in te e1071 library
#
rm(list = ls())  # clear workspace

library(caret)
library(nnet)
set.seed(2094)
set <- read.csv('train.csv')
boolean <- set
#testing_set <- read.csv('test.csv')

dataPartition <- createDataPartition (set$label, p = 0.01, list = FALSE)[, 1]
training <- set[dataPartition, ]
validate <- set[-dataPartition, ]

model <- svm( training$label ~ ., data=training, cost=10000, gamma=100)
res <- predict( model, newdata=validate )