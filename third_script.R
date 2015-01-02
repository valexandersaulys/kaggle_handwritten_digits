rm(list = ls())
library(caret)
library(nnet)
library(e1071)
set.seed(112289)
set <- read.csv('train.csv')
backup <- set
# data[row,column]

set <- set[, !colSums(set<2) == nrow(set)]  # removes columns with all zeros

#inTraining <- createDataPartition(set$label, p=0.6, list=FALSE)
small_fold <- createDataPartition(set$label, p=0.02, list=FALSE)
#training <- set[inTraining,]
#validation <- set[-inTraining,]
small_try <- set[small_fold,]
large_try <- set[-small_fold,]

ctrl <- trainControl(method="repeatedcv", number=10, repeats=3)

#modelFit_svmLinear <- train(label ~ ., data=set, method='svmLinear')
#modelFit_svmPoly <- train(label ~ ., data=set, method='svmPoly', tuneGrid=data.frame(degree=3,scale=1,C=1))
modelFit_svmPoly_Try2 <- train(label ~ ., data=small_try, method='svmPoly', trControl=ctrl, tuneGrid=data.frame(degree=3,scale=709,C=100))
#modelFit_svmPoly <- svm(label ~ ., data=small_try, scale=FALSE, kernel="polynomial", cross=10, degree=3, cross=10)
#validation['svmPoly'] <- predict(modelFit_svmPoly, newdata=validation)

validation["svmPoly_try2"] <- predict(modelFit_svmPoly2, newdata=validation)

#confusionMatrix(validation$svmPoly, validation$label)
