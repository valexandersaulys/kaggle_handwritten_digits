rm(list = ls())  # clear workspace

library(caret)
set.seed(209484)

# First to import and look at the data
set <- read.csv('train.csv')
dataPartition <- createDataPartition(set$label, p = 0.7, list = FALSE)[, 1]
training <- set[dataPartition, ]
validate <- set[-dataPartition, ]

modelFit_nn <- avNNet(x=training[,2:785], y=training[,1], size=10, MaxNWts=15000)
validate['pred1'] <- predict(modelFit_nn, newdata=validate)
