rm(list = ls())  # clear workspace
#
#   This is using the randomForest method
#   Time to Execute => 
#
#
library(caret)
library(randomForest)
library(e1071)
set.seed(2094)
set <- read.csv('train.csv')

dataPartition <- createDataPartition(set$label, p = 0.6, list = FALSE)[, 1]
training <- set[dataPartition, ]
validate <- set[-dataPartition, ]

tryer <- createDataPartition(set$label,p=0.01,list=FALSE)[, 1]
little_try <- set[tryer, ]

# (label ~ ., data=set, )
modelFit_rf <- randomForest(x=training[,2:785],y=as.factor(training[,1]), data=training, ntree=50) 
modelFit_rf_2nd <- randomForest(x=training[,2:785],y=as.factor(training[,1]), data=training, ntree=500)


